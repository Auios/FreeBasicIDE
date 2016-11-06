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
nSetAmbientLight(250,250,250)'Ambient color
nSetWorldGravity(0,-10.0,0)
nSetFog(96,96,96,0.0001)	

'Create a camera
camera = nCreateCameraFPS(100,1)
nSetEntityPosition(camera,2500,50,2500)
nSetCameraRange(camera,0.1,12000)


font1=nLoadFont("media/font/courier.xml")
nSetFont(font1)

dim as nTexture tex01 = nLoadTexture("media/images/FullskiesOvercast0036_1_S.jpg")
nCreateSkyDome(tex01,10000)'Creates the sky

dim as nTexture texcolormap = nLoadTexture("media/terrain/colormap.jpg")
dim as nTexture texdetail = nLoadTexture("media/terrain/detail.jpg")
'Create a terrain mesh
dim as nTerrain terrain = nLoadTerrain("media/terrain/heightmap.bmp",4,4,17)
    nSetEntityType(terrain,4)
    'nSetEntityPosition(terrain,0,-70,0)
    nSetMeshScale(terrain,10,5,10)
	nSetEntityTexture(terrain,texcolormap,0)
    nSetEntityTexture(terrain,texdetail,1)
	nSetScaleTerrainTexture(terrain,1,256)'Scale the texture of the terrain


Dim as nTexture grassTexture = nLoadTexture( "media/grass/grass.png" )


Dim as nImage xterrainHeight=nLoadImagefromFile("media/terrain/heightmap.bmp")
Dim as nImage terrainColor=nLoadImagefromFile("media/terrain/colormap.jpg")
Dim as nImage grassMap=nLoadImagefromFile("./media/grass/terrain-grassmap.bmp")
' we add the grass in as 100 seperate patches, these could even be grouped
' under a set of zone managers to make them more efficient

dim as nGrass grassNode
dim as INTEGER x,y

for x = 0 to 9
    for y = 0 to 9
        ' here we add the grass object, it has the following parameters: -
        ' a terrain onto which the grass layered,
        ' an x and y coordinate for the patch
        ' a size for the patch
        ' a scale for the grass height
        ' the height map associated with the terrain used for setting grass height
        ' the texture map associated with the terrain used for coloring the grass
        ' a grass map defining the types of grass placed onto the terrain
        ' a texture map containing the images of the grass
         grassNode = nAddGrass (terrain, x, y, 1024, 1.0, 2048, 0, 0, xterrainHeight, terrainColor, grassMap, grassTexture )                               
        ' here we set how much grass is visible firstly the number of grass
        ' particles that can be seen and secondly the distance upto which they
        ' are drawn
        nSetGrassDensity ( grassNode, 2048, 2048 )
        'grassrender(grassnode)
        ' here we set the wind effect on the grass, first parameter sets the
        ' strength of the wind and the second the resoloution
        nSetGrassWind ( grassNode, 1.0, 1.0 )
        
        nSetEntityFlag( grassNode, 3, 1 )
    next y
next x


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
    nDrawFontText(25,150,"xameraX: "+str$(nGetEntityX(camera)),0,0) 
    nDrawFontText(25,170,"xameraY: "+str$(nGetEntityY(camera)),0,0)
    nDrawFontText(25,190,"xameraZ: "+str$(nGetEntityZ(camera)),0,0)    		
	'End the scene
	EndScene()
	
Wend

'Ends Ninfa3D Engine
EndEngine()
