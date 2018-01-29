#ifndef __FLTK_GLUT__
#define __FLTK_GLUT__

#include once "fltk-c.bi"
#include once "GL/gl.bi"

extern "C"

' #######################################
' # Fl_Glut_Window extends Fl_Gl_Window #
' #######################################
declare function Fl_Glut_WindowNew(byval w as long,byval h as long,byval title as const zstring ptr=0) as Fl_Glut_Window ptr
declare function Fl_Glut_WindowNew2(byval x as long,byval y as long,byval w as long,byval h as long,byval title as const zstring ptr=0) as Fl_Glut_Window ptr
declare sub      Fl_Glut_WindowDelete(byref win as Fl_Glut_Window ptr)
declare sub      Fl_Glut_WindowMakeCurrent(byval win as Fl_Glut_Window ptr)

' #################################################
' # class Fl_Glut_WindowEx extends Fl_Glut_Window #
' #################################################
declare function Fl_Glut_WindowExNew(byval w as long,byval h as long,byval title as const zstring ptr=0) as Fl_Glut_WindowEx ptr
declare function Fl_Glut_WindowExNew2(byval x as long,byval y as long,byval w as long,byval h as long,byval title as const zstring ptr=0) as Fl_Glut_WindowEx ptr
declare sub      Fl_Glut_WindowExDelete(byref win as Fl_Glut_WindowEx ptr)
declare function Fl_Glut_WindowExHandleBase      (byval win as Fl_Glut_WindowEx ptr,byval event as Fl_Event) as long
declare sub      Fl_Glut_WindowExSetDestructorCB (byval win as Fl_Glut_WindowEx ptr,byval cb as Fl_DestructorEx)
declare sub      Fl_Glut_WindowExSetDrawCB       (byval win as Fl_Glut_WindowEx ptr,byval cb as Fl_DrawEx)
declare sub      Fl_Glut_WindowExSetDrawOverlayCB(byval win as Fl_Glut_WindowEx ptr,byval cb as Fl_Draw_OverlayEx)
declare sub      Fl_Glut_WindowExSetHandleCB     (byval win as Fl_Glut_WindowEx ptr,byval cb as Fl_HandleEx)
declare sub      Fl_Glut_WindowExSetResizeCB     (byval win as Fl_Glut_WindowEx ptr,byval cb as Fl_ResizeEx)

' ########
' # Glut #
' ########
#define GLUT_RGB         FL_MODE_RGB
#define GLUT_RGBA        FL_MODE_RGB
#define GLUT_INDEX       FL_MODE_INDEX
#define GLUT_SINGLE      FL_MODE_SINGLE
#define GLUT_DOUBLE      FL_MODE_DOUBLE
#define GLUT_ACCUM       FL_MODE_ACCUM
#define GLUT_ALPHA       FL_MODE_ALPHA
#define GLUT_DEPTH       FL_MODE_DEPTH
#define GLUT_STENCIL     FL_MODE_STENCIL
#define GLUT_MULTISAMPLE FL_MODE_MULTISAMPLE
#define GLUT_STEREO      FL_MODE_STEREO

#define GLUT_CURSOR_RIGHT_ARROW         2
#define GLUT_CURSOR_LEFT_ARROW          67
#define GLUT_CURSOR_INFO                FL_CURSOR_HAND
#define GLUT_CURSOR_DESTROY             45
#define GLUT_CURSOR_HELP                FL_CURSOR_HELP
#define GLUT_CURSOR_CYCLE               26
#define GLUT_CURSOR_SPRAY               63
#define GLUT_CURSOR_WAIT                FL_CURSOR_WAIT
#define GLUT_CURSOR_TEXT                FL_CURSOR_INSERT
#define GLUT_CURSOR_CROSSHAIR           FL_CURSOR_CROSS
#define GLUT_CURSOR_UP_DOWN             FL_CURSOR_NS
#define GLUT_CURSOR_LEFT_RIGHT          FL_CURSOR_WE
#define GLUT_CURSOR_TOP_SIDE            FL_CURSOR_N
#define GLUT_CURSOR_BOTTOM_SIDE         FL_CURSOR_S
#define GLUT_CURSOR_LEFT_SIDE           FL_CURSOR_W
#define GLUT_CURSOR_RIGHT_SIDE          FL_CURSOR_E
#define GLUT_CURSOR_TOP_LEFT_CORNER     FL_CURSOR_NW
#define GLUT_CURSOR_TOP_RIGHT_CORNER    FL_CURSOR_NE
#define GLUT_CURSOR_BOTTOM_RIGHT_CORNER FL_CURSOR_SE
#define GLUT_CURSOR_BOTTOM_LEFT_CORNER  FL_CURSOR_SW
#define GLUT_CURSOR_INHERIT             FL_CURSOR_DEFAULT
#define GLUT_CURSOR_NONE                FL_CURSOR_NONE
#define GLUT_CURSOR_FULL_CROSSHAIR      FL_CURSOR_CROSS

