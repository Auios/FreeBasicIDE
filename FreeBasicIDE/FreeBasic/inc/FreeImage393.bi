'' FreeImage 3.9.3
'' COVERED CODE IS PROVIDED UNDER THIS LICENSE ON AN "AS IS" BASIS, WITHOUT WARRANTY
'' OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, WITHOUT LIMITATION, WARRANTIES
'' THAT THE COVERED CODE IS FREE OF DEFECTS, MERCHANTABLE, FIT FOR A PARTICULAR PURPOSE
'' OR NON-INFRINGING. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE COVERED
'' CODE IS WITH YOU. SHOULD ANY COVERED CODE PROVE DEFECTIVE IN ANY RESPECT, YOU (NOT
'' THE INITIAL DEVELOPER OR ANY OTHER CONTRIBUTOR) ASSUME THE COST OF ANY NECESSARY
'' SERVICING, REPAIR OR CORRECTION. THIS DISCLAIMER OF WARRANTY CONSTITUTES AN ESSENTIAL
'' PART OF THIS LICENSE. NO USE OF ANY COVERED CODE IS AUTHORIZED HEREUNDER EXCEPT UNDER
'' THIS DISCLAIMER.
'' Use at your own risk!

#Ifndef __FREEIMAGE_BI__
#define __FREEIMAGE_BI__
#Inclib "FreeImage393"

#define FREEIMAGE_MAJOR_VERSION  3
#define FREEIMAGE_MINOR_VERSION  9
#define FREEIMAGE_RELEASE_SERIAL  3

#If Not Defined(__FB_WIN32__) Or Not Defined(__windows_bi__)

#Ifndef FALSE
#define FALSE 0
#EndIf
#Ifndef TRUE
#define TRUE 1
#EndIf
#Ifndef NULL
#define NULL 0
#EndIf

#Ifndef SEEK_SET
#define SEEK_SET  0
#define SEEK_CUR  1
#define SEEK_END  2
#EndIf

Type RGBQUAD Field=1
  #Ifdef __FB_BIGENDIAN__
  rgbRed As UByte
  rgbGreen As UByte
  rgbBlue As UByte
  #Else
  rgbBlue As UByte
  rgbGreen As UByte
  rgbRed As UByte
  #EndIf
  rgbReserved As UByte
End Type

Type RGBTRIPLE Field=1
  #Ifdef __FB_BIGENDIAN__
  rgbtRed As UByte
  rgbtGreen As UByte
  rgbtBlue As UByte
  #Else
  rgbtBlue As UByte
  rgbtGreen As UByte
  rgbtRed As UByte
  #EndIf
End Type

Type BITMAPINFOHEADER Field=1
  biSize As UInteger
  biWidth As UInteger
  biHeight As UInteger
  biPlanes As UShort
  biBitCount As UShort
  biCompression As UInteger
  biSizeImage As UInteger
  biXPelsPerMeter As UInteger
  biYPelsPerMeter As UInteger
  biClrUsed As UInteger
  biClrImportant As UInteger
End Type

Type BITMAPINFO
  bmiHeader  As BITMAPINFOHEADER
  bmiColors  As RGBQUAD
End Type

#EndIf '' __FB_WIN32__

'' 48-bit RGB
Type FIRGB16 Field=1
  red As UShort
  green As UShort
  blue As UShort
End Type

'' 64-bit RGBA
Type FIRGBA16 Field=1
  red As UShort
  green As UShort
  blue As UShort
  alpha As UShort
End Type

'' 96-bit RGB Float
Type FIRGBF Field=1
  red As Single
  green As Single
  blue As Single
End Type

'' 128-bit RGBA Float
Type FIRGBAF Field=1
  red As Single
  green As Single
  blue As Single
  alpha As Single
End Type

'' Data structure for COMPLEX type (complex number)
Type FICOMPLEX Field=1
  r As Double           ' real part
  i As Double           ' imaginary part
End Type

#Ifndef __FB_BIGENDIAN__
'' Little Endian (x86 / MS Windows, Linux) : BGR(A) order
#define FI_RGBA_RED  2
#define FI_RGBA_GREEN  1
#define FI_RGBA_BLUE  0
#define FI_RGBA_ALPHA  3
#define FI_RGBA_RED_MASK  &H00FF0000
#define FI_RGBA_GREEN_MASK  &H0000FF00
#define FI_RGBA_BLUE_MASK  &H000000FF
#define FI_RGBA_ALPHA_MASK  &HFF000000
#define FI_RGBA_RED_SHIFT  16
#define FI_RGBA_GREEN_SHIFT  8
#define FI_RGBA_BLUE_SHIFT  0
#define FI_RGBA_ALPHA_SHIFT  24
#Else
'' Big Endian (PPC / Linux, MaxOSX) : RGB(A) order
#define FI_RGBA_RED   0
#define FI_RGBA_GREEN  1
#define FI_RGBA_BLUE  2
#define FI_RGBA_ALPHA  3
#define FI_RGBA_RED_MASK  &hFF000000
Const FI_RGBA_GREEN_MASK=  &h00FF0000
#define FI_RGBA_BLUE_MASK &h0000FF00
#define FI_RGBA_ALPHA_MASK  &h000000FF
#define FI_RGBA_RED_SHIFT 24
Const FI_RGBA_GREEN_SHIFT=  16
Const FI_RGBA_BLUE_SHIFT=  8
#define FI_RGBA_ALPHA_SHIFT  0
#EndIf '' __FB_BIGENDIAN__

#define FI_RGBA_RGB_MASK  (FI_RGBA_RED_MASK Or FI_RGBA_GREEN_MASK Or FI_RGBA_BLUE_MASK)

'' The 16bit macros only include masks and shifts, since each color element is not byte aligned
#define FI16_555_RED_MASK  &H7C00
#define FI16_555_GREEN_MASK  &H03E0
#define FI16_555_BLUE_MASK  &H001F
#define FI16_555_RED_SHIFT  10
#define FI16_555_GREEN_SHIFT  5
#define FI16_555_BLUE_SHIFT  0
#define FI16_565_RED_MASK  &HF800
#define FI16_565_GREEN_MASK  &H07E0
#define FI16_565_BLUE_MASK  &H001F
#define FI16_565_RED_SHIFT  11
#define FI16_565_GREEN_SHIFT  5
#define FI16_565_BLUE_SHIFT  0

'' ICC profile support ------------------------------------------------------
#define FIICC_DEFAULT  &H00
#define FIICC_COLOR_IS_CMYK  &H01

Type FIICCPROFILE
  flags As Short
  size As Integer
  Data As Any Ptr
End Type

