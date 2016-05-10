#include once "fbgfx.bi"
#ifdef __FB_WIN32__
#include once "windows.bi"
#else
#define SYS_MPROTECT 125
#define PROT_RWE 1+2+4
#endif

sub RotateScale( dst as FB.IMAGE ptr = 0, src as FB.IMAGE ptr, positx as integer, posity as integer, angle as single, SCALE as single )
  
  #define PixSize uinteger
  #define RegPix eax
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
      mov eax,offset _RTZ32_ASM_BEGIN_
      mov ebx,offset _RTZ32_ASM_END_
      mov [STPTR],eax
      sub ebx,eax
      mov [BLKSZ],ebx
    end asm
    #ifdef __FB_WIN32__
    VirtualProtect(STPTR,BLKSZ,PAGE_EXECUTE_READWRITE,@OLDPROT)      
    #else
    asm
      mov	eax, SYS_MPROTECT          'Syscall for memory protect
      mov	ebx, [STPTR]               'starting address
      mov ecx,ebx                    'make a copy of it
      and	ebx, 0xFFFFF000            'align to page boundary
      add ecx, [BLKSZ]               'get eof of copy
      sub ecx,ebx                    'get size of code with align
      mov	edx, (PROT_RWE)            'set read write execute
      int	0x80                       'call syscall
      test eax, eax                  'success?
      jns _RTZ32_LINUX_SUCCESS_      'ok let's rock!
      mov dword ptr [INIT],0         'error... exit sub
    end asm
    exit sub
    asm _RTZ32_LINUX_SUCCESS_:
    #endif      
    
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
    mov [_RTZ32_SX_CONST_1_-2],ax
    mov eax,[SY]    'SY
    mov [_RTZ32_SY_CONST_1_-4],eax
    mov eax,[NXTCS] 'NXTCS
    mov [_RTZ32_NXTCS_CONST_1_-4],eax
    mov eax,[NXTSS] 'NXTSS
    mov [_RTZ32_NXTSS_CONST_1_-4],eax
    mov eax,[SW2]   'SW2
    mov [_RTZ32_SW2_CONST_1_-4],eax
    mov eax,[SH2]   'SH2
    mov [_RTZ32_SH2_CONST_1_-4],eax
    mov eax,[SRCWID] 'SRCWID
    mov [_RTZ32_SRCWID_CONST_1_-4],eax
    mov eax,[SRCHEI] 'SRCHEI
    mov [_RTZ32_SRCHEI_CONST_1_-4],eax
    mov eax,[SRCPTR] 'SRCPTR
    mov [_RTZ32_SRCPTR_CONST_1_-4],eax
    mov eax,[SRCPIT] 'SRCPIT
    mov [_RTZ32_SRCPIT_CONST_1_-4],eax
    mov eax,[DSTEXT] 'DSTEXT
    mov [_RTZ32_DSTEXT_CONST_1_-4],eax
    mov eax,[TC]     'TC
    mov [_RTZ32_TC_CONST_1_-4],eax
    mov [_RTZ32_TC_CONST_2_-4],eax
    mov eax,[TS]     'TS
    mov [_RTZ32_TS_CONST_1_-4],eax
    mov [_RTZ32_TS_CONST_2_-4],eax        
  end asm  
  #ifdef __FB_WIN32__
  FlushInstructionCache(GetCurrentProcess(),STPTR,BLKSZ)
  #endif
  
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
    _RTZ32_ASM_BEGIN_:           '\
    mov _DSTPTR_,[DSTPTR]       '|
    mov eax,[NYTS]              '|
    mov ebx,[NYTC]              '| Rotate/zoom
    movd mm0,ebp                '| asm begin
    movd mm1,esp                '|
    mov _NYTS_,eax              '|
    mov _NYTC_,ebx              '/
    mov _PY_,SelfMod          '\
    _RTZ32_SY_CONST_1_:        '|
    shl _PY_,16               '| for PY = SX to 1 step-1
    .balign 8                 '|
    _BEGIN_FOR_PY_:           '/
    mov _NXTC_,SelfMod          '\ NXTC=NXTCS: NXTS = NXTSS
    _RTZ32_NXTCS_CONST_1_:       '|
    sub _NXTC_,_NYTS_           '|
    mov _NXTS_,SelfMod          '|
    _RTZ32_NXTSS_CONST_1_:       '|
    add _NXTS_,_NYTC_           '/
    mov _PX_,SelfMod16        '\ for PX = SY to 1 step-1
    _RTZ32_SX_CONST_1_:        '|
    .balign 8                 '|
    _BEGIN_FOR_PX_:           '/
    'mov byte ptr [_DSTPTR_],255
    mov esi,_NXTC_              '\
    sar esi,cUSEBITS            '| MX = ((NXTC-NYTS) shr cUSEBITS) + SW2
    adc esi,SelfMod             '|
    _RTZ32_SW2_CONST_1_:         '/
    js _SKIP_IF_1_            '\
    cmp esi,SelfMod           '| if MX>=0 and MX<SRCWID then
    _RTZ32_SRCWID_CONST_1_:    '|
    jge _SKIP_IF_1_           '|
    shl esi,PixMul              '\
    add esi,SelfMod             '| OFFS = MX+SRCPTR
    _RTZ32_SRCPTR_CONST_1_:      '/
    mov eax,_NXTS_            '\
    sar eax, cUSEBITS         '| MY = ((NYTC+NXTS) shr cUSEBITS) + SH2
    adc eax, SelfMod          '|
    _RTZ32_SH2_CONST_1_:       '/
    js _SKIP_IF_1_              '\
    cmp eax,SelfMod             '| if MY>=0 and MY<SRCHEI then
    _RTZ32_SRCHEI_CONST_1_:      '|
    jge _SKIP_IF_1_             '/
    imul eax,SelfMod          '\
    _RTZ32_SRCPIT_CONST_1_:    '|
    add esi,eax               '| col = *cast(PixSize ptr, SRCPTR+MY*SRCPIT+MX)
    mov RegPix,[esi]          '/
    'or al,al                    '\ 'if col<>RGB(255,0,255) then
    'jz _SKIP_IF_1_              '/
    mov [_DSTPTR_],RegPix       '> *cast(PixSize ptr, DSTPTR) = COL
    .balign 2                   '> end if
    _SKIP_IF_1_:              '/ end if:end if
    add _DSTPTR_,PixSz          'DSTPTR += sizeof(PixSize)
    add _NXTC_,SelfMod        '\ NXTC += TC: NXTS += TS    
    _RTZ32_TC_CONST_1_:        '|
    add _NXTS_,SelfMod        '|
    _RTZ32_TS_CONST_1_:        '/
    dec _PX_                    '\ next PX
    jnz _BEGIN_FOR_PX_          '/
    add _DSTPTR_,SelfMod      '\ DSTPTR += DSTEXT
    _RTZ32_DSTEXT_CONST_1_:    '/
    add _NYTC_,SelfMod          '\
    _RTZ32_TC_CONST_2_:          '|NYTC += TC: NYTS += TS
    add _NYTS_,SelfMod          '|
    _RTZ32_TS_CONST_2_:          '/
    sub _PY_,(1 shl 16)       '\ next PY
    jnz _BEGIN_FOR_PY_        '/
    movd ebp,mm0                '\
    movd esp,mm1                '| Rotate/Zoom
    emms                        '| Asm End
    _RTZ32_ASM_END_:             '/
  end asm
  
