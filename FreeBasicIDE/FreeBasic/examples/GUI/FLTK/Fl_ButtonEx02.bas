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

dim as Fl_Window   ptr Win  = Fl_WindowNew(320,200)
dim as Fl_ButtonEx ptr BtnA = Fl_ButtonExNew( 10,10,300,30,"Button A")
dim as Fl_ButtonEx ptr BtnB = Fl_ButtonExNew( 10,50,300,30,"Button B")
dim as Fl_ButtonEx ptr BtnC = Fl_ButtonExNew( 10,90, 90,30,"Button C")
dim as Fl_ButtonEx ptr BtnD = Fl_ButtonExNew(110,90,100,30,"Button D")
dim as Fl_ButtonEx ptr BtnE = Fl_ButtonExNew(220,90, 90,30,"Button E")
Fl_ButtonExSetHandleCB BtnA,@ButtonHandleCB
Fl_ButtonExSetHandleCB BtnB,@ButtonHandleCB
Fl_ButtonExSetHandleCB BtnC,@ButtonHandleCB
Fl_ButtonExSetHandleCB BtnD,@ButtonHandleCB
Fl_ButtonExSetHandleCB BtnE,@ButtonHandleCB
Fl_WindowShow Win
Fl_Run
