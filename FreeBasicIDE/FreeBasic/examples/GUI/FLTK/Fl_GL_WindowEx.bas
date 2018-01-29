#include once "fltk-c.bi"
#include once "GL/gl.bi"
#include once "GL/glu.bi"

'test of:
' Fl_GL_WindowExNew
' Fl_GL_WindowExSetDrawCB
' Fl_GL_WindowSetMode
' Fl_WindowSizeRange

function DrawCB cdecl (byval self as any ptr) as long
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
  glClearColor rnd,rnd,rnd,1
  glClear GL_COLOR_BUFFER_BIT
  ' ...
  return 1
end function

function HandleCB cdecl (byval self as any ptr,event as Fl_Event) as long
  return Fl_GL_WindowExHandleBase(self,event)
end function

var win = Fl_GL_WindowExNew(640,400,"Fl_GL_WindowEx resize me ...")
Fl_GL_WindowExSetDrawCB   win, @DrawCB
Fl_GL_WindowExSetHandleCB win, @HandleCB
Fl_GL_WindowSetMode       win, FL_MODE_RGB or FL_MODE_DOUBLE
Fl_WindowSizeRange        win, 160,100
Fl_WindowShow             win
Fl_Run
