' test01.bas
#include "RS232.bas"

sub OpenCB()
  print
  print "device open event"
  print
end sub

sub CloseCB()
  print
  print "device close event"
  print
end sub

sub ErrorCB(msg as string)
  print
  print "ups: an error " & msg
  print
end sub

sub SendCB(byval Size as integer)
  print
  print "device send event " & size & " bytes."
  print
end sub

sub ReceiveCB(byval pBuffer as ubyte ptr, byval size as integer)
  print "device receive event"
  print "rx: ";
  for i as integer=0 to size-1
    print chr(pBuffer[i]);
  next
  print
end sub



dim as RS232 Com

' optional set your callback's
Com.EventOpen    = @OpenCB
Com.EventClose   = @CloseCB
Com.EventError   = @ErrorCB
Com.EventSend    = @SendCB
Com.EventReceive = @ReceiveCB

' open COM1 with 2400 bps
if Com.Open(1,2400)=false then
  print "error: can't open RS232 !"
  beep : sleep : end 
end if

dim as string txt="hello RS232"
Com.Send(strptr(txt),len(txt))

while inkey=""
  
  sleep 1000
  
wend
Com.Close