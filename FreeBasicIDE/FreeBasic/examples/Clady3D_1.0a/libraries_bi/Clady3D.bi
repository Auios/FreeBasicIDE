
#inclib "Clady3D"

Type I As Integer
Type UI As Uinteger
Type S As Single

' a vector consisting of 3 float values
TYPE IRR_VECTOR
    x as single
    y as single
    z as single
END TYPE

Type nENTITY As Uinteger Ptr
Type nMESH As Uinteger Ptr
Type nCAMERA As Uinteger Ptr
Type nSOUND As Uinteger Ptr
Type nLIGHT As Uinteger Ptr
Type nBillboard As Uinteger Ptr
Type nBODY As Uinteger Ptr
Type nCHILD As Uinteger Ptr
Type nFONT As Uinteger Ptr
Type nTEXTURE As Uinteger Ptr
Type nTERRAIN As Uinteger Ptr
Type nREAD As Uinteger Ptr
Type nWRITE As Uinteger Ptr
Type nPARTICLE As Uinteger Ptr
Type nEMITTER As Uinteger Ptr
Type nSHADER As Uinteger Ptr
Type nJOINT As Uinteger Ptr
Type nGUI As Uinteger Ptr
Type nMATERIAL As Uinteger Ptr
Type nLensFlare As Uinteger Ptr
Type nTimer As Uinteger Ptr
Type nClouds As Uinteger Ptr
Type nImage As Uinteger Ptr
Type nGrass As Uinteger Ptr
Type nBSPNode As Uinteger Ptr
Type nSplatManagerOGL As Uinteger Ptr
Type nSplatManagerDX9 As Uinteger Ptr
Type nBolt As Uinteger Ptr
Type nBeam As Uinteger Ptr
Type nTriSelector As Uinteger Ptr
Type nArrow As Uinteger Ptr

'Keyboard
#define KEY_LBUTTON 1
#define KEY_RBUTTON 2
#define KEY_CANCEL 3
#define KEY_MBUTTON 4
#define KEY_XBUTTON1 5
#define KEY_XBUTTON2 6
#define KEY_BACK 8 
#define KEY_TAB 9 
#define KEY_CLEAR 12
#define KEY_RETURN 13 
#define KEY_SHIFT 16
#define KEY_CONTROL 17
#define KEY_MENU 18
#define KEY_PAUSE 19 
#define KEY_CAPITAL 20
#define KEY_KANA 21
#define KEY_HANGUEL 21
#define KEY_HANGUL 21
#define KEY_JUNJA 23
#define KEY_FINAL 24 
#define KEY_HANJA 25
#define KEY_KANJI 25
#define KEY_ESCAPE 27
#define KEY_CONVERT 28 
#define KEY_NONCONVERT 29 
#define KEY_ACCEPT 30
#define KEY_MODECHANGE 31
#define KEY_SPACE 32 
#define KEY_PRIOR 33
#define KEY_NEXT 34
#define KEY_END 35
#define KEY_HOME 36
#define KEY_LEFT 37
#define KEY_UP 38 
#define KEY_RIGHT 39 
#define KEY_DOWN 40 
#define KEY_SELECT 41
#define KEY_PRINT 42 
#define KEY_EXECUT 43
#define KEY_SNAPSHOT 44
#define KEY_INSERT 45 
#define KEY_DELETE 46 
#define KEY_HELP 47
#define KEY_0 48 
#define KEY_1 49
#define KEY_2 50
#define KEY_3 51
#define KEY_4 52 
#define KEY_5 53
#define KEY_6 54
#define KEY_7 55
#define KEY_8 56 
#define KEY_9 57
#define KEY_A 65 
#define KEY_B 66 
#define KEY_C 67 
#define KEY_D 68
#define KEY_E 69
#define KEY_F 70
#define KEY_G 71 
#Define KEY_H 72 
#define KEY_I 73 
#define KEY_J 74 
#define KEY_K 75 
#define KEY_L 76 
#define KEY_M 77 
#define KEY_N 78
#define KEY_O 79 
#define KEY_P 80
#define KEY_Q 81
#define KEY_R 82 
#define KEY_S 83 
#define KEY_T 84 
#define KEY_U 85 
#define KEY_V 86
#define KEY_W 87 
#define KEY_X 88 
#define KEY_Y 89
#define KEY_Z 90 
#define KEY_LWIN 91 
#define KEY_RWIN 92
#define KEY_APPS 93 
#define KEY_SLEEP 94
#define KEY_NUMPAD0 96 
#define KEY_NUMPAD1 97 
#define KEY_NUMPAD2 98 
#define KEY_NUMPAD3 99 
#define KEY_NUMPAD4 100 
#define KEY_NUMPAD5 101 
#define KEY_NUMPAD6 102 
#define KEY_NUMPAD7 103
#define KEY_NUMPAD8 104 
#define KEY_NUMPAD9 105
#define KEY_MULTIPLY 106
#define KEY_ADD 107
#define KEY_SEPARATOR 108
#define KEY_SUBTRACT 109
#define KEY_DECIMAL 110
#define KEY_DIVIDE 111
#define KEY_F1 112 
#define KEY_F2 113
#define KEY_F3 114
#define KEY_F4 115
#define KEY_F5 116 
#define KEY_F6 117
#define KEY_F7 118
#define KEY_F8 119
#define KEY_F9 120 
#define KEY_F10 121
#define KEY_F11 122 
#define KEY_F12 123
#define KEY_F13 124
#define KEY_F14 125
#define KEY_F15 126
#define KEY_F16 127 
#define KEY_F17 128 
#define KEY_F18 129 
#define KEY_F19 130
#define KEY_F20 131
#define KEY_F21 132
#define KEY_F22 133
#define KEY_F23 134
#define KEY_F24 135
#define KEY_NUMLOCK 144 
#define KEY_SCROLL 145
#define KEY_LSHIFT 160
#define KEY_RSHIFT 161
#define KEY_LCONTROL 162 
#define KEY_RCONTROL 163
#define KEY_LMENU 164
#define KEY_RMENU 165 
#define KEY_PLUS 187 
#define KEY_COMMA 188
#define KEY_MINUS 189
#define KEY_PERIOD 190
#define KEY_ATTN 246
#define KEY_CRSEL 247
#define KEY_EXSEL 248
#define KEY_EREOF 249
#define KEY_PLAY 250
#define KEY_ZOOM 251
#define KEY_PA1 253
#define KEY_OEM_CLEAR 254
#define KEY_CODES_COUNT 255






'MOUSE
#define MOUSE_LEFT 0
#define MOUSE_MIDDLE 1
#define MOUSE_RIGHT 2

Enum PHYSIC_QUALITY
	Q_LINEAR = 0
	Q_ADAPTATIVE
	Q_EXACT
End Enum

Enum CHIL_UPDATE_MODE
	C_NONE = 0
	C_READ
	C_CONTROL
	C_COUNT
End Enum

Enum LIGHT_TYPE
	LGT_POINT = 0
	LGT_SPOT
	LGT_DIRECTIONAL
End Enum

Enum MATERIAL_FLAG
	MF_WIREFRAME = 0
	MF_POINTCLOUD
	MF_FLAT
	MF_FULLBRITGH
	MF_ZBUFFER
	MF_ZWRITER
	MF_BACKFACE
	MF_FRONTFACE
	MF_FOG
	MF_NORMALIZE
    MF_WRAP
    MF_COLOR_MASK
    MF_COLOR_MATERIAL
End Enum

Enum MATERIAL_TYPE
	EMT_SOLID = 0
	EMT_LIGHTMAP
    EMT_LIGHTMAP_ADD
	EMT_LIGHTMAP_LIGHTING
	EMT_DETAIL_MAP
	EMT_SPHERE_MAP
	EMT_REFLECTION_2_LAYER
	EMT_TRANSPARENT_ADD_COLOR
	EMT_TRANSPARENT_ALPHA_CHANNEL
	EMT_TRANSPARENT_ALPHA_CHANNEL_REF
	EMT_TRANSPARENT_VERTEX_ALPHA
	EMT_TRANSPARENT_REFLECTION_2_LAYER
	EMT_NORMAL_MAP_SOLID
	EMT_PARALLAX_MAP_SOLID
	EMT_PARALLAX_MAP_TRANSPARENT_ADD_COLOR
	EMT_PARALLAX_MAP_TRANSPARENT_VERTEX_ALPHA
	EMT_ONETEXTURE_BLEND
End Enum


Enum VERTEX_TYPE
	VT_TCOORS = 0
	VT_TANGENTS
End Enum

Enum MODE_UP
	UP_ALL = 0
	UP_GRAPHICS
	UP_PHYSICS
	UP_SOUNDS
End Enum

Enum IRR_TERRAIN_PATCH_SIZE
    ETPS_9 = 9                    ' patch size of 9, at most, use 4 levels of detail with this patch size.  
    ETPS_17 = 17                  ' patch size of 17, at most, use 5 levels of detail with this patch size.  
    ETPS_33 = 33                  ' patch size of 33, at most, use 6 levels of detail with this patch size.  
    ETPS_65 = 65                  ' patch size of 65, at most, use 7 levels of detail with this patch size.  
    ETPS_129 = 129                ' patch size of 129, at most, use 8 levels of detail with this patch size. 
End Enum

' A color format specifies how color information is stored
Enum IRR_COLOR_FORMAT
    ECF_A1R5G5B5 = 0       ' 16 bit color format used by the software driver, and thus preferred by all other irrlicht engine video drivers. There are 5 bits for every color component, and a single bit is left for alpha information.  
    ECF_R5G6B5          ' Standard 16 bit color format.  
    ECF_R8G8B8          ' 24 bit color, no alpha channel, but 8 bit for red, green and blue.  
    ECF_A8R8G8B8        ' Default 32 bit color format. 8 bits are used for every component: red, green, blue and alpha.  
End Enum

Enum IRR_TEXTURE_BLEND
    BLEND_SCREEN = 0
    BLEND_ADD
    BLEND_SUBTRACT
    BLEND_MULTIPLY
    BLEND_DIVIDE
End Enum

Enum ALPHA_CHANNEL_COLOR
    ALPHA_RED = 1
    ALPHA_GREEN = 2
    ALPHA_BLUE = 3
    ALPHA_ALPHA = 4
End Enum


'/--------------------------------|
'[GRAPHICS 2D                       ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/
'set the transparency of 2d graphic objects on the screen
Declare Sub nSetTransparency2D Cdecl Alias "nSetTransparency2D" (Byval Level As Uinteger)
'set the colors for the graphic operations on the screen
Declare Sub nSetColors2D Cdecl Alias "nSetColors2D" (Byval Red As Uinteger,Byval Green As Uinteger,Byval Blue As Uinteger)
'draws a 2D line on the screen
Declare Sub nDrawLine2D Cdecl Alias "nDrawLine2D" (Byval x1 As Integer,Byval y1 As Integer,Byval x2 As Integer,Byval y2 As Integer)
'draws a rectangle 2D on the screen
Declare Sub nDrawRect2D Cdecl Alias "nDrawRect2D" (Byval x As Integer,Byval y As Integer,Byval widht As Integer,Byval height As Integer)
'draws a pixel on the screen
Declare Sub nDrawPixel2D Cdecl Alias "nDrawPixel2D" (Byval x As Integer,Byval y As Integer)
'draws an image from a texture on the screen
Declare Sub nDrawImage2D Cdecl Alias "nDrawImage2D" (Byval texture As nTEXTURE,Byval x As Integer,Byval y As Integer)
'draws an image on the screen using the alpha channel
Declare Sub nDrawImage2DWithAlpha Cdecl Alias "nDrawImage2DWithAlpha" (Byval texture As nTEXTURE,Byval x As Integer,Byval y As Integer,_
                                                        byval usealpha as integer)
