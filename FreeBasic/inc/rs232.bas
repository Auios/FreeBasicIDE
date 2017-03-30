#include "RS232.bi"

private sub EventStart(byval param as any ptr)
  if param=NULL then return
  cptr(RS232 ptr,param)->Run()
end sub

constructor RS232
  hDevice        = cptr(HANDLE,INVALID_HANDLE_VALUE)
  InBufferSize   = 256
  OutBufferSize  = 256
  UseInBufferSize= 1
  pInBuffer      = callocate(InBufferSize)
  pOutBuffer     = callocate(OutBufferSize)
  hDevice        = cptr(HANDLE,INVALID_HANDLE_VALUE)
  hEvents(OBJECT_IN_DATA ) = CreateEvent(NULL, TRUE , FALSE, NULL)
  hEvents(OBJECT_OUT_DATA) = CreateEvent(NULL, TRUE , FALSE, NULL)
  hEvents(OBJECT_IN_DONE ) = CreateEvent(NULL, FALSE, FALSE, NULL)
  hEvents(OBJECT_OUT_DONE) = CreateEvent(NULL, FALSE, FALSE, NULL)
  hEvents(OBJECT_CLOSE   ) = CreateEvent(NULL, FALSE, FALSE, NULL)
end constructor


destructor RS232
  for i as integer = 0 to 4
    if (hEvents(i)<>INVALID_HANDLE_VALUE) then
      CloseHandle(hEvents(i))
    end if
  next
  if (hDevice<>INVALID_HANDLE_VALUE) then
    CloseHandle(hDevice)
  end if
  if pInBuffer <>0 then deallocate(pInBuffer)
  if pOutBuffer<>0 then deallocate(pOutBuffer)
end destructor

function RS232.Close() as boolean
  if (hDevice=INVALID_HANDLE_VALUE) then 
    if (EventError<>0) then EventError("Close() failed (hDevice=INVALID_HANDLE_VALUE) !")
    return false
  end if
  if hEvents(OBJECT_CLOSE)=INVALID_HANDLE_VALUE then 
    if (EventError<>0) then EventError("Close() failed hEvents(OBJECT_CLOSE)=INVALID_HANDLE_VALUE !")
    return false
  end if
  SetEvent(hEvents(OBJECT_CLOSE))
  return true
end function

