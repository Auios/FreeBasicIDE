''=============================================================================
''
''    Version 0.7
''    Easy GL2D (FB.IMAGE compatible version)
''    By Relminator (Richard Eric M. Lope)
''    http://rel.phatcode.net
''    
''    An easy to use OpenGL 2d lib
''    As easy as fbgfx (easier IMHO if you use my Texture packer)
''    
''    Can automatically load BMP's supported by BLOAD
''    Adds alpha transparency if you want
''    No external dependencies (only uses OpenGL/GLU and FBGFX)
''    Source license is "use or abuse"
''
''=============================================================================



#include once "FBGL2D7.bi"

namespace GL2D

'' Some globals to makelife easier
'' Kinda safe because access is limited to this
'' module and cannot be accessed outside of this
'' module even with a namespace qualifier
 
dim shared as GLuint current_texture = 0
dim shared as GLuint font_list_base = 0
dim shared as GLuint font_list_offset = 0
dim shared as GLuint font_textureID = 0

''*****************************************************************************
''
''  Global array for our 3D block
''
''*****************************************************************************

''Vertices for the cube
dim shared as single CubeVectors(23) =>_
{	(-0.5), (-0.5), ( 0.5),_ 
	( 0.5), (-0.5), ( 0.5),_
	( 0.5), (-0.5), (-0.5),_
	(-0.5), (-0.5), (-0.5),_
	(-0.5), ( 0.5), ( 0.5),_ 
	( 0.5), ( 0.5),	( 0.5),_
	( 0.5), ( 0.5), (-0.5),_
	(-0.5), ( 0.5), (-0.5) }


'' Poly Index
dim shared as integer CubeFaces(23) =>_
{	3,2,1,0,_
	0,1,5,4,_
	1,2,6,5,_
	2,3,7,6,_
	3,0,4,7,_
	4,5,6,7 }


''=============================================================================
''
''    synchronizes the drawing after vblank
''
''    got this from FB's example file
''    added Landeel's stuff for linux
''    
''=============================================================================
sub VsyncON()
	
	dim swapinterval as function(byval interval as integer) as integer
	dim extensions as string
	
	'' setup opengl and retrieve supported extensions
	screencontrol FB.GET_GL_EXTENSIONS, extensions
	
	if (instr(extensions, "WGL_EXT_swap_control") <> 0) then
	    '' extension supported, retrieve proc address
	    swapinterval = ScreenGLProc("wglSwapIntervalEXT")
	else
		swapinterval = ScreenGLProc("glXSwapIntervalSGI")
	end if

    if (swapinterval <> 0) then
        '' ok, we got it. set opengl to wait for vertical sync on buffer swaps
        swapinterval(1)
    end if

end sub


''=============================================================================
''
''    Starts the 2d drawing
''
''=============================================================================
sub Begin2D()
	
	current_texture = 0
	glDisable(GL_DEPTH_TEST)
    glDisable (GL_CULL_FACE)
	
	glEnable(GL_BLEND)    	    
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
	
	glDisable( GL_DEPTH_TEST )
	
	glEnable( GL_ALPHA_TEST )
	glAlphaFunc(GL_GREATER, 0)


	glDisable(GL_STENCIL_TEST)
	glDisable(GL_TEXTURE_1D)
	glDisable(GL_LIGHTING)
	glDisable(GL_LOGIC_OP)
	glDisable(GL_DITHER)
	glDisable(GL_FOG)

	glHint(GL_POINT_SMOOTH_HINT, GL_FASTEST)
	glHint(GL_LINE_SMOOTH_HINT , GL_FASTEST)

	glPointSize( 1 )
	glLineWidth( 1 )
	
	dim as integer ViewPort(3)

    glGetIntegerv(GL_VIEWPORT, @ViewPort(0))

    glMatrixMode(GL_PROJECTION)    
    glPushMatrix()
    glLoadIdentity()
    ''glOrtho(0, wid, hei, 0, -1, 1)
    glOrtho(0, ViewPort(2), ViewPort(3), 0, -1, 1)
    glMatrixMode(GL_MODELVIEW)
    glPushMatrix()
    glLoadIdentity()
    glTranslatef(0.375, 0.375, 0)	'' magic trick
    
end sub

''=============================================================================
''
''    Ends ortho drawing for if you want to do a 2d-3d combo engine
''
''=============================================================================
sub End2D()  
	
	
    glMatrixMode(GL_PROJECTION)
    glPopMatrix()
    glMatrixMode(GL_MODELVIEW)
    glPopMatrix()
    
    SetBlendMode(GL2D.BLEND_SOLID)
    glColor4ub(255,255,255,255)
    
end sub


''=============================================================================
''
''    private!! sets up the fontsystem
''
''=============================================================================
sub FontLoad( byval glyph_width as integer, byval glyph_height as integer,_
			  byval fontoffset as integer, byref filename as string, byval filter_mode as GLuint = GL_NEAREST )

	
	font_list_offset = fontoffset
	glDeleteLists( font_list_base, 256 )
    glDeleteTextures( 1, @font_textureID )
	
	if filename = "" then return
         
    
    dim as integer F = freefile
    dim as integer wid, hei		'' width and height
    dim as ushort bpp		'' bits per pixel
    
    '' test header
    open filename for binary as #f
    get #f, 19, wid
    get #f, 23, hei
    get #f, 29, bpp
    close #f
   
    dim as FB.IMAGE ptr image = imagecreate(wid,hei,RGBA(255,0,255,0))
    bload filename, image
    
    select case bpp
    	case 8
    		font_textureID = LoadImage8bitAlpha(image,filter_mode)
    	case 24
    		font_textureID = LoadImage24bitAlpha(image,filter_mode)
    	case else
    		font_textureID = LoadImage(image,filter_mode)
    end select
           
    imagedestroy( image )


    font_list_base = glGenLists(256)

    dim as single scalex = 1/wid
    dim as single scaley = 1/hei
    dim as single w = glyph_width * scalex
    dim as single h = glyph_height * scaley

	dim as integer TilesW = wid \ glyph_width 
    dim as integer TilesH = hei \ glyph_height 
    
    glPushMatrix()
    glLoadIdentity()
    for font_loop as integer = 0 to 255
	    
	    dim as single x = (font_loop mod TilesW) * w
	    dim as single y = fix(font_loop / TilesH) * h
	    
	    glNewList( font_list_base + font_loop, GL_COMPILE )
	    glBegin( GL_QUADS )
	            glTexCoord2f( x, y + h)
	            glVertex2i( 0, glyph_height )
	           
	            glTexCoord2f( x + w, y + h )
	            glVertex2i( glyph_width, glyph_height )
	           
	            glTexCoord2f( x + w,y )
	            glVertex2i( glyph_width, 0 )
	           
	            glTexCoord2f( x, y )
	            glVertex2i( 0, 0 )
	    glEnd()
	    
	    glTranslatef( glyph_width,0,0 )
	    glEndList()
	    
    next font_loop

	glPopMatrix()
	
end sub

''=============================================================================
''
''    private!! sets up the fontsystem
''
''=============================================================================
private sub font_init()

	font_list_offset = 0
    dim as any ptr image = imagecreate(128,128,RGBA(255,0,255,0))
    
    for x as integer = 0 to 15
        for y as integer = 0 to 15
        	draw string image, (x * 8, y * 8), chr( x + y * 16)
        next
    next

	
	font_textureID = LoadImage24bitAlpha( image )
	

    imagedestroy( image )


    font_list_base = glGenLists(256)
    dim as single scale = 1/128
    dim as single w = 8 * scale
    dim as single h = 8 * scale

    glPushMatrix()
    glLoadIdentity()
    for font_loop as integer = 0 to 255
	    
	    dim as single x = (font_loop mod 16) * w
	    dim as single y = fix(font_loop / 16) * h
	    
	    glNewList( font_list_base + font_loop, GL_COMPILE )
	    glBegin( GL_QUADS )
	            glTexCoord2f( x, y + h)
	            glVertex2i( 0, 8 )
	           
	            glTexCoord2f( x + w, y + h )
	            glVertex2i( 8, 8 )
	           
	            glTexCoord2f( x + w,y )
	            glVertex2i( 8, 0 )
	           
	            glTexCoord2f( x, y )
	            glVertex2i( 0, 0 )
	    glEnd()
	    
	    glTranslatef( 8,0,0 )
	    glEndList()
	    
    next font_loop

	glPopMatrix()
	
end sub

''=============================================================================
''
''    Sets up OpenGL for 2d mode
''
''=============================================================================
sub ScreenInit(byval screen_wid as integer, byval screen_hei as integer, byval flags as integer = 0)
	
	if flags then
		screenres screen_wid, screen_hei, 32, 2, FB.GFX_OPENGL or flags
	else
		screenres screen_wid, screen_hei, 32, 2, FB.GFX_OPENGL
	endif
	
	
	'screen information 
	dim w as integer, h as integer 
	'OpenGL params for gluerspective 
	dim FOVy as double            'Field of view angle in Y 
	dim Aspect as double          'Aspect of screen 
	dim znear as double           'z-near clip distance 
	dim zfar as double            'z-far clip distance 

	'using screen info w and h as params 
	glViewport(0, 0, screen_wid, screen_hei)
	
	'Set current Mode to projection(ie: 3d) 
	glMatrixMode(GL_PROJECTION) 
	
	'Load identity matrix to projection matrix 
	glLoadIdentity() 

	'Set gluPerspective params 
	FOVy = 90/2                                     '45 deg fovy 
	Aspect = screen_wid / screen_hei
	znear = 1                                       'Near clip 
	zfar = 1000                                      'far clip 
	
	'use glu Perspective to set our 3d frustum dimension up 
	gluPerspective(FOVy, aspect, znear, zfar) 
	
	'Modelview mode 
	'ie. Matrix that does things to anything we draw 
	'as in lines, points, tris, etc. 
	glMatrixMode(GL_MODELVIEW) 
	'load identity(clean) matrix to modelview 
	glLoadIdentity() 
	
	glShadeModel(GL_SMOOTH)                 'set shading to smooth(try GL_FLAT) 
	glClearColor(0.0, 0.0, 0.0, 1.0)        'set Clear color to BLACK 
	glClearDepth(1.0)                       'Set Depth buffer to 1(z-Buffer) 
	glDisable(GL_DEPTH_TEST)                'Disable Depth Testing so that our z-buffer works 
	
	'compare each incoming pixel z value with the z value present in the depth buffer 
	'LEQUAL means than pixel is drawn if the incoming z value is less than 
	'or equal to the stored z value 
	glDepthFunc(GL_LEQUAL) 
	
	'have one or more material parameters track the current color 
	'Material is your 3d model 
	glEnable(GL_COLOR_MATERIAL) 


    'Enable Texturing 
    glEnable(GL_TEXTURE_2D) 
    

   	'Tell openGL that we want the best possible perspective transform 
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST) 
	
	'Disable Backface culling
	glDisable (GL_CULL_FACE)
	
	glPolygonMode(GL_FRONT, GL_FILL) 
	
	'' enable blending for transparency 
	glEnable(GL_BLEND)    	    
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
	
	glDisable( GL_DEPTH_TEST )
	
	glEnable( GL_ALPHA_TEST )
	glAlphaFunc(GL_GREATER, 0)


	glDisable(GL_STENCIL_TEST)
	glDisable(GL_TEXTURE_1D)
	glDisable(GL_LIGHTING)
	glDisable(GL_LOGIC_OP)
	glDisable(GL_DITHER)
	glDisable(GL_FOG)

	glHint(GL_POINT_SMOOTH_HINT, GL_FASTEST)
	glHint(GL_LINE_SMOOTH_HINT , GL_FASTEST)

	glPointSize( 1 )
	glLineWidth( 1 )
	
	'' set up the font system
	font_init()

	
end sub


