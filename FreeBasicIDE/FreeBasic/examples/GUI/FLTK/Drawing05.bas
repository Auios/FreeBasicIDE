#include once "fltk-c.bi"

' test of 8 bit palette drawing

function DrawCB cdecl (byval self as any ptr) as long
  print "DrawCB"
  for z as long = 0 to 7
    for x as integer = 0 to 4
      for y as integer = 0 to 4
        DrawSetColor Fl_Color_Cube(y,z,x)
        DrawRectFill z*80+x*16,y*16, 16,16
      next
    next
  next
  return 1
end function


'
' main
'
var win = Fl_WindowExNew(8*80,5*16,"Drawing05.bas")
Fl_WindowExSetDrawCB win,@DrawCB
Fl_WindowShow win
Fl_Run
