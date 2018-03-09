''****************************************************************************
''
''    Easy GL2D (FB.IMAGE compatible version)
''
''    By Relminator (Richard Eric M. Lope)
''    http://rel.phatcode.net
''
''  Code supplement on how to use:
''  1. Spritesets and animations
''
''*****************************************************************************

#include once "fbgfx.bi"
#include once "/gl/gl.bi" 
#include once "/gl/glu.bi"   

#include once "FBGL2D7.bi"     	'' We're gonna use Hardware acceleration
#include once "FBGL2D7.bas"		'' So we'll be using my LIB

#include once "uvcoord_megaman_sprites.bi"		'' uvcoords


''*****************************************************************************
const as integer SCREEN_WIDTH = 640
const as integer SCREEN_HEIGHT = 480


const as integer FALSE = 0
const as integer TRUE = not FALSE

const as single GRAVITY = 0.75
const as single JUMPHEIGHT = 15

const as integer FLOOR_VALUE = 400  '' Our arbitrary floor value for collision purposes
const as integer LADDER_VALUE = SCREEN_WIDTH/2  '' Our arbitrary ladder value for climbing purposes


''*****************************************************************************
''
''	Our Player Class
''
''*****************************************************************************
Type Player

public:
	
	'' Player States for Finite State Machine
	Enum E_STATE
		IDLE = 0,
		WALKING,
		JUMPING,
		FALLING,
		SLIDING,
		CLIMBING,
		FIRING,
		FIRING_WALKING,
		FIRING_JUMPING,
		FIRING_FALLING,
		FIRING_CLIMBING,
		DIED
	End Enum
	
	'' Direction our player is facing for flipmode
	Enum E_DIRECTION
		DIR_RIGHT = 0,
		DIR_LEFT,
		DIR_UP,
		DIR_DOWN	
	End Enum
	
	'' length of time before the player gets "bored" standing up 
	Enum 
		SLIDE_WAIT_TIME = 30
		FIRE_WAIT_TIME = 10
	End Enum
	
	declare constructor()
	declare destructor()
	
	declare Sub Update()			'' This updates the player depending on its State
	declare sub Draw(SpriteSet() as GL2D.IMAGE ptr)				'' Draws the Player according to state
	
private:
	
	declare Sub UpdateIdle()			''\ 
	declare Sub UpdateWalking()			'' |  
	declare Sub UpdateJumping()			'' | 
	declare Sub UpdateSliding()			''  \ These are the functions to be called by Update
	declare Sub UpdateFalling()			''  / Depending on the Player.State
	declare Sub UpdateClimbing()		'' |
	declare Sub UpdateFiring()			'' |
	declare Sub UpdateFiringWalking()	'' |
	declare Sub UpdateFiringJumping()	'' |
	declare Sub UpdateFiringFalling()	'' |
	declare Sub UpdateFiringClimbing()	'' |
	declare Sub UpdateDied()			''/
	
	declare sub ResolveAnimationParameters( byval ContinueFrame as integer = 0 )	'' Sets up animation params depending on State
	declare sub Animate()						'' Animates the player
	
	x		as single				'' Position
	y		as single
	Dx		as single				'' Direction
	Dy		as Single
	Speed	as single				'' Horizontal Speed
	Wid		as integer				'' Width of the player
	Hei		as integer				
	CanJump as integer				'' If the player can Jump
	
	Counter 	as Integer
	Frame		as Integer
	BaseFrame 	as Integer
	MaxFrame	as Integer	
	FlipMode	as Integer
	FrameXoff	as integer
	FrameYoff	as integer
	
	Direction 		as Integer
	SlideCounter	as Integer
	FireCounter		as Integer
	
	State 			as E_STATE				'' State of the player
	
End Type

''*****************************************************************************
''
''*****************************************************************************
constructor Player()
	
	Counter = 0
	x = 32 * 2 
	y = 32 * 1 
	Speed = 2.5
	Wid = 32
	Hei = 46
	CanJump = false
	
	Frame = 0
	BaseFrame = 0
	MaxFrame = 8	
	FlipMode = GL2D.FLIP_NONE
	FrameXoff = 0
	FrameYoff = 0
	
	Direction = DIR_RIGHT
	SlideCounter = 0
	FireCounter = 0
	
	State = FALLING
	ResolveAnimationParameters()
	
End Constructor

''*****************************************************************************
''
''*****************************************************************************
destructor Player()

End Destructor



''*****************************************************************************
'' Updates the player according to states
''*****************************************************************************
sub Player.Update()

	Counter += 1
	Animate()
	
	'' Check to see the Player State and
	'' Update accordingly
	
	'' In my DS game I used function pointers 
	'' But I have no idea how to get and call
	'' function pointers of class methods in FB
	'' so I used select case which is not too bad.
	Select Case State
		case IDLE:
			SlideCounter = 0
			FireCounter = 0
			UpdateIdle()
		case WALKING:
			SlideCounter = 0
			FireCounter = 0
			UpdateWalking()
		case JUMPING:
			SlideCounter = 0
			FireCounter = 0
			UpdateJumping()
		case FALLING:
			SlideCounter = 0
			FireCounter = 0
			UpdateFalling()
		case SLIDING:
			FireCounter = 0
			UpdateSliding()
		case CLIMBING:
			SlideCounter = 0
			FireCounter = 0
			UpdateClimbing()
		case FIRING:
			SlideCounter = 0
			UpdateFiring()
		case FIRING_WALKING:
			SlideCounter = 0
			UpdateFiringWalking()
		case FIRING_JUMPING:
			SlideCounter = 0
			UpdateFiringJumping()
		case FIRING_FALLING:
			SlideCounter = 0
			UpdateFiringFalling()
		case FIRING_CLIMBING:
			SlideCounter = 0
			UpdateFiringClimbing()
		case DIED:
			SlideCounter = 0
			FireCounter = 0
			UpdateDied()
	End Select
    
    
