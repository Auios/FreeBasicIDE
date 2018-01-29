#Include "Clady3D.bi"

dim Shared camera As nCAMERA
Dim tex01 As nTEXTURE
Dim texmartor As nTEXTURE
dim i as integer
dim as single mousewh
dim shared as integer wh,cmsize,graf_mode,ws,hs,wt,ht,xs,ys,xt,yt,xofft,yofft,cmtype,_
                        xoffm,yoffm,xm,ym,wm,hm,rm
                        
dim as uinteger ptr pixeldeststart, pixelsrcstart, pixeleraserstart

xofft=0
yofft=0
wh=-1
cmsize=-1
graf_mode=-1
cmtype=-1

print ""
print "Choose the Graphic Mode : "
print "1 -->800x600,16b,fullscreen"
print "2 -->800x600,32b,fullscreen"
print "3 -->1024x768,16b,fullscreen"
print "4 -->1024x768,32b,fullscreen"
print "5 -->1280x1024,16b,fullscreen"
print "6 -->1280x1024,32b,fullscreen"
while ((graf_mode<1) or (graf_mode>6))
input "Enter the option for graphic mode : ",graf_mode
if ((graf_mode<1) or (graf_mode>6)) then print "Wrong value, the value must be 1 to 6 !"
wend
print ""
print "OK!"
print ""

print ""
print "Choose the colormap size : "
print "1 --> 512x512"
print "2 --> 1024x1024"
print "3 --> 2048x2048"
print "4 --> 4096x4096"
while ((cmsize<1) or (cmsize>4))
input "Enter the option for the colormap size : ",cmsize
if ((cmsize<1) or (cmsize>4)) then print "Wrong value, the value must be 1 to 4 !"
wend
print ""
print "OK!"
print ""
print ""
print "Choose the type of saved colormap: "
print "1 --> bmp file"
print "2 --> jpg file"
while ((cmtype<1) or (cmtype>2))
input "Enter the option for the type of saved colormap : ",cmtype
if ((cmtype<1) or (cmtype>2)) then print "Wrong value, the value must be 1 or 2 !"
wend
print ""
print "OK!"
print ""

if (cmsize=1) then wh=512
if (cmsize=2) then wh=1024
if (cmsize=3) then wh=2048
if (cmsize=4) then wh=4096

wt=wh
ht=wh

'Enable vertical synch.
nEnableVsync()

'Starts the Ninfa3D Engine
'InitEngine(1,1280,1024,32,1)

if (graf_mode=1) then 
    InitEngine(1,800,600,16,1)
    ws=800
    hs=600
    end if
if (graf_mode=2) then 
    InitEngine(1,800,600,32,1)
    ws=800
    hs=600
    end if
if (graf_mode=3) then 
    InitEngine(1,1024,768,16,1)
    ws=1024
    hs=768
    end if
if (graf_mode=4) then 
    InitEngine(1,1024,768,32,1)
    ws=1024
    hs=768
    end if
if (graf_mode=5) then 
    InitEngine(1,1280,1024,16,1)
    ws=1280
    hs=1024
    end if
if (graf_mode=6) then 
    InitEngine(1,1280,1024,32,1)
    ws=1280
    hs=1024
    end if
nSetBackGroundColor(128,128,128)'Background Color
nSetAmbientLight(64,64,64)'Ambient color
		
'Include the file "SampleFuntions.bi.
'It contains useful features, such as drawing the interface and create the test area.
'#Include "SampleFunctions.bi"

'Create a camera
camera = nCreateCamera()

'tex01 = LoadTexture("media\logofinal.png")
dim img1 as nimage
'img1=LoadImageFromFile("media\logofinal.png")
dim as ntexture tex=nloadtexture("images/tilebase.jpg")
'dim as integer w1=GetImageWidth(img1)
'dim as integer h1=GetImageHeight(img1)
dim as nfont font01 = nLoadFont("font\courier.xml")'Load the font, in format XML
'dim as ntexture tex2=loadtexture("images/sand.jpg")


'dim as ntexture tex3=Createtexture("test21",1024,1024,3)
'dim as ntexture tex4=Createtexture("test22",1024,1024,3)
'stergere
'dim as ntexture tex5=Createtexture("test23",1024,1024,3)

