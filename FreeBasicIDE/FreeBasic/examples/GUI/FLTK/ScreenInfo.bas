#include once "fltk-c.bi"

' test of:
' Fl_ScreenDpi
' Fl_ScreenXYWH

'
' main
'
dim as single dw,dh,iw,ih,cw,ch
dim as long px,py,pw,ph
Fl_ScreenDpi dw,dh
Fl_ScreenXYWH px,py,pw,ph
iw=pw/dw   : ih=ph/dh
cw=iw*2.54 : ch=ih*2.54
print "Resolution : " & pw & " x " & ph & " pixel"
print "Screen     : " & dw & " x " & dh & " dpi"
print "Screen     : " & iw & " x " & ih & " inch"
print "Screen     : " & cw & " x " & ch & " cm"
print "Monitor    : " & sqr(iw*iw+ih*ih) & " inches"
sleep

