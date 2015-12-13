#include once "fltk-c.bi"

'test of:
' Fl_Table                  http://www.fltk.org/doc-1.3/classFl__Table.html
' Fl_TableExNew
' Fl_TableExSetDrawCellCB
' Fl_TableSetRows
' Fl_TableSetRowHeader
' ...
' DrawPushClip
' DrawPopClip
' DrawBox
' DrawRect
' DrawRectFill
' DrawSetColor
' DrawStrBox

const MAX_ROWS = 32
const MAX_COLS = 26

dim shared as long datas(MAX_ROWS-1,MAX_COLS-1)

sub DrawHeader(byval tbl as Fl_Table ptr,byval s as string, _
               byval x as long,byval y as long,byval w as long,byval h as long)
  dim as zstring ptr z = strptr(s)
  DrawPushClip(x,y,w,h)
    DrawBox(BoxType(FL_THIN_UP_BOX), x,y,w,h, Fl_TableGetRowHeaderColor(tbl))
    DrawSetColor(FL_BLACK)
    DrawStrBox(z, x,y,w,h, FL_ALIGN_CENTER)
  DrawPopClip()
end sub

sub DrawData(byval tbl as Fl_Table ptr,byval s as string, _
             byval x as long,byval y as long,byval w as long,byval h as long)
  dim as zstring ptr z = strptr(s)
  DrawPushClip(x,y,w,h)
    DrawSetColor(FL_WHITE): DrawRectFill(x,y,w,h)
    DrawSetColor(FL_GRAY0): DrawStrBox(z, x,y,w,h, FL_ALIGN_CENTER)
    DrawSetColor(Fl_BLACK): DrawRect(x,y,w,h)
  DrawPopClip()
end sub

function DrawCellCB cdecl (byval self as any ptr,byval context as Fl_TableContext, _
                           byval r as long,byval c as long, _
                           byval x as long,byval y as long,byval w as long,byval h as long) as long
  '? r & "," & c & " " & x,y,w,h
  select case as const context
  case FL_CONTEXT_STARTPAGE
    DrawSetFont(FL_HELVETICA, 16)
  case FL_CONTEXT_COL_HEADER
    DrawHeader(self,chr(asc("A")+c),x,y,w,h)
  case FL_CONTEXT_ROW_HEADER
    DrawHeader(self,str(r),x,y,w,h)
  case FL_CONTEXT_CELL
    DrawData(self,str(datas(r,c)),x,y,w,h)
  case else 
    return 0
  end select
  return 1
end function

sub ColSliderCB cdecl(byval self as FL_WIDGET ptr,byval tbl as any ptr)
  Fl_TableSetColHeaderHeight tbl,200*Fl_ValuatorGetValue(cptr(Fl_Valuator ptr,self))
end sub
sub RowSliderCB cdecl(byval self as FL_WIDGET ptr,byval tbl as any ptr)
  Fl_TableSetRowHeaderWidth tbl,200*Fl_ValuatorGetValue(cptr(Fl_Valuator ptr,self))
end sub

'
' main
'
for r as long=0 to MAX_ROWS-1
  for c as long=0 to MAX_COLS-1
    datas(r,c)=rnd*1000
  next
next

var win = Fl_Double_WindowNew(320,240, "Fl_TableEx02.bas")
var tbl = Fl_TableExNew(20,20,280,160,"Fl_TableEx")
Fl_TableExSetDrawCellCB tbl,@DrawCellCB
Fl_TableBegin(tbl)              ' open child list
  ' Rows
  Fl_TableSetRows(tbl,MAX_ROWS)   ' how many rows
  Fl_TableSetRowHeader(tbl,1)     ' enable row headers (along left)
  Fl_TableRowHeightAll(tbl,20)    ' default height of rows
  Fl_TableSetRowResize(tbl,0)     ' disable row resizing
  '  Cols
  Fl_TableSetCols(tbl,MAX_COLS)   ' how many columns
  Fl_TableSetColHeader(tbl,1)     ' enable column headers (along top)
  Fl_TableColWidthAll(tbl,80)     ' default width of columns
  Fl_TableSetColResize(tbl,1)     ' enable column resizing
Fl_TableEnd(tbl)                ' close child list

var colsld = Fl_Hor_SliderNew(20,200,100,24,"col size")
Fl_WidgetSetCallbackArg colsld,@colSliderCB,tbl

var rowsld = Fl_Hor_SliderNew(200,200,100,24,"row size")
Fl_WidgetSetCallbackArg rowsld,@rowSliderCB,tbl


Fl_GroupSetResizable(win,win)
Fl_WindowShow(win)
Fl_Run
