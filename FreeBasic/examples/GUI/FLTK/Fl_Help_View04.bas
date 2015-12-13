#include once "fltk-c.bi"

function LinkCB cdecl (byval self as Fl_Widget ptr,byval uri as const zstring ptr) as const zstring ptr
  print "LinkCB: uri  " & *uri
  print "LinkCB: file " & *flFilenameName(uri)
  return flFilenameName(uri)
end function

Fl_Register_Images()
var win = Fl_Double_WindowNew(640,480, "Fl_Help_View04")
var hv  = Fl_Help_ViewNew(10,10,620,460)
Fl_Help_ViewLink hv,@LinkCB
Fl_Help_ViewLoad hv,"file://www.freebasic.net/forum/index.php"
Fl_GroupSetResizable win,hv
Fl_WindowShow win
Fl_Run
