'AuGUI.bas (Auios GUI)
#define fbc -lib -x ../../../lib/win32/libaugui.a

'#include "crt.bi"
'#include "augui.bi"

namespace Auios
'    function AuGUIInit(x as long,y as long,w as long,h as long,title as zstring*48) as AuGUI
'        dim as AuGUI thisGUI
'        with thisGUI
'            .x = x
'            .y = y
'            .w = w
'            .h = h
'            .title = title
'        end with
'        return thisGUI
'    end function
'    
'    function AuGUIOpen(thisGUI as AuGUI) as integer
'        with thisGUI
'            .isOpen = 1
'        end with
'        return 0
'    end function
'    
'    function AuGUIClose(thisGUI as AuGUI) as integer
'        with thisGUI
'            .isOpen = 0
'        end with
'        return 0
'    end function
'    
'    function AuGUIDestroy(thisGUI as AuGUI) as integer
'        with thisGUI
'            
'        end with
'        return 0
'    end function
'    
'    function AuGUIRender(thisGUI as AuGUI) as integer
'        dim as byte titleSzY = 16
'        dim as uinteger clrTitle = rgb(180,180,180)
'        dim as uinteger clrCanvas = rgb(200,200,200)
'        dim as uinteger clrBorder = rgb(100,100,100)
'        dim as uinteger clrText = rgb(100,100,100)
'        with thisGUI
'            if .isOpen then
'                view(.x,.y)-(.x+.w,.y+titleSzY) 
'                    line(0,0)-(.w,TitleSzY),clrTitle,bf 'Title canvas
'                    line(0,TitleSzY-1)-(.w,TitleSzY-1),clrBorder 'Title Border
'                    draw string(4,4),.title,clrText 'Window Title
'                
'                view(.x,.y+titleSzY)-(.x+.w,.y+titleSzY+.h)
'                    line(0,0)-(.x,.h),clrCanvas,bf 'Window canvas
'                
'                view(.x-1,.y-1)-(.x+.w+1,.y+.h+titleSzY+1)
'                    line(0,0)-(.w+1,.h+titleSzY+1),clrBorder,b 'Window border
'                
'                view(.x+.w-15,.y+titleSzY-16)-(.x+.w,.y+titleSzY)
'                    line(0,0)-(14,14),clrBorder,b 'X border
'                    line(2,2)-(12,12),clrText 'Upper left to lower right
'                    line(12,2)-(2,12),clrText 'Upper right to lower left
'                
'                window
'                view screen
'            end if
'        end with
'        return 0
'    end function
'    
'    function AuGUIInput(thisGUI as AuGUI, thisMs as AuMouse) as integer
'        if 
'        return 0
'    end function
end namespace
