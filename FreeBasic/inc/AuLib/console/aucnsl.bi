'AuCnsl.bi (Auios CONSOLE)

#ifndef __AUIOS_CONSOLE__
#define __AUIOS_CONSOLE__
    #inclib "aucnsl"

    namespace Auios
        type AuConsole
            as integer w,h
            as CONSOLE_SCREEN_BUFFER_INFO csbi
            as zstring*48 title
            
            'Setters
            declare sub setPos(as short, as short)
            declare sub setTitle(as zstring*48)
            
            'Getters
            declare sub getSize overload()
            declare sub getSize overload(byref as integer, byref as integer)
        end type
        
        'Setters
        declare sub AuConsoleSetPos(as short, as short)
        declare sub AuConsoleSetTitle(as AuConsole ,as zstring*48)
        
        'Getters
        declare sub AuConsoleStSize overload(as AuConsole)
        declare sub AuConsoleStSize overload(as AuConsole, byref as integer, byref as integer)
    end namespace
#endif