#define GLUT_LEFT_BUTTON   0
#define GLUT_MIDDLE_BUTTON 1
#define GLUT_RIGHT_BUTTON  2
#define GLUT_DOWN          0
#define GLUT_UP            1

#define GLUT_KEY_F1 1
#define GLUT_KEY_F2 2
#define GLUT_KEY_F3 3
#define GLUT_KEY_F4 4
#define GLUT_KEY_F5 5
#define GLUT_KEY_F6 6
#define GLUT_KEY_F7 7
#define GLUT_KEY_F8 8
#define GLUT_KEY_F9 9
#define GLUT_KEY_F10 10
#define GLUT_KEY_F11 11
#define GLUT_KEY_F12 12
' WARNING: Different values than GLUT uses:
#define GLUT_KEY_LEFT      FL_Left
#define GLUT_KEY_UP        FL_Up
#define GLUT_KEY_RIGHT     FL_Right
#define GLUT_KEY_DOWN      FL_Down
#define GLUT_KEY_PAGE_UP   FL_Page_Up
#define GLUT_KEY_PAGE_DOWN FL_Page_Down
#define GLUT_KEY_HOME      FL_Home
#define GLUT_KEY_END       FL_End
#define GLUT_KEY_INSERT    FL_Insert

' Warning: values are changed from GLUT!
const as ulong GLUT_RETURN_ZERO           = 0
const as ulong GLUT_WINDOW_X              = 1
const as ulong GLUT_WINDOW_Y              = 2
const as ulong GLUT_WINDOW_WIDTH          = 3
const as ulong GLUT_WINDOW_HEIGHT         = 4
const as ulong GLUT_WINDOW_PARENT         = 5
const as ulong GLUT_SCREEN_WIDTH          = 6
const as ulong GLUT_SCREEN_HEIGHT         = 7
const as ulong GLUT_MENU_NUM_ITEMS        = 8
const as ulong GLUT_DISPLAY_MODE_POSSIBLE = 9
const as ulong GLUT_INIT_WINDOW_X         = 10
const as ulong GLUT_INIT_WINDOW_Y         = 11
const as ulong GLUT_INIT_WINDOW_WIDTH     = 12
const as ulong GLUT_INIT_WINDOW_HEIGHT    = 13
const as ulong GLUT_INIT_DISPLAY_MODE     = 14
const as ulong GLUT_WINDOW_BUFFER_SIZE    = 15
const as ulong GLUT_VERSION               = 16


#define GLUT_WINDOW_STENCIL_SIZE     GL_STENCIL_BITS
#define GLUT_WINDOW_DEPTH_SIZE       GL_DEPTH_BITS
#define GLUT_WINDOW_RED_SIZE         GL_RED_BITS
#define GLUT_WINDOW_GREEN_SIZE       GL_GREEN_BITS
#define GLUT_WINDOW_BLUE_SIZE        GL_BLUE_BITS
#define GLUT_WINDOW_ALPHA_SIZE       GL_ALPHA_BITS
#define GLUT_WINDOW_ACCUM_RED_SIZE   GL_ACCUM_RED_BITS
#define GLUT_WINDOW_ACCUM_GREEN_SIZE GL_ACCUM_GREEN_BITS
#define GLUT_WINDOW_ACCUM_BLUE_SIZE  GL_ACCUM_BLUE_BITS
#define GLUT_WINDOW_ACCUM_ALPHA_SIZE GL_ACCUM_ALPHA_BITS
#define GLUT_WINDOW_DOUBLEBUFFER     GL_DOUBLEBUFFER
#define GLUT_WINDOW_RGBA             GL_RGBA
#define GLUT_WINDOW_COLORMAP_SIZE    GL_INDEX_BITS
#define GLUT_WINDOW_NUM_SAMPLES      GLUT_RETURN_ZERO
#define GLUT_WINDOW_STEREO           GL_STEREO