'' Important enums ----------------------------------------------------------
'' I/O image format identifiers.
Enum FREE_IMAGE_FORMAT
FIF_UNKNOWN = -1
FIF_BMP = 0
FIF_ICO = 1
FIF_JPEG = 2
FIF_JNG = 3
FIF_KOALA = 4
FIF_LBM = 5
FIF_IFF = FIF_LBM
FIF_MNG = 6
FIF_PBM = 7
FIF_PBMRAW = 8
FIF_PCD = 9
FIF_PCX = 10
FIF_PGM = 11
FIF_PGMRAW = 12
FIF_PNG = 13
FIF_PPM = 14
FIF_PPMRAW = 15
FIF_RAS = 16
FIF_TARGA = 17
FIF_TIFF = 18
FIF_WBMP = 19
FIF_PSD = 20
FIF_CUT = 21
FIF_XBM = 22
FIF_XPM = 23
FIF_DDS = 24
FIF_GIF = 25
FIF_HDR  = 26
FIF_FAXG3 = 27
FIF_SGI  = 28
End Enum

Enum FREE_IMAGE_TYPE
FIT_UNKNOWN = 0
FIT_BITMAP = 1
FIT_UINT16 = 2
FIT_INT16 = 3
FIT_UINT32 = 4
FIT_INT32 = 5
FIT_FLOAT = 6
FIT_DOUBLE = 7
FIT_COMPLEX = 8
FIT_RGB16 = 9
FIT_RGBA16 = 10
FIT_RGBF = 11 '' 96-bit RGB float image : 3 x 32-bit IEEE floating point
FIT_RGBAF = 12 '' 128-bit RGBA float image : 4 x 32-bit IEEE floating point
End Enum

Enum FREE_IMAGE_COLOR_TYPE
FIC_MINISWHITE = 0
FIC_MINISBLACK = 1
FIC_RGB = 2
FIC_PALETTE = 3
FIC_RGBALPHA = 4
FIC_CMYK = 5
End Enum

Enum FREE_IMAGE_QUANTIZE
FIQ_WUQUANT = 0
FIQ_NNQUANT = 1
End Enum

Enum FREE_IMAGE_DITHER
FID_FS = 0
FID_BAYER4x4 = 1
FID_BAYER8x8 = 2
FID_CLUSTER6x6 = 3
FID_CLUSTER8x8 = 4
FID_CLUSTER16x16 = 5
FID_BAYER16x16 = 6
End Enum

Enum FREE_IMAGE_JPEG_OPERATION
FIJPEG_OP_NONE = 0 '' no transformation
FIJPEG_OP_FLIP_H = 1 '' horizontal flip
FIJPEG_OP_FLIP_V = 2 '' vertical flip
FIJPEG_OP_TRANSPOSE = 3 '' transpose across UL-to-LR axis
FIJPEG_OP_TRANSVERSE = 4 '' transpose across UR-to-LL axis
FIJPEG_OP_ROTATE_90 = 5 '' 90-degree clockwise rotation
FIJPEG_OP_ROTATE_180 = 6 '' 180-degree rotation
FIJPEG_OP_ROTATE_270 = 7  '' 270-degree clockwise (or 90 ccw)
End Enum

Enum FREE_IMAGE_TMO
FITMO_DRAGO03 = 0
FITMO_REINHARD05 = 1
End Enum

Enum FREE_IMAGE_FILTER
FILTER_BOX = 0
FILTER_BICUBIC = 1
FILTER_BILINEAR = 2
FILTER_BSPLINE = 3
FILTER_CATMULLROM = 4
FILTER_LANCZOS3 = 5
End Enum

Enum FREE_IMAGE_COLOR_CHANNEL
FICC_RGB = 0
FICC_RED = 1
FICC_GREEN = 2
FICC_BLUE = 3
FICC_ALPHA = 4
FICC_BLACK = 5
FICC_REAL = 6
FICC_IMAG = 7
FICC_MAG = 8
FICC_PHASE = 9
End Enum

'' Metadata support ---------------------------------------------------------
Enum FREE_IMAGE_MDTYPE
FIDT_NOTYPE = 0
FIDT_BYTE = 1
FIDT_ASCII = 2
FIDT_SHORT = 3
FIDT_LONG = 4
FIDT_RATIONAL = 5
FIDT_SBYTE = 6
FIDT_UNDEFINED = 7
FIDT_SSHORT = 8
FIDT_SLONG = 9
FIDT_SRATIONAL = 10
FIDT_FLOAT = 11
FIDT_DOUBLE = 12
FIDT_IFD = 13
FIDT_PALETTE = 14
End Enum

Enum FREE_IMAGE_MDMODEL
FIMD_NODATA = -1
FIMD_COMMENTS = 0
FIMD_EXIF_MAIN = 1
FIMD_EXIF_EXIF = 2
FIMD_EXIF_GPS = 3
FIMD_EXIF_MAKERNOTE = 4
FIMD_EXIF_INTEROP = 5
FIMD_IPTC = 6
FIMD_XMP = 7
FIMD_GEOTIFF = 8
FIMD_ANIMATION = 9
FIMD_CUSTOM = 10
End Enum

Type FIMETADATA
  Data As Any Ptr
End Type

Type FITAG
  Data As Any Ptr
End Type

Type FIBITMAP
  Data As Any Ptr
End Type

Type FIMULTIBITMAP
  Data As Any Ptr
End Type


'' File IO routines ---------------------------------------------------------
Type FreeImageIO
  read_proc As Function (ByVal buffer As Any Ptr, ByVal size As UInteger, ByVal count As UInteger, ByVal handle As Any Ptr) As UInteger
  write_proc As Function (ByVal buffer As Any Ptr, ByVal size As UInteger, ByVal count As UInteger, ByVal handle As Any Ptr) As UInteger
  seek_proc As Function (ByVal handle As Any Ptr, ByVal Offset As Integer, ByVal origin As Integer) As Integer
  tell_proc As Function (ByVal handle As Any Ptr) As Integer
End Type

Type FIMEMORY
  Data As Any Ptr
End Type

'' Plugin routines ----------------------------------------------------------
Type Plugin
  format_proc As UInteger
  description_proc As UInteger
  extension_proc As UInteger
  regexpr_proc As UInteger
  open_proc As UInteger
  close_proc As UInteger
  pagecount_proc As UInteger
  pagecapability_proc As UInteger
  load_proc As UInteger
  save_proc As UInteger
  validate_proc As UInteger
  mime_proc As Integer
  supports_export_bpp_proc As UInteger
  supports_export_type_proc As UInteger
  supports_icc_profiles_proc As UInteger
End Type

