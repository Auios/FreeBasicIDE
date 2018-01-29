#include once "fltk-c.bi"

'test of:
' class Fl_Check_BrowserEx

function HandleCB cdecl(byval self as any ptr,byval event as FL_EVENT) as long
  if event=FL_EVENT_RELEASE then
    print "HandleCB: FL_EVENT_RELEASE"
    dim as integer nItems = Fl_Check_BrowserNItems(self)
    if nItems>0 then
      for item as integer = 1 to nItems
        if Fl_Check_BrowserGetChecked(self,item) then
          print "[*] ";
        else
          print "[ ] ";
        end if
        print *Fl_Check_BrowserText(self,item)
      next
    end if
  end if
  return Fl_Check_BrowserExHandleBase(self,event) ' don't eat the event
end function
'
' main
'
var win = Fl_Double_WindowNew(320,100,"Fl_Check_BrowserEx.bas")
var cbr = Fl_Check_BrowserExNew(10,10,320-20,100-20)

Fl_Check_BrowserExSetHandleCB cbr,@HandleCB
Fl_Browser_SetHasScrollbar    cbr, FL_SCROLL_VERTICAL_ALWAYS

Fl_Check_BrowserAdd cbr,"item 1"
Fl_Check_BrowserAdd cbr,"item 2"
Fl_Check_BrowserAdd cbr,"item 3"
Fl_Check_BrowserAdd cbr,"item 4"

Fl_GroupSetResizable win,cbr
Fl_WindowShow win
Fl_Run