#define GLUT_HAS_KEYBOARD            600
#define GLUT_HAS_MOUSE               601
#define GLUT_HAS_SPACEBALL           602
#define GLUT_HAS_DIAL_AND_BUTTON_BOX 603
#define GLUT_HAS_TABLET              604
#define GLUT_NUM_MOUSE_BUTTONS       605
#define GLUT_NUM_SPACEBALL_BUTTONS   606
#define GLUT_NUM_BUTTON_BOX_BUTTONS  607
#define GLUT_NUM_DIALS               608
#define GLUT_NUM_TABLET_BUTTONS      609

#define GLUT_ACTIVE_SHIFT FL_SHIFT
#define GLUT_ACTIVE_CTRL  FL_CTRL
#define GLUT_ACTIVE_ALT   FL_ALT

#define GLUT_OVERLAY_POSSIBLE  800
#define GLUT_TRANSPARENT_INDEX 803
#define GLUT_NORMAL_DAMAGED    804
#define GLUT_OVERLAY_DAMAGED   805


' fltk glut font/size attributes used in the glutXXX functions
type Fl_Glut_Bitmap_Font 
  as Fl_Font font
  as Fl_Fontsize size
end type

' GLUT stroked font sub-API
type Fl_Glut_StrokeVertex
  as single X, Y
end type
type Fl_Glut_StrokeStrip
  as long Number
  as const Fl_Glut_StrokeVertex ptr Vertices
end type
type Fl_Glut_StrokeChar 
  as single Right
  as long Number
  as const Fl_Glut_StrokeStrip ptr Strips
end type
type Fl_Glut_StrokeFont
  as zstring ptr  Name                           ' The source font name
  as long         Quantity                       ' Number of chars in font
  as single       Height                         ' Height of the characters
  as const Fl_Glut_StrokeChar ptr ptr Characters ' The characters mapping
end type


' opengl proc
declare function GlutGetProcAddress(byval procName as const zstring ptr) as any ptr
declare function GlutExtensionSupported(byval extensionName as const zstring ptr) as long

' glut lib
declare sub      GlutInit(byval argcp as long ptr,byval argv as zstring ptr ptr)
declare sub      GlutInitDisplayMode(byval mode as ulong)

declare sub      GlutSwapBuffers


' current active window or NULL
declare function Glut_window() as Fl_Glut_Window ptr
' current active menu or 0
declare function Glut_menu() as long

declare sub      GlutMainLoop

' window
declare sub      GlutInitWindowPosition(byval x as long,byval y as long)
declare sub      GlutInitWindowSize(byval w as long,byval h as long)

declare function GlutCreateWindow(byval title as zstring ptr) as long
declare function GlutCreateSubWindow(byval win as long,byval x as long,byval y as long,byval w as long,byval h as long) as long
declare sub      GlutDestroyWindow(byval win as long)

declare sub      GlutPostRedisplay
declare sub      GlutPostWindowRedisplay(byval win as long)

declare function GlutGetWindow() as long
declare sub      GlutSetWindow(byval win as long)
declare sub      GlutSetWindowTitle(byval title as zstring ptr)
declare sub      GlutSetIconTitle(byval title as zstring ptr)
declare sub      GlutPositionWindow(byval x as long,byval y as long)
declare sub      GlutReshapeWindow(byval w as long,byval h as long)
declare sub      GlutPopWindow
declare sub      GlutPushWindow
declare sub      GlutIconifyWindow
declare sub      GlutShowWindow
declare sub      GlutHideWindow
declare sub      GlutFullScreen
declare sub      GlutSetCursor(byval c as Fl_Cursor)
declare sub      GlutWarpPointer(byval x as long,byval y as long)
declare sub      GlutEstablishOverlay
declare sub      GlutRemoveOverlay
declare sub      GlutUseLayer(byval layer as ulong)
declare sub      GlutPostOverlayRedisplay
declare sub      GlutShowOverlay
declare sub      GlutHideOverlay