''=============================================================================
''
''    Sets blend mode 
''    E_TRANS = normal transparent
''    E_SOLID = solid with no transparency
''    E_BLENDED = 1:1 blending
''    E_GLOW = ADDITIVE blending
''
''=============================================================================
sub SetBlendMode(byval blend_mode as GL2D_BLEND_MODE)
	
	select case blend_mode
		case BLEND_TRANS
			glDisable(GL_BLEND)    	    
			glEnable(GL_ALPHA_TEST)
		case BLEND_SOLID
			glDisable(GL_BLEND)
			glDisable(GL_ALPHA_TEST)    	    
		case BLEND_BLENDED
			glEnable(GL_BLEND)
			glEnable(GL_ALPHA_TEST)    	    
			glBlendFunc(GL_SRC_ALPHA, GL_ONE)
		case BLEND_GLOW
			glEnable(GL_BLEND)
			glEnable(GL_ALPHA_TEST)    	    
			glBlendFunc(GL_ONE, GL_ONE)
		case BLEND_ALPHA
			glEnable(GL_BLEND)
			glEnable(GL_ALPHA_TEST)    	    
			glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
		case BLEND_BLACK
			glEnable(GL_BLEND)
			glEnable(GL_ALPHA_TEST)    	
			glBlendFunc(GL_ZERO,GL_ONE_MINUS_SRC_ALPHA)
		case else	
			glDisable(GL_BLEND)    	    
			glEnable(GL_ALPHA_TEST)
	end select
	
end sub


''=============================================================================
''
''    Sets texture environment color
''     
''    (1 - (texture image color))*(glColor colour) + (texture image colour)*(texture environment colour)
''    I didn't put this as part of the set_blend since we can use this alongside
''    blending
''
''=============================================================================
sub EnableSpriteStencil( byval flag as integer = 0,_
						   byval gl2dcolor as GLuint = GL2D_RGBA(0,0,0,0),_
						   byval gl2dcolor_env as GLuint = GL2D_RGBA(0,0,0,0)  )
	
	static as GLfloat env_color(3)
	if flag then
		
		env_color(0) = ARGB_B(gl2dcolor_env)/255
		env_color(1) = ARGB_G(gl2dcolor_env)/255
		env_color(2) = ARGB_R(gl2dcolor_env)/255
		env_color(3) = ARGB_A(gl2dcolor_env)/255
		
		glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND)
		glTexEnvfv(GL_TEXTURE_ENV, GL_TEXTURE_ENV_COLOR, @env_color(0))
		glColor4ubv( cast( GLubyte ptr, @gl2dcolor ) )	
	
	else
	
		glTexEnvf( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE )
	
	end if
	
	
end sub

''=============================================================================
''
''    Enables or disables AA depending on the switch
''
''=============================================================================
sub EnableAntialias(byval switch as integer = 1)
	
	if switch then
		glEnable( GL_POINT_SMOOTH )
        glEnable( GL_LINE_SMOOTH  )
	else
		glDisable( GL_POINT_SMOOTH )
        glDisable( GL_LINE_SMOOTH  )
	endIf
	
End Sub

''=============================================================================
''
''    Clears the buffer
''
''=============================================================================
sub ClearScreen()
	
	glClear(GL_COLOR_BUFFER_BIT OR GL_DEPTH_BUFFER_BIT)

end sub

''=============================================================================
''
''   gl2dColor should use GL2D_RGBA()     
''
''=============================================================================
sub Pset( byval x as integer, byval y as integer, byval gl2dcolor as GLuint )
	
	glDisable( GL_TEXTURE_2D )
	glColor4ubv( cast( GLubyte ptr, @gl2dcolor ) )
	glBegin( GL_POINTS )
		glVertex2i( x, y )
	glEnd()
	glEnable( GL_TEXTURE_2D )
	glColor4ub(255,255,255,255)
	
end sub

''=============================================================================
''
''   gl2dColor should use GL2D_RGBA()     
''
''=============================================================================
sub Line( byval x1 as integer, byval y1 as integer, byval x2 as integer, byval y2 as integer, byval gl2dcolor as GLuint )

	glDisable( GL_TEXTURE_2D )
	glColor4ubv( cast( GLubyte ptr, @gl2dcolor ) )

    glBegin( GL_LINES )
		glVertex2i( x1, y1 )
		glVertex2i( x2, y2 )
	glEnd()
	glEnable( GL_TEXTURE_2D )

	glColor4ub(255,255,255,255)
	
end sub

''=============================================================================
''
''   gl2dColor should use GL2D_RGBA()     
''
''=============================================================================
sub LineGradient( byval x1 as integer, byval y1 as integer, byval x2 as integer, byval y2 as integer, byval gl2dcolor1 as GLuint, byval gl2dcolor2 as GLuint )

	glDisable( GL_TEXTURE_2D )
	
    glBegin( GL_LINES )
		glColor4ubv( cast( GLubyte ptr, @gl2dcolor1 ) ): glVertex2i( x1, y1 )
		glColor4ubv( cast( GLubyte ptr, @gl2dcolor2 ) ): glVertex2i( x2, y2 )
	glEnd()
	glEnable( GL_TEXTURE_2D )

	glColor4ub(255,255,255,255)
	
end sub

''=============================================================================
''
''   gl2dColor should use GL2D_RGBA()     
''
''=============================================================================
sub Box( byval x1 as integer, byval y1 as integer, byval x2 as integer, byval y2 as integer, byval gl2dcolor as GLuint )

	glDisable( GL_TEXTURE_2D )
	glColor4ubv( cast( GLubyte ptr, @gl2dcolor ) )
	
    
	glBegin( GL_LINE_STRIP )
		glVertex2i( x1, y1 )
		glVertex2i( x2, y1 )
		glVertex2i( x2, y2 )
		glVertex2i( x1, y2 )
		glVertex2i( x1, y1 )
	glEnd()
	
	
	glEnable( GL_TEXTURE_2D )
	
	glColor4ub(255,255,255,255)
	
end sub


''=============================================================================
''
''   gl2dColor should use GL2D_RGBA()     
''
''=============================================================================
sub BoxFilled( byval x1 as integer, byval y1 as integer, byval x2 as integer, byval y2 as integer, byval gl2dcolor as GLuint )

	glDisable( GL_TEXTURE_2D )
	glColor4ubv( cast( GLubyte ptr, @gl2dcolor ) )
    
    x2 += 1
    y2 += 1
    
	glBegin(GL_QUADS)
		
		glVertex2i	(x1,y1)
		glVertex2i	(x1,y2)
		glVertex2i	(x2,y2)
		glVertex2i	(x2,y1)
		
	glEnd()
	
	glEnable( GL_TEXTURE_2D )
	
	glColor4ub(255,255,255,255)
    
end sub


''=============================================================================
''
''   gl2dColor should use GL2D_RGBA()     
''
''=============================================================================
sub BoxFilledGradient( byval x1 as integer, byval y1 as integer,_
						 byval x2 as integer, byval y2 as integer,_
						 byval gl2dcolor1 as GLuint,_
						 byval gl2dcolor2 as GLuint,_
						 byval gl2dcolor3 as GLuint,_
						 byval gl2dcolor4 as GLuint )

	glDisable( GL_TEXTURE_2D )
	
    x2 += 1
    y2 += 1
    
	glBegin(GL_QUADS)
		glColor4ubv( cast( GLubyte ptr, @gl2dcolor1 ) )
		glVertex2i	(x1,y1)
		glColor4ubv( cast( GLubyte ptr, @gl2dcolor2 ) )
		glVertex2i	(x1,y2)
		glColor4ubv( cast( GLubyte ptr, @gl2dcolor3 ) )
		glVertex2i	(x2,y2)
		glColor4ubv( cast( GLubyte ptr, @gl2dcolor4 ) )
		glVertex2i	(x2,y1)		
	glEnd()
	
	glEnable( GL_TEXTURE_2D )
	
	glColor4ub(255,255,255,255)
    
end sub

''=============================================================================
''
''   gl2dColor should use GL2D_RGBA()     
''
''=============================================================================
sub Triangle( byval x1 as integer, byval y1 as integer, byval x2 as integer, byval y2 as integer,_
			  byval x3 as integer, byval y3 as integer, byval gl2dcolor as GLuint )

	glDisable( GL_TEXTURE_2D )
	glColor4ubv( cast( GLubyte ptr, @gl2dcolor ) )

	glBegin( GL_LINE_STRIP )
		glVertex2i( x1, y1 )
		glVertex2i( x2, y2 )
		glVertex2i( x3, y3 )
		glVertex2i( x1, y1 )
	glEnd()
	
	glEnable( GL_TEXTURE_2D )
	
	glColor4ub(255,255,255,255)
	
end sub

''=============================================================================
''
''   gl2dColor should use GL2D_RGBA()     
''
''=============================================================================
sub TriangleFilled( byval x1 as integer, byval y1 as integer, byval x2 as integer, byval y2 as integer,_
			         byval x3 as integer, byval y3 as integer, byval gl2dcolor as GLuint )

	glDisable( GL_TEXTURE_2D )
	glColor4ubv( cast( GLubyte ptr, @gl2dcolor ) )

	glBegin( GL_TRIANGLES )
		glVertex2i( x1, y1 )
		glVertex2i( x2, y2 )
		glVertex2i( x3, y3 )
	glEnd()
	
	glEnable( GL_TEXTURE_2D )
	
	glColor4ub(255,255,255,255)
	
end sub

''=============================================================================
''
''   gl2dColor should use GL2D_RGBA()     
''
''=============================================================================
sub TriangleFilledGradient( byval x1 as integer, byval y1 as integer,_ 
							  byval x2 as integer, byval y2 as integer,_
			                  byval x3 as integer, byval y3 as integer,_
			                  byval gl2dcolor1 as GLuint, byval gl2dcolor2 as GLuint, byval gl2dcolor3 as GLuint )

	glDisable( GL_TEXTURE_2D )
	
	glBegin( GL_TRIANGLES )
		glColor4ubv( cast( GLubyte ptr, @gl2dcolor1 ) )
		glVertex2i( x1, y1 )
		glColor4ubv( cast( GLubyte ptr, @gl2dcolor2 ) )
		glVertex2i( x2, y2 )
		glColor4ubv( cast( GLubyte ptr, @gl2dcolor3 ) )
		glVertex2i( x3, y3 )
	glEnd()
	
	glEnable( GL_TEXTURE_2D )
	
	glColor4ub(255,255,255,255)
	
end sub


''=============================================================================
''
''    Draws a circle 
''
''=============================================================================
sub Circle(byval x as integer, byval y as integer, byval radius as integer, byval gl2dcolor as GLuint)

	ellipse(x, y, radius, radius, 0, gl2dcolor )
      	
end sub

''=============================================================================
''
''    Draws a circle 
''
''=============================================================================
sub CircleFilled(byval x as integer, byval y as integer, byval radius as integer, byval gl2dcolor as GLuint )

	EllipseFilled(x, y, radius, radius, 0, gl2dcolor )
    
end sub


''=============================================================================
''
''    Draws an ellipse
''    Contributed by Michael "h4tt3n" Nissen 
''    syntax: ellipse(center x, center y, semimajor axis, semiminor axis, angle in radians, color)
''
''=============================================================================

