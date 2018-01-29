#include once "fltk-c.bi"

'test of:
' Fl_Radio_Round_ButtonNew http://www.fltk.org/doc-1.3/classFl__Radio__Round__Button.html
' Fl_WidgetSetCallback0

#define Button(x,c) Fl_WidgetSetCallback0 Fl_Radio_Round_ButtonNew(x,10,90,30,c),@ButtonCB

sub ButtonCB cdecl (byval self as Fl_Widget ptr)
  print "ButtonCB: " & *Fl_WidgetGetLabel(self)
end sub
'
' main
'
var win = Fl_WindowNew(350,50,"Radio Round Button")
Fl_WindowBegin win
  Button( 10,"Radio A")
  Button(110,"Radio B")
  Button(210,"Radio C")
Fl_WindowEnd win
Fl_WindowShow win
Fl_Run
