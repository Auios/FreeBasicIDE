#include once "fltk-c.bi"

'test of:
' Fl_Double_WindowExNew
' Fl_Double_WindowExSetDrawCB
' DrawPushClip
' DrawPopClip
' DrawSetColor
' DrawRectFill
' DrawYXLine
' DrawXYLine

function DrawCB cdecl (byval self as any ptr) as long
  var x  = 0
  var y  = 0
  var w  = Fl_WidgetGetW(self)
  var h  = Fl_WidgetGetH(self)
  var x2 = x+w
  var y2 = y+h

  ' any drawing outside this clip region are ingnored
  DrawPushClip x,y,w,h 

  DrawSetColor(FL_WHITE)
  DrawRectFill(x,y,w,h)

  DrawSetColor(FL_RED)
  for xx as integer = x to x2 step 10
    DrawYXLine(xx,y,h)
  next

  DrawSetColor(FL_BLUE)
  for yy as integer = y to y2 step 10
    DrawXYLine(x,yy,w)
  next

  ' restore old clip region
  DrawPopClip
  return 1
end function

'
' main
'
' for drawing it's a good idea to use a flicker free double buffered window
var win = Fl_Double_WindowExNew(640,480,"Drawing01.bas resize me ...")
Fl_Double_WindowExSetDrawCB win,@DrawCB
Fl_GroupSetResizable win,win
Fl_WindowShow win
Fl_Run
