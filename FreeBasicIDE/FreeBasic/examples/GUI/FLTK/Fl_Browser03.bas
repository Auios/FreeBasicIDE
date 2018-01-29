#include once "fltk-c.bi"

' test of:

' Fl_WidgetSetSelectionColor()
' Fl_Browser_ScrollbarLeft()

sub BrowserCB cdecl(byval self as FL_WIDGET ptr,byval box as any ptr)
  var brw = cptr(Fl_Browser ptr,self)
  Fl_WidgetCopyLabel box,Fl_BrowserGetText(brw,Fl_BrowserGetValue(brw))
  Fl_WidgetRedrawLabel box
end sub
'
' main
'
var win = Fl_WindowNew (160,160,"")
var box = Fl_BoxNew    (10,0,140,24,"select an item")
var brw = Fl_BrowserNew(10,24,140,116,"FL_HOLDBROWSER")
Fl_Browser_ScrollbarLeft brw
Fl_WidgetSetType brw,FL_HOLDBROWSER
Fl_WidgetSetCallbackArg brw,@BrowserCB,box
Fl_WidgetSetSelectionColor brw,FL_RED
for i as integer = 1 to 8
  Fl_BrowserAdd brw,"item " & i
next
Fl_BrowserInsert brw,3,"item 2b"
Fl_BrowserSelect brw,3

Fl_WindowShow win
Fl_Run
