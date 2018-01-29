#Include "Clady3D.bi"


dim Shared camera As nCAMERA
dim shared camerastatic as ncamera
dim shared as nfont font01
dim shared as ntexture texmartor,textile,texdest,texeraser,texsrc,microtextilebase,_
                microtextile1,microtextile2,microtextile3,microtextile4,microtextile5,_
                microtextile6,microtextile7,microtextile8,microtextile9,microtextileshader,_
                curentsplat,othersplata,othersplatb,othersplatc

dim shared as nimage imgcmsave,microimtilebase,microimtile1,microimtile2,microimtile3,microimtile4,_
                microimtile5,microimtile6,microimtile7,microimtile8,microimtile9,microimtileshader,_
                maximagebase,maximagetile1,maximagetile2,maximagetile3,maximagetile4,maximagetile5,maximagetile6,maximagetile7,_
                maximagetile8,maximagetile9,maximagetileshader
dim shared as integer i,alpha,radius,mode
DIM shared as SINGLE water_level,xr1,yr1,zr1,xr2,yr2,zr2,scale_texture_cm,pas,u,v,xcam,ycam,zcam,txcam,tycam,tzcam
dim shared as single mousewh
dim shared as integer wh,cmsize,driver,graf_mode,ws,hs,wt,ht,xs,ys,xt,yt,xofft,yofft,cmtype,_
                        xoffm,yoffm,xm,ym,wm,hm,rm,scale_detail,sd,progr,nrtile

Dim shared terrain As nTERRAIN
Dim shared As nTEXTURE texcolormap,texdetailmap,tex05,tex53,texwater,texreflex,texdetail,texsky
Dim shared As nClouds clouds
Dim shared As Integer wire,terr_size,ch_terr,terr_scale_xz,j,xpos,zpos,shw,_
                diam_sculpt,shape,chanel,nr_stages
dim shared as nTriSelector selector
dim shared as nArrow arrow
dim shared as uinteger ptr vertentry
Dim shared As nMESH water




declare sub progr1()
declare sub progr2()

progr=1

nEnableVsync()
nEnableAntialias()
driver=-1
graf_mode=-1
ch_terr=-1
nr_stages=-1
cmsize=1
wt=512
ht=512
terr_size=-1
terr_scale_xz=-1
xofft=0
yofft=0
cmtype=1

progr1()

do
if progr=2 then progr2()
loop until progr=-1

sub progr1()
    InitEngine(0,800,600,16,0)
    nSetAppTitle("Clady3DTerrainSplatEditor")
    nSetBackGroundColor(0,0,0)
    nSetAmbientLight(200,200,200)
    
    Dim camera As nCAMERA
    camera = nCreateCamera( )
    
    font01 = nLoadFont("font\courier.xml")'Load the font, in format XML
    
    
    dim as uinteger ptr texscrshoot=nLoadTexture("data/textures/scrshoot.jpg")
    dim as uinteger ptr imgscrshoot=nAddImageGUI(0,0,800,600,"",0)
    nSetImageGUI(imgscrshoot,texscrshoot)
    
    dim as uinteger ptr texlogo=nLoadTexture("data/textures/logo.tga")
    dim as uinteger ptr imglogo=nAddImageGUI(250,100,320,200,"",0)
    nSetImageGUI(imglogo,texlogo)
    nSetUseAlphaChannelImageGUI(imglogo,1)
    
    
    dim as uinteger ptr driverstatictext=nAddStaticText("Driver",100,280,115,20,0,0,0,0)
    dim as uinteger ptr drivercombobox=nAddComboBox(100,300,115,20,0)
    dim as integer itemOpenGL=nAddItemComboBox(drivercombobox,"OpenGL")
    dim as integer itemDirectX90c=nAddItemComboBox(drivercombobox,"DirectX9.0c")
    nSetSelectedItemComboBox(drivercombobox,1)
    driver=nGetSelectedItemComboBox(drivercombobox)
    
    dim as uinteger ptr graf_modestatictext=nAddStaticText("Graphic mode",300,280,115,20,0,0,0,0)
    dim as uinteger ptr gmcombobox=nAddComboBox(300,300,115,20,0)
    dim as integer item800x600x16x1=nAddItemComboBox(gmcombobox,"800x600x16,fullscreen")
    dim as integer item800x600x32x1=nAddItemComboBox(gmcombobox,"800x600x32,fullscreen")
    dim as integer item1024x768x16x1=nAddItemComboBox(gmcombobox,"1024x768x16,fullscreen")
    dim as integer item1024x768x32x1=nAddItemComboBox(gmcombobox,"1024x768x32,fullscreen")
    dim as integer item1280x1024x16x1=nAddItemComboBox(gmcombobox,"1280x1024x16,fullscreen")
    dim as integer item1280x1024x32x1=nAddItemComboBox(gmcombobox,"1280x1024x32,fullscreen")
    nSetSelectedItemComboBox(gmcombobox,1)
    graf_mode=nGetSelectedItemComboBox(gmcombobox)

    dim as uinteger ptr ch_terrstatictext=nAddStaticText("Heightmap size",500,280,115,20,0,0,0,0)
    dim as uinteger ptr tscombobox=nAddComboBox(500,300,80,20,0)
    dim as integer item17x17=nAddItemComboBox(tscombobox,"17x17")
    dim as integer item33x33=nAddItemComboBox(tscombobox,"33x33")
    dim as integer item65x65=nAddItemComboBox(tscombobox,"65x65")
    dim as integer item129x129=nAddItemComboBox(tscombobox,"129x129")
    dim as integer item257x257=nAddItemComboBox(tscombobox,"257x257")
    dim as integer item513x513=nAddItemComboBox(tscombobox,"513x513")
    dim as integer item1025x1025=nAddItemComboBox(tscombobox,"1025x1025")
    nSetSelectedItemComboBox(tscombobox,2)
    ch_terr=nGetSelectedItemComboBox(tscombobox)
    
    dim as uinteger ptr nr_stagesstatictext=nAddStaticText("Shading stages",700,280,115,20,0,0,0,0)
    dim as uinteger ptr nrscombobox=nAddComboBox(700,300,35,20,0)
    dim as integer itemns1=nAddItemComboBox(nrscombobox,"1")
    dim as integer itemns2=nAddItemComboBox(nrscombobox,"2")
    dim as integer itemns3=nAddItemComboBox(nrscombobox,"3")
    dim as integer itemns4=nAddItemComboBox(nrscombobox,"4")
    nSetSelectedItemComboBox(nrscombobox,1)
    nr_stages=nGetSelectedItemComboBox(nrscombobox)
    
    
    dim as uinteger ptr spacestatictext=nAddStaticText("Press SPACE - key to continue... ",350,400,200,20,0,0,0,0)
    
    cmsize=1
    wt=512
    ht=512
    
    nSetTransparencyGUI(255)
    
    While(EngineRun)
   
    BeginScene()
    UpdateEngine(0.05)
    If KeyHit(KEY_SPACE) Then 
        progr=2
        CloseEngine()
    end if
    driver=nGetSelectedItemComboBox(drivercombobox)
    graf_mode=nGetSelectedItemComboBox(gmcombobox)
    ch_terr=nGetSelectedItemComboBox(tscombobox)
    nr_stages=nGetSelectedItemComboBox(nrscombobox)
    EndScene()
    Wend
    EndEngine()
