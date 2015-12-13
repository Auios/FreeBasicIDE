'AuCnsl.bas (Auios Console)
#define fbc -lib -x ../../../lib/win32/libaucnsl.a

#include "windows.bi"
#include "aucnsl.bi"

namespace Auios
    
    sub AuConsoleSetPos(x as short, y as short)
        SetConsoleCursorPosition( GetStdHandle(STD_OUTPUT_HANDLE),type(x,y))
    end sub
    
    sub AuConsoleGetSize overload(thisCnsl as AuConsole)
        with thisCnsl
            GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE),@.csbi)
            .w = .csbi.srWindow.Right - .csbi.srWindow.Left+1
            .h = .csbi.srWindow.Bottom - .csbi.srWindow.Top+1
        end with
    end sub
    
    sub AuConsoleGetSize overload(thisCnsl as AuConsole, byref ww as integer, byref hh as integer)
        with thisCnsl
            GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE),@.csbi)
            .w = .csbi.srWindow.Right - .csbi.srWindow.Left+1
            .h = .csbi.srWindow.Bottom - .csbi.srWindow.Top+1
            ww = .w
            hh = .h
        end with
    end sub
    
    sub AuConsoleSetTitle(thisCnsl as AuConsole, title as zstring*48)
        thisCnsl.title = title
    end sub
    
    'WARNING! No Mysofts allowed beyond this point!
    'Danger!!!
    '////////////////////OOP version
    '////////////////////OOP version
    '////////////////////OOP version
    '////////////////////OOP version
    'VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
    
    sub AuConsole.setPos(x as short, y as short)
        SetConsoleCursorPosition( GetStdHandle(STD_OUTPUT_HANDLE),type(x,y))
    end sub
    
    sub AuConsole.getSize overload()
        GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE),@csbi)
        w = csbi.srWindow.Right - csbi.srWindow.Left+1
        h = csbi.srWindow.Bottom - csbi.srWindow.Top+1
    end sub
    
    sub AuConsole.getSize overload(byref ww as integer, byref hh as integer)
        GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE),@csbi)
        w = csbi.srWindow.Right - csbi.srWindow.Left+1
        h = csbi.srWindow.Bottom - csbi.srWindow.Top+1
        ww = w
        hh = h
    end sub
    
    sub AuConsole.setTitle(_title as zstring*48)
        title = _title
    end sub
end namespace
