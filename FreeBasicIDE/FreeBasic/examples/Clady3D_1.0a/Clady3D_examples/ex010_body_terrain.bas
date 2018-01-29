#Include "Clady3d.bi"

dim shared camera As nCAMERA
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
nSetWorldSize(30000,30000,30000)
nSetPhysicQuality(Q_LINEAR)	
nSetFog(96,96,96,0.0001)	

'Create a camera
camera = nCreateCameraFPS(100,1)
nSetEntityPosition(camera,2500,50,2500)
nSetCameraRange(camera,0.1,12000)


font1=nLoadFont("media/font/courier.xml")
nSetFont(font1)

dim as nTexture tex01 = nLoadTexture("media/images/FullskiesOvercast0036_1_S.jpg")
nCreateSkyDome(tex01,10000)'Creates the sky

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

dim as uinteger ptr bodyterrain = nCreateBodyTerrain(terrain,5)
	'nSetEntityPosition(bodyterrain,0,-70,0)
    
Dim shared sound01 As nSOUND
	sound01 = nLoadSound("media/sounds/bullet_hit1.wav")
    nSetSoundType(sound01,1)    
    

Sub CreateBullet()
	
'Position of the target.
	dim As S tarx = nGetCameraTargetX(camera)
	dim As S tary = nGetCameraTargetY(camera)
	dim As S tarz = nGetCameraTargetZ(camera)
	
'Camera position.
	dim As S camx = nGetEntityX(camera)
	dim As S camy = nGetEntityY(camera)
	dim As S camz = nGetEntityZ(camera)
	
'Create a sphere.
	Dim As nMESH mesh = nCreateMeshSphere(16)
			nSetMeshScale(mesh,15,15,15)
        'dim  as nmesh mesh=loadmesh("media/ball.b3d")
		'ScaleMesh(mesh,0.4,0.4,0.4)
        
'Create a body type field.
	dim As nBODY body = nCreateBodySphere(15,15,15,5)
			nSetEntityParent(body,mesh)'The mesh uses the address data
										  'The body.
			nSetEntityPosition(body,camx,camy,camz)'The positions
			'LinearVelocity(body,tarx-camx,tary-camy,tarz-camz)'I applied speed
            nSetLinearVelocity(body,camx,camy,camz,tarx,tary,tarz,40)
            
'Activate the sound.
	nPlaySound(sound01)

End sub

While(EngineRun)'Returns 1 if the engine is running.

	'Begins scene
	BeginScene()
	
	'By pressing the "ESCAPE" closes the engine.
	If KeyHit(KEY_ESCAPE) Then CloseEngine()
    nWorldMousePick(nGetMouseX(),nGetMouseY(),MouseDown(MOUSE_LEFT))
    If MouseHit(MOUSE_RIGHT) Then CreateBullet()
	'Update the Engine.
	'Changing the value (only affects the physics) that will update the
	'Physical faster or slower.
	UpdateEngine(0.05)
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
