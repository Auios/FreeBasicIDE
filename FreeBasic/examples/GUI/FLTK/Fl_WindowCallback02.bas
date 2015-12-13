#include once "fltk-c.bi"

sub WindowCB cdecl (byval self as FL_WIDGET ptr)
  if ((Fl_EventNumber()=FL_EVENT_SHORTCUT) andalso (Fl_EventKey()=FL_Escape)) then
    return ' ignore Escape
  end if
  beep
  Fl_WindowHide Fl_WidgetAsWindow(self)
end sub
'
' main
'
var Win = Fl_WindowNew(320,200)
Fl_WidgetSetCallback0 Win, @WindowCB
Fl_WindowShow Win
Fl_Run