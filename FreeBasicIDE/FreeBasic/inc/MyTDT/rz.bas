#include "fbgfx.bi"

const as double pi = 3.1415926, pi_180 = pi / 180

type sse_t field = 1
	s(0 to 3) as single
end type

type mmx_t field = 1
	i(0 to 1) as integer
end type


declare sub rotozoom( byref dst as FB.IMAGE ptr = 0, byref src as const FB.IMAGE ptr, byval positx as integer, byval posity as integer, byref angle as single, byref zoomx as single, byref zoomy as single, byval transcol as uinteger  = &hffff00ff)

sub rotozoom( byref dst as FB.IMAGE ptr = 0, byref src as const FB.IMAGE ptr, byval positx as integer, byval posity as integer, byref angle as single, byref zoomx as single, byref zoomy as single, byval transcol as uinteger  = &hffff00ff)
    
    'Rotozoom for 32-bit FB.Image by Dr_D(Dave Stanley) and yetifoot(Simon Nash)
    'No warranty implied... use at your own risk ;) 
    
    static as integer mx, my, col, nx, ny
    static as single nxtc, nxts, nytc, nyts
    static as single tcdzx, tcdzy, tsdzx, tsdzy
    static as integer sw2, sh2, dw, dh
    static as single tc, ts, _mx, _my
    static as uinteger ptr dstptr, srcptr, odstptr
    static as integer xput, yput, startx, endx, starty, endy
    static as integer x(3), y(3), xa, xb, ya, yb, lx, ly
    static as ubyte ptr srcbyteptr, dstbyteptr
    static as integer dstpitch, srcpitch, srcbpp, dstbpp, srcwidth, srcheight
    
    if zoomx <= 0 or zoomy <= 0 then exit sub
    
    if dst = 0 then
        dstptr = screenptr
        odstptr = dstptr
        screeninfo dw,dh,,,dstpitch
    else
        dstptr = cast( uinteger ptr, dst + 1 )
        odstptr = cast( uinteger ptr, dst + 1 )
        dw = dst->width
        dh = dst->height
        dstbpp = dst->bpp
        dstpitch = dst->pitch
    end if
    
    srcptr = cast( uinteger ptr, src + 1 )
    srcbyteptr = cast( ubyte ptr, srcptr )
    dstbyteptr = cast( ubyte ptr, dstptr )
    
    sw2 = src->width\2
    sh2 = src->height\2
    srcbpp = src->bpp
    srcpitch = src->pitch
    srcwidth = src->width
    srcheight = src->height
    
    tc = cos( angle * pi_180 )
    ts = sin( angle * pi_180 )
    tcdzx = tc/zoomx
    tcdzy = tc/zoomy
    tsdzx = ts/zoomx
    tsdzy = ts/zoomy
    
    xa = sw2 * tc * zoomx + sh2  * ts * zoomx
    ya = sh2 * tc * zoomy - sw2  * ts * zoomy
    
    xb = sh2 * ts * zoomx - sw2  * tc * zoomx
    yb = sw2 * ts * zoomy + sh2  * tc * zoomy
    
    x(0) = sw2-xa
    x(1) = sw2+xa
    x(2) = sw2-xb
    x(3) = sw2+xb
    y(0) = sh2-ya
    y(1) = sh2+ya
    y(2) = sh2-yb
    y(3) = sh2+yb
    
    for i as integer = 0 to 3
        for j as integer = i to 3
            if x(i)>=x(j) then
                swap x(i), x(j)
            end if
        next
    next
    startx = x(0)
    endx = x(3)
    
    for i as integer = 0 to 3
        for j as integer = i to 3
            if y(i)>=y(j) then
                swap y(i), y(j)
            end if
        next
    next
    starty = y(0)
    endy = y(3)
    
    positx-=sw2
    posity-=sh2
    if posity+starty<0 then starty = -posity
    if positx+startx<0 then startx = -positx
    if posity+endy<0 then endy = -posity
    if positx+endx<0 then endx = -positx
    
    if positx+startx>(dw-1) then startx = (dw-1)-positx
    if posity+starty>(dh-1) then starty = (dh-1)-posity
    if positx+endx>(dw-1) then endx = (dw-1)-positx
    if posity+endy>(dh-1) then endy = (dh-1)-posity
    if startx = endx or starty = endy then exit sub
    
    
    xput = (startx + positx) * 4
    yput = starty + posity
    ny = starty - sh2
    nx = startx - sw2
    nxtc = (nx * tcdzx)
    nxts = (nx * tsdzx)
    nytc = (ny * tcdzy)
    nyts = (ny * tsdzy)
    dstptr += dstpitch * yput \ 4
    
	dim as integer y_draw_len = (endy - starty) + 1
	dim as integer x_draw_len = (endx - startx) + 1
    
    
    'and we're off!
    asm
        mov edx, dword ptr [y_draw_len]
        
        test edx, edx ' 0?
        jz y_end      ' nothing to do here
        
        fld dword ptr[tcdzy]
        fld dword ptr[tsdzy]
        fld dword ptr [tcdzx]
        fld dword ptr [tsdzx]
        
        y_inner:
        
        fld dword ptr[nxtc]     'st(0) = nxtc, st(1) = tsdzx, st(2) = tcdzx, st(3) = tsdzy, st(4) = tcdzy
        fsub dword ptr[nyts]    'nxtc-nyts
        fiadd dword ptr[sw2]    'nxtc-nyts+sw2
        
        fld dword ptr[nxts]     'st(0) = nxts, st(1) = tsdzx, st(2) = tcdzx, st(3) = tsdzy, st(4) = tcdzy
        fadd dword ptr[nytc]    'nytc+nxts
        fiadd dword ptr[sh2]    'nxts+nytc+sh2
        'fpu stack returns to: st(0) = tsdzx, st(1) = tcdzx, st(2) = tsdzy, st(3) = tcdzy 
        
        mov ebx, [xput]
        add ebx, [dstptr]
        
        mov ecx, dword ptr [x_draw_len]
        
        test ecx, ecx ' 0?
        jz x_end      ' nothing to do here
        
        x_inner:
        
        fist dword ptr [my] ' my = _my
        
        fld st(1)           ' mx = _mx
        fistp dword ptr [mx]
        
        mov esi, dword ptr [mx]         ' esi = mx
        mov edi, dword ptr [my]         ' edi = my
        
        ' bounds checking
        test esi, esi       'mx<0?
        js no_draw          
        'mov esi, 0
        
        test edi, edi
        'mov edi, 0
        js no_draw          'my<0?

        cmp esi, dword ptr [srcwidth]   ' mx >= width?
        jge no_draw
        cmp edi, dword ptr [srcheight]  ' my >= height?
        jge no_draw
        
        ' calculate position in src buffer
        mov eax, dword ptr [srcbyteptr] ' eax = srcbyteptr
        imul edi, dword ptr [srcpitch]  ' edi = my * srcpitch
        add eax, edi
        shl esi, 2
        ' eax becomes src pixel color
        mov eax, dword ptr [eax+esi]
        cmp eax, [transcol]
        je no_draw
        
        ' draw pixel
        mov dword ptr [ebx], eax
        no_draw:
        
        fld st(3)
        faddp st(2), st(0) ' _mx += tcdzx
        fadd st(0), st(2) ' _my += tsdzx
        
        ' increment the output pointer
        add ebx, 4
        
        ' increment the x loop
        dec ecx
        jnz x_inner
        
        x_end:
        
        fstp dword ptr [_my]
        fstp dword ptr [_mx]
        
        'st(0) = tsdzx, st(1) = tcdzx, st(2) = tsdzy, st(3) = tcdzy
        'nytc += tcdzy
        fld dword ptr[nytc]
        fadd st(0), st(4)
        fstp dword ptr[nytc]
        
        'st(0) = tsdzx, st(1) = tcdzx, st(2) = tsdzy, st(3) = tcdzy
        'nyts+=tsdzy
        fld dword ptr[nyts]
        fadd st(0), st(3) 
        fstp dword ptr[nyts]
        
        'dstptr += dst->pitch
        mov eax, dword ptr [dstpitch]
        add dword ptr [dstptr], eax
        
        dec edx
        jnz y_inner
        
        y_end:
        
        finit
    end asm
    
    'hey, how did this get here?
    'http://www.youtube.com/watch?v=0ca6Wlsa-ow
    
