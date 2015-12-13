#include once "fltk-tools.bi"

'test 2 of a user defined widget


type CheckBox
  enum CheckBoxStates
    CheckBox_off           = (1 shl 0)
    CheckBox_over          = (1 shl 1)
    CheckBox_down          = (1 shl 2)
    CheckBox_up            = (1 shl 3)
    CheckBox_selected_off  = (1 shl 4) or CheckBox_off
    CheckBox_selected_over = (1 shl 4) or CheckBox_over
    CheckBox_selected_down = (1 shl 4) or CheckBox_down
    CheckBox_selected_up   = (1 shl 4) or CheckBox_up
  end enum

  declare constructor (byval x as long, _
                       byval y as long, _
                       byval w as long=14, _
                       byval h as long=14, _
                       byval label as zstring ptr=0)
  declare operator cast as Fl_Widget ptr
  declare sub      Update
  declare property State as CheckBoxStates
  declare property State(byval newState as CheckBoxStates)
  declare static function DrawCB   cdecl (byval me as any ptr) as long
  declare static function ResizeCB cdecl (byval me as any ptr, _
                                          byval x as long, _
                                          byval y as long, _
                                          byval w as long, _
                                          byval h as long) as long
  declare static function HandleCB cdecl (byval me as any ptr, _
                                          byval event as FL_EVENT) as long
  as Fl_WidgetEx ptr m_Widget
  as CheckBoxStates  m_State
  as string          m_Label
  as long         m_Active
  as long         m_Selected
  as long         m_Over
  as long         m_Down
end type

' create a new CheckBox widget and set callback's
constructor CheckBox(byval x as long, _
                     byval y as long, _
                     byval w as long, _
                     byval h as long, _
                     byval label as zstring ptr)
  m_Widget = Fl_WidgetExNew(x,y,w,h,label)
  Fl_WidgetSetLabelColor m_Widget,FL_WHITE
  'Fl_WidgetSetLabel(m_Widget,label)
  'if label then m_Label=*label
  Fl_WidgetSetUserData    m_Widget,@This
  Fl_WidgetExSetDrawCB    m_Widget,@DrawCB
  Fl_WidgetExSetHandleCB  m_Widget,@HandleCB
  m_Active=1
  m_Selected=0
  m_Over=0
  m_Down=0
  state = CheckBox_off
end constructor

operator CheckBox.cast as Fl_Widget ptr
  'print "class CheckBox as Fl_Widget ptr"
  operator = m_Widget
end operator

' get
property CheckBox.State as CheckBoxStates
  property = m_State
end property
' set
property CheckBox.State(byval newState as CheckBoxStates) 
  ' a cjhange in state needs an redraw
  var RedrawFlag = (newState <> m_State)
  m_State = newState
  'if RedrawFlag then Fl_WidgetRedraw m_Widget
  Fl_WidgetRedraw m_Widget
end property

sub CheckBox.Update
  if m_Active then
    if m_Down then
      if m_Selected then
        state = CheckBox_selected_down
      else
        state = CheckBox_down
      end if
    elseif m_Over then
      if m_Selected then
        state = CheckBox_selected_over
      else
        state = CheckBox_over
      end if
    else
      if m_Selected then
        state = CheckBox_selected_up
      else
        state = CheckBox_up
      end if
    end if
  else
    if m_Selected then
      state = CheckBox_selected_off
    else
      state = CheckBox_off
    end if
  end if
end sub

function CheckBox.DrawCB cdecl (byval me as any ptr) as long
  ' get current dimension
  var x = Fl_WidgetGetX(me)
  var y = Fl_WidgetGetY(me)
  var w = Fl_WidgetGetW(me)
  var h = Fl_WidgetGetH(me)

  ' get CheckBox class from widget
  dim as CheckBox ptr pThis = Fl_WidgetGetUserData(me)
  
  ' if any label draw it
  var label = Fl_WidgetGetLabel(pThis->m_Widget)
  if label then
    ' todo: set clipping region before
    DrawSetColor Fl_WidgetGetLabelColor(me)
    ' current drawing font same as label font and size ?
