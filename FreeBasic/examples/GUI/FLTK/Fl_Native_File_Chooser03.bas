#include once "fltk-c.bi"
' test of class Fl_Native_File_Chooser
' single directory selection
var nfc = Fl_Native_File_ChooserNew(NFC_BROWSE_DIRECTORY)
Fl_Native_File_ChooserSetTitle      nfc,"Select folder ..."
Fl_Native_File_ChooserSetDirectory  nfc,ExePath()

if Fl_Native_File_ChooserShow(nfc)=0 then
  print "selected: " & *Fl_Native_File_ChooserFilename(nfc)
end if

Fl_Native_File_ChooserDelete nfc
print "..."
sleep
