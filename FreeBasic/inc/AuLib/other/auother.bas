'AuOther.bas (Auios Other)
'define fbc -lib -x ../../../lib/win32/libauother.a

#include "crt.bi"
#include "auother.bi"

namespace Auios
    function printBar(charVar as zstring*1, cnt as long) as integer
        for i as integer = 1 to 10
            printf(!"%s",charVar)
        next i
        printf(!"\n")
        return 0
    end function
end namespace