'draws an oval on the screen
Declare Sub nDrawOval2D Cdecl Alias "nDrawOval2D" (Byval x As Integer,Byval y As Integer,Byval Radius As single)
'draws a part of a texture as a 2D sprite on the screen
Declare Sub nDrawImageSprites2D Cdecl Alias "nDrawImageSprites2D" (Byval texture As nTEXTURE,Byval x As Integer,Byval y As Integer,Byval TX As Integer,Byval TY As Integer,_
Byval BX As Integer,Byval BY As Integer)
'create a blank image in RAM
Declare Function nCreateImage2 cdecl alias "nCreateImage2"(byval format as irr_color_format, byval w as integer,byval h as integer) as uinteger ptr 
'write an image to file
Declare Sub nWriteImageToFile cdecl alias "nWriteImageToFile"(byval image as uinteger ptr,byval imgext as integer)
'write a splat image to file depends by the splatting pass
Declare Sub nWriteImageSplatToFile cdecl alias "nWriteImageSplatToFile"(byval image as uinteger ptr,byval nrsplat as integer)
'load an image from file
declare function nLoadImageFromFile CDECL alias "nLoadImageFromFile"(Byval filename as  zstring ptr) as nImage
'create a blank image in RAM
declare function nCreateImage CDECL alias "nCreateImage" ( byval x as integer, byval y as integer, byval format as IRR_COLOR_FORMAT ) as nimage
' remove an image freeing its resources
declare sub nRemoveImage CDECL alias "nRemoveImage" ( byval image as nimage )
' locks the image and returns a pointer to the pixels
declare function nLockImage CDECL alias "nLockImage" ( byval image as nimage ) as uinteger ptr
' unlock the image, presumably after it has been modified
declare sub nUnlockImage CDECL alias "nUnlockImage" ( byval image as nimage )
'copy and scaling an image
declare sub  nCopyImageToScaling CDECL alias "nCopyImageToScaling"(byval imgsrc as uinteger ptr, byval imgtarget as uinteger ptr)
'get the width of the image
declare function nGetImageWidth  CDECL alias "nGetImageWidth"(byval imagine as uinteger ptr) as integer
'get the height of the image
declare function nGetImageHeight  CDECL alias "nGetImageHeight"(byval imagine as uinteger ptr) as integer
' blend the source image into the destination image to create a single image
declare function nBlendImages CDECL alias "nBlendImages" ( byval destination_image as nImage, byval source_image as nImage, byval x_offset as integer, byval y_offset as integer, byval operation as integer ) as integer
' blend the source image into the destination image using a third alphamap with rgb channels to create a single image
declare function nAlphaBlendImages CDECL alias "nAlphaBlendImages" ( byval destination_image as nImage, byval source_image as nImage, byval alpha_image as nImage,BYVAL alphacolorchannel as ALPHA_CHANNEL_COLOR) as integer
'paint the destination(base)image with a source image using an alpha value at x,y position
declare function nPaintTileImageWithAlpha CDECL alias "nPaintTileImageWithAlpha" ( byval destination_image as nImage, byval source_image as nImage, byval xpos as integer,BYVAL ypos as integer,byval radius as integer,byval alpha as integer) as integer

'paint the splat maps in the terrain editor
declare function nPaintSplatOGL CDECL alias "nPaintSplatOGL" (byval curentsplat as nTexture,_
                                                            byval othersplata as nTexture,_
                                                            byval othersplatb as nTexture,_
                                                            byval othersplatc as nTexture,_
                                                            byval stage as integer,_
                                                            byval chanelcolor as integer,_
                                                            byval xpos as integer,_
                                                            BYVAL ypos as integer,_
                                                            byval radius as integer,_
                                                            byval alpha as integer) as integer


'paint lightmap in the terrain editor
declare function nPaintLightMap CDECL alias "nPaintLightMap"(byval hm_terrain as zstring ptr,_
                                                            byval lm_texture as ntexture,_
                                                            byval sundist as integer,_
                                                            byval sunheight as integer) as integer
'interpolate the lightmap in the terrain editor                                                           
declare sub nInterpolateLightMap CDECL alias "nInterpolateLightMap"(byval lm_texture as ntexture)                                                            
'clear lightmap in the terrain editor                                                           
declare sub nClearLightMap CDECL alias "nClearLightMap"(byval lm_texture as ntexture)

'/--------------------------------|
'[INPUT                           ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/
'return 1 if true
Declare Function KeyDown Cdecl Alias "KeyDown" (Byval keystate As Integer) As Integer
'return 1 if true
Declare Function KeyHit Cdecl Alias "KeyHit" (Byval keystate As Integer) As Integer
'return 1 if true
Declare Function MouseHit Cdecl Alias "MouseHit" (Byval keystate As Integer) As Integer
'return 1 if true
Declare Function MouseDown Cdecl Alias "MouseDown" (Byval keystate As Integer) As Integer
'move mouse at x,y points
Declare Sub MoveMouse Cdecl Alias "MoveMouse" (Byval x As Integer,Byval y As Integer)
'return + or - if mouse wheel is active
Declare Function nGetMouseWheel Cdecl Alias "nGetMouseWheel" () As Integer
'return x mouse position
Declare Function nGetMouseX Cdecl Alias "nGetMouseX" () As Integer
'return y mouse position
Declare Function nGetMouseY Cdecl Alias "nGetMouseY" () As Integer
'show mouse on the screen
Declare Sub ShowMouse Cdecl Alias "ShowMouse" ()
'hide mouse
Declare Sub HideMouse Cdecl Alias "HideMouse" ()

'/--------------------------------|
'[FILE                            ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

Declare Sub nChangeDirectory Cdecl Alias "nChangeDirectory" (Byval file As I)
Declare Function nGetExistFile Cdecl Alias "nGetExistFile" (Byval file As Zstring Ptr) As Integer
Declare Sub nLoadZip Cdecl Alias "nLoadZip" (Byval file As ZString ptr)
Declare Function nLoadScene Cdecl Alias "nLoadScene" (Byval file As ZString ptr) As nMesh
Declare Sub nSaveScene Cdecl Alias "nSaveScene" (Byval file As ZString ptr)



'/--------------------------------|
'[TERRAIN SPLATTING GLSL                       ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\----------------------------------------------------
'create a splat manager in OpenGL driver mode
Declare function nCreateSplatManagerOGL CDECL alias "nCreateSplatManagerOGL"() as uinteger ptr
'bind the splat manager with the terrain
Declare sub nBindSplatManagerOGLwithTerrain CDECL alias "nBindSplatManagerOGLwithTerrain"(Byval splatmanager as nSplatManagerOGL, Byval terrain as nTerrain,_
                                                                                        byval nrpass as integer,_
                                                                                        byval lum as integer,_
                                                                                        byval anim as integer)
'bind the splat manager with the terrain
Declare sub nBindSplatManagerOGLwithTerrain2 CDECL alias "nBindSplatManagerOGLwithTerrain2"(Byval splatmanager as nSplatManagerOGL,_
                                                                                        Byval terrain as nTerrain,_
                                                                                        Byval splat1 as ntexture,_
                                                                                        Byval splat2 as ntexture,_
                                                                                        Byval splat3 as ntexture,_
                                                                                        Byval splat4 as ntexture,_
                                                                                        Byval splat_lm as ntexture,_
                                                                                        Byval tile1_red as ntexture,_
                                                                                        Byval tile1_green as ntexture,_
                                                                                        Byval tile1_blue as ntexture,_
                                                                                        Byval tile2_red as ntexture,_
                                                                                        Byval tile2_green as ntexture,_
                                                                                        Byval tile2_blue as ntexture,_
                                                                                        Byval tile3_red as ntexture,_
                                                                                        Byval tile3_green as ntexture,_
                                                                                        Byval tile3_blue as ntexture,_
                                                                                        Byval tile4_red as ntexture,_
                                                                                        Byval tile4_green as ntexture,_
                                                                                        Byval tile4_blue as ntexture,_
                                                                                        Byval tile_lm as ntexture,_
                                                                                        byval nrpass as integer,_
                                                                                        byval lum as integer,_
                                                                                        byval anim as integer)                                                                                        
                                                                                        
'draw splat in the main loop
Declare sub nDrawSplatOGL CDECL alias "nDrawSplatOGL"(Byval splatmanager as nSplatManagerOGL)


'/--------------------------------|
'[TERRAIN SPLATTING hlsl 2                       ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\----------------------------------------------------
'create a splat manager for HLSL shader in DirectX 9.0c
Declare function nCreateSplatManagerDX9 CDECL alias "nCreateSplatManagerDX9"() as uinteger ptr
'bind the splat manager with the terrain
Declare sub nBindSplatManagerDX9withTerrain CDECL alias "nBindSplatManagerDX9withTerrain"(Byval splatmanager as uinteger ptr, Byval terrain as nTerrain,_
                                                                                        byval nrpass as integer,_
                                                                                       byval lum as integer,_
                                                                                       byval anim as integer)
                                                                                        
'bind the splat manager with the terrain
Declare sub nBindSplatManagerDX9withTerrain2 CDECL alias "nBindSplatManagerDX9withTerrain2"(Byval splatmanager as uinteger ptr,_
                                                                                        Byval terrain as nTerrain,_
                                                                                        Byval splat1 as ntexture,_
                                                                                        Byval splat2 as ntexture,_
                                                                                        Byval splat3 as ntexture,_
                                                                                        Byval splat4 as ntexture,_
                                                                                        Byval splat_lm as ntexture,_
                                                                                        Byval tile1_red as ntexture,_
                                                                                        Byval tile1_green as ntexture,_
                                                                                        Byval tile1_blue as ntexture,_
                                                                                        Byval tile2_red as ntexture,_
                                                                                        Byval tile2_green as ntexture,_
                                                                                        Byval tile2_blue as ntexture,_
                                                                                        Byval tile3_red as ntexture,_
                                                                                        Byval tile3_green as ntexture,_
                                                                                        Byval tile3_blue as ntexture,_
                                                                                        Byval tile4_red as ntexture,_
                                                                                        Byval tile4_green as ntexture,_
                                                                                        Byval tile4_blue as ntexture,_
                                                                                        Byval tile_lm as ntexture,_
                                                                                        byval nrpass as integer,_
                                                                                        byval lum as integer,_
                                                                                        byval anim as integer)


'create a splat manager for HLSL shader in DirectX 9.0c 
'Declare sub CreateSplatManagerDX92 CDECL alias "CreateSplatManagerDX92"(byval terrain as uinteger ptr )
'draw the splat in the main loop
Declare sub nDrawSplatDX9 CDECL alias "nDrawSplatDX9"(Byval splatmanager as UINTEGER PTR)

 


'/--------------------------------|
'[GRASS                        ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\----------------------------------------------------


Declare function nAddGrass CDECL alias "nAddGrass"(Byval terrain as nTerrain,_
Byval x as integer,Byval z as integer,Byval patchSize as integer,Byval grassScale as Single,_
Byval maxDensity as Uinteger,Byval dataPozitionX as integer,Byval dataPozitionY as integer,_
Byval heightMap as nImage,Byval textureMap as nImage,Byval grassMap as nImage,Byval grassTexture as nTexture) as nGrass

Declare sub nSetGrassDensity CDECL alias "nSetGrassDensity"(Byval grass as nGrass,Byval density as Integer,Byval distance as Single)
Declare sub nSetGrassWind CDECL alias "nSetGrassWind"(Byval grass as nGrass,Byval strength as Single,Byval regularity as Single)
Declare function nGetGrassDrawCount CDECL alias "nGetGrassDrawCount"(Byval grass as nGrass) as uinteger

'/--------------------------------|
'[CLOUDS                       ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\----------------------------------------------------

Declare Function nCreateClouds cdecl alias "nAddClouds"(Byval texture As nTEXTURE,Byval lod as uinteger, Byval depth as uinteger, Byval density as uinteger) as uinteger ptr

'/--------------------------------|
'[LENS FLARE                       ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\----------------------------------------------------

Declare Function nCreateLensFlareNode cdecl alias "nAddLensFlare"(Byval texture As nTEXTURE) as uinteger ptr
Declare sub nsetLensFlareScale cdecl alias "nSetFlareScale"(Byval flare as nLensFlare,Byval source as single,Byval optics as single)

'/--------------------------------|
'[BOLT                           ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

