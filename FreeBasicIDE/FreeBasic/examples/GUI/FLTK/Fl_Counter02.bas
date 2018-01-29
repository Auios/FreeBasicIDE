#include once "fltk-c.bi"

sub CounterCB cdecl (byval self as FL_WIDGET ptr,byval valuator as any ptr)
  print *Fl_WidgetGetLabel(self) & " value = " & Fl_ValuatorGetValue(valuator)
end sub

var win = Fl_WindowNew(212,112,"Fl_Counter02.bas")
var cnt1 = Fl_CounterNew(10,10,192,24,"counter 1")
var cnt2 = Fl_Simple_CounterNew(10,64,192,24,"counter 2")
Fl_WidgetSetCallbackArg cnt1,@CounterCB,cnt1
Fl_WidgetSetCallbackArg cnt2,@CounterCB,cnt2
Fl_GroupSetResizable win,win
Fl_WindowShow win
Fl_Run

