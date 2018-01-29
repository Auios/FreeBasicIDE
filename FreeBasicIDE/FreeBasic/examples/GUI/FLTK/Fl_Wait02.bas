#include once "fltk-c.bi"

'test of:
' Fl_Wait2(time) http://www.fltk.org/doc-1.3/classFl.html#a108a84216f0b3fa1cb0c46ab7449a312
' Fl_Window
' Fl_box

dim as Fl_Window ptr Win = Fl_WindowNew(320,200, "Fl_Wait2")
Fl_BoxNew 20,40,300,100,"Hello, World!"
Fl_WindowShow Win


while Fl_WindowShown(win)
  ' wait for any event with time out value
  dim as double t = Fl_Wait2(0.1)
  print ".";
wend

