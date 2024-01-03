#include <idc.idc>

#define INF_SHORT_DN 142                // short form of the demangled name

#define DT_TYPE 0xF0000000L             // Mask for DATA typing

#define FF_BYTE 0x00000000L             // byte
#define FF_WORD 0x10000000L             // word
#define FF_DWRD 0x20000000L             // dword
#define FF_QWRD 0x30000000L             // qword
                                        //

static nh_mk_struct(ea, name, size, ptrsize=8) {
    auto i = 0;
    auto msid = AddStrucEx(-1, name, 0);
    if (msid == -1) {
        print("Failed to create struct", name);
        return -1;
    }

    for (i = 0; i < size; i ++) {
        auto idx = i * ptrsize;
        auto next = ea + idx;
        auto fptr = Qword(next);
        auto member_name = sprintf("field_%x", idx);
        auto FLAGS;
        if (ptrsize == 8) {
            FLAGS = FF_QWRD;
        } else {
            FLAGS = FF_DWRD;
        }
        auto rc = AddStrucMember(msid, member_name, idx, FLAGS, -1, ptrsize);

        auto cmt = sprintf("0x%x", fptr);
        SetMemberComment(msid, idx, cmt, 1);
    }
    return 0;
}


static main() {return 0;}
