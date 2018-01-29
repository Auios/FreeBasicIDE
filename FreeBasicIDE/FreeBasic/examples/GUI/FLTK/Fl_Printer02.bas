#include once "fltk-c.bi"

' test of:
' Fl_PrinterPrintWindow()

sub ButtonCB cdecl (byval wgt as Fl_Widget ptr,byval win as any ptr)
  dim as Fl_Printer ptr prt = Fl_PrinterNew()
  if prt then
    if Fl_PrinterStartJob(prt,1)=0 then
      if Fl_PrinterStartPage(prt)=0 then
        Fl_PrinterPrintWindow prt,win
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
var win = Fl_WindowNew(320,240)
Fl_WidgetSetCallbackArg Fl_ButtonNew(10,10,300,220,"print window"),@ButtonCB,win
Fl_WindowShow win
Fl_Run


