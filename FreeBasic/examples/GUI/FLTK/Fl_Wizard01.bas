#include once "fltk-c.bi"

' test of:
' Fl_Wizard    http://www.fltk.org/doc-1.3/classFl__Wizard.html

sub CloseCB cdecl (byval self as Fl_Widget ptr,byval win as any ptr)
  Fl_WindowHide win
end sub

sub PrevCB cdecl (byval self as Fl_Widget ptr,byval wiz as any ptr)
  Fl_WizardPrev wiz
end sub

sub NextCB cdecl (byval self as Fl_Widget ptr,byval wiz as any ptr) 
  Fl_WizardNext wiz
end sub

'
' main
'
var win = Fl_WindowNew(400,300,"Example Wizard")
Fl_WidgetSetCallbackArg win,@CloseCB,win
  var wiz = Fl_WizardNew(0,0,400,300)
    var page1 = Fl_WizardPageNew(0,0,400,300)
      Fl_WidgetSetCallbackArg Fl_ButtonNew(290,265,100,25,"Next"),@NextCB,wiz
      var Out1 = Fl_Multiline_OutputNew(10,30,380,220,"Welcome")
      Fl_WidgetSetLabelSize Out1,20 : Fl_WidgetSetAlign Out1,FL_ALIGN_TOP or FL_ALIGN_LEFT
      Fl_Input_SetValue Out1,"This is first page"
    Fl_WizardPageEnd page1

    var page2 = Fl_WizardPageNew(0,0,400,300)
      Fl_WidgetSetCallbackArg Fl_ButtonNew(290,265,100,25,"Next"),@NextCB,wiz
      Fl_WidgetSetCallbackArg Fl_ButtonNew(180,265,100,25,"Back"),@PrevCB,wiz
      var Out2 = Fl_Multiline_OutputNew(10,30,380,220,"Terms And Conditions")
      Fl_WidgetSetLabelSize Out2,20 : Fl_WidgetSetAlign Out2,FL_ALIGN_TOP or FL_ALIGN_LEFT
      Fl_Input_SetValue Out2,"This is the second page"
    Fl_WizardPageEnd page2

    var page3 = Fl_WizardPageNew(0,0,400,300)
      Fl_WidgetSetCallbackArg Fl_ButtonNew(290,265,100,25,"Finish"),@CloseCB,win
      Fl_WidgetSetCallbackArg Fl_ButtonNew(180,265,100,25,"Back"),@PrevCB,wiz
      var Out3 = Fl_Multiline_OutputNew(10,30,380,220,"Finish")
      Fl_WidgetSetLabelSize Out3,20 : Fl_WidgetSetAlign Out3,FL_ALIGN_TOP or FL_ALIGN_LEFT
      Fl_Input_SetValue Out3,"This is the last page"
    Fl_WizardPageEnd page3
  Fl_WizardEnd wiz
Fl_WindowEnd win
Fl_WindowShow win
Fl_Run