declare function nAddBoltSceneNode cdecl alias "nAddBoltSceneNode" () As nBolt

' aset the properties of the bolt node, steadyend=0/off, steadyend=1/on
declare sub nSetBoltProperties cdecl alias "nSetBoltProperties" ( _
        byval bolt as nBolt, _
        byval sx as single, byval sy as single, byval sz as single, _
        byval ex as single, byval ey as single, byval ez as single, _
        byval updateTime as uinteger = 50, _
        byval height as uinteger = 10, _
        byval thickness as single = 5.0, _
        byval parts as uinteger = 10, _
        byval nr_bolts as uinteger = 6, _
        byval steadyend as uinteger = 1, _
        byval a as uinteger = 255,_
        byval r as uinteger = 255,_
        byval g as uinteger = 255,_
        byval b as uinteger = 255)


'/--------------------------------|
'[BEAM                           ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

' add a beam node to the scene
declare function nAddBeam cdecl alias "nAddBeamSceneNode" () As nBeam

' set the beam
declare sub nSetBeamPosition cdecl alias "nSetBeamPosition" ( byval beam as nBeam,_
                                                byval startx as single, byval starty as single, byval startz as single, _
                                                byval endx as single, byval endy as single, byval endz as single)
                                                
declare sub nSetBeamSize cdecl alias "nSetBeamSize" ( byval beam as nBeam,byval size as single )



'/--------------------------------|
'[TEXT FONT                           ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

Declare Function nLoadFont Cdecl Alias "nLoadFont" (Byval File As Zstring Ptr) As nFONT
Declare Sub nSetFont Cdecl Alias "nSetFont" (Byval Font As nFONT)
Declare Sub nDrawFontText Cdecl Alias "nDrawFontText" (Byval x As integer,Byval y As integer,Byval txt As ZString Ptr,Byval cenx As Integer = 0,Byval ceny As Integer = 0)

'nGetFontTextSize(const char* Text)


'/--------------------------------|
'[PARTICLES                       ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

'Particles
Declare Function nCreateParticle Cdecl Alias "nCreateParticle" () As nPARTICLE
Declare Sub nSetParticleEndSize Cdecl Alias "nSetParticleEndSize" (Byval Particle As nPARTICLE,Byval sx As single,Byval sy As Single)
Declare Sub nSetParticleGravity Cdecl Alias "nSetParticleGravity" (Byval Particle As nPARTICLE,Byval gx As S,Byval gy As S,Byval gz As S)

'Global emitter functions
Declare Sub nSetEmitterDirection Cdecl Alias "nSetEmitterDirection" (Byval emitter As nEMITTER,Byval dx As S,Byval dy As S,Byval dz As S)
Declare Sub nSetEmitterPPS Cdecl Alias "nSetEmitterPPS" (Byval emitter As nEMITTER,Byval minpps As I,Byval maxpps As I)
Declare Sub nSetEmitterStartColor Cdecl Alias "nSetEmitterStartColor" (Byval emitter As nEMITTER,Byval mir As I,Byval mig As I,Byval mib As I,Byval mar As I,Byval mag As I,Byval mab As I)
Declare Sub nSetEmitterStartSize Cdecl Alias "nSetEmitterStartSize" (Byval emitter As nEMITTER,Byval mix As I,Byval miy As I,Byval max As I,Byval may As I)

'Box Emitter
Declare Function nCreateBoxEmitter Cdecl Alias "nCreateBoxEmitter" (Byval Particle As nPARTICLE,Byval minv As UInteger,Byval maxv As uinteger) As nEMITTER
Declare Sub nSetBoxEmitterSize Cdecl Alias "nSetBoxEmitterSize" (Byval emitter As nEMITTER,Byval sx As single,Byval sy As single,Byval sz As Single)

'Cylinder Emitter
Declare Function nCreateCylinderEmitter Cdecl Alias "nCreateCylinderEmitter" (Byval Particle As nPARTICLE,Byval minv As UInteger,Byval maxv As UInteger) As nEMITTER
Declare Sub nSetCylinderEmitterCenter Cdecl Alias "nSetCylinderEmitterCenter" (Byval emitter As nEMITTER,Byval x As Single,Byval y As single,Byval z As single)
Declare Sub nSetCylinderEmitterRadius Cdecl Alias "nSetCylinderEmitterRadius" (Byval emitter As nEMITTER,Byval radius As single)
Declare Sub nSetCylinderEmitterLength Cdecl Alias "nSetCylinderEmitterLength" (Byval emitter As nEMITTER,Byval length As Single)

'Mesh Emitter
Declare Function nCreateMeshEmitter Cdecl Alias "nCreateMeshEmitter" (Byval Particles As nPARTICLE,Byval minv As UInteger,Byval maxv As UInteger) As nEMITTER
Declare Sub nSetMeshEmitterMesh Cdecl Alias "nSetMeshEmitterMesh" (Byval emitter As nEMITTER,Byval Mesh As nMESH)
Declare Sub nSetMeshEmitterEveryVertex Cdecl Alias "nSetMeshEmitterEveryVertex" (Byval emitter As nEMITTER,Byval EveryMeshVertex As I)

'Ring Emitter
Declare Function nCreateRingEmitter Cdecl Alias "nCreateRingEmitter" (Byval Particle As nPARTICLE,Byval Min As UI,Byval Max As UI) As nEMITTER
Declare Sub nSetRingEmitterCenter Cdecl Alias "nSetRingEmitterCenter" (Byval emitter As nEMITTER,Byval X As S,Byval Y As S,Byval Z As S)
Declare Sub nSetRingEmitterRadius Cdecl Alias "nSetRingEmitterRadius" (Byval emitter As nEMITTER,Byval Radius As S)
Declare Sub nSetRingEmitterThickness Cdecl Alias "nSetRingEmitterThickness" (Byval emitter As nEMITTER,Byval Thickness As S)

'/--------------------------------|
'[MATERIALS                       ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

'For meshes
'a mesh may have many materials on them and each material may have up to 4 texture layers, depends of the material type
Declare Sub nSetMaterialType Cdecl Alias "nSetMaterialType" (Byval entity As nENTITY,Byval num As uinteger,Byval t As MATERIAL_TYPE)
Declare Sub nSetMaterialFlag Cdecl Alias "nSetMaterialFlag" (Byval entity As nENTITY,Byval num As uinteger,Byval flag As MATERIAL_FLAG,Byval mode As integer)
Declare Sub nSetMaterialTexture Cdecl Alias "nSetMaterialTexture" (Byval entity As nENTITY,Byval num As UInteger,Byval texture As nTEXTURE,Byval index As uinteger)
Declare Sub nSetMaterialColor Cdecl Alias "nSetMaterialColor" (Byval entity As nENTITY,Byval num As UInteger,Byval red As uinteger,Byval green As uinteger,Byval blue As UInteger)
Declare Sub nSetMaterialEmissiveColor Cdecl Alias "nSetMaterialEmissiveColor" (Byval entity As nENTITY,Byval num As UInteger,Byval red As uinteger,Byval green As uinteger,Byval blue As UInteger)
Declare Sub nSetMaterialShininess Cdecl Alias "nSetMaterialShininess" (Byval entity As nENTITY,Byval num As UInteger,Byval shininess As single)
Declare Sub nSetMaterialAlpha Cdecl Alias "nSetMaterialAlpha" (Byval entity As nENTITY,Byval num As UInteger,Byval level As UI)
Declare Sub nSetMaterialTextureUV Cdecl Alias "nSetMaterialTextureUV" (Byval entity As nENTITY,Byval num As UInteger,Byval index As UI,Byval u As S,Byval v As S)
Declare Sub nSetMaterialTextureAngle Cdecl Alias "nSetMaterialTextureAngle" (Byval entity As nENTITY,Byval num As UInteger,Byval index As UI,Byval angle As S)
Declare Sub nSetMaterialTextureScale Cdecl Alias "nSetMaterialTextureScale" (Byval entity As nENTITY,Byval num As UInteger,Byval index As UI,Byval sx As S,Byval sy As S)
Declare function nGetMaterialCount Cdecl Alias "nGetMaterialCount"( Byval entity As 	nENTITY) as UInteger

'For Bodies
Declare function nCreateBodyMaterial Cdecl Alias "nCreateBodyMaterial" () As nMATERIAL
Declare Sub nSetBodyMaterial Cdecl Alias"nSetMaterialBody" (Byval Body As nBODY, Byval material as nMATERIAL)
Declare Sub nSetBodyMaterialElasticity Cdecl Alias "nSetBodyMaterialElasticity" (Byval material1 As nMATERIAL,Byval material2 As nMATERIAL,Byval elasticity As single)
Declare Sub nSetBodyMaterialFriction Cdecl Alias "nSetBodyMaterialFriction" (Byval material1 As nMATERIAL,Byval material2 As nMATERIAL,Byval sfriction As single,Byval kfriction As single)
Declare Sub nSetBodyMaterialSoftness Cdecl Alias "nSetBodyMaterialSoftness" (Byval material1 As nMATERIAL,Byval material2 As nMATERIAL,Byval softness As single)
Declare Sub nSetBodyMaterialCollidable Cdecl Alias "nSetBodyMaterialCollidable" (Byval material1 As nMATERIAL,Byval material2 As nMATERIAL,Byval mode As integer)

'/--------------------------------|
'[CAMERA                          ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

'Fader
Declare Sub nSetFadeIn Cdecl Alias "nSetFadeIn" (Byval t As UInteger)
Declare Sub nSetFadeOut Cdecl Alias "nSetFadeOut" (Byval t As uInteger)
Declare Sub nSetFaderColor Cdecl Alias "nSetFaderColor" (ByVal r As uinteger,Byval g As uinteger,Byval b As UInteger)
Declare Function nGetFadeIsReady Cdecl Alias "nGetFadeIsReady"( ) As integer 

'Camera
Declare Function nCreateCamera Cdecl Alias "nCreateCamera" () As nCAMERA
Declare Function nCreateCameraFPS Cdecl Alias "nCreateCameraFPS" (Byval rots As S,Byval movs As S) As nCAMERA
Declare Function nCreateCameraMaya Cdecl Alias "nCreateCameraMaya" (Byval rots As S,Byval zoos As S,Byval movs As S) As nCAMERA
Declare Function nCreateCameraIsometric Cdecl Alias "nCreateCameraIsometric" (Byval Width As Single,Byval height As Single,Byval near As Single,Byval far As Single) As nCAMERA
Declare Sub nEnableControlCamera Cdecl Alias "nEnableControlCamera" (Byval camera As nCAMERA)
Declare Sub nDisableControlCamera Cdecl Alias "nDisableControlCamera" (Byval camera As nCAMERA)
Declare Sub nSetCameraFOV Cdecl Alias "nSetCameraFOV" (Byval camera As nCAMERA,Byval ratio As S)
Declare Sub nSetCameraRange Cdecl Alias "nSetCameraRange" (Byval camera As nCAMERA,Byval near As S,Byval far As S)
Declare Sub nSetCameraTarget Cdecl Alias "nSetCameraTarget" (Byval camera As nCAMERA,Byval tx As S,Byval ty As S,Byval tz As S)
Declare Sub nSetActiveCamera Cdecl Alias "nSetActiveCamera" (Byval camera As nCAMERA)
Declare Sub nSetCameraViewPort Cdecl Alias "nSetCameraViewPort" (Byval x1 As I,Byval y1 As I,Byval x2 As I,Byval y2 As I)
Declare Sub nSetCameraAspectRatio Cdecl Alias "nSetCameraAspectRatio" (Byval camera As nCAMERA,Byval aspect As S)
'return xtarget of the camera
Declare Function nGetCameraTargetX Cdecl Alias "nGetCameraTargetX" (Byval camera As nCAMERA) As single
Declare Function nGetCameraTargetY Cdecl Alias "nGetCameraTargetY" (Byval camera As nCAMERA) As Single
Declare Function nGetCameraTargetZ Cdecl Alias "nGetCameraTargetZ" (Byval camera As nCAMERA) As single

