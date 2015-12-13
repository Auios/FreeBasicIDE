#include once "fltk-c.bi"

' test of:
' Fl_Register_Images    http://www.fltk.org/doc-1.3/Fl__Shared__Image_8H.html#a5c361cb2fdac6c22f6259f5e044657f4
' Fl_Wait               http://www.fltk.org/doc-1.3/classFl.html#a108a84216f0b3fa1cb0c46ab7449a312
' Fl_File_Chooser       http://www.fltk.org/doc-1.3/classFl__File__Chooser.html
' Fl_File_ChooserShown
' Fl_File_ChooserGetValue
' Fl_File_ChooserCount

Fl_Register_Images() ' for image previews

dim as Fl_File_Chooser ptr fc

fc = Fl_File_ChooserNew("media", "Image Files (*.{gif,jpg,jpeg,bmp,png,tif})", FL_FILECHOOSER_SINGLE, "Fl_File_Chooser03.bas")

Fl_File_ChooserShow fc
while Fl_File_ChooserShown(fc)
  Fl_Wait()
wend

if Fl_File_ChooserCount(fc) then
  print *Fl_File_ChooserGetValue(fc)
end if
print "press any key ..."
sleep


