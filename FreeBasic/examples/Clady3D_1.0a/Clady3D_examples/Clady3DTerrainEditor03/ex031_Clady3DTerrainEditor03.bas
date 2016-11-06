#Include "Clady3D.bi"


dim Shared camera As nCAMERA
dim as nfont font01
dim as ntexture texmartor,textile,texdest,texeraser,texsrc,microtextilebase,_
                microtextile1,microtextile2,microtextile3,microtextile4,microtextile5,_
                microtextile6,microtextile7,microtextile8,microtextile9,microtextileshader

dim as nimage imgcmsave,microimtilebase,microimtile1,microimtile2,microimtile3,microimtile4,_
                microimtile5,microimtile6,microimtile7,microimtile8,microimtile9,microimtileshader,_
                maximagebase,maximagetile1,maximagetile2,maximagetile3,maximagetile4,maximagetile5,maximagetile6,maximagetile7,_
                maximagetile8,maximagetile9,maximagetileshader
dim as integer i,alpha,radius,mode
DIM as SINGLE water_level,xr1,yr1,zr1,xr2,yr2,zr2,scale_texture_cm,pas,u,v
dim as single mousewh
dim as integer wh,cmsize,graf_mode,ws,hs,wt,ht,xs,ys,xt,yt,xofft,yofft,cmtype,_
                        xoffm,yoffm,xm,ym,wm,hm,rm,scale_detail,graph_driver

Dim terrain As nTERRAIN
Dim As nTEXTURE texcolormap,texdetailmap,tex05,tex53,texwater,texreflex,texdetail,texsky
Dim As nClouds clouds
Dim As Integer wire,terr_size,ch_terr,terr_scale_xz,j,xpos,zpos,shw,_
                diam_sculpt,shape
dim as nTriSelector selector
dim as nArrow arrow
dim as uinteger ptr vertentry, pixeldeststart, pixelsrcstart, pixeleraserstart
Dim As nMESH water

scale_detail=160
xofft=0
yofft=0
wh=-1
cmsize=-1
graf_mode=-1
cmtype=-1
water_level=29
terr_size=-1
ch_terr=-1'choose terrain
terr_scale_xz=-1
graph_driver=-1

print ""
print "Choose the Graphic Driver : "
print "0 --> OpenGL"
print "1 --> DirectX(faster)"
while ((graph_driver<0) or (graph_driver>1))
input "Enter the option for the graphic driver : ",graph_driver
if ((graph_driver<0) or (graph_driver>1)) then print "Wrong value, the value must be 1 or 2 !"
wend
print ""
print "Choose the Graphic Mode : "
print "1 -->800x600,16b,fullscreen"
print "2 -->800x600,32b,fullscreen"
print "3 -->1024x768,16b,fullscreen"
print "4 -->1024x768,32b,fullscreen"
print "5 -->1280x1024,16b,fullscreen"
print "6 -->1280x1024,32b,fullscreen"
while ((graf_mode<1) or (graf_mode>6))
input "Enter the option for graphic mode : ",graf_mode
if ((graf_mode<1) or (graf_mode>6)) then print "Wrong value, the value must be 1 to 6 !"
wend
print ""
print "OK!"
print ""

print ""
print "Choose terrain :"
print "1 --> 17x17;"
print "2 --> 33x33;"
print "3 --> 65x65;"
print "4 --> 129x129;"
print "5 --> 257x257;"
print "6 --> 513x513;"
print "7 --> 1025x1025;"

while ((ch_terr<1) or (ch_terr>7))
input "Enter the option for terrain size: ",ch_terr
if (ch_terr<1) or (ch_terr>7) then print "Wrong value, the value must be 1 to 7 !"
wend
print""
print "OK!"
print ""

if (ch_terr=1) then terr_size=17
if (ch_terr=2) then terr_size=33
if (ch_terr=3) then terr_size=65
if (ch_terr=4) then terr_size=129
if (ch_terr=5) then terr_size=257
if (ch_terr=6) then terr_size=513
if (ch_terr=7) then terr_size=1025