End Sub

''*****************************************************************************
'' Called when player is not moving and standing on the ground
''*****************************************************************************
Sub Player.UpdateIdle()
	
	Dx = 0  '' Set speed to 0
	
	'' If we pressed left then we walk negatively
	'' and we set the State to WALKING since we moved
	if multikey(FB.SC_LEFT) then 
		Dx = -speed
		State = WALKING
		Direction = DIR_LEFT
		ResolveAnimationParameters()
	EndIf
	
	'' See comments above
    if multikey(FB.SC_RIGHT) then 
    	Dx = speed
    	State = WALKING
    	Direction = DIR_RIGHT
		ResolveAnimationParameters()
    EndIf
    
    '' We can climb while Standing 
    '' If we pressed up and we are on a ladder...
    if multikey(FB.SC_UP) then
    	dim as integer Cx = x + Wid\2				'' Center of player
    	if( abs( Cx - LADDER_VALUE ) < 16 ) then	'' Distance is less than 16
    		Cx = LADDER_VALUE						'' Snap center to center of ladder
    		x = Cx - Wid\2							'' Snap player to ladder
	    	State = CLIMBING						'' Climbing
	    	ResolveAnimationParameters()
	    	Dx = 0
	    end if
    EndIf
    
    
    '' We can Light a dynamite while standing
    if multikey(FB.SC_Z) then 
    	State = FIRING
		ResolveAnimationParameters()
    EndIf
    
    
    '' We can slide while standing
    if multikey(FB.SC_X) then 
    	State = SLIDING
    	if( Direction = DIR_RIGHT ) then
    		Dx = Speed * 2
    	else
    		Dx = -Speed * 2
    	EndIf
    	ResolveAnimationParameters()
    EndIf
   
    '' We can die while standing
    if multikey(FB.SC_C) then 
    	State = DIED
    	Dy = -JUMPHEIGHT	'' Mario Style death		
		ResolveAnimationParameters()
    EndIf
   
   	
    '' We can jump while not moving so jump when we press space
    '' Then set the state to JUMPING
    if multikey(FB.SC_SPACE) then 
	    if( CanJump ) then
	    	State = JUMPING 		
	    	Dy = -JUMPHEIGHT		'' This makes us jump
	    	CanJump = false			'' We can't jump again while in the middle of Jumping
	    	ResolveAnimationParameters()
	    end if
    EndIf
    
	
	'' Make the player fall down with GRAVITY
	Dy += GRAVITY
	
	x += Dx		'' Move player
	y += Dy		'' Ditto
	
	'' y = 400 is our arbitrary floor so set Dy = 0
	'' and snap the y position to 400 - Hei
	If( y + Hei > FLOOR_VALUE ) then    
		Dy = 0
		y = FLOOR_VALUE - Hei
		if( multikey(FB.SC_SPACE) = 0 ) then CanJump = true		'' We hit floor so we can jump again
	End If
		
	
End Sub

''*****************************************************************************
'' Called when player is walking on the ground
''*****************************************************************************
Sub Player.UpdateWalking()
	
	'' Assume we are not moving so set
	'' State to be idle
	State = IDLE
	
	Dx = 0  '' Set speed to 0
	
	'' If we pressed left then we walk negatively
	'' and we set the State to WALKING since we moved
	if multikey(FB.SC_LEFT) then 
		Dx = -speed
		State = WALKING
		Direction = DIR_LEFT
	EndIf
	
	'' See comments above
    if multikey(FB.SC_RIGHT) then 
    	Dx = speed
    	State = WALKING
    	Direction = DIR_RIGHT
    EndIf
    
    '' We can climb while walking 
    '' If we pressed up and we are on a ladder...
    if multikey(FB.SC_UP) then
    	dim as integer Cx = x + Wid\2				'' Center of player
    	if( abs( Cx - LADDER_VALUE ) < 16 ) then	'' Distance is less than 16
    		Cx = LADDER_VALUE						'' Snap center to center of ladder
    		x = Cx - Wid\2							'' Snap player to ladder
	    	State = CLIMBING						'' Climbing
	    	ResolveAnimationParameters()
	    	Dx = 0
	    end if
    EndIf
    
    '' We can fire while walking
    if multikey(FB.SC_Z) then 
    	State = FIRING_WALKING
		ResolveAnimationParameters( TRUE )
    EndIf
    
    
    '' We can slide while standing
    if multikey(FB.SC_X) then 
    	State = SLIDING
    	if( Direction = DIR_RIGHT ) then
    		Dx = Speed * 2
    	else
    		Dx = -Speed * 2
    	EndIf
    	ResolveAnimationParameters()
    EndIf
   
    '' We can die while walking
    if multikey(FB.SC_C) then 
    	State = DIED
    	Dy = -JUMPHEIGHT	'' Mario Style death		
		ResolveAnimationParameters()
    EndIf
   
    
    '' We can jump while not moving so jump when we press space
    '' Then set the state to JUMPING
    if multikey(FB.SC_SPACE) then 
	    if( CanJump ) then
	    	State = JUMPING 		
	    	Dy = -JUMPHEIGHT		'' This makes us jump
	    	CanJump = false			'' We can't jump while Jumping
	    	ResolveAnimationParameters()
	    end if
    EndIf
    
	
	'' Make the player fall down with GRAVITY
	Dy += GRAVITY
	
	x += Dx		'' Move player
	y += Dy		'' Ditto
	
	'' y = 400 is our arbitrary floor so set Dy = 0
	'' and snap the y position to 400 - Hei
	If( y + Hei > FLOOR_VALUE ) then    
		Dy = 0
		y = FLOOR_VALUE - Hei
		if( multikey(FB.SC_SPACE) = 0 ) then CanJump = true		'' We hit floor so we can jump again
	End If
		
	if( State = IDLE ) then ResolveAnimationParameters()
	
