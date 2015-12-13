#include once "fltk-c.bi"

'test of:
' class Fl_Hold_Browser extends Fl_Browser http://www.fltk.org/doc-1.3/classFl__Hold__Browser.html
' Fl_WidgetSetType class, FL_MULTIBROWSER
' Fl_BrowserAdd
' Fl_BrowserInsert
' Fl_BrowserGetSize
' Fl_BrowserGetText

dim as Fl_Window ptr Win = Fl_WindowNew(320,100,"Fl_Hold_Browser (multi selection)")
dim as Fl_Hold_Browser ptr br = Fl_Hold_BrowserNew(10,10,320-20,100-20)
Fl_Browser_SetHasScrollbar br, FL_SCROLL_VERTICAL_ALWAYS

Fl_WidgetSetType br, FL_MULTIBROWSER

Fl_BrowserAdd br,"item 1"
Fl_BrowserAdd br,"item 2"
Fl_BrowserAdd br,"item 3"
Fl_BrowserAdd br,"item 4"
Fl_BrowserAdd br,"item 5"
Fl_BrowserAdd br,"item 6"
Fl_BrowserAdd br,"item 7"
Fl_BrowserAdd br,"item 8"

Fl_BrowserInsert br,3,"item 2b"

dim as integer nitems = Fl_BrowserGetSize(br)
if nItems>0 then
  for item as integer = 1 to nItems
    ? *Fl_BrowserGetText(br,item)
  next
end if

Fl_WindowShow Win
Fl_Run
