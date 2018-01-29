#include once "fltk-c.bi"

' test of:
' Fl_Pack (HORIZONTAL)  http://www.fltk.org/doc-1.3/classFl__Pack.html

function CreateMainWindow as FL_WINDOW ptr
  dim as integer w=600
  dim as integer h=200
  ' create flicker free double window
  dim as FL_Window ptr win = Fl_Double_WindowNew(w,h,"resize me vertical")
  Fl_WindowBegin win
    w=Fl_WidgetGetW(win)
    h=Fl_WidgetGetH(win)
    dim as FL_Group ptr packV =  Fl_PackNew(0,0,w,h)
    Fl_WidgetSetType packV,FL_PACK_HORIZONTAL
    Fl_GroupBegin(packV)
      w \=3
      Fl_WidgetSetBox Fl_Round_ClockNew(0,0,w,h),FL_DOWN_BOX
      Fl_WidgetSetBox Fl_Round_ClockNew(0,0,w,h),FL_DOWN_BOX
      Fl_WidgetSetBox Fl_Round_ClockNew(0,0,w,h),FL_DOWN_BOX
    Fl_GroupEnd packV
  Fl_WindowEnd win
  Fl_GroupSetResizable win,win
  Fl_WindowSizeRange win,Fl_WidgetGetW(win),100
  return win
end function

'
' main
'
Fl_WindowShow CreateMainWindow()
Fl_Run
