#Include "Clady3d.bi"

dim  camera As nCAMERA
Dim font1 as nFont

'Enable vertical synch
nEnableVsync()

'Enable antialiasing
nEnableAntialias()

'Starts the Ninfa3D Engine
InitEngine(0,800,600,32,0)
nSetBackGroundColor(128,128,128)'Background Color
nSetAmbientLight(250,250,250)'Ambient color
nSetWorldGravity(0,-10.0,0)
nSetFog(96,96,96,0.0001)	

'Create a camera
camera = nCreateCameraFPS(100,1)
nSetEntityPosition(camera,2500,50,2500)
nSetCameraRange(camera,0.1,12000)


font1=nLoadFont("media/font/courier.xml")
nSetFont(font1)

dim as nTexture tex01 = nLoadTexture("media/images/FullskiesOvercast0036_1_S.jpg")
nCreateSkyDome(tex01,10000)'Creates the sky

dim as nSound sound01 = nLoadSound("media/sounds/alien_creeper.wav")
    nSetSoundType(sound01,2)
    nSetSoundPosition(sound01,3500,40,1000)
    nLoopSound(sound01)'Loop
    nPlaySound(sound01)
    nSetSoundVolume(sound01,1)
    nSetSoundReferenceDistance(sound01,300)
    nSetSoundRollOff(sound01,1)


dim as nSound sound02 = nLoadSound("media/sounds/burning3.wav")
	nSetSoundType(sound02,2)
    nSetSoundPosition(sound02,1624,400,3465)
    nLoopSound(sound02)'Loop
    nPlaySound(sound02)
    nSetSoundVolume(sound02,1)
    nSetSoundReferenceDistance(sound02,300)
    nSetSoundRollOff(sound02,1)



'dim as nSound music01 = nLoadSound("media/sounds/music.ogg")

	'nSetSoundType(music01,1)
	'nLoopSound(music01)'Loop
    'nSetSoundVolume(music01,0.3)
	'nPlaySound(music01)

dim as nTexture texcolormap = nLoadTexture("media/terrain/colormap.jpg")
dim as nTexture texdetail = nLoadTexture("media/terrain/detail.jpg")
'Create a terrain mesh
dim as nTerrain terrain = nLoadTerrain("media/terrain/heightmap.bmp",4,4,17)
    nSetEntityType(terrain,4)
    'nSetEntityPosition(terrain,0,0,0)
    nSetMeshScale(terrain,10,5,10)
	nSetEntityTexture(terrain,texcolormap,0)
    nSetEntityTexture(terrain,texdetail,1)
	nSetScaleTerrainTexture(terrain,1,256)'Scale the texture of the terrain



dim as nTexture tex_particle = nLoadTexture("media/images/glow.BMP") 'Load the texture.

'Create the particles, in this case to create fire type 1.
dim as UInteger Ptr fire = nCreateParticle()'Creates particles
	nSetEntityPosition(fire,1624,400,3465)'Position
	nSetParticleEndSize(fire,-40,-40)'Size of the final particles
	nSetEntityTexture(fire,tex_particle,0)'Texture
	
dim as UInteger Ptr emitter01 = nCreateBoxEmitter(fire,500,2000)'Creates the emitter.
	nSetBoxEmitterSize(emitter01,4,4,4)
	nSetEmitterDirection(emitter01,0,0.06,0) 'Direction of emitter.
	nSetEmitterPPS(emitter01,80,100)'Particles per second to be emitt by the emitter.
	nSetEmitterStartColor(emitter01,255,50,0,255,250,0)'Color of the minimum and maximum particle.
	nSetEmitterStartSize(emitter01,10,10,70,70)'Minimum and maximum size of the particle.

'Create the particles, in this case to create the smoke.
dim as UInteger Ptr smoke = nCreateParticle()
	nSetEntityPosition(smoke,1624,400,3465)
	nSetParticleEndSize(smoke,-10,-10)
	nSetEntityTexture(smoke,tex_particle,0)
	
