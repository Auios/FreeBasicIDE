''****************************************************************************
''
''    Easy GL2D (FB.IMAGE compatible version)
''
''    By Relminator (Richard Eric M. Lope)
''    http://rel.phatcode.net
''    
''  Code supplement on how to use:
''  1. 2d rendering with a 3d background 
''  2. Glow particles
''  3. Lollipops and candies
''
''****************************************************************************


#include once "FBGL2D7.bi"     	'' We're gonna use Hardware acceleration
#include once "FBGL2D7.bas"		'' So we'll be using my LIB


const as single PI = 3.141593
const as single TWOPI = (2 * PI) 

'' some parameters our 3d model would use
CONST as integer S_SLICES= 42
CONST as integer S_BANDS = 32          
CONST as single S_RADIUS = 3.5         


'' v1ctor 3d
type vector3d
    as single   x
    as single   y
    as single   z
end type

'' texture coordinates
type textuv
    as single  u
    as single  v 
end type

'' triangle    
Type polytype
        p1      as integer      'vertex 1 of our triangle
        p2      as integer      'huh?
        p3      as integer
        u1      as single
        v1      as single
        u2      as single
        v2      as single
        u3      as single
        v3      as single
        col		as single
end Type


'' prototypes
declare sub DrawSexy( model() as vector3d, model_tri() as PolyType, model_text() as textuv, model_norm() as vector3d, byval image as GL2D.image ptr )  

declare sub LoadSexy( model() as vector3d, modeltext() as textuv, model_norm() as vector3d,_
				      byval radius as single,_
	                  byval slices as single,_ 
	                  byval bands as single,_ 
	                  byval twist_delta as single,_
	                  byval frame as single )

declare sub Lathing( model() as vector3d, poly() as polytype, byval rings as integer, byval bands as integer )

declare sub VectorNormalize( byref v as vector3d )


using FB

'' max number of particles
const as integer MAX_PARTICLES = 255

'' screen dimensions
const SCR_WIDTH = 640
const SCR_HEIGHT = 480

const FALSE = 0
const TRUE = not FALSE

randomize timer

'' initialize GL2D (640 x 480)
GL2D.ScreenInit( SCR_WIDTH, SCR_HEIGHT )

GL2D.VsyncOn()   '' set vsynch on

Gl2D.FontLoad( 16, 16, 32,  "DeVinneOrn.bmp" )
	
'' our sexy texture
dim as GL2D.image ptr SexyImage = GL2D.LoadBmpToGLsprite( "artery.bmp", GL_LINEAR )

'' particle sprite	
dim as GL2D.image ptr ParticleImage = GL2D.LoadBmpToGLsprite( "particle.bmp", GL_LINEAR )

'' Random colors for our candies
dim as uinteger part_colors(MAX_PARTICLES)

'' 3d stuff
redim model(1) as vector3d
redim model_norm(1) as vector3d
redim model_text(1) as textuv

'' load sexy chick
LoadSexy( model(), model_text(), model_norm(), S_RADIUS,S_SLICES,S_BANDS, 0, 0 )
redim model_tri(1) as PolyType

'' Tesselate sexy model
Lathing( model(), model_tri(), S_SLICES, S_BANDS )


'' fill colors with random values
for i as integer = 0 to MAX_PARTICLES
	part_colors(i) = GL2D_RGBA(rnd*256,rnd*256,rnd*256,rnd*256)
next i


'' frame counter to animate stuff
dim as integer frame = 0

'' Controls how "sexy" the 3d model is
dim as single twist_d


'' Just to show that we can use standard GL in conjunction with Easy GL2D
'' set up lighting and material parameters for our 3d object
'' and separate the specular color for a shiny effect
dim as glFloat mat_ambient(0 to 3) =  { 0.5, 0.5, 1.0, 0.15 }
dim as glFloat mat_specular(0 to 3) = {  1.0, 1.0, 1.0, 0.15 }  
dim as glFloat mat_shininess = 15.0
dim as glFloat light_position(0 to 3)= { 7.0, 8.0, -16.0, 1.0  }
dim as glFloat light_ambient(0 to 3)= { 1.0, 1.0, 1.0, 1.0 }
dim as glFloat mat_twister(0 to 3) = { 0.75, 0.75, 0.0, 1.0 }
dim as GLfloat fBrightLight(0 to 3) = { 1.0, 1.0, 1.0, 1.0 }
glMaterialfv(GL_FRONT, GL_AMBIENT, @mat_ambient(0))
glMaterialfv(GL_FRONT, GL_SPECULAR, @mat_specular(0))
glMaterialfv(GL_FRONT, GL_SHININESS, @mat_shininess)
glMaterialfv(GL_FRONT, GL_DIFFUSE,@mat_twister(0))
glMaterialfv(GL_FRONT, GL_SPECULAR, @fBrightLight(0))