sub Ellipse(byval x as single, byval y as single, byval a as single, byval b as single, byval angle as single, byval gl2dcolor as GLuint )
       
	'' these constants decide the graphic quality of the ellipse
	const as single  pi = 4*atn(1)        ''        pi
	const as single  twopi  = 2*pi        ''        two pi (radians in a circle)
	const as integer face_length  = 8     ''        approx. face length in pixels
	const as integer max_faces = 256      ''        maximum number of faces in ellipse
	const as integer min_faces = 16       ''        minimum number of faces in ellipse
	
	'' approx. ellipse circumference (hudson's method)
	dim as single h        = (a-b*a-b)/(a+b*a+b)
	dim as single circumference = 0.25*pi*(a+b)*(3*(1+h*0.25)+1/(1-h*0.25))
	
	'' number of faces in ellipse
	dim as integer num_faces = circumference\face_length
	
	'' clamp number of faces
	if num_faces > max_faces then num_faces = max_faces
	if num_faces < min_faces then num_faces = min_faces
	
	'' keep number of faces divisible by 4
	num_faces -= num_faces mod 4
	
	'' precalc cosine theta
	dim as double s         = sin(twopi/num_faces)
	dim as double c         = cos(twopi/num_faces)
	dim as double xx        = 1
	dim as double yy        = 0
	dim as double xt        = 0
	dim as double ax  = cos(angle)
	dim as double ay  = sin(angle)
	
	
	'' draw ellipse
	glDisable( GL_TEXTURE_2D )	
	glColor4ubv( cast( GLubyte ptr, @gl2dcolor ) )

	glBegin(GL_LINE_LOOP)
	
		for i as integer = 1 to num_faces-1
			xt = xx
			xx = c * xx - s * yy
			yy = s * xt + c * yy
			glvertex2f(x+a*xx*ax-b*yy*ay, y+a*xx*ay+b*yy*ax)
		next
		glVertex2f(x+a*ax, y+a*ay)
	
	glEnd()

	glEnable( GL_TEXTURE_2D )
	
	glColor4ub(255,255,255,255)
 
end sub


''=============================================================================
''
''    Draws an ellipse
''    Contributed by Michael "h4tt3n" Nissen(I added a filled version ;*)) 
''    syntax: ellipse_filled(center x, center y, semimajor axis, semiminor axis, angle in radians, color)
''
''=============================================================================

