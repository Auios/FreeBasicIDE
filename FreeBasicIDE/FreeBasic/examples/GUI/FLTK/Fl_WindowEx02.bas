#include once "fltk-c.bi"

type FB_FORM extends Fl_Double_WindowEx
  public:
  declare destructor
  declare constructor(w as long,h as long,caption as zstring ptr=0)
  declare constructor(x as long,y as long,w as long,h as long,caption as zstring ptr=0)
  declare operator cast as Fl_Widget          ptr ' this form as Widget
  declare operator cast as Fl_Group           ptr ' this form as Group
  declare operator cast as Fl_Window          ptr ' this form as Window
  declare operator cast as Fl_Double_WindowEx ptr ' this form as Double_WindowEx

  ' user events (optional)
  as function (as FB_FORM ptr) as long ShowEvent
  as function (as FB_FORM ptr) as long HideEvent
  as function (as FB_FORM ptr) as long CloseEvent
  as function (as FB_FORM ptr) as long FocusEvent
  as function (as FB_FORM ptr) as long UnfocusEvent
  as function (as FB_FORM ptr) as long EnterEvent
  as function (as FB_FORM ptr) as long LeaveEvent
  as function (as FB_FORM ptr) as long DrawEvent
  as function (as FB_FORM ptr,x as long,y as long,w as long,h as long) as long ResizeEvent
  as function (as FB_FORM ptr,button as long,x as long,y as long) as long ButtonPushEvent
  as function (as FB_FORM ptr,button as long,x as long,y as long) as long ButtonReleaseEvent
  as function (as FB_FORM ptr,x as long,y as long) as long MouseMoveEvent
  as function (as FB_FORM ptr,x as long,y as long) as long MouseDragEvent
  as function (as FB_FORM ptr,x as long,y as long,z as long) as long MouseWheelEvent
  as function (as FB_FORM ptr,key as long) as long KeyDownEvent
  as function (as FB_FORM ptr,key as long) as long KeyUpEvent

  private: ' FLTK stuff
  declare static sub      DestructorCB cdecl(as any ptr)
  declare static function DrawCB       cdecl(as any ptr) as long
  declare static function HandleCB     cdecl(as any ptr,event as Fl_Event) as long
  declare static function ResizeCB     cdecl(as any ptr,x as long,y as long,w as long,h as long) as long
  declare sub SetCallbacks
  as Fl_Double_WindowEx ptr m_Double_WindowEx
end type
' private form tuff
destructor FB_FORM
  if m_Double_WindowEx then Fl_Double_WindowExDelete m_Double_WindowEx
end destructor
constructor FB_FORM(w as long,h as long,caption as zstring ptr)
  m_Double_WindowEx = Fl_Double_WindowExNew(w,h,caption) : SetCallbacks
end constructor
constructor FB_FORM(x as long,y as long,w as long,h as long,caption as zstring ptr)
  m_Double_WindowEx = Fl_Double_WindowExNew2(x,y,w,h,caption) : SetCallbacks
end constructor
operator FB_FORM.cast as Fl_Widget ptr
  operator = m_Double_WindowEx
end operator
operator FB_FORM.cast as Fl_Group ptr
  operator = m_Double_WindowEx
end operator
operator FB_FORM.cast as Fl_Window ptr
  operator = m_Double_WindowEx
end operator
operator FB_FORM.cast as Fl_Double_WindowEx ptr
  operator = m_Double_WindowEx
end operator
sub FB_FORM.SetCallbacks
  Fl_Double_WindowExSetDestructorCB(m_Double_WindowEx,@DestructorCB)
  Fl_Double_WindowExSetDrawCB      (m_Double_WindowEx,@DrawCB)
  Fl_Double_WindowExSetHandleCB    (m_Double_WindowEx,@HandleCB)
  Fl_Double_WindowExSetResizeCB    (m_Double_WindowEx,@ResizeCB)
  Fl_WidgetSetUserData      (m_Double_WindowEx,@This)
end sub
sub FB_FORM.DestructorCB cdecl(win as any ptr)
end sub
function FB_FORM.DrawCB cdecl(win as any ptr) as long
  dim as FB_FORM ptr me = Fl_WidgetGetUserData(win)
  if me->DrawEvent then return me->DrawEvent(me)
  return 0
