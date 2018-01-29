#include once "fltk-c.bi"

' test of:
' Fl_ScrollNew
' Fl_WidgetCopyLabel
' Fl_WidgetSetColorSel
' Fl_GroupSetResizable

var win = Fl_WindowNew(640,480,"Fl_Scroll use the scrollbars")
' create a scrollable area (Fl_Scroll extendes Fl_Group)
var scr = Fl_ScrollNew(50,50,Fl_WidgetGetW(win)-100,Fl_WidgetGetH(win)-100)

' Fl_WidgetSetAlign Fl_ScrollScrollbar(scr),Fl_ALIGN_TOP_LEFT
' Fl_WidgetSetAlign Fl_ScrollScrollbar(scr),Fl_ALIGN_TOP_RIGHT
' Fl_WidgetSetAlign Fl_ScrollScrollbar(scr),Fl_ALIGN_BOTTOM_LEFT
' Fl_WidgetSetAlign Fl_ScrollScrollbar(scr),Fl_ALIGN_BOTTOM_RIGHT ' <-- default


' create some buttons with random background and selection color
for y as integer = 0 to 49
  for x as integer = 0 to 49
    dim as string label = "[" & 1 + y*40 + x & "]"
    var btn = Fl_ButtonNew(x*50,y*50,45,45)
    Fl_WidgetCopyLabel btn, label
    Fl_WidgetSetColorSel(btn,Fl_RGB_Color(rnd*255,rnd*255,rnd*255), _
                             Fl_RGB_Color(rnd*255,rnd*255,rnd*255))
  next
next

Fl_GroupSetResizable win,scr
Fl_WindowShow win


Fl_Run