'dim as ntexture tex3=Createtexture("test21",512,512,3)
'dim as ntexture tex4=Createtexture("test22",512,512,3)
'stergere
dim as ntexture texdest=nCreatetexture("dest",wt,ht,3)


i=nBlendtextures (texdest,tex, 0,0,BLEND_SCREEN)
dim as ntexture texeraser=nCreatetexture("eraser",wt,ht,3)
i=nBlendtextures (texeraser,tex, 0,0,BLEND_SCREEN)

nremovetexture(tex)

dim as ntexture texsrc=nCreatetexture("source",wt,ht,3)
tex=nloadtexture("images/tile1.jpg")
i=nBlendtextures (texsrc,tex, 0,0,BLEND_SCREEN)
nremovetexture(tex)

wm=128
hm=128
xoffm=ws-wm-1
yoffm=hs-hm-1
texmartor=nloadtexture("images/martor.bmp")


dim as nimage microimtilebase = nCreateImage(32,32,3)
dim as nimage microimtile1 = nCreateImage(32,32,3)
dim as nimage microimtile2 = nCreateImage(32,32,3)
dim as nimage microimtile3 = nCreateImage(32,32,3)
dim as nimage microimtile4 = nCreateImage(32,32,3)
dim as nimage microimtile5 = nCreateImage(32,32,3)
dim as nimage microimtile6 = nCreateImage(32,32,3)
dim as nimage microimtile7 = nCreateImage(32,32,3)
dim as nimage microimtile8 = nCreateImage(32,32,3)
dim as nimage microimtile9 = nCreateImage(32,32,3)
dim as nimage microimtileshader = nCreateImage(32,32,3)

dim as nimage maximagebase=nLoadImageFromFile("images/tilebase.jpg")
nCopyImageToScaling(maximagebase,microimtilebase)
dim as ntexture microtextilebase=nCreateTextureFromImage(microimtilebase)
nremoveimage(microimtilebase)
nremoveimage(maximagebase)

dim as nimage maximagetile1=nLoadImageFromFile("images/tile1.jpg")
nCopyImageToScaling(maximagetile1,microimtile1)
dim as ntexture microtextile1=nCreateTextureFromImage(microimtile1)
nremoveimage(microimtile1)
nremoveimage(maximagetile1)

dim as nimage maximagetile2=nLoadImageFromFile("images/tile2.jpg")
nCopyImageToScaling(maximagetile2,microimtile2)
dim as ntexture microtextile2=nCreateTextureFromImage(microimtile2)
nremoveimage(microimtile2)
nremoveimage(maximagetile2)

dim as nimage maximagetile3=nLoadImageFromFile("images/tile3.jpg")
nCopyImageToScaling(maximagetile3,microimtile3)
dim as ntexture microtextile3=nCreateTextureFromImage(microimtile3)
nremoveimage(microimtile3)
nremoveimage(maximagetile3)

dim as nimage maximagetile4=nLoadImageFromFile("images/tile4.jpg")
nCopyImageToScaling(maximagetile4,microimtile4)
dim as ntexture microtextile4=nCreateTextureFromImage(microimtile4)
nremoveimage(microimtile4)
nremoveimage(maximagetile4)

dim as nimage maximagetile5=nLoadImageFromFile("images/tile5.jpg")
nCopyImageToScaling(maximagetile5,microimtile5)
dim as ntexture microtextile5=nCreateTextureFromImage(microimtile5)
nremoveimage(microimtile5)
nremoveimage(maximagetile5)

dim as nimage maximagetile6=nLoadImageFromFile("images/tile6.jpg")
nCopyImageToScaling(maximagetile6,microimtile6)
dim as ntexture microtextile6=nCreateTextureFromImage(microimtile6)
nremoveimage(microimtile6)
nremoveimage(maximagetile6)

dim as nimage maximagetile7=nLoadImageFromFile("images/tile7.jpg")
nCopyImageToScaling(maximagetile7,microimtile7)
dim as ntexture microtextile7=nCreateTextureFromImage(microimtile7)
nremoveimage(microimtile7)
nremoveimage(maximagetile7)

dim as nimage maximagetile8=nLoadImageFromFile("images/tile8.jpg")
nCopyImageToScaling(maximagetile8,microimtile8)
dim as ntexture microtextile8=nCreateTextureFromImage(microimtile8)
nremoveimage(microimtile8)
nremoveimage(maximagetile8)