sub EllipseFilled(byval x as single, byval y as single, byval a as single, byval b as single, byval angle as single, byval gl2dcolor as GLuint )
       
	'' these constants decide the graphic quality of the ellipse
	const as single  pi = 4*atn(1)        ''        pi
	const as single  twopi  = 2*pi        ''        two pi (radians in a circle)
	const as integer face_length  = 8     ''        approx. face length in pixels
	const as integer max_faces = 256      ''        maximum number of faces in ellipse
	const as integer min_faces = 16       ''        minimum number of faces in ellipse
	
	'' approx. ellipse circumference (hudson's method)
	dim as single h        = (a-b*a-b)/(a+b*a+b)
	dim as single circumference = 0.25*pi*(a+b)*(3*(1+h*0.25)+1/(1-h*0.25))
	
	'' number of faces in ellipse
	dim as integer num_faces = circumference\face_length
	
	'' clamp number of faces
	if num_faces > max_faces then num_faces = max_faces
	if num_faces < min_faces then num_faces = min_faces
	
	'' keep number of faces divisible by 4
	num_faces -= num_faces mod 4
	
	'' precalc cosine theta
	dim as double s         = sin(twopi/num_faces)
	dim as double c         = cos(twopi/num_faces)
	dim as double xx        = 1
	dim as double yy        = 0
	dim as double xt        = 0
	dim as double ax  = cos(angle)
	dim as double ay  = sin(angle)
	
	
	'' draw ellipse
	glDisable( GL_TEXTURE_2D )	
	glColor4ubv( cast( GLubyte ptr, @gl2dcolor ) )

	glBegin(GL_TRIANGLE_FAN)
	
		for i as integer = 1 to num_faces-1
			xt = xx
			xx = c * xx - s * yy
			yy = s * xt + c * yy
			glvertex2f(x+a*xx*ax-b*yy*ay, y+a*xx*ay+b*yy*ax)
		next
		glVertex2f(x+a*ax, y+a*ay)
	
	glEnd()

	glEnable( GL_TEXTURE_2D )
	
	glColor4ub(255,255,255,255)
 
end sub

''=============================================================================
''
''    Draws a 2d sprite 
''
''=============================================================================
sub Sprite( byval x as integer, byval y as integer, byval mode as GL2D_FLIP_MODE, byval spr as image ptr)
	
	dim as integer x1 = x
    dim as integer y1 = y
    dim as integer x2 = x + spr->width
    dim as integer y2 = y + spr->height

	dim as single u_off = spr->u_offset/spr->texture_width
	dim as single v_off = spr->v_offset/spr->texture_height
	
	dim as single u_width = spr->width/spr->texture_width
	dim as single v_height = spr->height/spr->texture_height
	
	
    dim as single u1 = iif( mode and FLIP_H, u_off + u_width , u_off	        )
    dim as single u2 = iif( mode and FLIP_H, u_off 			 , u_off + u_width  )
    dim as single v1 = iif( mode and FLIP_V, v_off + v_height, v_off			)
    dim as single v2 = iif( mode and FLIP_V, v_off			 , v_off + v_height )


    '' Only change active texture when there is a need
	'' Speeds up the rendering by batching textures
	if ( spr->textureID <> current_texture ) then
		glBindTexture(GL_TEXTURE_2D, spr->textureID)
		current_texture = spr->textureID
	endif
	
    glBegin( GL_QUADS )

        glTexCoord2f( u1, v1 ): glVertex2i( x1, y1 )
        glTexCoord2f( u1, v2 ): glVertex2i( x1, y2 )
        glTexCoord2f( u2, v2 ): glVertex2i( x2, y2 )
        glTexCoord2f( u2, v1 ): glVertex2i( x2, y1 )

    glEnd()

end sub


''=============================================================================
''
''    Draws a scaled 2d sprite 
''    having a scale of 1.0 gives you the original size
''
''=============================================================================
sub SpriteScale( byval x as integer, byval y as integer, byval scale as single, byval mode as GL2D_FLIP_MODE, byval spr as image ptr)
	
	dim  as integer x1 = 0
	dim  as integer y1 = 0
	dim  as integer x2 = (spr->width)
	dim  as integer y2 = (spr->height)
	
	dim as single u_off = spr->u_offset/spr->texture_width
	dim as single v_off = spr->v_offset/spr->texture_height
	
	dim as single u_width = spr->width/spr->texture_width
	dim as single v_height = spr->height/spr->texture_height
	
	
	dim as single u1 = iif( mode and FLIP_H, u_off + u_width , u_off	        )
    dim as single u2 = iif( mode and FLIP_H, u_off 			 , u_off + u_width  )
    dim as single v1 = iif( mode and FLIP_V, v_off + v_height, v_off			)
    dim as single v2 = iif( mode and FLIP_V, v_off			 , v_off + v_height )

	'' Only change active texture when there is a need
	'' Speeds up the rendering by batching textures
	if ( spr->textureID <> current_texture ) then
		glBindTexture(GL_TEXTURE_2D, spr->textureID)
		current_texture = spr->textureID
	endif
	
	glPushMatrix()
	
		glTranslatef(x, y, 0)
		
		glScalef(scale,scale,1.0)
		
		glBegin( GL_QUADS )
	
	        glTexCoord2f( u1, v1 ): glVertex2i( x1, y1 )
	        glTexCoord2f( u1, v2 ): glVertex2i( x1, y2 )
	        glTexCoord2f( u2, v2 ): glVertex2i( x2, y2 )
	        glTexCoord2f( u2, v1 ): glVertex2i( x2, y1 )
	
	    glEnd()

	glPopMatrix()
	
end sub

''=============================================================================
''
''    Draws a scaled 2d sprite 
''    having a scale of 1.0 gives you the original size
''
''=============================================================================
sub SpriteScaleXY( byval x as integer, byval y as integer, byval scaleX as single, byval scaleY as single, byval mode as GL2D_FLIP_MODE, byval spr as image ptr)
	
	dim  as integer x1 = 0
	dim  as integer y1 = 0
	dim  as integer x2 = (spr->width)
	dim  as integer y2 = (spr->height)
	
	dim as single u_off = spr->u_offset/spr->texture_width
	dim as single v_off = spr->v_offset/spr->texture_height
	
	dim as single u_width = spr->width/spr->texture_width
	dim as single v_height = spr->height/spr->texture_height
	
	
	dim as single u1 = iif( mode and FLIP_H, u_off + u_width , u_off	        )
    dim as single u2 = iif( mode and FLIP_H, u_off 			 , u_off + u_width  )
    dim as single v1 = iif( mode and FLIP_V, v_off + v_height, v_off			)
    dim as single v2 = iif( mode and FLIP_V, v_off			 , v_off + v_height )

	'' Only change active texture when there is a need
	'' Speeds up the rendering by batching textures
	if ( spr->textureID <> current_texture ) then
		glBindTexture(GL_TEXTURE_2D, spr->textureID)
		current_texture = spr->textureID
	endif
	
	glPushMatrix()
	
		glTranslatef(x, y, 0)
		
		glScalef(scaleX,scaleY,1.0)
		
		glBegin( GL_QUADS )
	
	        glTexCoord2f( u1, v1 ): glVertex2i( x1, y1 )
	        glTexCoord2f( u1, v2 ): glVertex2i( x1, y2 )
	        glTexCoord2f( u2, v2 ): glVertex2i( x2, y2 )
	        glTexCoord2f( u2, v1 ): glVertex2i( x2, y1 )
	
	    glEnd()

	glPopMatrix()
	
end sub

''=============================================================================
''
''    Draws a center-rotated 2d sprite 
''
''=============================================================================
sub SpriteRotate( byval x as integer, byval y as integer, byval angle as integer, byval mode as GL2D_FLIP_MODE, byval spr as image ptr)
	
	dim as integer s_half_x = spr->width\2
	dim as integer s_half_y = spr->height\2
	
	dim as integer x1 =  -s_half_x
	dim as integer y1 =  -s_half_y
	
	dim as integer x2 =  s_half_x
	dim as integer y2 =  s_half_y
	
	dim as single u_off = spr->u_offset/spr->texture_width
	dim as single v_off = spr->v_offset/spr->texture_height
	
	dim as single u_width = spr->width/spr->texture_width
	dim as single v_height = spr->height/spr->texture_height
	
	dim as single u1 = iif( mode and FLIP_H, u_off + u_width , u_off	        )
    dim as single u2 = iif( mode and FLIP_H, u_off 			 , u_off + u_width  )
    dim as single v1 = iif( mode and FLIP_V, v_off + v_height, v_off			)
    dim as single v2 = iif( mode and FLIP_V, v_off			 , v_off + v_height )

	'' Only change active texture when there is a need
	'' Speeds up the rendering by batching textures
	if ( spr->textureID <> current_texture ) then
		glBindTexture(GL_TEXTURE_2D, spr->textureID)
		current_texture = spr->textureID
	endif
	
	
	
	
	glPushMatrix()
	
		glTranslatef(x, y, 0)
		glRotatef(angle,0,0,1)
		
		glBegin( GL_QUADS )
	
	        glTexCoord2f( u1, v1 ): glVertex2i( x1, y1 )
	        glTexCoord2f( u1, v2 ): glVertex2i( x1, y2 )
	        glTexCoord2f( u2, v2 ): glVertex2i( x2, y2 )
	        glTexCoord2f( u2, v1 ): glVertex2i( x2, y1 )
	
	    glEnd()
	
	glPopmatrix()
	
end sub

''=============================================================================
''
''    Draws a center-rotated and scaled 2d sprite 
''
''=============================================================================
sub SpriteRotateScale( byval x as integer, byval y as integer, byval angle as integer, byval scale as single, byval mode as GL2D_FLIP_MODE, byval spr as image ptr)
	
	dim as integer s_half_x = spr->width\2
	dim as integer s_half_y = spr->height\2
	
	dim as integer x1 =  -s_half_x
	dim as integer y1 =  -s_half_y
	
	dim as integer x2 =  s_half_x
	dim as integer y2 =  s_half_y
	
	dim as single u_off = spr->u_offset/spr->texture_width
	dim as single v_off = spr->v_offset/spr->texture_height
	
	dim as single u_width = spr->width/spr->texture_width
	dim as single v_height = spr->height/spr->texture_height
	
	dim as single u1 = iif( mode and FLIP_H, u_off + u_width , u_off	        )
    dim as single u2 = iif( mode and FLIP_H, u_off 			 , u_off + u_width  )
    dim as single v1 = iif( mode and FLIP_V, v_off + v_height, v_off			)
    dim as single v2 = iif( mode and FLIP_V, v_off			 , v_off + v_height )

	'' Only change active texture when there is a need
	'' Speeds up the rendering by batching textures
	if ( spr->textureID <> current_texture ) then
		glBindTexture(GL_TEXTURE_2D, spr->textureID)
		current_texture = spr->textureID
	endif
	
	
	
	
	glPushMatrix()
	
		glTranslatef(x, y, 0)
		glScalef(scale,scale,1.0)
		glRotatef(angle,0,0,1)
		
		glBegin( GL_QUADS )

	        glTexCoord2f( u1, v1 ): glVertex2i( x1, y1 )
	        glTexCoord2f( u1, v2 ): glVertex2i( x1, y2 )
	        glTexCoord2f( u2, v2 ): glVertex2i( x2, y2 )
	        glTexCoord2f( u2, v1 ): glVertex2i( x2, y1 )

    	glEnd()

	glPopmatrix()
	
end sub


''=============================================================================
''
''    Draws a center-rotated and scaled 2d sprite 
''
''=============================================================================
sub SpriteRotateScaleXY( byval x as integer, byval y as integer, byval angle as integer, byval scaleX as single, byval scaleY as single, byval mode as GL2D_FLIP_MODE, byval spr as image ptr)
	
	dim as integer s_half_x = spr->width\2
	dim as integer s_half_y = spr->height\2
	
	dim as integer x1 =  -s_half_x
	dim as integer y1 =  -s_half_y
	
	dim as integer x2 =  s_half_x
	dim as integer y2 =  s_half_y
	
	dim as single u_off = spr->u_offset/spr->texture_width
	dim as single v_off = spr->v_offset/spr->texture_height
	
	dim as single u_width = spr->width/spr->texture_width
	dim as single v_height = spr->height/spr->texture_height
	
	dim as single u1 = iif( mode and FLIP_H, u_off + u_width , u_off	        )
    dim as single u2 = iif( mode and FLIP_H, u_off 			 , u_off + u_width  )
    dim as single v1 = iif( mode and FLIP_V, v_off + v_height, v_off			)
    dim as single v2 = iif( mode and FLIP_V, v_off			 , v_off + v_height )

	'' Only change active texture when there is a need
	'' Speeds up the rendering by batching textures
	if ( spr->textureID <> current_texture ) then
		glBindTexture(GL_TEXTURE_2D, spr->textureID)
		current_texture = spr->textureID
	endif
	
	
	
	
	glPushMatrix()
	
		glTranslatef(x, y, 0)
		glScalef(scaleX,scaleY,1.0)
		glRotatef(angle,0,0,1)
		
		glBegin( GL_QUADS )

	        glTexCoord2f( u1, v1 ): glVertex2i( x1, y1 )
	        glTexCoord2f( u1, v2 ): glVertex2i( x1, y2 )
	        glTexCoord2f( u2, v2 ): glVertex2i( x2, y2 )
	        glTexCoord2f( u2, v1 ): glVertex2i( x2, y1 )

    	glEnd()

	glPopmatrix()
	
end sub

''=============================================================================
''
''    Draws a stretched 2d sprite 
''
''=============================================================================
sub SpriteOnBox( byval x1 as integer, byval y1 as integer,_
				 byval x2 as integer, byval y2 as integer,_
				 byval mode as GL2D_FLIP_MODE, byval spr as image ptr)
	
	dim as single u_off = spr->u_offset/spr->texture_width
	dim as single v_off = spr->v_offset/spr->texture_height
	
	dim as single u_width = spr->width/spr->texture_width
	dim as single v_height = spr->height/spr->texture_height
	
	dim as single u1 = iif( mode and FLIP_H, u_off + u_width , u_off	        )
    dim as single u2 = iif( mode and FLIP_H, u_off 			 , u_off + u_width  )
    dim as single v1 = iif( mode and FLIP_V, v_off + v_height, v_off			)
    dim as single v2 = iif( mode and FLIP_V, v_off			 , v_off + v_height )

	'' Only change active texture when there is a need
	'' Speeds up the rendering by batching textures
	if ( spr->textureID <> current_texture ) then
		glBindTexture(GL_TEXTURE_2D, spr->textureID)
		current_texture = spr->textureID
	endif
	
	glBegin( GL_QUADS )

        glTexCoord2f( u1, v1 ): glVertex2i( x1, y1 )
        glTexCoord2f( u1, v2 ): glVertex2i( x1, y2 )
        glTexCoord2f( u2, v2 ): glVertex2i( x2, y2 )
        glTexCoord2f( u2, v1 ): glVertex2i( x2, y1 )

   	glEnd()

end sub


''=============================================================================
''
''    Draws a quad-stretched 2d sprite 
''
''=============================================================================
sub SpriteOnQuad( byval x1 as integer, byval y1 as integer,_
				  byval x2 as integer, byval y2 as integer,_
				  byval x3 as integer, byval y3 as integer,_
				  byval x4 as integer, byval y4 as integer,_
				  byval mode as GL2D_FLIP_MODE, byval spr as image ptr)
	
	dim as single u_off = spr->u_offset/spr->texture_width
	dim as single v_off = spr->v_offset/spr->texture_height
	
	dim as single u_width = spr->width/spr->texture_width
	dim as single v_height = spr->height/spr->texture_height
	
	dim as single u1 = iif( mode and FLIP_H, u_off + u_width , u_off	        )
    dim as single u2 = iif( mode and FLIP_H, u_off 			 , u_off + u_width  )
    dim as single v1 = iif( mode and FLIP_V, v_off + v_height, v_off			)
    dim as single v2 = iif( mode and FLIP_V, v_off			 , v_off + v_height )

	'' Only change active texture when there is a need
	'' Speeds up the rendering by batching textures
	if ( spr->textureID <> current_texture ) then
		glBindTexture(GL_TEXTURE_2D, spr->textureID)
		current_texture = spr->textureID
	endif
	
	glBegin( GL_QUADS )

        glTexCoord2f( u1, v1 ): glVertex2i( x1, y1 )
        glTexCoord2f( u1, v2 ): glVertex2i( x1, y2 )
        glTexCoord2f( u2, v2 ): glVertex2i( x2, y2 )
        glTexCoord2f( u2, v1 ): glVertex2i( x2, y1 )

   	glEnd()

end sub

sub SpriteStretch( byval x as integer, byval y as integer, byval length as integer, byval height as integer, byval spr as image ptr )
	
	
	dim as integer hw = (spr->width\2)
	dim as integer hh = (spr->height\2)

	dim as integer x1 = x
	dim as integer y1 = y
	dim as integer x2 = x + length
	dim as integer y2 = y + height
	
	dim as single u_off = spr->u_offset/spr->texture_width
	dim as single v_off = spr->v_offset/spr->texture_height
	
	dim as single u_width = spr->width/spr->texture_width
	dim as single v_height = spr->height/spr->texture_height

	dim as single su = u_width/2
	dim as single tv = v_height/2
		
	'' Only change active texture when there is a need
	'' Speeds up the rendering by batching textures
	if ( spr->textureID <> current_texture ) then
		glBindTexture(GL_TEXTURE_2D, spr->textureID)
		current_texture = spr->textureID
	endif

	'' variables
	
	dim as integer xh1 = x1 + hw
	dim as integer yh1 = y1 + hh
	dim as integer xh2 = x2 - hw
	dim as integer yh2 = y2 - hh
	
	'' top-left
	glBegin( GL_QUADS )
		glTexCoord2f( u_off, v_off )
		glVertex2i( x1, y1 )
		
		glTexCoord2f( u_off, v_off + tv )
		glVertex2i( x1, yh1 )
		
		glTexCoord2f( u_off + su, v_off + tv )
		glVertex2i( xh1, yh1 )
		
		glTexCoord2f( u_off + su, v_off )
		glVertex2i( xh1, y1 )
	glEnd()
	
	'' top-right
	glBegin( GL_QUADS )
		glTexCoord2f( u_off + su, v_off )
		glVertex2i( xh2, y1 )
		
		glTexCoord2f( u_off + su, v_off + tv )
		glVertex2i( xh2, yh1 )
		
		glTexCoord2f( u_off + u_width, v_off + tv )
		glVertex2i( x2, yh1 )
		
		glTexCoord2f( u_off + u_width, v_off )
		glVertex2i( x2, y1 )
	glEnd()

	'' bottom left
	glBegin( GL_QUADS )
		glTexCoord2f( u_off, v_off + tv)
		glVertex2i( x1, yh2 )
		
		glTexCoord2f( u_off, v_off + v_height )
		glVertex2i( x1, y2 )
		
		glTexCoord2f( u_off + su, v_off + v_height )
		glVertex2i( xh1, y2 )
		
		glTexCoord2f( u_off + su, v_off + tv )
		glVertex2i( xh1, yh2 )
	glEnd()
	
	'' bottom - right
	glBegin( GL_QUADS )
		glTexCoord2f( u_off + su, v_off + tv )
		glVertex2i( xh2,yh2 )
		
		glTexCoord2f( u_off + su, v_off + v_height )
		glVertex2i( xh2, y2 )
		
		glTexCoord2f( u_off + u_width, v_off + v_height )
		glVertex2i( x2, y2 )
		
		glTexCoord2f( u_off + u_width, v_off + tv )
		glVertex2i( x2, yh2 )
	glEnd()

	'' top-border
	glBegin( GL_QUADS )
		glTexCoord2f( u_off + su, v_off )
		glVertex2i( xh1,y1 )
				
		glTexCoord2f( u_off + su, v_off + tv )
		glVertex2i( xh1,yh1 )
		
		glTexCoord2f( u_off + su, v_off + tv )
		glVertex2i( xh2, yh1 )
		
		glTexCoord2f( u_off + su, v_off )
		glVertex2i( xh2, y1 )
	glEnd()
	
	'' bottom-border
	glBegin( GL_QUADS )
		glTexCoord2f( u_off + su, v_off + tv)
		glVertex2i( xh1,yh2 )
				
		glTexCoord2f( u_off + su, v_off + v_height )
		glVertex2i( xh1,y2 )
		
		glTexCoord2f( u_off + su, v_off + v_height )
		glVertex2i( xh2, y2 )
		
		glTexCoord2f( u_off + su, v_off + tv)
		glVertex2i( xh2, yh2 )
	glEnd()
	
	'' left-border
	glBegin( GL_QUADS )
		glTexCoord2f( u_off, v_off + tv)
		glVertex2i( x1,yh1 )
				
		glTexCoord2f( u_off, v_off + tv )
		glVertex2i( x1,yh2 )
		
		glTexCoord2f( u_off + su, v_off + tv )
		glVertex2i( xh1, yh2 )
		
		glTexCoord2f( u_off + su, v_off + tv )
		glVertex2i( xh1, yh1 )
	glEnd()
	
	'' right-border
	glBegin( GL_QUADS )
		glTexCoord2f( u_off + su, v_off + tv)
		glVertex2i( xh2,yh1 )
				
		glTexCoord2f( u_off + su, v_off + tv )
		glVertex2i( xh2,yh2 )
		
		glTexCoord2f( u_off + u_width, v_off + tv )
		glVertex2i( x2, yh2 )
		
		glTexCoord2f( u_off + u_width, v_off + tv )
		glVertex2i( x2, yh1 )
	glEnd()
	
	'' center
	glBegin( GL_QUADS )
	
		glTexCoord2f( u_off + su, v_off + tv )
		glVertex2i( xh1,yh1 )
				
		glTexCoord2f( u_off + su, v_off + tv )
		glVertex2i( xh1,yh2 )
		
		glTexCoord2f( u_off + su, v_off + tv )
		glVertex2i( xh2, yh2 )
		
		glTexCoord2f( u_off + su, v_off + tv )
		glVertex2i( xh2, yh1 )
		
	glEnd()
	
end sub




sub SpriteStretchHorizontal( byval x as integer, byval y as integer, byval length as integer, byval spr as image ptr )
	
	
	dim as integer hw = (spr->width\2)

	dim as integer x1 = x
	dim as integer y1 = y
	dim as integer x2 = x + length
	dim as integer y2 = y + spr->height
	
	dim as single u_off = spr->u_offset/spr->texture_width
	dim as single v_off = spr->v_offset/spr->texture_height
	
	dim as single u_width = spr->width/spr->texture_width
	dim as single v_height = spr->height/spr->texture_height

	dim as single su = u_width/2
	
		
	'' Only change active texture when there is a need
	'' Speeds up the rendering by batching textures
	if ( spr->textureID <> current_texture ) then
		glBindTexture(GL_TEXTURE_2D, spr->textureID)
		current_texture = spr->textureID
	endif

	'' left
	dim as integer x2l = x1 + hw
	glBegin(GL_QUADS)
	
		glTexcoord2f(u_off, v_off)
		glVertex2i(x1,y1)
		
		glTexcoord2f(u_off, v_off + v_height)
		glVertex2i(x1,y2)
		
		glTexcoord2f(u_off + su, v_off + v_height)
		glVertex2i(x2l,y2)
		
		glTexcoord2f(u_off + su, v_off)
		glVertex2i(x2l,y1)
		
	glEnd()
	
	'' center
	dim as integer x1l = x + hw
	x2l = x2 - hw -1 
	glBegin(GL_QUADS)
	
		glTexcoord2f(u_off + su, v_off)
		glVertex2i(x1l,y1)
				
		glTexcoord2f(u_off + su, v_off + v_height)
		glVertex2i(x1l,y2)
		
		glTexcoord2f(u_off + su, v_off + v_height)
		glVertex2i(x2l,y2)
		
		glTexcoord2f(u_off + su, v_off)
		glVertex2i(x2l,y1)
		
	glEnd()
	
	'' right
	x1l = x2 - hw -1
	glBegin(GL_QUADS)
	
		glTexcoord2f(u_off + su, v_off)
		glVertex2i(x1l,y1)
		
		glTexcoord2f(u_off + su, v_off + v_height)
		glVertex2i(x1l,y2)
		
		glTexcoord2f(u_off + u_width, v_off + v_height)
		glVertex2i(x2,y2)
		
		glTexcoord2f(u_off + u_width, v_off)
		glVertex2i(x2,y1)
		
	glEnd()
	
end sub


sub SpriteStretchVertical( byval x as integer, byval y as integer, byval height as integer, byval spr as image ptr )
	
	
	dim as integer hh = (spr->height\2)

	dim as integer x1 = x
	dim as integer y1 = y
	dim as integer x2 = x + spr->width
	dim as integer y2 = y + height
	
	dim as single u_off = spr->u_offset/spr->texture_width
	dim as single v_off = spr->v_offset/spr->texture_height
	
	dim as single u_width = spr->width/spr->texture_width
	dim as single v_height = spr->height/spr->texture_height

	dim as single tv = v_height/2
		
	'' Only change active texture when there is a need
	'' Speeds up the rendering by batching textures
	if ( spr->textureID <> current_texture ) then
		glBindTexture(GL_TEXTURE_2D, spr->textureID)
		current_texture = spr->textureID
	endif

	'' top
	dim as integer y21 = y1 + hh
	
	glBegin( GL_QUADS )
	
		glTexCoord2f( u_off, v_off )
		glVertex2i( x1, y1 )
		
		glTexCoord2f( u_off, v_off + tv )
		glVertex2i( x1, y21 )
		
		glTexCoord2f( u_off + u_width, v_off + tv )
		glVertex2i( x2, y21 )
		
		glTexCoord2f( u_off + u_width, v_off )
		glVertex2i( x2, y1 )
		
	glEnd()
	
	'' center
	dim as integer y11 = y + hh
	y21 = y2 - hh - 1
	
	glBegin( GL_QUADS )
	
		glTexCoord2f( u_off, v_off + tv )
		glVertex2i( x1,y11 )
				
		glTexCoord2f( u_off, v_off + tv )
		glVertex2i( x1,y21 )
		
		glTexCoord2f( u_off + u_width, v_off + tv )
		glVertex2i( x2, y21 )
		
		glTexCoord2f( u_off + u_width, v_off + tv )
		glVertex2i( x2, y11 )
		
	glEnd()
	
	'' bottom
	y11 = y2 - hh - 1
	
	glBegin( GL_QUADS )
	
		glTexCoord2f( u_off, v_off + tv )
		glVertex2i( x1,y11 )
		
		glTexCoord2f( u_off, v_off + v_height )
		glVertex2i( x1, y2 )
		
		glTexCoord2f( u_off + u_width, v_off + v_height )
		glVertex2i( x2, y2 )
		
		glTexCoord2f( u_off + u_width, v_off + tv )
		glVertex2i( x2, y11 )
		
	glEnd()
	
end sub


''=============================================================================
''
''    special function to get a particle texture 
''
''=============================================================================
private function get_glow_image() as GLuint
	
	static as GLuint textureID = 0
	 
	if textureID = 0 then
		
		const IMAGE_WIDTH = 32, IMAGE_HEIGHT = 32, IMAGE_BITDEPTH = 24
		dim as uinteger image_array(0 to 1031) => { _
	    &H00000007, &H00000004, &H00000020, &H00000020, &H00000080, &H00000000, _
	    &H00000000, &H00000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF010101, &HFF010101, &HFF020202, _
	    &HFF020202, &HFF030303, &HFF030303, &HFF030303, &HFF020202, &HFF020202, _
	    &HFF010101, &HFF010101, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF010101, &HFF020202, &HFF030303, _
	    &HFF040404, &HFF050505, &HFF060606, &HFF060606, &HFF060606, &HFF060606, _
	    &HFF060606, &HFF050505, &HFF040404, &HFF030303, &HFF020202, &HFF010101, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF010101, &HFF020202, &HFF040404, _
	    &HFF050505, &HFF070707, &HFF080808, &HFF090909, &HFF0A0A0A, &HFF0B0B0B, _
	    &HFF0B0B0B, &HFF0B0B0B, &HFF0A0A0A, &HFF090909, &HFF080808, &HFF070707, _
	    &HFF050505, &HFF040404, &HFF020202, &HFF010101, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF010101, &HFF030303, _
	    &HFF050505, &HFF070707, &HFF090909, &HFF0B0B0B, &HFF0C0C0C, &HFF0E0E0E, _
	    &HFF0F0F0F, &HFF0F0F0F, &HFF101010, &HFF0F0F0F, &HFF0F0F0F, &HFF0E0E0E, _
	    &HFF0C0C0C, &HFF0B0B0B, &HFF090909, &HFF070707, &HFF050505, &HFF030303, _
	    &HFF010101, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF010101, _
	    &HFF030303, &HFF060606, &HFF080808, &HFF0B0B0B, &HFF0D0D0D, &HFF0F0F0F, _
	    &HFF111111, &HFF131313, &HFF141414, &HFF151515, &HFF151515, &HFF151515, _
	    &HFF141414, &HFF131313, &HFF111111, &HFF0F0F0F, &HFF0D0D0D, &HFF0B0B0B, _
	    &HFF080808, &HFF060606, &HFF030303, &HFF010101, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF010101, &HFF030303, &HFF060606, &HFF090909, &HFF0C0C0C, &HFF0E0E0E, _
	    &HFF121212, &HFF141414, &HFF161616, &HFF181818, &HFF191919, &HFF1A1A1A, _
	    &HFF1B1B1B, &HFF1A1A1A, &HFF191919, &HFF181818, &HFF161616, &HFF141414, _
	    &HFF121212, &HFF0E0E0E, &HFF0C0C0C, &HFF090909, &HFF060606, &HFF030303, _
	    &HFF010101, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF010101, &HFF030303, &HFF060606, &HFF090909, &HFF0C0C0C, _
	    &HFF0F0F0F, &HFF131313, &HFF161616, &HFF191919, &HFF1B1B1B, &HFF1E1E1E, _
	    &HFF1F1F1F, &HFF202020, &HFF212121, &HFF202020, &HFF1F1F1F, &HFF1E1E1E, _
	    &HFF1B1B1B, &HFF191919, &HFF161616, &HFF131313, &HFF0F0F0F, &HFF0C0C0C, _
	    &HFF090909, &HFF060606, &HFF030303, &HFF010101, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF020202, &HFF050505, &HFF080808, _
	    &HFF0C0C0C, &HFF0F0F0F, &HFF131313, &HFF171717, &HFF1B1B1B, &HFF1E1E1E, _
	    &HFF212121, &HFF232323, &HFF252525, &HFF262626, &HFF272727, &HFF262626, _
	    &HFF252525, &HFF232323, &HFF212121, &HFF1E1E1E, &HFF1B1B1B, &HFF171717, _
	    &HFF131313, &HFF0F0F0F, &HFF0C0C0C, &HFF080808, &HFF050505, &HFF020202, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF010101, &HFF040404, _
	    &HFF070707, &HFF0B0B0B, &HFF0E0E0E, &HFF131313, &HFF171717, &HFF1B1B1B, _
	    &HFF1F1F1F, &HFF232323, &HFF262626, &HFF292929, &HFF2B2B2B, &HFF2C2C2C, _
	    &HFF2C2C2C, &HFF2C2C2C, &HFF2B2B2B, &HFF292929, &HFF262626, &HFF232323, _
	    &HFF1F1F1F, &HFF1B1B1B, &HFF171717, &HFF131313, &HFF0E0E0E, &HFF0B0B0B, _
	    &HFF070707, &HFF040404, &HFF010101, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF020202, &HFF050505, &HFF090909, &HFF0D0D0D, &HFF121212, &HFF161616, _
	    &HFF1B1B1B, &HFF1F1F1F, &HFF242424, &HFF282828, &HFF2B2B2B, &HFF2E2E2E, _
	    &HFF313131, &HFF323232, &HFF323232, &HFF323232, &HFF313131, &HFF2E2E2E, _
	    &HFF2B2B2B, &HFF282828, &HFF242424, &HFF1F1F1F, &HFF1B1B1B, &HFF161616, _
	    &HFF121212, &HFF0D0D0D, &HFF090909, &HFF050505, &HFF020202, &HFF000000, _
	    &HFF000000, &HFF010101, &HFF030303, &HFF070707, &HFF0B0B0B, &HFF0F0F0F, _
	    &HFF141414, &HFF191919, &HFF1E1E1E, &HFF232323, &HFF282828, &HFF2C2C2C, _
	    &HFF303030, &HFF333333, &HFF363636, &HFF383838, &HFF383838, &HFF383838, _
	    &HFF363636, &HFF333333, &HFF303030, &HFF2C2C2C, &HFF282828, &HFF232323, _
	    &HFF1E1E1E, &HFF191919, &HFF141414, &HFF0F0F0F, &HFF0B0B0B, &HFF070707, _
	    &HFF030303, &HFF010101, &HFF000000, &HFF010101, &HFF040404, &HFF080808, _
	    &HFF0C0C0C, &HFF111111, &HFF161616, &HFF1B1B1B, &HFF212121, &HFF262626, _
	    &HFF2B2B2B, &HFF303030, &HFF343434, &HFF383838, &HFF3B3B3B, &HFF3D3D3D, _
	    &HFF3D3D3D, &HFF3D3D3D, &HFF3B3B3B, &HFF383838, &HFF343434, &HFF303030, _
	    &HFF2B2B2B, &HFF262626, &HFF212121, &HFF1B1B1B, &HFF161616, &HFF111111, _
	    &HFF0C0C0C, &HFF080808, &HFF040404, &HFF010101, &HFF000000, &HFF020202, _
	    &HFF050505, &HFF090909, &HFF0E0E0E, &HFF131313, &HFF181818, &HFF1E1E1E, _
	    &HFF232323, &HFF292929, &HFF2E2E2E, &HFF333333, &HFF383838, &HFF3C3C3C, _
	    &HFF3F3F3F, &HFF424242, &HFF424242, &HFF424242, &HFF3F3F3F, &HFF3C3C3C, _
	    &HFF383838, &HFF333333, &HFF2E2E2E, &HFF292929, &HFF232323, &HFF1E1E1E, _
	    &HFF181818, &HFF131313, &HFF0E0E0E, &HFF090909, &HFF050505, &HFF020202, _
	    &HFF000000, &HFF020202, &HFF060606, &HFF0A0A0A, &HFF0F0F0F, &HFF141414, _
	    &HFF191919, &HFF1F1F1F, &HFF252525, &HFF2B2B2B, &HFF313131, &HFF363636, _
	    &HFF3B3B3B, &HFF3F3F3F, &HFF434343, &HFF454545, &HFF474747, &HFF454545, _
	    &HFF434343, &HFF3F3F3F, &HFF3B3B3B, &HFF363636, &HFF313131, &HFF2B2B2B, _
	    &HFF252525, &HFF1F1F1F, &HFF191919, &HFF141414, &HFF0F0F0F, &HFF0A0A0A, _
	    &HFF060606, &HFF020202, &HFF000000, &HFF030303, &HFF060606, &HFF0B0B0B, _
	    &HFF0F0F0F, &HFF151515, &HFF1A1A1A, &HFF202020, &HFF262626, &HFF2C2C2C, _
	    &HFF323232, &HFF383838, &HFF3D3D3D, &HFF424242, &HFF454545, &HFFAEAEAE, _
	    &HFFD3D3D3, &HFF454545, &HFF454545, &HFF424242, &HFF3D3D3D, &HFF383838, _
	    &HFF323232, &HFF2C2C2C, &HFF262626, &HFF202020, &HFF1A1A1A, &HFF151515, _
	    &HFF0F0F0F, &HFF0B0B0B, &HFF060606, &HFF030303, &HFF000000, &HFF030303, _
	    &HFF060606, &HFF0B0B0B, &HFF101010, &HFF151515, &HFF1B1B1B, &HFF212121, _
	    &HFF272727, &HFF2C2C2C, &HFF323232, &HFF383838, &HFF3D3D3D, &HFF424242, _
	    &HFF474747, &HFFD3D3D3, &HFFFFFFFF, &HFF454545, &HFF474747, &HFF424242, _
	    &HFF3D3D3D, &HFF383838, &HFF323232, &HFF2C2C2C, &HFF272727, &HFF212121, _
	    &HFF1B1B1B, &HFF151515, &HFF101010, &HFF0B0B0B, &HFF060606, &HFF030303, _
	    &HFF000000, &HFF030303, &HFF060606, &HFF0B0B0B, &HFF0F0F0F, &HFF151515, _
	    &HFF1A1A1A, &HFF202020, &HFF262626, &HFF2C2C2C, &HFF323232, &HFF383838, _
	    &HFF3D3D3D, &HFF424242, &HFF454545, &HFF454545, &HFF454545, &HFF454545, _
	    &HFF454545, &HFF424242, &HFF3D3D3D, &HFF383838, &HFF323232, &HFF2C2C2C, _
	    &HFF262626, &HFF202020, &HFF1A1A1A, &HFF151515, &HFF0F0F0F, &HFF0B0B0B, _
	    &HFF060606, &HFF030303, &HFF000000, &HFF020202, &HFF060606, &HFF0A0A0A, _
	    &HFF0F0F0F, &HFF141414, &HFF191919, &HFF1F1F1F, &HFF252525, &HFF2B2B2B, _
	    &HFF313131, &HFF363636, &HFF3B3B3B, &HFF3F3F3F, &HFF434343, &HFF454545, _
	    &HFF474747, &HFF454545, &HFF434343, &HFF3F3F3F, &HFF3B3B3B, &HFF363636, _
	    &HFF313131, &HFF2B2B2B, &HFF252525, &HFF1F1F1F, &HFF191919, &HFF141414, _
	    &HFF0F0F0F, &HFF0A0A0A, &HFF060606, &HFF020202, &HFF000000, &HFF020202, _
	    &HFF050505, &HFF090909, &HFF0E0E0E, &HFF131313, &HFF181818, &HFF1E1E1E, _
	    &HFF232323, &HFF292929, &HFF2E2E2E, &HFF333333, &HFF383838, &HFF3C3C3C, _
	    &HFF3F3F3F, &HFF424242, &HFF424242, &HFF424242, &HFF3F3F3F, &HFF3C3C3C, _
	    &HFF383838, &HFF333333, &HFF2E2E2E, &HFF292929, &HFF232323, &HFF1E1E1E, _
	    &HFF181818, &HFF131313, &HFF0E0E0E, &HFF090909, &HFF050505, &HFF020202, _
	    &HFF000000, &HFF010101, &HFF040404, &HFF080808, &HFF0C0C0C, &HFF111111, _
	    &HFF161616, &HFF1B1B1B, &HFF212121, &HFF262626, &HFF2B2B2B, &HFF303030, _
	    &HFF343434, &HFF383838, &HFF3B3B3B, &HFF3D3D3D, &HFF3D3D3D, &HFF3D3D3D, _
	    &HFF3B3B3B, &HFF383838, &HFF343434, &HFF303030, &HFF2B2B2B, &HFF262626, _
	    &HFF212121, &HFF1B1B1B, &HFF161616, &HFF111111, &HFF0C0C0C, &HFF080808, _
	    &HFF040404, &HFF010101, &HFF000000, &HFF010101, &HFF030303, &HFF070707, _
	    &HFF0B0B0B, &HFF0F0F0F, &HFF141414, &HFF191919, &HFF1E1E1E, &HFF232323, _
	    &HFF282828, &HFF2C2C2C, &HFF303030, &HFF333333, &HFF363636, &HFF383838, _
	    &HFF383838, &HFF383838, &HFF363636, &HFF333333, &HFF303030, &HFF2C2C2C, _
	    &HFF282828, &HFF232323, &HFF1E1E1E, &HFF191919, &HFF141414, &HFF0F0F0F, _
	    &HFF0B0B0B, &HFF070707, &HFF030303, &HFF010101, &HFF000000, &HFF000000, _
	    &HFF020202, &HFF050505, &HFF090909, &HFF0D0D0D, &HFF121212, &HFF161616, _
	    &HFF1B1B1B, &HFF1F1F1F, &HFF242424, &HFF282828, &HFF2B2B2B, &HFF2E2E2E, _
	    &HFF313131, &HFF323232, &HFF323232, &HFF323232, &HFF313131, &HFF2E2E2E, _
	    &HFF2B2B2B, &HFF282828, &HFF242424, &HFF1F1F1F, &HFF1B1B1B, &HFF161616, _
	    &HFF121212, &HFF0D0D0D, &HFF090909, &HFF050505, &HFF020202, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF010101, &HFF040404, &HFF070707, &HFF0B0B0B, _
	    &HFF0E0E0E, &HFF131313, &HFF171717, &HFF1B1B1B, &HFF1F1F1F, &HFF232323, _
	    &HFF262626, &HFF292929, &HFF2B2B2B, &HFF2C2C2C, &HFF2C2C2C, &HFF2C2C2C, _
	    &HFF2B2B2B, &HFF292929, &HFF262626, &HFF232323, &HFF1F1F1F, &HFF1B1B1B, _
	    &HFF171717, &HFF131313, &HFF0E0E0E, &HFF0B0B0B, &HFF070707, &HFF040404, _
	    &HFF010101, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF020202, _
	    &HFF050505, &HFF080808, &HFF0C0C0C, &HFF0F0F0F, &HFF131313, &HFF171717, _
	    &HFF1B1B1B, &HFF1E1E1E, &HFF212121, &HFF232323, &HFF252525, &HFF262626, _
	    &HFF272727, &HFF262626, &HFF252525, &HFF232323, &HFF212121, &HFF1E1E1E, _
	    &HFF1B1B1B, &HFF171717, &HFF131313, &HFF0F0F0F, &HFF0C0C0C, &HFF080808, _
	    &HFF050505, &HFF020202, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF010101, &HFF030303, &HFF060606, &HFF090909, &HFF0C0C0C, _
	    &HFF0F0F0F, &HFF131313, &HFF161616, &HFF191919, &HFF1B1B1B, &HFF1E1E1E, _
	    &HFF1F1F1F, &HFF202020, &HFF212121, &HFF202020, &HFF1F1F1F, &HFF1E1E1E, _
	    &HFF1B1B1B, &HFF191919, &HFF161616, &HFF131313, &HFF0F0F0F, &HFF0C0C0C, _
	    &HFF090909, &HFF060606, &HFF030303, &HFF010101, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF010101, &HFF030303, _
	    &HFF060606, &HFF090909, &HFF0C0C0C, &HFF0E0E0E, &HFF121212, &HFF141414, _
	    &HFF161616, &HFF181818, &HFF191919, &HFF1A1A1A, &HFF1B1B1B, &HFF1A1A1A, _
	    &HFF191919, &HFF181818, &HFF161616, &HFF141414, &HFF121212, &HFF0E0E0E, _
	    &HFF0C0C0C, &HFF090909, &HFF060606, &HFF030303, &HFF010101, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF010101, &HFF030303, &HFF060606, &HFF080808, &HFF0B0B0B, _
	    &HFF0D0D0D, &HFF0F0F0F, &HFF111111, &HFF131313, &HFF141414, &HFF151515, _
	    &HFF151515, &HFF151515, &HFF141414, &HFF131313, &HFF111111, &HFF0F0F0F, _
	    &HFF0D0D0D, &HFF0B0B0B, &HFF080808, &HFF060606, &HFF030303, &HFF010101, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF010101, &HFF030303, _
	    &HFF050505, &HFF070707, &HFF090909, &HFF0B0B0B, &HFF0C0C0C, &HFF0E0E0E, _
	    &HFF0F0F0F, &HFF0F0F0F, &HFF101010, &HFF0F0F0F, &HFF0F0F0F, &HFF0E0E0E, _
	    &HFF0C0C0C, &HFF0B0B0B, &HFF090909, &HFF070707, &HFF050505, &HFF030303, _
	    &HFF010101, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF010101, &HFF020202, &HFF040404, &HFF050505, &HFF070707, _
	    &HFF080808, &HFF090909, &HFF0A0A0A, &HFF0B0B0B, &HFF0B0B0B, &HFF0B0B0B, _
	    &HFF0A0A0A, &HFF090909, &HFF080808, &HFF070707, &HFF050505, &HFF040404, _
	    &HFF020202, &HFF010101, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF010101, _
	    &HFF020202, &HFF030303, &HFF040404, &HFF050505, &HFF060606, &HFF060606, _
	    &HFF060606, &HFF060606, &HFF060606, &HFF050505, &HFF040404, &HFF030303, _
	    &HFF020202, &HFF010101, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF010101, &HFF010101, &HFF020202, _
	    &HFF020202, &HFF030303, &HFF030303, &HFF030303, &HFF020202, &HFF020202, _
	    &HFF010101, &HFF010101, &HFF000000, &HFF000000, &HFF000000, &HFF000000, _
	    &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000, &HFF000000 }

	
		textureID = LoadImage( @image_array(0),GL_LINEAR )
	
	endif
	
	return textureID 

end function

''=============================================================================
''
''    Draws a 2d glowing line
''    x1,y1,x2,y2 as start and end coordinate of the line
''    lwidth is the width of the line (how fat it is)
''    mycolor should use GL2D_RGBA() 
''
''=============================================================================

sub LineGlow ( byval x1 as single, byval y1 as single, byval x2 as single, byval y2 as single,_
			   byval lwidth as single, byval mycolor as GLuint, byval spr as image ptr = 0)

	dim as GLuint textureID
	if spr = 0 then
		textureID= get_glow_image()
	else
		textureID = spr->textureID
	end if
	
	'' Only change active texture when there is a need
	'' Speeds up the rendering by batching textures
	if ( textureID <> current_texture ) then
		glBindTexture(GL_TEXTURE_2D, textureID)
		current_texture = textureID
	endif

	
	dim as single nx,ny	
	nx = -(y2-y1)
	ny =  (x2-x1)
	
	dim leng as single
    leng = sqr(nx * nx + ny * ny )
    nx = nx / leng
    ny = ny / leng

	nx *= lwidth/2
	ny *= lwidth/2
	 	
	dim as single lx1, ly1, lx2, ly2, lx3, ly3, lx4, ly4
	
	lx1 = x2+nx
    ly1 = y2+ny
    lx2 = x2-nx
    ly2 = y2-ny                            
    lx3 = x1-nx
    ly3 = y1-ny
    lx4 = x1+nx
    ly4 = y1+ny 

	glColor4ubv (cast(GLubyte ptr, @mycolor))

	''MAIN
	glbegin(GL_QUADS)
		glTexCoord2f( 0.5,0 )
		glVertex3f( lx1,ly1,0 )

		glTexCoord2f( 0.5,1 )
		glVertex3f( lx2,ly2,0 )

		glTexCoord2f( 0.5,1 )
		glVertex3f( lx3, ly3,0 )

		glTexCoord2f( 0.5,0 )
		glVertex3f( lx4,ly4,0 )
	glend()

	'RIGHT
	dim as single lx5, ly5,lx6,ly6,vx,vy
	vx = (x2-x1)
	vy = (y2-y1)
	leng = sqr(vx * vx + vy * vy )
	vx = vx / leng
	vy = vy / leng
	vx *= lwidth/2
	vy *= lwidth/2
	
	lx5 = lx1 + vx
	ly5 = ly1 + vy
	lx6 = lx2 + vx
	ly6 = ly2 + vy
	
	glbegin(GL_QUADS)
		glTexCoord2f( 0.5,0 )
		glVertex3f( lx1,ly1,0 )

		glTexCoord2f( 1,0 )
		glVertex3f( lx5,ly5,0 )

		glTexCoord2f( 1,1 )
		glVertex3f( lx6, ly6,0 )

		glTexCoord2f( 0.5,1 )
		glVertex3f( lx2,ly2,0 )
	glend() 

	'LEFT
	lx5 = lx4 -vx
	ly5 = ly4 -vy
	lx6 = lx3 -vx
	ly6 = ly3 -vy
	glbegin(GL_QUADS)
		glTexCoord2f( 0.5,0 )
		glVertex3f( lx4,ly4,0 )
		
		glTexCoord2f( 0.5,1 )
		glVertex3f( lx3,ly3,0 )

		glTexCoord2f( 1,1 )
		glVertex3f( lx6, ly6,0 )

		glTexCoord2f( 1,0 )
		glVertex3f( lx5,ly5,0 )
		
	glend()
	
	glColor4ub(255,255,255,255)

end sub


''=============================================================================
''
''    Rudimentary font system
''
''=============================================================================
sub PrintScale(byval x as integer, byval y as integer, byval scale as single, byref text as const string)

   
   '' Only change active texture when there is a need
	'' Speeds up the rendering by batching textures
	if ( font_textureID <> current_texture ) then
		glBindTexture(GL_TEXTURE_2D, font_textureID)
		current_texture = font_textureID
	endif
	
	glPushMatrix()
    glLoadIdentity()
    glTranslatef( x, y, 0 )
    glScalef(scale, scale, 1)
    glListBase( font_list_base )
        for i as integer = 0 to len(text) - 1
        	glCallList( font_list_base + text[i] - font_list_offset )
        next i
    glPopMatrix()

end sub


''=============================================================================
''
''    Loads a 32 bit buffer (BLOADed from a BMP image)
''
''=============================================================================
function LoadImage( byval spr as any ptr , byval filter_mode as GLuint = GL_NEAREST) as GLuint
	
        dim as GLuint TextureID
   		dim as ubyte r, g, b, a
   		dim As FB.IMAGE ptr temp = cast(FB.IMAGE ptr, spr)
   		       
        glEnable( GL_TEXTURE_2D )
        glGenTextures(1, @TextureID)
        glBindTexture(GL_TEXTURE_2D, TextureID)
        
   		glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT )
        glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT )
        glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, filter_mode )
        glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, filter_mode )
        glTexEnvf( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE )
               
        glTexImage2d( GL_TEXTURE_2D, 0, GL_RGBA, temp->width, temp->height,_
        			  0, GL_BGRA, GL_UNSIGNED_BYTE, spr + sizeof(FB.IMAGE) )
        glBindTexture(GL_TEXTURE_2D, 0)
        
        
        return TextureID
        