'' Load / Save flag constants -----------------------------------------------
#define BMP_DEFAULT  0
#define BMP_SAVE_RLE  1
#define CUT_DEFAULT  0
#define DDS_DEFAULT  0
#define FAXG3_DEFAULT 0
#define GIF_DEFAULT 0
#define GIF_LOAD256 1
#define GIF_PLAYBACK 2
#define HDR_DEFAULT 0
#define ICO_DEFAULT  0
#define ICO_MAKEALPHA  1
#define IFF_DEFAULT  0
#define JPEG_DEFAULT  0
#define JPEG_FAST  1
#define JPEG_ACCURATE  2
#define JPEG_CMYK 4
#define JPEG_QUALITYSUPERB  &H80
#define JPEG_QUALITYGOOD  &H100
#define JPEG_QUALITYNORMAL  &H200
#define JPEG_QUALITYAVERAGE  &H400
#define JPEG_QUALITYBAD  &H800
#define JPEG_PROGRESSIVE &H2000
#define KOALA_DEFAULT  0
#define LBM_DEFAULT  0
#define MNG_DEFAULT  0
#define PCD_DEFAULT  0
#define PCD_BASE  1
#define PCD_BASEDIV4  2
#define PCD_BASEDIV16  3
#define PCX_DEFAULT  0
#define PNG_DEFAULT  0
#define PNG_IGNOREGAMMA  1
#define PNM_DEFAULT  0
#define PNM_SAVE_RAW  0
#define PNM_SAVE_ASCII  1
#define PSD_DEFAULT  0
#define RAS_DEFAULT  0
#define SGI_DEFAULT  0
#define TARGA_DEFAULT  0
#define TARGA_LOAD_RGB888  1
#define TIFF_DEFAULT  0
#define TIFF_CMYK  1
#define TIFF_PACKBITS  &H0100
#define TIFF_DEFLATE  &H0200
#define TIFF_ADOBE_DEFLATE  &H0400
#define TIFF_NONE  &H0800
#define TIFF_CCITTFAX3  &H1000
#define TIFF_CCITTFAX4  &H2000
#define TIFF_LZW  &H4000
#define TIFF_JPEG  &H8000
#define WBMP_DEFAULT  0
#define XBM_DEFAULT  0
#define XPM_DEFAULT  0

'' Init / Error routines ----------------------------------------------------
Declare Sub FreeImage_Initialise Alias "FreeImage_Initialise" (ByVal load_local_plugins_only As Integer = 0)
Declare Sub FreeImage_DeInitialise Alias "FreeImage_DeInitialise" ()

'' Version routines ---------------------------------------------------------
Declare Function FreeImage_GetVersion Alias "FreeImage_GetVersion" () As ZString Ptr
Declare Function FreeImage_GetCopyrightMessage Alias "FreeImage_GetCopyrightMessage" () As ZString Ptr

'' Message output functions -------------------------------------------------
Declare Sub FreeImage_OutputMessageProc Cdecl Alias "FreeImage_OutputMessageProc" (ByVal fif As Integer, ByVal fmt As ZString Ptr, ...)
Declare Sub FreeImage_SetOutputMessage Alias "FreeImage_SetOutputMessage" (ByVal omf As Integer)

'' Allocate / Clone / Unload routines ---------------------------------------
Declare Function FreeImage_Allocate Alias "FreeImage_Allocate" (ByVal Width As Integer, ByVal height As Integer, ByVal bpp As Integer, ByVal red_mask As UInteger = 0, ByVal green_mask As UInteger = 0, ByVal blue_mask As UInteger = 0) As FIBITMAP Ptr
Declare Function FreeImage_AllocateT Alias "FreeImage_AllocateT" (ByVal Type As FREE_IMAGE_TYPE, ByVal Width As Integer, ByVal height As Integer, ByVal bpp As Integer = 8, ByVal red_mask As UInteger = 0, ByVal green_mask As UInteger = 0, ByVal blue_mask As UInteger = 0) As FIBITMAP Ptr
Declare Function FreeImage_Clone Alias "FreeImage_Clone" (ByVal dib As FIBITMAP Ptr) As FIBITMAP Ptr
Declare Sub FreeImage_Unload Alias "FreeImage_Unload" (ByVal dib As FIBITMAP Ptr)

'' Load / Save routines -----------------------------------------------------
Declare Function FreeImage_Load Alias "FreeImage_Load" (ByVal fif As FREE_IMAGE_FORMAT, ByVal filename As ZString Ptr, ByVal flags As Integer = 0) As FIBITMAP Ptr
Declare Function FreeImage_LoadU Alias "FreeImage_LoadU" (ByVal fif As FREE_IMAGE_FORMAT, ByVal filename As WString Ptr, ByVal flags As Integer = 0) As FIBITMAP Ptr
Declare Function FreeImage_LoadFromHandle Alias "FreeImage_LoadFromHandle" (ByVal fif As FREE_IMAGE_FORMAT, ByVal io As Integer, ByVal handle As Integer, ByVal flags As Integer = 0) As FIBITMAP Ptr
Declare Function FreeImage_Save Alias "FreeImage_Save" (ByVal fif As FREE_IMAGE_FORMAT, ByVal dib As FIBITMAP Ptr, ByVal filename As ZString Ptr, ByVal flags As Integer = 0) As Integer
Declare Function FreeImage_SaveU Alias "FreeImage_SaveU" (ByVal fif As FREE_IMAGE_FORMAT, ByVal dib As FIBITMAP Ptr, ByVal filename As WString Ptr, ByVal flags As Integer = 0) As Integer
Declare Function FreeImage_SaveToHandle Alias "FreeImage_SaveToHandle" (ByVal fif As FREE_IMAGE_FORMAT, ByVal dib As FIBITMAP Ptr, ByVal io As Integer, ByVal handle As Integer, ByVal flags As Integer = 0) As Integer

'' Memory I/O stream routines -----------------------------------------------
Declare Function FreeImage_OpenMemory Alias "FreeImage_OpenMemory" (ByVal Data As UByte Ptr = NULL, ByVal size_in_bytes As Integer = 0) As FIMEMORY Ptr
Declare Sub FreeImage_CloseMemory Alias "FreeImage_CloseMemory" (ByVal stream As FIMEMORY Ptr)
Declare Function FreeImage_LoadFromMemory Alias "FreeImage_LoadFromMemory" (ByVal fif As FREE_IMAGE_FORMAT, ByVal stream As FIMEMORY Ptr, ByVal flags As Integer = 0) As FIBITMAP Ptr
Declare Function FreeImage_SaveToMemory Alias "FreeImage_SaveToMemory" (ByVal fif As FREE_IMAGE_FORMAT, ByVal dib As FIBITMAP Ptr, ByVal stream As FIMEMORY Ptr, ByVal flags As Integer = 0) As Integer
Declare Function FreeImage_TellMemory Alias "FreeImage_TellMemory" (ByVal stream As FIMEMORY Ptr) As Integer
Declare Function FreeImage_SeekMemory Alias "FreeImage_SeekMemory" (ByVal stream As FIMEMORY Ptr, ByVal Offset As Integer, ByVal origin As Integer) As Integer
Declare Function FreeImage_AcquireMemory Alias "FreeImage_AcquireMemory" (ByVal stream As FIMEMORY Ptr, ByVal Data As UByte Ptr Ptr, ByVal size_in_bytes As Integer Ptr) As Integer
Declare Function FreeImage_ReadMemory Alias  "FreeImage_ReadMemory" (ByVal buffer As Any Ptr, ByVal size As Integer, ByVal count As Integer, ByVal stream As FIMEMORY Ptr) As UInteger
Declare Function FreeImage_WriteMemory Alias  "FreeImage_WriteMemory" (ByVal buffer As Any Ptr, ByVal size As Integer, ByVal count As Integer, ByVal stream As FIMEMORY Ptr) As UInteger
Declare Function FreeImage_LoadMultiBitmapFromMemory Alias  "FreeImage_LoadMultiBitmapFromMemory" (ByVal fif As FREE_IMAGE_FORMAT, ByVal stream As FIMEMORY Ptr, ByVal flags As Integer = 0)As FIMULTIBITMAP Ptr

