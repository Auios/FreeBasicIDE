#include once "fltk-c.bi"
' tests of:
' Fl_WidgetGetLabel
' Fl_WidgetSetLabelColor
' Fl_RGB_Color
' Fl_WidgetDeactivate
' Fl_WidgetSetTooltip

function HandleCB cdecl (byval self as any ptr,byval event as Fl_Event) as long
  dim as string msg = *Fl_WidgetGetLabel(self) & " "
  select case as const event
  case FL_EVENT_PUSH,FL_EVENT_RELEASE
    if event = FL_EVENT_PUSH then
      msg &= "pushed with MouseButton"
      select case Fl_EventButtons()
      case FL_BUTTON1 : msg &= "(1)"
      case FL_BUTTON2 : msg &= "(2)"
      case FL_BUTTON3 : msg &= "(3)"
      end select
    else
      msg &= "released"
    end if
    msg & = " at position " & Fl_EventX() & "," & Fl_EventY()
    ? msg
  end select
  return Fl_ButtonExHandleBase(self,event) ' don't eat the event
end function
dim as Fl_ButtonEx ptr Btn
dim as Fl_Window ptr Win = Fl_WindowNew2(100,100,320,130,"ButtonEx04")
Btn = Fl_ButtonExNew( 10,10,300,30,"Button A") : Fl_ButtonExSetHandleCB Btn,@HandleCB : Fl_WidgetSetTooltip Btn,"I'm Buttun A"
Btn = Fl_ButtonExNew( 10,50,300,30,"Button B") : Fl_ButtonExSetHandleCB Btn,@HandleCB : Fl_WidgetSetTooltip Btn,"I'm Buttun B"
Btn = Fl_ButtonExNew( 10,90, 90,30,"Button C") : Fl_ButtonExSetHandleCB Btn,@HandleCB : Fl_WidgetSetLabelColor Btn, FL_RED : Fl_WidgetSetTooltip Btn,"I'm red"
Btn = Fl_ButtonExNew(110,90,100,30,"Button D") : Fl_ButtonExSetHandleCB Btn,@HandleCB : Fl_WidgetSetTooltip Btn,"I'm Buttun D"
Btn = Fl_ButtonExNew(220,90, 90,30,"Button E") : Fl_WidgetSetLabelColor Btn, Fl_RGB_Color(160,80,0) : Fl_WidgetDeactivate Btn : Fl_WidgetSetTooltip Btn,"I'm deactived"

Fl_WindowShow Win
Fl_Run
