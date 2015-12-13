#include once "fltk-tools.bi" ' for EventAsString etc.

'#define _DEBUG

#ifdef _DEBUG
#define DPRINT(_msg_) open err for output as #1 : print #1,_msg_ : close #1 :
#else
#define DPRINT(_msg_) :
#endif

#define BORDER 3
#define EXTRASPACE 3
#define SELECTION_BORDER 3
#define TAB_LEFT 0
#define TAB_RIGHT 1
#define TAB_SELECTED 2

type Fl_TabsClone extends Fl_GroupEx
  public:
  declare constructor(byval x as long, _
                      byval y as long, _
                      byval w as long, _
                      byval h as long, _
                      byval label as zstring ptr=0)
  declare operator cast as Fl_GroupEx ptr
  declare operator cast as Fl_Group  ptr
  declare operator cast as Fl_Widget ptr
  declare sub      ClearTabPositions
  declare function TabPositions as long 
  declare function TabHeight as long 

  declare function GetValue as Fl_Widget ptr
  declare function SetValue(byval wgt as Fl_Widget ptr) as long
  declare function GetPush as const Fl_Widget ptr
  declare function SetPush(byval wgt as Fl_Widget ptr) as long
  declare function Which(byval event_x as long, byval event_y as long) as Fl_Widget ptr
  declare sub      ClientArea(byref rx as long, _
                              byref ry as long, _
                              byref rw as long, _
                              byref rh as long, _
                              byval tabh as long=0)

  
  declare sub      DrawTab(byval x1 as long, _
                           byval x2 as long, _
                           byval w  as long, _
                           byval h  as long, _ 
                           byval wgt as Fl_Widget ptr, _
                           byval sel as long=0)
  declare sub      TriggerRedrawTabs
  declare static function DrawCB cdecl (byval me as any ptr) as long
  declare static function HandleCB cdecl (byval me as any ptr, _
                                          byval event as FL_EVENT) as long
  as Fl_Widget  ptr value_
  as Fl_Widget  ptr push_
  as long    ptr tab_pos
  as long    ptr tab_width
  as long        tab_count
  as long       first,last
  as Fl_Group  ptr Buttons
  as Fl_Button ptr ButtonLeft
  as Fl_Button ptr ButtonRight
  private:
  as Fl_GroupEx ptr self
end type
dim shared as Fl_TabsClone ptr gFl_TabsClone
operator Fl_TabsClone.cast as Fl_GroupEx ptr : operator = self : end operator
operator Fl_TabsClone.cast as Fl_Group   ptr : operator = self : end operator
operator Fl_TabsClone.cast as Fl_Widget  ptr : operator = self : end operator

constructor Fl_TabsClone(byval x as long, _
                     byval y as long, _
                     byval w as long, _
                     byval h as long, _
                     byval label as zstring ptr)
  Buttons = Fl_GroupNew(0,0,32,16)
  Fl_GroupBegin Buttons
    ButtonLeft  = Fl_ButtonNew( 0,0,16,16,"<")
    ButtonRight = Fl_ButtonNew(16,0,16,16,">")
  Fl_GroupEnd Buttons
  Fl_WidgetHide Buttons

  self = Fl_GroupExNew(x,y,w,h,label)
  Fl_WidgetSetUserData  self,@this
  Fl_WidgetSetBox       self,BoxType(FL_THIN_UP_BOX)
  Fl_GroupExSetDrawCB   self,@Fl_TabsClone.DrawCB
  Fl_GroupExSetHandleCB self,@Fl_TabsClone.HandleCB
  
end constructor

sub Fl_TabsClone.ClearTabPositions
  DPRINT("  Fl_TabsClone.ClearTabPositions")
  if tab_pos   then deallocate tab_pos  : tab_pos   = 0
  if tab_width then deallocate tab_width: tab_width = 0
end sub

