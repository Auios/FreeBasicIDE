''****************************************************************************
''
''    Easy GL2D (FB.IMAGE compatible version)
''
''    By Relminator (Richard Eric M. Lope)
''    http://rel.phatcode.net
''    
''  Code supplement on how to use:
''  1. Sprites 
''  2. HUDS
''  3. Easy Scrolling using GL2D.GetImage()
''
''****************************************************************************

#include once "fbgfx.bi"
#include once "/gl/gl.bi" 
#include once "/gl/glu.bi"   

#include once "FBGL2D7.bi"     	'' We're gonna use Hardware acceleration
#include once "FBGL2D7.bas"		'' So we'll be using my LIB



''*****************************************************************************
const as integer SCREEN_WIDTH = 640
const as integer SCREEN_HEIGHT = 480


const as integer FALSE = 0
const as integer TRUE = not FALSE

''*****************************************************************************
'' Our main sub
''*****************************************************************************
sub main()

	
	'' Set up a dynamic memory for our images
	redim as GL2D.IMAGE ptr GripeImages(0)
	
	
	dim as integer Frame = 0
	 
	GL2D.ScreenInit( SCREEN_WIDTH, SCREEN_HEIGHT )   ''Set up GL screen
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
	
	'' Initialize our sprites
	'' See tutorial for Easy GL2D..
	'' http://back2basic.phatcode.net/?Issue_%232:Basic_2D_Rendering_in_OpenGL_using_Easy_GL2D%3A_Part_1
	'' http://back2basic.phatcode.net/?Issue_%232:Basic_2D_Rendering_in_OpenGL_using_Easy_GL2D%3A_Part_2
	GL2D.InitSprites( GripeImages(), 32,32, "gripe.bmp", GL_NEAREST )

	'' Scroller
	dim as GL2D.Image Test
	
	'' Stretched sprite for HUDS and Dialogue boxes
	dim as GL2D.Image ptr Orb = GL2D.LoadBmpToGLsprite( "redorb.bmp", GL_NEAREST )
	
	'' Override default font
	Gl2D.FontLoad( 16, 16, 32,  "metro.bmp", GL_LINEAR )
	
	
	do
		
		Frame += 1

		
		GL2D.ClearScreen()
			
		GL2D.Begin2D()
			
			GL2D.SetBlendMode(GL2D.BLEND_TRANS)
		
			glColor4ub(255,255,255,255)
	
			'' Axis exclusive rotate and scale with flipping
			GL2D.SpriteRotateScaleXY( 10, 10, (Frame/1), 2 * sin(Frame/20), 2 * sin(Frame/10), GL2D.FLIP_NONE, GripeImages(0) )
			GL2D.SpriteRotateScaleXY( 50, 50, (Frame/1), 2 * sin(Frame/20), 2 * sin(Frame/10), GL2D.FLIP_H, GripeImages(0) )
			GL2D.SpriteRotateScaleXY( 100, 100, (Frame/1), 2 * sin(Frame/20), 2 * sin(Frame/10), GL2D.FLIP_V, GripeImages(0) )
			GL2D.SpriteRotateScaleXY( 150, 150, (Frame/1), 2 * sin(Frame/20), 2 * sin(Frame/10), GL2D.FLIP_H or GL2D.FLIP_V, GripeImages(0) )
		
			'' Huds
			dim as integer Px = SCREEN_WIDTH - 450 * abs(sin(Frame/70))
			GL2D.SpriteStretchHorizontal( Px\2, 400,  64 + 450 * abs(sin(Frame/70)), Orb )
			GL2D.SpriteStretchVertical( 0, 150,  64 + 250 * abs(sin(Frame/160)), Orb )
		
			'' Moving Dialogue box
			GL2D.SpriteStretch( 350, 150,  64 + 250 * abs(sin(Frame/210)),  64 + 150 * abs(sin(Frame/110)), Orb )
			
			'' Just to see that stretch and normal sprite can draw the same sprite
			GL2D.SpriteStretch( 250, 150,  32,  32, GripeImages(0) )
			GL2D.Sprite( 250, 150+32, GL2D.FLIP_NONE, GripeImages(0) )
		
			
			''  Using GetImage for easy scrolling
			dim as integer GetOffset = Frame * 2
			GL2D.GetImage( @Test, GripeImages(0), GetOffset, GetOffset, GetOffset + 256, GetOffset+128 )
			GL2D.Sprite( 250, 16, GL2D.FLIP_NONE, @Test )
		
			'' Our little mascot
			GL2D.Sprite( 550, 32, GL2D.FLIP_NONE, img )
		
			'' Dialogue box
			glColor4ub(255,255,0,255)
			GL2D.SpriteStretch( 70, 180,  270,  220, Orb )
		
			GL2D.SetBlendMode(GL2D.BLEND_BLENDED)
			glColor4ub(0,255,255,255)
			GL2D.PrintScale(80, 220, 1.2, "GFX by:")
			
			glColor4ub(255,255,255,255)
			GL2D.PrintScale(100, 270, 0.8, "Marc Russell")
			GL2D.PrintScale(100, 310, 0.8, "SpicyPixel.Net")
			
		GL2D.End2D()
		
		
		dim as integer FPS = GL2D.LimitFPS(60)
		
		sleep 1,1
		flip
		
	Loop until multikey(FB.SC_ESCAPE)

	Gl2D.DestroyImage(img)
	GL2D.DestroySprites( GripeImages() )

	GL2D.ShutDown()
	
End Sub

''*****************************************************************************
''*****************************************************************************


main()


end


