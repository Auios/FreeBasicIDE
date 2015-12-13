'AuWnd.bi (Auios Window)

#ifndef __AUIOS_WINDOW__
#define __AUIOS_WINDOW__
    'include "math.bi"
    
    #inclib "auwnd"

    namespace Auios
        type AuWindow
            private:
                declare function PrintBar(charVar as zstring*1, cnt as long) as integer
            public:
                as long w,h
                as long depth
                as long pages
                as long flags
                as ubyte visible
                as zstring*48 title
                
                declare sub Set(as long = 800, as long = 600, as long = 32, as long = 1, as long = 0, as zstring*32 = "Application")
                declare function GetSize(byref as long, byref as long) as integer
                declare function Create() as integer
                
                declare function Hide() as integer
                declare function Destroy() as integer
                declare function Dump(as zstring*32 = "") as integer
        end type
        
        declare function AuWindowSet(as long = 800, as long = 600, as long = 32, as long = 1, as long = 0, as zstring*32 = "Application") as AuWindow
        declare function AuWindowGetSize(as AuWindow, byref as long, byref as long) as integer
        declare function AuWindowCreate(as AuWindow) as integer
        
        declare function AuWindowHide(as AuWindow) as integer
        declare function AuWindowDestroy(as AuWindow) as integer
        declare function AuWindowDump(as AuWindow, as zstring*32 = "") as integer
        
        declare function AuWindowPrintBar(charVar as zstring*1, cnt as long) as integer
    end namespace
#endif