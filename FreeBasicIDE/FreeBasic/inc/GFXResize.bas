#include once "windows.bi"
#include once "crt.bi"
#include once "fbgfx.bi"

#define GfxResize
namespace gfx
  dim shared as long lOrgFbProc
  dim shared as integer iScrWid,iScrHei
  function FbSubClass(hwnd as hwnd,iMsg as integer,wparam as wparam,lparam as lparam) as lresult
    select case iMsg
    case WM_MOUSEMOVE      
      var xPos = cshort(LOWORD(lParam)),yPos = cshort(HIWORD(lParam))      
      dim as rect fbcli = any: GetClientRect(hwnd,@fbcli)            
      xPos = cshort((xPos*iScrWid)\fbcli.Right)
      yPos = cshort((yPos*iScrHei)\fbcli.Bottom)
      'SetWindowText(hwnd,"Ok = " & iScrWid & "x" & iScrHei & " - " & fbcli.right & "x" & fbcli.bottom & " - " & xPos & "," & yPos)
      lParam = MAKELONG(cushort(xPos),cushort(yPos))
    case WM_NCHITTEST,WM_NCMOUSEMOVE,12,174,32      
      '
    case WM_GETMINMAXINFO,WM_SIZE
      return DefWindowProc(hwnd,imsg,wparam,lparam)
    case WM_DESTROY,WM_CLOSE
      'return 0
    case else
      'printf "%i(%x) ",iMsg,iMsg
    end select    
    return CallWindowProc(cast(any ptr,lOrgFbProc),hwnd,iMsg,wparam,lparam)
  end function
  sub Resize(iWid as integer=0,iHei as integer=0,iCenter as integer=1)    
    static fbWnd as hwnd, fbrct as rect, fbcli as rect
    static iDeskWid as integer,iDeskHei as integer    
    dim as hwnd newWnd
    Screencontrol(fb.get_window_handle,*cast(ulong ptr,@newWnd))      
    screeninfo iScrWid,iScrHei
    if newWnd<>fbWnd then
      fbWnd = newWnd
      lOrgFbProc = SetWindowLong(fbWnd,GWL_WNDPROC,clng(@FbSubClass))              
      iDeskWid = GetSystemMetrics(SM_CXFULLSCREEN)
      iDeskHei = GetSystemMetrics(SM_CYFULLSCREEN)
      GetWindowRect(fbwnd,@fbrct)
      GetClientRect(fbwnd,@fbcli)
    end if    
    var iSx = ((fbrct.right-fbrct.left)-(fbcli.right-fbcli.left))+iWid
    var iSy = ((fbrct.bottom-fbrct.top)-(fbcli.bottom-fbcli.top))+iHei    
    var iLeft = (iDeskWid-iSx)\2, iTop = (iDeskHei-iSy)\2
    var iFlags = iif(iCenter,0,SWP_NOMOVE) or SWP_SHOWWINDOW or SWP_NOZORDER
    if iWid=0 or iHei=0 then 
      iSx = GetSystemMetrics(SM_CXSCREEN)
      iSy = GetSystemMetrics(SM_CYSCREEN)      
      iCenter=1 : iLeft=0 : iTop=0
    end if    
    
    'if iWasMax then 
    '  SetWindowPos(fbWnd,null,-640,0,null,null,SWP_NOSIZE or SWP_NOZORDER)
    '  ShowWindow(fbwnd,SW_MAXIMIZE)
    'else
    SetWindowPos(fbWnd,HWND_TOPMOST,iLeft,iTop,iSx,iSy,iFlags)
    'end if
  end sub    
  dim shared PreDetour as any ptr, llDetour as ulongint
  declare sub PreResize(iUndo as integer=0)  
  sub AutoUnDetour() destructor    
    if PreDetour then PreResize(1)    
  end sub 
  const NOTVIS = (not WS_VISIBLE)
  sub CreateWindowExADetour naked ()
    asm
      mov eax,[PreDetour]
      pusha
      push 1
      call PreResize
      popa      
      and dword ptr [esp+16], NOTVIS
      push ebp
      mov ebp,esp
      jmp eax
    end asm
  end sub     
  sub PreResize(iUndo as integer=0)
    if PreDetour=0 then                  
      var pPtr = cast(any ptr,GetProcAddress(GetModuleHandle("user32.dll"),"CreateWindowExA"))
      dim as integer OldProt = any      
      PreDetour = pPtr+5 'mov esi | push ebp | mov ebp,esp
      VirtualProtect(pPtr,8,PAGE_READWRITE,@OldProt)      
      if iUndo then
        *cptr(ulongint ptr,pPtr) = llDetour
        PreDetour = 0
      else
        llDetour = *cptr(ulongint ptr,pPtr)
        *cptr(ubyte ptr,pPtr+0) = &hE9
        *cptr(ulong ptr,pPtr+1) = clng(@CreateWindowExADetour)-clng(pPtr+5)      
      end if
      VirtualProtect(pPtr,8,OldProt,@OldProt)
      FlushInstructionCache(GetCurrentProcess(),pPtr,8)      
    end if    
  end sub  
end namespace