dim as UInteger Ptr emitter02 = nCreateBoxEmitter(smoke,1000,2000)
	nSetBoxEmitterSize(emitter02,10,10,10)
	nSetEmitterDirection(emitter02,0,0.08,0)
	nSetEmitterPPS(emitter02,20,50) 
	nSetEmitterStartColor(emitter02,0,0,0,10,10,10) 
	nSetEmitterStartSize(emitter02,25,25,30,30) 



dim as UInteger Ptr pivot = nCreateMeshNull()'Creates an empty mesh is used as the pivot.
        nSetEntityPosition(pivot,3500,40,1000)
        
Dim As Integer i,r,g,b

For i = 1 To 10
	
	'Random!!!
	r = nGetRand(0,255)
	g = nGetRand(0,255)
	b = nGetRand(0,255)
	
	'Create the particles, in this case to create fire type 1.
	dim as UInteger Ptr fairy01 = nCreateParticle()'Creates particles
		nSetEntityParent(fairy01,pivot)
        nSetEntityPosition(fairy01,100*(i/6),64*(i/2),0)'Position
		nSetParticleEndSize(fairy01,-40,-40)'Size of the final particles
		nSetEntityTexture(fairy01,tex_particle,0)'Texture
		
	dim as UInteger Ptr emitter011 = nCreateBoxEmitter(fairy01,500,2000)'Creates the emitter.
		nSetBoxEmitterSize(emitter011,4,4,4)'Box emitter size.
		nSetEmitterDirection(emitter011,0,-0.06,0) 'Direction of emitter.
		nSetEmitterPPS(emitter011,60,80)'Particles per second to be emitt by the emitter.
		nSetEmitterStartColor(emitter011,r,g,b,255,255,255)'Color of the minimum and maximum particle.
		nSetEmitterStartSize(emitter011,5,5,30,30)'Minimum and maximum size of the particle.
	
	dim as UInteger Ptr fairy02 = nCreateParticle()'Creates particles
		nSetEntityParent(fairy02,pivot)
        nSetEntityPosition(fairy02,-100*(i/6),64*(i/2),0)'Position
		nSetParticleEndSize(fairy02,-40,-40)'Size of the final particles
		nSetEntityTexture(fairy02,tex_particle,0)'Texture
	
	dim as UInteger Ptr emitter021 = nCreateBoxEmitter(fairy02,500,2000)'Creates the emitter.
		nSetBoxEmitterSize(emitter021,4,4,4)'Box emitter size.
		nSetEmitterDirection(emitter021,0,-0.06,0) 'Direction of emitter.
		nSetEmitterPPS(emitter021,60,80)'Particles per second to be emitt by the emitter.
		nSetEmitterStartColor(emitter021,0,r,g,b,255,255)'Color of the minimum and maximum particle.
		nSetEmitterStartSize(emitter021,5,5,30,30)'Minimum and maximum size of the particle.
Next

While(EngineRun)'Returns 1 if the engine is running.

	'Begins scene
	BeginScene()
	
	'By pressing the "ESCAPE" closes the engine.
	If KeyHit(KEY_ESCAPE) Then CloseEngine()

	'Update the Engine.
	'Changing the value (only affects the physics) that will update the
	'Physical faster or slower.
	UpdateEngine(0.0)
    nSetEntityLocalRotation(pivot,0,1,0)
    nSetEntityPosition(camera,nGetEntityX(camera),nGetTerrainHeight(terrain,nGetEntityX(camera),nGetEntityZ(camera))+40,nGetEntityZ(camera))
    nSetListenerPosition(nGetEntityX(camera),nGetEntityY(camera),nGetEntityZ(camera))
    nSetTransparency2D(255)
    nSetColors2D(255,255,255)
    nDrawFontText(25,150,"xameraX: "+str$(nGetEntityX(camera)),0,0) 
    nDrawFontText(25,170,"xameraY: "+str$(nGetEntityY(camera)),0,0)
    nDrawFontText(25,190,"xameraZ: "+str$(nGetEntityZ(camera)),0,0)    		
	'End the scene
	EndScene()
	
Wend

'Ends Ninfa3D Engine
EndEngine()
