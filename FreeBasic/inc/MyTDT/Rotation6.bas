#include once "windows.bi"
#include once "fbgfx.bi"

sub Rotate( dst as FB.IMAGE ptr = 0, src as FB.IMAGE ptr, positx as integer, posity as integer, angle as single, SCALE as single )
  
  #define PixSize ubyte
  #define RegPix al
  const PI_180 = atn(1)/45
  const cUSEBITS = 18
  const cMULNUMB = 1 shl cUSEBITS
  const cDIVNUMB = 1/cMULNUMB
  const cBITREAL = (1 shl cUSEBITS)-1
  const PixSz = sizeof(PixSize)
  const PixMul = PixSz\2
  
  static as byte INIT
  static as any ptr STPTR
  static as integer OLDPROT,BLKSZ  
  static as integer NX,NY,SX,SY
  static as integer SW2, SH2, SWA,SHA
  static as integer NXTC,NXTS,NYTC,NYTS,NXTCS,NXTSS
  static as integer TC,TS,IMIN,IMAX
  static as any ptr DSTPTR,SRCPTR
  static as integer STARTX,STARTY,ENDX,ENDY,XPUT,YPUT  
  static as integer DSTWID,DSTHEI,DSTPIT,DSTEXT
  ' clearing access for selfmodify
  'buffers info
  dim as integer POSX=POSITX,POSY=POSITY
  dim as integer SRCWID = src->width
  dim as integer SRCHEI = src->height
  dim as integer SRCPIT = src->pitch
  dim as single ZOOMX = SCALE, ZOOMY = SCALE
  
  if INIT=0 then    
    asm
      inc dword ptr [INIT]
      mov eax,offset _RTZ8_ASM_BEGIN_
      mov ebx,offset _RTZ8_ASM_END_
      mov [STPTR],eax
      sub ebx,eax
      mov [BLKSZ],ebx
    end asm
    VirtualProtect(STPTR,BLKSZ,PAGE_EXECUTE_READWRITE,@OLDPROT)
    FlushInstructionCache(GetCurrentProcess(),STPTR,BLKSZ)        
  end if
  
  if dst = 0 then
    dstptr = screenptr
    screeninfo DSTWID,DSTHEI
    DSTPIT = DSTWID*sizeof(PixSize)    
  else
    dstptr = cast( any ptr, dst+1):DSTPIT = dst->pitch
    DSTWID = dst->width:DSTHEI = dst->height    
  end if  
  
  'quadrant
  var DTMP = ANGLE
  while DTMP < 0: DTMP += 360: wend
  while DTMP > 360: DTMP -= 360: wend
  while DTMP > 90: DTMP -= 90: wend    
  ' rotation data
  SRCPTR = cast( PixSize ptr, src+1)  
  SW2 = src->width\2: sh2 = src->height\2  
  TS = (sin( -angle * pi_180 )*cMULNUMB)/SCALE
  TC = (cos( -angle * pi_180 )*cMULNUMB)/SCALE  
  if SH2 > SW2 then SWA = SH2 else SWA = SW2
  'SHA = (-int(-SWA*sin(PI_180*(DTMP+45))/sin(PI_180*45)))
  'SWA = (-int(-SWA*sin(PI_180*(DTMP+45))/sin(PI_180*45)))  
  SHA=SH2*1.5:SWA=SW2*1.5
  XPUT = SWA*ZOOMX-SW2: YPUT = SHA*ZOOMX-SH2  
  POSITX -= SW2: POSITY -= SH2
  STARTX = -XPUT: ENDX = src->width+XPUT
  STARTY = -YPUT: ENDY = src->height+YPUT
  ' clipping
  IMIN = STARTX+POSITX:  if IMIN < 0 then STARTX -= IMIN
  IMAX = ENDX+POSITX: if IMAX >= DSTWID then ENDX += (DSTWID-1)-IMAX
  if IMIN < 0 and IMAX < 0 then exit sub
  if IMIN >= DSTWID and IMAX >= DSTWID then exit sub
  IMIN = STARTY+POSITY:  if IMIN < 0 then STARTY -= IMIN
  IMAX = ENDY+POSITY: if IMAX >= DSTHEI then ENDY += (DSTHEI-1)-IMAX
  if IMIN < 0 and IMAX < 0 then exit sub
  if IMIN >= DSTHEI and IMAX >= DST then exit sub
  ' initial values  
  DSTPTR += (STARTY+POSITY)*DSTPIT
  DSTPTR += (STARTX+POSITX)*sizeof(PixSize)
  SX = (ENDX-STARTX)+1: SY = (ENDY-STARTY)+1
  DSTEXT = DSTPIT-SX*sizeof(PixSize)  
  NY = (STARTY-SH2): NYTC = NY*TC: NYTS = NY*TS
  NX = (STARTX-SW2): NXTCS = NX*TC: NXTSS = NX*TS
  ' self modifing variables to constants
  asm    
    mov eax,[SX]    'SX
    mov [_RTZ8_SX_CONST_1_-2],ax
    mov eax,[SY]    'SY
    mov [_RTZ8_SY_CONST_1_-4],eax
    mov eax,[NXTCS] 'NXTCS
    mov [_RTZ8_NXTCS_CONST_1_-4],eax
    mov eax,[NXTSS] 'NXTSS
    mov [_RTZ8_NXTSS_CONST_1_-4],eax
    mov eax,[SW2]   'SW2
    mov [_RTZ8_SW2_CONST_1_-4],eax
    mov eax,[SH2]   'SH2
    mov [_RTZ8_SH2_CONST_1_-4],eax
    mov eax,[SRCWID] 'SRCWID
    mov [_RTZ8_SRCWID_CONST_1_-4],eax
    mov eax,[SRCHEI] 'SRCHEI
    mov [_RTZ8_SRCHEI_CONST_1_-4],eax
    mov eax,[SRCPTR] 'SRCPTR
    mov [_RTZ8_SRCPTR_CONST_1_-4],eax
    mov eax,[SRCPIT] 'SRCPIT
    mov [_RTZ8_SRCPIT_CONST_1_-4],eax
    mov eax,[DSTEXT] 'DSTEXT
    mov [_RTZ8_DSTEXT_CONST_1_-4],eax
    mov eax,[TC]     'TC
    mov [_RTZ8_TC_CONST_1_-4],eax
    mov [_RTZ8_TC_CONST_2_-4],eax
    mov eax,[TS]     'TS
    mov [_RTZ8_TS_CONST_1_-4],eax
    mov [_RTZ8_TS_CONST_2_-4],eax        
  end asm  
  FlushInstructionCache(GetCurrentProcess(),STPTR,BLKSZ)
  
  ' draw rotated/scaled block
  asm
    #define SelfMod 0x8899AABB
    #define SelfMod16 0x88BB
    #define _DSTPTR_ edi 
    #define _PY_ ecx
    #define _PX_ cx
    #define _NXTC_ ebx
    #define _NXTS_ edx
    #define _NYTS_ esp
    #define _NYTC_ ebp
    _RTZ8_ASM_BEGIN_:           '\
    mov _DSTPTR_,[DSTPTR]       '|
    mov eax,[NYTS]              '|
    mov ebx,[NYTC]              '| Rotate/zoom
    movd mm0,ebp                '| asm begin
    movd mm1,esp                '|
    mov _NYTS_,eax              '|
    mov _NYTC_,ebx              '/
    mov _PY_,SelfMod          '\
    _RTZ8_SY_CONST_1_:        '|
    shl _PY_,16               '| for PY = SX to 1 step-1
    .balign 8                 '|
    _BEGIN_FOR_PY_:           '/
    mov _NXTC_,SelfMod          '\ NXTC=NXTCS: NXTS = NXTSS
    _RTZ8_NXTCS_CONST_1_:       '|
    sub _NXTC_,_NYTS_           '|
    mov _NXTS_,SelfMod          '|
    _RTZ8_NXTSS_CONST_1_:       '|
    add _NXTS_,_NYTC_           '/
    mov _PX_,SelfMod16        '\ for PX = SY to 1 step-1
    _RTZ8_SX_CONST_1_:        '|
    .balign 8                 '|
    _BEGIN_FOR_PX_:           '/
    'mov byte ptr [_DSTPTR_],255
    mov esi,_NXTC_              '\
    sar esi,cUSEBITS            '| MX = ((NXTC-NYTS) shr cUSEBITS) + SW2
    adc esi,SelfMod             '|
    _RTZ8_SW2_CONST_1_:         '/
    js _SKIP_IF_1_            '\
    cmp esi,SelfMod           '| if MX>=0 and MX<SRCWID then
    _RTZ8_SRCWID_CONST_1_:    '|
    jge _SKIP_IF_1_           '|
    shl esi,PixMul              '\
    add esi,SelfMod             '| OFFS = MX+SRCPTR
    _RTZ8_SRCPTR_CONST_1_:      '/
    mov eax,_NXTS_            '\
    sar eax, cUSEBITS         '| MY = ((NYTC+NXTS) shr cUSEBITS) + SH2
    adc eax, SelfMod          '|
    _RTZ8_SH2_CONST_1_:       '/
    js _SKIP_IF_1_              '\
    cmp eax,SelfMod             '| if MY>=0 and MY<SRCHEI then
    _RTZ8_SRCHEI_CONST_1_:      '|
    jge _SKIP_IF_1_             '/
    imul eax,SelfMod          '\
    _RTZ8_SRCPIT_CONST_1_:    '|
    add esi,eax               '| col = *cast(PixSize ptr, SRCPTR+MY*SRCPIT+MX)
    mov RegPix,[esi]          '/
    'or al,al                    '\ 'if col<>RGB(255,0,255) then
    'jz _SKIP_IF_1_              '/
    mov [_DSTPTR_],RegPix       '> *cast(PixSize ptr, DSTPTR) = COL
    .balign 2                   '> end if
    _SKIP_IF_1_:              '/ end if:end if
    add _DSTPTR_,PixSz          'DSTPTR += sizeof(PixSize)
    add _NXTC_,SelfMod        '\ NXTC += TC: NXTS += TS    
    _RTZ8_TC_CONST_1_:        '|
    add _NXTS_,SelfMod        '|
    _RTZ8_TS_CONST_1_:        '/
    dec _PX_                    '\ next PX
    jnz _BEGIN_FOR_PX_          '/
    add _DSTPTR_,SelfMod      '\ DSTPTR += DSTEXT
    _RTZ8_DSTEXT_CONST_1_:    '/
    add _NYTC_,SelfMod          '\
    _RTZ8_TC_CONST_2_:          '|NYTC += TC: NYTS += TS
    add _NYTS_,SelfMod          '|
    _RTZ8_TS_CONST_2_:          '/
    sub _PY_,(1 shl 16)       '\ next PY
    jnz _BEGIN_FOR_PY_        '/
    movd ebp,mm0                '\
    movd esp,mm1                '| Rotate/Zoom
    emms                        '| Asm End
    _RTZ8_ASM_END_:             '/
  end asm
  
