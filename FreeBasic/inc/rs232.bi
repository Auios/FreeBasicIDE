#ifndef __CLASS_RS232__
#define __CLASS_RS232__

#include "windows.bi"

#define RS232_OPEN    0
#define RS232_CLOSE   1
#define RS232_DATA_TX 2
#define RS232_DATA_RX 3

#define OBJECT_IN_DATA   0
#define OBJECT_OUT_DATA  1
#define OBJECT_IN_DONE   2
#define OBJECT_OUT_DONE  3
#define OBJECT_CLOSE     4

type RS232
  enum 
   _NO_
   _ODD_
   _EVEN_
   _MARK_
   _SPACE_
  end enum
  enum
   _STOP_1_
   _STOP_1_5_
   _STOP_2_
  end enum

  private:
  as HANDLE  hDevice
  as HANDLE  hEvents(4)
  as any ptr ThreadID

  ' TX
  as integer IsTXActive
  as OVERLAPPED OverlappedRX
  as any ptr pOutBuffer
  as integer OutBufferBytes
  as integer OutBufferSize
  
  ' RX
  as integer ISRXActive
  as OVERLAPPED OverlappedTX
  as any ptr pInBuffer
  as integer InBufferBytes
  as integer InBufferSize
  as integer UseInBufferSize

  public:
  declare constructor
  declare destructor
  declare sub      Run
  declare function Open(byval ParamPort     as integer, _
                        byval ParamBaud     as uinteger = CBR_9600, _
                        byval ParamParity   as integer =  _NO_, _
                        byval ParamBits     as integer =    8, _
                        byval ParamStopBits as integer = _STOP_1_) as boolean
  declare function Close() as boolean
  declare function SetUseInBufferSize(byval Size as integer) as boolean
  declare function Send(byval pBuffer as any ptr,byval Size as integer) as boolean
  declare function GetInBytes() as integer
  declare function GetInBuffer() as any ptr
  declare function SetInBufferEmpty() as boolean
  declare function EnableDTR(byval state as boolean) as boolean
  declare function EnableRTS(byval state as boolean) as boolean
  EventError   as sub (ErrMsg as string)
  EventOpen    as sub ()
  EventClose   as sub ()
  EventSend    as sub (byval size    as integer)
  EventReceive as sub (byval pBuffer as ubyte ptr,byval size as integer)
end type

#endif '  __CLASS_RS232__