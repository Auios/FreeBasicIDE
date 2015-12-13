#include once "fltk-c.bi"

' Demonstrate simple spreadsheet editor that includes editing row/col headers as well as table cells erco 5/23/14
' from: http://seriss.com/people/erco/fltk/#Fl_Table_Spreadsheet_Cell_Row_Col_Edit

const as integer MAX_COLS = 16
const as integer MAX_ROWS = 64

type Spreadsheet
  declare constructor (byval x as long,byval y as long,byval w as long,byval h as long,byval label as const zstring ptr=0)
  declare operator cast as Fl_TableEx ptr
  declare operator cast as Fl_Table   ptr
  declare operator cast as Fl_Group   ptr
  declare operator cast as Fl_Widget  ptr
  declare sub EventCB2  ' table's event callback (instance)
  declare sub SetValueHide
  declare sub StartEditing(byval context as Fl_TableContext,byval r as long,byval c as long)
  declare sub DoneEditing
  declare static function HandleCB   cdecl (byval me as any ptr,byval event as Fl_Event) as long
  declare static function DrawCellCB cdecl (byval self as any ptr,byval context as Fl_TableContext, _
                                            byval r as long, byval c as long, _
                                            byval x as long, byval y as long, byval w as long, byval h as long) as long
  declare static sub EventCB cdecl (byval wgt as Fl_Widget ptr,byval v as any ptr) ' table's event callback
  declare static sub InputCB cdecl (byval wgt as Fl_Widget ptr,byval v as any ptr) ' input widget's callback

  as Fl_Input ptr m_input                       ' single instance of Fl_Int_Input widget
  as long row_edit, col_edit                    ' row/col being modified
  as Fl_TableContext context_edit               ' context being edited (row head/col head/cell)
  ' Buffer for spreadsheet content
  as string * 20 row_values(MAX_ROWS)           ' one dimensional array of strings
  as string * 20 col_values(MAX_COLS)           ' one dimensional array of strings
  as string * 20 cell_values(MAX_ROWS,MAX_COLS) ' two dimensional array of strings
  as Fl_TableEx ptr m_tbl
end type

operator Spreadsheet.cast as Fl_TableEx ptr : operator = m_tbl : end operator
operator Spreadsheet.cast as Fl_Table   ptr : operator = m_tbl : end operator
operator Spreadsheet.cast as Fl_Group   ptr : operator = m_tbl : end operator
operator Spreadsheet.cast as Fl_Widget  ptr : operator = m_tbl : end operator

constructor Spreadsheet(byval x as long,byval y as long,byval w as long,byval h as long,byval label as const zstring ptr)
  m_tbl = Fl_TableExNew(x,y,w,h,label)
  Fl_TableBegin(m_tbl)

    Fl_TableSetTableBox      m_tbl,BoxType(FL_THIN_UP_FRAME)
    Fl_TableExSetDrawCellCB  m_tbl,@DrawCellCB
    'Fl_TableExSetHandleCB    m_tbl,@HandleCB
    Fl_WidgetSetCallbackArg  m_tbl,@EventCB, @this
    Fl_WidgetSetUserdata     m_tbl,@this
    Fl_WidgetSetWhen         m_tbl,FL_WHEN_NOT_CHANGED or Fl_WidgetGetWhen(m_tbl)


    ' Create input widget that we'll use whenever user clicks on a cell
    m_input = Fl_InputNew(w/2,w/2,0,0)
    Fl_WidgetHide           m_input
    Fl_WidgetSetCallbackArg m_input,@InputCB,@this
    Fl_WidgetSetWhen        m_input,FL_WHEN_ENTER_KEY_ALWAYS  ' callback triggered when user hits Enter
    Fl_Input_SetMaximumSize m_input,5
    Fl_WidgetSetColor       m_input,FL_YELLOW
  
    Fl_TableEnd m_tbl
  
    ' Table rows
    Fl_TableSetRowHeader       m_tbl, 1
    Fl_TableSetRowHeaderWidth  m_tbl,70
    Fl_TableRowHeightAll       m_tbl,25
    Fl_TableSetRowResize       m_tbl, 1
    Fl_TableSetRows            m_tbl,MAX_ROWS
  
    ' Table cols
    Fl_TableSetColHeader       m_tbl, 1
    Fl_TableSetColHeaderHeight m_tbl,25
    Fl_TableColWidthAll        m_tbl,70
    Fl_TableSetColResize       m_tbl, 1
    Fl_TableSetCols            m_tbl,MAX_COLS
  
    context_edit = FL_CONTEXT_NONE
    row_edit = 0
    col_edit = 0
    Fl_TableSetSelection m_tbl,0,0,0,0
    dim as long r,c
    for r=0 to MAX_ROWS
      for c=0 to MAX_COLS
       cell_values(r,c)= "" & r * MAX_ROWS + c
      next
    next  
    for r=0 to MAX_ROWS
      row_values(r)="" & r
    next
    for c=0 to MAX_COLS
      col_values(c) = chr(asc("A")+c)
    next
  Fl_TableEnd(m_tbl)
