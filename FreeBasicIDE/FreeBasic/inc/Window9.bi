#Ifndef __WINDOW9_BI__
#define __WINDOW9_BI__

'#define WIN_INCLUDEALL
 
#Include once "zlib.bi"
#include once "windows.bi"
#Include once "win/commctrl.bi"
#include once "win/commdlg.bi"
#include once "win/shellapi.bi"
#include once "win/shlobj.bi"
#Include once "win/tlhelp32.bi"
#include once "win/gdiplus.bi"
#Include once "win/richedit.bi"
#Include once "win/dshow.bi"
#Include once "win/exdisp.bi"
#Include once "win/mshtmhst.bi"
#include once "GL/glu.bi"
#Include Once "win/wininet.bi"


#define FB_IGNORE 999999



#Define EventSize     &h5
#define EventActivate &H6
#define EventClose    &H10
#Define EventPaint    &hF

#define EventKeyDown &h100
#define EventKeyUp   &h101

#Define EventTimer &H113

#define EventLBDown   &H201
#define EventLBUp     &H202
#define EventRBDown   &H204
#define EventRBUp     &H205
#define EventMBDown   &H207
#define EventMBUp     &H208

#define EventMouseMove  &H200
#define EventMouseWheel &H20A

#define EventGadget   &h401
#define EventMenu  &h402

Dim shared Sl99ee3p____w99in__dow__9 As Integer
#Macro SleepW9(n)
	Sl99ee3p____w99in__dow__9+=1
	If Sl99ee3p____w99in__dow__9>=n Then
		sleep(1)
		Sl99ee3p____w99in__dow__9=0
	EndIf
#EndMacro

#IFNDEF __INCARRAY_BI__
#DEFINE __INCARRAY_BI__

#macro IncludeBinary(filename,name)
#if __FUNCTION__ <> "__FB_MAINPROC__"
    #error "IncArray() cannot be used within a function."
    ' just to avoid extra pointless errors and keep things cleaner
    dim label() as ubyte
#else   
    extern "c"
    extern name() alias #name as ubyte
    end extern
   
    asm
    #IF __FB_DEBUG__
        jmp .LT_END_OF_FILE_##name##_DEBUG_JMP
    #ELSE       
        .section .data
    #ENDIF
        .balign 1
        __##name##__start = .
        .incbin filename
        __##name##__len = . - __##name##__start
        .long 0                 ' add one null int as padding
        .globl ##name
        .balign 4
        ##name:
        .int __##name##__start  'data
        .int __##name##__start  'ptr
        .int __##name##__len    'size
        .int 1                  'element_len
        .int 1                  'dimensions
       
        ' dimTB
        .int  __##name##__len   'elements
        .int 0                  'lbound
        .int  __##name##__len-1 'ubound
        .LT_END_OF_FILE_##name##_DEBUG_JMP:
        .section .text
        .balign 16
    End asm
   
    #undef Name##size
#endif
#endmacro

#ENDIF        '__INCARRAY_BI__ 



' is it a exe build ?
#if __FB_OUT_EXE__ or __FB_OUT_DLL__

#inclib "window9"

	InitCommonControls( )
	Dim InitCtrlEx As INITCOMMONCONTROLSEX
	InitCtrlEx.dwSize = sizeof(InitCommonControlsEx)
	InitCtrlEx.dwICC  = ICC_STANDARD_CLASSES
	InitCommonControlsEx(@InitCtrlEx)

#else
' no must be a lib build declare things for internal use only

Type ACCELERATOR
	As HACCEL hAccel
	As HWND hwnd
End Type
#define ACCELERATORSTRUCT ACCELERATOR

Declare Function GadgetClass(ByVal gadget As HWND) As Long
Declare Sub      GetAcceleratorInfo(ByVal aa As ACCELERATOR ptr)
Declare Function GETGURRENTAL Alias "GETGURRENTAL" () As HWND
Declare Function ADDIN9999 Alias "ADDIN9999" (ByVal gadget As Integer, ByVal hhh As HWND) As Integer
Declare Function GGF() As Integer
Declare Function ColorAdd Alias "ColorAdd" (byval hwnd as HWND,ByVal colorBKD_ as Integer,ByVal colorText_ as Integer ) As Integer
Declare Function GetFbGuiWinProc() As Integer
Declare Function GetfbguiMSG() As Integer 
Declare Sub      SETDCPrint(pHdc As HDC)
Declare Function DSGC(ByVal gadget As HWND,ByVal COLBND As integer,ByVal COLText As Integer,ByVal flag As byte) As byte
Declare Function ERR_(ByVal bk As Integer) As Integer
Declare Function COOLOOR(ByVal bk As Integer, ByVal te As integer) As Integer
declare Sub      MDISUB(ByVal hMDI As HWND)

#EndIf

Namespace window9
	Type FontPrint
		Name_ As String
		size As Integer
		BOLD As integer
		Italic As Integer
		Underline As Integer
		StrikeOut As Integer
	End Type
	Type SinglePoint
		x As Single
		y As Single
	End Type
	Declare function StartPrinter(ByRef Scale As SinglePoint Ptr=0, ByVal Flagstart As Integer=1) As HDC
	Declare Sub StopPrinter()
	Declare Sub FramePage(ByRef Left_ As Integer,ByRef Right_ As Integer,ByRef Top As Integer,ByRef Bottom As Integer)
	Declare Sub PrintText(text As String,L As Integer=0,T As Integer=0, R As Integer=0, B As Integer=0, flag As Integer=0)
	Declare Sub PrintImage(ByVal bitmap_ As HBITMAP,ByVal x As Integer, ByVal y As Integer)
	Declare Sub ColorPrinter(ColorText As Integer=0,colorBK As Integer=-1, Flag As Integer=1)
	Declare Sub FontPrinter(Font As FontPrint Ptr=0)
	Declare Sub GetRealSize(ByRef X As Integer, ByRef Y As Integer)
	Declare Function GetCountLine() As Integer
	Declare Sub GetFullSize(ByRef X As Integer, ByRef Y As Integer)
	Declare Sub GetLenString(ByVal Str_ As String,ByRef X As Integer, ByRef Y As Integer)
	Declare function GetCountDoc()As Integer
	Declare Sub DocumentStart()
	Declare Sub DocumentEnd()
	Declare Sub PageStart()
	Declare Sub PageEnd()
End Namespace

' events
Declare Function WindowEvent() As Long
Declare Function WaitEvent() As Long
Declare Function EventNumber() As Integer
Declare Function MouseX() As Integer
Declare Function MouseY() As Integer
Declare Function EventHwnd() As HWND
Declare Function EventKEY() As Integer
Declare Function EventNumberToolBar() As Integer
Declare Function EventNumberListView() As Integer
Declare Function EventNumberTreeView() As Integer
Declare Function EventWParam() As WPARAM
Declare Function EventLParam() As LPARAM

' window
Declare Function OpenWindow Alias "OpenWindow" (ByVal name_ As String, ByVal x As Integer,ByVal y As Integer,ByVal Width_ As Integer,ByVal height_ As Integer,ByVal stil As Integer=WS_OVERLAPPEDWINDOW or WS_VISIBLE,ByVal style As Integer=0) As HWND
Declare Function Close_Window Alias "Close_Window" (ByVal hwnd As HWND) As Integer
Declare Function DisableWindow Alias "DisableWindow" (ByVal hwnd As HWND,ByVal state As Byte) As Integer
Declare Function HideWindow Alias "HideWindow" (ByVal hwnd As HWND,ByVal state As Byte) As Integer
Declare Function CenterWindow (ByVal hWnd As HWND) As Byte
Declare Function WindowColor Alias "WindowColor" (ByVal hwnd As HWND,ByVal colorRGB As Integer) As Integer
Declare Function UseGadgetList Alias "UseGadgetList" (hw As HWND) As Integer
Declare Function SizeX() As Integer
Declare Function SizeY() As Integer
Declare Function ResizeWindow(ByVal WindowID As HWND, ByVal x As Integer=FB_ignore,ByVal y As Integer=FB_ignore,ByVal Width_ As Integer=FB_ignore,ByVal Height_ As Integer=FB_ignore) As Integer
Declare Function WindowX(ByVal WindowID As HWND) As Integer
Declare Function WindowY(ByVal WindowID As HWND) As Integer
Declare Function WindowWidth(ByVal WindowID As HWND) As Integer
Declare Function WindowHeight(ByVal WindowID As HWND) As Integer
Declare Function WindowClientWidth(ByVal WindowID As HWND) As Integer
Declare Function WindowClientHeight(ByVal WindowID As HWND) As Integer
Declare Function WindowBounds(ByVal WindowID As HWND,byval MinimalWidth As Integer,ByVal  MinimalHeight As integer,byval MaximalWidth As integer,ByVal  MaximalHeight As integer)As Integer
Declare Function SetWindowStyle(hwnd As HWND, style As Integer , ExStyle As Bool=0, added As BOOL = 0) As Integer
Declare Function GetClassName_(hwnd As HWND) As String

#Ifndef UNICODE
#Undef GetWindowText
Declare Function GetWindowText overload(hwnd As HWND) As String
Declare Function GetWindowText overload(hwnd as HWND, buf as LPSTR, lenBuf as integer) as Integer 
#EndIf	
	


Declare Function SetWindowTop(ByVal hwnd As HWND,ByVal state As Integer) As Integer
Declare Function SetTransparentWindow(ByVal wnd As HWND,ByVal AlphaState As Integer) As Integer
Declare Function WindowBackgroundImage(ByVal wnd As HWND,ByVal bitmap_ As HBITMAP,ByVal param As Integer=0) As Integer
Declare Function AddKeyboardShortcut(ByVal hwnd As HWND,ByVal Syskey As Integer,ByVal Shortcut As integer, ByVal ID_Event As Integer)As HACCEL
Declare Function DeleteAllKeyboardShortcut(ByVal hwnd As HWND) As Integer
Declare function IsMouseOver(ByVal wnd As HWND) As Integer

