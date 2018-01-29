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
nSetEntityPosition(camera,0,180,0)
nSetCameraRange(camera,0.1,12000)

font1=nLoadFont("media/font/courier.xml")'Load font
nSetFont(font1)'Set Font



tex01 = nLoadTexture("media/images/FullskiesOvercast0036_1_S.jpg")
nCreateSkyDome(tex01,10000)'Creates the sky

nLoadZip("media/BSP/chiropteraDM.pk3")
DIM AS UINTEGER PTR BSPMesh = nLoadMeshBSPinRAM("chiropteraDM.bsp")
DIM AS UINTEGER PTR BSPNode = nCreateNodeBSPfromFile( "chiropteraDM.bsp" )
dim as nbody bdybsp=nCreateBodyTreeBSP(BSPMesh,BSPNode)

nSetCollisionsBSP(BSPMesh,BSPNode,camera)

nSetEntityFlag(bspnode,6,0)
nSetEntityType(bspnode,9)


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


'HideMouse()

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
    If MouseHit(MOUSE_RIGHT) Then CreateBullet()
    If KeyDown(KEY_SPACE) Then nSetEntityPosition(camera,nGetEntityX(camera),nGetEntityY(camera)+5,nGetEntityZ(camera))
    
	'End the scene
	EndScene()
	
Wend ' end for while

'Ends Ninfa3D Engine
EndEngine()
