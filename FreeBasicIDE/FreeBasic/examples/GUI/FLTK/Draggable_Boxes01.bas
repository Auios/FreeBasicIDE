#include once "fltk-c.bi"

dim as zstring ptr cat_xpm(...) => { _
@"50 34 4 1", _
@"  c #000000", _
@"o c #ff8800", _
@"@ c #ffffff", _
@"# c none", _
@"##################################################", _
@"###      ##############################       ####", _
@"### ooooo  ###########################  ooooo ####", _
@"### oo  oo  #########################  oo  oo ####", _
@"### oo   oo  #######################  oo   oo ####", _
@"### oo    oo  #####################  oo    oo ####", _
@"### oo     oo  ###################  oo     oo ####", _
@"### oo      oo                     oo      oo ####", _
@"### oo       oo  ooooooooooooooo  oo       oo ####", _
@"### oo        ooooooooooooooooooooo        oo ####", _
@"### oo     ooooooooooooooooooooooooooo    ooo ####", _
@"#### oo   ooooooo ooooooooooooo ooooooo   oo #####", _
@"####  oo oooooooo ooooooooooooo oooooooo oo  #####", _
@"##### oo oooooooo ooooooooooooo oooooooo oo ######", _
@"#####  o ooooooooooooooooooooooooooooooo o  ######", _
@"###### ooooooooooooooooooooooooooooooooooo #######", _
@"##### ooooooooo     ooooooooo     ooooooooo ######", _
@"##### oooooooo  @@@  ooooooo  @@@  oooooooo ######", _
@"##### oooooooo @@@@@ ooooooo @@@@@ oooooooo ######", _
@"##### oooooooo @@@@@ ooooooo @@@@@ oooooooo ######", _
@"##### oooooooo  @@@  ooooooo  @@@  oooooooo ######", _
@"##### ooooooooo     ooooooooo     ooooooooo ######", _
@"###### oooooooooooooo       oooooooooooooo #######", _
@"###### oooooooo@@@@@@@     @@@@@@@oooooooo #######", _
@"###### ooooooo@@@@@@@@@   @@@@@@@@@ooooooo #######", _
@"####### ooooo@@@@@@@@@@@ @@@@@@@@@@@ooooo ########", _
@"######### oo@@@@@@@@@@@@ @@@@@@@@@@@@oo ##########", _
@"########## o@@@@@@ @@@@@ @@@@@ @@@@@@o ###########", _
@"########### @@@@@@@     @     @@@@@@@ ############", _
@"############  @@@@@@@@@@@@@@@@@@@@@  #############", _
@"##############  @@@@@@@@@@@@@@@@@  ###############", _
@"################    @@@@@@@@@    #################", _
@"####################         #####################", _
@"##################################################"}

function HandleCB cdecl (byval self as any ptr,byval event as Fl_Event) as long
  static as integer xStart,yStart
  select case as const event
  case FL_EVENT_PUSH
    ' save where dragging begins
    xStart = Fl_WidgetGetX(self)-Fl_EventX() 
    yStart = Fl_WidgetGetY(self)-Fl_EventY()
  case FL_EVENT_DRAG
    ' handle dragging
    Fl_WidgetPosition self,xStart+Fl_EventX(), yStart+Fl_EventY()
    Fl_WidgetRedraw Fl_WidgetWindow(self)
  case FL_EVENT_RELEASE
    Fl_WidgetRedraw Fl_WidgetWindow(self)
  case else
    ' all other events should be handle by FLTK
    return 0
  end select

  return 1 ' we handle FL_EVENT_PUSH,FL_EVENT_DRAG and FL_EVENT_RELEASE
end function

'
' main
'
var w = Fl_GetW()*0.5
var h = Fl_GetH()*0.5
var cat = Fl_PixmapNew(@cat_xpm(0))
var win = Fl_Double_WindowNew(w,h,"dragable boxes")
w \= 50 : h \= 34
for y as integer =0 to h
  for x as integer =0 to w
    if rnd>.5 then
      var box = Fl_BoxExNew(x*50,y*34,50,34)
      Fl_BoxExSetHandleCB box,@HandleCB
      Fl_WidgetSetImage   box,cat
    end if
  next
next
Fl_WindowShow win
Fl_Run