End function

''=============================================================================
''
''    Loads a 32 bit buffer (BLOADed from a 24-bit BMP image)
''    Adds alpha transparency
''
''=============================================================================
function LoadImage24bitAlpha( byval spr as any ptr, byval filter_mode as GLuint = GL_NEAREST ) as GLuint
	
        dim as GLuint TextureID
   		dim as ubyte r, g, b, a
   		dim As FB.IMAGE ptr temp = spr
   		
   		for y as integer = 0 to temp->height-1
	    	dim as uinteger ptr p = cast(uinteger ptr,(spr + sizeof (FB.IMAGE)) + y * temp->pitch)	   
		    for x as integer = 0 to temp->width-1
		    	a = argb_a(p[x])
		    	r = argb_r(p[x])
		    	g = argb_g(p[x])
		    	b = argb_b(p[x])
		    	'' check for transparency
				if ( g = 0 ) then
					if ( (r = 255) and (b = 255) ) then
						p[x] = rgba(r,g,b,0)
					endif
				endif
		    next x
   		next y
   		
   		
   		glEnable( GL_TEXTURE_2D )
        glGenTextures(1, @TextureID)
        glBindTexture(GL_TEXTURE_2D, TextureID)
        
   		glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT )
        glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT )
        glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, filter_mode )
        glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, filter_mode )
        glTexEnvf( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE )
               
        glTexImage2d( GL_TEXTURE_2D, 0, GL_RGBA, temp->width, temp->height,_
        			  0, GL_BGRA, GL_UNSIGNED_BYTE, spr + sizeof(FB.IMAGE) )
        glBindTexture(GL_TEXTURE_2D, 0)
        
        
        return TextureID
        
