#include once "fltk-c.bi"

sub ShowCB cdecl (byval self as Fl_Widget ptr, box as any ptr)
  ' get HWND or XLib window ID from Fl_Window
  var xid = Fl_XID(Fl_WidgetWindow(self))
  ' get Fl_Window from HWND or XLib window ID 
  var win = Fl_Find(xid)
  Fl_WidgetCopyLabel(box,"Fl_XID(win) = 0x" & hex(xid) & " Fl_Find(xid) = 0x" & hex(win) )
  Fl_WidgetDeactivate self
end sub
'
' main
'
var win = Fl_WindowNew(500,80,"Fl_Find() and Fl_XID()")
var btn = Fl_ButtonNew(10,10,480,24,"show")
var box = Fl_BoxNew   (10,44,480,32)
Fl_WidgetSetLabelSize  box,20
Fl_WidgetSetLabelColor box,&H0000AA00
Fl_WidgetSetCallbackArg btn,@ShowCB,box
Fl_WindowShow win
Fl_Run



