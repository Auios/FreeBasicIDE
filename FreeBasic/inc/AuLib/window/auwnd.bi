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
                
                declare sub Set(w as long = 800, h as long = 600, depth as long = 32, pages as long = 1, flags as long = 0, title as zstring*32 = "Application")
                declare function GetSize(byref w as long, byref h as long) as integer
                declare function Create() as integer
                
                declare function Hide() as integer
                declare function Destroy() as integer
                declare function Dump(message as zstring*32 = "") as integer
        end type
        
        declare function AuWindowSet(w as long = 800, h as long = 600, depth as long = 32, pages as long = 1, flags as long = 0, title as zstring*32 = "Application") as AuWindow
        declare function AuWindowGetSize(thisWnd as AuWindow, byref w as long, byref h as long) as integer
        declare function AuWindowCreate(thisWnd as AuWindow) as integer
        
        declare function AuWindowHide(thisWnd as AuWindow) as integer
        declare function AuWindowDestroy(thisWnd as AuWindow) as integer
        declare function AuWindowDump(thisWnd as AuWindow,message as zstring*32 = "") as integer
        
        declare function AuWindowPrintBar(charVar as zstring*1, cnt as long) as integer
    end namespace
#endif