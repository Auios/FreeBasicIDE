#include once "fltk-c.bi"
' original file "ask.cxx"

' test of:
' flMessageTitle, flInput, flPassword, flChoice
' Fl_Return_Button, Fl_Button, Fl_WidgetAsWindow

' this is a test to make sure automatic destructors work.
' Pop up the question dialog several times and make sure it doesn't crash.
' Also we test to see if the window exit callback works.

sub update_input_text(byval wgt as Fl_Widget ptr,byval pInput as const zstring ptr)
  if (pInput) then
    Fl_WidgetCopyLabel wgt,pInput
    Fl_WidgetRedraw wgt
  end if
end sub

sub RenameMeCB cdecl (byval self as Fl_Widget ptr,byval pUserdata as any ptr)
  flMessageTitle("RenameMeCB")
  dim as const zstring ptr pInput = flInput("Input:", Fl_WidgetGetLabel(self))
  update_input_text(self, pInput)
end sub

sub RenameMePasswordCB cdecl (byval self as Fl_Widget ptr,byval pUserdata as any ptr)
  flMessageTitle("RenameMePasswordCB")
  dim as const zstring ptr pInput = flPassword("Input password:", Fl_WidgetGetLabel(self))
  update_input_text(self, pInput)
end sub

sub WindowCB cdecl (byval self as Fl_Widget ptr,byval pUserdata as any ptr)
  flMessageTitle("WindowCB")
  dim as integer rep = flChoice("Are you sure you want to quit?", "Cancel", "Quit", "Dunno")
  if (rep=1) then
    Fl_WindowHide Fl_WidgetAsWindow(self)
  elseif (rep=2) then
    flMessage("Well, maybe you should know before we quit.")
  end if
end sub

' 
' main
'
dim as zstring * 128 buffer1 = "Test text"
dim as zstring * 128 buffer2 = "MyPassword"
dim as Fl_Double_Window ptr win = Fl_Double_WindowNew(200,105)
Fl_WidgetSetCallback win,@WindowCB
Fl_WidgetSetCallback Fl_Return_ButtonNew(20, 10, 160, 35, buffer1),@RenameMeCB
Fl_WidgetSetCallback Fl_ButtonNew       (20, 50, 160, 35, buffer2),@RenameMePasswordCB
Fl_GroupSetResizable win,win
Fl_WindowShow win
Fl_Run
