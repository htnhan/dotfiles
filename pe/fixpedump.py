'''
This utility is used to fix PE files dumped directly from memory. Usually,
a PE section virtual address and raw address (file offset) are usually not
the same due to memory alignment (4k page) and file structure alignment. This
script simply fix the section header to point to the correct offset from
memory dump.
'''
from __future__ import print_function
import pefile


def mkoutname(iname):
    idx = iname.rfind('.')
    if idx == -1:
        return "{}.fixed".format(iname)

    fname, ext = iname[:idx], iname[idx+1:]
    return "{}.fixed.{}".format(fname, ext)


def printinfo(fname):
    pe = pefile.PE(fname)
    print("-" * 0x20)
    print("PE file: {}".format(fname))
    print("Number of sections: {}".format(pe.FILE_HEADER.NumberOfSections))
    for sec in pe.sections:
        print("Section {:>8}: ".format(sec.Name.decode().rstrip("\x00")),
              "vsize: {:>8}, ".format(hex(sec.Misc_VirtualSize)),
              "va: {:>10}, ".format(hex(sec.VirtualAddress)),
              "rsize: {:>8}, ".format(hex(sec.SizeOfRawData)),
              "offset: {:>10}".format(hex(sec.PointerToRawData)))
    return


def main(argv):
    if len(argv) != 2:
        print ("Usage: {} <PEfile>".format(argv[0]))
        return -1

    printinfo(argv[1])

    pe = pefile.PE(argv[1])
    for sec in pe.sections:
        sec.PointerToRawData = sec.VirtualAddress
        sec.SizeOfRawData = sec.Misc_VirtualSize
    oname = mkoutname(argv[1])
    pe.write(oname)

    printinfo(oname)



if __name__ == '__main__':
    import sys
    sys.exit(main(sys.argv))