End Sub

''*****************************************************************************
'' Called when player is jumping
''*****************************************************************************
Sub Player.UpdateJumping()
	
	'' You will notice that there is no way to plant bombs or dynamite within this sub
	'' This is the beauty of FSM. You can limit behaviors depending on your needs.
	'' I didn't want the player to plant bombs or dynamites while jumping or falling so
	'' I just didn't include a check here.
	
	dim as integer Walked = FALSE    '' a way to check if we moved left or right
									 '' Since Dx is single and EPSILON would not look
									 '' good in a tutorial
	
	Dx = 0  '' Set speed to 0
	'' We can move left or right when jumping so...
	
	'' If we pressed left then we walk negatively
	'' and we set the State to WALKING since we moved
	if multikey(FB.SC_LEFT) then 
		Dx = -speed
		Walked = TRUE  			''Set walked to true for checking later 
		Direction = DIR_LEFT
	EndIf
	
	'' See comments above
    if multikey(FB.SC_RIGHT) then 
    	Dx = speed
    	Walked = TRUE
    	Direction = DIR_RIGHT
    EndIf
    
    '' We can climb while jumping 
    '' If we pressed up and we are on a ladder...
    if multikey(FB.SC_UP) then
    	dim as integer Cx = x + Wid\2				'' Center of player
    	if( abs( Cx - LADDER_VALUE ) < 16 ) then	'' Distance is less than 16
    		Cx = LADDER_VALUE						'' Snap center to center of ladder
    		x = Cx - Wid\2							'' Snap player to ladder
	    	State = CLIMBING						'' Climbing
	    	ResolveAnimationParameters()
	    	Dx = 0
	    end if
    EndIf
    
    '' We can fire while jumping
    if multikey(FB.SC_Z) then 
    	State = FIRING_JUMPING
		ResolveAnimationParameters( TRUE )
    EndIf
    
    
    '' We can die while jumping
    if multikey(FB.SC_C) then 
    	State = DIED
    	Dy = -JUMPHEIGHT	'' Mario Style death		
		ResolveAnimationParameters()
    EndIf
   
    '' Make the player fall down with GRAVITY
	Dy += GRAVITY
	
	x += Dx		'' Move player
	y += Dy		'' Ditto
	
	'' y = 400 is our arbitrary floor so set Dy = 0
	'' and snap the y position to 400 - Hei
	If( y + Hei > FLOOR_VALUE ) then
		Dy = 0
		y = FLOOR_VALUE - Hei
		if( multikey(FB.SC_SPACE) = 0 ) then CanJump = true	'' We hit floor so we can jump again
		
		'' Check if we walked or not
		if( Walked ) then
			State = WALKING	'' Set the State to WALKING when we hit the floor
			ResolveAnimationParameters()
		else
			State = IDLE	'' Ditto
			ResolveAnimationParameters()
		EndIf
		
	End If
	
End Sub

''*****************************************************************************
'' Called when player is falling
''*****************************************************************************
Sub Player.UpdateFalling()
	
	'' You will notice that there is no way to plant bombs or dynamite within this sub
	'' This is the beauty of FSM. You can limit behaviors depending on your needs.
	'' I didn't want the player to plant bombs or dynamites while jumping or falling so
	'' I just didn't include a check here.
	
	dim as integer Walked = FALSE    '' a way to check if we moved left or right
									 '' Since Dx is single and EPSILON would not look
									 '' good in a tutorial
	
	Dx = 0  '' Set speed to 0
	'' We can move left or right when falling so...
	
	'' If we pressed left then we walk negatively
	'' and we set the State to WALKING since we moved
	if multikey(FB.SC_LEFT) then 
		Dx = -speed
		Walked = TRUE  			''Set walked to true for checking later 
		Direction = DIR_LEFT
	EndIf
	
	'' See comments above
    if multikey(FB.SC_RIGHT) then 
    	Dx = speed
    	Walked = TRUE
    	Direction = DIR_RIGHT
    EndIf
    
    '' We can climb while Falling 
    '' If we pressed up and we are on a ladder...
    if multikey(FB.SC_UP) then
    	dim as integer Cx = x + Wid\2				'' Center of player
    	if( abs( Cx - LADDER_VALUE ) < 16 ) then	'' Distance is less than 16
    		Cx = LADDER_VALUE						'' Snap center to center of ladder
    		x = Cx - Wid\2							'' Snap player to ladder
	    	State = CLIMBING						'' Climbing
	    	ResolveAnimationParameters()
	    	Dx = 0
	    end if
    EndIf
    
    '' We can fire while falling
    if multikey(FB.SC_Z) then 
    	State = FIRING_FALLING
		ResolveAnimationParameters( TRUE )
    EndIf
    
    '' We can die while falling
    if multikey(FB.SC_C) then 
    	State = DIED
    	Dy = -JUMPHEIGHT	'' Mario Style death		
		ResolveAnimationParameters()
    EndIf
   
    
	'' Make the player fall down with GRAVITY
	Dy += GRAVITY
	
	x += Dx		'' Move player
	y += Dy		'' Ditto
	
	'' y = 400 is our arbitrary floor so set Dy = 0
	'' and snap the y position to 400 - Hei
	If( y + Hei > FLOOR_VALUE ) then
		Dy = 0
		y = FLOOR_VALUE - Hei
		
		CanJump = false
		
		'' Check if we walked or not
		if( Walked ) then
			State = WALKING	'' Set the State to WALKING when we hit the floor
			ResolveAnimationParameters()
		else
			State = IDLE	'' Ditto
			ResolveAnimationParameters()
		EndIf
		
	End If
	
