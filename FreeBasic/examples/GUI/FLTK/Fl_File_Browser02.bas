#include once "fltk-c.bi"

' test of:

' flFilenameExpand
' Fl_WidgetSetType
' Fl_WidgetSetCallbackArg
' Fl_File_BrowserNew
' Fl_File_BrowserLoad
' Fl_BrowserGetValue
' Fl_BrowserGetText 


#ifdef __FB_WIN32__
const PATH = "$USERPROFILE"
#else
const PATH = "$HOME"
#endif

dim shared as zstring ptr UserPath
UserPath = callocate(FL_MAX_PATH)
flFilenameExpand(UserPath,FL_MAX_PATH,PATH)

sub BrowserCB cdecl (byval self as FL_WIDGET ptr,byval filebrowser as any ptr)
  var index = Fl_BrowserGetValue(filebrowser)
  print *Fl_BrowserGetText(filebrowser,index)
end sub
'
' main
'
var win = Fl_WindowNew(300,300)
var fbr = Fl_File_BrowserNew(10,10,280,280)
Fl_WidgetSetType           fbr,FL_HOLDBROWSER
Fl_WidgetSetCallbackArg    fbr,@BrowserCB,fbr
Fl_Browser_SetHasScrollbar fbr,FL_SCROLL_VERTICAL
Fl_File_BrowserLoad        fbr,UserPath
Fl_WindowShow win
Fl_Run


