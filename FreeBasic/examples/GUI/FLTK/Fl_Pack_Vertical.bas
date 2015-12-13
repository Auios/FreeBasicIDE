#include once "fltk-c.bi"

' test of:
' Fl_Pack (VERTICAL) http://www.fltk.org/doc-1.3/classFl__Pack.html

function CreateMainWindow as FL_WINDOW ptr
  dim as integer w=300
  dim as integer h=900
  ' create flicker free double window
  dim as FL_Window ptr win = Fl_Double_WindowNew(w,h,"resize me horizontal")
  Fl_WindowBegin win
    w=Fl_WidgetGetW(win)
    h=Fl_WidgetGetH(win)
    dim as FL_Group ptr packV =  Fl_PackNew(0,0,w,h)
    Fl_WidgetSetType packV,FL_PACK_VERTICAL
    Fl_GroupBegin(packV)
      h \=3
      Fl_WidgetSetBox Fl_Round_ClockNew(0,0,w,h),FL_DOWN_BOX
      Fl_WidgetSetBox Fl_Round_ClockNew(0,0,w,h),FL_DOWN_BOX
      Fl_WidgetSetBox Fl_Round_ClockNew(0,0,w,h),FL_DOWN_BOX
    Fl_GroupEnd packV
  Fl_WindowEnd win
  Fl_GroupSetResizable win,win
  Fl_WindowSizeRange win,160,Fl_WidgetGetH(win)
  return win
end function

'
' main
'
Fl_WindowShow CreateMainWindow()
Fl_Run