end constructor

sub Spreadsheet.EventCB cdecl (byval wgt as Fl_Widget ptr,byval v as any ptr)
  dim as Spreadsheet ptr me=v
  me->EventCB2()
end sub

sub Spreadsheet.InputCB cdecl (byval wgt as Fl_Widget ptr,byval v as any ptr)
  dim as Spreadsheet ptr me=v
  me->SetValueHide()
end sub

' Apply value from input widget to values[row][col] array and hide (done editing)
sub Spreadsheet.SetValueHide
  select case as const context_edit
  case FL_CONTEXT_ROW_HEADER: row_values(row_edit) = *Fl_Input_GetValue(m_input)
  case FL_CONTEXT_COL_HEADER: col_values(col_edit) = *Fl_Input_GetValue(m_input)
  case FL_CONTEXT_CELL:       cell_values(row_edit,col_edit) = *Fl_Input_GetValue(m_input)
  end select
  Fl_WidgetHide(m_input)
  Fl_WindowCursor(Fl_WidgetWindow(m_tbl),FL_CURSOR_DEFAULT) ' if we don't do this, cursor can disappear!
end sub

' Start editing a new cell: move the Fl_Int_Input widget to specified row/column
' Preload the widget with the cell's current value and make the widget 'appear' at the cell's location.
' If R=-1, indicates column C is being edited
' If C=-1, indicates row R is being edited
sub Spreadsheet.StartEditing(byval context as Fl_TableContext,byval r as long,byval c as long) 
  ' Keep track of cell being edited
  context_edit = context
  row_edit = r
  col_edit = c
  ' Clear any previous multicell selection
  if (r<0 or c<0) then
    Fl_TableSetSelection(m_tbl,0,0,0,0)
  else
    Fl_TableSetSelection(m_tbl,r,c,r,c)
  end if
  ' Find X/Y/W/H of cell
  dim as long X,Y,W,H
  Fl_TableExFindCell m_tbl,context, R,C, X,Y,W,H
  Fl_WidgetResize(m_input,X,Y,W,H)  ' Move Fl_Input widget there
  select case as const context
  case FL_CONTEXT_ROW_HEADER
    Fl_GroupAdd Fl_WidgetWindow(m_tbl),m_input ' XXX parent to nonscrollable group
    Fl_Input_SetValue m_input,row_values(R)
  case FL_CONTEXT_COL_HEADER
    Fl_GroupAdd Fl_WidgetWindow(m_tbl),m_input ' XXX parent to nonscrollable group
    Fl_Input_SetValue m_input,col_values(C)
  case FL_CONTEXT_CELL
    Fl_GroupAdd m_tbl,m_input ' XXX parent to scrollable table
    Fl_Input_SetValue m_input,cell_values(R,C)
  case else ' shouldn't happen
    Fl_Input_SetValue m_input,"?"
  end select
  ' Fl_WidgetPosition or Fl_Input_SetPosition2 ?
  Fl_Input_SetPosition2 m_input,0,len(*Fl_Input_GetValue(m_input))' Select entire input field
  Fl_WidgetShow      m_input ' Show the input widget, now that we've positioned it
  Fl_WidgetTakeFocus m_input
end sub

  ' Tell the input widget it's done editing, and to 'hide'
sub Spreadsheet.DoneEditing
  if (Fl_WidgetVisible(m_input)) then ' input widget visible, ie. edit in progress?
    SetValueHide() ' Transfer its current contents to cell and hide
  end if
end sub

