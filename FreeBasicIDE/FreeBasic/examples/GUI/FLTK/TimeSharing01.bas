#include once "fltk-c.bi"

sub DoSomeThing(v as double)
  while v: v*=.5 : wend
end sub

sub StuffCB cdecl (self as Fl_Widget ptr)
  Fl_WidgetDeactivate self               ' disable new trigger of button stuff callback
  var win = Fl_WidgetWindow(self)        ' get the window from widget
  var w = Fl_WidgetGetW(win)             ' get current size of the window
  var h = Fl_WidgetGetH(win)
  Fl_WidgetSize win,w,h+10+32            ' resize the window for a new widget
  
  Fl_WindowBegin win                     ' open the window child list 
  var prg = Fl_ProgressNew(10,h,w-20,32) ' add a progress widget (dynamical)
  Fl_WindowEnd win                       ' close the window child list

  const nLoops=500000 ' do any havy task
  dim as long oldValue,newValue,onePercent=nLoops\100
  for i as long = 1 to nLoops
    var s = sin(rnd())
    DoSomeThing(s) : newValue=i\onePercent
    ' update progress bar only if newValue are changed
    if newValue<>oldValue then
      var strValue = "find sense of life " & newValue & "% done."
      Fl_WidgetCopyLabel prg,strptr(strValue) ' set progress text
      Fl_WidgetSetSelectionColor prg,Fl_RGB_Color(200-newValue*2,newValue*2,0)
      Fl_WidgetSetLabelColor prg,FL_BLUE
      Fl_ProgressSetValue prg,newValue ' set progress value
      oldValue=newValue
    end if
    if i mod 100=0 then Fl_Wait2(0.001) ' time sharing
  next
  Fl_DeleteWidget prg    ' set progress widget on deletion list
  Fl_DoWidgetDeletion    ' delete all widgets on deletion list
  Fl_WidgetSize win,w,h  ' resize the window to old size 
  Fl_WidgetActivate self ' activate the stuff button
end sub

sub OtherCB cdecl (self as Fl_Widget ptr)
  static as long nTimes=0
  nTimes+=1 
  var label = "OtherCB called " & nTimes & " !"
  Fl_WindowSetLabel Fl_WidgetWindow(self),label

end sub

sub ExitCB cdecl (self as Fl_Widget ptr,btnStuff as any ptr)
  ' calculation running ?
  if Fl_WidgetActive(btnStuff)=0 then
    flMessageTitle "window close event."
    flAlert "note: stuff callback are running !"
  else
    Fl_WindowHide Fl_WidgetAsWindow(self)
  end if
end sub

'
' main
'
const GAB = 10
var win = Fl_WindowNew(400,44)
' button width
var bw = Fl_WidgetGetW(win)-3*GAB:bw\=2
' button height
var bh = Fl_WidgetGetH(win)-2*GAB
var btnStuff = Fl_ButtonNew(GAB*1+BW*0,GAB,BW,BH,"stuff")
var btnOther = Fl_ButtonNew(GAB*2+BW*1,GAB,BW,BH,"other")
Fl_WidgetSetCallback0 btnStuff,@StuffCB
Fl_WidgetSetCallback0 btnOther,@OtherCB
Fl_WidgetSetCallbackArg win,@ExitCB,btnStuff
Fl_WindowShow win
Fl_Run
