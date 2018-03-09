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


#pragma once

'' include needed libs
#include once "fbgfx.bi"
#include once "gl/gl.bi" 
#include once "gl/glu.bi"   


'' safety
namespace GL2D

'' enums for blending options
enum GL2D_BLEND_MODE

	BLEND_TRANS = 0,
	BLEND_SOLID,
	BLEND_BLENDED,
	BLEND_GLOW,
	BLEND_ALPHA,
	BLEND_BLACK

end enum

enum GL2D_FLIP_MODE

	FLIP_NONE 	= 1 shl 0,
	FLIP_V 		= 1 shl 1,
	FLIP_H 		= 1 shl 2,
	
end enum

''=============================================================================
''
''    Some helpful macros for FB.IMAGE type
''    For GL2D primitives that accepts color(GLuint)
''    Use GL2D_RGBA( r, g, b, a ) as FB is and GL are reversed endians
''
''=============================================================================	
#define ARGB_A(u) (((u) shr 24) and &H000000FF)
#define ARGB_R(u) (((u) shr 16) and &H000000FF)
#define ARGB_G(u) (((u) shr 8)  and &H000000FF)
#define ARGB_B(u) (((u) shr 0)  and &H000000FF)
#define ARGB( r, g, b, a )   	rgba( (b), (g), (r), (a) )
#define GL2D_RGBA( r, g, b, a )	rgba( (b), (g), (r), (a) )
#define GL2D_RGB( r, g, b )		rgba( (b), (g), (r), (255) )



''=============================================================================
''
''    Our sprite datatype (Uses the FB.IMAGE struct)
''
''=============================================================================
type _OLD_HEADER field = 1
	bpp : 3 as ushort
	width : 13 as ushort
	height as ushort
end type


type IMAGE field = 1

	union
		old 		as _OLD_HEADER
		type 		as uinteger
	end union
	bpp 			as integer
	width 			as uinteger
	height 			as uinteger
	pitch 			as uinteger
	
	'' _reserved(1 to 12) as ubyte
	'' 12 bytes are used to be compatible 

	textureID 		as uinteger			'' 4 bytes
	u_offset		as ushort			'' 2 bytes
	v_offset		as ushort			'' 2 bytes
	texture_width	as ushort			'' 2 bytes
	texture_height	as ushort			'' 2 bytes

end type


declare sub VsyncOn()

declare sub Begin2D()

declare sub End2D()  

declare sub ScreenInit(byval screen_wid as integer, byval screen_hei as integer, byval flags as integer = 0)

declare sub SetBlendMode(byval blend_mode as GL2D_BLEND_MODE)

declare sub EnableSpriteStencil( byval flag as integer = 0,_
						   byval gl2dcolor as GLuint = GL2D_RGBA(0,0,0,0),_
						   byval gl2dcolor_env as GLuint = GL2D_RGBA(0,0,0,0)  )
	
declare sub EnableAntialias(byval switch as integer = 1)

declare sub ClearScreen()

declare sub Pset( byval x as integer, byval y as integer, byval gl2dcolor as GLuint )

declare sub Line( byval x1 as integer, byval y1 as integer, byval x2 as integer, byval y2 as integer, byval gl2dcolor as GLuint )

declare sub LineGradient( byval x1 as integer, byval y1 as integer, byval x2 as integer, byval y2 as integer, byval gl2dcolor1 as GLuint, byval gl2dcolor2 as GLuint )

declare sub Box( byval x1 as integer, byval y1 as integer, byval x2 as integer, byval y2 as integer, byval gl2dcolor as GLuint )

declare sub BoxFilled( byval x1 as integer, byval y1 as integer, byval x2 as integer, byval y2 as integer, byval gl2dcolor as GLuint )

declare sub BoxFilledGradient( byval x1 as integer, byval y1 as integer,_
						 byval x2 as integer, byval y2 as integer,_
						 byval gl2dcolor1 as GLuint,_
						 byval gl2dcolor2 as GLuint,_
						 byval gl2dcolor3 as GLuint,_
						 byval gl2dcolor4 as GLuint )

declare sub Triangle( byval x1 as integer, byval y1 as integer, byval x2 as integer, byval y2 as integer,_
			  byval x3 as integer, byval y3 as integer, byval gl2dcolor as GLuint )

declare sub TriangleFilled( byval x1 as integer, byval y1 as integer, byval x2 as integer, byval y2 as integer,_
			         byval x3 as integer, byval y3 as integer, byval gl2dcolor as GLuint )

declare sub TriangleFilledGradient( byval x1 as integer, byval y1 as integer,_ 
							  byval x2 as integer, byval y2 as integer,_
			                  byval x3 as integer, byval y3 as integer,_
			                  byval gl2dcolor1 as GLuint, byval gl2dcolor2 as GLuint, byval gl2dcolor3 as GLuint )

