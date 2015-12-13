#include once "fltk-tools.bi" ' for BoxtypeAsString()

' test of:

' BoxType()
' BoxtypeAsString()

const BOX_WIDTH  = 240
const BOX_HEIGHT = 50

var win = Fl_Double_WindowNew(6*10+5*BOX_WIDTH,12*10+11*BOX_HEIGHT,"Fl_Boxtype01.bas")
Fl_WidgetSetColor win,12
for i as integer = 0 to 55
  dim as integer row = i \ 5
  dim as integer col = i mod 5
  Fl_BoxNew2(BoxType(i),10+col*(10+BOX_WIDTH),10+row*(10+BOX_HEIGHT),BOX_WIDTH,BOX_HEIGHT,BoxtypeAsString(i))
next

Fl_WindowShow win
Fl_Run
