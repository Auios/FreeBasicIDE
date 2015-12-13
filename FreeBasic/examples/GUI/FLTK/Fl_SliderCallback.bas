#include once "fltk-c.bi"

'test of:
' Fl_ValuatorGetValue
' Fl_ValuatorSetStep
' Fl_ValuatorBounds

sub SliderCB cdecl(byval self as FL_WIDGET ptr,byval sld as any ptr)
  print "SliderCB: " & Fl_ValuatorGetValue(sld)
end sub
'
' main
'
var win = Fl_WindowNew(150,240)
var sld = Fl_SliderNew(60, 35, 30,170)
Fl_WidgetSetCallbackArg sld,@SliderCB,sld
Fl_ValuatorSetStep sld,0.05
Fl_ValuatorBounds  sld,0,1
Fl_WindowShow win
Fl_Run
