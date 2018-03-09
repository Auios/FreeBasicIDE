
					Easy GL2D for FreeBASIC v0.7 

Description:
	Easy GL2D is a very simple 2D OpenGL rendering engine.
	It is made with two simple things in mind: Speed and ease of use.
	Everything is function based so just about any programming
	design pattern can be used in conjunction with easy GL2D.
	
	
	Relminator(Richard Eric M. Lope) 08/19/2010 | 02/14/2012 | 09/30/2012
	http://rel.phatcode.net/

	*Use this with my texture packer and it would
	be very easy to grab tiles from a tileset.
         
	Texturepacker
	http://rel.phatcode.net/junk.php?id=106
         

	
Features:

	Easy to use
	Very fast
	No dependencies except FreeBASIC, OpenGL, GLU
	OpenGL states(color, AA, blending, etc) can be applied to any primitive or sprite.	
	Full hardware
	Able to support standard FBGFX BMPs in any bitdepth >= 8
	Portable(even has a Nintendo DS port, actually the DS version is the first one I made so this is the port)

Limitations:
    Full hardware
	Author is lazy

	
	* See the examples if you like it.

How to use:
	1. You can use it as a "module"
		* just include FBGL2D7.BI and link with FBGL2D7.bas
	2. You can also use Easy GL2D as part of your source file
		* just include FBGL2D7.BAS and FBGL2D7.BI then code away.
	
	
	* See the reference in the /Docs section for more details
	
Code constributions:

    Michael "h4tt3n" Nissen (Fast ellipse code)
    
Greetz:
    DR_D
    Lachie
    LOJ
    AAP
	Plasma
	Jofers
    All the guys at freebasic.net
    All the guys at DBFinteractive.com
    All the guys at Devkitpro.org and GBAdev.org
	All the guys at Codelite.org
	All the guys at shmup-dev.com and shmups.com
	All the guys at gbatemp.net
	

Update ver 0.7 (BIG Change!)
	- Changed calling convention so that the CPP, DS and FB versions
		share the the same calls and convention
	- Cleaner and better stream-lined API
	- Font stuff
	- Lots of stuff I couldn't remember
	- Better docs (Doxygen and Chm)
	- No cast needed for using FB.Image sprites
	
Update ver 0.6
	- ALPHA mode
	- Forgot

Update ver 0.5
	- Forgot
	
Update ver 0.
	- Added more primitives
	- Glowline looks better
	- More sprite stretching
	- Many more stuff I'm too lazy to document