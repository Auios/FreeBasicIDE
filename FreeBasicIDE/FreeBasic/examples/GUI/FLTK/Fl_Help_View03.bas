#include once "fltk-c.bi"

'test of:
' Fl_Help_ViewLink()

function LinkCB cdecl (byval self as Fl_Widget ptr,byval uri as const zstring ptr) as const zstring ptr
  print "LinkCB " & *flFilenameName(uri)
  return uri
end function

Fl_Register_Images()
var win = Fl_Double_WindowNew(640,480, "Fl_Help_View03")
var hv  = Fl_Help_ViewNew(10,10,620,460)
Fl_Help_ViewLink hv,@LinkCB
Fl_Help_ViewLoad hv,"media/test02.html"
Fl_GroupSetResizable win,hv
Fl_WindowShow win
Fl_Run
