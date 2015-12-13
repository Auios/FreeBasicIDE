'AuCnsl2.bi (Auios Console v2)

#ifndef __AUIOS_CONSOLE__
#define __AUIOS_CONSOLE__
'    #inclib "aucnsl2"

    declare sub AuConsoleCls cdecl alias "fb_ConsoleClear" (iMode as integer = 0)
    declare sub AuConsoleClear cdecl alias "fb_ConsoleClear" (iMode as integer = 0)
    declare function AuConsoleLocate cdecl alias "fb_ConsoleLocate" (iRow as integer=-1,iCol as integer=-1,iState as integer=-1,iStart as integer=0,iStop as integer=0) as integer
    declare function AuConsoleColor cdecl alias "fb_ConsoleColor" (iFore as integer=-1,iBack as integer=-1,iFlags as integer=0) as integer
#endif