end sub



sub progr2()
    
    nr_stages=nr_stages+1

    if (ch_terr=0) then terr_size=17
    if (ch_terr=1) then terr_size=33
    if (ch_terr=2) then terr_size=65
    if (ch_terr=3) then terr_size=129
    if (ch_terr=4) then terr_size=257
    if (ch_terr=5) then terr_size=513
    if (ch_terr=6) then terr_size=1025

    if (ch_terr=0) then terr_scale_xz=80
    if (ch_terr=1) then terr_scale_xz=40
    if (ch_terr=2) then terr_scale_xz=20
    if (ch_terr=3) then terr_scale_xz=10
    if (ch_terr=4) then terr_scale_xz=5
    if (ch_terr=5) then terr_scale_xz=2.5
    if (ch_terr=6) then terr_scale_xz=1.25




'Starts the Ninfa3D Engine


if (graf_mode=0) then
    ws=800
    hs=600
    if (driver=0) then InitEngine(0,800,600,16,1)
    if (driver=1) then InitEngine(1,800,600,16,1)
    nSetAppTitle("Clady3DTerrainSplatEditor")
end if

if (graf_mode=1) then
    ws=800
    hs=600
    if (driver=0) then InitEngine(0,800,600,32,1)
    if (driver=1) then InitEngine(1,800,600,32,1)
    nSetAppTitle("Clady3DTerrainSplatEditor")
end if

if (graf_mode=2) then
    ws=1024
    hs=768
    if (driver=0) then InitEngine(0,1024,768,16,1)
    if (driver=1) then InitEngine(1,1024,768,16,1)
    nSetAppTitle("Clady3DTerrainSplatEditor")
end if

if (graf_mode=3) then
    ws=1024
    hs=768
    if (driver=0) then InitEngine(0,1024,768,32,1)
    if (driver=1) then InitEngine(1,1024,768,32,1)
    nSetAppTitle("Clady3DTerrainSplatEditor")
end if

if (graf_mode=4) then 
    ws=1280
    hs=1024
    if (driver=0) then InitEngine(0,1280,1024,16,1)
    if (driver=1) then InitEngine(1,1280,1024,16,1)
    nSetAppTitle("Clady3DTerrainSplatEditor")
end if

if (graf_mode=5) then 
    ws=1280
    hs=1024
    if (driver=0) then InitEngine(0,1280,1024,32,1)
    if (driver=1) then InitEngine(1,1280,1024,32,1)
    nSetAppTitle("Clady3DTerrainSplatEditor")
end if




	nSetBackGroundColor(26,140,180)'Background Color
    'BackGroundColor(250,250,250)'Background Color
	nSetAmbientLight(255,255,255)'Ambient color
	nSetFog(0,0,200,0.001)' Fog
camerastatic = nCreateCamera()
'Create a camera
camera = nCreateCameraFPS(100,0.15)
	nSetCameraRange(camera,1,3000)
	nSetEntityPosition(camera,640,256,-100)' Position
    nSetCameraTarget(camera,640,30,640)
    

    
font01 = nLoadFont("font\courier.xml")'Load the font, in format XML

dim as uinteger ptr imgunderwater=nAddImageGUI(0,0,ws,hs,"",0)
nSetColorImageGUI(imgunderwater,0,0,225,255)
nSetTransparencyGUI(180)
nSetVisibleGUIElement(imgunderwater,0)

dim as uinteger ptr texwait=nLoadTexture("data/textures/wait.tga")
dim as uinteger ptr imgwait=nAddImageGUI(ws/2-80,hs/2-200,160,120,"",0)
nSetImageGUI(imgwait,texwait)
nSetUseAlphaChannelImageGUI(imgwait,1)
nSetVisibleGUIElement(imgwait,0)


dim as uinteger ptr Radiusstatictext=nAddStaticText("Tool Radius",ws-210,20,60,16,0,0,0,0)
dim as uinteger ptr scrollBarRadius=nCreateGUIScrollBar(ws-150,20,100,16,0,0)
nSetScrollBarSmallStep(scrollbarradius,1)
nSetMinScrollBar(scrollbarradius,1)
nSetMaxScrollBar(scrollbarradius,(terr_size-1)/2)
nSetScrollBarPosition(scrollbarradius,(terr_size-1)/16)

dim as uinteger ptr StrenghtSculptstatictext=nAddStaticText("Strenght Sculpt",ws-210,40,60,16,0,0,0,0)
dim as uinteger ptr scrollBarStrenghtSculpt=nCreateGUIScrollBar(ws-150,40,100,16,0,0)
nSetScrollBarSmallStep(scrollBarStrenghtSculpt,1)
'setMinScrollBar(scrollBarStrenghtSculpt,1)
'setMaxScrollBar(scrollBarStrenghtSculpt,100)
nSetScrollBarPosition(scrollBarStrenghtSculpt,75)

dim as uinteger ptr Alphastatictext=nAddStaticText("Alpha Paint",ws-210,60,60,16,0,0,0,0)
dim as uinteger ptr scrollBarAlpha=nCreateGUIScrollBar(ws-150,60,100,16,0,0)
nSetScrollBarSmallStep(scrollbaralpha,1)
nSetMinScrollBar(scrollbaralpha,0)
nSetMaxScrollBar(scrollbaralpha,255)
nSetScrollBarPosition(scrollbaralpha,100)

