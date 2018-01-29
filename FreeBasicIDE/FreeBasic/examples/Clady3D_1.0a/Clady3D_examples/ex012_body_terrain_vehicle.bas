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
nSetWorldSize(10000,10000,10000)
nSetPhysicQuality(Q_LINEAR)	
nSetFog(96,96,96,0.001)	

'Create a camera
camera = nCreateCamera()
nSetEntityPosition(camera,3000,50,3500)
nSetCameraRange(camera,0.1,12000)


font1=nLoadFont("media/font/courier.xml")
nSetFont(font1)

dim as nTexture tex01 = nLoadTexture("media/images/FullskiesOvercast0036_1_S.jpg")
nCreateSkyDome(tex01,10000)'Creates the sky

dim as nTexture texcolormap = nLoadTexture("media/terrain/colormap.jpg")
dim as nTexture texdetail = nLoadTexture("media/terrain/detail.jpg")
'Create a terrain mesh
dim as nTerrain terrain = nLoadTerrain("media/terrain/heightmap.bmp",12,4,17)
    nSetEntityType(terrain,4)
    nSetEntityPosition(terrain,0,0,0)
    nSetMeshScale(terrain,10,2,10)
	nSetEntityTexture(terrain,texcolormap,0)
    nSetEntityTexture(terrain,texdetail,1)
	nSetScaleTerrainTexture(terrain,1,256)'Scale the texture of the terrain
    nSetEntityFlag(terrain,8,1)

dim as uinteger ptr bodyterrain = nCreateBodyTerrain(terrain,12)
	nSetEntityPosition(bodyterrain,0,0,0)
    
Dim shared sound01 As nSOUND
	sound01 = nLoadSound("media/sounds/bullet_hit1.wav")
    nSetSoundType(sound01,1)    

Dim As nMESH mshsph = nCreateMeshSphere(12)'use this sphere as pivot camera
nSetMeshScale( mshsph, 0.01, 0.01, 0.01 )
nSetEntityPosition(mshsph,0,-10,-50)

Dim As nMESH msh2 = nLoadMesh("media/meshes/impreza1.3ds")'Load a mesh
    nSetEntityFlag(msh2,6,0)
    nSetMeshScale(msh2,2,2,2)
    
    
    
    
    'nSetEntityPosition(camera,0,20,-50)
	
Dim As nBODY bdy2 = nCreateBodyHull(msh2,300.0)'Create a cube body
	nSetEntityParent(bdy2,msh2)'This makes the mesh assigned, follow both
    nSetBodyCenterOfMass(bdy2,0,-5,5)
    nSetEntityPosition(bdy2,2700,50,3700)
    
    nSetEntityParent(mshsph,msh2)
    
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
			nSetLinearVelocity(body,camx,camy,camz,tarx,tary,tarz,40)
            
'Activate the sound.
	nPlaySound(sound01)

End sub

Dim Shared texture05 As nTEXTURE 
	texture05 = nLoadTexture("media/images/Wood.jpg")

Dim mesh1 As nMESH
Dim body1 As nBODY
    mesh1 = nCreateMeshCube()
		nSetMeshScale(mesh1,1,50,1)
        nSetEntityPosition(mesh1,2500,25,2750)
		nSetEntityTexture(mesh1,texture05,0)
    body1 = nCreateBodyHull(mesh1,0)
        nSetEntityParent(body1,mesh1)
        nSetEntityPosition(body1,2500,25,2750)
        
        


Dim mesh2 As nMESH
Dim body2 As nBODY
    mesh2 = nCreateMeshCube()
		nSetMeshScale(mesh2,1,50,1)
        nSetEntityPosition(mesh2,2600,25,2750)
		nSetEntityTexture(mesh2,texture05,0)
    body2 = nCreateBodyHull(mesh2,0)
        nSetEntityPosition(body2,2600,25,2750)
        nSetEntityParent(body2,mesh2)
        

