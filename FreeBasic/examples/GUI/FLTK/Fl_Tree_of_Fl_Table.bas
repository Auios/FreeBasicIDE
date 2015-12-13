#include once "fltk-c.bi"
#include once "string.bi"

#ifndef PI
#define PI 3.14159
#endif

function DrawCellCB cdecl (byval self as any ptr,byval context as Fl_TableContext, _
                           byval r as long,byval c as long, _
                           byval x as long,byval y as long,byval w as long,byval h as long) as long
  dim as string mode
  dim as const zstring ptr pMode = Fl_WidgetGetUserData(self)
  if pMode then mode = *pMode
  select case as const context
  case FL_CONTEXT_STARTPAGE ' before page is drawn..
    DrawSetFont(FL_HELVETICA, 10) ' set the font for our drawing operations
  case FL_CONTEXT_COL_HEADER,FL_CONTEXT_ROW_HEADER
    dim as long value,colour
    dim as string header
    if (context=FL_CONTEXT_COL_HEADER) then
      value = c
      colour = Fl_TableGetColHeaderColor(self)
    else
      value = r
      colour = Fl_TableGetRowHeaderColor(self)
    end if
    if mode="SinCos" then
      header = format(value/10.0*PI,"0.000")
    else 
      header = str(value)
    end if
    DrawPushClip(x,y,w,h)
      DrawBox(BoxType(FL_THIN_UP_BOX),x,y,w,h,colour)
      DrawSetColor(FL_BLACK)
      DrawStrBox(header,x,y,w,h,FL_ALIGN_CENTER)
    DrawPopClip()
  case FL_CONTEXT_CELL
    dim as string cell="???"
    if mode = "Addition" then
      cell=str(r+c)
    elseif mode = "Subtract" then
      cell=str(r-c)
    elseif mode = "Multiply" then
      cell=str(r*c)
    elseif mode = "Divide" then
      if (c<>0) then cell = Format(r/c,"0.000") else cell = "N/A"
    elseif mode = "Exponent" then
      cell = str(r^c)
    elseif mode = "SinCos" then
      cell = Format ( sin(r/10.0*PI) * cos(c/10.0*PI),"0.000" ) 
    end if
    dim as long colour = iif(Fl_TableIsSelected(self,r,c),FL_YELLOW,FL_WHITE)
    DrawPushClip(x,y,w,h)
      DrawRectFillColor(x,y,w,h,colour)
      DrawSetColor(FL_GRAY0) 
      DrawStrBox(cell,x,y,w,h,FL_ALIGN_CENTER)
      DrawRectColor(x,y,w,h,Fl_WidgetGetColor(self))
    DrawPopClip()
  case else 
    return 0 ' let FLTK do the job
  end select

  return 1 ' we have done our job
end function

function ResizeCB cdecl (byval self as any ptr,byval x as long,byval y as long,byval w as long,byval h as long) as long
  if (w>718) then 
   w = 718 ' don't exceed 700 in width
   Fl_TableResize(self,x,y,w,Fl_WidgetGetH(self)) ' disallow changes in height
   return 1 ' ' we have done our job
  end if
  return 0 ' let FLTK do the job 
end function

function HandleCB cdecl (byval self as any ptr,byval event as Fl_Event) as long
  return Fl_TableExHandleBase(self,event)
end function

#macro AddTable(path,mode)
  ' create Fl_TableEx
  table = Fl_TableExNew(0,0,500,156)
  Fl_TableBegin(table) ' <-- optional (is done by the base constructor)
    ' setup row 
    Fl_TableSetRows(table,11)
    Fl_TableRowHeightAll(table,20)
    Fl_TableSetRowHeader(table,1)

    ' setup col
    Fl_TableSetCols(table,11)
    Fl_TableColWidthAll(table,60)
    Fl_TableSetColHeader(table,1)
    ' enable column resizing
    Fl_TableSetRowResize(table,0)

  Fl_TableEnd(table) ' <- !!! important !!! we must close the child list

  ' save string mode as user data
  Fl_WidgetSetUserData table,mode
  ' set DrawCell, Resize and Handle callback
  Fl_TableExSetDrawCellCB table,@DrawCellCB
  Fl_TableExSetHandleCB table,@HandleCB
  Fl_TableExSetResizeCB table,@ResizeCB
  ' add new tree item
  item = Fl_TreeAdd(tree,path)
  ' set table as tree item
  Fl_Tree_ItemSetWidget(item,table)
#endmacro

'
' main
'
var win = Fl_Double_WindowNew(700, 400, "Tree of tables")
Fl_WindowBegin win
  ' Create tree
  var tree = Fl_TreeNew(10, 10, Fl_WidgetGetW(win)-20,Fl_WidgetGetH(win)-20)
  Fl_Tree_ItemSetLabel Fl_TreeRoot(tree),"Math Tables"
  Fl_TreeSetItemLabelFont tree,FL_COURIER ' font to use for items
  Fl_TreeSetLineSpacing tree,12 ' extra space between items
  Fl_TreeSetItemDrawMode(tree,Fl_TreeGetItemDrawMode(tree)   or _ 
                              FL_TREE_ITEM_DRAW_LABEL_AND_WIDGET or _ ' draw item with widget() next to it 
                              FL_TREE_ITEM_HEIGHT_FROM_WIDGET)        ' make item height follow table's height

  Fl_TreeSetSelectMode(tree,FL_TREE_SELECT_NONE) ' font to use for items
  Fl_TreeSetWidgetMarginLeft(tree,12)            ' space between item and table
  Fl_TreeSetConnectorStyle(tree,FL_TREE_CONNECTOR_DOTTED)
  ' Create tables, assign each a tree item
  Fl_TreeBegin(tree)
    dim as Fl_TableEx   ptr table
    dim as Fl_Tree_Item ptr item
    AddTable(@"Arithmetic/Addition",@"Addition")
    AddTable(@"Arithmetic/Subtract",@"Subtract")
    AddTable(@"Arithmetic/Multiply",@"Multiply")
    AddTable(@"Arithmetic/Divide  ",@"Divide")
    AddTable(@"Misc/Exponent"      ,@"Exponent")
    AddTable(@"Misc/Sin*Cos "      ,@"SinCos")
  Fl_TreeEnd(tree)
Fl_WindowEnd win
Fl_WindowShow win
Fl_Run

