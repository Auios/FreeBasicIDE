#include once "fltk-c.bi"

sub ButtonCB cdecl (byval wgt as Fl_Widget ptr,byval pData as any ptr)
  dim as long w,h,l,t,r,b,pw,ph
  var prt = Fl_PrinterNew()
  if prt then
    if Fl_PrinterStartJob(prt,1)=0 then
      if Fl_PrinterStartPage(prt)=0 then
        Fl_PrinterSetCurrent prt
        dim as single DPI = 72
        dim as single CM  = DPI/2.54
        'Fl_PrinterScale prt,1.0/(DPI/72) ' 72 dpi per inch 
        Fl_PrinterGetPrintableRect prt,w,h
        Fl_PrinterGetMargins prt,l,t,r,b
        pw=w+l+r
        ph=h+t+b
        print "paper size " & pw          & " x " & ph          & " points"
        print "paper size " & pw/DPI      & " x " & ph/DPI      & " zoll"
        print "paper size " & pw/DPI*2.54 & " x " & ph/DPI*2.54 & " cm"
        print
        print "print size " & w          & " x " & h          & " points"
        print "print size " & w/DPI      & " x " & h/DPI      & " zoll"
        print "print size " & w/DPI*2.54 & " x " & h/DPI*2.54 & " cm"
        w \=16:w *=16
        h \=16:h *=16
        
        DrawRect 0,0,w-1,h-1
        for x as integer=0 to w-1 step CM
          DrawLine x,0,x,h-1
        next
        for y as integer=0 to h-1 step CM
          DrawLine 0,y,w-1,y
        next
        Fl_PrinterEndPage prt
      end if  
      Fl_PrinterEndJob prt
    end if  
    Fl_PrinterDelete prt
  end if
end sub


dim as Fl_Window ptr win = Fl_WindowNew(70,40)
dim as Fl_Button ptr btn = Fl_ButtonNew(10,10,60,20,"print")
Fl_WidgetSetCallBack btn,@ButtonCB

Fl_WindowShow win
Fl_Run