end sub
#if 0
sub rotozoom_alpha2 _
	( _
    byref dst as FB.IMAGE ptr = 0, _
    byref src as const FB.IMAGE ptr, _
    byval positx as integer, _
    byval posity as integer, _
    byref angle as single, _
    byref zoomx as single, _
    byref zoomy as single, _
    byval transcol as uinteger = &hffff00ff, _
    byval alphalvl as integer = 255 _
	)
    
	'Rotozoom for 32-bit FB.Image by Dr_D(Dave Stanley) and yetifoot(Simon Nash)
	'No warranty implied... use at your own risk ;) 
    
	dim as sse_t sse0, sse1, sse2, sse3, sse4, sse5
	dim as integer nx = any, ny = any
	dim as single tcdzx = any, tcdzy = any, tsdzx = any, tsdzy = any
	dim as integer sw2 = any, sh2 = any, dw = any, dh = any
	dim as single tc = any, ts = any
	dim as uinteger ptr dstptr = any, srcptr = any
	dim as integer startx = any, endx = any, starty = any, endy = any
	dim as integer x(3), y(3)
	dim as integer xa = any, xb = any, ya = any, yb = any
	dim as integer dstpitch = any
	dim as integer srcpitch = any, srcwidth = any, srcheight = any
	dim as ulongint mask1 = &H000000FF00FF00FFULL
	dim as integer x_draw_len = any, y_draw_len = any
	'dim as ulongint alphalevel = (alphalvl) or (alphalvl  &h000000FF00FF00FFull
	dim as short alphalevel(3) = {alphalvl,alphalvl,alphalvl,alphalvl}
    
	if zoomx = 0 then exit sub
    if zoomy = 0 then zoomy = zoomx
    
	if dst = 0 then
		dstptr = screenptr
		screeninfo dw,dh,,,dstpitch
    else
		dstptr = cast( uinteger ptr, dst + 1 )
		dw = dst->width
		dh = dst->height
		dstpitch = dst->pitch
    end if
    
	srcptr = cast( uinteger ptr, src + 1 )
    
	sw2 = src->width\2
	sh2 = src->height\2
	srcpitch = src->pitch
	srcwidth = src->width
	srcheight = src->height
    
	tc = cos( angle * pi_180 )
	ts = sin( angle * pi_180 )
	tcdzx = tc/zoomx
	tcdzy = tc/zoomy
	tsdzx = ts/zoomx
	tsdzy = ts/zoomy
    
	xa = sw2 * tc * zoomx + sh2  * ts * zoomx
	ya = sh2 * tc * zoomy - sw2  * ts * zoomy
    
	xb = sh2 * ts * zoomx - sw2  * tc * zoomx
	yb = sw2 * ts * zoomy + sh2  * tc * zoomy
    
	x(0) = sw2-xa
	x(1) = sw2+xa
	x(2) = sw2-xb
	x(3) = sw2+xb
	y(0) = sh2-ya
	y(1) = sh2+ya
	y(2) = sh2-yb
	y(3) = sh2+yb
    
	for i as integer = 0 to 3
		for j as integer = i to 3
			if x(i)>=x(j) then
				swap x(i), x(j)
            end if
        next
    next
	startx = x(0)
	endx = x(3)
    
	for i as integer = 0 to 3
		for j as integer = i to 3
			if y(i)>=y(j) then
				swap y(i), y(j)
            end if
        next
    next
	starty = y(0)
	endy = y(3)
    
	positx-=sw2
	posity-=sh2
	if posity+starty<0 then starty = -posity
	if positx+startx<0 then startx = -positx
	if posity+endy<0 then endy = -posity
	if positx+endx<0 then endx = -positx
    
	if positx+startx>(dw-1) then startx = (dw-1)-positx
	if posity+starty>(dh-1) then starty = (dh-1)-posity
	if positx+endx>(dw-1) then endx = (dw-1)-positx
	if posity+endy>(dh-1) then endy = (dh-1)-posity
	if startx = endx or starty = endy then exit sub
    
	ny = starty - sh2
	nx = startx - sw2
    
	dstptr += dstpitch * (starty + posity) \ 4
    
	x_draw_len = (endx - startx)' + 1
	y_draw_len = (endy - starty)' + 1
    
	sse1.s(0) = tcdzx
	sse1.s(1) = tsdzx
    
	sse2.s(0) = -(ny * tsdzy)
	sse2.s(1) = (ny * tcdzy)
    
	sse3.s(0) = -tsdzy
	sse3.s(1) = tcdzy
    
	sse4.s(0) = (nx * tcdzx) + sw2
	sse4.s(1) = (nx * tsdzx) + sh2
    
	if x_draw_len = 0 then exit sub
	if y_draw_len = 0 then exit sub
    
	cptr( any ptr, dstptr ) += (startx + positx) * 4
    
	dim as any ptr ptr row_table = callocate( srcheight * sizeof( any ptr ) )
	dim as any ptr p = srcptr
    
	for i as integer = 0 to srcheight - 1
		row_table[i] = p
		p += srcpitch
    next i
    
	asm
		.balign 4
        
        movups xmm1, [sse1]
        movups xmm2, [sse2]
        movups xmm3, [sse3]
        movups xmm4, [sse4]
        
		.balign 4
		y_inner4:
        
        ' _mx = nxtc + sw2
        ' _my = nxts + sh2
        movaps xmm0, xmm4
        
        ' _dstptr = cptr( any ptr, dstptr )
        mov edi, dword ptr [dstptr]
        
        ' _x_draw_len = x_draw_len
        mov ecx, dword ptr [x_draw_len]
        
        ' _mx += -nyts
        ' _my += nytc
        addps xmm0, xmm2
        
		.balign 4
		x_inner4:
        
        ' get _mx and _my out of sse reg
        cvtps2pi mm0, xmm0
        
        ' mx = mmx0.i(0)
        movd esi, mm0
        
        ' shift mm0 so my is ready
        psrlq mm0, 32
        
        ' if (mx >= srcwidth) or (mx < 0) then goto no_draw3
        cmp esi, dword ptr [srcwidth]
        jae no_draw4
        
        ' my = mmx0.i(1)
        movd edx, mm0
        
        ' if (my >= srcheight) or (my < 0) then goto no_draw3
        cmp edx, dword ptr [srcheight]
        jae no_draw4
        
        ' _srcptr = srcbyteptr + (my * srcpitch) + (mx shl 2)
        shl esi, 2
        mov eax, dword ptr [row_table]
        add esi, dword ptr [eax+edx*4]
        
        '_srccol = *cptr( uinteger ptr, _srcptr )
        mov eax, dword ptr [esi]
        
        ' if (_srccol and &HFF000000) = 0 then goto no_draw3
        test eax, &HFF000000
        jz no_draw4
        
        ' if _srccol = transcol then goto no_draw3
        cmp eax, dword ptr [transcol]
        je no_draw4
        
        ' blend
        
        ' load src pixel and dst pixel mmx, with unpacking
        punpcklbw mm0, dword ptr [esi]
        punpcklbw mm1, dword ptr [edi]
        
        ' shift them to the right place
        psrlw mm0, 8                ' mm0 = 00sa00sr00sg00sb
        psrlw mm1, 8                ' mm1 = 00da00dr00dg00db
        
        ' Prepare alpha
	
        movq mm2, [alphalevel]      ' mm2 = 00sa00xx00xx00xx
        'punpckhwd mm2, mm2          ' mm2 = 00sa00sa00xx00xx
        'punpckhdq mm2, mm2          ' mm2 = 00sa00sa00sa00sa
        
        ' Perform blend
        psubw mm0, mm1              ' (sX - dX)
        pmullw mm0, mm2             ' (sX - dX) * sa
        psrlq mm0, 8                ' mm0 = 00aa00rr00gg00bb
        paddw mm0, mm1              ' ((sX - dX) * sa) + dX
        pand mm0, qword ptr [mask1] ' mask off alpha and high parts
        
        ' repack to 32 bit
        packuswb mm0, mm0
        
        ' store in destination
        movd dword ptr [edi], mm0
        
		.balign 4
		no_draw4:
        
        ' _mx += tcdzx
        ' _my += tsdzx
        addps xmm0, xmm1
        
        ' _dstptr += 4
        add edi, 4
        
        ' _x_draw_len -= 1
        sub ecx, 1
        
        jnz x_inner4
        
		x_end4:
        
        ' nyts += tsdzy
        ' nytc += tcdzy
        addps xmm2, xmm3
        
        ' cptr( any ptr, dstptr ) += dstpitch
        mov eax, dword ptr [dstpitch]
        add dword ptr [dstptr], eax
        
        ' y_draw_len -= 1
        sub dword ptr [y_draw_len], 1
        
        jnz y_inner4
        
		y_end4:
        
        emms
    end asm
    
	deallocate( row_table )
    
  end sub
#endif