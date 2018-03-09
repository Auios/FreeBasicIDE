''****************************************************************************
''
''    Easy GL2D (FB.IMAGE compatible version)
''
''    By Relminator (Richard Eric M. Lope)
''    http://rel.phatcode.net
''    
'' Code supplement on how to use:
''  1. Metaballs as lasers 
''  2. Glowlines as lightsabers
''  3. Fire
''  3. Fonts
''
''****************************************************************************


#include once "FBGL2D7.bi"   
#include once "FBGL2D7.bas" 


'' particles struct for our laser, saber and fire
type Tparticle
	x			as single
	y			as single
	life		as integer
	alpha		as integer
	active		as integer
	ID			as integer
end type



const PI = 3.141593
const TWOPI = (2 * PI) 
const MAXPARTS = 256	'' maximum particle on screen * 2(Laser and Fire)
const MAXSEGMENT = 32   '' Saber trail effect
const MAXFLARES = 10

'' screen dimensions
const SCREEN_WIDTH = 640
const SCREEN_HEIGHT = 480

const FALSE = 0
const TRUE = not FALSE

randomize timer


using FB


dim as Tparticle parts(0 to MAXPARTS-1)
dim as Tparticle fire(0 to MAXPARTS-1)
dim as Tparticle laser(0 to MAXSEGMENT-1)

dim as GLuint colors(MAXFLARES)

'' laser and fire particles
for i as integer = 0 to  MAXPARTS-1
	parts(i).active = FALSE
 	fire(i).active = FALSE 
next i

'' saber trail effect
for j as integer = 0 to (MAXSEGMENT - 1)
    laser(j).x = 320
    laser(j).y = 240
next j
    

for i as integer = 0 to MAXFLARES
	colors(i) = GL2D_RGBA(rnd * 256,rnd * 256,rnd * 256,rnd * 256)
next i


'' initialize GL2D (640 x 480)
GL2D.ScreenInit( SCREEN_WIDTH, SCREEN_HEIGHT )

GL2D.VsyncOn()   '' set vsynch on

'' Load a special font
Gl2D.FontLoad( 16, 16, 32,  "consolas.bmp", GL_LINEAR )
	
'' particle sprites	(force linear mapping for better effect)
redim as GL2D.IMAGE ptr PartsImages(0)
GL2D.InitSprites( PartsImages(), 64, 64, "metaball.bmp", GL_LINEAR )


'' Saber
dim img as GL2D.Image ptr = imagecreate( 32, 32, rgb(255, 255, 255), 32 )
GL2D.LoadImageToHW( img, GL_LINEAR )



'' flare
dim as GL2D.Image ptr FlareImage = GL2D.LoadBmpToGLsprite( "particle.bmp", GL_LINEAR )


'' smoke
dim as GL2D.Image ptr SmokeImage = GL2D.LoadBmpToGLsprite( "smoke.bmp", GL_LINEAR )


dim as GL2D.image ptr ShipImages(1)
ShipImages(0) = GL2D.LoadBmpToGLsprite( "triunglow.bmp", GL_LINEAR )
ShipImages(1) = GL2D.LoadBmpToGLsprite( "triglow.bmp", GL_LINEAR )

'' frame counter to animate stuff
dim as integer Frame = 0
dim as single ox, oy