if (ch_terr=1) then terr_scale_xz=80
if (ch_terr=2) then terr_scale_xz=40
if (ch_terr=3) then terr_scale_xz=20
if (ch_terr=4) then terr_scale_xz=10
if (ch_terr=5) then terr_scale_xz=5
if (ch_terr=6) then terr_scale_xz=2.5
if (ch_terr=7) then terr_scale_xz=1.25


print ""
print "Choose the colormap size : "
print "1 --> 512x512"
print "2 --> 1024x1024"
print "3 --> 2048x2048"
print "4 --> 4096x4096"
while ((cmsize<1) or (cmsize>4))
input "Enter the option for the colormap size : ",cmsize
if ((cmsize<1) or (cmsize>4)) then print "Wrong value, the value must be 1 to 4 !"
wend
print ""
print "OK!"
print ""
print ""
print "Choose the type of saved colormap: "
print "1 --> bmp file"
print "2 --> jpg file"
while ((cmtype<1) or (cmtype>2))
input "Enter the option for the type of saved colormap : ",cmtype
if ((cmtype<1) or (cmtype>2)) then print "Wrong value, the value must be 1 or 2 !"
wend
print ""
print "OK!"
print ""

if (cmsize=1) then wh=512
if (cmsize=2) then wh=1024
if (cmsize=3) then wh=2048
if (cmsize=4) then wh=4096

wt=wh
ht=wh

'Enable vertical synch.
nEnableVsync()

'Starts the Clady3D Engine
if (graf_mode=1) then InitEngine(graph_driver,800,600,16,1)
if (graf_mode=2) then InitEngine(graph_driver,800,600,32,1)
if (graf_mode=3) then InitEngine(graph_driver,1024,768,16,1)
if (graf_mode=4) then InitEngine(graph_driver,1024,768,32,1)
if (graf_mode=5) then InitEngine(graph_driver,1280,1024,16,1)
if (graf_mode=6) then InitEngine(graph_driver,1280,1024,32,1)




	nSetBackGroundColor(26,140,180)'Background Color
	nSetAmbientLight(255,255,255)'Ambient color
	nSetFog(0,0,200,0.001)' Fog
'Create a camera
camera = nCreateCameraFPS(100,0.15)
	nSetCameraRange(camera,1,3000)
	nSetEntityPosition(camera,0,256,0)' Position
    nSetCameraTarget(camera,640,30,640)
    

font01 = nLoadFont("font\courier.xml")'Load the font, in format XML


texWater = nLoadTexture("Data/textures/watercm.jpg")


   water = nCreateMeshWater (0.5,256,256)
   nSetMeshScale(water,25,0.2,25)
   nSetEntityPosition(water,650,water_level,650)
   nSetEntityTexture(water, texwater, 0)
   nSetEntityType(water,7)
   nSetEntityFlag(water,6,0)
   nSetEntityFlag(water,8,1)
  
   
   nSetMaterialTextureScale( water, 0, 0, 120, 120)

textile=nLoadTexture("Data/tiles/tilebase.jpg")
texdest=nCreateTexture("dest",wt,ht,3)


i=nBlendTextures (texdest,textile, 0,0,BLEND_SCREEN)
texeraser=nCreateTexture("eraser",wt,ht,3)
i=nBlendTextures (texeraser,textile, 0,0,BLEND_SCREEN)
nRemoveTexture(textile)

texsrc=nCreateTexture("source",wt,ht,3)
textile=nLoadTexture("Data/tiles/tile1.jpg")
i=nBlendTextures (texsrc,textile, 0,0,BLEND_SCREEN)
nRemoveTexture(textile)

alpha=150
radius=60
mode=0

texcolormap = nLoadTexture("Data/textures/colormap.jpg")
texdetail=nLoadTexture("Data/textures/detail.jpg")

scale_texture_cm=1

