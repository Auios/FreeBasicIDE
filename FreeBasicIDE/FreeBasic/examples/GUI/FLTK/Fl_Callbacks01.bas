#include once "fltk-c.bi"

' you can set for each widget callback's and there are 3 kinds of callbacks

' Callback with an pointer as user argument sub cecl callback(widget as FL_WIDGET ptr, pUserData as any ptr)
' Fl_WidgetSetCallback widget,@Callback
' Fl_WidgetSetCallbackArg widget,@Callback,pArg

' Callback0 without an argument sub cecl callback(widget as FL_WIDGET ptr)
' Fl_WidgetSetCallback0 widget,@Callback

' Callback1 with an long as user argument sub cecl callback(widget as FL_WIDGET ptr, UserData as long)
' Fl_WidgetSetCallback1Arg widget,@Callback,value

sub Callback cdecl (byval widget as FL_WIDGET ptr,byval pUserData as any ptr)
  print "Callback with ptr arg " & *Fl_WidgetGetLabel(widget) & " , 0x"  & hex(pUserData,8)
end sub

sub Callback1 cdecl (byval widget as FL_WIDGET ptr,byval UserData as long)
  print "Callback with long arg " & *Fl_WidgetGetLabel(widget) & " , "  & UserData
end sub

sub Callback0 cdecl (byval widget as FL_WIDGET ptr)
  print "Callback without arg " & *Fl_WidgetGetLabel(widget)
end sub
'
' main
'
Fl_SetScheme "gleam"
var win  = Fl_WindowNew(250,50,"Fl_Callbacks")
var btn1 = Fl_ButtonNew( 10,10,70,30,"button 1")
var btn2 = Fl_ButtonNew( 90,10,70,30,"button 2")
var btn3 = Fl_ButtonNew(170,10,70,30,"button 3")

Fl_WidgetSetCallbackArg  btn1,@Callback,btn1
Fl_WidgetSetCallback0    btn2,@Callback0
Fl_WidgetSetCallback1Arg btn3,@Callback1,123


Fl_WindowShow win
Fl_Run
