#pragma once

#include "crt.bi"

sub db(s as string)
    var smsg = s & !"\n"
    printf(smsg)
end sub

sub dbBar()
    printf(!"------------------\n")
end sub

sub dbError(s as string)
    printf(s & !"\n")
    sleep()
end sub