if (ch_terr=1) then terrain = nLoadTerrain("Data/textures/PLAINMAP17.bmp",0,4,17)
if (ch_terr=2) then terrain = nLoadTerrain("Data/textures/PLAINMAP33.bmp",0,4,17)
if (ch_terr=3) then terrain = nLoadTerrain("Data/textures/PLAINMAP65.bmp",0,4,17)
if (ch_terr=4) then terrain = nLoadTerrain("Data/textures/PLAINMAP129.bmp",0,4,17)
if (ch_terr=5) then terrain = nLoadTerrain("Data/textures/PLAINMAP257.bmp",0,4,17)
if (ch_terr=6) then terrain = nLoadTerrain("Data/textures/PLAINMAP513.bmp",0,4,17)
if (ch_terr=7) then terrain = nLoadTerrain("Data/textures/PLAINMAP1025.bmp",0,4,17)

nSetMeshScale(terrain,terr_scale_xz,1,terr_scale_xz)
nSetEntityPosition(terrain,0,0,0)
nSetEntityType(terrain,1)
nSetEntityTexture(terrain,texdest,0)
nSetEntityTexture(terrain,texdetail,1)
nSetScaleTerrainTexture(terrain,1,160)
nSetEntityFlag(terrain,3,1)

selector=nGetTerrainSelector(terrain)
arrow=nCreateArrow()

vertentry=nGetTerrainVerticesEntry(terrain)



   
shw=1
diam_sculpt=(terr_size-1)/4
pas=1.0
shape=1
u=0
v=0
pixelsrcstart=nLockTexture(texsrc)
pixeleraserstart=nLockTexture(texeraser)



