#include once "fltk-c.bi"

' test of:
' WidgetExSetDestructorCB
' WidgetExSetHandleCB
' Fl_ButtonExHandleBase

' Fl_DeleteWidget
' Fl_WidgetWindow
' Fl_WidgetRedraw

sub DestructorCB cdecl (byval self as any ptr)
  Fl_WidgetRedraw Fl_WidgetWindow(self) ' redraw the parent
end sub

function HandleCB cdecl (byval self as any ptr,byval event as Fl_Event) as long
  if event=FL_EVENT_RELEASE then Fl_DeleteWidget self
  return Fl_ButtonExHandleBase(self,event) ' don't eat the event
end function
'
' main
'
var win = Fl_WindowNew(320,200)
var btn = Fl_ButtonExNew(10,10,128,24,"Delete me ...")
Fl_ButtonExSetDestructorCB btn,@DestructorCB
Fl_ButtonExSetHandleCB     btn,@HandleCB
Fl_WindowShow win
Fl_Run