'returns in targetX,targetY,targetZ x,y,z of the camera target
Declare Sub nGetCameraTargetPos Cdecl Alias "nGetCameraTargetPos" (Byval camera As nCAMERA,_
                                                        byref targetX as single,_
                                                        byref targetY as single,_
                                                        byref targetZ as single)
'returns in dx,dy,dz the direction of the camera                                                        
Declare Sub nGetCameraDir Cdecl Alias "nGetCameraDir" (Byval camera As nCAMERA,_
                                                        byref dx as single,_
                                                        byref dy as single,_
                                                        byref dz as single)

Declare Function nGetViewPortWidth Cdecl Alias "nGetViewPortWidth" () As I
Declare Function nGetViewPortHeight Cdecl Alias "nGetViewPortHeight" () As I

'/--------------------------------|
'[LIGHT                           ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

Declare Function nCreateLight Cdecl Alias "nCreateLight" (Byval mode As LIGHT_TYPE) As nLIGHT
Declare Sub nSetLightRadius Cdecl Alias "nSetLightRadius" (Byval light As nLIGHT,Byval radius As Single)
Declare Sub nSetLightCastShadow Cdecl Alias "nSetLightCastShadow" (Byval light As nLIGHT)
Declare Sub nSetLightColor Cdecl Alias "nSetLightColor" (Byval light As nLIGHT,Byval red As uinteger,Byval green As uinteger,Byval blue As UInteger)
Declare Sub nSetLightFalloff Cdecl Alias "nSetLightFalloff" (Byval light As nLIGHT,Byval falloff As S)
Declare Sub nSetLightConeAngles Cdecl Alias "nSetLightConeAngles" (Byval light As nLIGHT,Byval Inner As Single,Byval Outer As single)
Declare Sub nSetLightAttenuation Cdecl Alias "nSetLightAttenuation" (Byval light As nLIGHT,Byval c As single,Byval l As single,Byval q As single)
Declare Sub nSetLightDirection Cdecl Alias "nSetLightDirection" (Byval light As nLIGHT,Byval x As Single,Byval y As Single,Byval z As Single)

'/--------------------------------|
'[MESH                            ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

Declare Function nCreateMeshNull Cdecl Alias "nCreateMeshNull" () As nMESH
Declare Function nCreateMeshCube Cdecl Alias "nCreateMeshCube" () As nMESH
Declare Function nCreateMeshSphere Cdecl Alias "nCreateMeshSphere" (Byval polycount As uinteger) As nMESH
Declare Function nCreateMeshCylinder Cdecl Alias "nCreateMeshCylinder" (Byval polycount As UInteger) As nMESH
Declare Function nCreateMeshCone Cdecl Alias "nCreateMeshCone" (Byval polycount As UInteger) As nMESH
Declare Function nCreateMeshPlane Cdecl Alias "nCreateMeshPlane" (Byval size As Single,Byval tileCount As uinteger) As nMESH
Declare Function nCreateMeshWater Cdecl Alias "nCreateMeshWater" (Byval height As single,Byval speed As single,Byval length As single) As nENTITY

'Declare Function nAddCubeNode Cdecl Alias "nAddCubeNode" (byval size as single) As uinteger ptr
'Declare Function nAddSphereNode Cdecl Alias "nAddSphereNode" (byval radius as single,byval polyCount as integer) As uinteger ptr

Declare Function nLoadMesh Cdecl Alias "nLoadMesh" (Byval file As Zstring Ptr,Byval toTangents As VERTEX_TYPE = VT_TCOORS) As nBSPNode
Declare Sub nSetMeshCastShadow Cdecl Alias "nSetMeshCastShadow" (Byval mesh As nMESH)
Declare Sub nDrawOutlineMesh Cdecl Alias "nDrawOutlineMesh" (Byval mesh As nMESH,Byval w As single,Byval r As uinteger,Byval g As uinteger,Byval b As uinteger)
Declare Sub nSetMeshScale Cdecl Alias "nSetMeshScale" (Byval mesh As nMESH,Byval scax As single,Byval scay As single,Byval scaz As Single)
Declare Sub nAnimateMesh Cdecl Alias "nAnimateMesh" (Byval mesh As nMESH,Byval looped As I,Byval speed As Single,Byval b As integer,Byval e As integer,Byval t As single)
Declare Function nGetMeshesCollide Cdecl Alias "nGetMeshesCollide" (Byval mesh1 As nMESH,Byval mesh2 As nMESH) As Integer
Declare Function nGetVertexCount Cdecl Alias "nGetVertexCount" (Byval mesh As nMESH) As UInteger
Declare Function nGetCurrentFrame Cdecl Alias "nGetCurrentFrame" (Byval mesh As nMESH) As integer
Declare Function nGetStartFrame Cdecl Alias "nGetStartFrame" (Byval mesh As nMESH) As integer
Declare Function nGetEndFrame Cdecl Alias "nGetEndFrame" (Byval mesh As nMESH) As integer




Declare Function nGetChildrenCount Cdecl Alias "nGetChildrenCount" (Byval mesh As nMESH) As Uinteger
Declare Function nGetChildByName Cdecl Alias "nGetChildByName" (Byval mesh As nMESH,Byval nameChild As Zstring Ptr) As nCHILD
Declare Function nGetChildByIndex Cdecl Alias "nGetChildByIndex" (Byval mesh As nMESH,Byval indexChild As uinteger) As nCHILD
Declare Function nGetChildName Cdecl Alias "nGetChildName" (Byval child As nCHILD) As Zstring Ptr
Declare Sub nSetChildMode Cdecl Alias "nSetChildMode" (Byval mesh As nMESH,ByVal mode As integer)






'/--------------------------------|
'[TERRAIN                         ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

declare function nLoadTerrain CDECL alias "nLoadTerrain" ( _
        byval path as zstring ptr, _
        byval smoothing as integer = 0, _
        byval maxLOD as integer = 4, _
        byval patchSize as IRR_TERRAIN_PATCH_SIZE = 17) as nterrain

'SCALE THE TEXTURES OF THE TERRAIN,1ST TEXTURE(COLORMAP TEXTURE),2ND TEXTURE(DETAIL TEXTURE)
Declare Sub nSetScaleTerrainTexture Cdecl Alias "nSetScaleTerrainTexture" (Byval terrain As nENTITY,Byval sx As S,Byval sy As S)
'GET THE HEIGHT OF TERRAIN AT X,Z CORDINATE
Declare Function nGetTerrainHeight Cdecl Alias "nGetTerrainHeight" (Byval terrain As nENTITY,Byval x As S,Byval z As S) As S


'terrain selector, no set with terrain
Declare Function nGetTerrainSelector Cdecl Alias "nGetTerrainSelector" (Byval terrain As nTerrain) As nTriSelector

Declare Function nCreateArrow Cdecl Alias "nCreateArrow" () as nArrow

Declare Function nGetXPoSArrow Cdecl Alias "nGetXPoSArrow"(byval terrain as nTerrain,_
                                               byval arrow as narrow,_
                                               byval selector as nTriSelector,_ 
                                               byval camera as nCamera,_ 
                                               byval scaleXZ as integer,_ 
                                               byval scaleY as integer,_ 
                                               byval terrSize as integer) as integer
Declare Function nGetZPoSArrow Cdecl Alias "nGetZPoSArrow"(byval terrain as nTerrain,_
                                               byval arrow as narrow,_
                                               byval selector as nTriSelector,_ 
                                               byval camera as nCamera,_ 
                                               byval scaleXZ as integer,_ 
                                               byval scaleY as integer,_ 
                                               byval terrSize as integer) as integer 
 
Declare Function nGetTerrainVerticesEntry Cdecl Alias "nGetTerrainVerticesEntry"(byval terrain as nTerrain) as uinteger ptr 
                                               
Declare sub nSetHeightTerrainVertex Cdecl Alias "nSetHeightTerrainVertex"(byval terrain as nTerrain,_
                                               byval xpos as integer,_
                                               byval zpos as integer,_ 
                                               byval stp as single,_ 
                                               byval up as integer,_ 
                                               byval scaleXZ as integer,_
                                               byval scaleY as integer,_ 
                                               byval terrSize as integer)                                                

Declare sub nSetHeightTerrainVerticesGroup Cdecl Alias "nSetHeightTerrainVerticesGroup"(byval terrain as nTerrain,_
                                               byval n as integer,_
                                               byval xpos as integer,_
                                               byval zpos as integer,_ 
                                               byval stp as single,_ 
                                               byval up as integer,_ 
                                               byval scaleXZ as integer,_
                                               byval scaleY as integer,_ 
                                               byval terrSize as integer,_
                                               byval shape as integer)
                                               
Declare sub nSetHeightTerrainVerticesGroup2 Cdecl Alias "nSetHeightTerrainVerticesGroup2"(byval terrain as nTerrain,_
                                               byval n as integer,_
                                               byval xpos as integer,_
                                               byval zpos as integer,_ 
                                               byval stp as single,_ 
                                               byval up as integer,_ 
                                               byval scaleXZ as integer,_
                                               byval scaleY as integer,_ 
                                               byval terrSize as integer,_
                                               byval shape as integer,_
                                               byval verticesentry as uinteger ptr)
                                               
Declare sub nSaveTerrainHM Cdecl Alias "nSaveTerrainHM"(byval terrain as nTerrain,_
                                                        byval terrSize as integer)

'/--------------------------------|
'[MISC                            ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

'Sky
Declare Function nCreateSkyDome Cdecl Alias "nCreateSkyDome" (Byval texture As nTEXTURE,Byval radius as Single) As nENTITY
Declare Function nCreateSkyBox Cdecl Alias "nCreateSkyBox" (Byval tp As nTEXTURE,Byval bt As nTEXTURE,Byval lf As nTEXTURE,Byval rg As nTEXTURE,Byval ft As nTEXTURE,Byval bk As nTEXTURE) As nENTITY

'/--------------------------------|
'[MATHS                           ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

Declare Function nGetWrapValue Cdecl Alias "nGetWrapValue" (Byval newvalue As S,Byval oldvalue As S,Byval increment As S) As S
Declare Function nGetCurveValue Cdecl Alias "nGetCurveValue" (Byval newvalue As S,Byval oldvalue As S,Byval increment As S) As S
Declare Function nGetDistance2D Cdecl Alias "nGetDistance2D" (Byval x1 As S,Byval y1 As S,Byval x2 As S,Byval y2 As S) As S
Declare Function nGetDistance3D Cdecl Alias "nGetDistance3D" (Byval x1 As S,Byval y1 As S,Byval z1 As S,Byval x2 As S,Byval y2 As S,Byval z2 As S) As S
Declare Function nGetMin Cdecl Alias "nGetMin" (Byval value1 As S,Byval value2 As S) As S
Declare Function nGetMax Cdecl Alias "nGetMax" (Byval value1 As S,Byval value2 As S) As S
Declare Function nGetRand Cdecl Alias "nGetRand" (Byval value1 As I,Byval value2 As I) As I


'nGetClampValue(float value,float low,float high)

'/--------------------------------|
'[TEXTURE                         ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

Declare Function nLoadTexture Cdecl Alias "nLoadTexture" (Byval filename As Zstring Ptr) As nTEXTURE
Declare Function nCreateRTT Cdecl Alias "nCreateRTT" (Byval sx As I,Byval sy As I) As nTEXTURE
Declare Sub nSetRenderTarget Cdecl Alias "nSetRenderTarget" (Byval texture As nTEXTURE)
Declare Sub nSetColorKeyTexture Cdecl Alias "nSetColorKeyTexture" (Byval texture As nTEXTURE,Byval red As UI,Byval green As UI,Byval blue As UI)
Declare Function nFindTexture Cdecl Alias "nFindTexture" (Byval n As Zstring Ptr) As nTEXTURE
Declare Function nGetTextureWidth Cdecl Alias "nGetTextureWidth" (Byval texture As nTEXTURE) As I
Declare Function nGetTextureHeight Cdecl Alias "nGetTextureHeight" (Byval texture As nTEXTURE) As I
Declare Function nLockTexture Cdecl Alias "nLockTexture" (Byval texture As nTEXTURE) As Uinteger Ptr
Declare Sub nUnLockTexture Cdecl Alias "nUnLockTexture" (Byval texture As nTEXTURE)
Declare Sub nUnLockTextureNoMipMap Cdecl Alias "nUnLockTextureNoMipMap" (Byval texture As nTEXTURE)
' create a blank texture
declare function nCreateTexture CDECL alias "nCreateTexture" ( byval path as zstring ptr, byval x as integer, byval y as integer, byval format as IRR_COLOR_FORMAT ) as ntexture