end sub

sub RotateScaleHQ( dst as FB.IMAGE ptr = 0, src as FB.IMAGE ptr, positx as integer, posity as integer, angle as single, SCALE as single)
  
  const HPI = atn(1)*2
  const PI_180 = atn(1)/45
  const cUSEBITS = 20                      '\
  const cMULNUMB = 1 shl cUSEBITS          '| For Fixed Point "Single Precision"
  const cDIVNUMB = 1/cMULNUMB              '| 15-24 bits meaning 65536x65536 to 128x128
  const cBITREAL = cMULNUMB-1              '/
  const cLowBits = 8                         '\
  const cLowMul = 1 shl cLowBits             '|
  const cLowDiv = 1/cLowMul                  '| For Fixed Point "Half Precision"
  const cLowReal = cLowMul-1                 '| 8 bits meaning 1/256
  const cLowAnd = cLowReal+(cLowReal shl 16) '|
  const cLowDiff = cUSEBITS-ClowBits         '/
  #define PixSize uinteger
  #define PixPtr byte ptr
  const cPixSz = sizeof(PixSize)
  const cPixMul = cPixSz\2
  
  type InterpolStruct field=1
    ABCD as integer
  end type
  
  static as InterpolStruct ptr MATHPTR 
  static as any ptr STPTR
  static as integer COR,INIT,BLKSZ,OLDPROT
  static as integer NX,NY,TC,TS,PX,PY,NXTCS,NXTSS
  static as integer SW2,SH2,SWA,SHA
  static as any ptr DSTPTR,SRCPTR
  static as integer STARTX,STARTY,ENDX,ENDY,XPUT,YPUT
  static as any ptr SRCPIXPTR    
  static as integer DSTWID,DSTHEI,DSTPIT,DSTEXT  
  static as integer SX,SY,IMIN,IMAX,REGEBP,REGESP
  dim as single ZOOMX = SCALE, ZOOMY = SCALE
  dim as integer SRCWID = src->width-1
  dim as integer SRCHEI = src->height-1
  dim as integer SRCPIT = src->pitch    
  dim as integer NYTC,NYTS
  
  scope 'setup rotation parameters
    if INIT=0 then      
      asm
        inc dword ptr [INIT]
        mov eax,offset _HQR32_ASM_BEGIN_
        mov ebx,offset _HQR32_ASM_END_
        mov [STPTR],eax
        sub ebx,eax
        mov [BLKSZ],ebx
      end asm
      #ifdef __FB_WIN32__
      VirtualProtect(STPTR,BLKSZ,PAGE_EXECUTE_READWRITE,@OLDPROT)      
      #else
      asm
        mov	eax, SYS_MPROTECT          'Syscall for memory protect
        mov	ebx, [STPTR]               'starting address
        mov ecx,ebx                    'make a copy of it
        and	ebx, 0xFFFFF000            'align to page boundary
        add ecx, [BLKSZ]               'get eof of copy
        sub ecx,ebx                    'get size of code with align
        mov	edx, (PROT_RWE)            'set read write execute
        int	0x80                       'call syscall
        test eax, eax                  'success?
        jns _HQR32_LINUX_SUCCESS_      'ok let's rock!
        mov dword ptr [INIT],0         'error... exit sub
      end asm
      exit sub
      asm _HQR32_LINUX_SUCCESS_:
      #endif      
      if MATHPTR then deallocate(MATHPTR)
      MATHPTR = allocate((cLowMul*cLowMul*sizeof(InterpolStruct))+64) 
      asm 'aligning 256k table
        test dword ptr [MATHPTR],63
        jz _HQR32_SKIP_ALIGN_
        or dword ptr [MATHPTR],63
        add dword ptr [MATHPTR],1
        _HQR32_SKIP_ALIGN_:
      end asm
      dim as ubyte ptr ABCD = cast(any ptr,MATHPTR)      
      dim as uinteger AA,BB,CC,DD,TXX,TYY            
      for XX as integer = 0 to cLowReal        
        dim as single SSX=XX*cLowDiv,SRX=1-SSX                  
        for YY as integer = 0 to cLowReal
          dim as single SSY=YY*cLowDiv,SRY=1-SSY
          AA=((SRX*SRY)*cLowMul): if AA > 255 then AA = 255
          BB=((SSX*SRY)*cLowMul): if BB > 255 then BB = 255
          CC=((SRX*SSY)*cLowMul): if CC > 255 then CC = 255
          DD=((SSX*SSY)*cLowMul): if DD > 255 then DD = 255
          ABCD[0]=AA:ABCD[1]=BB:ABCD[2]=CC:ABCD[3]=DD
          ABCD += sizeof(InterpolStruct)
        next YY
      next XX      
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
    pxor mm3,mm3                    'clear mm3 (for byte to hi-word conversion)
    pshufw mm4,mm5, &b00000000      'get the first num as 4 words
    punpcklbw mm3,mm0               'convert pixel11 to 4 hi-words
    pmulhuw mm3,mm4                 'multiply rgba * (PX*PY)
    pxor mm4,mm4                    'clear mm4 (byte to hi-word conversion)
    movq mm6,mm3                    'store the result of multiply on temp
    pshufw mm3,mm5, &b01010101      'get the second num as 4 words
    punpckhbw mm4,mm0               'convert pixel21 to 4 hi-word
    pmulhuw mm4,mm3                 'multiply rgba * (SUBX*PY)
    pxor mm3,mm3                    'clear mm3 (byte to hi-word conversion)
    paddw mm6,mm4                   'add the result of the multiply
    pshufw mm4,mm5, &b10101010      'get the third num as 4 words
    punpcklbw mm3,mm1               'convert pixel12 to 4 hi-word
    pmulhuw mm3,mm4                 'multiply rgba * (PX*SUBY)
    pxor mm4,mm4                    'clear mm4 (byte to hi-word conversion)
    paddw mm6,mm3                   'add the result of the multiply
    pshufw mm3,mm5, &b11111111      'get the fourth num as 4 words
    punpckhbw mm4,mm1               'convert pixel22 to 4 hi-word
    pmulhuw mm4,mm3                 'multiply rgba * (SUBX*SUBY)
    paddw mm6,mm4                   'add the result of the multiply
    movq mm5,mm6                    '\
    psrlw mm5,6                     '| Extra accuracy (optional)
    paddw mm6,mm5                   '/
    packuswb mm6,mm6                'convert 4word to 4bytes (pixel 0-255)
    'movd esi,mm6
    'movnti [_DSTPTR_],esi             'store pixel
    movd [_DSTPTR_],mm6
    #endmacro
  end asm
  asm   'Converting variables to constants / relative to fixed
    mov eax,[SX]      'SX
    mov [_HQR32_SX_CONST1_-2],ax
    mov eax,[NXTCS]   'NXTCS
    mov [_HQR32_NXTCS_CONST1_-4],eax
    mov eax,[NXTSS]   'NXTSS
    mov [_HQR32_NXTSS_CONST1_-4],eax
    mov eax,[SW2]     'SW2
    mov [_HQR32_SW2_CONST1_-4],eax
    mov eax,[SH2]     'SH2
    mov [_HQR32_SH2_CONST1_-4],eax
    mov eax,[SRCPTR]  'SRCPTR
    mov [_HQR32_SRCPTR_CONST1_-4],eax
    mov eax,[SRCWID]  'SRCWID
    mov [_HQR32_SRCWID_CONST1_-4],eax
    mov eax,[SRCHEI]  'SRCHEI
    mov [_HQR32_SRCHEI_CONST1_-4],eax
    mov eax,[SRCPIT]  'SRCPIT
    mov [_HQR32_SRCPIT_CONST1_-4],eax
    mov [_HQR32_SRCPIT_CONST2_-4],eax
    mov eax,[TC]      'TC
    mov [_HQR32_TC_CONST1_-4],eax
    mov [_HQR32_TC_CONST2_-4],eax
    mov eax,[TS]      'TS
    mov [_HQR32_TS_CONST1_-4],eax
    mov [_HQR32_TS_CONST2_-4],eax
    mov eax,[DSTEXT]  'DSTEXT
    mov [_HQR32_DSTEXT_CONST1_-4],eax
    mov eax,[MATHPTR]
    mov [_HQR32_MATHPTR_CONST1_-4],eax
    add eax,65536
    mov [_HQR32_MATHPTR_CONST2_-4],eax
    
    #define dwp dword ptr
    #define SelfMod16 0x88BB
    #define SelfMod 0x8899AABB
    #define _DSTPTR_ edi
    #define _SRCPTR_ esi    
    #define _PY_ ecx    
    #define _PX_ cx    
    #define _NXTC_ ebp
    #define _NXTS_ esp
    #define _NYTC_ ebx
    #define _NYTS_ edx
    
  end asm
  #ifdef __FB_WIN32__
  FlushInstructionCache(GetCurrentProcess(),STPTR,BLKSZ)  
  #endif
  asm   'Drawing Rotate/Scaled Block
    jmp _HQR32_ASM_BEGIN_      '\
    .balign 64                 '|
    _HQR32_ASM_BEGIN_:         '|
    pxor mm7,mm7
    mov _DSTPTR_,[DSTPTR]      '| Render Init
    mov _NYTC_,[NYTC]          '|
    mov _NYTS_,[NYTS]          '|
    mov eax,[SY]               '|
    mov _PY_,eax               '|
    mov [REGESP],esp           '|
    mov [REGEBP],ebp           '/
    'PREFETCHT1 [SelfMod]
    mov eax,[SelfMod]
    _HQR32_MATHPTR_CONST2_:
    shl _PY_,16              '\  for PY = SY to 1 step-1    
    .balign 16               '|
    _HQR32_BEGIN_FOR_PY_:    '/
    mov _NXTC_,SelfMod         '\
    _HQR32_NXTCS_CONST1_:      '| NXTC=NXTCS-NYTS
    sub _NXTC_,_NYTS_          '/
    mov _NXTS_,SelfMod       '\
    _HQR32_NXTSS_CONST1_:    '| NXTS=NXTSS+NYTC
    add _NXTS_,_NYTC_        '/
    mov _PX_,SelfMod16         '\
    _HQR32_SX_CONST1_:         '| for PX = SX to 1 step-1
    .balign 16                 '|
    _HQR32_BEGIN_FOR_PX_:      '/
    mov eax,_NXTC_           '\
    sar eax,cUSEBITS         '| MX = (NXTC shr cUSEBITS)+SW2
    add eax,SelfMod          '|
    _HQR32_SW2_CONST1_:      '/
    js _HQR32_SKIP_IF1_        '\
    cmp eax,SelfMod            '| if MX>=0 and MX<SRCWID then        
    _HQR32_SRCWID_CONST1_:     '|
    jge _HQR32_SKIP_IF1_       '|
    mov _SRCPTR_,eax           '/
    mov eax,_NXTS_           '\
    sar eax,cUSEBITS         '| MY = (NXTS shr cUSEBITS)+SH2
    add eax,SelfMod          '|
    _HQR32_SH2_CONST1_:      '/
    js _HQR32_SKIP_IF1_        '\
    cmp eax,SelfMod            '| if MY>=0 and MY<SRCHEI then
    _HQR32_SRCHEI_CONST1_:     '|
    jge _HQR32_SKIP_IF1_       '/
    shl _SRCPTR_,cPixMul      '\
    add _SRCPTR_,SelfMod      '|
    _HQR32_SRCPTR_CONST1_:    '/
    imul eax,SelfMod         '\
    _HQR32_SRCPIT_CONST1_:   '|
    add _SRCPTR_,eax         '/
    movq mm0,[_SRCPTR_]        'load line 1
    mov eax,_NXTC_           '\
    movq mm1,[_SRCPTR_+SelfMod]'load line 2
    _HQR32_SRCPIT_CONST2_:     'label for constant
    mov esi,_NXTS_           '| \    
    shr eax,cLowDiff         '| |
    shr esi,cLowDiff         '| |
    and eax,cLowReal         '|SUBX = (NXTC and cBITREAL)
    and esi,cLowReal         '| | SUBY = (NXTS and cBITREAL)    
    shl eax,cLowBits         '| /
    add eax,esi              '/
    movd mm5,[SelfMod+eax*4] '\load the multiply matrix
    _HQR32_MATHPTR_CONST1_:  '/
    punpcklbw mm5,mm7
    DrawPixel()              '> --- DrawPixel() ---
    _HQR32_SKIP_IF1_:          '> end if,if
    add _DSTPTR_,cPixSz      '> DSTPTR += sizeof(PixSize)
    add _NXTC_,SelfMod         '\
    _HQR32_TC_CONST1_:         '| NXTC += TC: NXTS += TS
    add _NXTS_,SelfMod         '|
    _HQR32_TS_CONST1_:         '/
    sub _PX_,1               '\ next PX
    jnz _HQR32_BEGIN_FOR_PX_ '/
    add _DSTPTR_,SelfMod       '\ DSTPTR += DSTEXT
    _HQR32_DSTEXT_CONST1_:     '/
    add _NYTC_,SelfMod       '\ NYTC += TC: NYTS += TS
    _HQR32_TC_CONST2_:       '|
    add _NYTS_,SelfMod       '|
    _HQR32_TS_CONST2_:       '/
    sub _PY_,1 shl 16          '\ next PY
    jnz _HQR32_BEGIN_FOR_PY_   '/
    _HQR32_ASM_END_:         '\
    mov esp,[REGESP]         '| Render FInished
    mov ebp,[REGEBP]         '|
    emms                     '/
  end asm
  
end sub
