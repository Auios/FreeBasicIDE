#include once "fltk-tools.bi" ' for EventAsString

' test of:
' Fl_TreeSetOpenIcon
' Fl_TreeSetCloseIcon
' Fl_TreeClose

sub TreeCB cdecl (byval self as Fl_Widget ptr,byval tree as any ptr)
  if Fl_TreeGetCallbackReason(tree)=FL_TREE_REASON_SELECTED then
    var item = Fl_TreeGetCallbackItem(tree)
    Fl_WidgetCopyLabel self,Fl_Tree_ItemGetLabel(item)
    Fl_WidgetRedraw Fl_WidgetWindow(self)
  end if
end sub

'
' main
'
ChDir ExePath()

Fl_Register_Images() ' be sure png,jpg ... loader's are reistered

var win = Fl_WindowNew(200,200, "Fl_Tree04.bas")
Fl_WindowBegin win
  var tree = Fl_TreeNew(10,24,Fl_WidgetGetW(win)-20,Fl_WidgetGetH(win)-34,"slecet an item ...")
  Fl_TreeBegin tree
    Fl_WidgetSetCallbackArg tree,@TreeCB,tree
    Fl_TreeSetOpenIcon      tree,Fl_Shared_ImageGet("themes/default/Tree_closed_9x9.png")
    Fl_TreeSetCloseIcon     tree,Fl_Shared_ImageGet("themes/default/Tree_open_9x9.png")
    Fl_TreeRootLabel        tree,"FreeBASIC Ltd."
    for nCountry as integer = 1 to 3
      var country = "/Country " & nCountry 
      for nCity    as integer = 1 to 4
        var city = country & "/City " & nCity
        for nShop    as integer = 1 to 2
          var shop = city & "/Shop " & nShop
          for nGroup   as integer = 1 to 3
            var group = shop & "/Group " & nGroup
            for nItem    as integer = 1 to 5
              var item = group & "/Item " & nItem
              'print "Fl_TreeAdd tree," & item
              Fl_TreeAdd tree, item
            next
          next
        next
        Fl_TreeClose tree, country
      next
    next
    Fl_TreeClose tree,"FreeBASIC Ltd."
  Fl_TreeEnd tree
Fl_WindowEnd win
Fl_WindowShow win
Fl_Run
