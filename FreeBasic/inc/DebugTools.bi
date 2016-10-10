#pragma once

#include "crt.bi"

declare function db (s as string) as string
function db(s as string) as string
    var smsg = s & !"\n"
    printf(smsg)
    return smsg
end function

sub dbBar()
    printf(!"------------------\n")
end sub