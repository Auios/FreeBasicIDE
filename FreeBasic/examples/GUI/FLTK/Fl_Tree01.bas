#include once "fltk-c.bi"

'test of:
' Fl_Tree  http://www.fltk.org/doc-1.3/classFl__Tree.html

sub TreeCB cdecl (byval wgt as Fl_Widget ptr,byval tree as any ptr)
  dim as Fl_Tree_Item ptr item = Fl_TreeGetCallbackItem(tree)
  if (item=0) then exit sub
  print *Fl_Tree_ItemGetLabel(item);
  select case Fl_TreeGetCallbackReason(tree)
  case FL_TREE_REASON_SELECTED
    print " selected"
  case FL_TREE_REASON_DESELECTED
    print " deselected"
  case FL_TREE_REASON_OPENED
    print " opened"
  case FL_TREE_REASON_CLOSED
    print " closed"
  case else
    print "?"
  end select
end sub

'
' main
'
dim as Fl_Window ptr win = Fl_WindowNew(320,200, "Fl_Tree01.bas")
dim as Fl_Tree ptr tree = Fl_TreeNew(10,20,300,170,"Fl_Tree")
Fl_TreeSetShowRoot(tree,0)         ' don't show root of tree

Fl_TreeAdd(tree,"Flintstones/Fred") ' add some items
Fl_TreeAdd(tree,"Flintstones/Wilma")
Fl_TreeAdd(tree,"Flintstones/Pebbles")

Fl_TreeAdd(tree,"Simpsons/Homer")
Fl_TreeAdd(tree,"Simpsons/Marge")
Fl_TreeAdd(tree,"Simpsons/Bart")
Fl_TreeAdd(tree,"Simpsons/Lisa")
Fl_TreeClose(tree,"Simpsons") ' Start with one item closed

Fl_WidgetSetCallbackArg(tree,@TreeCB,tree) ' setup a callback for the treeview
Fl_WindowEnd(win)
Fl_GroupSetResizable(win,win)
Fl_WindowShow win
Fl_Run
