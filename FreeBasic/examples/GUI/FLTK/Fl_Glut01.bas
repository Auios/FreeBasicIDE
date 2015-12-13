#include once "fltk-glut.bi"

sub ReshapeFunc cdecl(byval w as long,h as long)
  if (w<1) or (h<1) then return
  glViewport(0,0,w,h)
  glMatrixMode(GL_PROJECTION)
  glLoadIdentity()
  ' replacement for gluPerspective
  Perspective(60.0,w/h,0.1,1000.0)
  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity()
end sub

sub DisplayFunc cdecl
  static as boolean init=false
  if init=false then
    glEnable(GL_DEPTH_TEST)
    glEnable(GL_LIGHTING)
    glEnable(GL_LIGHT0)
    glEnable(GL_COLOR_MATERIAL)
    glClearColor(0,.5,.5,1)
    glColor3f(.75,.5,0)
    init=true
  end if
  
  glClear GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT
  glPushMatrix
    glTranslatef(0,0,-1.5)
    'GlutSolidSphere(.5,24,24)
    GlutSolidTeapot(.5)
    'GlutSolidTorus .1,.6,16,50
    'GlutSolidCube 1
  glPopMatrix
  glFlush()
end sub

'
' main
'
Fl_GlutInit() ' helper calls GluInit(@argc,@argv)
GlutInitDisplayMode(GLUT_RGB or GLUT_DOUBLE or GLUT_DEPTH)
GlutCreateWindow("Fl_Glut_Window01.bas")
GlutDisplayFunc(@DisplayFunc)
GlutReshapeFunc(@ReshapeFunc)
GlutShowWindow()
GlutMainLoop() ' same as Fl_Run

