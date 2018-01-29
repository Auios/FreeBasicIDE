#include once "fltk-c.bi"
' test of:
' Fl_Window  http://www.fltk.org/doc-1.3/classFl__Window.html
' Fl_Button  http://www.fltk.org/doc-1.3/classFl__Button.html

sub ButtonCB cdecl (byval button as FL_WIDGET ptr)
  static var Pushed=1
  Fl_WidgetCopyLabel button,"push me:" & chr(10) & Pushed & " times pushed"
  Pushed+=1
end sub
'
' main
'
var Win = Fl_WindowNew(320,200,"FL_BUTTON")
var Btn = Fl_ButtonNew(10,10,320-20,200-20,"push me:")
Fl_WidgetSetCallback0 Btn,@ButtonCB
Fl_WindowShow Win
Fl_Run