'    if DrawGetFont()     <> Fl_WidgetGetLabelFont(me) or _
'       DrawGetFontSize() <> Fl_WidgetGetLabelSize(me) then
      DrawSetFont(Fl_WidgetGetLabelFont(me),Fl_WidgetGetLabelSize(me))
'    end if
    DrawStrBox label,x+18,y,w,h,Fl_WidgetGetAlign(me)
  end if

  ' draw the CheckBox image
  dim as Fl_Image ptr img
  select case pThis->State
  case CheckBox_off           : img = Fl_Shared_ImageGet("themes/default/CheckBox_off_14x14.png")
  case CheckBox_over          : img = Fl_Shared_ImageGet("themes/default/CheckBox_over_14x14.png")
  case CheckBox_down          : img = Fl_Shared_ImageGet("themes/default/CheckBox_down_14x14.png")
  case CheckBox_up            : img = Fl_Shared_ImageGet("themes/default/CheckBox_up_14x14.png")
  case CheckBox_selected_off  : img = Fl_Shared_ImageGet("themes/default/CheckBox_selected_off_14x14.png")
  case CheckBox_selected_over : img = Fl_Shared_ImageGet("themes/default/CheckBox_selected_over_14x14.png")
  case CheckBox_selected_down : img = Fl_Shared_ImageGet("themes/default/CheckBox_selected_down_14x14.png")
  case CheckBox_selected_up   : img = Fl_Shared_ImageGet("themes/default/CheckBox_selected_up_14x14.png")
  end select
  if img then
    y += h/2-Fl_ImageH(img)/2
    DrawImage Fl_ImageData(img)[0], _
              x, _
              y, _
              Fl_ImageW(img), _ ' width
              Fl_ImageH(img), _ ' height
              Fl_ImageD(img), _ ' depth
              Fl_ImageLD(img)   ' pitch
  end if
  return 0
end function

function CheckBox.HandleCB cdecl (byval me as any ptr,byval event as FL_EVENT) as long
  ' get our class from widget
  dim as CheckBox ptr pThis = Fl_WidgetGetUserData(me)
  ' nothing to do. tell FLTK handle the event for us
  if pThis->m_Active=0 then return 0 

  select case as const event
  case FL_EVENT_PUSH ' button down
    pThis->m_Down=1
    pThis->m_Selected=1-pThis->m_Selected
  case FL_EVENT_RELEASE  ' button up
    pThis->m_Down=0
  case FL_EVENT_ENTER  ' mouse enter
    pThis->m_Over=1
  case FL_EVENT_LEAVE ' mouse leave
    pThis->m_Down=0
    pThis->m_Over=0
  case else ' delegat all other events to the base class
    return Fl_WidgetExHandleBase(pThis->m_Widget,event)
  end select
  ' we need update our widget with new state
  pThis->Update
  return 1 ' tel FLZK we handled the event
end function

'
' main
'
Fl_Register_Images() ' enable all image decoders
Fl_Background(112,121,134)
var win = Fl_WindowNew(240,20+3*24,"Fl_WidgetEx02")

var chk1 = new CheckBox(10,10+0*24,200,24,"align left")
Fl_WidgetSetAlign *chk1,Fl_ALIGN_LEFT or Fl_ALIGN_INSIDE

var chk2 = new CheckBox(10,10+1*24,200,24,"align center ")
Fl_WidgetSetAlign *chk2,Fl_ALIGN_CENTER or Fl_ALIGN_INSIDE

var chk3 = new CheckBox(10,10+2*24,200,24,"align right")
Fl_WidgetSetAlign *chk3,Fl_ALIGN_RIGHT or Fl_ALIGN_INSIDE

Fl_WindowShow win
Fl_Run

