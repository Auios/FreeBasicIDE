#include once "fltk-c.bi"
' test of:
' Fl_SetScheme "none"
' Fl_SetScheme "plastic"
' Fl_SetScheme "gtk+"
' Fl_SetScheme "gleam"

sub ButtonCB cdecl (byval widget as FL_WIDGET ptr,byval scheme as any ptr)
  Fl_SetScheme scheme : Fl_Redraw
end sub

sub SliderCB cdecl (byval widget as FL_WIDGET ptr,byval sld as any ptr)
  dim as long scheme = Fl_ValuatorGetValue(sld)
  select case as const scheme
  case 1    : Fl_SetScheme "gtk+"
  case 2    : Fl_SetScheme "plastic"
  case 3    : Fl_SetScheme "gleam"
  case else : Fl_SetScheme "none"
  end select
  Fl_Redraw
end sub
'
' main
'
var win = Fl_WindowNew(320,210,"Fl_SetScheme()")
Fl_WidgetSetCallbackArg Fl_ButtonNew            ( 10,10    ,140,32,"None"   ),@ButtonCB,@"none"
Fl_WidgetSetCallbackArg Fl_ButtonNew            ( 10,10+ 40,140,32,"Gtk+"   ),@ButtonCB,@"gtk+"
Fl_WidgetSetCallbackArg Fl_ButtonNew            ( 10,10+ 80,140,32,"Plastic"),@ButtonCB,@"plastic"
Fl_WidgetSetCallbackArg Fl_ButtonNew            ( 10,10+120,140,32,"Gleam"  ),@ButtonCB,@"gleam"
Fl_WidgetSetCallbackArg Fl_Radio_Round_ButtonNew(170,10   ,  90,30,"None"   ),@ButtonCB,@"none"
Fl_WidgetSetCallbackArg Fl_Radio_Round_ButtonNew(170,10+ 40, 90,30,"Gtk+"   ),@ButtonCB,@"gtk+"
Fl_WidgetSetCallbackArg Fl_Radio_Round_ButtonNew(170,10+ 80, 90,30,"Plastic"),@ButtonCB,@"plastic"
Fl_WidgetSetCallbackArg Fl_Radio_Round_ButtonNew(170,10+120, 90,30,"Gleam"  ),@ButtonCB,@"gleam"
var sld = Fl_Hor_Nice_SliderNew (10,170,300,30)
Fl_WidgetSetCallbackArg sld,@SliderCB,sld
Fl_ValuatorSetStep sld,1
Fl_ValuatorBounds  sld,0,3
Fl_WindowShow Win
Fl_Run
