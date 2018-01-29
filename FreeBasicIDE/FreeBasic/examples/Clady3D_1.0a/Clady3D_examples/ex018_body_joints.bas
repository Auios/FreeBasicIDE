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
nSetAmbientLight(200,200,200)'Ambient color
nSetWorldGravity(0,-10.0,0)
nSetWorldSize(10000,10000,10000)
nSetPhysicQuality(Q_LINEAR)		

'Create a camera
camera = nCreateCameraFPS(100,0.2)
nSetEntityPosition(camera,0,50,-100)
nSetCameraTarget(camera,0,50,0)
nSetCameraRange(camera,0.1,12000)

Dim Shared texture04 As nTEXTURE
	texture04 = nLoadTexture("media/images/wall.jpg")

Dim Shared texture05 As nTEXTURE 
	texture05 = nLoadTexture("media/images/Wood.jpg")

font1=nLoadFont("media/font/courier.xml")
nSetFont(font1)



Sub CreateGround()

	Dim mesh As nMESH
	Dim body As nBODY

	mesh = nCreateMeshCube()
		nSetMeshScale(mesh,512,20,1)
		nSetEntityPosition(mesh,0,10,256)
		nSetEntityTexture(mesh,texture05,0)
        body = nCreateBodyCube(512,20,1,0)
		nSetEntityPosition(body,0,10,256)
	
	mesh = nCreateMeshCube()
		nSetMeshScale(mesh,1,20,512)
		nSetEntityPosition(mesh,256,10,0)
		nSetEntityTexture(mesh,texture05,0)
	body = nCreateBodyCube(1,20,512,0)
		nSetEntityPosition(body,256,10,0)
	
	mesh = nCreateMeshCube()
		nSetMeshScale(mesh,512,20,1)
		nSetEntityPosition(mesh,0,10,-256)
		nSetEntityTexture(mesh,texture05,0)
	body = nCreateBodyCube(512,20,1,0)
		nSetEntityPosition(body,0,10,-256)
	
	mesh = nCreateMeshCube()
		nSetMeshScale(mesh,1,20,512)
		nSetEntityPosition(mesh,-256,10,0)
		nSetEntityTexture(mesh,texture05,0)
	body = nCreateBodyCube(1,20,512,0)
		nSetEntityPosition(body,-256,10,0)
	
	mesh = nCreateMeshPlane(64,8)
		nSetEntityTexture(mesh,texture04,0)
	body = nCreateBodyCube(512,1,512,0)
		nSetEntityPosition(body,0,0,0)

End Sub

CreateGround()




Dim mesh1 As nMESH
Dim body1 As nBODY
    mesh1 = nCreateMeshCube()
		nSetMeshScale(mesh1,10,6,0.2)
        nSetEntityPosition(mesh1,0,50,0)
		nSetEntityTexture(mesh1,texture05,0)
    body1 = nCreateBodyHull(mesh1,0)
        nSetEntityParent(body1,mesh1)
		nSetEntityPosition(body1,0,50,0)
        


Dim mesh2 As nMESH
Dim body2 As nBODY
    mesh2 = nCreateMeshCube()
		nSetMeshScale(mesh2,10,6,0.2)
        nSetEntityPosition(mesh2,0,44,0)
		nSetEntityTexture(mesh2,texture04,0)
    body2 = nCreateBodyHull(mesh2,5)
        nSetEntityParent(body2,mesh2)
		nSetEntityPosition(body2,0,44,0)
        

Dim mesh3 As nMESH
Dim body3 As nBODY
    mesh3 = nCreateMeshCube()
		nSetMeshScale(mesh3,10,6,0.2)
        nSetEntityPosition(mesh3,0,38,0)
		nSetEntityTexture(mesh3,texture05,0)
    body3 = nCreateBodyHull(mesh3,5)
        nSetEntityParent(body3,mesh3)
		nSetEntityPosition(body3,0,38,0)

Dim mesh4 As nMESH
Dim body4 As nBODY
    mesh4 = nCreateMeshCube()
		nSetMeshScale(mesh4,10,6,0.2)
        nSetEntityPosition(mesh4,0,32,0)
		nSetEntityTexture(mesh4,texture04,0)
    body4 = nCreateBodyHull(mesh4,5)
        nSetEntityParent(body4,mesh4)
		nSetEntityPosition(body4,0,32,0)


Dim mesh7 As nMESH
Dim body7 As nBODY
    mesh7 = nCreateMeshCube()
		nSetMeshScale(mesh7,1,50,1)
        nSetEntityPosition(mesh7,100,25,0)
		nSetEntityTexture(mesh7,texture05,0)
    body7 = nCreateBodyHull(mesh7,0)
        nSetEntityParent(body7,mesh7)
        nSetEntityPosition(body7,100,25,0)
        
        
Dim mesh8 As nMESH
Dim body8 As nBODY
    mesh8 = nCreateMeshCube()
		nSetMeshScale(mesh8,8,8,8)
        nSetEntityPosition(mesh8,100,25,0)
		nSetEntityTexture(mesh8,texture04,0)
    body8 = nCreateBodyHull(mesh8,10)
        nSetEntityParent(body8,mesh8)
        nSetEntityPosition(body8,100,25,0)


