'''
This is useful when reversing something that manually resolves APIs into fields
of a structure

Plug in windbg, let it run through all the API resolves. Then, in memory view,
inspect the base of the structure. Set the "Display Format" to "Pointer and
Symbols". Windbg will happily prints out symbols for those APIs.

Make a complete copy of the memory view and saves in 'struct.txt'. Then, in
IDA, run this script to make a struct with appropriate names for its fields.

Sample content of struct.txt:

0050fbf0 77e247fa kernel32!LoadLibraryExAStub
0050fbf4 77e24775 kernel32!LoadLibraryExWStub
0050fbf8 77e33c01 kernel32!LoadLibraryW

It automatically handles gaps in the struct (i.e where there is unknown data
that windbg fails to display):

0050fe6c 6fc34642 OLEAUT32!SysAllocString
0050fe70 6fc33e59 OLEAUT32!SysFreeString
0050fe74 00133260
0050fe78 001362a0
0050fe7c 00000000
0050fe80 ffffffff
0050fe84 3fe00000 VERSION
0050fe88 3fe01c9c VERSION!GetFileVersionInfoSizeA
0050fe8c 3fe01ced VERSION!GetFileVersionInfoA
0050fe90 3fe01b72 VERSION!VerQueryValueA
0050fe94 3fe019d9 VERSION!GetFileVersionInfoSizeW
0050fe98 3fe019f4 VERSION!GetFileVersionInfoW
0050fe9c 3fe01b51 VERSION!VerQueryValueW
'''
import idaapi
import logging
import idc

FNAME='struct.txt'
STRUCTNAME = 'Struct'
PTRSIZE = 4


def process_file(fname):
    '''Parse the file line by line:
    1. Split the line using ' '
    2. Use the first address as the base of the structure
    3. Parse the fullname (i.e "kernel32!WriteFileImplementation" or
       "advapi32!SetEventStub") into short name (WriteFile, or SetEvent)
    4. If there is any error while parsing, skip that line.
    5. Calculate the offset to the base
    6. Add that to the result and return
    '''
    base = None
    result = list()
    with open(fname, 'r') as ifile:
        for line in ifile:
            line = line.strip().replace('  ', ' ')
            try:
                ea, _, fullname = line.split(' ')
                ea = int(ea, 0x10)
                if base is None:
                    base = ea
                try:
                    name = fullname.split('!')[1]
                    name = name.replace('Stub', '')
                    name = name.replace('Implementation', '')
                except:
                    name = fullname
                offset = ea - base
                result.append((ea, offset, name))
            except:
                offset = None
                name = None
    return result


def fix_fields(infields, ptrsize):
    '''
    Handle the case where the struct has gaps within its field. This happens
    when there is an entry that fails to parse. Process like this:
    1. Reverse the list, and use pop() to start at the top
    2. Assume the first offset must be 0. If not, add some dummy fields to
       fill up the empty space
    3. Add the proper entry
    4. Return the fixed fields
    '''
    fields = infields[::-1]
    count = 0
    newfields = list()
    while len(fields) > 0:
        _ea, offset, name = fields.pop()
        cur_offset = count * ptrsize
        while cur_offset < offset:
            cur_name = 'field_%x' % (cur_offset,)
            newfields.append((-1, cur_offset, cur_name))
            count += 1
            cur_offset = count * ptrsize
        newfields.append((_ea, offset, name))
        count += 1
    return newfields


def make_struct(struct_name, fields, flags, ptrsize):
    '''
    Make a struct: Simply go through each entry and make a name. Didn't test
    what happens when there is a name collision...
    '''
    msid = idc.add_struc(-1, struct_name, 0)
    if msid == 0xFFFFFFFF:
        logging.error('Failed to create struct %s' % (struct_name,))
        return -1

    for _ea, offset, name in fields:
        idc.add_struc_member(msid, name, -1, flags, -1, ptrsize)
    return 0


def main():
    is64 = idaapi.get_inf_structure().is_64bit()
    if is64:
        flags = FF_QWORD & 0xFFFFFFFF
        ptrsize = 0x08
    else:
        flags = FF_DWORD & 0xFFFFFFFF
        ptrsize = 0x04
    result = process_file(FNAME)
    result = fix_fields(result, ptrsize)
    make_struct(STRUCTNAME, result, flags, ptrsize)
    return 0


if __name__ == '__main__':
    main()


