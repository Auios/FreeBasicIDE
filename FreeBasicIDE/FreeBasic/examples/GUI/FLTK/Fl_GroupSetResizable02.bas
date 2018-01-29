#include once "fltk-c.bi"

' test of:
' Fl_GroupSetResizable  http://www.fltk.org/doc-1.3/classFl__Group.html#afd220e45e1ac817bde7d6a25fdf74e37

const BOX_STYLE = FL_DOWN_BOX

' get screensize and calculate window size
dim as integer sw = Fl_GetW(),ww=sw\2
dim as integer sh = Fl_GetH(),wh=sh\2

' create a centered flicker free (double buffered) window
dim as FL_WINDOW ptr win = Fl_Double_WindowNew2(ww\2,wh\2,ww,wh, "resize me ...")

Fl_WindowBegin win ' open the child list
  dim as integer bw = ww\4,bh = wh\4
  dim as FL_BOX ptr box

  ' add 4 boxes in first row
  Fl_WidgetSetColor Fl_BoxNew2(BOX_STYLE,bw*0,bh*0,bw*1,bh*1),fl_RGB_Color(rnd*255,rnd*255,rnd*255)
  Fl_WidgetSetColor Fl_BoxNew2(BOX_STYLE,bw*1,bh*0,bw*1,bh*1),fl_RGB_Color(rnd*255,rnd*255,rnd*255)
  Fl_WidgetSetColor Fl_BoxNew2(BOX_STYLE,bw*2,bh*0,bw*1,bh*1),fl_RGB_Color(rnd*255,rnd*255,rnd*255)
  Fl_WidgetSetColor Fl_BoxNew2(BOX_STYLE,bw*3,bh*0,bw*1,bh*1),fl_RGB_Color(rnd*255,rnd*255,rnd*255)

  ' add 3 boxes in second row
  Fl_WidgetSetColor Fl_BoxNew2(BOX_STYLE,bw*0,bh*1,bw*1,bh*2),fl_RGB_Color(rnd*255,rnd*255,rnd*255)
                box=Fl_BoxNew2(BOX_STYLE,bw*1,bh*1,bw*2,bh*2) : Fl_WidgetSetColor box,FL_BLACK
  Fl_WidgetSetColor Fl_BoxNew2(BOX_STYLE,bw*3,bh*1,bw*1,bh*2),fl_RGB_Color(rnd*255,rnd*255,rnd*255)

  ' add 2 boxes in third row
  Fl_WidgetSetColor Fl_BoxNew2(BOX_STYLE,bw*0,bh*3,bw*2,bh*1),fl_RGB_Color(rnd*255,rnd*255,rnd*255)
  Fl_WidgetSetColor Fl_BoxNew2(BOX_STYLE,bw*2,bh*3,bw*2,bh*1),fl_RGB_Color(rnd*255,rnd*255,rnd*255)

Fl_WindowEnd win ' close the child list

Fl_GroupSetResizable win,box ' the black box and it's row defines the resizeable behavior of all other boxes

Fl_WindowShow win ' bring the window on the screen

Fl_Run ' enter the message loop