' remove a texture freeing its resources
declare sub nRemoveTexture CDECL alias "nRemoveTexture" ( byval texture as ntexture )

' create a normal map from a grayscale heightmap texture
declare sub nMakeNormalMapTexture CDECL alias "nMakeNormalMapTexture" ( byval texture as ntexture, byval amplitude as single)

' blend the source texture into the destination texture to create a single texture
declare function nBlendTextures CDECL alias "nBlendTextures" ( byval destination_texture as ntexture, byval source_texture as ntexture, byval x_offset as integer, byval y_offset as integer, byval operation as integer ) as integer
' blend the source texture into the destination texture using a third alphamap with rgb channels to create a single texture
declare function nAlphaBlendTextures CDECL alias "nAlphaBlendTextures" ( byval destination_texture as ntexture, byval source_texture as ntexture, byval alpha_texture as ntexture,BYVAL alphacolorchannel as ALPHA_CHANNEL_COLOR) as integer
'create a texture in videoRAM from an image in RAM
declare function nCreateTextureFromImage CDECL alias  "nCreateTextureFromImage"(byval image as uinteger ptr)as uinteger ptr
'create image from texture or part of texture
declare function nCreateImageFromTexture CDECL alias "nCreateImageFromTexture"(byval texture as ntexture,_
                                                                            byval originX as integer,_
                                                                            byval originY as integer,_
                                                                            byval w as integer,_
                                                                            byval h as integer)as nimage
'paint the destination(base) texture with a source texture using an alpha value at x,y position
declare function nPaintTileTextureWithAlpha CDECL alias "nPaintTileTextureWithAlpha" ( byval destination_texture as nTexture, byval source_texture as nTexture, byval xpos as integer,BYVAL ypos as integer,byval radius as integer,byval alpha as integer) as integer
declare function nPaintTileTextureWithAlpha2 CDECL alias "nPaintTileTextureWithAlpha2" ( byval destination_texture as nTexture, byval source_texture as nTexture, byval xpos as integer,BYVAL ypos as integer,byval radius as integer,byval alpha as integer) as integer
declare function nPaintTileTextureWithAlpha3 CDECL alias "nPaintTileTextureWithAlpha3" ( byval destination_texture as nTexture, byval source_texture as nTexture,_
                                                                                        byval pixeldeststart as uinteger ptr,_
                                                                                        byval pixelsrcstart as uinteger ptr,_
                                                                                        byval xpos as integer,BYVAL ypos as integer,byval radius as integer,byval alpha as integer) as integer





'/--------------------------------|
'[SOUND                           ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

Declare Function nLoadSound Cdecl Alias "nLoadSound" (Byval File As zstring ptr) As nSOUND
Declare Sub nSetSoundType Cdecl Alias "nSetSoundType" (Byval sound As nSOUND,Byval mode As I)
Declare Sub nSetSoundVolume Cdecl Alias "nSetSoundVolume" (Byval sound As nSOUND,Byval volume as single)
Declare Sub nSetSoundPitch Cdecl Alias "nSetSoundPitch" (Byval sound As nSOUND,Byval pitch as single)
Declare Sub nPlaySound Cdecl Alias "nPlaySound" (Byval sound As nSOUND)
Declare Sub nStopSound Cdecl Alias "nStopSound" (Byval sound As nSOUND)
Declare Sub nPauseSound Cdecl Alias "nPauseSound" (Byval sound As nSOUND)
Declare Sub nLoopSound Cdecl Alias "nLoopSound" (Byval sound As nSOUND)
Declare Sub nSetListenerPosition Cdecl Alias "nSetListenerPosition" (Byval x as Single,_
                                                                Byval y as Single, Byval z as Single)
Declare Sub nSetSoundPosition Cdecl Alias "nSetSoundPosition" (Byval sound As nSOUND, Byval x as Single,_
                                                                Byval y as Single, Byval z as Single)
Declare Sub nSetSoundReferenceDistance Cdecl Alias "nSetSoundReferenceDistance" (Byval sound As nSOUND,Byval value As S)
Declare Sub nSetSoundRollOff Cdecl Alias "nSetSoundRollOff" (Byval sound As nSOUND,Byval value As S)

'/--------------------------------|
'[SPRITE                          ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

Declare Function nLoadBillboard Cdecl Alias "nLoadBillboard" (Byval fileName As Zstring Ptr) As nBILLBOARD
Declare Sub nSetBillboardScale Cdecl Alias "nSetBillboardScale" (Byval billbd As nBILLBOARD,Byval sx As Single,Byval sy As Single)
Declare Sub nSetBillboardColor Cdecl Alias "nSetBillboardColor" (Byval billbd As nBILLBOARD,Byval red As Uinteger,Byval green As Uinteger,Byval blue As Uinteger)

'/--------------------------------|
'[SHADERS                         ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/
'selector = 0, GLSL 1.1
'selector = 1, HLSL 2.0

Declare Function nLoadShader Cdecl Alias "nLoadShader" (Byval VFileName As Zstring Ptr,Byval PFileName As Zstring Ptr,byval selector as integer) As nSHADER
Declare Sub nApplyShadersEntity Cdecl Alias "nApplyShadersEntity" (Byval Shader As nSHADER,Byval Entity As nENTITY)
Declare Sub nApplyShadersMaterial Cdecl Alias "nApplyShadersMaterial" (Byval Shader As nSHADER,Byval Entity As nENTITY,Byval Num As Uinteger)
Declare Sub nSetVertexShaderConstant Cdecl Alias "nSetVertexShaderConstant" (Byval Shader As nSHADER,Byval FName As Zstring Ptr,Byval CData As Single Ptr, Byval Count As Integer)
Declare Sub nSetPixelShaderConstant Cdecl Alias "nSetPixelShaderConstant" (Byval Shader As nSHADER,Byval FName As Zstring Ptr,Byval CData As Single Ptr, Byval Count As Integer)

'matrixtype
'0 = "matWorldViewProjection"
'1 = "matWorldView"
'2 = "matProj"
'3 = "matView"
'4 = "matWorld"
'5 = "matInvWorld"
Declare Sub nSetMatrixToVertexShaderConstant Cdecl Alias "nSetMatrixToVertexShaderConstant" (Byval Shader As nSHADER,Byval matrixtype As Integer)
'Declare Sub ApplyShadersTerrain Cdecl Alias "ApplyShadersTerrain" (Byval Shader As nSHADER,Byval terrain As uinteger ptr)



'/--------------------------------|
'[CONTROL                         ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

Declare Sub nDeleteEntity Cdecl Alias "nDeleteEntity" (Byval Entity As nENTITY)
Declare Sub nShowEntity Cdecl Alias "nShowEntity" (Byval Entity As nENTITY)
Declare Sub nHideEntity Cdecl Alias "nHideEntity" (Byval Entity As nENTITY)
Declare Sub nSetNameEntity Cdecl Alias "nSetNameEntity" (Byval Entity As nENTITY,Byval namemesh As zstring ptr)
Declare Sub nSetEntityParent Cdecl Alias "nSetEntityParent" (Byval entity As nENTITY,Byval Parent As nENTITY)
Declare Sub nSetEntityTexture Cdecl Alias "nSetEntityTexture" (Byval Entity As nENTITY,Byval Texture As nTEXTURE,Byval Index As Uinteger)
Declare Sub nSetEntityColor Cdecl Alias "nSetEntityColor" (Byval Entity As nENTITY,Byval Red As Uinteger,Byval Green As Uinteger,Byval Blue As Uinteger)
Declare Sub nSetEntitySpecularColor Cdecl Alias "nSetEntitySpecularColor" (Byval Entity As nENTITY,Byval Red As Uinteger,Byval Green As Uinteger,Byval Blue As Uinteger)
Declare Sub nSetEntityShininess Cdecl Alias "nSetEntityShininess" (Byval Entity As nENTITY,Byval shininess As Single)
Declare Sub nSetEntityAlpha Cdecl Alias "nSetEntityAlpha" (Byval Entity As nENTITY,Byval level As Uinteger)
Declare Sub nSetEntityType Cdecl Alias "nSetEntityType" (Byval Entity As nENTITY,Byval t As MATERIAL_TYPE)
Declare Sub nSetEntityFlag Cdecl Alias "nSetEntityFlag" (Byval Entity As nENTITY,Byval Flag As MATERIAL_FLAG,Byval Mode As Integer)
Declare Function nCloneEntity Cdecl Alias "nCloneEntity" (Byval Entity As nENTITY) As nENTITY

'/--------------------------------|
'[MOVEMENT                        ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

Declare Sub nSetEntityPosition Cdecl Alias "nSetEntityPosition" (Byval entity As nENTITY,Byval x As Single,Byval y As Single,Byval z As Single)
Declare Sub nSetEntityAbsoluteRotation Cdecl Alias "nRotateEntity" (Byval entity As nENTITY,Byval x As Single,Byval y As Single,Byval z As Single)
Declare Sub nSetEntityLocalRotation Cdecl Alias "nTurnEntity" (Byval entity As nENTITY,Byval x As Single,Byval y As Single,Byval z As Single)
Declare Sub nSetEntityLocalRotation2 Cdecl Alias "nTurnEntity2" (Byval entity As nENTITY,Byval x As Single,Byval y As Single,Byval z As Single)
'Declare Sub ResetLocalAxis Cdecl Alias "ResetLocalAxis" (Byval entity As nENTITY)
Declare Sub nSetEntityRelMove Cdecl Alias "nMoveEntity" (Byval entity As nENTITY,Byval x As Single,Byval y As Single,Byval z As Single)
Declare Sub nSetEntityToPoint Cdecl Alias "nPointEntity" (Byval entity1 As nENTITY,Byval entity2 As nENTITY)
Declare Sub nSetEntityPointToTarget Cdecl Alias "nPointToTarget" (Byval entity As nENTITY,byval xtarget as single,_
                                                        byval ytarget as single,_
                                                        byval ztarget as single)
Declare function nGetHorAngle Cdecl Alias "nGetHorAngle" (Byval entity As nENTITY,byval xtarget as single,_
                                                        byval ytarget as single,_
                                                        byval ztarget as single) as single
                                                        
'/--------------------------------|
'[STATE                           ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

Declare Function nGetEntityX Cdecl Alias "nGetEntityX" (Byval entity As nENTITY) As Single
Declare Function nGetEntityY Cdecl Alias "nGetEntityY" (Byval entity As nENTITY) As Single
Declare Function nGetEntityZ Cdecl Alias "nGetEntityZ" (Byval entity As nENTITY) As Single
Declare Function nGetEntityPitch Cdecl Alias "nGetEntityPitch" (Byval entity As nENTITY) As Single
Declare Function nGetEntityYaw Cdecl Alias "nGetEntityYaw" (Byval entity As nENTITY) As Single
Declare Function nGetEntityRoll Cdecl Alias "nGetEntityRoll" (Byval entity As nENTITY) As Single
Declare Function nGetEntityName Cdecl Alias "nGetEntityName" (Byval entity As nENTITY) As zstring ptr

Declare Function nGetLinePick Cdecl Alias " nGetLinePick "(Byval X1 As single, Byval Y1 As single,Byval Z1 As single,_
    Byval X2 As single,Byval Y2 As single,Byval Z2 As single) As nENTITY
Declare Function nGetEntitiesDistance Cdecl Alias "nGetEntitiesDistance"(Byval entity1 As nENTITY,Byval entity2 As nENTITY) As Single 
Declare Function nGetDistance Cdecl Alias "nGetDistance"(byval x1 as single,_
                                                    byval y1 as single,_
                                                    byval z1 as single,_
                                                    byval x2 as single,_
                                                    byval y2 as single,_
                                                    byval z2 as single) As Single 
                                                    
