#include once "windows.bi"
#include once "fbgfx.bi"

sub Rotate( dst as FB.IMAGE ptr = 0, src as FB.IMAGE ptr, positx as integer, posity as integer, angle as single, SCALE as single )
  
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
  'SHA=SH2:SWA=SW2
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
  #define PixPtr byte ptr
  const cPixSz = sizeof(PixSize)
  const cPixMul = cPixSz\2
  
  static as integer COR
  static as integer NX, NY, MX, MY
  static as integer sw2, sh2, SWA,SHA
  static as integer NXTC,NXTS,NYTC,NYTS,NXTCS,NXTSS
  static as integer TC,TS
  static as any ptr DSTPTR,SRCPTR
  static as integer STARTX,STARTY,ENDX,ENDY,XPUT,YPUT
  static as any ptr SRCPIXPTR
  static as integer RX,RY,SUBX,SUBY
  static as integer C1,C2,C3,C4
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
  'SHA = (-int(-SWA*sin(PI_180*(DTMP+45))/sin(PI_180*45)))
  'SWA = (-int(-SWA*sin(PI_180*(DTMP+45))/sin(PI_180*45)))
  SHA = SWA*1.5: SWA = SWA*1.5
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
  
  #macro DrawPixel()  
  '#define DSTPIX *cast(PixSize ptr, DSTPTR)  
  '#define SRCPIX(Offset) *cast(PixSize ptr,SRCPIXPTR+Offset)  
  mov eax,cMULNUMB                '\
  sub eax,[SUBX]                  '| RX = cMULNUMB-SUBX
  mov [RX],eax                    '/
  mov eax,cMULNUMB              '\
  sub eax,[SUBY]                '| RY=cMULNUMB-SUBY
  mov [RY],eax                  '/
  mov dword ptr [C4],0            '\
  xor eax,eax                     '|
  mov al, PixPtr [_SRCPTR_+0]     '| C4=-512:C1=SRCPIX(0)
  mov [C1],al                     '/
  cmp dword ptr [MX],127        '\ if MX=127 then
  jne _HQR8_ELSE_IF_MX_         '/
  mov al, PixPtr [_DSTPTR_]       '\
  mov [C2],al                     '| C2=DSTPIX:C4=C2 
  mov [C4],al                     '|
  jmp _HQR8_END_IF_MX_            '/
  _HQR8_ELSE_IF_MX_:            '> else
  mov al, PixPtr [_SRCPTR_+1]     '\ C2 = SRCPIX(1)
  mov [C2],al                     '/
  _HQR8_END_IF_MX_:             '> end if
  cmp dword ptr [MY],127          '\ if MY=127 then 
  jne _HQR8_ELSE_IF_MY_           '/
  mov al, PixPtr [_DSTPTR_]     '\
  mov [C3], al                  '| C3=DSTPIX:C4=C3 
  mov [C4], al                  '|
  jmp _HQR8_END_IF_MY_          '/
  _HQR8_ELSE_IF_MY_:              '> else 
  mov al,PixPtr[_SRCPTR_+128]   '\ C3 = SRCPIX(128)
  mov [C3],al                   '/
  _HQR8_END_IF_MY_:               '> end if
  cmp dword ptr [C4],0          '\ if C4=-512 then
  jne _HQR8_SKIP_IF_C4_         '/
  'mov eax,[MX]                    '\
  'or eax,[MY]                     '| if MX=0 and MY=0 then
  'jnz _HQR8_ELSE_IF_MXMY_         '/
  'mov eax,[C1]                  '\
  'mov [C4],eax                  '| C4=C1 
  'jmp _HQR8_END_IF_MXMY_        '/
  _HQR8_ELSE_IF_MXMY_:            '> else
  mov al,PixPtr[_SRCPTR_+129]   '\ C4 = SRCPIX(129)
  mov [C4],al                   '/
  _HQR8_END_IF_MXMY_:             '> end if
  _HQR8_SKIP_IF_C4_:            '> end if  
  mov eax,[RX]                    '\
  imul eax,[RY]                   '|
  sar eax,cUSEBITS                '|
  adc eax,0                       '| C1=(C1*((RX*RY) shr cUSEBITS)) shr cUSEBITS
  imul eax,[C1]                   '|
  sar eax,cUSEBITS                '|
  adc eax,0                       '|
  mov [C1],eax                    '/
  mov eax,[SUBX]                '\
  imul eax,[RY]                 '|
  sar eax,cUSEBITS              '|
  adc eax,0                     '| C2=(C2*((SUBX*RY) shr cUSEBITS)) shr cUSEBITS
  imul eax,[C2]                 '|
  sar eax,cUSEBITS              '|
  adc eax,0                     '|
  mov [C2],eax                  '/
  mov eax,[RX]                    '\
  imul eax,[SUBY]                 '|
  sar eax,cUSEBITS                '|
  adc eax,0                       '| C3=(C3*((RX*SUBY) shr cUSEBITS)) shr cUSEBITS
  imul eax,[C3]                   '|
  sar eax,cUSEBITS                '|
  adc eax,0                       '|
  mov [C3],eax                    '/
  mov eax,[SUBX]                '\
  imul eax,[SUBY]               '|
  sar eax,cUSEBITS              '|
  adc eax,0                     '| C4=(C4*((SUBX*SUBY) shr cUSEBITS)) shr cUSEBITS 
  imul eax,[C4]                 '|
  sar eax,cUSEBITS              '|
  adc eax,0                     '|
  mov [C4],eax                  '/
  mov eax,[C1]                    '\
  add eax,[C2]                    '| COR = C1+C2+C3+C4 
  add eax,[C3]                    '|
  add eax,[C4]                    '/
  cmp eax,255                   '\
  jle _HQR8_SKIP_IF_COR_        '|
  mov eax,255                   '| if COR > 255 then COR=255
  _HQR8_SKIP_IF_COR_:           '/
  mov [_DSTPTR_],al               '> DSTPIX = COR
  #endmacro
  asm
    #define _DSTPTR_ edi
    #define _SRCPTR_ esi
    #define _PY_ ecx
    #define _PX_ cx
    mov _DSTPTR_,[DSTPTR]
    mov _PY_,[SY]          '\
    shl _PY_,16            '|  for PY = SY to 1 step-1    
    _HQR8_BEGIN_FOR_PY_:   '/
    mov eax,[NXTCS]          '\
    sub eax,[NYTS]           '| NXTC=NXTCS-NYTS
    mov [NXTC],eax           '/
    mov eax,[NXTSS]        '\
    add eax,[NYTC]         '| NXTS=NXTSS+NYTC
    mov [NXTS],eax         '/
    mov _PX_,[SX]            '\ for PX = SX to 1 step-1
    _HQR8_BEGIN_FOR_PX_:     '/
    mov eax,[NXTC]         '\
    mov edx,eax            '|
    sar eax,cUSEBITS       '| MX = (NXTC shr cUSEBITS)+SW2
    and edx,cBITREAL       '| SUBX = (NXTC and cBITREAL)
    mov [SUBX],edx         '|
    add eax,[SW2]          '/
    js _HQR8_SKIP_IF1_       '\
    cmp eax,[SRCWID]         '| if MX>=0 and MX<SRCWID then        
    jge _HQR8_SKIP_IF1_      '|
    mov _SRCPTR_,eax         '-\
    shl _SRCPTR_,cPixMul     '-|
    add _SRCPTR_,[SRCPTR]    '-/
    mov [MX],eax             '/
    mov eax,[NXTS]         '\
    mov edx,eax            '|
    sar eax,cUSEBITS       '| MY = (NXTS shr cUSEBITS)+SH2
    and edx,cBITREAL       '| SUBY = (NXTS and cBITREAL)
    mov [SUBY],edx         '|
    add eax,[SH2]          '/
    js _HQR8_SKIP_IF1_       '\
    cmp eax,[SRCHEI]         '| if MY>=0 and MY<SRCHEI then
    jge _HQR8_SKIP_IF1_      '|
    mov [MY],eax             '/
    imul eax,[SRCPIT]       '\
    add _SRCPTR_,eax        '/
    DrawPixel()            '> --- DrawPixel() ---
    _HQR8_SKIP_IF1_:       ' end if,if
    add _DSTPTR_,cPixSz      '> DSTPTR += sizeof(PixSize)
    mov eax,[TC]           '\
    add [NXTC],eax         '| NXTC += TC: NXTS += TS
    mov eax,[TS]           '|
    add [NXTS],eax         '/
    dec _PX_                 '\ next PX
    jnz _HQR8_BEGIN_FOR_PX_  '/
    add _DSTPTR_,[DSTEXT]  '> DSTPTR += DSTEXT
    mov eax,[TC]             '\
    add [NYTC],eax           '| NYTC += TC: NYTS += TS
    mov eax,[TS]             '|
    add [NYTS],eax           '/
    sub _PY_,1 shl 16      '\
    jnz _HQR8_BEGIN_FOR_PY_'/
  end asm
  
end sub