do
	Frame += 1	
	
	'' clear buffer
	GL2D.ClearScreen()     '' clear buffer


	GL2D.Begin2D()
	
		'' Flares
		GL2D.SetBlendMode(GL2D.BLEND_GLOW)
	
		for i as integer = 0 to MAXFLARES
			dim as integer x = 5 *  ( (cos((frame)/10*i/5) + sin((frame)/60)) )
			dim as integer y = 4 *  ( (sin(-(frame)/20*i/9) + sin((frame)/30)) )
			glColor4ubv(  cast( GLubyte ptr, @colors(i) ) )   '' random colors
			GL2D.SpriteRotateScale(x + 64+(img->width/2), y + 200+(img->height/2), frame + i*15*sgn(i),1 + i/3, GL2D.FLIP_NONE, FlareImage )
		next i	
	
	
		'' Blobies
		for i as integer = 0 to MAXFLARES
			dim as integer x = 30 *  ( (cos((frame)/10*i/5) + sin((frame)/40)) )
			dim as integer y = 25 *  ( (sin(-(frame)/20*i/9) + sin((frame)/50)) )
			'dim as integer  angle = 		
			glColor4ubv(  cast( GLubyte ptr, @colors(i) ) )   '' random colors
			GL2D.SpriteRotateScale(x + 570+(img->width/2), y + 200+(img->height/2), 0, 1 + i/5, GL2D.FLIP_NONE, PartsImages(i and 1) )
		next i	
	
		'' *******************FIRE***************************
		'' Glow it for kicks
		GL2D.SetBlendMode(GL2D.BLEND_GLOW)
		glColor4ub(255,255,255,255)   '' full glow
	
		'' parts update for fire
		for j as integer = 0 to 10
			for i as integer = 0 to  MAXPARTS-1
				if fire(i).active = false then 
					fire(i).x			= rnd*600
					fire(i).y			= 470
					fire(i).life		= 10+rnd*200
					fire(i).alpha		= 255
					fire(i).active		= true
					exit for   		
				end if
			next i
		next j
		
			'' do parts
		for i as integer = 0 to  MAXPARTS-1
			if fire(i).active then
				fire(i).life		-= 1
				if fire(i).alpha >0 then fire(i).alpha -= 1
				fire(i).y		    -= 0.32
				if fire(i).life < 0 then 
					fire(i).active = false						
				endif
			endif
		next i
	
		'' draw parts
		for i as integer = 0 to  MAXPARTS-1
			if fire(i).active then
				glColor4ub(fire(i).life,fire(i).life/2,fire(i).life/2,fire(i).life/3)   '' full glow
				GL2D.SpriteScale(fire(i).x-32,fire(i).y-16,1.5*(fire(i).life/210), GL2D.FLIP_NONE, SmokeImage )
			endif
		next i
	

		'' *******************LIGHT SABER**************************
		
		GL2D.SetBlendMode(GL2D.BLEND_BLENDED)
		glColor4ub(255,255,255,255)   '' full glow
	
	
		dim as integer saber_x = 320 + ( ((cos((frame)/10) + sin((frame)/60)) * (SCREEN_WIDTH\5)))
		dim as integer saber_y = 240 + ( ((sin(-(frame)/20) + sin((frame)/30)) * (SCREEN_HEIGHT\5)))		
	
		'' set initial value to tip of saber
		laser(0).x = saber_x
	    laser(0).y = saber_y
	    
	    '' reverse copy
	    for j as integer = (MAXSEGMENT - 1) to 1 step -1
	        laser(j)= laser(j-1)
	    next j
	    
	    '' draw trail effect using triangles
	    for j as integer = (MAXSEGMENT - 1) to 1 step -1
	    	dim as integer x1 = laser(j).x
	    	dim as integer y1 = laser(j).y
	    	dim as integer x2 = laser(j-1).x
	    	dim as integer y2 = laser(j-1).y
	    	dim as integer strength1 = (MAXSEGMENT-j-1)/MAXSEGMENT * 255
			dim as integer strength2 = (MAXSEGMENT-j)/MAXSEGMENT * 255
			GL2D.TriangleFilledGradient( 320, 240, x1, y1, x2, y2,_
										 GL2D_RGBA(strength1,0,strength1,strength1),_
										 GL2D_RGBA(strength1,0,strength1,strength1),_
										 GL2D_RGBA(strength2,0,strength2,strength2))
	    next j
	    
		'' draw the main part of the saber
		'' multiple glowlines for better effect
		GL2D.LineGlow (320, 240, saber_x, saber_y, 30,GL2D_RGBA(60,128,25,255))
		GL2D.LineGlow (320, 240, saber_x, saber_y, 20,GL2D_RGBA(100,200,200,255))
		GL2D.LineGlow (320, 240, saber_x, saber_y, 15,GL2D_RGBA(160,128,215,255))
		GL2D.LineGlow (320, 240, saber_x, saber_y, 10,GL2D_RGBA(55,128,25,255))


		'' *******************LASER ***************************
	
		'' move lasers
		dim as integer x = ( ((cos((frame)/70) + sin((frame)/90)) * (SCREEN_WIDTH\5)))
		dim as integer y = ( ((sin(-(frame)/60) + sin((frame)/40)) * (SCREEN_HEIGHT\5)))		
	
		'' Laser 1
		'' parts update
		for i as integer = 0 to  MAXPARTS-1
			if parts(i).active = false then 
				parts(i).x			= 320 + x
				parts(i).y			= 240 + y
				parts(i).life		= 100
				parts(i).alpha		= 255
				parts(i).active		= true
				parts(i).ID			= 0
				exit for   		
			end if
		next i
	
		'' laser 2
		'' parts update
		for i as integer = 0 to  MAXPARTS-1
			if parts(i).active = false then 
				parts(i).x			= 320 - x
				parts(i).y			= 240 - y
				parts(i).life		= 100
				parts(i).alpha		= 255
				parts(i).active		= true
				parts(i).ID			= 1
				exit for   		
			end if
		next i
	    
	    
	    '' update particles
		'' do parts
		for i as integer = 0 to  MAXPARTS-1
			if parts(i).active then
				parts(i).life		-= 1
				parts(i).alpha		-= 2
				if parts(i).life < 0 then 
					parts(i).active = false						
				endif
			endif
		next i
	
		'' glow mode
		GL2D.SetBlendMode(GL2D.BLEND_GLOW)
		glColor4ub(255,255,255,255)   '' full glow
	
		'' draw using additive blending
		'' draw parts
		for i as integer = 0 to  MAXPARTS-1
			if parts(i).active then
				glColor4ub(255,255,255,parts(i).alpha)
				GL2D.SpriteScale( parts(i).x,parts(i).y,0.5*(parts(i).alpha/255), GL2D.FLIP_NONE, PartsImages(parts(i).ID) )
			endif
		next i


	
		'' glowing ship position
		dim as single sx = 320 + ( ((cos((frame)/30) + sin((frame)/60)) * (SCREEN_WIDTH\4)))
		dim as single sy = 240 + ( ((sin(-(frame)/40) + sin((frame)/70)) * (SCREEN_HEIGHT\4)))		
		
		'' get angle(in degrees) to draw the rotated ship 
		dim as integer angle = atan2(sy - oy, sx - ox) * 180 / PI
	
		'' save old position for angle calculation
		ox = sx
		oy = sy
	
		'' draw glowing ship	
		dim as single glow = abs(sin(frame/5) * 0.2)		'' glow it
		
		'' Non-glowing
		GL2D.SpriteRotateScale(sx+(ShipImages(0)->width/2), sy+(ShipImages(0)->height/2), angle, 1, GL2D.FLIP_NONE, ShipImages(0) )
		'' Glowing
		GL2D.SpriteRotateScale(sx+(ShipImages(1)->width/2), sy+(ShipImages(1)->height/2), angle, 1+glow, GL2D.FLIP_NONE, ShipImages(1) )
	
	
		'' limit fps to 60 frames per second
		dim as single FPS = GL2D.LimitFPS(60)	
	    		
		'' Test print
		GL2D.PrintScale(0, 10, 1, "Easy Laser and Lightsaber  FPS = " + str(FPS))
		
		GL2D.SetBlendMode(GL2D.BLEND_TRANS)   '' transparent
		glColor4ub(0,255,255,128)  '' transluceny	
		GL2D.PrintScale(0, 40,0.7, "Just a bunch of particles that looks like a laser")
		GL2D.PrintScale(0, 60,0.7, "Lightsaber is done with glowlines and triangles.")
		GL2D.PrintScale(0, 80,0.7, "Fire uses a smoke(smoke.bmp) texture.")
		GL2D.PrintScale(0, 100,0.7, "Glowing ship uses 2 ship sprites(triglow & triunglow).")
	
	
	GL2D.End2D()
	
	flip
    
    
	sleep 11,1
	
Loop Until Multikey( FB.SC_ESCAPE ) 


'' cleanup
GL2D.DestroyImage(img)
GL2D.DestroyImage(FlareImage)
GL2D.DestroyImage(SmokeImage)
GL2D.DestroyImage(ShipImages(0))
GL2D.DestroyImage(ShipImages(1))

GL2D.DestroySprites(PartsImages())

GL2D.ShutDown()

end