Declare Function nGetEntitiesCollide Cdecl Alias "nGetEntitiesCollide"(Byval entity1 As nENTITY,Byval entity2 As nENTITY) As integer                                                    
Declare Sub nGetDirection Cdecl Alias "nGetDirection"(byval xstart as single,_
                                                    byval ystart as single,_
                                                    byval zstart as single,_
                                                    byval xtarget as single,_
                                                    byval ytarget as single,_
                                                    byval ztarget as single,_
                                                    byref dx as single,_
                                                    byref dy as single,_
                                                    byref dz as single)




'/--------------------------------|
'[PHYSIC                          ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

'WORLD
Declare Sub nSetPhysicQuality Cdecl Alias "nSetPhysicQuality" (Byval mode As PHYSIC_QUALITY)
Declare Sub nSetWorldGravity Cdecl Alias "nSetWorldGravity" (Byval GX As S,Byval GY As S,Byval GZ As S)
Declare Sub nSetWorldSize Cdecl Alias "nSetWorldSize" (Byval X As S,Byval Y As S,Byval state As S)
Declare Sub nWorldMousePick Cdecl Alias "nWorldMousePick" (Byval X As I,Byval Y As I,Byval Z As I)


'Body
Declare Function nCreateBodyNull Cdecl Alias "nCreateBodyNull" () As nBODY
Declare Function nCreateBodyCube Cdecl Alias "nCreateBodyCube" (Byval SX As Single,Byval SY As Single,Byval SZ As Single,Byval Mass As single) As nBODY
Declare Function nCreateBodySphere Cdecl Alias "nCreateBodySphere" (Byval SX As Single,Byval SY As Single,Byval SZ As Single,Byval Mass As Single) As nBODY
Declare Function nCreateBodyCylinder Cdecl Alias "nCreateBodyCylinder" (Byval Radius As Single,Byval Height As Single,Byval Mass As Single,ByVal Offset As Integer = 1) As nBODY
Declare Function nCreateBodyCone Cdecl Alias "nCreateBodyCone" (Byval Radius As single,Byval Height As Single,Byval Mass As Single,ByVal Offset As Integer = 1) As nBODY
Declare Function nCreateBodyCapsule Cdecl Alias "nCreateBodyCapsule" (Byval Radius As single,Byval Height As single,Byval Mass As Single,ByVal Offset As Integer = 1) As nBODY

Declare Function nCreateBodyHull Cdecl Alias "nCreateBodyHull" (Byval Mesh As nMESH,Byval mass As Single) As nBODY
Declare Function nCreateBodyTree Cdecl Alias "nCreateBodyTree" (Byval Mesh As nMESH,Byval mass As Single) As nBODY
Declare Function nCreateBodyTreeBSP Cdecl Alias "nCreateBodyTreeBSP"(Byval Mesh As Uinteger ptr,Byval Node As Uinteger ptr) As nBODY
Declare Function nCreateBodyTerrain Cdecl Alias "nCreateBodyTerrain" (Byval terrain As nTERRAIN,Byval LOD As Integer) As nBODY
Declare Function nCreateBodyWater Cdecl Alias "nCreateBodyWater" (Byval SX As Single,Byval SY As Single,Byval SZ As Single,Byval fluidDensity As Single,Byval linearViscosity As Single,Byval angularViscosity As Single) As nBODY

Declare Sub nSetAngularVelocity Cdecl Alias "nSetAngularVelocity" (Byval Body As nBODY,Byval VX As S,Byval VY As S,Byval VZ As S)
Declare Sub nLinearVelocity Cdecl Alias "nLinearVelocity" (Byval Body As nBODY,Byval VX As S,Byval VY As S,Byval VZ As S)
Declare Sub nSetLinearVelocity Cdecl Alias "nSetLinearVelocity" (Byval Body As nBODY,_
                                                                Byval xpos as single,_
                                                                Byval ypos As single,_
                                                                Byval zpos As single,_
                                                                byval xtarget as single,_
                                                                byval ytarget as single,_
                                                                byval ztarget as single,_
                                                                byval speed as single)




Declare Sub nSetLinearDamping Cdecl Alias "nSetLinearDamping" (Byval Body As nBODY,Byval Damping As S)
Declare Sub nSetAngularDamping Cdecl Alias "nSetAngularDamping" (Byval Body As nBODY,Byval ax As S,Byval ay As S,Byval az As S)
Declare Sub nAddImpulse Cdecl Alias "nAddImpulse" (Byval Body As nBODY,Byval PX As S,Byval PY As S,Byval PZ As S,Byval VX As S,Byval VY As S,Byval VZ As S)

Declare Function nGetBodiesCollide Cdecl Alias "nGetBodiesCollide" (Byval body1 As nBODY,Byval body2 As nBODY) As Integer


Declare Function nGetBodyCollX Cdecl Alias "nGetBodyCollX" (Byval body1 As nBODY,Byval body2 As nBODY) As Single
Declare Function nGetBodyCollY Cdecl Alias "nGetBodyCollY" (Byval body1 As nBODY,Byval body2 As nBODY) As Single
Declare Function nGetBodyCollZ Cdecl Alias "nGetBodyCollZ" (Byval body1 As nBODY,Byval body2 As nBODY) As Single

Declare Function nGetBodyCollNX Cdecl Alias "nGetBodyCollNX" (Byval body1 As nBODY,Byval body2 As nBODY) As Single
Declare Function nGetBodyCollNY Cdecl Alias "nGetBodyCollNY" (Byval body1 As nBODY,Byval body2 As nBODY) As Single
Declare Function nGetBodyCollNZ Cdecl Alias "nGetBodyCollNZ" (Byval body1 As nBODY,Byval body2 As nBODY) As Single

Declare Sub nDrawBody Cdecl Alias "nDrawBody" (Byval body As nBODY)
Declare Sub nSetBodyCenterOfMass Cdecl Alias "nSetBodyCenterOfMass" (Byval body As nBODY,Byval x as single,Byval y as single,Byval z as single)
Declare Sub nRemoveBody Cdecl Alias "nRemoveBody" (Byval body As nBODY)
Declare Sub nSetBodyMass Cdecl Alias "nSetBodyMass" (Byval body As nBODY,byval mass as single)
'Joint
Declare Function nCreateJointBall Cdecl Alias "nCreateJointBall" (Byval px As Single,Byval py As Single,Byval pz As Single,_
                                                                Byval vectx As Single,Byval vecty As Single,Byval vectz As Single,_
                                                                Byval body1 As nBODY,Byval body2 As nBODY) As nJOINT
Declare Function nCreateJointHinge Cdecl Alias "nCreateJointHinge" (Byval posx As Single,Byval posy As Single,Byval posz As Single,_
                                                                    Byval vectx As Single,Byval vecty As Single,Byval vectz As Single,_
                                                                    Byval body1 As nBODY,Byval body2 As nBODY) As nJOINT
Declare Function nCreateJointSlider Cdecl Alias "nCreateJointSlider" (Byval px As Single,Byval py As Single,Byval pz As Single,_
                                                                    Byval vectx As Single,Byval vecty As Single,Byval vectz As Single,_
                                                                    Byval body1 As nBODY,Byval body2 As nBODY) As nJOINT
Declare Function nCreateJointUpVector Cdecl Alias "nCreateJointUpVector" (Byval px As Single,Byval py As Single,Byval pz As Single,Byval body1 As nBODY) As nJOINT
Declare Function nCreateJointCorkscrew Cdecl Alias "nCreateJointCorkscrew" (Byval px As Single,Byval py As Single,Byval pz As Single,_
                                                                            Byval vectx As Single,Byval vecty As Single,Byval vectz As Single,_
                                                                            Byval body1 As nBODY,Byval body2 As nBODY) As nJOINT
Declare Function nCreateJointGear Cdecl Alias "nCreateJointGear" (Byval gearRatio as single,Byval childX As Single,Byval childY As Single,Byval childZ As Single,_
                                                                            Byval parentX As Single,Byval parentY As Single,Byval parentZ As Single,_
                                                                            Byval bodyChild As nBODY,Byval bodyParent As nBODY) As nJOINT

Declare Function nCreateJointWormGear Cdecl Alias "nCreateJointWormGear" (Byval gearRatio as single,Byval rotdX As Single,Byval rotdY As Single,Byval rotdZ As Single,_
                                                                            Byval lineardX As Single,Byval lineardY As Single,Byval lineardZ As Single,_
                                                                            Byval rotBody As nBODY,Byval linearBody As nBODY) As nJOINT

Declare Sub nRemoveJoint Cdecl Alias "nDeleteJoint" (Byval joint As nJoint)



'Declare Sub setJointStiffness Cdecl Alias "nsetJointStiffness" (Byval joint As nJOINT,Byval stiffness As single)
Declare Sub nSetJointCollisionState Cdecl Alias "nSetJointCollisionState" (Byval joint As nJOINT,Byval state As Integer)
Declare Sub nSetBallLimits Cdecl Alias "nSetBallLimits" (Byval joint As nJOINT,Byval maxconeangle As Single,Byval mintwistangle As Single,Byval maxtwistangle As Single)
Declare Sub nSetHingeLimits Cdecl Alias "nSetHingeLimits" (Byval joint As nJOINT,Byval minAngle As Single,Byval maxAngle As Single)
Declare Sub nSetSliderLimits Cdecl Alias "nSetSliderLimits" (Byval joint As nJOINT,Byval minAngle As Single,Byval maxAngle As Single)
Declare Sub nSetCorkScrewLinearLimits Cdecl Alias "nSetCorkScrewLinearLimits" (Byval joint As nJOINT,Byval minDist As Single,Byval maxDist As Single)
Declare Sub nSetCorkScrewAngularLimits Cdecl Alias "nSetCorkScrewAngularLimits" (Byval joint As nJOINT,Byval minDist As Single,Byval maxDist As Single)

'Vehicle
Declare Function nCreateVehicle Cdecl Alias "nCreateVehicle" (Byval x As Single,Byval y As Single,Byval z As Single,Byval body1 As nBODY) As nJOINT
Declare function nGetVehicleSpeed Cdecl Alias "nGetVehicleSpeed" (Byval joint As nJOINT) As single
Declare sub nAddTireVehicle Cdecl Alias "nAddTireVehicle" (Byval joint As nJOINT,ByVal ud As nENTITY,Byval x As Single,Byval y As Single,Byval z As Single,Byval mass As Single,Byval r As Single,Byval w As Single,Byval f As Single,Byval sl As Single,Byval sc As Single,Byval sd As Single)
Declare Sub nApplyBrakeVehicle Cdecl Alias "nApplyBrakeVehicle" (Byval joint As nJOINT,Byval wheel As integer,Byval brake As Single)
Declare Sub nApplySteeringVehicle Cdecl Alias "nApplySteeringVehicle" (Byval joint As nJOINT,Byval indwheel As integer,Byval vrate As Single)
Declare Sub nApplySteeringJoystickVehicle Cdecl Alias "nApplySteeringJoystickVehicle" (Byval joint As nJOINT,Byval indwheel As integer,Byval vrate As Single,Byval maxangle as Single)
Declare Sub nApplyTorqueVehicle Cdecl Alias "nApplyTorqueVehicle" (Byval joint As nJOINT,Byval wheel As integer,Byval torque As Single)

'/--------------------------------|
'[TIME                            ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