end function
function FB_FORM.HandleCB cdecl(win as any ptr,event as Fl_Event) as long
  dim as FB_FORM ptr me = Fl_WidgetGetUserData(win)
  select case as const event
  case FL_EVENT_SHOW       : if me->ShowEvent          then return me->ShowEvent(me)
  case FL_EVENT_HIDE       : if me->HideEvent          then return me->HideEvent(me)
  case FL_EVENT_CLOSE      : if me->CloseEvent         then return me->CloseEvent(me)
  case FL_EVENT_FOCUS      : if me->FocusEvent         then return me->FocusEvent(me)
  case FL_EVENT_UNFOCUS    : if me->FocusEvent         then return me->UnfocusEvent(me)
  case FL_EVENT_ENTER      : if me->EnterEvent         then return me->EnterEvent(me)
  case FL_EVENT_LEAVE      : if me->LeaveEvent         then return me->LeaveEvent(me)
  case FL_EVENT_PUSH       : if me->ButtonPushEvent    then return me->ButtonPushEvent   (me,Fl_EventButton(),Fl_EventX(),Fl_EventY())
  case FL_EVENT_RELEASE    : if me->ButtonReleaseEvent then return me->ButtonReleaseEvent(me,Fl_EventButton(),Fl_EventX(),Fl_EventY())
  case FL_EVENT_MOVE       : if me->MouseMoveEvent     then return me->MouseMoveEvent(me,Fl_EventX(),Fl_EventY())
  case FL_EVENT_DRAG       : if me->MouseDragEvent     then return me->MouseDragEvent(me,Fl_EventX(),Fl_EventY())
  case FL_EVENT_MOUSEWHEEL : if me->MouseWheelEvent    then return me->MouseWheelEvent(me,Fl_EventX(),Fl_EventY(),Fl_EventDY())
  case FL_EVENT_KEYDOWN    : if me->KeyDownEvent       then return me->KeyDownEvent(me,Fl_EventKey())
  case FL_EVENT_KEYUP      : if me->KeyUpEvent         then return me->KeyUpEvent(me,Fl_EventKey())
  end select
  ' delegate all unhandled events to the base class
  dim as Fl_WindowEx ptr ex=win
  return Fl_WindowExHandleBase(ex,event)
end function

function FB_FORM.ResizeCB cdecl(win as any ptr,x as long,y as long,w as long,h as long) as long
  dim as FB_FORM ptr me = Fl_WidgetGetUserData(win)
  if me->ResizeEvent then return me->ResizeEvent(me,x,y,w,h)
  return 0
end function



'
' main
'
function ShowEventCB(frm as FB_FORM ptr) as long
  print "ShowEventCB"
  return 0
end function
function HideEventCB(frm as FB_FORM ptr) as long
  print "HideEventCB"
  return 0
end function

function FocusEventCB(frm as FB_FORM ptr) as long
  print "FocusEventCB"
  return 0
end function
function UnfocusEventCB(frm as FB_FORM ptr) as long
  print "UnfocusEventCB"
  return 0
end function

function EnterEventCB(frm as FB_FORM ptr) as long
  print "EnterEventCB"
  return 0
end function
function LeaveEventCB(frm as FB_FORM ptr) as long
  print "LeaveEventCB"
  return 0
end function

function ButtonPushEventCB(frm as FB_FORM ptr,button as long,x as long,y as long) as long
  print "ButtonPushEventCB Button(" & button & " at " & x & "," & y & ")"
  return 0
end function
function ButtonReleaseEventCB(frm as FB_FORM ptr,button as long,x as long,y as long) as long
  print "ButtonReleaseEventCB  Button(" & button & " at " & x & "," & y & ")"
  return 0
end function

function MouseMoveEventCB(frm as FB_FORM ptr,x as long,y as long) as long
  print "MouseMoveEventCB (" & x & "," & y & ")"
  return 0
end function

function MouseDragEventCB(frm as FB_FORM ptr,x as long,y as long) as long
  print "MouseMoveEventCB (" & x & "," & y & ")"
  return 0
end function

function MouseWheelEventCB(frm as FB_FORM ptr,x as long,y as long,z as long) as long
  print "MouseWheelEventCB (" & x & "," & y & "," & z & ")"
  return 0
end function

function KeyDownEventCB(frm as FB_FORM ptr,key as long) as long
  print "KeyDownEventCB Key(" & key & ")"
  return 0
end function
function KeyUpEventCB(frm as FB_FORM ptr,key as long) as long
  print "KeyUpEventCB  Key(" & key & ")"
  return 0
end function

function ResizeEventCB(frm as FB_FORM ptr,x as long,y as long,w as long,h as long) as long
  print "ResizeEventCB(" & x & "," & y & "," & w & "," & h & ")"
  return 0
end function
function DrawEventCB(frm as FB_FORM ptr) as long
  print "DrawEventCB"
  return 0
end function

var frm1 = new FB_FORM(320,200, "Form 1")
frm1->ShowEvent          = @ShowEventCB
frm1->HideEvent          = @HideEventCB
frm1->FocusEvent         = @FocusEventCB
frm1->UnfocusEvent       = @UnfocusEventCB
frm1->EnterEvent         = @EnterEventCB
frm1->LeaveEvent         = @LeaveEventCB
frm1->ButtonPushEvent    = @ButtonPushEventCB
frm1->ButtonReleaseEvent = @ButtonReleaseEventCB
frm1->MouseMoveEvent     = @MouseMoveEventCB
frm1->MouseDragEvent     = @MouseDragEventCB
frm1->MouseWheelEvent    = @MouseWheelEventCB
frm1->KeyDownEvent       = @KeyDownEventCB
frm1->KeyUpEvent         = @KeyUpEventCB
frm1->ResizeEvent        = @ResizeEventCB
frm1->DrawEvent          = @DrawEventCB

Fl_WindowShow *frm1
Fl_Run
