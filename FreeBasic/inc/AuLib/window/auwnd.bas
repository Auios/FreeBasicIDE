'AuWnd.bas (Auios Window)
#define fbc -lib -x ../../../lib/win32/libauwnd.a

#include "crt.bi"
#include "fbgfx.bi"
#include "auwnd.bi"

namespace Auios
    'Sets the window
    function AuWindowSet(w as long, h as long, depth as long, pages as long, flags as long, title as zstring*32) as AuWindow
        dim as AuWindow thisWnd
        with thisWnd
            .w = w
            .h = h
            .depth = depth
            .pages = pages
            .flags = flags
            .title = title
            .buffer = screenPtr()
            screenInfo(,,,.bpp,.pitch,.rate,.driver)
        end with
        return thisWnd
    end function
    
    'Get size
    function AuWindowGetSize(thisWnd as AuWindow, byref w as long, byref h as long) as integer
        with thisWnd
            w = .w
            h = .h
        end with
        return 0
    end function
    
    'Creates the window
    function AuWindowCreate(thisWnd as AuWindow) as integer
        dim as integer result
        with thisWnd
            result = screenres(.w,.h,.depth,.pages,.flags or fb.gfx_high_priority)
            windowtitle .title
            .visible = 1
        end with
        return result
    end function
    
    'Closes the window. Does not destroy the variables
    function AuWindowHide(thisWnd as AuWindow) as integer
        thisWnd.visible = 0
        screen 0
        return 0
    end function
    
    'Close the window and destroys AuWindow variables.
    function AuWindowDestroy(thisWnd as AuWindow) as integer
        with thisWnd
            .w = 0
            .h = 0
            .depth = 0
            .pages = 0
            .flags = 0
            .title = "N/A"
            .visible = 0
        end with
        screen 0
        return 0
    end function
    
    'Dumps all the variables to the console for debug purposes
    function AuWindowDump(thisWnd as AuWindow, message as zstring*32) as integer
        with thisWnd
            AuWindowPrintBar("-",10)
            if(message <> "") then printf(!"%s\n",message)
            printf(!"Width---: %d\n",.w)
            printf(!"Height--: %d\n",.h)
            printf(!"Depth---: %d\n",.depth)
            printf(!"Pages---: %d\n",.pages)
            printf(!"Flags---: %d\n",.flags)
            printf(!"Title---: %s\n",.title)
            printf(!"Visible-: %d\n",.visible)
        end with
        return 0
    end function
    
    function AuWindowPrintBar(charVar as zstring*1, cnt as long) as integer
        for i as integer = 1 to 10
            printf(!"%s",charVar)
        next i
        printf(!"\n")
        return 0
    end function
    
    'WARNING! No Mysofts allowed beyond this point!
    'Danger!!!
    '////////////////////OOP version
    '////////////////////OOP version
    '////////////////////OOP version
    '////////////////////OOP version
    'VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
    
    
    sub AuWindow.Set(w as long, h as long, depth as long, pages as long, flags as long, title as zstring*32)
        with this
            .w = w
            .h = h
            .depth = depth
            .pages = pages
            .flags = flags
            .title = title
        end with
    end sub
    
    'Get size
    function AuWindow.GetSize(byref w as long, byref h as long) as integer
        with this
            w = .w
            h = .h
        end with
        return 0
    end function
    
    'Creates the window
    function AuWindow.Create() as integer
        dim as integer result
        with this
            result = screenres(.w,.h,.depth,.pages,.flags)
            windowtitle .title
            .visible = 1
        end with
        return result
    end function
    
    'Closes the window. Does not destroy the variables
    function AuWindow.Hide() as integer
        this.visible = 0
        screen 0
        return 0
    end function
    
    'Close the window and destroys AuWindow variables.
    function AuWindow.Destroy() as integer
        with this
            .w = 0
            .h = 0
            .depth = 0
            .pages = 0
            .flags = 0
            .title = "N/A"
            .visible = 0
        end with
        screen 0
        return 0
    end function
    
    'Dumps all the variables to the console for debug purposes
    function AuWindow.Dump(message as zstring*32) as integer
        with this
            AuWindowPrintBar("-",10)
            if(message <> "") then printf(!"%s\n",message)
            printf(!"Width---: %d\n",.w)
            printf(!"Height--: %d\n",.h)
            printf(!"Depth---: %d\n",.depth)
            printf(!"Pages---: %d\n",.pages)
            printf(!"Flags---: %d\n",.flags)
            printf(!"Title---: %s\n",.title)
            printf(!"Visible-: %d\n",.visible)
        end with
        return 0
    end function
    
    function AuWindow.PrintBar(charVar as zstring*1, cnt as long) as integer
        for i as integer = 1 to 10
            printf(!"%s",charVar)
        next i
        printf(!"\n")
        return 0
    end function
end namespace
