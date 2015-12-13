#include once "fltk-c.bi"

sub AdjusterCB cdecl (byval self as Fl_Widget ptr,byval box as any ptr)
  dim as const zstring ptr tmp = Fl_WidgetGetLabel(box)
  dim as       zstring ptr label = cast(any ptr,tmp)
  Fl_ValuatorFormat cptr(Fl_Valuator ptr,self),label
  Fl_WidgetRedraw box
end sub

'
' main
'
dim as string * 128 buf1
dim as string * 128 buf2

var win = Fl_Double_WindowNew(400,100,"click adjusters and drag")

var btn1 = Fl_BoxNew2(FL_DOWN_BOX,20,30,80,25,buf1) : Fl_WidgetSetColor btn1,FL_WHITE
var adj1 = Fl_AdjusterNew(30+80,30,3*25,25)
Fl_WidgetSetCallbackArg adj1,@AdjusterCB,btn1 : AdjusterCB adj1,btn1

var btn2 = Fl_BoxNew2(FL_DOWN_BOX,50+80+4*25,30,80,25,buf2) : Fl_WidgetSetColor btn2,FL_WHITE
var adj2 = Fl_AdjusterNew(10+Fl_WidgetGetX(btn2)+Fl_WidgetGetW(btn2),10,25,3*25)
Fl_WidgetSetCallbackArg adj2,@AdjusterCB,btn2 : AdjusterCB adj2,btn2

Fl_WindowShow win
Fl_Run
