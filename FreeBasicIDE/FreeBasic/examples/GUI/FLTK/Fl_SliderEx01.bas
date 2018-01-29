#include once "fltk-c.bi"

'test of:
' Fl_SliderExNew()      http://www.fltk.org/doc-1.3/classFl__Slider.html

function HandleCB cdecl (byval self as any ptr,byval event as Fl_Event) as long
  select case event
  case FL_EVENT_RELEASE , FL_EVENT_DRAG
    print "HandleCB SliderValue = " & Fl_ValuatorGetValue(self)
  end select
  return Fl_SliderExHandleBase(self,event) ' don't eat the event
end function
'
' main
'
var win = Fl_WindowNew(390,210,"Fl_SliderEx01")
var sld = Fl_SliderExNew( 10, 10, 30,180,"0.0-1.0")
Fl_SliderExSetHandleCB sld, @HandleCB
Fl_WindowShow win
Fl_Run
