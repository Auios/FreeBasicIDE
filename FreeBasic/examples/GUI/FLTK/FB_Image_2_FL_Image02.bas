#include once "fltk-c.bi"

'test of:
' Fl_RGB_ImageNew
' Fl_WidgetSetImage http://www.fltk.org/doc-1.3/classFl__Widget.html#aff29d81e64b617158472f38d2cac186e

' if we redefine RGB and RGBA there are no needs to swap red and green anymore :-)

#undef RGB
#undef RGBA
#define RGBA(r,g,b,a) a shl 24 or b shl 16 or g shl 8 or r
#define RGB(r,g,b) RGBA(r,g,b,255)

ScreenRes 1,1,32,,&HFFFFFFFF
dim as ubyte ptr fb_img=ImageCreate(101,101)
dim as ubyte ptr fb_pixels
dim as integer   w,h,bpp,pitch
ImageInfo fb_img,w,h,bpp,pitch,fb_pixels
Line fb_img,(0,0)-(100,100),RGBA(0,0,0,0),BF
Circle fb_img,(50,50),50,RGB(255,255,  0),,,,F
Circle fb_img,(25,30),12,RGB(255,255,255),,,,F
Circle fb_img,(75,30),12,RGB(255,255,255),,,,F
Circle fb_img,(25,30), 7,RGB(  0,  0,  0),,,,F
Circle fb_img,(75,30), 7,RGB(  0,  0,  0),,,,F
Circle fb_img,(50,50),28,RGB(  0,  0,  0),3.14,0.0
Circle fb_img,(50,51),28,RGB(  0,  0,  0),3.14,0.0
Circle fb_img,(50,52),28,RGB(  0,  0,  0),3.14,0.0


var img = Fl_RGB_ImageNew(fb_pixels,w,h,bpp,pitch)
var win = Fl_WindowNew(w*2,h)
var box = Fl_BoxNew(w\2,0,w,h)
Fl_WidgetSetImage box,img

Fl_WindowShow win
Fl_Run
