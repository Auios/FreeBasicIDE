#include once "fltk-tools.bi" ' for EventAsString()

' test of:
'  Fl_WidgetSetWhen

' you can control when an callback should be triggered

sub Callback cdecl (byval self as FL_WIDGET ptr)
  print *EventAsString(Fl_EventNumber())
end sub
'
' main
'
var w = Fl_WindowNew(320,80,"Fl_Callbacks02.bas")
var b = Fl_ButtonNew(10,10,300,24,"button")
Fl_WidgetSetWhen       b,FL_WHEN_CHANGED ' enable PUSH and RELEASE
Fl_WidgetSetCallback0  b,@Callback

var i = Fl_InputNew(45,44,260,24,"input")
Fl_WidgetSetWhen       i,FL_WHEN_ENTER_KEY_CHANGED ' enable keystrokes and the ENTER key
Fl_WidgetSetCallback0  i,@Callback
Fl_WindowShow          w
Fl_Run