'' Plugin Interface ---------------------------------------------------------
Declare Function FreeImage_RegisterLocalPlugin Alias "FreeImage_RegisterLocalPlugin" (ByVal proc_address As Integer, ByVal Format As ZString Ptr, ByVal description As ZString Ptr, ByVal extension As ZString Ptr, ByVal regexpr As ZString Ptr) As FREE_IMAGE_FORMAT
Declare Function FreeImage_RegisterExternalPlugin Alias "FreeImage_RegisterExternalPlugin" (ByVal path As ZString Ptr, ByVal Format As ZString Ptr, ByVal description As ZString Ptr, ByVal extension As ZString Ptr, ByVal regexpr As ZString Ptr) As FREE_IMAGE_FORMAT
Declare Function FreeImage_GetFIFCount Alias "FreeImage_GetFIFCount" () As Integer
Declare Function FreeImage_SetPluginEnabled Alias "FreeImage_SetPluginEnabled" (ByVal fif As FREE_IMAGE_FORMAT, ByVal enable As Integer) As Integer
Declare Function FreeImage_IsPluginEnabled Alias "FreeImage_IsPluginEnabled" (ByVal fif As FREE_IMAGE_FORMAT) As Integer
Declare Function FreeImage_GetFIFFromFormat Alias "FreeImage_GetFIFFromFormat" (ByVal Format As ZString Ptr) As FREE_IMAGE_FORMAT
Declare Function FreeImage_GetFIFFromMime Alias "FreeImage_GetFIFFromMime" (ByVal mime As ZString Ptr) As FREE_IMAGE_FORMAT
Declare Function FreeImage_GetFormatFromFIF Alias "FreeImage_GetFormatFromFIF" (ByVal fif As FREE_IMAGE_FORMAT) As ZString Ptr
Declare Function FreeImage_GetFIFExtensionList Alias "FreeImage_GetFIFExtensionList" (ByVal fif As FREE_IMAGE_FORMAT) As ZString Ptr
Declare Function FreeImage_GetFIFDescription Alias "FreeImage_GetFIFDescription" (ByVal fif As FREE_IMAGE_FORMAT) As ZString Ptr
Declare Function FreeImage_GetFIFRegExpr Alias "FreeImage_GetFIFRegExpr" (ByVal fif As FREE_IMAGE_FORMAT) As ZString Ptr
Declare Function FreeImage_GetFIFMimeType Alias "FreeImage_GetFIFMimeType" (ByVal fif As FREE_IMAGE_FORMAT) As ZString Ptr
Declare Function FreeImage_GetFIFFromFilename Alias "FreeImage_GetFIFFromFilename" (ByVal filename As ZString Ptr) As FREE_IMAGE_FORMAT
Declare Function FreeImage_GetFIFFromFilenameU Alias "FreeImage_GetFIFFromFilenameU" (ByVal filename As WString Ptr) As FREE_IMAGE_FORMAT
Declare Function FreeImage_FIFSupportsReading Alias "FreeImage_FIFSupportsReading" (ByVal fif As FREE_IMAGE_FORMAT) As Integer
Declare Function FreeImage_FIFSupportsWriting Alias "FreeImage_FIFSupportsWriting" (ByVal fif As FREE_IMAGE_FORMAT) As Integer
Declare Function FreeImage_FIFSupportsExportBPP Alias "FreeImage_FIFSupportsExportBPP" (ByVal fif As FREE_IMAGE_FORMAT, ByVal bpp As Integer) As Integer
Declare Function FreeImage_FIFSupportsExportType Alias "FreeImage_FIFSupportsExportType" (ByVal fif As FREE_IMAGE_FORMAT, ByVal type_ As FREE_IMAGE_TYPE) As Integer
Declare Function FreeImage_FIFSupportsICCProfiles Alias "FreeImage_FIFSupportsICCProfiles" (ByVal fif As FREE_IMAGE_FORMAT) As Integer

'' Multipaging interface ----------------------------------------------------
Declare Function FreeImage_OpenMultiBitmap Alias "FreeImage_OpenMultiBitmap" (ByVal fif As FREE_IMAGE_FORMAT, ByVal filename As ZString Ptr, ByVal create_new_ As Integer, ByVal read_only As Integer, ByVal keep_cache_in_memory As Integer = 0) As FIMULTIBITMAP Ptr
Declare Function FreeImage_CloseMultiBitmap Alias "FreeImage_CloseMultiBitmap" (ByVal bitmap As FIMULTIBITMAP Ptr, ByVal flags As Integer = 0) As Integer
Declare Function FreeImage_GetPageCount Alias "FreeImage_GetPageCount" (ByVal bitmap As FIMULTIBITMAP Ptr) As Integer
Declare Sub FreeImage_AppendPage Alias "FreeImage_AppendPage" (ByVal bitmap As FIMULTIBITMAP Ptr, ByVal Data As FIBITMAP Ptr)
Declare Sub FreeImage_InsertPage Alias "FreeImage_InsertPage" (ByVal bitmap As FIMULTIBITMAP Ptr, ByVal Page As Integer, ByVal Data As FIBITMAP Ptr)
Declare Sub FreeImage_DeletePage Alias "FreeImage_DeletePage" (ByVal bitmap As FIMULTIBITMAP Ptr, ByVal Page As Integer)
Declare Function FreeImage_LockPage Alias "FreeImage_LockPage" (ByVal bitmap As FIMULTIBITMAP Ptr, ByVal Page As Integer) As FIBITMAP Ptr
Declare Sub FreeImage_UnlockPage Alias "FreeImage_UnlockPage" (ByVal bitmap As FIMULTIBITMAP Ptr, ByVal Page As FIBITMAP Ptr, ByVal changed As Integer)
Declare Function FreeImage_MovePage Alias "FreeImage_MovePage" (ByVal bitmap As FIMULTIBITMAP Ptr, ByVal target As Integer, ByVal source As Integer) As Integer
Declare Function FreeImage_GetLockedPageNumbers Alias "FreeImage_GetLockedPageNumbers" (ByVal bitmap As FIMULTIBITMAP Ptr, ByVal pages As Integer Ptr, ByVal count As Integer Ptr) As Integer