'' separate specular light so that the "sexiness" shows
'' only 1 light but the more the merrier
glLightModeli(GL_LIGHT_MODEL_COLOR_CONTROL, GL_SEPARATE_SPECULAR_COLOR)
glLightfv(GL_LIGHT0,GL_AMBIENT, @light_ambient(0))
glLightfv(GL_LIGHT0,GL_DIFFUSE, @light_ambient(0))
glLightfv(GL_LIGHT0, GL_POSITION, @light_position(0))
glEnable(GL_LIGHTING)
glEnable(GL_LIGHT0)

dim as single FPS = 0

do
	frame += 1	
	twist_d = sin(frame*PI/180)*0.29171   '' twist it
	
	'' clear buffer
	GL2D.ClearScreen()     '' clear buffer
	
	
	'' enable lighting since 2d mode disables it by default
	glEnable(GL_LIGHTING)
  	
  	'' reload model
	LoadSexy( model(), model_text(), model_norm(), S_RADIUS,S_SLICES,S_BANDS, twist_d, frame )
	'' draw model
	DrawSexy( model(), model_tri(), model_text(), model_norm(), SexyImage )  

	
	'' normal color
	glColor4ub(255,255,255,255)

	'' return to 2d so that we could print
	'' and draw some popcorns
	GL2D.Begin2D()
	
	
		'' Glow it for kicks
		GL2D.SetBlendMode(GL2D.BLEND_GLOW)
		glColor4ub(255,255,255,255)   '' full glow
	
		'' draw the popcorns
		for i as integer = 0 to MAX_PARTICLES
			dim as integer x = ( ((cos((frame+i*10)/40) + sin((frame+i*30)/10)) * (SCR_WIDTH\5)))
			dim as integer y = ( ((sin(-(frame+i*20)/20) + sin((frame+i*40)/60)) * (SCR_HEIGHT\5)))
			
			glColor4ubv(cast(GLubyte ptr, @part_colors(i)))
			'' Trans rotated and scaled
			GL2D.SpriteRotateScaleXY( 320 + x + (ParticleImage->width/2),_
									  300 + y + (ParticleImage->height/2),_
									  -frame*5,_
									  sin((frame+i*10)/30)*3,_
									  sin((frame+i*10)/30)*3,_
									  GL2D.FLIP_NONE,_
									  ParticleImage )
		next i	
	
		glColor3f(1,1,1)
		'' Test print
		GL2D.PrintScale(0, 10, 0.9, "Disco 2D + sexy 3D = U is da winner! FPS:" + str(FPS))
		
		GL2D.SetBlendMode(GL2D.BLEND_BLENDED)   '' transparent
		glColor4ub(0,255,255,128)  '' transluceny	
		GL2D.PrintScale(0, 40,2.0, "Too easy it hurts!")

	GL2D.End2D()
	
	'' limit fps to 60 frames per second
	FPS = GL2D.LimitFPS(60)	
	
		
    flip
    
    
	sleep 1,1
Loop Until Multikey( FB.SC_ESCAPE ) 




GL2D.DestroyImage( SexyImage )
GL2D.DestroyImage( ParticleImage )

GL2D.ShutDown()



end



'' draws the sexy model
sub DrawSexy( model() as vector3d, model_tri() as PolyType, model_text() as textuv, model_norm() as vector3d, byval image as GL2D.image ptr)  

	dim as integer i  
	static as integer theta= 0
	theta += 1
	
	glPushMatrix()
	
		glEnable(GL_DEPTH_TEST)
		glLoadIdentity()
		glTranslatef(0.0,-1.0,-18)  
		glRotatef(theta, 0, 0, 1)
		glRotatef(90, 1, 0, 0)
		
		glBindTexture(GL_TEXTURE_2D, image->TextureID)
		
		glBegin(GL_TRIANGLES)   
		for i = 0 to Ubound(model_tri)    	 
			glNormal3fv( @model_norm(model_tri(i).p1).x )
			glTexCoord2fv( @model_text(model_tri(i).p1).u )
			glVertex3fv( @model(model_tri(i).p1).x )
			glNormal3fv( @model_norm(model_tri(i).p2).x )
			glTexCoord2fv( @model_text(model_tri(i).p2).u )
			glVertex3fv( @model(model_tri(i).p2).x )
			glNormal3fv( @model_norm(model_tri(i).p3).x )
			glTexCoord2fv( @model_text(model_tri(i).p3).u )
			glVertex3fv( @model(model_tri(i).p3).x )
		next i
		glEnd()
	   
  	glPopMatrix()
  	
  	
  	