end sub

sub HQrotate( dst as FB.IMAGE ptr = 0, src as FB.IMAGE ptr, positx as integer, posity as integer, angle as single, SCALE as single)
  
  const PI_180 = atn(1)/45
  const cUSEBITS = 15
  const cMULNUMB = 1 shl cUSEBITS
  const cDIVNUMB = 1/cMULNUMB
  const cBITREAL = cMULNUMB-1
  #define PixSize ubyte  
  
  static as integer COR
  static as integer NX, NY, MX, MY
  static as integer sw2, sh2, SWA,SHA
  static as integer NXTC,NXTS,NYTC,NYTS,NXTCS,NXTSS
  static as integer TC,TS
  static as any ptr DSTPTR,SRCPTR
  static as integer STARTX,STARTY,ENDX,ENDY,XPUT,YPUT
  
  static as integer DSTWID,DSTHEI,DSTPIT,DSTEXT  
  static as integer PX,PY,SX,SY,IMIN,IMAX
  dim as single ZOOMX = SCALE
  dim as single ZOOMY = SCALE
  dim as integer SRCWID = src->width
  dim as integer SRCHEI = src->height
  dim as integer SRCPIT = src->pitch
  
  if dst = 0 then
    dstptr = screenptr
    screeninfo DSTWID,DSTHEI
    DSTPIT = DSTWID*sizeof(PixSize)
  else
    DSTPTR = cast( any ptr, dst+1)
    DSTWID = dst->width
    DSTHEI = dst->height
    DSTPIT = dst->pitch
  end if
  
  var DTMP = ANGLE
  while DTMP < 0: DTMP += 360: wend
  while DTMP > 360: DTMP -= 360: wend
  while DTMP > 90: DTMP -= 90: wend
  
  srcptr = cast( PixSize ptr, src+1)  
  sw2 = src->width\2: sh2 = src->height\2  
  ts = (sin( -angle * pi_180 )*cMULNUMB)/SCALE
  tc = (cos( -angle * pi_180 )*cMULNUMB)/SCALE
  if SH2 > SW2 then SWA = SH2 else SWA = SW2
  SHA = (-int(-SWA*sin(PI_180*(DTMP+45))/sin(PI_180*45)))
  SWA = (-int(-SWA*sin(PI_180*(DTMP+45))/sin(PI_180*45)))
  'SHA = SWA*1.5: SWA = SWA*1.5
  XPUT = SWA*SCALE-sw2: YPUT = SHA*SCALE-sh2  
  POSITX -= SW2: POSITY -= SH2
  STARTX = -XPUT: ENDX = src->width+XPUT
  STARTY = -YPUT: ENDY = src->height+YPUT
  
  IMIN = STARTX+POSITX:  if IMIN < 0 then STARTX -= IMIN
  IMAX = ENDX+POSITX: if IMAX >= DSTWID then ENDX += (DSTWID-1)-IMAX
  if IMIN < 0 and IMAX < 0 then exit sub
  if IMIN >= DSTWID and IMAX >= DSTWID then exit sub
  IMIN = STARTY+POSITY:  if IMIN < 0 then STARTY -= IMIN
  IMAX = ENDY+POSITY: if IMAX >= DSTHEI then ENDY += (DSTHEI-1)-IMAX
  if IMIN < 0 and IMAX < 0 then exit sub
  if IMIN >= DSTHEI and IMAX >= DST then exit sub
  
  DSTPTR += (STARTY+POSITY)*DSTPIT
  DSTPTR += (STARTX+POSITX)*sizeof(PixSize)
  SX = (ENDX-STARTX)+1: SY = (ENDY-STARTY)+1
  DSTEXT = (DSTPIT-SX*sizeof(PixSize))
  NY = (STARTY-SH2): NYTC = NY*TC: NYTS = NY*TS
  NX = (STARTX-SW2): NXTCS = NX*TC: NXTSS = NX*TS
  
  #macro FixToInt(TGT,SRC,SUM)
  'TGT = (SRC shr! cUSEBITS) + SUM
  asm
    mov eax,[SRC]
    sar eax,cUSEBITS
    add eax,[SUM]
    mov [TGT],eax
  end asm
  #endmacro
  
  #macro DrawPixel()  
  #define DSTPIX *cast(PixSize ptr, DSTPTR)  
  #define SRCPIX(Offset) *cast(PixSize ptr,SRCPIXPTR+Offset)  
  SRCPIXPTR = SRCPTR+MY*SRCPIT+MX
  SUBX = (NXTC and cBITREAL)
  SUBY = (NXTS and cBITREAL)
  RX = cMULNUMB-SUBX: RY=cMULNUMB-SUBY
  C4=512:C1=SRCPIX(0)    
  if MX=127 then C2=DSTPIX:C4=C2 else C2 = SRCPIX(1)
  if MY=127 then C3=DSTPIX:C4=C3 else C3 = SRCPIX(128)
  if C4=512 then 
    if MX=0 and MY=0 then C4=C1 else C4 = SRCPIX(129)
  end if  
  C1 *= ((RX*RY) shr cUSEBITS)
  C2 *= ((SUBX*RY) shr cUSEBITS)
  C3 *= ((RX*SUBY) shr cUSEBITS)
  C4 *= ((SUBX*SUBY) shr cUSEBITS)
  COR = C1 shr cUSEBITS+C2 shr cUSEBITS+C3 shr cUSEBITS+C4 shr cUSEBITS
  'if COR > 255 then COR=255  
  DSTPIX = COR
  #endmacro
  
  static as any ptr SRCPIXPTR
  static as integer RX,RY,SUBX,SUBY
  static as integer C1,C2,C3,C4
  
  for PY = SY to 1 step-1    
    NXTC=NXTCS-NYTS: NXTS=NXTSS+NYTC
    for PX = SX to 1 step-1      
      FixToInt(MX,NXTC,SW2) 
      if MX>=0 and MX<SRCWID then        
        FixToInt(MY,NXTS,SH2)
        if MY>=0 and MY<SRCHEI then      
          DrawPixel()
        end if
      end if
      DSTPTR += sizeof(PixSize)
      NXTC += TC: NXTS += TS
    next PX
    DSTPTR += DSTEXT
    NYTC += TC: NYTS += TS
  next PY
  
  end sub