'' Filetype request routines ------------------------------------------------
Declare Function FreeImage_GetFileType Alias "FreeImage_GetFileType" (ByVal filename As ZString Ptr, ByVal size As Integer = 0) As FREE_IMAGE_FORMAT
Declare Function FreeImage_GetFileTypeU Alias "FreeImage_GetFileTypeU" (ByVal filename As WString Ptr, ByVal size As Integer = 0) As FREE_IMAGE_FORMAT
Declare Function FreeImage_GetFileTypeFromHandle Alias "FreeImage_GetFileTypeFromHandle" (ByVal io As Integer, ByVal handle As Integer, ByVal size As Integer = 0) As FREE_IMAGE_FORMAT
Declare Function FreeImage_GetFileTypeFromMemory Alias "FreeImage_GetFileTypeFromMemory" (ByVal stream As FIMEMORY Ptr, ByVal size As Integer = 0) As FREE_IMAGE_FORMAT

'' Image type request routine -----------------------------------------------
Declare Function FreeImage_GetImageType Alias "FreeImage_GetImageType" (ByVal dib As FIBITMAP Ptr) As FREE_IMAGE_TYPE

'' FreeImage helper routines ------------------------------------------------
Declare Function FreeImage_IsLittleEndian Alias "FreeImage_IsLittleEndian" () As Integer
Declare Function FreeImage_LookupX11Color Alias "FreeImage_LookupX11Color" (ByVal szColor As ZString Ptr, ByVal nRed As Integer Ptr, ByVal nGreen As Integer Ptr, ByVal nBlue As Integer Ptr) As Integer
Declare Function FreeImage_LookupSVGColor Alias "FreeImage_LookupSVGColor" (ByVal szColor As ZString Ptr, ByVal nRed As Integer Ptr, ByVal nGreen As Integer Ptr, ByVal nBlue As Integer Ptr) As Integer

'' Pixel access routines ----------------------------------------------------
Declare Function FreeImage_GetBits Alias "FreeImage_GetBits" (ByVal dib As FIBITMAP Ptr) As ZString Ptr
Declare Function FreeImage_GetScanLine Alias "FreeImage_GetScanLine" (ByVal dib As FIBITMAP Ptr, ByVal scanline As Integer) As ZString Ptr

Declare Function FreeImage_GetPixelIndex Alias "FreeImage_GetPixelIndex" (ByVal dib As FIBITMAP Ptr, ByVal x As UInteger, ByVal y As UInteger, ByVal value As UByte Ptr) As Integer
Declare Function FreeImage_GetPixelColor Alias "FreeImage_GetPixelColor" (ByVal dib As FIBITMAP Ptr, ByVal x As UInteger, ByVal y As UInteger, ByVal value As RGBQUAD Ptr) As Integer
Declare Function FreeImage_SetPixelIndex Alias "FreeImage_SetPixelIndex" (ByVal dib As FIBITMAP Ptr, ByVal x As UInteger, ByVal y As UInteger, ByVal Value As UByte Ptr) As Integer
Declare Function FreeImage_SetPixelColor Alias "FreeImage_SetPixelColor" (ByVal dib As FIBITMAP Ptr, ByVal x As UInteger, ByVal y As UInteger, ByVal Value As RGBQUAD Ptr) As Integer

'' DIB info routines --------------------------------------------------------
Declare Function FreeImage_GetColorsUsed Alias "FreeImage_GetColorsUsed" (ByVal dib As FIBITMAP Ptr) As UInteger
Declare Function FreeImage_GetBPP Alias "FreeImage_GetBPP" (ByVal dib As FIBITMAP Ptr) As UInteger
Declare Function FreeImage_GetWidth Alias "FreeImage_GetWidth" (ByVal dib As FIBITMAP Ptr) As UInteger
Declare Function FreeImage_GetHeight Alias "FreeImage_GetHeight" (ByVal dib As FIBITMAP Ptr) As UInteger
Declare Function FreeImage_GetLine Alias "FreeImage_GetLine" (ByVal dib As FIBITMAP Ptr) As UInteger
Declare Function FreeImage_GetPitch Alias "FreeImage_GetPitch" (ByVal dib As FIBITMAP Ptr) As UInteger
Declare Function FreeImage_GetDIBSize Alias "FreeImage_GetDIBSize" (ByVal dib As FIBITMAP Ptr) As UInteger
Declare Function FreeImage_GetPalette Alias "FreeImage_GetPalette" (ByVal dib As FIBITMAP Ptr) As RGBQUAD Ptr

Declare Function FreeImage_GetDotsPerMeterX Alias "FreeImage_GetDotsPerMeterX" (ByVal dib As FIBITMAP Ptr) As UInteger
Declare Function FreeImage_GetDotsPerMeterY Alias "FreeImage_GetDotsPerMeterY" (ByVal dib As FIBITMAP Ptr) As UInteger
Declare Sub FreeImage_SetDotsPerMeterX Alias "FreeImage_SetDotsPerMeterX" (ByVal dib As FIBITMAP Ptr, ByVal res As UInteger)
Declare Sub FreeImage_SetDotsPerMeterY Alias "FreeImage_SetDotsPerMeterY" (ByVal dib As FIBITMAP Ptr, ByVal res As UInteger)

Declare Function FreeImage_GetInfoHeader Alias "FreeImage_GetInfoHeader" (ByVal dib As FIBITMAP Ptr) As BITMAPINFOHEADER Ptr
Declare Function FreeImage_GetInfo Alias "FreeImage_GetInfo" (ByVal dib As FIBITMAP Ptr) As BITMAPINFO Ptr
Declare Function FreeImage_GetColorType Alias "FreeImage_GetColorType" (ByVal dib As FIBITMAP Ptr) As FREE_IMAGE_COLOR_TYPE

Declare Function FreeImage_GetRedMask Alias "FreeImage_GetRedMask" (ByVal dib As FIBITMAP Ptr) As UInteger
Declare Function FreeImage_GetGreenMask Alias "FreeImage_GetGreenMask" (ByVal dib As FIBITMAP Ptr) As UInteger
Declare Function FreeImage_GetBlueMask Alias "FreeImage_GetBlueMask" (ByVal dib As FIBITMAP Ptr) As UInteger

Declare Function FreeImage_GetTransparencyCount Alias "FreeImage_GetTransparencyCount" (ByVal dib As FIBITMAP Ptr) As UInteger
Declare Function FreeImage_GetTransparencyTable Alias "FreeImage_GetTransparencyTable" (ByVal dib As FIBITMAP Ptr) As UByte Ptr
Declare Sub FreeImage_SetTransparent Alias "FreeImage_SetTransparent" (ByVal dib As FIBITMAP Ptr, ByVal enabled As Integer)
Declare Sub FreeImage_SetTransparencyTable Alias "FreeImage_SetTransparencyTable" (ByVal dib As FIBITMAP Ptr, ByVal table As UByte Ptr, ByVal count As Integer)
Declare Function FreeImage_IsTransparent Alias "FreeImage_IsTransparent" (ByVal dib As FIBITMAP Ptr) As Integer

