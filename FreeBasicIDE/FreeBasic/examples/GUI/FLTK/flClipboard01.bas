#include once "fltk-c.bi"

namespace Widgets
  dim as Fl_Window ptr _Window
  dim as Fl_Input  ptr _Source
  dim as Fl_Input  ptr _Target
  dim as Fl_Button ptr _Copy
  dim as Fl_Button ptr _Paste
end namespace 

using Widgets

sub CopyCB cdecl(self as Fl_Widget ptr)
  var nChars =  Fl_Input_GetSize(_source)
  ' no text disable paste button
  if nChars=0 then Fl_WidgetDeactivate _Paste : return
  ' copy text to clipboard
  Fl_Copy Fl_Input_GetValue(_Source),nChars,1
  ' enable paste button
  Fl_WidgetActivate _Paste
end sub

sub PasteCB cdecl(self as Fl_Widget ptr)
  ' paste text from clipboard to target widget
  Fl_Paste _Target, 1
end sub

'
' main
'
_Window = Fl_WindowNew(620,78,        "clipboard")
_Source = Fl_InputNew ( 80,10,320,24, "source:"  )
_Target = Fl_InputNew ( 80,44,320,24, "target:"  )
_Copy   = Fl_ButtonNew(410,10,160,24, "copy to clipboard")
_Paste  = Fl_ButtonNew(410,44,160,24, "paste from clipboard")
Fl_WidgetSetCallback0 _Copy,@CopyCB
Fl_WidgetSetCallback0 _Paste,@PasteCB
Fl_WidgetDeactivate   _Paste
Fl_WidgetDeactivate   _Target
Fl_WindowShow         _Window
Fl_Run