dim as uinteger ptr WaterLevelstatictext=nAddStaticText("Water Level",ws-210,100,60,16,0,0,0,0)
dim as uinteger ptr scrollBarWaterLevel=nCreateGUIScrollBar(ws-150,100,100,16,0,0)
nSetScrollBarSmallStep(scrollBarWaterLevel,1)
nSetMinScrollBar(scrollBarWaterLevel,0)
nSetMaxScrollBar(scrollBarWaterLevel,255)
nSetScrollBarPosition(scrollBarWaterLevel,29)

dim as uinteger ptr ScaleDetailstatictext=nAddStaticText("Detail Scale",ws-210,120,60,16,0,0,0,0)
dim as uinteger ptr scrollBarScaleDetail=nCreateGUIScrollBar(ws-150,120,100,16,0,0)
nSetScrollBarSmallStep(scrollBarScaleDetail,1)
nSetMinScrollBar(scrollBarScaleDetail,0)
nSetMaxScrollBar(scrollBarScaleDetail,126)
nSetScrollBarPosition(scrollBarScaleDetail,8)

dim as uinteger ptr texpaint=nLoadTexture("data/textures/paintz.bmp")
dim as uinteger ptr texsculpt=nLoadTexture("data/textures/sculptz.bmp")
dim as uinteger ptr texupsculpt=nLoadTexture("data/textures/up_sculptz.bmp")
dim as uinteger ptr texdownsculpt=nLoadTexture("data/textures/down_sculptz.bmp")
dim as uinteger ptr texcyrshape=nLoadTexture("data/textures/cyr_shapez.bmp")
dim as uinteger ptr texrectshape=nLoadTexture("data/textures/rect_shapez.bmp")
dim as uinteger ptr texexitup=nLoadTexture("data/textures/exitup.bmp")
dim as uinteger ptr texexitdown=nLoadTexture("data/textures/exitdown.bmp")
dim as uinteger ptr texsavehmup=nLoadTexture("data/textures/savehm_up.bmp")
dim as uinteger ptr texsavecmup=nLoadTexture("data/textures/savecm_up.bmp")
dim as uinteger ptr texsavesmup=nLoadTexture("data/textures/savesm_up.bmp")
dim as uinteger ptr texsaved=nLoadTexture("data/textures/saved.bmp")


dim as uinteger ptr buttswitchmode=nCreateGUIButtonToolTip(ws-100,150,32,32,"","SCULPT/PAINT SWITCH",0)
nSetIsPushButton(buttswitchmode,1)
nSetButtonImageNormal(buttswitchmode,texsculpt,0,0,32,32)
nSetButtonImagePressed(buttswitchmode,texpaint,0,0,32,32)
nButtonDrawBorder(buttswitchmode,1)

dim as uinteger ptr buttupdownsculpt=nCreateGUIButtonToolTip(ws-100,200,32,32,"","UP/DOWN SCULPT SWITCH",0)
nSetIsPushButton(buttupdownsculpt,1)
nSetButtonImageNormal(buttupdownsculpt,texupsculpt,0,0,32,32)
nSetButtonImagePressed(buttupdownsculpt,texdownsculpt,0,0,32,32)
nButtonDrawBorder(buttupdownsculpt,1)

dim as uinteger ptr buttshapesculpt=nCreateGUIButtonToolTip(ws-100,250,32,32,"","SCULPT SHAPE SWITCH",0)
nSetIsPushButton(buttshapesculpt,1)
nSetButtonImageNormal(buttshapesculpt,texcyrshape,0,0,32,32)
nSetButtonImagePressed(buttshapesculpt,texrectshape,0,0,32,32)
nButtonDrawBorder(buttshapesculpt,1)



dim as uinteger ptr combobox1=nAddComboBox(ws-110,300,64,20,0)

dim as integer tilecb1=nAddItemComboBox(combobox1,"tile1_red")
dim as integer tilecb2=nAddItemComboBox(combobox1,"tile1_green")
dim as integer tilecb3=nAddItemComboBox(combobox1,"tile1_blue")
if nr_stages>1 then
    dim as integer tilecb4=nAddItemComboBox(combobox1,"tile2_red")
    dim as integer tilecb5=nAddItemComboBox(combobox1,"tile2_green")
    dim as integer tilecb6=nAddItemComboBox(combobox1,"tile2_blue")
end if
if nr_stages>2 then
    dim as integer tilecb7=nAddItemComboBox(combobox1,"tile3_red")
    dim as integer tilecb8=nAddItemComboBox(combobox1,"tile3_green")
    dim as integer tilecb9=nAddItemComboBox(combobox1,"tile3_blue")
end if
if nr_stages>3 then
    dim as integer tilecb10=nAddItemComboBox(combobox1,"tile4_red")
    dim as integer tilecb11=nAddItemComboBox(combobox1,"tile4_green")
    dim as integer tilecb12=nAddItemComboBox(combobox1,"tile4_blue")
end if





'setTransparencyGUI(255)


dim as integer sbarradiuspos,sbaralphapos,sbarstrenghtsculptpos,sbarwaterlevelpos,sbarscaledetailpos


water_level=nGetScrollBarXY(scrollbarwaterlevel)
dim as integer wl=water_level
scale_detail=nGetScrollBarXY(scrollbarScaleDetail)
sd=scale_detail

texWater = nLoadTexture("Data/textures/watercm.jpg")


   water = nCreateMeshWater (0.5,256,256)
   nSetMeshScale(water,25,0.2,25)
   nSetEntityPosition(water,650,water_level,650)
   nSetEntityTexture(water, texwater, 0)
   nSetEntityType(water,7)
   nSetEntityFlag(water,6,0)
   nSetEntityFlag(water,8,1)
   nSetMaterialTextureScale( water, 0, 0, 120, 120)
