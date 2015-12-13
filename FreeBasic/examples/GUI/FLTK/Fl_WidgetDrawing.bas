#include once "fltk-c.bi"

' test of:
' Fl_ButtonExSetDrawCB
' Fl_ButtonExSetHandleCB

sub Button1PressCB cdecl (byval Button1 as Fl_Widget ptr,byval Button2 as any ptr)
  Fl_WidgetSetUserData Button2, cast(any ptr,1)
  Fl_WidgetRedraw      Button2
end sub

function Button2DrawCB cdecl (byval Button2 as any ptr) as long
  var DrawFlag = Fl_WidgetGetUserData(Button2)
  if DrawFlag then
    var x = Fl_WidgetGetX(Button2) + Fl_WidgetGetW(Button2)/2
    var y = Fl_WidgetGetY(Button2) + Fl_WidgetGetH(Button2)/2
    var r = Fl_WidgetGetH(Button2) / 3
    DrawSetColor FL_RED : DrawCircle x,y,r
    DrawFlag=0 : Fl_WidgetSetUserData Button2,DrawFlag
    return 1 ' <-- tell FLTK "ignore the callback we are drawing the button self"
  else
    return 0 ' <-- tell FLTK "we don't draw it and draw the button for us"
  end if
end function

function Button2HandleCB cdecl (byval self as any ptr,byval event as Fl_Event) as long
  return Fl_ButtonExHandleBase(self,event) ' dnon't eat the event
end function
'
' main
'
var Window1 = Fl_WindowNew(158,52,"WidgetDrawing")
var Button1 = Fl_ButtonNew(10,10,64,32,"draw...")
var Button2 = Fl_ButtonExNew(84,10,64,32,"clear...")
Fl_WidgetSetCallbackArg Button1,@Button1PressCB,Button2
Fl_ButtonExSetDrawCB    Button2,@Button2DrawCB
Fl_ButtonExSetHandleCB  Button2,@Button2HandleCB
Fl_WindowShow           Window1
Fl_Run