function Fl_TabsClone.TabPositions as long 
  DPRINT("Fl_TabsClone.TabPositions")
  dim as long nc = Fl_GroupChildren(self)
  if (nc <> tab_count) then
    'DPRINT("  (nc <> tab_count)")
    ClearTabPositions()
    if (nc) then
      tab_pos   = callocate((nc+1)*sizeof(long))
      tab_width = callocate((nc+1)*sizeof(long))
    end if
    tab_count = nc
  end if
  if (nc=0) then 
    DPRINT("  no tabs")
    return 0
  end if
  
  dim as long selected = 0
  dim as Fl_Widget ptr ptr a = Fl_GroupArray(self)
  dim as ubyte prev_draw_shortcut = Fl_GetDrawShortcutFlag()

  Fl_SetDrawShortcutFlag(1)
    dim as long i
    tab_pos[0] = Fl_BoxDX(Fl_WidgetGetBox(self))
    for i=0 to nc-1
      dim as Fl_Widget ptr o = *a : a+=1
      if (Fl_WidgetVisible(o)) then selected = i
      dim as long wt = 0
      dim as long ht = 0
      Fl_WidgetMeasureLabel o,wt,ht
      tab_width[i] = wt + EXTRASPACE
      tab_pos[i+1] = tab_pos[i] + tab_width[i] + BORDER
    next
  Fl_SetDrawShortcutFlag(prev_draw_shortcut)


  dim as long r = Fl_WidgetGetW(self)
  if (tab_pos[i] <= r) then
    dprint("  all visible")
    return selected
  end if

  ' they are too big pack them against right edge:
  tab_pos[i] = r
  i=nc
  while i
    i-=1
    dim as long l = r-tab_width[i]
    if (tab_pos[i+1] < l) then l = tab_pos[i+1]
    if (tab_pos[i] <= l) then exit while
    tab_pos[i] = l
    r -= EXTRASPACE
  wend
  
  for i = 0 to nc-1
    if (tab_pos[i] >= i*EXTRASPACE) then exit for
    tab_pos[i] = i*EXTRASPACE
    dim as long W = Fl_WidgetGetW(self)- 1 - EXTRASPACE*(nc-i) - tab_pos[i]
    if (tab_width[i] > W) then tab_width[i] = W
  next
  i = nc
  while i > selected
    tab_pos[i] = tab_pos[i-1] + tab_width[i-1]
    i-=1
  wend 
  return selected
end function

function Fl_TabsClone.TabHeight as long 
  'DPRINT("Fl_TabsClone.TabHeight")
  if (Fl_GroupChildren(self)=0) then return Fl_WidgetGetH(self)
  dim as long H  = Fl_WidgetGetH(self)
  dim as long H2 = Fl_WidgetGetY(self)
  dim as Fl_Widget ptr ptr a = Fl_GroupArray(self)
  dim as long i=Fl_GroupChildren(self)
  while i>0
    dim as Fl_Widget ptr o = *a : a+=1
    if (Fl_WidgetGetY(o) < Fl_WidgetGetY(self)+H) then H  = Fl_WidgetGetY(o)-Fl_WidgetGetY(self)
    if (Fl_WidgetGetY(o) + Fl_WidgetGetH(o) > H2) then H2 = Fl_WidgetGetY(o)+Fl_WidgetGetH(o)
    i-=1
  wend
  H2 = Fl_WidgetGetY(self)+Fl_WidgetGetH(self)-H2
  if (H2 > H) then
    return iif(H2 <= 0,0,-H2)
  else
    return iif(H  <= 0,0,  H)
  end if
end function

function Fl_TabsClone.GetValue as Fl_Widget ptr
  'DPRINT("Fl_TabsClone.GetValue")
  dim as Fl_Widget ptr v = 0
  dim as Fl_Widget ptr ptr a = Fl_GroupArray(self)
  dim as long i=Fl_GroupChildren(self)
  while i>0
    i-=1
    dim as Fl_Widget ptr o = *a : a+=1
    if (v) then
      Fl_WidgetHide(o)
    elseif (Fl_WidgetVisible(o)) then
      v = o
    elseif (i=0) then
      Fl_WidgetShow(o)
      v = o
    end if
  wend
  return v
end function

