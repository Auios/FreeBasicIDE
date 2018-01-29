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
nSetAmbientLight(120,120,120)'Ambient color
nSetWorldGravity(0,-10.0,0)
nSetWorldSize(10000,10000,10000)
nSetPhysicQuality(Q_LINEAR)		

'Create a camera
camera = nCreateCamera()
nSetEntityPosition(camera,512,50,512)
nSetCameraTarget(camera,0,0,0)
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

dim as nlight light01=nCreateLight(LGT_POINT)
nSetLightRadius(light01,150)
nSetLightColor(light01,200,150,50)
nSetEntityPosition(light01,0,100,0)

Dim As nMESH msh2 = nLoadMesh("media/meshes/impreza1.3ds",1)'Load a mesh
    nSetEntityFlag(msh2,6,0)
    nSetMeshScale(msh2,2,2,2)
    nSetEntityPosition(camera,0,40,-50)
    nSetEntityShininess(msh2,20)
	
Dim As nBODY bdy2 = nCreateBodyHull(msh2,300.0)'Create a cube body
	nSetEntityParent(bdy2,msh2)'This makes the mesh assigned, follow both
								  'Position as the rotation of the body.
    nSetBodyCenterOfMass(bdy2,0,-5,5)                              
	nSetEntityPosition(bdy2,50,50,100)
    
Dim As nJOINT vehicle = nCreateVehicle(0,0,1,bdy2)

Dim As nMESH FLWheel = nLoadMesh("media/meshes/tire1.3ds")'FindChild(msh2,"RuedaDelIzq")
nSetMeshScale(FLWheel,2,2,2)
Dim As nMESH FRWheel = nLoadMesh("media/meshes/tire1.3ds")'FindChild(msh2,"RuedaDelDer")
nSetMeshScale(FRWheel,2,2,2)
Dim As nMESH BLWheel = nLoadMesh("media/meshes/tire1.3ds")'FindChild(msh2,"RuedaTraIzq")
nSetMeshScale(BLWheel,2,2,2)
Dim As nMESH BRWheel = nLoadMesh("media/meshes/tire1.3ds")'FindChild(msh2,"RuedaTraDer")
nSetMeshScale(BRWheel,2,2,2)
'Configuration of the wheels.
Dim As single MASS = 15.0f
Dim As single FRICTION	= 5.0f
Dim As single sLENGTH = 3.0f
Dim As single sSPRING = 100.0f
Dim As single sDAMPER = 2.0f

'Add wheels to the chassis of the vehicle.
nAddTireVehicle(vehicle,FLWheel,14.0,-10,22,MASS,6.5,6,FRICTION,sLENGTH,sSPRING,sDAMPER)
nAddTireVehicle(vehicle,FRWheel,-14.0,-10,22,MASS,6.5,6,FRICTION,sLENGTH,sSPRING,sDAMPER)
nAddTireVehicle(vehicle,BLWheel,14.0,-10,-21,MASS,6.5,6,FRICTION,sLENGTH,sSPRING,sDAMPER)
nAddTireVehicle(vehicle,BRWheel,-14.0,-10,-21,MASS,6.5,6,FRICTION,sLENGTH,sSPRING,sDAMPER)        
    
Dim as nTexture tex01 = nLoadTexture("media/images/FullskiesOvercast0036_1_S.jpg")
nCreateSkyDome(tex01,10000)'Creates the sky    


dim as single steer=nGetCurveValue(1,0,10)




While(EngineRun)'Returns 1 if the engine is running.

	'Begins scene
	BeginScene()
	
	'By pressing the "ESCAPE" closes the engine.
	If KeyHit(KEY_ESCAPE) Then CloseEngine()

	'Update the Engine.
	'Changing the value (only affects the physics) that will update the
	'Physical faster or slower.
	UpdateEngine(0.05)
        
     If KeyDown(KEY_W) Then
		nApplyTorqueVehicle(vehicle,0,100.0f)
		nApplyTorqueVehicle(vehicle,1,100.0f)
		nApplyTorqueVehicle(vehicle,2,100.0f)
		nApplyTorqueVehicle(vehicle,3,100.0f)
    
    
	elseIf KeyDown(KEY_S) Then
		nApplyTorqueVehicle(vehicle,0,-100.0f)
		nApplyTorqueVehicle(vehicle,1,-100.0f)
		nApplyTorqueVehicle(vehicle,2,-100.0f)
		nApplyTorqueVehicle(vehicle,3,-100.0f)
	else
        nApplyBrakeVehicle(vehicle,0,0.01f)
		nApplyBrakeVehicle(vehicle,1,0.01f)
        nApplyBrakeVehicle(vehicle,2,0.01f)
		nApplyBrakeVehicle(vehicle,3,0.01f)
    EndIf

	If KeyDown(KEY_A) Then
        
            steer=nGetCurveValue(1,steer,10)
			'nApplySteeringVehicle(vehicle,0,-0.0001f)
            nApplySteeringJoystickVehicle(vehicle,0,-0.1,steer)
			'nApplySteeringVehicle(vehicle,1,-0.0001f)
            nApplySteeringJoystickVehicle(vehicle,1,-0.1,steer)
	ElseIf KeyDown(KEY_D) Then
            steer=nGetCurveValue(1,steer,10)
			'nApplySteeringVehicle(vehicle,0,0.0001f)
            nApplySteeringJoystickVehicle(vehicle,0,0.1f,steer)
			'nApplySteeringVehicle(vehicle,1,0.0001f)
            nApplySteeringJoystickVehicle(vehicle,1,0.1f,steer)
	Else
        steer=0.0f
		'nApplySteeringVehicle(vehicle,0,0.0f)
        nApplySteeringJoystickVehicle(vehicle,0,0.000f,steer)
		'nApplySteeringVehicle(vehicle,1,0.0f)
        nApplySteeringJoystickVehicle(vehicle,1,0.000f,steer)
	EndIf

	If KeyDown(KEY_SPACE) Then
		nApplyBrakeVehicle(vehicle,0,5.0f)
		nApplyBrakeVehicle(vehicle,1,5.0f)
        nApplyBrakeVehicle(vehicle,2,5.0f)
		nApplyBrakeVehicle(vehicle,3,5.0f)
	EndIf
    
    'nSetEntityPosition( camera, CurveValue( entityX(mshsph), entityX(camera), 20 ), entityY(mshsph)+30, CurveValue( entityZ(mshsph), entityZ(camera), 20 ) )
	nSetCameraTarget(camera,nGetEntityX(bdy2),nGetEntityY(bdy2),nGetEntityZ(bdy2))
    nWorldMousePick(nGetMouseX(),nGetMouseY(),MouseDown(MOUSE_LEFT))   
		
	'End the scene
	EndScene()
	
Wend

'Ends Ninfa3D Engine
EndEngine()
