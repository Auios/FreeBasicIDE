#include once "fltk-tools.bi" ' for getGUIPath() and getGUIApp()

' test of class Fl_Preferences 
' http://www.fltk.org/doc-1.3/classFl__Preferences.html

' create a preferences db
dim as Fl_Preferences ptr db = Fl_PreferencesNew2(getGUIPath(),"vendor.xxx",getGUIApp())

' write in the default group "."
Fl_PreferencesSetString(db,"name","value")

' create a ".group" in the db
dim as Fl_Preferences ptr group = Fl_PreferencesNewGroup(db,"group")

' write some integer values
for i as long=0 to 3
  Fl_PreferencesSetInt(group,"i" & i,i)
next

' write a float value
Fl_PreferencesSetFloat(group,"f",123.4)
' write a double value
Fl_PreferencesSetDouble(group,"d",123.456789)
' write a double with precision count of 10
Fl_PreferencesSetDouble2(group,"d2",123.456789,10)
' write a string value
Fl_PreferencesSetString(group,"s","i'm a string")
' be sure all written
Fl_PreferencesFlush db
' close the db
Fl_PreferencesDelete db

' reopen a preferences db
db = Fl_PreferencesNew2(getGUIPath(),"vendor.xxx",getGUIApp())

' open a group
group = Fl_PreferencesNewGroup(db,"group")


' read some integers
dim as long iValue
for i as long=0 to 3
  Fl_PreferencesGetInt(group,"i" & i,iValue,0)
  print iValue
next
' read a single value
dim as single fValue
Fl_PreferencesGetFloat(group,"f",fValue,0.0)
print fValue
' read a double value
dim as double dValue
Fl_PreferencesGetDouble(group,"d",dValue,0.0)
print dValue
' read a double value
Fl_PreferencesGetDouble(group,"d2",dValue,0.0)
print dValue
' read a string value
dim as zstring ptr sValue = callocate(255)
Fl_PreferencesGetString(group,"s",sValue,"")
print *sValue
deallocate sValue
' close the db
Fl_PreferencesDelete db


sleep


