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
nSetAmbientLight(64,64,64)'Ambient color
nSetWorldGravity(0,-10.0,0)
	

'Create a camera
camera = nCreateCamera()


font1=nLoadFont("media/font/courier.xml")
nSetFont(font1)

While(EngineRun)'Returns 1 if the engine is running.

	'Begins scene
	BeginScene()
	
	'By pressing the "ESCAPE" closes the engine.
	If KeyHit(KEY_ESCAPE) Then CloseEngine()

	'Update the Engine.
	'Changing the value (only affects the physics) that will update the
	'Physical faster or slower.
	UpdateEngine(0.05)
        nSetTransparency2D(255)
        nSetColors2D(255,255,255)
        nDrawFontText(25,150,"HELLO WORLD!",0,0)
        nSetTransparency2D(100)
        nSetColors2D(0,0,0)
		nDrawFontText(25,190,"HELLO WORLD!",0,0)
        nSetTransparency2D(250)
        nSetColors2D(255,0,0)
		nDrawFontText(25,230,"HELLO WORLD!",0,0)
        
		
	'End the scene
	EndScene()
	
Wend

'Ends Ninfa3D Engine
EndEngine()
