#include once "fltk-c.bi"

'test of:
' Fl_Table_Row

const MAX_ROWS = 32
const MAX_COLS = 26

dim shared as long datas(MAX_ROWS-1,MAX_COLS-1)

sub DrawHeader(byval tbl as Fl_Table ptr,byval z as const zstring ptr, _
               byval x as long,byval y as long,byval w as long,byval h as long)
  DrawPushClip   x,y,w,h
    DrawBox      BoxType(FL_THIN_UP_BOX), x,y,w,h, Fl_TableGetRowHeaderColor(tbl)
    DrawSetColor FL_BLACK
    DrawStrBox   z, x,y,w,h, FL_ALIGN_CENTER
  DrawPopClip
end sub

sub DrawData(byval tbl as Fl_Table ptr,byval z as const zstring ptr, _
             byval x as long,byval y as long,byval w as long,byval h as long, _
             byval fillcolor as Fl_Color=Fl_Write)
  DrawPushClip x,y,w,h
    DrawSetColor fillcolor: DrawRectFill x,y,w,h
    DrawSetColor FL_GRAY0: DrawStrBox z,x,y,w,h, FL_ALIGN_CENTER
    DrawSetColor Fl_BLACK: DrawRect     x,y,w,h
  DrawPopClip
end sub

function DrawCellCB cdecl (byval self as any ptr,byval context as Fl_TableContext, _
                           byval r as long,byval c as long, _
                           byval x as long,byval y as long,byval w as long,byval h as long) as long
  dim as string value
  select case as const context
  case FL_CONTEXT_STARTPAGE
    DrawSetFont(FL_HELVETICA, 16)
  case FL_CONTEXT_COL_HEADER
    value=chr(asc("A")+c)
    DrawHeader(self,strptr(value),x,y,w,h)
  case FL_CONTEXT_ROW_HEADER
    value=str(r)
    DrawHeader(self,strptr(value),x,y,w,h)
  case FL_CONTEXT_CELL
    value=str(datas(r,c))
    if Fl_Table_RowRowSelected(self,r) then
      DrawData(self,strptr(value),x,y,w,h,Fl_Red)
    else
      DrawData(self,strptr(value),x,y,w,h,Fl_White)
    end if
  case else 
    return 0
  end select
  return 1
end function

'
' main
'
for r as long=0 to MAX_ROWS-1
  for c as long=0 to MAX_COLS-1
    datas(r,c)=rnd*1000
  next
next

var win = Fl_Double_WindowNew(520,240, "Fl_Table_RowEx01.bas")
var tbr = Fl_Table_RowExNew(10,20,500,210)
Fl_Table_RowExSetDrawCellCB tbr,@DrawCellCB


Fl_TableBegin tbr ' open child list
  ' Rows
  Fl_Table_RowSetRows tbr,MAX_ROWS  ' how many rows
  Fl_TableSetRowHeader tbr, 1       ' enable row headers (along left)
  Fl_TableRowHeightAll tbr,20       ' default height of rows
  Fl_TableSetRowResize tbr, 0       ' disable row resizing
  '  Cols
  Fl_TableSetCols      tbr,MAX_COLS ' how many columns
  Fl_TableSetColHeader tbr, 1       ' enable column headers (along top)
  Fl_TableColWidthAll  tbr,80       ' default width of columns
  Fl_TableSetColResize tbr, 1       ' enable column resizing
Fl_TableEnd tbr ' close child list

Fl_Table_RowSetType tbr,FL_SELECT_SINGLE
Fl_Table_RowSelectRow tbr,2


Fl_GroupSetResizable win,win
Fl_WindowShow win
Fl_Run
