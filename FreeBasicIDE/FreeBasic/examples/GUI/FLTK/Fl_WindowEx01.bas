#include once "fltk-c.bi"

'test of:
' Fl_WindowExNew
' Fl_WindowExSetResizeCB
' Fl_WidgetSetUserData
' Fl_WidgetGetUserData
' Fl_BoxNew

function ResizeCB cdecl (byval self as any ptr,byval x as long,byval y as long,byval w as long,byval h as long) as long
  ' center the hello world box
  Fl_WidgetResize(Fl_WidgetGetUserData(self), w/2-50, h/2-12,100,24)
  return 0
end function
'
' main
'
var Win = Fl_WindowExNew(320,200, "Resize Me ...")
Fl_WindowExSetResizeCB Win,@ResizeCB
Fl_WidgetSetUserData Win,Fl_BoxNew(20,40,100,24,"Hello, World!")
Fl_WindowSizeRange Win,160,100
Fl_WindowShow Win
Fl_Run
