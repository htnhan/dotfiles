# idapro init python scripts
import idc
import idaapi

def hightlight_jmpregs():
    '''Hightlight calls to registers'''
    OPTYPE_REGISTER = 0x1
    COLOR = 0x000077
    heads = Heads(SegStart(ScreenEA()), SegEnd(ScreenEA()))
    for ea in heads:
        if not GetMnem(ea) == 'jmp':
            continue
        if GetOpType(ea, 0) == OPTYPE_REGISTER:
            SetColor(ea, CIC_ITEM, COLOR)
            print 'Call to register at 0x%08x: %s %s' % (
                    ea, GetMnem(ea), GetOpnd(ea, 0))
    return


def hightlight_antivms():
    '''Hightlight anti-vm x86 instructions. These are very uncommon in
    most benign code'''
    COLOR = 0x000077
    heads = Heads(SegStart(ScreenEA()), SegEnd(ScreenEA()))
    antivm_instructions = set(['sidt', 'sgdt', 'sldt',
                               'smsw', 'str', 'in', 'cpuid'])
    for ea in heads:
        if GetMnem(ea).lower() in antivm_instructions:
            print "Detect anti-vm at 0x%08x" % (ea)
            SetColor(ea, CIC_ITEM, COLOR)
    return 0


def hightlight_calls():
    '''Hightlight all calls, with dark background'''
    COLOR = 0x000077
    heads = Heads(SegStart(ScreenEA()), SegEnd(ScreenEA()))
    print 'hightlight calls called'
    for h in heads:
        if GetMnem(h) == 'call':
            SetColor(h, CIC_ITEM, COLOR)

    return 0


def hightlight_peb():
    '''Highlight SEH setup on stack
    '''
    COLOR = 0x000077
    heads = Heads(SegStart(ScreenEA()), SegEnd(ScreenEA()))
    for ea in heads:
        op0, op1 = GetOpnd(ea, 0), GetOpnd(ea, 1)
        if 'fs:' in op0.lower() or 'fs:' in op1.lower():
            SetColor(ea, CIC_ITEM, COLOR)
            print 'Accessing fs at 0x%x' % (ea,)
        elif 'gs:' in op0.lower() or 'gs:' in op1.lower():
            SetColor(ea, CIC_ITEM, COLOR)
            print 'Accessing gs at 0x%x' % (ea,)
    return


def hightlight_xor():
    '''Highlight XOR operation, really common and useful
    '''
    heads = Heads(SegStart(ScreenEA()), SegEnd(ScreenEA()))
    COLOR = 0x005757
    print 'hightlight calls called'
    for h in heads:
        if GetMnem(h) == 'xor':
            SetColor(h, CIC_ITEM, COLOR)

    return 0


def reset_color():
    '''reset all colors'''
    heads = Heads(SegStart(ScreenEA()), SegEnd(ScreenEA()))
    print 'hightlight calls called'
    COLOR = 0x0
    for h in heads:
        if GetMnem(h) == 'xor':
            SetColor(h, CIC_ITEM, COLOR)

    return 0


def nopit(start, end=None):
    if end is None:
        end = start+1
    for _ in xrange(start, end):
        idaapi.patch_byte(_, 0x90)
        idaapi.autoMark(_, idaapi.AU_CODE)
    idc.Refresh()
    return 0


def mkvtable(name, vtblref, count):
    FLAGS = (FF_DWRD|FF_DATA) & 0xFFFFFFFF
    is64 = idaapi.get_inf_structure().is_64bit()
    if is64:
        fn = Qword
        addrsize = 8
    else:
        fn = Dword
        addrsize = 4

    msid = AddStrucEx(-1, name, 0)
    print 'added', hex(msid), type(msid)
    if msid == 0xFFFFFFFF:
        print 'failed'
        return

    for _ in xrange(count):
        offset = _ * addrsize
        addr = hex(fn(vtblref + offset))[:-1]
        membername = 'field_%x' % (offset,)
        print 'adding member:', membername,
        rc = AddStrucMember(msid, membername, -1, FLAGS, -1, addrsize)
        print hex(rc)
        SetMemberComment(msid, offset, addr, 1)


def help():
    print 'reset_color()'
    print 'nopit(start, end)'
    print 'mkvtable(name, vtblref, count)'

def main():
    reset_color()
    hightlight_xor()
    hightlight_peb()
    hightlight_antivms()
    hightlight_calls()
    hightlight_jmpregs()


if __name__ == '__main__':
    main()


