/'
int serialData = 0;

void setup()
{
  Serial.begin(9600); 
  pinMode(13,OUTPUT); 
}

void loop()
{
  if (Serial.available() > 0)
  {
    serialData = Serial.read();
    if (serialData == 97)
       digitalWrite(13,HIGH);

    if (serialData == 98)
       digitalWrite(13,LOW);
    
    Serial.println(serialData);  // return data
  }
}
'/

Dim Shared As String   Key, buffer

Cls

Open Com "COM9:9600,n,8,1,cs0,ds0,cd0,rs" As #1
If Err <> 0 Then
   Print "Error opening COM9"
   Sleep 2000,1
   Cls
   end
End If

Do
   Key = InKey

   If Key <> "" Then
      If Key = Chr(13) Then   ' Check for CR
         Print #1, Chr(13);   ' Send CR
      Else
         Print #1,Key;
      End If
   End If

   ' When used with a serial device, LOC returns the number of bytes
   ' waiting to be read from the serial device's input buffer.
   While LOC(1) > 0
      buffer = Input(LOC(1),#1)
      Print buffer;
   Wend

   Sleep 1
Loop until Key=chr(27)


Close #1

sleep