function Fl_TabsClone.SetValue(byval newvalue as Fl_Widget ptr) as long
  'DPRINT("Fl_TabsClone.SetValue")
  dim as Fl_Widget ptr ptr a = Fl_GroupArray(self)
  dim as long ret = 0
  dim as long i=Fl_GroupChildren(self)
  while i>0
    i-=1
    dim as Fl_Widget ptr o = *a : a+=1
    if (o = newvalue) then
      if (Fl_WidgetVisible(o)=0) then ret = 1
      Fl_WidgetShow(o)
    else
      Fl_WidgetHide(o)
    end if
  wend
  return ret
end function

function Fl_TabsClone.GetPush as const Fl_Widget ptr
  'DPRINT("Fl_TabsClone.GetPush")
  return push_
end function

function Fl_TabsClone.SetPush(byval o as Fl_Widget ptr) as long
  'DPRINT("Fl_TabsClone.SetPush")
  if (push_ = o) then return 0
  if ( (push_<>0 andalso Fl_WidgetVisible(push_)=0) or (o<>0 andalso Fl_WidgetVisible(o)=0) ) then TriggerRedrawTabs()
  push_ = o
  return 1
end function

function Fl_TabsClone.Which(byval event_x as long, byval event_y as long) as Fl_Widget ptr
  'DPRINT("Fl_TabsClone.Which")
  dim as long nc = Fl_GroupChildren(self)
  if nc=0 then return 0
  dim as long H = TabHeight()
  if (H < 0) then
    if (event_y > Fl_WidgetGetY(self)+Fl_WidgetGetH(self) or event_y < Fl_WidgetGetY(self)+Fl_WidgetGetH(self)+H) then return 0
  else
    if (event_y > Fl_WidgetGetY(self)+H or event_y < Fl_WidgetGetY(self)) then return 0
  end if

  if (event_x < Fl_WidgetGetX(self)) then return 0

  dim as Fl_Widget ptr ret = 0
  TabPositions()
  for i as long=0 to nc-1
    if (event_x < Fl_WidgetGetX(self)+tab_pos[i+1]) then
      ret = Fl_GroupChild(self,i)
      exit for
    end if
  next
  return ret
end function

sub Fl_TabsClone.ClientArea(byref rx as long, _
                        byref ry as long, _
                        byref rw as long, _
                        byref rh as long, _
                        byval tabh as long)
  'DPRINT("Fl_TabsClone.ClientArea")
  if Fl_GroupChildren(self)>0 then
    var child = Fl_GroupChild(self,0)
    rx = Fl_WidgetGetX(child)
    ry = Fl_WidgetGetY(child)
    rw = Fl_WidgetGetW(child)
    rh = Fl_WidgetGetH(child)
  else
    dim as long y_offset
    dim as long label_height = DrawHeight(Fl_WidgetGetLabelFont(self), Fl_WidgetGetLabelSize(self)) + BORDER*2

    if (tabh = 0) then
      y_offset = label_height
    elseif (tabh = -1) then
      y_offset = -label_height
    else
      y_offset = tabh
    end if
    rx = Fl_WidgetGetX(self)
    rw = Fl_WidgetGetW(self)

    if (y_offset >= 0) then
      ry = Fl_WidgetGetY(self) + y_offset
      rh = Fl_WidgetGetH(self) - y_offset
    else
      ry = Fl_WidgetGetY(self)
      rh = Fl_WidgetGetH(self) + y_offset
    end if
  end if
end sub