function RS232.Open(byval ParamPort     as integer, _
                    byval ParamBaud     as uinteger, _
                    byval ParamParity   as integer, _
                    byval ParamBits     as integer, _
                    byval ParamStopBits as integer) as boolean

  if (hDevice<>INVALID_HANDLE_VALUE) then 
    CloseHandle(hDevice)
    hDevice=cptr(HANDLE,INVALID_HANDLE_VALUE)
  end if
  
  hDevice=CreateFile(!"\\\\.\\COM" & str(ParamPort), _
                     GENERIC_READ or GENERIC_WRITE, _
                     0, _
                     NULL, _
                     OPEN_EXISTING, _
                     FILE_FLAG_OVERLAPPED, _
                     NULL)
  if hDevice=INVALID_HANDLE_VALUE then
    if (EventError<>0) then EventError("CreateFile() failed !")
    return false
  end if

  ' configure the device
  dim as COMMPROP     Properties
  dim as COMMTIMEOUTS TimeOuts
  dim as DCB          DeviceConfig

  if     ParamBaud <    CBR_300 then
    ParamBaud=CBR_110
  elseif ParamBaud <    CBR_600 then
    ParamBaud=CBR_300
  elseif ParamBaud <   CBR_1200 then
    ParamBaud=CBR_600
  elseif ParamBaud <   CBR_2400 then
    ParamBaud=CBR_1200
  elseif ParamBaud <   CBR_4800 then
    ParamBaud=CBR_2400
  elseif ParamBaud <   CBR_9600 then
    ParamBaud=CBR_4800
  elseif ParamBaud <  CBR_14400 then
    ParamBaud=CBR_9600
  elseif ParamBaud <  CBR_19200 then
    ParamBaud=CBR_14400
  elseif ParamBaud <  CBR_38400 then
    ParamBaud=CBR_19200
  elseif ParamBaud <  CBR_57600 then
    ParamBaud=CBR_38400
  elseif ParamBaud < CBR_115200 then
    ParamBaud=CBR_57600
  elseif ParamBaud < CBR_128000 then
    ParamBaud=CBR_115200
  elseif ParamBaud < CBR_256000 then
    ParamBaud=CBR_128000
  elseif ParamBaud < 512000 then
    ParamBaud=CBR_256000
  else
    ' on real COM ports CBR_256000 is the max
    ' but on USB<->serial devices higher baudrates are possible
  end if

  ' get the default config from device manager at first
  DeviceConfig.DCBlength = SizeOf(DCB)
  if GetCommState(hDevice,@DeviceConfig)=0 then
    CloseHandle(hDevice)
    hDevice = cptr(HANDLE,INVALID_HANDLE_VALUE)
    if (EventError<>0) then EventError("GetCommState() failed !")
    return false
  end if

  ' setup in/out buffer size
  if SetupComm(hDevice,InBufferSize,OutBufferSize)=0 then 
    CloseHandle(hDevice)
    hDevice = cptr(HANDLE,INVALID_HANDLE_VALUE)
    if (EventError<>0) then EventError("SetupComm() failed !")
    return false
  end if

  ' first disable all HW events
  if SetCommMask(hDevice,0) =0 then
    CloseHandle(hDevice)
    hDevice = cptr(HANDLE,INVALID_HANDLE_VALUE)
    if (EventError<>0) then EventError("SetCommMask() failed !")
    return false
  end if

  ' setup time outs
  if SetCommTimeouts(hDevice,@TimeOuts)=0 then
    CloseHandle(hDevice)
    hDevice = cptr(HANDLE,INVALID_HANDLE_VALUE)
    if (EventError<>0) then EventError("SetCommTimeouts() failed !")
    return false
  end if

  ' setup our parameters
  with DeviceConfig
    .fBinary     = 1                 ' on Windows it must be binary
    .BaudRate    = ParamBaud         ' CBR_XXXX
    .Parity      = ParamParity       ' _NO_ , _ODD_ , _EVEN__
    .StopBits    = ParamStopBits     ' _STOP_1_, _STOP_1_5, _STOP_2_
    .ByteSize    = ParamBits         ' 5,6,7 and 8
    .fDtrControl = DTR_CONTROL_DISABLE
    .fRtsControl = RTS_CONTROL_DISABLE
  end with

  if SetCommState(hDevice,@DeviceConfig)=0 then
    CloseHandle(hDevice)
    hDevice = cptr(HANDLE,INVALID_HANDLE_VALUE)
    if (EventError<>0) then EventError("SetCommState() failed !")
    return false
  end if

  OverLappedRX.hEvent = hEvents(OBJECT_IN_DATA)
  OverLappedTX.hEvent = hEvents(OBJECT_OUT_DATA)
  ThreadID            = ThreadCreate(@EventStart,@this)
  return true
end function

function RS232.SetUseInBufferSize(byval Size as integer) as boolean
  if Size>0 then
    if Size>InBufferSize then
      UseInBufferSize=InBufferSize
    else
      UseInBufferSize=Size
    end if
    return true
  end if
  if (EventError<>0) then EventError("SetUseInBufferSize() size<0 !")
  return false
end function

function RS232.GetInBuffer() as any ptr
  return pInBuffer
end function

function RS232.GetInBytes() as integer
  return InBufferBytes
end function

function RS232.SetInBufferEmpty() as boolean
  if hDevice=INVALID_HANDLE_VALUE then 
    if (EventError<>0) then EventError("SetInBufferEmpty() failed hDevice=INVALID_HANDLE_VALUE !")
    return false
  end if
  InBufferBytes=0
  if hEvents(OBJECT_IN_DONE)=INVALID_HANDLE_VALUE then
    if (EventError<>0) then EventError("SetInBufferEmpty() failed hEvents(OBJECT_IN_DONE)=INVALID_HANDLE_VALUE !")
    return false
  end if
  SetEvent(hEvents(OBJECT_IN_DONE))
  return true
end function

