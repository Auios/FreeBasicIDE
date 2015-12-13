#include once "fltk-c.bi"

'test of:
' Fl_WindowShown()
' Fl_WindowMakeCurrent()
' Fl_Wait2()

sub DrawMe(byval win as Fl_Window ptr)
  static as long gfxPrimitive=0
  ' select the window as curent drawing target
  Fl_WindowMakeCurrent win
  ' from here you can use any DrawXYZ commands take a look at "fltk-c.bi"

  ' get position and size of the window
  dim as long x = 10
  dim as long y = 10
  dim as long w = Fl_WidgetGetW(win)-20
  dim as long h = Fl_WidgetGetH(win)-20

  DrawPushClip x,y,w,h ' any drawing outside this clip region are ingnored

  DrawRectFillColor x,y,w,h,FL_WHITE ' fill the whole background
  dim as long r
  for i as integer = 1 to 10
    DrawSetRGBColor rnd*255,rnd*255,rnd*255
    select case gfxPrimitive
    case 0 : DrawPoint rnd*w,rnd*h
    case 1 : DrawLine  rnd*w,rnd*h, rnd*w,rnd*h
    case 2 : DrawRect  rnd*w,rnd*h, rnd*w,rnd*h
    case 3 : r=rnd*h/2:DrawArc rnd*w,rnd*h, r,r, 0,360 ' circle
    case 4 : DrawRectFill rnd*w,rnd*h, rnd*w,rnd*h
    case 5 : dim as integer bt=1+rnd*15 
             DrawBox bt, rnd*w,rnd*h, rnd*w,rnd*h, Fl_RGB_Color(rnd*255,rnd*255,rnd*255)
    case 6 : DrawArc rnd*w,rnd*h, rnd*w,rnd*h, 0,360 ' oval
    end select
  next
  DrawPopClip ' restore old clip region 
  gfxPrimitive=(gfxPrimitive+1) mod 7
end sub
'
' main
'
var win = Fl_Double_WindowNew(640,480,"Drawing03.bas")
Fl_WindowShow win
do
  ' wait for any event with a timeout value
  var t = Fl_Wait2(0.05)
  if Fl_WindowShown(win) =0 then exit do 
  DrawMe win
loop 
