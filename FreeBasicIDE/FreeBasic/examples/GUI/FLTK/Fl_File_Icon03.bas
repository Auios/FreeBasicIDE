#include once "fltk-c.bi"

' test of:
' icon = Fl_File_IconNew(patter,type,size,data)

' The Fl_File_Icon class is a container for vector graphics.
' You can create and use your own vector images.

' bottom,left is the vertex position     0,    0 
' the center  is the vertex position  5000, 5000
' right ,top  is the vertex position 10000,10000
#define DOP_COLOR(col) HIWORD(col), LOWORD(col)
dim as short opcodes(...)=> { _
  FL_DOP_COLOR   ,DOP_COLOR(FL_RED), _
  FL_DOP_LINE    , _
    FL_DOP_VERTEX,    0,    0, _
    FL_DOP_VERTEX,10000,10000, _
  FL_DOP_END     , _
  FL_DOP_COLOR   ,DOP_COLOR(FL_GREEN), _
  FL_DOP_LINE    , _
    FL_DOP_VERTEX,    0,10000, _
    FL_DOP_VERTEX,10000,    0, _
  FL_DOP_END     , _
  FL_DOP_COLOR   ,DOP_COLOR(FL_BLUE), _
  FL_DOP_LINE    , _
    FL_DOP_VERTEX,    0, 5000, _
    FL_DOP_VERTEX,10000, 5000, _
  FL_DOP_END     , _
  FL_DOP_COLOR   ,DOP_COLOR(Fl_DARK_YELLOW), _
  FL_DOP_POLYGON , _
    FL_DOP_VERTEX, 1000, 1000, _
    FL_DOP_VERTEX, 1000, 9000, _
    FL_DOP_VERTEX, 9000, 9000, _
    FL_DOP_VERTEX, 9000, 1000, _
    FL_DOP_VERTEX, 1000, 1000, _
    _ ' opposite direction = hole
    FL_DOP_VERTEX, 1500, 1500, _ 
    FL_DOP_VERTEX, 8500, 1500, _
    FL_DOP_VERTEX, 8500, 8500, _
    FL_DOP_VERTEX, 1500, 8500, _
    FL_DOP_VERTEX, 1500, 1500, _
  FL_DOP_END _
}

sub ButtonCB cdecl (byval self as Fl_Widget ptr,byval btn as any ptr)
  flMessageTitle "ButtonCB"
  flMessage "you pressed the button."
end sub
sub SliderCB cdecl (byval self as Fl_Widget ptr,byval sld as any ptr)
  var win = Fl_WidgetWindow(self)
  var btn = Fl_WidgetGetUserdata(win)
  var size = Fl_ValuatorGetValue(sld)
  Fl_WidgetResize btn,256-size*.5,256-size*.5,size,size
  Fl_WidgetRedraw win
end sub
'
' main
'
Fl_SetScheme "plastic"
Fl_SetScheme "gleam"
' create icon by array of vector opcodes
var icn = Fl_File_IconNew(,,ubound(opcodes),@opcodes(0))
var win = Fl_Double_WindowNew(512,512+50,"Fl_File_Icon03.bas")
Fl_WidgetSetColor win,Fl_RGB_Color(128,128,128)
var btn = Fl_ButtonNew(0,0,512,512)
Fl_WidgetSetColor btn,Fl_RGB_Color(128,128,128)
Fl_WidgetSetCallbackArg btn,@ButtonCB,btn
Fl_File_IconLabel icn,btn

Fl_WidgetSetUserdata win,btn

var sld = Fl_Hor_Value_SliderNew(10,512,492, 30,"scale")
Fl_WidgetSetColor sld,Fl_RGB_Color(128,128,128)
Fl_WidgetSetSelectionColor sld,Fl_RGB_Color(128,128,128)

Fl_WidgetSetCallbackArg sld,@SliderCB,sld
Fl_ValuatorBounds sld,8,512
Fl_ValuatorSetValue sld,256
SliderCB sld,sld


Fl_WindowShow win
Fl_Run
