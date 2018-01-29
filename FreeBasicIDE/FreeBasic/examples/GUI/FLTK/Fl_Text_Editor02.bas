#include once "fltk-c.bi"

'test of:
' Fl_Text_DisplayHighlightData http://www.fltk.org/doc-1.3/classFl__Text__Display.html#ae09d61739b737a32868ffe0295a25dec

dim as Style_Table_Entry StyleTable(...) => _
{ (FL_BLUE      ,FL_COURIER,12)           , _ ' style 'A'
  (FL_DARK_RED  ,Fl_COURIER_ITALIC,12)    , _ ' style 'B'
  (Fl_DARK_GREEN,Fl_COURIER_BOLD_ITALIC,12) _ ' style 'C'
}  

var win = Fl_WindowNew(320,240, "Fl_Text_Editor02")
var edt = Fl_Text_EditorNew(10,10,Fl_WidgetGetW(win)-20,Fl_WidgetGetH(win)-20)
var buf = Fl_Text_BufferNew()
var hd  = Fl_Text_BufferNew()

Fl_Text_DisplaySetLinenumberWidth edt,40 ' 0= line numbers off
Fl_Text_DisplaySetBuffer edt,buf
Fl_Text_DisplayHighlightData edt,hd,@StyleTable(0),3

Fl_Text_BufferSetText buf ,!"print \"hello world\" ' comment"
Fl_Text_BufferSetText hd,   "AAAAA BBBBBBBBBBBBB CCCCCCCCC"

Fl_GroupSetResizable win,edt
Fl_WindowShow win
Fl_Run
