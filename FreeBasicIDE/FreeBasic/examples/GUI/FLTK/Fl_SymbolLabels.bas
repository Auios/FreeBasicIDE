#include once "fltk-c.bi"

const ROWS = 4
const COLS = 6
const GAP  = 10
const SIZE = 40

labels:
data "->"    ,">"     ,">>"  ,">|"  ,">[]"    ,"<|"
data "<-"    ,"<"     ,"<<"  ,"|<"  ,"[]<"    ,"|>"
data "<->"   ,"->|"   ,"||"  ,"+"   ,"arrow"  ,"returnarrow"
data "square","circle","line","menu","UpArrow","DnArrow"

var win = Fl_WindowNew(GAP+COLS*(GAP+SIZE),GAP+ROWS*(GAP+SIZE),"Fl_SymbolLabels.bas")
for y as integer = 0 to ROWS-1
  for x as integer = 0 to COLS-1
    dim as string label : read label : label="@" & label
    var btn=Fl_ButtonNew(GAP+x*(GAP+SIZE),GAP+y*(GAP+SIZE),SIZE,SIZE)
    Fl_WidgetCopyLabel btn,strptr(label)
  next
next
Fl_WindowShow win
Fl_Run