function Fl_TabsClone.HandleCB cdecl (byval me as any ptr, _
                                  byval event as FL_EVENT) as long
  DPRINT("Fl_TabsClone.HandleCB " & EventAsString(event))
  dim as Fl_TabsClone ptr pThis = Fl_WidgetGetUserData(me)
  dim as Fl_Widget ptr o
  dim as long i

  select case as const event
  case FL_EVENT_PUSH, FL_EVENT_DRAG, FL_EVENT_RELEASE
    'DPRINT("  case FL_EVENT_PUSH,FL_EVENT_DRAG, FL_EVENT_RELEASE")
    if (event = FL_EVENT_PUSH) then
      'DPRINT("  FL_EVENT_PUSH")
      dim as long H = pThis->TabHeight()
      if (H >= 0) then
        if (Fl_EventY() > Fl_WidgetGetY(me)+H) then return Fl_GroupExHandleBase(me,event)
      else
        if (Fl_EventY() < Fl_WidgetGetY(me)+Fl_WidgetGetH(me)+H) then return Fl_GroupExHandleBase(me,event)
      end if
    end if

    o = pThis->which(Fl_EventX(), Fl_EventY())
    if (event = FL_EVENT_RELEASE) then
      'DPRINT("  FL_EVENT_RELEASE")
      pThis->SetPush(0)
      if (o<>0 andalso Fl_GetVisibleFocus()<>0 andalso Fl_GetFocus()<>me) then
        Fl_SetFocus(me)
        pThis->TriggerRedrawTabs()
      end if
      if (o<>0) andalso (pThis->SetValue(o)<>0) then
        dim as Fl_Widget_Tracker ptr wp = Fl_Widget_TrackerNew(o)
        Fl_WidgetSetChanged(me)
        Fl_WidgetDoCallback(me)
        if Fl_Widget_TrackerDeleted(wp) then return 1
      end if
      Fl_TooltipSetCurrentWidget(o)
    else
      'DPRINT("  FL_EVENT_DRAG")
      pThis->SetPush(o)
    end if
    return 1

  case FL_EVENT_MOVE
    'DPRINT("  case FL_EVENT_MOVE")
    dim as long ret = Fl_GroupExHandleBase(me,event)
    dim as Fl_Widget ptr o = Fl_TooltipGetCurrentWidget()
    dim as Fl_Widget ptr n = o
    dim as long H = pThis->TabHeight()
    if ( (H>=0) andalso (Fl_EventY()>Fl_WidgetGetY(me)+H) ) then 
      return ret
    elseif ( (H<0) andalso (Fl_EventY() < Fl_WidgetGetY(me)+Fl_WidgetGetH(me)+H) ) then
      return ret
    else
     'DPRINT("  case FL_EVENT_MOVE pThis->Which(Fl_EventX(), Fl_EventY())")
      n = pThis->Which(Fl_EventX(), Fl_EventY())
      if (n=0) then n = me ' this !!!
    end if
    if (n<>o) then 
      'DPRINT("  Fl_TooltipEnter(n)")
      Fl_TooltipEnter(n)
    end if
    return ret

  case FL_EVENT_FOCUS,FL_EVENT_UNFOCUS
    'DPRINT("  case FL_EVENT_FOCUS,FL_EVENT_UNFOCUS ")
    if (Fl_GetVisibleFocus()=0) then
      return Fl_GroupExHandleBase(me,event)
    end if 
    if ((Fl_EventNumber() = FL_EVENT_RELEASE)  or _
        (Fl_EventNumber() = FL_EVENT_SHORTCUT) or _
        (Fl_EventNumber() = FL_EVENT_KEYBOARD) or _
        (Fl_EventNumber() = FL_EVENT_FOCUS)    or _
        (Fl_EventNumber() = FL_EVENT_UNFOCUS)) then
      ' trigger DrawCB 
      pThis->TriggerRedrawTabs()
      if (Fl_EventNumber() = FL_EVENT_FOCUS) then
        dim as long ret = Fl_GroupExHandleBase(me,event)
        'DPRINT("  Fl_EventNumber() = FL_EVENT_FOCUS return " & ret)
        return ret
        
      end if

      if (Fl_EventNumber() = FL_EVENT_UNFOCUS) then
        'DPRINT("  Fl_EventNumber() = FL_EVENT_UNFOCUS return 0")
        return 0
      else
        'DPRINT("  Fl_EventNumber() <> NO FL_EVENT_FOCUS,FL_EVENT_UNFOCUS return 1")
        return 1
      end if
    else
      'DPRINT("  Fl_EventNumber() don't match !!!")
      return Fl_GroupExHandleBase(me,event)
    end if

  case FL_EVENT_KEYBOARD
    dim as long k=Fl_EventKey() 
    select case as const k
    case FL_Left
      'DPRINT("  case FL_EVENT_KEYBOARD FL_Left")
      if Fl_WidgetVisible(Fl_GroupChild(me,0)) then return 0
      
      for i = 1 to Fl_GroupChildren(me)-1
        if Fl_WidgetVisible(Fl_GroupChild(me,i)) then exit for
      next
      pThis->SetValue(Fl_GroupChild(me,i - 1))
      Fl_WidgetSetChanged(me)
      Fl_WidgetDoCallback(me)
      return 1
    case FL_Right
      'DPRINT("  case FL_EVENT_KEYBOARD FL_Right")
      if Fl_WidgetVisible(Fl_GroupChild(me,Fl_GroupChildren(me)-1)) then return 0
      for i = 0 to Fl_GroupChildren(me)-1
        if Fl_WidgetVisible(Fl_GroupChild(me,i)) then exit for
      next
      pThis->SetValue(Fl_GroupChild(me,i + 1))
      Fl_WidgetSetChanged(me)
      Fl_WidgetDoCallback(me)
      return 1
    case FL_Down
      'DPRINT("  case FL_EVENT_KEYBOARD FL_Down")
      Fl_WidgetRedraw(me)
      return Fl_GroupExHandleBase(me,FL_EVENT_FOCUS)
    end select
    'DPRINT("  case FL_EVENT_KEYBOARD unhandled key = " & k)
    return Fl_GroupExHandleBase(me,event)

  case FL_EVENT_SHORTCUT
    'DPRINT("  FL_EVENT_SHORTCUT")
    for i = 0 to Fl_GroupChildren(me)-1
      dim as Fl_Widget ptr c = Fl_GroupChild(me,i)
      ' !!! static/widget or FL:: !!!
      ' if (c->test_shortcut(c->label())) then
      if Fl_WidgetTestShortcut2(Fl_WidgetGetLabel(c)) then
        dim as ubyte sc = Fl_WidgetVisible(c)
        pThis->SetValue(c)
        if (sc=0) then Fl_WidgetSetChanged(me)
        Fl_WidgetDoCallback(me)
        return 1
      end if
    next
    return Fl_GroupExHandleBase(me,event)
  case FL_EVENT_SHOW
    pThis->GetValue()
    return Fl_GroupExHandleBase(me,event)
  case else
    DPRINT("  Event not handled")
    return Fl_GroupExHandleBase(me,event)
  end select