Declare Function FreeImage_HasBackgroundColor Alias "FreeImage_HasBackgroundColor" (ByVal dib As FIBITMAP Ptr) As Integer
Declare Function FreeImage_GetBackgroundColor Alias "FreeImage_GetBackgroundColor" (ByVal dib As FIBITMAP Ptr, ByVal bkcolor As Integer) As Integer
Declare Function FreeImage_SetBackgroundColor Alias "FreeImage_SetBackgroundColor" (ByVal dib As FIBITMAP Ptr, ByVal bkcolor As Integer) As Integer

'' ICC profile routines -----------------------------------------------------
Declare Function FreeImage_GetICCProfile Alias "FreeImage_GetICCProfile" (ByVal dib As FIBITMAP Ptr) As FIICCPROFILE Ptr
Declare Function FreeImage_CreateICCProfile Alias "FreeImage_CreateICCProfile" (ByVal dib As FIBITMAP Ptr, ByVal Data As Any Ptr, ByVal size As Integer) As FIICCPROFILE Ptr
Declare Sub FreeImage_DestroyICCProfile Alias "FreeImage_DestroyICCProfile" (ByVal dib As FIBITMAP Ptr)

'' Line conversion routines -------------------------------------------------
Declare Sub FreeImage_ConvertLine1To4 Alias "FreeImage_ConvertLine1To4" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine8To4 Alias "FreeImage_ConvertLine8To4" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer, ByVal Palette As RGBQUAD Ptr)
Declare Sub FreeImage_ConvertLine16To4_555 Alias "FreeImage_ConvertLine16To4_555" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine16To4_565 Alias "FreeImage_ConvertLine16To4_565" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine24To4 Alias "FreeImage_ConvertLine24To4" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine32To4 Alias "FreeImage_ConvertLine32To4" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine1To8 Alias "FreeImage_ConvertLine1To8" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine4To8 Alias "FreeImage_ConvertLine4To8" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine16To8_555 Alias "FreeImage_ConvertLine16To8_555" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine16To8_565 Alias "FreeImage_ConvertLine16To8_565" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine24To8 Alias "FreeImage_ConvertLine24To8" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine32To8 Alias "FreeImage_ConvertLine32To8" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine1To16_555 Alias "FreeImage_ConvertLine1To16_555" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer, ByVal Palette As RGBQUAD Ptr)
Declare Sub FreeImage_ConvertLine4To16_555 Alias "FreeImage_ConvertLine4To16_555" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer, ByVal Palette As RGBQUAD Ptr)
Declare Sub FreeImage_ConvertLine8To16_555 Alias "FreeImage_ConvertLine8To16_555" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer, ByVal Palette As RGBQUAD Ptr)
Declare Sub FreeImage_ConvertLine16_565_To16_555 Alias "FreeImage_ConvertLine16_565_To16_555" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine24To16_555 Alias "FreeImage_ConvertLine24To16_555" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine32To16_555 Alias "FreeImage_ConvertLine32To16_555" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine1To16_565 Alias "FreeImage_ConvertLine1To16_565" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer, ByVal Palette As RGBQUAD Ptr)
Declare Sub FreeImage_ConvertLine4To16_565 Alias "FreeImage_ConvertLine4To16_565" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer, ByVal Palette As RGBQUAD Ptr)
Declare Sub FreeImage_ConvertLine8To16_565 Alias "FreeImage_ConvertLine8To16_565" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer, ByVal Palette As RGBQUAD Ptr)
Declare Sub FreeImage_ConvertLine16_555_To16_565 Alias "FreeImage_ConvertLine16_555_To16_565" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine24To16_565 Alias "FreeImage_ConvertLine24To16_565" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine32To16_565 Alias "FreeImage_ConvertLine32To16_565" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine1To24 Alias "FreeImage_ConvertLine1To24" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer, ByVal Palette As RGBQUAD Ptr)
Declare Sub FreeImage_ConvertLine4To24 Alias "FreeImage_ConvertLine4To24" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer, ByVal Palette As RGBQUAD Ptr)
Declare Sub FreeImage_ConvertLine8To24 Alias "FreeImage_ConvertLine8To24" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer, ByVal Palette As RGBQUAD Ptr)
Declare Sub FreeImage_ConvertLine16To24_555 Alias "FreeImage_ConvertLine16To24_555" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine16To24_565 Alias "FreeImage_ConvertLine16To24_565" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine32To24 Alias "FreeImage_ConvertLine32To24" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine1To32 Alias "FreeImage_ConvertLine1To32" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer, ByVal Palette As RGBQUAD Ptr)
Declare Sub FreeImage_ConvertLine4To32 Alias "FreeImage_ConvertLine4To32" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer, ByVal Palette As RGBQUAD Ptr)
Declare Sub FreeImage_ConvertLine8To32 Alias "FreeImage_ConvertLine8To32" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer, ByVal Palette As RGBQUAD Ptr)
Declare Sub FreeImage_ConvertLine16To32_555 Alias "FreeImage_ConvertLine16To32_555" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine16To32_565 Alias "FreeImage_ConvertLine16To32_565" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)
Declare Sub FreeImage_ConvertLine24To32 Alias "FreeImage_ConvertLine24To32" (ByVal target As UByte Ptr, ByVal source As UByte Ptr, ByVal width_in_pixels As Integer)

