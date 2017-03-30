/' This is my first FreeBasic program. I thought it would be easy because
   I was sure that I would snatch some sample code and proceed on. Wrong!
   Extensive searches revealed a bit here and a bit there but always just
   a bit missing: and that bit always seemed to be enough to foil my efforts.
   
   Sitting on the other end of my serial cable is an Auduino Nano 
   microprocessor board. It is sitting there printing "Hello World!" once
   every second. All this program does is read the input from the com port 
   and print it to the screen. Pressing any key will cause the program to
   close the com port and exit. It is amazing how much time I wasted on this.
   
   It is implimented as a straight fall through process and one loop.
   Not overly efficent as its wastes lots of CPU time sitting in the loop
   polling for a character to come through. However it does have the advantage
   that it does work fairly reliably.
'/
 
#include "string.bi"         ' needed for format function
Dim LineCount As LongInt      ' just so we can see how many lines are read
Dim chrcount as Long 
Dim C As Byte               ' this is our incoming byte of data
Dim InBuffer As String         ' this is our buffer to collect the bytes
Dim PortStr as String
InBuffer=""                     
LineCount=0
chrcount=0

/' Any of these strings except the last will work 
   but the first is more reliable 
     Port = Com12
     Parity = none
     Data Bits = 8
     Stop bits = 1
     Carrier Detect Duration = 0
     Clear to Send duration = 0
     Data Set Ready duration = 0
     Open Timeout = 0
     Bin = Binary communications

    PortStr = "COM12:9600,N,8,1,CD,CS,DS,OP,BIN"
    PortStr = "COM12:9600,N,8,1,CD,CS,DS,OP,ASC,FE,TB0,RB0"
    PortStr = "COM12:9600,N,8,1,CD,CS,DS,OP"
    PortStr = "COM12:9600,N,8,1,CD,CS,DS"
    PortStr = "COM12:9600,N,8,1,CD,CS"    /' does not work for Arduino '/
    // Open Com ("COM12:9600,N,8,1,CD,CS,DS,OP,BIN") as #2 //
'/

PortStr = "COM12:9600,N,8,1,CD,CS,DS,OP,BIN"
Open Com(PortStr) AS #2
' loop untill there is a keypress ... any keypress
While InKey = ""
    ' This first line is one of the bits that was missing.
    ' It checks to see if there is anything waiting in the Serial buffer
    ' Without it you are subject to reading a bunch of garbage
    If Not(EOF(2)) then
        ' get a single byte from the serial port
        Get #2,0,C,1
        ' characters below ASCII 32 are 'non-printing characters
        ' characters above ASCII 126 are not define (by ASCII)
        ' append any printable character to the string 
        If (C > 31) and (C < 127) Then 
            InBuffer = InBuffer + Chr(C)
            ' chrcount is not really needed. I added it while trying
            ' to figure out why I was getting garbage ... before the
            ' EOF() check was added.
            chrcount=chrcount+1
        else
            ' ignore this character
        End If
        ' Linux/Unix terminate strings with a line feed (ASCII 10)
        ' MACs terminate lines with a carriage return (ASCII 13)
        ' Microsoft and Arduino use carriage return/linefeed (ASCII 13,10)
        ' If we get any of the above then increment the line count and
        ' print the string but only if we have something to print.
        If ((C=13) Or (C=10)) And  (chrcount >0) Then 
            LineCount = LineCount + 1
            Print  Format(LineCount,"000000") +" ("+ Format(chrcount,"000") + "):  " + Inbuffer
            ' clear the buffer so that we can do it again
            InBuffer=""
            chrcount=0
        End If
    End If
    ' Call Sleep with 25ms or less to release time-slice when waiting 
    ' for user input or looping inside a thread.This will prevent the program 
    ' from unnecessarily hogging the CPU.
    Sleep 25
Wend

' we opened it, we close it
Close #2

' you'all come back, ya hear?
End