Dim mesh3 As nMESH
Dim body3 As nBODY
    mesh3 = nCreateMeshCube()
		nSetMeshScale(mesh3,48,40,1)
        nSetEntityPosition(mesh3,2525,25,2750)
		nSetEntityTexture(mesh3,texture05,0)
    body3 = nCreateBodyHull(mesh3,50)
        nSetEntityPosition(body3,2525,25,2750)
        nSetEntityParent(body3,mesh3)
        
        
Dim mesh4 As nMESH
Dim body4 As nBODY
    mesh4 = nCreateMeshCube()
		nSetMeshScale(mesh4,48,40,1)
        nSetEntityPosition(mesh4,2575,25,2750)
		nSetEntityTexture(mesh4,texture05,0)
    body4 = nCreateBodyHull(mesh4,50)
        nSetEntityParent(body4,mesh4)
		nSetEntityPosition(body4,2575,25,2750)
        





'dim as nJoint joint31=nCreateJointHinge(2501,15,2750,0,1,0,body3,body1)
dim as nJoint joint31=nCreateJointCorkscrew(2501,15,2750,0,1,0,body3,body1)



'dim as nJoint joint42=nCreateJointHinge(2599,25,2750,0,1,0,body4,body2)

'dim as nJoint joint42=nCreateJointSlider(2599,25,2750,0,1,0,body4,body2)

dim as nJoint joint42=nCreateJointCorkscrew(2599,25,2750,0,1,0,body4,body2)





dim as single steer=nGetCurveValue(1,0,5)



While(EngineRun)'Returns 1 if the engine is running.

	'Begins scene
	BeginScene()
	
	'By pressing the "ESCAPE" closes the engine.
	If KeyHit(KEY_ESCAPE) Then CloseEngine()
    
    If MouseHit(MOUSE_RIGHT) Then CreateBullet()
	'Update the Engine.
	'Changing the value (only affects the physics) that will update the
	'Physical faster or slower.
	UpdateEngine(0.05)
    
    
     If KeyDown(KEY_W) Then
		nApplyTorqueVehicle(vehicle,0,50.0f)
		nApplyTorqueVehicle(vehicle,1,50.0f)
		nApplyTorqueVehicle(vehicle,2,50.0f)
		nApplyTorqueVehicle(vehicle,3,50.0f)
    
    
	elseIf KeyDown(KEY_S) Then
		nApplyTorqueVehicle(vehicle,0,-50.0f)
		nApplyTorqueVehicle(vehicle,1,-50.0f)
		nApplyTorqueVehicle(vehicle,2,-50.0f)
		nApplyTorqueVehicle(vehicle,3,-50.0f)
	else
        nApplyBrakeVehicle(vehicle,0,0.01f)
		nApplyBrakeVehicle(vehicle,1,0.01f)
        nApplyBrakeVehicle(vehicle,2,0.01f)
		nApplyBrakeVehicle(vehicle,3,0.01f)
    EndIf

	If KeyDown(KEY_A) Then
        
            steer=nGetCurveValue(1,steer,20)
			'nApplySteeringVehicle(vehicle,0,-0.0001f)
            nApplySteeringJoystickVehicle(vehicle,0,-0.1,steer)
			'AnApplySteeringVehicle(vehicle,1,-0.0001f)
            nApplySteeringJoystickVehicle(vehicle,1,-0.1,steer)
	ElseIf KeyDown(KEY_D) Then
            steer=nGetCurveValue(1,steer,20)
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
    nSetEntityPosition( camera, nGetCurveValue( nGetEntityX(mshsph), nGetEntityX(camera), 20 ), nGetEntityY(mshsph)+30, nGetCurveValue( nGetEntityZ(mshsph), nGetEntityZ(camera), 20 ) )
    nSetCameraTarget(camera,nGetEntityX(bdy2),nGetEntityY(bdy2),nGetEntityZ(bdy2))
    nWorldMousePick(nGetMouseX(),nGetMouseY(),MouseDown(MOUSE_LEFT))
    
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