'' Smart conversion routines ------------------------------------------------
Declare Function FreeImage_ConvertTo4Bits Alias "FreeImage_ConvertTo4Bits" (ByVal dib As FIBITMAP Ptr) As FIBITMAP Ptr
Declare Function FreeImage_ConvertTo8Bits Alias "FreeImage_ConvertTo8Bits" (ByVal dib As FIBITMAP Ptr) As FIBITMAP Ptr
Declare Function FreeImage_ConvertToGreyscale Alias "FreeImage_ConvertToGreyscale" (ByVal dib As FIBITMAP Ptr) As FIBITMAP Ptr
Declare Function FreeImage_ConvertTo16Bits555 Alias "FreeImage_ConvertTo16Bits555" (ByVal dib As FIBITMAP Ptr) As FIBITMAP Ptr
Declare Function FreeImage_ConvertTo16Bits565 Alias "FreeImage_ConvertTo16Bits565" (ByVal dib As FIBITMAP Ptr) As FIBITMAP Ptr
Declare Function FreeImage_ConvertTo24Bits Alias "FreeImage_ConvertTo24Bits" (ByVal dib As FIBITMAP Ptr) As FIBITMAP Ptr
Declare Function FreeImage_ConvertTo32Bits Alias "FreeImage_ConvertTo32Bits" (ByVal dib As FIBITMAP Ptr) As FIBITMAP Ptr
Declare Function FreeImage_ColorQuantize Alias "FreeImage_ColorQuantize" (ByVal dib As FIBITMAP Ptr, ByVal quantize As FREE_IMAGE_QUANTIZE) As FIBITMAP Ptr
Declare Function FreeImage_ColorQuantizeEx Alias "FreeImage_ColorQuantizeEx" (ByVal dib As FIBITMAP Ptr, ByVal quantize As FREE_IMAGE_QUANTIZE =FIQ_WUQUANT,ByVal PaletteSize As Integer=256, ByVal ReserveSize As Integer=0, ByVal ReservePalette As RGBQUAD Ptr=NULL ) As FIBITMAP Ptr
Declare Function FreeImage_Threshold Alias "FreeImage_Threshold" (ByVal dib As FIBITMAP Ptr, ByVal T As Byte) As FIBITMAP Ptr
Declare Function FreeImage_Dither Alias "FreeImage_Dither" (ByVal dib As FIBITMAP Ptr, ByVal algorithm As FREE_IMAGE_DITHER) As FIBITMAP Ptr

Declare Function FreeImage_ConvertFromRawBits Alias "FreeImage_ConvertFromRawBits" (ByRef bits As Integer, ByVal Width As Integer, ByVal height As Integer, ByVal pitch As Integer, ByVal bpp As UInteger, ByVal red_mask As UInteger, ByVal green_mask As UInteger, ByVal blue_mask As UInteger, ByVal topdown As Integer = 0) As FIBITMAP Ptr
Declare Sub FreeImage_ConvertToRawBits Alias "FreeImage_ConvertToRawBits" (ByRef bits As Integer, ByVal dib As FIBITMAP Ptr, ByVal pitch As Integer, ByVal bpp As UInteger, ByVal red_mask As UInteger, ByVal green_mask As UInteger, ByVal blue_mask As UInteger, ByVal topdown As Integer = 0)

Declare Function FreeImage_ConvertToRGBF Alias "FreeImage_ConvertToRGBF" (ByVal dib As FIBITMAP Ptr) As FIBITMAP Ptr

Declare Function FreeImage_ConvertToStandardType Alias "FreeImage_ConvertToStandardType" (ByVal src As Integer, ByVal scale_linear As Integer = 1) As FIBITMAP Ptr
Declare Function FreeImage_ConvertToType Alias "FreeImage_ConvertToType" (ByVal src As Integer, ByVal dst_type As FREE_IMAGE_TYPE, ByVal scale_linear As Integer = 1) As FIBITMAP Ptr

'' tone mapping operators
Declare Function FreeImage_ToneMapping Alias "FreeImage_ToneMapping" (ByVal dib As FIBITMAP Ptr, ByVal tmo As FREE_IMAGE_TMO, ByVal first_param As Double =0, ByVal second_param As Double =0) As FIBITMAP Ptr
Declare Function FreeImage_TmoDrago03 Alias "FreeImage_TmoDrago03" (ByVal src As FIBITMAP Ptr, ByVal gamma As Double =2.2, ByVal exposure As Double =0) As FIBITMAP Ptr
Declare Function FreeImage_TmoReinhard05 Alias "FreeImage_TmoReinhard05" (ByVal src As FIBITMAP Ptr, ByVal intensity As Double =0, ByVal contrast As Double =0) As FIBITMAP Ptr

'' ZLib interface -----------------------------------------------------------
Declare Function FreeImage_ZLibCompress Alias "FreeImage_ZLibCompress" (ByVal target As UByte Ptr, ByVal target_size As Integer, ByVal source As UByte Ptr, ByVal source_size As Integer) As Integer
Declare Function FreeImage_ZLibUncompress Alias "FreeImage_ZLibUncompress" (ByVal target As UByte Ptr, ByVal target_size As Integer, ByVal source As UByte Ptr, ByVal source_size As Integer) As Integer
Declare Function FreeImage_ZLibGZip Alias "FreeImage_ZLibGZip" (ByVal target As UByte Ptr, ByVal target_size As Integer, ByVal source As UByte Ptr, ByVal source_size As Integer) As Integer
Declare Function FreeImage_ZLibGUnzip Alias "FreeImage_ZLibGUnzip" (ByVal target As UByte Ptr, ByVal target_size As Integer, ByVal source As UByte Ptr, ByVal source_size As Integer) As Integer
Declare Function FreeImage_ZLibCRC32 Alias "FreeImage_ZLibCRC32" (ByVal crc As Integer, ByVal source As UByte Ptr, ByVal source_size As Integer) As Integer

''???
'' Metadata routines --------------------------------------------------------
'' tag creation / destruction
Declare Function FreeImage_CreateTag Alias "FreeImage_CreateTag" () As FITAG Ptr
Declare Sub FreeImage_DeleteTag Alias "FreeImage_DeleteTag" (ByVal tag As FITAG Ptr)
Declare Function FreeImage_CloneTag Alias "FreeImage_CloneTag" (ByVal tag As FITAG Ptr) As FITAG Ptr

'' tag getters and setters
Declare Function FreeImage_GetTagKey Alias "FreeImage_GetTagKey" (ByVal tag As FITAG Ptr) As ZString Ptr
Declare Function FreeImage_GetTagDescription Alias "FreeImage_GetTagDescription" (ByVal tag As FITAG Ptr) As ZString Ptr
Declare Function FreeImage_GetTagID Alias "FreeImage_GetTagID" (ByVal tag As FITAG Ptr) As UShort
Declare Function FreeImage_GetTagType Alias "FreeImage_GetTagType" (ByVal tag As FITAG Ptr) As FREE_IMAGE_MDTYPE
Declare Function FreeImage_GetTagCount Alias "FreeImage_GetTagCount" (ByVal tag As FITAG Ptr) As Integer
Declare Function FreeImage_GetTagLength Alias "FreeImage_GetTagLength" (ByVal tag As FITAG Ptr) As Integer
Declare Sub FreeImage_GetTagValue Alias "FreeImage_GetTagValue" (ByVal tag As FITAG Ptr)' const void *

