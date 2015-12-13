#include once "fltk-c.bi"

sub DrawCB cdecl (byval self as Fl_Widget ptr,byval SaveButton as any ptr)
  Fl_WindowMakeCurrent(Fl_WidgetWindow(self))
  for i as integer = 1 to 100
    DrawSetRGBColor(rnd*256,rnd*256,rnd*256)
    DrawLine(rnd*128,rnd*128,rnd*128,rnd*128)
  next
  Fl_WidgetActivate SaveButton
end sub

sub SaveCB cdecl (byval self as Fl_Widget ptr,byval LoadButton as any ptr)
  Fl_WindowMakeCurrent(Fl_WidgetWindow(self))
  ScreenRes 128,128,32,,-1
  dim as ubyte ptr p = ImageCreate(128,128)
  dim as ubyte ptr pixels = p+32
  DrawReadImage pixels,0,0,128,128,255
  ' BGRA->RGBA
  for i as long=0 to 128*128-1
    dim as ubyte tmp=pixels[i*4+0]
    pixels[i*4+0]=pixels[i*4+2]
    pixels[i*4+2]=tmp
  next
  bsave "media/temp.bmp",p
  ImageDestroy p
  Screen 0
  Fl_WidgetActivate LoadButton
end sub

sub LoadCB cdecl (byval self as Fl_Widget ptr,byval RightBox as any ptr)
  Fl_WidgetSetImage RightBox,Fl_BMP_ImageNew("media/temp.bmp")
  Fl_WidgetRedraw RightBox
end sub

'
' main
'
chdir exepath
var MainWindow = Fl_WindowNew(128*3,128,"")
var LeftBox    = Fl_BoxNew   (  0,0,128,128)
var RightBox   = Fl_BoxNew   (256,0,128,128)
var DrawButton = Fl_ButtonNew(128+32,10   ,64,24,"Draw")
var SaveButton = Fl_ButtonNew(128+32,10+32,64,24,"Save")
var LoadButton = Fl_ButtonNew(128+32,10+64,64,24,"Load")

Fl_WidgetSetImage LeftBox, Fl_BMP_ImageNew("media/renata.bmp")
Fl_WidgetSetCallbackArg(DrawButton,@DrawCB,SaveButton)
Fl_WidgetSetCallbackArg(SaveButton,@SaveCB,LoadButton)
Fl_WidgetSetCallbackArg(LoadButton,@LoadCB,RightBox)
Fl_WidgetDeactivate SaveButton
Fl_WidgetDeactivate LoadButton
Fl_WindowShow       MainWindow
Fl_Run
