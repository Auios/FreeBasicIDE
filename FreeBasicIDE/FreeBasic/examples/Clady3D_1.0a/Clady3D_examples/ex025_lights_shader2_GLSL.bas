#Include "Clady3d.bi"

dim Shared camera As nCAMERA 'declare camera
Dim font1 as nFont 'declare font
Dim as nTexture tex01,tex_particle 'declare textures
Dim i as INTEGER 'declare contor i
Dim shoot as integer
dim shared as uinteger ptr trisel1,trisel2,trisel3,trisel4,trisel5
dim as nLight light01,light02,light03


'Enable vertical synch.
nEnableVsync()

'Enable antialiasing
nEnableAntialias()

'Starts the Ninfa3D Engine
InitEngine(0,800,600,32,0)
nSetBackGroundColor(128,128,128)'Background Color
nSetAmbientLight(50,50,50)'Ambient color
nSetWorldSize(30000,30000,30000)
nSetWorldGravity(0,-10.0,0)'not necesarry right now
nSetPhysicQuality(Q_LINEAR)	

'Create a camera
camera = nCreateCameraFPS(100,0.5)
nSetEntityPosition(camera,0,50,-100)
nSetCameraRange(camera,0.1,12000)

font1=nLoadFont("media/font/courier.xml")'Load font
nSetFont(font1)'Set Font


Dim Shared texture04 As nTEXTURE
	texture04 = nLoadTexture("media/images/wall.jpg")

Dim Shared texture05 As nTEXTURE 
	texture05 = nLoadTexture("media/images/Wood.jpg")



	Dim As nMESH mesh01,mesh02,mesh03,mesh04,mesh05 
	Dim As nBODY body01,body02,body03,body04,body05 

	mesh01 = nCreateMeshCube()
    trisel1=nCreateGeneralTriangleSelector(mesh01,2)
		nSetMeshScale(mesh01,512,20,1)
		nSetEntityPosition(mesh01,0,10,256)
		nSetEntityTexture(mesh01,texture05,0)
        body01 = nCreateBodyCube(512,20,1,0)
		nSetEntityPosition(body01,0,10,256)
	
	mesh02 = nCreateMeshCube()
    trisel2=nCreateGeneralTriangleSelector(mesh02,2)
		nSetMeshScale(mesh02,1,20,512)
		nSetEntityPosition(mesh02,256,10,0)
		nSetEntityTexture(mesh02,texture05,0)
	body02 = nCreateBodyCube(1,20,512,0)
		nSetEntityPosition(body02,256,10,0)
	
	mesh03 = nCreateMeshCube()
    trisel3=nCreateGeneralTriangleSelector(mesh03,2)
		nSetMeshScale(mesh03,512,20,1)
		nSetEntityPosition(mesh03,0,10,-256)
		nSetEntityTexture(mesh03,texture05,0)
	body03 = nCreateBodyCube(512,20,1,0)
		nSetEntityPosition(body03,0,10,-256)
	
	mesh04 = nCreateMeshCube()
    trisel4=nCreateGeneralTriangleSelector(mesh04,2)
		nSetMeshScale(mesh04,1,20,512)
		nSetEntityPosition(mesh04,-256,10,0)
		nSetEntityTexture(mesh04,texture05,0)
	body04 = nCreateBodyCube(1,20,512,0)
		nSetEntityPosition(body04,-256,10,0)
	
	mesh05 = nCreateMeshPlane(64,8)
    trisel5=nCreateGeneralTriangleSelector(mesh05,2)
		nSetEntityTexture(mesh05,texture04,0)
	body05 = nCreateBodyCube(512,1,512,0)
		nSetEntityPosition(body05,0,-1,0)


tex_particle = nLoadTexture("media/images/glow.BMP")

tex01 = nLoadTexture("media/images/FullskiesOvercast0036_1_S.jpg")
nCreateSkyDome(tex01,10000)'Creates the sky



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



dim as nmesh goku = nLoadMesh("media/meshes/goku.b3d",1)
    nAnimateMesh(goku,1,30,1,235,1)
	nSetEntityPosition(goku,0,42,0)
	nSetMeshScale(goku,5,5,5)
    nSetEntityShininess(goku,20)

dim as uinteger ptr triselgoku=nCreateGeneralTriangleSelector(goku,2)


dim as uinteger ptr metatrisel=nCreateMetaTriangleSelector()

nAddTriangleSelector(metatrisel,trisel1)
nAddTriangleSelector(metatrisel,trisel2)
nAddTriangleSelector(metatrisel,trisel3)
nAddTriangleSelector(metatrisel,trisel4)
nAddTriangleSelector(metatrisel,trisel5)
nAddTriangleSelector(metatrisel,triselgoku)

Dim as nBillboard bill01= nLoadBillboard("media/images/glow.bmp")
	
    nSetEntityPosition(bill01,0,0,0)
    

light01=nCreateLight(LGT_POINT)
nSetLightRadius(light01,150)
nSetEntityParent(bill01,light01)
nSetLightColor(light01,200,150,50)
nSetEntityPosition(light01,0,80,-150)

'nSetLightCastShadow(light01)
'nSetMeshCastShadow(goku)


Dim as nShader shad2 = nLoadShader("media/shaders/Lighting.vert","media/shaders/OneSidedLighting.frag",0)

nApplyShadersEntity(shad2,goku)
nApplyShadersEntity(shad2,mesh01)
nApplyShadersEntity(shad2,mesh02)
nApplyShadersEntity(shad2,mesh03)
nApplyShadersEntity(shad2,mesh04)
nApplyShadersEntity(shad2,mesh05)




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
        if outnode=goku then nDrawFontText(25,250,"HIT !!!!",0,0)
    end if
    
   
    
        
    
    nGetNodeAndCollisionPointFromRay(nGetEntityX(camera),nGetEntityY(camera),nGetEntityZ(camera),_
    nGetCameraTargetX(camera),nGetCameraTargetY(camera),nGetCameraTargetZ(camera),outnode,metatrisel,xcoll,ycoll,zcoll)
    outnode=nGetCollisionNodeFromCamera(camera)
    
    if (shoot=1) and (outnode<>0) then
        nDrawLine3D(nGetEntityX(camera),nGetEntityY(camera)-1,nGetEntityZ(camera),xcoll,ycoll,zcoll,1,255,255,50,0)
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
