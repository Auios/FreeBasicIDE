#include once "fltk-c.bi"
' test of:
' DrawOverlayRect
' DrawOverlayClear

type DRAWJOB
  as integer state
  as integer x,y,x2,y2
end type

function DrawCB cdecl (byval self as any ptr) as long
  dim as DRAWJOB ptr dj = Fl_WidgetGetUserData(self)
  var x = dj->x    : var y = dj->y
  var w = dj->x2-x : var h = dj->y2-y
  select case as const dj->state
  case 2
    DrawOverlayClear
    DrawOverlayRect x,y,w,h
  case 3
    DrawOverlayClear
    DrawSetRGBColor 0,0,255
    If w<0 Then x+=w:w=-w
    If h<0 Then y+=h:h=-h
    DrawRect x,y,w,h
    dj->state = 0
  case else
    return 1
  end select
  return 1
end function

function HandleCB cdecl (byval self as any ptr,byval event as FL_EVENT) as long
  dim as DRAWJOB ptr dj = Fl_WidgetGetUserData(self)
  select case as const event
  case FL_EVENT_PUSH
    dj->state=1
    dj->x=Fl_EventX() : dj->y=Fl_EventY()
  case FL_EVENT_DRAG
    dj->state=2
    dj->x2=Fl_EventX() : dj->y2=Fl_EventY()
  case FL_EVENT_RELEASE
    if dj->state=2 then dj->state=3
  case else
    return 0
  end select
  Fl_WidgetRedraw self
  return 1
end function

'
' main
'
var win = Fl_WindowNew(640,480,"DrawOverlayRect.bas")
var box = Fl_BoxExNew(0,0,640,480)
dim as DRAWJOB dj
Fl_WidgetSetUserData box,@dj
Fl_BoxExSetDrawCB    box,@DrawCB
Fl_BoxExSetHandleCB  box,@HandleCB
Fl_WindowShow win
Fl_Run