end sub

'' animates the sexy model
sub LoadSexy( model() as vector3d, modeltext() as textuv, model_norm() as vector3d,_
			  byval radius as single,_
              byval slices as single,_ 
              byval bands as single,_ 
              byval twist_delta as single,_
              byval frame as single)
	
	static first_time as integer = 0
	if first_time = 0 then
	    redim model ((slices * (Bands + 1) )-1) as vector3d
	    redim model_norm ((slices * (Bands + 1) )-1) as vector3d
	    redim modeltext((slices * (bands + 1))-1) as textuv
	end if
	dim as integer i, slice, band
	dim as single phi, theta,z,zdist,twister,steps
	static as single sliceoff=0
	dim as single xc,yc,zc
	sliceoff +=0.1
	i = 0
	zdist = 0.75
	twister = 0
	z = zdist * Slices / 2
	FOR Slice = 0 TO Slices - 1
	    zc = slice + frame * 0.3
	    xc = cos(TWOPI * zc *1.5/ slices) * 2.8
	    yc = sin(TWOPI * zc *1.5/ slices) * 2.8
	FOR Band = 0 TO Bands '- 1
	    Theta = (2 * PI / Bands) * Band
	    Model(i).x = xc+((radius)+sin((sliceoff+slice)*PI/8)) * COS(Theta+twister)
	    Model(i).y = yc+((radius)+sin((sliceoff+slice)*PI/8)) * SIN(Theta+twister)
	    Model(i).z = -z
	    model_norm(i).x =  model(i).x - xc
	    model_norm(i).y =  model(i).y - yc
	    model_norm(i).z =  model(i).z 
	    VectorNormalize( model_norm(i) )
	    modeltext(i).v = (((Band) / (bands-0.0) ) * 2)  
	    modeltext(i).u = (((Slice) / (slices-0.0) ) * 2)    
	    i = i + 1
	NEXT Band
	    twister += twist_delta
	    z = z - zdist
	NEXT Slice

end sub

'' tesselates a quadric
sub Lathing( model() as vector3d, poly() as polytype, byval rings as integer, byval bands as integer )
       
       dim as integer maxpoint,i
       MaxPoint = (Rings) * (Bands+ 1)
       

       dim Maxtri as integer
	   maxtri = MaxPoint * 2
       redim Poly(maxtri) as polytype


		'lathing
	    dim s as integer, u as integer
	    dim maxvert as integer
	    dim slice as integer
	    maxvert = MaxPoint
	    i = 0
		for s = 0 to rings - 4
			 slice = s * bands
			 for u = 0 to bands		  'duplicate texture ( not bands - 1)
				 poly(i).p1=(u+bands+1+(slice)) mod maxvert
				 poly(i).p2=(u+bands+(slice)) mod maxvert
				 poly(i).p3=(u+(slice)) mod maxvert
				 poly(i).col=rnd
				 poly(i).u1=0
				 poly(i).v1=0
				 poly(i).u2=1
				 poly(i).v2=0
				 poly(i).u3=1
				 poly(i).v3=1
				 poly(i+1).p1=(u+(slice)) mod maxvert
				 poly(i+1).p2=(u+1+(slice)) mod maxvert
				 poly(i+1).p3=(u+bands+1+(slice)) mod maxvert
				 poly(i+1).col=rnd
				 poly(i+1).u1=1
				 poly(i+1).v1=1
				 poly(i+1).u2=0
				 poly(i+1).v2=1
				 poly(i+1).u3=0
				 poly(i+1).v3=0
				 i = i + 2
			next u
		next s



end sub


'' normalizes a v1ctor
sub VectorNormalize (byref v as vector3d)
    'makes v a unit vector
    dim mag as single
    mag = 1/sqr(v.x * v.x + v.y * v.y + v.z * v.z)
    if mag <> 0 then
        v.x = v.x * mag
        v.y = v.y * mag
        v.z = v.z * mag
    else
        v.x = 0
        v.y = 0
        v.z = 1
    end if

end sub