While(EngineRun)'Returns 1 if the engine is running.

	'Begins scene
	BeginScene()
    
    
    if u>100000 then u=0
    if u>100000 then v=0
    u=u+0.001
    v=v+0.01
    nSetMaterialTextureUV( water, 0,0,u,v )
    if (nGetEntityY(camera)<WATER_LEVEL) and (shw=1) then nSetFog(26,140,180,0.01)
    if (nGetEntityY(camera)<WATER_LEVEL) and (shw=0) then nSetFog(200,240,250,0.002)
    if nGetEntityY(camera)>WATER_LEVEL then nSetFog(200,240,250,0.002)
   
    UpdateEngine(0.05)
    
    if mousehit(mouse_middle) then mode=mode+1
    if mode>1 then mode = 0
	'By pressing the "ESCAPE" closes the engine.
	If KeyHit(KEY_ESCAPE) Then CloseEngine()
    
    
    If KeyHit(KEY_E) Then wire = wire + 1
		
	If wire>1 Then wire = 0
	
	If Wire = 1 Then
		nSetEntityFlag(terrain,0,1)
	Else
		nSetEntityFlag(terrain,0,0)
	EndIf
    
    
    if keydown(key_O) then alpha=alpha+10
    if keydown(key_L) then alpha = alpha-10
    if alpha<0 then alpha=0
    if alpha>255 then alpha=255
    
    if keydown(key_I) then diam_sculpt=diam_sculpt+2
    if keydown(key_K) then diam_sculpt = diam_sculpt-2
    if diam_sculpt<2 then diam_sculpt=2
    
    
    
     If KeyHit(KEY_Q) Then 
        shw=1
        nShowEntity(water)
    end if
    
    If KeyHit(KEY_Z) Then 
        shw=0
        nHideEntity(water)
    end if
    
    If KeyHit(KEY_R) Then shape=1
    If KeyHit(KEY_T) Then shape=0
    
    If KeyHit(KEY_F) Then nSetEntityFlag(terrain,8,1)
    If KeyHit(KEY_G) Then nSetEntityFlag(terrain,8,0) 
    
    If KeyDown(KEY_U) Then pas=pas+0.5
    If KeyDown(KEY_J) Then pas=pas-0.5
    if pas>3 then pas=3
    if pas<1 then pas=1
    
    
    'detail on/off
    if keyhit(key_N) then 
        nSetEntityType(terrain,0)
   end if
    
    if keyhit(key_M) then 
        nSetEntityType(terrain,1)
    end if
    
    
    if keydown(key_b) then
        scale_detail=scale_detail+5
        if scale_detail>320 then scale_detail=320
        nSetScaleTerrainTexture(terrain,1,scale_detail)
    end if
    
    if keydown(key_v) then 
        scale_detail=scale_detail-5
        if scale_detail<1 then scale_detail=1
        nSetScaleTerrainTexture(terrain,1,scale_detail)
    end if
    
    
    If KeyDown(KEY_Y) Then WATER_LEVEL=WATER_LEVEL + 0.05
    If KeyDown(KEY_H) Then WATER_LEVEL=WATER_LEVEL - 0.05
    nSetEntityPosition(water,650,water_level,650)
    
    if keyhit(key_1) then
        nUnlockTexture(texsrc)
		textile=nLoadTexture("Data/tiles/tile1.jpg")
        nRemoveTexture(texsrc)
        texsrc=nCreateTexture("source",wt,ht,3)
        i=nBlendTextures (texsrc,textile, 0,0,BLEND_SCREEN)
        nRemoveTexture(textile)
        pixelsrcstart=nLockTexture(texsrc)
    end if
    if keyhit(key_2) then
        nUnlockTexture(texsrc)
		textile=nLoadTexture("Data/tiles/tile2.jpg")
        nRemoveTexture(texsrc)
        texsrc=nCreateTexture("source",wt,ht,3)
        i=nBlendTextures (texsrc,textile, 0,0,BLEND_SCREEN)
        nRemoveTexture(textile)
        pixelsrcstart=nLockTexture(texsrc)
    end if
    if keyhit(key_3) then
        nUnlockTexture(texsrc)
		textile=nLoadTexture("Data/tiles/tile3.jpg")
        nRemoveTexture(texsrc)
        texsrc=nCreateTexture("source",wt,ht,3)
        i=nBlendTextures (texsrc,textile, 0,0,BLEND_SCREEN)
        nRemoveTexture(textile)
        pixelsrcstart=nLockTexture(texsrc)
    end if
    if keyhit(key_4) then
        nUnlockTexture(texsrc)
		textile=nLoadTexture("Data/tiles/tile4.jpg")
        nRemoveTexture(texsrc)
        texsrc=nCreateTexture("source",wt,ht,3)
        i=nBlendTextures (texsrc,textile, 0,0,BLEND_SCREEN)
        nRemoveTexture(textile)
        pixelsrcstart=nLockTexture(texsrc)
    end if
    if keyhit(key_5) then
        nUnlockTexture(texsrc)
		textile=nLoadTexture("Data/tiles/tile5.jpg")
        nRemoveTexture(texsrc)
        texsrc=nCreateTexture("source",wt,ht,3)
        i=nBlendTextures (texsrc,textile, 0,0,BLEND_SCREEN)
        nRemoveTexture(textile)
        pixelsrcstart=nLockTexture(texsrc)
    end if
    if keyhit(key_6) then
        nUnlockTexture(texsrc)
		textile=nLoadTexture("Data/tiles/tile6.jpg")
        nRemoveTexture(texsrc)
        texsrc=nCreateTexture("source",wt,ht,3)
        i=nBlendTextures (texsrc,textile, 0,0,BLEND_SCREEN)
        nRemoveTexture(textile)
        pixelsrcstart=nLockTexture(texsrc)
    end if
    if keyhit(key_7) then
        nUnlockTexture(texsrc)
		textile=nLoadTexture("Data/tiles/tile7.jpg")
        nRemoveTexture(texsrc)
        texsrc=nCreateTexture("source",wt,ht,3)
        i=nBlendTextures (texsrc,textile, 0,0,BLEND_SCREEN)
        nRemoveTexture(textile)
        pixelsrcstart=nLockTexture(texsrc)
    end if
    if keyhit(key_8) then
        nUnlockTexture(texsrc)
		textile=nLoadTexture("Data/tiles/tile8.jpg")
        nRemoveTexture(texsrc)
        texsrc=nCreateTexture("source",wt,ht,3)
        i=nBlendTextures (texsrc,textile, 0,0,BLEND_SCREEN)
        nRemoveTexture(textile)
        pixelsrcstart=nLockTexture(texsrc)
    end if
    if keyhit(key_9) then
        nUnlockTexture(texsrc)
		textile=nLoadTexture("Data/tiles/tile9.jpg")
        nRemoveTexture(texsrc)
        texsrc=nCreateTexture("source",wt,ht,3)
        i=nBlendTextures (texsrc,textile, 0,0,BLEND_SCREEN)
        nRemoveTexture(textile)
        pixelsrcstart=nLockTexture(texsrc)
    end if
    
    if keyhit(key_0) then
        nUnlockTexture(texsrc)
		textile=nLoadTexture("Data/tiles/tile10.jpg")
        nRemoveTexture(texsrc)
        texsrc=nCreateTexture("source",wt,ht,3)
        i=nBlendTextures (texsrc,textile, 0,0,BLEND_SCREEN)
        nRemoveTexture(textile)
        pixelsrcstart=nLockTexture(texsrc)
    end if
    
    if keyhit(KEY_MINUS) then
        nUnlockTexture(texsrc)
		textile=nLoadTexture("Data/tiles/tile11.jpg")
        nRemoveTexture(texsrc)
        texsrc=nCreateTexture("source",wt,ht,3)
        i=nBlendTextures (texsrc,textile, 0,0,BLEND_SCREEN)
        nRemoveTexture(textile)
        pixelsrcstart=nLockTexture(texsrc)
    end if
    
    if keyhit(KEY_PLUS) then
        nUnlockTexture(texsrc)
		textile=nLoadTexture("Data/tiles/tileshader.jpg")
        nRemoveTexture(texsrc)
        texsrc=nCreateTexture("source",wt,ht,3)
        i=nBlendTextures (texsrc,textile, 0,0,BLEND_SCREEN)
        nRemoveTexture(textile)
        pixelsrcstart=nLockTexture(texsrc)
    end if

    nSetColors2D(150,0,0)
    nDrawFontText(20,15,"SHAPE SCULPT TOOL ( CIRCLE/SQUARE ) --> R / T",0,0)
    nDrawFontText(20,30,"SCULPT/PAINT MODE --> MIDDLE MOUSE BUTTON",0,0)
    nDrawFontText(20,45,"RAISE SCULPT / PAINT --> LEFT MOUSE BUTTON",0,0)
    nDrawFontText(20,60,"DECREASE SCULPT / ERASER PAINT --> RIGHT MOUSE BUTTON",0,0)
    nDrawFontText(20,75,"INCREASE/DECREASE RADIUS TOOL --> I / K",0,0)
    nDrawFontText(20,90,"INCREASE/DECREASE SPEED SCULPT --> U / J",0,0)
    nDrawFontText(20,105,"INCREASE/DECREASE ALPHA PAINT --> O / L",0,0)
    nDrawFontText(20,120,"INCREASE/DECREASE WATER LEVEL --> Y / H",0,0)
    nDrawFontText(20,135,"FOG ON/OF --> G / F",0,0)
    nDrawFontText(20,150,"WATER SHOW/HIDE -->Q / Z",0,0)
    nDrawFontText(20,165,"WIREFRAME ON / OFF --> E",0,0)
    nDrawFontText(20,180,"SET TILE PAINT --> 1 TO 0, minus, plus KEY",0,0)
    nDrawFontText(20,195,"SAVE HEIGHTMAP --> F2 IN SCULPT MODE",0,0)
    nDrawFontText(20,210,"SAVE COLORMAP --> F2 IN PAINT MODE",0,0)
    nDrawFontText(20,225,"DETAIL ON/OFF --> M / N",0,0)
    nDrawFontText(20,240,"SCALE DETAIL (+/-) --> B / V",0,0)
    nDrawFontText(20,255,"CAMERA FPS --> W,A,S,D",0,0)
     
    nDrawFontText(400,40,"FPS = "+STR(FPS),0,0)
    
    nDrawFontText(600,15,"WATER LEVEL = "+STR(WATER_LEVEL),0,0)
    nDrawFontText(600,30,"ALPHA PAINT = "+STR(ALPHA),0,0)
    nDrawFontText(600,45,"DETAIL SCALE FACTOR = "+STR(SCALE_DETAIL),0,0)
    nDrawFontText(600,60,"TERRAIN X = : "+STR(XPOS),0,0)
    nDrawFontText(600,75,"TERRAIN Z = : "+STR(ZPOS),0,0)
    nDrawFontText(600,90,"TERRAIN Y = : "+STR(nGetTerrainHeight(TERRAIN,XPOS,ZPOS)),0,0)
    
