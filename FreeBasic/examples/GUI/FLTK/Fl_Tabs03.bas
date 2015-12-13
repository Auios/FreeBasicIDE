#include once "fltk-c.bi"

' test of: Fl_TabsEnd, Fl_TabNew and Fl_TabEnd 
' this are macros defined in fltk-c.bi

sub TabCB cdecl (byval tabs as FL_WIDGET ptr,byval parent as any ptr)
  print "TabCB: " & *Fl_WidgetGetLabel(Fl_TabsGetValue(parent))
end sub

sub ButtonCB cdecl (byval btn as FL_WIDGET ptr)
  print "ButtonCB: " & *Fl_WidgetGetLabel(btn)
end sub

var win = Fl_WindowNew(500,200,"Tabs03.bas")
 var tabs = Fl_TabsNew(10,10,500-20,200-20)
  Fl_WidgetSetCallbackArg tabs,@TabCB,tabs
  var tab1 = Fl_TabNew(10,35,500-20,200-45,"Tab 1")
   Fl_WidgetSetCallback0 Fl_ButtonNew(50,60,90,25,"Button A"),@ButtonCB
   Fl_WidgetSetCallback0 Fl_ButtonNew(50,90,90,25,"Button B"),@ButtonCB
  Fl_TabEnd tab1
  var tab2 = Fl_TabNew(10,35,500-20,200-45,"Tab 2")
   Fl_WidgetSetCallback0 Fl_ButtonNew(50,60,90,25,"Button C"),@ButtonCB
   Fl_WidgetSetCallback0 Fl_ButtonNew(50,90,90,25,"Button D"),@ButtonCB
  Fl_TabEnd tab2
  var tab3 = Fl_TabNew(10,35,500-20,200-45,"Tab 3")
   Fl_WidgetSetCallback0 Fl_ButtonNew(50,60,90,25,"Button E"),@ButtonCB
   Fl_WidgetSetCallback0 Fl_ButtonNew(50,90,90,25,"Button F"),@ButtonCB
  Fl_TabEnd tab3
 Fl_TabsEnd tabs
Fl_WindowEnd win

Fl_WindowShow win
Fl_Run
