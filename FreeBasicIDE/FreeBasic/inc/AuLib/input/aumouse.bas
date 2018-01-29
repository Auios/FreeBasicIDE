'AuMouse.bi
'1/22/2017

#IFNDEF _AULIB_BI_
#DEFINE _AULIB_BI_

#include once "../string/austringmanip.bas"
#include once "crt.bi"

namespace AuLib
    type AuMouse
        as long state
        as long x,y
        as long wheel
        as long buttons
        as long clip
        as long visible
        
        declare sub dump()
        declare function set(x as long, y as long, visible as long, clip as long) as long
        declare function get() as integer
        declare function compare(target as AuMouse) as integer
        declare function update() as integer
        declare sub hide()
        declare sub show()
    end type
    
    sub AuMouse.dump()
        printBar("-",10)
        printf(!"State---: %d\n", this.state)
        printf(!"X,Y-----: %d,%d\n", this.x, this.y)
        printf(!"Wheel---: %d\n", this.wheel)
        printf(!"Buttons-: %d\n", this.buttons)
        printf(!"Clip----: %d\n", this.clip)
    end sub
    
    function AuMouse.set(x as long, y as long, visible as long, clip as long) as long
        dim as long result = setMouse(x,y,visible,clip)
        this.x = x
        this.y = y
        this.visible = visible
        this.clip = clip
        return result
    end function
    
    function AuMouse.get() as integer
        this.state = getMouse(this.x, this.y, this.wheel, this.buttons, this.clip)
        return this.state
    end function
    
    'Useful for checking if the mouse has moved
    function AuMouse.compare(target as AuMouse) as integer
        return memCmp(@this, @target, sizeof(AuMouse)) 'Return 0 if they are the same
    end function
    
    function AuMouse.update() as integer
        this.state = getMouse(this.x, this.y, this.wheel, this.buttons, this.clip)
        return this.state
    end function
    
    sub AuMouse.hide()
        this.visible = 0
        setMouse(this.x, this.y, this.visible, this.clip)
    end sub
    
    sub AuMouse.show()
        this.visible = 1
        setMouse(this.x, this.y, this.visible, this.clip)
    end sub
end namespace

#ENDIF