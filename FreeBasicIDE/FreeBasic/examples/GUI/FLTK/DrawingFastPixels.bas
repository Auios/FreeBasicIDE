#include once "fltk-c.bi"

const as integer scr_w = 1024
const as integer scr_h = scr_w/16*9

const g         as single  = 9.80665
const g2        as single  = g * 2.0
const gd2       as single  = g * 0.5
const pi        as single  = 3.141592654
const pi2       as single  = pi * 2.0
const onedegree as single  = pi/180.0

const max_particles as integer = 100000
const last_particle as integer = max_particles - 1

type PARTICLE
  bt   as double ' birth time
  scrx as integer
  scry as integer
  posx as integer
  posy as integer
  v0   as single ' speed at time 0
  acc  as single
  col  as uinteger
end type
dim shared particles(max_particles) as PARTICLE

sub init_particle(byval i as integer,byval t as double)
  static w as single
  dim as single rc=cos(w     )*0.5+0.5
  dim as single gc=cos(w*1.25)*0.5+0.5
  dim as single bc=cos(w*1.5 )*0.5+0.5
  with particles(i)
    .posx=int(cos(w)*scr_w\4)
    .bt  = t
    .v0  = sin(w)*80
    .acc = cos(w)*pi+pi2*rnd
    .col = RGBA(255*bc,255*gc,255*rc,255)
  end with
  w=w+(1.0/max_particles)
end sub

sub update_particles(byval t as double)
  dim as single s,vs
  dim i as integer
  for i=0 to last_particle
    with particles(i)
      s=(t - .bt):vs=.v0*s
      .scrx=(scr_w\2) + .posx + int(vs*cos(.acc))
      .scry=(scr_h\2) -(.posy + int(vs*sin(.acc)-gd2*(s*s)))
    end with
  next
end sub   

sub render_particles(byval t   as double, _
                     byval box as Fl_Box ptr)
  static as ulong ptr Pixels=0
  var img = Fl_WidgetGetImage(box)
  if img then Fl_ImageDelete img:img=0
  if Pixels then deallocate Pixels:pixels=0
  if Pixels=0 then Pixels=allocate(scr_w*scr_h*4)
  for i as integer=0 to scr_w*scr_h-1
    Pixels[i]=&HFFFFFFFF
  next
  dim as uinteger ptr pPixels
  for i as integer=0 to last_particle
    with particles(i)
      if .scry>scr_h-1 or .scrx<0 or .scrx>scr_w then
        init_particle i,t
      elseif .scry>-1 then
        Pixels[.scrx+.scry*scr_w]=.col
      end if
    end with
  next
  img = Fl_RGB_ImageNew(Pixels,scr_w,scr_h,4,0)
  Fl_WidgetSetImage box,img
  Fl_WidgetRedraw box
end sub

'
' main
'
dim as double curtime=Timer()
for index as integer=0 to last_particle
  init_particle index,curtime
next

var win=Fl_Double_WindowNew(scr_w,scr_h)
var box=Fl_BoxNew(0,0,scr_w,scr_h)
Fl_WindowShow win

while Fl_Wait()
  curtime=timer
  update_particles curtime
  render_particles curtime,box
  sleep 1000\60,1
wend