'dim as ntexture texsplatbase=loadtexture("data/splatmap/splatbase.tga")   
dim as ntexture texsplat1=nLoadTexture("data/splatmap/splat_1.tga")
dim as ntexture tile1_red=nLoadTexture("data/textures/tile1_red.jpg")
dim as ntexture tile1_green=nLoadTexture("data/textures/tile1_green.jpg")
dim as ntexture tile1_blue=nLoadTexture("data/textures/tile1_blue.jpg")

    dim as ntexture texsplat2=nLoadTexture("data/splatmap/splat_2.tga")
    dim as ntexture tile2_red=nLoadTexture("data/textures/tile2_red.jpg")
    dim as ntexture tile2_green=nLoadTexture("data/textures/tile2_green.jpg")
    dim as ntexture tile2_blue=nLoadTexture("data/textures/tile2_blue.jpg")


    dim as ntexture texsplat3=nLoadTexture("data/splatmap/splat_3.tga")
    dim as ntexture tile3_red=nLoadTexture("data/textures/tile3_red.jpg")
    dim as ntexture tile3_green=nLoadTexture("data/textures/tile3_green.jpg")
    dim as ntexture tile3_blue=nLoadTexture("data/textures/tile3_blue.jpg")


    dim as ntexture texsplat4=nLoadTexture("data/splatmap/splat_4.tga")
    dim as ntexture tile4_red=nLoadTexture("data/textures/tile4_red.jpg")
    dim as ntexture tile4_green=nLoadTexture("data/textures/tile4_green.jpg")
    dim as ntexture tile4_blue=nLoadTexture("data/textures/tile4_blue.jpg")

    dim as ntexture texsplatlm=nLoadTexture("data/splatmap/splat_lm.tga")
    dim as ntexture tile_lm=nLoadTexture("data/textures/tile_lm.jpg")



dim as uinteger ptr imagegui1=nAddImageGUI(ws-150,300,32,32,"tile",0)
nSetUseAlphaChannelImageGUI(imagegui1,1)
nSetScaleImageGUI(imagegui1,1)
nSetImageGUI(imagegui1,tile1_red)

alpha=nGetScrollBarXY(scrollbaralpha)
radius=nGetScrollBarXY(scrollbarradius)
mode=0



scale_texture_cm=1

if (ch_terr=0) then terrain = nLoadTerrain("Data/textures/PLAINMAP17.bmp",0,4,17)
if (ch_terr=1) then terrain = nLoadTerrain("Data/textures/PLAINMAP33.bmp",0,4,17)
if (ch_terr=2) then terrain = nLoadTerrain("Data/textures/PLAINMAP65.bmp",0,4,17)
if (ch_terr=3) then terrain = nLoadTerrain("Data/textures/PLAINMAP129.bmp",0,4,17)
if (ch_terr=4) then terrain = nLoadTerrain("Data/textures/PLAINMAP257.bmp",0,4,17)
if (ch_terr=5) then terrain = nLoadTerrain("Data/textures/PLAINMAP513.bmp",0,4,17)
if (ch_terr=6) then terrain = nLoadTerrain("Data/textures/PLAINMAP1025.bmp",0,4,17)
nSetMeshScale(terrain,terr_scale_xz,1,terr_scale_xz)
nSetScaleTerrainTexture(terrain,1,scale_detail)'Scale the texture of the terrain splat
scale_detail=8
Dim splatOGL as nsplatmanagerogl
Dim splatDX9 as nsplatmanagerDX9
if (driver=0) then 
splatOGL=nCreateSplatManagerOGL()
nBindSplatManagerOGLwithTerrain2(splatOGL,terrain,texsplat1,texsplat2,texsplat3,texsplat4,texsplatlm,_
                                tile1_red,tile1_green,tile1_blue,_
                                tile2_red,tile2_green,tile2_blue,_
                                tile3_red,tile3_green,tile3_blue,_
                                tile4_red,tile4_green,tile4_blue,tile_lm,_
                                nr_stages,1,0)
end if
                            
if (driver=1) then 
splatDX9=nCreateSplatManagerDX9()
nBindSplatManagerDX9withTerrain2(splatDX9,terrain,texsplat1,texsplat2,texsplat3,texsplat4,texsplatlm,_
                                tile1_red,tile1_green,tile1_blue,_
                                tile2_red,tile2_green,tile2_blue,_
                                tile3_red,tile3_green,tile3_blue,_
                                tile4_red,tile4_green,tile4_blue,tile_lm,_
                                nr_stages,1,0)
end if


selector=nGetTerrainSelector(terrain)
arrow=nCreateArrow()

vertentry=nGetTerrainVerticesEntry(terrain)

'texsky=loadtexture("data/textures/skydome.jpg")
'CreateSkyDome(texsky,3000)'Creates the sky

   
shw=1
diam_sculpt=2*nGetScrollBarXY(scrollbarradius)
pas=nGetScrollBarXY(scrollbarstrenghtsculpt)*3/100
shape=1
u=0
v=0
        curentsplat=texsplat1
        othersplata=texsplat1
        othersplatb=texsplat1
        othersplatc=texsplat1
        chanel=1
        wh=512
  dim as integer xsplat,ysplat,stage      
   ' for xsplat=0 to 512 step 80
     '  for ysplat=0 to 512 step 80
     '   PaintSplatOGL(curentsplat,othersplata,othersplatb,othersplatc,4,1,xsplat,ysplat,90,255)
     '  next
    'next
    'othersplatc=texsplat4
   ' for xsplat=0 to 512 step 80
      ' for ysplat=0 to 512 step 80
      '  PaintSplatOGL(curentsplat,othersplata,othersplatb,othersplatc,1,1,xsplat,ysplat,90,255)
      ' next
    'next
    dim as integer modecam
    modecam=1
    
    'dim as integer diam_sculpt_max=2*int(90*terr_size/wt)
    
dim as integer xmempos,zmempos