dim as nimage maximagetile9=nLoadImageFromFile("images/tile9.jpg")
nCopyImageToScaling(maximagetile9,microimtile9)
dim as ntexture microtextile9=nCreateTextureFromImage(microimtile9)
nremoveimage(microimtile9)
nremoveimage(maximagetile9)


dim as nimage maximagetileshader=nLoadImageFromFile("images/tileshader.jpg")
nCopyImageToScaling(maximagetileshader,microimtileshader)
dim as ntexture microtextileshader=nCreateTextureFromImage(microimtileshader)
nremoveimage(microimtileshader)
nremoveimage(maximagetileshader)


'i=Blendtextures (tex3,tex1, 0,0,BLEND_SCREEN)
'i=Blendtextures (tex4,tex2, 0,0,BLEND_SCREEN)


'PaintTileWithAlpha(img3,img22,256,256,50,255)

'dim as nimage img3=CreateImage1(3,512,512)
'dim as integer w3=GetImageWidth(img3)
'dim as integer h3=GetImageHeight(img3)



'dim as integer errorcode=BlendImages(img3,img2,0,0,BLEND_SCREEN)

dim alpha as integer
dim radius as integer
alpha=50
radius=60
rm=0

'pixeldeststart=locktexture(texdest)
pixelsrcstart=nlocktexture(texsrc)
pixeleraserstart=nlocktexture(texeraser)

