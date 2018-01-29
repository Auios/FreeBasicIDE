#Include "Clady3d.bi"

dim Shared camera As nCAMERA 'declare camera
Dim font1 as nFont 'declare font
Dim as nTexture tex01 'declare textures
Dim i as INTEGER 'declare contor i

'Enable vertical synch.
nEnableVsync()

'Enable antialiasing
nEnableAntialias()

'Starts the Ninfa3D Engine
InitEngine(0,800,600,32,0)
nSetBackGroundColor(128,128,128)'Background Color
nSetAmbientLight(64,64,64)'Ambient color
nSetWorldSize(30000,30000,30000)
nSetWorldGravity(0,-10.0,0)'not necesarry right now
nSetPhysicQuality(Q_LINEAR)	

'Create a camera
camera = nCreateCameraFPS(100,1)
nSetEntityPosition(camera,1000,500,1000)
nSetCameraRange(camera,0.1,12000)

font1=nLoadFont("media/font/courier.xml")'Load font
nSetFont(font1)'Set Font



tex01 = nLoadTexture("media/images/FullskiesOvercast0036_1_S.jpg")
nCreateSkyDome(tex01,10000)'Creates the sky

nLoadZip("media/BSP/map-20kdm2.pk3")

DIM AS UINTEGER PTR BSPMesh = nLoadMesh("20kdm2.bsp")

HideMouse()

While(EngineRun)'Returns 1 if the engine is running.

	'Begins scene
	BeginScene()
	
	'By pressing the "ESCAPE" closes the engine.
	If KeyHit(KEY_ESCAPE) Then CloseEngine()

	'Update the Engine.
	'Changing the value (only affects the physics) that will update the
	'Physical faster or slower.
	UpdateEngine(0.05)
   
    If KeyDown(KEY_SPACE) Then nSetEntityPosition(camera,nGetEntityX(camera),nGetEntityY(camera)+5,nGetEntityZ(camera))
    
	'End the scene
	EndScene()
	
Wend ' end for while

'Ends Ninfa3D Engine
EndEngine()
