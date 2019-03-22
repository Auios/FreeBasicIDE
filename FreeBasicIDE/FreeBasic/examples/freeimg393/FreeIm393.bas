'Freeimage quantizes a high-color 24-bit bitmap to an 8-bit palette color bitmap in a first class quality.
'I use Joshys "test32.png" for testing 

#Include Once "FreeImage393.bi"

Screen 19,32
Dim As FIBITMAP Ptr Dib1, Dib2

Dib1 = FreeImage_Load(FIF_PNG, "test32.png", 0)
FreeImage_Save(FIF_BMP, Dib1, "xtest32.bmp", 0)
BLoad "xtest32.bmp"

'erst zu 24-bit Bitmap dann zu 8-bit Palette Color Bitmap umwandeln.
'Dib2 = FreeImage_ColorQuantize (FreeImage_ConvertTo24Bits (Dib1), FIQ_NNQUANT)

'A new function in the freeimage.dll (v3.9.3) is:
' // Only use 255 colors, so the 256th can be used for transparency
' FIBITMAP *dib8_b = FreeImage_ColorQuantizeEx(dib, FIQ_NNQUANT, 255, 0, NULL);
Dib2 = FreeImage_ColorQuantizeEx(FreeImage_ConvertTo24Bits (Dib1), FIQ_NNQUANT, 255, 0, NULL)
'but this function isn't declare in the FreeImage.bi (v3.5.0)
FreeImage_Unload(Dib1)

'Erg = FreeImage_Save(FIF_PNG, Dib2, "test8bit.png", Flag)
Dib1 = FreeImage_RotateClassic(Dib2, 90)
FreeImage_Save(FIF_BMP, Dib1, "test8bit.bmp", 0)
FreeImage_Unload(Dib2)
FreeImage_Unload(Dib1)
Sleep 3000
Screen 19,8
BLoad "test8bit.bmp"

Dim As String fimg=*FreeImage_GetVersion
Color 254,1: Locate 27,1
Print "Version ";fimg
Sleep

