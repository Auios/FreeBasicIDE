#include "windows.bi"
#include "fbgfx.bi"

'FSTYLE 
 const FS_BOLD = 2
 const FS_ITALIC = 4 

Sub DrawFont(byref BUFFER As Any Ptr=0,byval POSX As long, byval POSY As long, _
  byref FTEXT As String, byref FNAME As String,byval FSIZE As long, _
 byval FCOLOR As Ulong=rgb(255,255,255),byval FSTYLE As long=0,byval CHARSET As long=DEFAULT_CHARSET )
 
  Static FINIT As long
  Static As hdc THEDC
  Static As hbitmap THEBMP
  Static As Any Ptr THEPTR
  Static As fb.image Ptr FBBLK
  Static As long TXTSZ,RESU,RESUU
  Static As hfont THEFONT
  Static As long FW,FI,TXYY',FCOR
  Static DSKWND As hwnd, DSKDC As hdc
  Static MYBMPINFO As BITMAPINFO
  Static As TEXTMETRIC MYTXINFO
  Static As SIZE TXTSIZE
  Static As RECT RCT
  #define FontSize(PointSize) -MulDiv(PointSize, GetDeviceCaps(THEDC, LOGPIXELSY), 72) 
 
  If FINIT = 0 Then   
    FINIT = 1   
    With MYBMPINFO.bmiheader
      .biSize = sizeof(BITMAPINFOHEADER)
      .biWidth = 2048
      .biHeight = -513
      .biPlanes = 1
      .biBitCount = 32
      .biCompression = BI_RGB
    End With   
    DSKWND = GetDesktopWindow()
    DSKDC = GetDC(DSKWND)
    THEDC = CreateCompatibleDC(DSKDC)
    THEBMP = CreateDIBSection(THEDC,@MYBMPINFO,DIB_RGB_COLORS,@THEPTR,null,null)  
    ReleaseDC(DSKWND,DSKDC)   
  End If
  If (FSTYLE And FS_BOLD) Then FW = FW_BOLD Else FW = FW_NORMAL   
  If (FSTYLE And FS_ITALIC) Then FI = True Else FI = False   
  THEFONT = CreateFont(FontSize(FSIZE),0,0,0,FW,FI,0,0,CHARSET,0,0,0,0,cast(Any Ptr,Strptr(FNAME)))   
  SelectObject(THEDC,THEBMP)
  SelectObject(THEDC,THEFONT)
  GetTextMetrics(THEDC,@MYTXINFO)
  GetTextExtentPoint32(THEDC,Strptr(FTEXT),Len(FTEXT),@TXTSIZE) 
  TXTSZ = TXTSIZE.CX
  TXYY = TXTSIZE.CY
  If (FSTYLE And FS_ITALIC) Then
    If MYTXINFO.tmOverhang Then
      TXTSZ += MYTXINFO.tmOverhang
    Else
      TXTSZ += 1+(FSIZE/2)
    End If
    TXYY += 1+(FSIZE/8)
  End If
    RCT.LEFT = 0
    RCT.TOP = 1
    RCT.RIGHT = TXTSZ
    RCT.BOTTOM = TXYY+1
  TXTSZ -= 1
  TXYY -= 1
  dim as ubyte ptr ubp=cptr(ubyte ptr,@FCOLOR)
  swap ubp[0],ubp[2]
  if ubp[3]=255 then ubp[3]=0
  SetBkColor(THEDC,rgba(255,0,255,0))
  SetTextColor(THEDC,FCOLOR)
  SystemParametersInfo(SPI_GETFONTSMOOTHING,null,@RESU,null)
  If RESU Then SystemParametersInfo(SPI_SETFONTSMOOTHING,False,@RESUU,null)
  ExtTextOut(THEDC,0,1,ETO_CLIPPED Or ETO_OPAQUE,@RCT,Strptr(FTEXT),Len(FTEXT),null)
  If RESU Then SystemParametersInfo(SPI_SETFONTSMOOTHING,True,@RESUU,null)
  FBBLK = THEPTR+(2048*4)-sizeof(fb.image)
  FBBLK->type = 7
  FBBLK->bpp = 4
  FBBLK->width = 2048
  FBBLK->height = 512
  FBBLK->pitch = 2048*4
   Put BUFFER,(POSX,POSY),FBBLK,(0,0)-(TXTSZ-1,TXYY),trans
  DeleteObject(THEFONT)
End Sub