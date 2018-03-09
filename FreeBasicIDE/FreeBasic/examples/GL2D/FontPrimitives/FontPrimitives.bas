''****************************************************************************
''
''    Easy GL2D (FB.IMAGE compatible version)
''
''    By Relminator (Richard Eric M. Lope)
''    http://rel.phatcode.net
''
''  Code supplement on how to use:
''  1. Primitives 
''  1. Fonts 
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

const as single PI = atn(1) * 4
''*****************************************************************************
'' Our main sub
''*****************************************************************************
sub main()

	
	
	dim as integer Frame = 0
	 
	GL2D.ScreenInit( SCREEN_WIDTH, SCREEN_HEIGHT )   ''Set up GL screen
	GL2D.VsyncON()
	
	Gl2D.FontLoad( 16, 16, 32,  "DeVinneOrn.bmp", GL_LINEAR )
	
	do
		
		Frame += 1

		
		GL2D.ClearScreen()
			
		GL2D.Begin2D()
		
			glColor4ub(255,255,255,255)
			
			Gl2D.SetBlendMode(GL2D.BLEND_SOLID)
		    
			'' circle test
			Gl2D.CircleFilled(100,100,150-abs(sin(frame/25)*150),GL2D_RGBA(0,255,0,255))
			Gl2D.Circle(100,100,abs(sin(frame/25)*150),GL2D_RGBA(255,255,0,255))
			Gl2D.Ellipse(320, 240, 50, 200, PI/6*5, GL2D_RGBA(255, 128, 64, 255))
			Gl2D.EllipseFilled(320, 240, 10+abs(sin(frame/25)*250), 10+250-abs(sin(frame/25)*250), frame/65, GL2D_RGBA(255, 128, 64, 255))

			'' Glowlines
			'' draw 3 blended lines with decreasing widths to
		    '' make the effect  better.
			Gl2D.SetBlendMode(GL2D.BLEND_GLOW)
		    for i as integer = frame to (360+frame) step 10

				dim as integer px =  sin(frame/30.0)  * 220 * cos( (i * PI) / 180.0 )
				dim as integer py =  sin(frame/80.0)  * 120 * sin( (i * PI) / 180.0 )
				dim as integer px2 = sin(frame/130.0)  * 170 * cos( ( (i+20) * PI ) / 180.0 )
				dim as integer py2 =  sin(frame/40.0)  * 160 * sin( ( (i+20) * PI ) / 180.0 )
				dim as single adder = abs( 7*sin( frame/ 20.0) )

				for j as integer = 0 to adder
					GL2D.LineGlow( 128+px, 328+py, 228+px2, 228+py2, 25-(adder*2), GL2D_RGBA(255+frame,255-frame,128+frame,255) )
				next j

			next i

			'' box
			GL2D.Box(400,40,639,479,GL2D_RGBA(220,255,55,0))
			'' test gradient box
			GL2D.BoxFilledGradient(420,350,560,460,_
					   			  	 GL2D_RGBA(0,255,255,255),_
									 GL2D_RGBA(255,255,0,255),_
									 GL2D_RGBA(255,255,255,255),_
									 GL2D_RGBA(255,0,255,255))
			
			'' triangle test
			GL2D.Triangle(480,100,630,50,560,200,GL2D_RGBA(25,2,255,255))
			GL2D.TriangleFilled(490,105,610,60,590,135,GL2D_RGBA(255,255,255,255))
			
			glColor4ub(255,255,255,64)		'' factor of 64/256 blending
			GL2D.SetBlendMode(GL2D.BLEND_BLENDED)
			GL2D.TriangleFilledGradient(290,150,510,60,490,135,_
										  GL2D_RGBA(0,255,255,255),_
										  GL2D_RGBA(255,255,0,255),_
										  GL2D_RGBA(255,0,255,255))
			
			
			Gl2D.SetBlendMode(GL2D.BLEND_ALPHA)
		    
			glColor4ub(255,0,255,255)
			Gl2D.PrintScale(10,10,2,"RELMINATOR")
			Gl2D.PrintScale(10,50,1,"ABC !@!#$#$#%^%&^*(*&(*&)(")
			
			glColor4ub(255,255,0,255)
			Gl2D.PrintScale(10,100,1.5,"Anya Therese B. Lope")
			
			
	GL2D.End2D()
		
		
		dim as integer FPS = GL2D.LimitFPS(60)
		
		sleep 1,1
		flip
		
	Loop until multikey(FB.SC_ESCAPE)

	GL2D.ShutDown()
	
End Sub

''*****************************************************************************
''*****************************************************************************


main()


end


