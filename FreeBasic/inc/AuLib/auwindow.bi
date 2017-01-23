'AuWnd.bi
'1/22/2017

#IFNDEF _AUWND_BI_
#DEFINE _AUWND_BI_

#include "AuHelper.bi"
#include "crt.bi"
#include "fbgfx.bi"

nameSpace AuLib
    type AuWindow
        as long wdth, hght
        as long depth
        as long pages
        as long flags
        as long bpp
        as long pitch
        as long rate
        as ubyte visible
        as ubyte isInit
        as zstring*48 driver
        as zstring*64 title
        as any ptr buffer
    end type
    
    function AuWindowInit(wdth as long = 800, hght as long = 600, depth as long = 32, pages as long = 1, flags as long = 0, title as zstring*64 = "Application") as AuWindow
        dim as AuWindow wnd
        wnd.wdth = wdth
        wnd.hght = hght
        wnd.depth = depth
        wnd.pages = pages
        wnd.flags = flags
        wnd.title = title
        wnd.isInit = 1
        return wnd
    end function
    
    function AuWindowSet(wdth as long = 800, hght as long = 600, depth as long = 32, pages as long = 1, flags as long = 0, title as zstring*64 = "Application") as AuWindow
        return AuWindowInit(wdth, hght, depth, pages, flags, title)
    end function
    
    sub AuWindowGetSize(wnd as AuWindow, byref wdth as long, byref hght as long)
        wdth = wnd.wdth
        hght = wnd.hght
    end sub
    
    function AuWindowCreate(wnd as AuWindow) as integer
        dim as integer result
        if(wnd.isInit) then
            wnd.visible = 1
            result  = screenRes(wnd.wdth, wnd.hght, wnd.depth, wnd.pages, wnd.flags)
            wnd.buffer = screenPtr()
            screenInfo(,,,wnd.bpp, wnd.pitch, wnd.rate, wnd.driver)
            windowTitle(wnd.title)
        else
            result = -4669
        end if
        return result
    end function
    
    sub AuWindowHide(wnd as AuWindow)
        wnd.visible = 0
        screen(0)
    end sub
    
    sub AuWindowDestroy(wnd as AuWindow)
        wnd.wdth = 0
        wnd.hght = 0
        wnd.depth = 0
        wnd.pages = 0
        wnd.flags = 0
        wnd.title = ""
        wnd.isInit = 0
        wnd.visible = 0
        screen(0)
    end sub
    
    sub AuWindowDump(wnd as AuWindow, message as zstring*64 = "")
        AuLibPrintBar("-",10)
        if(message <> "") then printf(!"%s\n", message)
        printf(!"Width---: %d\n", wnd.wdth)
        printf(!"Height--: %d\n", wnd.hght)
        printf(!"Depth---: %d\n", wnd.depth)
        printf(!"Pages---: %d\n", wnd.pages)
        printf(!"Flags---: %d\n", wnd.flags)
        printf(!"Title---: %d\n", wnd.title)
        printf(!"Visible-: %d\n", wnd.visible)
    end sub
end nameSpace

#ENDIF