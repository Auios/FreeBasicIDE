#include once "fltk-c.bi"
'test of:
' Fl_Menu_Bar  http://www.fltk.org/doc-1.3/classFl__Menu__Bar.html
' Fl_Menu_Add
' flChoice

sub QuitCB cdecl (byval self as Fl_Widget ptr,byval userdata as any ptr)
  if flChoice("Do you really want to exit ?","no","yes") then
    Fl_WindowHide Fl_WidgetWindow(self)
  end if
end sub

sub EditCB cdecl (byval self as Fl_Widget ptr,byval userdata as any ptr)
 print "EditCB "
end sub

sub MenuCB cdecl (byval self as Fl_Widget ptr,byval userdata as any ptr)
 print "MenuCB "
end sub

var win = Fl_WindowNew(320,200,"Fl_Menu_Bar01")
Fl_BoxNew(5,35,310,160,"Hello, World!")
var mnb = Fl_Menu_BarNew(0,0,320,30)
Fl_Menu_Add(mnb,"File/Quit" , FL_CTRL+asc("q"), @QuitCB)
Fl_Menu_Add(mnb,"Edit/Cut"  , FL_CTRL+asc("x"), @EditCB)
Fl_Menu_Add(mnb,"Edit/Copy" , FL_CTRL+asc("c"), @EditCB)
Fl_Menu_Add(mnb,"Edit/Paste", FL_CTRL+asc("v"), @EditCB)
Fl_Menu_Add(mnb,"Menu/Item 1",FL_CTRL+asc("m"), @MenuCB)
Fl_Menu_Add3(mnb,"Menu/Submenu/Item 2")
Fl_Menu_Add3(mnb,"Menu/Submenu/Item 3")

Fl_WindowEnd win
Fl_WindowShow win
Fl_Run
