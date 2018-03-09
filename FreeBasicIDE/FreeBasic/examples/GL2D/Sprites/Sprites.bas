''****************************************************************************
''
''    Easy GL2D (FB.IMAGE compatible version)
''
''    By Relminator (Richard Eric M. Lope)
''    http://rel.phatcode.net
''    
''  Code supplement on how to use:
''  1. Sprites and its plethora of uses 
''  2. Shadows
''  3. Fading
''
''****************************************************************************


#include once "FBGL2D7.bi"   
#include once "FBGL2D7.bas" 


declare sub DrawSprites(byval x as integer, byval y as integer, byval frame as integer, byval spr as GL2D.Image ptr)
declare sub DrawBG(byval spr as GL2D.Image ptr)


const SCR_WIDTH = 640
const SCR_HEIGHT = 480
const as single PI = atn(1)*4

const false = 0
const true = not false


GL2D.ScreenInit( SCR_WIDTH, SCR_HEIGHT )   ''Set up GL screen
GL2D.VsyncON()

'' Got this happy face from the example files
Paint (0, 0), RGB(64, 128, 255)

'' set up an image and draw something in it
Dim img As GL2D.Image Ptr = ImageCreate( 32, 32, RGB(255, 0, 255) )
Circle img, (16, 16), 15, RGB(255, 255, 0),     ,     , 1, f
Circle img, (10, 10), 3,  RGB(  0,   0, 0),     ,     , 2, f
Circle img, (23, 10), 3,  RGB(  0,   0, 0),     ,     , 2, f
Circle img, (16, 18), 10, RGB(  0,   0, 0), 3.14, 6.28

'' Load FB image to Hardware
GL2D.LoadImageToHW(img)
	
dim as integer xa, ya, xb, yb

xa = 100
ya = 100

xb = 200
yb = 100
dim as integer frame = 0
dim as integer fade = false
dim as integer fade_alpha = 0

dim as single FPS = 0	
	