Declare Function FreeImage_SetTagKey Alias "FreeImage_SetTagKey" (ByVal tag As FITAG Ptr, ByVal Key As ZString Ptr) As Integer
Declare Function FreeImage_SetTagDescription Alias "FreeImage_SetTagDescription" (ByVal tag As FITAG Ptr, ByVal description As ZString Ptr) As Integer
Declare Function FreeImage_SetTagID Alias "FreeImage_SetTagID" (ByVal tag As FITAG Ptr, ByVal id As UShort) As Integer
Declare Function FreeImage_SetTagType Alias "FreeImage_SetTagType" (ByVal tag As FITAG Ptr, ByVal Type As FREE_IMAGE_MDTYPE) As Integer
Declare Function FreeImage_SetTagCount Alias "FreeImage_SetTagCount" (ByVal tag As FITAG Ptr, ByVal count As UInteger) As Integer
Declare Function FreeImage_SetTagLength Alias "FreeImage_SetTagLength" (ByVal tag As FITAG Ptr, ByVal length As UInteger) As Integer
Declare Function FreeImage_SetTagValue Alias "FreeImage_SetTagValue" (ByVal tag As FITAG Ptr, ByVal value As ZString Ptr) As Integer

'' iterator
'DLL_API FIMETADATA *DLL_CALLCONV FreeImage_FindFirstMetadata(FREE_IMAGE_MDMODEL model, FIBITMAP *dib, FITAG **tag);
'DLL_API BOOL DLL_CALLCONV FreeImage_FindNextMetadata(FIMETADATA *mdhandle, FITAG **tag);
'DLL_API void DLL_CALLCONV FreeImage_FindCloseMetadata(FIMETADATA *mdhandle);

'' metadata setter and getter
'DLL_API BOOL DLL_CALLCONV FreeImage_SetMetadata(FREE_IMAGE_MDMODEL model, FIBITMAP *dib, const char *key, Byval tag as FITAG ptr);
'DLL_API BOOL DLL_CALLCONV FreeImage_GetMetadata(FREE_IMAGE_MDMODEL model, FIBITMAP *dib, const char *key, FITAG **tag);

'' helpers
'DLL_API unsigned DLL_CALLCONV FreeImage_GetMetadataCount(FREE_IMAGE_MDMODEL model, FIBITMAP *dib);

'' tag to C string conversion
'DLL_API const char* DLL_CALLCONV FreeImage_TagToString(FREE_IMAGE_MDMODEL model, Byval tag as FITAG ptr, char *Make FI_DEFAULT(NULL));

'' Image manipulation toolkit -----------------------------------------------
'' rotation and flipping
Declare Function FreeImage_RotateClassic Alias "FreeImage_RotateClassic" (ByVal dib As FIBITMAP Ptr, ByVal angle As Double) As FIBITMAP Ptr
Declare Function FreeImage_RotateEx Alias "FreeImage_RotateEx" (ByVal dib As FIBITMAP Ptr, ByVal angle As Double, ByVal x_shift As Double, ByVal y_shift As Double, ByVal x_origin As Double, ByVal y_origin As Double, ByVal use_mask As Integer) As FIBITMAP Ptr
Declare Function FreeImage_FlipHorizontal Alias "FreeImage_FlipHorizontal" (ByVal dib As FIBITMAP Ptr) As Integer
Declare Function FreeImage_FlipVertical Alias "FreeImage_FlipVertical" (ByVal dib As FIBITMAP Ptr) As Integer
Declare Function FreeImage_JPEGTransform Alias "FreeImage_JPEGTransform" (ByVal src_file As ZString Ptr, ByVal dst_file As ZString Ptr, ByVal operation As FREE_IMAGE_JPEG_OPERATION, ByVal perfect As Integer =0) As Integer

Declare Function FreeImage_Rescale Alias "FreeImage_Rescale" (ByVal dib As FIBITMAP Ptr, ByVal dst_width As Integer, ByVal dst_height As Integer, ByVal filter As FREE_IMAGE_FILTER) As FIBITMAP Ptr
Declare Function FreeImage_MakeThumbnail Alias "FreeImage_MakeThumbnail" (ByVal dib As FIBITMAP Ptr, ByVal max_pixel_size As Integer, ByVal convert As Integer =0) As FIBITMAP Ptr

Declare Function FreeImage_AdjustCurve Alias "FreeImage_AdjustCurve" (ByVal dib As FIBITMAP Ptr, ByRef LUT As Integer, ByVal channel As FREE_IMAGE_COLOR_CHANNEL) As Integer
Declare Function FreeImage_AdjustGamma Alias "FreeImage_AdjustGamma" (ByVal dib As FIBITMAP Ptr, ByVal gamma As Double) As Integer
Declare Function FreeImage_AdjustBrightness Alias "FreeImage_AdjustBrightness" (ByVal dib As FIBITMAP Ptr, ByVal percentage As Double) As Integer
Declare Function FreeImage_AdjustContrast Alias "FreeImage_AdjustContrast" (ByVal dib As FIBITMAP Ptr, ByVal percentage As Double) As Integer
Declare Function FreeImage_Invert Alias "FreeImage_Invert" (ByVal dib As FIBITMAP Ptr) As Integer
Declare Function FreeImage_GetHistogram Alias "FreeImage_GetHistogram" (ByVal dib As FIBITMAP Ptr, ByRef histo As Integer, ByVal channel As FREE_IMAGE_COLOR_CHANNEL = FICC_BLACK) As Integer

Declare Function FreeImage_GetChannel Alias "FreeImage_GetChannel" (ByVal dib As FIBITMAP Ptr, ByVal channel As FREE_IMAGE_COLOR_CHANNEL) As Integer
Declare Function FreeImage_SetChannel Alias "FreeImage_SetChannel" (ByVal dib As FIBITMAP Ptr, ByVal dib8 As Integer, ByVal channel As FREE_IMAGE_COLOR_CHANNEL) As Integer
Declare Function FreeImage_GetComplexChannel Alias "FreeImage_GetComplexChannel" (ByVal src As Integer, ByVal channel As FREE_IMAGE_COLOR_CHANNEL) As Integer
Declare Function FreeImage_SetComplexChannel Alias "FreeImage_SetComplexChannel" (ByVal dst As Integer, ByVal src As Integer, ByVal channel As FREE_IMAGE_COLOR_CHANNEL) As Integer

Declare Function FreeImage_Copy Alias "FreeImage_Copy" (ByVal dib As FIBITMAP Ptr, ByVal Left As Integer, ByVal top As Integer, ByVal Right As Integer, ByVal bottom As Integer) As FIBITMAP Ptr
Declare Function FreeImage_Paste Alias "FreeImage_Paste" (ByVal dst As Integer, ByVal src As Integer, ByVal Left As Integer, ByVal top As Integer, ByVal alpha As Integer) As Integer
Declare Function FreeImage_Composite Alias "FreeImage_Composite" (ByVal fg As Integer, ByVal useFileBkg As Integer = 0, ByVal appBkColor As Integer = 0, ByVal bg As Integer = 0) As FIBITMAP Ptr
Declare Function FreeImage_JPEGCrop Alias "FreeImage_JPEGCrop" (ByVal src_file As ZString Ptr, ByVal dst_file As ZString Ptr, ByVal Left As Integer, ByVal top As Integer, ByVal Right As Integer, ByVal bottom As Integer) As Integer

#EndIf '' __FREEIMAGE_BI__