dim as integer renderpas
curentsplat=texsplat1
othersplata=texsplat2
othersplatb=texsplat3
othersplatc=texsplat4
stage=1
chanel=1
renderpas=0
nSetVisibleGUIElement(imgunderwater,0)
While(EngineRun)'Returns 1 if the engine is running.

	'Begins scene
	BeginScene()
     
    
    if u>100000 then u=0
    if u>100000 then v=0
    u=u+0.001
    v=v+0.01
    nSetMaterialTextureUV( water, 0,0,u,v )
    
    if (driver=0) then
        if (nGetEntityY(camera)<WATER_LEVEL) and (shw=1) then nSetVisibleGUIElement(imgunderwater,1)
        if (nGetEntityY(camera)<WATER_LEVEL) and (shw=0) then nSetVisibleGUIElement(imgunderwater,0)   
        if nGetEntityY(camera)>WATER_LEVEL then nSetVisibleGUIElement(imgunderwater,0)
    end if
    
    if (driver=1) then
       if (nGetEntityY(camera)<WATER_LEVEL) and (shw=1) then nSetFog(26,140,180,0.01)
        if (nGetEntityY(camera)<WATER_LEVEL) and (shw=0) then nSetFog(200,240,250,0.002)
        if nGetEntityY(camera)>WATER_LEVEL then nSetFog(200,240,250,0.002) 
    end if
    
    nSetColors2D(255,255,255)
    
    
   
    
   
    UpdateEngine(0.5)
    if (driver=0) then nDrawSplatOGL(splatOGL)
    if (driver=1) then nDrawSplatDX9(splatDX9)
        
    updateengine(0.5)
    
    
    if KeyHit(KEY_SPACE) then modecam=modecam+1
    if modecam>1 then modecam=0
    if modecam=0 then
        xcam=nGetentityx(camera)
        ycam=nGetentityy(camera)
        zcam=nGetentityz(camera)
        txcam=nGetCameraTargetX(camera)
        tycam=nGetCameraTargetY(camera)
        tzcam=nGetCameraTargetZ(camera)
        nSetActiveCamera(camerastatic)
        nSetEntityPosition(camerastatic,xcam,ycam,zcam)
        nSetCameraTarget(camerastatic,txcam,tycam,tzcam)
        ShowMouse()
    end if
    if modecam=1 then 
        movemouse(ws/2,hs/2)
        nSetActiveCamera(camera)
        HideMouse()
    end if
    
    
    
    if mousehit(mouse_middle) then mode=mode+1
    if mode>1 then mode = 0
	'By pressing the "ESCAPE" closes the engine.
	If KeyHit(KEY_ESCAPE) Then 
        progr=-1
        CloseEngine()
    end if
    
    
    If KeyHit(KEY_E) Then wire = wire + 1
		
	If wire>1 Then wire = 0
	
	If Wire = 1 Then
		nSetEntityFlag(terrain,0,1)
	Else
		nSetEntityFlag(terrain,0,0)
	EndIf
    
    alpha=nGetScrollBarXY(scrollbaralpha)
    'if keydown(key_O) then alpha=alpha+10
    'if keydown(key_L) then alpha = alpha-10
    'if alpha<0 then alpha=0
    'if alpha>255 then alpha=255
    
    
    diam_sculpt=2*nGetScrollBarXY(scrollbarradius)
    'if keyhit(key_I) then diam_sculpt=diam_sculpt+2
    'if keyhit(key_K) then diam_sculpt = diam_sculpt-2
    'if diam_sculpt<2 then diam_sculpt=2
    'if diam_sculpt>diam_sculpt_max then diam_sculpt=diam_sculpt_max
    'if diam_sculpt>40 then diam_sculpt=40
    
    
    ' If KeyHit(KEY_Q) Then 
       ' shw=1
      '  showentity(water)
   ' end if
    
   ' If KeyHit(KEY_Z) Then 
      '  shw=0
      '  hideentity(water)
   ' end if
    
    If KeyHit(KEY_R) Then shape=1
    If KeyHit(KEY_T) Then shape=0
    
    If KeyHit(KEY_F) Then nSetEntityFlag(terrain,8,1)
    If KeyHit(KEY_G) Then nSetEntityFlag(terrain,8,0) 
    
    pas=nGetScrollBarXY(scrollbarstrenghtsculpt)*3/100
    'If Keyhit(KEY_U) Then pas=pas+0.5
    'If KeyDown(KEY_J) Then pas=pas-0.5
    'if pas>3 then pas=3
    'if pas<1 then pas=1
    
    
    'detail on/off
    'if keyhit(key_b) then entitytype(terrain,0)
    'if keyhit(key_v) then entitytype(terrain,1)
    
    scale_detail=nGetScrollBarXY(scrollbarScaleDetail)
    if sd<>scale_detail then
        sd=scale_detail
        nSetScaleTerrainTexture(terrain,1,scale_detail)
    end if
    
   ' if keydown(key_b) then
      '  scale_detail=scale_detail+5
       ' if scale_detail>320 then scale_detail=320
    '    scaletexture(terrain,1,scale_detail)
   ' end if
    
   ' if keydown(key_v) then 
     '   scale_detail=scale_detail-5
     '   if scale_detail<1 then scale_detail=1
      '  scaletexture(terrain,1,scale_detail)
   ' end if
    
    water_level=nGetScrollBarXY(scrollbarwaterlevel)
    if wl<>water_level then
        wl=water_level
        nSetEntityPosition(water,650,water_level,650)
    end if
    
    'If KeyDown(KEY_Y) Then WATER_LEVEL=WATER_LEVEL + 0.05
    'If KeyDown(KEY_H) Then WATER_LEVEL=WATER_LEVEL - 0.05
    'PositionEntity(water,650,water_level,650)
    
    nrtile=nGetSelectedItemComboBox(combobox1)
    
    'if keyhit(key_1) then
    if (nrtile=0) then
        curentsplat=texsplat1
        othersplata=texsplat2
        othersplatb=texsplat3
        othersplatc=texsplat4
        stage=1
        chanel=1
        nSetImageGUI(imagegui1,tile1_red)
    end if
    'if keyhit(key_2) then
    if (nrtile=1) then
		curentsplat=texsplat1
        othersplata=texsplat2
        othersplatb=texsplat3
        othersplatc=texsplat4
        stage=1
        chanel=2
        nSetImageGUI(imagegui1,tile1_green)
    end if
    'if keyhit(key_3) then
    if (nrtile=2) then
		curentsplat=texsplat1
        othersplata=texsplat2
        othersplatb=texsplat3
        othersplatc=texsplat4
        stage=1
        chanel=3
        nSetImageGUI(imagegui1,tile1_blue)
    end if
    'if keyhit(key_4) then
    if (nrtile=3) then
		curentsplat=texsplat2
        othersplata=texsplat1
        othersplatb=texsplat3
        othersplatc=texsplat4
        stage=2
        chanel=1
        nSetImageGUI(imagegui1,tile2_red)
    end if
    'if keyhit(key_5) then
    if (nrtile=4) then
		curentsplat=texsplat2
        othersplata=texsplat1
        othersplatb=texsplat3
        othersplatc=texsplat4
        stage=2
        chanel=2
        nSetImageGUI(imagegui1,tile2_green)
    end if
    'if keyhit(key_6) then
    if (nrtile=5) then
		curentsplat=texsplat2
        othersplata=texsplat1
        othersplatb=texsplat3
        othersplatc=texsplat4
        stage=2
        chanel=3
        nSetImageGUI(imagegui1,tile2_blue)
    end if
    'if keyhit(key_7) then
    if (nrtile=6) then
		curentsplat=texsplat3
        othersplata=texsplat1
        othersplatb=texsplat2
        othersplatc=texsplat4
        stage=3
        chanel=1
        nSetImageGUI(imagegui1,tile3_red)
    end if
    'if keyhit(key_8) then
    if (nrtile=7) then
		curentsplat=texsplat3
        othersplata=texsplat1
        othersplatb=texsplat2
        othersplatc=texsplat4
        stage=3
        chanel=2
        nSetImageGUI(imagegui1,tile3_green)
    end if
    'if keyhit(key_9) then
    if (nrtile=8) then
		curentsplat=texsplat3
        othersplata=texsplat1
        othersplatb=texsplat2
        othersplatc=texsplat4
        stage=3
        chanel=3
        nsetImageGUI(imagegui1,tile3_blue)
    end if
    'if keyhit(key_0) then
    if (nrtile=9) then
		curentsplat=texsplat4
        othersplata=texsplat1
        othersplatb=texsplat2
        othersplatc=texsplat3
        stage=4
        chanel=1
        nsetImageGUI(imagegui1,tile4_red)
    end if
    'if keyhit(key_p) then
    if (nrtile=10) then
		curentsplat=texsplat4
        othersplata=texsplat1
        othersplatb=texsplat2
        othersplatc=texsplat3
        stage=4
        chanel=2
        nsetImageGUI(imagegui1,tile4_green)
    end if
    'if keyhit(key_c) then
    if (nrtile=11) then
		curentsplat=texsplat4
        othersplata=texsplat1
        othersplatb=texsplat2
        othersplatc=texsplat3
        stage=4
        chanel=3
        nsetImageGUI(imagegui1,tile4_blue)
    end if
   

 ' image(texsplat1,0,0)
  'image(texsplat2,0,512)
    'text(400,40,"alpha= "+str(alpha),0,0) 
    'text(400,60,"radius="+str(radius),0,0)
    
    if mode=0 then nSetPressed(buttswitchmode,0)
    if mode=1 then nSetPressed(buttswitchmode,1)
    
    if shape=1 then nSetPressed(buttshapesculpt,0)
    if shape=0 then nSetPressed(buttshapesculpt,1)
    
    
    