do
	frame += 1	
	'' clear buffer
	GL2D.ClearScreen()
	
	GL2D.Begin2D()
	
		'' draw our bg
		DrawBG(img)
		
		
		'' normal color
		glColor4ub(255,255,255,255)
	
		'' SOLID
		'' Solid simple
		GL2D.SetBlendMode(GL2D.BLEND_SOLID)
		DrawSprites( 100, 150, Frame , img )
		
		'' TRANSPARENT
		'' Trans simple
		GL2D.SetBlendMode(GL2D.BLEND_TRANS)
		DrawSprites( 100, 250, Frame , img )
		
		''' BLENDED
		'' set color to 200/256 blending
		glColor4ub(255,255,255,200)
		GL2D.SetBlendMode(GL2D.BLEND_BLENDED)
		DrawSprites( 100, 350, Frame , img )
		
		''' GLOW
		'' set color to 200/256 blending
		glColor4ub(128,128,128,200)
		GL2D.SetBlendMode(GL2D.BLEND_GLOW)
		DrawSprites( 100, 450, Frame , img )
		
		'' Green blended streched
		GL2D.SetBlendMode(GL2D.BLEND_BLENDED)
		glColor4ub(0,255,255,200)
		GL2D.SpriteStretchHorizontal(xb,yb,32+abs(sin(frame/20)*300), img)
	
		'' Red transparent
		GL2D.SetBlendMode(GL2D.BLEND_TRANS)
		glColor4ub(255,0,0,255)
		GL2D.Sprite(xa,ya,GL2D.FLIP_NONE, img)
	
		'' Shadow and fade effect
		GL2D.SetBlendMode(GL2D.BLEND_BLACK)   '' transparent
		glColor4ub(0,255,255,abs(sin(frame/50)*255))
		
		'' Blended rotated and scaled
		GL2D.SpriteRotateScaleXY(500 + (img->width/2),100 + (img->height/2),-frame,sin(frame/30)*5,sin(frame/10)*5, GL2D.FLIP_NONE, img )
	
		
	
		'' Sprite stencil (draws a sprite in pure RGBA color)
		GL2D.SetBlendMode(GL2D.BLEND_TRANS)
	
		'' enable sprite stencil with colour of GL2D_RGBA(0,0,255,255) and env color of GL2D_RGBA(255,0,255,255)
		GL2D.EnableSpriteStencil(true, GL2D_RGBA(0,0,255,255), GL2D_RGBA(255,0,255,255))
	
		'' Fuchsia color transparent
		GL2D.SpriteRotateScaleXY(500 + (img->width/2),250 + (img->height/2),-frame,sin(frame/15)*5,sin(frame/20)*5, GL2D.FLIP_NONE, img )
	
		'' Pure white blended
		GL2D.EnableSpriteStencil(true, GL2D_RGBA(255,255,255,255), GL2D_RGBA(255,255,255,255))
		GL2D.SetBlendMode(GL2D.BLEND_BLENDED)   '' blending
		glColor4ub(0,0,255,127)
		GL2D.SpriteRotateScaleXY(500 + (img->width/2),400 + (img->height/2),-frame,sin(frame/10)*5,sin(frame/30)*5, GL2D.FLIP_NONE, img )
	
		'' Disable sprite stencil
		GL2D.EnableSpriteStencil(false)
	
	
		
		'' Control the red face
		if multikey(FB.SC_LEFT ) and xa >   0 then xa = xa - 1
	    if multikey(FB.SC_RIGHT) and xa < 639 then xa = xa + 1
	    if multikey(FB.SC_UP   ) and ya >   0 then ya = ya - 1
	    if multikey(FB.SC_DOWN ) and ya < 479 then ya = ya + 1
	
		if multikey(FB.SC_SPACE) then fade = true
		
	
		'' Fade screen
		if fade then
			GL2D.SetBlendMode(GL2D.BLEND_BLENDED)   '' fade to white by blending
			GL2D.BoxFilled(0,0, SCR_WIDTH-1, SCR_HEIGHT-1, GL2D_RGBA(255,255,255,fade_alpha))
			if frame and 7 then fade_alpha += 1   '' increase alpha every 8th frame
			if fade_alpha = 255 then exit do   '' exit if full
		EndIf
	
		
		'' Test print
		GL2D.SetBlendMode(GL2D.BLEND_TRANS)   '' transparent
		glColor4ub(255,255,255,255)  '' no transluceny
		GL2D.PrintScale(0, 10,2, "Simple sprites      FPS = " + str(fps))
		GL2D.SetBlendMode(GL2D.BLEND_BLENDED)   '' transparent
		glColor4ub(0,255,255,200)  '' 1/2 transluceny
		GL2D.PrintScale(0, 30,1.5, "Use arrow keys to move.")
		
		GL2D.PrintScale(0, 50,1.5, "Press <space> to fade.")
	
	GL2D.End2D()
		
    ' limit fps to 60 frames per second
	FPS = GL2D.LimitFps(60)	
	sleep 11,1
	
	flip
	
Loop Until Multikey( FB.SC_ESCAPE ) 






'' Reset screen and test the sprite in
'' FBGFX mode
screenres 640, 480, 32

cls

Print "Back in FBGFX"
put(100,100), img, trans

'' destroy da happy face
GL2D.DestroyImage( img )
GL2D.ShutDown()

sleep
sleep

end


sub DrawSprites(byval x as integer, byval y as integer, byval frame as integer, byval spr as GL2D.Image ptr)
	
	'' Normal
	GL2D.Sprite( x, y, GL2D.FLIP_NONE, spr )
	
	'' Rotated
	'' add 1/2 dimensions since rotation is center-based
	GL2D.SpriteRotate( x  + (spr->width/2) + 100, y + (spr->height/2),frame,GL2D.FLIP_NONE, spr)
	
	'' rotated and scaled
	GL2D.SpriteRotateScale( x + (spr->width/2) + 200, y + (spr->height/2),-frame,sin(frame/30)*3,GL2D.FLIP_NONE, spr )
	
	'' Flipped
	GL2D.Sprite( x + 300, y, GL2D.FLIP_V or GL2D.FLIP_H, spr )

End Sub

sub DrawBG(byval spr as GL2D.Image ptr)
	
	dim as GL2D.Image ptr temp = spr
	dim as integer tiles_x = SCR_WIDTH\temp->width 
	dim as integer tiles_Y = SCR_HEIGHT\temp->height 
	
	GL2D.SetBlendMode(GL2D.BLEND_TRANS)
			
	for y as integer = 0 to tiles_y
		for x as integer = 0 to tiles_x
			glColor4ub(x*2 / (tiles_x) * 255, y*4 / (tiles_y) * 255, (y+x)*2 / (tiles_y) * 255,255)
			GL2D.sprite(x * temp->width,y * temp->height, GL2D.FLIP_NONE, spr )
		next x
	next y

End Sub