' menu
declare function GlutCreateMenu(byval f as sub (byval menu as long)) as long
declare sub      GlutDestroyMenu(byval menu as long)
declare function GlutGetMenu() as long
declare sub      GlutSetMenu(byval m as long)
declare sub      GlutAddMenuEntry(byval label as zstring ptr,byval value as long)
declare sub      GlutAddSubMenu(byval label as zstring ptr,byval submenu as long)
declare sub      GlutChangeToMenuEntry(byval item as long, byval label as zstring ptr,byval value as long)
declare sub      GlutChangeToSubMenu(byval item as long, byval label as zstring ptr,byval submenu as long)
declare sub      GlutRemoveMenuItem(byval item as long)
declare sub      GlutAttachMenu(byval menu as long)
declare sub      GlutDetachMenu(byval menu as long)

' callback's
declare sub      GlutDisplayFunc(byval f as sub())
declare sub      GlutReshapeFunc(byval f as sub(byval w as long,byval h as long))
declare sub      GlutKeyboardFunc(byval f as sub(byval key as ubyte,byval x as long,byval y as long))
declare sub      GlutMouseFunc(byval f as sub(byval b as long,byval state as long,byval x as long,byval y as long))
declare sub      GlutMotionFunc(byval f as sub(byval x as long,byval y as long))
declare sub      GlutPassiveMotionFunc(byval f as sub(byval x as long,byval y as long))
declare sub      GlutEntryFunc(byval f as sub(byval s as long))
declare sub      GlutVisibilityFunc(byval f as sub(byval s as long))
declare sub      GlutIdleFunc(byval f as sub())
declare sub      GlutTimerFunc(byval msec as ulong,byval f as sub(byval value as long),byval value as long)
declare sub      GlutMenuStateFunc(byval f as sub(byval state as long))
declare sub      GlutMenuStatusFunc(byval f as sub(byval status as long,byval x as long,byval y as long))
declare sub      GlutSpecialFunc(byval f as sub(byval key as long,byval x as long,byval y as long))
declare sub      GlutOverlayDisplayFunc(byval f as sub())

declare function GlutGet(byval typ as ulong) as long
declare function GlutDeviceGet(byval typ as ulong) as long
declare function GlutGetModifiers() as long


' bitmap font
declare function GlutBitmap9By15() as Fl_Glut_Bitmap_Font ptr
declare function GlutBitmap8By13() as Fl_Glut_Bitmap_Font ptr
declare function GlutBitmapTimesRoman10() as Fl_Glut_Bitmap_Font ptr
declare function GlutBitmapTimesRoman24() as Fl_Glut_Bitmap_Font ptr
declare function GlutBitmapHelvetica10() as Fl_Glut_Bitmap_Font ptr
declare function GlutBitmapHelvetica12() as Fl_Glut_Bitmap_Font ptr
declare function GlutBitmapHelvetica18() as Fl_Glut_Bitmap_Font ptr
declare sub      GlutBitmapCharacter(byval font as Fl_Glut_Bitmap_Font ptr,byval character as long)
declare function GlutBitmapHeight(byval font as Fl_Glut_Bitmap_Font ptr) as long
declare function GlutBitmapLength(byval font as Fl_Glut_Bitmap_Font ptr,byval string_ as const zstring ptr) as long
declare sub      GlutBitmapString(byval font as Fl_Glut_Bitmap_Font ptr,byval string_ as const zstring ptr)
declare function GlutBitmapWidth(byval fon as Fl_Glut_Bitmap_Font ptr,byval character as long) as long
' stroke font
declare function GlutStrokeRoman() as Fl_Glut_StrokeFont ptr
declare function GlutStrokeMonoRoman() as  Fl_Glut_StrokeFont ptr
declare sub      GlutStrokeCharacter(byval font as Fl_Glut_StrokeFont ptr,byval character as long) 
declare function GlutStrokeHeight(byval font as Fl_Glut_StrokeFont ptr) as single
declare function GlutStrokeLength(byval font as Fl_Glut_StrokeFont ptr,byval string_ as const zstring ptr) as long
declare sub      GlutStrokeString(byval font as Fl_Glut_StrokeFont ptr,byval string_ as const zstring ptr)
declare function GlutStrokeWidth(byval font as Fl_Glut_StrokeFont ptr,byval character as long) as long
' 3D models
declare sub      GlutWireSphere(byval radius as double,byval slices as long,byval stacks as long)
declare sub      GlutSolidSphere(byval radius as double,byval slices as long,byval stacks as long)
declare sub      GlutWireCone(byval base_ as double,byval height as double,byval slices as long,byval stacks as long)
declare sub      GlutSolidCone(byval base_ as double,byval height as double,byval slices as long,byval stacks as long)
declare sub      GlutWireCube(byval size as double)
declare sub      GlutSolidCube(byval size as double)
declare sub      GlutWireTorus(byval innerRadius as double,byval outerRadius as double,byval sides as long,byval rings as long)
declare sub      GlutSolidTorus(byval innerRadius as double,byval outerRadius as double,byval sides as long,byval rings as long)
declare sub      GlutWireDodecahedron
declare sub      GlutSolidDodecahedron
declare sub      GlutWireTeapot(byval size as double)
declare sub      GlutSolidTeapot(byval size as double)
declare sub      GlutWireOctahedron
declare sub      GlutSolidOctahedron
declare sub      GlutWireTetrahedron
declare sub      GlutSolidTetrahedron
declare sub      GlutWireIcosahedron
declare sub      GlutSolidIcosahedron

