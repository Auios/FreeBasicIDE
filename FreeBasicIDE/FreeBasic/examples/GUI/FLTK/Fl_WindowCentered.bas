#include once "fltk-c.bi"
' test of:
' Fl_GetH()
' Fl_GetW()
const WinWidth = 640
const WinHeight = 480
var Win = Fl_WindowNew2(Fl_GetW()/2-WinWidth /2, _
                        Fl_GetH()/2-WinHeight/2, _
                        WinWidth,WinHeight,"Fl_WindowCentered.bas")
Fl_BoxNew 10,10,WinWidth-20,WinHeight-20,"Hello, World!"
Fl_WindowShow Win
Fl_Run