End Sub

''*****************************************************************************
'' Called when Player slides
''*****************************************************************************
Sub Player.UpdateSliding()
	
	SlideCounter += 1
	if( SlideCounter > SLIDE_WAIT_TIME ) then
		SlideCounter = 0
		State = IDLE
		ResolveAnimationParameters()
	EndIf
	
    '' We can die while sliding
    if multikey(FB.SC_C) then 
    	State = DIED
    	Dy = -JUMPHEIGHT	'' Mario Style death		
		ResolveAnimationParameters()
    EndIf
   
	'' Make the player fall down with GRAVITY
	Dy += GRAVITY
	
	x += Dx		'' Move player
	y += Dy		'' Ditto
	
	'' y = 400 is our arbitrary floor so set Dy = 0
	'' and snap the y position to 400 - Hei
	If( y + Hei > FLOOR_VALUE ) then    
		Dy = 0
		y = FLOOR_VALUE - Hei
		if( multikey(FB.SC_SPACE) = 0 ) then CanJump = true		'' We hit floor so we can jump again
	End If
	
	
End Sub


''*****************************************************************************
'' Called when Player climbs
''*****************************************************************************
Sub Player.UpdateClimbing()
	
	dim as integer Climbed = FALSE
	static as integer LastDir = DIR_RIGHT
	Dx = 0
	Dy = 0  '' Set speed to 0
	'' We can move left or right when jumping so...
	
	Direction = LastDir
	
	if multikey(FB.SC_UP) then 
		Dy = -speed
		Climbed = TRUE
		Direction = DIR_UP
	EndIf
	
	'' See comments above
    if multikey(FB.SC_DOWN) then 
    	Dy = speed
    	Climbed = TRUE
    	Direction = DIR_DOWN
    EndIf
    
    if( Climbed = FALSE ) then
   	
	    if multikey(FB.SC_RIGHT) then 
	    	Direction = DIR_RIGHT
	    	LastDir = Direction
	    EndIf
	   
	   	if multikey(FB.SC_LEFT) then 
	    	Direction = DIR_LEFT
	    	LastDir = Direction
	    EndIf
    end if
    
    '' We can fire while climbing
    if multikey(FB.SC_Z) then 
    	State = FIRING_CLIMBING
    	Direction = LastDir
		ResolveAnimationParameters( TRUE )
    EndIf
    
    if multikey(FB.SC_SPACE) then 
    	State = FALLING
    	ResolveAnimationParameters()
    	Direction = LastDir
    EndIf
    
    
    '' We can die while Climbing
    if multikey(FB.SC_C) then 
    	State = DIED
    	Dy = -JUMPHEIGHT	'' Mario Style death		
		ResolveAnimationParameters()
    EndIf
   
    y += Dy		'' Ditto
	
	'' y = 400 is our arbitrary floor so set Dy = 0
	'' and snap the y position to 400 - Hei
	If( y + Hei + Dy > FLOOR_VALUE ) then
		Dy = 0
		y = FLOOR_VALUE - Hei
		if( multikey(FB.SC_SPACE) = 0 ) then CanJump = true	'' We hit floor so we can jump again
		
		State = IDLE '' Ditto
		ResolveAnimationParameters()
		Direction = LastDir
	End If
	
End Sub


''*****************************************************************************
'' Called when Player fires
''*****************************************************************************
Sub Player.UpdateFiring()
	
	Dx = 0  '' Set speed to 0
	
	'' Stop firing when after a set time
    if( not multikey(FB.SC_Z) ) then 
    	FireCounter += 1
    else
    	FireCounter = 0
    EndIf
	if( FireCounter > FIRE_WAIT_TIME ) then
		FireCounter = 0
		State = IDLE
		ResolveAnimationParameters()
	EndIf
	
	'' If we pressed left then we walk negatively
	'' and we set the State to WALKING since we moved
	if multikey(FB.SC_LEFT) then 
		Dx = -speed
		State = WALKING
		Direction = DIR_LEFT
		ResolveAnimationParameters()
	EndIf
	
	'' See comments above
    if multikey(FB.SC_RIGHT) then 
    	Dx = speed
    	State = WALKING
    	Direction = DIR_RIGHT
		ResolveAnimationParameters()
    EndIf
    
    '' We can climb while firing 
    '' If we pressed up and we are on a ladder...
    if multikey(FB.SC_UP) then
    	dim as integer Cx = x + Wid\2				'' Center of player
    	if( abs( Cx - LADDER_VALUE ) < 16 ) then	'' Distance is less than 16
    		Cx = LADDER_VALUE						'' Snap center to center of ladder
    		x = Cx - Wid\2							'' Snap player to ladder
	    	State = CLIMBING						'' Climbing
	    	ResolveAnimationParameters()
	    	Dx = 0
	    end if
    EndIf
    
    '' We can slide while firing
    if multikey(FB.SC_X) then 
    	State = SLIDING
    	if( Direction = DIR_RIGHT ) then
    		Dx = Speed * 2
    	else
    		Dx = -Speed * 2
    	EndIf
    	ResolveAnimationParameters()
    EndIf
   
    '' We can die while firing
    if multikey(FB.SC_C) then 
    	State = DIED
    	Dy = -JUMPHEIGHT	'' Mario Style death		
		ResolveAnimationParameters()
    EndIf
   
   	
   	
    '' We can jump while firing so jump when we press space
    '' Then set the state to JUMPING
    if multikey(FB.SC_SPACE) then 
	    if( CanJump ) then
	    	State = JUMPING 		
	    	Dy = -JUMPHEIGHT		'' This makes us jump
	    	CanJump = false			'' We can't jump again while in the middle of Jumping
	    	ResolveAnimationParameters()
	    end if
    EndIf
    
	
	'' Make the player fall down with GRAVITY
	Dy += GRAVITY
	
	x += Dx		'' Move player
	y += Dy		'' Ditto
	
	'' y = 400 is our arbitrary floor so set Dy = 0
	'' and snap the y position to 400 - Hei
	If( y + Hei > FLOOR_VALUE ) then    
		Dy = 0
		y = FLOOR_VALUE - Hei
		if( multikey(FB.SC_SPACE) = 0 ) then CanJump = true		'' We hit floor so we can jump again
	End If
	
	
