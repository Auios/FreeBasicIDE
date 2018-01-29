#include once "fltk-c.bi"


' class Fl_Browser_ extends Fl_Group    http://www.fltk.org/doc-1.3/classFl__Browser__.html
' class Fl_Browser  extends Fl_Browser_ http://www.fltk.org/doc-1.3/classFl__Browser.html

'test of: FL_HOLDBROWSER with callback


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
Fl_WidgetSetType brw,FL_HOLDBROWSER
Fl_WidgetSetCallbackArg  brw,@BrowserCB,box
for item as integer = 1 to 10
  Fl_BrowserAdd brw,"item " & item
next
Fl_WindowShow win
Fl_Run
