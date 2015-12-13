#include once "fltk-c.bi"

' test of class Fl_Preferences 
' http://www.fltk.org/doc-1.3/classFl__Preferences.html

const datasize = 4
dim as ubyte ptr outData = new ubyte[datasize]
for i as integer=0 to datasize-1
  outData[i]=i
next


' create a preferences file
var pref = Fl_PreferencesNew(FL_ROOT_USER,"vendor.xxx","myapp")

' write some integer values
for i as long=0 to 3
  Fl_PreferencesSetInt(pref,"key_i_" & i,i)
next

' write a float value
Fl_PreferencesSetFloat(pref,"key_f",123.4)
' write a double value
Fl_PreferencesSetDouble(pref,"key_d",123.456789)
' write a double with precision count of 10
Fl_PreferencesSetDouble2(pref,"key_d2",123.456789,10)
' write a string value
Fl_PreferencesSetString(pref,"key_s","i'm a string")

var group = Fl_PreferencesNewGroup(pref,"mygroup")
' write binary data to the group
Fl_PreferencesSetData(group,"key_bin",outData,datasize)
' close the pref
Fl_PreferencesDelete pref



' open a preferences db
pref = Fl_PreferencesNew(FL_ROOT_USER,"vendor.xxx","myapp")
' read some integers
dim as long iValue
for i as long = 0 to 3
  Fl_PreferencesGetInt(pref,"key_i_" & i,iValue,0)
  print iValue
next
' read a single value
dim as single fValue
Fl_PreferencesGetFloat(pref,"key_f",fValue,0.0)
print fValue
' read a double value
dim as double dValue
Fl_PreferencesGetDouble(pref,"key_d",dValue,0.0)
print dValue
' read a double value
Fl_PreferencesGetDouble(pref,"key_d2",dValue,0.0)
print dValue
' read a string value
dim as zstring ptr sValue = callocate(255)
Fl_PreferencesGetString(pref,"key_s",sValue,"")
print *sValue
deallocate sValue

' read binary data
dim as ubyte ptr inData
group = Fl_PreferencesNewGroup(pref,"mygroup")

Fl_PreferencesGetData(group,"key_bin",inData,outData,datasize)
for i as integer=0 to datasize-1: 
  print inData[i],
next
Fl_Free inData

Fl_PreferencesDelete pref

sleep


