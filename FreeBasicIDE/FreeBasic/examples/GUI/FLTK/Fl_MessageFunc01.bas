#include once "fltk-c.bi"

' test of
' Fl_SetWarningMessageFunc
' Fl_WarningMessage
' Fl_ErrorMessage
' Fl_ErrorMessage

' The default version of Fl::warning on Windows returns without printing a warning message, 
' because Windows programs normally don't have stderr (a console window) enabled.
#ifdef __FB_WIN32__
sub MyWarningMessageFunc cdecl (byval msg as const zstring ptr,...)
  dim as integer hFile = FreeFile()
  open err for output as #hFile
  print #hFile,"warning: " & *msg
  close #hFile
end sub
' overwrite Fl::warning
Fl_SetWarningMessageFunc @MyWarningMessageFunc
#endif

' user defined func on windows stderr on Linux/Unix
Fl_WarningMessage "warning !"
' MessageBox on windows stderr on Linux/Unix
Fl_ErrorMessage "error !"
' MessageBox on windows stderr on Linux/Unix
Fl_FatalMessage "fatal !"