End Sub


''*****************************************************************************
'' Called when Player fires
''*****************************************************************************
Sub Player.UpdateFiringWalking()
	
	State = FIRING
	
	Dx = 0  '' Set speed to 0
	
	'' If we pressed left then we walk negatively
	'' and we set the State to WALKING since we moved
	if multikey(FB.SC_LEFT) then 
		Dx = -speed
		State = FIRING_WALKING
		Direction = DIR_LEFT
	EndIf
	
	'' See comments above
    if multikey(FB.SC_RIGHT) then 
    	Dx = speed
    	State = FIRING_WALKING
    	Direction = DIR_RIGHT
    EndIf
    
    '' We can climb while firing and walking 
    '' If we pressed up and we are on a ladder...
    if multikey(FB.SC_UP) then
    	dim as integer Cx = x + Wid\2				'' Center of player
    	if( abs( Cx - LADDER_VALUE ) < 16 ) then	'' Distance is less than 16
    		Cx = LADDER_VALUE						'' Snap center to center of ladder
    		x = Cx - Wid\2							'' Snap player to ladder
	    	State = CLIMBING						'' Climbing
	    	ResolveAnimationParameters()
	    	Dx = 0
	    end if
    EndIf
    
	'' Stop firing when after a set time
    if( not multikey(FB.SC_Z) ) then 
    	FireCounter += 1
    else
    	FireCounter = 0
    EndIf
	
	if( FireCounter > FIRE_WAIT_TIME ) then
		FireCounter = 0
		State = WALKING
		ResolveAnimationParameters( TRUE )
	EndIf
	
    
    '' We can slide while firing
    if multikey(FB.SC_X) then 
    	State = SLIDING
    	if( Direction = DIR_RIGHT ) then
    		Dx = Speed * 2
    	else
    		Dx = -Speed * 2
    	EndIf
    	ResolveAnimationParameters()
    EndIf
   
    '' We can die while firing
    if multikey(FB.SC_C) then 
    	State = DIED
    	Dy = -JUMPHEIGHT	'' Mario Style death		
		ResolveAnimationParameters()
    EndIf
   
   	
   	
    '' We can jump while firing so jump when we press space
    '' Then set the state to JUMPING
    if multikey(FB.SC_SPACE) then 
	    if( CanJump ) then
	    	State = JUMPING 		
	    	Dy = -JUMPHEIGHT		'' This makes us jump
	    	CanJump = false			'' We can't jump again while in the middle of Jumping
	    	ResolveAnimationParameters()
	    end if
    EndIf
    
	
	'' Make the player fall down with GRAVITY
	Dy += GRAVITY
	
	x += Dx		'' Move player
	y += Dy		'' Ditto
	
	'' y = 400 is our arbitrary floor so set Dy = 0
	'' and snap the y position to 400 - Hei
	If( y + Hei > FLOOR_VALUE ) then    
		Dy = 0
		y = FLOOR_VALUE - Hei
		if( multikey(FB.SC_SPACE) = 0 ) then CanJump = true		'' We hit floor so we can jump again
	End If
	
	
	if( State = FIRING ) then ResolveAnimationParameters( TRUE )
	
End Sub


''*****************************************************************************
'' Called when Player fires
''*****************************************************************************
Sub Player.UpdateFiringJumping()
	
	dim as integer Walked = FALSE    '' a way to check if we moved left or right
									 '' Since Dx is single and EPSILON would not look
									 '' good in a tutorial
	
	Dx = 0  '' Set speed to 0
	'' We can move left or right when jumping so...
	
	'' If we pressed left then we walk negatively
	'' and we set the State to WALKING since we moved
	if multikey(FB.SC_LEFT) then 
		Dx = -speed
		Walked = TRUE  			''Set walked to true for checking later 
		Direction = DIR_LEFT
	EndIf
	
	'' See comments above
    if multikey(FB.SC_RIGHT) then 
    	Dx = speed
    	Walked = TRUE
    	Direction = DIR_RIGHT
    EndIf
    
    '' We can climb while firing and jumping 
    '' If we pressed up and we are on a ladder...
    if multikey(FB.SC_UP) then
    	dim as integer Cx = x + Wid\2				'' Center of player
    	if( abs( Cx - LADDER_VALUE ) < 16 ) then	'' Distance is less than 16
    		Cx = LADDER_VALUE						'' Snap center to center of ladder
    		x = Cx - Wid\2							'' Snap player to ladder
	    	State = CLIMBING						'' Climbing
	    	ResolveAnimationParameters()
	    	Dx = 0
	    end if
    EndIf
    
    '' Stop firing when after a set time
    if( not multikey(FB.SC_Z) ) then 
    	FireCounter += 1
    else
    	FireCounter = 0
    EndIf
	
	if( FireCounter > FIRE_WAIT_TIME ) then
		FireCounter = 0
		State = JUMPING
		ResolveAnimationParameters( TRUE )
	EndIf
	
    
    
    '' We can die while jumping
    if multikey(FB.SC_C) then 
    	State = DIED
    	Dy = -JUMPHEIGHT	'' Mario Style death		
		ResolveAnimationParameters()
    EndIf
   
    '' Make the player fall down with GRAVITY
	Dy += GRAVITY
	
	x += Dx		'' Move player
	y += Dy		'' Ditto
	
	'' y = 400 is our arbitrary floor so set Dy = 0
	'' and snap the y position to 400 - Hei
	If( y + Hei > FLOOR_VALUE ) then
		Dy = 0
		y = FLOOR_VALUE - Hei
		if( multikey(FB.SC_SPACE) = 0 ) then CanJump = true	'' We hit floor so we can jump again
		
		'' Check if we walked or not
		if( Walked ) then
			State = FIRING_WALKING	'' Set the State to WALKING when we hit the floor
			ResolveAnimationParameters()
		else
			State = FIRING	'' Ditto
			ResolveAnimationParameters()
		EndIf
		
	End If
	
