#define fbc -gen gcc -O 3
 
#include "crt.bi"
randomize()
 
const scrwid=800,scrhei=600,RandMaxSz=(1 shl 20)-1
type pixel as ushort
dim shared as pixel ptr pScr
 
screenres(scrwid,scrhei,16,1,0)
pScr = screenptr
 
#define rgbx(R,G,B) cast(pixel,(((((R) shl 5)+15) shr 8) shl 11)+(((((G) shl 6)+31) shr 8) shl 5)+((((B) shl 5)+15) shr 8))
#define psetx(X,Y,C) pScr[((Y)*scrwid)+(X)]=C
#define pointx(X,Y) pScr[((Y)*scrwid)+(X)]
 
const redDot = rgbx(200,100,100)
const greenDot = rgbx(100,200,100)
const blueDot = rgbx(100,100,200)
const bgClr = rgbx(200,200,200)
const bgClr32 = rgb(200,200,200)
dim as integer c,iColor
 
line(0,0)-(scrwid-1,scrhei-1),bgClr32,bf
 
for i as integer = 1 to 50
    c = int(5*rnd+1)    
    select case c
    case 2 'Red
        psetx(int(scrwid*rnd),int(scrhei*rnd),redDot)
    case 3 'Green
        psetx(int(scrwid*rnd),int(scrhei*rnd),greenDot)
    case 4 'Blue
        psetx(int(scrwid*rnd),int(scrhei*rnd),blueDot)
    end select
next i
 
dim as double TMR = timer
dim as integer iFPS,N
dim shared as byte iRand(RandMaxSz)
for I as integer = 0 to RandMaxSz
  iRand(I) = int(rnd*4+1)
next I
 
do  
  N = int(rnd*RandMaxSz)
  screenlock
  var pPix = cast(pixel ptr,screenptr)
  for y as integer = 0 to scrhei-1
    for x as integer = 0 to scrwid-1      
      iColor = *pPix
      if iColor <> bgClr then
        N = (N+1) and RandMaxSz
        select case iRand(N) '(rand() and 3)+1
        case 1: if y>   0       then pPix[-ScrWid] = iColor
        case 2: if x<(scrwid-1) then pPix[   1   ] = iColor
        case 3: if y<(scrhei-1) then pPix[ ScrWid] = iColor
        case 4: if x>   0       then pPix[  -1   ] = iColor
        end select
      end if          
      pPix += 1
    next x
  next y
  screenunlock
 
  iFPS += 1
  if abs(timer-TMR) > 1 then    
    WindowTitle "Life! (" & iFPS & " fps)"
    iFPS = 0: TMR = timer
  end if
 
 sleep 1,1
loop until inkey = chr(27)
 
end 0