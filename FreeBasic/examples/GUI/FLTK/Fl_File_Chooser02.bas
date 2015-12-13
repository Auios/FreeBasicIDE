#include once "fltk-c.bi"

'test of:
' Fl_File_Chooser  http://www.fltk.org/doc-1.3/classFl__File__Chooser.html
' Fl_File_ChooserShown
' Fl_Wait
' Fl_File_ChooserGetValue
' Fl_File_ChooserCount

dim as Fl_File_Chooser ptr fc = Fl_File_ChooserNew(".", "*.bas", FL_FILECHOOSER_MULTI, "Fl_File_Chooser02.bas")

Fl_File_ChooserShow fc

while Fl_File_ChooserShown(fc)
  Fl_Wait()
wend

if Fl_File_ChooserCount(fc)>0 then
  for item as long=1 to Fl_File_ChooserCount(fc)
    print *Fl_File_ChooserGetValue(fc,item)
  next
end if
print "press any key ..."
sleep


