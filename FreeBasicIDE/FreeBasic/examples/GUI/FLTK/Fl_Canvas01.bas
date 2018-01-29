#include once "fltk-tools.bi"

'test of Fl_Canvas


sub CanvasDrawCB cdecl (byval me as any ptr, _
                        byref dstX as long,byref dstY as long, _
                        byref cpyW as long,byref cpyH as long, _
                        byref srcX as long,byref srcY as long)
  static as integer xp=-1000,xs=1
  static as integer yp=-1000,ys=1
  static as integer sw=0,sh=0
  var par = Fl_WidgetGetParent(me)
  var x = Fl_WidgetGetX(me)
  var y = Fl_WidgetGetY(me)
  var w = cpyW 'Fl_WidgetGetW(me)
  var h = cpyH 'Fl_WidgetGetH(me)
  var x2=x+w
  var y2=y+h
  if sw=0 or sh=0 then 
    DrawSetFont Fl_HELVETICA_BOLD,50
    sw=DrawGetStrWidth("Canvas")
    sh=DrawGetFontHeight()-DrawGetFontDescent()
  end if
  if xp=-1000 then xp=x+w\2-sw\2
  if yp=-1000 then yp=y+h\2-sh\2

  DrawPushClip 0,0,w,h
    DrawSetColor FL_WHITE : DrawRectFill 0,0,w,h
    DrawSetColor FL_BLACK : DrawRect     0,0,w,h
    DrawSetColor FL_BLACK : DrawStr "Canvas",xp+3,yp+3
    DrawSetColor FL_RED   : DrawStr "Canvas",xp  ,yp
  DrawPopClip

  xp+=xs ' move x position
  if xp<1 then
    xp=0:xs*=-1
  elseif (xp+sw+3)>=w then 
    xs*=-1:xp=w-(sw+3)
  end if

  yp+=ys ' move y position
  if yp<sh-y then
    yp=sh-y:ys*=-1
  elseif yp>=h then 
    ys*=-1:yp=h
  end if

end sub

sub TimeoutCB cdecl (byval can as any ptr)
  Fl_WidgetDraw can
  Fl_RepeatTimeout 1.0/80, @TimeoutCB,can
end sub

'
' main
'
var win = Fl_Double_WindowNew(640,120,"Fl_Canvas resize me ...")
var can = Fl_CanvasNew(10,10,Fl_WidgetGetW(win)-20,Fl_WidgetGetH(win)-20)
Fl_CanvasSetDrawCB   can,@CanvasDrawCB
Fl_WindowSizeRange   win,240,100
Fl_GroupSetResizable win,can
Fl_WindowShow        win
Fl_AddTimeout 1.0, @TimeoutCB, can
Fl_Run

