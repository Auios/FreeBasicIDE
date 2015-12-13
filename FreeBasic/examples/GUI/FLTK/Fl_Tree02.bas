#include once "fltk-c.bi"

'test of:
' Fl_Tree  http://www.fltk.org/doc-1.3/classFl__Tree.html

sub TreeCB cdecl (byval wgt as Fl_Widget ptr,byval pdata as any ptr)
  dim as Fl_Tree ptr tr = cptr(Fl_Tree ptr,wgt)
  dim as Fl_Tree_Item ptr item = Fl_TreeGetCallbackItem(tr)
  if (item=0) then exit sub
  
  dim as const zstring ptr label = Fl_Tree_ItemGetLabel(item)
  select case Fl_TreeGetCallbackReason(tr)
  case FL_TREE_REASON_SELECTED    : print "FL_TREE_REASON_SELECTED   " & *label
  case FL_TREE_REASON_DESELECTED  : print "FL_TREE_REASON_DESELECTED " & *label
  case FL_TREE_REASON_OPENED      : print "FL_TREE_REASON_OPENED     " & *label
  case FL_TREE_REASON_CLOSED      : print "FL_TREE_REASON_CLOSED     " & *label
  end select
end sub

'
' main
'
var win = Fl_WindowNew(320,200, "Fl_Tree02.bas")
var tr = Fl_TreeNew(10,20,300,170,"Fl_Tree")
Fl_TreeSetShowRoot(tr,0)         ' don't show root of tree

Fl_TreeAdd(tr,"Flintstones/Fred") ' add some items
Fl_TreeAdd(tr,"Flintstones/Wilma")
Fl_TreeAdd(tr,"Flintstones/Pebbles")

Fl_TreeAdd(tr,"Simpsons/Homer")
Fl_TreeAdd(tr,"Simpsons/Marge")
Fl_TreeAdd(tr,"Simpsons/Bart")
Fl_TreeAdd(tr,"Simpsons/Lisa")

Fl_TreeClose(tr,"Simpsons") ' Start with one item closed

Fl_TreeAdd(tr,!"Pathnames/\\/bin")              ' front slashes
Fl_TreeAdd(tr,!"Pathnames/\\/usr\\/sbin")
Fl_TreeAdd(tr,!"Pathnames/C:\\\\Program Files") ' backslashes
Fl_TreeAdd(tr,!"Pathnames/C:\\\\Documents and Settings")

Fl_WidgetSetCallback(tr,@TreeCB) ' setup a callback for the treeview

Fl_WindowEnd(win)
Fl_GroupSetResizable(win,win)
Fl_WindowShow win
Fl_Run
