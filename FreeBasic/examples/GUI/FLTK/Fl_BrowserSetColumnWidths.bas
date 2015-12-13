#Include once "fltk-c.bi"
' test of:
' Fl_BrowserSetColumnWidths

const T9 = chr(9)
dim as long col(...) = {100, 100, 100,0}
'
' main
'
var win = Fl_Double_WindowNew(400, 400, "Tabelle")
  var brw = Fl_BrowserNew(20, 20, 360, 360)
    Fl_BrowserSetColumnWidths(brw, @col(0))
    Fl_BrowserAdd(brw, "x" & T9 & "x^2" & T9 & "Sqr(x)")
    For x as single= 1 To 100
      Fl_BrowserAdd(brw, Str(x) & T9 & Str(x^2) & T9 & Str(Sqr(x)))
    Next
  Fl_BrowserEnd brw
Fl_WindowEnd win

Fl_GroupSetResizable(win,brw)
Fl_WindowShow(win)
Fl_Run
