#include once "fltk-c.bi"

' drawing via timer proc

function DrawCB cdecl (box as any ptr) as long
  static as single sx=2.345
  static as single sy=3.456
  static as single x=0
  static as single y=0
  static as single w=0 
  
  dim as ubyte r=127.5+cos(w)*127
  dim as ubyte g=127.5+sin(w)*127
  dim as ubyte b=127.5+cos(w+3.14)*127
  DrawSetColor Fl_RGB_Color(r,g,b)
  DrawRectFill x,y,32,32
  dim as long xmax = Fl_WidgetGetW(box)-32
  dim as long ymax = Fl_WidgetGetH(box)-32
  x+=sx
  if x<0 then
    x=0 : sx=-sx
  elseif x>xMax then
    x=xmax : sx=-sx
  end if

  y+=sy
  if y<0 then
    y=0 : sy=-sy
  elseif y>ymax then
    y=ymax : sy=-sy
  end if

  w+=0.01
  return 0
end function

sub TimeoutHandler cdecl (byval win as any ptr)
  ' triger DrawCB
  Fl_WidgetRedraw win
  ' reapeat the timer with 50 FPS
  Fl_RepeatTimeout(1/50, @TimeoutHandler,win)
end sub

'
' main
'
var win = Fl_Double_WindowNew(512,512,"Drawing06.bas")
var box = Fl_BoxExNew(0,0,Fl_WidgetGetW(win),Fl_WidgetGetH(win))
Fl_BoxExSetDrawCB box,@DrawCB
Fl_WindowShow win
Fl_AddTimeout 0, @TimeoutHandler,win
Fl_Run
