#include once "windows.bi"
#include once "fbgfx.bi"

sub RotateScale( dst as FB.IMAGE ptr = 0, src as FB.IMAGE ptr, positx as integer, posity as integer, angle as single, SCALE as single )
  
  #define PixSize ubyte
  #define RegPix al
  const PI_180 = atn(1)/45
  const cUSEBITS = 20
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
  SHA = (-int(-SWA*sin(PI_180*(DTMP+45))/sin(PI_180*45)))
  SWA = (-int(-SWA*sin(PI_180*(DTMP+45))/sin(PI_180*45)))  
  'SHA=SH2*1.5:SWA=SW2*1.5
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

'dim shared as integer SRX,SRY
dim shared as integer RX,RY,PX,PY

sub RotateScaleHQ( dst as FB.IMAGE ptr = 0, src as FB.IMAGE ptr, positx as integer, posity as integer, angle as single, SCALE as single)
  
  const PI_180 = atn(1)/45
  const cUSEBITS = 20                      '\
  const cMULNUMB = 1 shl cUSEBITS          '| For Fixed Point "Single Precision"
  const cDIVNUMB = 1/cMULNUMB              '| 15-24 bits meaning 65536x65536 to 128x128
  const cBITREAL = cMULNUMB-1              '/
  const cLowBits = 15                        '\
  const cLowMul = 1 shl cLowBits             '|
  const cLowDiv = 1/cLowMul                  '| For Fixed Point "Half Precision"
  const cLowReal = cLowMul-1                 '| 8 bits meaning 1/256
  const cLowAnd = cLowReal+(cLowReal shl 16) '|
  const cLowDiff = cUSEBITS-ClowBits         '/
  #define PixSize ubyte  
  #define PixPtr byte ptr
  const cPixSz = sizeof(PixSize)
  const cPixMul = cPixSz\2
  
  static as any ptr STPTR
  static as integer COR,INIT,BLKSZ,OLDPROT
  static as integer NX,NY,TC,TS
  static as integer SW2, SH2, SWA,SHA
  static as any ptr DSTPTR,SRCPTR
  static as integer STARTX,STARTY,ENDX,ENDY,XPUT,YPUT
  static as any ptr SRCPIXPTR    
  static as integer DSTWID,DSTHEI,DSTPIT,DSTEXT  
  static as integer SX,SY,IMIN,IMAX
  dim as single ZOOMX = SCALE, ZOOMY = SCALE
  dim as integer SRCWID = src->width-1
  dim as integer SRCHEI = src->height-1
  dim as integer SRCPIT = src->pitch  
  dim as integer NXTCS,NXTSS
  dim as integer NXTC,NXTS,NYTC,NYTS
  dim as integer SUBX,SUBY
  
  scope 'setup rotation parameters
    if INIT=0 then    
      asm
        inc dword ptr [INIT]
        mov eax,offset _HQR8_ASM_BEGIN_
        mov ebx,offset _HQR8_ASM_END_
        mov [STPTR],eax
        sub ebx,eax
        mov [BLKSZ],ebx
      end asm
      VirtualProtect(STPTR,BLKSZ,PAGE_EXECUTE_READWRITE,@OLDPROT)    
    end if  
    
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
  end scope
  asm   'Draw Pixel Macros
    #macro DrawPixel()  
    '#define DSTPIX *cast(PixSize ptr, DSTPTR)  
    '#define SRCPIX(Offset) *cast(PixSize ptr,SRCPIXPTR+Offset)
    
    mov ecx,cLowMul               '  \
    mov edx,cLowMul               '\ |
    sub ecx,[SelfMod]             '| | RX = cMULNUMB-SUBX
    _HQR8_SUBX_PTR2_:
    'sub ebx,_SUBX_
    sub edx,[SelfMod]             '| |RY=cMULNUMB-SUBY
    _HQR8_SUBY_PTR2_:
    'mov [RX],ebx                  '| /
    'mov [RY],edx                  '/  
    
    movzx eax,pixptr [_SRCPTR_+0]
    imul eax,edx                    '|
    shr eax,cLowBits                '| C1=(C1*((RX*RY) shr cUSEBITS)) shr cUSEBITS
    imul eax,ecx                    '|
    shr eax,cLowBits                '|
    adc eax,0                       '|
    mov ebx,eax                     '/
    movzx eax,pixptr [_SRCPTR_+1] '\
    'imul eax,_SUBX_
    imul eax,[SelfMod]            '|
    _HQR8_SUBX_PTR3_:
    shr eax,cLowBits              '| C2=(C2*((SUBX*RY) shr cUSEBITS)) shr cUSEBITS
    imul eax,edx                  '|
    shr eax,cLowBits              '|
    adc eax,0                     '|
    add ebx,eax                   '/
    
    mov edx,[SelfMod]
    _HQR8_SUBY_PTR3_:
    movzx eax,pixptr [_SRCPTR_+128] '\
    imul eax,ecx '[RX]                   '|
    shr eax,cLowBits                '| C3=(C3*((RX*SUBY) shr cUSEBITS)) shr cUSEBITS
    imul eax,edx                    '|
    shr eax,cLowBits                '|
    adc eax,0                       '|
    add ebx,eax                     '/
    movzx eax,pixptr[_SRCPTR_+129]'\
    'imul eax,_SUBX_
    imul eax,[SelfMod]            '|
    _HQR8_SUBX_PTR4_:
    shr eax,cLowBits              '|C4=(C4*((SUBX*SUBY) shr cUSEBITS)) shr cUSEBITS
    imul eax,edx                  '|
    shr eax,cLowBits              '|
    mov edx,255                   '|
    adc eax,0                     '|
    add ebx,eax                   '/
    
    cmp ebx,edx                   '  | if COR > 255 then COR=255
    cmovg ebx,edx                 '  /
    mov [_DSTPTR_],bl             '> DSTPIX = COR
    
    #endmacro
  end asm
  asm   'Converting variables to constants / relative to fixed
    mov eax,[SX]      'SX
    mov [_HQR8_SX_CONST1_-2],ax
    mov eax,[NXTCS]   'NXTCS
    mov [_HQR8_NXTCS_CONST1_-4],eax
    mov eax,[NXTSS]   'NXTSS
    mov [_HQR8_NXTSS_CONST1_-4],eax
    mov eax,[SW2]     'SW2
    mov [_HQR8_SW2_CONST1_-4],eax
    mov eax,[SH2]     'SH2
    mov [_HQR8_SH2_CONST1_-4],eax
    mov eax,[SRCPTR]  'SRCPTR
    mov [_HQR8_SRCPTR_CONST1_-4],eax
    mov eax,[SRCWID]  'SRCWID
    mov [_HQR8_SRCWID_CONST1_-4],eax
    mov eax,[SRCHEI]  'SRCHEI
    mov [_HQR8_SRCHEI_CONST1_-4],eax
    mov eax,[SRCPIT]  'SRCPIT
    mov [_HQR8_SRCPIT_CONST1_-4],eax
    mov eax,[TC]      'TC
    mov [_HQR8_TC_CONST1_-4],eax
    mov [_HQR8_TC_CONST2_-4],eax
    mov eax,[TS]      'TS
    mov [_HQR8_TS_CONST1_-4],eax
    mov [_HQR8_TS_CONST2_-4],eax
    mov eax,[DSTEXT]  'DSTEXT
    mov [_HQR8_DSTEXT_CONST1_-4],eax
    lea eax,[NYTS]    'NYTS pointer
    mov [_HQR8_NYTS_PTR1_-4],eax
    mov [_HQR8_NYTS_PTR2_-8],eax
    lea eax,[NYTC]    'NYTC pointer
    mov [_HQR8_NYTC_PTR1_-4],eax
    mov [_HQR8_NYTC_PTR2_-8],eax
    lea eax,[SUBX]    'SUBX pointer
    mov [_HQR8_SUBX_PTR1_-4],eax
    mov [_HQR8_SUBX_PTR2_-4],eax
    mov [_HQR8_SUBX_PTR3_-4],eax
    mov [_HQR8_SUBX_PTR4_-4],eax
    lea eax,[SUBY]    'SUBY pointer
    mov [_HQR8_SUBY_PTR1_-4],eax
    mov [_HQR8_SUBY_PTR2_-4],eax
    mov [_HQR8_SUBY_PTR3_-4],eax
    
    #define dwp dword ptr
    #define SelfMod16 0x88BB
    #define SelfMod 0x8899AABB
    #define _DSTPTR_ edi
    #define _SRCPTR_ esi
    #define _SUBX_ ecx
    #define _PY_ dword ptr [PY]
    'ecx
    #define _PX_ word ptr [PX]
    'cx
    #define _NXTC_ ebp
    #define _NXTS_ esp
    
  end asm
  FlushInstructionCache(GetCurrentProcess(),STPTR,BLKSZ)  
  asm   'Drawing Rotate/Scaled Block
    jmp _HQR8_ASM_BEGIN_      '\
    .balign 64                '| Init
    _HQR8_ASM_BEGIN_:         '|
    mov _DSTPTR_,[DSTPTR]     '/
    mov eax,[SY]
    shl eax,16
    mov _PY_,eax           '\
    movd MM0,esp           '|
    movd MM1,ebp           '|
    'shl _PY_,16           '|  for PY = SY to 1 step-1    
    .balign 16             '|
    _HQR8_BEGIN_FOR_PY_:   '/
    mov _NXTC_,SelfMod       '\
    _HQR8_NXTCS_CONST1_:     '|
    sub _NXTC_,[SelfMod]     '| NXTC=NXTCS-NYTS
    _HQR8_NYTS_PTR1_:        '/
    mov _NXTS_,SelfMod     '\
    _HQR8_NXTSS_CONST1_:   '|
    add _NXTS_,[SelfMod]   '| NXTS=NXTSS+NYTC
    _HQR8_NYTC_PTR1_:      '/
    mov _PX_,SelfMod16       '\ for PX = SX to 1 step-1
    _HQR8_SX_CONST1_:        '|
    .balign 16               '|
    _HQR8_BEGIN_FOR_PX_:     '/
    mov eax,_NXTC_         '\
    mov edx,_NXTC_         '|
    sar eax,cUSEBITS       '| MX = (NXTC shr cUSEBITS)+SW2
    shr edx,cLowDiff
    and edx,cLowReal       '| SUBX = (NXTC and cBITREAL)
    add eax,SelfMod        '|
    _HQR8_SW2_CONST1_:     '|
    'mov _SUBX_,edx
    mov [SelfMod], edx     '|
    _HQR8_SUBX_PTR1_:      '/
    js _HQR8_SKIP_IF1_       '\
    cmp eax,SelfMod          '| if MX>=0 and MX<SRCWID then        
    _HQR8_SRCWID_CONST1_:    '|
    jge _HQR8_SKIP_IF1_      '|
    mov _SRCPTR_,eax         '-
    'mov [SRX],eax            '/
    mov eax,_NXTS_         '\
    shl _SRCPTR_,cPixMul   '-
    mov edx,_NXTS_         '|
    add _SRCPTR_,SelfMod   '-
    _HQR8_SRCPTR_CONST1_:  '-
    sar eax,cUSEBITS       '| MY = (NXTS shr cUSEBITS)+SH2
    shr edx,cLowDiff
    and edx,cLowReal       '| SUBY = (NXTS and cBITREAL)
    add eax,SelfMod        '|
    _HQR8_SH2_CONST1_:     '|
    mov [SelfMod],edx      '|
    _HQR8_SUBY_PTR1_:      '/
    js _HQR8_SKIP_IF1_       '\
    cmp eax,SelfMod          '| if MY>=0 and MY<SRCHEI then
    _HQR8_SRCHEI_CONST1_:    '|
    jge _HQR8_SKIP_IF1_      '|
    'mov [SRY],eax            '/
    imul eax,SelfMod        '\
    _HQR8_SRCPIT_CONST1_:   '|
    add _SRCPTR_,eax        '/
    DrawPixel()            '> --- DrawPixel() ---
    _HQR8_SKIP_IF1_:       ' end if,if
    add _DSTPTR_,cPixSz      '> DSTPTR += sizeof(PixSize)
    add _NXTC_,SelfMod     '\ NXTC += TC: NXTS += TS
    _HQR8_TC_CONST1_:      '|
    add _NXTS_,SelfMod     '|
    _HQR8_TS_CONST1_:      '/
    sub _PX_,1               '\ next PX
    jnz _HQR8_BEGIN_FOR_PX_  '/
    add _DSTPTR_,SelfMod   '\ DSTPTR += DSTEXT
    _HQR8_DSTEXT_CONST1_:  '/
    add dwp [SelfMod],SelfMod'\ NYTC += TC: NYTS += TS
    _HQR8_NYTC_PTR2_:        '|
    _HQR8_TC_CONST2_:        '|
    add dwp [SelfMod],SelfMod'|
    _HQR8_NYTS_PTR2_:        '|
    _HQR8_TS_CONST2_:        '/
    sub _PY_,1 shl 16      '\
    jnz _HQR8_BEGIN_FOR_PY_'/
    _HQR8_ASM_END_:
    movd esp,mm0
    movd ebp,mm1    
    emms
  end asm
  
end sub
