#include once "fltk-c.bi"

sub WindowCB cdecl (byval self as FL_WIDGET ptr)
  Fl_WindowHide Fl_WidgetAsWindow(self)
  print "window closed !"
  beep:sleep 1000
end sub
'
' main
'
var Win = Fl_WindowNew(320,200)
Fl_WidgetSetCallback0 Win, @WindowCB
Fl_WindowShow Win
Fl_Run