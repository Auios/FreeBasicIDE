/'
// FBArduino01
#define LED 13

void setup() {
  // initialize serial communication at 9600 bits per second
  Serial.begin(9600);
  // wait for serial port to connect.
  while (!Serial) ;

  // make the LED pin as output
  pinMode(LED,OUTPUT);
}

// the loop routine runs over and over again forever:
void loop() {
  digitalWrite(LED, HIGH);
  Serial.println("LED on");
  delay(1000);

  digitalWrite(LED, LOW);
  Serial.println("LED off");
  delay(1000);
}
'/

' fbarduion01.bas
#include "RS232.bas"

#define COMPORT    3 ' <--- !!! define your Arduino COM port here !!!
#define BAUDRATE 9600 ' use the same serial speed as in your arduino sketch

dim shared as RS232 Serial

' NOTE: On all Windows OS's the serial device works in binary mode only.
' So if you waiting for a complete string you have to collect all
' incomming data until chr(10) !"\n" are received.
sub ReceiveStringCB(byval buffer as ubyte ptr, byval size as integer)
  static as string msg
  dim as boolean StringComplete
  dim as integer n
  ' copy chars from buffer to string
  while n<size
    ' it's not a printable char
    if buffer[n]<32 then
      ' it's a new line/string char
      if buffer[n]=asc(!"\n") then
        StringComplete=true 
        exit while
      end if
    else
      msg &= chr(buffer[n])
    end if
    n+=1
  wend
  if StringComplete then
    line (0,12)-step(639,8),0,BF
    draw string (0,12),"arduino says: " & msg
    if instr(msg,"on") then
       circle (320,240),100,2,,,,F
    else
       circle (320,240),100,0,,,,F
    end if
    circle (320,240),100,15
    msg=""
  end if
end sub

' faked arduino Setup() style
sub Setup constructor
  screenres 640,480
  Serial.EventReceive = @ReceiveStringCB
  if Serial.Open(COMPORT,BAUDRATE)=false then
    draw string (0,0),"error: can't open RS232 at COM" & COMPORT & ":"
    beep : sleep : end 1
  else
    draw string (0,0),"press [ESC] to quit ..."
  end if
end sub

dim as boolean quit
while quit=false
  var char = inkey()
  if char=chr(27) then quit=true
  sleep 200
wend

Serial.Close()