End Sub


''*****************************************************************************
'' Called when Player fires
''*****************************************************************************
Sub Player.UpdateFiringFalling()
	
	dim as integer Walked = FALSE    '' a way to check if we moved left or right
									 '' Since Dx is single and EPSILON would not look
									 '' good in a tutorial
	
	Dx = 0  '' Set speed to 0
	'' We can move left or right when jumping so...
	
	'' If we pressed left then we walk negatively
	'' and we set the State to WALKING since we moved
	if multikey(FB.SC_LEFT) then 
		Dx = -speed
		Walked = TRUE  			''Set walked to true for checking later 
		Direction = DIR_LEFT
	EndIf
	
	'' See comments above
    if multikey(FB.SC_RIGHT) then 
    	Dx = speed
    	Walked = TRUE
    	Direction = DIR_RIGHT
    EndIf
    
    '' We can climb while firing and falling 
    '' If we pressed up and we are on a ladder...
    if multikey(FB.SC_UP) then
    	dim as integer Cx = x + Wid\2				'' Center of player
    	if( abs( Cx - LADDER_VALUE ) < 16 ) then	'' Distance is less than 16
    		Cx = LADDER_VALUE						'' Snap center to center of ladder
    		x = Cx - Wid\2							'' Snap player to ladder
	    	State = CLIMBING						'' Climbing
	    	ResolveAnimationParameters()
	    	Dx = 0
	    end if
    EndIf
    
    '' Stop firing when after a set time
    if( not multikey(FB.SC_Z) ) then 
    	FireCounter += 1
    else
    	FireCounter = 0
    EndIf
	
	if( FireCounter > FIRE_WAIT_TIME ) then
		FireCounter = 0
		State = FALLING
		ResolveAnimationParameters( TRUE )
	EndIf
	
    
    
    '' We can die while jumping
    if multikey(FB.SC_C) then 
    	State = DIED
    	Dy = -JUMPHEIGHT	'' Mario Style death		
		ResolveAnimationParameters()
    EndIf
   
    '' Make the player fall down with GRAVITY
	Dy += GRAVITY
	
	x += Dx		'' Move player
	y += Dy		'' Ditto
	
	'' y = 400 is our arbitrary floor so set Dy = 0
	'' and snap the y position to 400 - Hei
	If( y + Hei > FLOOR_VALUE ) then
		Dy = 0
		y = FLOOR_VALUE - Hei
		CanJump = false
		
		'' Check if we walked or not
		if( Walked ) then
			State = FIRING_WALKING	'' Set the State to WALKING when we hit the floor
			ResolveAnimationParameters()
		else
			State = FIRING	'' Ditto
			ResolveAnimationParameters()
		EndIf
		
	End If
	
End Sub

''*****************************************************************************
'' Called when Player climbs
''*****************************************************************************
Sub Player.UpdateFiringClimbing()
	
	'' No Movement on Ladder while firing	
	Dx = 0
	Dy = 0  '' Set speed to 0
	
	
    if multikey(FB.SC_RIGHT) then 
    	Direction = DIR_RIGHT
    EndIf
   
   	if multikey(FB.SC_LEFT) then 
    	Direction = DIR_LEFT
   	EndIf

    '' Stop firing when after a set time
    if( not multikey(FB.SC_Z) ) then 
    	FireCounter += 1
    else
    	FireCounter = 0
    EndIf
	
	if( FireCounter > FIRE_WAIT_TIME ) then
		FireCounter = 0
		State = CLIMBING
		ResolveAnimationParameters( TRUE )
	EndIf
	
    if multikey(FB.SC_SPACE) then 
    	State = FIRING_FALLING
    	ResolveAnimationParameters()
    EndIf
    
    
    '' We can die while Climbing
    if multikey(FB.SC_C) then 
    	State = DIED
    	Dy = -JUMPHEIGHT	'' Mario Style death		
		ResolveAnimationParameters()
    EndIf
   
    y += Dy		'' Ditto
	
	'' y = 400 is our arbitrary floor so set Dy = 0
	'' and snap the y position to 400 - Hei
	If( y + Hei + Dy > FLOOR_VALUE ) then
		Dy = 0
		y = FLOOR_VALUE - Hei
		if( multikey(FB.SC_SPACE) = 0 ) then CanJump = true	'' We hit floor so we can jump again
		
		State = FIRING '' Ditto
		ResolveAnimationParameters()
	End If
	
End Sub