if mode=0 then
    
    
    nDrawFontText(400,20,"SCULPT   MODE",0,0)
    
    nSetEntityPosition(water,650,water_level,650)
    
    xpos=nGetXPoSArrow(terrain,arrow,selector,camera,terr_scale_xz,1,terr_size)
    zpos=nGetZPoSArrow(terrain,arrow,selector,camera,terr_scale_xz,1,terr_size)
    If MouseDown(MOUSE_LEFT) Then nSetHeightTerrainVerticesGroup2(terrain,diam_sculpt,xpos,zpos,pas,1,terr_scale_xz,1,terr_size,shape,vertentry)
    If MouseDown(MOUSE_RIGHT) Then nSetHeightTerrainVerticesGroup2(terrain,diam_sculpt,xpos,zpos,pas,0,terr_scale_xz,1,terr_size,shape,vertentry)
    
    If KeyDown(KEY_F2) Then nSaveTerrainHM(terrain, terr_size)
    
    if shape=1 then
  xr1=diam_sculpt/2*terr_scale_xz
  zr1=0
  yr1=nGetTerrainHeight(terrain,xpos+xr1,zpos+zr1)
  if (xpos+xr1<0) or (xpos+xr1>terr_size*terr_scale_xz) or (zpos+zr1<0) or (zpos+zr1>terr_size*terr_scale_xz) then yr1=water_level
  for j=0 to 360 step 10
      xr2=diam_sculpt/2*terr_scale_xz*cos(j*3.1415926535897932/180)
      zr2=diam_sculpt/2*terr_scale_xz*sin(j*3.1415926535897932/180)
      yr2=nGetTerrainHeight(terrain,xpos+xr2,zpos+zr2)
      if (xpos+xr2<0) or (xpos+xr2>terr_size*terr_scale_xz) or (zpos+zr2<0) or (zpos+zr2>terr_size*terr_scale_xz) then yr2=water_level
      nDrawLine3D(xpos+xr1,yr1+2,zpos+zr1,xpos+xr2,yr2+2,zpos+zr2,2,150,255,0,0)
        xr1=xr2
        yr1=yr2
        zr1=zr2
        if (xpos+xr1<0) or (xpos+xr1>terr_size*terr_scale_xz) or (zpos+zr1<0) or (zpos+zr1>terr_size*terr_scale_xz) then yr1=water_level
    next
