#include once "fltk-c.bi"

sub TreeCB cdecl (byval widget as Fl_Widget ptr,byval tree as any ptr)
  Fl_TreeSetConnectorColor tree,Fl_RGB_Color(rnd*255,rnd*255,rnd*255)
  Fl_TreeSetConnectorStyle tree,cast(Fl_Tree_Connector,int(rnd*3))
  Fl_TreeSetSelectBox      tree,Boxtype(1+int(rnd*54))

  var item = Fl_TreeGetCallbackItem(tree)
  if item=0 then return 

  ' change properties of selected item
  item->_labelfont   =   rnd*14
  item->_labelsize   =12+rnd*20
  item->_labelfgcolor=Fl_RGB_Color(rnd*255,rnd*255,rnd*255)
  item->_labelbgcolor=Fl_RGB_Color(rnd*255,rnd*255,rnd*255)

  var nChilds = item->_children._total
  if nChilds<1 then return 

  ' change child properties of selected item
  for index as long = 0 to nChilds-1
    var child =item->_children._items[index]
    child->_labelfont   =   rnd*14
    child->_labelfont   =   rnd*14
    child->_labelsize   =12+rnd*20
    child->_labelfgcolor=Fl_RGB_Color(rnd*255,rnd*255,rnd*255)
    child->_labelbgcolor=Fl_RGB_Color(rnd*255,rnd*255,rnd*255)
  next
  Fl_WidgetRedraw tree
end sub
'
' main
'
Fl_SetScheme "gleam"
Fl_Background 128,128,128
var win  = Fl_Double_WindowNew(200,400)
var tree = Fl_TreeNew(Fl_WidgetGetX(win)+10,Fl_WidgetGetY(win)+10,Fl_WidgetGetW(win)-20,Fl_WidgetGetH(win)-20)
Fl_TreeSetShowRoot tree,0 ' don't show root of tree
Fl_WidgetSetCallbackArg tree,@TreeCB,tree
Fl_TreeBegin tree
  dim as integer root,parent,child
  for i as integer=1 to 20
    if rnd<0.25 then
      root+=1:child=1
    elseif rnd<0.5 then
      parent+=1:child=1
    else
      child+=1
    end if
    Fl_TreeAdd tree,"root " & root & "/parent " & parent & "/ Item " & child
  next
Fl_TreeEnd tree

Fl_GroupSetResizable win,tree
Fl_WindowShow win
Fl_Run
