#include once "fltk-c.bi"

sub ShowCB cdecl (byval self as Fl_Widget ptr, box as any ptr)
  var win = Fl_WidgetWindow(self)
  Fl_WidgetCopyLabel(box,"0x" & hex(Fl_XID(win)))
  Fl_WidgetDeactivate self
end sub
'
' main
'
var win = Fl_WindowNew(320,52,"Fl_XID()")
var btn = Fl_ButtonNew( 10,10,150,32,"show handle")
var box = Fl_BoxNew   (170,10,150,32)
Fl_WidgetSetLabelSize  box,20
Fl_WidgetSetLabelColor box,&H0000AA00
Fl_WidgetSetCallbackArg btn,@ShowCB,box
Fl_WindowShow win
Fl_Run