end function


''=============================================================================
''
''    Loads a 32 bit buffer (BLOADed from an 8-bit BMP image)
''    Adds alpha transparency
''
''=============================================================================
function LoadImage8bitAlpha( byval spr as any ptr, byval filter_mode as GLuint = GL_NEAREST ) as GLuint
	
        dim as GLuint TextureID
   		dim as ubyte r, g, b, a
   		dim As FB.IMAGE ptr temp = spr
   
		    	
   		for y as integer = 0 to temp->height-1
	    	dim as uinteger ptr p = cast(uinteger ptr,(spr + sizeof(FB.IMAGE)) + y * temp->pitch)	   
		    for x as integer = 0 to temp->width-1
		    	a = argb_a(p[x])
		    	r = argb_r(p[x])
		    	g = argb_g(p[x])
		    	b = argb_b(p[x])
		    	'' check for transparency
		    	if ( ( p[x] and &H00FFFFFF ) = 0 ) then
		    		p[x] = rgba(r,g,b,0)
		    	endif
				
		    next x
   		next y
   		
   		
   		glEnable( GL_TEXTURE_2D )
        glGenTextures(1, @TextureID)
        glBindTexture(GL_TEXTURE_2D, TextureID)
        
   		glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT )
        glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT )
        glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, filter_mode )
        glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, filter_mode )
        glTexEnvf( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE )
               
        glTexImage2d( GL_TEXTURE_2D, 0, GL_RGBA, temp->width, temp->height,_
        			  0, GL_BGRA, GL_UNSIGNED_BYTE, spr + sizeof(FB.IMAGE) )
        glBindTexture(GL_TEXTURE_2D, 0)
        
        
        return TextureID
        
