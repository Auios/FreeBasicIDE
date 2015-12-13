#include once "fltk-c.bi"

'test of:
' Fl_Tree_ItemSetWidget 

sub TreeCB cdecl (byval wgt as Fl_Widget ptr,byval tree as any ptr)
  var item = Fl_TreeGetCallbackItem(tree)
  if (item=0) then exit sub
  var label = Fl_Tree_ItemGetLabel(item)
  select case Fl_TreeGetCallbackReason(tree)
  case FL_TREE_REASON_SELECTED    : print "FL_TREE_REASON_SELECTED   " & *label
  case FL_TREE_REASON_DESELECTED  : print "FL_TREE_REASON_DESELECTED " & *label
  case FL_TREE_REASON_OPENED      : print "FL_TREE_REASON_OPENED     " & *label
  case FL_TREE_REASON_CLOSED      : print "FL_TREE_REASON_CLOSED     " & *label
  end select
end sub

sub ButtonCB cdecl (byval self as Fl_Widget ptr,byval btn as any ptr)
  ? "ButtonCB " & *Fl_WidgetGetLabel(self)
end sub
sub InputCB cdecl (byval self as Fl_Widget ptr,byval ip as any ptr)
  ? "InputCB "  & *Fl_Input_GetValue(ip)
end sub
sub SliderCB cdecl (byval self as Fl_Widget ptr,byval sld as any ptr)
  ? "SliderCB "  & int(Fl_ValuatorGetValue(sld)*100)
end sub

'
' main
'
var win = Fl_Double_WindowNew(160,128, "Fl_Tree03.bas")
Fl_WindowBegin(win)
  var tree = Fl_TreeNew(10,10,Fl_WidgetGetW(win)-20,Fl_WidgetGetH(win)-20)
  Fl_TreeSetShowRoot tree,0 ' don't show root of tree
  Fl_WidgetSetCallbackArg tree,@TreeCB,tree ' setup a callback for the treeview
  Fl_TreeBegin tree
    Fl_TreeAdd   tree,"Flintstones/Fred" ' add some items
    Fl_TreeAdd   tree,"Flintstones/Wilma"
    Fl_TreeAdd   tree,"Flintstones/Pebbles"
    Fl_TreeClose tree,"Flintstones"
    
    Fl_TreeAdd   tree,"Simpsons/Homer"
    Fl_TreeAdd   tree,"Simpsons/Marge"
    Fl_TreeAdd   tree,"Simpsons/Bart"
    Fl_TreeAdd   tree,"Simpsons/Lisa"
    Fl_TreeClose tree,"Simpsons"

    var InputItem  = Fl_TreeAdd(tree,"Widgets/Input")
    var InputGroup = Fl_GroupNew(0,0,120,16)
       var ip = Fl_InputNew(0,0,120,16)
       Fl_WidgetSetCallbackArg ip,@InputCB,ip
    Fl_GroupEnd InputGroup
    Fl_Tree_ItemSetWidget InputItem,InputGroup

    var ButtonItem  = Fl_TreeAdd(tree,"Widgets/Button")
    var ButtonGroup = Fl_GroupNew(0,0,120,16)
      var btn = Fl_ButtonExNew(0,0,120,16,"push me")
      Fl_WidgetSetCallbackArg btn,@ButtonCB,btn
    Fl_GroupEnd ButtonGroup
    Fl_Tree_ItemSetWidget ButtonItem,ButtonGroup

   var SliderItem  = Fl_TreeAdd(tree,"Widgets/Slider")
    var SliderGroup = Fl_GroupNew(0,0,120,16)
      var sld = Fl_Hor_SliderNew(0,0,120,16)
      Fl_WidgetSetCallbackArg sld,@SliderCB,sld
    Fl_GroupEnd SliderGroup
    Fl_Tree_ItemSetWidget SliderItem,SliderGroup
    Fl_TreeClose tree,"Widgets"
  Fl_TreeEnd tree
Fl_WindowEnd win
Fl_GroupSetResizable win,tree
Fl_WindowShow win
Fl_Run
