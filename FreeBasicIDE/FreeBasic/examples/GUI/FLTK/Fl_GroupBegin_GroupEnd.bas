#include once "fltk-c.bi"
' test of:

' Fl_GroupBegin()    http://www.fltk.org/doc-1.3/classFl__Group.html#aa21559a7b1f4234f4655db274609fd8b
' Fl_GroupEnd()      http://www.fltk.org/doc-1.3/classFl__Group.html#a029653337efa0cb2ec52852519293ba8
' Fl_WidgetRedraw()  http://www.fltk.org/doc-1.3/classFl__Widget.html#aa63ce68cbf4620cf8750b868368ea02b

sub AddChild cdecl (byval button as Fl_Widget ptr,byval parent as any ptr)
  ' open the widget list of the parent
  Fl_GroupBegin parent
    ' add a widget to the widget list
    Fl_WidgetSetCallbackArg Fl_ButtonNew(rnd*(Fl_WidgetGetW(parent)-64),rnd*(Fl_WidgetGetH(parent)-24),64,24,"add child"),@AddChild,parent
  ' close the widget list
  Fl_GroupEnd parent
  ' be sure the new widget are drawn
  Fl_WidgetRedraw parent
end sub
'
' main
'
var win = Fl_WindowNew(640,480,"test of Fl_GroupBegin/End()")
AddChild 0,win ' of course we self can call FLTK callbacks too
Fl_WindowShow win
Fl_Run