end if
if shape=0 then
    xr1=diam_sculpt/2*terr_scale_xz+xpos
    zr1=zpos-diam_sculpt/2*terr_scale_xz
    yr1=nGetTerrainHeight(terrain,xr1,zr1)
    xr2=xr1
    zr2=zpos+diam_sculpt/2*terr_scale_xz
    yr2= nGetTerrainHeight(terrain,xr2,zr2)
    nDrawLine3D(xr1,yr1+2,zr1,xr2,yr2+2,zr2,2,150,255,0,0)
    xr1=xr2
    yr1=yr2
    zr1=zr2
    xr2=xpos-diam_sculpt/2*terr_scale_xz
    zr2=zpos+diam_sculpt/2*terr_scale_xz
    yr2= nGetTerrainHeight(terrain,xr2,zr2)
    nDrawLine3D(xr1,yr1+2,zr1,xr2,yr2+2,zr2,2,150,255,0,0)
    xr1=xr2
    yr1=yr2
    zr1=zr2
    xr2=xpos-diam_sculpt/2*terr_scale_xz
    zr2=zpos-diam_sculpt/2*terr_scale_xz
    yr2= nGetTerrainHeight(terrain,xr2,zr2)
    nDrawLine3D(xr1,yr1+2,zr1,xr2,yr2+2,zr2,2,150,255,0,0)
    xr1=xr2
    yr1=yr2
    zr1=zr2
    xr2=xpos+diam_sculpt/2*terr_scale_xz
    zr2=zpos-diam_sculpt/2*terr_scale_xz
    yr2= nGetTerrainHeight(terrain,xr2,zr2)
    nDrawLine3D(xr1,yr1+2,zr1,xr2,yr2+2,zr2,2,150,255,0,0)