end function

sub Fl_TabsClone.DrawTab(byval x1 as long, _
                     byval x2 as long, _
                     byval w  as long, _
                     byval h  as long, _ 
                     byval o  as Fl_Widget ptr, _
                     byval what as long)
  #ifdef _DEBUG
  select case as const what
  case TAB_LEFT     : DPRINT("DrawTab(" & x1 & ", " & x2 & ", " & w & ", " & h & ", LEFT")
  case TAB_RIGHT    : DPRINT("DrawTab(" & x1 & ", " & x2 & ", " & w & ", " & h & ", RIGHT")
  case TAB_SELECTED : DPRINT("DrawTab(" & x1 & ", " & x2 & ", " & w & ", " & h & ", SELECTED")
  end select 
  #endif

  dim as long sel = (what = TAB_SELECTED)
  dim as long  dh = Fl_BoxDH(Fl_WidgetGetBox(self))
  dim as long  dy = Fl_BoxDY(Fl_WidgetGetBox(self))
  dim as ubyte prev_draw_shortcut = Fl_GetDrawShortcutFlag()
  Fl_SetDrawShortcutFlag 1

  dim as Fl_Boxtype bt = iif(o=push_ andalso sel=0,fldown(Fl_WidgetGetBox(self)) , Fl_WidgetGetBox(self))
  dim as long yofs = iif(sel,0,BORDER)

  if ((x2 < x1+W) andalso what=TAB_RIGHT) then x1 = x2 - W

  if (H >= 0) then
    if (sel) then
      DrawPushClip(x1, Fl_WidgetGetY(self), x2 - x1, H + dh - dy)
    else
      DrawPushClip(x1, Fl_WidgetGetY(self), x2 - x1, H)
    end if
    H += dh

    dim as Fl_Color c = iif(sel,Fl_WidgetGetSelectionColor(self),Fl_WidgetGetSelectionColor(o))
    DrawBox(bt, x1, Fl_WidgetGetY(self) + yofs, W, H + 10 - yofs, c)
    dim as Fl_Color oc = Fl_WidgetGetLabelColor(o)
    
    Fl_WidgetSetLabelColor(o,iif(sel, Fl_WidgetGetLabelColor(self),Fl_WidgetGetLabelColor(o)))
    Fl_WidgetDrawLabel(o,x1, Fl_WidgetGetY(self) + yofs, W, H - yofs, FL_ALIGN_CENTER)
    Fl_WidgetSetLabelColor(o,oc)

    if (Fl_GetFocus() = self andalso Fl_WidgetVisible(o)) then
      Fl_WidgetDrawFocus(self,Fl_WidgetGetBox(self), x1, Fl_WidgetGetY(self), W, H)
    end if

    DrawPopClip()
  
  else
    H = -H
    if (sel) then
      DrawPushClip(x1, Fl_WidgetGetY(self) + Fl_WidgetGetH(self) - H - dy, x2 - x1, H + dy)
    else
      DrawPushClip(x1, Fl_WidgetGetY(self) + Fl_WidgetGetH(self) - H, x2 - x1, H)
    end if

    H += dh
    dim as Fl_Color c = iif(sel,Fl_WidgetGetSelectionColor(self),Fl_WidgetGetSelectionColor(o))
    DrawBox(bt, x1, Fl_WidgetGetY(self) + Fl_WidgetGetH(self) - H - 10, W, H + 10 - yofs, c)
    dim as Fl_Color oc = Fl_WidgetGetLabelColor(o)
    Fl_WidgetSetLabelColor(o,iif(sel,Fl_WidgetGetLabelColor(self),Fl_WidgetGetLabelColor(o)))
    Fl_WidgetDrawLabel(o,x1,Fl_WidgetGetY(self) + Fl_WidgetGetH(self) - H, W, H - yofs, FL_ALIGN_CENTER)
    Fl_WidgetSetLabelColor(o,oc)
    if (Fl_GetFocus() = self) andalso (Fl_WidgetVisible(o)<>0) then
      Fl_WidgetDrawFocus(self,Fl_WidgetGetBox(self), x1, Fl_WidgetGetY(self)+Fl_WidgetGetH(self)-H, W, H)
    end if
    DrawPopClip()
  end if
  Fl_SetDrawShortcutFlag prev_draw_shortcut
