#include once "fltk-c.bi"

'test of:
' DrawSetFont
' DrawStr
' DrawStrRot

function DrawCB cdecl (byval self as any ptr) as long
  dim as long w =Fl_WidgetGetW(self)
  dim as long h =Fl_WidgetGetH(self)
  dim as long deg = 180
  DrawPushClip 0,0,w,h 
  for font as long = 0 to 15
    dim as long size=6+rnd*70
    DrawSetFont font,size
    for i as long = 0 to 1
      DrawSetRGBColor rnd*255,rnd*255,rnd*255
      dim as long x=rnd*w
      dim as long y=rnd*h
      if i and 1 then
        DrawStr "DrawStr()",x,y
      else
        DrawStrRot deg,"DrawStrRot()",x,y
        deg+=5
      end if
    next
  next
  DrawPopClip
  return 1
end function
'
' main
'
' for drawing it's a good idea to use a flicker free double buffered window
var win = Fl_Double_WindowExNew(640,480,"Drawing02.bas resize me ...")
Fl_Double_WindowExSetDrawCB win,@DrawCB
Fl_GroupSetResizable win,win
Fl_WindowShow win
Fl_Run