Declare Function nCreateTimer Cdecl Alias "CreateTimer" () As ntimer
Declare sub nTimerStart Cdecl Alias "nTimerStart" (byval timer as ntimer)
Declare sub nTimerStop Cdecl Alias "nTimerStop" (byval timer as ntimer)
Declare sub nSetTimerSpeed Cdecl Alias "nSetTimerSpeed" (byval timer as ntimer, byval speed As Single)
Declare Function nGetTimerSpeed Cdecl Alias "nGetTimerSpeed" (byval timer as ntimer) As single
Declare sub nSetCurrentTime Cdecl Alias "nSetCurrentTime" (byval timer as ntimer, byval time As uinteger)
Declare Function nGetCurrentTimeInMs Cdecl Alias "nGetCurrentTimeInMs" (byval timer as ntimer) As UInteger
Declare Function nGetCurrentTimeInSeconds Cdecl Alias "nGetCurrentTimeInSeconds" (byval timer as ntimer) As single
Declare Function nGetRealTimeInMs Cdecl Alias "nGetRealTimeInMs" (byval timer as ntimer) As UInteger
Declare Function nGetTimerIsStopped Cdecl Alias "nGetTimerIsStopped" (byval timer as ntimer) As integer
Declare sub nTimerTick Cdecl Alias "nTimerTick" (byval timer as ntimer)

'/--------------------------------|
'[SYSTEM                          ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

Declare Sub nSetAppTitle Cdecl Alias "nSetAppTitle" (Byval t As Zstring Ptr)
Declare Function nGetSupportGLSL Cdecl Alias "nGetSupportGLSL" () As Integer
Declare Function nGetSupportHLSL Cdecl Alias "nGetSupportHLSL" () As Integer
Declare Function nGetSupportHardwareTL Cdecl Alias "nGetSupportHardwareTL" () As Integer
Declare Function nGetAvailableMemory Cdecl Alias "nGetAvailableMemory" () As UInteger
Declare Function nGetTotalMemory Cdecl Alias "nGetTotalMemory" () As UInteger
'Declare Function nGetVideoModeCount() Cdecl Alias "nGetVideoModeCount" () As Integer
Declare Function nGetVideoModeDepth Cdecl Alias "nGetVideoModeDepth" () As Integer
Declare Function nGetVideoModeResolutionWidth Cdecl Alias "nGetVideoModeResolutionWidth" () As Integer
Declare Function nGetVideoModeResolutionHeight Cdecl Alias "nGetVideoModeResolutionHeight" () As Integer
Declare Function nGetSupportStencilBuffer Cdecl Alias "nGetSupportStencilBuffer"() As Integer
Declare Function nGetSupportMultiTexture Cdecl Alias "nGetSupportMultiTexture"() As Integer
Declare Function nGetSupportARB Cdecl Alias "nGetSupportARB"() As Integer
Declare Function nGetProcessorSpeed Cdecl Alias "ProcessorSpeed"() As UInteger


'/--------------------------------|
'[GLOBAL                          ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'\-----------------------------------------------------------------------------------------------/

Declare Sub nSetBackGroundColor Cdecl Alias "nSetBackGroundColor" (Byval r As UInteger,Byval g As UInteger,Byval b As UInteger)
Declare Sub nSetAmbientLight Cdecl Alias "nSetAmbientLight" (Byval r As UInteger,Byval g As UInteger,Byval b As UInteger)
Declare Sub nSetShadowColor Cdecl Alias "nSetShadowColor" (Byval r As UInteger,Byval g As UInteger,Byval b As UInteger,Byval a As UInteger)

Declare Sub nSetFog Cdecl Alias "nSetFog" (Byval r As UInteger,Byval g As UInteger,Byval b As UInteger,Byval Density As Single)

Declare Sub nScreenShot Cdecl Alias "nScreenShot" ()

Declare Sub InitEngine Cdecl Alias "InitEngine" (Byval driverType As Integer, Byval X As Integer,Byval Y As Integer,Byval bits As Integer,Byval mode As Integer)
Declare Function EngineRun Cdecl Alias "EngineRun" () As Integer
Declare Sub UpdateEngine Cdecl Alias "UpdateEngine" (Byval TimeStep As Single,ByVal mode As MODE_UP = UP_ALL)
Declare Sub CloseEngine Cdecl Alias "CloseEngine" ()
Declare Sub EndEngine Cdecl Alias "EndEngine" ()


Declare Sub nEnableAntialias Cdecl Alias "nEnableAntialias" ()
Declare Sub nEnableVsync Cdecl Alias "nEnableVsync" ()
Declare Sub nSetFrameRateLimit Cdecl Alias "nSetFrameRateLimit" (byval limit as uinteger)

Declare Sub BeginScene Cdecl Alias "BeginScene" ()
Declare Sub EndScene Cdecl Alias "EndScene" ()

Declare Function Fps Cdecl Alias "Fps" () As single'Integer
Declare Function nGetTrisRendered Cdecl Alias "nGetTrisRendered" () As uinteger

Declare Function nGetLightCount Cdecl Alias "nGetLightCount" () As UI
Declare Function nGetPrimitiveCount Cdecl Alias "nGetPrimitiveCount" () As I
Declare Function nGetBodyCount Cdecl Alias "nGetBodyCount" () As I


'BSP

declare function nLoadMeshBSPinRAM CDECL alias "nLoadMeshBSPinRAM" ( byval path as zstring ptr ) as UINTEGER PTR
declare function nCreateNodeBSPfromMeshBSP CDECL alias "nCreateNodeBSPfromMeshBSP" (byval mesh as UINTEGER PTR) as UINTEGER PTR
declare function nCreateNodeBSPfromFile CDECL alias "nCreateNodeBSPfromFile" (byval path as zstring ptr) as UINTEGER PTR



'GUI
declare function nCreateGUIButton CDECL alias "nCreateGUIButton" (BYVAL X AS INTEGER,BYVAL Y AS INTEGER,BYVAL W AS INTEGER,BYval H AS INTEGER,BYval TEXT AS zstring ptr,BYVAL Parent AS UINTEGER PTR) as uinteger ptr
declare function nCreateGUIButtonToolTip CDECL alias "nCreateGUIButtonToolTip" (BYVAL X AS INTEGER,BYVAL Y AS INTEGER,BYVAL W AS INTEGER,BYval H AS INTEGER,_
                                                                            BYval TEXT AS zstring ptr,BYval TTip AS zstring ptr,BYVAL Parent AS UINTEGER PTR) as uinteger ptr
declare sub nSetIsPushButton CDECL alias "nSetIsPushButton" (byval buton as uinteger ptr, byval ispush as integer)
declare sub nSetPressed CDECL alias "nSetPressed" (byval buton as uinteger ptr, byval press as integer)
declare sub nSetButtonImageNormal CDECL alias "nSetButtonImageNormal" (byval buton as uinteger ptr, byval texture as uinteger ptr,BYVAL X AS INTEGER,BYVAL Y AS INTEGER,BYVAL W AS INTEGER,BYval H AS INTEGER)
declare sub nSetButtonImagePressed CDECL alias "nSetButtonImagePressed" (byval buton as uinteger ptr, byval texture as uinteger ptr,BYVAL X AS INTEGER,BYVAL Y AS INTEGER,BYVAL W AS INTEGER,BYval H AS INTEGER)
declare sub nSetScaleImage CDECL alias "nSetScaleImage" (byval buton as uinteger ptr, byval scaleflag as integer)
declare function nGetButtonIsPressed CDECL alias "nGetButtonIsPressed" (BYVAL buton as uinteger ptr) as integer
declare sub nButtonDrawBorder CDECL alias "nButtonDrawBorder" (BYVAL buton as uinteger ptr,byval border as integer)
declare sub nDeleteButton CDECL alias "DeleteButton" (BYVAL buton as uinteger ptr)

declare function nCreateGUIScrollBar CDECL alias "nCreateGUIScrollBar" (BYVAL X AS INTEGER,BYVAL Y AS INTEGER,BYVAL W AS INTEGER,BYval H AS INTEGER,BYval HorVert as integer,BYVAL Parent AS UINTEGER PTR) as uinteger ptr
declare sub nSetScrollBarPosition CDECL alias "nSetScrollBarPosition" (BYVAL scrollbar as uinteger ptr,byval position as integer)
declare sub nSetScrollBarSmallStep CDECL alias "nSetScrollBarSmallStep" (BYVAL scrollbar as uinteger ptr,byval step as integer)
declare sub nSetScrollBarLargeStep CDECL alias "nSetScrollBarLargeStep" (BYVAL scrollbar as uinteger ptr,byval step as integer)
declare sub nSetMaxScrollBar CDECL alias "nSetMaxScrollBar" (BYVAL scrollbar as uinteger ptr,byval maxsb as integer)
declare sub nSetMinScrollBar CDECL alias "nSetMinScrollBar" (BYVAL scrollbar as uinteger ptr,byval minsb as integer)
declare function nGetScrollBarXY CDECL alias "nGetScrollBarXY" (BYVAL scrollbar as uinteger ptr) as integer
declare sub nDeleteScrollBar CDECL alias "nDeleteScrollBar" (BYVAL scrollbar as uinteger ptr)

declare function nCreateGUIWindow CDECL alias "nCreateGUIWindow" (BYVAL X AS INTEGER,BYVAL Y AS INTEGER,BYVAL W AS INTEGER,BYval H AS INTEGER,BYval TEXT AS zstring ptr,_
                                                                byval modal as integer,BYVAL Parent AS UINTEGER PTR) as uinteger ptr
declare sub nDeleteWindow CDECL alias "nDeleteWindow" (BYVAL wind as uinteger ptr)

declare function nCreateFileOpenDialog CDECL alias "nAddFileOpenDialog" (BYval TEXT AS zstring ptr,_
                                                                byval modal as integer,BYVAL Parent AS UINTEGER PTR) as uinteger ptr
declare function nGetFileNameFromDialog CDECL alias "nGetFileNameFromDialog" (BYval FileOpenDialog as uinteger ptr) as zstring ptr
declare function nGetDirectoryNameFromDialog CDECL alias "nGetDirectoryNameFromDialog" (BYval FileOpenDialog as uinteger ptr) as wstring ptr

declare function CreateColorSelector CDECL alias "nAddColorSelectDialog" (BYval TEXT AS zstring ptr,_
                                                                byval modal as integer,BYVAL Parent AS UINTEGER PTR) as uinteger ptr

declare function nCreateGUIMessageBox CDECL alias "nCreateGUIMessageBox" (BYval caption AS zstring ptr,byval flags as integer,BYval text AS zstring ptr,BYVAL Parent AS UINTEGER PTR) as uinteger ptr

declare function nCreateGUICheckBox CDECL alias "nCreateGUICheckBox" (BYVAL X AS INTEGER,BYVAL Y AS INTEGER,BYVAL W AS INTEGER,BYval H AS INTEGER,BYval TEXT AS zstring ptr,BYVAL Parent AS UINTEGER PTR) as uinteger ptr
declare sub nSetCheckBoxEnable CDECL alias "nSetCheckBoxEnable" (BYVAL checkbox as uinteger ptr,byval enable as integer)
declare sub nSetCheckBoxChecked CDECL alias "nSetCheckBoxChecked" (BYVAL checkbox as uinteger ptr,byval checker as integer)
declare function nGetCheckBoxIsChecked CDECL alias "nGetkBoxIsChecked" (BYVAL checkbox as uinteger ptr)as integer

declare sub nDrawGUI CDECL alias "nDrawGUI" ()

declare function nCreateEditBox CDECL alias "nAddEditBox" (BYVAL X AS INTEGER,BYVAL Y AS INTEGER,BYVAL W AS INTEGER,BYval H AS INTEGER,_
                                                        BYval TEXT AS zstring ptr,byval border as integer,BYVAL Parent AS UINTEGER PTR) as uinteger ptr
declare sub nSetTextEditBox CDECL alias "nSetTextEditBox" (byval edittext as uinteger ptr,byval text as zstring ptr)
declare function nGetTextEditBox CDECL alias "nGetTextEditBox" (byval edittext as uinteger ptr) as wstring ptr
declare sub nSetEditBoxTextAlignment CDECL alias "nSetEditBoxTextAlignment" (byval edittext as uinteger ptr,byval hor as integer,byval vert as integer)

declare function nAddStaticText CDECL alias "nAddStaticText" (BYval TEXT AS wstring ptr,BYVAL X AS INTEGER,BYVAL Y AS INTEGER,BYVAL W AS INTEGER,BYval H AS INTEGER,_
                                                        byval border as integer,byval wrap as integer,byval backgr as integer,_
                                                        BYVAL Parent AS UINTEGER PTR) as uinteger ptr