if mode=0 and modecam=0 then
        
    if shape=1 then
  xr1=diam_sculpt/2*terr_scale_xz
  zr1=0
  yr1=nGetTerrainHeight(terrain,xpos+xr1,zpos+zr1)
  if (xmempos+xr1<0) or (xmempos+xr1>terr_size*terr_scale_xz) or (zmempos+zr1<0) or (zmempos+zr1>terr_size*terr_scale_xz) then yr1=water_level
  for j=0 to 360 step 10
      xr2=diam_sculpt/2*terr_scale_xz*cos(j*3.1415926535897932/180)
      zr2=diam_sculpt/2*terr_scale_xz*sin(j*3.1415926535897932/180)
      yr2=nGetTerrainHeight(terrain,xmempos+xr2,zmempos+zr2)
      if (xmempos+xr2<0) or (xmempos+xr2>terr_size*terr_scale_xz) or (zmempos+zr2<0) or (zmempos+zr2>terr_size*terr_scale_xz) then yr2=water_level
      nDrawLine3d(xmempos+xr1,yr1+2,zmempos+zr1,xmempos+xr2,yr2+2,zmempos+zr2,2,150,255,0,0)
        xr1=xr2
        yr1=yr2
        zr1=zr2
        if (xmempos+xr1<0) or (xmempos+xr1>terr_size*terr_scale_xz) or (zmempos+zr1<0) or (zmempos+zr1>terr_size*terr_scale_xz) then yr1=water_level
    next
end if
if shape=0 then
    xr1=diam_sculpt/2*terr_scale_xz+xmempos
    zr1=zmempos-diam_sculpt/2*terr_scale_xz
    yr1=nGetTerrainHeight(terrain,xr1,zr1)
    xr2=xr1
    zr2=zmempos+diam_sculpt/2*terr_scale_xz
    yr2= nGetTerrainHeight(terrain,xr2,zr2)
    nDrawLine3d(xr1,yr1+2,zr1,xr2,yr2+2,zr2,2,150,255,0,0)
    xr1=xr2
    yr1=yr2
    zr1=zr2
    xr2=xmempos-diam_sculpt/2*terr_scale_xz
    zr2=zmempos+diam_sculpt/2*terr_scale_xz
    yr2= nGetTerrainHeight(terrain,xr2,zr2)
    nDrawLine3d(xr1,yr1+2,zr1,xr2,yr2+2,zr2,2,150,255,0,0)
    xr1=xr2
    yr1=yr2
    zr1=zr2
    xr2=xmempos-diam_sculpt/2*terr_scale_xz
    zr2=zmempos-diam_sculpt/2*terr_scale_xz
    yr2= nGetTerrainHeight(terrain,xr2,zr2)
    nDrawLine3d(xr1,yr1+2,zr1,xr2,yr2+2,zr2,2,150,255,0,0)
    xr1=xr2
    yr1=yr2
    zr1=zr2
    xr2=xmempos+diam_sculpt/2*terr_scale_xz
    zr2=zmempos-diam_sculpt/2*terr_scale_xz
    yr2= nGetTerrainHeight(terrain,xr2,zr2)
    nDrawLine3d(xr1,yr1+2,zr1,xr2,yr2+2,zr2,2,150,255,0,0)
end if
end if
if mode=1 and modecam=0 then
   shape=1
  xr1=diam_sculpt/2*terr_scale_xz
  zr1=0
  yr1=nGetTerrainHeight(terrain,xpos+xr1,zpos+zr1)
  if (xmempos+xr1<0) or (xmempos+xr1>terr_size*terr_scale_xz) or (zmempos+zr1<0) or (zmempos+zr1>terr_size*terr_scale_xz) then yr1=water_level
  for j=0 to 360 step 10
      xr2=diam_sculpt/2*terr_scale_xz*cos(j*3.1415926535897932/180)
      zr2=diam_sculpt/2*terr_scale_xz*sin(j*3.1415926535897932/180)
      yr2=nGetTerrainHeight(terrain,xmempos+xr2,zmempos+zr2)
      if (xmempos+xr2<0) or (xmempos+xr2>terr_size*terr_scale_xz) or (zmempos+zr2<0) or (zmempos+zr2>terr_size*terr_scale_xz) then yr2=water_level
      nDrawLine3d(xmempos+xr1,yr1+2,zmempos+zr1,xmempos+xr2,yr2+2,zmempos+zr2,2,150,255,0,0)
        xr1=xr2
        yr1=yr2
        zr1=zr2
        if (xmempos+xr1<0) or (xmempos+xr1>terr_size*terr_scale_xz) or (zmempos+zr1<0) or (zmempos+zr1>terr_size*terr_scale_xz) then yr1=water_level
    next