' Handle drawing all cells in table
function Spreadsheet.DrawCellCB cdecl (byval me as any ptr,byval context as Fl_TableContext, _
                                       byval r as long, byval c as long, _
                                       byval x as long, byval y as long, byval w as long, byval h as long) as long
  dim as Spreadsheet ptr self = Fl_WidgetGetUserdata(me)
  select case as const context
  case FL_CONTEXT_STARTPAGE  ' table about to redraw
  case FL_CONTEXT_COL_HEADER ' table wants us to draw a column heading (C is column)
    ' don't draw this cell if it's being edited
    if ( self->context_edit = context andalso C = self->col_edit andalso Fl_WidgetVisible(self->m_input)) then return 1
    DrawSetFont FL_HELVETICA or FL_BOLD, 14      ' set font for heading to bold
    DrawPushClip X,Y,W,H                    ' clip region for text
      DrawBox BoxType(FL_THIN_UP_BOX), x,y,w,h, Fl_TableGetColHeaderColor(self->m_tbl)
      DrawSetColor FL_BLACK
      DrawStrBox self->col_values(C), x,y,w,h, FL_ALIGN_CENTER
    DrawPopClip
    return 1

  case FL_CONTEXT_ROW_HEADER  ' table wants us to draw a row heading (R is row)
    ' don't draw this cell if it's being edited
    if ( self->context_edit = context andalso R = self->row_edit andalso Fl_WidgetVisible(self->m_input)) then return 1
    DrawSetFont FL_HELVETICA or FL_BOLD, 14      ' set font for heading to bold
    DrawPushClip X,Y,W,H                    ' clip region for text
      DrawBox BoxType(FL_THIN_UP_BOX), x,y,w,h, Fl_TableGetRowHeaderColor(self->m_tbl)
      DrawSetColor FL_BLACK
      DrawStrBox self->row_values(R), x,y,w,h, FL_ALIGN_CENTER
    DrawPopClip
    return 1

  case FL_CONTEXT_CELL ' table wants us to draw a cell
    ' don't draw this cell if it's being edited
    if ( self->context_edit = context andalso _
         R = self->row_edit andalso _
         C = self->col_edit andalso _
         Fl_WidgetVisible(self->m_input)) then return 1
    ' Background
    dim as long highlight = Fl_TableIsSelected(self->m_tbl,R,C) and (context=self->context_edit)
    DrawBox BoxType(FL_THIN_UP_BOX), x,y,w,h, iif(highlight,FL_YELLOW,FL_WHITE)
    ' Text
    DrawSetFont(FL_HELVETICA, 14) ' ..in regular font
    DrawPushClip(X+3, Y+3, W-6, H-6)
      DrawSetColor(FL_BLACK)
      DrawStrBox self->cell_values(R,C), x+3,y+3,w-6,h-8, FL_ALIGN_RIGHT
    DrawPopClip
    return 1

  case FL_CONTEXT_RC_RESIZE ' table resizing rows or columns
    if Fl_WidgetVisible(self->m_input) then
      Fl_TableExFindCell(self->m_tbl,self->context_edit,self->row_edit,self->col_edit, X, Y, W, H)
      Fl_WidgetResize(self->m_input,X,Y,W,H)
      Fl_TableInitSizes(self->m_tbl)
    end if
    return 1
  end select

  return 0
end function

' Callback whenever someone clicks on different parts of the table
sub Spreadsheet.EventCB2
  var context = Fl_TableCallbackContext(m_tbl)
  var c = Fl_TableCallbackCol(m_tbl)
  var r = Fl_TableCallbackRow(m_tbl)

  select case as const context
  case FL_CONTEXT_ROW_HEADER, _
       FL_CONTEXT_COL_HEADER, _
       FL_CONTEXT_CELL ' A table event occurred on a cell
    select case as const Fl_EventNumber() ' see what FLTK event caused it
    case FL_EVENT_PUSH  ' mouse click?
      DoneEditing       ' finish editing previous
      StartEditing(context,R,C)
    case FL_EVENT_KEYBOARD  ' key press in table?
      DoneEditing() ' finish any previous editing
      if (C=Fl_TableGetCols(m_tbl)-1 or R=Fl_TableGetRows(m_tbl)-1) then 
        return ' no editing of totals column
      end if
      dim as ubyte b = Fl_EventText()[0]
      select case b
      case asc("0") to asc("9"),asc("+"),asc("-")  ' any of these should start editing new cell
        StartEditing(context, R, C)
        Fl_InputHandle(m_input,Fl_EventNumber()) ' pass typed char to input
      case 10,13 ' let enter key edit the cell
        StartEditing(context, R, C)
      end select
    end select
  case FL_CONTEXT_TABLE '  A table event occurred on dead zone in table
    DoneEditing() ' done editing, hide
  end select
end sub

'
' main
'
var win = Fl_Double_WindowNew(800,600, "Spreadsheet")
var tbl = new Spreadsheet(10,10,Fl_WidgetGetW(win)-20,Fl_WidgetGetH(win)-20)
Fl_GroupSetResizable(win,win)
Fl_WindowShow win
Fl_Run

