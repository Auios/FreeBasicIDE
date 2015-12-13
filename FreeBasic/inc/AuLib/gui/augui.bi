'AuGUI.bi (Auios GUI)

#ifndef __AUIOS_GUI__
#define __AUIOS_GUI__

'    #include "../mouse/AuMs.bi"
'    
'    #inclib "augui"
    
    namespace Auios
'        type AuGUI
'            as ubyte canResize
'            as ubyte isOpen
'            as long x,y,w,h
'            as ulong zorder
'            
'            as zstring*48 title
'        end type
'        
'        declare function AuGUIInit(x as long,y as long,w as long = 200,h as long = 150,title as zstring*48 = "GUI Window") as AuGUI
'        declare function AuGUIOpen(thisGUI as AuGUI) as integer
'        declare function AuGUIClose(thisGUI as AuGUI) as integer
'        declare function AuGUIDestroy(thisGUI as AuGUI) as integer
'        declare function AuGUIRender(thisGUI as AuGUI) as integer
'        declare function AuGUIInput(thisGUI as AuGUI, thisMs as AuMouse) as integer
    end namespace
#endif