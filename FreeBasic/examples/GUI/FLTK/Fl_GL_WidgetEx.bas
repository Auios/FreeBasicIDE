#include once "fltk-c.bi"
#include once "GL/gl.bi"
#include once "GL/glu.bi"

'test of:
' Fl_Gl_WindowExNew
' Fl_Gl_WindowSetMode
' Fl_Gl_WindowExSetDrawCB
' Fl_Gl_WindowExSetHandleCB
' Fl_GL_WindowExHandleBase
' Fl_AddTimeout
' Fl_RepeatTimeout

function DrawCB cdecl (byval self as any ptr) as long
  static As GLUquadric Ptr sphere = 0
  if sphere=0 then
    sphere = gluNewQuadric()
    gluQuadricOrientation(sphere,GLU_OUTSIDE)
    gluQuadricDrawStyle(sphere,GLU_FILL)
    gluQuadricNormals(sphere,GLU_SMOOTH)
  end if
  
  if Fl_GL_WindowGetValid(self)=0 then
    glViewport 0,0,Fl_WidgetGetW(self),Fl_WidgetGetH(self)
    glMatrixMode GL_PROJECTION
    glLoadIdentity()
    gluPerspective 60.0,Fl_WidgetGetW(self)/Fl_WidgetGetH(self),0.1,50.0
    glMatrixMode GL_MODELVIEW
    glLoadIdentity
    glTranslatef(0,0,-1)
    glClearColor(rnd,rnd,rnd,1)
    glEnable(GL_DEPTH_TEST)
    glEnable(GL_LIGHTING)
    glEnable(GL_LIGHT0)
  end if
  
  glClear GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT
  glRotatef 1,0.33,0.33,0.33
  gluSphere sphere,.5,16,16
  return 1
end function

function HandleCB cdecl (byval self as any ptr,event as Fl_Event) as long
  return Fl_GL_WindowExHandleBase(self,event)
end function

sub TimeoutCB cdecl (byval glw as any ptr)
  Fl_WidgetRedraw glw 
  ' repeat it with 30 FPS
  Fl_RepeatTimeout 1.0/30.0, @TimeoutCB,glw
end sub
'
' main
'
var win = Fl_WindowNew(640,480,"Fltk Window with OpenGL Widget")
var glw = Fl_Gl_WindowExNew2(5,5,Fl_WidgetGetW(win)-10,Fl_WidgetGetH(win)-10)
Fl_Gl_WindowSetMode       glw, FL_MODE_RGB or FL_MODE_DOUBLE or FL_MODE_DEPTH
Fl_Gl_WindowExSetDrawCB   glw, @DrawCB
Fl_Gl_WindowExSetHandleCB glw, @HandleCB

Fl_GroupSetResizable      win,glw
Fl_WindowSizeRange        win,160,100
Fl_WindowShow win
Fl_AddTimeout             1.0, @TimeoutCB, glw
Fl_Run()
