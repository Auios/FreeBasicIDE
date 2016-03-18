#include "MysoftFmod.bi"
#include "windows.bi"
#include "crt.bi"
#include "fbgfx.bi"

dim shared as string FOLDER,FILENAME
'FILENAME = "H:/Mp3/beat1.mp3"
FOLDER = "H:\Mp3\Ayreon\9+"

FSOUND_Init( 44100 , 16 , FSOUND_INIT_ACCURATEVULEVELS )
' Enabling FFT so Spectrum(VU) will work
var pFFT = FSOUND_DSP_GetFFTUnit()
FSOUND_DSP_SetActive(pFFT, 1)

' Get pointer to array of FLOATS (512) for the spectrum range
var pfVU = FSOUND_DSP_GetSpectrum()


const VuLevels = int(80\4)-1
dim as integer iMaxLVL(VuLevels),iLastLVL(VuLevels)
dim as string sBar = "###",sBlank="   "
dim as double TMR = timer
dim as integer iLoop = FSOUND_LOOP_NORMAL

locate 24,1: color 1
for CNT as integer = 0 to VuLevels
  iLastLVL(CNT) = 20
  print sBar+" ";
next CNT

if len(FOLDER) then 
  if FOLDER[len(FOLDER)-1] <> asc("\") then
    if FOLDER[len(FOLDER)-1] <> asc("/") then
      FOLDER += "/"
    end if
  end if
  FILENAME = dir$(FOLDER+"*.mp3")
  iLoop = FSOUND_LOOP_OFF
end if

while len(FILENAME)

  SetConsoleTitle("VuTest: '"+FILENAME+"'")
  var MyMusic = FSOUND_Stream_Open(FOLDER+FILENAME,iLoop,0,0)
  var iDuration = FSOUND_Stream_GetLengthMs(MyMusic)
  
  var iChan = FSOUND_Stream_Play(FSOUND_FREE,MyMusic)
  
  do
    locate 1,1,0: color 15
    var iMS = FSOUND_Stream_GetTime(MyMusic)
    var iMinute = iMS\(1000*60) mod 60
    var iSecond = (iMS\1000) mod 60
    var iMili   = (iMS\10) mod 100
    printf !"%02i:%02i.%02i (%i%%) \r",iMinute,iSecond,iMili,(iMS*100)\iDuration
    
    locate 3,1
    dim as single fSUM,fVU(VuLevels),iVU(VuLevels)
    for CNT as integer = 0 to VuLevels
      fSUM += pfVU[CNT]
      var iNum = CNT
      fVU(iNum) += pfVU[CNT]: iVU(iNum) += 1  
    next CNT  
    for CNT as integer = 0 to VuLevels
      var iLVL = int((fVU(CNT)/iVU(CNT))*20)
      if iLVL >= 20 then iLVL = 19
      if iLVL > iMaxLVL(CNT) then 
        iMaxLVL(CNT) = iLVL    
      else
        iMaxLVL(CNT) = (iMaxLVL(CNT)*2+iLVL)\3
      end if
      if iLastLVL(CNT) <> iMaxLVL(CNT) then      
        var iSzY = iMaxLVL(CNT),iX=1+(CNT*4)
        var iMinY = iLastLVL(CNT)
        iLastLVL(CNT) = iMaxLVL(CNT)
        for iY as integer = iMinY to iSzy
          locate 24-iY,iX
          color 1 shl (iY/8)
          print sBar;
        next iY
        for iY as integer = (24-iSzy)-1 to (24-iMinY) step -1
          locate iY,iX: print sBlank;
        next iY    
      end if    
    next CNT  
    
    while abs(timer-TMR) < 1/20
      sleep 1,1
    wend
    TMR = timer
    
    if multikey(fb.SC_ESCAPE) then exit while
    if len(inkey) then exit do
      
  loop until FSOUND_IsPlaying(iChan)=0
  FSOUND_Stream_Stop(MyMusic)
  FSOUND_Stream_Close(MyMusic)

  
  FILENAME = dir$()
  
wend




  