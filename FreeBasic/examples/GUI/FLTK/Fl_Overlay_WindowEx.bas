#include once "fltk-c.bi"
' test of:
' Fl_Overlay_Window http://www.fltk.org/doc-1.3/classFl__Overlay__Window.html

dim shared as integer w=150,h=150

sub Draw_OverlayCB cdecl (byval self as any ptr)
  DrawSetColor(FL_RED)
  DrawRect((Fl_WidgetGetW(self)-w)/2,(Fl_WidgetGetH(self)-h)/2,w,h)
end sub

function HandleCB cdecl(byval self as any ptr,byval event as Fl_Event) as long
  return Fl_Overlay_WindowExHandleBase(self,event) ' don't eat the event
end function

sub Button1CB cdecl (byval self as Fl_Widget ptr,byval ovl as any ptr)
  h+=20 : Fl_Overlay_WindowRedrawOverlay ovl
end sub

sub Button2CB cdecl (byval self as Fl_Widget ptr,byval ovl as any ptr)
  h-=20 : Fl_Overlay_WindowRedrawOverlay ovl
end sub

sub Button3CB cdecl (byval self as Fl_Widget ptr,byval ovl as any ptr)
  w+=20 : Fl_Overlay_WindowRedrawOverlay ovl
end sub

sub Button4CB cdecl (byval self as Fl_Widget ptr,byval ovl as any ptr)
  w-=20 : Fl_Overlay_WindowRedrawOverlay ovl
end sub
'
' main
'
dim as  Fl_Overlay_WindowEx ptr win = Fl_Overlay_WindowExNew(400,400,"Fl_Overlay_WindowEx")
Fl_Overlay_WindowExSetDraw_OverlayCB win,@Draw_OverlayCB
Fl_Overlay_WindowExSetHandleCB       win,@HandleCB
Fl_WidgetSetCallbackArg Fl_ButtonNew( 50, 50,100,100,"wider")   ,@Button1CB,win
Fl_WidgetSetCallbackArg Fl_ButtonNew(250, 50,100,100,"narrower"),@Button2CB,win
Fl_WidgetSetCallbackArg Fl_ButtonNew( 50,250,100,100,"taller")  ,@Button3CB,win
Fl_WidgetSetCallbackArg Fl_ButtonNew(250,250,100,100,"shorter") ,@Button4CB,win
Fl_GroupSetResizable(win,win)

Fl_Overlay_WindowRedrawOverlay win
Fl_Overlay_WindowShow win
Fl_Run