''*****************************************************************************
'' Called when player is dead
''*****************************************************************************
Sub Player.UpdateDied()

	'' We can't do anything except fall down when dying so no checks for
	'' walking, jumping, dynamite, bombs, etc.
	'' Make the player fall down with GRAVITY
	Dy += GRAVITY
	
	y += Dy		'' Move
	
	'' y = 400 is our arbitrary floor so set Dy = 0
	'' and snap the y position to 400 - Hei
	If( y + Hei > FLOOR_VALUE ) then
		Dy = 0
		y = FLOOR_VALUE - Hei
		
		State = IDLE			'' Set to standing for now when we hit the floor while dying
		ResolveAnimationParameters()
	
	End If
	

End Sub


''*****************************************************************************
'' Draws the player according to state
''*****************************************************************************
sub Player.Draw(SpriteSet() as GL2D.IMAGE ptr)

	''GL2D.BoxFilled( x, y, x + Wid, y + Hei, GL2D_RGBA(0,255,0,255) )
			
	Select Case State
		case IDLE:
			FrameXoff = -2
			FrameYoff = 0
			GL2D.PrintScale(0, 0, 1, "State = IDLE" )
		case WALKING:
			FrameXoff = -6
			FrameYoff = 0
			GL2D.PrintScale(0, 0, 1, "State = WALKING" )
		case JUMPING:
			FrameXoff = -5
			FrameYoff = 0
			GL2D.PrintScale(0, 0, 1, "State = JUMPING" )
		case FALLING:
			FrameXoff = -5
			FrameYoff = 0
			GL2D.PrintScale(0, 0, 1, "State = FALLING" )
		case SLIDING:
			FrameXoff = -8
			FrameYoff = 16
			GL2D.PrintScale(0, 0, 1, "State = SLIDING" )
		case CLIMBING:
			FrameXoff = -1
			FrameYoff = 0
			GL2D.PrintScale(0, 0, 1, "State = CLIMBING" )
		case FIRING:
			FrameXoff = -6
			FrameYoff = 0
			GL2D.PrintScale(0, 0, 1, "State = FIRING" )
		case FIRING_WALKING:
			FrameXoff = -8
			FrameYoff = 0
			GL2D.PrintScale(0, 0, 1, "State = FIRING_WALKING" )
		case FIRING_JUMPING:
			FrameXoff = -8
			FrameYoff = 0
			GL2D.PrintScale(0, 0, 1, "State = FIRING_JUMPING" )
		case FIRING_FALLING:
			FrameXoff = -8
			FrameYoff = 0
			GL2D.PrintScale(0, 0, 1, "State = FIRING_FALLING" )
		case FIRING_CLIMBING:
			FrameXoff = -8
			FrameYoff = 0
			GL2D.PrintScale(0, 0, 1, "State = FIRING_CLIMBING" )
		case DIED:
			FrameXoff = -4
			FrameYoff = 0
			GL2D.PrintScale(0, 0, 1, "State = DIED" )
	End Select
		
		GL2D.Sprite( x + FrameXoff, y + FrameYoff, FlipMode, SpriteSet(BaseFrame + Frame))
			
		GL2D.PrintScale(0, 20, 1, "Slide counter = " & str(SlideCounter) )    
		GL2D.PrintScale(0, 30, 1, "Fire  counter = " & str(FireCounter) )    
		GL2D.PrintScale(0, 40, 1, "Direction = " & str(Direction) )    
		
		
		GL2D.PrintScale(0,  50, 1, "CONTROLS")    
		GL2D.PrintScale(0,  70, 1, "ARROWS = Move")    
		GL2D.PrintScale(0,  80, 1, " SPACE = Jump")    
		GL2D.PrintScale(0,  90, 1, "     Z = Fire")    
		GL2D.PrintScale(0, 100, 1, "     X = Slide")
		GL2D.PrintScale(0, 110, 1, "     C = Die")    
	    GL2D.PrintScale(0, 120, 1, "    UP = Climb Ladder")    
	    
	
end sub