' gadget
Declare Function ID_In_Number Alias "ID_In_Number"(ByVal ID As HWND) As Integer
Declare Function GadgetID Alias "GadgetID"(ByVal gadget As Integer) As HWND
Declare Function FreeGadget(ByVal gadget As Integer) As Byte
Declare Function GadgetX(ByVal gadget As Integer) As Long
Declare Function GadgetY(ByVal gadget As Integer) As Long
Declare Function GadgetWidth(ByVal gadget As Integer) As Integer
Declare Function GadgetHeight(ByVal gadget As Integer) As Integer
Declare Function ResizeGadget(ByVal gadget As Integer, ByVal x As Integer=FB_ignore,ByVal y As Integer=FB_ignore,ByVal Width_ As Integer=FB_ignore,ByVal Height_ As Integer=FB_ignore) As Integer
Declare Function DisableGadget Alias "DisableGadget" (ByVal gadget As Integer,ByVal state As Byte) As Integer
Declare Function HideGadget Alias "HideGadget" (ByVal gadget As Integer,ByVal state As Byte) As Integer
Declare Function GetGadgetText Alias "GetGadgetText"(ByVal gadget As Integer,ByVal num As Byte=1) As String
Declare Function SetGadgetText Alias "SetGadgetText" (ByVal gadget As Integer,ByVal Text As string) As integer
Declare Function GetGadgetState(ByVal NumberGadget As Integer) As Integer
Declare Function SetGadgetState(ByVal NumberGadget As Integer,ByVal state As Integer) As Integer
Declare Function GetGadgetAttribute(ByVal NumberGadget As Integer,ByVal Attribut As Integer) As Integer
Declare Function SetGadgetAttribute(ByVal NumberGadget As Integer,ByVal Attribut As Integer,ByVal ValueMax As Integer,ByVal ValueMin As Integer=0) As Integer
Declare Function SetGadgetColor Alias "SetGadgetColor" (byval gadget As Integer,ByVal colorBKD_ as Integer,ByVal colorText_ as Integer, ByVal flag as Byte) As Integer
Declare Function GetGadgetColor Alias "GetGadgetColor" (byval gadget as Integer ,ByVal flag as Byte ) As Integer
Declare Function UpdateItem(ByVal gadget As Integer,ByVal item As Integer) As Integer
Declare Function SetGadgetStyle(gadget As Integer, style As Integer , ExStyle As Bool=0, added As BOOL = 0) As Integer

' statusbar
Declare Function StatusBarGadget(ByVal gadget As Integer,ByVal SingleText As String="",ByVal style As Long=0,ByVal style2 As Long=0) As HWND
Declare Sub      RemoveStatusbar(gadget As Integer)
Declare Function SetStatusBarField(ByVal gadget As Integer,ByVal NField As Integer, ByVal Width_ As Integer, ByVal Text As String) As Integer
Declare Sub      ToolTipStatusBar(ByVal gadget As Integer, ByVal NumberField As Integer,ByVal text As String)

' combobox
Declare Function ComboBoxGadget Alias "ComboBoxGadget" (ByVal gadget As Integer, ByVal x As Integer,ByVal y As Integer,ByVal Width_ As Integer,ByVal height_ As Integer,ByVal par As Integer=CBS_DROPDOWNLIST Or WS_VSCROLL) As HWND
Declare Function ShowListComboBox Alias "ShowListComboBox" (ByVal gadget As Integer, ByVal state As Integer=0) As Integer
Declare Function LenItemTextComboBox Alias "LenItemTextComboBox" (ByVal gadget As Integer, ByVal item As Integer=0) As Integer
Declare Function AddComboBoxItem Alias "AddComboBoxItem" (ByVal gadget As Integer, ByVal string_ As String,ByVal pos_ As integer) As Integer
Declare Function DeleteComboBoxItem Alias "DeleteComboBoxItem" (ByVal gadget As Integer, ByVal pos_ As integer) As Integer
Declare Function GetComboBoxText Alias "GetComboBoxText" (ByVal gadget As Integer, ByVal pos_ As Integer) As String
Declare Function CountItemComboBox Alias "CountItemComboBox" (ByVal gadget As Integer) As Integer
Declare Function ResetAllComboBox Alias "ResetAllComboBox" (ByVal gadget As Integer) As Integer
Declare Function FindItemComboBox Alias "FindItemComboBox" (ByVal gadget As Integer,ByVal stri As String,ByVal Startpos As Short=-1) As Integer
Declare Function SetItemComboBox Alias "SetItemComboBox" (ByVal gadget As Integer,ByVal number As Integer) As Integer
Declare Function GetItemComboBox Alias "GetItemComboBox" (ByVal gadget As Integer) As Integer
Declare Function FileComboBoxItem Alias "FileComboBoxItem" (ByVal gadget As Integer, ByVal File_AND_MASK As String,ByVal ATTRIBUT As Integer=DDL_READWRITE or DDL_READONLY Or DDL_HIDDEN or DDL_SYSTEM or DDL_DIRECTORY) As Integer
Declare Function ComboBoxImageGadget Alias "ComboBoxImageGadget" (ByVal gadget As Integer, ByVal x As Integer,ByVal y As Integer,ByVal Width_ As Integer, _
ByVal height_ As Integer,ByVal SizeIcon As Integer=16,ByVal par As Integer=CBS_DROPDOWNLIST Or WS_VSCROLL    ) As HWND
Declare Function GetHimageCombo_(ByVal gadget As Integer) As Integer
Declare Function AddComboBoxImageItem Alias "AddComboBoxImageItem" (ByVal gadget As Integer, ByVal string_ As String,ByVal IDImage_ As HBITMAP,ByVal pos_ As integer) As Integer
Declare Function SetComboBoxItemText(ByVal gadget As Integer, ByVal string_ As String,ByVal Item As integer) As Integer

' listbox
Declare Function ListBoxGadget Alias "ListBoxGadget" (ByVal gadget As Integer, ByVal x As Integer,ByVal y As Integer,ByVal Width_ As Integer,ByVal height_ As Integer,ByVal parametr As Integer=LBS_SORT Or WS_VSCROLL Or WS_HSCROLL Or LBS_WANTKEYBOARDINPUT Or LBS_NOTIFY,ByVal parametr2 As Integer=0) As HWND
Declare Function AddListBoxItem Alias "AddListBoxItem" (ByVal gadget As Integer, ByVal string_ As String,ByVal item As Integer=-1) As Integer
Declare Function DeleteListBoxItem Alias "DeleteListBoxItem" (ByVal gadget As Integer,ByVal pos_ As integer) As Integer
Declare Function FileListBoxItem Alias "FileListBoxItem" (ByVal gadget As Integer, ByVal File_AND_MASK As String,ByVal ATTRIBUT As Integer=DDL_READWRITE or DDL_READONLY Or DDL_HIDDEN or DDL_SYSTEM or DDL_DIRECTORY) As Integer
Declare Function FindItemListBox Alias "FindItemListBox" (ByVal gadget As Integer,ByVal stri As String,ByVal Startpos As Short=-1) As Integer
Declare Function CountItemListBox Alias "CountItemListBox" (ByVal gadget As Integer) As Integer
Declare Function SetSelectManyItem Alias "SetSelectManyItem" (ByVal gadget As Integer,ByVal Start As Integer,ByVal Finish As Integer, ByVal flag As Integer=1) As Integer
Declare Function SetColumnWidthListBox Alias "SetColumnWidthListBox" (ByVal gadget As Integer,ByVal width_ As Integer) As Integer
Declare Function SetItemListBox Alias "SetItemListBox" (ByVal gadget As Integer,ByVal number As Integer) As Integer
Declare Function GetItemListBox Alias "GetItemListBox" (ByVal gadget As Integer) As Integer
Declare Function GetSelCountListBox Alias "GetSelCountListBox" (ByVal gadget As Integer,ByVal ARRAY_ As Integer Ptr=0) As Integer
Declare Function GetListBoxText Alias "GetListBoxText" (ByVal gadget As Integer,ByVal item As Integer) As String
Declare Function LenItemTextListBox Alias "LenItemTextListBox" (ByVal gadget As Integer,ByVal item As Integer) As Integer
Declare Function GetTopIndexListBox Alias "GetTopIndexListBox" (ByVal gadget As Integer) As Integer
Declare Function SetTopIndexListBox Alias "SetTopIndexListBox" (ByVal gadget As Integer, ByVal item As Integer) As Integer
Declare Function ResetAllListBox Alias "ResetAllListBox" (ByVal gadget As Integer) As Integer
Declare Function SetListBoxItemText(ByVal gadget As Integer, ByVal string_ As String,ByVal Item As integer) As Integer

' listview
Declare Function ListViewGadget(ByVal gadget As Integer, ByVal x As Integer,ByVal y As Integer,ByVal Width_ As Integer,ByVal height_ As Integer,ByVal StyleListView As Integer=0,ByVal par As Integer= LVS_ICON  Or LVS_REPORT,ByVal par2 As Integer=0,ByVal SizeIcon As Integer=16, ByVal StyleIcon As Integer=LVSIL_SMALL  ) As HWND
Declare Function AddListViewColumn(ByVal gadget As Integer, ByVal string_ As String,ByVal pos_ As Integer,ByVal SubItem_ As Integer,ByVal width_Column As Integer,ByVal Style_Column_TEXT As Integer=LVCFMT_CENTER,ByVal Style_Mask As Integer=LVCF_FMT Or LVCF_SUBITEM Or LVCF_TEXT Or LVCF_WIDTH) As Integer
Declare Function AddListViewItem(ByVal gadget As Integer, ByRef string_ As String,ByVal IDImage_ As HBITMAP,ByVal pos_ As integer,ByVal SubItem_ As integer,ByVal Mask_item As Integer=LVIF_TEXT  Or LVIF_IMAGE) As Integer
Declare Function GetSubItemListView() As Integer
Declare Function GetItemListView() As Integer
Declare Function FlagKeyListView() As Integer
Declare Function GetColumnListView() As Integer
Declare Function DeleteListViewItemsAll(ByVal gadget As Integer) As Integer
Declare Function DeleteItemListView(ByVal gadget As Integer,ByVal Item As Integer) As Integer
Declare Function DeleteIndexImageListView(ByVal gadget As Integer,ByVal indexImage As Integer) As Integer
Declare Function DeleteListViewColumn(ByVal gadget As Integer,ByVal columnIndex As Integer) As Integer
Declare Function GetColumnWidthListView(ByVal gadget As Integer,ByVal IndexColumn As Integer) As Integer
Declare Function GetItemCountListView(ByVal gadget As Integer) As Integer
Declare Function GetTextItemListView(ByVal gadget As Integer,ByVal Item As Integer,ByVal SubItem_ As Integer) As String
Declare Function SetColumnWidthListView(ByVal gadget As Integer,ByVal IndexColumn As Integer,ByVal Width_ As Integer,ByVal flag As Integer=-1) As Integer
Declare Function GetSelectedCountListView(ByVal gadget As Integer) As Integer
Declare Function ReplaceTextItemListView(ByVal gadget As Integer,ByVal Item_ As integer,ByVal SubItem_ As integer, ByVal Text_ As String) As Integer
Declare Function ReplaceTextColumnListView(ByVal gadget As Integer,ByVal Column As integer , ByVal Text_ As String) As Integer
Declare Function ReplaceImageListView(ByVal gadget As Integer,ByVal indexImage As Integer, ByVal Image As HBITMAP) As Integer
Declare Function SetSelectListViewItem(ByVal gadget As Integer, ByVal Item As Integer) As Integer
Declare Function GetSelectedListViewItem( gadget As Integer, Item as Integer, Mask As Integer = LVIS_SELECTED	Or LVIS_FOCUSED) As Integer

