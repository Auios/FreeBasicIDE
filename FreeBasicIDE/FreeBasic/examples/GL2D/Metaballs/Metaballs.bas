''****************************************************************************
''
''    Easy GL2D (FB.IMAGE compatible version)
''
''    By Relminator (Richard Eric M. Lope)
''    http://rel.phatcode.net
''    
''  Code supplement on how to use:
''  1. Metaballs 
''  2. Font
''
''****************************************************************************


#include once "FBGL2D7.bi"   
#include once "FBGL2D7.bas" 


using FB

const MAX_BLOBS = 256

const SCREEN_WIDTH = 640
const SCREEN_HEIGHT = 480
const as single PI = atn(1)*4

'' Set up a screen so we could draw oldskool FBGFX stuff( hiding it BTW)
screenres SCREEN_WIDTH, SCREEN_HEIGHT, 32, 2, GFX_NO_FRAME

'' GL2D.Image is compatible to imagecreate
'' and by doing it this way makes if easier to 
'' Call GL2D sprite routines since we don't need to cast
'' them to FB.Image/GL2D.Image
dim img as GL2D.Image ptr = imagecreate( 64, 64, rgba(255, 0, 255,0), 32 )

dim as integer wid_d2 = img->width\2
dim as integer hei_d2 = img->height\2

dim as single strength =  img->width \ 2

dim as integer col
dim as single dist


for y as integer = 0 to img->width - 1
        for x as integer = 0 to img->height - 1
        	dist = sqr((wid_d2-x) ^ 2 + (hei_d2-y) ^ 2)
        	if dist < sqr(img->width ^ 2 + img->height ^ 2) then
        		if (wid_d2-x) = 0 and (hei_d2-y) = 0 then
                    col = 255
                else
                    col = (Strength / (dist)) * 255                    
                    col = col - 255
                end if
                if col < 0 then 
                	col = 0
                EndIf
                if col > 255 then 
                	col = 255                
                EndIf
                pset img,(x,y),RGBA(col,col,col,255)
        	else
        		pset img,(x,y),RGBA(255,0,255,0)
        	end if
        next x
next y

'' initialize GL2D (640 x 480)
GL2D.ScreenInit( SCREEN_WIDTH, SCREEN_HEIGHT )

GL2D.VsyncOn()   '' set vsynch on

Gl2D.FontLoad( 16, 16, 32,  "sifont.bmp" )
	

'' load the sprite to HW (SW data still remains for whatever purposes you want)
GL2D.LoadImageToHW(cast(GL2D.image ptr, img), GL_LINEAR)

dim as uinteger colors(MAX_BLOBS)
dim as single scale(MAX_BLOBS)

for i as integer = 0 to MAX_BLOBS
	colors(i) = GL2D_RGBA(RND*256,RND*256,RND*256,RND*256)
	scale(i) = 0.5 + abs(sin(i)*1.5)
Next i


dim as integer xa, ya, xb, yb

xa = 100
ya = 100

xb = 200
yb = 100

dim as single demo_time
dim as single old_time = timer

dim as single FPS = 0
dim as integer Frame = 0 
do
	
	Frame += 1	
	demo_time = timer 
	if( (demo_time - old_time) > 1 ) then
		FPS = Frame/(demo_time - old_time)
		old_time = timer
		Frame = 0
	EndIf
	
	'' clear buffer
	GL2D.ClearScreen()
	
	
	GL2D.Begin2D()
	
		'' normal color
		glColor4ub(255,255,255,255)
	
		GL2D.SetBlendMode(GL2D.BLEND_GLOW)
		
	    for i as integer = 0 to MAX_BLOBS
	        dim as integer bx = sin(demo_time / 175 * 0.8 * i) * 320  
	        dim as integer by = cos(demo_time / 195 * 0.9 * i) * 240
	        glColor4ubv(cast( GLubyte ptr, @colors(i)))             
	        GL2D.SpriteScale(320-32+bx,240-32+by,scale(i), GL2D.FLIP_NONE, img )  '' See, no cast()           
	    next i
	
		'' Test print
		GL2D.SetBlendMode(GL2D.BLEND_TRANS)   '' transparent
		glColor4ub(0,0,0,255)  '' no transluceny
		GL2D.PrintScale(0, 0,1, "DISCO BALLS!!!         FPS = " + str(int(fps)))
		GL2D.PrintScale(0, 30,1, "DID YOU JUST TAKE LSD?")
	
	GL2D.End2D()
	
	
	
		
	flip
	sleep 1,1
Loop Until Multikey( FB.SC_ESCAPE ) 



'' destroy da happy face
GL2D.DestroyImage( img )
GL2D.ShutDown()


end