'hor=0 left,hor=1 center,hor=2 right,vert=0 up,vert=1 center,vert=2 down
declare sub nSetStaticTextAlignment CDECL alias "nSetStaticTextAlignment" (byval StaticText as uinteger ptr,byval hor as integer,byval vert as integer)

declare function nAddMenu CDECL alias "nAddMenu"(BYVAL Parent AS UINTEGER PTR)as uinteger ptr
declare function nAddItemToMenu CDECL alias "nAddItemToMenu"(BYVAL menu AS UINTEGER PTR,byval text as wstring ptr,_
                                                            byval commandId as integer,_
                                                            byval hassubmenu as integer)as integer
declare sub nAddSeparatorToMenu CDECL alias "nAddSeparatorToMenu"(BYVAL menu AS UINTEGER PTR)
declare function nGetSelectedItem CDECL alias "nGetSelectedItem"(BYVAL menu AS UINTEGER PTR) as integer
declare function nGetItemCommandId CDECL alias "nGetItemCommandId"(BYVAL menu AS UINTEGER PTR,byval idxItem as integer) as integer

declare function nGetSubMenu CDECL alias "nGetSubMenu"(BYVAL menu AS UINTEGER PTR,byval idxItem as integer) as uinteger ptr

declare function nAddContextMenu CDECL alias "nAddContextMenu"(BYVAL Parent AS UINTEGER PTR,byval X as integer,byval Y as integer,_
                                                                byval W as integer,byval H as integer)as uinteger ptr
declare sub nSetVisibleContextMenu CDECL alias "nSetVisibleContextMenu"(BYVAL ContextMenu AS UINTEGER PTR,byval visible as integer)
declare sub nSetCloseHandlingContextMenu CDECL alias "nSetCloseHandling"(BYVAL ContextMenu AS UINTEGER PTR,byval closebehavior as integer)
declare sub nSetVisibleGUIElement CDECL alias "nSetVisibleGUIElement"(BYVAL Element AS UINTEGER PTR,byval visible as integer)
declare function nAddToolBar CDECL alias "nAddToolBar"(byval parent as uinteger ptr) as uinteger ptr
declare function nAddButtonToToolBar CDECL alias "nAddButtonToToolBar"(byval ToolBar as uinteger ptr,_
                                                                    byval text as wstring ptr,_
                                                                    byval tooltiptext as wstring ptr,_
                                                                    byval image as ntexture,_
                                                                    byval pressedimage as ntexture,_
                                                                    byval isPush as integer,_
                                                                    byval useAlpha as integer) as uinteger ptr
declare sub nSetTransparencyGUI CDECL alias "nSetTransparencyGUI"(byval alpha as integer)


'nAddTabPage(int X,int Y,int W,int H,IGUIElement* parent)
'nSetTabDrawBackground(IGUITab* TabPage,int flagdrawbg)
'nSetTabBackgroundColor(IGUITab* TabPage,int R,int G,int B,int A)
'nSetTabTextColor(IGUITab* TabPage,int R,int G,int B,int A)



declare function nAddTabControl CDECL alias "nAddTabControl"(byval X as integer,_
                                                        byval Y as integer,_
                                                        byval W as integer,_
                                                        byval H as integer,_
                                                        byval parent as uinteger ptr,_
                                                        byval fillingbg as integer,_
                                                        byval border as integer) as uinteger ptr
                                                        
declare function nAddTabInTabControl CDECL alias "nAddTabInTabControl"(byval TabControl as uinteger ptr,_
                                                                byval caption as wstring ptr) as uinteger ptr
                                                                
declare function nGetNrTabsInTabControl CDECL alias "nGetNrTabsInTabControl"(byval TabControl as uinteger ptr) as integer
declare function nGetActiveTabInTabControl CDECL alias "nGetActiveTabInTabControl"(byval TabControl as uinteger ptr) as integer
declare sub nSetActiveTabByIndexInTabControl CDECL alias "nSetActiveTabByIndexInTabControl"(byval TabControl as uinteger ptr,_
                                                            byval index as integer)
declare sub nSetActiveTabByNameInTabControl CDECL alias "nSetActiveTabByNameInTabControl"(byval TabControl as uinteger ptr,_
                                                            byval tab as uinteger ptr)
declare function nGetPointToTabInTabControl CDECL alias "nGetPointToTabInTabControl"(byval TabControl as uinteger ptr,_
                                                        byval indextab as integer) as uinteger ptr
declare sub nSetTabHeight CDECL alias "nSetTabHeight"(byval TabControl as uinteger ptr,_
                                                            byval height as integer)

                                               
declare function nAddImageGUI CDECL alias "nAddImageGUI"(byval X as integer,_
                                                        byval Y as integer,_
                                                        byval W as integer,_
                                                        byval H as integer,_
                                                        byval text as wstring ptr,_
                                                        byval parent as uinteger ptr) as uinteger ptr
declare sub nSetImageGUI CDECL alias "nSetImageGUI"(byval imageGUI as uinteger ptr,_
                                                    byval texture as uinteger ptr)
declare sub nSetColorImageGUI CDECL alias "nSetColorImageGUI"(byval imageGUI as uinteger ptr,_
                                                    byval r as integer,byval g as integer,_
                                                    byval b as integer,byval a as integer)
declare sub nSetScaleImageGUI CDECL alias "nSetScaleImageGUI"(byval imageGUI as uinteger ptr,_
                                                    byval flagscale as integer)
declare sub nSetUseAlphaChannelImageGUI CDECL alias "nSetUseAlphaChannelImageGUI"(byval imageGUI as uinteger ptr,_
                                                    byval flagalpha as integer)

declare function nAddComboBox CDECL alias "nAddComboBox"(byval X as integer,_
                                                        byval Y as integer,_
                                                        byval W as integer,_
                                                        byval H as integer,_
                                                        byval parent as uinteger ptr) as uinteger ptr

declare function nAddItemComboBox CDECL alias "nAddItemComboBox"(byval comboBox as uinteger ptr,byval text as wstring ptr)as integer
declare function nGetItemCountComboBox CDECL alias "nGetItemCountComboBox"(byval comboBox as uinteger ptr) as integer
declare function nGetStringItemComboBox CDECL alias "nGetStringItemComboBox"(byval comboBox as uinteger ptr,_
                                                                byval indexitem as integer) as wstring ptr 
                                                            
declare function nGetSelectedItemComboBox CDECL alias "nGetSelectedItemComboBox"(byval comboBox as uinteger ptr) as integer

'Sets the selected item. Set this to -1 if no item should be selected
declare sub nSetSelectedItemComboBox CDECL alias "nSetSelectedItemComboBox"(byval comboBox as uinteger ptr,_
                                                                byval indexitem as integer)
declare sub nRemoveComboBox CDECL alias "nRemoveComboBox"(byval comboBox as uinteger ptr)


'nSetTextAlignmentComboBox(IGUIComboBox* comboBox,int horiz_align,int vert_align)



'Collisions
'draws a 3D line in the 3D world
Declare Sub nDrawLine3D Cdecl Alias "nDrawLine3D" (Byval x1 As single,Byval y1 As single,Byval z1 As single,Byval x2 As single,Byval y2 As single,Byval z2 As single,Byval thickness As single,Byval Alpha As Uinteger,Byval Red As Uinteger,Byval Green As Uinteger,Byval Blue As Uinteger)

Declare Sub nSetCollisions Cdecl Alias "nSetCollisions" (Byval mesh As nMESH,Byval entity As nENTITY,Byval mode As I,_
        Byval SX AS Single=10,Byval SY AS Single=10,Byval SZ AS Single=10,_
        Byval GX AS SINGLE=0,Byval GY AS SINGLE=-1,Byval GZ AS SINGLE=0,_
        Byval OFFX AS SINGLE=0,Byval OFFY AS SINGLE=10,Byval OFFZ AS SINGLE=0)


Declare Sub nSetCollisionsBSP Cdecl Alias "nSetCollisionsBSP" (Byval meshBSP As nMESH,Byval nodeBSP As nMESH,Byval entity As nENTITY,_
        Byval SX AS Single=20,Byval SY AS Single=20,Byval SZ AS Single=20,_
        Byval GX AS SINGLE=0,Byval GY AS SINGLE=-10,Byval GZ AS SINGLE=0,_
        Byval OFFX AS SINGLE=0,Byval OFFY AS SINGLE=50,Byval OFFZ AS SINGLE=0)                         
                                                
Declare Function nGetCollisionNodeFromCamera Cdecl Alias "nGetCollisionNodeFromCamera"(byval camera as ncamera) As nENTITY
Declare Function nGetCollisionNodeFromScreenCoordinates Cdecl Alias "nGetCollisionNodeFromScreenCoordinates"( byval x_screen as integer,byval y_screen as integer) As nENTITY

Declare Function nGetCollisionNodeFromRay Cdecl Alias "nGetCollisionNodeFromRay"(byval xstart as single,_
                                                                                byval ystart as single,_
                                                                                byval zstart as single,_
                                                                                byval xend as single,_
                                                                                byval yend as single,_
                                                                                byval zend as single) as nentity
                                                                                
                                                                                
                                                                                

Declare sub nGetScreenCoordinatesFrom3DPosition CDECL alias "nGetScreenCoordinatesFrom3DPosition" ( byref screen_x as integer, byref screen_y as integer,_
									byval xpos as single,  byval ypos as single, byval zpos as single)


Declare Function nCreateGeneralTriangleSelector CDECL alias "nCreateGeneralTriangleSelector"(byval meshnode as uinteger ptr,_
															byval mode as integer) as uinteger ptr
                                                            
                                                            
Declare Function nCreateTriangleSelectorBSP CDECL alias "nCreateTriangleSelectorBSP"(byval meshBSP as uinteger ptr,_
														byval nodeBSP as uinteger ptr) as uinteger ptr


Declare Function nCreateOctTreeTriangleSelector CDECL alias "nCreateOctTreeTriangleSelector"(byval meshnode as uinteger ptr) as uinteger ptr

                                                                                            
Declare Function nCreateTriangleSelectorFromBoundingBox CDECL alias "nCreateTriangleSelectorFromBoundingBox"(byval meshnode as uinteger ptr) as uinteger ptr


Declare Function nCreateTerrainSelector CDECL alias "nCreateTerrainSelector"(byval terrain as uinteger ptr) as uinteger ptr

Declare Function nCreateMetaTriangleSelector CDECL alias "nCreateMetaTriangleSelector"() as uinteger ptr

Declare Sub nAddTriangleSelector CDECL alias "nAddTriangleSelector"(byval mts as uinteger ptr,_
                                                                        byval ts as uinteger ptr)


Declare Sub nRemoveAllTriangleSelectors CDECL alias "nRemoveAllTriangleSelectors"(byval mts as uinteger ptr)

Declare Sub nRemoveTriangleSelector CDECL alias "nRemoveTriangleSelector"(byval mts as uinteger ptr,_
                                                                        byval ts as uinteger ptr)
                                                                        

Declare Function nGetNodeAndCollisionPointFromCamera CDECL alias "nGetNodeAndCollisionPointFromCamera"(byval camera as uinteger ptr,_
                                                        byval node as uinteger ptr,_
                                                        byval trisel as uinteger ptr,_
                                                        byref xcoll as single,_
                                                        byref ycoll as single,_
                                                        byref zcoll as single) as uinteger ptr
                                                        



Declare Function nGetNodeAndCollisionPointFromRay CDECL alias "nGetNodeAndCollisionPointFromRay"(byval xstart as single,_
                                                        byval ystart as single,_
                                                        byval zstart as single,_
                                                        byval xend as single,_
                                                        byval yend as single,_
                                                        byval zend as single,_
                                                        byval node as uinteger ptr,_
                                                        byval trisel as uinteger ptr,_
                                                        byref xcoll as single,_
                                                        byref ycoll as single,_
                                                        byref zcoll as single) as uinteger ptr
                                                        


