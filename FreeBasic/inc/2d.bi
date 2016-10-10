#include once "fbgfx.bi"
#include once "GL/gl.bi"

#ifdef Render_OpenGL


namespace ogl

dim shared as integer CORS(255)
dim shared as any ptr BUFFER
dim shared as integer TEXTURE,SCRX,SCRY,BPP
dim shared as double OFX,OFY,UPTIME
dim shared as integer FRAMESKIP=0


sub CallScreen( WID as integer,HEI as integer, BPP as integer,PAGS as integer,FLAGS as integer ) 
  Screenres WID,HEI,BPP,PAGS,FLAGS
  WindowTitle("OpenGL Render")
end sub

' ***** Make a integer multiple of a power of 2 ****
#macro ogl_MulBits( MultipleBits, MyIntVar )
asm
  mov eax,[MyIntVar]
  dec eax
  shr eax,(MultipleBits)
  inc eax
  shl eax,(MultipleBits)
  mov [MyIntVar],eax
end asm
#endmacro
' ***** Raise a integer to a power of 2 *****
#macro ogl_Power2( MyIntNumber )
asm
  mov eax,[MyIntNumber]  
  dec eax
  bsr ecx,eax
  inc ecx
  mov eax,0xFFFF0000  
  rol eax,cl
  and eax,0xFFFF
  inc eax
  mov [MyIntNumber],eax
end asm
#endmacro

end namespace



#undef screenres
sub screenres( WID as integer=-1, HEI as integer=-1, BPP as integer=32, PAGS as integer=1, FLAGS as integer=0 )
  
  dim as integer TEXX,TEYY
  dim as any ptr TMP
  dim as integer SCX,SCY
  ScreenControl(fb.GET_DESKTOP_SIZE,SCX,SCY)  
  if WID=-1 then WID=SCX
  if HEI=-1 then HEI=SCY  
  if WID>=SCX or HEI>=SCY then FLAGS or= fb.gfx_fullscreen
  
  ogl_Power2(BPP)
  if BPP <> 8 and BPP <> 32 and BPP <> 32 then BPP = 32  
  if BPP = 8 then exit sub
  ogl_Mulbits( 3, WID)
  ogl_Mulbits( 3, HEI)
  ogl.SCRX = WID:ogl.SCRY = HEI
  TEXX = WID:TEYY = HEI  
  ogl_Power2(TEXX)  
  ogl_Power2(TEYY)
  ogl.OFX=WID/TEXX
  ogl.OFY=HEI/TEYY  
  ogl.BPP=BPP
  ogl.callscreen WID,HEI,BPP,PAGS,fb.GFX_OPENGL or FLAGS  
  glViewport(0,0,WID,HEI)
  glMatrixMode(GL_PROJECTION)  'Select The Projection Matrix
  glLoadIdentity()             'Reset The Projection Matrix
  glMatrixMode(GL_MODELVIEW)   'Select The Modelview Matrix
  glLoadIdentity()             'Reset The Projection Matrix
  glEnable(GL_TEXTURE_2D)      'Texture Mapping
  glGenTextures 1, @ogl.TEXTURE
  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_FASTEST)
  glClearColor(0f, 0f, 0f, 1.0f)
  glClear(GL_COLOR_BUFFER_BIT)  
  glLoadIdentity()
  glBindTexture GL_TEXTURE_2D, ogl.TEXTURE
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR)  
  if BPP = 8 then BPP=32
  TMP = ImageCreate(TEXX,TEYY,0,BPP)    
  if BPP = 32 then
    glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA,TEXX,TEYY,0,GL_BGRA,GL_UNSIGNED_BYTE,TMP+sizeof(fb.image))
  else
    glTexImage2D(GL_TEXTURE_2D,0,GL_RGB,TEXX,TEYY,0,GL_RGB,GL_UNSIGNED_SHORT_5_6_5,TMP+sizeof(fb.image))    
  end if
  
  if ogl.bpp = 8 then 
    ogl.BUFFER = TMP
  else 
    ImageDestroy(TMP)
  end if
  color ,rgba(0,0,0,0)
  cls  
end sub

#undef screensync

sub screenSync()  
  glColor4f(1.0, 1.0, 1.0, 1.0)

  glActiveTexture(GL_TEXTURE0)
  glClientActiveTexture(GL_TEXTURE0)

  dim BT as double,TMP as any ptr, BUFSZ as integer    
  static as integer FS
  BT=timer
  glBindTexture GL_TEXTURE_2D, ogl.TEXTURE  
  FS += 1
  if FS > OGL.FRAMESKIP then FS=0  
  if FS=0 then
  if ogl.BPP = 32 then    
    glTexSubImage2D(GL_TEXTURE_2D,0,0,0,ogl.SCRX,ogl.SCRY,GL_BGRA,GL_UNSIGNED_BYTE,screenptr)  

  elseif ogl.BPP = 16 then
    glTexSubImage2D(GL_TEXTURE_2D,0,0,0,ogl.SCRX,ogl.SCRY,GL_RGB,GL_UNSIGNED_SHORT_5_6_5,screenptr)
  else
    for BUFSZ = 0 to 255
      'ogl.CORS(BUFSZ) = rgba(64,0,BUFSZ,0) 
      Palette Get BUFSZ,ogl.CORS(BUFSZ)
    next BUFSZ
    TMP = screenptr
    BUFSZ = ogl.SCRX*ogl.SCRY
    asm
      mov esi,[TMP]    
      mov edi,[ogl.BUFFER]
      add edi,sizeof(fb.image)
      mov edx,offset ogl.CORS      
      mov ecx,[BUFSZ]
      xor eax,eax
      _8TO32_NEXTPIXEL_:
      lodsb
      mov ebx,[EDX+EAX*4]
      mov [edi],ebx
      add edi,4
      dec ecx
      jnz _8TO32_NEXTPIXEL_
    end asm
    glTexSubImage2D(GL_TEXTURE_2D,0,0,0,ogl.SCRX,ogl.SCRY,GL_BGRA,GL_UNSIGNED_BYTE,ogl.BUFFER+sizeof(fb.image))
  end if
  end if

  glDisable(GL_LIGHTING)
  glDisable(GL_CULL_FACE)
  glDisable(GL_NORMALIZE)
  glMatrixMode (GL_PROJECTION)
  glPushMatrix ()
  glLoadIdentity ()
  glOrtho (-1, 1, -1, 1, -1, 1)
  glEnable(GL_TEXTURE_2D)
  glEnable(GL_BLEND)
  glEnable(GL_ALPHA_TEST)
  glDisable(GL_DEPTH_TEST)
  glMatrixMode (GL_MODELVIEW)
  glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA)
  glLoadIdentity ()

  glBegin(GL_QUADS)      
  glTexCoord2f(ogl.OFX, ogl.OFY):glVertex3f(1,-1,0)  
  glTexCoord2f(0, ogl.OFY):glVertex3f(-1,-1,0)  
  glTexCoord2f(0,0):glVertex3f(-1,1,0)  
  glTexCoord2f(ogl.OFX, 0):glVertex3f(1,1,0)  
  glEnd() 
  ogl.UPTIME=timer-BT
  flip

  glEnable(GL_LIGHTING)
  glEnable(GL_CULL_FACE)
  glEnable(GL_NORMALIZE)
  glDisable(GL_TEXTURE_2D)
  glDisable(GL_BLEND)
  glEnable(GL_DEPTH_TEST)


end sub

#else
namespace ogl
dim shared as double UPTIME
dim shared as integer FRAMESKIP=0
end namespace
#endif
