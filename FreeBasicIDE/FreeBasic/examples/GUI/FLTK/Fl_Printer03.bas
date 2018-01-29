#include once "fltk-c.bi"

' test of:
' Fl_PrinterPrintWidget()

sub ButtonCB cdecl (byval wgt as Fl_Widget ptr)
  dim as Fl_Printer ptr prt = Fl_PrinterNew()
  if prt then
    if Fl_PrinterStartJob(prt,1)=0 then
      if Fl_PrinterStartPage(prt)=0 then
        Fl_PrinterPrintWidget prt,wgt
        Fl_PrinterEndPage prt
      else
        beep:print "Fl_PrinterStartPage() failed"
      end if
      Fl_PrinterEndJob prt
    else
      beep:print "Fl_PrinterStartJob() failed"
    end if
    Fl_PrinterDelete prt
  else
    beep:print "Fl_PrinterNew() failed"
  end if
end sub
'
' main
'
var win = Fl_WindowNew(80,40)
Fl_WidgetSetCallback0 Fl_ButtonNew(10,10,60,20,"print me"),@ButtonCB
Fl_WindowShow win
Fl_Run


