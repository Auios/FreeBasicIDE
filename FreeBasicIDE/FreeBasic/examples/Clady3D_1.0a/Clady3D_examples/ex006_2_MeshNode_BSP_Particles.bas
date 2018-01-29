#Include "Clady3d.bi"

dim Shared camera As nCAMERA 'declare camera
Dim font1 as nFont 'declare font
Dim as nTexture tex01,tex_particle 'declare textures
Dim i as INTEGER 'declare contor i
Dim shoot as integer




'Enable vertical synch.
nEnableVsync()

'Enable antialiasing
nEnableAntialias()

'Starts the Ninfa3D Engine
InitEngine(0,800,600,32,1)
nSetBackGroundColor(128,128,128)'Background Color
nSetAmbientLight(164,164,164)'Ambient color
nSetWorldSize(30000,30000,30000)
nSetWorldGravity(0,-10.0,0)'not necesarry right now
nSetPhysicQuality(Q_LINEAR)	

'Create a camera
camera = nCreateCameraFPS(100,1)
nSetEntityPosition(camera,1000,500,1000)
nSetCameraRange(camera,0.1,12000)

font1=nLoadFont("media/font/courier.xml")'Load font
nSetFont(font1)'Set Font

tex_particle = nLoadTexture("media/images/glow.BMP")

tex01 = nLoadTexture("media/images/FullskiesOvercast0036_1_S.jpg")
nCreateSkyDome(tex01,10000)'Creates the sky

nLoadZip("media/BSP/map-20kdm2.pk3")
DIM AS UINTEGER PTR BSPMesh = nLoadMeshBSPinRAM("20kdm2.bsp")
DIM AS UINTEGER PTR BSPNode = nCreateNodeBSPfromFile( "20kdm2.bsp" )
nSetCollisionsBSP(BSPMesh,BSPNode,camera)

dim as single xcoll,ycoll,zcoll


dim as uinteger ptr outnode


Dim shared sound01 As nSOUND
	sound01 = nLoadSound("media/sounds/bullet_hit1.wav")
    nSetSoundType(sound01,1)



dim as uinteger ptr fire = nCreateParticle()'Creates particles
		nSetParticleEndSize(fire,1,1)'Size of the final particles
        nSetEntityTexture(fire,tex_particle,0)'Texture
dim as uinteger ptr emitter01 = nCreateRingEmitter(fire,100,150)
    nSetRingEmitterCenter(emitter01,0,0,0)
    nSetRingEmitterRadius(emitter01,0.5)
    nSetRingEmitterThickness(emitter01,0.5)
    nSetEmitterDirection(emitter01,0,0,0) 'Direction of emitter.
	nSetEmitterPPS(emitter01,50,50)'Particles per second to be emitt by the emitter.
	'EmitterStartColor(emitter01,255,150,200,255,150,200)'Color of the minimum and maximum particle.
    nSetEmitterStartColor(emitter01,200,200,200,200,200,200)'Color of the minimum and maximum particle.
	nSetEmitterStartSize(emitter01,20,20,25,25)'Minimum and maximum size of the particle.

dim timer1 as double

nHideEntity(fire)

HideMouse()

Dim as nTexture textarget
textarget=nLoadTexture("media/images/target.png")


dim as ntexture tex03 = nLoadTexture("media/images/nskinrd.jpg")
dim as nmesh ninja = nLoadMesh("media/meshes/ninja.b3d",1)
	nSetEntityTexture(ninja,tex03,0)
	nAnimateMesh(ninja,1,15,1,300,1)'Animate the mesh
	nSetEntityPosition(ninja,1400,65,1350)
	nSetMeshScale(ninja,10,10,10)
    
    
dim as nmesh goku = nLoadMesh("media/meshes/goku.b3d",1)
	nAnimateMesh(goku,1,30,1,235,1)'Animate the mesh
	nSetMeshScale(goku,5,5,5)
	nSetEntityPosition(goku,900,230,1700)
	
dim as uinteger ptr trisel=nCreateTriangleSelectorBSP(BSPMesh,BSPNode)
dim as uinteger ptr trisel2=nCreateGeneralTriangleSelector(ninja,2)
dim as uinteger ptr trisel3=nCreateGeneralTriangleSelector(goku,2)

dim as uinteger ptr metatrisel=nCreateMetaTriangleSelector()

nAddTriangleSelector(metatrisel,trisel)
nAddTriangleSelector(metatrisel,trisel2)
nAddTriangleSelector(metatrisel,trisel3)



While(EngineRun)'Returns 1 if the engine is running.

	'Begins scene
	BeginScene()
	
	'By pressing the "ESCAPE" closes the engine.
	If KeyHit(KEY_ESCAPE) Then CloseEngine()

	'Update the Engine.
	'Changing the value (only affects the physics) that will update the
	'Physical faster or slower.
	UpdateEngine(0.05)
    nDrawImage2DWithAlpha(textarget,nGetMouseX()-16,nGetMouseY()-16,1)
    
    If MouseHit(MOUSE_LEFT) Then 
        shoot=1
        nPlaySound(sound01)
        timer1=timer()
        if outnode=ninja then nDrawFontText(25,250,"HIT ninja!!!!",0,0)
        if outnode=goku then nDrawFontText(25,250,"HIT goku!!!!",0,0)
    end if
    
   
    
    'outnode=nGetCollisionNodeFromCamera(camera)
    'if outnode=BSPNode then
        'nGetNodeAndCollisionPointFromRay(nGetEntityX(camera),nGetEntityY(camera),nGetEntityZ(camera),_
        'nGetCameraTargetX(camera),nGetCameraTargetY(camera),nGetCameraTargetZ(camera),BSPNode,trisel,xcoll,ycoll,zcoll)
    'end if
    
    
    nGetNodeAndCollisionPointFromRay(nGetEntityX(camera),nGetEntityY(camera),nGetEntityZ(camera),_
    nGetCameraTargetX(camera),nGetCameraTargetY(camera),nGetCameraTargetZ(camera),outnode,metatrisel,xcoll,ycoll,zcoll)
    outnode=nGetCollisionNodeFromCamera(camera)
    
    if (shoot=1) and (outnode<>0) then
        nDrawLine3D(nGetEntityX(camera),nGetEntityY(camera)-1,nGetEntityZ(camera),xcoll,ycoll,zcoll,1,255,150,50,0)
        nSetEntityPosition(fire,xcoll,ycoll,zcoll)
        nShowEntity(fire)
        shoot=0
    end if
    
    if (timer()-timer1)>0.25 then 
        nHideEntity(fire)
        timer1=0
        
    end if
    

   If KeyDown(KEY_SPACE) Then nSetEntityPosition(camera,nGetEntityX(camera),nGetEntityY(camera)+5,nGetEntityZ(camera))
    
    nSetTransparency2D(255)
    nSetColors2D(255,255,255)
    nDrawFontText(25,150,"xameraX: "+str$(nGetEntityX(camera)),0,0) 
    nDrawFontText(25,170,"xameraY: "+str$(nGetEntityY(camera)),0,0)
    nDrawFontText(25,190,"xameraZ: "+str$(nGetEntityZ(camera)),0,0)
    nDrawFontText(25,270,"outnode: "+str$(outnode),0,0)
	'End the scene
	EndScene()
	
Wend ' end for while

'Ends Ninfa3D Engine
EndEngine()