end extern

' helpers
sub Fl_GlutInit
  dim as long argc=0
  dim as zstring ptr argv=0
  GlutInit @argc,@argv
end sub


' same as gluPerspective
sub Perspective(fov as double, ratio as double, zNear as double, zFar as double)
  dim as double fH = tan( fov / 360.0 * 3.1415926535897932384626433832795 ) * zNear
  dim as double fW = fH * ratio
  glFrustum(-fW,fW,-fH,fH,zNear,zFar)
end sub

' same as gluLookAt
sub LookAt(ex as double, ey as double, ez as double, _
           lx as double, ly as double, lz as double, _
           ux as double, uy as double, uz as double )
  dim as double z(2) = {ex-lx,ey-ly,ez-lz}
  dim as double l=z(0)*z(0)+z(1)*z(1)+z(2)*z(2)
  if (l) then
    l=1.0/sqr(l):z(0)*=l:z(1)*=l:z(2)*=l
  end if
  dim as double x(2)={uy*z(2)-uz*z(1), _
                     -ux*z(2)+uz*z(0), _
                      ux*z(1)-uy*z(0)}
  l=x(0)*x(0)+x(1)*x(1)+x(2)*x(2)
  if (l) then
    l=1.0/sqr(l):x(0)*=l:x(1)*=l:x(2)*=l
  end if
  dim as double y(2)={z(1)*x(2)-z(2)*x(1), _
                     -z(0)*x(2)+z(2)*x(0), _
                      z(0)*x(1)-z(1)*x(0)}

  l=y(0)*y(0)+y(1)*y(1)+y(2)*y(2)
  if (l) then
    l=1.0/sqr(l):y(0)*=l:y(1)*=l:y(2)*=l
  end if
  dim as double m4x4(15)=>{x(0),y(0),z(0),0, _
                           x(1),y(1),z(1),0, _
                           x(2),y(2),z(2),0, _
                              0,   0,   0,1}
  glMultMatrixd @m4x4(0)
  glTranslated -ex,-ey,-ez
end sub