end function

''=============================================================================
''
''    Loads any type of BMP (Power of 2) into an OpenGL texture
''
''=============================================================================
function LoadBmpToTexture(byref filename as string) as GLuint
	
        if filename = "" then return 0
         
        dim as GLuint textureID
        
        dim as integer F = freefile
        dim as integer w, h		'' width and height
        dim as ushort bpp		'' bits per pixel
        
        '' test header
        open filename for binary as #f
        get #f, 19, w
        get #f, 23, h
        get #f, 29, bpp
        close #f
       
        dim as FB.IMAGE ptr spr = imagecreate(w,h)
        bload filename, spr
       
       
        select case bpp
        	case 8
        		textureID = LoadImage8bitAlpha(spr)
        	case 24
        		textureID = LoadImage24bitAlpha(spr)
        	case else
        		textureID = LoadImage(spr)
        end select
        
        imagedestroy spr
        
        return textureID
        
end function 



''=============================================================================
''
''    Loads any type of BMP (Power of 2) into an OpenGL texture
''    results are stored in a glsprite datatype
''
''=============================================================================
function LoadBmpToGLsprite(byref filename as string, byval filter_mode as GLuint = GL_NEAREST ) as IMAGE ptr
	
        if filename = "" then exit function
        
        dim as GLuint textureID
        
        dim as integer F = freefile
        dim as integer w, h		'' width and height
        dim as ushort bpp		'' bits per pixel
        
        '' test header
        open filename for binary as #f
        get #f, 19, w
        get #f, 23, h
        get #f, 29, bpp
        close #f
       
        dim as IMAGE ptr spr = imagecreate(w,h)
        bload filename, spr
       
       
        select case bpp
        	case 8
        		textureID = LoadImage8bitAlpha(spr, filter_mode)
        	case 24
        		textureID = LoadImage24bitAlpha(spr, filter_mode)
        	case else
        		textureID = LoadImage(spr, filter_mode)
        end select
        
        
        spr->textureID = textureID
        spr->u_offset = 0
        spr->v_offset = 0
        spr->texture_width = spr->width
        spr->texture_height = spr->height
        
        
        return spr
        
end function 


sub LoadImageToHW(byval spr as image ptr, byval filter_mode as GLuint = GL_NEAREST )
	
        dim as GLuint textureID
        
		select case spr->bpp
        	case 1
        		textureID = LoadImage8bitAlpha(spr, filter_mode)
        	case 4
        		textureID = LoadImage24bitAlpha(spr, filter_mode)
        	case else
        		textureID = LoadImage(spr, filter_mode)
        end select        
        
        spr->textureID = textureID
        spr->u_offset = 0
        spr->v_offset = 0
        spr->texture_width = spr->width
        spr->texture_height = spr->height
        
        
end sub 

