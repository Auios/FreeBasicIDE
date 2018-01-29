#Include "Clady3d.bi"

dim Shared camera As nCAMERA
dim As nLIGHT light01
Dim sprite As nBILLBOARD
Dim tex01 As nTEXTURE
Dim As nMESH mesh,mesh2,mesh03
Dim As nBODY body,body2
Dim As nMATERIAL material1,material2

'Enable vertical synch.
nEnableVsync()

'Starts the Ninfa3D Engine
InitEngine(0,800,600,32,0)
	nSetBackGroundColor(128,128,128)'Background Color
	nSetAmbientLight(64,64,64)'Ambient color
	nSetWorldGravity(0,-10.0,0)
	
'Include the file "SampleFuntions.bi.
'It contains useful features, such as drawing the interface and create the test area.
'#Include "SampleFunctions.bi"

'Create a camera
camera = nCreateCameraFPS(100,0.5)
	nSetEntityPosition(camera,0,128,-128)' Position

'Creates the lights
    light01 = nCreateLight(LGT_POINT)
    nSetlightcolor(light01,100,100,50)
    nSetlightradius(light01,256)
	nSetEntityPosition(light01,0,128,256)' Position
	nSetLightCastShadow(light01)'It makes the light cast shadows.
	
    
sprite = nLoadBillboard("media/images/glow.bmp")
	nSetEntityParent(sprite,light01)
	nSetBillboardScale(sprite,30,30)

'CreateGround()'Creates the test area

material1=nCreateBodyMaterial( )
material2=nCreateBodyMaterial( )
nSetBodyMaterialElasticity( material1, material2, 0.8 ) 

mesh = nCreateMeshCylinder(12)
	nSetEntityColor(mesh,0,0,255)
	nSetMeshScale(mesh,100,25,100)
	nSetEntityPosition(mesh,0,25,0)'Move the mesh

body = nCreateBodyCylinder(100,25,0)' 0 = Static
	nSetEntityPosition(body,0,25,0)'Move the mesh
    nSetBodyMaterial(body,material1)
    
mesh2 = nCreateMeshSphere(12)
	nSetEntityColor(mesh2,255,0,0)
	nSetMeshScale(mesh2,10,10,10)
	
body2 = nCreateBodySphere(10,10,10,1)
	nSetEntityParent(body2,mesh2)
	nSetEntityPosition(body2,10,100,0)'Move the mesh
	nSetEntityAbsoluteRotation(body2,0,0,0)
    nSetBodyMaterial(body2,material2)

mesh03 = nCreateMeshCube()
	nSetMeshScale(mesh03,10,1,10)

While(EngineRun)'Returns 1 if the engine is running.

	'Begins scene
	BeginScene()
	
	'By pressing the "ESCAPE" closes the engine.
	If KeyHit(KEY_ESCAPE) Then CloseEngine()

	'Update the Engine.
	'Changing the value (only affects the physics) that will update the
	'Physical faster or slower.
	UpdateEngine(0.05)
	
	nWorldMousePick(nGetMouseX(),nGetMouseY(),MouseDown(MOUSE_LEFT))

	If nGetBodiesCollide(body,body2) Then nDrawFontText(25,125,"Collided!",0,0)

		nDrawFontText(25,150,"ColX: "+Str$(nGetBodyCollX(body,body2)),0,0)
		nDrawFontText(25,160,"ColY: "+Str$(nGetBodyCollY(body,body2)),0,0)
		nDrawFontText(25,170,"ColZ: "+Str$(nGetBodyCollZ(body,body2)),0,0)
		nDrawFontText(25,190,"ColNX: "+Str$(nGetBodyCollNX(body,body2)),0,0)
		nDrawFontText(25,200,"ColNY: "+Str$(nGetBodyCollNY(body,body2)),0,0)
		nDrawFontText(25,210,"ColNZ: "+Str$(nGetBodyCollNZ(body,body2)),0,0)

	nSetEntityPosition(mesh03,nGetBodyCollX(body,body2),nGetBodyCollY(body,body2),nGetBodyCollZ(body,body2))
	nSetEntityAbsoluteRotation(mesh03,nGetBodyCollNX(body,body2),nGetBodyCollNY(body,body2),nGetBodyCollNZ(body,body2))
	
	'Displays the interface (FPS and triangles)
	'Interface()
	
	'End the scene
	EndScene()
	
Wend

'Ends Ninfa3D Engine
EndEngine()
