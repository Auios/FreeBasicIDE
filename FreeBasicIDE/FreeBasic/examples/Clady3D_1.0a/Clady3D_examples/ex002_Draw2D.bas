#Include "Clady3d.bi"

dim camera As nCAMERA 'declare camera
Dim font1 as nFont 'declare font
Dim as nTexture tex01,tex02 'declare textures
Dim i as INTEGER 'declare contor i

'Enable vertical synch.
nEnableVsync()

'Enable antialiasing
nEnableAntialias()

'Starts the Ninfa3D Engine
InitEngine(0,800,600,32,0)
nSetBackGroundColor(128,128,128)'Background Color
nSetAmbientLight(64,64,64)'Ambient color
nSetWorldGravity(0,-10.0,0)'not necesarry right now
	

'Create a camera
camera = nCreateCamera()


font1=nLoadFont("media/font/courier.xml")'Load font
nSetFont(font1)'Set Font

tex01=nLoadTexture("media/images/logo2.jpg")'load texture
tex02=nLoadTexture("media/images/logo.png")'load texture

While(EngineRun)'Returns 1 if the engine is running.

	'Begins scene
	BeginScene()
	
	'By pressing the "ESCAPE" closes the engine.
	If KeyHit(KEY_ESCAPE) Then CloseEngine()

	'Update the Engine.
	'Changing the value (only affects the physics) that will update the
	'Physical faster or slower.
	UpdateEngine(0.05)
    
    nSetTransparency2D(255)'set global transparency in 2D
    nSetColors2D(255,255,255)'set colors in 2D
    nDrawLine2D(100,100,400,100)'draw a 2D line
    
    nSetColors2D(0,0,0)
    nDrawLine2D(100,100,400,200)
    
    nSetTransparency2D(250)
    nSetColors2D(255,0,0)
    nDrawOval2D(300,300,50)'draw a 2D oval
    
    nSetTransparency2D(100)
    nSetColors2D(0,0,0)
    nDrawRect2D(300,300,200,50)'draw a 2D rectangle
    
    nSetTransparency2D(255)
    nSetColors2D(255,255,255)
    nDrawImage2D(tex01,600,200)'draw a texture on the screen, no alpha channel
    
    
    
    nDrawImage2DWithAlpha(tex02,600,400,1)'draw a texture on the screen, with alpha channel
    
    nDrawImageSprites2D(tex01,400,400,20,20,50,100)'draw part of a texture on the screen
    
    nSetColors2D(255,255,255) 
    for i=1 to 100 
        nDrawPixel2D(200+i,nGetRand(200,300))'draw pixels on the screen
    next
    

		
	'End the scene
	EndScene()
	
Wend ' end for while

'Ends Ninfa3D Engine
EndEngine()