end if

    
if mode=0 and modecam=1 then
    
    
    nDrawFontText(400,20,"SCULPT   MODE",0,0)
    
    nDrawFontText(20,15,"SPACE --> SWITCH EDIT/MENU MODE",0,0)
    nDrawFontText(20,30,"R / T --> SHAPE SCULPT TOOL ( CIRCLE/SQUARE )",0,0)
    nDrawFontText(20,45,"MIDDLE MOUSE BUTTON --> SCULPT/PAINT MODE",0,0)
    nDrawFontText(20,60,"LEFT MOUSE BUTTON --> UP SCULPT / PAINT",0,0)
    nDrawFontText(20,75,"RIGHT MOUSE BUTTON --> DOWN SCULPT",0,0)
    nDrawFontText(20,90,"G / F --> FOG ON/OF",0,0)
    nDrawFontText(20,105,"E --> WIREFRAME ON / OFF",0,0)
    nDrawFontText(20,120,"F2 --> SAVE HEIGHTMAP and SPLATMAPS",0,0)
    nDrawFontText(20,135,"L -->CALCULATE, PAINT AND SAVE LIGHTMAP(IN PAINT MODE)",0,0)
    nDrawFontText(20,150,"K --> CLEAR LIGHTMAP(IN PAINT MODE)",0,0)
    nDrawFontText(20,165,"W,A,S,D --> CONTROL CAMERA FPS",0,0)
    nDrawFontText(20,180,"ESCAPE --> EXIT",0,0)
    
    nDrawFontText(20,220,"FPS = "+STR(FPS),0,0)
    nDrawFontText(20,235,"WATER LEVEL = "+STR(WATER_LEVEL),0,0)
    nDrawFontText(20,250,"ALPHA PAINT = "+STR(ALPHA),0,0)
    nDrawFontText(20,265,"DETAIL SCALE FACTOR = "+STR(SCALE_DETAIL),0,0)
    nDrawFontText(20,280,"TERRAIN X = : "+STR(XPOS),0,0)
    nDrawFontText(20,295,"TERRAIN Z = : "+STR(ZPOS),0,0)
    nDrawFontText(20,310,"TERRAIN Y = : "+STR(nGetTerrainHeight(TERRAIN,XPOS,ZPOS)),0,0)
    
    
    
   
    nSetEntityPosition(water,650,water_level,650)
    
    xpos=nGetXPoSArrow(terrain,arrow,selector,camera,terr_scale_xz,1,terr_size)
    zpos=nGetZPoSArrow(terrain,arrow,selector,camera,terr_scale_xz,1,terr_size)
    xmempos=xpos
    zmempos=zpos
    If MouseDown(MOUSE_LEFT) Then 
        nSetHeightTerrainVerticesGroup2(terrain,diam_sculpt,xpos,zpos,pas,1,terr_scale_xz,1,terr_size,shape,vertentry)
        nSetPressed(buttupdownsculpt,0)
    end if
    If MouseDown(MOUSE_RIGHT) Then 
        nSetHeightTerrainVerticesGroup2(terrain,diam_sculpt,xpos,zpos,pas,0,terr_scale_xz,1,terr_size,shape,vertentry)
        nSetPressed(buttupdownsculpt,1)
    end if
    
    If KeyDown(KEY_F2) Then
        nSetVisibleGUIElement(imgwait,1)
        imgcmsave=nCreateImageFromTexture(texsplat1,0,0,512,512)
        nWriteImageToFile(imgcmsave,cmtype)
        nWriteImageSplatToFile(imgcmsave,1)
        nRemoveImage(imgcmsave)
        imgcmsave=nCreateImageFromTexture(texsplat2,0,0,512,512)
        nWriteImageToFile(imgcmsave,cmtype)
        nWriteImageSplatToFile(imgcmsave,2)
        nRemoveImage(imgcmsave)
        imgcmsave=nCreateImageFromTexture(texsplat3,0,0,512,512)
        nWriteImageToFile(imgcmsave,cmtype)
        nWriteImageSplatToFile(imgcmsave,3)
        nremoveimage(imgcmsave)
        imgcmsave=nCreateImageFromTexture(texsplat4,0,0,512,512)
        nWriteImageToFile(imgcmsave,cmtype)
        nWriteImageSplatToFile(imgcmsave,4)
        nremoveimage(imgcmsave)
        nSaveTerrainHM(terrain, terr_size)
        nsetVisibleGUIElement(imgwait,0)
    end if
    
    
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
      nDrawline3d(xpos+xr1,yr1+2,zpos+zr1,xpos+xr2,yr2+2,zpos+zr2,2,150,255,0,0)
        xr1=xr2
        yr1=yr2
        zr1=zr2
        if (xpos+xr1<0) or (xpos+xr1>terr_size*terr_scale_xz) or (zpos+zr1<0) or (zpos+zr1>terr_size*terr_scale_xz) then yr1=water_level
    next
end if
if shape=0 then
    xr1=diam_sculpt/2*terr_scale_xz+xpos
    zr1=zpos-diam_sculpt/2*terr_scale_xz
    yr1=nGetterrainheight(terrain,xr1,zr1)
    xr2=xr1
    zr2=zpos+diam_sculpt/2*terr_scale_xz
    yr2= nGetterrainheight(terrain,xr2,zr2)
    nDrawline3d(xr1,yr1+2,zr1,xr2,yr2+2,zr2,2,150,255,0,0)
    xr1=xr2
    yr1=yr2
    zr1=zr2
    xr2=xpos-diam_sculpt/2*terr_scale_xz
    zr2=zpos+diam_sculpt/2*terr_scale_xz
    yr2= nGetterrainheight(terrain,xr2,zr2)
    nDrawline3d(xr1,yr1+2,zr1,xr2,yr2+2,zr2,2,150,255,0,0)
    xr1=xr2
    yr1=yr2
    zr1=zr2
    xr2=xpos-diam_sculpt/2*terr_scale_xz
    zr2=zpos-diam_sculpt/2*terr_scale_xz
    yr2= nGetterrainheight(terrain,xr2,zr2)
    nDrawline3d(xr1,yr1+2,zr1,xr2,yr2+2,zr2,2,150,255,0,0)
    xr1=xr2
    yr1=yr2
    zr1=zr2
    xr2=xpos+diam_sculpt/2*terr_scale_xz
    zr2=zpos-diam_sculpt/2*terr_scale_xz
    yr2= nGetterrainheight(terrain,xr2,zr2)
    nDrawline3d(xr1,yr1+2,zr1,xr2,yr2+2,zr2,2,150,255,0,0)