end sub

sub Fl_TabsClone.TriggerRedrawTabs
  dim as long H = TabHeight()
  if (H >= 0) then
    DPRINT("Fl_TabsClone.TriggerRedrawTabs all")
    H += Fl_BoxDY(Fl_WidgetGetBox(self))
    Fl_WidgetSetDamage2(self,FL_DAMAGE_SCROLL, Fl_WidgetGetX(self), Fl_WidgetGetY(self)                          , Fl_WidgetGetW(self), H)
  else
    DPRINT("Fl_TabsClone.TriggerRedrawTabs")
    H = Fl_BoxDY(Fl_WidgetGetBox(self)) - H
    Fl_WidgetSetDamage2(self,FL_DAMAGE_SCROLL, Fl_WidgetGetX(self), Fl_WidgetGetY(self) + Fl_WidgetGetH(self) - H, Fl_WidgetGetW(self), H)
  end if
end sub

function Fl_TabsClone.DrawCB cdecl (byval me as any ptr) as long
  dim as Fl_TabsClone ptr pThis = Fl_WidgetGetUserData(me) 
  dim as Fl_Widget ptr v = pThis->GetValue()
  dim as long H = pThis->TabHeight()
  DPRINT("Fl_TabsClone.DrawCB")
  if (Fl_WidgetGetDamage(me) and FL_DAMAGE_ALL) then 
    DPRINT("  redraw the entire thing")
    dim as Fl_Color c = iif(v<>0, Fl_WidgetGetColor(v),Fl_WidgetGetColor(me))
    ' draw the box below the tabs buttons
    DrawBox(Fl_WidgetGetBox(me), Fl_WidgetGetX(me), Fl_WidgetGetY(me)+iif(H>=0,H,0), Fl_WidgetGetW(me), Fl_WidgetGetH(me)-iif(H >= 0,H,-H), c)
    
    if (Fl_WidgetGetSelectionColor(me) <> c) then
      ' Draw the line between tab buttons and the tab in selection color
      dim as long clip_y = iif(H >= 0, Fl_WidgetGetY(me) + H, Fl_WidgetGetY(me) + Fl_WidgetGetH(me) + H - SELECTION_BORDER)
      DrawPushClip(Fl_WidgetGetX(me), clip_y, Fl_WidgetGetW(me), SELECTION_BORDER)
        DrawBox(Fl_WidgetGetBox(me), Fl_WidgetGetX(me), clip_y, Fl_WidgetGetW(me), SELECTION_BORDER,Fl_WidgetGetSelectionColor(me))
      DrawPopClip()
    end if
    ' draw the tab group
    if (v) then Fl_Group_DrawChild(v)
  else 
    ' redraw the tab group (if needed)
    if (v) then Fl_Group_UpdateChild(v)
  end if

  ' draw the tabs label
  if (Fl_WidgetGetDamage(me) and (FL_DAMAGE_SCROLL or FL_DAMAGE_ALL)) then
    dim as long nc = Fl_GroupChildren(me)
    dim as long selected = pThis->TabPositions()
    dim as long i
    dim as Fl_Widget ptr ptr a = Fl_GroupArray(me)

    for i=0 to selected-1
      pThis->DrawTab(Fl_WidgetGetX(me)+pThis->tab_pos[i], Fl_WidgetGetX(me)+pThis->tab_pos[i+1],pThis->tab_width[i], H, a[i], TAB_LEFT)
    next
    i=nc-1
    while i > selected
     pThis->DrawTab(Fl_WidgetGetX(me)+pThis->tab_pos[i], Fl_WidgetGetX(me)+pThis->tab_pos[i+1],pThis->tab_width[i], H, a[i], TAB_RIGHT)
     i-=1
    wend
    if (v) then
      i = selected
      pThis->DrawTab(Fl_WidgetGetX(me)+pThis->tab_pos[i], Fl_WidgetGetX(me)+pThis->tab_pos[i+1],pThis->tab_width[i], H, a[i], TAB_SELECTED)
    end if
    
  end if

  return 1