end if
end if

    
    
if mode=1 then
    
    nDrawFontText(400,20,"PAINT   MODE",0,0)
    
 	
    radius=int((diam_sculpt/2)*wt/terr_size)
    

    xpos=nGetXPoSArrow(terrain,arrow,selector,camera,terr_scale_xz,1,terr_size)
    zpos=nGetZPoSArrow(terrain,arrow,selector,camera,terr_scale_xz,1,terr_size)
    yt=int(xpos*wt/(terr_size*terr_scale_xz))
    xt=int(zpos*wt/(terr_size*terr_scale_xz))
    If MouseDown(MOUSE_LEFT) Then 
        pixeldeststart=nLockTexture(texdest)
        nPaintTiletextureWithAlpha3(texdest,texsrc,pixeldeststart,pixelsrcstart,xt,wt-yt,radius,alpha)
        nUnlockTexture(texdest)
    end if
    
    'erase
    If MouseDown(MOUSE_RIGHT) Then 
        pixeldeststart=nLockTexture(texdest)
        nPaintTiletextureWithAlpha3(texdest,texeraser,pixeldeststart,pixeleraserstart,xt,wt-yt,radius,alpha)
        nUnlockTexture(texdest)
    end if
    
    If KeyHit(KEY_F2) Then 
       imgcmsave=nCreateImageFromTexture(texdest,0,0,wt,ht)
        nWriteImageToFile(imgcmsave,cmtype)
        nRemoveImage(imgcmsave)
    end if
    
   shape=1

  xr1=diam_sculpt/2*terr_scale_xz
  zr1=0
  yr1=nGetTerrainHeight(terrain,xpos+xr1,zpos+zr1)
  if (xpos+xr1<0) or (xpos+xr1>terr_size*terr_scale_xz) or (zpos+zr1<0) or (zpos+zr1>terr_size*terr_scale_xz) then yr1=water_level
  for j=0 to 360 step 10
      xr2=diam_sculpt/2*terr_scale_xz*cos(j*3.1415926535897932/180)
      zr2=diam_sculpt/2*terr_scale_xz*sin(j*3.1415926535897932/180)
      yr2=nGetTerrainHeight(terrain,xpos+xr2,zpos+zr2)
      if (xpos+xr2<0) or (xpos+xr2>terr_size*terr_scale_xz) or (zpos+zr2<0) or (zpos+zr2>terr_size*terr_scale_xz) then yr2=water_level
      nDrawLine3d(xpos+xr1,yr1+2,zpos+zr1,xpos+xr2,yr2+2,zpos+zr2,2,150,255,0,0)
        xr1=xr2
        yr1=yr2
        zr1=zr2
        if (xpos+xr1<0) or (xpos+xr1>terr_size*terr_scale_xz) or (zpos+zr1<0) or (zpos+zr1>terr_size*terr_scale_xz) then yr1=water_level
    next
  
end if
    



'End the scene
	EndScene()
	
Wend
nUnlockTexture(texsrc)
nUnlockTexture(texeraser)
'Ends Clady3D Engine
EndEngine()

