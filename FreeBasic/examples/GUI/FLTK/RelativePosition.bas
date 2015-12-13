#include once "fltk-c.bi"

function RelX(byval parent as FL_Widget ptr,byval x as long) as long
  if parent=0 then return x
  if Fl_WidgetAsWindow(parent)  then return x
  if Fl_WidgetAsGroup(parent)=0 then return x
  return x+Fl_WidgetGetX(parent)
end function

function RelY(byval parent as FL_Widget ptr,byval y as long) as long
  if parent=0 then return y
  if Fl_WidgetAsWindow(parent)  then return y
  if Fl_WidgetAsGroup(parent)=0 then return y
  return y+Fl_WidgetGetY(parent)
end function
'
' main
'
var win = Fl_WindowNew(320,200)
Fl_ButtonNew RelX(win,50),RelY(win,50),120,24,"window relative"
var grp = Fl_GroupNew(50,50,220,100)
Fl_ButtonNew RelX(grp,50),RelY(grp,50),120,24,"group realative"
Fl_WindowShow win
Fl_Run


