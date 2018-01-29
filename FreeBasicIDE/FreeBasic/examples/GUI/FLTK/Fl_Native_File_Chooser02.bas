#include once "fltk-c.bi"
' test of class Fl_Native_File_Chooser
' multiply file selection
var nfc = Fl_Native_File_ChooserNew(NFC_BROWSE_MULTI_FILE)
Fl_Native_File_ChooserSetTitle      nfc,"Load some FreeBASIC files ..."
Fl_Native_File_ChooserSetFilter     nfc,"*.{bas,bi}"
Fl_Native_File_ChooserSetDirectory  nfc,ExePath()
'Fl_Native_File_ChooserSetPresetFile nfc,"Fl_Native_File_Chooser01.bas"


if Fl_Native_File_ChooserShow(nfc)=0 then
  var nFiles = Fl_Native_File_ChooserCount(nfc)
  for i as integer =0 to nFiles-1
    print "selected: " & *Fl_Native_File_ChooserGetFilename(nfc,i)
  next
end if

Fl_Native_File_ChooserDelete nfc
print "..."
sleep