end function


function Fl_TabsCloneNew(byval x as long, _
                         byval y as long, _
                         byval w as long, _
                         byval h as long, _
                         byval label as zstring ptr=0) as Fl_TabsClone ptr
  DPRINT("Fl_TabsCloneNew(" & x & "," & y & "," & w & "," & h & "," & iif(label,*label,"") & ")")
  gFl_TabsClone = new Fl_TabsClone(x,y,w,h,label)
  return gFl_TabsClone
end function

function Fl_TabsCloneGetValue(byval tabs as Fl_TabsClone ptr) as Fl_Widget ptr
  return tabs->GetValue()
end function

'
' main
'
sub TabCB cdecl (self as FL_WIDGET ptr,tabs as any ptr)
  DPRINT("TabCB: " & *Fl_WidgetGetLabel(Fl_TabsCloneGetValue(tabs)))
end sub

var win = Fl_WindowNew(500,200,"TabsClone.bas")  
  var tabs = Fl_TabsCloneNew(10,10,500-20,200-20)
  Fl_WidgetSetCallbackArg *tabs,@TabCB,tabs
  Fl_WidgetSetSelectionColor *tabs,FL_RED
    for i as long = 1 to 10
      var t = Fl_TabNew(10,35,500-20,200-45)
      Fl_TabBegin t
        var label = "file" & str(i) & ".bas"
        Fl_WidgetCopyLabel t,label
        var b = fl_ButtonNew(20,50,64,24)
        Fl_WidgetCopyLabel b,label

      Fl_TabEnd t
    next
  Fl_TabsEnd *tabs
Fl_WindowEnd win
Fl_GroupSetResizable win,tabs
Fl_WindowShow win
Fl_Run