end if
end if

    
    
if mode=1 and modecam=1 then
    
    nDrawFontText(400,20,"PAINT   MODE",0,0)
    
    
    nDrawFontText(20,15,"SPACE --> SWITCH EDIT/MENU MODE",0,0)
    nDrawFontText(20,30,"R / T --> SHAPE SCULPT TOOL ( CIRCLE/SQUARE )",0,0)
    nDrawFontText(20,45,"MIDDLE MOUSE BUTTON --> SCULPT/PAINT MODE",0,0)
    nDrawFontText(20,60,"LEFT MOUSE BUTTON --> UP SCULPT / PAINT",0,0)
    nDrawFontText(20,75,"RIGHT MOUSE BUTTON --> DOWN SCULPT",0,0)
    nDrawFontText(20,90,"G / F --> FOG ON/OF",0,0)
    nDrawFontText(20,105,"E --> WIREFRAME ON / OFF",0,0)
    nDrawFontText(20,120,"F2 --> SAVE HEIGHTMAP and SPLATMAPS",0,0)
    nDrawFontText(20,135,"L -->CALCULATE, PAINT AND SAVE LIGHTMAP(IN PAINT MODE)",0,0)
    nDrawFontText(20,150,"K --> CLEAR LIGHTMAP(IN PAINT MODE)",0,0)
    nDrawFontText(20,165,"W,A,S,D --> CONTROL CAMERA FPS",0,0)
    nDrawFontText(20,180,"ESCAPE --> EXIT",0,0)
    
    nDrawFontText(20,220,"FPS = "+STR(FPS),0,0)
    nDrawFontText(20,235,"WATER LEVEL = "+STR(WATER_LEVEL),0,0)
    nDrawFontText(20,250,"ALPHA PAINT = "+STR(ALPHA),0,0)
    nDrawFontText(20,265,"DETAIL SCALE FACTOR = "+STR(SCALE_DETAIL),0,0)
    nDrawFontText(20,280,"TERRAIN X = : "+STR(XPOS),0,0)
    nDrawFontText(20,295,"TERRAIN Z = : "+STR(ZPOS),0,0)
    nDrawFontText(20,310,"TERRAIN Y = : "+STR(nGetTERRAINHEIGHT(TERRAIN,XPOS,ZPOS)),0,0)
    
    
 	
    radius=int((diam_sculpt/2)*wt/terr_size)
    'if radius>90 then radius=90
    'if radius>190 then radius=190

    xpos=nGetXPoSArrow(terrain,arrow,selector,camera,terr_scale_xz,1,terr_size)
    zpos=nGetZPoSArrow(terrain,arrow,selector,camera,terr_scale_xz,1,terr_size)
    yt=int(xpos*wt/(terr_size*terr_scale_xz))
    xt=int(zpos*wt/(terr_size*terr_scale_xz))
    xmempos=xpos
    zmempos=zpos
    If MouseDown(MOUSE_LEFT) Then nPaintSplatOGL(curentsplat,othersplata,othersplatb,othersplatc,stage,chanel,xt,wt-yt,radius,alpha)
   
    
    If KeyHit(KEY_F2) Then 
        nsetVisibleGUIElement(imgwait,1)
        imgcmsave=nCreateImageFromTexture(texsplat1,0,0,512,512)
        nWriteImageToFile(imgcmsave,cmtype)
        nWriteImageSplatToFile(imgcmsave,1)
        nremoveimage(imgcmsave)
        imgcmsave=nCreateImageFromTexture(texsplat2,0,0,512,512)
        nWriteImageToFile(imgcmsave,cmtype)
        nWriteImageSplatToFile(imgcmsave,2)
        nremoveimage(imgcmsave)
        imgcmsave=nCreateImageFromTexture(texsplat3,0,0,512,512)
        nWriteImageToFile(imgcmsave,cmtype)
        nWriteImageSplatToFile(imgcmsave,3)
        nremoveimage(imgcmsave)
        imgcmsave=nCreateImageFromTexture(texsplat4,0,0,512,512)
        nWriteImageToFile(imgcmsave,cmtype)
        nWriteImageSplatToFile(imgcmsave,4)
        nremoveimage(imgcmsave)
        nSaveTerrainHM(terrain, terr_size)
        nsetVisibleGUIElement(imgwait,0)
    end if
    
     if  renderpas>10 then
        nPaintLightMap("heightmap/heightmap.bmp",texsplatlm,1500,1000)
        nInterpolateLightMap(texsplatlm)
        nInterpolateLightMap(texsplatlm)
        nInterpolateLightMap(texsplatlm)
        nInterpolateLightMap(texsplatlm)
        nInterpolateLightMap(texsplatlm)
       
        imgcmsave=nCreateImageFromTexture(texsplatlm,0,0,512,512)
        nWriteImageSplatToFile(imgcmsave,5)
        nremoveimage(imgcmsave)
        nsetVisibleGUIElement(imgwait,0)
        renderpas=0
    end if
    if renderpas>0 then renderpas=renderpas+1
        
    If KeyHit(KEY_L) Then 
        nsetVisibleGUIElement(imgwait,1)
        renderpas=renderpas+1
    end if
    
    If KeyHit(KEY_K) Then nClearLightMap(texsplatlm)    
        
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
      nDrawline3d(xpos+xr1,yr1+2,zpos+zr1,xpos+xr2,yr2+2,zpos+zr2,2,150,255,0,0)
        xr1=xr2
        yr1=yr2
        zr1=zr2
        if (xpos+xr1<0) or (xpos+xr1>terr_size*terr_scale_xz) or (zpos+zr1<0) or (zpos+zr1>terr_size*terr_scale_xz) then yr1=water_level
    next
  
end if
    
   


'End the scene
	EndScene()
	
Wend

'Ends Ninfa3D Engine
EndEngine()

end sub