Dim mesh6 As nMESH
Dim body6 As nBODY

mesh6=nCreateMeshCylinder(12)
    nSetMeshScale(mesh6,10,3,10)
    nSetEntityPosition(mesh6,100,50,0)
    nSetEntityTexture(mesh6,texture05,0)
body6 = nCreateBodyCylinder(10,3,0.5)
    nSetEntityParent(body6,mesh6)
    nSetEntityPosition(body6,100,50,0)

Dim mesh9 As nMESH
Dim body9 As nBODY

mesh9=nCreateMeshCylinder(12)
    nSetMeshScale(mesh9,15,4,15)
    nSetEntityPosition(mesh9,100,70,0)
    nSetEntityTexture(mesh9,texture05,0)
body9 = nCreateBodyCylinder(15,4,0.05)
    nSetEntityParent(body9,mesh9)
    nSetEntityPosition(body9,100,70,0)


'dim as nJoint joint87=nCreateJointSlider(100,25,0,0,1,0,body8,body7)
dim as nJoint joint87=nCreateJointCorkscrew(100,25,0,0,1,0,body8,body7)

dim as nJoint joint67=nCreateJointHinge(100,50,0,0,1,0,body6,body7)

dim as nJoint joint97=nCreateJointHinge(100,70,0,0,1,0,body9,body7)

dim as nJoint joint68=nCreateJointWormGear(5,0,1,0,0,1,0,body6,body8)


dim as nJoint joint96=nCreateJointGear(0.1,0,1,0,0,1,0,body9,body6)


dim as nJoint joint21=nCreateJointHinge(0,47,0,1,0,0,body2,body1)
'nSetHingeLimits(joint21,-45,45)
dim as nJoint joint32=nCreateJointHinge(0,41,0,1,0,0,body3,body2)
'nSetHingeLimits(joint32,-45,45)
dim as nJoint joint43=nCreateJointHinge(0,35,0,1,0,0,body4,body3)
'nSetHingeLimits(joint43,-45,45)


sub CreateChain( ByVal x As Single,ByVal y As Single,ByVal z As Single,ByVal mass As Single)

	Dim Body(30) As nBODY
	Dim c As nMESH
	Dim ball As nJOINT
	Dim i As UInteger
	

	For i = 1 To 9
		If i = 10 Then
			c = nCreateMeshSphere(32)
			nSetEntityTexture(c,texture04,0)
			nSetMeshScale(c, 20, 20, 20)
          
		Else
			c = nCreateMeshSphere(12)
			nSetEntityTexture(c,texture04,0)
			nSetMeshScale(c, 5, 5, 5)
		EndIf
		nSetEntityShininess(c,20)
		if i = 10 Then
			Body(i) = nCreateBodySphere(20,20,20,mass)' 1 + (i = height) * 2)
		Else
			If i = 1 then
				Body(i) = nCreateBodySphere(5,5,5,0)
			Else
				Body(i) = nCreateBodySphere(5,5,5,mass/1.5)
			EndIf
		EndIf
	
		nSetEntityParent(Body(i),c)
		nSetEntityPosition(Body(i),x,y - i * 13,z)
		nSetEntityPosition(c,x,y - i * 13,z)
	
		If i <> 1 Then
			ball = nCreateJointBall(x,y - i * 13,z,0,1,0,Body(i), Body(i - 1))'Create joint
				nSetBallLimits(ball,45.0,-10.0,10.0)'Limits!!!
		EndIf
	
	Next

End sub

CreateChain( 128,200,0,10)
CreateChain( 64,200,0,10)
CreateChain( 0,200,0,20)
CreateChain( -64,200,0,10)
CreateChain( -128,200,0,10)



Dim as nTexture tex01 = nLoadTexture("media/images/FullskiesOvercast0036_1_S.jpg")
nCreateSkyDome(tex01,10000)'Creates the sky    

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
			'nSetMeshScale(mesh,1,1,1)
        'dim  as nmesh mesh=loadmesh("media/ball.b3d")
		'ScaleMesh(mesh,0.4,0.4,0.4)
        
'Create a body type field.
	dim As nBODY body = nCreateBodySphere(1,1,1,0.3)
			nSetEntityParent(body,mesh)'The mesh uses the address data
										  'The body.
			nSetEntityPosition(body,camx,camy,camz)'The positions
			'LinearVelocity(body,tarx-camx,tary-camy,tarz-camz)'I applied speed
            nSetLinearVelocity(body,camx,camy,camz,tarx,tary,tarz,10)
            
'Activate the sound.
	nPlaySound(sound01)

End sub



While(EngineRun)'Returns 1 if the engine is running.

	'Begins scene
	BeginScene()
	
	'By pressing the "ESCAPE" closes the engine.
	If KeyHit(KEY_ESCAPE) Then CloseEngine()
    If MouseHit(MOUSE_RIGHT) Then CreateBullet()
	'Update the Engine.
	'Changing the value (only affects the physics) that will update the
	'Physical faster or slower.
	UpdateEngine(0.01)
        
     
    nWorldMousePick(nGetMouseX(),nGetMouseY(),MouseDown(MOUSE_LEFT))   
		
	'End the scene
	EndScene()
	
Wend

'Ends Ninfa3D Engine
EndEngine()
