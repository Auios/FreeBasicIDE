' ard1.bas

' test talking to arduino

    #include "string.bi"         ' needed for format function
    Dim LineCount As LongInt      ' just so we can see how many lines are read
    Dim chrcount as Long
    Dim inchar As Byte               ' this is our incoming byte of data
    Dim InBuffer As String         ' this is our buffer to collect the bytes
    Dim PortStr as String
    InBuffer=""
    LineCount=0
    chrcount=0


dim as integer filnum
filnum = freefile

    PortStr = "COM12:9600,N,8,1,CD,CS,DS,OP,BIN"


    shell "stty -F /dev/ttyUSB0 speed 9600 -clocal -hupcl"
    sleep 1000
    open com "/dev/ttyUSB0:9600,n,8,1,cs0,cd0,ds0,rs" as #filnum

    sleep 1000, 1

    ' loop until there is a keypress ... any keypress
    while inkey <> "" : wend
do
        If Not(EOF(filnum)) then
            ' get a single byte from the serial port
            Get #filnum,0,inchar,1
            ' characters below ASCII 32 are 'non-printing characters
            ' characters above ASCII 126 are not define (by ASCII)
            ' append any printable character to the string
            If (inchar > 31) and (inchar < 127) Then
                InBuffer = InBuffer + Chr(inchar)
                chrcount=chrcount+1
            else
                ' ignore this character
            End If
            ' Linux/Unix terminate strings with a line feed (ASCII 10)
            ' MACs terminate lines with a carriage return (ASCII 13)
            ' Microsoft and Arduino use carriage return/linefeed (ASCII 13,10)
            ' If we get any of the above then increment the line count and
            ' print the string but only if we have something to print.
            If ((inchar=13) Or (inchar=10)) And  (chrcount >0) Then
                LineCount = LineCount + 1
                Print  Format(LineCount,"000000") +" ("+ Format(chrcount,"000") + "):  " + Inbuffer
                ' clear the buffer so that we can do it again
                InBuffer=""
                chrcount=0
            End If
        End If
        Sleep 25, 1
    if inkey <> "" then exit do
loop
    Close #filnum

    End