declare sub Circle(byval x as integer, byval y as integer, byval radius as integer, byval gl2dcolor as GLuint)

declare sub CircleFilled(byval x as integer, byval y as integer, byval radius as integer, byval gl2dcolor as GLuint )

declare sub Ellipse(byval x as single, byval y as single, byval a as single, byval b as single, byval angle as single, byval gl2dcolor as GLuint )

declare sub EllipseFilled(byval x as single, byval y as single, byval a as single, byval b as single, byval angle as single, byval gl2dcolor as GLuint )

declare sub Sprite( byval x as integer, byval y as integer, byval mode as GL2D_FLIP_MODE, byval spr as image ptr)

declare sub SpriteScale( byval x as integer, byval y as integer, byval scale as single, byval mode as GL2D_FLIP_MODE, byval spr as image ptr)

declare sub SpriteScaleXY( byval x as integer, byval y as integer, byval scaleX as single, byval scaleY as single, byval mode as GL2D_FLIP_MODE, byval spr as image ptr)

declare sub SpriteRotate( byval x as integer, byval y as integer, byval angle as integer, byval mode as GL2D_FLIP_MODE, byval spr as image ptr)

declare sub SpriteRotateScale( byval x as integer, byval y as integer, byval angle as integer, byval scale as single, byval mode as GL2D_FLIP_MODE, byval spr as image ptr)

declare sub SpriteRotateScaleXY( byval x as integer, byval y as integer, byval angle as integer, byval scaleX as single, byval scaleY as single, byval mode as GL2D_FLIP_MODE, byval spr as image ptr)

declare sub SpriteOnBox( byval x1 as integer, byval y1 as integer,_
						 byval x2 as integer, byval y2 as integer,_
						 byval mode as GL2D_FLIP_MODE, byval spr as image ptr)

declare sub SpriteOnQuad( byval x1 as integer, byval y1 as integer,_
						  byval x2 as integer, byval y2 as integer,_
						  byval x3 as integer, byval y3 as integer,_
						  byval x4 as integer, byval y4 as integer,_
						  byval mode as GL2D_FLIP_MODE, byval spr as image ptr)

declare sub SpriteStretch( byval x as integer, byval y as integer, byval length as integer, byval height as integer, byval spr as image ptr )

declare sub SpriteStretchHorizontal( byval x as integer, byval y as integer, byval length as integer, byval spr as image ptr )

declare sub SpriteStretchVertical( byval x as integer, byval y as integer, byval height as integer, byval spr as image ptr )

declare sub LineGlow ( byval x1 as single, byval y1 as single, byval x2 as single, byval y2 as single,_
				byval lwidth as single, byval mycolor as GLuint, byval spr as image ptr = 0 )

declare sub PrintScale(byval x as integer, byval y as integer,byval scale as single, byref text as const string)

declare function LoadImage( byval spr as any ptr, byval filter_mode as GLuint = GL_NEAREST ) as GLuint

declare function LoadImage24bitAlpha( byval spr as any ptr, byval filter_mode as GLuint = GL_NEAREST ) as GLuint

declare function LoadImage8bitAlpha( byval spr as any ptr, byval filter_mode as GLuint = GL_NEAREST ) as GLuint

declare function LoadBmpToTexture(byref filename as string) as GLuint

declare function LoadBmpToGLsprite(byref filename as string, byval filter_mode as GLuint = GL_NEAREST ) as IMAGE ptr

declare sub LoadImageToHW(byval spr as image ptr, byval filter_mode as GLuint = GL_NEAREST )

declare sub InitSprites overload(spriteset() as IMAGE ptr, texcoords() as uinteger,_
				 byref filename as string, byval filter_mode as GLuint = GL_NEAREST )

declare sub InitSprites overload(spriteset() as IMAGE ptr, byval tile_wid as integer, byval tile_hei as integer, byref filename as string, byval filter_mode as GLuint = GL_NEAREST )

declare sub GetImage( byval dest as image ptr, byval source as image ptr,_ 
		 		 	  byval x1 as integer, byval y1 as integer, x2 as integer, y2 as integer )

declare sub FontLoad( byval glyph_width as integer, byval glyph_height as integer,_
			  		  byval fontoffset as integer, byref filename as string, byval filter_mode as GLuint = GL_NEAREST )

declare sub DestroySprites(spriteset() as IMAGE ptr)

declare sub ShutDown()

declare sub DestroyImage(byval spr as IMAGE ptr)

declare function LimitFPS(byval max_FPS as single) as single

declare sub Sprite3D( byval x as single, byval y as single, byval z as single, byval mode as GL2D_FLIP_MODE, byval spr as image ptr)
declare sub DrawFace( byval PolyIdx as integer, byval Size as single, byval Flipmode as integer, byval spr as IMAGE ptr )
declare sub DrawCube( byval x as single, byval y as single, byval z as single, byval Size as single, byval spr as IMAGE ptr )


end namespace