' o m4x4 = m m4x4.invert()
function IMD(m as const double ptr, o as double ptr) as boolean
  dim as double t(15)
  dim as double ptr inv=@t(0)
  inv[ 0] =  m[5]*m[10]*m[15] - m[ 5]*m[11]*m[14] - m[ 9]*m[6]*m[15] + m[9]*m[7]*m[14] + m[13]*m[6]*m[11] - m[13]*m[7]*m[10]
  inv[ 4] = -m[4]*m[10]*m[15] + m[ 4]*m[11]*m[14] + m[ 8]*m[6]*m[15] - m[8]*m[7]*m[14] - m[12]*m[6]*m[11] + m[12]*m[7]*m[10]
  inv[ 8] =  m[4]*m[ 9]*m[15] - m[ 4]*m[11]*m[13] - m[ 8]*m[5]*m[15] + m[8]*m[7]*m[13] + m[12]*m[5]*m[11] - m[12]*m[7]*m[ 9]
  inv[12] = -m[4]*m[ 9]*m[14] + m[ 4]*m[10]*m[13] + m[ 8]*m[5]*m[14] - m[8]*m[6]*m[13] - m[12]*m[5]*m[10] + m[12]*m[6]*m[ 9]
  inv[ 1] = -m[1]*m[10]*m[15] + m[ 1]*m[11]*m[14] + m[ 9]*m[2]*m[15] - m[9]*m[3]*m[14] - m[13]*m[2]*m[11] + m[13]*m[3]*m[10]
  inv[ 5] =  m[0]*m[10]*m[15] - m[ 0]*m[11]*m[14] - m[ 8]*m[2]*m[15] + m[8]*m[3]*m[14] + m[12]*m[2]*m[11] - m[12]*m[3]*m[10]
  inv[ 9] = -m[0]*m[ 9]*m[15] + m[ 0]*m[11]*m[13] + m[ 8]*m[1]*m[15] - m[8]*m[3]*m[13] - m[12]*m[1]*m[11] + m[12]*m[3]*m[ 9]
  inv[13] =  m[0]*m[ 9]*m[14] - m[ 0]*m[10]*m[13] - m[ 8]*m[1]*m[14] + m[8]*m[2]*m[13] + m[12]*m[1]*m[10] - m[12]*m[2]*m[ 9]
  inv[ 2] =  m[1]*m[ 6]*m[15] - m[ 1]*m[ 7]*m[14] - m[ 5]*m[2]*m[15] + m[5]*m[3]*m[14] + m[13]*m[2]*m[ 7] - m[13]*m[3]*m[ 6]
  inv[ 6] = -m[0]*m[ 6]*m[15] + m[ 0]*m[ 7]*m[14] + m[ 4]*m[2]*m[15] - m[4]*m[3]*m[14] - m[12]*m[2]*m[ 7] + m[12]*m[3]*m[ 6]
  inv[10] =  m[0]*m[ 5]*m[15] - m[ 0]*m[ 7]*m[13] - m[ 4]*m[1]*m[15] + m[4]*m[3]*m[13] + m[12]*m[1]*m[ 7] - m[12]*m[3]*m[ 5]
  inv[14] = -m[0]*m[ 5]*m[14] + m[ 0]*m[ 6]*m[13] + m[ 4]*m[1]*m[14] - m[4]*m[2]*m[13] - m[12]*m[1]*m[ 6] + m[12]*m[2]*m[ 5]
  inv[ 3] = -m[1]*m[ 6]*m[11] + m[ 1]*m[ 7]*m[10] + m[ 5]*m[2]*m[11] - m[5]*m[3]*m[10] - m[ 9]*m[2]*m[ 7] + m[ 9]*m[3]*m[ 6]
  inv[ 7] =  m[0]*m[ 6]*m[11] - m[ 0]*m[ 7]*m[10] - m[ 4]*m[2]*m[11] + m[4]*m[3]*m[10] + m[ 8]*m[2]*m[ 7] - m[ 8]*m[3]*m[ 6]
  inv[11] = -m[0]*m[ 5]*m[11] + m[ 0]*m[ 7]*m[ 9] + m[ 4]*m[1]*m[11] - m[4]*m[3]*m[ 9] - m[ 8]*m[1]*m[ 7] + m[ 8]*m[3]*m[ 5]
  inv[15] =  m[0]*m[ 5]*m[10] - m[ 0]*m[ 6]*m[ 9] - m[ 4]*m[1]*m[10] + m[4]*m[2]*m[ 9] + m[ 8]*m[1]*m[ 6] - m[ 8]*m[2]*m[ 5]

  dim as double det = m[0]*inv[0] + m[1]*inv[4] + m[2]*inv[8] + m[3]*inv[12]
  if (det = 0) then return false
  det = 1.0 / det
  for i as long = 0 to 15
    o[i] = inv[i] * det
  next
  return true
end function