''*****************************************************************************
'' Animates the player
''*****************************************************************************
Sub Player.Animate()
	
	Select Case State
		
		case IDLE:
			If( (Counter and 7) = 0 ) Then
				Frame = ( Frame + 1 ) mod MaxFrame
			EndIf
		
		case WALKING:
			If( (Counter and 3) = 0 ) Then
				Frame = ( Frame + 1 ) mod MaxFrame
			EndIf
		
		case JUMPING:
			if( Dy < 0 ) then
				BaseFrame = 15
				if( abs(Dy) > (JUMPHEIGHT\2) ) then
					BaseFrame = 15
				else
					BaseFrame = 16
				EndIf
			else
				BaseFrame = 17
				if( abs(Dy) > (JUMPHEIGHT\2) ) then
					BaseFrame = 18
				else
					BaseFrame = 17
				EndIf
			EndIf
			If( (Counter and 3) = 0 ) Then
				Frame = ( Frame + 1 ) mod MaxFrame
			EndIf			
		
		case FALLING:
			BaseFrame = 17
			if( abs(Dy) > (JUMPHEIGHT\2) ) then
				BaseFrame = 18
			else
				BaseFrame = 17
			EndIf
			If( (Counter and 3) = 0 ) Then
				Frame = ( Frame + 1 ) mod MaxFrame
			EndIf
		
		case SLIDING:
			If( (Counter and 7) = 0 ) Then
				Frame = ( Frame + 1 ) mod MaxFrame
			EndIf
		
		case CLIMBING:
			If( (Counter and 3) = 0 ) Then
				select case Direction
					case DIR_UP:
						Frame = ( Frame + 1 ) mod MaxFrame
					case DIR_DOWN:
						Frame = ( Frame - 1 )
						if( Frame < 0 ) then Frame = MaxFrame - 1
				End Select
			EndIf
		
		case FIRING:
			If( (Counter and 7) = 0 ) Then
				Frame = ( Frame + 1 ) mod MaxFrame
			EndIf
		
		case FIRING_WALKING:
			If( (Counter and 3) = 0 ) Then
				Frame = ( Frame + 1 ) mod MaxFrame
			EndIf
		
		case FIRING_JUMPING:
			if( Dy < 0 ) then
				BaseFrame = 19
				if( abs(Dy) > (JUMPHEIGHT\2) ) then
					BaseFrame = 19
				else
					BaseFrame = 20
				EndIf
			else
				BaseFrame = 21
				if( abs(Dy) > (JUMPHEIGHT\2) ) then
					BaseFrame = 22
				else
					BaseFrame = 21
				EndIf
			EndIf
			If( (Counter and 3) = 0 ) Then
				Frame = ( Frame + 1 ) mod MaxFrame
			EndIf
		
		case FIRING_FALLING:
			BaseFrame = 21
			if( abs(Dy) > (JUMPHEIGHT\2) ) then
				BaseFrame = 22
			else
				BaseFrame = 21
			EndIf
			If( (Counter and 3) = 0 ) Then
				Frame = ( Frame + 1 ) mod MaxFrame
			EndIf
			
		case FIRING_CLIMBING:
			If( (Counter and 7) = 0 ) Then
				Frame = ( Frame + 1 ) mod MaxFrame
			EndIf
		
		case DIED:
			If( (Counter and 3) = 0 ) Then
				Frame = ( Frame + 1 ) mod MaxFrame
			EndIf
	
	End Select
    
	
	
	if( Direction = DIR_RIGHT ) then
		FlipMode = GL2D.FLIP_NONE
	else
		FlipMode = GL2D.FLIP_H
	EndIf
	
End Sub

''*****************************************************************************
'' Sets up animation frames depending on current state
''*****************************************************************************
sub Player.ResolveAnimationParameters(  byval ContinueFrame as integer = 0  )
	
	Select Case State
		case IDLE:
			BaseFrame = 0
			MaxFrame = 4	
		case WALKING:
			BaseFrame = 23
			MaxFrame = 8
		case JUMPING:
			BaseFrame = 15
			MaxFrame = 1
		case FALLING:
			BaseFrame = 17
			MaxFrame = 1
		case SLIDING:
			BaseFrame = 39
			MaxFrame = 1
		case CLIMBING:
			BaseFrame = 4
			MaxFrame = 6
		case FIRING:
			BaseFrame = 12
			MaxFrame = 2 
		case FIRING_WALKING:
			BaseFrame = 31
			MaxFrame = 8
		case FIRING_JUMPING:
			BaseFrame = 19
			MaxFrame = 1
		case FIRING_FALLING:
			BaseFrame = 21
			MaxFrame = 1
		case FIRING_CLIMBING:
			BaseFrame = 10
			MaxFrame = 2
		case DIED:
			BaseFrame = 14
			MaxFrame = 1   
	End Select
	
	if( ContinueFrame = false ) then 
		Frame = 0
	else
		Frame = Frame mod MaxFrame
	EndIf
    
End Sub
	
''*****************************************************************************
'' Our main sub
''*****************************************************************************
sub main()

	
	
	redim as GL2D.IMAGE ptr MegamanImages(0)
	
	
	dim as integer Frame = 0
	 
	dim as Player Mega
	 
	GL2D.ScreenInit( SCREEN_WIDTH, SCREEN_HEIGHT )   ''Set up GL screen
	GL2D.VsyncON()
	
	GL2D.InitSprites( MegamanImages(), megaman_sprites_texcoords(), "megaman_sprites.bmp" )

	do
		
		Frame += 1

		Mega.Update()     '' Do player movements
    
		GL2D.ClearScreen()
			
		GL2D.Begin2D()
			
			GL2D.SetBlendMode(GL2D.BLEND_TRANS)

			'' Draw Floor
			GL2D.BoxFilled( 0, FLOOR_VALUE-2, SCREEN_WIDTH, SCREEN_HEIGHT, GL2D_RGBA(255,255,255,255) )
			
			'' Draw Ladder
			GL2D.BoxFilled( LADDER_VALUE - 16, 0, LADDER_VALUE + 16, FLOOR_VALUE, GL2D_RGBA(128,0,128,255) )
			GL2D.Line( LADDER_VALUE, 0 , LADDER_VALUE, FLOOR_VALUE, GL2D_RGBA(0,255,0,255) )
			dim as Integer Steps = FLOOR_VALUE \ 16
			for i as Integer = 0 to Steps
				GL2D.Line( LADDER_VALUE - 16, i * 16 , LADDER_VALUE + 16, i * 16, GL2D_RGBA(0,255,0,255) )
			Next
			'' Draw Player
			Mega.Draw(MegamanImages())
			
			GL2D.SetBlendMode(GL2D.BLEND_TRANS)
			GL2D.PrintScale(0,  140, 1, "Entity management using FSM")    
			GL2D.PrintScale(0,  150, 1, "Code by Richard Eric M. Lope")    
			GL2D.PrintScale(0,  160, 1, "Sprites made by GregarLink10")    
		
		GL2D.End2D()
		
		
		dim as integer FPS = GL2D.LimitFPS(60)
		
		sleep 1,1
		flip
		
	Loop until multikey(FB.SC_ESCAPE)

	GL2D.DestroySprites( MegamanImages() )

	GL2D.ShutDown()
	
End Sub

''*****************************************************************************
''*****************************************************************************


main()


end


