#include once "fltk-c.bi"

function ButtonHandleCB cdecl (byval self as any ptr,byval event as Fl_Event) as long
  dim as string msg
  select case as const event
  case FL_EVENT_PUSH
    msg = *Fl_WidgetGetLabel(self) & " pushed with mouse button "
    select case Fl_EventButtons()
    case FL_BUTTON1 : msg &= "1 "
    case FL_BUTTON2 : msg &= "2 "
    case FL_BUTTON3 : msg &= "3 "
    end select
    msg & = "at position " & Fl_EventX() & "," & Fl_EventY()
    ? msg
  end select
  return Fl_ButtonExHandleBase(self,event) ' don't eat the event
end function

dim as Fl_Window ptr Win  = Fl_WindowNew2(100,100,320,200,"ButtonEx02")
Fl_ButtonExSetHandleCB Fl_ButtonExNew( 10,10,300,30,"Button A"),@ButtonHandleCB
Fl_ButtonExSetHandleCB Fl_ButtonExNew( 10,50,300,30,"Button B"),@ButtonHandleCB
Fl_ButtonExSetHandleCB Fl_ButtonExNew( 10,90, 90,30,"Button C"),@ButtonHandleCB
Fl_ButtonExSetHandleCB Fl_ButtonExNew(110,90,100,30,"Button D"),@ButtonHandleCB
Fl_ButtonExSetHandleCB Fl_ButtonExNew(220,90, 90,30,"Button E"),@ButtonHandleCB
Fl_WindowShow Win
Fl_Run
