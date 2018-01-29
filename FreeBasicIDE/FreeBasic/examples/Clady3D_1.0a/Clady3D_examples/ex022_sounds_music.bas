#Include "Clady3d.bi"

dim  camera As nCAMERA
Dim font1 as nFont
Dim music01 As nSOUND

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

'Load the music.
music01 = nLoadSound("media/sounds/music.ogg")

	nSetSoundType(music01,1)
	nLoopSound(music01)'Loop

font1=nLoadFont("media/font/courier.xml")
nSetFont(font1)

While(EngineRun)'Returns 1 if the engine is running.

	'Begins scene
	BeginScene()
	
	'By pressing the "ESCAPE" closes the engine.
	If KeyHit(KEY_ESCAPE) Then CloseEngine()
    
    UpdateEngine(0)
    
    nDrawFontText(200,350,"(1) Play",1,1)
	If KeyHit(KEY_1) Then nPlaySound(music01)

	nDrawFontText(300,350,"(2) Stop",1,1)
	If KeyHit(KEY_2) Then nStopSound(music01)

	nDrawFontText(400,350,"(3) Pause",1,1)
	If KeyHit(KEY_3) Then nPauseSound(music01)
    
    nDrawFontText(300,400,"(4,5) Volume",1,1)
    If KeyHit(KEY_4) Then nSetSoundVolume(music01,0.5)
    If KeyHit(KEY_5) Then nSetSoundVolume(music01,1.0)
    
    nDrawFontText(500,400,"(6,7,8) Pitch",1,1)
    If KeyHit(KEY_6) Then nSetSoundPitch(music01,0.5)
    If KeyHit(KEY_7) Then nSetSoundPitch(music01,2.0)
    If KeyHit(KEY_8) Then nSetSoundPitch(music01,1.0)

	
        
        
		
	'End the scene
	EndScene()
	
Wend

'Ends Ninfa3D Engine
EndEngine()
