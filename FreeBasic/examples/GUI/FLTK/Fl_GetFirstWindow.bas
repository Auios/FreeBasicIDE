#include once "fltk-c.bi"

' test of:
' Fl_GetFirstWindow()

sub CloseCB cdecl (byval self as Fl_Widget ptr)
  var  win = Fl_GetFirstWindow()
  while win
    Fl_WindowHide win
    win = Fl_GetFirstWindow()
    sleep 200
  wend
end sub
'
' main
'
var win = Fl_WindowNew2(Fl_GetW()/2-320,Fl_GetH()/2-240,640,480,"main window close me")
Fl_WidgetSetCallback0 win,@CloseCB
for i as integer =1 to 20
   dim as integer w=160+rnd*320
   dim as integer h=w/16*9
   dim as string c = "Form " & i
   Fl_WindowShow Fl_WindowNew2(rnd*(Fl_GetW()-w),rnd*(Fl_GetH()-h),w,h,c)
next
Fl_WindowShow win
Fl_Run

