#include once "fltk-c.bi"

'test of:
' Fl_File_Chooser  http://www.fltk.org/doc-1.3/classFl__File__Chooser.html
' Fl_File_ChooserCallback
' Fl_File_ChooserShow
sub FileChooserCB cdecl(byval fc as Fl_File_Chooser ptr,byval pData as any ptr)
  dim as const zstring ptr filename=0
  filename = Fl_File_ChooserGetValue(fc)
  print "FileChooserCB: " & *filename
end sub
'
' main
'
Fl_Register_Images()

dim as Fl_File_Chooser ptr fc = Fl_File_ChooserNew(Exepath(), "*.bas", FL_FILECHOOSER_SINGLE, "Fl_File_Chooser01.bas")
Fl_File_ChooserSetPreview fc,1
Fl_File_ChooserCallback fc,@FileChooserCB,0
Fl_File_ChooserShow fc
Fl_Run
