#include once "fltk-c.bi"

sub InputCB cdecl (byval self as Fl_Widget ptr,byval me as any ptr)
  print "InputCB: " & *Fl_Input_GetValue(me)
end sub

sub Fl_InputGridNew(byval parent     as Fl_Group ptr, _
                    byval nCols      as integer, _
                    byval nRows      as integer, _
                    byval CellWidth  as integer=64, _
                    byval CellHeight as integer=24)
  Fl_GroupBegin parent
    for r as integer=0 to nRows-1
      for c as integer=0 to nCols-1
        var ip = Fl_InputNew(c*CellWidth,r*CellHeight,CellWidth,CellHeight)
        Fl_Input_SetValue ip,"r: " & r & " c:" & c
        Fl_WidgetSetCallbackArg ip,@InputCB,ip
        Fl_GroupAdd parent,ip
      next
    next
  Fl_GroupEnd parent
end sub

var win = Fl_WindowNew(320,240,"A grid of Fl_Input wigets.")
Fl_InputGridNew      win,10,12
Fl_GroupSetResizable win,win
Fl_WindowShow win
Fl_Run