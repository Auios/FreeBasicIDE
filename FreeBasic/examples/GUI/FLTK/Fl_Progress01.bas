#include once "fltk-c.bi"

sub TimeoutHandler cdecl (byval self as any ptr)
  dim as integer value = Fl_ProgressGetValue(self)
  if value<100 then
    value+=1 : Fl_ProgressSetValue self,Value
    dim as string vStr=str(value) & "%"
    Fl_WidgetCopyLabel self,strptr(vStr)
    Fl_WidgetSetSelectionColor self,Fl_RGB_Color(200-value*2,value*2,0)
    Fl_RepeatTimeout 1.0/20, @TimeoutHandler, self
  end if
end sub

var win = Fl_WindowNew(320,35,"Fl_Progress")
var prg = Fl_ProgressNew(5,5,310,25)

Fl_WindowShow win
Fl_AddTimeout 1.0, @TimeoutHandler, prg
Fl_Run