While(EngineRun)'Returns 1 if the engine is running.

	'Begins scene
	BeginScene()
	
	'By pressing the "ESCAPE" closes the engine.
	If KeyHit(KEY_ESCAPE) Then CloseEngine()
	if keyhit(key_1) then
        nunlocktexturenomipmap(texsrc)
		tex=nloadtexture("images/tile1.jpg")
        nremovetexture(texsrc)
        texsrc=ncreatetexture("source",wt,ht,3)
        i=nBlendtextures (texsrc,tex, 0,0,BLEND_SCREEN)
        nremovetexture(tex)
        pixelsrcstart=nlocktexture(texsrc)
    end if
    if keyhit(key_2) then
        nunlocktexturenomipmap(texsrc)
		tex=nloadtexture("images/tile2.jpg")
        nremovetexture(texsrc)
        texsrc=ncreatetexture("source",wt,ht,3)
        i=nBlendtextures (texsrc,tex, 0,0,BLEND_SCREEN)
        nremovetexture(tex)
        pixelsrcstart=nlocktexture(texsrc)
    end if
    if keyhit(key_3) then
        nunlocktexturenomipmap(texsrc)
		tex=nloadtexture("images/tile3.jpg")
        nremovetexture(texsrc)
        texsrc=ncreatetexture("source",wt,ht,3)
        i=nBlendtextures (texsrc,tex, 0,0,BLEND_SCREEN)
        nremovetexture(tex)
        pixelsrcstart=nlocktexture(texsrc)
    end if
    if keyhit(key_4) then
        nunlocktexturenomipmap(texsrc)
		tex=nloadtexture("images/tile4.jpg")
        nremovetexture(texsrc)
        texsrc=ncreatetexture("source",wt,ht,3)
        i=nBlendtextures (texsrc,tex, 0,0,BLEND_SCREEN)
        nremovetexture(tex)
        pixelsrcstart=nlocktexture(texsrc)
    end if
    if keyhit(key_5) then
        nunlocktexturenomipmap(texsrc)
		tex=nloadtexture("images/tile5.jpg")
        nremovetexture(texsrc)
        texsrc=ncreatetexture("source",wt,ht,3)
        i=nBlendtextures (texsrc,tex, 0,0,BLEND_SCREEN)
        nremovetexture(tex)
        pixelsrcstart=nlocktexture(texsrc)
    end if
    if keyhit(key_6) then
        nunlocktexturenomipmap(texsrc)
		tex=nloadtexture("images/tile6.jpg")
        nremovetexture(texsrc)
        texsrc=ncreatetexture("source",wt,ht,3)
        i=nBlendtextures (texsrc,tex, 0,0,BLEND_SCREEN)
        nremovetexture(tex)
        pixelsrcstart=nlocktexture(texsrc)
    end if
    if keyhit(key_7) then
        nunlocktexturenomipmap(texsrc)
		tex=nloadtexture("images/tile7.jpg")
        nremovetexture(texsrc)
        texsrc=ncreatetexture("source",wt,ht,3)
        i=nBlendtextures (texsrc,tex, 0,0,BLEND_SCREEN)
        nremovetexture(tex)
        pixelsrcstart=nlocktexture(texsrc)
    end if
    if keyhit(key_8) then
        nunlocktexturenomipmap(texsrc)
		tex=nloadtexture("images/tile8.jpg")
        nremovetexture(texsrc)
        texsrc=ncreatetexture("source",wt,ht,3)
        i=nBlendtextures (texsrc,tex, 0,0,BLEND_SCREEN)
        nremovetexture(tex)
        pixelsrcstart=nlocktexture(texsrc)
    end if
    if keyhit(key_9) then
        nunlocktexturenomipmap(texsrc)
		tex=nloadtexture("images/tile9.jpg")
        nremovetexture(texsrc)
        texsrc=ncreatetexture("source",wt,ht,3)
        i=nBlendtextures (texsrc,tex, 0,0,BLEND_SCREEN)
        nremovetexture(tex)
        pixelsrcstart=nlocktexture(texsrc)
    end if
    
    if keyhit(key_0) then
        nunlocktexturenomipmap(texsrc)
		tex=nloadtexture("images/tileshader.jpg")
        nremovetexture(texsrc)
        texsrc=ncreatetexture("source",wt,ht,3)
        i=nBlendtextures (texsrc,tex, 0,0,BLEND_SCREEN)
        nremovetexture(tex)
        pixelsrcstart=nlocktexture(texsrc)
    end if
    
    if keydown(key_W) then alpha=alpha+1
    if keydown(key_S) then alpha = alpha-1
    if alpha<0 then alpha=0
    if alpha>255 then alpha=255
    
    if keydown(key_Q) then radius=radius+1
    if keydown(key_A) then radius = radius-1
    if radius<1 then radius=1
    'if radius>90 then radius=90
    
   
    
	'Update the Engine.
	'Changing the value (only affects the physics) that will update the
	'Physical faster or slower.
	UpdateEngine(0)
    
    nSetFont(font01)
    
    xs=nGetMouseX()
    ys=nGetMouseY()
    xt=xs+xofft
    yt=ys+yofft
    
    if (xs<=5) then xofft=xofft-10
    if (xofft<0) then xofft=0
    if (xs>=ws-5) then xofft=xofft+10
    if (xofft>wt) then xofft=xofft-100
    
    
    if (ys<=5) then yofft=yofft-10
    if (yofft<0) then yofft=0
    if (ys>=hs-5) then yofft=yofft+10
    if (yofft>ht) then yofft=yofft-100
    
    nSetTransparency2D(255)'
    
    nSetColors2D(255,255,255)
	
    ' Change the color
	
	
	'Image(texdest,0,0)' Draw the image
    nDrawImageSprites2D(texdest,0,0,xofft,yofft,wt,ht)
    
    nSetColors2D(255,0,0)
    nDrawOval2D(xs,ys,radius)
    
    nSetColors2D(255,255,255)
    nDrawFontText(10,20,"PAINT --> MOUSE LEFT",0,0)
    nDrawFontText(10,40,"ERASE --> MOUSE RIGHT",0,0)
    nDrawFontText(10,60,"RAISE ALPHA --> W",0,0)
    nDrawFontText(10,80,"DECREASE ALPHA --> S",0,0)
    nDrawFontText(10,100,"RAISE RADIUS --> Q",0,0)
    nDrawFontText(10,120,"DECREASE RADIUS --> A",0,0)
    nDrawFontText(10,140,"SELECT TILE --> 1 TO 0",0,0)
    nDrawFontText(10,160,"(OR SELECT WITH MIDDLE MOUSE BUTTON)",0,0)
    nDrawFontText(10,180,"SAVE COLORMAP --> F2",0,0)
    nDrawFontText(10,210,"Alpha = "+str(alpha),0,0)
    nDrawFontText(10,230,"Radius = "+str(radius),0,0)
    nDrawFontText(10,260,"X: "+str(xs+xofft),0,0)
    nDrawFontText(10,280,"Y: "+str(ys+yofft),0,0)
    
    
    
        
    'paint
    If MouseDown(MOUSE_LEFT) Then 
        pixeldeststart=nlocktexture(texdest)
        nPaintTiletextureWithAlpha3(texdest,texsrc,pixeldeststart,pixelsrcstart,yt,xt,radius,alpha)
        nunlocktexturenomipmap(texdest)
    end if
    
    'erase
    If MouseDown(MOUSE_RIGHT) Then 
        pixeldeststart=nlocktexture(texdest)
        nPaintTiletextureWithAlpha3(texdest,texeraser,pixeldeststart,pixeleraserstart,yt,xt,radius,alpha)
        nunlocktexturenomipmap(texdest)
    end if
    
    If KeyHit(KEY_F2) Then 
       img1=nCreateImageFromTexture(texdest,0,0,wt,ht)
        nWriteImageToFile(img1,cmtype)
        nremoveimage(img1)
        end if
    
	nSetTransparency2D(200)
    nSetColors2D(255,255,255)
    nDrawImage2DwithAlpha(texmartor,xoffm,yoffm,1)
    xm=xoffm+int(xt/(wt/wm))
    ym=yoffm+int(yt/(ht/hm))
    nSetTransparency2D(255)
    nSetColors2D(255,0,0)
    rm=rm+1
    if (rm>5) then rm=1
    nDrawOval2D(xm,ym,rm)
    
    nSetColors2D(255,255,255)
	nDrawImage2D(microtextilebase,0,hs-40)
    nDrawFontText(0,hs-25,"base",0,0)
    nDrawImage2D(microtextile1,33,hs-40)
    nDrawFontText(34,hs-25," 1",0,0)
    nDrawImage2D(microtextile2,66,hs-40)
    nDrawFontText(67,hs-25," 2",0,0)
    nDrawImage2D(microtextile3,99,hs-40)
    nDrawFontText(100,hs-25," 3",0,0)
    nDrawImage2D(microtextile4,132,hs-40)
    nDrawFontText(133,hs-25," 4",0,0)
    nDrawImage2D(microtextile5,165,hs-40)
    nDrawFontText(166,hs-25," 5",0,0)
    nDrawImage2D(microtextile6,198,hs-40)
    nDrawFontText(199,hs-25," 6",0,0)
    nDrawImage2D(microtextile7,231,hs-40)
    nDrawFontText(232,hs-25," 7",0,0)
    nDrawImage2D(microtextile8,264,hs-40)
    nDrawFontText(265,hs-25," 8",0,0)
    nDrawImage2D(microtextile9,297,hs-40)
    nDrawFontText(298,hs-25," 9",0,0)
    nDrawImage2D(microtextileshader,330,hs-40)
    nDrawFontText(331,hs-35," 0",0,0)
    nDrawFontText(330,hs-20,"shadow",0,0)
    
    if mousehit(mouse_middle) then
        if nGetMouseX()>32 and nGetMouseX()<66 and nGetMouseY()>(hs-40) and nGetMouseY()<(hs-8) then
            nunlocktexturenomipmap(texsrc)
            tex=nloadtexture("images/tile1.jpg")
            nremovetexture(texsrc)
            texsrc=ncreatetexture("source",wt,ht,3)
            i=nBlendtextures (texsrc,tex, 0,0,BLEND_SCREEN)
            nremovetexture(tex)
            pixelsrcstart=nlocktexture(texsrc)
        end if
        if nGetMouseX()>66 and nGetMouseX()<99 and nGetMouseY()>(hs-40) and nGetMouseY()<(hs-8) then
            nunlocktexturenomipmap(texsrc)
            tex=nloadtexture("images/tile2.jpg")
            nremovetexture(texsrc)
            texsrc=ncreatetexture("source",wt,ht,3)
            i=nBlendtextures (texsrc,tex, 0,0,BLEND_SCREEN)
            nremovetexture(tex)
            pixelsrcstart=nlocktexture(texsrc)
        end if
        if nGetMouseX()>99 and nGetMouseX()<132 and nGetMouseY()>(hs-40) and nGetMouseY()<(hs-8) then
            nunlocktexturenomipmap(texsrc)
            tex=nloadtexture("images/tile3.jpg")
            nremovetexture(texsrc)
            texsrc=ncreatetexture("source",wt,ht,3)
            i=nBlendtextures (texsrc,tex, 0,0,BLEND_SCREEN)
            nremovetexture(tex)
            pixelsrcstart=nlocktexture(texsrc)
        end if
        if nGetMouseX()>132 and nGetMouseX()<165 and nGetMouseY()>(hs-40) and nGetMouseY()<(hs-8) then
            nunlocktexturenomipmap(texsrc)
            tex=nloadtexture("images/tile4.jpg")
            nremovetexture(texsrc)
            texsrc=ncreatetexture("source",wt,ht,3)
            i=nBlendtextures (texsrc,tex, 0,0,BLEND_SCREEN)
            nremovetexture(tex)
            pixelsrcstart=nlocktexture(texsrc)
        end if
        if nGetMouseX()>165 and nGetMouseX()<199 and nGetMouseY()>(hs-40) and nGetMouseY()<(hs-8) then
            nunlocktexturenomipmap(texsrc)
            tex=nloadtexture("images/tile5.jpg")
            nremovetexture(texsrc)
            texsrc=ncreatetexture("source",wt,ht,3)
            i=nBlendtextures (texsrc,tex, 0,0,BLEND_SCREEN)
            nremovetexture(tex)
            pixelsrcstart=nlocktexture(texsrc)
        end if
        if nGetMouseX()>199 and nGetMouseX()<232 and nGetMouseY()>(hs-40) and nGetMouseY()<(hs-8) then
            nunlocktexturenomipmap(texsrc)
            tex=nloadtexture("images/tile6.jpg")
            nremovetexture(texsrc)
            texsrc=ncreatetexture("source",wt,ht,3)
            i=nBlendtextures (texsrc,tex, 0,0,BLEND_SCREEN)
            nremovetexture(tex)
            pixelsrcstart=nlocktexture(texsrc)
        end if
        if nGetMouseX()>232 and nGetMouseX()<264 and nGetMouseY()>(hs-40) and nGetMouseY()<(hs-8) then
            nunlocktexturenomipmap(texsrc)
            tex=nloadtexture("images/tile7.jpg")
            nremovetexture(texsrc)
            texsrc=ncreatetexture("source",wt,ht,3)
            i=nBlendtextures (texsrc,tex, 0,0,BLEND_SCREEN)
            nremovetexture(tex)
            pixelsrcstart=nlocktexture(texsrc)
        end if
        if nGetMouseX()>264 and nGetMouseX()<297 and nGetMouseY()>(hs-40) and nGetMouseY()<(hs-8) then
            nunlocktexturenomipmap(texsrc)
            tex=nloadtexture("images/tile8.jpg")
            nremovetexture(texsrc)
            texsrc=ncreatetexture("source",wt,ht,3)
            i=nBlendtextures (texsrc,tex, 0,0,BLEND_SCREEN)
            nremovetexture(tex)
            pixelsrcstart=nlocktexture(texsrc)
        end if
        if nGetMouseX()>297 and nGetMouseX()<330 and nGetMouseY()>(hs-40) and nGetMouseY()<(hs-8) then
            nunlocktexturenomipmap(texsrc)
            tex=nloadtexture("images/tile9.jpg")
            nremovetexture(texsrc)
            texsrc=ncreatetexture("source",wt,ht,3)
            i=nBlendtextures (texsrc,tex, 0,0,BLEND_SCREEN)
            nremovetexture(tex)
            pixelsrcstart=nlocktexture(texsrc)
        end if
        if nGetMouseX()>330 and nGetMouseX()<364 and nGetMouseY()>(hs-40) and nGetMouseY()<(hs-8) then
            nunlocktexturenomipmap(texsrc)
            tex=nloadtexture("images/tileshader.jpg")
            nremovetexture(texsrc)
            texsrc=ncreatetexture("source",wt,ht,3)
            i=nBlendtextures (texsrc,tex, 0,0,BLEND_SCREEN)
            nremovetexture(tex)
            pixelsrcstart=nlocktexture(texsrc)
        end if
        
        
    end if
    
    
	EndScene()
    
    
    
	
Wend
nunlocktexturenomipmap(texsrc)
nunlocktexturenomipmap(texeraser)
nremovetexture(texdest)
nremovetexture(texsrc)
nremovetexture(texeraser)
'Ends Ninfa3D Engine
EndEngine()
