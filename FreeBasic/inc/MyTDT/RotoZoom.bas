#include once "fbgfx.bi"

const PI_180 = 3.141592/180
#define ZoomSize uinteger

'Dr_D rotozoom code... nothing super, just a rotozoomer. :p


sub rotozoom( byref dst as FB.IMAGE ptr = 0, byref src as FB.IMAGE ptr, byref positx as integer, byref posity as integer, byref angle as single, byref zoomx as single, byref zoomy as single )
  
  static as ZoomSize Col
  static as integer nx, ny, mx, my
  static as single nxtc, nxts, nytc, nyts
  static as integer sw2, sh2, dw, dh
  static as single tc,ts
  static as ZoomSize ptr dstptr, srcptr
  static as integer xput, yput, startx, endx, starty, endy
  
  if dst = 0 then
    dstptr = screenptr
    screeninfo dw,dh
  else
    dstptr = cast( ZoomSize ptr, dst+1)
    dw = dst->width
    dh = dst->height
  end if
  
  srcptr = cast( ZoomSize ptr, src+1)  
  sw2 = src->width\2
  sh2 = src->height\2  
  tc = cos( angle * pi_180 )
  ts = sin( angle * pi_180 )  
  xput = (src->width  * zoomx)
  yput = (src->height * zoomy)  
  startx = -xput
  endx = src->width + xput
  starty = -yput
  endy = src->height + yput  
  for y as integer = starty to endy    
    yput = y + posity    
    if yput>-1 and yput<dh then      
      ny = y - sh2      
      nytc = (ny * tc) / zoomy
      nyts = (ny * ts) / zoomy      
      for x as integer = startx to endx        
        xput = x+positx        
        if xput>-1 and xput<dW then          
          nx = x - sw2          
          nxtc = (nx * tc) / zoomx
          nxts = (nx * ts) / zoomx          
          mx = (nxtc - nyts) + sw2
          my = (nytc + nxts) + sh2          
          if mx>-1 and my>-1 and mx<src->width and my<src->height then            
            col = *cast(ZOOMSIZE ptr, cast(ubyte ptr, srcptr) + my * src->pitch + mx * src->bpp )            
            if col<>RGB(255,0,255) then              
              if dst = 0 then
                dstptr[ (yput * dw ) + xput ] = col
              else
                *cast(ZOOMSIZE ptr, cast(ubyte ptr, dstptr) + yput * dst->pitch + xput * dst->bpp) = col
              end if              
            end if            
          end if          
        end if        
      next      
    end if    
  next  
end sub

#if 0
screenres 400,300,8
dim as fb.image ptr MYIMG
MYIMG = Imagecreate(128,128)
bload "1-bw.bmp",MYIMG
do
  for CNT as single = 0 to 359 step 1
    screenlock
    line(0,0)-(399,299),0,bf
    rotozoom(,MYIMG,200,150,CNT,1,1)
    screenunlock
    'sleep 1,1
  next CNT
loop
sleep
#endif