'AuMs.bas (Auios Mouse)
#define fbc -lib -x ../../../lib/win32/libaums.a

#include "crt.bi"
#include "aums.bi"

namespace Auios
    'Dump all variables to the console for debugging
    function AuMouseDump(thisMs as AuMouse) as integer
        with thisMs
            AuMousePrintBar("-",10)
            printf(!"State---: %d\n",.state)
            printf(!"X,Y-----: %d,%d\n",.x,.y)
            printf(!"Wheel---: %d\n",.wheel)
            printf(!"Buttons-: %d\n",.buttons)
            printf(!"Clip----: %d\n",.clip)
        end with
        return 0
    end function
    
    function AuMouseSet(x as long, y as long, visible as long, clip as long) as AuMouse
        dim as AuMouse thisMs
        dim as long result = setmouse(x,y,visible,clip)
        with thisMs
            .x = x
            .y = y
            .visible = visible
            .clip = clip
        end with
        return thisMs
    end function
    
    function AuMouseGet(byref thisMs as AuMouse) as integer
        dim as long x,y,wheel
        with thisMs
            .state = getMouse(.x,.y,.wheel,.buttons,.clip)
            x = .x
            y = .y
            wheel = .wheel
            return .state
        end with
    end function
    
    function AuMouseCompare(thisMs1 as AuMouse,thisMs2 as AuMouse) as integer
        return memcmp(@thisMs1,@thisMs2,sizeof(AuMouse)) 'Return 0 if they are the same
    end function
    
    function AuMousePrintBar(charVar as zstring*1, cnt as long) as integer
        for i as integer = 1 to 10
            printf(!"%s",charVar)
        next i
        printf(!"\n")
        return 0
    end function
    
    function AuMouseHide(byref thisMs as AuMouse) as integer
        with thisMs
            .visible = 0
            setmouse(.x,.y,.visible,.clip)
        end with
        return 0
    end function
    
    function AuMouseShow(byref thisMs as AuMouse) as integer
        with thisMs
            .visible = 0
            setmouse(.x,.y,.visible,.clip)
        end with
        return 0
    end function
end namespace