function RS232.Send(byval pBuffer as any ptr,byval BufferSize as integer) as boolean
  if hDevice = INVALID_HANDLE_VALUE then
    if (EventError<>0) then EventError("Send() failed hDevice = INVALID_HANDLE_VALUE !") 
    return false
  end if
  if hEvents(OBJECT_OUT_DONE)=INVALID_HANDLE_VALUE then
    if (EventError<>0) then EventError("Send() failed hEvents(OBJECT_OUT_DONE)=INVALID_HANDLE_VALUE !") 
    return false
  end if
  if BufferSize<1 then
    if (EventError<>0) then EventError("Send() failed BufferSize<1 !") 
    return false
  end if
  if pBuffer =0 then
    if (EventError<>0) then EventError("Send() failed Buffer=NULL !") 
    return false
  end if

  if (IsTXActive = 0) then
    IsTXActive = 1
    dim as ubyte ptr pSrc=pBuffer
    dim as ubyte ptr pDes=pOutBuffer
    OutBufferBytes=BufferSize
    for i as integer=0 to OutBufferBytes-1
      pDes[i] = pSrc[i]
    next
    SetEvent(hEvents(OBJECT_OUT_DONE))
  end if
  return true
end function


function RS232.EnableDTR(byval state as boolean) as boolean
  if hDevice=INVALID_HANDLE_VALUE then 
    if (EventError<>0) then EventError("EnableDTR() failed hDevice=INVALID_HANDLE_VALUE !") 
    return false
  end if
  EscapeCommFunction(hDevice,iif(state,SETDTR,CLRDTR))
  return true
end function

function RS232.EnableRTS(byval state as boolean) as boolean
  if hDevice=INVALID_HANDLE_VALUE then
    if (EventError<>0) then EventError("EnableRTS() failed hDevice=INVALID_HANDLE_VALUE !") 
    return false
  end if
  EscapeCommFunction(hDevice,iif(state,SETRTS,CLRRTS))
  return true
end function

sub RS232.Run()
  if hDevice=INVALID_HANDLE_VALUE then return
  IsTXActive = 0
  IsRXActive = 0
  GetLastError()
  if (EventOpen<>0) then EventOpen()
  SetEvent(hEvents(OBJECT_IN_DONE))
  dim as integer nBytes
  dim as boolean blnRun=true
  while blnRun=true
    dim as integer result = WaitForMultipleObjects(5,@hEvents(0),FALSE,INFINITE) - WAIT_OBJECT_0
    if result<0 or result>4 then
      if (EventError<>0) then EventError("WaitForMultipleObjects() failed wrong result !") 
      blnRun=false
    else
      select case as const result
      case OBJECT_CLOSE
        blnRun=false
      case OBJECT_IN_DONE
        if (IsRXActive=0) then
          IsRXActive = 1
          if 0=ReadFile(hDevice,pInBuffer,UseInBufferSize,@nBytes,@OverlappedRX) then
            if (GetLastError() <> ERROR_IO_PENDING ) then
              if (EventError<>0) then EventError(" ReadFile() failed !") 
              blnRun=false
            end if 
          end if
        end if

      case OBJECT_IN_DATA
        if GetOverlappedResult(hDevice,@OverlappedRX,@nBytes, FALSE) then
          ResetEvent(hEvents(OBJECT_IN_DATA))
          IsRXActive = 0
          if (nBytes>0) andalso (EventReceive<>0) then
            InBufferBytes=nBytes
            EventReceive(pInBuffer,nBytes)
            nBytes=0
          end if
          SetEvent(hEvents(OBJECT_IN_DONE))
        elseif (GetLastError()<>ERROR_IO_PENDING) then
          if (EventError<>0) then EventError("GetOverlappedResult(RX) failed ! " & GetLastError()) 
          blnRun=false
        end if

      case OBJECT_OUT_DONE
        if WriteFile(hDevice,pOutBuffer,OutBufferBytes,@nBytes,@OverlappedTX) then
          OutBufferBytes-=nBytes
          nBytes=0
        elseif (GetLastError() <> ERROR_IO_PENDING ) then
          if (EventError<>0) then EventError("WriteFile() failed ! ") 
          blnRun=false
        end if

      case OBJECT_OUT_DATA
        if (GetOverlappedResult(hDevice,@OverlappedTX,@nBytes,FALSE)) then
          if (EventSend<>0) then EventSend(nBytes)
          nBytes=0
          ResetEvent(hEvents(OBJECT_OUT_DATA))
          IsTXActive = 0
        elseif (GetLastError() <> ERROR_IO_PENDING) then
          if (EventError<>0) then EventError("GetOverlappedResult(TX) failed ! ") 
          blnRun=false
        end if
      end select
    end if
  wend

  if (hDevice<>INVALID_HANDLE_VALUE) then
    CloseHandle(hDevice)
    hDevice = cptr(HANDLE,INVALID_HANDLE_VALUE)
    if (EventClose<>0) then Eventclose()
  end if

end sub