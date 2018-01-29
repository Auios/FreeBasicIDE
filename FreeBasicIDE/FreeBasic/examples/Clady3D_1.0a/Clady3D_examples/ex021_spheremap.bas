#Include "Clady3d.bi"

dim  camera As nCAMERA
Dim font1 as nFont

'Enable vertical synch
nEnableVsync()

'Enable antialiasing
nEnableAntialias()

'Starts the Ninfa3D Engine
InitEngine(0,640,480,32,0)
nSetBackGroundColor(128,128,128)'Background Color
nSetAmbientLight(164,164,164)'Ambient color
nSetWorldGravity(0,-10.0,0)
	

'Create a camera
camera = nCreateCameraFPS(100,0.1)
nSetEntityPosition(camera,0,0,-20)
dim as uinteger ptr sphere1=nCreateMeshSphere(12)
nSetMeshScale(sphere1,5,5,5)
Dim Shared texture01 As nTEXTURE 

texture01 = nLoadTexture("media/spheremap/cubemap2.jpg")
'texture01 = nLoadTexture("media/spheremap/spheremap.jpg")

nSetEntityType(sphere1,5)
nSetEntityTexture(sphere1,texture01,0)


While(EngineRun)'Returns 1 if the engine is running.

	'Begins scene
	BeginScene()
	
	'By pressing the "ESCAPE" closes the engine.
	If KeyHit(KEY_ESCAPE) Then CloseEngine()

	'Update the Engine.
	'Changing the value (only affects the physics) that will update the
	'Physical faster or slower.
	UpdateEngine(0.05)
        
        
		
	'End the scene
	EndScene()
	
Wend

'Ends Ninfa3D Engine
EndEngine()
