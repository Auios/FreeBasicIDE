'AuMouse.bi
'1/22/2017

#IFNDEF _AULIB_BI_
#DEFINE _AULIB_BI_

#include "AuHelper.bi"
#include "crt.bi"

namespace AuLib
    type AuMouse
        as long state
        as long x,y
        as long wheel
        as long buttons
        as long clip
        as long visible
    end type
    
    sub AuMouseDump(mouse as AuMouse)
        AuLibPrintBar("-",10)
        printf(!"State---: %d\n", mouse.state)
        printf(!"X,Y-----: %d,%d\n", mouse.x, mouse.y)
        printf(!"Wheel---: %d\n", mouse.wheel)
        printf(!"Buttons-: %d\n", mouse.buttons)
        printf(!"Clip----: %d\n", mouse.clip)
    end sub
    
    function AuMouseSet(x as long, y as long, visible as long, clip as long) as AuMouse
        dim as AuMouse mouse
        dim as long result = setMouse(x,y,visible,clip)
        mouse.x = x
        mouse.y = y
        mouse.visible = visible
        mouse.clip = clip
        return mouse
    end function
    
    function AuMouseGet(mouse as AuMouse) as integer
        mouse.state = getMouse(mouse.x, mouse.y, mouse.wheel, mouse.buttons, mouse.clip)
        return mouse.state
    end function
    
    'Useful for checking if the mouse has moved
    function AuMouseCompare(mouse1 as AuMouse, mouse2 as AuMouse) as integer
        return memCmp(@mouse1, @mouse2, sizeof(AuMouse)) 'Return 0 if they are the same
    end function
    
    function AuMouseUpdate(mouse as AuMouse) as integer
        mouse.state = getMouse(mouse.x, mouse.y, mouse.wheel, mouse.buttons, mouse.clip)
        return mouse.state
    end function
    
    sub AuMouseHide(mouse as AuMouse)
        mouse.visible = 0
        setMouse(mouse.x, mouse.y, mouse.visible, mouse.clip)
    end sub
    
    sub AuMouseShow(mouse as AuMouse)
        mouse.visible = 1
        setMouse(mouse.x, mouse.y, mouse.visible, mouse.clip)
    end sub
end namespace

#ENDIF