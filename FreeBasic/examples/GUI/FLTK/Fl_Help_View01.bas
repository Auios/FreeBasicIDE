#include once "fltk-c.bi"

'test of:
' Fl_Register_Images
' Fl_Help_View extends Fl_Group  http://www.fltk.org/doc-1.3/classFl__Help__View.html
' Fl_Help_ViewSetValue

dim as string html = _
"<HTML>" & _
  "<HEAD>" & _
  "</HEAD>" & _
  "<BODY>" & _
   !"<IMG WIDTH=128 HEIGHT=128 SRC=\"media/renata.png\">" & _
    "<HR>" & _
    "<H1>The Fl_Help_View class !</H1>" & _
    "<CODE>Fl_Register_Images()<BR>" & _
   !"var win = Fl_Double_WindowNew(640,480,\"Fl_Help_View01\")<BR>" & _
    "var hv  = Fl_Help_ViewNew(10,10,620,460)<BR>" & _
    "Fl_Help_ViewSetValue hv, html<BR>" & _
    "Fl_GroupSetResizable win,hv<BR>" & _
    "Fl_WindowShow win<BR>" & _
    "Fl_Run</CODE><BR>" & _
  "</BODY>" & _
"</HTML>"

Fl_Register_Images()
var win = Fl_Double_WindowNew(640,480, "Fl_Help_View01")
var hv  = Fl_Help_ViewNew(10,10,620,460)
Fl_Help_ViewSetValue hv,html
Fl_GroupSetResizable win,hv
Fl_WindowShow win
Fl_Run
