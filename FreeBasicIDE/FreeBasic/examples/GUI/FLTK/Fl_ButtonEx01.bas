#include once "fltk-c.bi"

'test of:
' Fl_WindowNew()    http://www.fltk.org/doc-1.3/classFl__Window.html
' Fl_ButtonExNew()
' Fl_ButtonExSetHandleCB()
' Fl_EventButtons() http://www.fltk.org/doc-1.3/group__fl__events.html#gaee06c25589974fafb1c8df8d0e2c7c80
' Fl_EventX()       http://www.fltk.org/doc-1.3/group__fl__events.html#ga91585fcbaa1e79f7452fd2d16a82136e
' Fl_EventY()       http://www.fltk.org/doc-1.3/group__fl__events.html#ga192a0c5a37f33b9d117a69f20977c2a1

function ButtonHandleCB cdecl (byval self as any ptr,byval event as Fl_Event) as long
  dim as string msg
  select case as const event
  case FL_EVENT_PUSH
    msg = "Button pushed with mouse button "
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

dim as Fl_Window   ptr Win = Fl_WindowNew(320,200)
dim as Fl_ButtonEx ptr Btn = Fl_ButtonExNew(10,10,320-20,200-20,"push me !")
Fl_ButtonExSetHandleCB Btn,@ButtonHandleCB
Fl_WindowShow Win
Fl_Run