''=============================================================================
''
''    Initializes our spriteset
''    Uses a BI file generated by rel's texture packer
''
''=============================================================================
sub InitSprites overload(spriteset() as IMAGE ptr, texcoords() as uinteger,_
				 		  byref filename as string, byval filter_mode as GLuint = GL_NEAREST )


    if filename = "" then exit sub
     
    dim as GLuint textureID
    
    dim as integer F = freefile
    dim as integer w, h		'' width and height
    dim as ushort bpp		'' bits per pixel
    
    '' test header
    open filename for binary as #f
    get #f, 19, w
    get #f, 23, h
    get #f, 29, bpp
    close #f
   
    dim as FB.IMAGE ptr spr = imagecreate(w,h)
    bload filename, spr
   
   
    select case bpp
    	case 8
    		textureID = LoadImage8bitAlpha(spr,filter_mode)
    	case 24
    		textureID = LoadImage24bitAlpha(spr,filter_mode)
    	case else
    		textureID = LoadImage(spr,filter_mode)
    end select
    
    
	dim as integer max_sprites = ubound(texcoords)\4
	redim spriteset(max_sprites)
	
	'' init sprites texture coords and texture ID
	for i as integer = 0 to max_sprites
		dim as integer  j = i * 4
		dim as integer sw = texcoords(j+2)
		dim as integer sh = texcoords(j+3)
		dim as integer su = texcoords(j)
		dim as integer sv = texcoords(j+1) 
		spriteset(i) 					= imagecreate(sw, sh)
		get spr, (su,sv)-(su+(sw-1),sv+(sh-1)), spriteset(i)
		spriteset(i)->textureID 		= textureID
		spriteset(i)->width 			= texcoords(j+2)
		spriteset(i)->height 			= texcoords(j+3)
		spriteset(i)->u_offset			= texcoords(j)
		spriteset(i)->v_offset			= texcoords(j+1) 
		spriteset(i)->texture_width 	= w
		spriteset(i)->texture_height	= h 	
	next i
	
	
	imagedestroy spr
	
end sub

''=============================================================================
''
''    Initializes our spriteset 
''    each sprite has spr_wid and spr_hei as dimensions
''
''=============================================================================
sub InitSprites overload(spriteset() as IMAGE ptr, byval tile_wid as integer, byval tile_hei as integer, byref filename as string, byval filter_mode as GLuint = GL_NEAREST )


    if filename = "" then exit sub
     
    dim as GLuint textureID
    
    dim as integer F = freefile
    dim as integer w, h		'' width and height
    dim as ushort bpp		'' bits per pixel
    
    '' test header
    open filename for binary as #f
    get #f, 19, w
    get #f, 23, h
    get #f, 29, bpp
    close #f
   
    dim as FB.IMAGE ptr spr = imagecreate(w,h)
    bload filename, spr
   
   
    select case bpp
    	case 8
    		textureID = LoadImage8bitAlpha(spr,filter_mode)
    	case 24
    		textureID = LoadImage24bitAlpha(spr,filter_mode)
    	case else
    		textureID = LoadImage(spr,filter_mode)
    end select
    
   
     
	dim as integer max_sprites = (w\tile_wid) * (h\tile_hei)
	redim spriteset(max_sprites-1)
	
	
	dim as integer i = 0
    for y as integer = 0 to (h\tile_hei) - 1 
    for x as integer = 0 to (w\tile_wid) - 1 
    	spriteset(i) = imagecreate(tile_wid,tile_hei)
        get spr,(x*tile_wid, y*tile_hei)-step(tile_wid-1,tile_hei-1), spriteset(i)	
   		spriteset(i)->textureID 		= textureID
		spriteset(i)->width 			= tile_wid
		spriteset(i)->height 			= tile_hei
		spriteset(i)->u_offset			= x*tile_wid
		spriteset(i)->v_offset			= y*tile_hei 
		spriteset(i)->texture_width 	= w
		spriteset(i)->texture_height	= h 	
        i += 1
    next x
    next y
    
	imagedestroy spr
	
end sub

sub GetImage( byval Spritedest as image ptr, byval Spritesource as image ptr,_ 
		 	  byval x1 as integer, byval y1 as integer, x2 as integer, y2 as integer )
	
	if( x2 < x1 ) then swap x1, x2
	if( y2 < y1 ) then swap y1, y2
	
	dim as integer _width = (x2 - x1 ) + 1
	dim as integer height = (y2 - y1 ) + 1
	dim as single uoff = x1
	dim as single voff = y1
	dim as single uwidth = _width
	dim as single vheight= height
	
	SpriteDest->textureID = SpriteSource->textureID
    SpriteDest->width = _width
    SpriteDest->height = height
    SpriteDest->u_offset = uoff		'' set x-coord
    SpriteDest->v_offset = voff		'' y-coord
    SpriteDest->texture_width = SpriteSource->texture_width			'' set x-coord
    SpriteDest->texture_height = SpriteSource->texture_height		'' y-coord

	
End Sub
''=============================================================================
''
''    deallocates the texture of a spriteset 
''
''=============================================================================
sub DestroySprites(spriteset() as IMAGE ptr)
	
	glDeleteTextures( 1, @spriteset(0)->textureID )
	
	for i as integer = 0 to ubound(spriteset)
		spriteset(i)->textureID 	= 0
		imagedestroy(spriteset(i))
	next i
	
end sub

''=============================================================================
''
''    call this before closing the program
''
''=============================================================================
sub ShutDown()
	
    glDeleteLists( font_list_base, 256 )
    glDeleteTextures( 1, @font_textureID )
	
end sub


''=============================================================================
''
''    call this before closing the program
''
''=============================================================================

sub DestroyImage(byval spr as IMAGE ptr)
	
	glDeleteTextures( 1, @spr->textureID )
	
	imagedestroy(spr)
	
end sub

''=============================================================================
''
''    use this to limit the FPS if vsync_ON does not work
''
''=============================================================================
function LimitFPS(byval max_FPS as single) as single
	
	'' vars to be used in calculating FPS
	static as integer frames_per_second = 0.0
	static as single last_time = 0.0 
	
	static as single time_start = 0.0
	
	'' time interval between frames
	dim as single time_difference

	static as single fps = 60
		
	
	'' Increase the frame counter
	frames_per_second += 1

	do : loop until (timer - time_start) >= (1/max_FPS)
	
	time_start =  timer
	
	if  (time_start - last_time) > 1.0 then
	 
		'' save old_time
	    last_time = time_start

		'' duh?		
		FPS = frames_per_second
		
		'' Reset the frames counter since 1 second has already elapsed
	   frames_per_second = 0
	   
	 end if
	 	   
	 
	return fps

end function


''=============================================================================
''
''    3D addendum
''
''=============================================================================

''*************************************
'' Draws a sprite at (x,y,0)
''*************************************
sub Sprite3D( byval x as single, byval y as single, byval z as single, byval mode as GL2D_FLIP_MODE, byval spr as image ptr)
	
	dim  as single x1 = x
	dim  as single y1 = y
	dim  as single x2 = x + (spr->width)
	dim  as single y2 = y + (spr->height)
	
	dim as single u_off = spr->u_offset/spr->texture_width
	dim as single v_off = spr->v_offset/spr->texture_height
	
	dim as single u_width = spr->width/spr->texture_width
	dim as single v_height = spr->height/spr->texture_height
	
	
	'' Only change active texture when there is a need
	'' Speeds up the rendering by batching textures
	if ( spr->textureID <> current_texture ) then
		glBindTexture(GL_TEXTURE_2D, spr->textureID)
		current_texture = spr->textureID
	endif
	
	dim as single u1 = iif( mode and FLIP_H, u_off + u_width , u_off	        )
    dim as single u2 = iif( mode and FLIP_H, u_off 			 , u_off + u_width  )
    dim as single v1 = iif( mode and FLIP_V, v_off + v_height, v_off			)
    dim as single v2 = iif( mode and FLIP_V, v_off			 , v_off + v_height )


    '' Only change active texture when there is a need
	'' Speeds up the rendering by batching textures
	if ( spr->textureID <> current_texture ) then
		glBindTexture(GL_TEXTURE_2D, spr->textureID)
		current_texture = spr->textureID
	endif
	
	
	glBegin(GL_QUADS)
		
		glTexcoord2f(u1, v1)
		glVertex3f	(x1,y1,z)
		
		glTexcoord2f(u1, v2)
		glVertex3f	(x1,y2,z)
		
		glTexcoord2f(u2, v2)
		glVertex3f	(x2,y2,z)
		
		glTexcoord2f(u2, v1)
		glVertex3f	(x2,y1,z)
		
	glEnd()
	
end sub

''*************************************
'' Draws one of the 6 cube faces
'' Size = TILE_SIZE
''*************************************
sub DrawFace( byval PolyIdx as integer, byval Size as single, byval Flipmode as integer, byval spr as IMAGE ptr )
	
	dim as integer f1 = CubeFaces(PolyIdx * 4 + 0)
	dim as integer f2 = CubeFaces(PolyIdx * 4 + 1)
	dim as integer f3 = CubeFaces(PolyIdx * 4 + 2)
	dim as integer f4 = CubeFaces(PolyIdx * 4 + 3)

	dim as single u_off = spr->u_offset/spr->texture_width
	dim as single v_off = spr->v_offset/spr->texture_height
	
	dim as single u_width = spr->width/spr->texture_width
	dim as single v_height = spr->height/spr->texture_height
	
	'' Only change active texture when there is a need
	'' Speeds up the rendering by batching textures
	if ( spr->textureID <> current_texture ) then
		glBindTexture(GL_TEXTURE_2D, spr->textureID)
		current_texture = spr->textureID
	endif
	
	dim as single u1 = iif( Flipmode and FLIP_H, u_off + u_width , u_off	        )
    dim as single u2 = iif( Flipmode and FLIP_H, u_off 			 , u_off + u_width  )
    dim as single v1 = iif( Flipmode and FLIP_V, v_off + v_height, v_off			)
    dim as single v2 = iif( Flipmode and FLIP_V, v_off			 , v_off + v_height )
 
	
	dim as single S = Size
	
	glTexCoord2f( u1, v1 )
	glVertex3f(CubeVectors(f1*3) * S, CubeVectors(f1*3 + 1) * S, CubeVectors(f1*3 +  2) * S )
	
	glTexCoord2f( u2, v1 )
	glVertex3f(CubeVectors(f2*3) * S, CubeVectors(f2*3 + 1) * S, CubeVectors(f2*3 + 2) * S )
	
	glTexCoord2f( u2, v2 )
	glVertex3f(CubeVectors(f3*3) * S, CubeVectors(f3*3 + 1) * S, CubeVectors(f3*3 + 2) * S )

	glTexCoord2f( u1, v2 )
	glVertex3f(CubeVectors(f4*3) * S, CubeVectors(f4*3 + 1) * S, CubeVectors(f4*3 + 2) * S )
	
	
End Sub


''*************************************
'' Draws a 3d cube
''*************************************
sub DrawCube( byval x as single, byval y as single, byval z as single, byval Size as single, byval spr as IMAGE ptr  )

	'' Only change active texture when there is a need
	'' Speeds up the rendering by batching textures
	if ( spr->textureID <> current_texture ) then
		glBindTexture(GL_TEXTURE_2D, spr->textureID)
		current_texture = spr->textureID
	endif
	
	glPushMatrix()
		glTranslatef( x + Size/2, y + Size/2, z)  '' Offset by Size/2 so that we draw from top-left at (0,0)
		glBegin( GL_QUADS )
		
			DrawFace( 0, Size, GL2D.FLIP_V   , spr )   '' top
			DrawFace( 1, Size, GL2D.FLIP_NONE, spr )   '' front
			DrawFace( 2, Size, GL2D.FLIP_H   , spr )   '' right
			DrawFace( 3, Size, GL2D.FLIP_NONE, spr )   '' back so don't draw
			DrawFace( 4, Size, GL2D.FLIP_H   , spr )   '' left
			DrawFace( 5, Size, GL2D.FLIP_V   , spr )   '' bottom
			
		glEnd()
		
	glPopMatrix()

end sub




end namespace