'ExplorerListGadget
Type OptionsExplorerGadget
	szName As String*30 = "Name"
	szSize As String*15 = "Size"
	szType As String*15 = "Type"
	szModified As String*15 = "Modified"
	szCaptionError As String*15 = "Error"
	szTextError As String*50 = "Access Denied"
	iStyle As Integer	= 0
	iOneWidth As Integer = FB_IGNORE
	iTwoWidth As Integer = FB_IGNORE
	iThreeWidth As Integer = FB_IGNORE
	iFourWidth As Integer = FB_IGNORE
End Type
Declare Function ExplorerListGadget(gadget As Integer, x As Integer, y As Integer, width_ As Integer=400, height As Integer=300, szPath As String = "C:\", LGELocal As OptionsExplorerGadget ptr= 0) As HWND
Declare Function GetExplorerListGadgetHwnd(gadget As Integer) As HWND
Declare Function GetExplorerListGadgetPath(gadget As Integer) As String
Declare Function SetExplorerListGadgetPath(gadget As Integer, Path As String) As BOOL
Declare Function SetExplorerListGadgetSort(gadget As Integer, Column As Integer) As Integer
Declare Function GetExplorerListGadgetCurentItem(gadget As Integer) As Integer
Declare Function SetExplorerListGadgetStyle(gadget As Integer,Style As Integer) As Integer
Declare Sub FlagExplorerListGadget(gadget As Integer, iFlag As Integer = 3)

' trackbar
Declare Function TrackBarGadget (ByVal gadget As Integer, ByVal x As Integer,ByVal y As Integer,ByVal Width_ As Integer,ByVal height_ As Integer,ByVal min_ As Integer, ByVal max_ As Integer,ByVal style As Integer=1) As HWND
Declare Function SetTrackBarPos (ByVal gadget As Integer, ByVal NewPos_ As Integer) As Integer
Declare Function GetTrackBarPos (ByVal gadget As Integer) As Integer
Declare Function SetTrackBarMaxPos (ByVal gadget As Integer, ByVal MaxPos_ As Integer,ByVal flag As Integer=0) As Integer
Declare Function SetTrackBarMinPos (ByVal gadget As Integer, ByVal MinPos_ As Integer,ByVal flag As Integer=0) As Integer

' calender
Declare Function CalendarGadget(ByVal gadget As Integer,ByVal x As Integer,ByVal y As Integer,ByVal width_ As Integer,ByVal height_ As Integer,ByVal Style As Integer=0) As HWND
Declare Function DateCalendarGadget (ByVal gadget As Integer,ByVal x As Integer,ByVal y As Integer,ByVal width_ As Integer,ByVal height_ As Integer) As HWND
Declare Function GetStateCalendar (ByVal gadget As Integer,ByVal flag As Byte=5) As Integer
Declare Function SetStateCalendar (ByVal gadget As Integer,ByVal YEAR_ As Integer,ByVal MONTH_ As Integer,ByVal DAY_ As Integer) As Integer

' treeview
#Undef TVI_ROOT
#Undef TVI_FIRST
#Undef TVI_LAST
#Undef TVI_SORT
#define TVI_ROOT	&hFFFF0000
#define TVI_FIRST	&hFFFF0001
#define TVI_LAST	&hFFFF0002
#define TVI_SORT	&hFFFF0003
Declare Function TreeViewGadget(ByVal gadget As Integer, ByVal x As Integer,ByVal y As Integer,ByVal Width_ As Integer,ByVal height_ As Integer,ByVal par As Integer= 0,ByVal par2 As Integer=0,ByVal SizeIcon As Integer=16)As HWND
Declare Function AddTreeViewItem OverLoad(ByVal gadget As Integer, ByVal string_ As String,ByVal IDImage_0 As HBITMAP,ByVal IDImage_Selected As HBITMAP,ByVal pos_ As integer,ByVal parent As Integer=0) As Integer 
Declare Function AddTreeViewItem(ByVal gadget As Integer, ByVal string_ As String,ByVal IDImage_0 As HICON,ByVal IDImage_Selected As HICON,ByVal pos_ As integer,ByVal parent As Integer=0) As Integer 
Declare Function GetItemTreeView() As Integer
Declare Function DeleteTreeViewItem(ByVal gadget As Integer,ByVal Item As Integer) As Integer
Declare Function GetCountItemTreeView(ByVal gadget As Integer) As Integer
Declare Sub ReplaceImageItemTreeView OverLoad(ByVal gadget As Integer,ByVal item As Integer, ByVal image As Hbitmap=0,ByVal Selectimage As Hbitmap=0)
Declare Sub ReplaceImageItemTreeView (ByVal gadget As Integer,ByVal item As Integer, ByVal image As HICON=0,ByVal Selectimage As HICON=0) 
Declare Function RenameItemTreeView(ByVal gadget As Integer,ByVal item As Integer, ByVal String_ As String)As Integer
Declare Function GetIndexImageTreeView(ByVal gadget As Integer, ByVal item As Integer,ByVal flag As Integer=0) As Integer
Declare Function GetTextTreeView(ByVal gadget As Integer, ByVal item As Integer) As String
Declare Function MoveItemTreeView(ByVal gadget As Integer,ByVal itembegin As Integer, ByVal itemend As Integer, ByVal Parent As Integer)As Integer

' ipstringfield
Declare Function IpAddressGadget Alias "IpAddressGadget"(ByVal gadget As Integer,ByVal x As Integer,ByVal y As Integer,ByVal width_ As Integer,ByVal height_ As Integer) As HWND
Declare Function SetIpAddress Alias "SetIpAddress" (ByVal gadget As Integer, IP_ADDRESS As string) As LongInt
Declare Function GetIpAddress Alias "GetIpAddress" (ByVal gadget As Integer) As String

' toolbar
Declare Function CreateToolBar(ByVal Style As Integer=0,ByVal Style1 As Integer=CCS_ADJUSTABLE or CCS_NODIVIDER,ByVal Style2 As Integer=0) As Integer
Declare Function ToolBarStandardButton(ByVal hwndToolBar As Integer,ByVal ButtonID As Integer,ByVal IndexImage As Integer,ByVal String_ As String="",ByVal PositionButton As Integer=-1,ByVal Style As Integer=4,ByVal Style2 As Integer=0) As Integer
Declare Function ToolBarImageButton(ByVal hwndToolBar As Integer,ByVal buttonID As Integer,ByVal ImageID_ As Integer,ByVal String_ As String="",ByVal PositionButton As Integer=-1,ByVal Style As Integer=4,ByVal Style2 As Integer=0,ByVal SizeIcon As Integer=16) As Integer
Declare Function DeleteButtonToolBar(ByVal hwndToolBar As Integer,ByVal IndexButton As Integer) As Integer
Declare Function SetButtonToolBarState(ByVal hwndToolBar As Integer,ByVal IdButton As Integer,ByVal flag As Integer,ByVal State As Integer) As Integer
Declare Function GetButtonToolBarState(ByVal hwndToolBar As Integer,ByVal IdButton As Integer,ByVal flag As Integer) As Integer
Declare Function CountButtonToolBar(ByVal hwndToolBar As Integer) As Integer
Declare Function ToolBarToolTip(ByVal Hwnd As Hwnd,ByVal buttonID As Integer,ByRef toolTipS As String) As Integer
Declare Function SetToolBarToolTipFont(ByVal HwndToolBar As integer, ByVal Font_ As integer) As Integer
Declare Function SetToolBarToolTipColor(ByVal HwndToolBar As Integer, ByVal colorBk_ As Integer=0, ByVal colorText_ As Integer=0, ByVal flag As Integer=0) As Integer
Declare Function GetToolBarTextButton(byval HwndToolBar As Integer,ByVal ButtonID As Integer) As String
Declare Function SetToolBarButtonSize(byval HwndToolBar As Integer,ByVal x_ As Integer,ByVal y_ As Integer) As Integer
Declare Function ToolBarSeparator(ByVal hwndToolBar As Integer,ByVal IndexButton As Integer=-1) As Integer
Declare Function DeleteToolBar(ByVal hwndToolBar As Integer) As Integer 

' image
Declare Function ImageGadget (ByVal gadget As Integer, ByVal x As Integer,ByVal y As Integer,ByVal Width_ As Integer,ByVal height_ As Integer, ByVal imageId As HBITMAP=0,stil As Integer =0,Style As Integer = SS_BITMAP) As HWND
Declare function SetImageGadget(ByVal gadget As Integer, ByVal imageID As HBITMAP) As Integer
Declare Function SetIconGadget(ByVal gadget As integer, ByVal icon As HICON) As Integer 

declare Function Load_imageA(byval Namevhod as String) as Any Ptr
declare function Load_image (byval Namevhod as String,ByVal ColorBack As Integer=0) as HBITMAP
declare Function Catch_Image(array() As UByte , color_ As COLORREF=&hf0f0f0) As HBITMAP
declare Function Catch_ImageA(array() As Ubyte ) As Any ptr
Declare Function LoadImageFromResource(lpResName As LPCTSTR,color_ As Integer=&hf0f0f0) As HBITMAP
Declare Function LoadImageFromResourceA(lpResName As LPCTSTR) As Any ptr

Declare function Free_Image(ByVal hBitmap As HBITMAP) as Integer
Declare Sub FreeGpBitmap(ByVal GpBitmap As Any Ptr)

declare function IMAGE_HEIGHT (ByVal hBitmap As HBITMAP) as Integer
declare function IMAGE_WIDTH (ByVal hBitmap As HBITMAP) as Integer
declare Function Image_WidthA(byval GpImage as Any Ptr) as Integer
declare Function Image_HeightA(byval GpImage as Any Ptr) as Integer
declare function Resize_image (ByVal hBitmap As HBITMAP , ByVal w As Integer, ByVal h As Integer,ByVal TIP As Integer = 0) as HBITMAP
declare Sub Resize_imageA(ByRef GpImage as Any Ptr,ByRef width_ As Single=0, ByRef height_ As Single=0)
declare Function Copy_imageA(byval GpImage as Any Ptr) as Any Ptr
declare function COPY_image (ByVal hBitmap As HBITMAP) as HBITMAP
declare function SAVE_image (ByVal hBitmap As HBITMAP,ByVal NAMES As String) as Integer
Declare Function SAVE_imageA(ByVal GpBitmap As Any Ptr, ByVal NAMES As string) as Integer
Declare Function Grab_Image(ByVal imagesourse As HBITMAP,ByVal x As Integer,ByVal y As Integer, ByVal width_ As Integer, ByVal Height_ As Integer) As HBITMAP
Declare Function Grab_imageA(byval GpImage as Any Ptr,ByVal x As Single=0, ByVal y As Single=0, Byref width_ As Single=0, ByRef height_ As Single=0) as Any Ptr 
Declare Function CreateCopyImageWindow(ByVal window_ As HWND) As HBITMAP
Declare Function CreateCopyImageWindowClient(ByVal window_ As HWND) As HBITMAP
Declare Function CreateCopyImageDesktop() As HBITMAP
Declare Function CreateCopyImageRect(ByVal window_ As HWND,ByVal x As Integer,ByVal y As Integer,ByVal width_ As Integer,ByVal height_ As Integer) As HBITMAP
Declare Function Create_Image(ByVal width_ As Integer, ByVal Height_ As Integer) As HBITMAP
Declare Function Create_ImageA(ByVal Width_ As Single, ByVal height_ As Single) As Any Ptr
Declare Function CreateHBitmapFromGpBitmap(ByVal GpBitmap As Any Ptr,ByVal BackColor As Integer=&hf0f0f0) As HBITMAP
Declare Function CreateGPBitmapFromHBitmap(ByVal HBitmap As HBITMAP) As Any Ptr

Declare Function Rotate4_Image(ByVal imagesourse As HBITMAP,ByVal angle As Integer) As HBITMAP
Declare Sub RotateAndScaleImage(ByVal hbmpSource As HBITMAP,ByRef hbmpDest As HBITMAP,ByVal X As Integer,ByVal Y As Integer,ByVal Xr As Integer,ByVal Yr As Integer,ByVal angle As Single,ByVal Xscale As Single=0,ByVal Yscale As Single=0,ByVal Color_ As integer=0,ByVal BGbitmap As HBITMAP=0)
Declare Sub RotateAndScaleImageA(Byval GpbitmapSource As Any Ptr,ByRef hbmpDest As HBITMAP,ByVal X As Integer,ByVal Y As Integer,ByVal Xr As Integer,ByVal Yr As Integer,ByVal angle As Single,ByVal Xscale As Single=0,ByVal Yscale As Single=0,ByVal Color_ As Integer=0,ByVal BGbitmap As Any ptr=0)

' icon
Declare Function CreateIconOrCursorFromFile(ByVal NameFile As String) As HICON
Declare Function CreateIconOrCursorFromBitmap(ByVal hbmp As HBITMAP) As HICON
Declare Function CreateIconOrCursorFromGpBitmap(ByVal GpBitmap As Any Ptr) As HICON
Declare Function SaveIconOrCursor(hIcon As HICON, filename As String) As Integer
Declare Function load_Icon(ByVal filename As String) As HICON
Declare Function Extract_Icon(byval FileName as String,ByVal number As Integer,ByVal colorBk As Integer=&hf0f0f0) as HBITMAP

' button
Declare Function ButtonImageGadget (ByVal gadget As Integer, ByVal x As Integer,ByVal y As Integer,ByVal Width_ As Integer,ByVal height_ As Integer,ByVal imageId As Integer=0, ByVal Style As Integer=BS_BITMAP) As HWND
Declare Function ButtonGadget (ByVal gadget As Integer, ByVal x As Integer,ByVal y As Integer,ByVal Width_ As Integer,ByVal height_ As Integer,ByVal stri As String="",ByVal par As Integer=0) As HWND
Declare Function CheckBoxGadget (ByVal gadget As Integer, ByVal x As Integer,ByVal y As Integer,ByVal Width_ As Integer,ByVal height_ As Integer,ByVal stri As String="",ByVal par As Integer=3) As HWND
Declare Function TextGadget (ByVal gadget As Integer, ByVal x As Integer,ByVal y As Integer,ByVal Width_ As Integer,ByVal height_ As Integer,ByVal stri As String="",ByVal par As Integer=0) As HWND
Declare Function OptionGadget (ByVal gadget As Integer, ByVal x As Integer,ByVal y As Integer,ByVal Width_ As Integer,ByVal height_ As Integer,ByVal stri As String="",ByVal par As Integer=9) As HWND
Declare Function StringGadget (ByVal gadget As Integer, ByVal x As Integer,ByVal y As Integer,ByVal Width_ As Integer,ByVal height_ As Integer,ByVal stri As String="",ByVal par As Integer=0,ByVal DOPPAR As Integer=0) As HWND
Declare Function HyperLinkGadget(ByVal gadget As Integer, ByVal x As Integer,ByVal y As Integer,ByVal Width_ As Integer,ByVal height_ As Integer,ByVal stri As String="") As HWND
Declare Function SpinGadget(ByVal gadget As Integer,ByVal x As Long,ByVal y As Long,ByVal w As Long,ByVal h As Long,ByVal maxvalue As Long,ByVal minvalue As Long,ByVal curvalue As Long,ByVal style As Long=2 Or 4,ByVal style2 As Long=0) As HWND
Declare Function GroupGadget (ByVal gadget As Integer, ByVal x As Integer,ByVal y As Integer,ByVal Width_ As Integer,ByVal height_ As Integer,ByVal stri As String="") As HWND

Declare Function ProgressBarGadget(ByVal gadget As Integer, ByVal x As Integer,ByVal y As Integer,ByVal Width_ As Integer,ByVal height_ As Integer,ByVal BeginPos As Integer=0,ByVal EndPos As Integer=0,ByVal style As Integer=0) As HWND
Declare Function SetRangeProgressBar(ByVal gadget As Integer,ByVal BeginPos As Integer,ByVal EndPos As Integer) As Integer
Declare Function SetXProgressBarColor(ByVal gadget As Integer,ByVal farbe As Integer) As Integer

' browser
Declare Function WebGadget(ByVal Gadget As Integer,ByVal x As integer,ByVal y As integer,byval Width_ As integer,byval Height_ As integer,byval URL As String=" ",ByVal par1 As Integer=0,ByVal par2 As Integer=0) As Integer Ptr
Declare Function WebGadgetNavigate(ByVal pIWebBrowser As Integer Ptr,ByVal URL As wString ptr) As Integer
Declare Function WebGadgetGoForward(ByVal pIWebBrowser As Integer Ptr) As Integer
Declare Function WebGadgetGoBack(ByVal pIWebBrowser As Integer Ptr) As Integer
Declare Function WebGadgetRefresh(ByVal pIWebBrowser As Integer Ptr) As Integer
Declare Function WebGadgetGetURL(ByVal pIWebBrowser As Integer Ptr) As String
Declare Function WebGadgetState(ByVal pIWebBrowser As Integer Ptr) As Integer
Declare Function WebGadgetStop(ByVal pIWebBrowser As Integer Ptr) As Integer
Declare Function WebGadgetGetBody(ByVal pIWebBrowser As Integer Ptr,ByVal flag As bool=0) As String
Declare Sub      WebGadgetSetBody(ByVal pIWebBrowser As Integer Ptr,ByVal text As String)

' tooltip
Declare Function GadgetToolTip(ByVal GadgetPARRENT As INTEGER, ByVal text As String,ByVal gadget As Integer=0)As Integer
Declare Function DelToolTip(ByVal GadgetPARRENT As INTEGER,ByVal gadget As Integer) As Integer
Declare Function DisableToolTip(ByVal gadget As Integer,ByVal state As Byte) As Integer
Declare Function GetToolTipText(ByVal GadgetPARRENT As INTEGER,ByVal gadget As Integer) As string
Declare Function SetToolTipText(ByVal GadgetPARRENT As INTEGER,ByVal gadget As Integer,ByVal text As String) As Integer'

' menu
Declare Function Create_Menu() As HMENU
Declare Function CreatePopMenu () As HMENU
Declare Function CreateIconItemMenu(ByVal Hmenu As HMENU,ByVal Number As Integer,ByVal ImageId As Hbitmap) As Integer
Declare Function MenuTitle(ByVal menu As HMENU,ByVal name_ As String ) As HMENU
Declare Function MenuItem  OverLoad(ByVal number As Integer,ByVal menu As HMENU,ByVal name_ As String, ByVal flag As Integer=0 ) As Integer
Declare Function MenuItem  OverLoad(ByVal number As Integer,ByVal menu As HMENU,ByVal name_ As integer, ByVal flag As Integer=MF_BITMAP ) As Integer
Declare Function Insert_Menu  OverLoad (ByVal number As Integer,ByVal menu As HMENU,ByVal name_ As string, ByVal NumberSpace As Integer,ByVal flag As Integer=0) As Integer
Declare Function Insert_Menu  OverLoad (ByVal number As Integer,ByVal menu As HMENU,ByVal name_ As integer, ByVal NumberSpace As Integer,ByVal flag As Integer=MF_BITMAP) As Integer
Declare Function MenuBar(ByVal menu As HMENU) As Integer
Declare Function OpenSubMenu(ByVal menu As HMENU, ByVal name_ As String) As HMENU
Declare Function Delete_Menu(ByVal Hmenu As HMENU) As Integer
Declare Function HideMenu(ByVal Hmenu As HMENU,ByVal State As byte) As Integer
Declare Function FreeMenu(ByVal Hmenu As HMENU) As Integer
Declare Function Modify_Menu OverLoad (ByVal Soursenumber As Integer,ByVal menu As HMENU,ByVal name_ As string, ByVal Newnumber As Integer=FB_IGNORE,ByVal flag As Integer=0) As Integer
Declare Function Modify_Menu  OverLoad (ByVal Soursenumber As Integer,ByVal menu As HMENU,ByVal name_ As integer, ByVal Newnumber As Integer=FB_IGNORE,ByVal flag As Integer=MF_BITMAP) As Integer
Declare Function DeleteItemMenu(ByVal Hmenu As HMENU,ByVal Npos As Integer,ByVal flag As Integer=0) As Integer
Declare Function SetStateMenu(ByVal Hmenu As HMENU,ByVal Npos As Integer,ByVal State As Integer) As Integer
Declare Function GetStateMenu(ByVal Hmenu As HMENU,ByVal Npos As Integer) As Integer
Declare Function GetMenuItemText(ByVal Hmenu As HMENU,ByVal Npos As Integer) As string
Declare Function DisplayPopupMenu(ByVal Hmenu As HMENU,ByVal Xpos As Integer=MouseX(),ByVal Ypos As Integer=MouseY(),ByVal hwnd As Integer=1,ByVal flag As Integer=64) As Integer
Declare Function MenuBackColor(menu as HMENU,colour as integer,submenues as integer) as byte


' requester
Declare Function OpenFileRequester(ByVal Title As String,ByVal curentdir As String, ByVal Pattern As String = "All files (*.*)"+Chr(0)+"*.*"+Chr(0),ByVal flag As Integer=0, ByVal templateName As String = "") As String
Declare Function NextSelectedFilename() As String
Declare Function SaveFileRequester Alias "SaveFileRequester"(ByVal Title As String,ByVal curentdir As String, ByVal Pattern As String = "All files (*.*)"+Chr(0)+"*.*"+Chr(0), ByVal defaultsetpattern As bool=0,ByVal templateName As String = "") As String 
Declare Function ShellFolder( byval NameDialog as string,ByVal DefaultFolder as String,ByVal FlagOption As Integer=81) as String 'BIF_RETURNONLYFSDIRS Or BIF_USENEWUI=81
Declare Function ColorRequester(ByVal rgbCurrentUSER As Integer=0,ByVal flagg As Integer=2,ByVal hwnd As HWND=0) As COLORREF

' simple dialog
Declare Function MessBox(ByVal Caption As String,ByVal Message As String,ByVal flag As Integer=0) As Integer
Declare Function InputBox(ByVal Caption As String="", ByVal Message As String="Enter text:", ByVal DefaultString As String="", ByVal flag As Integer=0, ByVal flag2 As Integer=0) As String

' font
Declare Function LoadFont(ByVal Name_ As String ,ByVal Size As Integer,ByVal corner As Integer=0,ByVal BOLD As Integer=0,ByVal Italic As Integer=0,ByVal Underline As Integer=0,ByVal StrikeOut As Integer=0) As HFONT
Declare Function SetGadgetFont(ByVal gadget As integer = -1 ,ByVal Font As integer=-1) As Integer
Declare Function FontRequester(hwnd As HWND = 0, nColor As Integer = 0) As Integer
Declare Function SelectedFontColor() As Integer
Declare Function SelectedFontName() As String
Declare Function SelectedFontSize() As Integer
Declare Function SelectedFontStyle(ByVal style As Byte) As Byte

' clipboard
Declare Function GetClipBoardText() As String
Declare Function SetClipBoardText(ByVal Text As String) As Integer
Declare Function GetClipBoardImage() As HBITMAP
Declare Function SetClipBoardImage(ByVal hbmp As HBITMAP) As Integer
Declare Function GetClipBoardFile() As String
Declare Function SetClipboardFile(sFile As String) As Integer
Declare Function ClearClipBoard() As Integer

' file
declare Function Create_File ( ByVal FileName As String,ByVal PAR As Integer=FILE_ATTRIBUTE_NORMAL) As HANDLE
declare Function Open_File (ByVal FileName As String,ByVal PAR As Integer=FILE_ATTRIBUTE_NORMAL) As HANDLE
declare Function Read_File (ByVal FileName As String,ByVal PAR As Integer=FILE_ATTRIBUTE_NORMAL) As HANDLE
declare Function Close_File ( ByVal Handle As HANDLE) As Integer
declare Function Size_File ( ByVal Handle As HANDLE) As Integer
declare Function E_O_F ( ByVal Handle As HANDLE) As Integer
declare Function Get_File_Pointer ( ByVal Handle As HANDLE) As Integer
declare Function Set_File_Pointer ( ByVal Handle As HANDLE,ByVal Number As Integer, ByVal Method As Integer=1) As Integer
declare Function Read_Character ( ByVal Handle As HANDLE) As String
declare Function Read_Byte ( ByVal Handle As HANDLE) As Byte
declare Function Read_WORD ( ByVal Handle As HANDLE) As Short
declare Function Read_Integer ( ByVal Handle As HANDLE) As Integer
declare Function Read_Single ( ByVal Handle As HANDLE) As Single
declare Function Read_Double ( ByVal Handle As HANDLE) As Double
declare Function Read_LONGINT ( ByVal Handle As HANDLE) As LongInt
Declare Function Read_Data( ByVal Handle As handle,ByRef pMemory As Byte ptr ,ByVal Lenght As Integer) As BOOL
Declare Function Read_DataA( ByVal Handle As handle, ByVal Lenght As Integer) As Byte Ptr
Declare Function Read_DataS( ByVal Handle As handle, ByVal Lenght As Integer) As Byte Ptr
Declare Function Read_String( ByVal Handle As HANDLE) As String
declare Function Write_Character ( ByVal Handle As HANDLE, ByVal CHAR As String) As Integer
declare Function Write_Byte ( ByVal Handle As HANDLE, ByVal Byte_ As Byte) As Integer
declare Function Write_Word ( ByVal Handle As HANDLE, ByVal Word_ As Short) As Integer
declare Function Write_Integer ( ByVal Handle As HANDLE, ByVal Integer_ As Integer) As Integer
declare Function Write_Single ( ByVal Handle As HANDLE, ByVal Single_ As Single) As Integer
declare Function Write_Double ( ByVal Handle As HANDLE, ByVal Double_ As Double) As Integer
declare Function Write_String ( ByVal Handle As HANDLE, ByVal String_ As String) As Integer
declare Function Write_StringN ( ByVal Handle As HANDLE, ByVal String_ As String) As Integer
Declare Function Write_Longint ( ByVal Handle As HANDLE, ByVal Longint_ As longint) As Integer
Declare Function Write_Data ( ByVal Handle As HANDLE, ByVal Address_ As Integer, ByVal Lenght As Integer) As Integer

' folder
Declare Function CreateDir(ByVal dir_ As String) As Integer
Declare Function RemoveDir(ByVal dir_ As String) As Integer
Declare Function GetCurentDir() As String
Declare Function SetCurentDir(ByVal Dir_ As String) As Integer
Declare Function GetWindowsDir() As String
Declare Function GetSystemDir() As String
Declare Function GetTempDir() As String
Declare function GetSpecialFolder(ByVal folderFlag As integer) As String
Declare Function CopyDir(ByVal SourseDir As String,ByVal NewDir As String,ByVal flag As Integer=0) As Integer
Declare Function MoveDir(ByVal SourseDir As String,ByVal NewDir As String,ByVal flag As Integer=0) As Integer
Declare Function RenameDir(ByVal SourseDirName As String,ByVal NewDirName As String,ByVal flag As Integer=0) As Integer
Declare Function DeleteDir(ByVal DeleteDirName As String,ByVal flag As Integer=0) As Integer
Declare Function GetExtensionPart(ByVal path_ As String) As String
Declare Function GetPathPart(ByVal path_ As String) As String
Declare Function GetFilePart(ByVal path_ As String) As String
Declare Function ExamineDirectory(ByVal  DirectoryName As string,ByVal Pattern As string) As Integer
Declare Function NextDirectoryEntry(ByVal  HandleDirectory As integer) As Integer
Declare Function FinishDirectory(ByVal  HandleDirectory As integer) As Integer
Declare Function DirectoryEntrySize(ByVal  HandleDirectory As integer) As ULongInt
Declare Function DirectoryEntryDate(ByVal  HandleDirectory As Integer , ByVal flag As Integer) As String
Declare Function DirectoryEntryName(ByVal  HandleDirectory As integer) As string
Declare Function DirectoryEntryAttributes(ByVal  HandleDirectory As integer) As Integer

' dshow movie
Declare Function LoadMovie(ByVal Hwnd As HWND,ByVal nameFile As String,ByVal x As Integer, ByVal y As Integer,ByVal Width_ As Integer, ByVal Height_ As integer) as integer
Declare Function FreeMovie(ByVal Movie_ As Integer) As Integer
Declare Function PlayMovie(ByVal Movie_ As integer) As Integer
Declare Function StopMovie(ByVal Movie_ As Integer) As Integer
Declare Function PauseMovie(ByVal Movie_ As Integer) As Integer
Declare Function ResizeMovie(ByVal Movie_ As Integer,ByVal x As Integer, ByVal y As Integer, ByVal Width_ As Integer, ByVal Height_ As integer) As Integer
Declare Function SetRateMovie(ByVal Movie_ As Integer,ByVal Rate As Double) As bool
Declare Function GetRateMovie(ByVal Movie_ As Integer) As Double
Declare Function GetEndPosMovie(ByVal Movie_ As Integer) As longint
Declare Function MovieSetPositions(ByVal Movie_ As Integer,ByVal Rnew As LongInt,ByVal Rend As LongInt,ByVal flagNew As Integer=1,ByVal flagEnd As Integer=1) As Integer 'AM_SEEKING_AbsolutePositioning=1
Declare Function MovieGetCurrentPosition(ByVal Movie_ As Integer) As LongInt
Declare Function MovieSourseWidth(ByVal Movie_ As Integer) As LongInt
Declare Function MovieSourseHeight(ByVal Movie_ As Integer) As LongInt
Declare Function MovieFullScreen(ByVal Movie_ As Integer,ByVal Mode As Integer) As Integer
Declare Function MovieAudioSetVolume(ByVal Movie_ As Integer,ByVal Volume As Integer) As Integer
Declare Function MovieAudioGetVolume(ByVal Movie_ As Integer) As Integer
Declare Function MovieScreenShot(ByVal Movie_ As Integer) As HBITMAP
Declare Function MovieGetState(ByVal Movie_ As Integer,ByVal msTimeout As Integer=-1) As Integer

' 2D drawing
Declare Function ImageStartDraw(ByVal hbitmap As HBITMAP) As HDC
Declare Function WindowStartDraw(ByVal window_ As HWND,ByVal x As Integer=0,ByVal y As Integer=0,ByVal width_ As Integer=0, ByVal height_ As Integer=0,ByVal Alpha_FLAG As Integer=0, ByVal Alpha_VALUE As UInteger=0) As HDC
Declare Function StopDraw() As Integer
Declare Function LineDraw(ByVal x As Integer,ByVal y As Integer,ByVal x1 As Integer,ByVal y1 As Integer,ByVal width_ As Integer=0,ByVal color_ As Integer=0,ByVal style As Integer=PS_SOLID) As Integer
Declare Function PixDraw(ByVal x As Integer,ByVal y As Integer,ByVal Color_ As Integer) As Integer
Declare Function GetPix(ByVal x As Integer,ByVal y As Integer) As Integer
Declare Function BoxDraw(ByVal x As Integer,ByVal y As Integer,ByVal width_ As Integer,ByVal height_ As Integer,ByVal ColorPen As Integer=0,ByVal ColorBk As Integer=0,ByVal widthPen As Integer=0,ByVal StylePen As Integer=PS_SOLID, ByVal AlPHAPARAM As Integer=255) As Integer
Declare Function RoundBoxDraw(ByVal x As Integer,ByVal y As Integer,ByVal width_ As Integer,ByVal height_ As Integer,ByVal ColorPen As Integer=0,ByVal ColorBk As Integer=0,ByVal widthPen As Integer=0,ByVal StylePen As Integer=PS_SOLID,ByVal ellipsewidth As Integer=0,ByVal ellipseheight As Integer=0, ByVal AlPHAPARAM As Integer=255) As Integer
Declare Function RoundDraw(ByVal x As Integer,ByVal y As Integer,ByVal width_ As Integer,ByVal height_ As Integer,ByVal ColorPen As Integer=0,ByVal ColorBk As Integer=0,ByVal widthPen As Integer=0,ByVal StylePen As Integer=PS_SOLID, ByVal AlPHAPARAM As Integer=255) As Integer
Declare Function CircleDraw(ByVal x As Integer,ByVal y As Integer,ByVal radius As Integer,ByVal ColorPen As Integer=0,ByVal ColorBk As Integer=0,ByVal widthPen As Integer=0,ByVal StylePen As Integer=PS_SOLID, ByVal AlPHAPARAM As Integer=255) As Integer
Declare Function FontDraw(ByVal FontID As HFONT) As Integer
Declare Function TextDraw(ByVal x As Integer,ByVal y As Integer,ByVal string_ As string,ByVal ColorBK As Integer=0,ByVal ColorText As Integer=0, ByVal AlPHAPARAM As Integer=255) As Integer
Declare Function PolylineDraw(ByVal pPoint As POINT Ptr,ByVal nCount As Integer,ByVal ColorPen As Integer=0,ByVal widthPen As Integer=0,ByVal StylePen As Integer=PS_SOLID) As Integer
Declare Function PolygonDraw(ByVal pPoint As POINT ptr,ByVal nCount As Integer,byval FillColor as integer,ByVal BorderColor As Integer=0,ByVal BorderWidth As Integer=0,ByVal BorderStyle As Integer=PS_SOLID) As Integer
Declare Function ImageDraw(ByVal bitmap_ As HBITMAP,ByVal x As Integer, ByVal y As Integer, ByVal AlPHAPARAM As Integer=255) As Integer
Declare Function FillRectDraw(ByVal x As Integer, ByVal y As Integer, ByVal Color_ As Integer) As Integer
Declare Function FocusDraw(ByVal x As Integer, ByVal y As Integer, ByVal width_ As Integer, ByVal height_ As Integer) As Integer
Declare Function IconDraw(ByVal x As Integer, ByVal y As Integer, ByVal Hicon As HICON) As Integer
Declare Function GradientFillDraw  Alias "GradientFillDrawWINDOW9"(ByVal x As Integer, ByVal y As Integer,ByVal width_ As Integer, ByVal height_ As Integer,ByVal Rbegin As Integer,ByVal Gbegin As Integer,ByVal Bbegin As Integer,ByVal REnd As Integer,ByVal GEnd As Integer,ByVal BEnd As Integer, ByVal GOR_VERT As bool=0)As Integer
Declare Function PieDraw(ByVal x As Integer,ByVal y As Integer,ByVal width_ As Integer,ByVal height_ As Integer,ByVal x1 As Integer,ByVal y1 As Integer,ByVal x2 As Integer,ByVal y2 As Integer,ByVal ColorPen As Integer=0,ByVal ColorBk As Integer=0,ByVal widthPen As Integer=0,ByVal StylePen As Integer=PS_SOLID) As Integer

' 2D drawing GDI+

Declare Function ImageStartDrawA(ByRef bitmapGP As Any Ptr,ByVal ColorFlag As Integer=0,ByVal Color_ As Integer=&hFFFFFFFF) As Any Ptr
Declare Function WindowStartDrawA(ByVal window_ As HWND,ByVal x As Integer=0,ByVal y As Integer=0,ByVal width_ As Integer=0, ByVal height_ As Integer=0,ByVal ColorFlag As Integer=0,ByVal Color_ As Integer=&hFFFFFFFF) As Any Ptr
Declare Sub StopDrawA()
Declare Sub LineDrawA(ByVal x As single,ByVal y As single,ByVal x1 As single,ByVal y1 As single,ByVal width_ As Single=1,ByVal color_ As Integer=&hff000000,byval brushPen as Any Ptr=0)
Declare Sub BoxDrawA(ByVal x As single,ByVal y As single,ByVal width_ As single,ByVal height_ As single,ByVal ColorPen As integer=&hff000000,ByVal flagcolorBK As Integer=1,ByVal ColorBk As integer=&hff000000,byval brushPen as Any Ptr=0,byval brushBk as Any Ptr=0,ByVal widthPen As Single=1)
Declare Sub BezierDrawA(ByVal x0 As single,ByVal y0 As single,ByVal x1 As single,ByVal y1 As single,ByVal x2 As single,ByVal y2 As single,ByVal x3 As single,ByVal y3 As single,ByVal ColorPen As integer=&hff000000,ByVal brushPen as Any Ptr=0,ByVal widthPen As Single=1)
Declare Sub RoundDrawA(ByVal x As single,ByVal y As single,ByVal width_ As single,ByVal height_ As single,ByVal ColorPen As integer=&hff000000,ByVal flagcolorBK As Integer=1,ByVal ColorBk As integer=&hff000000,ByVal brushPen as Any Ptr=0,byval brushBk as Any Ptr=0,ByVal widthPen As Single=1)
Declare Sub CircleDrawA(ByVal x As single,ByVal y As single,ByVal Radius As single,ByVal ColorPen As integer=&hff000000,ByVal flagcolorBK As Integer=1,ByVal ColorBk As integer=&hff000000,ByVal brushPen as Any Ptr=0,byval brushBk as Any Ptr=0,ByVal widthPen As Single=1)
Declare Sub ArcDrawA(ByVal x As single,ByVal y As single,ByVal width_ As single,ByVal height_ As single,ByVal startAngle As Single,ByVal sweepAngle As Single,ByVal ColorPen As integer=&hff000000,ByVal brushPen as Any Ptr=0,ByVal widthPen As Single=1)
Declare Sub PieDrawA(ByVal x As single,ByVal y As single,ByVal width_ As single,ByVal height_ As single,ByVal startAngle As Single,ByVal sweepAngle As Single,ByVal ColorPen As integer=&hff000000,ByVal flagcolorBK As Integer=1,ByVal ColorBk As integer=&hff000000,ByVal brushPen as Any Ptr=0,byval brushBk as Any Ptr=0,ByVal widthPen As Single=1)
Declare Sub PolygonDrawA(ByVal Points As Any ptr,ByVal countPoints As Integer,ByVal ColorPen As integer=&hff000000,ByVal flagcolorBK As Integer=1,ByVal ColorBk As integer=&hff000000,ByVal brushPen as Any Ptr=0,byval brushBk as Any Ptr=0,ByVal widthPen As Single=1,ByVal fillmode As Integer=0)
Declare Sub SetPixA(ByVal X As single,ByVal Y As Single,ByVal Color_ As integer=&hff000000)
Declare Function GetPixA(ByVal X As single,ByVal Y As Single) As Integer
Declare Sub CurveDrawA(ByVal Points As Any ptr,ByVal countPoints As Integer,ByVal RoundPoints As Single=0.5,ByVal ColorPen As integer=&hff000000,ByVal flagcolorBK As Integer=1,ByVal ColorBk As integer=&hff000000,ByVal brushPen as Any Ptr=0,byval brushBk as Any Ptr=0,ByVal widthPen As Single=1,ByVal Closed As Integer=0,ByVal fillmode As Integer=0)
Declare Function CreateBrushA(ByVal x0 As Single=0,ByVal y0 As Single=0,ByVal x1 As Single=0,ByVal y1 As Single=0, ByVal color1 As Integer=&hFF00FF00, ByVal color2 As Integer=&hFF0000FF,ByVal GpImage As Any ptr=0,ByVal WrapMode As Integer=3 ) As Any Ptr
Declare Function CreateFontDrawA(ByVal name_ As String="Arial",ByVal size As Integer=10,ByVal style As Integer=0,ByVal Unit As Integer=6) As Any Ptr
Declare Sub FreeFontDrawA(ByVal GpFont As Any Ptr)
Declare Sub FreeBrushA(ByVal Brush As Any Ptr)
Declare Sub TextDrawA(ByVal text As String,ByVal x As Integer, ByVal y As Integer, ByVal GpFont As Any Ptr=0, ByVal color_ As Integer=&hFFFFFFFF,ByVal brush As Any Ptr=0,ByVal mode As Integer=0)
Declare Sub ImageDrawA(ByVal GpImage As Any Ptr,ByVal x As single, ByVal y As single,ByVal Width_ As Single=0, ByVal Height_ As Single=0)
Declare Sub ModeDrawA(ByVal mode As Integer)
Declare Sub FillRectDrawA(x As Integer, y As Integer ,newcol As Integer)

' 3D / 2D OpenGL
declare function OpenGLGadget(ByVal gadget As integer, ByVal x As Integer,ByVal y As Integer,ByVal w As Integer,ByVal h As Integer, _
     ByVal cBits  As integer=24,byval dBits as integer = 16,byval sBits as integer=0,byval aBits as integer=0) As HWND
declare function OpenGLGadgetMakeCurrent(ByVal gadget As Integer) as integer
declare function OpenGLGadgetSwapBuffers(ByVal gadget As Integer) as integer


' desktop
Declare Function EnumSettingsDisplay() As String
Declare Function ResetEnum() As Integer
Declare Function SetCurrentSettingsDisplay(ByVal width_ As Integer,ByVal height_ As Integer,ByVal Bits As Integer,ByVal Frequency As Integer) As Integer
Declare Function GetCurrentSettingsDisplay() As string
Declare Function GetWidthDesktop(ByVal setting As String) As Integer
Declare Function GetHeightDesktop(ByVal setting As String) As Integer
Declare Function GetBitsDesktop(ByVal setting As String) As Integer
Declare Function GetFrequencyDesktop(ByVal setting As String) As Integer
Declare Function GlobalMouseX() As Integer
Declare Function GlobalMouseY() As Integer

' scrollbar
Declare Function ScrollBarGadget(ByVal gadget As Integer,ByVal x As Integer, ByVal y As Integer, ByVal width_ As Integer, ByVal Height_ As Integer, ByVal MINRange As Integer, ByVal MAXRange As Integer,ByVal Style As Integer=SB_HORZ, ByVal PageLength As Integer=10) As HWND
Declare Function GetScrollGadgetRange OverLoad(ByVal HWND As HWND,ByVal flag As Integer, ByVal style As Integer) As Integer
Declare Function GetScrollGadgetRange OverLoad(ByVal gadget As Integer, ByVal flag As Integer) As Integer
Declare Function SetScrollGadgetRange OverLoad(ByVal hwnd As HWND,ByVal MINRange As Integer,ByVal MAXRange As Integer, ByVal style As Integer) As Integer
Declare Function SetScrollGadgetRange OverLoad(ByVal gadget As Integer,ByVal MINRange As Integer,ByVal MAXRange As Integer) As Integer
Declare Function GetScrollGadgetPos OverLoad(ByVal hwnd As hwnd, ByVal style As Integer) As Integer
Declare Function GetScrollGadgetPos OverLoad(ByVal gadget As Integer) As Integer
Declare Function SetScrollGadgetPos OverLoad(ByVal hwnd As HWND,ByVal POSITION As Integer, ByVal style As integer) As Integer
Declare Function SetScrollGadgetPos OverLoad(ByVal gadget As Integer,ByVal POSITION As Integer) As Integer
Declare Function SetScrollGadgetPage OVERLOAD(ByVal gadget As Integer, ByVal page As Integer) As Integer
Declare Function SetScrollGadgetPage OVERLOAD(ByVal HWND As HWND, ByVal page As Integer,ByVal style As Integer) As Integer
Declare Sub      SetPageStepScrollBar(ByVal parscroll As Integer)

' systray
#Ifndef NIIF_USER
#Define NIIF_USER 4
#EndIf
Declare Function AddSysTrayIcon(ByVal NumberSysTray As Integer,ByVal hwnd As HWND,ByVal icon As HICON,ByVal ToolTipSysTray As String) As Integer
Declare Function ReplaceSysTrayIcon(ByVal NumberSysTray As Integer,ByVal icon As HICON,ByVal ToolTipSysTray As String) As Integer
Declare Function DeleteSysTrayIcon(ByVal NumberSysTray As Integer) As Integer
Declare Function MessageSysTrayIcon(ByVal NumberSysTray As Integer,ByVal hwnd As HWND,Title As String,Text As String,Timeout As Integer = 5000,ByVal icon As HICON = 0 , ByVal TypeIcon As Integer = NIIF_INFO) As Integer
' mdi
Declare Function ClientMDIGadget(ByVal H_menu As HMENU,ByVal IDmenuMDI As Integer, ByVal Style As Integer=WS_CLIPCHILDREN Or WS_CLIPSIBLINGS  Or WS_VSCROLL Or WS_HSCROLL) As HWND
Declare Function MDIGadget(ByVal Name_ As String,ByVal x As Integer,ByVal y As Integer,ByVal width_ As Integer,ByVal height_ As Integer, ByVal Style As Integer=WS_OVERLAPPEDWINDOW) As HWND

' printer
Declare Function HWNDPrinter(hWnd As HWND,Xpr As Integer=0,Ypr As Integer=0,X As Integer=0,Y As Integer=0,X1 As Integer=0,Y1 As Integer=0) As Long
Declare Sub      TextPrinter(SourseText As String,Font As window9.FontPrint Ptr=0,color_BK As COLORREF=0,color_T As COLORREF=0)


Declare Function ContainerGadget(ByVal gadget As Integer, ByVal x As Integer,ByVal y As Integer,ByVal Width_ As Integer,ByVal height_ As Integer,ByVal par As Integer=0) As HWND
Declare Function GroupContainerGadget(byval id as integer,byval x as integer,byval y as integer,byval w as integer,byval h as integer,byval caption as string) as HWND

' panel
Declare Function PanelGadget(ByVal gadget As Integer, ByVal x As Integer,ByVal y As Integer,ByVal Width_ As Integer=0,ByVal height_ As Integer=0,ByVal SizeIcon As Integer=16,ByVal par As Integer=0) As HWND
Declare Function AddPanelGadgetItem(ByVal gadget As Integer, ByVal Item As Integer,ByVal text As String, ByVal ImageID As HBITMAP=0, ByVal flag As bool=0) As HWND
Declare Function DeleteItemPanelGadget(ByVal gadget As Integer, ByVal item As Integer) As Integer
Declare Function PanelGadgetGetCursel(ByVal gadget As Integer)As Integer
Declare Function PanelGadgetSetCursel(ByVal gadget As Integer, ByVal item As Integer)As Integer


' richedit
Declare Function EditorGadget(ByVal gadget As Integer, ByVal x As Integer,ByVal y As Integer,ByVal Width_ As Integer,ByVal height_ As Integer,ByVal stri As String="",ByVal par As Integer=0) As HWND
Declare Function UndoEditor(ByVal gadget As Integer) As Integer
Declare Function RedoEditor(ByVal gadget As Integer) As Integer
Declare Function PasteEditor(ByVal gadget As Integer, ByVal text As String , ByVal param As BOOL=1) As Integer
Declare Function CanUndoEditor(ByVal gadget As Integer) As Integer
Declare Function CanRedoEditor(ByVal gadget As Integer) As Integer
Declare Function EmptyUndoBufferEditor(ByVal gadget As Integer) As Integer
Declare Function GetLineTextEditor(ByVal gadget As Integer, ByVal Number As Integer, ByVal Buffer As Integer=512) As String
Declare Function GetLineCountEditor(ByVal gadget As Integer) As Integer
Declare Function GetModifyEditor(ByVal gadget As Integer) As Integer
Declare Function GetRectEditor(ByVal gadget As Integer, ByVal rect As RECT Ptr) As integer
Declare Function SetLimitTextEditor(ByVal gadget As Integer, ByVal limit As Integer=0) As Integer
Declare Function SetModifyEditor(ByVal gadget As Integer, ByVal flag As Integer=0) As Integer
Declare Function SetPasswordChar(ByVal gadget As Integer, ByVal CharCode As UBYTE=0) As Integer
Declare Function GetPasswordChar(ByVal gadget As Integer) As UByte
Declare Function LineFromCharEditor(ByVal gadget As Integer, ByVal index As Integer=-1) As Integer
Declare Function LineIndexEditor(ByVal gadget As Integer, ByVal NumberLine As Integer=-1) As Integer
Declare Function LineLengthEditor(ByVal gadget As Integer, ByVal index As Integer=-1) As Integer
Declare Function LineScrollEditor(ByVal gadget As Integer, ByVal VertPos As Integer) As Integer
Declare Function SetTabStopsEditor(ByVal gadget As Integer, ByVal TABWIDTH As Integer=0) As integer
Declare Function ReadOnlyEditor(ByVal gadget As Integer, ByVal ReadOnly As Integer=0) As Integer
Declare Function GetFirstVisibleLineEditor(ByVal gadget As Integer) As Integer
Declare Function SetRectEditor(ByVal gadget As Integer, ByVal rect As RECT Ptr) As integer
Declare Function GetCurrentIndexCharEditor(ByVal gadget As Integer) As integer
Declare Function SetTransferTextLineEditorGadget(ByVal gadget As Integer, ByVal state As Integer) As Integer
Declare Function GetSelectTextEditorGadget(ByVal gadget As Integer)As String
Declare Function SetSelectTextEditorGadget(ByVal gadget As Integer,ByVal begin As Integer, ByVal End_ As integer)As integer


' rebar
Declare Function RebarGadget(ByVal gadget As Integer,ByVal Style1 As Integer=WS_CLIPCHILDREN  Or WS_CLIPSIBLINGS  Or  RBS_VARHEIGHT  Or  RBS_AUTOSIZE  Or RBS_BANDBORDERS  Or  CCS_ADJUSTABLE  Or  CCS_TOP  Or  CCS_NODIVIDER,ByVal Style2 As Integer =0) As HWND
Declare Function AddRebarTab (ByVal gadget As Integer,ByVal GadgetChild As Integer,ByVal IDinNumber As Integer=0, ByVal string_ As String="",ByVal pos_ As Integer=-1,ByVal x As Integer=100, ByVal MinX As Integer=0, ByVal MinY As Integer=20, ByVal Mask As Integer=RBBIM_STYLE Or RBBIM_CHILD Or RBBIM_CHILDSIZE Or RBBIM_SIZE Or RBBIM_TEXT Or RBBIM_ID,ByVal Style As Integer=RBBS_CHILDEDGE Or  RBBS_GRIPPERALWAYS) As Integer
Declare Function GetCountTabRebarGadget(ByVal gadget As Integer) As Integer
Declare Function GetHeightRebarGadget(ByVal gadget As Integer) As Integer
Declare Function GetTextRebarGadget(ByVal gadget As Integer, ByVal index As Integer) As String
Declare Function SetTextRebarGadget(ByVal gadget As Integer, ByVal index As Integer, ByVal text As String) As Integer
Declare Function MoveTabRebarGadget(ByVal gadget As Integer, ByVal IndexMove As Integer, byval IndexNew as Integer) As integer
Declare Function DeleteTabRebarGadget(ByVal gadget As Integer, ByVal Index As Integer) As integer
Declare Function IDinIndexRebarGadget(ByVal gadget As Integer, ByVal ID As Integer) As integer

' ini
Declare Function CreateFBini( ByVal filename As String) As handle
Declare Function OpenFBini( ByVal filename As String,ByVal flag As bool=0) As handle
Declare Function CloseFBini() As bool
Declare Sub      WriteGroupFBini(Byref group As String)
Declare Sub      WriteValueFBini OverLoad(ByVal group As String,ByVal Key As String, ByVal value As byte)
Declare Sub      WriteValueFBini OverLoad(ByVal group As String,ByVal Key As String, ByVal value As Short)
Declare Sub      WriteValueFBini OverLoad(ByVal group As String,ByVal Key As String, ByVal value As Integer)
Declare Sub      WriteValueFBini OverLoad(ByVal group As String,ByVal Key As String, ByVal value As Double)
Declare Sub      WriteValueFBini OverLoad(ByVal group As String,ByVal Key As String, ByVal value As LongInt)
Declare Sub      WriteValueFBini OverLoad(ByVal group As String,ByVal Key As String, ByVal value As string)
Declare Function ReadByteValueFBini(ByVal group As String,ByVal Key As String) As byte
Declare Function ReadShortValueFBini(ByVal group As String,ByVal Key As String) As Short
Declare Function ReadIntegerValueFBini(ByVal group As String,ByVal Key As String) As Integer
Declare Function ReadLongintValueFBini(ByVal group As String,ByVal Key As String) As LongInt
Declare Function ReadDoubleValueFBini(ByVal group As String,ByVal Key As String) As Double
Declare Function ReadStringValueFBini(ByVal group As String,ByVal Key As String) As String
Declare Function GetCurrentFileName() As String
Declare Function GetCurrentFileNameA() As String
Declare Sub      SetRunOnlyExe()

' process / thread
Declare Function InitProcess()As HANDLE
Declare Function FirstProcess(handle As HANDLE) As Bool
Declare Function NextProcess(handle As HANDLE) As Bool
Declare Function GetNameProcess() As String
Declare Function GetIDProcess() As Integer
Declare Function Create_Process(ByVal FileName As String,ByVal DirDefault As String="",ByVal flag As Integer=0,ByVal STARTUPINFO_ As STARTUPINFO Ptr=0, ByVal PROCESS_INFORMATION_ As PROCESS_INFORMATION Ptr=0) As Integer
Declare Function Open_Process(ByVal pid As Integer, ByVal Access_ As Integer=PROCESS_ALL_ACCESS, ByVal flag As BOOL=0) As HANDLE
Declare Function KillProcess(ByVal hprocess As HANDLE, ByVal ExitCode As Integer=0)As bool
Declare Function WaitExitProcess(ByVal hprocess As HANDLE, ByVal WaitTime As Integer=INFINITE)As bool
Declare Function WaitLoadProcess(ByVal hprocess As HANDLE, ByVal WaitTime As Integer=INFINITE)As bool
Declare Function GetExitCode(ByVal hprocess As HANDLE) As Integer


' zip packer
Declare Function CompressMem(Byref BUF_DEST As Byte Ptr,byval SOURSEDATA As Byte ptr,Byval SIZEDATA As UInteger, ByVal level As Integer=5) As Integer
Declare Function DeCompressMem(Byref BUF_COMPRESSED As Byte Ptr,byval SIZECOMPRESSED As integer,ByRef BUFDESTDATA As Byte Ptr) As Integer
Declare Function CompressFile(ByVal filename As String, ByVal filenameDest As String,ByVal level As Integer=5) As Integer
Declare Function DeCompressFile(ByVal filename As String, ByVal filenameDest As String) As Integer

' HELP
Declare Function OpenHelp(szPathHelp As String ,szTopic As String , iParam As Integer = FB_IGNORE) As HWND
Declare Sub CloseHelp()

' tools and misc.
Declare Function ASCIITOUTF(ByVal text As String) As WString Ptr
Declare Function UTFTOASCII(ByVal text As WString Ptr) As String

Declare sub      FastCopy(Byval pTarget as any ptr, Byval pSource as any ptr, Byval nBytes as integer)
Declare Function FastCRC32(Byval lpBuffer As any Ptr, Byval BufferSize As Integer) As Uinteger


declare function AESEncoder(Text as string, Key as string) as String
declare function AESDecoder(Text as string, Key as string) as String

Declare Function Encode64(text As String ) As String
Declare Function Decode64(str_b64 as const String) As String

Declare Function MD5createFileHash(file As String) As String
Declare Function MD5createHash(text As String) As String

Declare Function SHA512create(text As String) As String
Declare Function SHA512createFile(file As String) As String

Declare Function SHA1createFile(file As String) As String
Declare Function SHA1create(file As String) As String

declare Function PeekS( ByVal Memory As Any Ptr, iLen As Integer = 0) As String
declare Function RunProgram(ByVal Filename As String, ByVal Parameter As String="", ByVal WorkingDirectory As String="", ByVal  Flags As String="open",ByVal ShowCmd As Integer=1)  As Integer
Declare Function ReplaceString(ByVal String_ As string,byval SearchString As String,byval ReplaceString_ As String,ByVal Position As Integer=1,ByVal searchParam As Integer=0, ByVal RegisterParam As Integer=0) As String
Declare Function InsertString(ByRef DestS As String,ByVal InsertS As String,ByVal Position As Integer) As Integer
Declare Function LtrimA(ByVal dest As String, ByVal trimString As String=" ") As String
Declare Function RtrimA(ByVal dest As String, ByVal trimString As String=" ") As String
Declare Function TrimA(ByVal dest As String, ByVal trimString As String=" ") As String
Declare Function ClearString(ByVal dest As String, ByVal trimString As String=" ") As String 
Declare Function SetWindowCallback(ByVal Address_Function As Integer,ByVal flag As Integer=0) As Integer
Declare Function FreeCallback(byval flag as integer) As Integer

' Internet

Type FTPINFO
	As WIN32_FIND_DATA FileInformation
	Declare Function FtpExamineDirectory(ByVal hConnect As HINTERNET, ByVal DirectoryName As String,ByVal Pattern As String, dwFlags As Integer = 0) As HINTERNET
	Declare Function FtpNextDirectoryEntry(ByVal hFind As HINTERNET) As Integer
	Declare Function FtpFinishDirectory(ByVal hFind As HINTERNET) As Integer
	Declare Function FtpDirectoryEntryAttributes() As Integer
	Declare Function FtpDirectoryEntrySize() As ULongInt
	Declare Function FtpDirectoryEntryDate() As String
	Declare Function FtpDirectoryEntryName() As String
End Type

Declare Function UrlDecoder(sUrl As String) As String
Declare Function UrlEncoder(sUrl As String) As String
Declare Function InetOpen(szUserAgent As String = "FB", iType As Integer = INTERNET_OPEN_TYPE_DIRECT , szProxyName As String = "" ,szProxyBypass As String="", iFlags As Integer = 0) As HINTERNET
Declare Function OpenUrl(hInet As HINTERNET, szURL As String ,szHeaders As String = "",iSizeHeaders As Integer = 0, iFlags As Integer = INTERNET_FLAG_RELOAD) As HINTERNET
Declare Function InetReadFile(hUrl As HINTERNET, psData As Any Ptr, iLenData As Integer) As Integer
Declare Sub InetFreeHandle(handle As HINTERNET)
Declare Function GetHTTPHeader(hUrl As HINTERNET) As String
Declare Function ReceiveHTTPFile(sUrl As String, sFile As String) As Integer
Declare Function GetContentSize(hUrl As HINTERNET) As ULongInt
Declare Function FtpFinishDirectory(ByVal hFind As HINTERNET) As Integer
Declare Function FtpConnect(hInet As HINTERNET, ServerName As String , UserName As String , UserPassword As String , ServerPort As Integer = 21, Flags As Integer = 0) As HINTERNET
Declare Function FtpFileGet(hConnect As HINTERNET, RemoteFile As String , LocalFile As String , fFailExists As Integer = 0, dwFlagAttributes As Integer = 0, dwFlags As Integer = FTP_TRANSFER_TYPE_BINARY ) As Integer
Declare Function FtpFilePut(hInet As HINTERNET, LocalFile As String , RemoteFile As String , dwFlags As Integer = FTP_TRANSFER_TYPE_BINARY) As Integer
Declare Function FtpSetDirectory(hConnect As HINTERNET, Directory As String) As Integer
Declare Function FtpGetDirectory(hConnect As HINTERNET) As String
Declare Function FtpFileOpen(hConnect As HINTERNET, File As String , dwFlags As Integer = FTP_TRANSFER_TYPE_BINARY, dwAccess As Integer = GENERIC_WRITE) As HINTERNET
Declare Function FtpFileClose(hFile As HINTERNET) As Integer
Declare Function FtpWriteFile(hFile As HINTERNET, Buffer As Any ptr , nBuffer As Integer ) As Integer
Declare Function FtpGetSizeFile(hFile As HINTERNET) As ULongint

#EndIf ' __WINDOW9_BI__