' r m4x4 = a m4x4 * b m4x4
sub MMD(a as const double ptr, b as const double ptr, r as double ptr)
  r[ 0] = a[ 0]*b[0] + a[ 1]*b[4] +a[ 2]*b[ 8] + a[ 3]*b[12]
  r[ 1] = a[ 0]*b[1] + a[ 1]*b[5] +a[ 2]*b[ 9] + a[ 3]*b[13]
  r[ 2] = a[ 0]*b[2] + a[ 1]*b[6] +a[ 2]*b[10] + a[ 3]*b[14]
  r[ 3] = a[ 0]*b[3] + a[ 1]*b[7] +a[ 2]*b[11] + a[ 3]*b[15]
  r[ 4] = a[ 4]*b[0] + a[ 5]*b[4] +a[ 6]*b[ 8] + a[ 7]*b[12]
  r[ 5] = a[ 4]*b[1] + a[ 5]*b[5] +a[ 6]*b[ 9] + a[ 7]*b[13]
  r[ 6] = a[ 4]*b[2] + a[ 5]*b[6] +a[ 6]*b[10] + a[ 7]*b[14]
  r[ 7] = a[ 4]*b[3] + a[ 5]*b[7] +a[ 6]*b[11] + a[ 7]*b[15]
  r[ 8] = a[ 8]*b[0] + a[ 9]*b[4] +a[10]*b[ 8] + a[11]*b[12]
  r[ 9] = a[ 8]*b[1] + a[ 9]*b[5] +a[10]*b[ 9] + a[11]*b[13]
  r[10] = a[ 8]*b[2] + a[ 9]*b[6] +a[10]*b[10] + a[11]*b[14]
  r[11] = a[ 8]*b[3] + a[ 9]*b[7] +a[10]*b[11] + a[11]*b[15]
  r[12] = a[12]*b[0] + a[13]*b[4] +a[14]*b[ 8] + a[15]*b[12]
  r[13] = a[12]*b[1] + a[13]*b[5] +a[14]*b[ 9] + a[15]*b[13]
  r[14] = a[12]*b[2] + a[13]*b[6] +a[14]*b[10] + a[15]*b[14]
  r[15] = a[12]*b[3] + a[13]*b[7] +a[14]*b[11] + a[15]*b[15]
end sub
' o = m4x4 * v4
sub MMV(m as const double ptr, v as const double ptr, o as double ptr)
  o[0] = v[0]*m[0] + v[1]*m[4] + v[2]*m[ 8] + v[3]* m[12]
  o[1] = v[0]*m[1] + v[1]*m[5] + v[2]*m[ 9] + v[3]* m[13]
  o[2] = v[0]*m[2] + v[1]*m[6] + v[2]*m[10] + v[3]* m[14]
  o[3] = v[0]*m[3] + v[1]*m[7] + v[2]*m[11] + v[3]* m[15]
end sub

' same as gluUnproject
function UnProject(winx as double, winy as double , winz as double, _
                   mMatrix  as const double ptr, _
                   pMatrix  as const double ptr, _
                   viewport as const long ptr, _
                   ox as double ptr, oy as double ptr, oz as double ptr) as long
  dim as double t(15)
  dim as double ptr fMatrix=@t(0)
  MMD(mMatrix, pMatrix, fMatrix)
  if IMD(fMatrix, fMatrix)=0 then return 0
  dim as double i(3)={winx,winy,winz,1.0}
  i(0) = (i(0) - viewport[0]) / viewport[2]
  i(1) = (i(1) - viewport[1]) / viewport[3]
  i(0) = i(0) * 2 - 1
  i(1) = i(1) * 2 - 1
  i(2) = i(2) * 2 - 1
  dim as double o(3) : MMV(fMatrix, @i(0), @o(0))
  if (o(3) = 0.0) then return 0
  o(3)=1.0/o(3)
  *ox = o(0)*o(3):*oy = o(1)*o(3):*oz = o(2)*o(3)
  return 1
end function

sub MouseUnproject(      mx as single,      my as single,      mz as single, _
                   byref ox as single,byref oy as single,byref oz as single)
  dim as double mMatrix(15)=any
  dim as double pMatrix(15)=any 
  dim as long   vP(3)=any
  dim as double objx=any,objy=any,objz=any
  dim as double winx=mx
  dim as double winy=my
  dim as double winz=mz
  glGetDoublev(GL_MODELVIEW_MATRIX ,@mMatrix(0))
  glGetDoublev(GL_PROJECTION_MATRIX,@pMatrix(0))
  glGetIntegerv(GL_VIEWPORT ,@vP(0))
  winy=vP(3)-winy
  UnProject(winx,winy,winz, @mMatrix(0), @pMatrix(0), @vp(0), @objx, @objy, @objz)
  ox=objx:oy=objy:oz=objz
end sub

#endif ' __FLTK_GLUT__
