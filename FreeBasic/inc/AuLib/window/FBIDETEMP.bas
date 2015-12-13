'AuWnd.bas (Auios Window)
#define fbc -lib -x ../../../lib/win32/libauwnd.a

#include "crt.bi"
#include "fbgfx.bi"
#include "../other/auother.bas"
#include "auwnd.bi"

namespace Auios
    'Sets the window
    function AuWindow.set(w as long, h as long, depth as long, pages as long, flags as long, title as zstring*32) as integer
        with this
            .w = w
            .h = h
            .depth = depth
            .pages = pages
            .flags = flags
            .title = title
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
    function AuWindow.Close() as integer
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
            printBar("-",10)
            if(message <> "") then printf(!"%s\n",message)
            printf(!"Width---: %d\n",.w)
            printf(!"Height--: %d\n",.h)
            printf(!"Depth---: %d\n",.depth)
            printf(!"Pages---: %d\n",.pages)
            printf(!"Flags---: %d\n",.flags)
            printf(!"Title---: %s\n",.title)
            printf(!"Visible-: %s\n",.visible)
        end with
        return 0
    end function
end namespace