#include once "fltk-c.bi"

' test of DND :
' Fl_EventText()

function HandleCB cdecl (byval self as any ptr,byval event as FL_EVENT) as long
  static as integer ActiveDND=0
  select case as const event
  case FL_EVENT_DND_ENTER   : ActiveDND=1 : return 1
  case FL_EVENT_DND_LEAVE   : ActiveDND=0 : return 1
  case FL_EVENT_DND_DRAG , FL_EVENT_DND_RELEASE : return 1
  case FL_EVENT_PASTE
    if ActiveDND then
      beep
      print *Fl_EventText() : ActiveDND=0 : return 1
    end if
  end select
  return Fl_WindowExHandleBase(self,event)
end function
'
' main
'
var win = Fl_WindowExNew(640,480,"Drag file[s] over the window !")
Fl_WindowExSetHandleCB win,@HandleCB
Fl_WindowShow win
Fl_Run
