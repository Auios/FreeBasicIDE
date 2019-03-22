'=================================================================
'===== DEBUGGER FOR FREEBASIC === (C) 2006-2013 Laurent GRAS =====
'=================================================================
#Define fbdebuggerversion "V 2.64 "
'#Define fulldbg_prt 'uncomment to get more informations
#Define dbg_prt2 dbg_prt 'used temporary for debugging fbdebugger 
#Include once "windows.bi"
#include once "win\commctrl.bi"
#include once "win\commdlg.bi"
#include once "win\wingdi.bi"
#include once "win\richedit.bi"
#include once "win\tlhelp32.bi"
#include once "win\shellapi.bi"
#include once "win\psapi.bi" 
#include once "file.bi"

#Define MAXSRCSIZE 500000
' if they are not already defined
#Ifndef EXCEPTION_DEBUG_EVENT
	#Define EXCEPTION_DEBUG_EVENT  1
	#define CREATE_THREAD_DEBUG_EVENT  2
	#define CREATE_PROCESS_DEBUG_EVENT  3
	#define EXIT_THREAD_DEBUG_EVENT  4
	#define EXIT_PROCESS_DEBUG_EVENT  5
	#define LOAD_DLL_DEBUG_EVENT  6
	#define UNLOAD_DLL_DEBUG_EVENT  7
	#define OUTPUT_DEBUG_STRING_EVENT  8
	#define RIP_EVENT  9
	''' DUPLICATE #define DBG_CONTINUE  &h00010002
	#define DBG_TERMINATE_THREAD           &h40010003
	#define DBG_TERMINATE_PROCESS          &h40010004
	#define DBG_CONTROL_C                  &h40010005
	#define DBG_CONTROL_BREAK              &h40010008
#EndIf
' DBG_EXCEPTION_NOT_HANDLED = &H80010001
#Define EXCEPTION_GUARD_PAGE_VIOLATION      &H80000001
#Define EXCEPTION_NO_MEMORY                 &HC0000017
#Define EXCEPTION_FLOAT_DENORMAL_OPERAND    &HC000008D
#Define EXCEPTION_FLOAT_DIVIDE_BY_ZERO      &HC000008E
#Define EXCEPTION_FLOAT_INEXACT_RESULT      &HC000008F
#Define EXCEPTION_FLOAT_INVALID_OPERATION   &HC0000090
#Define EXCEPTION_FLOAT_OVERFLOW            &HC0000091
#Define EXCEPTION_FLOAT_STACK_CHECK         &HC0000092
#Define EXCEPTION_FLOAT_UNDERFLOW           &HC0000093
#Define EXCEPTION_INTEGER_DIVIDE_BY_ZERO    &HC0000094
#Define EXCEPTION_INTEGER_OVERFLOW          &HC0000095
#Define EXCEPTION_PRIVILEGED_INSTRUCTION    &HC0000096
#Define EXCEPTION_CONTROL_C_EXIT            &HC000013A
 'take l char form a string and complete with spaces if needed
#Define fmt(t,l) Left(t,l)+Space(l-Len(t))+"  "
#Define fmt2(t,l) Left(t,l)+Space(l-Len(t))
#Define UM_CHECKSTATECHANGE (WM_USER + 100) 'for checkboxes
#define UM_FOCUSSRC         (WM_USER + 101) 'for focus source
#define RGBA_R( c ) ( c  Shr 16 And 255 )
#define RGBA_G( c ) ( c  Shr  8 And 255 )
#define RGBA_B( c ) ( c         And 255 )

'for use of htmlhelp 05/06/2013
#Ifndef HH_DISPLAY_TOPIC 
	#Define HH_DISPLAY_TOPIC 0000
	#Define HH_HELP_CONTEXT  0015
#EndIf

'buttons main screen
Const IDBUTSTEP  = 101
const IDBUTSTEPP = 102
const IDBUTSTEPM = 103
const IDBUTAUTO  = 104
const IDBUTRUN   = 105
const IDBUTSTOP  = 106
const IDBUTMINI  = 107
const IDBUTFREE  = 108
const IDBUTTOOL  = 109
const IDBUTFILE  = 110
const IDBUTRRUNE = 111
const IDBUTATTCH = 112
const IDBUTKILL  = 113
const IDNOTES    = 114
Const IDLSTEXE   = 115
const IDFASTRUN  = 116
const IDEXEMOD   = 117
const IDBUTSTEPB = 118
const IDBUTSTEPT = 119

const IDWATCH1 = 120
const IDWATCH2 = 121
const IDWATCH3 = 122
const IDWATCH4 = 123
const IDBRKVAR = 124
const IDCURLIG = 125
const IDBMKCMB = 126
Const IDDUMP   = 127

const ENLRSRC   =130
const ENLRVAR   =131
const ENLRMEM   =132
const IDVCLPSE  =133
const IDVEXPND  =134
const IDFNDTXUP =135
const IDFNDTXDW =136
const IDFNDTXCS =137
Const IDRICHWIN =200
Const IDNOTEWIN =201
Const IDSTATUS  =202
' ID for TAB
Const TAB1=210
Const TAB2=211
const TVIEW1=220
const TVIEW2=221
const TVIEW3=222
const TVIEW4=223
' ID for dump

' ID for menu source
const IDSETBRK =500
const IDSETBRT =501
const IDMNGBRK =502
const IDCONTHR =503 'used also with button
const IDFNDTXT =504
const IDTGLBMK =505
const IDNXTBMK =506
const IDPRVBMK =507
const IDADDNOT =508
Const IDGOTO   =509
Const IDSHWVAR =510
Const IDSETWVAR=511
const IDACCLINE=512
Const IDFCSSRC =513 
Const IDLINEADR=514
Const IDBRKENB =515 '01/03/2013
Const IDTHRDAUT=516 'automatic execution alternating threads 16/03/2013
'ID for menu var
Const IDVARDMP =520
const IDVAREDT =521
const IDVARBRK =522
Const IDSELIDX =523
Const IDSHSTRG =524
Const IDSHWEXP =525
const IDSETWTCH=526
const IDSETWTTR=527
Const IDCHGZSTR=528
Const IDCALLINE=529
Const IDLSTVARA=530 'list all proc/variables
Const IDLSTVARS=531 'list only selected and below
'ID for proc
Const IDRSTPRC =533 'reset proc follow
Const IDSETPRC =534 'set proc follow
Const IDSORTPRC=535 'toogle sort by module name / proc name 17/05/2013
'ID for thread
Const IDTHRDCHG=537 'select thread
Const IDLOCPRC =538 'locate proc (also used in menu var and proc)
Const IDTHRDKLL=539 'kill thread
Const IDEXCLINE=540 'show next executed line
Const IDCREATHR=541 'show line creating thread
Const IDTHRDLST=542 'list threads
Const IDSHWPROC=543 'show proc in proc/var
Const IDSHPRSRC=544 'show proc in source
Const IDTHRDEXP=545 'expand one thread '14/12/2012
Const IDTHRDCOL=546 'collapse all threads
Const IDPRCRADR=547 'addr about running proc start,end stack
'ID for tools
const IDCMDLPRM=550
const IDDBGHELP=551
const IDINFOS  =552
const IDABOUT  =553
const IDFILEIDE=554
const IDQCKEDT =555
Const IDCMPNRUN=556
const IDWINMSG =557
const IDSHWBDH =558
Const IDCLIPBRD=559
Const IDDELLOG =560
Const IDSHWLOG =561
Const IDSHENUM =562
Const IDCMPINF =563
Const IDJITDBG =564
Const IDTUTO   =565
Const IDLSTDLL =566
Const IDHIDLOG =567 '09/06/2013
Const IDLSTSHC =568
Const IDFRTIMER=569
'ID for watched var
Const IDWCHVAR =570
Const IDWCHDMP =571
Const IDWCHDEL =572
const IDSTWTCH1=573
const IDSTWTCH2=574
const IDSTWTCH3=575
const IDSTWTCH4=576
const IDWCHSTG =577
const IDWCHSHW =578
Const IDWCHEDT =579
Const IDWCHTTGL=580
Const IDWCHTTGA=581
Const IDWCHDALL=582

' for proc_find / thread
Const KFIRST=1
Const KLAST=2
' when select a var for proc/var or set watched
Const PROCVAR=1
Const WATCHED=2
union pointeurs
pxxx as any ptr
pinteger as integer ptr
puinteger as uinteger ptr
psingle as single ptr
pdouble as double ptr
plinteger as longint ptr
pulinteger as ulongint ptr
pbyte as byte ptr
pubyte as ubyte ptr
pshort as short ptr
pushort as ushort ptr
pstring as string ptr
pzstring as zstring ptr
pwstring as wstring ptr
end union
union valeurs
vinteger as integer
vuinteger as uinteger
vsingle as single
vdouble as double
vlinteger as longint
vulinteger as ulongint
vbyte as byte
vubyte as ubyte
vshort as short
vushort as ushort
'vstring as string
'vzstring as zstring
'vwstring as wstring
end Union
' DATA STAB
type udtstab
	stabs as Integer
	code as ushort
	nline as ushort
	ad as uinteger
end type
Enum 'type udt/redim/dim
	TYUDT
	TYRDM
	TYDIM
End enum
enum 'type of running
	RTRUN
	RTSTEP
	RTAUTO
	RTOFF
	RTFRUN
	RTFREE
	RTEND
End Enum
Enum
NODLL
DLL
End Enum


' TO CREATE CLASSNAME / tooltips -------------
dim shared fb_szAppName as string
fb_szAppName="DEBUGGER"
dim shared fb_hinstance as HINSTANCE
dim shared fb_hToolTip as HWND
dim shared crc_table(255)  as Integer 'for checksum
Dim Shared flaglog As Byte=0    ' flag for dbg_prt 0 --> no output / 1--> only screen / 2-->only file / 3 --> both
Dim Shared flagtrace As Byte    ' flag for trace mode : 1 proc / +2 line
Dim Shared flagverbose As Byte  ' flag for verbose mode
Dim Shared flagmain As Byte     ' flag for first main
Dim Shared flagattach as byte   ' flag for attach
dim shared flagtooltip As integer =TRUE 'TRUE=activated/FALSE=DESACTIVATED
Dim Shared flagrestart as Integer=-1  'flag to indicate restart in fact number of bas files to avoid to reload those files
Dim Shared flagwtch As Integer =0 'flag =0 clean watched / 1 no cleaning in case of restart 
Dim Shared flagfollow As Integer =FALSE 'flag to follow next executed line on focus window
Dim Shared flagkill   As Integer =FALSE 'flag if killing process to avoid freeze in thread_del
Dim Shared flagtuto  As Integer 'flag for tutorial -1=no tuto / 2=let execution then return at value 1 / 1=tutorial so no possible command '03/01/2013
Dim Shared compinfo As string   'informations about compile
Dim Shared hattach as HANDLE    'handle to signal attchement done
Dim Shared jitprev As String
Dim Shared fasttimer As double
'GCC
Dim Shared as byte    gengcc       ' flag for compiled with gcc
Dim Shared As Integer defaulttype  ' flag to skip default type (see cutup_1)
ReDim shared as string trans()
Dim   shared as string stringarray
'END GCC
Dim shared as integer autostep=200 'delay for auto step
Enum 'code stop
	CSSTEP=0
	CSCURSOR
	CSBRKTEMPO
	CSBRK
	CSBRKV
	CSBRKM
	CSHALTBU
   CSACCVIOL
   CSNEWTHRD
end Enum
Dim shared stopcode as Integer
Dim Shared stoplibel(20) as string*17 =>{"","cursor","tempo break","break","Break var","Break mem"_ '05/03/2013
,"Halt by user","Access violation","New thread"}
Dim Shared stringadr As Integer
' -------------------------------------------------
dim shared pinfo As PROCESS_INFORMATION
dim shared windmain as HWND
dim shared tviewcur as HWND  'TV1 ou TV2 ou TV3
dim shared tviewvar as HWND 'running proc/var
dim shared tviewprc as HWND 'all proc
dim shared tviewthd as HWND 'all threads
dim shared tviewwch as HWND 'watched variables

Dim shared dbgstatus As HWND
Dim Shared recsav As RECT 'save windmain sizes
'for dump
dim shared listview1 as HWND
dim shared lvnbcol as integer
dim shared lvtyp as integer =1

dim shared hcurline as HWND 'current line
dim shared butstep As HWND
dim shared butstepp As HWND
dim shared butstept As HWND
dim shared butstepb As HWND
dim shared butstepm As HWND
dim shared butcont As HWND
dim Shared Butexemod As HWND
dim shared butauto As HWND
dim shared butrun As HWND
dim shared butfastrun As HWND
dim shared butstop As HWND
dim shared butmini As HWND
dim shared butfree As HWND
dim shared Buttool As HWND
dim shared Butfile As HWND
dim shared Butrrune  As HWND
dim shared Butlstexe As HWND
dim shared Butattch  As HWND
dim shared Butkill   As HWND
dim shared butenlrsrc  As HWND
dim shared butenlrvar  As HWND
dim shared butnotes    As HWND
dim shared butenlrmem  As HWND
dim shared dbgEdit1    As HWND 'for notes
dim shared dbgrichedit as HWND 'for rich edit current
''''' dim shared timerid1 as integer 'not used if 2 threads
dim shared menuRoot   As HMENU
dim Shared menuedit   As HMENU 'popup menu with richedit
dim shared menuvar    As HMENU 'popup menu var/proc
dim shared menuvar2   As HMENU 'popup sub menu var/proc
dim shared menutools  As HMENU 'popup menu tools
dim shared menuproc   As HMENU 'popup menu proc
dim shared menuthread As HMENU 'popup menu thread
dim shared menuwatch  As HMENU 'popup menu watch
'dim shared as integer mnubm

'THREAD
type tthread
 hd  As HANDLE    'handle
 id  As UInteger  'ident
 pe  As integer   'flag if true indicates proc end 
 sv  As integer   'sav line
 od  As Integer   'previous line
 nk  As uInteger  'for naked proc, stack and used as flag
 st  as integer   'to keep starting line 09/12/2012
 tv  As HTREEITEM 'to keep handle of thread item '12/12/2012
 plt As HTREEITEM 'to keep handle of last proc of thread in proc/var tview '12/12/2012
 ptv As HTREEITEM 'to keep handle of last proc of thread in thread tview '12/12/2012
 exc As Integer   'to indicate execution in case of auto 1=yes, 0=no '17/03/2013
end type
const THREADMAX=50
dim shared thread(THREADMAX) as tthread
dim shared threadnb As Integer =-1
dim shared threadcur as Integer
Dim Shared threadprv As Integer     'previous thread used when mutexunlock released thread or after thread create 12/02/2013
Dim Shared threadsel As Integer     'thread selected by user, used to send a message if not equal current
Dim Shared threadaut As Integer     'number of threads for change when  auto executing
dim shared threadcontext as HANDLE
Dim Shared threadhs As HANDLE       'handle thread to resume
dim shared dbgprocid as Integer     'pinfo.dwProcessId : debugged process id
Dim Shared dbgthreadID As Integer   'pinfo.dwThreadId : debugged thread id
dim shared dbghand as HANDLE  		'debugged proc handle
dim shared dbghthread as HANDLE     'debuggee thread handle
dim shared dbghfile  As HANDLE   	'debugged file handle
Dim shared prun as Integer        	'indicateur process running
dim shared curlig as Integer  		'current line
Dim Shared curtab As UShort =0 		'associated wih curlig
Dim Shared shwtab As UShort =0 		'tab showed could be different of curtab
' compiler,commandline for compilation and for debug
dim shared as string fbcexe,cmdlfbc,ideexe
dim shared exename as ZString *300 'debuggee executable
Dim Shared exedate As Double 'serial date
dim shared savexe(9) as string 'last 10 exe, 0=more recent
dim shared cmdexe(9) as string 'last 10 exe

'SOURCES
Const MAXSRC=200 							   'max 200 sources
dim shared dbgsrc as string 			   'current source
dim shared dbgmaster as Integer 		   'index master source if include
dim shared dbgmain as Integer 		   'index main source proc entry point, to update dbgsrc see load_sources
Dim shared source(MAXSRC) as String    'source names
Dim Shared sourcenb as Integer  =-1    'number of src
dim shared richedit(MAXSRC) as HWND    'one for each tab
Dim Shared clrrichedit As Integer=&hFFFFFF    'background color
Dim Shared clrcurline As Integer=&hFF0000    'current line color, default blue
Dim Shared clrkeyword As Integer=&hFF8040       'keyword color (highlight), default 
Dim Shared clrtmpbrk As Integer=&h04A0FB    'current line color, default orange
Dim Shared clrperbrk As Integer=&hFF 'permanent breakpoint default red (used also when access violation)
Dim Shared As Byte runtype=RTOFF       'running type

dim shared dsptyp As Integer=0         'type of display
Dim Shared dspofs As Integer=4         'type offset current line source : 2->3/ 4->5
Dim Shared dspsize As Integer          'number of lines of the source window
Dim Shared dspwidth As Integer         'max width in characters 
        
dim shared breakcpu as integer =&hCC

'===== DLL '24/01/2013
Type tdll
	As HANDLE   hdl 'handle to close
	As UInteger bse 'base address
	As HTREEITEM tv 'item treewiew to delete
	As integer gblb 'index/number in global var table
	As Integer gbln 
	As Integer  lnb 'index/number in line '01/02/2013
	As Integer  lnn 
	As String   fnm 'full name
End Type
Const DLLMAX=300
Dim Shared As tdll dlldata(DLLMAX)
Dim Shared As Integer dllnb 'use index base 1


'===================== proc (sub or function) ============================
const PROCMAX=20000 'in sources
Enum
 KMODULE=0 'used with IDSORTPRC
 KPROCNM
End Enum

Type tproc
	nm As String   'name
	db as UInteger 'lower address
	fn as UInteger 'upper address
	sr as UShort   'source index
	nu As UShort   'line number to quick access
	''''ad As UInteger 'address
	vr As uinteger 'lower index variable upper (next proc) -1
	rv As Integer  'return value type
	pt As Integer  'counter pointer for return value (** -> 2)
   tv as HTREEITEM 'in tview2
   st as byte     'state followed = not checked
End Type
dim shared proc(PROCMAX) as tproc
Dim shared procnb as integer
Dim Shared as UInteger procsv,procad,procin,procsk,proccurad,procesp,procfn,procbot,proctop,procsort

Const PROCRMAX=50000 'Running proc
Type tprocr
	sk   As UInteger  'stack
	idx  As UInteger  'index for proc
	tv   As HTREEITEM 'index for treview
	'lst as uinteger 'future array in LIST
	cl   As Integer   'calling line
	thid As Integer   'idx thread
	vr   As Integer   'lower index running variable upper (next proc) -1
End Type
Dim Shared procr(PROCRMAX) As tprocr,procrnb as Integer 'list of running proc
'line ==============================================
Const LINEMAX=100000
Type tline
	ad as UInteger
	nu as Integer
	sv as Byte
	pr as UShort
	hp As Integer
	hn As integer
End Type
dim shared as Integer linenb,rlineold 'numbers of lines, index of previous executed line (rline) '14/12/2012
Dim Shared As Integer linenbprev 'used for dll 
dim shared rline(LINEMAX) As tline
'DIM ARRAY =========================================
Const ARRMAX=1500
Type tnlu
	'nb As UInteger
	lb As UInteger
	ub As UInteger
End Type
Type tarr 'five dimensions max
	dm As UInteger
	nlu(5) As tnlu
End Type
Dim Shared arr(ARRMAX) As tarr,arrnb As Integer
'var =============================
Const VARMAX=20000 'CAUTION 3000 elements taken for globals 
Const VGBLMAX=3000 'max globals
Type tvrb
	nm As String    'name
	typ As Integer  'type
	adr As Integer  'address or offset 
	mem As UByte    'scope 
	arr As tarr Ptr 'pointer to array def
	pt As UByte     'pointer
End Type
Dim Shared vrbloc      As Integer 'pointer of loc variables or components (init VGBLMAX+1)
Dim Shared vrbgbl      As Integer 'pointer of globals or components
Dim Shared vrbgblprev  As Integer '26/01/2013 for dll, previous value of vrbgbl, initial 1
Dim Shared vrbptr      As integer Ptr 'equal @vrbloc or @vrbgbl
Dim Shared vrb(VARMAX) As tvrb
Const VRRMAX=100000
Type tvrr
	ad As UInteger 'address
	tv As HTREEITEM 'tview handle
	vr As Integer  'variable if >0 or component if <0
	ini As UInteger 'dyn array address (structure) or array initial address
	ix(4) As Integer  '5 index max in case of array
End Type
Dim Shared vrr(VRRMAX) As tvrr
Dim Shared vrrnb As UInteger
'UDT ==============================
Type tudt
	nm As String  'name of udt
	lb As Integer 'lower limit for components
	ub As Integer 'upper
	lg As Integer 'lenght 
	En As Integer 'flag if enum 1 or 0
End Type
Type tcudt
	nm As String    'name of components or text for enum
	Union
	Typ As Integer  'type
	Val As Integer  'value for enum
	End Union
	ofs As UInteger 'offset
	ofb As UInteger 'rest offset bits 
   lg As UInteger  'lenght
	arr As tarr ptr 'arr ptr
	pt As UByte
End Type
Const TYPEMAX=80000,CTYPEMAX=100000
'CAUTION : TYPEMAX is the type for bitfield so the real limit is typemax-1
Dim Shared udt(TYPEMAX) As tudt,udtidx As Integer
Dim Shared cudt(CTYPEMAX) As tcudt,cudtnb As Integer,cudtnbsav as Integer
'in case of module or DLL the udt number is initialized each time
Dim Shared As Integer udtcpt,udtcptmax 'current, max cpt
udt(0).nm="Unknown"
udt(1).nm="Integer":udt(1).lg=Len(Integer)
udt(2).nm="Byte":udt(2).lg=Len(Byte)
udt(3).nm="Ubyte":udt(3).lg=Len(UByte)
udt(4).nm="Zstring":udt(4).lg=4
udt(5).nm="Short":udt(5).lg=Len(Short)
udt(6).nm="Ushort":udt(6).lg=Len(UShort)
udt(7).nm="Void":udt(7).lg=4
udt(8).nm="Uinteger":udt(8).lg=Len(UInteger)
udt(9).nm="Longint":udt(9).lg=Len(LongInt)
udt(10).nm="Ulongint":udt(10).lg=Len(ULongInt)
udt(11).nm="Single":udt(11).lg=Len(Single)
udt(12).nm="Double":udt(12).lg=Len(Double)
udt(13).nm="String":udt(13).lg=Len(String)
udt(14).nm="Fstring":udt(14).lg=4
udt(15).nm="Pchar":udt(15).lg=4
 'BREAK ON LINE
const BRKMAX=10 'breakpoint index zero for "run to cursor"
Type breakol
	isrc  As UShort    'source index 
	nline As UInteger  'num line for display
	index As Integer   'index for rline
	ad    As UInteger  'address
	typ   As Byte	    'type normal=1 /temporary=0, 3 or 4 =disabled
End Type
dim shared brkol(BRKMAX) as breakol,brknb as Byte
dim shared as string brkexe(9,BRKMAX) 'to save breakpoints by session
'break on var
Type tbrkv
	
	typ as Integer   'type of variable
	adr as Uinteger  'address
	arr as uinteger  'adr if dyn array
	ivr as integer   'variable index
	psk as integer   'stack proc
	Val as valeurs   'value
	vst as string    'value as string
	tst as byte=1    'type of comparison (1 to 6)
	ttb as byte      'type of comparison (16 to 0)
	txt As String	  'name and value just for brkv_box
End Type
Dim Shared brkv As tbrkv 
Dim Shared brkv2 As tbrkv 'copie for use inside brkv_box
Dim Shared brkvhnd as HWND   'handle
'BOOKMARK
Type tbmk
	nline As Integer 'bookmark line
	ntab  As Integer 'bookmark tab number, =-1 --> empty
End Type
const BMKMAX=10
dim shared As tbmk    bmk(BMKMAX) 
dim shared As HWND    bmkh   'handle combo
dim shared as Integer bmkcpt 'bmk counter
'WATCH
const WTCHMAIN=3
Const WTCHMAX=9
Const WTCHALL=9999999
Type twtch
    hnd as HWND     'handle
    tvl  As HTREEITEM 'tview handle
    adr as uinteger 'memory address
    typ as integer  'type for var_sh2
    pnt As Integer  'nb pointer
    ivr As Integer  'index vrr
    psk as uinteger 'stk procr or -1 (empty)/-2 (memory)/-3 (non-existent local var)/-4 (session)
    lbl as string   'name & type,etc
    arr as UInteger 'ini for dyn arr
    tad as Integer  'additionnal type
    old As String   'keep previous value for tracing
    idx As Integer  'index proc only for local var
    dlt As Integer  'delta on stack only for local var
    vnb as integer  'number of level
    vnm(10) as string   'name of var or component
    vty(10) As String   'type
    Var     as Integer  'array=1 / no array=0
end Type
dim shared wtch(WTCHMAX) as twtch
Dim Shared wtchcpt As Integer 'counter of watched value, used for the menu 
Dim Shared hwtchbx As HWND    'handle
Dim Shared wtchidx As Integer 'index for delete 
dim shared wtchexe(9,WTCHMAX) as String 'watched var (no memory for next execution)
Dim Shared wtchnew As Integer 'to keep index after creating new watched
'For findtext
dim shared chkcase  as integer  'flag match case
dim shared sfind    as string   'string to find
dim shared stext    as string   'string under cursor or slected by user
dim shared hfindbx  as HWND     'hwnd find zone
'for save box
dim shared savebx   as HWND     'just little yes/cancel box
'for help box
dim shared helpbx   as HWND   
dim shared helptyp  as byte     '1=help,2=infos
' or dump
dim shared hdumpbx as HWND       'hwnd dump zone
dim shared dumplig as integer =1 'nb lines(1 or xx)
dim shared dumpadr as uinteger   'address for dump
dim shared dumpdec as integer =0 'value dump dec=0 or hexa=50
' input_box
dim shared inputval as zstring *25
dim shared inputtyp as byte
'focus box
dim shared focusbx   as HWND  
'tutorial box
dim shared tutobx   as HWND 
'bitmap buttons
dim shared bmb(23) AS HBITMAP 
'TAB
Dim Shared  As HWND htab1,htab2
'index box
Dim Shared hindexbx As HWND
' For size font
Const KSIZE8=8
Const KSIZE10=10
Const KSIZE12=12
'font handle
Dim Shared As HFONT   fonthdl
Dim Shared As HFONT   fontbold
Dim Shared As Integer fontsize=KSIZE8
Dim Shared As String  fontname
fontname="Courier new"
'show/expand
const SHWEXPMAX=10 'max shwexp boxes
Const VRPMAX=5000  'max elements in each treeview
Type tshwexp
	dim bx As HWND     'handle pointed value box
	Dim tv As HWND     'corresponding tree view
	Dim nb As Integer  'number of elements tvrp
	Dim dl As Integer  'delta x size of type
	Dim lb As HWND     'hanlde of the delta label
End Type
Type tvrp
	nm As String    'name
	ty As Integer   'type
	pt As Integer   'is pointer
	ad As UInteger  'address
	tl As HTREEITEM 'line in treeview
	'iv As Integer   'index of variables 
End Type
dim shared as integer shwexpnb 'current number of show/expand box
dim shared As tshwexp shwexp(1 to SHWEXPMAX) 'data for show/expand

Dim Shared As tvrp vrp(SHWEXPMAX,VRPMAX)
'VAR FIND
Type tvarfind
	ty As Integer
	pt As Integer
	nm As String    'var name or description when not a variable
	pr As Integer   'index of running var parent (if no parent same as ivr)
	ad As UInteger
	iv As Integer   'index of running var
	tv As HWND      'handle treeview
   tl As HTREEITEM 'handle ligne
End Type
Dim Shared As tvarfind varfind

'HIGH LIGHTING keywords
type tmodif
    lg as integer
    ps as integer
end type
dim shared as integer hgltmax
dim shared as integer hgltpt=0
redim shared hgltdata() as tmodif
dim Shared As Integer hgltflag=FALSE
'shortcuts
Const SHCUTMAX=100
Const VSHIFT=&hF00000
Const VALT  =&hF0000
Const VCTRL =&hF000
Type tshcut
	As Integer sccur
	As HMENU   scmenu
	As Integer scidnt
End Type
Dim Shared As tshcut shcut(SHCUTMAX)
dim Shared As Integer shcutnb 


'================ DECLARATIONS ========================================================
declare function fb_toolbar (hwnd as HWND,id as Integer,NumBtns as integer,Text as string,Bstyles as integer ptr =0, _
img as Any Ptr =0,imgidx as integer ptr =0,bx as integer =0,by as integer =0,Style as integer =0, _
ExStyle as integer =0) as HWND
declare function fb_Edit(text As string,form1 as HWND,id as Integer,x as integer, _
y as integer,w as integer,h as integer,byval s as integer = 0,byval ex as integer = -1) _
as HWND
declare function fb_Editw(text As wstring,form1 as HWND,id as Integer,x as integer, _
y as integer,w as integer,h as integer,byval s as integer = 0,byval ex as integer = -1) _
as HWND
declare function fb_label(Text as string,hWnd as HWND,id as integer=0,X As Integer=0,Y As Integer=0, _
W As Integer=0,H As Integer=0,byval Style As Integer=0,byval Exstyle As Integer=-1) As HWND
declare function fb_Form(t as string,x as integer =0,y as integer =0,w as integer =250,h as integer =150,s as integer =0,ex as integer =0) as HWND
declare sub fb_show(hwnd as HWND)
declare function fb_RichEdit (t as string,h as HWND,i as integer,x as integer,y as Integer,w as integer,h as integer,s as integer=0,x as integer=-1) as HWND
declare function fb_Status (text as string,hand as HWND,id as integer) as HWND
declare function WinMain     ( byval hInstance as HINSTANCE, _
                                      byval hPrevInstance as integer, _
                                      szCmdLine as string, _
                                      byval iCmdShow as integer ) as integer
declare  function fb_button(a as string,byval hwnd as HWND,byval i as Integer=0, byval x as integer =0 _
,byval y as integer =0,byval w as integer =0, byval h as integer =0,s as integer =0,es as integer =-1) as HWND
declare function fb_CreateTooltips(hControl AS HWND, Text As string,Title as string, ToolIcon As integer) AS HWND
declare function fb_ModStyle(hWnd as HWND, dwAdd as integer=0, dwRemove as integer=0, bEx as integer =0) as integer
Declare function fb_UpDown (hWnd as HWND,X as integer,Y as integer,W as integer,H as integer,Lo as integer,Hi as integer,uStart as Integer=0) as HWND
declare function fb_message (title as string ,text as string,style as integer=0) as integer
declare function fb_Treeview(hwnd as HWND,id as integer,x as integer,y as integer,w as integer,h as integer,s as Integer =0,ex as Integer =-1) As HWND
declare function fb_Group(t as string,H as HWND,i as integer,x as integer,y as integer,w as integer,h as integer,s as integer =0,e as integer =0) as HWND
declare function fb_Checkbox(t as string,H as HWND,i as integer=0,x as integer=0,y as integer=0,w as integer=0,h as integer=0,s as integer =0,e as integer =0) as HWND
declare function fb_radio(t as string,H as HWND,i as integer=0,x as integer=0,y as integer=0,w as integer=0,h as integer=0,s as integer =0,e as integer =0) as HWND
declare function fb_combobox(H as HWND,i as integer,x as integer,y as integer,w as integer,h as integer,s as integer =0,e as integer =-1) as HWND
declare function fb_listbox(H as HWND,i as integer,x as integer,y as integer,w as integer,h as integer,s as integer =0,e as integer =-1) as HWND
declare function fb_datepick(H as HWND,i as integer,x as integer,y as integer,w as integer,h as integer,s as integer =0,e as integer =-1) as HWND
declare function fb_listview(H as HWND,i as integer,x as integer,y as integer,w as integer,h as integer,s as integer =0,e as integer =-1) as HWND
declare function fb_MDialog (DPro as Any Ptr,title as string,hWnd as HWND,X As Integer,Y As Integer,W As Integer,H As Integer,Style As Integer=0,Exstyle As Integer=0) as Integer
declare function fb_Dialog (DPro as Any Ptr,title as string,hWnd as HWND,X As Integer,Y As Integer,W As Integer,H As Integer,Style As Integer=0,Exstyle As Integer=0) as HWND
Declare Function fb_Tab (As HWND,as integer,as Integer,as integer,as integer,as integer,as Integer=0,as Integer=0) as HWND
declare Sub tab_add(As Integer,As hwnd,As String)
declare Sub exrichedit(As Integer)
declare function wait_debug() as integer
declare sub load_sources(As integer)
declare Sub save_source()
declare Sub log_show()
declare Sub log_hide()
declare function Tree_AddItem(hParent AS HTREEITEM,Text as string,hInsAfter AS HTREEITEM,hTV AS HWND) AS HTREEITEM
declare sub dbg_return(a As Integer,l As Integer)
declare sub menu_set()
declare sub ide_launch()
declare sub sel_line(l as integer,c as Integer=0,d as Integer=0,As HWND=dbgrichedit,As Integer=TRUE)
declare sub brk_set(t as integer)
declare sub brk_color(as Integer)
declare sub brk_apply()
Declare Sub exe_mod()
declare sub dump_set(h as HWND)
declare sub bmk_tgl()
Declare Sub bmk_goto(As Integer)
declare sub notes_add()
declare sub start_pgm(p As Any Ptr)
declare sub dsp_hide(t as integer)
declare sub but_enable()
declare sub menu_enable()
declare function brk_manage (byval hWnd As HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) as integer
declare sub watch_set()
declare sub watch_sh(aff as integer=WTCHALL)
Declare Sub watch_sel(As Integer)
Declare Sub watch_del(As Integer=WTCHALL)
Declare Sub watch_exch(As Integer)
Declare function watch_find()As Integer
Declare Sub watch_array()
Declare Function watch_box(ByVal hWnd as HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
Declare Sub watch_add(As Integer,As Integer =-1)
Declare Sub watch_trace(As Integer=WTCHALL)
Declare Sub watch_addtr
Declare sub brkv_set(a As Integer)
Declare sub proc_expcol(t As Integer)
declare sub var_dump(As HWND)
declare sub setvpdmp()
declare sub dump_sh()
declare function wtext() As String
declare sub frground()
declare function fb_GetFileName(Title as string, Filt As string,Flag As Integer,hWnd As HWND,Flags As Integer,InitialDr as string) as string
declare function find_box(byval hWnd As HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
declare function input_box(byval hWnd As HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
declare function save_box(byval hWnd As HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
declare function dump_box(byval hWnd As HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
declare function settings_box(byval hWnd As HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
declare function brkv_box(byval hWnd As HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
declare function help_box(byval hWnd As HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
declare function edit_box(byval hWnd As HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
Declare function index_box(byval hWnd as HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
Declare function attach_box(byval hWnd as HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
Declare function shwexp_box(byval hWnd As HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
declare Function jit_box(byval hWnd As HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) as Integer
Declare Function focus_box(byval hWnd as HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
Declare Function tuto_box(byval hWnd As HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) as Integer
declare Sub shwexp_det(As Integer,As uInteger,As Integer,As HTREEITEM,As integer)
Declare function shwexp_ini(As Integer,As string,As UInteger,As Integer,As Integer) As Integer
Declare Sub shwexp_new(as HWND)
Declare Sub shwexp_del()
Declare Sub shwexp_arrange()
Declare Sub var_tip(As Integer)
declare function prep_var(t As string) as string
declare function prep_debug(As string) As string
declare sub treat_file(f As string)
declare sub ini_read()
declare sub crc_init()
declare Function crc_string(txt as string) As integer
declare Function crc_file(fname as string) as string
declare sub winmsg()
declare sub dechexbin()
Declare sub line_goto()
declare sub dump_update(As NMLISTVIEW ptr)
declare sub showcontext()
Declare Sub cutup_udt(As String)
Declare Sub cutup_enum(As String)
Declare Sub cutup_1(As String,As UInteger,As Integer=0) '06/02/2013
Declare Sub cutup_2(As String,As byte)
Declare function cutup_proc(As String) As String
declare function cutup_op (as string) as String
Declare function cutup_array(As String,As Integer,As Byte) As Integer
Declare Function cutup_scp(As Byte,As UInteger,deltadll As Integer=0) As Integer '06/02/2013
Declare Sub cutup_retval(As Integer,As String)
Declare Function common_exist(As uinteger) As Integer
Declare Sub dbg_prt (As String)
declare sub seteip(as uinteger)
Declare Sub var_iniudt(As UInteger,As UInteger,As HTREEITEM,As UInteger)
Declare Function var_sh2(As Integer,As UInteger, As UByte=0,As String="") As String
Declare Function var_add(As String,As Integer,As integer)As String
Declare Sub gest_brk(As UInteger)
Declare Sub stab_extract(As UInteger,As Byte)
Declare Function name_extract(As String) As String
Declare Sub brk_del(As Integer)
Declare sub proc_new()
Declare Sub proc_watch(as integer)
Declare sub proc_end()
Declare Sub globals_load(As Integer=0)
Declare Sub ini_write()
Declare sub proc_sh()
declare sub proc_activ(as HTREEITEM)
declare sub proc_flw(as byte)
Declare Sub thread_check(as HTREEITEM)
Declare Function proc_find(As integer,As Byte) As Integer
Declare Function proc_verif(As UShort) As Byte
Declare Sub var_ini(As UInteger, As Integer , As Integer)
Declare Sub var_sh()
Declare Sub fastrun()
Declare Sub proc_del(As Integer,As Integer=1) '29/01/2013
Declare sub proc_newfast()
Declare Function proc_retval(As Integer) As String
Declare Function fb_Set_Font (Font As string,Size As integer,Bold As Integer=0,Italic As Integer=0,Underline As Integer=0,StrikeThru As Integer=0) As HFONT
Declare Function proc_name(ad As uinteger) As String
Declare Sub proc_loc()
Declare sub proc_update()
Declare function fb_LoadBMP (F As string,i As Integer=0) As HBITMAP
Declare Sub dsp_size()
Declare Function excep_lib(As Integer) As string
Declare Sub dbg_attach(p As Any Ptr)
Declare Sub string_sh(As HWND)
Declare Sub thread_change(As Integer=-1)
Declare function enum_find(As integer,As Integer) as String
Declare function var_find2(as HWND) as Integer
declare sub enum_check(as integer)
declare sub enum_show(as HWND)
Declare Sub font_change(As String="",As Integer=0)
Declare Sub drag_exe(As handle)
Declare Function kill_process(as string) as Integer
Declare Sub dsp_sizecalc()
Declare Sub compinfo_sh()
Declare Function messageboxw Lib "libuser32" alias "MessageBoxW" (byval as HWND, byval as LPCWSTR, byval as LPCWSTR, byval as UINT) as Integer
Declare Function setwindowtextw Lib "libuser32" alias "SetWindowTextW" (byval as HWND, byval as LPCWSTR) as BOOL
Declare Function CreateWindowExW Lib "libuser32" alias "CreateWindowExW" (byval as DWORD, _
 byval as LPCWSTR, byval as LPCWSTR, byval as DWORD, byval as integer, byval as integer, _
 byval as integer, byval as integer,  byval as HWND, byval as HMENU, byval as HINSTANCE, byval as LPVOID) as HWND
declare sub exe_sav(exename as string,cmdline as string) 
declare sub dsp_access(shwtab as integer) 
Declare Sub dsp_noaccess()
Declare Sub help_manage(As Integer=0) '05/06/2013 replace help_start
Declare Function var_search(pproc as integer,text() as string,vnb as integer,varr as Integer,As Integer=0) as Integer
Declare Function var_sh1(as integer) as String
Declare Sub watch_sav()
Declare Sub brk_sav() '27/02/2013
Declare Function fb_FontDlg (As HWND) As Integer
Declare Function color_change(As Integer) As Integer 
Declare Sub hglt_lines(as integer,as integer)
declare sub hglt_data(nline as integer,src as integer, datas() as tmodif, cptk as integer)
Declare sub translate_gcc(as string)
Declare Sub zstringbyte_exchange()
Declare Sub proc_loccall()
Declare Sub thread_kill()
Declare Sub thread_execline(As Integer)
Declare Sub line_adr
declare sub thread_expcol(As Integer)
declare sub thread_text(As Integer=-1)
Declare Sub thread_procloc(As Integer)
Declare Sub procvar_list(As Integer=0)
Declare Sub surround(hdl As HWND,x As Integer=-1,y As Integer=0,w As Integer=0,h As Integer=0)  '02/01/2013
Declare Sub decode_help(dData As  HELPINFO Pointer)
Declare Sub str_replace(strg as string,srch as string, repl as string)
Declare Function dll_name(FileHandle As HANDLE,t As Integer =1 )As String
Declare Sub shcut_display(As Integer,As HWND,As HWND,As HWND,As HWND)
Declare function shcut_txt(As Integer,As Integer) As String
Declare function shcut_check(As Integer,As integer)As Integer
Declare Function menu_gettxt(As HMENU,As integer) As String
Declare Sub menu_update(As Integer,As String="")
'========================================
'To avoid multiple launching
if CreateSemaphore(0, 0, 1,"FBdebugger" )<>0 and GetLastError() = ERROR_ALREADY_EXISTS then
   If fb_message("Starting FBdebugger","An other occurence is already running."+chr(13)+"Continue ?", _
   MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_DEFBUTTON1) = IDNO then End 1
End If

end WinMain( Cast(HINSTANCE,GetModuleHandle( 0 )), null, Command, SW_NORMAL )

'=================================================
SUB fb_win()
	Dim  As Integer l,pstatus(3)={120,220,520,-1}
	Dim As UInteger tabstop=8
	windmain = fb_FORM ( "DEBUG", 0, 0,800, 590)',WS_MINIMIZEBOX or WS_CAPTION Or WS_SYSMENU)
	DragAcceptFiles(windmain, TRUE)
	butstep = fb_BUTTON("",windmain, IDBUTSTEP, 8, 0, 30, 26)
	fb_CreateTooltips(butstep, "[S]tep by step ", "FBDEBUGGER",0)
	 fb_modstyle(butstep,BS_BITMAP) 'add BS_BITMAP
	 'bmb(0)=LoadImage(fb_hinstance,"step.bmp",IMAGE_BITMAP,23,19,LR_LOADFROMFILE) kept for example
	 bmb(0)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1000)))
	 SendMessage(butstep, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(0)))
	 
	 butcont = fb_BUTTON("",windmain,IDCONTHR, 40, 0, 30, 26)' >+ 18
	 fb_CreateTooltips(butcont, "Run to [C]ursor", "",0)
	 fb_modstyle(butcont,BS_BITMAP)
	 bmb(1)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1001)))
	 SendMessage(butcont, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(1)))
	 
	 butstepp = fb_BUTTON("",windmain,IDBUTSTEPP, 72, 0, 30, 26)' >+ 18
	 fb_createtooltips(butstepp, "Step [O]ver sub/func", "",0)
	 fb_modstyle(butstepp,BS_BITMAP)
	 bmb(2)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1002)))
	 SendMessage(butstepp, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(2)))

	 butstept = fb_BUTTON("",windmain,IDBUTSTEPT, 104, 0, 30, 26)
	 fb_createtooltips(butstept, "[T]op next called sub/func", "",0)
	 fb_modstyle(butstept,BS_BITMAP)
	 bmb(22)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1022)))
	 SendMessage(butstept, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(22)))
	 
	 butstepb = fb_BUTTON("",windmain,IDBUTSTEPB, 136, 0, 30, 26)
	 fb_createtooltips(butstepb, "[B]ottom current sub/func", "",0)
	 fb_modstyle(butstepb,BS_BITMAP)
	 bmb(23)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1023)))
	 SendMessage(butstepb, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(23)))

	 butstepm = fb_BUTTON("",windmain,IDBUTSTEPM, 168, 0, 30, 26)
	 fb_createtooltips(butstepm, "[E]xit current sub/func", "",0)
	 fb_modstyle(butstepm,BS_BITMAP)
	 bmb(3)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1003)))
	 SendMessage(butstepm, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(3)))
	
	 butauto = fb_BUTTON("AUTO", windmain,IDBUTAUTO, 200, 0, 30, 26)
	 fb_createtooltips(butauto, "Step [A]utomatically, stopped by [H]alt", "",0)
	 fb_modstyle(butauto,BS_BITMAP)
	 bmb(4)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1004)))
	 SendMessage(butauto, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(4)))
	
	 butrun = fb_BUTTON("RUN",windmain, IDBUTRUN, 232, 0, 30, 26)
	 fb_createtooltips(butrun, "[R]un, stopped by [H]alt", "",0)
	 fb_modstyle(butrun,BS_BITMAP)
	 bmb(5)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1005)))
	 SendMessage(butrun, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(5)))
	
	 butstop = fb_BUTTON("HALT",windmain, IDBUTSTOP, 264, 0, 30, 26)
	 fb_createtooltips(butstop, "[H]alt running pgm", "",0)
	 fb_modstyle(butstop,BS_BITMAP)
	 bmb(6)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1006)))
	 SendMessage(butstop, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(6)))
	
	 butmini = fb_BUTTON("MINI",windmain, IDBUTMINI,296, 0, 30, 26)
	 fb_createtooltips(butmini, "Mini window", "",0)
	 fb_modstyle(butmini,BS_BITMAP)
	 bmb(7)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1007)))
	 SendMessage(butmini, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(7)))
	
	 butfree = fb_BUTTON("free",windmain, IDBUTFREE,392, 0, 30, 26)
	 fb_createtooltips(butfree, "Release debugged prgm", "",0)
	 fb_modstyle(butfree,BS_BITMAP)
	 bmb(8)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1008)))
	 SendMessage(butfree, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(8)))
	
	 Butkill = fb_BUTTON("KILL",windmain, IDBUTKILL,424, 0, 30, 26)
	 fb_createtooltips(Butkill, "CAUTION [K]ill process", "",0)
	 fb_modstyle(butkill,BS_BITMAP)
	 bmb(9)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1009)))
	 SendMessage(butkill, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(9)))
	
	 Butrrune = fb_BUTTON("EXE>>",windmain, IDBUTRRUNE,466, 0, 30, 26)
	 fb_createtooltips(Butrrune, "Restart debugging (exe)", "",0)
	 fb_modstyle(butrrune,BS_BITMAP)
	 bmb(10)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1010)))
	 SendMessage(butrrune, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(10)))
	 
	 Butlstexe = fb_BUTTON("EXE>>",windmain, IDLSTEXE,498, 0, 30, 26)
	 fb_createtooltips(Butlstexe, "Last 10 exe(s)", "",0)
	 fb_modstyle(Butlstexe,BS_BITMAP)
	 bmb(11)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1011)))
	 SendMessage(Butlstexe, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(11)))
	 
	 Butattch = fb_BUTTON("ATT>>",windmain, IDBUTATTCH,530, 0, 30, 26)
	 fb_createtooltips(Butattch, "Attach running program", "",0)
	 fb_modstyle(butattch,BS_BITMAP)
	 bmb(12)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1012)))
	 SendMessage(butattch, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(12)))
	 
	 Butfile = fb_BUTTON("FILE",windmain, IDBUTFILE,562, 0, 30, 26)
	 fb_createtooltips(Butfile, "Select EXE/BAS", "",0)
	 fb_modstyle(butfile,BS_BITMAP)
	 bmb(13)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1013)))
	 SendMessage(butfile, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(13)))
	
	 butnotes=fb_BUTTON("NOTES",windmain, IDNOTES,600,0, 30, 26)
	 fb_createtooltips(butnotes,"Open or close notes", "",0)
	 fb_modstyle(butnotes,BS_BITMAP)
	 bmb(14)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1014)))
	 SendMessage(butnotes, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(14)))
	
	 Buttool = fb_BUTTON("TOOLS",windmain, IDBUTTOOL,632, 0, 30, 26)
	 fb_createtooltips(Buttool, "Some usefull....Tools", "",0)
	 fb_modstyle(buttool,BS_BITMAP)
	 bmb(15)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1015)))
	 SendMessage(buttool, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(15)))
	 
	 Butexemod = fb_BUTTON("EXE MOD",windmain, IDEXEMOD,360, 0, 30, 26)
	 fb_createtooltips(Butexemod, "CAUTION [M]odify execution, continue with line under cursor", "",0)
	 fb_ModStyle(Butexemod,BS_BITMAP)
	 bmb(16)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1016)))
	 SendMessage(Butexemod, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(16)))
	 
	 Butfastrun = fb_BUTTON("Fast Run",windmain, IDFASTRUN,328, 0, 30, 26)
	 fb_createtooltips(Butfastrun, "CAUTION [F]AST Run to cursor", "",0)
	 fb_ModStyle(Butfastrun,BS_BITMAP)
	 bmb(17)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1017)))
	 SendMessage(Butfastrun, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(17)))

	 butenlrsrc = fb_BUTTON("Source",windmain, ENLRSRC,690, 0, 30, 26)
	 fb_createtooltips(butenlrsrc,"Enlarge/reduce source", "",0)
	 fb_ModStyle(butenlrsrc,BS_BITMAP)
	 bmb(18)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1018)))
	 SendMessage(butenlrsrc, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(18)))

	 butenlrvar = fb_BUTTON("VarProc",windmain, ENLRVAR,720, 0, 30, 26)
	 fb_createtooltips(butenlrvar, "Enlarge/reduce proc/var", "",0)
	 fb_ModStyle(butenlrvar,BS_BITMAP)
	 bmb(19)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1019)))
	 SendMessage(butenlrvar, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(19)))


	 butenlrmem = fb_BUTTON("Memory",windmain,ENLRMEM,750,0, 30, 26)
	 fb_createtooltips(butenlrmem, "Enlarge/reduce dump memory", "",0)
	 fb_ModStyle(butenlrmem,BS_BITMAP)
	 bmb(20)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1020)))
	 SendMessage(butenlrmem, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(20)))

	 bmb(21)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1021))) 'if notes changes
	 
	' next line just to see it works
	'fb_createtooltips(dbgEdit1, "See your source", "",0)
	
	'TimerID1    = SetTimer (windmain, 1,10,NULL) 'not used if 2 threads
	
	hTab2       = fb_tab(windmain,TAB2,478,43,315,25)
	
	fonthdl=fb_Set_Font(fontname,fontsize,,TRUE)
	fontbold=fb_Set_Font(fontname,fontsize,FW_SEMIBOLD,TRUE) 'in bold
	tviewvar   = fb_TREEVIEW (windmain,TVIEW1,478,65,315,365) 'procr/var
	SendMessage(tviewvar,WM_SETFONT,Cast(WPARAM,fonthdl),0)
   tviewcur=tviewvar
   tab_add(0,htab2,"Proc/var")
   
   tviewprc   = fb_TREEVIEW (windmain,TVIEW2,478,65,315,365) 'procr
   SendMessage(tviewprc,WM_SETFONT,Cast(WPARAM,fonthdl),0)
   Dim dwStyle As Long =GetWindowLong(tviewprc, GWL_STYLE)
   SetWindowLong(tviewprc,GWL_STYLE,dwStyle Or TVS_CHECKBOXES)
   ShowWindow(tviewprc,SW_HIDE)
   tab_add(1,htab2,"Procrs")
   
   tviewthd   = fb_TREEVIEW (windmain,TVIEW3,478,65,315,365) 'thread
   SendMessage(tviewthd,WM_SETFONT,Cast(WPARAM,fonthdl),0)
   dwStyle=GetWindowLong(tviewthd, GWL_STYLE)
   SetWindowLong(tviewthd,GWL_STYLE,dwStyle Or TVS_CHECKBOXES)
   ShowWindow(tviewthd,SW_HIDE)
   tab_add(2,htab2,"Threads")
   
   tviewwch   = fb_TREEVIEW (windmain,TVIEW4,478,65,315,365) 'watch
   SendMessage(tviewwch,WM_SETFONT,Cast(WPARAM,fonthdl),0)
   ShowWindow(tviewwch,SW_HIDE)
   tab_add(3,htab2,"Watched var")
   
   hTab1       = fb_tab(windmain,TAB1,3,43,475,25)
	tab_add(0,htab1,"Sources")
	
	For i As Integer=0 To MAXSRC
	richedit(i) = fb_richEDIT("fb Edit Box",windmain,IDRICHWIN,3,65,475,363)',WS_CHILD or WS_VISIBLE or ES_WANTRETURN or WS_VSCROLL or WS_HSCROLL or ES_MULTILINE or ES_AUTOVSCROLL or ES_AUTOHSCROLL or ES_READONLY)
	SendMessage(richedit(i),WM_SETFONT,Cast(WPARAM,fonthdl),0)
	SendMessage(richedit(i),EM_SETEVENTMASK,0,ENM_KEYEVENTS Or ENM_MOUSEEVENTS)
	sendmessage(richedit(i),EM_SETTABSTOPS,1,Cast(LPARAM,@tabstop))
	sendmessage(richedit(i),EM_SETBKGNDCOLOR,0,clrrichedit)
	ShowWindow(richedit(i),SW_HIDE)
	Next
	dbgrichedit=richedit(0)
	

    
	'used to put margins
'SendMessage( dbgrichedit, EM_SETMARGINS, EC_LEFTMARGIN, 70 )
	ShowWindow(dbgrichedit,SW_SHOW)
	''setWindowText(dbgrichedit,"Source")
	
	hcurline   = fb_label("Current line:",windmain,IDCURLIG,3,28,790,16)
	fb_createtooltips(hcurline, "Click here to go to current line", "",0)
	'bookmark handle
	bmkh = fb_combobox(windmain,IDBMKCMB,3,430,790,100)
	
	wtch(0).hnd = fb_label("Watch 1",windmain,IDWATCH1,3,448,395,16)
	wtch(1).hnd = fb_label("Watch 2",windmain,IDWATCH2,398,448,395,16)
	wtch(2).hnd = fb_label("Watch 3",windmain,IDWATCH3,3,464,395,16)
	wtch(3).hnd = fb_label("Watch 4",windmain,IDWATCH4,398,464,395,16)
	For l=0 to 3
		fb_createtooltips(wtch(l).hnd, "Left  Click to Select"+Chr(13)+"Right Click to Reset", "",0)
	Next
	 
	 brkvhnd=fb_label("Break on var",windmain,IDBRKVAR,3,480,790,16)
	 fb_createtooltips(brkvhnd, "Click on to reset", "",0)
	
	dbgEdit1   = fb_edit("",windmain,IDNOTEWIN,3,430,790,143,WS_CHILD or _
	ES_WANTRETURN or WS_VSCROLL or WS_HSCROLL or ES_MULTILINE or ES_AUTOVSCROLL or ES_AUTOHSCROLL )
	'or ES_READONLY)
	fb_modstyle(dbgEdit1,0,WS_EX_NOPARENTNOTIFY,1)
	
	 dbgstatus=fb_Status ("No Program",windmain, IDSTATUS)
	 SendMessage(dbgstatus,SB_SETPARTS,4,Cast(LPARAM,@pstatus(0)))
	 listview1=fb_listview(windmain,IDDUMP,3,496,790,37)
	 dump_set(listview1)
	 menu_set()
	 but_enable() 'some buttons disabled as no running prgm
	 menu_enable() 'disable some options
	 EnableMenuItem(menutools,IDHIDLOG,MF_GRAYED)
	 'redrawwindow(windmain,0,0,0)

'-------------- pour test toolbar -------------------------------
'dim as string tbText = "||Open|Save||New|Options|About||Exit"
'dim as integer ImIdx(9)={STD_FILEOPEN,STD_PROPERTIES,STD_COPY,STD_FILENEW,STD_HELP,STD_DELETE,IDB_STD_SMALL_COLOR}
'fb_TOOLBAR(windmain,900,6,"-",0,HINST_COMMCTRL,@ImIdx(0))
'fb_TOOLBAR(windmain,900,4,tbText,,,,20,15)

'dim as integer Btnstyles(7)={0,TBSTYLE_CHECK,TBSTYLE_CHECKGROUP,TBSTYLE_CHECKGROUP,TBSTYLE_CHECKGROUP,0}

'dim bm AS HBITMAP
'bm=LoadImage(fb_hinstance,"step_over.bmp",IMAGE_BITMAP,23,19,LR_LOADFROMFILE)
'fb_TOOLBAR(windmain,900,1,"-",@Btnstyles(0),bm)
'DeleteObject(cast(HGDIOBJ,bm)) a rajouter en fin de proc
'----------------- fin test toolbar ---------------------------------
   dsp_size()
   fb_show(windmain)
   ini_read() 'where find FBC.exe
   If command<>"" then treat_file("") 'case command line exe see treat_file
END SUB
'=======================================================
'Syntax:
' HWND = fb_TOOLBAR(HWND,ID,NumBtns,Text$="",BtnStyles=0,HBITMAP=0,ImgIndex=0,BtnWidth=0,BtnHeig
'ht=0,Style=0,ExStyle=0)
'
'          HWND     - Parent Handle
'          ID       - Toolbar control ID - each button will be consecutively
'                     numbered following this number.
'          NumBtns  - Number of buttons on the toolbar
'          Text$    - An optional string of names for the buttons
'                     In the format of name1|name2 each separated by a |
'                     Each additional | will place separators (spaces)
'                     between those buttons name1|||name2 will place 2
'                     spaces between names 1 and 2.
'         BtnStyles - Optional array specifying the style of each button.
'         HBITMAP   - Optional handle to a bitmap to be placed on each button.
'         ImgIndex  - An optional array specifying the order the bitmaps are
'                     placed on the buttons. The default will be in the order
'                     the bitmap is supplied in. This also allows use of
'                     windows built in images.
'                     Special note: The last entry in the index when using the
'                     built in images should be the image list.
'                     i.e. IDB_STD_LARGE_COLOR Check the WIn API Help and the
'                     example for the available options. For the HBITMAP enter
'                     HINST_COMMCTRL.
'        BtnWidth   - The width and height of each button. This only has an effect
'        BtnHeight    if no text is being used. In which case the integerest name
'                     determines the button width.
'        Style      - Optional Styles and extended styles for the toolbar.
'        ExStyle
'-------------------------------------------------------------------------------
'Example #1 The minimal needed for a standard button bar with text labels
'-------------------------------------------------------------------------------
'            HWND = FB_TOOLBAR(HWND,ID,4,"OPEN|SAVE|SETUP|QUIT")
'-------------------------------------------------------------------------------
'Example #2 The minimal needed for a standard button bar with text labels and
'           built in windows icons.
'-------------------------------------------------------------------------------
'tbText$ = "||Open|Save||New|Options|About||Exit"

'SET ImIdx[]
'STD_FILEOPEN,STD_FILESAVE,STD_COPY,STD_FILENEW,STD_HELP,STD_DELETE,IDB_STD_SMALL_COLOR
'END SET
'
'            HWND  = fb_TOOLBAR(Form1,ID,6,tbText$,0,HINST_COMMCTRL,ImIdx)

'autre exemple
'   SET Btnstyles[]
'   0,TBSTYLE_CHECK,TBSTYLE_CHECKGROUP,TBSTYLE_CHECKGROUP,TBSTYLE_CHECKGROUP,0
'   END SET
'   RAW tbText$
'   tbText$ = "||Open|Save||New|Options|About||Exit"
'   RAW bm AS HBITMAP
'   bm = fb_LOADBMP("testtool.bmp",0,1)
'   hToolBar  = fb_TOOLBAR(Form1,ID_Toolbar,6,tbText$,Btnstyles,bm)
'======================================================================


function fb_Toolbar (hwnd as HWND,id as Integer,NumBtns as integer,Text as string,Bstyles as integer ptr,img as Any ptr,imgidx as integer ptr,bx As Integer,by As Integer,Style As Integer,ExStyle As Integer) As HWND

dim a as HWND
dim as TBBUTTON  tbb(50) '=callocate(NumBtns+20,sizeof(TBBUTTON))
dim as TBADDBITMAP tbbitmap=(0,0)
static as BITMAP  bm
dim seppos As Integer=0, absidx As Integer=0, index As Integer=0 ,txtlen As Integer=len(Text)

if Style=0 then Style=WS_CHILD or WS_BORDER

A=CreateWindowEx(ExStyle,TOOLBARCLASSNAME,"",Style,0,0,0,0,hwnd,Cast(HMENU,id),fb_hInstance,NULL)

SendMessage(A,TB_BUTTONSTRUCTSIZE,sizeof(TBBUTTON),0)
SendMessage(A,WM_SETFONT,Cast(WPARAM,GetStockObject(DEFAULT_GUI_FONT)),0)

if bx<>0 and by<>0 then SendMessage(A,TB_SETBUTTONSIZE,0,MAKELONG(bx,by))

  while absidx<NumBtns
     while txtlen
        if Text[seppos]=asc("|") then exit while
       	if seppos=0 or seppos=txtlen then seppos=0: exit while
       	seppos+=1
      wend
      if Text[seppos]=asc("|") and Text[seppos+1]=asc("|") then
          tbb(index).fsStyle=TBSTYLE_SEP
      else
          if imgidx then
              tbb(index).iBitmap=imgidx[absidx]
          else
              tbb(index).iBitmap=absidx
          end if
          tbb(index).idCommand=id+absidx+1
          tbb(index).fsState=TBSTATE_ENABLED
          if Bstyles then tbb(index).fsStyle=Bstyles[absidx]
          tbb(index).iString=absidx
          absidx+=1
      end if
      seppos+=1
      index+=1
    wend
  SendMessage(A,TB_ADDBUTTONS,index,Cast(LPARAM,@tbb(0)))
  if img then
      if img=HINST_COMMCTRL then
          tbbitmap.hInst=HINST_COMMCTRL
          tbbitmap.nID=imgidx[NumBtns]
          SendMessage(A,TB_ADDBITMAP,0,Cast(LPARAM,@tbbitmap))

      else
          dim  As Integer tempo
          tempo=GetObject(img,sizeof(BITMAP),@bm)=0
          if tempo Then
              SendMessage(A, TB_SETIMAGELIST, 0,Cast(LPARAM,img))
          Else
              tbbitmap.hinst=null
              tbbitmap.nID=Cast(UInteger,img)
              'SendMessage(A,TB_SETBITMAPSIZE,0,MAKELONG(bm.bmWidth/NumBtns,bm.bmHeight))
              SendMessage(A,TB_SETBITMAPSIZE,0,MAKELONG(23,19))
              SendMessage(A,TB_ADDBITMAP,NumBtns,Cast(LPARAM,@tbbitmap))
          end if  
     end if
  end if

  if txtlen and Text[0] <>asc("-") then
  dim  titles as string *1000	'callocate(2+txtlen,sizeof(char))
      absidx=0
      for index=0 to txtlen
        if Text[index]=asc("|") then
            if Text[index+1]=asc("|") or titles[0]=0 then continue for
            titles[absidx]=0
        else
            titles[absidx]=Text[index]
        end if
        absidx+=1
      next
      SendMessage(A,TB_ADDSTRING,0,Cast(LPARAM,StrPtr(titles)))
      ''inutile free(titles)
  end if
  SendMessage(A,TB_AUTOSIZE, 0, 0)
  ShowWindow(A,SW_SHOW)
  '''inutile deallocate tbb
  return A
end function
'=======================================================
function fb_edit(Text As string,hWnd As HWND,id As Integer,X As Integer,Y As Integer,W As Integer,H As Integer,byval Style As Integer,byval Exstyle As Integer) As HWND
dim A as HWND
if Style=0 then
  Style = WS_CHILD or WS_VISIBLE or ES_WANTRETURN or _
  WS_VSCROLL or ES_MULTILINE Or ES_AUTOVSCROLL or ES_AUTOHSCROLL
end if

if Exstyle=-1 then
      Exstyle = WS_EX_CLIENTEDGE
end if

A = CreateWindowEx(Exstyle,"edit",Text, Style, _
      X, Y, W, H,hWnd,Cast(HMENU,id),fb_hInstance,NULL)
 SendMessage(A,WM_SETFONT,Cast(WPARAM,GetStockObject(DEFAULT_GUI_FONT)),0)
Return A
end Function
Function fb_editw(Text As WString,hWnd As HWND,id As Integer,X As Integer,Y As Integer,W As Integer,H As Integer,byval Style As Integer,byval Exstyle As Integer) As HWND
dim A as HWND
if Style=0 then
  Style = WS_CHILD or WS_VISIBLE or ES_WANTRETURN or _
  WS_VSCROLL or ES_MULTILINE or ES_AUTOVSCROLL or ES_AUTOHSCROLL
end if

if Exstyle=-1 then
      Exstyle = WS_EX_CLIENTEDGE
end If

A = CreateWindowExW(Exstyle,WStr("edit"),Text, Style, _
      X, Y, W, H,hWnd,Cast(HMENU,id),fb_hInstance,NULL)
SendMessage(A,WM_SETFONT,Cast(WPARAM,fonthdl),0)

Return A
end Function
'=====================================================================
function fb_getTextSize(text As string,hwnd As Integer,hfont As Integer) As integer
fb_message("To code, not existing proc","fb_getTextSize, return always ZERO"):Return 0
'SIZE*   GetTextSize (char*, HWND=0, HFONT=0)
'GetTextSize
'SIZE* GetTextSize(char* text, HWND hWnd, HFONT fnt)
'  HDC  hdc=GetDC(hWnd)
'  if(!fnt) fnt=(HFONT)SendMessage(hWnd,WM_GETFONT,0,0)
'  HGDIOBJ sobj=SelectObject(hdc,fnt)
'  static SIZE sz
'  GetTextExtentPoint32(hdc,text,strlen(text),&sz)
'  SelectObject(hdc,sobj)
'  ReleaseDC(hWnd,hdc)
'  return (&sz)
'return
end function
'=====================================================================

function fb_MDialog (DPro as Any Ptr,title as string,hWnd as HWND,X As Integer,Y As Integer,W As Integer,H As Integer,Style As Integer,Exstyle As Integer) as integer
 
dim     lpdt as DLGTEMPLATE ptr
dim     lpw as short ptr
dim     ret as integer
        lpdt=callocate(256+(len(title)*2),1)

      if Style=0 then ' or DS_MODALFRAME 
         lpdt->style=WS_POPUP or WS_SYSMENU _
         or WS_CAPTION
      else
         lpdt->style=Style
      end if
      lpdt->dwExtendedStyle=Exstyle or WS_EX_TOOLWINDOW	
      lpdt->cdit=0
      lpdt->x =X
      lpdt->y =Y
      lpdt->cx=W
      lpdt->cy=H
'      lpw=lpdt+len(DLGTEMPLATE)
    lpw=Cast(short Ptr,lpdt+1)
    *lpw=0 :lpw+=1 'no menu
    *lpw=0 :lpw+=1 'no class, standard class 
    MultiByteToWideChar(CP_ACP,0,byval title,-1,lpw,len(title)+1)
    ret=DialogBoxIndirectParam(fb_hInstance,byval lpdt,hwnd,Cast( DLGPROC,dpro),0)
    deallocate(lpdt)
    function=ret
end function
'=========== modeless =================================
function fb_Dialog (DPro as Any Ptr,title as string,hWnd as HWND,X As Integer,Y As Integer,W As Integer,H As Integer,Style As Integer,Exstyle As Integer) as HWND
 
dim     lpdt as DLGTEMPLATE ptr
dim     lpw as short ptr
dim     ret as HWND
        lpdt=callocate(256+(len(title)*2),1)
      if Style=0 then
         lpdt->style=WS_POPUP or WS_SYSMENU or ws_border _
         or WS_CAPTION or WS_VISIBLE
      else
         lpdt->style=Style
      end if
      lpdt->dwExtendedStyle=Exstyle or WS_EX_TOOLWINDOW	
      lpdt->cdit=0
      lpdt->x =X
      lpdt->y =Y
      lpdt->cx=W
      lpdt->cy=H
      lpw=Cast(short Ptr,lpdt+1)
      *lpw=0 :lpw+=1 'no menu
      *lpw=0 :lpw+=1 'no class, standard class 
      MultiByteToWideChar(CP_ACP,0,byval title,-1,lpw,Len(title)+1)
      ret=createDialogIndirectParam(fb_hInstance,byval lpdt,hwnd,Cast( DLGPROC,dpro),0)
      deallocate(lpdt)
      Return ret
end function
'===============================================================
function fb_Label(Text as string,hWnd As HWND,id As Integer,X As Integer,Y As Integer,W As Integer,H As Integer,byval Style As Integer,byval Exstyle As Integer) As HWND
dim A As HWND,size as SIZEL ptr
if Style=0 then
    Style=WS_CHILD or SS_NOTIFY or SS_LEFTNOWORDWRAP or WS_VISIBLE
end if
if Exstyle=-1 then
      Exstyle = WS_EX_CLIENTEDGE
end If
A = CreateWindowEx(Exstyle,"static",Text,Style,X,Y,W,H,hWnd,Cast(HMENU,id),fb_hInstance,NULL)
SendMessage(A,WM_SETFONT,Cast(WPARAM,GetStockObject(DEFAULT_GUI_FONT)),0)
if W=0 then
    'size=GetTextSize(Text,A)
    MoveWindow(A,X,Y,size->cx,size->cy,TRUE)
end if
return A
end function
'=====================================================================
function fb_Form(Title As string,X As Integer,Y As Integer,W As Integer,H As Integer,Style As Integer,Exstyle As Integer) As HWND
   dim  A as HWND
   if Style=0 then
        Style= WS_MINIMIZEBOX  or _
        WS_SIZEBOX      or _
        WS_CAPTION      or _
        WS_MAXIMIZEBOX  or _
        WS_POPUP        or _
        WS_SYSMENU
   end if
   A = CreateWindowEx(Exstyle,fb_szAppName,title,Style,X,Y,W,H, _
   NULL,0,fb_hInstance,0)
   SendMessage(A,WM_SETFONT,Cast(WPARAM,GetStockObject(DEFAULT_GUI_FONT)),0)
   Return A
end Function
'========================================
Function fb_Tab (hWnd as HWND, id as integer,X as Integer  _
	 ,Y as integer,W as integer,H as integer,Style as integer,StyleEx as integer) as HWND


Dim hMainTab As HWND

If Style=0 Then Style=WS_CHILD or WS_VISIBLE or WS_TABSTOP or WS_CLIPSIBLINGS Or TCS_TABS or TCS_SINGLELINE or TCS_FOCUSONBUTTONDOWN

	hMainTab=CreateWindowEx(StyleEx,WC_TABCONTROL,null,Style,X,Y,W,H,hWnd,Cast(HMENU,id),fb_hInstance,NULL)
	If hMainTab=0 Then Return NULL
	SendMessage(hMainTab,WM_SETFONT,Cast(WPARAM,GetStockObject(DEFAULT_GUI_FONT)),0) 
  return hMainTab
End function	
Sub tab_add(i As Integer,htab As hwnd,Nm As string) 'image as HIMAGELIST à voir mettre param im
Dim ttc_item as TC_ITEM
Clear ttc_item,0,sizeof(ttc_item)
  'Insert tabs in the tab control...
      ttc_item.mask=TCIF_TEXT
      ttc_item.iImage=-1
      		'If image<>NULL then
      		'  ttc_item.mask = TCIF_TEXT Or TCIF_IMAGE
      		'  ttc_item.iImage=im
      		'End if
      ttc_item.pszText=StrPtr(Nm)
      ttc_item.lParam=0
      SendMessage(htab,TCM_INSERTITEM,i,Cast(LPARAM,@ttc_item))
	'If image then SendMessage(hMainTab,TCM_SETIMAGELIST,0,image)
End Sub
'=============================================
function fb_RichEdit(Text as string,hWnd as HWND,id As Integer,X As Integer,Y As Integer,W As Integer, _
	H As Integer,Style As Integer,Exstyle As Integer) As HWND
      if LoadLibrary("RICHED20.DLL")=0 then
         fb_message("LOADLIBRARY ERROR","riched20.dll",MB_SYSTEMMODAL)
      end if
      dim A as HWND
      if Style=0 then ' or WS_CLIPSIBLINGS 
          Style=WS_CHILD or WS_VISIBLE or ES_NOHIDESEL or ES_READONLY or _
                WS_HSCROLL or WS_VSCROLL or ES_MULTILINE or _
                ES_AUTOVSCROLL or ES_AUTOHSCROLL  or ES_WANTRETURN
      end if
      if Exstyle=-1 then
          Exstyle=WS_EX_CLIENTEDGE
      end if
      A=CreateWindowEx(Exstyle,"RichEdit20a",NULL,Style,X,Y,W,H,hWnd,Cast(HMENU,id),fb_hInstance,NULL)
      '''SetWindowRTFText(A,Text)
      SendMessage(A,WM_SETFONT,Cast(WPARAM,GetStockObject(DEFAULT_GUI_FONT)),0)
      function=A
end function
'=============================================
function fb_Group (Text as string,hWnd As HWND,id As Integer,X As Integer,Y As Integer,W As Integer,H As Integer,Style As Integer,Exstyle As Integer) As HWND
  dim A as HWND
  if Style=0 then
      Style=BS_GROUPBOX or WS_CHILD or WS_VISIBLE
  end if
  A = CreateWindowEx(Exstyle,"button",Text,Style,X,Y,W,H,hWnd,Cast(HMENU,id),fb_hInstance,NULL)
  SendMessage(A,WM_SETFONT,Cast(WPARAM,GetStockObject(DEFAULT_GUI_FONT)),0)
  function=A
end function
'=====================================================================
function fb_Checkbox(Text as string,hWnd As HWND,id As Integer,X As Integer,Y As Integer,W As Integer,H As Integer,Style As Integer,Exstyle As Integer) as HWND
  dim A as HWND
  if Style=0 then
      Style=WS_CHILD or WS_VISIBLE or BS_AUTOCHECKBOX or WS_TABSTOP
   end if
  A = CreateWindowEx(Exstyle,"button",Text,Style,X,Y,W,H,hWnd,Cast(HMENU,id),fb_hInstance,NULL)
  SendMessage(A,WM_SETFONT,Cast(WPARAM,GetStockObject(DEFAULT_GUI_FONT)),0)
'  if W=0 then
'      dim size as lsize  
'      size=GetTextSize(Text,A)
'      MoveWindow(A,X,Y,size->cx+24,size->cy,TRUE)
'  end if
Return A
end function
'=====================================================================
function fb_radio(Text as string,hWnd As HWND,id As Integer,X As Integer,Y As Integer,W As Integer,H As Integer,Style As Integer,Exstyle As Integer) As HWND
  dim A as HWND
  if Style=0 then
      Style=WS_CHILD or WS_VISIBLE or BS_AUTORADIOBUTTON or WS_TABSTOP
   end if
  A = CreateWindowEx(Exstyle,"button",Text,Style,X,Y,W,H,hWnd,Cast(HMENU,id),fb_hInstance,NULL)
  SendMessage(A,WM_SETFONT,Cast(WPARAM,GetStockObject(DEFAULT_GUI_FONT)),0)
'  if W=0 then
'      dim size as lsize  
'      size=GetTextSize(Text,A)
'      MoveWindow(A,X,Y,size->cx+24,size->cy,TRUE)
'  end if
Return A
end function
'=====================================================================
function fb_combobox(hWnd As HWND,id As Integer,X As Integer,Y As Integer,W As Integer,H As Integer,Style As Integer,Exstyle As Integer)  As HWND
  dim A as HWND
  if Style=0 then 'cbs_simple cbs_dropdown list  or CBS_SORT
      Style=WS_CHILD or WS_VISIBLE or CBS_DROPDOWNLIST  or WS_VSCROLL or WS_TABSTOP
  end if
  if Exstyle=-1 then
      Exstyle=WS_EX_CLIENTEDGE
  end if
  A = CreateWindowEx(Exstyle,"Combobox",NULL,Style,X,Y,W,H,hWnd,Cast(HMENU,id),fb_hInstance,NULL)
  SendMessage(A,WM_SETFONT,Cast(WPARAM,GetStockObject(DEFAULT_GUI_FONT)),0)
Return A
end function
'=====================================================================
function fb_listbox(hWnd As HWND,id As Integer,X As Integer,Y As Integer,W As Integer,H As Integer,Style As Integer,Exstyle As Integer) As HWND
  dim A as HWND
  if Style=0 then
      Style=LBS_STANDARD or WS_CHILD or WS_VISIBLE or WS_HSCROLL or WS_VSCROLL or WS_TABSTOP
  end if
  if Exstyle=-1 then
      Exstyle=WS_EX_CLIENTEDGE
  end if
  A = CreateWindowEx(Exstyle,"listbox",NULL,Style,X,Y,W,H,hWnd,Cast(HMENU,id),fb_hInstance,NULL)
  SendMessage(A,WM_SETFONT,Cast(WPARAM,GetStockObject(DEFAULT_GUI_FONT)),0)
Return A
end function
'=====================================================================
function fb_datepick(hWnd As HWND,id As Integer,X As Integer,Y As Integer,W As Integer,H As Integer,Style As Integer,Exstyle As Integer) As HWND
  dim A as HWND
  if Style=0 then
      Style=WS_CHILD or WS_TABSTOP or WS_VISIBLE or DTS_LONGDATEFORMAT
  end if
  if Exstyle=-1 then
      Exstyle=WS_EX_CLIENTEDGE
  end if
  A = CreateWindowEx(Exstyle,"SysDateTimePick32",NULL,Style,X,Y,W,H,hWnd,Cast(HMENU,id),fb_hInstance,NULL)
  SendMessage(A,WM_SETFONT,Cast(WPARAM,GetStockObject(DEFAULT_GUI_FONT)),0)
function=A
end Function
'===================
function fb_UpDown (hWnd as HWND,X as integer,Y as integer,W as integer,H as integer,Lo as integer,Hi as integer,uStart as integer) as HWND
dim as HWND UpDn
dim as HWND Buddy
dim as integer Style = WS_CHILD or WS_VISIBLE or WS_TABSTOP or ES_NUMBER or ES_LEFT or ES_AUTOHSCROLL

  Buddy=CreateWindowEx(WS_EX_CLIENTEDGE,"edit",0,Style,X,Y,W,H,hWnd,0,fb_hInstance,NULL)
  SendMessage(buddy,WM_SETFONT,Cast(WPARAM,GetStockObject(DEFAULT_GUI_FONT)),0)
  'just for 16 bit
  'UpDn=CreateUpDownControl(WS_CHILD or WS_VISIBLE or WS_TABSTOP or WS_BORDER or _
  '                         UDS_ARROWKEYS or UDS_SETBUDDYINT or UDS_ALIGNRIGHT, _
  '                         X,Y,W,H,hWnd,0,fb_hInstance,Buddy,Hi,Lo,uStart)
  'for 32 bits range
  updn=CreateWindowEx(0,UPDOWN_CLASS,0, _
  WS_CHILD or WS_VISIBLE or WS_TABSTOP or WS_BORDER or _
  UDS_ARROWKEYS or UDS_SETBUDDYINT or UDS_ALIGNRIGHT Or UDS_WRAP, _
  0,0,0,0,hwnd,0,fb_hInstance,NULL)
  SendMessage(updn,UDM_SETBUDDY,Cast(WPARAM,buddy),0)
  SendMessage(updn,UDM_SETRANGE32,lo,hi)
  SendMessage(updn,UDM_SETPOS32,0,ustart)
 return UpDn
End function
'=====================================================================
function fb_listview(hWnd As HWND,id As Integer,X As Integer,Y As Integer,W As Integer,H As Integer,Style As Integer,Exstyle As Integer) As HWND
  dim A as HWND,i As Integer, lvStyle As Integer
  dim lvCol as   LVCOLUMN 
  if Style=0 then Style=WS_CHILD or WS_TABSTOP or WS_VISIBLE or  LVS_REPORT or LVS_SINGLESEL or LVS_SHOWSELALWAYS or WS_BORDER 'or LVS_NOCOLUMNHEADER	
  if Exstyle=-1 then Exstyle=WS_EX_CLIENTEDGE or LVS_EX_FULLROWSELECT
  A = CreateWindowEx(Exstyle,"SysListView32",NULL,Style,X,Y,W,H,hWnd,Cast(HMENU,id),fb_hInstance,NULL)
  SendMessage(A,WM_SETFONT,Cast(WPARAM,GetStockObject(DEFAULT_GUI_FONT)),0)
  lvStyle=LVS_EX_GRIDLINES 'or LVS_EX_FULLROWSELECT
  SendMessage(A,LVM_SETEXTENDEDLISTVIEWSTYLE,0,byval lvStyle)
Return A
end function
'=============================================
	Function fb_Trackbar(hwnd as HWND ,id As Integer,X As Integer,Y As Integer,W As Integer,H As Integer,orient As Integer,imin  As UInteger,imax As UInteger,iselmin As UInteger,iselmax As UInteger ) As HWND
   ' iMin,     // minimum value in trackbar range 
   ' iMax,     // maximum value in trackbar range 
   ' iSelMin,  // minimum value in trackbar selection 
   ' iSelMax)  // maximum value in trackbar selection 

    Dim As HWND htrackbar = CreateWindowEx(0,TRACKBAR_CLASS,"Trackbar Control",WS_CHILD Or WS_VISIBLE Or orient _
                            Or TBS_AUTOTICKS Or TBS_ENABLESELRANGE,x,y,w,h,hwnd,Cast(HMENU,id),fb_hInstance,NULL) 
        '0,                               // no extended styles 
        'TRACKBAR_CLASS,                  // class name 
        '"Trackbar Control",              // title (caption) 
        'WS_CHILD Or WS_VISIBLE Or TBS_AUTOTICKS Or TBS_ENABLESELRANGE,              // style 
        '10, 10,                          // position 
        '200, 30,                         // size 
        'hwnd,                            // parent window 
        'ID_TRACKBAR,                     // control identifier 
        'fb_hInstance,                         // instance 
        'NULL                             // no WM_CREATE parameter 


    SendMessage(htrackbar, TBM_SETRANGE,TRUE,MAKELONG(iMin, iMax)) 
        '(WPARAM) TRUE,                   // redraw flag 
        '(LPARAM) MAKELONG(iMin, iMax));  // min. & max. positions
        
    SendMessage(htrackbar, TBM_SETPAGESIZE,0, 4) 
        '0, (LPARAM) 4);                  // new page size 

    SendMessage(htrackbar, TBM_SETSEL,FALSE,MAKELONG(iSelMin, iSelMax))
        '(WPARAM) FALSE,                  // redraw flag 
        '(LPARAM) MAKELONG(iSelMin, iSelMax)); 
        
    SendMessage(htrackbar, TBM_SETPOS,TRUE,iSelMin) 
        '(WPARAM) TRUE,                   // redraw flag 
        '(LPARAM) iSelMin); 

    SetFocus(htrackbar) 

    return htrackbar 
End Function

sub Trackbar_buddy(htrackbar As HWND ,orient As Integer =1,hlvt As String ="",hrvb As String ="")
'orient : 1 --> horizontal (default), 2 --> vertical
    Dim As HWND hwndBuddy
    Dim As HWND hwnd=getparent(htrackbar)
    Dim As Integer style1=WS_CHILD Or WS_VISIBLE,style2=WS_CHILD Or WS_VISIBLE
    const staticWidth   = 50
    const staticHeight  = 20
If orient=1 Then
		'''' For horizontal Trackbar.
	style1=style1 Or SS_RIGHT
	style2=style2 Or SS_LEFT
Else
	style1=style1 Or SS_CENTER
	style2=style1
EndIf
If hlvt<>"" Then
    hwndBuddy = CreateWindowEx(0, "STATIC", hlvt,style1, _
                                    0, 0, staticWidth, staticHeight, hwnd, NULL, fb_hInstance, NULL)
    SendMessage(hwndBuddy,WM_SETFONT,Cast(WPARAM,GetStockObject(ANSI_FIXED_FONT)),0)
    SendMessage(htrackbar, TBM_SETBUDDY, TRUE, Cast(LPARAM,hwndBuddy))
End If     
			'-------------------------------------------------
If hrvb<>"" Then
    hwndBuddy = CreateWindowEx(0, "STATIC", hrvb, style2, _
                               0, 0, staticWidth, staticHeight, hwnd, NULL, fb_hInstance, NULL)
    SendMessage(hwndBuddy,WM_SETFONT,Cast(WPARAM,GetStockObject(ANSI_FIXED_FONT)),0) 
    SendMessage(htrackbar, TBM_SETBUDDY, FALSE, Cast(LPARAM,hwndBuddy))
End If   

End Sub
function fb_setcolor(h As HWND,s As Integer,c As Integer,d As Integer) As integer
'''#define WM_USER  &h0400
'''#define EM_SETCHARFORMAT 1092 'wm_user+68
''#define CFM_COLOR  &h40000000
''#define SCF_SELECTION  1
''#define SCF_WORD  2
''#define SCF_DEFAULT  0
''#define SCF_ALL  4
''#define CFE_AUTOCOLOR	1073741824
dim lpcharformat as CHARFORMAT,selt as integer
select case s
    case 0
selt=0 'set to the default format
    case 1
selt=SCF_ALL 'Applies the formatting to all text in the control.
    case 2
selt=SCF_SELECTION 'Applies the formatting to the current selection.
    case 3
selt=SCF_WORD or SCF_SELECTION 'Applies the formatting to the selected word or words.
end select
lpcharformat.cbsize=len(charformat)
lpcharformat.crtextcolor=c

lpcharformat.dwmask= CFM_UNDERLINE Or CFM_BOLD Or CFM_COLOR Or CFM_ITALIC 
If d=1 then
   lpcharformat.dweffects=CFE_AUTOCOLOR
ElseIf d=2 Then
   lpcharformat.dweffects=CFE_UNDERLINE Or CFE_BOLD 'Or STRIKEOUT'
ElseIf d=3 Then
   ' lpcharformat.dweffects=CFE_ITALIC
End if

if sendmessage(h,EM_SETCHARFORMAT,selt,Cast(LPARAM,@lpcharformat))=0 then
	fb_message("ERROR","Set color format")
	 Return false
else
	Return true
end if
end function
'=============================================
function fb_Status (Text As string, hWnd As HWND, ID As Integer) As HWND
Return CreateStatusWindow(WS_CHILD or WS_BORDER or WS_VISIBLE ,Text,hWnd,ID) ' Or CCS_TOP or or SBS_SIZEGRIP
end function
'==============================================
sub fb_show (hwnd As HWND)
RedrawWindow(hwnd,byval 0,0,0)
ShowWindow(hwnd,SW_SHOW)
end sub
'==============================================
function fb_ModStyle(hWnd As HWND, dwAdd As Integer, dwRemove As Integer, bEx As Integer) as integer
dim dwstyle as uinteger
dim dwnewstyle as uinteger
  SetLastError(0)
if bex then
  dwStyle = GetWindowLong(hWnd,GWL_EXSTYLE)
  dwNewStyle = (dwStyle and (not dwRemove)) or dwAdd
  SetWindowLong(hWnd, GWL_EXSTYLE,dwNewStyle)
else
  dwStyle = GetWindowLong(hWnd,GWL_STYLE)
  dwNewStyle = (dwStyle and (not dwRemove)) or dwAdd
  SetWindowLong(hWnd, GWL_STYLE,dwNewStyle)
end if  
  SetWindowPos(hWnd,NULL,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER or SWP_FRAMECHANGED)
 if GetLastError() = 0 then
  Return true
else
  Return false
end if
end function

'==============================================
function fb_button (Text as string,byval hWnd As HWND,byval id As Integer,byval X As Integer,byval Y As Integer,byval W As Integer,byval H As Integer, Style As Integer, Exstyle As Integer)  As HWND

 dim A as HWND

 if Style=0 then
     Style=(WS_CHILD or WS_VISIBLE or BS_MULTILINE or BS_PUSHBUTTON or WS_TABSTOP)
 end if

 if Exstyle=-1 then
     Exstyle=WS_EX_STATICEDGE
 end if
 
 A = CreateWindowEx(Exstyle,"button",Text,Style, X, Y, W, H,hWnd,Cast (HMENU,id) ,fb_hInstance,NULL)
 
 SendMessage(A,WM_SETFONT,Cast(WPARAM,GetStockObject(DEFAULT_GUI_FONT)),0)
 
 if W=0 then
   dim hdc as HDC
   hdc=GetDC(A)
   dim vsize as SIZEL
   GetTextExtentPoint32(hdc,Text,len(Text),@vsize)
   ReleaseDC(A,hdc)

 MoveWindow(A,X,Y,vsize.cx+(vsize.cx*0.5),vsize.cy+(vsize.cy*0.32),TRUE)
 end if
 Return A
end function
'===================================================================
function fb_message(title as string ,text as string,style As Integer) As Integer
   if title="" then
      Return MessageBox(GetActiveWindow(),text," ",style)
   else
      Return MessageBox(GetActiveWindow(),text,title,style)
   end if
end function
'===================================================
function fb_Treeview(hWnd as HWND,id As Integer,X As Integer,Y As Integer,W As Integer,H As Integer,Style As Integer,Exstyle As Integer) As HWND
dim A as HWND
if Style=0 then
      Style=WS_VISIBLE or WS_CHILD or TVS_HASLINES or TVS_HASBUTTONS or TVS_LINESATROOT or TVS_SHOWSELALWAYS
end if
if Exstyle-1 then
   Exstyle=WS_EX_CLIENTEDGE
end if
A =CreateWindowEx(Exstyle,WC_TREEVIEW,NULL,Style,X,Y,W,H,hWnd,Cast(HMENU,id),fb_hinstance,NULL)
'SendMessage(A,WM_SETFONT,GetStockObject(DEFAULT_GUI_FONT),0)
SendMessage(A,WM_SETFONT,Cast(WPARAM,GetStockObject(ANSI_FIXED_FONT)),0)
Return A
end function
'=========================================================================
FUNCTION fb_CreateTooltips(hControl AS HWND, Text As string, Title as string, ToolIcon As Integer) AS HWND
    
    'Create tooltip class     fb_htooltip must be global
    DIM Balloon AS TOOLINFO 
    DIM ttStyle AS INTEGER 
    dim hwnd As HWND

   if fb_htooltip=null then
     hwnd=getparent(hcontrol) 
     if hwnd=null then hWnd = GetActiveWindow()
    'Create the tooltip class (GetWindowLong(hWnd,GWL_HINSTANCE) utilisable à la place de getmodu...)
       ttStyle = 0 '64 for balloon tips 0 -->rectangle
       fb_hToolTip = CreateWindowEx(0,"ToolTips_Class32","",ttStyle,0,0,0,0,hWnd,0,GetModuleHandle(0),0) 
       if fb_htooltip=null then exit function
    'Set up the tool tips 
       SendMessage(fb_hToolTip, TTM_SETMAXTIPWIDTH, 0 , 180) 
       SendMessage(fb_hToolTip, TTM_SETDELAYTIME, TTDT_INITIAL ,400) 
       SendMessage(fb_hToolTip, TTM_SETDELAYTIME, TTDT_RESHOW  ,600)
   end if
    'Set structure 
    Balloon.cbSize = len(TOOLINFO) 
    Balloon.uFlags = TTF_IDISHWND OR TTF_SUBCLASS 
    Balloon.hwnd = hwnd 
    Balloon.uId = Cast(UInteger,hControl)
    Balloon.lpszText = strptr(Text) 
    Balloon.hinst = fb_HINSTANCE 
    'Send message 
    SendMessage(fb_hToolTip, TTM_ADDTOOL, 0,Cast(LPARAM,@Balloon))
    'Add a title 
    IF LEN(Title) > 0 THEN 
        SendMessage(fb_hToolTip, 1056, ToolIcon,Cast(LPARAM,strptr(title)))
    END IF 
    'Return handle 
    return fb_hToolTip 
END FUNCTION 
'------------------------------------------------------------------------
SUB fb_UpdateTooltip(hToolTip AS HWND, hControl AS HWND, Text As string, Title As string, ToolIcon As Integer) 
    DIM Balloon AS TOOLINFO 
    'set structure 
    Balloon.cbSize = len(TOOLINFO) 
    'Balloon.hwnd = getparent(hcontrol)
    Balloon.uFlags = TTF_IDISHWND' OR TTF_SUBCLASS 
    Balloon.uId = Cast(UInteger,hControl)
    Balloon.lpszText = strptr(Text)
    'Balloon.hinst = fb_HINSTANCE
    'send message to update text 
    SendMessage(hToolTip, TTM_UPDATETIPTEXT, 0, Cast(LPARAM,@Balloon )) 
    'add a title 
    IF LEN(Title) > 0 THEN '1056
        SendMessage(hToolTip, 1056, ToolIcon, Cast(LPARAM,StrPtr(Title)) )
    END IF 
END SUB
'==============================================================
function fb_find(d as integer,s as string) As integer
dim ftext as FINDTEXT,range as CHARRANGE,ret As Integer
dim nbl As Integer,nbc As Integer,mov As Integer
sendmessage(dbgrichedit,EM_EXGETSEL,0, Cast(LPARAM,@range)) 'get pos cursor
nbl=sendmessage(dbgrichedit,EM_GETLINECOUNT,0,0)-1' number of lines (zero based)
nbc=sendmessage(dbgrichedit,EM_LINEINDEX ,nbl,0)  ' nb of char except last line
nbc+=sendmessage(dbgrichedit,EM_LINELENGTH,nbc,0)  'total of char (added last line)

if d then 'bottom direction
   ftext.chrg.cpmin=range.cpmax
   ftext.chrg.cpmax=nbc
   mov=1 'FR_DOWN 
   else 'top
   ftext.chrg.cpmin=range.cpmin
   ftext.chrg.cpmax=0
   mov=0 'FR_DOWN
end if
ftext.lpstrText=strptr(s)
ret=sendmessage(dbgrichedit,EM_FINDTEXT,mov+chkcase,Cast(LPARAM,@ftext))
if ret=-1 then 'not found
   if d then
      range.cpmin=0:range.cpmax=0
      sendmessage(dbgrichedit,EM_EXSETSEL,0,Cast(LPARAM,@range)) 'restart top
      Return SetWindowText(hfindbx, "Bottom reached go to top")
   else
      range.cpmin=nbc :range.cpmax=nbc
      sendmessage(dbgrichedit,EM_EXSETSEL,0,Cast(LPARAM,@range)) 'restart bottom
      Return SetWindowText(hfindbx, "Top reached go to bottom")
   end if
else
   range.cpmin=ret
   range.cpmax=ret+len(s)
   sendmessage(dbgrichedit,EM_EXSETSEL,0,Cast(LPARAM,@range)) 'inverse 
   Return SetWindowText(hfindbx, "Findtext (Circular)")
end if
end function
'=====================================================
 
'example getfilename("Essai choissisez un fichier","Tous *.*|*.*|test *.txt|*.txt;*.jpg||",0,0,0,"freebasic\")

Function fb_GetFileName(Title as string, Filt as String,Flag As Integer,hWnd As HWND,Flags As Integer,InitialDr as string) as string
 
dim OPENFILENAME as OpenFilename
dim filter as zstring *500
dim filename as zstring *2000
dim Extension as string *256
dim Counter As Integer
dim initialdir as zstring *500
filter=filt
initialdir=initialdr
clear filename,,2000
' RAZ zone : memset(&OpenFileName,0,sizeof(OpenFileName))

       for Counter=0 to len(Filter)
          if Filter[Counter]=asc("|") then
            Extension[Counter]=0
          else
            Extension[Counter]=Filter[Counter]
        end if
    next
       'CmDlgHook=SetWindowsHookEx(WH_CBT,(HOOKPROC)SBProc,(HINSTANCE)NULL,GetCurrentThreadId())
       OpenFileName.lStructSize=len(OpenFilename)
       OpenFileName.hwndOwner=hWnd
       OpenFileName.hInstance=0
       OpenFileName.lpstrFilter=Cast(lpstr,@Extension)
       OpenFileName.lpstrTitle=strptr(title)
       OpenFileName.nMaxFile=2000
       OpenFileName.nMaxFileTitle=0
       OpenFileName.lpstrFile=@filename
       OpenFileName.lpstrFileTitle=NULL
       OpenFileName.lpstrCustomFilter=0
       OpenFileName.nMaxCustFilter=0
       OpenFileName.nFilterIndex=0
       OpenFileName.lpstrInitialDir=@(InitialDir)
       OpenFileName.nFileOffset=0
       OpenFileName.nFileExtension=0
       OpenFileName.lpstrDefExt=0
       OpenFileName.lCustData=0
       OpenFileName.lpfnHook=0
       OpenFileName.lpTemplateName=0
       if Flags=0 then
         OpenFileName.Flags = OFN_HIDEREADONLY or OFN_CREATEPROMPT or OFN_EXPLORER 'or OFN_ALLOWMULTISELECT 
       else
OpenFileName.Flags = Flags or OFN_EXPLORER
       end if

        if GetopenFileName(@OpenFileName) then
            counter=0
            do
                if filename[counter]=0 then
                    if filename[counter+1]=0 then exit do
                    filename[counter]=asc("|")
                end if
                counter+=1
            loop
        end if
        return filename
end Function
Sub dsp_sizecalc()
'calculate the maximum number of lines displayed in the window
Dim As HDC hdc
Dim As RECT wndRect
Dim As Integer rectheight
Dim As TEXTMETRIC tm
'get height of window
SendMessage( dbgrichedit, EM_GETRECT, 0 , cast(LPARAM,@wndrect))
rectheight = wndrect.bottom - wndrect.top
'get height of font being used
hdc = GetDC( dbgrichedit )
If hdc=0 Then dspsize=10:Exit sub 'not very good
selectobject(hdc,fonthdl)
GetTextMetrics( hdc, @tm )
ReleaseDC( dbgrichedit, hdc )
'use height of font and height of rich edit control
dspsize=rectheight\tm.tmHeight
dspwidth=(wndrect.right - wndrect.left)\tm.tmAveCharWidth-4
End Sub
sub thread_rsm()'07/03/2013
WriteProcessMemory(dbghand,Cast(LPVOID,rLine(thread(threadcur).sv).ad),@rLine(thread(threadcur).sv).sv,1,0) 'restore old value for execution
resumethread(threadhs)
end Sub
'=============================================
Function WndProc ( byval hWnd as HWND, _
                   byval message as integer, _
                   byval wParam as integer, _
                   byval lParam as integer ) as integer
                   WndProc=0
                   
                   static x As Integer,y As Integer,pnt as POINT,hbrsh As HBRUSH
                   
   If flagtuto=1 Then '03/01/2013
   	If message<>WM_DESTROY Then Return DefWindowProc( hWnd, message, wParam, lParam )
   ElseIf flagtuto=2 then
   	flagtuto=1
   EndIf
                   
    SELECT CASE message
   	case WM_CREATE

      CASE WM_LBUTTONDOWN
            'only if mini screen
            if dsptyp>99 then
                SetCapture(windmain)
                x = LOWORD(lParam)
                y = HIWORD(lParam)
            end if
          Case WM_MOUSEMOVE
          If  wParam = MK_LBUTTON and dsptyp>99 Then
           GetCursorPos(@pnt)
           SetWindowPos(windmain, 0, pnt.x - x, pnt.y - y, 0, 0, SWP_NOSIZE or SWP_NOZORDER)
          End If
          Case WM_LBUTTONUP
          ReleaseCapture()
        CASE WM_CONTEXTMENU ' right click
            GetCursorPos(@pnt)
            if wparam=dbgrichedit then
              TrackPopupMenuEx(menuedit, TPM_LEFTALIGN or TPM_RIGHTBUTTON, pnt.x, pnt.y, hWnd,byval NULL)
              PostMessage(windmain, WM_NULL, 0, 0)
            elseif wparam=tviewvar Then
              TrackPopupMenuEx(menuvar, TPM_LEFTALIGN or TPM_RIGHTBUTTON, pnt.x, pnt.y, hWnd,byval NULL)
              PostMessage(windmain, WM_NULL, 0, 0)
            elseif wparam=tviewprc Then
              	TrackPopupMenuEx(menuproc, TPM_LEFTALIGN or TPM_RIGHTBUTTON, pnt.x, pnt.y, hWnd,byval NULL)
              	PostMessage(windmain, WM_NULL, 0, 0)
            ElseIf wparam=tviewthd Then
            	TrackPopupMenuEx(menuthread, TPM_LEFTALIGN or TPM_RIGHTBUTTON, pnt.x, pnt.y, hWnd,byval NULL)
            	PostMessage(windmain, WM_NULL, 0, 0)
            elseif wparam=tviewwch Then
            	If wtchcpt Then
              		TrackPopupMenuEx(menuwatch, TPM_LEFTALIGN or TPM_RIGHTBUTTON, pnt.x, pnt.y, hWnd,byval NULL)
              		PostMessage(windmain, WM_NULL, 0, 0)
            	Else
            		fb_message("Context menu for watched var list","Watched var list is empty"+chr(13)+"Nothing to do")
            	End If
            ElseIf wparam=listview1 and prun then
                if hdumpbx=0 then
                    fb_dialog(@dump_box,"Manage dump",windmain,283,25,100,70)
                    PostMessage(windmain, WM_NULL, 0, 0)
                end If
            Else 'Erase watch ?
            	For i As Integer =0 To WTCHMAIN
            		If wparam=wtch(i).hnd Then watch_del(i):Exit For
            	Next
            end If
    	Case WM_KEYDOWN
		   Dim As integer	sccheck=wparam+(getkeystate(VK_CONTROL) And &h8000)/&h8000*&hF000+(getkeystate(VK_MENU) And &h8000)/&h8000*&hF0000+(getkeystate(VK_SHIFT) And &h8000)/&h8000*&hF00000
		   For i As Integer =0 To shcutnb-1 
		  		If sccheck=shcut(i).sccur Then
					If GetMenuState(shcut(i).scmenu,shcut(i).scidnt,MF_BYCOMMAND)=0 Then
						SendMessage(windmain,WM_COMMAND,makelong(shcut(i).scidnt,BN_CLICKED),null):Return TRUE
					EndIf
		    		Exit For
		  		EndIf
		   Next
    	Case WM_DROPFILES
    		Drag_exe(Cast(handle,wParam))
      Case WM_COMMAND
         select case loword(wparam)
         	case IDBUTSTEP 'STEP
                        stopcode=0
                        SetFocus(windmain) 'just to lose focus
                        thread_rsm()
         	case IDBUTSTEPP 'STEP+ over
                        procin=procsk
                        runtype=RTRUN
                        but_enable()
                        SetFocus(windmain)
                        thread_rsm()
         	case IDBUTSTEPM 'STEP- out
                        if proc_find(thread(threadcur).id,KLAST)<>proc_find(thread(threadcur).id,KFIRST) then 'impossible to go out first proc of thread
                            procad=procsv
                            runtype=RTRUN
                            but_enable()
                        end If
                        SetFocus(windmain)
                        thread_rsm()
         	case IDBUTSTEPB 'STEP at bottom of proc 27/02/2013
									If rline(thread(threadcur).sv).ad<>proc(procsv).fn Then 'if current line is end of proc simple step   26/02/2013
									  procbot=procsv
									  runtype=RTRUN
									  but_enable()
									EndIf
                        SetFocus(windmain)
                        thread_rsm()
         	case IDBUTSTEPT 'STEP at top of proc 09/03/2013
								If rline(thread(threadcur).sv).ad<>proc(procsv).fn Then 'if current line is end of proc simple step   26/02/2013
									  proctop=TRUE
									  runtype=RTRUN
									  but_enable()
									EndIf
                        SetFocus(windmain)
                        thread_rsm()
         	case IDBUTAUTO,IDTHRDAUT 'simple and multi thread auto
         				   threadaut=0
			         		If loword(wparam)=IDTHRDAUT Then
									For i As Integer =0 To threadnb
										If thread(i).exc Then threadaut+=1
									Next
									If threadaut<2 Then fb_message("Automatic execution","Not enough selected thread so normal auto")
								EndIf
			               runtype=RTAUTO
			               but_enable()
			               SetFocus(windmain)
			               thread_rsm()
            case IDBUTRUN
			               runtype=RTRUN
			               but_enable()
			               thread_rsm()
         	case IDFASTRUN
         					fastrun()
         	case IDBUTSTOP
                        If runtype=RTFREE Or runtype=RTFRUN Then
                        	runtype=RTFRUN 'to treat free as fast
                        	For i As Integer = 1 To linenb 'restore old instructions
                					WriteProcessMemory(dbghand,Cast(LPVOID,rline(i).ad),@breakcpu,1,0)
                				Next
                        Else
                        	runtype=RTSTEP:procad=0:procin=0:proctop=FALSE:procbot=0
                        EndIf
                        Stopcode=CSHALTBU
                        SetFocus(dbgrichedit)
           case IDBUTMINI
                        if dsptyp>99 then 'set full screen
                        	dsptyp-=100
                           DeleteObject(Cast(HGDIOBJ,hbrsh))
                           fb_ModStyle (windmain,WS_MAXIMIZEBOX or WS_MINIMIZEBOX or WS_SIZEBOX or WS_CAPTION or WS_SYSMENU, 0,FALSE)
                           SetWindowPos(windmain,HWND_NOTOPMOST,recsav.left,recsav.top,recsav.right-recsav.left,recsav.bottom-recsav.top,SWP_NOACTIVATE)' OR SWP_NOSIZE OR SWP_NOMOVE
                        Else 'set mini screen
                        	dsptyp+=100
                        	GetWindowRect(windmain,@recsav)
                           fb_ModStyle (windmain,0,WS_MAXIMIZEBOX or WS_MINIMIZEBOX or WS_SIZEBOX or WS_CAPTION or WS_SYSMENU, FALSE)
                           hbrsh=createsolidbrush(&h0000FF) 'red background
                           SetClassLong(windmain,GCL_HBRBACKGROUND,Cast(Long,hbrsh))
                           SetWindowPos(windmain,HWND_TOPMOST,50,50,456,45,SWP_NOACTIVATE ) ' OR SWP_NOSIZE OR SWP_NOMOVE
                        end If
                        SetFocus(windmain)
           case IDBUTTOOL
               GetCursorPos(@pnt)
               if dir(exepath+"\dbg_log_file.txt")="" Then 'the file can be deleted by user outside
						EnableMenuItem(menutools,IDSHWLOG,MF_GRAYED)
						EnableMenuItem(menutools,IDDELLOG,MF_GRAYED)
               Else
               	EnableMenuItem(menutools,IDSHWLOG,MF_ENABLED)
						EnableMenuItem(menutools,IDDELLOG,MF_ENABLED)
               End If
               TrackPopupMenuEx(menutools, TPM_LEFTALIGN or TPM_RIGHTBUTTON, pnt.x, pnt.y, hWnd,byval NULL)
               PostMessage(windmain, WM_NULL, 0, 0)
               SetFocus(windmain)
           case IDBUTFILE
                treat_file("£$_NO$FILE_$£") 'hope that nobody uses a such name ;-)
                SetFocus(windmain)
           case IDRICHWIN  'click sur dbgrichEdit prévoir remettre ligne en cours
                       'tester pour uniquement mouse sur client area
           Case IDNOTEWIN
         		If HiWord(wparam)=EN_CHANGE Then
         			If SendMessage(dbgedit1,EM_GETMODIFY,0,0) Then
         				SendMessage(butnotes,BM_SETIMAGE,IMAGE_BITMAP,cast(LPARAM,bmb(21)))
         			EndIf
         		EndIf
         		'SetFocus(windmain)
         	Case IDBUTRRUNE  'restart exe
           		Dim As Double dtempo=FileDateTime(exename)'21/07/2013
           		If exedate<>0 AndAlso exedate=dtempo Then
           			flagrestart=sourcenb
           		EndIf
           		If wtchcpt Then flagwtch=1 
               treat_file(exename)
         	Case IDLSTEXE 'last 10 EXE(s)   
               GetCursorPos(@pnt)
               dim exelist as HMENU
               exelist = CreatepopupMenu()
               for i as byte =0 to 9
               	if savexe(i)<>"" then AppendMenu(exelist, MF_STRING,1200+i,savexe(i)):if i=0 then AppendMenu(exelist, MF_SEPARATOR, 0, "")
               next
               TrackPopupMenuEx(exelist, TPM_LEFTALIGN or TPM_RIGHTBUTTON, pnt.x, pnt.y, hWnd,byval NULL)
               destroymenu(exelist)
               PostMessage(windmain, WM_NULL, 0, 0)
           Case 1200 To 1209   
                exename=savexe(loword(wparam)-1200)
                treat_file(exename)
         	case IDBUTATTCH  'attach running process
                If prun andalso kill_process("Trying to attach but debuggee still running")=false then
                        'nothing to do but better algo
         		Else
         			GetCursorPos(@pnt)
             		fb_mdialog(@attach_box,"Attachment to a running process",windmain,pnt.x-300,pnt.y,100,150)
             	end If 
         	case IDBUTFREE
                If fb_message("FREE","Release debugged prgm",MB_YESNO OR MB_ICONQUESTION)=IDYES then
                	For i As Integer = 1 To linenb 'restore old instructions
                		WriteProcessMemory(dbghand,Cast(LPVOID,rline(i).ad),@rLine(i).sv,1,0)
                	Next
                	runtype=RTFREE
                	but_enable()
                	thread_rsm()
                End if
         	case IDBUTKILL  'kill process
						kill_process("Terminate immediatly no saved data, other option Release")
         	case IDCMDLPRM   'open settings
                fb_mdialog(@settings_box,"Settings",windmain,50,25,337,196)
            case IDABOUT
               fb_message("FB DEBUGGER",fbdebuggerversion+chr(13)+__DATE__+chr(13)+"(C) L.GRAS"+chr(13)+"sarg @ aliceadsl . fr")
         	Case IDCMPINF
               compinfo_sh
         	case IDINFOS
               If helpbx=0 then helptyp=2:fb_Dialog(@help_box,"PROCESS LIST",windmain,2,2,400,250)
         	Case IDLSTDLL
               If helpbx=0 then helptyp=7:fb_Dialog(@help_box,"DLLS LIST",windmain,2,2,400,250)
         	Case IDLSTSHC
               If helpbx=0 then helptyp=8:fb_Dialog(@help_box,"SHORTCUT KEYS LIST",windmain,2,2,400,250)
            case IDDBGHELP
            	help_manage '05/06/2013
            case IDFILEIDE
                ide_launch()
         	case IDQCKEDT
         		If prun andalso kill_process("If YES debuggee is killed then Quick edit is started")=false then
                        'nothing to do but better algo
         		Else
               	If dbgsrc="" OrElse dir(dbgsrc)="" then
                    fb_message("Quick internal Editor","No file !!!")
               	Else
                    sendmessage(dbgrichedit,EM_SETREADONLY,FALSE,0)
                    dsp_hide(1)
                    fb_dialog(@save_box,"Quick edit",windmain,283,25,150,25)
                    setfocus(dbgrichedit)
                    sendmessage(dbgrichedit,EM_HIDESELECTION,1,0)
                    sendmessage(dbgrichedit,EM_SETSEL,1,1)
               	end If
               endif
         	Case IDCLIPBRD
         		sendmessage(dbgedit1,EM_SETSEL,0,-1)
         		sendmessage(dbgedit1,WM_COPY,0,0)
         		sendmessage(dbgedit1,EM_SETSEL,-1,0)
         	Case IDDELLOG 'delete log file if exists
						flaglog=flaglog And 1                'change the value but keeps screen output
						dbg_prt(" $$$$___CLOSE ALL___$$$$ ") 'close the file if needed
						Kill (exepath+"\dbg_log_file.txt")   'delete it
         	Case IDSHWLOG
         			log_show
         	Case IDHIDLOG '09/06/2013
         			log_hide
         	Case IDSHENUM
                if helpbx=0 Then helptyp=6:fb_dialog(@help_box,"LIST ENUMS",windmain,2,2,260,250)
         	Case IDCMPNRUN  'recompil bas then run
              	If source(dbgmain)="" Then
              		treat_file("£$_NO$FILE_$£")
              	Else
              		treat_file(source(dbgmain))
              	EndIf
            case IDWINMSG
                winmsg()
            case IDSHWBDH
                dechexbin()
         	Case IDFRTIMER
                fb_message("Fast run timer","Elapsed Time : "+str(fasttimer))
         	Case IDJITDBG
         		fb_MDialog(@jit_box,"Set/reset JIT debugger",windmain,283,25,325,60)
         	case IDTUTO
         		If tutobx=0 Then fb_Dialog(@tuto_box,"Tutorial",windmain,20,280,325,60) '04/01/2013
         		'fb_message("Tutorial","Sorry, Work in progress !!!")
         	case IDSETBRK 'set breakpoint
               brk_set(1)
         	case IDSETBRT 'set tempo brkp
               brk_set(2)
         	case IDBRKENB 'enable/disable brkp
               brk_set(3) '01/03/2013
           	case IDMNGBRK
               fb_MDialog(@brk_manage,"Manage breakpoints",windmain,500,8,330,170) '27/02/2013
         	case IDCONTHR 'run to cursor
         		SetFocus(windmain)
               brk_set(9)
         	case IDEXEMOD 'modify execution from cursor
         		exe_mod()
         	Case IDSHWVAR
         		var_tip(PROCVAR)
         	Case IDSETWVAR
         		var_tip(WATCHED)
           	case IDFNDTXT
					if hfindbx=0 then 'findtext not active ?
						stext=wtext() 'selected text or ascii text near cursor
						fb_Dialog(@find_box,"Findtext (Circular)",windmain,283,25,100,25)
					end If
				case IDACCLINE 
            	'dsp_access(shwtab)
            	dsp_noaccess
         	Case IDFCSSRC
         		If focusbx=0 Then
                	fb_dialog(@focus_box,"Focus on some lines from source",windmain,2,2,400,260)
         		EndIf   
         	case IDTGLBMK
               bmk_tgl()
         	case IDNXTBMK
         		bmk_goto(TRUE) 'move forward
         	case IDPRVBMK  
               bmk_goto(FALSE)'move backward
         	case IDCURLIG 'label
                       exrichedit(curtab)
                       sel_line(curlig-1)
         	Case IDBMKCMB 'combobox bookmark
				   If hiword(wparam)=CBN_SELCHANGE then 'move to bmk
				      x=sendmessage(bmkh,CB_GETCURSEL,0,0)
		      		x=sendmessage(bmkh,CB_GETITEMDATA,x,0)
		      		If bmk(x).ntab<>shwtab Then exrichedit(bmk(x).ntab) 'change tab
		            sel_line(bmk(x).nline-1)'select line
				   EndIf
         	case IDADDNOT
               notes_add()
         	Case IDGOTO 'goto line
         			line_goto
         	Case IDLINEADR 'line address (in memory)
         		line_adr
           	case ENLRSRC 'enlarge source
              	dsp_hide(1)
           	case ENLRVAR 'enlarge proc/var
              	dsp_hide(2)
         	case IDNOTES 'open or close notes
              	If dsptyp<>0 and dsptyp<>3 Then dsp_hide(dsptyp)'cancel full source or mem or var
              	dsp_hide(3)
           	case ENLRMEM 'enlarge dump
              	dsp_hide(4)
           	case IDVCLPSE 'collapse proc/var
		         proc_expcol(TVE_COLLAPSE)
         	Case IDLSTVARA
               procvar_list()
         	Case IDLSTVARS
         		procvar_list(1)
         	case IDVEXPND 'expand
               proc_expcol(TVE_EXPAND)
         	Case IDSELIDX
         		If hindexbx=0 Then fb_Dialog(@index_box,"Index selection",windmain,283,25,220,115)
         	case IDSTWTCH1,IDSTWTCH2,IDSTWTCH3,IDSTWTCH4 'exchange watch 0 to 3
               watch_exch(loword(wparam)-IDSTWTCH1) 
         	Case IDWCHDEL'delete watch on cursor from watched
         		watch_del(watch_find())
         	Case IDWCHDALL'delete all watches
   				If fb_message("Delete watched vars","Delete all",MB_YESNO OR MB_ICONQUESTION)=IDYES Then
   					watch_del()
   				EndIf
         	Case IDWCHVAR'show in proc:var window from watched
         		watch_sel(watch_find())
         	Case IDWCHTTGL 'toogle trace
         		watch_trace(watch_find()) 
         	Case IDWCHTTGA 'cancel all traces
         		watch_trace()
         	Case IDWCHDMP'dump for watched
         		var_dump(tviewwch)
         	Case IDWCHSTG'shw string from watched
         		string_sh(tviewwch)
         	Case IDWCHSHW'shw/exp from watched
         		shwexp_new(tviewwch)
         	Case IDWCHEDT'edit from watched
         		If var_find2(tviewwch)<>-1 then 'not local non-existent
         			fb_MDialog(@edit_box,"Edit var value (Be carefull)",windmain,283,25,350,50)
         		End If
         	Case IDSETWTCH 'set watched first free slot
            	If var_find2(tviewvar)<>-1 Then watch_set()
         	Case IDSETWTTR 'set watched + trace
         		watch_addtr
         	case IDVARDMP  'var dump
              var_dump(tviewvar)
         	case IDSHSTRG  'show z/w/string
              string_sh(tviewvar)
         	Case IDCHGZSTR
              zstringbyte_exchange()
         	case IDVAREDT  'edit var value
              If var_find2(tviewvar)<>-1 Then fb_mdialog(@edit_box,"Edit var value (Be carefull)",windmain,283,25,350,50)
         	Case IDSHWEXP  'show and expand variables
					shwexp_new(tviewvar)
            case IDVARBRK  'break on var value
              brkv_set(1)
         	Case IDRSTPRC 'reset all proc
         		proc_flw(1)
         	Case IDSETPRC 'set all proc
           		proc_flw(2)
         	Case IDSORTPRC
         		procsort=1-procsort:proc_sh 'toogle type of sort and update display 17/05/2013
         	Case IDLOCPRC 'locate proc
         		proc_loc()
         	Case IDCALLINE 'locate calling line
         	   proc_loccall
         	Case IDSHWPROC 'locate proc in proc/var treeview
         		thread_procloc(1)
         	Case IDSHPRSRC 'locate proc in source
         		thread_procloc(2)
         	Case IDPRCRADR 'informations about running proc
         		thread_procloc(3)
         	case IDTHRDCHG 'change next executed thread
                thread_change
         	Case IDTHRDKLL 'kill a thread
         		thread_kill
         	Case IDEXCLINE 'show line
         		thread_execline(1)
         	Case IDCREATHR 'show line creating thread
         		thread_execline(2)
         	Case IDTHRDLST
         		if helpbx=0 Then helptyp=1:fb_dialog(@help_box,"THREADS LIST",windmain,2,2,260,250)
         	Case IDTHRDEXP
         		thread_expcol(TVE_EXPAND) '14/12/2012
         	Case IDTHRDCOL	
         		thread_expcol(TVE_COLLAPSE)
         	case IDFNDTXUP
            	fb_find(0,sfind)
            case IDFNDTXDW
            	fb_find(1,sfind)
         	case IDWATCH1,IDWATCH2,IDWATCH3,IDWATCH4
					watch_sel(loword(wparam)-IDWATCH1) 'check adr then select watched variable inside proc/var
            case IDBRKVAR 'update break on var
            	if brkv.adr<>0 then brkv_set(2)
         end Select
    	Case WM_HELP
    		decode_help(Cast(HELPINFO Ptr,lparam))
    	case WM_NOTIFY
    		If LoWord(wparam)=IDDUMP then
        		dim lvp as NMLISTVIEW ptr
        		lvp=Cast(NMLISTVIEW Ptr,lparam) 'click on one column so can change the value in memory
        		if lvp->hdr.code =&hFFFFFF94 and dumpadr<>0 and prun then dump_update(lvp)'LVN_COLUMNCLICK
    		ElseIf LoWord(wparam)=TAB1 then
				dim pnotify as NMHDR Ptr,wnot As Integer
				pnotify=Cast(NMHDR Ptr,lparam)
				If pnotify->code=TCN_SELCHANGE Then
					wnot=sendmessage(htab1,TCM_GETCURSEL,0,0)
					exrichedit(wnot) 'change tab and richedit
				End If
    		ElseIf LoWord(wparam)=TAB2 Then
    			dim pnotify as NMHDR Ptr,wnot As Integer
				pnotify=Cast(NMHDR Ptr,lparam)
				If pnotify->code=TCN_SELCHANGE Then
					wnot=sendmessage(htab2,TCM_GETCURSEL,0,0)
					ShowWindow(tviewcur,SW_HIDE)
					Select Case wnot
						Case 0 'proc/var
							tviewcur=tviewvar
							SetFocus(dbgrichedit)
						Case 1 'procrs
							tviewcur=tviewprc
							proc_sh()
							SetFocus(tviewprc)'20/05/2013
						Case 2 'threads	
							tviewcur=tviewthd
							SetFocus(dbgrichedit)
						Case 3 'watched var
							tviewcur=tviewwch
							SetFocus(dbgrichedit)
					End Select
               ShowWindow(tviewcur,SW_SHOW)
				End If
    		ElseIf LoWord(wparam)=TVIEW2 Then
                dim pnotify as NMHDR Ptr =Cast(NMHDR Ptr,lparam)
                dim as TVHITTESTINFO ht
                if pnotify->code=NM_CLICK then
                    dim as integer dwpos = GetMessagePos()
                    ht.pt.x = LOWORD(dwpos)
                    ht.pt.y = HIWORD(dwpos)
                    MapWindowPoints(HWND_DESKTOP, pnotify->hwndFrom, @ht.pt, 1)
                    sendmessage(tviewprc,TVM_HITTEST,0,Cast(LPARAM,@ht))
                    if(TVHT_ONITEMSTATEICON and ht.flags) then
                        PostMessage(hWnd, UM_CHECKSTATECHANGE, 2, Cast(LPARAM,ht.hItem)) '2=tviewprc
                    end If
                ElseIf pnotify->code=NM_DBLCLK Then 'check double click then show the beginning of the selected proc in source
                	proc_loc
                ElseIf pnotify->code=TVN_KEYDOWN Then 'enter key
                	dim pnotify2 as TV_KEYDOWN Ptr =Cast(TV_KEYDOWN Ptr,lparam)
                	If pnotify2->wvkey=VK_SHIFT Then
                		proc_loc
                	EndIf
                end If
    		ElseIf LoWord(wparam)=TVIEW3 Then
    				dim pnotify as NMHDR Ptr =Cast(NMHDR Ptr,lparam)
    				dim as TVHITTESTINFO ht
                if pnotify->code=NM_CLICK then
                    dim as integer dwpos = GetMessagePos()
                    ht.pt.x = LOWORD(dwpos)
                    ht.pt.y = HIWORD(dwpos)
                    MapWindowPoints(HWND_DESKTOP, pnotify->hwndFrom, @ht.pt, 1)
                    sendmessage(tviewthd,TVM_HITTEST,0,Cast(LPARAM,@ht))
                    if(TVHT_ONITEMSTATEICON and ht.flags) then
                        PostMessage(hWnd, UM_CHECKSTATECHANGE, 3, Cast(LPARAM,ht.hItem))'3=tviewthd
                    end if
                end If    
    		ElseIf LoWord(wparam)=IDRICHWIN then
                dim pmsgfilter as MSGFILTER Ptr =Cast(MSGFILTER Ptr,lparam)
                'Dim idtempo As Integer
                if pmsgfilter->msg=WM_KEYDOWN Then
 						'SendMessage(windmain,WM_KEYDOWN,makelong(idtempo,pmsgfilter->wparam),null)
 						SendMessage(windmain,WM_KEYDOWN,pmsgfilter->wparam,null)
                ElseIf getkeystate(VK_CONTROL) And &h8000 Then
                	If pmsgfilter->msg=WM_LBUTTONUP Then 'display var in proc/var
                		var_tip(PROCVAR)
                	EndIf
                ElseIf getkeystate(VK_LMENU) And &h8000 Then 
                	If pmsgfilter->msg=WM_LBUTTONUP Then
                		var_tip(WATCHED) 'select watched var
                	EndIf
                end If
            End if
    	case UM_CHECKSTATECHANGE 'user message  not MSWindows
    			If wparam=2 Then
	        		SendMessage(tviewprc,TVM_SELECTITEM,TVGN_CARET,lparam)
            	proc_activ(Cast(HTREEITEM,lparam)) 'handle tree item
    			Else
    				SendMessage(tviewthd,TVM_SELECTITEM,TVGN_CARET,lparam)
            	thread_check(Cast(HTREEITEM,lparam)) 'thread tree item
            End if
        CASE WM_SIZE
               dim cx As Integer, cy As Integer
               cx = LOWORD (lParam)
               cy = HIWORD (lParam)
               dsp_size()
               dsp_sizecalc()
            'Case WM_SETCURSOR

               'Select Case wParam
               'Case dbgrichedit
                      'fb_message("setcursor",str(wparam))
               'End Select
    	CASE WM_CLOSE
    		Dim text As String '17/05/2013
    				If prun Then text="CAUTION PROGRAM STILL RUNNING."+chr(10)+chr(10)
                If fb_message("END OF  FBDEBUGGER",text+"Don't forget to copy your notes if any."+chr(10)+chr(10)+chr(10)+"Quit debugger ?",_ 
                MB_YESNO OR MB_ICONWARNING ) = IDYES THEN DestroyWindow (windmain)
                exit function
    	case WM_DESTROY
    			'If flaglog Then dbg_prt(" $$$$___CLOSE ALL___$$$$ ")
    			'test to avoid to suppress the watched 
    			If sourcenb<>-1 Then watch_sav:brk_sav '27/02/2013 'case exiting without stopping debuggee before
    			ini_write()
            ''''KillTimer (windmain,TimerID1) 'Clean Up Timers 'not used if 2 threads
            sendmessage(fb_hToolTip,WM_DESTROY,0,0)
            destroymenu(menuroot)
            destroymenu(menuvar)
            destroymenu(menuvar2)
            destroymenu(menuedit)
            destroymenu(menutools)
            destroymenu(menuproc)
            destroymenu(menuthread)
            destroymenu(menuwatch)
            if hfindbx then destroywindow(hfindbx)
            if hdumpbx then destroywindow(hdumpbx)
            if savebx then destroywindow(savebx)
            if helpbx then destroywindow(helpbx)
            If hindexbx Then destroywindow(hindexbx)
            If focusbx Then destroywindow(focusbx)
				If tutobx Then destroywindow(tutobx)
				
            for x=0 to 23:DeleteObject(cast(HGDIOBJ,bmb(x))):Next
            shwexp_del() 'destroy all shwexp boxes
            DeleteObject(cast(HGDIOBJ,fonthdl))
            DeleteObject(cast(HGDIOBJ,fontbold))
            DragAcceptFiles(hwnd, FALSE)
            help_manage(-1) 'to unload "hhctrl.ocx"
            PostQuitMessage 0            
            exit Function
    	Case Else
    		WndProc = DefWindowProc( hWnd, message, wParam, lParam ) 
    END SELECT
  
end Function
'=======================
Sub menu_chg(hmenu As HMENU,mitem As Integer,text As String)
	Dim newitem As MENUITEMINFO
	With newitem
	.cbSize=SizeOf(newitem)
   .fMask=MIIM_STRING
   .fType=MFT_STRING
   .fState=0
   .wID=0
   .hSubMenu=0
   .hbmpChecked=0
   .hbmpUnchecked=0
   .dwItemData=0
   .dwTypeData=StrPtr(text)
   .cch=0
	End With
	SetMenuItemInfo(hmenu,mitem,FALSE,@newitem)
End Sub
Function menu_gettxt(hmenu As HMENU,mitem As Integer) As String 'WARNING without the shortcut key text
	Dim As ZString*99 text=String(100,0)
	Dim newitem As MENUITEMINFO
	Dim As Integer p
	With newitem
	.cbSize=SizeOf(newitem)
   .fMask=MIIM_STRING
   .fType=MFT_STRING
   .fState=0
   .wID=0
   .hSubMenu=0
   .hbmpChecked=0
   .hbmpUnchecked=0
   .dwItemData=0
   .dwTypeData=@text
   .cch=99
	End With
	getMenuItemInfo(hmenu,mitem,FALSE,@newitem)
	p=InStr(text,Chr(9))
	If p Then
		text=Left(text,p-1)
	EndIf
	Return text
End Function
Sub drag_exe( hdrop As Handle)
	' The following example uses the DragQueryPoint function to determine where to begin to write text.
	' The first call to the DragQueryFile function determines the number of dropped files.
	' The loop writes the name of each file, beginning at the point returned by DragQueryPoint. 

'POINT pt;  
'WORD cFiles, a;  
'char lpszFile[80]; 
 
'DragQueryPoint((HANDLE) hdrop, &pt); 


Dim As ZString *256 filename
Dim As Integer filesnb = DragQueryFile(hdrop, &hFFFFFFFF,NULL, 0) 'nb files
	If filesnb>1 Then 
		fb_message("Drag and drop error","Select only one file")
		Exit sub
	EndIf

	DragQueryFile(hdrop, 0, filename, sizeof(filename)) 'only one file index zero
	DragFinish(hdrop)
	
	If Right(filename,4)<>".exe" And Right(filename,4)<>".bas"Then
		fb_message("Drag and drop error","Select only a .exe or .bas file")
		Exit sub
	EndIf
	treat_file(filename)
End Sub


'==============================================
Sub exrichedit(ntab As Integer)
ShowWindow(dbgrichedit,SW_HIDE)
dbgrichedit=richedit(ntab)
if dsptyp=0 or dsptyp=1 Or dsptyp=3 Then ShowWindow(dbgrichedit,SW_SHOW) 'full view or source view 
SendMessage(htab1,TCM_SETCURSEL,ntab,0) 'item
dbgsrc=source(ntab)
menu_update(IDQCKEDT,"Quick edit "+dbgsrc)
shwtab=ntab
SetFocus(dbgrichedit)
End sub
'========================
sub brk_set(t As Integer)
dim l As Integer,i As Integer,range as charrange,b As Integer,ln As integer
range.cpmin=-1 :range.cpmax=0

sendmessage(dbgrichedit,EM_exsetsel,0,Cast(LPARAM,@range)) 'deselect
l=sendmessage(dbgrichedit,EM_EXLINEFROMCHAR,0,-1) 'get line

for i=1 to linenb
	if rline(i).nu=l+1 and proc(rline(i).pr).sr=shwtab Then Exit For 'check nline 
Next
if i>linenb then fb_message("Break point Not possible","Inaccessible line (not executable)") :exit Sub
For j As Integer =1 To procnb
	If rline(i).ad=proc(j).db Then fb_message("Break point Not possible","Inaccessible line (not executable)") :exit Sub
Next
ln=i
if t=9 Then 'run to cursor 01/02/2013
    'l N°line/by 0
    if curlig=l+1 and shwtab=curtab then
        If fb_message("Run to cursor","Same line, continue ?",MB_YESNO OR MB_ICONQUESTION)=IDNO then exit sub
    end if
    brkol(0).ad=rline(ln).ad
    brkol(0).typ=2 'to clear when reached
    runtype=RTRUN
    but_enable()
    thread_rsm()
else
   for i=1 To brknb 'search if still put on this line
   	if brkol(i).nline=l+1 And brkol(i).isrc=shwtab Then Exit for
   Next
	If i>brknb Then 'not put
		If brknb=BRKMAX Then fb_message("Max of brk reached ("+str(BRKMAX)+")","Delete one and retry"):Exit sub
		brknb+=1
   	brkol(brknb).nline=l+1
   	brkol(brknb).typ=t
   	brkol(brknb).index=ln
   	brkol(brknb).isrc=shwtab
   	brkol(brknb).ad=rline(ln).ad 
   else 'still put
   	If t=3 Then 'toggle enabled/disabled
   		If brkol(i).typ>2 Then
   			brkol(i).typ-=2
   		Else
   			brkol(i).typ+=2
   		EndIf
   	elseif t=brkol(i).typ OrElse brkol(i).typ>2 Then 'cancel breakpoint
      	brk_del(i)
      	Exit Sub
   	Else 'change type of breakpoint
      	brkol(i).typ=t
      End if
	end If
	brk_color(i)
   if brknb=1 then EnableMenuItem(menuedit,IDMNGBRK,MF_ENABLED) '01/03/2013
end if
end sub
'=============================================
Sub brk_del(n As integer) 'delete one breakpoint
	brkol(n).typ=0
	brk_color(n)
	brknb-=1
	For i As Integer =n To brknb
		brkol(i)=brkol(i+1)
	Next
   If brknb=0 then EnableMenuItem(menuedit,IDMNGBRK,MF_GRAYED)
End Sub
'==================
Function brk_test(ad as uinteger) As Byte 'check on breakpoint ?
 for i as integer=0 to brknb
 	If brkol(i).typ>2 Then Continue For 'disabled 28/02/2013
 	if ad=brkol(i).ad Then 'reached line = breakpoint
 		stopcode=CSBRK
 		If i=0 Then
 			brkol(0).ad=0 'delete continue to cursor
 			stopcode=CSCURSOR
 		Else
 			if brkol(i).typ=2 then brk_del(i):stopcode=CSBRKTEMPO 'tempo breakpoint
 		End If
 		return TRUE
 	End if
 next
 return false
end Function
Sub brk_color(brk As Integer)'01/03/2013
	Dim h As hwnd=richedit(brkol(brk).isrc),l As Integer=brkol(brk).nline-1,t As Integer=brkol(brk).typ
	Dim colr As Integer,range as charrange,b As Integer
    if t then 'set 
      If t=1 then 
			colr=clrperbrk'permanent breakpoint
      ElseIf t=2 then
      	colr=clrtmpbrk'tempo breakpoint
      Else
      	colr=&hB0B0B0 'disabled 27/02/2013
      EndIf
      If l+1=curlig and brkol(brk).isrc=curtab Then colr=colr Xor clrcurline
      sel_line(l,colr,2,h,FALSE) 'purple brk+current 
    else 'reset 
		If l+1=curlig and  brkol(brk).isrc=curtab then 
		   sel_line(l,clrcurline,2,h,FALSE) 'blue
		else 
			b=rlineold:rlineold=brkol(brk).index 'hack to correctly color line
		   sel_line(l,0,1,h,FALSE) 'grey 
		   rlineold=b
		end If   
    end If
   b=sendmessage(h,EM_LINEINDEX,-1,0)'char index for line with caret 01/03/2013
   range.cpmin=b :range.cpmax=b 'caret at begining of line
   sendmessage(h,EM_exsetsel,0,Cast(LPARAM,@range))
end Sub 
'================================ 
sub brk_apply() 

'brkexe = <name>,<#line>,<typ>
Dim f As Integer =FALSE
For i As Integer =1 To BRKMAX
	Dim As String brks,fn
	Dim As Integer p,p2,ln,ty

	If brknb=BRKMAX Then Exit For 'no more breakpoint possible

	If brkexe(0,i)<>"" Then 'not empty
		brks=brkexe(0,i) 
		p=InStr(brks,",")'parsing
		fn=Left(brks,p-1) 'file name
		p2=p+1
		p=InStr(p2,brks,",")
		ln=ValInt(Mid(brks,p2,p-p2)) 'number line
		ty=ValInt(right(brks,1)) 'type
		For j As Integer =0 To sourcenb
			If name_extract(source(j))=fn Then 'name matching
				For k as integer= 1 to linenb
        			If rline(k).nu=ln andalso proc(rline(k).pr).sr=j Then 'searching index in rline
        				brknb+=1
						brkol(brknb).isrc =j
						brkol(brknb).nline=ln
						brkol(brknb).index=k
						brkol(brknb).ad   =rline(k).ad
						brkol(brknb).typ  =ty
						brk_color(brknb)
						f=TRUE 'flag for managing breakpoint
						Exit For
        			EndIf
				Next
				brkexe(0,i)="" 'used one time
				Exit For
			EndIf
		Next
	EndIf
	
Next
If f Then
	fb_MDialog(@brk_manage,"Restart debuggee, managing breakpoints",windmain,500,8,330,170)  '02/03/2013
	EnableMenuItem(menuedit,IDMNGBRK,MF_ENABLED)
EndIf

end sub 
'===========================
Sub brk_sav'27/02/2013
	For i As Integer =1 To BRKMAX
		If i<=brknb Then
			brkexe(0,i)=name_extract(source(brkol(i).isrc))+","+Str(brkol(i).nline)+","+Str(brkol(i).typ)
		'Else
		'	brkexe(0,i)="" 'last ones empty
		EndIf
	Next
End Sub
'================================
function brk_manage(byval hwnd as HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) as integer
dim rc as RECT => (0, 0, 4, 8)
dim scalex As Integer,scaley As Integer,lw As Integer
dim text as string *500
static As HWND xbut(BRKMAX+1),xbut2(BRKMAX+1),label(BRKMAX+1)
SELECT Case Msg

	CASE WM_INITDIALOG
' to test
    'SendMessage(hWnd, WM_SETICON, TRUE, _   'Set Application Icon
    '(HICON)LoadImage(0,"i.ico",IMAGE_ICON,0,0,LR_LOADFROMFILE))
      MapDialogRect (hwnd,@rc)
      ScaleX = rc.right/4
      ScaleY = rc.bottom/8
      for i As byte =1 to brknb
         text=chr(150)+chr(0)
         sendmessage(richedit(brkol(i).isrc),EM_GETLINE,brkol(i).nline-1,Cast(LPARAM,StrPtr(text)))
         label(i)=fb_Label(" "+name_extract(source(brkol(i).isrc))+" ["+str(brkol(i).nline)+"] >> "+left(Trim(text,Any Chr(9)+" "),50),hWnd,910+i,34*scalex, 3*scaley+i*20, 280*scalex, 9*scaley)

         xbut(i) =fb_BUTTON("X",hWnd,900+i, 4*scalex, 3*scaley+i*20, 10*scalex, 9*scaley)
			If brkol(i).typ>2 then text="ENB" Else text="DSB"         
         xbut2(i)=fb_BUTTON(text,hWnd,920+i,14*scalex, 3*scaley+i*20, 20*scalex, 9*scaley) '27/02/2013
      next
      fb_BUTTON("Close"      ,hWnd,940, 10*scalex, 120*scaley, 40*scalex, 12*scaley)
      fb_BUTTON("Delete all" ,hWnd,941, 70*scalex, 120*scaley, 40*scalex, 12*scaley)
      fb_BUTTON("Disable all",hWnd,942,120*scalex, 120*scaley, 40*scalex, 12*scaley)
      fb_BUTTON("Enable all" ,hWnd,943,160*scalex, 120*scaley, 40*scalex, 12*scaley)
  
	Case WM_COMMAND
    	lw=loword(wparam)
	   select case lw
	   	Case Is <901
	   		EndDialog(hWnd,0)
	   	case is <911 'delete one breakpoint
	      	lw=lw-900
	         brk_del(lw)
	         showwindow(xbut(lw),SW_HIDE)
	         showwindow(xbut2(lw),SW_HIDE)
	         showwindow(label(lw),SW_HIDE)
	         If brknb=0 then 
	            EndDialog(hWnd,0) 'no more breakpoint so close the window 
	         EndIf 
		   Case Is <921 'selectline
	      	lw=lw-910
	         exrichedit(brkol(lw).isrc)
	         sel_line(brkol(lw).nline-1)
		   Case Is <931 'enable/disable
	      	lw=lw-920
	      	If brkol(lw).typ>2 Then 
	      		brkol(lw).typ-=2
	      		setWindowText(xbut2(lw),@"DSB")
	      	Else
	      		brkol(lw).typ+=2
	      		setWindowText(xbut2(lw),@"ENB")
	      	EndIf
	      	brk_color(lw)
	   	Case 940 'close
	      	EndDialog(hWnd,0)
	   	case 941     '"Delete all" button
	        	For i As byte=1 to brknb
	         	brk_del(i)
	        	Next
	        	EndDialog(hWnd,0)
	   	case 942 'disable all
	      	For i As byte =1 to brknb
	      	   If brkol(i).typ<3 Then 
	      	   	brkol(i).typ+=2
	      	   	brk_color(i)
	      	   	setWindowText(xbut2(i),@"ENB")
	      	   EndIf
	      	Next
	   	case 943 'enable all	
	   	   For i As byte =1 to brknb
	      	   If brkol(i).typ>2 Then 
	      	   	brkol(i).typ-=2
	      	   	brk_color(i)
	      	   	setWindowText(xbut2(i),@"DSB")
	      	   EndIf
	   	   Next
	   End Select
   case WM_CLOSE
     	EndDialog(hWnd,0) 
   	Return 0 'not really used
end select
end Function
Sub bmk_tgl()
dim l As Integer,s as zstring * 259,range as charrange,itempo As Integer,idx As Integer

clear s,0,101
l=sendmessage(dbgrichedit,EM_EXLINEFROMCHAR,0,-1)+1 'get line

For i As Integer =1 To BMKMAX
	If bmk(i).ntab=shwtab AndAlso bmk(i).nline=l Then 'previously set, reset
		For j As Integer =0 To bmkcpt-1 'zero based
			If SendMessage(bmkh,CB_GETITEMDATA,j,0)=i Then 'is this index ?
				sendmessage(bmkh,CB_DELETESTRING,j,0)
				SendMessage(bmkh,CB_SETCURSEL,0,0) 'show first string
				Exit For
			EndIf
		Next
		
		bmkcpt-=1
		bmk(i).ntab=-1
		If bmkcpt=0 Then 
			EnableMenuItem(menuedit,IDNXTBMK,MF_GRAYED)
			EnableMenuItem(menuedit,IDPRVBMK,MF_GRAYED)
		EndIf
		Exit Sub
	Else
		If bmk(i).ntab=-1 Then itempo=i 'free slot
	EndIf
Next

If itempo=0 Then
	fb_message("Set bookmark","No free slot, delete one existing")
	Exit Sub
EndIf

bmk(itempo).ntab=shwtab
bmk(itempo).nline=l
s=chr(100)
sendmessage(dbgrichedit,EM_getline,l-1,Cast(LPARAM,@s))'copy max 100 bytes
s="BMK --> "+name_extract(source(shwtab))+"["+str(l)+"] "+Trim(s)
idx=SendMessage(bmkh,CB_ADDSTRING,0,Cast(LPARAM,@s)) 'add name/nline
SendMessage(bmkh,CB_SETITEMDATA,idx,Cast(LPARAM,itempo)) 'store index inside combo data

bmkcpt+=1
If bmkcpt=1 Then
	SendMessage(bmkh,CB_SETCURSEL,0,0) 'show first string
	EnableMenuItem(menuedit,IDNXTBMK,MF_ENABLED)
	EnableMenuItem(menuedit,IDPRVBMK,MF_ENABLED)
EndIf
End Sub
'============================================
Sub bmk_goto(direct As integer)
	Dim As Integer idx,nline,nltemp,b,l,f
	Dim range as charrange
	Dim As Integer  bmkidx=sendmessage(dbgrichedit,EM_EXLINEFROMCHAR,0,-1)+1 'get line
	
	If  direct Then
		nline=999999999
	Else
		nline=0
	End If
	For i As Integer = 1 To BMKMAX
		If bmk(i).ntab=shwtab Then 'same file
			nltemp=bmk(i).nline
			If direct Then 
				If nltemp>bmkidx Then 'must go forward
					If nltemp<nline Then
						nline=nltemp
					EndIf
				End if	
			Else
				If nltemp<bmkidx Then 'must go backward
					If nltemp>nline Then
						nline=nltemp
					EndIf
				EndIf
			EndIf
		EndIf
	Next
	If nline<>999999999 AndAlso nline<>0 Then
		sel_line(nline-1)
	Else
		If fb_message("Goto next/prev bookmark","End/beginning of file reached"+Chr(13)+"Do you want to move at beginning/end ?",MB_YESNO)=IDYES then
			If direct Then
				SendMessage ( dbgrichedit , EM_LINESCROLL,-500,-99999999) 'beginning
				b=sendmessage(dbgrichedit,EM_LINEINDEX,0,0)'char index for line 0
			Else
				'number of lines zero based
				b=sendmessage(dbgrichedit,EM_GETLINECOUNT,0,0)-1
				'next first visible line with filled window
				l=b-dspsize+1
				'offset with current first visible line
				f=l-SendMessage (dbgrichedit,EM_GETFIRSTVISIBLELINE,0,0)
				'scroll offset
				SendMessage ( dbgrichedit , EM_LINESCROLL,-500,f)
				 'number of lines
				b=sendmessage(dbgrichedit,EM_LINEINDEX,b,0) 'char index for last line
			EndIf
	    	range.cpmin=b :range.cpmax=b 'caret at begining of line
	    	sendmessage(dbgrichedit,EM_exsetsel,0,Cast(LPARAM,@range))
	    	setfocus(dbgrichedit)
		EndIf

	End If
End Sub
sub notes_add()
dim text as string *1000,l As Integer,range as charrange
l=sendmessage(dbgrichedit,EM_GETSELTEXT,0,Cast(LPARAM,StrPtr(text)))
'Returns the number of characters copied, not including the terminating null character
if l=0 then
   l=sendmessage(dbgrichedit,EM_EXLINEFROMCHAR,0,-1) 'get line
   text=chr(1)+chr(3)
   sendmessage(dbgrichedit,EM_getline,l,Cast(LPARAM,StrPtr(text)))
end if
text=chr(13)+chr(10)+"["+date+" "+time+"] "+text
sendmessage(dbgedit1,EM_SETSEL,0,-1) 'no return value
'nstart=0 and nend=-1 --> all the text / nstart=-1 --> remove selection
sendmessage(dbgedit1,EM_SETSEL,-1,0)
sendmessage(dbgedit1,EM_REPLACESEL,true,Cast(LPARAM,@text)) 'no return value
'flag : true-->can be undone / false -->can't be undone
end Sub
'========================================
Sub dsp_color 'change to the right color
Dim As Integer colr
	sel_line(curlig-1,clrcurline,2,richedit(curtab),false) 'current line in blue
	for i As Integer =1 to brknb
   	If brkol(i).typ=1 Then
     		colr=clrperbrk' red  breakpoint
   	ElseIf brkol(i).typ=2 Then
    		colr=clrtmpbrk ' orange tempo breakpoint
   	Else
      	colr=&hB0B0B0 'disabeld
   	EndIf
      if brkol(i).nline=curlig and brkol(i).isrc=curtab Then
      	If brkol(i).typ=1 Then
      		colr=clrcurline Xor colr ' blue and red current and breakpoint
      	ElseIf brkol(i).typ=2 then
      		colr=clrcurline Xor colr ' blue and orange current and tempo breakpoint
      	Else
      		colr=&hB0B0B0 'disabeld
      	EndIf
      EndIf
      sel_line(brkol(i).nline-1,colr,2,richedit(brkol(i).isrc),FALSE)
   Next
End Sub
'=============================================
sub dsp_change(index As Integer)
dim l as zstring *300
Dim As Integer icurold,icurlig,curold,decal,clrold,clrcur
Dim ntab As integer=proc(rline(index).pr).sr
   curold=curlig
   curlig=rline(index).nu
   icurold=false :icurlig=false
   For i As Integer =1 to brknb
      if brkol(i).nline=curold and brkol(i).isrc=shwtab Then
      	icurold=TRUE
      	If brkol(i).typ=1 Then
      		clrold=clrperbrk
      	ElseIf brkol(i).typ=2 Then '27/02/2013
      		clrold=clrtmpbrk
      	Else
      		clrold=&hB0B0B0
      	End If
      EndIf
      if brkol(i).nline=curlig and brkol(i).isrc=ntab Then
      	icurlig=TRUE
      	If brkol(i).typ=1 Then
      		clrcur=clrperbrk Xor clrcurline
      	ElseIf brkol(i).typ=2 Then '27/02/2013
      		clrcur=clrtmpbrk Xor clrcurline
      	Else	
      		clrcur=&hB0B0B0 Xor clrcurline
      	End If
      EndIf
   Next

   if icurold then
      sel_line(curold-1,clrold,2,richedit(curtab),FALSE) 'restore breakpoint red
   else
      sel_line(curold-1,0,1,richedit(curtab),FALSE) 'default color
   END If

   If ntab<>shwtab Then exrichedit(ntab)
   curtab=shwtab
   IF icurlig Then
      sel_line(curlig-1,clrcur,2) 'current line + brk purple
   Else
      sel_line(curlig-1,clrcurline,2) 'current line in blue
   end If
   '??? sendmessage(dbgrichedit ,WM_HSCROLL,SB_PAGELEFT,0)
   rlineold=index
   sendmessage(dbgrichedit,EM_GETSELTEXT,0,Cast(LPARAM,@l))   
   setWindowText(hcurline,"Current line ["+str(curlig)+"]:"+ltrim(l))
	If flagtrace And 2 Then dbg_prt(l)
   if runtype=RTAUTO Then
   	watch_array 'update adr watched dyn array
   	watch_sh    'update watched but not all the variables
   	'If tviewcur = tviewthd Then thread_text 'update
   ElseIf runtype=RTSTEP Then
      var_sh()
      dump_sh()
      but_enable()
      If tviewcur = tviewprc Then proc_sh 'update 12/12/2012
      If flagfollow=true Andalso focusbx<>0 Then  
      	sendmessage(focusbx,UM_FOCUSSRC,0,0)
      EndIf
   end If
end Sub
'================================================================
sub showcontext()
	dim vcontext as CONTEXT
	vcontext.contextflags=CONTEXT_CONTROL
	GetThreadContext(threadcontext,@vcontext)
	dbg_prt ("Ebp,Eip "+Str(threadcontext)+" "+hex(vcontext.Ebp)+" "+hex(vcontext.Eip))
	for i As integer=0 to threadnb
		GetThreadContext(thread(i).hd,@vcontext)
		dbg_prt ("Ebp,Eip "+Str(thread(i).hd)+" "+hex(vcontext.Ebp)+" "+hex(vcontext.Eip))
	next
end Sub
'================================================================
Sub sel_line(l As Integer,c As Integer=0,s As Integer=0,h As HWND=dbgrichedit,dsp As Integer=TRUE)
dim d As Integer,f As Integer,range as charrange
Dim As Integer fl,ofs,tl,nl=l+1
Static flag As Integer=0
If l=-1 Then Exit Sub 'first line no need to execute as no oldline 
d=SendMessage ( h , EM_LINEINDEX,l, 0)
f=SendMessage ( h , EM_LINEINDEX,l+1, 0)
If f-d > dspwidth Then f=d+dspwidth 'select no more than the width
range.cpmin=d :range.cpmax=f-1
SendMessage ( h , EM_exSETSEL,0,Cast(LPARAM,@range))

If dsp Then
	'if the whole file is displayed no need to decal
	tl=sendmessage(h,EM_GETLINECOUNT,0,0)
	If tl>dspsize Then
		'current first line, return zero based so +1
		fl=SendMessage (h,EM_GETFIRSTVISIBLELINE,0,0)+1
		'current line outside limits ?
		If nl<fl+dspofs orelse nl>=fl+dspsize-dspofs Then
			ofs=nl-dspofs-fl
			'ofs too big so loss of visible lines, reduce it  
			If fl+ofs>tl+1-dspsize Then ofs=tl+1-dspsize-fl
			'apply offset
			SendMessage ( h , EM_LINESCROLL,0,ofs)
		End If
	EndIf
	setfocus(h)
EndIf	
if s then fb_setcolor(h,2,c,s)

If s=1 andalso hgltflag=TRUE then
	SendMessage(h,EM_HIDESELECTION,1,0) 'no move
	for i as integer = 0 to rline(rlineold).hn-1 'number of keywords in the line
	   d=SendMessage ( h , EM_LINEINDEX,l, 0) 'begin of line
	   range.cpmin=d+hgltdata(rline(rlineold).hp+i).ps-1
	   range.cpmax=range.cpmin+hgltdata(rline(rlineold).hp+i).lg
	   SendMessage ( h , EM_exSETSEL,0,Cast(LPARAM,@range))
	   fb_setcolor(h,2,clrkeyword,3)
	Next
	range.cpmin=-1:range.cpmax=0
	sendmessage(dbgrichedit,EM_exsetsel,0,Cast(LPARAM,@range)) 'deselect
	SendMessage(h,EM_HIDESELECTION,0,0)
EndIf

end Sub

sub hglt_lines(vbeg as integer,vend as integer)
    dim as integer l,d,f,procbegin
    dim as charrange range 
    dim as HWND h=dbgrichedit
    dim as zstring  * 10000 text
    dim as string keyw=" abs access acos alias allocate append as asc asin asm atan2 atn base beep bin binary bload bsave"+_
" byval byref call callocate case cdecl chain chdir chr circle class clear close cls color com command common"+_ 
" condbroadcast condcreate conddestroy condsignal condwait cons constructor continue cos csrlin curdir cvd"+_ 
" cvi cvl cvlongint cvs cvshort data date dateadd datediff datepart dateserial datevalue day deallocate"+_ 
" declare destructor dim dir do draw dylibfree dylibload dylibsymbol dynamic else elseif encoding end endif"+_
" enum environ eof erase erfn erl ermn err error escape exec exepath exit exp explicit export extends"+_
" extern field fileattr filecopy filedatetime fileexists filelen fix flip for format frac fre freefile"+_ 
" function get getjoystick getkey getmouse gosub goto hex hour if iif imageconvertrow imagecreate $dynamic"+_
" imagedestroy imageinfo implements import inkey inp input va_arg va_first va_next delete rem lpos pos"+_
" instr instrrev int is isdate kill lbound lcase left len lib line loc local locate lock lof log loop lpos"+_
" lprint lpt lset ltrim mid minute mkd mkdir mki mkl mklongint mks mkshort month monthname multikey"+_ 
" mutexcreate mutexdestroy mutexlock mutexunlock naked name namespace next nogosub nokeyword now oct"+_ 
" on open operator option out output overload paint palette pascal pcopy peek pipe pmap point poke pos"+_
" preserve preset print private property protected pset public put random randomize read reallocate redim"+_ 
" reset restore resume return right rmdir rnd rset rtrim run scope screen screencontrol screencopy"+_ 
" screenevent screenglproc screeninfo screenlist screenlock screenptr screenres screenset screensync"+_ 
" screenunlock scrn second seek select setdate setenviron setmouse settime sgn shell sin sizeof sleep"+_ 
" space spc sqr stdcall step stick str strig sub swap system tab tan then this threadcall threadcreate"+_
" threadwait time timer timeserial timevalue to trim type typeof ubound ucase union unlock until using"+_ 
" val valint vallng valuint valulng var view wait wbin wchr weekday weekdayname wend whex while width"+_ 
" window windowtitle winput with woct write wspace wstr year any byte cast cbyte cdbl cint clng clngint"+_
" const cptr cshort csign csng cubyte cuint culng culngint cunsg cushort defbyte defdbl defint deflng"+_ 
" deflongint defshort defsng defstr defubyte defuint defulongint defushort double integer long longint"+_ 
" object pointer procptr ptr sadd shared short single static string strptr ubyte uinteger ulong ulongInt"+_
" unsigned ushort varptr wstring zstring add alpha and andalso custom eqv imp let mod not or orelse shl"+_
" shr trans xor __date__ __fb_argc__ __fb_argv__ __fb_backend__ __fb_bigendian__ __fb_build_date__"+_ 
" __fb_cygwin__ __fb_darwin__ __fb_debug__ __fb_dos__ __fb_err__ __fb_fpmode__ __fb_fpu__"+_ 
" __fb_freebsd__ __fb_lang__ __fb_linux__ __fb_main__ __fb_min_version__ __fb_mt__ __fb_netbsd__"+_
" __fb_openbsd__ __fb_option_byval__ __fb_option_dynamic__ __fb_option_escape__"+_
" __fb_option_explicit__ __fb_option_gosub__ __fb_option_private__ __fb_out_dll__ __fb_out_exe__"+_
" __fb_out_lib__ __fb_out_obj__ __fb_pcos__ __fb_signature__ __fb_sse__ __fb_unix__ $include"+_
" __fb_vectorize__ __fb_ver_major__ __fb_ver_minor__ __fb_ver_patch__ __fb_version__ __fb_win32__"+_ 
" __fb_xbox__ __file__ __file_nq__ __function__ __function_nq__ __line__ __path__ __time__ assert"+_ 
" assertwarn bit bitreset bitset defined hibyte hiword lobyte loword offsetof once rgb rgba stop" _
" #define #else #elseif #endif #endmacro #error #if #ifdef #ifndef #inclib #include #libpath #line" _
" #macro #pragma #print #undef virtual abstract" 

	 Dim ln as String
	 Dim as integer i,p,b,lgt,cptk,flagquote,cptm,cptq
	 dim as string part
    dim as tmodif modif(100)
    dim as tmodif commt(100)
    dim as tmodif quote(100)
    static as integer flagcomment
    
   For j as integer=vbeg to vend
   	h=richedit(j)
      SendMessage(h,EM_HIDESELECTION,1,0) 'no move
      
		For k As Integer =0 To sendmessage(h,EM_GETLINECOUNT,0,0)-1
			procbegin=0 '28/03/2013
			'get line text
			text=chr(1)+chr(3)
			sendmessage(h,EM_GETLINE,k,Cast(LPARAM,@text)) 'get line text
			'analyze text
    		ln=lcase(rtrim(text, any chr(13)+" "))+" " 'adding a space to simplify the algorithm
    		i=-1:p=1:b=0:lgt=len(ln)-1:cptk=0:flagquote=0:cptm=0:cptq=0

    		If flagcomment=1 then cptm=1:commt(cptm).ps=1:commt(cptm).lg=0:i=-2
    		While i<lgt
      		i+=1
      		b=ln[i]        
      		While (b=asc("(") orelse b=asc(")") orelse b=asc("=") orelse b=asc(" ") orelse b=9 orelse b=asc(":") orelse b=asc(",") orelse b=asc("[") orelse b=asc("]") orelse b=asc("<") orelse b=asc(">"))
            	i+=1:b=ln[i]:p+=1
            	If i>=lgt then exit while,while
      		Wend        
        If flagquote=0 Then
	        if b=asc("/") andalso ln[i+1]=asc("'") then
                flagcomment=1:i+=1:b=ln[i]:p+=1:cptm+=1:commt(cptm).ps=i:commt(cptm).lg=1
            endif
	        while flagcomment
	            i+=1:b=ln[i]:p+=1:commt(cptm).lg+=1
	            if ln[i]=asc("'") andalso ln[i+1]=asc("/") then i+=2:b=ln[i]:p+=2:flagcomment=0:commt(cptm).lg+=2
	            if i>=lgt then commt(cptm).lg=9999999:exit while, while
	        Wend
        End If
        if b=asc("""") then flagquote=1:cptq+=1:quote(cptq).ps=i:quote(cptq).lg=1
        while flagquote
            i+=1:b=ln[i]:p+=1:quote(cptq).lg+=1
            if ln[i]=asc("""") then
                if ln[i+1]<>asc("""") then flagquote=0:i+=1:p+=1:b=ln[i]:quote(cptq).lg+=1 else i+=2:p+=2:b=ln[i]:quote(cptq).lg+=2
            endif
            if i>=lgt then quote(cptq).lg=9999999:exit while, while
        Wend
        if b=asc("'") then 
            cptm+=1:commt(cptm).ps=p:commt(cptm).lg=9999999:exit while
        endif 
        
        while b<>asc("(") andalso b<>asc(")") andalso b<>asc("=") andalso b<>asc(" ") andalso b<>9 andalso b<>asc(":") andalso b<>asc("""") andalso b<>asc(",") andalso b<>asc("[") andalso b<>asc("]") andalso b<>asc("<") andalso b<>asc(">")
           i+=1:b=ln[i] 
        wend
      
        part=mid(ln,p,i-p+1)
        if instr(keyw," "+part+" ")<>0 Then
            cptk+=1:modif(cptk).ps=p:modif(cptk).lg=i-p+1
            If (part="sub" Orelse part="function" Orelse part="operator" Orelse part="property" Orelse part="destructor" _
             Orelse part="constructor" Orelse part="public" Orelse part="private") AndAlso cptk=1 Then procbegin=1 '28/03/2013
            if part="rem" then cptm+=1:commt(cptm).ps=p:commt(cptm).lg=9999999:exit while
        end if
        p=i+2
    		Wend
      'make changes
	   For i as integer = 1 to cptk
			d=SendMessage ( h , EM_LINEINDEX,k, 0) 'begin of line
			range.cpmin=d+modif(i).ps-1 :range.cpmax=range.cpmin+modif(i).lg
			SendMessage ( h , EM_exSETSEL,0,Cast(LPARAM,@range))
			If i=1 Andalso procbegin Then '28/03/2013
				fb_setcolor(h,2,&h0000FF,3) 'sub and function in red
			Else
				fb_setcolor(h,2,clrkeyword,3)
			EndIf
	   Next

   	If cptk Then hglt_data(k+1 ,j, modif(),cptk)

		Next
      SendMessage(h,EM_HIDESELECTION,0,0)
      SendMessage(h,EM_SETSEL,-1,0)'to remove select
      hidecaret(h)
   Next
End Sub
sub hglt_data(nline as integer,src as integer, datas() as tmodif, cptk as integer)
  
    for i as integer= 1 to linenb
        if rline(i).nu=nline andalso proc(rline(i).pr).sr=src Then
            rline(i).hn=cptk
            rline(i).hp=hgltpt+1
            for j as integer=1 to cptk
                hgltpt+=1
                hgltdata(hgltpt)=datas(j)
            next
            if hgltmax-500<hgltpt then 'near the limit
                hgltmax+=5000
                redim preserve hgltdata(hgltmax)
            EndIf
            If rline(i+1).nu<>nline Then Exit Sub 'test because same nu line for begin of proc and real executable line
        end if
    next
    'if arrived here not an executable line so no need to keep data
end sub
Sub hglt_all()
   Dim as hwnd h
if hgltflag=true then
    hgltpt=0
    hglt_lines(0,sourcenb)
Else
    for i as integer = 0 to sourcenb
        h=richedit(i)
        SendMessage(h,EM_HIDESELECTION,1,0) 'no move
            fb_setcolor(h,1,0,1)'all the text
        SendMessage(h,EM_HIDESELECTION,0,0)
    next
endif
dsp_color
End Sub
'===================== break on var ===============================================================
function brkv_test() as byte
Dim recup(20) as Integer,ptrs as pointeurs,flag as Integer=0
dim as integer adr,temp2,temp3
Dim As String strg
    ptrs.pxxx=@recup(0)
   
    if brkv.arr Then 'watching dyn array element ?
        adr=vrr(brkv.ivr).ini
        ReadProcessMemory(dbghand,Cast(LPCVOID,adr),@adr,4,0)
        if adr<>brkv.arr then brkv.adr+=brkv.arr-adr:brkv.arr=adr 'compute delta then add it if needed
        temp2=vrr(brkv.ivr).ini+8 'adr global size
        ReadProcessMemory(dbghand,Cast(LPCVOID,temp2),@temp3,4,0)
        If brkv.adr>adr+temp3 Then 'out of limit ?
            brkv_set(0) 'erase
            return false 
        End If
    End If    
    
    select case brkv.typ
    case 2 'byte
        ReadProcessMemory(dbghand,Cast(LPCVOID,brkv.adr),@recup(0),1,0)
        if brkv.val.vbyte>*ptrs.pbyte then
            if 42 and brkv.ttb then flag=1
        elseif brkv.val.vbyte<*ptrs.pbyte then
            if 37 and brkv.ttb then flag=1
        elseif brkv.val.vbyte=*ptrs.pbyte then
            if 19 and brkv.ttb then flag=1
        end if
    case 3 'ubyte
        ReadProcessMemory(dbghand,Cast(LPCVOID,brkv.adr),@recup(0),1,0)
        if brkv.val.vubyte<*ptrs.pubyte then
            if 42 and brkv.ttb then flag=1
        elseif brkv.val.vubyte>*ptrs.pubyte then
            if 37 and brkv.ttb then flag=1
        elseif brkv.val.vubyte=*ptrs.pubyte then 
            if 19 and brkv.ttb then flag=1
        end if
    case 5 'short
        ReadProcessMemory(dbghand,Cast(LPCVOID,brkv.adr),@recup(0),2,0)
        if brkv.val.vshort<*ptrs.pshort then
            if 42 and brkv.ttb then flag=1
        elseif brkv.val.vshort>*ptrs.pshort then
            if 37 and brkv.ttb then flag=1
        elseif brkv.val.vshort=*ptrs.pshort then
            if 19 and brkv.ttb then flag=1
        end if
    case 6 'ushort
        ReadProcessMemory(dbghand,Cast(LPCVOID,brkv.adr),@recup(0),2,0)
        if brkv.val.vushort<*ptrs.pushort then
            if 42 and brkv.ttb then flag=1
        elseif brkv.val.vushort>*ptrs.pushort then
            if 37 and brkv.ttb then flag=1
        elseif brkv.val.vushort=*ptrs.pushort then
            if 19 and brkv.ttb then flag=1
        end if
    case 1 'integer
        ReadProcessMemory(dbghand,Cast(LPCVOID,brkv.adr),@recup(0),4,0)
        if brkv.val.vinteger<*ptrs.pinteger then
            if 42 and brkv.ttb then flag=1
        elseif brkv.val.vinteger>*ptrs.pinteger then
            if 37 and brkv.ttb then flag=1
        elseif brkv.val.vinteger=*ptrs.pinteger then
            if 19 and brkv.ttb then flag=1
        end If
    case 8 'uinteger/pointer
        ReadProcessMemory(dbghand,Cast(LPCVOID,brkv.adr),@recup(0),4,0)
        if brkv.val.vuinteger<*ptrs.puinteger then
            if 42 and brkv.ttb then flag=1
        elseif brkv.val.vuinteger>*ptrs.puinteger then
            if 37 and brkv.ttb then flag=1
        elseif brkv.val.vuinteger=*ptrs.puinteger then
            if 19 and brkv.ttb then flag=1
        end If
    	Case 4,13,14
			if brkv.typ=13 then  ' normal string
				ReadProcessMemory(dbghand,Cast(LPCVOID,brkv.adr),@adr,4,0) 'address ptr
			Else 
				adr=brkv.adr
			end if
			clear recup(0),0,26 'max 25 char
			ReadProcessMemory(dbghand,Cast(LPCVOID,adr),@recup(0),25,0) 'value
		   strg=*ptrs.pzstring 
		   If brkv.ttb=32 then
		      if brkv.vst<>strg then flag=1
		   Else
		      if brkv.vst=strg then flag=1
		   EndIf     
    end select
if flag Then
		If brkv.ivr=0 Then stopcode=CSBRKM Else stopcode=CSBRKV
   	brkv_set(0)
      Return true
end if
return false
end Function
'===============================================================================
FUNCTION Tree_AddItem(hParent AS HTREEITEM,Text as string,hInsAfter AS HTREEITEM,hTV AS HWND) AS HTREEITEM

dim hItem AS HTREEITEM
dim tvIns AS TVINSERTSTRUCT
dim tvI   AS TV_ITEM
tvI.mask = TVIF_TEXT OR TVIF_IMAGE OR TVIF_SELECTEDIMAGE OR TVIF_PARAM
tvI.pszText         =  strptr(Text)
tvI.cchTextMax      =  LEN(Text)
tvIns.item          =  tvI
tvIns.hinsertAfter  =  hInsAfter
tvIns.hParent       =  hParent
'Pour hinsertafter soit hitem soit :
'TVI_FIRST	Inserts the item at the beginning of the list.
'TVI_LAST	Inserts the item at the end of the list.
'TVI_SORT	Inserts the item into the list in alphabetical order.

hItem = Cast(HTREEITEM,SendMessage(hTV,TVM_INSERTITEM,0,Cast(LPARAM,@tvIns)))
 ' SendMessage(htv,TVM_SORTCHILDREN ,0,byval hparent) 'Activate to sort elements
   SendMessage(htv,TVM_EXPAND,TVE_COLLAPSE,Cast(LPARAM,hparent))
  ' SendMessage(htv,TVM_EXPAND,TVE_EXPAND,hparent)
Return hItem
END FUNCTION
'==========================================
function Tree_upditem(hitem as HTREEITEM,text as string,hTV AS HWND) as Integer ' UPDATE TEXT ITEM
dim tvI AS TVITEM
tvI.mask = TVIF_TEXT
tvI.pszText         =  strptr(Text)
tvI.cchTextMax      =  LEN(Text)
tvi.hitem=hitem
Tree_upditem=SendMessage(htv,TVM_SETITEM,0,Cast(LPARAM,@tvI)) 'Returns true if successful or false otherwise
end function
'================================================
Sub menu_option(menu As HMENU,idnt As Integer,txt As String,value As Integer=0)
	Dim As String stempo=txt
	If value Then stempo+=shcut_txt(value,1)
	AppendMenu(menu, MF_STRING, idnt,StrPtr(stempo))
	shcut(shcutnb).sccur=value
	shcut(shcutnb).scmenu=menu
	shcut(shcutnb).scidnt=idnt
	shcutnb+=1
End Sub
sub menu_set
	
  menuRoot = CreateMenu()
  menuedit = CreatepopupMenu()

  menu_option(menuedit,IDCONTHR,  "Run to Cursor",VK_C)
'AppendMenu(menuedit, MFT_BITMAP,IDCONTHR, LoadImage(fb_hinstance,"buttons\step_over.bmp",IMAGE_BITMAP,19,17,LR_LOADFROMFILE))
'AppendMenu(menuedit, MFT_BITMAP,IDCONTHR, Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1001))))
  menu_option(menuedit,IDBUTSTEP,  "Next step",VK_S)
  menu_option(menuedit,IDBUTSTEPP, "Step over procs",VK_O)
  menu_option(menuedit,IDBUTSTEPM, "Step out current proc",VK_E)
  menu_option(menuedit,IDBUTSTEPT, "Step top called proc",VK_T)
  menu_option(menuedit,IDBUTSTEPB, "Step bottom current proc",VK_B)
  menu_option(menuedit,IDBUTRUN,   "Run",VK_R)
  menu_option(menuedit,IDFASTRUN,  "Fast Run",VK_F)
  menu_option(menuedit,IDBUTSTOP,  "Halt running debuggee",VK_H)
  menu_option(menuedit,IDBUTKILL,  "Kill debuggee",VK_K)
  menu_option(menuedit,IDBUTAUTO,  "Step auto",VK_A)
  menu_option(menuedit,IDTHRDAUT,  "Step auto multi threads",VK_D)
  menu_option(menuedit,IDEXEMOD,   "Modify execution",VK_M)
  AppendMenu(menuedit, MF_SEPARATOR, 0, "")
  menu_option(menuedit,IDSETBRK,   "Set/Clear Breakpoint",VK_F3)
  menu_option(menuedit,IDSETBRT,   "Set/Clear tempo Breakpoint",VSHIFT+VK_F3)
  menu_option(menuedit,IDBRKENB,   "Enable/disable Breakpoint",VCTRL+VK_F3)
  menu_option(menuedit,IDMNGBRK,   "Manage Breakpoints")
  AppendMenu(menuedit, MF_SEPARATOR, 0, "")
  AppendMenu(menuedit,MF_STRING,IDSHWVAR,   "Show var"+chr(9)+"Ctrl+Left click")
  AppendMenu(menuedit,MF_STRING,IDSETWVAR,  "Set watched var"+Chr(9)+"Alt+Left click")
  AppendMenu(menuedit, MF_SEPARATOR, 0, "")
  menu_option(menuedit,IDFNDTXT,   "Find text",VCTRL+VK_F)
  menu_option(menuedit,IDTGLBMK,   "Toogle bookmark",VCTRL+VK_F2)
  menu_option(menuedit,IDNXTBMK,   "Next bookmark",VK_F2)
  menu_option(menuedit,IDPRVBMK,   "Previous bookmark",VSHIFT+VK_F2)
  menu_option(menuedit,IDGOTO,     "Goto Line")
  menu_option(menuedit,IDLINEADR,  "Line Address")
  menu_option(menuedit,IDACCLINE,  "Mark no executable lines")
  menu_option(menuedit,IDFCSSRC,   "Focus lines",VK_L)
  AppendMenu(menuedit, MF_SEPARATOR, 0, "")
  menu_option(menuedit,IDADDNOT,   "Add Notes")

  menuvar = CreatepopupMenu()
  menuvar2 = CreatepopupMenu()
  AppendMenu(menuvar, MF_STRING Or MF_POPUP, Cast(Integer,menuvar2),"Set watched")
  menu_option(menuvar2,IDSETWTCH,"Set watched")
  menu_option(menuvar2,IDSETWTTR,"Set watched+trace")
  menu_option(menuvar,IDVARBRK, "Break on var value")
  AppendMenu(menuvar, MF_SEPARATOR, 0, "")
  menu_option(menuvar,IDSELIDX, "Select index")
  menu_option(menuvar,IDVARDMP, "Variable Dump")
  menu_option(menuvar,IDVAREDT, "Edit var value")
  menu_option(menuvar,IDSHWEXP, "Show/expand variable")
  menu_option(menuvar,IDSHSTRG, "Show z/w/string")
  menu_option(menuvar,IDCHGZSTR,"Change byte<>zstring type")
  AppendMenu(menuvar, MF_SEPARATOR, 0, "")
  menu_option(menuvar,IDLOCPRC, "Locate proc in source")
  menu_option(menuvar,IDCALLINE,"Locate calling line")
  menu_option(menuvar,IDVCLPSE, "Collapse proc/var")
  menu_option(menuvar,IDVEXPND, "Expand proc/var")
  menu_option(menuvar,IDLSTVARA, "List all proc/var (log)")  
  menu_option(menuvar,IDLSTVARS, "List selected proc/var (log)")
  
  menuwatch = CreatepopupMenu()
  menu_option(menuwatch,IDWCHVAR, "Show in var window")
  menu_option(menuwatch,IDWCHEDT, "Edit value")
  menu_option(menuwatch,IDWCHDMP, "Memory Dump")
  menu_option(menuwatch,IDWCHSHW, "Show/expand variable")
  menu_option(menuwatch,IDWCHSTG, "Show z/w/string")
  AppendMenu(menuwatch, MF_SEPARATOR, 0, "")
  menu_option(menuwatch,IDWCHTTGL,"Toggle Tracing")
  menu_option(menuwatch,IDWCHTTGA,"Cancel all Tracing")
  AppendMenu(menuwatch, MF_SEPARATOR, 0, "")
  menu_option(menuwatch,IDSTWTCH1,"Switch watch 1")
  menu_option(menuwatch,IDSTWTCH2,"Switch watch 2")
  menu_option(menuwatch,IDSTWTCH3,"Switch watch 3")
  menu_option(menuwatch,IDSTWTCH4,"Switch watch 4")
  AppendMenu(menuwatch, MF_SEPARATOR, 0, "")
  menu_option(menuwatch,IDWCHDEL,"Delete")
  menu_option(menuwatch,IDWCHDALL,"Delete all")
  
  menuproc = CreatePopupMenu()
  menu_option(menuproc,IDLOCPRC, "Locate proc in source")
  menu_option(menuproc,IDSORTPRC,"Toogle sort by module or by proc") '17/05/2013
  AppendMenu(menuproc, MF_SEPARATOR, 0, "")
  menu_option(menuproc,IDRSTPRC, "&All procs followed")
  menu_option(menuproc,IDSETPRC, "&No proc followed")
  

  menuthread = CreatepopupMenu()
  menu_option(menuthread,IDTHRDCHG, "Select next thread to be executed")
  menu_option(menuthread,IDEXCLINE, "Show next executed line (source)")
  menu_option(menuthread,IDCREATHR, "Show line creating thread (source)")
  menu_option(menuthread,IDLOCPRC,  "Show first proc of thread (source)")
  menu_option(menuthread,IDSHWPROC, "Show proc (proc/var)")
  menu_option(menuthread,IDSHPRSRC, "Show proc (source)")
  menu_option(menuthread,IDPRCRADR, "Addresses about proc")
  menu_option(menuthread,IDTHRDKLL, "Kill thread")
  menu_option(menuthread,IDTHRDEXP, "Expand one thread")'14/12/2012
  menu_option(menuthread,IDTHRDCOL, "Collapse all threads")
  menu_option(menuthread,IDTHRDLST, "List all threads")

  menutools = CreatepopupMenu()
  menu_option(menutools,IDCMDLPRM, "Settings")
  menu_option(menutools,IDABOUT,   "About")
  menu_option(menutools,IDCMPINF,  "Compile info")
  menu_option(menutools,IDDBGHELP, "Help",VK_F1)
  menu_option(menutools,IDTUTO,    "Launch tutorial")
  AppendMenu(menutools, MF_SEPARATOR, 0, "")
  menu_option(menutools,IDFILEIDE, "Launch IDE",VK_F10)'"F10"
  menu_option(menutools,IDQCKEDT,  "Quick edit",VK_F11)'"F11"
  menu_option(menutools,IDCMPNRUN, "Compile (-g) and debug",VK_F9)'"F9"
  menu_option(menutools,IDCLIPBRD, "Copy notes to clipboard")
  menu_option(menutools,IDSHWLOG,  "Show log file")
  menu_option(menutools,IDHIDLOG,  "Hide log file") '09/06/2013
  menu_option(menutools,IDDELLOG,  "Delete log file")
  menu_option(menutools,IDSHENUM,  "List enum")
  AppendMenu(menutools, MF_SEPARATOR, 0, "")
  menu_option(menutools,IDINFOS,  "Process list")
  menu_option(menutools,IDLSTDLL, "Dlls list")
  menu_option(menutools,IDLSTSHC, "Shortcut keys list")
  menu_option(menutools,IDWINMSG, "Translate Win Message")
  menu_option(menutools,IDSHWBDH, "Bin/Dec/Hex")
  menu_option(menutools,IDFRTIMER,"Show fast run timer")
  menu_option(menutools,IDJITDBG, "Set JIT Debugger")
 
' Attach menu items to main menu
  AppendMenu(menuRoot,MF_POPUP, Cast(UInteger,menuedit),"Not seen")
'  InsertMenu(dbgmnuRoot, 0, MF_POPUP, menuvar,"")
end sub
'==============================================
function WinMain ( byval hInstance as HINSTANCE, _
                   byval hPrevInstance as integer, _
                   szCmdLine as string, _
                   byval iCmdShow as integer ) as integer    
     
     dim wMsg as MSG
     dim wcls as WNDCLASS     

     dim hWnd as unsigned integer

     
     WinMain = 0
     
     ''
     '' Setup window class
     ''
     fb_hinstance=hinstance
     with wcls
     	.style         = CS_HREDRAW or CS_VREDRAW
     	.lpfnWndProc   = Cast(WndProc,@WndProc)
     	.cbClsExtra    = 0
     	.cbWndExtra    = 0
     	.hInstance     = hInstance
     	.hIcon         = LoadIcon( hInstance,MAKEINTRESOURCE(1))'LoadIcon( null, byval IDI_APPLICATION )
     	.hCursor       = LoadCursor( null, byval IDC_ARROW )
     	.hbrBackground = GetStockObject( WHITE_BRUSH )
     	.lpszMenuName  = null
     	.lpszClassName = strptr( fb_szAppName )
     end with
     
     
     ''
     '' Register the window class     
     ''     
     if ( RegisterClass( @wcls ) = false ) then
        MessageBox null, "Failed to register the window class", fb_szAppName, MB_ICONERROR               
        exit function
    end if
    ' -----------------------------------------------
   dim iccex as INITCOMMONCONTROLSEX 
   iccex.dwSize = len(INITCOMMONCONTROLSEX)
   iccex.dwICC = _
             ICC_LISTVIEW_CLASSES or ICC_TREEVIEW_CLASSES or ICC_BAR_CLASSES _
             or ICC_TAB_CLASSES or ICC_UPDOWN_CLASS or ICC_PROGRESS_CLASS _
             or ICC_USEREX_CLASSES or ICC_DATE_CLASSES
   InitCommonControlsEx(@iccex)
        
' --------------- call FB_WIN() for initialisation ------------------
   Fb_win() 'create window, etc
' --------------------------------------------------------------------------------
    '' Process windows messages
   while ( GetMessage( @wMsg, null, 0, 0 ) <> false )    
      dim hActiveWindow as HWND
      hActiveWindow = GetActiveWindow()
      if (IsWindow(hActiveWindow)=0) or (IsDialogMessage(hActiveWindow,@wMsg)=0) then
        TranslateMessage @wMsg
        DispatchMessage  @wMsg
    end if
    wend

    WinMain = wMsg.wParam
end function
'=======================================================
Sub dump_set(hWnd as HWND)
  DIM lvCol   AS LVCOLUMN,lvItem  AS LVITEM
  DIM i       AS integer
  dim as rect recbox
  dim tmp as string,delta As Integer,lg As Integer
for i=lvnbcol+1 to 0 step -1
    sendmessage(hwnd,LVM_DELETECOLUMN,i,0)
next      
select case lvtyp
  case 2,3  'byte/ubyte       sng/usng dec/hex
      lvnbcol=16 :lg=34
  case 5,6  'short/ushort
      lvnbcol=8 :lg=50
	case 1,8,7  'integer/uinteger
      lvnbcol=4 :lg=80
  case 9,10  'longinteger/ulonginteger
      lvnbcol=2 :lg=140
  case 11 'single
      lvnbcol=4 :lg=100
  case 12 'double
      lvnbcol=2 :lg=160
end select
  
  lvCol.mask      =  LVCF_FMT OR LVCF_WIDTH OR LVCF_TEXT OR LVCF_SUBITEM
  lvCol.fmt       =  LVCFMT_LEFT
  lvcol.cx=0
  lvItem.mask     =  LVIF_TEXT

  lvCol.pszText   = strptr("ADDRESS")
  lvCol.iSubItem  = 0
  sendmessage(hwnd,LVM_INSERTCOLUMN,0,Cast(LPARAM,@lvCol))
  'LVSCW_AUTOSIZE_USEHEADER = -2 ou AUTOSIZE= -1)
  sendmessage(hwnd,LVM_SETCOLUMNWIDTH,0,75)
  
delta=16/lvnbcol
for i=1 to lvnbcol 'nb colonnes
 tmp="+"+right("0"+str(delta*(i-1)),2)
 lvCol.pszText   = strptr(tmp)
 lvCol.iSubItem  =  i
 sendmessage(hwnd,LVM_INSERTCOLUMN,i,Cast(LPARAM,@lvCol))
 sendmessage(hwnd,LVM_SETCOLUMNWIDTH,i,lg)
next
 tmp="ASCII"
 lvCol.pszText   = strptr(tmp)
 lvCol.iSubItem  =  lvnbcol+1   '17
sendmessage(hwnd,LVM_INSERTCOLUMN,lvnbcol+1,Cast(LPARAM,@lvCol))
sendmessage(hwnd,LVM_SETCOLUMNWIDTH,lvnbcol+1,125)
''''to avoid display update every update
  'SendMessage(hwnd, WM_SETREDRAW, FALSE, 0)
  
'   sendmessage(hwnd,LVM_SETCOLUMNWIDTH,lvnbcol+1,LVSCW_AUTOSIZE)'_USEHEADER)
'====================================================================
 sendmessage(hwnd,LVM_SETTEXTCOLOR,0,RGB(128,0,0))
 'sendmessage(hwnd,LVM_SETTEXTBKCOLOR,0,RGB(0,128,0))
 'sendmessage(hwnd,LVM_SETBKCOLOR,0,RGB(0,0,128))
'  InvalidateRect(hWnd,0,1)

'recreate dump_box to take in account new parameters
if hdumpbx then 
    GetWindowRect(hdumpbx,@recbox):destroywindow(hdumpbx)
    fb_Dialog(@dump_box,"Manage dump",windmain,283,250,100,70,WS_POPUP or WS_SYSMENU or ws_border or WS_CAPTION)
    SetWindowPos(hdumpbx,NULL,recbox.left,recbox.top,0,0,SWP_NOACTIVATE Or SWP_NOZORDER OR SWP_NOSIZE Or SWP_SHOWWINDOW)
End if
END SUB
'================================
sub start_pgm(p As Any ptr) 
    Dim  As Integer pclass,st
    dim  as string workdir,cmdl
    Dim sinfo As STARTUPINFO    
    'directory
    st=0
    while instr(st+1,exename,"\")
       st=instr(st+1,exename,"\")
    wend
    workdir=Left(exename,st)
    cmdl=""""+exename+""" "+cmdexe(0)
   #Ifdef fulldbg_prt
   	dbg_prt ("Start Debug with "+cmdl)
   #EndIf
   sinfo.cb = Len(sinfo)
'Set the flags
   sinfo.dwFlags = STARTF_USESHOWWINDOW
'Set the window's startup position
   sinfo.wShowWindow = SW_NORMAL
'Set the priority class
   pclass = NORMAL_PRIORITY_CLASS or CREATE_NEW_CONSOLE or DEBUG_PROCESS or DEBUG_ONLY_THIS_PROCESS
'Start the program
   If CreateProcess(exename,strptr(cmdl),byval null,byval null, False, pclass, _
   NULL, WorkDir, @sinfo, @pinfo) Then
		'Wait
		WaitForSingleObject pinfo.hProcess, 10
		dbgprocId=pinfo.dwProcessId
		dbgthreadID=pinfo.dwThreadId
		dbghand=pinfo.hProcess
		dbghthread=pinfo.hThread
      #Ifdef fulldbg_prt
        dbg_prt ("Create process")
        dbg_prt ("pinfo.hThread "+Str(pinfo.hThread))
        dbg_prt ("pinfo.dwThreadId "+Str(pinfo.dwThreadId))
        dbg_prt ("hand "+Str(dbghand)+" Pid "+Str(dbgprocid))
      #endif  
      prun=TRUE
      runtype=RTSTEP
      wait_debug
   Else
      fb_message("PROBLEM","no debugged pgm -->"+exename+chr(10)+"error :"+str(GetLastError()),MB_ICONERROR or MB_SYSTEMMODAL)
   End If
End sub
'===========================
sub frground()
dim Proc As Integer,Nous As Integer,timeout As Integer
'SPI_GETFOREGROUNDLOCKTIMEOUT = 0x2000
'SPI_SETFOREGROUNDLOCKTIMEOUT = 0x2001
''''''' messagebeep(MB_ICONASTERISK)
SetForegroundWindow(windmain)
FlashWindow(windmain,true)
Return

Proc=GetWindowThreadProcessId(GetForeGroundWindow,0)
Nous=GetCurrentThreadID
If Proc<>Nous Then
'    fbdebugger not in foreground
    SystemParametersInfo(&h2000,0,@timeout,0)
    SystemParametersInfo(&h2001,0,0,SPIF_SENDWININICHANGE or SPIF_UPDATEINIFILE)
    SetForegroundWindow(windmain)
    SystemParametersInfo(&h2001,0,Cast(PVOID,timeout),SPIF_SENDWININICHANGE or SPIF_UPDATEINIFILE)
Else
    'already
    SetForegroundWindow(windmain)
End if
end sub
'=================================================
sub but_enable()
	Dim l as zstring *300
   Select case runtype
    	Case RTSTEP 'wait
			EnableWindow(butstep,TRUE)
			EnableWindow(butstepp,TRUE)
			EnableWindow(butstept,TRUE)
			EnableWindow(butstepb,TRUE)
			EnableWindow(butstepm,TRUE)
			EnableWindow(butauto,TRUE)
			EnableWindow(butrun,TRUE)
			EnableWindow(butfastrun,TRUE)
			EnableWindow(butstop,TRUE)
			EnableWindow(butcont,TRUE)
			EnableWindow(butfree,TRUE)
			EnableWindow(butkill,TRUE)
			EnableWindow(butexemod,TRUE)
			EnableWindow(butmini,TRUE)
         l="Waiting "+stoplibel(stopcode)
			SendMessage(dbgstatus,SB_SETTEXT,0,Cast(LPARAM,@l))
			l="Thread "+Str(thread(threadcur).id)
			SendMessage(dbgstatus,SB_SETTEXT,1,Cast(LPARAM,@l))
			l=name_extract(source(proc(procsv).sr))
			SendMessage(dbgstatus,SB_SETTEXT,2,Cast(LPARAM,@l))
			SendMessage(dbgstatus,SB_SETTEXT,3,Cast(LPARAM,StrPtr(proc(procsv).nm)))
			frground()
   	case RTRUN,RTFREE,RTFRUN 'step over / out / free / run / fast run
			EnableWindow(butstep,FALSE)
			EnableWindow(butstepp,FALSE)
			EnableWindow(butstept,FALSE)
			EnableWindow(butstepb,FALSE)
			EnableWindow(butstepm,FALSE)
			EnableWindow(butauto,FALSE)
			EnableWindow(butrun,FALSE)
			EnableWindow(butfastrun,FALSE)
			EnableWindow(butcont,FALSE)
			EnableWindow(butfree,FALSE)
			EnableWindow(butkill,FALSE)
			EnableWindow(butexemod,FALSE)
			Select Case runtype
				Case RTRUN
					SendMessage(dbgstatus,SB_SETTEXT,0,Cast(LPARAM,@"Running"))
				Case RTFRUN
					SendMessage(dbgstatus,SB_SETTEXT,0,Cast(LPARAM,@"FAST Running"))
				Case Else
					SendMessage(dbgstatus,SB_SETTEXT,0,Cast(LPARAM,@"Released"))
			End Select
    	case RTAUTO 'auto
			EnableWindow(butstep,FALSE)
			EnableWindow(butstepp,FALSE)
			EnableWindow(butstept,FALSE)
			EnableWindow(butstepb,FALSE)
			EnableWindow(butstepm,FALSE)
			EnableWindow(butauto,FALSE)
			EnableWindow(butrun,FALSE)
			EnableWindow(butfastrun,FALSE)
			EnableWindow(butcont,FALSE)
			EnableWindow(butfree,FALSE)
			EnableWindow(butkill,FALSE)
			EnableWindow(butexemod,FALSE)
      	SendMessage(dbgstatus,SB_SETTEXT,0,Cast(LPARAM,@"Auto"))
   	case else 'prun=false --> terminated or no pgm
			EnableWindow(butstep,FALSE)
			EnableWindow(butstepp,FALSE)
			EnableWindow(butstept,FALSE)
			EnableWindow(butstepb,FALSE)
			EnableWindow(butstepm,FALSE)
			EnableWindow(butauto,FALSE)
			EnableWindow(butrun,FALSE)
			EnableWindow(butfastrun,FALSE)
			EnableWindow(butstop,FALSE)
			EnableWindow(butcont,FALSE)
			EnableWindow(butfree,FALSE)
			EnableWindow(butkill,FALSE)
			EnableWindow(butexemod,FALSE)
    	  	If runtype=RTEND Then SendMessage(dbgstatus,SB_SETTEXT,0,Cast(LPARAM,@"Terminated"))
         enablewindow(butmini,FALSE)  
    end select
end sub
'=================================================
sub menu_enable()
'MF_DISABLED MF_ENABLED MF_GRAYED
dim flag As Integer
if prun then flag=MF_ENABLED else flag=MF_GRAYED

EnableMenuItem(menuedit,IDSETBRK,  flag)
EnableMenuItem(menuedit,IDSETBRT,  flag)
EnableMenuItem(menuedit,IDBRKENB,  flag)'01/03/2013
EnableMenuItem(menuedit,IDCONTHR,  flag)
EnableMenuItem(menuedit,IDBUTSTEP, flag)
EnableMenuItem(menuedit,IDBUTSTEPP,flag)
EnableMenuItem(menuedit,IDBUTSTEPM,flag)
EnableMenuItem(menuedit,IDBUTSTEPB,flag)
EnableMenuItem(menuedit,IDBUTSTEPT,flag)
EnableMenuItem(menuedit,IDBUTRUN,  flag)
EnableMenuItem(menuedit,IDEXEMOD,  flag)
EnableMenuItem(menuedit,IDFASTRUN, flag)
EnableMenuItem(menuedit,IDBUTKILL,  flag)
EnableMenuItem(menuedit,IDBUTSTOP, flag)
EnableMenuItem(menuedit,IDBUTAUTO, flag)
EnableMenuItem(menuedit,IDTHRDAUT, flag)
EnableMenuItem(menuedit,IDSHWVAR,  flag)
EnableMenuItem(menuedit,IDSETWVAR, flag)
EnableMenuItem(menuedit,IDLINEADR, flag)
EnableMenuItem(menutools,IDLSTDLL, flag)
EnableMenuItem(menuvar,0, flag Or MF_BYPOSITION)
EnableMenuItem(menuvar,IDSELIDX,  flag)
EnableMenuItem(menuvar,IDVARDMP,  flag)
EnableMenuItem(menuvar,IDVAREDT,  flag)
EnableMenuItem(menuvar,IDSHWEXP,  flag)
EnableMenuItem(menuvar,IDVARBRK,  flag)
EnableMenuItem(menuvar,IDSHSTRG,  flag)
EnableMenuItem(menuvar,IDCHGZSTR, flag)
EnableMenuItem(menuvar,IDLSTVARA, flag)
EnableMenuItem(menuvar,IDLSTVARS, flag)

EnableMenuItem(menuthread,IDTHRDCHG,flag)
EnableMenuItem(menuthread,IDTHRDKLL,flag)
EnableMenuItem(menuthread,IDEXCLINE,flag)
EnableMenuItem(menuthread,IDCREATHR,flag)
EnableMenuItem(menuthread,IDTHRDEXP,flag) '14/12/2012
EnableMenuItem(menuthread,IDTHRDCOL,flag)
EnableMenuItem(menuthread,IDLOCPRC, flag)
EnableMenuItem(menuthread,IDSHWPROC,flag)
EnableMenuItem(menuthread,IDSHPRSRC,flag)
EnableMenuItem(menuthread,IDPRCRADR,flag)
EnableMenuItem(menuthread,IDTHRDLST,flag)
If wtchcpt Andalso prun Then flag=MF_ENABLED else flag=MF_GRAYED
EnableMenuItem(menuwatch,IDSTWTCH1,flag)
EnableMenuItem(menuwatch,IDSTWTCH2,flag)
EnableMenuItem(menuwatch,IDSTWTCH3,flag)
EnableMenuItem(menuwatch,IDSTWTCH4,flag)
EnableMenuItem(menuwatch,IDWCHVAR,flag)
EnableMenuItem(menuwatch,IDWCHDMP,flag)
EnableMenuItem(menuwatch,IDWCHSHW,flag)
EnableMenuItem(menuwatch,IDWCHSTG,flag)
EnableMenuItem(menuwatch,IDWCHDEL,flag)
EnableMenuItem(menuwatch,IDWCHDALL,flag)
EnableMenuItem(menuwatch,IDWCHEDT,flag)
EnableMenuItem(menuwatch,IDWCHTTGL,flag)
EnableMenuItem(menuwatch,IDWCHTTGA,flag)

If procnb Then flag=MF_ENABLED
EnableMenuItem(menuproc,IDRSTPRC,flag)
EnableMenuItem(menuproc,IDSETPRC,flag)
EnableMenuItem(menuproc,IDLOCPRC,flag)
EnableMenuItem(menuproc,IDSORTPRC,flag) '17/05/2013

EnableMenuItem(menuvar,IDLOCPRC,flag)
EnableMenuItem(menuvar,IDCALLINE,flag)
EnableMenuItem(menuvar,IDVCLPSE,flag)
EnableMenuItem(menuvar,IDVEXPND,flag)
		
If brknb then
   EnableMenuItem(menuedit,IDMNGBRK,MF_ENABLED)
else
   EnableMenuItem(menuedit,IDMNGBRK,MF_GRAYED)
EndIf

End sub
'=================================================
sub dsp_hide(t As Integer)

if dsptyp=0 Then 'enlarge or notes
	dsptyp=t
	ShowWindow(butenlrsrc,SW_HIDE)
	ShowWindow(butenlrvar,SW_HIDE)
	ShowWindow(butenlrmem,SW_HIDE)
	If t<>3 then 'notes
	  ShowWindow(htab1,SW_HIDE)
	  ShowWindow(htab2,SW_HIDE)
	  ShowWindow(dbgrichedit,SW_HIDE)
	  ShowWindow(tviewcur,SW_HIDE)
	End If
   ShowWindow(bmkh,SW_HIDE)
   ShowWindow(listview1,SW_HIDE)
   ShowWindow(brkvhnd,SW_HIDE)
   For i As Integer =0 to WTCHMAIN:ShowWindow(wtch(i).hnd,SW_HIDE):Next
   dsp_size()
	Select case t 
		Case 1 'source
			ShowWindow(dbgrichedit,SW_SHOW)	
			ShowWindow(htab1,SW_SHOW)
			ShowWindow(butenlrsrc,SW_SHOW)
		Case 2 'var
		 	ShowWindow(htab2,SW_SHOW)
        	ShowWindow(tviewcur,SW_SHOW)
			ShowWindow(butenlrvar,SW_SHOW)
		case 3 'notes
			ShowWindow(dbgedit1,SW_SHOW)
			setfocus(dbgedit1)
		Case 4 'dump
			ShowWindow(listview1,SW_SHOW)
			ShowWindow(butenlrmem,SW_SHOW)
	End Select
Else 'normal display
		dsptyp=0
		dsp_size()
	   select case t
	   	case 1 'src
	   	case 2'var
	   	case 3 'notes
				ShowWindow(dbgEdit1,SW_HIDE)
	   	case 4 'dump
	   end Select
	   ShowWindow(butenlrsrc,SW_SHOW)
		ShowWindow(butenlrvar,SW_SHOW)
		ShowWindow(butenlrmem,SW_SHOW)
		ShowWindow(htab1,SW_SHOW)
		ShowWindow(htab2,SW_SHOW)
		ShowWindow(dbgrichedit,SW_SHOW)
		setfocus(dbgrichedit)
		ShowWindow(tviewcur,SW_SHOW)
		ShowWindow(listview1,SW_SHOW)
		ShowWindow(bmkh,SW_SHOW)
		ShowWindow(brkvhnd,SW_SHOW)
		for i As Integer =0 to WTCHMAIN:ShowWindow(wtch(i).hnd,SW_SHOW):Next
Endif
end sub
'==========================================================
sub proc_expcol(v As Integer)
	for j As Integer =0 to procrnb
		SendMessage(tviewvar,TVM_EXPAND,v,Cast(LPARAM,procr(j).tv))
	Next
end sub
'==========================================================
Function var_parent(child As HTREEITEM) As Integer 'find var master parent
	Dim As HTREEITEM temp,temp2,hitemp
	temp=child
	Do
		hitemp=temp2
		temp2=temp
		temp=Cast(HTREEITEM,SendMessage(tviewvar,TVM_GETNEXTITEM,TVGN_PARENT,Cast(LPARAM,temp)))
	Loop While temp
for i as integer =1 to vrrnb
    if vrr(i).tv=hitemp Then return i
Next
End Function
'==========================================================
function var_find() as Integer 'return NULL if error
dim hitem as integer
'get current hitem in tree
hitem=sendmessage(tviewvar,TVM_GETNEXTITEM,TVGN_CARET,null)

for i As Integer = 1 To vrrnb 'search index variable
	if vrr(i).tv=hitem Then 
		If vrr(i).ad=0 Then fb_message("Variable selection error","Dynamic array not yet sized !!"):return 0
		If vrr(i).vr<0 Then
			Return -i
		Else
			Return i
		EndIf
	End if   	
next
fb_message("Variable selection error","Select only a variable")
return 0
end Function
Sub var_fill(i As Integer)
If vrr(i).vr<0 Then
    varfind.ty=cudt(-vrr(i).vr).Typ
    varfind.pt=cudt(-vrr(i).vr).pt
    varfind.nm=cudt(-vrr(i).vr).nm
    varfind.pr=vrr(var_parent(vrr(i).tv)).vr'index of the vrb
Else
    varfind.ty=vrb(vrr(i).vr).Typ
    varfind.pt=vrb(vrr(i).vr).pt
    varfind.nm=vrb(vrr(i).vr).nm
    varfind.pr=vrr(i).vr 'no parent so himself, index of the vrb
end if
varfind.ad=vrr(i).ad
varfind.iv=i
varfind.tv=tviewvar  'handle treeview
varfind.tl=vrr(i).tv 'handle line
End Sub

function var_find2(tv as HWND) as Integer 'return -1 if error
dim hitem as HTREEITEM,idx As Integer
if tv=tviewvar then
    'get current hitem in tree
    hitem=Cast(HTREEITEM,sendmessage(tviewvar,TVM_GETNEXTITEM,TVGN_CARET,null))
    for i As Integer = 1 To vrrnb 'search index variable
        if vrr(i).tv=hitem Then 
            If vrr(i).ad=0 Then fb_message("Variable selection error","Dynamic array not yet sized !!"):return -1
				var_fill(i)
            Return i
        End if           
    next
    fb_message("Variable selection error","Select only a variable")
    return -1
Elseif tv=tviewwch Then
	idx=watch_find()
	If wtch(idx).psk=-3 Orelse wtch(idx).psk=-4 then Return -1 'case non-existent local
	If wtch(idx).adr=0 Then Return -1 'dyn array 
	varfind.nm=Left(wtch(idx).lbl,Len(wtch(idx).lbl)-1)
   varfind.ty=wtch(idx).typ
   varfind.pt=wtch(idx).pnt
   varfind.ad=wtch(idx).adr
   varfind.tv=tviewwch 'handle treeview
   varfind.tl=wtch(idx).tvl 'handle line
   varfind.iv=wtch(idx).ivr
Else'shw/expand tree
   For idx =1 to SHWEXPMAX
		If shwexp(idx).tv=tv Then Exit For 'found index matching tview
   Next 
   'get current hitem in tree
   hitem=Cast(HTREEITEM,sendmessage(tv,TVM_GETNEXTITEM,TVGN_CARET,null))
    for i As Integer = 1 To shwexp(idx).nb 'search index variable
        if vrp(idx,i).tl=hitem Then
        		varfind.nm=vrp(idx,i).nm
        		If varfind.nm="" Then varfind.nm="<Memory>"
            varfind.ty=vrp(idx,i).Ty
            varfind.pt=vrp(idx,i).pt
            varfind.ad=vrp(idx,i).ad
            varfind.tv=tv 'handle treeview
            varfind.tl=hitem 'handle line
            varfind.iv=-1
            Return i
        end if
    Next
End if
end Function
'==========================================
sub watch_set()
If wtchcpt>WTCHMAX Then ' free slot not found
	' change focus
	ShowWindow(tviewcur,SW_HIDE)
	tviewcur=tviewwch
   ShowWindow(tviewcur,SW_SHOW)
   SetFocus(tviewcur)
   SendMessage(htab2,TCM_SETCURSEL,3,0)
   fb_message("Add watched variable","No free slot, delete one")
	Exit Sub
EndIf
'Already set ?
For i As Integer =0 To WTCHMAX
	If wtch(i).psk<>-1 AndAlso wtch(i).adr=varfind.ad Andalso wtch(i).typ=varfind.ty AndAlso _
		wtch(i).pnt=varfind.pt Then'found
		'If fb_message("Set watched variable/memory","Already existing"+Chr(13)+"Continue ?", _
		'MB_YESNO or MB_ICONQUESTION or MB_DEFBUTTON1) = IDNO Then exit sub 
		wtchidx=i'for delete
		fb_mdialog(@watch_box,"Adding watched : "+Left(wtch(i).lbl,Len(wtch(i).lbl)-1)+" already existing",windmain,50,25,180,90)
		Exit sub
	EndIf
Next
watch_add(0)'first create no additional type
End sub
Sub watch_add(f As integer,r as integer =-1) 'if r<>-1 session watched, return index
	Dim As Integer t
	Dim As String temps,temps2
    if r=-1 then
        'Find first free slot
        For i As Integer =0 To WTCHMAX
            If wtch(i).psk=-1 Then t=i:exit For 'found
        Next
        wtchcpt+=1
        If wtchcpt=1 Then menu_enable 'enable the context menu for the watched window
    else
        t=r
    end if

	wtch(t).typ=varfind.ty
	wtch(t).pnt=varfind.pt
	wtch(t).adr=varfind.ad
	wtch(t).arr=0
	wtch(t).tad=f
	
If varfind.iv=-1 Then 'memory from dump_box or shw/expand
	wtch(t).lbl=varfind.nm
	wtch(t).psk=-2
	wtch(t).ivr=0
Else 'variable
	wtch(t).ivr=varfind.iv
	' if dyn array store real adr
	If vrb(varfind.pr).arr=-1 Then
	   ReadProcessMemory(dbghand,Cast(LPCVOID,vrr(varfind.iv).ini),@wtch(t).arr,4,0)
	End If

	for j As uInteger = 1  To procrnb 'find proc to delete watching
   	if varfind.iv>=procr(j).vr and varfind.iv<procr(j+1).vr Then
   		wtch(t).psk=procr(j).sk
   		wtch(t).idx=procr(j).idx 'data for reactivating watch 
   		wtch(t).dlt=wtch(t).adr-wtch(t).psk
   		temps=var_sh1(varfind.iv)
         If procr(j).idx=0 Then 'dll
	         For k As Integer =1 To dllnb
	         	If dlldata(k).bse=procr(j).sk Then
	         		temps2=dll_name(dlldata(k).hdl,2)
	         		Exit For
	         	EndIf
	         Next
         Else   
	      	temps2=proc(procr(j).idx).nm
         End If
         wtch(t).lbl="  "+temps2+"/"+Left(temps,InStr(temps,"/")+1)
         If vrb(varfind.pr).mem=3 Then
             wtch(t).psk=procr(1).sk 'static
         end if
         Exit for
   	EndIf
	Next
'fill wtch vnm, vty, var - component/var bottom to top
	Dim As HTREEITEM temp,temp2,hitemp
   Dim as integer iparent,c=0
   iparent=wtch(t).ivr
 	Do
     	If vrr(iparent).vr>0 Then
         c+=1
         wtch(t).vnm(c)=vrb(vrr(iparent).vr).nm
         wtch(t).vty(c)=udt(vrb(vrr(iparent).vr).typ).nm
         If vrb(vrr(iparent).vr).arr Then wtch(t).var=1 Else wtch(t).var=0
         Exit Do
     	Else
         c+=1
         wtch(t).vnm(c)=cudt(abs(vrr(iparent).vr)).nm
         wtch(t).vty(c)=udt(cudt(abs(vrr(iparent).vr)).typ).nm
         If cudt(abs(vrr(iparent).vr)).arr Then wtch(t).var=1:Exit do Else wtch(t).var=0
     	End if
      temp=Cast(HTREEITEM,SendMessage(tviewvar,TVM_GETNEXTITEM,TVGN_PARENT,Cast(LPARAM,vrr(iparent).tv)))
     
     	For i as integer =1 to vrrnb
         if vrr(i).tv=temp Then iparent=i
     	Next
 	Loop While 1
 	wtch(t).vnb=c

Endif
if r=-1 then wtch(t).tvl=Tree_AddItem(null,"To fill", 0, tviewwch) 'create an empty line in treeview
watch_sh(t)
wtchnew=t
end sub
Sub watch_sh(aff as integer) 'default all watched
dim as Integer vbeg,vend
Dim As String libel,value
if aff=WTCHALL then vbeg=0:vend=WTCHMAX else vbeg=aff:vend=aff
for i as integer= vbeg to vend	
   If wtch(i).psk<>-1 Then
   	libel=wtch(i).lbl
      If wtch(i).psk=-3 Then
         value=libel
         libel+=udt(wtch(i).typ).nm
         If wtch(i).idx Then '08/02/2013
         	libel+=">=LOCAL NON-EXISTENT"
         Else
         	libel+=">=Dll not loaded"
         EndIf
      ElseIf wtch(i).psk=-4 Then
      	value=libel
      Else
        	value=var_sh2(wtch(i).typ,wtch(i).adr,wtch(i).pnt)
        	libel+=value '2 spaces for trace T
      End If
		'trace
		If len(wtch(i).old)<>0 then
				If wtch(i).old<>value Then dbg_prt("Trace :"+libel):wtch(i).old=value
				Mid(libel,1, 1) = "T" 
		End If
		'additionnal data
		If wtch(i).tad Then libel+=" "+var_add(Mid(value,InStr(value,"=")+1),wtch(i).typ,wtch(i).tad)'additionnal info
		'main display
		If i<=WTCHMAIN Then setWindowText(wtch(i).hnd,libel)
		'watched tab
		Tree_upditem(wtch(i).tvl,libel,tviewwch)
   End If
Next    
end Sub
Sub watch_trace(t As Integer=WTCHALL)
	If t=WTCHALL Then 'reset all
		For i As Integer =0 To WTCHMAX
			If wtch(i).old<>"" Then
				wtch(i).old=""
				watch_sh(i)
			EndIf
		Next
	Else
	If wtch(t).old<>"" Then 'reset one 
        wtch(t).old="" 
    Else 'set tracing 
    	If wtch(t).typ>15 AndAlso wtch(t).pnt=0 Then 
            fb_message("Tracing Watched var/mem","Only with pointer or standard type") 
            Exit Sub 
        Else 
            If flaglog=0 Then 
                If fb_message("Tracing var/mem","No log output defined"+Chr(13)+"Open settings ?",MB_YESNO)=IDYES Then 
                    sendmessage(windmain,WM_COMMAND,IDCMDLPRM,0) 
                EndIf 
                if flaglog=0 then 
                    fb_message("Tracing var/mem","No log output defined"+Chr(13)+"So doing nothing") 
                    exit sub 
                endif 
            EndIf 
            If wtch(t).psk=-2 Then 
            	wtch(t).old=var_sh2(wtch(t).typ,wtch(t).adr,wtch(t).pnt)
            Elseif wtch(t).psk=-3 Or wtch(t).psk=-4 Then
            	wtch(t).old=wtch(t).lbl
            Else
            	wtch(t).old=var_sh2(wtch(t).typ,wtch(t).adr,wtch(t).pnt)
            EndIf
        EndIf 
	EndIf 
    watch_sh(t) 
EndIf 
End Sub 
Sub watch_del(i As Integer=WTCHALL)
	Dim As Integer bg,ed
	
	If i=WTCHALL Then
		bg=0:ed=WTCHMAX
	Else
		bg=i:ed=i
	EndIf
	For j As Integer=bg To ed
	   If wtch(j).psk=-1 Then Continue For
	   wtch(j).psk=-1
	   wtch(j).old=""
	   wtch(j).tad=0
	   wtchcpt-=1
	   If wtchcpt=0 Then menu_enable
	   If j<=WTCHMAIN Then setWindowText(wtch(j).hnd,"Watch "+str(j+1))
	  	SendMessage(tviewwch,TVM_DELETEITEM,0,Cast(LPARAM,wtch(j).tvl))   
	Next
end Sub
Sub watch_sel(i As Integer) 'i index
If wtch(i).psk=-1 OrElse wtch(i).psk=-3 OrElse wtch(i).psk=-4 Then Exit sub
If wtch(i).ivr=0 Then 'watch memory
	dumpadr=wtch(i).adr
	lvtyp=wtch(i).typ
	dump_set(listview1)
	dump_sh
	if hdumpbx=0 then
        fb_dialog(@dump_box,"Manage dump",windmain,283,25,100,70)   
    end if
Else
	If vrr(wtch(i).ivr).ad=wtch(i).adr Then
		ShowWindow(tviewcur,SW_HIDE)
		tviewcur=tviewvar
   	ShowWindow(tviewcur,SW_SHOW)
   	SendMessage(htab2,TCM_SETCURSEL,0,0)
		SendMessage(tviewvar,TVM_SELECTITEM,TVGN_CARET,Cast(LPARAM,vrr(wtch(i).ivr).tv))
		SetFocus(tviewcur)
	Else
		fb_message("Select watched variable","Not possible : changed index (different address)")
	End If
End If
End Sub
Function watch_find() As Integer
	dim hitem as integer
	'get current hitem in tree
	hitem=sendmessage(tviewwch,TVM_GETNEXTITEM,TVGN_CARET,null)
	For k As Integer =0 To WTCHMAX
		If wtch(k).tvl=hitem Then Return k 'found
	Next
End Function
Sub watch_exch(i As Integer)
	dim j As Integer
	'get current hitem in tree
	j=watch_find()
	If i=j Then Exit Sub 'same nothing to do

	Swap wtch(i),wtch(j)
	Swap wtch(i).hnd,wtch(j).hnd 'handle for main display DO NOT BE CHANGED
	If wtch(j).psk=-1 Then 'destination (watch in main is empty)
		watch_sh(i)
		If j<=WTCHMAIN Then setWindowText(wtch(j).hnd,"Watch "+str(j+1))
	Else
		watch_sh(i):watch_sh(j)
	EndIf
End Sub
'==========================================
Sub watch_check(wname()As String)
   Dim As Integer dlt,bg,ed,pidx,vidx,tidx,index,p,q,vnb,varb,ispnt,tad
  	Dim as string pname,vname,vtype

While wname(index)<>""
	pidx=-1:vidx=-1:p=0:vnb=1
	
   p=instr(wname(index),"/")
	pname=mid(wname(index),1,P-1)
	If InStr(pname,".dll") Then 'shared in dll '07/02/2013
		pidx=0
	Else
	'check proc existing ?
		For i As Integer=1 To procnb
			If proc(i).nm=pname Then pidx=i:Exit For 
		Next
	EndIf
	'var name : vname,vtype/ and so on then pointer number
	q=p+1
	p=instr(q,wname(index),",")
	vname=mid(wname(index),q,p-q)
	
	q=p+1
	p=instr(q,wname(index),"/")
	vtype=mid(wname(index),q,p-q)
	
	If pidx=-1 Then
	  fb_message("Applying watched variables","Proc <"+pname+"> for <"+vname+"> removed, canceled",MB_SYSTEMMODAL)
	  index+=1
	  continue while 'proc has been removed
	EndIf
	'check var existing ?
	bg=proc(pidx).vr:ed=proc(pidx+1).vr-1
    
   If pname="main" Then
		For i As Integer = 1 To vrbgbl
		   If vrb(i).nm=vname andalso udt(vrb(i).typ).nm=vtype AndAlso vrb(i).arr=0 Then
				vidx=i
				tidx=vrb(i).typ
				ispnt=vrb(i).pt
				Exit For
		   End if
		Next
   Else
   	If pidx=0 Then 'DLL [WTC]=dll.dll/B,Integer/0/0 '08/02/2013
			For i As Integer= 1 To 15
				If udt(i).nm=vtype Then tidx=i:Exit For
			Next
			wtch(index).typ=tidx
			wtch(index).psk=-4
			wtch(index).vnb=1 'only basic type or pointer
			wtch(index).idx=pidx
			wtch(index).pnt=ValInt(Right(wname(index),1))
			wtch(index).tad=0 'unknown address
			wtch(index).vnm(vnb)=vname
			wtch(index).var=0 'not an array
			wtch(index).vty(vnb)=vtype
			wtch(index).tvl=Tree_AddItem(null,"", 0, tviewwch)
			wtch(index).lbl="  "+pname+"/"+vname+" <"+String(wtch(index).pnt,"*")+" "+udt(tidx).nm+">=Dll not loaded"
			wtchcpt+=1
   		index+=1
   		Continue while
   	EndIf	
   EndIf
   If vidx=-1 Then
   	'local
      For i As Integer = bg To ed
         If vrb(i).nm=vname andalso udt(vrb(i).typ).nm=vtype AndAlso vrb(i).arr=0 Then
         	vidx=i
            tidx=vrb(i).typ
            ispnt=vrb(i).pt
            Exit For
         end if
      Next
   EndIf
   If vidx=-1 Then
      'var has been removed
      fb_message("Applying watched variables","<"+vname+"> removed, canceled",MB_SYSTEMMODAL)
      index+=1
      continue While
   End if
	'store value for var_search
	wtch(index).vnm(vnb)=vname
	wtch(index).var=0
	wtch(index).vty(vnb)=vtype
	varb=vidx
	'check component
	q=p+1
	p=instr(q,wname(index),",")
	while p
      vidx=-1
      vname=mid(wname(index),q,p-q)
		q=p+1
		p=instr(q,wname(index),"/")
		vtype=mid(wname(index),q,p-q)
		For i As Integer =udt(tidx).lb To udt(tidx).ub
         With cudt(i)
         If .nm=vname andalso udt(.typ).nm=vtype andalso .arr=0 Then
            vidx=i:tidx=.typ
            ispnt=cudt(i).pt
            Exit for
         End if
         End with
		Next
		If vidx=-1 Then
	      'udt has been removed
	      fb_message("Applying watched variables","udt <"+vname+"> removed, canceled")
	      index+=1
	      Continue while,while
		end If
		vnb+=1
		wtch(index).vnm(vnb)=vname
		wtch(index).vty(vnb)=vtype
		if tidx<=15 then exit While
		q=p+1
		p=instr(q,wname(index),",")
	Wend
	tad=ValInt(mid(wname(index),q,1)) 'tad
	q+=2
	If ispnt<>ValInt(mid(wname(index),q,1)) Then 'pnt
		'pointer doesn't match
	   fb_message("Applying watched variables",Left(wname(index),Len(wname(index))-2)+" not a pointer or pointer, canceled")
	   index+=1
	   Continue While
	EndIf
	wtch(index).tvl=Tree_AddItem(null,"", 0, tviewwch)
	wtch(index).lbl="  "+proc(pidx).nm+"/"+vname+" <"+String(ispnt,"*")+" "+udt(tidx).nm+">=LOCAL NON-EXISTENT"
	wtch(index).typ=tidx
	wtch(index).psk=-4
	wtch(index).vnb=vnb
	wtch(index).idx=pidx
	wtch(index).pnt=ispnt
	wtch(index).tad=tad
	wtchcpt+=1
   index+=1
Wend
If wtchcpt Then menu_enable 
End Sub
Sub watch_sav()'save watched
'example main/TUTU,TTEST/B,TTITI/C,Integer/pnt 
'= PROC main,tutu type ttest,B type ttiti, C type integer, nb pointer
   Dim As Integer begb,Endb,stepb
   Dim As String  text

	For i As Integer =0 To WTCHMAX
		If wtch(i).psk=-1 OrElse wtch(i).psk=-2 OrElse wtch(i).Var<>0 Then 'not used or memory not saved or array
			text=""
		Else  'dll, more than one level and not a basic type on not a pointer ? 07/02/2013
			If wtch(i).idx=0 AndAlso wtch(i).vnb>1 AndAlso wtch(i).typ>15 AndAlso wtch(i).pnt=0 Then
				text=""
			Else
				If wtch(i).idx=0 Then 'shared in dll
					text=Left( wtch(i).lbl , InStr( wtch(i).lbl ,"/") ) 'dll name
				   'watched used or saved previously but not used this time (psk= -3 or 4)
				Else
					text=proc(wtch(i).idx).nm+"/" 'proc name
				End if
				'if -4 order of storage is different than -3 so inverse stepping
				If wtch(i).psk=-4 Then begb=1:Endb=wtch(i).vnb:Stepb=1 Else begb=wtch(i).vnb:Endb=1:Stepb=-1
				For j As Integer =begb To Endb Step Stepb '10 levels max
					text+=wtch(i).vnm(j)+","+wtch(i).vty(j)+"/" 'name type
				Next
				text+=Str(wtch(i).tad)+"/"+Str(wtch(i).pnt)
			Endif
		EndIf
		If text="/0/0" Then text=""
		wtchexe(0,i)=text
	Next
End Sub
Sub watch_addtr
   wtchnew=-1
   If var_find2(tviewvar)<>-1 Then
		watch_set()
   	If wtchnew<>-1 Then watch_trace(wtchnew)
   EndIf
End Sub
Sub brkv_set(a As Integer) 'breakon variable
dim As Integer t,p
dim Title As String, j as uinteger,ztxt as zstring*301,tvi as TVITEM
if a=0 then 'cancel break
    brkv.adr=0
    setWindowText(brkvhnd,"Break on var")
    exit sub
elseif a=1 then 'new
    If var_find2(tviewvar)=-1 Then Exit Sub 'search index variable under cursor
    'search master variable

    	t=varfind.Ty
      p=varfind.pt
  
    
	 If p Then t=8
    if t>8 andalso p=0 andalso t<>4 andalso t<>13 andalso t<>14 then
        fb_message("Break on var selection error","Only [unsigned] Byte, Short, integer or z/f/string")
        exit sub
    end If

    
    brkv2.typ=t           'change in brkv_box if pointed value
    brkv2.adr=varfind.ad   'idem
    brkv2.vst=""          'idem
    brkv2.tst=1           'type of test
    brkv2.ivr=varfind.iv
    ' if dyn array store real adr
    If vrb(varfind.pr).arr=-1 Then
        ReadProcessMemory(dbghand,Cast(LPCVOID,vrr(varfind.iv).ini),@brkv2.arr,4,0)
    Else
        brkv2.arr=0
    End If
    
    If vrb(varfind.pr).mem=3 Then
		brkv2.psk=-2 'static
    else
		for j As uInteger = 1  To procrnb 'find proc to delete watching
			if varfind.iv>=procr(j).vr and varfind.iv<procr(j+1).vr then brkv2.psk=procr(j).sk:Exit for
		Next
    End If
    
    tvI.mask       = TVIF_TEXT
    tvI.pszText    = @(ztxt)
    tvI.hitem      = vrr(varfind.iv).tv
    tvI.cchTextMax = 300
    sendmessage(tviewvar,TVM_GETITEM,0,Cast(LPARAM,@tvi))
    '' ??? treat verbose to reduce width ???

    ztxt="Stop if  "+ztxt

else 'update
	 brkv2=brkv
    getwindowtext(brkvhnd,ztxt,150)
End If
brkv2.txt=left(ztxt,instr(ztxt,"<"))+var_sh2(brkv2.typ,brkv2.adr,p)

fb_mdialog(@brkv_box,"Test for break on value",windmain,283,25,350,50)

end Sub
'==========================================
Sub string_sh(tv as HWND)

if var_find2(tv)=-1 then exit sub 'search index variable under cursor

If varfind.ty<>4 and varfind.ty<>13 and varfind.ty<>14 and varfind.ty <>6 Then 'or ty<>15
   fb_message("Show string error","Select only a string variable")
   Exit sub
End If
stringadr=varfind.ad
if varfind.pt Then
   ReadProcessMemory(dbghand,Cast(LPCVOID,stringadr),@stringadr,4,0) 'string ptr
   If varfind.pt=2 Then ReadProcessMemory(dbghand,Cast(LPCVOID,stringadr),@stringadr,4,0) 'if two levels
EndIf                

if varfind.ty <>6 Then
	If varfind.ty=13 Then 'string
	   ReadProcessMemory(dbghand,Cast(LPCVOID,stringadr),@stringadr,4,0)'string address
	End If	
	If helpbx=0 Then helptyp=4:fb_dialog(@help_box,"String : "+varfind.nm+"       (To change value use dump)" ,windmain,2,2,400,260)
Else
	If helpbx=0 Then helptyp=5:fb_dialog(@help_box,"WString (ushort) : "+varfind.nm+"       (To change value use dump)" ,windmain,2,2,400,250)
EndIf
End Sub
'==========================================
Sub zstringbyte_exchange()
Dim As Integer i,typ 
   i=var_find() 'search index variable under cursor
	If i=0 then exit sub 
If i>0 Then 'var
	typ=vrb(vrr(i).vr).typ
	If typ=2 And vrb(vrr(i).vr).arr=0 Then typ=9 'not and array of bytes --> error 
Else
	typ=cudt(abs(vrr(Abs(i)).vr)).typ
	If typ=2 And cudt(abs(vrr(Abs(i)).vr)).arr=0 Then typ=9 'not and array of bytes --> error 
End If	
If typ<>2 And typ<>4 Then 'byte / zstring
   fb_message("Change byte <> zstring error","Select only a byte array or zstring variable")
   Exit sub
End If
If Typ=2 Then Typ=4 Else Typ=2
If i>0 Then
	vrb(vrr(i).vr).typ=typ
Else
	cudt(abs(vrr(Abs(i)).vr)).typ=typ
EndIf
var_sh() 'display update
End Sub
'==========================================
Sub var_dump(tv as HWND) 'dump variable

If var_find2(tv)=-1 then exit sub 'search index variable under cursor

dumpadr=varfind.ad
If udt(varfind.ty).en Then
   lvtyp=1 'if enum then as integer
else
   lvtyp=varfind.ty
end if
if varfind.pt Then
   lvtyp=8
Else                
   Select case lvtyp                
   	Case 13 'string
         lvtyp=2 'default for string
         ReadProcessMemory(dbghand,Cast(LPCVOID,dumpadr),@dumpadr,4,0)'string address
   	Case 4,14 'f or zstring
 	   	lvtyp=2
   	Case IS>15
         lvtyp=8 'default for pudt and any
   End Select
End If
dump_set(listview1)
dump_sh()
end Sub
'======================================
sub dump_sh()
dim i As Integer,j As Integer,tmp as string,lvi as LVITEM
dim buf(16) as ubyte,r As Integer,ad as uinteger
dim ascii as string
dim ptrs as pointeurs
'delete all items
sendmessage(listview1,LVM_DELETEALLITEMS,0,0)
ad=dumpadr
for j=1 to dumplig
'put address
lvI.mask     = LVIF_TEXT
lvi.iitem    = j-1 'index line
lvi.isubitem = 0 'index colonn
tmp=Str(ad)
lvi.pszText  = strptr(tmp)
sendmessage(listview1,LVM_INSERTITEM,0,Cast(LPARAM,@lvi))
'handle,adr start read,adr put read,nb to read,nb read
ReadProcessMemory(dbghand,Cast(LPCVOID,ad),@buf(0),16,@r)
ad+=r
ptrs.pxxx=@buf(0)
for i=1 to lvnbcol
  lvi.isubitem = i
  select case lvtyp+dumpdec
     case 2 'byte/dec/sng
        tmp=str(*ptrs.pbyte)
        lvi.pszText  = strptr(tmp)
        ptrs.pbyte+=1
     case 3 'byte/dec/usng
        tmp=str(*ptrs.pubyte)
        lvi.pszText  = strptr(tmp)
        ptrs.pubyte+=1
     case 5 'short/dec/sng
        tmp=str(*ptrs.pshort)
        lvi.pszText  = strptr(tmp)
        ptrs.pshort+=1
     case 6 'short/dec/usng
        tmp=str(*ptrs.pushort)
        lvi.pszText  = strptr(tmp)
        ptrs.pushort+=1
     case 1 'integer/dec/sng
        tmp=str(*ptrs.pinteger)
        lvi.pszText  = strptr(tmp)
        ptrs.pinteger+=1
     case 7,8 'integer/dec/usng
        tmp=str(*ptrs.puinteger)
        lvi.pszText  = strptr(tmp)
        ptrs.puinteger+=1
     case 9 'longinteger/dec/sng
        tmp=str(*ptrs.plinteger)
        lvi.pszText  = strptr(tmp)
        ptrs.plinteger+=1
     case 10 'longinteger/dec/usng
        tmp=str(*ptrs.pulinteger)
        lvi.pszText  = strptr(tmp)
        ptrs.pulinteger+=1
     case 11 'single
         tmp=str(*ptrs.psingle)
        lvi.pszText  = strptr(tmp)
        ptrs.psingle+=1
     case 12 'double
         tmp=str(*ptrs.pdouble)
        lvi.pszText  = strptr(tmp)
        ptrs.pdouble+=1
     case 52,53 'byte/hex
        tmp=right("0"+hex(*ptrs.pbyte),2)
        lvi.pszText  = strptr(tmp)
        ptrs.pbyte+=1
     case 55,56 'short/hex
        tmp=right("000"+hex(*ptrs.pshort),4)
        lvi.pszText  = strptr(tmp)
        ptrs.pshort+=1
     case 51,58 'integer/hex
        tmp=right("0000000"+hex(*ptrs.pinteger),8)
        lvi.pszText  = strptr(tmp)
        ptrs.pinteger+=1
    case 59,60 'longinteger/hex
        tmp=right("000000000000000"+hex(*ptrs.plinteger),16)
        lvi.pszText  = strptr(tmp)
        ptrs.pulinteger+=1
    case else
        lvi.pszText  = strptr("Error")
  end select
  sendmessage(listview1,LVM_SETITEMTEXT,j-1,Cast(LPARAM,@lvi))
  'sendmessage(listview1,LVM_SETCOLUMNWIDTH,lvnbcol,LVSCW_AUTOSIZE)
next
ascii=""
for i=1 to 16
  if buf(i-1)>31 then
      ascii+=chr(buf(i-1))
  else
      ascii+="."
  end if
next
lvi.isubitem = lvnbcol+1
lvi.pszText  = strptr(ascii)
sendmessage(listview1,LVM_SETITEMTEXT,j-1,Cast(LPARAM,@lvi))
'sendmessage(listview1,LVM_SETCOLUMNWIDTH,lvnbcol+1,LVSCW_AUTOSIZE)
next 
end sub
'====================================
sub dump_update(lvp as NMLISTVIEW ptr)
dim lvi as LVITEM,tmp as zstring *25,lvu as valeurs
lvI.mask     = LVIF_TEXT
lvi.iitem    = 0 'first line
lvi.isubitem = lvp->isubitem 'index colonn
lvi.pszText  = @tmp
lvi.cchtextmax=24
SendMessage(listview1,LVM_GETITEM,0,Cast(LPARAM,@lvi))
if lvp->isubitem=lvnbcol+1 then fb_message("Change value error","Not possible with this colonn"):exit sub
inputval=tmp
inputtyp=lvtyp
fb_mdialog(@input_box,"Change value ["+tmp+"]",windmain,283,25,150,30)

if inputval<>"" then
    fb_message("Change"," column/new value : "+str(lvp->isubitem)+" "+inputval)
    select case lvtyp
        case 2
            lvu.vbyte=valint(inputval)
        case 3
            lvu.vubyte=valuint(inputval)
        case 5
            lvu.vshort=valint(inputval)
        case 6
            lvu.vushort=valuint(inputval)
        case 1
            lvu.vinteger=valint(inputval)
        case 7,8
            lvu.vuinteger=valuint(inputval)
        case 9
            lvu.vlinteger=vallng(inputval)
        case 10
            lvu.vulinteger=valulng(inputval)
        case 11
            lvu.vsingle=val(inputval)
        case 12
            lvu.vdouble=val(inputval)
    end select
    writeprocessmemory(dbghand,Cast(LPVOID,dumpadr+(lvp->isubitem-1)*16\lvnbcol),@lvu,16\lvnbcol,0)
    var_sh()
    dump_sh()
    'If vrptdbx Then varptd_box(vrptdbx,WM_COMMAND,120,0) manual update only under the user's control
end if
end sub

'====================================
Function settings_box(byval hWnd As HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
  dim txt as string *300
  dim rc as RECT => (0, 0, 4, 8)
  dim As Integer scalex,scaley,flaglogold,clrnew,tempo
  static As HWND hedit1,hedit2,hedit3,hedit4,hedit5,hcomb01,rich,hsbox,hcbox,habox
  Static As HWND checkbox1,checkbox2,checkbox3,radio(7),hfont8,hfont10,hfont12,checkttp,fontbut,hlkbut
  Static As Integer shcutindex,shcutkey
  Dim As MSGFILTER Ptr msgfilter
Select CASE Msg
        CASE WM_INITDIALOG    'All controls are created here
            MapDialogRect (hwnd,@rc)
            ScaleX = rc.right/4
            ScaleY = rc.bottom/8
            fb_modstyle(hwnd,0,WS_EX_NOPARENTNOTIFY,1)

				fb_Group("Customize shortcuts : select a combination, use ""A"" button to check and apply, ""Del"" key To delete",hwnd,2003,6*scalex,2*scaley,252*scalex,20*scaley)
				hsbox=fb_Checkbox("Shift",hwnd,2004,140*scalex,9*scaley,20*scalex,10*scaley)
				hcbox=fb_Checkbox("Ctrl",hwnd,2005,165*scalex,9*scaley,20*scalex,10*scaley)
				habox=fb_Checkbox("Alt",hwnd,2006,190*scalex,9*scaley,18*scalex,10*scaley)
				hcomb01=fb_combobox (hWnd,2007,8*scalex,9*scaley,130*scalex,200*scaley)
    			rich=fb_richEDIT("",hWnd,2008,218*scalex,9*scaley,28*scalex,10*scaley)
    			SendMessage(rich,EM_SETEVENTMASK,0,ENM_KEYEVENTS Or ENM_MOUSEEVENTS)
				fb_button("A",hWnd,2009,248*scalex, 9*scaley, 8*scalex, 10*scaley)
				shcutkey=shcut(shcutindex).sccur And &hFFF
				shcut_display(shcutindex,hcbox,habox,hsbox,rich)
				
				For i As Integer =0 To shcutnb-1
					txt=menu_gettxt(shcut(i).scmenu,shcut(i).scidnt)
					sendmessage(hcomb01,CB_ADDSTRING,0,Cast(LPARAM,StrPtr(txt)))
				Next
				sendmessage(hcomb01,CB_SETCURSEL,shcutindex,0)

            fb_Group("Cmdline, parameters for compiling (-g added by default) and for the debuggee when debugging",hwnd,2002,6*scalex,69*scaley,252*scalex,45*scaley)
            fb_label("CMPL",hwnd,100,13*scalex,81*scaley,18*scalex,9*scaley,SS_LEFT)
            hEdit1   = fb_EDIT ("",hWnd,101,34*scalex,81*scaley,201*scalex,9*scaley)
            fb_modstyle(hedit1,0,WS_EX_NOPARENTNOTIFY,1)
            fb_modstyle(hedit1,0,WS_VSCROLL,0)
            setwindowtext(hedit1,cmdlfbc)
        
            fb_label("DBG",hwnd,100,13*scalex,93*scaley,18*scalex,9*scaley,SS_LEFT)
            hEdit2   = fb_EDIT ("",hWnd,102,34*scalex,93*scaley,201*scalex,9*scaley)
            fb_modstyle(hedit2,0,WS_EX_NOPARENTNOTIFY,1)
            fb_modstyle(hedit2,0,WS_VSCROLL,0)
            setwindowtext(hedit2,cmdexe(0))
                  
            fb_Group("Files location, disc:\path\name[.exe]",hwnd,2001,6*scalex,23*scaley,252*scalex,42*scaley)
            fb_Label("FBC",hwnd,150,13*scalex,33*scaley,18*scalex,9*scaley,SS_LEFT)
            hEdit3   = fb_EDIT ("",hWnd,151,33*scalex,33*scaley,201*scalex,9*scaley)
            fb_BUTTON("...",hWnd,152,240*scalex, 33*scaley, 12*scalex, 9*scaley)
            fb_modstyle(hedit3,0,WS_EX_NOPARENTNOTIFY,1)
            fb_modstyle(hedit3,0,WS_VSCROLL,0)
            setwindowtext(hedit3,fbcexe)


  		fb_label("IDE",hwnd,155,13*scalex,45*scaley,18*scalex,9*scaley,SS_LEFT)
    	hEdit4   = fb_EDIT ("",hWnd,156,33*scalex,45*scaley,201*scalex,9*scaley)
    	fb_BUTTON("...",hWnd,157,240*scalex, 45*scaley, 12*scalex, 9*scaley)
    	fb_modstyle(hedit4,0,WS_EX_NOPARENTNOTIFY,1)
    	fb_modstyle(hedit4,0,WS_VSCROLL,0)
  		setwindowtext(hedit4,ideexe)
  		
		Dim As HWND loggroup=fb_Group("Advanced log (FBDebugger path\dbg_log_file.txt)",hwnd,200,6*scalex,123*scaley,226*scalex,36*scaley)
		radio(1)=fb_radio("Screen",loggroup,201,10*scalex,8*scaley,35*scalex,15*scaley)
		radio(2)=fb_radio("File ",loggroup,202,50*scalex,8*scaley,35*scalex,15*scaley)
		radio(3)=fb_radio("Screen/file",loggroup,203,85*scalex,8*scaley,35*scalex,15*scaley)
		radio(0)=fb_radio("None",loggroup,204,130*scalex,8*scaley,35*scalex,15*scaley)
		sendmessage(radio(flaglog),BM_SETCHECK,BST_CHECKED	,0)
		
		checkbox1=fb_Checkbox("Trace proc On",hwnd,210,175*scalex,130*scaley,55*scalex,15*scaley)
		If flagtrace Then SendMessage(checkbox1,BM_SETCHECK,BST_CHECKED	,0)
		checkbox3=fb_Checkbox("Trace line On",hwnd,211,175*scalex,142*scaley,55*scalex,15*scaley)
		If flagtrace And 2 Then SendMessage(checkbox3,BM_SETCHECK,BST_CHECKED	,0)

		
		fb_label("10000> Delay auto (ms) >50",hwnd,170,6*scalex,162*scaley,75*scalex,9*scaley,SS_LEFT)
    	hEdit5   = fb_EDIT ("200",hWnd,171,83*scalex,162*scaley,25*scalex,9*scaley)
  		fb_modstyle(hedit5,0,WS_VSCROLL Or ES_NUMBER,0)
  		setwindowtext(hedit5,Str(autostep))
  			
		checkbox2=fb_Checkbox("Verbose mode On (proc/var)",hwnd,220,130*scalex,162*scaley,85*scalex,9*scaley)
		If flagverbose=TRUE Then sendmessage(checkbox2,BM_SETCHECK,BST_CHECKED	,0)
		
		'Dim As HWND fontgroup=fb_Group("Font size",hwnd,230,240*scalex,123*scaley,75*scalex,20*scaley)
		'hfont8=fb_radio("8 ",fontgroup,231,3*scalex,6*scaley,23*scalex,12*scaley)
		'hfont10=fb_radio("10",fontgroup,232,26*scalex,6*scaley,23*scalex,12*scaley)
		'hfont12=fb_radio("12",fontgroup,233,49*scalex,6*scaley,23*scalex,12*scaley)
		'If fontsize=KSIZE8 Then
		'	sendmessage(hfont8,BM_SETCHECK,BST_CHECKED	,0)
		'ElseIf fontsize=KSIZE10 Then
		'	sendmessage(hfont10,BM_SETCHECK,BST_CHECKED	,0)
		'Else
		'	sendmessage(hfont12,BM_SETCHECK,BST_CHECKED	,0)
		'EndIf
		fontbut=fb_BUTTON("Change font"+Chr(13)+fontname+"/"+Str(fontsize),hWnd,234,240*scalex, 126*scaley, 60*scalex, 20*scaley)
		checkttp=fb_Checkbox("Activated tooltips",hwnd,240,240*scalex,148*scaley,55*scalex,15*scaley)
		If flagtooltip=TRUE Then sendmessage(checkttp,BM_SETCHECK,BST_CHECKED	,0)
		
		Dim As HWND dspgroup=fb_Group("Position current source line,x lines from top and x lines before bottom",hwnd,250,6*scalex,175*scaley,170*scalex,20*scaley)
		radio(4)=fb_radio("3 lines ",   dspgroup,251, 10*scalex,7*scaley,35*scalex,10*scaley)
		radio(5)=fb_radio("5 lines",    dspgroup,252, 50*scalex,7*scaley,39*scalex,10*scaley)
		'trick value of dspofs = 2 or 4, /2 +3 --> 4 or 5  !!!
		sendmessage(radio(dspofs/2+3),BM_SETCHECK,BST_CHECKED	,0)
				
    	fb_BUTTON("Ok",hWnd,103,240*scalex, 171*scaley, 35*scalex, 15*scaley)
    	fb_BUTTON("Cancel",hWnd, 104, 283*scalex, 171*scaley, 35*scalex, 15*scaley)
'    	100 / 83 / 66 / 49 / 32
    	fb_BUTTON("Color Bkgrd",hWnd, 105, 283*scalex, 32*scaley, 35*scalex, 15*scaley)
    	If hgltflag=TRUE Then txt="No HL keywords" Else txt="HL keywords"
    	hlkbut=fb_BUTTON(txt,hWnd, 106, 283*scalex, 100*scaley, 35*scalex, 15*scaley)
    	fb_BUTTON("Color keywords",hWnd, 107, 283*scalex, 83*scaley, 35*scalex, 15*scaley)
    	fb_BUTTON("Color current line",hWnd, 108, 283*scalex, 49*scaley, 35*scalex, 15*scaley)
    	fb_BUTTON("Color tmp breakpoint",hWnd, 109, 263*scalex, 66*scaley, 35*scalex, 15*scaley)
    	fb_BUTTON("Color per breakpoint",hWnd, 110, 300*scalex, 66*scaley, 35*scalex, 15*scaley)
CASE WM_COMMAND
  	select case loword(wparam)
  		Case 152 'select new location for FBC
  			txt=fb_getfilename("Select Exe file","FBC *.exe|fbc.exe||",0,0,0,"")
  			If txt<>"" Then setwindowtext(hedit3,txt)
  		Case 157 'select new location for IDE
  			txt=fb_getfilename("Select IDE file","*.exe|*.exe||",0,0,0,"")
  			If txt<>"" Then setwindowtext(hedit4,txt)
  		Case 210
  			if SendMessage(Checkbox1, BM_GETCHECK,0,0)=BST_UNCHECKED Then
  				SendMessage(Checkbox3, BM_SETCHECK,BST_UNCHECKED,0)
  			EndIf
  		Case 211
  			if SendMessage(Checkbox3, BM_GETCHECK,0,0)=BST_CHECKED Then
  				SendMessage(Checkbox1, BM_SETCHECK,BST_CHECKED,0)
  			EndIf
  		case 103   'Ok
	      GetWindowText(hEdit1,txt,299)
	      cmdlfbc=txt
	      getwindowtext(hEdit2,txt,299)
	      cmdexe(0)=txt
	     	GetWindowText(hEdit3,txt,299)
	     	fbcexe=txt
	     	GetWindowText(hEdit4,txt,299)
	     	ideexe=txt
	     	if SendMessage(Checkbox1, BM_GETCHECK,0,0)=BST_CHECKED Then
	     		flagtrace=1
	     		if SendMessage(Checkbox3, BM_GETCHECK,0,0)=BST_CHECKED Then flagtrace+=2	     	
	     	Else
	     		flagtrace=0
	     	EndIf
	     	
	     	If SendMessage(Checkbox2, BM_GETCHECK,0,0)=BST_CHECKED Then flagverbose=TRUE Else flagverbose=FALSE
	     	
	     	If SendMessage(Checkttp, BM_GETCHECK,0,0)=BST_CHECKED Then flagtooltip=TRUE Else flagtooltip=FALSE
	     	sendmessage (fb_hToolTip,TTM_ACTIVATE, cast(WPARAM,flagtooltip),0)
	     	
			If prun Then proc_update():var_sh:proc_sh:thread_text
	     	flaglogold=flaglog
	     	For i As Integer =0 To 3
		     	If SendMessage(radio(i), BM_GETCHECK,0,0)=BST_CHECKED Then flaglog=i:Exit For
	     	Next
	     	If flaglogold And flaglog<>flaglogold Then dbg_prt(" $$$$___CLOSE ALL___$$$$ ") 'close if needed
	     	
	     	GetWindowText(hEdit5,txt,299) 'value for auto
	     	autostep=ValInt(txt)
	     	If autostep<50 Then autostep=200
	     	If autostep>10000 Then autostep=200
	     	
	     	'If SendMessage(hfont8, BM_GETCHECK,0,0)=BST_CHECKED Then
	     	'	font_change(,KSIZE8)
	     	'ElseIf SendMessage(hfont10, BM_GETCHECK,0,0)=BST_CHECKED Then
	     	'	font_change(,KSIZE10)
	     	'Else
	     	'	font_change(,KSIZE12)
	     	'EndIf
	     	'change of dspofs ?
	     	For i As Integer =1 To 2
		     	If SendMessage(radio(i+3), BM_GETCHECK,0,0)=BST_CHECKED Then dspofs=i*2:Exit For
	     	Next
	     	
	      enddialog(hwnd,0)
   	case 104     'Cancel
      	enddialog(hwnd,0)
  		Case 105
  			clrnew=color_change(clrrichedit)
  			If clrnew<>clrrichedit Then
  				clrrichedit=clrnew
  				For i As Integer=0 To MAXSRC
  					sendmessage(richedit(i),EM_SETBKGNDCOLOR,0,clrrichedit)
  				Next
  			EndIf
  		Case 106
  			If hgltflag=TRUE Then
  				hgltflag=FALSE
  				txt="HL keywords"
  			Else
  				hgltflag=TRUE
  				txt="No HL keywords"
  			EndIf
  				setwindowtext(hlkbut,txt)
            hglt_all
  		Case 107
  			clrnew=color_change(clrkeyword)
  			If clrnew<>clrkeyword Then clrkeyword=clrnew:hglt_all
  		Case 108
  			clrnew=color_change(clrcurline)
  			If clrnew<>clrcurline Then clrcurline=clrnew:dsp_color	   	
  		Case 109
  			clrnew=color_change(clrtmpbrk)
  			If clrnew<>clrtmpbrk Then clrtmpbrk=clrnew:dsp_color
  		Case 110
  			clrnew=color_change(clrperbrk)
  			If clrnew<>clrperbrk Then clrperbrk=clrnew:dsp_color	  			          
  		Case 234
  			If fb_FontDlg(hwnd) Then
  				txt="Change font"+Chr(13)+fontname+"/"+Str(fontsize)
  				setwindowtext(fontbut,txt)
  				font_change(fontname,fontsize)
  			EndIf
  		Case 2009 'check if new shortcut is valid
  			tempo=shcutkey
  			If SendMessage(hsbox, BM_GETCHECK,0,0)=BST_CHECKED Then tempo+=VSHIFT
  			If SendMessage(habox, BM_GETCHECK,0,0)=BST_CHECKED Then tempo+=VALT
  			If SendMessage(hcbox, BM_GETCHECK,0,0)=BST_CHECKED Then tempo+=VCTRL
  			If shcut_check(shcutindex,tempo) Then 
  				shcut_display(shcutindex,hcbox,habox,hsbox,rich) 'restore 
  			Else
 				shcut(shcutindex).sccur=tempo
  				menu_update(shcutindex)
  			EndIf
  	End Select
  	If lparam=hcomb01 Then 'combobox
     	If hiword(wparam)=CBN_SELCHANGE then 'change selected shortcut
     		shcutindex=sendmessage(hcomb01,CB_GETCURSEL,0,0) 'get new index
  			shcutkey=shcut(shcutindex).sccur And &hFFF
			shcut_display(shcutindex,hcbox,habox,hsbox,rich)
     	EndIf
  	EndIf	
Case wm_notify
	msgfilter=Cast(MSGFILTER Ptr,lparam)
	If msgfilter->msg=WM_KEYDOWN And msgfilter->nmhdr.idfrom=2008 Then
		If msgfilter->wparam=VK_DELETE Then 
			shcut(shcutindex).sccur=0
			shcutkey=0
			shcut_display(shcutindex,hcbox,habox,hsbox,rich)
			menu_update(shcutindex)
		Else
			txt=shcut_txt(msgfilter->wparam,0)
			If txt<>"Error" Then
				shcutkey=msgfilter->wparam
			EndIf
		sendmessage(rich,WM_SETTEXT,0,Cast(LPARAM,StrPtr(txt)))
		EndIf
	EndIf
case WM_CLOSE
     enddialog(hwnd,0)
     Return 0 'not really used
End SELECT
END Function
Sub font_change(fname As String="",fsize As Integer=0)
	If fname="" Then
		fname=fontname
	Else
		fontname=fname
	EndIf
	If fsize=0 Then
		fsize=fontsize
	Else
		fontsize=fsize
	EndIf
	'If fontsize=fsize AndAlso fontname=fname Then Exit Sub
	DeleteObject(cast(HGDIOBJ,fonthdl))
	fonthdl=fb_Set_Font(fontname,fontsize)
	fontbold=fb_Set_Font(fontname,fontsize,FW_SEMIBOLD)
	SendMessage(tviewvar,WM_SETFONT,Cast(WPARAM,fonthdl),0)
	SendMessage(tviewprc,WM_SETFONT,Cast(WPARAM,fonthdl),0)
	SendMessage(tviewthd,WM_SETFONT,Cast(WPARAM,fonthdl),0)
	SendMessage(tviewwch,WM_SETFONT,Cast(WPARAM,fonthdl),0)
	For i As Integer=0 To MAXSRC
		SendMessage(richedit(i),WM_SETFONT,Cast(WPARAM,fontbold),0)
	Next
	If focusbx Then destroywindow(focusbx)
	if hgltflag=true then hglt_all 
	dsp_sizecalc
End Sub
Function shcut_check(idx As Integer,value As Integer) As Integer
	If value=0 Then Return 0 'no need to test
	For i As Integer=0 To shcutnb
		If shcut(i).sccur<>value OrElse idx=i Then Continue For
		fb_message("Defining New Shortcut","Combination not possible, already used by : "+menu_gettxt(shcut(i).scmenu,shcut(i).scidnt) )
		Return 1 'already used
	Next
	Return 0 'possible
End Function
Function shcut_txt(value As Integer, full As Integer) As String
	Dim As Integer vkey=value And &hFFF
	Dim As String stempo

	If value=0 Then Return ""
	If full Then
		If full=1 Then stempo=Chr(9)
		If (value And VSHIFT) Then
			stempo+="Shift+"
		EndIf
		If (value And VALT) Then
			stempo+="Alt+"
		EndIf
		If (value And VCTRL) Then
			stempo+="Ctrl+"
		EndIf
	EndIf
	If vkey>Asc("0") Andalso vkey<Asc("Z") Then Return stempo+Chr(vkey) '0 to 9 or A to Z
	If vkey>=112 Andalso vkey<=123 Then
		If vkey<121 Then Return stempo+"F"+Chr(vkey-&h3F) 'F12 to F9
		Return stempo+"F1"+Chr(vkey-&h49)'F10 to F12
	EndIf
	If vkey=VK_RETURN Then Return stempo+"Enter" 'return key
	' add other values if needed
	Return "Error"
End Function
Sub shcut_display(idx As Integer,hcbox As hwnd,habox As hwnd,hsbox As hwnd,rich As hwnd)
	Dim As Integer value=shcut(idx).sccur
	Dim As String stempo=shcut_txt(value,0)
  	If (value And VSHIFT) Then
		SendMessage(hsbox, BM_SETCHECK,BST_CHECKED,0)
	Else
		SendMessage(hsbox, BM_SETCHECK,BST_UNCHECKED,0)
	EndIf
	If (value And VALT) Then
		SendMessage(habox, BM_SETCHECK,BST_CHECKED,0)
	Else
		SendMessage(habox, BM_SETCHECK,BST_UNCHECKED,0)
	EndIf
	If (value And VCTRL) Then
		SendMessage(hcbox, BM_SETCHECK,BST_CHECKED,0)
	Else
		SendMessage(hcbox, BM_SETCHECK,BST_UNCHECKED,0)
	EndIf
	sendmessage(rich,WM_SETTEXT,0,Cast(LPARAM,StrPtr(stempo)))
End Sub
Sub shcut_ini(Strg As String)
	Static As Integer llimit 'as data are in order no need to begin each time the loop at zero
	Dim As Integer p=InStr(Strg,","),ident,value
	ident=ValInt(Left(Strg,p-1)):value=ValInt(mid(Strg,p+1))
	For i As Integer =llimit To shcutnb-1
		If shcut(i).scidnt=ident Then
			shcut(i).sccur=value:menu_update(i)
			llimit=i+1:Exit sub
		EndIf
	Next
End Sub
Sub menu_update(idx As Integer,s As String="")
	Dim As String stempo
	Dim As Integer itempo
	If s<>"" Then 'if string is given idx=ident so at first find the index in shcut
		For i As Integer=0 To shcutnb
			If idx=shcut(i).scidnt Then
				itempo=i
			EndIf
		Next
		stempo=s
	Else
		itempo=idx
		stempo=menu_gettxt(shcut(idx).scmenu,shcut(idx).scidnt)
	EndIf
	stempo+=shcut_txt(shcut(itempo).sccur,1)'1=full text
	menu_chg(shcut(itempo).scmenu,shcut(itempo).scidnt,stempo)
End Sub
Function input_box(byval hWnd As HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) as integer
    dim rc as RECT => (0, 0, 4, 8)
    dim scalex As Integer,scaley As Integer,vflag As Integer,vald as double
    static hedit1 As HWND
    SELECT CASE Msg
    CASE WM_INITDIALOG    'All of your controls are created here in the same
        MapDialogRect (hwnd,@rc)
        ScaleX = rc.right/4
        ScaleY = rc.bottom/8
        fb_modstyle(hwnd,0,WS_EX_NOPARENTNOTIFY,1)
 '       fb_label(inputtxt,hwnd,100,2*scalex,2*scaley,150*scalex,10*scaley,SS_LEFT)
        hEdit1   = fb_edit ("",hWnd,101,8*scalex,2*scaley,80*scalex,10*scaley)
        fb_modstyle(hedit1,0,WS_EX_NOPARENTNOTIFY,1)
        fb_modstyle(hedit1,,ES_MULTILINE or WS_VSCROLL,0)
        setwindowtext(hedit1,inputval)
        setfocus(hedit1)
        sendmessage(hedit1,EM_SETSEL,0,-1)
        fb_BUTTON("Ok",hWnd,103,8*scalex, 13*scaley, 36*scalex, 10*scaley)
        fb_BUTTON("Cancel",hWnd, 104, 50*scalex, 13*scaley, 36*scalex, 10*scaley)
        setfocus(hedit1)
    CASE WM_COMMAND
        select case loword(wparam)
        	case 103   'Ok
            getwindowtext(hedit1,inputval,25)
            vflag=1
            vald=val(inputval)
            select case inputtyp
            	case 2
                if vald<-128 or vald>127 then setwindowtext(hwnd,"min -128,max 127"):vflag=0
            	case 3
                if vald<0 or vald>255 then setwindowtext(hwnd,"min 0,max 255"):vflag=0
            	case 5
                if vald<-32768 or vald>32767 then setwindowtext(hwnd,"min -32768,max 32767"):vflag=0
            	case 6
                if vald<0 or vald>65535 then setwindowtext(hwnd,"min 0,max 65535"):vflag=0
            	case 1
                if vald<-2147483648 or vald>2147483648 then setwindowtext(hwnd,"min -2147483648,max +2147483647"):vflag=0
            case 7,8
                if vald<0 or vald>4294967395 then setwindowtext(hwnd,"min 0,max 4294967395"):vflag=0
            end select
            if vflag then enddialog(hwnd,0)
        case 104     'Cancel
            inputval=""
            enddialog(hwnd,0)
        end select
    case WM_CLOSE
            if vflag=0 then inputval=""
            enddialog(hwnd,0)
            Return 0
    case WM_DESTROY
    end select
end function
'====================================
function save_box(byval hWnd As HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS integer
   Dim rc as RECT => (0, 0, 4, 8)
   Dim  As Integer scalex,scaley
   dim l as Integer,f as Integer,buf(MAXSRCSIZE) as Byte
    
    SELECT CASE Msg
    CASE WM_INITDIALOG    'All of your controls are created here in the same
        MapDialogRect (hwnd,@rc)
        ScaleX = rc.right/4
        ScaleY = rc.bottom/8
        fb_modstyle(hwnd,0,WS_EX_NOPARENTNOTIFY,1)

        fb_label("Select option after editing done (no backup)",hwnd,100,2*scalex,2*scaley,110*scalex,10*scaley,SS_LEFT)
        fb_BUTTON("Save",hWnd,103,2*scalex, 13*scaley, 36*scalex, 10*scaley)
        'option only with 1 source code
        If sourcenb=0 Then fb_button("Save, Compile and Run",hWnd,104,40*scalex, 13*scaley, 72*scalex, 10*scaley)
        fb_BUTTON("Reload",hWnd, 105, 112*scalex, 13*scaley, 36*scalex, 10*scaley)
        fb_BUTTON("Quit",hWnd, 106, 112*scalex, 2*scaley, 36*scalex, 10*scaley)
        savebx=hwnd
    CASE WM_COMMAND
        select case loword(wparam)
        case 103   'Ok save richedit
				save_source
            destroywindow(hwnd)
        	Case 104
        		save_source
        		treat_file(dbgsrc)
        		destroywindow(hwnd)
        	Case 105 'reloading
				If FileExists(dbgsrc)=0 Then
					fb_message("Source "+dbgsrc,"not found, can not reload",MB_ICONERROR)
				Else
	   			Clear(buf(0),0,MAXSRCSIZE)
	    			f = freefile 
	    			Open dbgsrc for binary as #f 
	    			l=lof(f)
	    			If l>MAXSRCSIZE Then 
	    				fb_message(dbgsrc,"Source too large ("+Str(l)+">"+Str(MAXSRCSIZE)+") not loaded",MB_ICONERROR)
	    				destroywindow(hwnd)
	    			Else
		    			Get #f,,buf() 'get source
	    			End if
	    			Close #f
	    			SendMessage(dbgrichedit,EM_EXLIMITTEXT,0,l+10000) 'put file size
	    			setWindowText(dbgrichedit,@buf(0))
    			End If
    			destroywindow(hwnd)
        	case 106     'Cancel
            destroywindow(hwnd)
        end select
    case WM_CLOSE
        destroywindow(hwnd)
    case WM_DESTROY
        sendmessage(dbgrichedit,EM_SETREADONLY,TRUE,0)
        dsp_hide(1)
        savebx=0
        Return 0
    end select
end function
'====================================
function find_box(byval hWnd As HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
  dim Txt as string *300
  dim rc as RECT => (0, 0, 4, 8)
  dim scalex as Integer,scaley as Integer
  Static As HWND hedit1,checkcase,hbutton1
  SELECT CASE Msg

     CASE WM_INITDIALOG    'All of your controls are created here in the same
' à tester
    'SendMessage(hWnd, WM_SETICON, TRUE, _   'Set Application Icon
    '(HICON)LoadImage(0,"i.ico",IMAGE_ICON,0,0,LR_LOADFROMFILE))
    
    hfindbx=hwnd
    MapDialogRect (hwnd,@rc)
    ScaleX = rc.right/4
    ScaleY = rc.bottom/8
    fb_modstyle(hwnd,0,WS_EX_NOPARENTNOTIFY,1)
    hEdit1   = fb_EDIT ("",hWnd,101,2*scalex,2*scaley,95*scalex,10*scaley)
    fb_modstyle(hedit1,0,WS_EX_NOPARENTNOTIFY,1)
    fb_modstyle(hedit1,0,WS_VSCROLL,0)
    setwindowtext(hedit1,stext)
	 setfocus(hedit1)
	 SendMessage(hedit1,EM_SETSEL,0,-1)
    hButton1 = fb_BUTTON("Up",hWnd,IDFNDTXUP,2*scalex, 14*scaley, 18*scalex, 10*scaley)
    fb_modstyle(hbutton1,0,WS_EX_NOPARENTNOTIFY,1)
    fb_BUTTON("Dw",hWnd, IDFNDTXDW, 20*scalex, 14*scaley, 18*scalex, 10*scaley)
    checkcase=fb_checkbox("Case",hwnd,IDFNDTXCS,42*scalex, 14*scaley, 25*scalex, 10*scaley)
 CASE WM_COMMAND
  select case loword(wparam)
    case IDFNDTXUP    'clicked the up button
      getwindowtext(hEdit1,txt,299)
      sfind=txt
      sendmessage(windmain,WM_COMMAND,makelong(IDFNDTXUP,BN_CLICKED),Cast(LPARAM,hbutton1))
   case IDFNDTXDW     'clicked dw button
      getwindowtext(hEdit1,txt,299)
      sfind=txt
      sendmessage(windmain,WM_COMMAND,makelong(IDFNDTXDW,BN_CLICKED),Cast(LPARAM,hbutton1))
   case IDFNDTXCS     'clicked case
      if SendMessage(Checkcase, BM_GETCHECK,0,0)=BST_CHECKED then
         chkcase=4 'FR_MATCHCASE
      else
         chkcase=0
      end if
    END select
	Case WM_CLOSE 
		hfindbx=0 
		destroywindow(hwnd) 
		setfocus(dbgrichedit)
		Return 0 'not really used
  End SELECT
END function

'==================================
Function wtext() as string '-->return automatic searched text 
dim text as zstring *200,range as charrange
Dim as Integer n,p,c,i,j,l
l=sendmessage(dbgrichedit,EM_GETSELTEXT,0,Cast(LPARAM,@text)) 'selected text
'Returns the number of characters copied, not including the terminating null character
if l=0 then
   n=SendMessage(dbgrichedit,EM_LINEINDEX,-1,0) 'nb char until current line
   sendmessage(dbgrichedit,EM_EXGETSEL,0, Cast(LPARAM,@range)) 'get pos cursor
   p=range.cpmin
   l=sendmessage(dbgrichedit,EM_EXLINEFROMCHAR,0,-1) 'get line number
   text=Chr(150)+chr(0)
   sendmessage(dbgrichedit,EM_GETLINE,l,Cast(LPARAM,@text)) 'get line text
   if right(text,1)=Chr(13) then text=left(text,len(text)-1) 'suppress chr$(13) at the end
   p=p-n+1 'real pos of cursor in line one based
   for i=p-1 to 1 step-1
   	c=asc(text,i)
      if c>=asc("0") AndAlso c<=asc("9") Then Continue For
      if c>=asc("A") AndAlso c<=asc("Z") Then Continue For
      if c>=asc("a") AndAlso c<=asc("z") Then Continue For
      if c>=asc(".") Then Continue For
      if c>=asc("_") Then Continue For
      i+=1:exit for
   next
   if i=0 then i+=1
   for j=p to len(text)
   	c=asc(text,j)
      if c>=asc("0") AndAlso c<=asc("9") Then Continue For
      if c>=asc("A") AndAlso c<=asc("Z") Then Continue For
      if c>=asc("a") AndAlso c<=asc("z") Then Continue For
      if c=asc(".") Then Continue For
      if c=asc("_") Then Continue For
      j-=1 :exit for
   next
   If i>j then
      text=""
   else
      text=mid(text,i,j-i+1)
   end if
end if
Return text
end Function
'====================================
Function brkv_box(byval hWnd As HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
  static Txt as zstring *300
  dim rc as RECT => (0, 0, 4, 8)
  dim scalex as Integer,scaley as Integer
  static As HWND hedit1,hcombo1,hbutdel,hbutapl
  Static vflag as Integer,vald as double
SELECT CASE Msg
CASE WM_INITDIALOG
	MapDialogRect (hwnd,@rc)
	ScaleX = rc.right/4
	ScaleY = rc.bottom/8
	fb_ModStyle(hwnd,0,WS_EX_NOPARENTNOTIFY,1)
	fb_Label (brkv2.txt,hWnd,101,2*scalex,2*scaley,250*scalex,10*scaley)

   If brkv2.vst="" Then
      brkv2.vst=mid(brkv2.txt,instr(brkv2.txt,"=")+1,25)
   End If
	hEdit1=fb_edit (brkv2.vst,hWnd,101,275*scalex,2*scaley,70*scalex,10*scaley)
	fb_ModStyle(hedit1,0,WS_EX_NOPARENTNOTIFY,1)
	fb_ModStyle(hedit1,,WS_VSCROLL,0)
   SetFocus(hedit1)
   SendMessage(hedit1,EM_SETSEL,0,-1)
   	
	hcombo1   = fb_combobox (hWnd,101,255*scalex,2*scaley,20*scalex,40*scaley)
	SendMessage(hcombo1,CB_ADDSTRING,0,Cast(LPARAM,@"<>"))
	SendMessage(hcombo1,CB_ADDSTRING,0,Cast(LPARAM,@"="))
	if brkv2.typ<>4 andalso brkv2.typ<>13 andalso brkv2.typ<>14 Then
		SendMessage(hcombo1,CB_ADDSTRING,0,Cast(LPARAM,@">"))
		SendMessage(hcombo1,CB_ADDSTRING,0,Cast(LPARAM,@"<"))
		SendMessage(hcombo1,CB_ADDSTRING,0,Cast(LPARAM,@">="))
		SendMessage(hcombo1,CB_ADDSTRING,0,Cast(LPARAM,@"<="))
	end If	
   SendMessage(hcombo1,CB_SETCURSEL,brkv2.tst-1,0)
	hButapl = fb_BUTTON("Apply",hWnd,1,170*scalex, 28*scaley, 36*scalex, 10*scaley)
	fb_ModStyle(hbutapl,0,WS_EX_NOPARENTNOTIFY,1)
	hButdel=fb_BUTTON("Delete",hWnd,2, 210*scalex, 28*scaley, 36*scalex, 10*scaley)
	fb_ModStyle(hbutdel,0,WS_EX_NOPARENTNOTIFY,1)


   txt=brkv2.vst
   vflag=1
CASE WM_COMMAND
  select case lparam
    case hButapl    'clicked apply
        if hiword(wparam)=BN_CLICKED then
            if vflag=1 then
               brkv2.tst=sendmessage(hcombo1,CB_GETCURSEL,0,0)+1
                
					brkv2.ttb=32 shr (brkv2.tst-1)
					Select case brkv2.tst
						Case 1
					    brkv2.txt+=" becomes <> "
						Case 2
					    brkv2.txt+=" becomes = "
						Case 3
					    brkv2.txt+=" becomes > "
						Case 4
					    brkv2.txt+=" becomes < "
						Case 5
					    brkv2.txt+=" becomes >= "
						Case 6
					    brkv2.txt+=" becomes <= "
					End select
					
               select case brkv2.typ
                case 2
                    brkv2.val.vbyte=valint(txt)
                    brkv2.vst=str(brkv2.val.vbyte)
                case 3
                    brkv2.val.vubyte=valuint(txt)
                    brkv2.vst=str(brkv2.val.vubyte)
                case 5
                    brkv2.val.vshort=valint(txt)
                    brkv2.vst=str(brkv2.val.vshort)
                case 6
                    brkv2.val.vushort=valuint(txt)
                    brkv.vst=str(brkv2.val.vushort)
                case 1
                    brkv2.val.vinteger=valint(txt)
                    brkv2.vst=str(brkv2.val.vinteger)
                case 7,8
                    brkv2.val.vuinteger=valuint(txt)
                    brkv2.vst=str(brkv2.val.vuinteger)
               	case Else
                    brkv2.vst=left(txt,26)'str(brkv.val.vuinteger)
                end Select
                brkv=brkv2
                SetWindowText(brkvhnd,brkv.txt+brkv.vst) 'update display
                enddialog(hwnd,0)
            end if
        end if
    case hButdel     'clicked delete
        if hiword(wparam)=BN_CLICKED then
            brkv_set(0) 'delete current break on var
            enddialog(hwnd,0)
        end if
    'case hcombo1 'combobox
    ' if hiword(wparam)=CBN_SELCHANGE then 'change kind of test
    'end if
    case hedit1 'change address
        if hiword(wparam)=EN_CHANGE then
            sendmessage(hedit1,WM_GETTEXT,26,Cast(LPARAM,@txt))
            vflag=1
            vald=val(txt)
            select case brkv2.typ
            case 2
                if vald<-128 or vald>127 then setwindowtext(hwnd,"min -128,max 127"):vflag=0
            case 3
                if vald<0 or vald>255 then setwindowtext(hwnd,"min 0,max 255"):vflag=0
            case 5
                if vald<-32768 or vald>32767 then setwindowtext(hwnd,"min -32768,max 32767"):vflag=0
            case 6
                if vald<0 or vald>65535 then setwindowtext(hwnd,"min 0,max 65535"):vflag=0
            case 1
                if vald<-2147483648 or vald>2147483648 then setwindowtext(hwnd,"min -2147483648,max +2147483647"):vflag=0
            case 7,8
                if vald<0 or vald>4294967395 then setwindowtext(hwnd,"min 0,max 4294967395"):vflag=0
            end select
        end if
    END select
	case WM_CLOSE
    enddialog(hwnd,0)
    Return 0
END SELECT
END Function
'====================================

function kill_process(text as string) as integer
    if fb_message("Kill current running Program ?",text+Chr(10)+Chr(10) _
    	           +"USE CARREFULLY SYSTEM CAN BECOME UNSTABLE, LOSS OF DATA, MEMORY LEAK"+Chr(10)+ _
                        "Try to close your program first",MB_ICONWARNING or MB_YESNO or MB_APPLMODAL) = IDYES Then
      flagkill=TRUE
      dbg_prt ("return code terminate process + lasterror "+Str(terminateprocess(dbghand,999))+" "+Str(GetLastError))
      thread_rsm()
      While prun:Sleep 500:Wend 
      return true
    else
        Return false
    endif
end Function
function attach_box(byval hWnd as HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
	dim rc as RECT => (0, 0, 4, 8),ad as UInteger,scalex as Integer,scaley as Integer
	Static As HWND hlistbox
	dim prcinfo as PROCESSENTRY32,snap as HANDLE,text As String
	Dim stext as string *200,nitem as Integer
 	SELECT CASE Msg
 		CASE WM_INITDIALOG
 			MapDialogRect (hwnd,@rc)
			ScaleX = rc.right/4
			ScaleY = rc.bottom/8
			fb_ModStyle(hwnd,0,WS_EX_NOPARENTNOTIFY,1)
			hlistbox=fb_listbox(hWnd,101,0*scalex,0*scaley,100*scalex,130*scaley)
			SendMessage(hlistbox,WM_SETFONT,Cast(WPARAM,GetStockObject(ANSI_FIXED_FONT)),0)
			snap=CreateToolhelp32Snapshot (TH32CS_SNAPPROCESS, 0)'Take snapshot of running processes
			if snap <> INVALID_HANDLE_VALUE then
				prcinfo.dwSize=sizeof(PROCESSENTRY32)
				If Process32First (snap,@prcinfo) then
					do
						text=fmt(prcinfo.szExeFile,20)+fmt(Str(prcinfo.th32ProcessID),5)
						If SendMessage(hlistbox, LB_SETITEMDATA,SendMessage(hlistbox, LB_ADDSTRING, 0,Cast(LPARAM,StrPtr(text))),prcinfo.th32ProcessID)=LB_ERR then fb_message("Error insertion data ","")
					loop while  Process32Next (snap,@prcinfo)
        		Else
					fb_message("Process list error","Failed to create process list!")
					enddialog(hwnd,0)
				End If
		   CloseHandle (snap)
		   Else
				fb_message("Process list error","INVALID_HANDLE_VALUE")
				EndDialog(hwnd,0)
			end if
 		Case WM_COMMAND
			If lparam=hlistbox then
			  if (HIWORD(wParam))=LBN_DBLCLK then
			      nitem=SendMessage(hlistbox, LB_GETCURSEL, 0, 0)
			      SendMessage(hlistbox, LB_GETTEXT,nitem,Cast(LPARAM,@stext))
			      If fb_message("Attach to this process ?",stext,MB_YESNO) = IDYES Then
			      	dbgprocid=SendMessage(hlistbox, LB_GETITEMDATA,nitem,0)
               	ThreadCreate(@dbg_attach)
               	enddialog(hwnd,0)
			      End If
			  end if
			End if
Case WM_CLOSE
     enddialog(hwnd,0)
     Return 0 'Not really used
End Select
End Function
function watch_box(byval hWnd as HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
dim rc as RECT => (0, 0, 4, 8),ad as uinteger
static scalex as Integer,scaley as Integer
Static As HWND hbutton1,hbutton2,hbutton3
static As HWND butrad(5)
SELECT CASE Msg

	CASE WM_INITDIALOG    'All of your controls are created here in the same
	
		hwtchbx=hwnd
		MapDialogRect (hwnd,@rc)
		ScaleX = rc.right/4
		ScaleY = rc.bottom/8
		fb_modstyle(hwnd,0,WS_EX_NOPARENTNOTIFY,1)
    
    	fb_Label("Current type : "+udt(varfind.ty).nm+", Select type of additional info",hwnd,,_
    	                                        2*scalex, 4*scaley, 150*scalex, 10*scaley)
    	                                        
   	butrad(1)=fb_radio("Hex FA0B",      hwnd,1,2*scalex, 14*scaley, 60*scalex, 10*scaley)
   	butrad(2)=fb_radio("Binary 11010",  hwnd,2,2*scalex, 24*scaley, 60*scalex, 10*scaley)
   	butrad(3)=fb_radio("Ascii ARXp",    hwnd,3,2*scalex, 34*scaley, 60*scalex, 10*scaley)
   	butrad(4)=fb_radio("Byte 23,78",    hwnd,4,2*scalex, 44*scaley, 60*scalex, 10*scaley)
   	butrad(5)=fb_radio("Word 2345,6789",hwnd,5,2*scalex, 54*scaley, 60*scalex, 10*scaley)
   	butrad(0)=fb_radio("None",          hwnd,0,2*scalex, 64*scaley, 60*scalex, 10*scaley)
   	sendmessage(butrad(0),BM_SETCHECK,BST_CHECKED	,0)
   	   	
		hButton1 = fb_BUTTON("Remove",hWnd,,2*scalex, 78*scaley, 30*scalex, 10*scaley)
		fb_modstyle(hbutton1,0,WS_EX_NOPARENTNOTIFY,1)
		hButton2 = fb_BUTTON("Add",hWnd,,34*scalex, 78*scaley, 30*scalex, 10*scaley)
		fb_modstyle(hbutton3,0,WS_EX_NOPARENTNOTIFY,1)
		hButton3=fb_BUTTON("Cancel",hWnd,, 66*scalex, 78*scaley, 30*scalex, 10*scaley)
		fb_modstyle(hbutton3,0,WS_EX_NOPARENTNOTIFY,1)

	Case WM_COMMAND
  		Select case lparam
		  	case hButton1,hButton2,hButton3
		      If hiword(wparam)=BN_CLICKED then
		         select case lparam
		         	case hButton1		'remove
			            watch_del(wtchidx)
			            sendmessage(hwnd,WM_CLOSE,0,0)
		         	case hButton2     'add
		           		If sendmessage(butrad(0),BM_GETCHECK,0,0)=BST_UNCHECKED Then
	            			For i As Integer =1 To 5
	            				if sendmessage(butrad(i),BM_GETCHECK,0,0)=BST_CHECKED Then
	            					watch_add(i)
	            					Exit For		
	            				EndIf
	            			Next
	            		Else
	            			fb_message("Add watched var","operation aborted, No additionnal type")
		           		End If
		           		sendmessage(hwnd,WM_CLOSE,0,0)
	            	case hButton3     'cancel, abort
	            		sendmessage(hwnd,WM_CLOSE,0,0)
	            END Select
		      End If
      End select
	Case WM_CLOSE
		hwtchbx=0
		enddialog(hwnd,0)
		Return 0 'not really used
  END SELECT
END Function
function dump_box(byval hWnd as HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
  dim Txt as zstring *300,combotyp as integer, i as integer
  dim rc as RECT => (0, 0, 4, 8),ad as uinteger
  static scalex as Integer,scaley as Integer
  Static As HWND hbutton1,hbutton2,hbutton3,hbutton4
  static As HWND hedit1,hcombo1,butrad1,butrad2,butwtch,butbrk,butmem
  SELECT CASE Msg

     CASE WM_INITDIALOG    'All of your controls are created here in the same
    
    hdumpbx=hwnd
    MapDialogRect (hwnd,@rc)
    ScaleX = rc.right/4
    ScaleY = rc.bottom/8
    fb_modstyle(hwnd,0,WS_EX_NOPARENTNOTIFY,1)
    hEdit1   = fb_edit ("",hWnd,101,2*scalex,2*scaley,60*scalex,10*scaley)
    fb_modstyle(hedit1,0,WS_EX_NOPARENTNOTIFY,1)
    fb_ModStyle(hedit1,ES_NUMBER,WS_VSCROLL,0)
    txt=Str(dumpadr)
    setfocus(hedit1)
    sendmessage(hedit1,WM_SETTEXT,0,Cast(LPARAM,@txt))
    sendmessage(hedit1,EM_SETSEL,0,-1)
    hcombo1   = fb_combobox (hWnd,101,65*scalex,2*scaley,30*scalex,40*scaley)

    txt="Integer":sendmessage(hcombo1,CB_ADDSTRING,0,Cast(LPARAM,@txt))  
    txt="Byte":sendmessage(hcombo1,CB_ADDSTRING,0,Cast(LPARAM,@txt))
    txt="uByte":sendmessage(hcombo1,CB_ADDSTRING,0,Cast(LPARAM,@txt))
    
    txt="Short":sendmessage(hcombo1,CB_ADDSTRING,0,Cast(LPARAM,@txt))
    txt="uShort":sendmessage(hcombo1,CB_ADDSTRING,0,Cast(LPARAM,@txt))
    
    txt="uInteger":sendmessage(hcombo1,CB_ADDSTRING,0,Cast(LPARAM,@txt))
    txt="Longint":sendmessage(hcombo1,CB_ADDSTRING,0,Cast(LPARAM,@txt))
    txt="uLongint":sendmessage(hcombo1,CB_ADDSTRING,0,Cast(LPARAM,@txt))
    txt="Single":sendmessage(hcombo1,CB_ADDSTRING,0,Cast(LPARAM,@txt))
    txt="Double":sendmessage(hcombo1,CB_ADDSTRING,0,Cast(LPARAM,@txt))
    select case lvtyp
    case is>7
        combotyp=lvtyp-2
    case is>3
        combotyp=lvtyp-1
    case else
        combotyp=lvtyp
    end select
    sendmessage(hcombo1,CB_SETCURSEL,combotyp-1,0)
    
   butrad1=fb_radio("Dec",hwnd,,2*scalex, 14*scaley, 20*scalex, 10*scaley)
   butrad2=fb_radio("Hex",hwnd,,24*scalex, 14*scaley, 20*scalex, 10*scaley)
    if dumpdec=0 then
        sendmessage(butrad1,BM_SETCHECK,BST_CHECKED	,0)
    else
        sendmessage(butrad2,BM_SETCHECK,BST_CHECKED	,0)
    endif
    hButton1 = fb_BUTTON("-",hWnd,1,2*scalex, 28*scaley, 18*scalex, 10*scaley)
    fb_modstyle(hbutton1,0,WS_EX_NOPARENTNOTIFY,1)
    hButton2=fb_BUTTON("+",hWnd,2, 20*scalex, 28*scaley, 18*scalex, 10*scaley)
    fb_modstyle(hbutton1,0,WS_EX_NOPARENTNOTIFY,1)
    hButton3 = fb_BUTTON("--",hWnd,3,38*scalex, 28*scaley, 18*scalex, 10*scaley)
    fb_modstyle(hbutton3,0,WS_EX_NOPARENTNOTIFY,1)
    hButton4=fb_BUTTON("++",hWnd,4, 56*scalex, 28*scaley, 18*scalex, 10*scaley)
    fb_modstyle(hbutton4,0,WS_EX_NOPARENTNOTIFY,1)
    
    butwtch=fb_BUTTON("Add watched",hWnd,991, 2*scalex, 45*scaley, 52*scalex, 10*scaley)
    
    butbrk=fb_BUTTON("--> Break on mem",hWnd,995,2*scalex,58*scaley,52*scalex,10*scaley)
 
    butmem=fb_BUTTON("M",hWnd,996,80*scalex,52*scaley,18*scalex,15*scaley)
    fb_createtooltips(butmem, "Enlarge/reduce dump memory", "",0)
    fb_ModStyle(butmem,BS_BITMAP)
    SendMessage(butmem, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM,bmb(20)))
    ' récup pour checkbox update auto ???
    'checkcase=fb_checkbox("Case",hwnd,IDFNDTXCS,42*scalex, 14*scaley, 25*scalex, 10*scaley)
 CASE WM_COMMAND
  select case lparam
    case hButton1,hButton2,hButton3,hButton4    'clicked the - button
        if hiword(wparam)=BN_CLICKED then
            select case lparam
            case hButton1
                if dumplig=1 then ad=dumpadr-16/lvnbcol else ad=dumpadr-16 end if
            case hButton2     'clicked + button
                if dumplig=1 then ad=dumpadr+16/lvnbcol else ad=dumpadr+16 end if
            case hButton3    'clicked the -- button
                ad=dumpadr-16*dumplig 
            case hButton4     'clicked ++ button
                ad=dumpadr+16*dumplig 
            END SELECT
            if readProcessMemory(dbghand,Cast(LPCVOID,ad),@txt,1,0)=0 then
                sendmessage(hdumpbx,WM_SETTEXT,0,Cast(LPARAM,@"Invalid Memory Address"))
            else
                sendmessage(hdumpbx,WM_SETTEXT,0,Cast(LPARAM,@"Manage Dump"))
                dumpadr=ad
                txt=Str(dumpadr):sendmessage(hedit1,WM_SETTEXT,0,Cast(LPARAM,@txt))
                dump_sh()
            end if
        end if
    'case IDFNDTXCS     'clicked case
    'if SendMessage(Checkcase, BM_GETCHECK,0,0)=BST_CHECKED then
    '   chkcase=4 'FR_MATCHCASE
    ' else
    '  chkcase=0
    'end if
    case hcombo1 'combobox
        if hiword(wparam)=CBN_SELCHANGE then 'change kind of unit
            combotyp=sendmessage(hcombo1,CB_GETCURSEL,0,0)+1
            select case combotyp
            case is>5 
                lvtyp=combotyp+2
            case is>3
                lvtyp=combotyp+1
            case else
                lvtyp=combotyp
            end select
            dump_set(listview1)
            dump_sh()
        end if
    case hedit1 'change address
        if hiword(wparam)=EN_CHANGE then
            sendmessage(hedit1,WM_GETTEXT,10,Cast(LPARAM,@txt))
            ad=val(txt)
            if readProcessMemory(dbghand,Cast(LPCVOID,ad),@txt,1,0)=0 then
                sendmessage(hdumpbx,WM_SETTEXT,0,Cast(LPARAM,@"Invalid Memory Address"))
            else
                sendmessage(hdumpbx,WM_SETTEXT,0,Cast(LPARAM,@"Manage Dump"))
                dumpadr=ad
                dump_sh()
            end if
        end if
    case butrad1,butrad2 'DEC/HEX
        if hiword(wparam)=BN_CLICKED then
            if sendmessage(butrad1,BM_GETCHECK,0,0)=BST_CHECKED then
                dumpdec=0
            else
                dumpdec=50
            end if
            dump_sh()
        end if
    case butwtch
      If hiword(wparam)=BN_CLICKED Then
     		varfind.ty=lvtyp
     		varfind.ad=dumpadr
     		varfind.nm="Memory ["+str(dumpadr)+"]<"
     		varfind.pt=0
     		varfind.iv=-1
         watch_set()
      End if
  	case butbrk
        if hiword(wparam)=BN_CLICKED then
            brkv2.typ=lvtyp        'change in brkv_box if pointed value
            brkv2.adr=dumpadr   'idem
            brkv2.vst=""          'idem
            brkv2.tst=1           'type of test
            brkv2.ivr=0            'not var
            brkv2.arr=0
            brkv2.psk=-2    'permanent
            brkv2.txt="Stop if  MEMORY ["+str(dumpadr)+"]<"+var_sh2(brkv2.typ,brkv2.adr)
            fb_mdialog(@brkv_box,"Test for break on value",windmain,283,25,350,50)
            hdumpbx=0
            destroywindow(hwnd)
        end if
    case butmem
        dsp_hide(4)
  END Select
case WM_CLOSE
     hdumpbx=0
     destroywindow(hwnd)
     Return 0 'not really used
  END SELECT
END Function
Sub fill_focus(l As Integer,hedit1 As HWND,hsrc As HWND)
	  	Dim f as Integer,d As Integer,c As Integer
	  	Dim src as string *1000
	  	setWindowText(hedit1,"")
	   d=l-3:If d<0 Then d=0
      f=l+10:c=sendmessage(hsrc,EM_GETLINECOUNT,0,0)-1:If f>c Then f=c
      For i As Integer =d To f
			src=chr(1)+chr(3)
			sendmessage(hsrc,EM_getline,i,Cast(LPARAM,StrPtr(src)))  'get text
			src+=Chr(13)+Chr(10)
			If i=l Then src="----------------------------------------"+Chr(13)+Chr(10)+src+"----------------------------------------"+Chr(13)+Chr(10)
			sendmessage(hedit1,EM_SETSEL,0,-1)
			sendmessage(hedit1,EM_SETSEL,-1,0)
			sendmessage(hedit1,EM_REPLACESEL,FALSE,Cast(LPARAM,@src))
      Next
      setfocus(dbgrichedit)
End Sub
function dll_name(FileHandle As HANDLE,t As Integer =1 )As String '25/01/2013 t=1 --> full name, t=2 --> short name
   Dim As ZString*251 fileName
   Dim As zstring*512 zstr,dn,tzstr=" :"
   Dim As HANDLE hfileMap
   Dim As uinteger fileSizeHi,fileSizeLo,p
	Dim As Any Ptr pmem
	Dim As String tstring 
   fileSizeLo = GetFileSize(FileHandle, @fileSizeHi)
   If fileSizeLo = 0 And fileSizeHi=0 Then Return "Empty file." ' cannot map an 0 byte file
   hfileMap = CreateFileMapping(FileHandle,0,PAGE_READONLY, 0, 1, null)
   If hfileMap Then
      pMem = MapViewOfFile(hfileMap,FILE_MAP_READ, 0, 0, 1)
      If pMem Then
      	GetMappedFileName(GetCurrentProcess(),pMem, @fileName, 250)
         UnmapViewOfFile(pMem)
         CloseHandle(hfileMap)
         If Len(fileName) > 0 Then
				getlogicaldrivestrings(511,zstr)'get all the device letters c:\ d:\ etc separate by null
				While zstr[p]
					tzstr[0]=zstr[p]'replace space by letter
					querydosdevice(tzstr,dn,511)'get corresponding device name
					If InStr(fileName,dn) Then
						tstring=fileName
						str_replace(tstring,dn,tzstr)
						If t=1 Then
							return tstring 'full name
						Else
							Return name_extract(tstring)'extract only name without path
						EndIf
					EndIf
					p+=4'next letter skip ":\<null>"
				Wend 
         Else
            return "Empty filename."
         EndIf
      EndIf
   End If
   Return "Empty filemap handle."
End Function
Function focus_box(byval hWnd as HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
  	Dim rc as RECT => (0, 0, 4, 8),scalex as Integer,scaley as Integer
  	Dim As Integer Style = WS_CHILD or WS_VISIBLE or ES_WANTRETURN or WS_VSCROLL or ES_MULTILINE Or ES_AUTOVSCROLL
  	Static As HWND hedit1,hbut1,hsrc
  	Static As Integer linenum,nblines
Select CASE Msg
	CASE WM_INITDIALOG
		focusbx=hwnd
		MapDialogRect (hwnd,@rc)
		ScaleX = rc.right/4
		ScaleY = rc.bottom/8
		hbut1=fb_BUTTON("Exec following",hWnd,992, 10*scalex, 250*scaley, 50*scalex, 10*scaley)
      fb_button("UP",hWnd,993, 60*scalex, 250*scaley, 50*scalex, 10*scaley)
      fb_button("DOWN",hWnd,994, 100*scalex, 250*scaley, 50*scalex, 10*scaley)
		fb_ModStyle(hwnd,0,WS_EX_NOPARENTNOTIFY,1)
   	hEdit1=fb_edit ("",hWnd,101,0*scalex,0*scaley,400*scalex,250*scaley,style)
   	SendMessage (hedit1,WM_SETFONT,Cast(WPARAM,fonthdl),0)
   	hsrc=dbgrichedit
   	linenum=sendmessage(hsrc,EM_EXLINEFROMCHAR,0,-1) 'get line number
   	nblines=sendmessage(hsrc,EM_GETLINECOUNT,0,0)-1
      flagfollow=FALSE
      SendMessage(hedit1,EM_SETREADONLY,TRUE,0) 
      fill_focus(linenum,hedit1,hsrc)
      Return TRUE
   CASE WM_COMMAND   
  	  	Select case As Const LoWord(wparam)
  	  		Case 992
	  			If flagfollow=true Then
	  				flagfollow=FALSE
	  				setWindowText(hbut1,"Exec following")
	  			Else
	  				flagfollow=TRUE
	  				setWindowText(hbut1,"No Exec following")
	  				hsrc=richedit(curtab)
	  				linenum=sendmessage(hsrc,EM_EXLINEFROMCHAR,0,-1) 'get line number
			   	nblines=sendmessage(hsrc,EM_GETLINECOUNT,0,0)-1
			      fill_focus(linenum,hedit1,hsrc)
	  			EndIf
  	  		Case 993
  	  			If linenum>0 Then linenum-=1:fill_focus(linenum,hedit1,hsrc)
  	  		Case 994
  	  			If linenum<nblines Then linenum+=1:fill_focus(linenum,hedit1,hsrc)
  	  	End Select
  	  	Return TRUE
	Case UM_FOCUSSRC
		linenum=sendmessage(dbgrichedit,EM_EXLINEFROMCHAR,0,-1)
	   fill_focus(linenum,hedit1,hsrc)
      Return TRUE
	case WM_CLOSE
     	focusbx=0
     	flagfollow=FALSE 'not for all cases but by default
     	destroywindow(hwnd)
     	Return TRUE
End Select  
End Function
'======================================================================
function help_box(byval hWnd as HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
  	Dim rc as RECT => (0, 0, 4, 8)
  	Dim f as Integer,inc as integer=32000,wstrg As WString *32001,bufw As UShort
  	Dim As String text
  	Dim As Integer Style = WS_CHILD or WS_VISIBLE or ES_WANTRETURN or WS_VSCROLL or ES_MULTILINE Or ES_AUTOVSCROLL
  	Static As Byte wrapflag,buf(32004)
  	Static As HWND hedit1 ,hbut
  	Static scalex as Integer,scaley as Integer
Select CASE Msg
	CASE WM_INITDIALOG
		helpbx=hwnd
		MapDialogRect (hwnd,@rc)
		ScaleX = rc.right/4
		ScaleY = rc.bottom/8
		fb_ModStyle(hwnd,0,WS_EX_NOPARENTNOTIFY,1)
		If helptyp<>5 Andalso helptyp<>6 Then
			hEdit1=fb_edit ("",hWnd,101,0*scalex,0*scaley,400*scalex,250*scaley)
			SendMessage(hedit1,WM_SETFONT,Cast(WPARAM,GetStockObject(ANSI_FIXED_FONT)),0)
		EndIf
		If helptyp=1 Then 'threads list
			For i as integer =0 to threadnb
				Dim As Integer thid,p
				thid=thread(i).id
				'text+="ThreadID="+Str(thid)+"/"+hex(thid)+" / Handle="+Str(thread(i).hd)+"/"+hex(thread(i).hd)+" : "
				text+="ID="+fmt2(Str(thid),4)+"/"+fmt2(hex(thid),4)+" HD="+fmt2(Str(thread(i).hd),4)+"/"+fmt2(hex(thread(i).hd),3)+" : "
				If thread(i).sv<>-1 Then 'thread debugged	
					p=proc_find(thid,KLAST)
					text+=proc(procr(p).idx).nm
					If threadhs=thread(i).hd Then text+="(next execution)"
				Else
					text+="(not debugged, hidden)"
				End If
				text+=Chr(13)+Chr(10)
			Next
			SetWindowText(hedit1,StrPtr(text))
		ElseIf helptyp=2 Then 'process list
			dim prcinfo as PROCESSENTRY32,snap as HANDLE
 			snap=CreateToolhelp32Snapshot (TH32CS_SNAPPROCESS, 0)'Take snapshot of running processes
			if snap <> INVALID_HANDLE_VALUE then
				prcinfo.dwSize=sizeof(PROCESSENTRY32)
				text="file Process name     ID  Nthread parent id"+Chr(13)+Chr(10)  
				If Process32First (snap,@prcinfo) then
					do
						text+=fmt(prcinfo.szExeFile,20)+fmt(Str(prcinfo.th32ProcessID),5)+fmt(Str(prcinfo.cntThreads),3)+fmt(Str(prcinfo.th32ParentProcessID),5)+Chr(13)+Chr(10)    
					loop while  Process32Next (snap,@prcinfo)
        		Else
					fb_message("Process list error","Failed to create process list!")
		      End If
	        	CloseHandle (snap)
			End if
         SetWindowText(hedit1,StrPtr(text))
         
		ElseIf helptyp=3 then
            f = freefile 
            Open exepath+"\fbdebug_compil.log" for binary as #f 
            get #f,,buf() 'get compil log
            close #f
            setWindowText(hedit1,@buf(0))
            
		ElseIf helptyp=4 Then 'string zstring
			inc=32000
			f=stringadr
			while inc<>0
				If ReadProcessMemory(dbghand,Cast(LPCVOID,f+inc),@buf(0),4,0) then
        			f+=inc
        			Exit While '04/01/2013
				else
        			inc\=2
				end If
			Wend
         ReadProcessMemory(dbghand,Cast(LPCVOID,stringadr),@buf(0),f-stringadr,0)
         buf(f-stringadr+1)=0 'end of string if lenght >32000
         setWindowText(hedit1,@buf(0))
         hbut=fb_BUTTON("Wrapping",hWnd,991, 10*scalex, 250*scaley, 40*scalex, 10*scaley)
         
		ElseIf helptyp=5 Then 'wstring 
			hEdit1   = fb_editw (WStr(""),hWnd,101,0*scalex,0*scaley,400*scalex,250*scaley)
      	inc=0:wstrg=""
      	ReadProcessMemory(dbghand,Cast(LPCVOID,stringadr),@bufw,2,0)
         While bufw
         	wstrg[inc]=bufw
         	inc+=1
         	If inc=32000 Then Exit While 'limit if wstring >32000
         	ReadProcessMemory(dbghand,Cast(LPCVOID,stringadr+inc*2),@bufw,2,0)
         Wend
         WStrg[inc]=0 'end of wstring
         SendMessage (hedit1,WM_SETFONT,Cast(WPARAM,fonthdl),0)
         setwindowtextw(hedit1,wstrg)
         
		ElseIf helptyp=6 Then 'enums list
			enum_show(hwnd)
		ElseIf helptyp=7 Then 'dlls list
			For i As Integer=1 To dllnb
				text+=dlldata(i).fnm
				If dlldata(i).hdl=0 then text+="  Currently not used"
				text+=Chr(13)+Chr(10)
			Next
			SetWindowText(hedit1,StrPtr(text))
		ElseIf helptyp=8 Then 'shortcut keys list
			For i As Integer =0 To shcutnb-1
				If shcut(i).sccur Then
					text+=fmt(shcut_txt(shcut(i).sccur,2),18)+menu_gettxt(shcut(i).scmenu,shcut(i).scidnt)
					text+=Chr(13)+Chr(10)
				EndIf
			Next
			SetWindowText(hedit1,StrPtr(text))
		EndIf
      fb_ModStyle(hedit1,0,WS_EX_NOPARENTNOTIFY,1)
      fb_ModStyle(hedit1,WS_VSCROLL or WS_HSCROLL,0)
      SendMessage(hedit1,EM_SETREADONLY,TRUE,0)
        
' just for test       
'CAUTION it's displayed behind the edit area so change the y coordinate       	
	'Static MyhBmp as HBITMAP
'		MyhBmp = fb_LOADBMP("toolbar2.bmp")
'	Case WM_PAINT
'
'		static  ps       AS   PAINTSTRUCT
'		static  hdc      AS   long
'		static  hdcMem   AS   long
'  		hdc = BeginPaint (hWnd, @ps)
'  		hdcMem = CreateCompatibleDC (hdc)
''-----------------------------------
'  		SelectObject (hdcMem, MyhBmp)
' 
'		
' 		''''''StretchBlt (hdc,1,1,L,H,hdcMem,0,0,L0,H0,SRCCOPY)
' 		bitblt(hdc,100,100,396,16,hdcMem,0,0,SRCCOPY)
''-----------------------------------
'  		DeleteDC (hdcMem)
'  		EndPaint (hWnd,@ps)
'		'end of test			
	CASE WM_COMMAND
  		If LoWord(wparam)=991 Then
			destroywindow (hedit1)
  			If wrapflag Then
  				hEdit1=fb_edit ("",hWnd,101,0*scalex,0*scaley,400*scalex,250*scaley)
  				wrapflag=0
  				setWindowText(hbut,"Wrapping")
  			Else
  				hEdit1=fb_edit ("",hWnd,101,0*scalex,0*scaley,400*scalex,250*scaley,style)
 				wrapflag=1
         	setWindowText(hbut,"No Wrapping")
  			EndIf
  			SendMessage(hedit1,EM_SETREADONLY,TRUE,0)
  			fb_ModStyle(hedit1,0,WS_EX_NOPARENTNOTIFY,1)
         fb_ModStyle(hedit1,WS_VSCROLL or WS_HSCROLL,0)
  			setWindowText(hedit1,@buf(0))
  		EndIf
  		Return TRUE
	case WM_CLOSE
     	helpbx=0
     	destroywindow(hwnd)
     	Return TRUE
End SELECT
END Function

function tuto_box(byval hWnd As HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) as Integer '03/01/2013
	dim rc as RECT => (0, 0, 4, 8)
	dim scalex As Integer,scaley As Integer,bg As Integer,ZStr As ZString Ptr
	static hedit1 As HWND,cpt As Integer,buf(100000) as Byte,f as Integer,l as Integer
	
   Select CASE Msg
    	
   	Case WM_INITDIALOG    'All of your controls are created here in the same
        tutobx=hwnd
        MapDialogRect (hwnd,@rc)
        ScaleX = rc.right/4
        ScaleY = rc.bottom/8
        fb_ModStyle(hwnd,0,WS_EX_NOPARENTNOTIFY,1)
 '       fb_label(inputtxt,hwnd,100,2*scalex,2*scaley,150*scalex,10*scaley,SS_LEFT)
        hEdit1   = fb_edit ("",hWnd,101,8*scalex,1*scaley,300*scalex,50*scaley)
        fb_modstyle(hedit1,0,WS_EX_NOPARENTNOTIFY,1)
        setwindowtext(hedit1,"Begin tutorial, click on button NEXT for next step"+Chr(13)+Chr(10)+"Click on button HELP for help on some part of screen")
        SendMessage(hedit1,EM_SETREADONLY,TRUE,0)
        fb_BUTTON("Next",hWnd,103,8*scalex, 51*scaley, 36*scalex, 10*scaley)
        fb_button("Help",hWnd,104,78*scalex, 51*scaley, 36*scalex, 10*scaley)
        cpt=1 'first instruction
        flagtuto=1

	   	If dir(exepath+"\tutorial.txt")="" Then
	   		fb_message("Launching tutorial","""File "+exepath+"\tutorial.txt"" not found"+Chr(13)+Chr(10)+" can't continue tutorial.")
	   		sendmessage(hwnd,WM_close,0,0)
	   		Return 0
	   	EndIf
	   	Clear(buf(0),0,100000)
	    	f = freefile 
	    	open exepath+"\tutorial.txt" for binary as #f 
	    	l=lof(f)
	    	If l>100000 Then 
	    		fb_message("Launching tutorial","""File "+ExePath+"\tutorial.txt"" too large ("+Str(l)+">"+Str(100000)+") not loaded"+Chr(13)+Chr(10)+"Can't continue tutorial.")
	    		Close #f 
	   		sendmessage(hwnd,WM_close,0,0)
	   		Return 0
	    	else
		    	get #f,,buf() 'get source
		   End if
	    	close #f  
  			f=0
  			
  			If Dir(ExePath+"\tutorial.exe")="" Then 'tutorial.exe
				fb_message("Launching tutorial","""File "+exepath+"\tutorial.exe"" not found."+Chr(13)+Chr(10)+" can't continue tutorial.")
	   		sendmessage(hwnd,WM_close,0,0)
	  	   	Return 0
	   	EndIf
   	Case WM_COMMAND
        select case loword(wparam)
        	case 103   'next

		    	bg=f 'get text
		    	While f<l
		    		If buf(f)=Asc("#") AndAlso buf(f+1)=Asc("#") AndAlso buf(f+2)=Asc("#") Then
			    		buf(f)=0
			    		zstr=@buf(bg)
			    		f=f+5
			    		Exit While
		    		EndIf
		    		f+=1
		    	Wend
		    	setwindowtext(hedit1,*zstr)
         	Select case cpt
        			Case 1
						surround(butfile)
         		Case 2
	         		treat_file(ExePath+"\tutorial.exe")
	         		flagtuto=1
	         		redrawwindow(butfile,0,0, RDW_INVALIDATE)
         		Case 3
         			surround(dbgrichedit)
         		Case 4
         			redrawwindow(dbgrichedit,0,0, RDW_INVALIDATE)
						surround(butstep)
         		Case 5
	        			redrawwindow(butstep,0,0, RDW_INVALIDATE)
		        		flagtuto=2
		        		SendMessage(windmain,WM_COMMAND,makelong(IDBUTSTEP,BN_CLICKED),null)
         		Case 6
	        			TrackPopupMenuEx(menuedit, TPM_LEFTALIGN or TPM_RIGHTBUTTON, 500, 150, windmain,byval NULL)
         		Case else
        				sendmessage(hwnd,WM_close,0,0)	
        		End Select
			   cpt+=1
			Case 104 'HELP
				flagtuto=-1
				SendMessage(windmain, WM_SYSCOMMAND, SC_CONTEXTHELP, NULL)
				flagtuto=1
         End select
   	case WM_CLOSE
    			flagtuto=-1
            tutobx=0
    			destroyWindow(hwnd)
    			Return 0
    end Select

end function
'====================================
Function edit_box(byval hWnd as HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
  static Txt as zstring *301
  dim rc as RECT => (0, 0, 4, 8)
  dim as Integer scalex ,scaley,p2
  static As HWND hedit1,hedit2,hbutdel,hbutapl,hbutdmp
  Static adr as UInteger,vflag as Integer
  dim edt as valeurs,tvi as TVITEM,aptr As UInteger,vald as Double
SELECT CASE Msg
CASE WM_INITDIALOG
        If (varfind.ty=4 or varfind.ty=13 or varfind.ty=14 or varfind.ty=15) and varfind.pt=0 Then
           fb_message("Edit variable error","Select only a numeric variable"+chr(13)+"For string use change with dump")
           var_dump(varfind.tv)
           enddialog(hwnd,0):exit function
        End if
        If varfind.ty>15 and varfind.pt=0 And udt(varfind.ty).en=0 then
           fb_message("Edit variable error","Select only a numeric variable")
           enddialog(hwnd,0):exit function
        End If
        MapDialogRect (hwnd,@rc)
        ScaleX = rc.right/4
        ScaleY = rc.bottom/8
        fb_ModStyle(hwnd,0,WS_EX_NOPARENTNOTIFY,1)
        
        tvI.mask       = TVIF_TEXT
        tvI.pszText    = @(txt)
        tvI.hitem      = varfind.tl
        tvI.cchTextMax = 300
        SendMessage(varfind.tv,TVM_GETITEM,0,Cast(LPARAM,@tvi))
        fb_Label (txt,hWnd,101,2*scalex,2*scaley,250*scalex,10*scaley)

         txt=mid(txt,instr(txt,"=")+1,25)       
        hEdit1=fb_edit (Str(Val(txt)),hWnd,101,275*scalex,2*scaley,70*scalex,10*scaley)
        fb_ModStyle(hedit1,0,WS_EX_NOPARENTNOTIFY,1)
        fb_ModStyle(hedit1,,WS_VSCROLL,0)
   		SetFocus(hedit1)
   		SendMessage(hedit1,EM_SETSEL,0,-1)
   
        If varfind.pt Then 'pointer
                If varfind.pt>220 then
                   p2=varfind.pt-220
                ElseIf varfind.pt>200 then
                   p2=varfind.pt-200
                Else
                   p2=varfind.pt
                End if
                aptr=varfind.ad
                For j as integer = 1 to p2 'only the last pointer is displayed
                   ReadProcessMemory(dbghand,Cast(LPCVOID,aptr),@aptr,4,0)
                   fb_Label (str(aptr),hWnd,101,2*scalex,20*scaley,50*scalex,10*scaley)
                Next
                adr=aptr
                If adr Then 'if null address don't anything 
                        If varfind.pt>200 Then
                           fb_label (proc_name(adr),hWnd,101,65*scalex,20*scaley,150*scalex,10*scaley) 'proc name
                        Else
               txt=var_sh2(varfind.ty,adr):txt=Mid(txt,instr(txt,"=")+1,90)
                           fb_label (txt,hWnd,101,65*scalex,20*scaley,150*scalex,10*scaley) 'pointed value
                        End if
                        if (varfind.ty<>4 and varfind.ty<13 And varfind.pt<200) Or  udt(varfind.ty).en Then
                                 hEdit2=fb_edit (Str(Val(txt)),hWnd,101,275*scalex,20*scaley,70*scalex,10*scaley)
                                 fb_ModStyle(hedit2,,WS_VSCROLL,0)
                        End If
                        hButdmp=fb_BUTTON("Ptr dump",hWnd,3, 130*scalex, 32*scaley, 36*scalex, 10*scaley)
                        fb_ModStyle(hbutdel,0,WS_EX_NOPARENTNOTIFY,1)
                Else
                        fb_label ("Null address, Nothing to display",hWnd,101,65*scalex,20*scaley,150*scalex,10*scaley)
                End If
        End If   
        hButapl = fb_BUTTON("Apply",hWnd,1,170*scalex, 32*scaley, 36*scalex, 10*scaley)
        fb_ModStyle(hbutapl,0,WS_EX_NOPARENTNOTIFY,1)
        hButdel=fb_BUTTON("Cancel",hWnd,2, 210*scalex, 32*scaley, 36*scalex, 10*scaley)
        fb_ModStyle(hbutdel,0,WS_EX_NOPARENTNOTIFY,1)

   vflag=0
   if udt(varfind.ty).en then varfind.ty=7 'enum treated as integer, here just for control

CASE WM_COMMAND
  select case lparam
  	Case hButapl    'clicked apply
        if hiword(wparam)=BN_CLICKED then
            if vflag Then
                    If vflag=1 Then
                            If varfind.pt Then varfind.ty=8
                    Else
                            varfind.ad=adr
                    EndIf
                select case varfind.ty
                case 2
                    edt.vbyte=valint(txt) :p2=1
                case 3
                    edt.vubyte=valuint(txt) :p2=1
                case 5
                    edt.vshort=valint(txt) :p2=2
                case 6
                    edt.vushort=valuint(txt) :p2=2
                case 1
                    edt.vinteger=valint(txt) :p2=4
                case 7,8
                    edt.vuinteger=valuint(txt) :p2=4
                case 9
                    edt.vlinteger=vallng(txt) :p2=8
                case 10
                    edt.vulinteger=valulng(txt) :p2=8
                case 11
                    edt.vsingle=val(txt) :p2=4
                case 12
                    edt.vdouble=val(txt) :p2=8
                case else
                    edt.vuinteger=valuint(txt) :p2=4
                end select
                writeprocessmemory(dbghand,Cast(LPVOID,varfind.ad),@edt,p2,0)
                var_sh()
                dump_sh()
                enddialog(hwnd,0)
            end if
        end if
  	Case hButdel     'clicked delete
        if hiword(wparam)=BN_CLICKED then
            enddialog(hwnd,0)
        end if
  	case hedit1,hedit2 '
        if hiword(wparam)=EN_CHANGE Then
            vald=val(txt)
            If lparam=hedit1 Then
            	vflag=1
            	sendmessage(hedit1,WM_GETTEXT,25,Cast(LPARAM,@txt))
            Else
            	vflag=2
            	sendmessage(hedit2,WM_GETTEXT,25,Cast(LPARAM,@txt))
            End If
            select case varfind.ty
                    case 2
                if vald<-128 or vald>127 then setwindowtext(hwnd,"min -128,max 127"):vflag=0
                    case 3
                if vald<0 or vald>255 then setwindowtext(hwnd,"min 0,max 255"):vflag=0
                    case 5
                if vald<-32768 or vald>32767 then setwindowtext(hwnd,"min -32768,max 32767"):vflag=0
                    case 6
                if vald<0 or vald>65535 then setwindowtext(hwnd,"min 0,max 65535"):vflag=0
                    case 1
                if vald<-2147483648 or vald>2147483648 then setwindowtext(hwnd,"min -2147483648,max +2147483647"):vflag=0
                    Case 7,8
                if vald<0 or vald>4294967395 then setwindowtext(hwnd,"min 0,max 4294967395"):vflag=0
            end select
        end If
  	Case hbutdmp
                  lvtyp=varfind.ty:dumpadr=adr
                  Select case lvtyp        
                Case 13 'string
                          lvtyp=2 'default for string
                          ReadProcessMemory(dbghand,Cast(LPCVOID,dumpadr),@dumpadr,4,0)'string address
                Case 4,14 'f or zstring
                lvtyp=2
                Case IS>15
                lvtyp=8 'default for pudt and any
                  End Select
                dump_set(listview1)
                dump_sh()
                enddialog(hwnd,0)
   End select
case WM_CLOSE
    enddialog(hwnd,0)
    Return 0 'not really used
END SELECT
END Function
'======================================================================
sub load_sources(n As integer)
   dim l as Integer,f as Integer,buf(MAXSRCSIZE) as Byte
   If flagrestart=-1 Then
	   For i As Integer=n To sourcenb ' main index =0
	   	If FileExists(source(i))=0 Then fb_message("Loading Source error","File : "+source(i)+" not found",MB_ICONERROR Or MB_SYSTEMMODAL):Continue For'12/05/2013
	   	Clear(buf(0),0,MAXSRCSIZE)
	    	f = freefile 
	    	open source(i) for binary as #f 
	    	l=lof(f)
	    	If l>MAXSRCSIZE Then 
	    		fb_message("Loading Source error","File : "+source(i)+" too large ("+Str(l)+">"+Str(MAXSRCSIZE)+") not loaded",MB_ICONERROR) '12/05/2013
	    	else
		    	get #f,,buf() 'get source
		   End if
	    	close #f
	    	SendMessage(richedit(i),EM_EXLIMITTEXT,0,l+10000) 'put file size
	    	setWindowText(richedit(i),@buf(0))
	    	tab_add(i,htab1,LCase(name_extract(source(i))))
			If FileDateTime (source(i))>exedate Then
				fb_message("Loading source file","WARNING Date of "+source(i)+Chr(10)+Chr(13)+" is > date of exe "+exename,MB_ICONWARNING Or MB_SYSTEMMODAL) '06/02/2013
			EndIf
	   Next
		EnableMenuItem(menutools,IDHIDLOG,MF_GRAYED) 'log file tab canceled so option menu grayed 09/06/2013
		if hgltflag then hglt_lines(n,sourcenb)
   Else 'restart with same exe, only the main files are not loaded, dll sources are removed
		For i As Integer=sourcenb+1 To flagrestart
			setWindowText(richedit(i),""):ShowWindow(richedit(i),SW_HIDE)'hide all the exceding windows (>sourcenb)
			sendmessage(htab1,TCM_DELETEITEM ,i,0) 'delete tabs
		Next
		flagrestart=-1
	EndIf 	
   If n then Exit Sub 'not need to execute next lines
	curtab=dbgmain
	exrichedit(dbgmain)
	menu_update(IDCMPNRUN,"Compile and run "+dbgsrc)
	
	For j As Integer =0 To procnb 'As .nu not consistent for main '29/11/2012
		Dim As UInteger temp=proc(j).db'14/12/2012
		If proc(j).nm="main" then
			For i As Integer =1 To linenb
				If rline(i).ad>temp Then 'found first line of main
					proc(j).nu=rline(i).nu:rlineold=i '14/12/2012
					Exit For,For
				EndIf
			Next
		End If
	Next	 	

End Sub
Function check_source(sourcenm As String) As Integer ' check if source yet stored
   For i As Integer=0 To sourcenb
      If source(i)=sourcenm Then Return i 'found
	Next
	Return -1 'not found
End Function
sub save_source()
   Dim f As Integer,buf as zstring *200000,a As Integer,bufp as zstring Ptr
	getWindowText(dbgrichedit,@buf,199999)
	for a=0 to 199999
		If buf[a]=0 then exit for
	next
	kill dbgsrc
	f = freefile 
	bufp=@buf
	open dbgsrc for binary access write as #f
	put #f,,bufp[0],a-1 'write source
	close #f
End Sub
'===============================================================
Sub log_show()
	Dim f As Integer,buffer As Byte Ptr, l As Integer,flaguse As Integer
If (flaglog And 2) Then 'close if needed
	flaglog And=1
	dbg_prt(" $$$$___CLOSE ALL___$$$$ ")
	flaguse=1
EndIf

if dir(exepath+"\dbg_log_file.txt")="" Then
	fb_message("Display dbg_log_file.txt","File doesn't exist")
	Exit Sub
EndIf

f = freefile 
open ExePath+"\dbg_log_file.txt" for binary as #f 
l=lof(f)+1
buffer = Allocate(l)
If buffer=0 Then
	close #f
	fb_message("Display dbg_log_file.txt","Unable to allocate memory")
	Exit Sub
EndIf
get #f,,*buffer,l-1 'get file
close #f
*(buffer+l-1)=0 'null-terminated string
SendMessage(richedit(sourcenb+1),EM_EXLIMITTEXT,0,l)
SetWindowText(richedit(sourcenb+1),buffer)
Deallocate(buffer)
source(sourcenb+1)="Log file"
EnableMenuItem(menutools,IDHIDLOG,MF_ENABLED) 'enable option menu 09/06/2013
l=SendMessage(htab1,TCM_GETITEMCOUNT,0,0)
If l>sourcenb+1 Then SendMessage(htab1,TCM_DELETEITEM,l-1,0)'To avoid adding of another empty tab named also log file
tab_add(sourcenb+1,htab1,LCase(name_extract(source(sourcenb+1))))
exrichedit(sourcenb+1)
If flaguse Then flaglog Or=2
End Sub
Sub log_hide() '07/06/2013
Dim As Integer l=SendMessage(htab1,TCM_GETITEMCOUNT,0,0)
	'If l>sourcenb+1 Then 'log file currently displayed
		SendMessage(htab1,TCM_DELETEITEM,l-1,0) 'remove tab
		If sourcenb=-1 Then 'only log file 
			showWindow(richedit(sourcenb+1),SW_HIDE) 'to hide 
		Else
			exrichedit(sourcenb) 'to show first file
		EndIf
		EnableMenuItem(menutools,IDHIDLOG,MF_GRAYED)'09/06/2013
	'End If
End Sub
function prep_debug(fname As string) As String
dim as integer pst
Dim As String exenm
'start compil
if fbcexe<>"" Then
   ''start compile, log in fbcompil.log
    Shell(""""""+fbcexe+""""+" -v  -w 1 -g "+cmdlfbc+" """+fname+""""+" >"""+ExePath+"\fbdebug_compil.log""")
    pst=InStr(fname,"."):If pst=0 Then pst=999
    exenm=Left(fname,pst)+"exe"
    if dir(exenm)="" then
        if helpbx then destroywindow(helpbx)
        helptyp=3
        fb_dialog(@help_box,"Exe not created : Compilation log",windmain,2,2,400,250)
        return ""
    else
        'fb_message("Compile ok","start debugging...")
        return exenm
    end if
else
    fb_message("Compile error","[FBC]=<path><fbc.exe> not in fbdebugger.ini")
    return ""
end if
end function
'======================================================================
sub ini_read()

    dim filein As Integer,lineread as String, c As Integer=-1,w As Integer,b As Integer

    if dir(exepath+"\fbdebugger.ini")="" then
       'fb_message("Init Error","fbdebugger.ini doesn't exist"+chr(10)+"compile impossible")
       Exit sub
    end if
    Filein = FreeFile
    OPEN exepath+"\"+"fbdebugger.ini" FOR INPUT AS #Filein
    DO WHILE NOT EOF(Filein)
        line input #filein,lineread
        if left(lineread,6)="[FBC]=" then
            lineread=rtrim(mid(lineread,7))
            If instr(lineread,"fbc.exe")=0 Then lineread+=".exe"
            if dir(lineread)="" then
                fb_message("Init Error","fbc.exe not found, searching : "+lineread)
            else
                fbcexe=lineread
            end if
        elseif left(lineread,6)="[IDE]=" then
            lineread=rtrim(mid(lineread,7))
            If instr(lineread,".exe")=0 Then lineread+=".exe"
            if dir(lineread)="" then
                'fb_message("Init Error","<ide>.exe not found")
            else
                ideexe=lineread
                menu_update(IDFILEIDE,"Launch "+ideexe)
            end If
        elseif left(lineread,6)="[EXE]=" Then
        		lineread=rtrim(mid(lineread,7))
        		if dir(lineread)<>"" and instr(lineread,".exe") Then
        			c+=1
        			savexe(c)=lineread:cmdexe(c)="" '27/02/2013
        			w=-1:b=0
        		EndIf
        elseif left(lineread,6)="[CMD]=" Then
        		cmdexe(c)=rtrim(mid(lineread,7))
        ElseIf left(lineread,6)="[WTC]=" Then
        		w+=1
        		wtchexe(c,w)=rtrim(mid(lineread,7))
        ElseIf left(lineread,6)="[BRK]=" Then '27/02/2013
        		b+=1
        		brkexe(c,b)=rtrim(mid(lineread,7))
        elseif left(lineread,6)="[TTP]=" Then
        		If RTrim(mid(lineread,7,999))="TRUE" Then
        			flagtooltip=TRUE
        		Else
        			flagtooltip=FALSE
        		EndIf
        		'activate or inactive the tooltips
    			sendmessage (fb_hToolTip,TTM_ACTIVATE, cast(WPARAM,flagtooltip),0)
        ElseIf left(lineread,6)="[FTN]=" Then	
    			font_change(rtrim(mid(lineread,7)))
        elseif left(lineread,6)="[FTS]=" Then
        		font_change(,ValInt(RTrim(mid(lineread,7))))
        elseif left(lineread,6)="[DPO]=" Then
        		dspofs=ValInt(RTrim(mid(lineread,7)))
        elseif left(lineread,6)="[JIT]=" then
            jitprev=rtrim(mid(lineread,7))
        elseif left(lineread,6)="[HLK]=" then
        		If RTrim(mid(lineread,7))="TRUE" Then
        			hgltflag=TRUE
        		Else
        			hgltflag=FALSE
        		EndIf
        elseif left(lineread,6)="[CRE]=" Then 'color richedit
            clrrichedit=ValInt(RTrim(mid(lineread,7)))
     			For i As Integer=0 To MAXSRC
  					sendmessage(richedit(i),EM_SETBKGNDCOLOR,0,clrrichedit)
     			Next
        elseif left(lineread,6)="[CRK]=" Then	'color highlighted keywords
        		clrkeyword=ValInt(RTrim(mid(lineread,7)))
        elseif left(lineread,6)="[CCL]=" Then	'color current line
        		clrcurline=ValInt(RTrim(mid(lineread,7)))
        elseif left(lineread,6)="[CTB]=" Then	'color tempo breakpoint
        		clrtmpbrk=ValInt(RTrim(mid(lineread,7)))
        elseif left(lineread,6)="[CPB]=" Then	'color perm breakpoint
        		clrperbrk=ValInt(RTrim(mid(lineread,7)))
        elseif left(lineread,6)="[LOG]=" Then	'type of log
        		flaglog=ValInt(RTrim(mid(lineread,7)))
        elseif left(lineread,6)="[PST]=" Then	'type of proc sort
        		procsort=ValInt(RTrim(mid(lineread,7)))
        elseif left(lineread,6)="[SCK]=" Then	'shcut keys
        		shcut_ini(RTrim(mid(lineread,7)))	
        end if        
    Loop
    CLOSE #Filein
    exename=savexe(0)
    fb_UpdateTooltip(fb_hToolTip,butrrune,"Restart "+exename,"",0)
    'crc_init() 'for checksum
end sub
'======== init =========================================
sub re_ini()
prun=FALSE
curlig=0
runtype=RTOFF
brkv.adr=0 'no break on var
brknb=0 'no break on line
brkol(0).ad=0   'no break on cursor

setwindowtext(hcurline,"")
setwindowtext(brkvhnd,"Break on var")
setwindowtext(windmain,"Debug")

SendMessage(listview1,LVM_DELETEALLITEMS,0,0) 'dump
SendMessage(tviewvar,TVM_DELETEITEM,0,Cast(LPARAM,TVI_ROOT)) 'procs/vars
SendMessage(tviewprc,TVM_DELETEITEM,0,Cast(LPARAM,TVI_ROOT)) 'procs
SendMessage(tviewthd,TVM_DELETEITEM,0,Cast(LPARAM,TVI_ROOT)) 'threads

ShowWindow(tviewcur,SW_HIDE):tviewcur=tviewvar:ShowWindow(tviewcur,SW_SHOW)
SendMessage(htab2,TCM_SETCURSEL,0,0)
if dsptyp then dsp_hide(dsptyp)
dsp_sizecalc
threadnb=-1
If flagrestart=-1 Then 'add test for restart without loading again all the files 21/07/2013 
	setwindowtext(dbgrichedit,"Your source")
	sendmessage(htab1,TCM_DELETEALLITEMS ,0,0) 'zone tab
	For i As Integer=0 To MAXSRC:setWindowText(richedit(i),""):ShowWindow(richedit(i),SW_HIDE):Next
EndIf
sourcenb=-1:dllnb=0
vrrnb=0:procnb=0:procrnb=0:linenb=0:cudtnb=0:arrnb=0:procr(1).vr=1:procin=0:procfn=0:procbot=0:proctop=FALSE
proc(1).vr=VGBLMAX+1 'for the first stored proc 
dumpadr=0
'flaglog=0:dbg_prt(" $$$$___CLOSE ALL___$$$$ "):flagtrace=0
flagmain=TRUE:flagattach=FALSE:flagkill=FALSE
udtcpt=0:udtcptmax=0
For i As Integer = 0 To 3 :SendMessage(dbgstatus,SB_SETTEXT,i,Cast(LPARAM,@"")) : Next
vrbgbl=0:vrbloc=VGBLMAX:vrbgblprev=0
shwexp_del() 'destroy all shwexp boxes
'reset bookmarks
sendmessage(bmkh,CB_RESETCONTENT,0,0)
bmkcpt=0:For i As Integer =1 To BMKMAX:bmk(i).ntab=-1:Next
EnableMenuItem(menuedit,IDNXTBMK,MF_GRAYED)
EnableMenuItem(menuedit,IDPRVBMK,MF_GRAYED)
EnableMenuItem(menutools,IDHIDLOG,MF_GRAYED) '09/06/2013
compinfo="" 'informations about compilation
threadprv=0 '12/02/2013
threadsel=0 '15/03/2013
hgltmax=20000 'for highlighting keywords
hgltpt=0
redim hgltdata(hgltmax) as tmodif
redim trans(70000)
Trans(1)="1"
Trans(2)="2"
Trans(3)="1"
trans(4)="8"
trans(5)="8"
Trans(6)="9"
trans(7)="10"
trans(8)="5"
Trans(9)="6"
Trans(10)="2"
Trans(11)="3"
Trans(12)="11"
trans(13)="12"
End sub
'================================================================
sub treat_file(f As string)
    dim  as string ffinal,cmdline=cmdexe(0)
    Dim as Integer p
If prun andalso kill_process("Trying to launch but debuggee still running")=false Then
    exit sub
end If
re_ini() 'init all

If f="£$_NO$FILE_$£" Then 'call by button files
   ffinal=fb_getfilename("Select Exe file","pgm *.exe or .bas|*.exe;*.bas||",0,0,0,"") 
elseif f="" then 'Fbdebugger launched by shell eventually with parameters 
   p=InStr(Command,".exe") 
   If p Then 'fbdebugger <name exe>.exe param 1 param2 
        ffinal=Left(Command,p+3) 
        cmdline=Trim(Mid(Command,p+4)) 
   Else 
      p=InStr(Command,".bas") 
      If p Then 'fbdebugger <name bas>.bas compilparam 
         ffinal=Left(Command,p+3) 
         cmdlfbc=Trim(Mid(Command,p+4)) 
      Else              
			p=InStr(Command,"-p")
			if p<>0 and InStr(Command,"-e")<>0 and InStr(Command,"-g")<>0 then 'started by 
			  dbgprocid=valint(mid(command,P+3))
			  p=InStr(p+3,Command,"-e")
			  hattach=cast(HANDLE,valint(mid(command,P+3)))
			  ThreadCreate(@dbg_attach)
			  exit sub
			endif    
      EndIf 
   EndIf 
Else 
   ffinal=f 
End If    
 
ffinal=Trim(ffinal)
#Ifdef fulldbg_prt
	dbg_prt (ffinal)
#endif
if ffinal="" Or dir(ffinal)="" Then 
    fb_message("File error","No file or "+ffinal+" doesn't exist")
    exit Sub 
ElseIf right(ffinal,4)<>".exe" Then
	ffinal=prep_debug(ffinal)'exe name
	if ffinal="" then exit Sub 'unsuccesfull compile
	If fb_message("Ready to debug","Launch file --> "+ffinal,MB_YESNO OR MB_ICONQUESTION)<>IDYES Then
		Exit sub
	EndIf
end if
    exename=ffinal
    exe_sav(exename,cmdline)
    If ThreadCreate(@start_pgm)=0 Then
    	fb_message("ERROR unable to start the thread managing the debuggee","Debuggee not running",MB_SYSTEMMODAL Or MB_ICONSTOP )
    EndIf
End Sub
Sub exe_sav(exename as string,cmdline as string)
	 Dim as Integer c
	 Dim As Double tempdate=FileDateTime(exename)
	 
	If flagwtch=0 orelse exedate<>tempdate Then
		watch_del()
	EndIf
    exedate=tempdate
    For i As Integer =0 To 8
    	If savexe(0)<>exename Then
    		swap savexe(0),savexe(c)
    		swap cmdexe(0),cmdexe(c)
    		
    		For j As Integer=0 To WTCHMAX
				Swap wtchexe(0,j),wtchexe(c,j)
    		Next
    		
    		For j As Integer=0 To BRKMAX '27/02/2013
				Swap brkexe(0,j),brkexe(c,j)
    		Next
    		
    		c+=1
    	Else
    		Exit for
    	End if
    Next
    savexe(0)=exename
    If cmdline<>"" Then cmdexe(0)=cmdline
    fb_UpdateTooltip(fb_hToolTip,butrrune,"Restart "+exename,"",0)
    setwindowtext(windmain,"Debugging "+exename) 
End sub   
'==============
sub ide_launch()
    Dim pclass As integer,st as integer
    dim  as string workdir,cmdl
    Dim sinfo As STARTUPINFO
if ideexe="" then
    fb_message("Launch Ide error","[IDE]=<path><name ide.exe> not defined")        
    exit sub
end if
if dbgsrc="" or dir(dbgsrc)="" then 
    fb_message("Launch Ide error","No source")        
    exit sub
end If
    fb_message("Ready to edit","file : "+dbgsrc)
    st=0
    while instr(st+1,ideexe,"\")
       st=instr(st+1,ideexe,"\")
    wend
    workdir=Left(ideexe,st)
    cmdl=""""+ideexe
    For i as Byte =0 To sourcenb
    	cmdl+=""" """+source(i)
    Next
    cmdl+=""""
    sinfo.cb = Len(sinfo)
'Set the flags
    sinfo.dwFlags = STARTF_USESHOWWINDOW
'Set the window's startup position
    sinfo.wShowWindow = SW_SHOWDEFAULT
'Set the priority class
    pclass = NORMAL_PRIORITY_CLASS or CREATE_NEW_CONSOLE
'Start the program
    CreateProcess(ideexe,strptr(cmdl),byval null,byval null, False, pclass, _
    null, WorkDir, @sinfo, @pinfo)
end sub
'===============================================
sub crc_init() 'initialisation for checksum
DIM i as Integer,j as Integer,value as Integer
  For i=0 To 255
    value=i
    For j=0 To 7
      If (value And 1) Then 
        value=(value Shr 1) Xor &hEDB88320
      Else
        value=(value Shr 1)
      EndIf
    Next
    crc_table(i)=value
  Next
End sub
'--------------------------
Function crc_string(txt as string) As integer
dim vbyte as byte,crc as Integer,i as Integer,size as Integer
  crc=&hFFFFFFFF
  size=Len(txt)
  For i=1 To size
    vbyte=Asc(Mid(txt,i,1))
    crc=(crc Shr 8) Xor crc_table(vbyte Xor (crc And &hFF))
  Next
  Return crc
End Function
'---------------------------
Function crc_bank(bank  As Integer,size As Integer) as Integer
dim vbyte as byte,crc as Integer,i as Integer
  crc=&hFFFFFFFF
  For i=0 To size-1
    vbyte=Peek (BYTE,bank+i)
    crc=(crc Shr 8) Xor crc_table(vbyte Xor (crc And &hFF))
  Next
  Return crc
End Function
'---------------------------------
Function crc_file(fname as string) as string
dim vbyte as byte ,crc as integer,filein as Integer
  crc=&hFFFFFFFF
  filein=freefile
  if dir(fname)="" then print "No file ";fname:exit function
  open fname for binary access read as filein
  do While Not Eof(filein)
    get #filein,,vbyte
    crc=(crc Shr 8) Xor crc_table(vbyte Xor (crc And &hFF))
  loop
  close filein
  return right("00000000"+hex(crc),8)
End Function
'==============================
sub winmsg()' winmessage
Dim Buffer As String*210
inputval=""
inputtyp=5
fb_mdialog(@input_box,"Window message number",windmain,283,25,90,30)
if inputval<>"" then
    'Format the message string
    FormatMessage FORMAT_MESSAGE_FROM_SYSTEM, ByVal 0,valint(inputval) , LANG_NEUTRAL, Buffer, 200, ByVal 0
    fb_message("Window message","Code : "+inputval+chr(10)+"Message : "+buffer) 
end if
end Sub
'===============================
sub dechexbin() 'dec/hex/bin
inputval=""
inputtyp=99
fb_mdialog(@input_box,"Input value HEX(&h) or DEC",windmain,283,25,90,30)
if inputval<>"" then
    fb_message("Value in dec, hex and bin","Dec= "+Str(Val(inputval))+chr(10)+"Hex="+hex(Val(inputval))+chr(10)+"Bin="+bin(Val(inputval)))
end if
end Sub
Sub compinfo_sh
	Dim cdata(3) As String
	Dim As uInteger p,q

If compinfo="" Then                                                           
	fb_message("No information about compilation or no progam loaded","Just add this line anywhere"+Chr(13)+"const FDBG_COMPIL_INFO As String=""$$__COMPILINFO__$$""+__FB_VERSION__+""/""+__FB_BUILD_DATE__+""/""+__FB_BACKEND__+""/""+__DATE__+"" ""+__TIME__)")
	Exit sub
EndIf

p=InStr(compinfo,"/")
cdata(0)="version number of the compiler : "+mid(compinfo,19,p-19)
q=InStr(p+1,compinfo,"/")
cdata(1)="build date : "+Mid(compinfo,p+1,q-p-1)
p=q
q=InStr(p+1,compinfo,"/")
cdata(2)="backend : "+Mid(compinfo,p+1,q-p-1)
cdata(3)="debuggee compile date : "+Mid(compinfo,q+1,19)

fb_message("Compile Informations",cdata(0)+Chr(13)+cdata(1)+Chr(13)+cdata(2)+Chr(13)+cdata(3))

End Sub
sub line_goto() 'Goto line
	Dim Linenb As Integer
	inputval=""
	inputtyp=99
	linenb=SendMessage(dbgrichedit,EM_EXLINEFROMCHAR,0,-1)+1 'get line zero based
	fb_mdialog(@input_box,"Current line "+Str(linenb)+", Goto line ?",windmain,283,25,90,30)
	Linenb=valint(inputval)-1
	if linenb>=0 then
	   sel_line(linenb)
	end if
end Sub
Sub line_adr() 'address of cursor on line in memory
dim l As Integer,i As Integer,range as charrange,b As Integer,ln As integer
range.cpmin=-1 :range.cpmax=0

sendmessage(dbgrichedit,EM_exsetsel,0,Cast(LPARAM,@range)) 'deselect
l=sendmessage(dbgrichedit,EM_EXLINEFROMCHAR,0,-1) 'get line

for i=1 to linenb
	if rline(i).nu=l+1 and proc(rline(i).pr).sr=shwtab Then Exit For 'check nline 
Next
if i>linenb then fb_message("Line memory address","Not executable so no address") :exit Sub
For j As Integer =1 To procnb
	If rline(i).ad=proc(j).db Then fb_message("Line memory address","Not executable so no address") :exit Sub
Next
sel_line(l)'07/03/2013
fb_message("Line memory address","Adr = "+Str(rline(i).ad)+" / &h "+Hex(rline(i).ad))
End Sub
Sub line_info '13/03/2013
	
	'calculate the maximum number of lines displayed in the window
Dim As HDC hdc
Dim As RECT wndRect
Dim As Integer rectheight,fl,nbl
Dim As TEXTMETRIC tm
'get height of window
SendMessage( dbgrichedit, EM_GETRECT, 0 , cast(LPARAM,@wndrect))
rectheight = wndrect.bottom - wndrect.top
'get height of font being used
hdc = GetDC( dbgrichedit )
If hdc=0 Then dspsize=10:Exit sub 'not very good
selectobject(hdc,fonthdl)
GetTextMetrics( hdc, @tm )

'use height of font and height of rich edit control
dspsize=rectheight\tm.tmHeight
dspwidth=(wndrect.right - wndrect.left)\tm.tmAveCharWidth-4
	
	fl=SendMessage (dbgrichedit,EM_GETFIRSTVISIBLELINE,0,0)+1
	'dspsize
fl=9997
	'getclientrect(dbgrichedit,@rect)
'linecount=sendmessage(dbgrichedit,EM_GETLINECOUNT,0,0)-1
	'FillRect(hdc, @rect, cast(HBRUSH,COLOR_WINDOW+1))
	'dbg_prt2("dsp size "+str(dspsize)+" "+Str(rectheight))
	'nbl=Int((rectheight\tm.tmHeight
	For i As Integer =0 To dspsize
		Dim As string temp
'If i>linecount Then Exit For 'in not all the window is filled
      temp = "H12345678"+" "+Space(5-Len(Str(fl)))+Str(fl)
      wndRect.left = 2   :  wndRect.top = i*tm.tmHeight+1
      wndRect.right = 100:  wndRect.bottom =i*tm.tmHeight+tm.tmHeight+1
      DrawText hDC, StrPTR(temp), Len(temp), @wndRect, DT_right
      fl+=1
	Next
	
	ReleaseDC( dbgrichedit, hdc )
	sendmessage(dbgrichedit,WM_NCPAINT,0,0) 'redraw ascensors
End Sub
sub compinfo_load(basedata As UInteger,sizedata As UInteger)
redim as byte buffer(sizedata)
dim  as uinteger idx=0,find
Dim As String strg="$$__COMPILINFO__$$"
Dim as zstring Ptr pzstrg

ReadProcessMemory(dbghand,Cast(LPCVOID,basedata),@buffer(0),sizedata,0)

while idx<sizedata-17
	find=TRUE
	For i As Integer =0 To Len(strg)-1
		if buffer(idx+i)<>strg[i] Then find=FALSE:Exit For
	Next
   If find Then
   	pzstrg=@buffer(idx)
   	compinfo=*pzstrg
   	Exit While
   End If  
   idx+=1
wend
ReDim as byte recup(0)'reduce size of buffer
end Sub
Sub stab_extract(exebase As UInteger,flagdll As byte)
dim recup as zstring *10000
dim recupstab as udtstab,secnb As UShort,secnm As String *8,lastline As UShort=0
dim as UInteger basestab=0,basestabs=0,pe,baseimg,sizemax,sizestabs,proc1,proc2
Dim sourceix as Integer,sourceixs as Integer
Dim As Byte procfg,flag=0,procnodll=TRUE,flagstabd=TRUE 'flags  (flagstabd to skip stabd 68,0,1)
Dim As Integer n=sourcenb+1,temp
Dim procnmt As String
SendMessage(dbgstatus,SB_SETTEXT,0,Cast(LPARAM,@"Loading debug data"))
ReadProcessMemory(dbghand,Cast(LPCVOID,exebase+&h3C),@pe,4,0)
pe+=exebase+6 'adr nb section
ReadProcessMemory(dbghand,Cast(LPCVOID,pe),@secnb,2,0)
pe+=46 'adr compiled baseimage
ReadProcessMemory(dbghand,Cast(LPCVOID,pe),@baseimg,4,0)
pe+=&hC4 'adr sections 
For i As ushort =1 To secnb
	Dim As UInteger basedata,sizedata
	secnm=String(8,0) 'Init var
	ReadProcessMemory(dbghand,Cast(LPCVOID,pe),@secnm,8,0) 'read 8 bytes max name size
	If secnm=".stab" Then
		ReadProcessMemory(dbghand,Cast(LPCVOID,pe+12),@basestab,4,0)
	ElseIf secnm=".stabstr" Then
		ReadProcessMemory(dbghand,Cast(LPCVOID,pe+12),@basestabs,4,0)
		ReadProcessMemory(dbghand,Cast(LPCVOID,pe+8),@sizestabs,4,0)
	ElseIf secnm=".data" andalso flagdll=NODLL then 'compinfo
		ReadProcessMemory(dbghand,Cast(LPCVOID,pe+12),@basedata,4,0)
		ReadProcessMemory(dbghand,Cast(LPCVOID,pe+8),@sizedata,4,0)
		compinfo_load(basedata+exebase,sizedata+exebase)
	EndIf
	pe+=40
Next
vrbgblprev=vrbgbl '27/01/2013
linenbprev=linenb '01/02/2013
If basestab=0 And basestabs=0 Then
	If flagdll=NODLL Then
		fb_message("NO information for Debugging","Compile again with option -g"+Chr(10)+"Or in case of GCC 4 add also -Wc -gstabs+",MB_TOPMOST)
	EndIf
	Exit Sub
End If
basestab+=exebase+12:basestabs+=exebase

while 1
   if ReadProcessMemory(dbghand,Cast(LPCVOID,basestab),@recupstab,12,0)=0 Then
		#Ifdef fulldbg_prt
   		dbg_prt ("error reading memory "+Str(GetLastError))
   	#EndIf
   	fb_message("ERROR","When reading memory"):Exit sub
   end If
   
	#Ifdef fulldbg_prt
   	dbg_prt (Str(recupstab.stabs)+" "+Str(recupstab.code)+" "+Str(recupstab.nline)+" "+Str(recupstab.ad))
	#EndIf
	'dbg_prt (Str(recupstab.stabs)+" "+Str(recupstab.code)+" "+Str(recupstab.nline)+" "+Str(recupstab.ad))
    if recupstab.code=0 then exit While
    if recupstab.stabs Then
    	sizemax=IIf ((sizestabs-recupstab.stabs)>9999,9999,(sizestabs-recupstab.stabs))
    	if ReadProcessMemory(dbghand,Cast(LPCVOID,recupstab.stabs+basestabs),@recup,sizemax,0)=0 Then
   		fb_message("ERROR When reading memory : "+Str(GetLastError),"Exit loading"):Exit Sub
    	End If
    	
    	#Ifdef fulldbg_prt
    	  dbg_prt (recup)
    	#EndIf
    	
        select case recupstab.code
        	case 36 'proc
        			 procnodll=FALSE
        			 procnmt=cutup_proc(left(recup,instr(recup,":")-1))
        			 If procnmt="main" Then flagstabd=TRUE '30/08/2012 + A FAIRE supp l'équivalent cidessous 
        			 If procnmt<>"" and procnmt<>"{MODLEVEL}" and(flagmain=TRUE Or procnmt<>"main") Then
        			 	'If InStr(procnmt,"structor : IRHLCCTX")=0 And InStr(procnmt,".LT")=0 Then
        			 	If InStr(procnmt,".LT")=0 Then
        			 	#Ifdef fulldbg_prt
        			 		dbg_prt ("Proc : "+procnmt)
        			 	#EndIf
	        			 	If flagmain=TRUE And procnmt="main" Then
	        			 		flagmain=FALSE:flagstabd=TRUE'first main ok but not the others
		        			 	#Ifdef fulldbg_prt
		        			 		dbg_prt("MAIN main "+source(sourceix))
		        			 	#EndIf
	        			 	EndIf
        			 	procnodll=TRUE:proc2=recupstab.ad+exebase-baseimg 'only when <> exebase and baseimg (DLL)
                	procfg=1:procnb+=1:proc(procnb).sr=sourceix
                	proc(procnb).nm=procnmt 'proc(procnb).ad=proc2 keep it if needed
                	' :F --> public / :f --> private then return value 
                	Dim As String recupbis
                	If gengcc Then recupbis=recup:translate_gcc(recupbis):recup=recupbis
                  cutup_retval(procnb,Mid(recup,instr(recup,":")+2,99))'return value .rv + pointer .pt 
                  proc(procnb).st=1 'state no checked
                  proc(procnb).nu=recupstab.nline:lastline=0
                  proc(procnb+1).vr=proc(procnb).vr 'case no param / no local
        			 	EndIf
        			 End if
        	case 38,40,128,160 'init var / uninit var / local / parameter
                'if procnodll Then cutup_1(recup,recupstab.ad)' ???? dont remember why
               If flagdll=DLL Andalso exebase<>baseimg Then 'dll with relocation 07/02/2013
               	cutup_1(recup,recupstab.ad,exebase-baseimg)
               Else
               	cutup_1(recup,recupstab.ad)
               EndIf 
            'GCC
        	Case 60 
                if recup="gcc2_compiled." Then
                	fb_message("Compiled with option -gen gcc","Expect few strange behaviours")
                	gengcc=1'not sure so comment :sourcenb-=1
                EndIf
            'END GCC
        	Case 46,78 'beginning/end of a relocatable function block, not used
        	case 100
        			If flag=0 Then
        				If InStr(recup,":")=0  Then Exit Select ' case just name in excess then new path '12/05/2013
        				flag=1
        				If InStr(recup,".") Then 'full name so can check '24/01/2013
        					temp=check_source(recup)
        				Else
        					temp=-1
        				EndIf
        				If temp=-1 Then
                     sourcenb+=1:source(sourcenb)=recup:sourceix=sourcenb:sourceixs=sourceix
        				Else
                 	   sourceix=temp:sourceixs=sourceix
        				End If
        				dbgmaster=sourcenb 'master bas not the include files
        				'reinit when new module (main, lib or dll)
        				gengcc=0:defaulttype=1:procnodll=TRUE
        			Else
        				flag=0 'case path then full name or path then name 
        				'GCC
        				If Right(recup,2)=".c" Then
        					recup=Left(recup,Len(recup)-2)+".bas"
        					dbgmain=sourcenb 'considering that entry point is inside this source
        				EndIf
        				'END GCC
                	If instr(recup,":")=0 Then recup=source(sourcenb)+recup 'path + name '24/01/2013
                	temp=check_source(recup)
        				If temp<>-1 Then
                 	   sourceix=temp:sourceixs=sourceix:sourcenb-=1
        				Else
        					source(sourcenb)=recup
        				End If
        			End if
        	Case 130 'include RAS
        		case 132 'include
	        		#Ifdef fulldbg_prt
                	dbg_prt ("Include : "+recup)
               #EndIf
               'GCC
              ' ==
               If InStr(recup,":") Then 'new include file path name with file name
                 temp=check_source(recup)
                 If temp=-1 Then
                     sourcenb+=1:source(sourcenb)=recup:sourceix=sourcenb ' ????? Utilité :sourcead(sourcenb)=recupstab.ad
                 Else
                 	   sourceix=temp
                 End If
               Else
               	sourceix=0
               EndIf
              ' ==
               'If InStr(recup,":") Then 'new include file path name with file name
              	'	sourcenb+=1:source(sourcenb)=recup:sourceix=sourcenb' ????? Utilité :sourcead(sourcenb)=recupstab.ad
               'Else 'return in main source because no path name
               '	sourceix=0
               'EndIf
                'just usefull if GCC because the information for include is arriving after the proc !!!
                if gengcc then proc(procnb).sr=sourceix':dbg_prt("include ahah "+source(sourceix)+" "+proc(procnb).nm)
                'END GCC
        	Case 42 'main proc  = entry point
        			flagstabd=false ' order : code 42 / stabd / code 36 main
        			dbgmain=dbgmaster
        		case Else
        			#Ifdef fulldbg_prt
                	dbg_prt ("UNKNOWN stabs "+Str(recupstab.code)+" "+Str(recupstab.stabs)+" "+Str(recupstab.nline)+" "+Str(recupstab.ad)+" "+recup)
               #EndIf
        end select
    Else
        select case recupstab.code
        	case 68
        		'dbg_prt2("code 68 "+Str(procnodll)+" "+Str(flagstabd)+" "+Str(recupstab.nline)+" "+Str(lastline))
        		'And recupstab.nline>lastline    : To avoid very last line see next comment about lastline
        		'recupstab.nline<>65535 And 
            if procnodll And flagstabd Then 'And recupstab.nline>lastline Then
            	If gengcc Or (gengcc=0 and recupstab.nline>lastline) Then
            	'asm with just comment 25/06/2012
               If recupstab.ad+proc2<>rline(linenb).ad Then 
               	linenb+=1
               Else 
               	WriteProcessMemory(dbghand,Cast(LPVOID,rline(linenb).ad),@rLine(linenb).sv,1,0)
               EndIf
               ' 25/06/2012
               rline(linenb).ad=recupstab.ad+proc2:rLine(linenb).nu=recupstab.nline:rLine(linenb).pr=procnb
               ReadProcessMemory(dbghand,Cast(LPCVOID,rline(linenb).ad),@rLine(linenb).sv,1,0) 'sav 1 byte before writing &CC
               WriteProcessMemory(dbghand,Cast(LPVOID,rline(linenb).ad),@breakcpu,1,0)
               #Ifdef fulldbg_prt
                	dbg_prt("Line / adr : "+Str(recupstab.nline)+" "+Str(rline(linenb).ad))
               #EndIf
               If recupstab.ad<>0 Then lastline=recupstab.nline 'first proc line always coded 1 but ad=0
            	end If
            End If
        	case 192
                if procfg And procnodll then
                    ''Begin.block proc, real first program ligne for every proc not use now
                    ''procfg=0:proc(procnb).db=recupstab.ad+proc2 
                else
                    ''Begin. of block                   
                end if
        	case 224
                ''End of block
                if procnodll Then proc1=recupstab.ad+proc2
        	Case 36
                    ''End of proc
                if procnodll Then
                	proc(procnb).fn=proc1:proc(procnb).db=proc2
                	If proc1>procfn Then procfn=proc1+1 '24/01/2013 just to be sure to be above see gest_brk
                EndIf
        	Case 162
                ''End include
                sourceix=sourceixs
        	case 100
        		flag=0
        		'as the definitions for integer, ushort etc are repeated keep only the 15 first ones
            udtcpt=udtcptmax-15
        	case Else
        		#Ifdef fulldbg_prt
        		 	dbg_prt ("UNKNOWN "+Str(recupstab.code)+" "+Str(recupstab.stabs)+" "+Str(recupstab.nline)+" "+Str(recupstab.ad))
        		#EndIf    
        end select
    end if
    basestab+=12
Wend
globals_load() '27/01/2013
SendMessage(dbgstatus,SB_SETTEXT,0,Cast(LPARAM,@"Loading sources"))
load_sources(n)
'activate buttons/menu after real start
but_enable()
menu_enable()
brk_apply 'apply previous breakpoints
End sub
'GCC
'udt(0).nm="Unknown"
'udt(1).nm="Integer":udt(1).lg=Len(Integer)       integer:t(0,1) / int:t(0,1)=r(0,1);-2147483648;2147483647;
'udt(2).nm="Byte":udt(2).lg=Len(Byte)             byte:t(0,2) / char:t(0,2)=r(0,2);0;127;
'                            plutôt signed char ?? signed char:t(0,10)=@s8;r(0,10);-128;127;
'udt(3).nm="Ubyte":udt(3).lg=Len(UByte)           ubyte:t(0,11) / unsigned char:t(0,11)=@s8;r(0,11);0;255;
'udt(4).nm="Zstring":udt(4).lg=4                  byte
'udt(5).nm="Short":udt(5).lg=Len(Short)           short int:t(0,8)=@s16;r(0,8);-32768;32767;
'udt(6).nm="Ushort":udt(6).lg=Len(UShort)          ushort:t(0,9) / short unsigned int:t(0,9)=@s16;r(0,9);0;65535; 
'udt(7).nm="Void":udt(7).lg=4                     void:t(0,19)=(0,19)
'udt(8).nm="Uinteger":udt(8).lg=Len(UInteger)     uinteger:t(0,4) unsigned int:t(0,4)=r(0,4);0000000000000;0037777777777; 
'udt(9).nm="Longint":udt(9).lg=Len(LongInt)       longint:t(0,6) long long int:t(0,6)=@s64;r(0,6);01000000000000000000000;0777777777777777777777; 
'udt(10).nm="Ulongint":udt(10).lg=Len(ULongInt)   ulongint:t(0,7) long long unsigned int:t(0,7)=@s64;r(0,7);0000000000000;01777777777777777777777; 
'udt(11).nm="Single":udt(11).lg=Len(Single)       single:t(0,12) / float:t(0,12)=r(0,1);4;0;
'udt(12).nm="Double":udt(12).lg=Len(Double)       double:t(0,13)=r(0,1);8;0;
'udt(13).nm="String":udt(13).lg=Len(String)       _string:T(0,22)=s12data:(0,23)=*(0,2),0,32;len:(0,1),32,32;size:(0,1),64,32;;
'udt(14).nm="Fstring":udt(14).lg=4                fixstr:t(0,2)
'udt(15).nm="Pchar":udt(15).lg=4
'
'5      LSYM   0      0      00000000 165    long int:t(0,3)=r(0,3);-2147483648;2147483647;
'7      LSYM   0      0      00000000 268    long unsigned int:t(0,5)=r(0,5);0000000000000;0037777777777;
'16     LSYM   0      0      00000000 717    long double:t(0,14)=r(0,1);12;0;
'17     LSYM   0      0      00000000 750    complex int:t(0,15)=s8real:(0,1),0,32;imag:(0,1),32,32;;
'18     LSYM   0      0      00000000 807    complex float:t(0,16)=R3;8;0;
'19     LSYM   0      0      00000000 837    complex double:t(0,17)=R3;16;0;
'20     LSYM   0      0      00000000 869    complex long double:t(0,18)=R3;24;0;
'21     LSYM   0      0      00000000 906    
'22     LSYM   0      0      00000000 926    __builtin_va_list:t(0,20)=*(0,2)
'23     LSYM   0      0      00000000 959    _Bool:t(0,21)=@s8;-16;
'      
'29     LSYM   0      0      00000000 1053   ulong:t(0,5)
'  

'in string STRG all the occurences of SRCH are replaced by REPL
sub str_replace(strg as string,srch as string, repl as string)
    dim as integer p,lgr=len(repl),lgs=len(srch)
    p=instr(strg,srch)
    while p
        strg=left(strg,p-1)+repl+mid(strg,p+lgs)
        p=instr(p+lgr,strg,srch)
    wend
end Sub
Function translate_type(strg as string,p as integer) as integer
    dim As Integer index
    Static As Integer flagstring,flagvoid
    If flagstring=0 AndAlso Left(strg,9)="_string:T" Then
    	index=val(mid(strg,13,9))
    	Trans(index)="13" '_string:T(0,xx)
    	flagstring=1
    	Return index
    EndIf
    If flagvoid=0 AndAlso Left(strg,6)="void:t" Then 'void:t(0,xx)
    	index=Val(mid(strg,10,9))
    	Trans(index)="7" 
    	flagvoid=1
    	Return index
    EndIf
    index=val(mid(strg,instr(p,strg,",")+1,9))
    return index
end Function
sub translate_part(strg as string,masterindex as integer)
    Dim As String sav,modif
    dim as integer p,q,index,indexbis,limit
         sav=strg
			While InStr(sav,")=")
				q=1
				p=InStr(q,sav,"(")
				q=instr(p+1,sav,")")
				indexbis=Val(mid(sav,instr(p,sav,",")+1,9))
				modif=Mid(sav,q+2)
				sav=Mid(sav,InStr(q+2,sav,"("))
				p=InStr(modif,"(")
				While p
					q=InStr(p+1,modif,")")
					index=Val(mid(modif,instr(p,modif,",")+1,9))
					If Trans(index)<>"" Then
						str_replace(modif,Mid(modif,p,q-p+1),Trans(index))
					Else
						str_replace(modif,Mid(modif,p,q-p+1),Str(index))
					EndIf
					p=InStr(p+1,modif,"(")
				Wend
				Trans(indexbis)=Str(indexbis)+"="+modif
			Wend
			'strg=Str(masterindex)+"="+Trans(masterindex)
			strg=Trans(masterindex)
end Sub
sub translate_gcc(strg as string)
dim as integer p,q,index
dim as string part
static as integer flagarray,flagstring,flagvoid
if flagarray=0 then
    p=instr(strg,";003777")
    if p then 'found =r(0,xx);0000000000000;0037777777777;;
        q=instr(p-31,strg,"=ar(")
        stringarray=mid(strg,q,instr(q+4,strg,")")-q+1) 'ar(0,xx) equivalent ar1
        str_replace(strg,mid(strg,q,p+15-q),stringarray)
        flagarray=1
    endif
else
    str_replace(strg,stringarray,"=ar1")
EndIf
p=InStr(strg,"(")
q=instr(p+1,strg,")")
'index=val(mid(strg,instr(p,strg,",")+1,9))
index=Val(mid(strg,instr(p,strg,",")+1,9))

If flagvoid=0 AndAlso Left(strg,6)="void:t" Then
	Trans(index)="7" 'void:t(0,xx)
	str_replace(strg,Mid(strg,p,q-p+1),str(index))
	flagvoid=1
	Return
EndIf
'"_TMP$3:T(0,25)=s44DATA:(0,26)=*(0,27)=*(0,1),0,32;PTR:(0,26),32,32;SIZE:(0,1),64,
'_TUDT:T(0,38)=s8VINT:(0,1),0,32;VBYTE:(0,2),32,8;;
If Strg[p-2]=Asc("T") Then	'Trans(masterindex)=""
	str_replace(strg,Mid(strg,p,q-p+1),Str(index)) 'replace master index
	p=InStr(strg,"(")'find begin and end of type (with array if needed) of component
	
	While p
		q=instr(p+1,strg,"),")
		part=Mid(strg,p,q-p+1)
	   translate_part(part,Val(mid(strg,InStr(p,strg,",")+1,9)))
	   str_replace(strg,Mid(strg,p,q-p+1),part)
	   p=InStr(p,strg,"(")
	Wend
	If flagstring=0 AndAlso Left(strg,9)="_string:T" Then '_string:T(0,xx)
		Trans(index)="13" 
		flagstring=1
	Else
		Trans(index)=Str(index)
	EndIf

Else
    If Trans(index)<>"" Then
       str_replace(strg,Mid(strg,p,q-p+1),Trans(index)) 'replace by the corresponding string
    else
        'str_replace(strg,Mid(strg,p,q-p+1),Str(index)) 'replace master index
        part=Mid(strg,p)
        translate_part(part,index)
        str_replace(strg,Mid(strg,p),part)
    End If
end If
End Sub
Function cutup_names(strg As string) As String
	 '"__ZN9TESTNAMES2XXE:S1
	Dim As Integer p,d
	Dim As String nm,strg2,nm2
	strg2=Mid(strg,5,999)
	p=Val(strg2)
	If p>9 Then d=3 Else d=2
	nm=Mid(strg2,d,p)
	strg2=Mid(strg2,d+p)
	p=Val(strg2)
	If p>9 Then d=3 Else d=2
	nm2=Mid(strg2,d,p)
	Return "NS : "+nm+"."+nm2
End function
function cutup_proc(strg As String) As String
        Dim As Integer p,d
        Dim As String nm,strg2,nm2
        If Left(strg,3)<>"__Z" Then Return strg
        If strg[3]=Asc("N") Then
                strg2=Mid(strg,5)
                p=Val(strg2)
                If p>9 Then d=3 Else d=2
                nm=Mid(strg2,d,p)
                strg2=Mid(strg2,d+p)
                p=Val(strg2)
                If p Then
                        If p>9 Then d=3 Else d=2
                        nm2=Mid(strg2,d,p)
                        p=InStr(nm2,"__get__")
                        If p Then
                                Return "Get property : "+nm+"."+Left(nm2,p-1)
                        Else
                                p=InStr(nm2,"__set__")
                                If p Then
                                        Return "Set property : "+nm+"."+Left(nm2,p-1)
                                Else
                                        Return "Func/sub : "+nm+"."+nm2
                                EndIf
                        EndIf
                Else
                        Select Case Left(strg2,2)
                                Case "C1"
                                        Return "Constructor : "+nm
                                Case "D1"
                                        Return "Destructor : "+nm
                                Case Else
                                        Return "Operator : "+nm+" "+cutup_op(Left(strg2,2))'"Unknown"+strg2
                        End Select
                EndIf
        Else 'operator
        strg2=Mid(strg,7)
                p=Val(strg2)
                If p>9 Then d=3 Else d=2
                nm=Mid(strg2,d,p)
                Return "Operator : "+nm+" "+cutup_op(mid(strg,4,2))
        EndIf
        
End Function

function cutup_op (op as string) as string        
select case  op
case "aS"
    function = "Let "                
case "pl"                
    function = "+"                
case "pL"                
    function = "+="                
case "mi"        
    function = "-"                
case "mI"                
    function = "-="                
case "ml"                
    function = "*"                
case "mL"                
    function = "*="                
case "dv"
    function = "/"                
case "dV"
    function = "/="                
case "Dv"        
    function = "\"                
case "DV"        
    function = "\="                
case "rm"                
    function = "mod"                
case "rM"        
    function = "mod="                
case "an"                
    function = "and"                
case "aN"                
    function = "and="                
case "or"                
    function = "or"                
case "oR"        
    function = "or="                
case "aa"                 
    function = "andalso"             
case "aA"        
    function = "andalso="                
case "oe"               
    function = "orelse"               
case "oE"       
    function = "orelse="              
case "eo"                
    function = "xor"                
case "eO"                 
    function = "xor="              
case "ev"                 
    function = "eqv"                
case "eV"                 
    function = "eqv="                
case "im"                 
    function = "imp"               
case "iM"               
    function = "imp="               
case "ls"                
    function = "shl"               
case "lS"                
    function = "shl="                
case "rs"                 
    function = "shr"               
	case "rS"                 
    function = "shr="             
case "po"                 
    function = "^"               
case "pO"        
    function = "^="                
case "ct"               
    function = "&"                
case "cT"         
    function = "&="                
	Case "eq" 
    function = "eq"                
case "gt"                
    function = "gt"                
case "lt"                
    function = "lt"                
case "ne"                
    function = "ne"                
case "ge"                
    function = "ge"                
case "le"                
    function = "le"                
case "nt"                
    function = "not"                
	case "ng"                
    function = "neg"                
	case"ps"                
    function = "ps"                
	case "ab"                
    function = "ab"                
	case "fx"                
    function = "fix"                
case "fc"                 
    function = "frac"                
case "sg"                
    function = "sgn"                
case "fl"                
    function = "floor"                
case "nw"
    function = "new"                
case "na"
    function = "new []?"                
case "dl"        
    function = "del"
case "da"
    function = "del[]?"                
case "de"                
    function = "."                
case "pt"                
    function = "->"                
case "ad"                
    function = "@"                
case "fR"                
    function = "for"                
case "sT"                
    function = "step"                
case "nX"                
    function = "next"                
case "cv"                        
    function = "Cast"        
case else                        
    function = "Unknow"                
end select   
End Function
Sub cutup_1(gv as String,ad As UInteger, dlldelta As Integer=0) '06/02/2013
	Dim p As Integer
	If defaulttype Then
		If gengcc Then
			If Left(gv,13)="long double:t" Then defaulttype=0
		Else
			If Left(gv,7)="pchar:t" Orelse Left(gv,7)="wchar:t" Then defaulttype=0 'last default type
		EndIf			
		Exit Sub	
	EndIf
	If gengcc Then translate_gcc(gv)
	'$$ for redim variable, tmp$.$ for dim
	If Left(gv,2)="$$" Or (instr(gv,"tmp$") And InStr(gv,"$:")) Then
		dbg_prt ("SPECIAL Taken "+gv)
		Exit Sub
	End If
   p=instr(gv,"$") 'Caution beginning by zero for [] see below

   if p<>0 then
         'temporary variables added by the compilator but keep tmp$..$, $$name and fb$result$
        'if gv[p]<>asc(":") andalso instr(gv,"fb$result$")=0 andalso (instr(gv,"tmp$")=0 And InStr(gv,"$:"=0) )Then dbg_prt ("Not taken "+gv):exit sub
    	If gv[p]<>asc(":") andalso instr(gv,"fb$result$")=0 andalso instr(gv,"$BASE")=0 _
        	andalso instr(gv,"$FB_PVT")=0 andalso instr(gv,"$FB_BASEVT")=0  AndAlso instr(gv,"$VPTR")=0 then
        	dbg_prt ("Not taken "+gv)
        	Exit Sub
    	EndIf
      gv=mid(gv,1,p-1)+mid(gv,p+1) 'eliminate $ at the end of name
   Else
        if instr(gv,":t") then dbg_prt ("Not taken "+gv):exit sub 'second part of udt but not usefull
   End If
    'END GCC
	if instr(gv,";;") Then 'defined type or redim var
		If instr(gv,":T") Then 'GCC change ":Tt" in just ":T"
					'UDT
			cutup_udt(gv)
		Else
      'REDIM
			If cutup_scp(gv[instr(gv,":")],ad,dlldelta)=0 Then Exit Sub 'Scope / increase number and put adr 06/02/2013
			'if common exists return 0 so exit sub 
			vrb(*vrbptr).nm=left(gv,InStr(gv,":")-1) 'var or parameter
			cutup_2(mid(gv,instr(gv,";;")+2),TYRDM) 'datatype
			vrb(*vrbptr).arr=Cast(tarr Ptr,-1) 'redim array
		EndIf
	ElseIf instr(gv,"=e") Then
		'ENUM
		cutup_enum(gv)
	Else
		'DIM
		If InStr(gv,"FDBG_COMPIL_INFO") Then Exit Sub '25/04/2013
		If gv[0]=Asc(":") Then Exit Sub 'no name, added by compiler don't take it
		p=cutup_scp(gv[instr(gv,":")],ad,dlldelta)'Scope / increase number and put adr 06/02/2013
		If p=0 Then Exit Sub 'see redim
		If Left(gv,4)="__ZN" And InStr(gv,":") Then
			vrb(*vrbptr).nm=cutup_names(gv) 'namespace
		else
			vrb(*vrbptr).nm=left(gv,instr(gv,":")-1) 'var or parameter
			If vrb(*vrbptr).nm=vrb(*vrbptr-1).nm Then 'to avoid two lines in proc/var tree, case dim shared array and use of erase or u/lbound
            *vrbptr-=1 'decrement pointed value, vrbgbl in this case 05/06/2013
            Exit Sub 
			EndIf
		End If
		cutup_2(mid(gv,instr(gv,":")+p),TYDIM)
	EndIf
end Sub
Function cutup_scp(gv As Byte, ad As UInteger,dlldelta As Integer=0) As Integer 
Select Case gv
	Case Asc("S"),asc("G")     'shared/common
		If gv=Asc("G") Then If Common_exist(ad) Then Return 0 'to indicate that no needed to continue
		If vrbgbl=VGBLMAX Then fb_message("Init Globals","Reached limit "+Str(VGBLMAX)):Exit function
		vrbgbl+=1
		vrb(vrbgbl).adr=ad
		vrbptr=@vrbgbl
		Select Case gv
			Case Asc("S")		'shared
				vrb(vrbgbl).mem=2
				vrb(vrbgbl).adr+=dlldelta 'in case of relocation dll, all shared addresses are relocated 06/02/2013
			Case Asc("G")     'common
				vrb(vrbgbl).mem=6
		End Select
		Return 2
	Case Else
		If vrbloc=VARMAX Then fb_message("Init locals","Reached limit "+Str(VARMAX-3000)):Exit function
		vrbloc+=1
		vrb(vrbloc).adr=ad
		vrbptr=@vrbloc
		proc(procnb+1).vr=vrbloc+1 'just to have the next beginning
		Select Case gv
			Case Asc("V")     'static
				vrb(vrbloc).mem=3
				Return 2
			Case Asc("v")     'byref parameter
				vrb(vrbloc).mem=4
				Return 2
			Case Asc("p")     'byval parameter
				vrb(vrbloc).mem=5
				Return 2
			Case Else         'local
				vrb(vrbloc).mem=1
				Return 1
		End Select
End Select	
End Function
sub cutup_2(gv as String,f As Byte)
Dim p As Integer=1,c As Integer,e As Integer,gv2 As String,pp As Integer

If InStr(gv,"=")=0 Then
	'GCC A SUPP
	c=Val(mid(gv,p,9))
	'c=type_trans( Mid(gv,p) )
	'END GCC
	If c>15 Then c+=udtcpt 'udt type so adding the decal
	pp=0
	If f=TYUDT Then 
		cudt(cudtnb).typ=c 
		cudt(cudtnb).pt=pp 
		cudt(cudtnb).arr=0 'by default not an array
	else 
		vrb(*vrbptr).typ=c 
		vrb(*vrbptr).pt=pp
		vrb(*vrbptr).arr=0 'by default not an array
	End If 
Else
	If InStr(gv,"=ar1") Then p=cutup_array(gv,InStr(gv,"=ar1")+1,f)
	gv2=Mid(gv,p)
	For p=0 To Len(gv2)-1
		If gv2[p]=Asc("*") Then c+=1
		If gv2[p]=Asc("=") Then e=p+1
	Next 
	If c Then 'pointer
		If InStr(gv2,"=f") Then 'proc
			If InStr(gv2,"=f7") Then
				pp=200+c 'sub
			Else
				pp=220+c 'function
			EndIf
		else
			pp=c
			e+=1
		End If
	else
		pp=0
	End If
	c=Val(Mid(gv2,e+1))
	If c>15 Then c+=udtcpt
	If f=TYUDT Then
		cudt(cudtnb).pt=pp
		cudt(cudtnb).typ=c
	else
		vrb(*vrbptr).pt=pp
		vrb(*vrbptr).typ=c
	End If
EndIf 
end Sub

Sub cutup_udt(readl As string)
Dim As Integer p,q,lgbits
Dim As string tnm 
p=instr(readl,":")
'GCC
if readl[0]=asc("_") then 
    tnm=mid(readl,2,p-2)
    p+=2 'skip :T
else
    tnm=left(readl,p-1)
    p+=3 'skip :Tt
endif
'END GCC

q=instr(readl,"=")
'GCC A SUPP
udtidx=val(mid(readl,p,q-p))
'udtidx=type_trans( mid(readl,p,q-p) )

'END GCC

udtidx+=udtcpt:If udtidx>udtcptmax Then udtcptmax=udtidx
If udtcptmax > TYPEMAX-1 Then fb_message("Storing UDT","Max limit reached "+Str(TYPEMAX)):Exit sub
udt(udtidx).nm=tnm
p=q+2
q=p-1
while readl[q]<64
	q+=1
Wend
q+=1
udt(udtidx).lg=val(mid(readl,p,q-p))
p=q
udt(udtidx).lb=cudtnb+1
while readl[p-1]<>Asc(";")
	'dbg_prt("STORING CUDT "+readl)
	If cudtnb = CTYPEMAX Then fb_message("Storing CUDT","Max limit reached "+Str(CTYPEMAX)):Exit Sub
	cudtnb+=1
	q=instr(p,readl,":")
	cudt(cudtnb).nm=Mid(readl,p,q-p) 'variable name
	p=q+1
	q=InStr(p,readl,",")
	cutup_2(Mid(readl,p,q-p),TYUDT) 'variable type
	p=q+1
	q=InStr(p,readl,",")
	cudt(cudtnb).ofs=Val(Mid(readl,p,q-p))  'bits offset / beginning
	p=q+1
	q=InStr(p,readl,";")
	lgbits=Val(Mid(readl,p,q-p))	'lenght in bits
	p=q+1
 	If cudt(cudtnb).typ<>4 and cudt(cudtnb).pt=0 And cudt(cudtnb).arr=0 Then 'not zstring, pointer,array !!!
		If lgbits<>udt(cudt(cudtnb).typ).lg*8 then 'bitfield 
		  cudt(cudtnb).typ=TYPEMAX 'special type for bitfield
		  cudt(cudtnb).ofb=cudt(cudtnb).ofs-(cudt(cudtnb).ofs\8) * 8 ' bits mod byte
		  cudt(cudtnb).lg=lgbits  'lenght in bits
		End If
 	End If
	cudt(cudtnb).ofs=cudt(cudtnb).ofs\8 'offset bytes
Wend
udt(udtidx).ub=cudtnb
End Sub
Sub cutup_enum(readl As string)
'.stabs "TENUM:T26=eESSAI:5,TEST08:8,TEST09:9,TEST10:10,FIN:99,;",128,0,0,0
Dim As Integer p,q
Dim As string tnm
p=instr(readl,":")
tnm=left(readl,p-1)
p+=2 'skip :T
q=instr(readl,"=")
udtidx=val(mid(readl,p,q-p))
udtidx+=udtcpt:If udtidx>udtcptmax Then udtcptmax=udtidx
If udtcptmax > TYPEMAX Then fb_message("Storing ENUM","Max limit reached "+Str(TYPEMAX)):Exit sub
udt(udtidx).nm=tnm 'enum name
udt(udtidx).en=udtidx 'flag enum, in case of already treated use same previous cudt
udt(udtidx).lg=Len(Integer) 'same size as integer
'each cudt contents the value (typ) and the associated text (nm)
udt(udtidx).lb=cudtnb+1
p=q+2
cudtnbsav=cudtnb 'save value for restoring see enum_check
while readl[p-1]<>asc(";")
q=instr(p,readl,":") 'text
cudtnb+=1
cudt(cudtnb).nm=mid(readl,p,q-p)

p=q+1
q=instr(p,readl,",") 'value
cudt(cudtnb).val=val(mid(readl,p,q-p))
p=q+1

Wend
udt(udtidx).ub=cudtnb
enum_check(udtidx) 'eliminate duplicates
End Sub
Function cutup_array(gv As string,d As Integer,f As Byte) as integer
	Dim As Integer p=d,q,c

If arrnb>ARRMAX Then fb_message("Max array reached","can't store"):Exit Function
arrnb+=1

'While gv[p-1]=Asc("a") 
While InStr(p,gv,"ar")
	'GCC
	'p+=4 
	
	If InStr(gv,"=r(")Then 	
		p=InStr(p,gv,";;")+2 'skip range =r(n,n);n;n;;
	Else
		p=InStr(p,gv,";")+1 'skip ar1;
	End If
	
	
	q=InStr(p,gv,";")
	'END GCC
	arr(arrnb).nlu(c).lb=Val(Mid(gv,p,q-p)) 'lbound

	p=q+1
	q=InStr(p,gv,";")
	arr(arrnb).nlu(c).ub=Val(Mid(gv,p,q-p))'ubound
	'''arr(arrnb).nlu(c).nb=arr(arrnb).nlu(c).ub-arr(arrnb).nlu(c).lb+1 'dim
	p=q+1
	c+=1
Wend
	arr(arrnb).dm=c 'nb dim
If f=TYDIM Then
	vrb(*vrbptr).arr=@arr(arrnb)
Else
	cudt(cudtnb).arr=@arr(arrnb)
End If
Return p
End Function
Sub cutup_retval(prcnb As Integer,gv2 As String)
	'example :f7 --> private sub /  :F18=*19=f7" --> public sub ptr / :f18=*19=*1 --> private integer ptr ptr
	Dim p As Integer,c As integer,e As Integer
	For p=0 To Len(gv2)-1
		If gv2[p]=Asc("*") Then c+=1
		If gv2[p]=Asc("=") Then e=p+1
	Next 
	If c Then 'pointer
		If InStr(gv2,"=f") Orelse InStr(gv2,"=F") Then
			If InStr(gv2,"=f7") Orelse InStr(gv2,"=F7") Then
				p=200+c 'sub
			Else
				p=220+c 'function
			EndIf
		else
			p=c
			e+=1
		End If
	else
		p=0
	End If
	c=Val(Mid(gv2,e+1))
	If c>15 Then c+=udtcpt
	proc(prcnb).pt=p
	proc(prcnb).rv=c
End Sub
Function Common_exist(ad As uinteger) As Integer
	For i As Integer = 1 To vrbgbl
		If vrb(i).adr=ad Then Return TRUE 'return true if a common still stored 
	Next
	Return FALSE
End Function

function CtrlHandler(fdwCtrlType As integer) As Integer  
    'Select casefdwCtrlType) { 
    '    /* Handle the CTRL+C signal. */ 
     '    case CTRL_C_EVENT: 
    '        Beep(1000, 1000); 
    '        return TRUE; 
    '    /* CTRL+CLOSE: confirm that the user wants to exit. */ 
    '    case CTRL_CLOSE_EVENT: 
    '        return TRUE; 
    '    /* Pass other signals to the next handler. */ 
     '    case CTRL_BREAK_EVENT: 
    '    case CTRL_LOGOFF_EVENT: 
    '    case CTRL_SHUTDOWN_EVENT: 
    '    default: 
    '        return FALSE; 
    '} 
    PostMessage(windmain,WM_CLOSE,0,0)
	Return true
End Function
'========================
'flaglog=0 --> no output / 1--> only screen / 2-->only file / 3 --> both
Sub dbg_prt(t As String)
	Static As HANDLE scrnnumber
	Static As Integer filenumber
	Dim cpt As Integer,libel As String
	dim As COORD maxcoord
	Dim As CONSOLE_SCREEN_BUFFER_INFO csbi 
	Dim As SMALL_RECT disparea=Type(0,0,0,0)
	
	If scrnnumber=0 And (flaglog And 1) Then
		libel=Chr(13)+Chr(10)+Date+" "+Time+Chr(13)+Chr(10)
		AllocConsole()
		scrnnumber=GetStdHandle(STD_OUTPUT_HANDLE)
		setconsoletitle(StrPtr("FBdebugger trace/log"))
		maxcoord=GetLargestConsoleWindowSize(scrnnumber)
		GetConsoleScreenBufferInfo(scrnnumber,@csbi)
		'change buffer to max sizes
		maxcoord.y=csbi.dwsize.y
		SetConsoleScreenBufferSize(scrnnumber,maxcoord)
		'change display
		disparea.right=(maxcoord.x-1)*.8
		disparea.bottom=(csbi.dwMaximumWindowSize.y-1)/2
		SetConsoleWindowInfo(scrnnumber,TRUE,@disparea)
		SetConsoleCtrlHandler(Cast(PHANDLER_ROUTINE,@CtrlHandler),TRUE)
		WriteConsole(scrnnumber, StrPtr(libel),len(libel),@cpt,0)
	EndIf
	If filenumber=0 And (flaglog And 2) Then
		filenumber=FreeFile:open ExePath+"\dbg_log_file.txt"  For Append As filenumber
		Print #filenumber,Date,Time
	EndIf
	If t<>" $$$$___CLOSE ALL___$$$$ " Then 
		If (flaglog And 1) Then libel=t+Chr(13)+Chr(10):WriteConsole(scrnnumber, StrPtr(libel),len(libel),@cpt,0)
		If (flaglog And 2) Then Print # filenumber,t   
	Else 'closing
		If scrnnumber<>0 And (flaglog And 1)=0 Then
			FreeConsole():scrnnumber=0
		EndIf
		If filenumber And (flaglog And 2)=0 Then Close filenumber:filenumber=0
	EndIf
End Sub

Sub thread_cleaning()'suppress all threads not debugged, keep but not used
	Dim As Integer k=1,cpt
	For i As Integer =1 to threadnb 'first thread ,main, =0 so never concerned
	   If thread(i).sv<>-1 Then 'debugged so not suppressed
	    	If i<>k Then thread(k)=thread(i)
	    	k+=1
	   Else
	   	cpt+=1
	   End If
	Next
	threadnb-=cpt
End Sub
Sub thread_del(thid As UInteger)'22/01/2013
Dim As Integer k=1,threadsup,threadold=threadcur
for i As Integer =1 to threadnb
   If thid<>thread(i).id Then
    	If i<>k Then thread(k)=thread(i):If i=threadcur Then threadcur=k 'optimization 29/11/2012
    	k+=1
   Else
   	threadsup=i '28/01/2013
   	If thread(i).sv<>-1 Then
   		'delete thread item and child
			sendmessage(tviewthd,TVM_DELETEITEM,0,Cast(LPARAM,thread(i).tv))
   		'proc delete
			for j As Integer = procrnb To 2 Step -1 'always keep procr(1)=main
				If procr(j).thid=thid Then
					proc_del(j)
				EndIf
			Next
   	EndIf
   End If 
Next
threadnb-=1
If threadsup<>threadold Then Exit Sub 'if deleted thread was the current, replace by first thread

If runtype=RTAUTO AndAlso threadaut>1 Then 'searching next thread
	threadaut-=1
	k=threadcur
	Do
		k+=1:If k>threadnb Then k=0
	Loop Until thread(k).exc
	thread_change(k)
	thread_rsm()
Else
	threadcur=0 'first thread
	threadprv=0 'no change 02/03/2013
	threadsel=0 '15/03/2013
	threadhs=thread(0).hd
	thread_text(0)
	runtype=RTSTEP
	dsp_change(thread(0).sv)
EndIf
End Sub
Function thread_select(id As Integer =0) As Integer 'find thread index based on cursor or threadid
	Dim tvi as TVITEM,text as zstring *100, pr as Integer, thid As Integer '13/12/2012
	Dim as Integer hitem,temp

	If id =0 Then  'take on cursor
	'get current hitem in tree
		temp=sendmessage(tviewthd,TVM_GETNEXTITEM,TVGN_CARET,null)

		Do 'search thread item
			hitem=temp
			temp=SendMessage(tviewcur,TVM_GETNEXTITEM,TVGN_PARENT,hitem)
		Loop While temp

		tvI.mask       = TVIF_TEXT or TVIF_STATE
		tvI.hitem      = Cast(HTREEITEM,hitem)
		tvI.pszText    = @(text)
		tvI.cchTextMax = 99
		sendmessage(tviewthd,TVM_GETITEM,0,Cast(LPARAM,@tvi))
		thid=ValInt(mid(text,10,6))
	Else
		thid=id
	End If
	For p As integer =0 To threadnb
		If thid=thread(p).id Then Return p 'find index number
	Next
End Function
Sub thread_execline(s As Integer) 'show the next executed line or threadcreate line
 Dim As Integer t,l
   t=thread_select()
   If s=1 Then
		l=thread(t).sv
   Else
   	If t=0 Then
   		fb_message("Threadcreate line","Main so no such line !!")
			Exit Sub
   	EndIf
   	If thread(t).st=0 Then 
   		fb_message("Threadcreate line","Impossible to locate in case of fast run !!")
			Exit Sub
   	EndIf
		l=thread(t).st
   End If
	exrichedit(proc(rline(l).pr).sr) 'display source
   sel_line(rline(l).nu-1)'Select Line
End sub
sub thread_kill()
 Dim t As Integer
   t=thread_select()
	If t=0 Then
		fb_message("Killing thread","This is the first thread --> process"+Chr(10)+"Use kill process button")
		Exit Sub
	EndIf
	If fb_message("Killing thread : "+Str(thread(t).id),"Are you sure ?"+Chr(10)+"It could cause Memory leak, etc.",MB_YESNO OR MB_ICONWARNING)=IDYES Then
		If terminatethread(thread(t).hd,999)=0 Then
			fb_message("Thread killing","Something goes wrong, error: "+str(GetLastError))
		EndIf
	EndIf
End Sub
Sub proc_del(j As Integer,t As Integer=1) '29/01/2013
Dim  As Integer tempo,th
Dim parent As HTREEITEM 
Dim As String text 
' delete procr in treeview
if SendMessage(tviewvar,TVM_DELETEITEM,0,Cast(LPARAM,procr(j).tv))=0 then
    fb_message("DELETE TREEVIEW ITEM","Not ok (not blocking) for proc "+proc(procr(j).idx).nm) '29/01/2013)
end If

'delete watch
for i As Integer =0 to WTCHMAX 
	'keep the watched var for reusing !!!
   If wtch(i).psk=procr(j).sk Then
    	wtch(i).psk=-3
   EndIf
next
'delete breakvar
if brkv.psk=procr(j).sk Then brkv_set(0)

' compress running variables
tempo=procr(j+1).vr-procr(j).vr
vrrnb-=tempo
For i As Integer = procr(j).vr To vrrnb
	vrr(i)=vrr(i+tempo)
Next

If t=1 Then 'not dll
	th=thread_select(procr(j).thid) 'find thread index
	parent=Cast(HTREEITEM,sendmessage(tviewthd,TVM_GETNEXTITEM,TVGN_PARENT,Cast(LPARAM,thread(th).ptv))) 'find parent of last proc item
	sendmessage(tviewthd,TVM_DELETEITEM,0,Cast(LPARAM,thread(th).ptv)) 'delete item
	thread(th).ptv=parent 'parent becomes the last
	thread_text(th) 'update thread text
EndIf

' compress procr and update vrr index
procrnb-=1
For i As Integer =j To procrnb
	procr(i)=procr(i+1)
	procr(i).vr-=tempo
Next

End Sub

Sub debugstring_read(debugev As debug_event)
	Dim As WString *400 wstrg
	Dim As ZString *400 sstrg 
	Dim leng As Integer
	If debugev.debugstring.nDebugStringLength<400 Then
		leng=debugev.debugstring.nDebugStringLength
	Else
		leng=400
	EndIf
If debugev.debugstring.fUnicode Then	
	ReadProcessMemory(dbghand,Cast(LPCVOID,debugev.debugstring.lpDebugStringData),_
	@wstrg,leng,0)
	messagebox(0,wstrg,WStr("debug wstring"),MB_OK)
Else
	ReadProcessMemory(dbghand,Cast(LPCVOID,debugev.debugstring.lpDebugStringData),_
	@sstrg,leng,0)
	messagebox(0,sstrg,@"debug string",MB_OK)
EndIf
End Sub

function wait_debug() As integer
Dim DebugEv as DEBUG_EVENT    ' debugging event information  
Dim dwContinueStatus as long =DBG_CONTINUE ' exception continuation
Dim recup as string *300,libel As string
Dim erreur as Long,cpt As integer
dim as integer firstchance,flagsecond 
Dim As UInteger adr
Dim As String Accviolstr(1)={"TRYING TO READ","TRYING TO WRITE"}
' Wait for a debugging event to occur. The second parameter indicates 
' that the function does not return until a debugging event occurs. 
if hattach then setevent(hattach):hattach=0
While 1
	if WaitForDebugEvent(@DebugEv, infinite)=0 then 'INFINITE ou null ou x
		erreur=GetLastError
		ContinueDebugEvent(DebugEv.dwProcessId,DebugEv.dwThreadId, dwContinueStatus)
		exit function  
	end if
' Process the debugging event code. 
'dbg_prt("exception code "+Str(DebugEv.dwDebugEventCode))
	Select case (DebugEv.dwDebugEventCode) 
		
		Case EXCEPTION_DEBUG_EVENT
		'dbg_prt("exception code "+Hex(DebugEv.Exception.ExceptionRecord.ExceptionCode))'+DebugEv.Exception.dwfirstchance+" adr : "+DebugEv.Exception.ExceptionRecord.ExceptionAddress)
		  	firstchance=DebugEv.Exception.dwfirstchance 
         adr=Cast(UInteger,DebugEv.Exception.ExceptionRecord.ExceptionAddress)
	      If firstchance=0 Then 'second try 
	         If flagsecond=0 then 
               flagsecond=1 
               firstchance=1               
               For i As Integer =0 to threadnb '22/01/2013
  					If DebugEv.dwThreadId=thread(i).id Then
  						threadcontext=thread(i).hd:threadhs=threadcontext
                  threadcur=i
  						Exit For
  					End If
               Next
               For i As Integer =1 To linenb 'debugbreak or access violation could be in the middle of line
						If rline(i).ad<=adr And rline(i+1).ad>adr Then
							thread(threadcur).od=thread(threadcur).sv:thread(threadcur).sv=i
							Exit For
						EndIf
               Next
	         EndIf
	      Else
	        	flagsecond=0'22/01/2013
	      End if 
		
			If firstchance Then 'if =0 second try so no compute code
				Select case (DebugEv.Exception.ExceptionRecord.ExceptionCode) 
					case EXCEPTION_BREAKPOINT: 
						for i As Integer =0 to threadnb 'if msg from thread then flag off
							If DebugEv.dwThreadId=thread(i).id Then
								threadcontext=thread(i).hd:threadhs=threadcontext
								suspendthread(threadcontext)
			               threadcur=i
								Exit For
							End if
						Next        
						gest_brk(adr)
			      	ContinueDebugEvent(DebugEv.dwProcessId,DebugEv.dwThreadId, dwContinueStatus)
			      	'gest_brk(adr) 01/02/2013
			      	
					Case EXCEPTION_ACCESS_VIOLATION: 
	               with DebugEv.Exception.ExceptionRecord
	                	For i As Integer =0 to threadnb 'if msg from thread then flag off
	        					If DebugEv.dwThreadId=thread(i).id Then
	        						threadcontext=thread(i).hd:threadhs=threadcontext
	                        threadcur=i
	        						Exit For
	        					End if
	                	Next               
	               	#Ifdef fulldbg_prt
        						dbg_prt ("Thread ID : "+Str(DebugEv.dwThreadId)+" ACCESS_VIOLATION adr : "+Str(adr))
        					#EndIf
							libel=Accviolstr(.ExceptionInformation(0))+" AT ADR : "+Str(.ExceptionInformation(1))
							#Ifdef fulldbg_prt
								dbg_prt (libel)
								showcontext
							#EndIf
							If flagverbose Then 
								libel+=Chr(13)+"Thread ID "+Str(DebugEv.dwThreadId)+" adr : "+Str(adr)+Chr(13)
							Else
								libel+=Chr(13)
							EndIf
							'If runtype<>RTFRUN And runtype<>RTFREE Then
							If runtype=RTFRUN Orelse runtype=RTFREE Then	
								runtype=RTFRUN								
								For i As Integer =1 To linenb
									'WriteProcessMemory(dbghand,Cast(LPVOID,rline(i).ad),@breakcpu,1,0)'restore CC
									If rline(i).ad<=adr AndAlso rline(i+1).ad>adr Then
										thread(threadcur).od=thread(threadcur).sv:thread(threadcur).sv=i
									EndIf
									Exit For
								Next
							Else
								runtype=RTSTEP
							End if	
							stopcode=CSACCVIOL  
    						gest_brk(rline(thread(threadcur).sv).ad) 
								
               		exrichedit(proc(rline(thread(threadcur).sv).pr).sr) 'display source
               		sel_line(rline(thread(threadcur).sv).nu-1,clrperbrk,2)'Select Line in red               
							SendMessage(dbgrichedit,EM_GETSELTEXT,0,Cast(LPARAM,@recup))
							SendMessage(dbgrichedit,EM_HIDESELECTION,1,0)'hide selection
							'case error inside proc initialisation (e.g. stack over flow)
							If adr>rline(thread(threadcur).sv).ad And _
								adr<rline(thread(threadcur).sv+1).ad And _
								rline(thread(threadcur).sv+1).nu=rline(thread(threadcur).sv).nu Then
								libel+="ERROR AT BEGINNING OF PROC NOT REALLY ON THIS LINE"+chr(13)+ _
								"CHECK DIM (e.g. width array to big), Preferably don't continue"+Chr(13)+Chr(13)
							Else
								libel+="Possible error on this line but not SURE"+Chr(13)+Chr(13)
							End If
							
							libel+="File  : "+source(proc(rline(thread(threadcur).sv).pr).sr)+Chr(13)+ _
	                  "Proc  : "+proc(rline(thread(threadcur).sv).pr).nm+Chr(13)+ _
	                  "Line  : "+Str(rline(thread(threadcur).sv).nu)+" (selected and put in red)"+Chr(13)+ _
							recup+Chr(13)+Chr(13)+"Try To continue ? (if yes change values and/or use [M]odify execution)"
							If fb_message("ACCESS_VIOLATION",libel,MB_SYSTEMMODAL Or MB_ICONSTOP Or MB_YESNO) = IDYES Then
								suspendthread(threadcontext)
	               		ContinueDebugEvent(DebugEv.dwProcessId,DebugEv.dwThreadId, dwContinueStatus)
							Else
		               	ContinueDebugEvent(DebugEv.dwProcessId,DebugEv.dwThreadId, DBG_EXCEPTION_NOT_HANDLED)
							End If
							SendMessage(dbgrichedit,EM_HIDESELECTION,0,0)'show selection
	               End With
					Case Else
	      			fb_message("EXCEPTION_DEBUG_EVENT ","Code :"+excep_lib(DebugEv.Exception.ExceptionRecord.ExceptionCode),MB_SYSTEMMODAL Or MB_ICONSTOP)
	      			#Ifdef fulldbg_prt
	      				dbg_prt("EXCEPTION_DEBUG_EVENT : "+excep_lib(DebugEv.Exception.ExceptionRecord.ExceptionCode))
	      			#EndIf
	               ContinueDebugEvent(DebugEv.dwProcessId,DebugEv.dwThreadId, DBG_EXCEPTION_NOT_HANDLED)
				End Select
			Else'second chance 
         	ContinueDebugEvent(DebugEv.dwProcessId,DebugEv.dwThreadId, DBG_EXCEPTION_NOT_HANDLED)
         	
			End If  
		Case CREATE_THREAD_DEBUG_EVENT:
         With DebugEv.Createthread
         	#Ifdef fulldbg_prt 
	         	dbg_prt(""):dbg_prt ("Create thread : DebugEv.dwProcessId "+Str(DebugEv.dwProcessid))
	         	dbg_prt ("DebugEv.dwThreadId "+Str(DebugEv.dwThreadId))
	         	dbg_prt ("hthread "+Str(.hthread)+" start address "+Str(.lpStartAddress)) 
         	#EndIf
				If threadnb<THREADMAX Then
			      threadnb+=1 :thread(threadnb).hd=.hthread:thread(threadnb).id=DebugEv.dwThreadId
			      threadcontext=.hthread
			      thread(threadnb).pe=FALSE
			      thread(threadnb).sv=-1 'used for thread not debugged '29/11/2012
			      thread(threadnb).plt=0 'used for first proc of thread then keep the last proc '09/12/2012
			      thread(threadnb).st=thread(threadcur).od 'used to keep line origin
			      thread(threadnb).tv=0
			      thread(threadnb).exc=0 'no exec auto
				Else 
			      fb_message("New thread","Number of threads ("+Str(THREADMAX+1)+") exceeded , change the THREADMAX value."+Chr(10)+Chr(10)+"CLOSING FBDEBUGGER, SORRY",MB_SYSTEMMODAL Or MB_ICONSTOP)
			      postmessage(windmain,WM_DESTROY,0,0)
				EndIf
         End With
         ContinueDebugEvent(DebugEv.dwProcessId,DebugEv.dwThreadId, dwContinueStatus)
         
		Case CREATE_PROCESS_DEBUG_EVENT: 
			With DebugEv.CreateProcessInfo
				dbghfile=.hfile' to close the handle and liberate the file .exe
				threadnb=0:thread(0).hd=.hthread:thread(0).id=DebugEv.dwThreadId
				threadcontext=.hthread
				thread(0).pe=FALSE
		      thread(0).sv=0  'used for thread not debugged '29/11/2012
		      thread(0).plt=0 'used for first proc of thread then keep the last proc '09/12/2012
		      thread(0).tv=0  'handle of thread
		      thread(0).exc=0 'no exec auto
		      #Ifdef fulldbg_prt    
		  			dbg_prt ("create process debug") 
					dbg_prt ("DebugEv.dwProcessId "+Str(DebugEv.dwProcessid))
					dbg_prt ("DebugEv.dwThreadId "+Str(DebugEv.dwThreadId))
		    		dbg_prt ("hFile "+Str(.hfile))
		    		dbg_prt ("hProcess "+Str(.hprocess))
					dbg_prt ("hThread "+Str(.hthread))		  
					dbg_prt ("lpBaseOfImage "+Str(.lpBaseOfImage))
					dbg_prt ("dwDebugInfoFileOffset "+Str(.dwDebugInfoFileOffset))
					dbg_prt ("nDebugInfoSize "+Str(.nDebugInfoSize))
					dbg_prt ("lpThreadLocalBase "+Str(.lpThreadLocalBase))
					dbg_prt ("lpStartAddress "+Str(.lpStartAddress))
					dbg_prt ("lpImageName "+Str(.lpImageName))
					dbg_prt ("fUnicode "+Str(.fUnicode))
					showcontext
				#EndIf
				stab_extract(Cast(UInteger,.lpBaseOfImage),NODLL)
			End With
			ContinueDebugEvent(DebugEv.dwProcessId,DebugEv.dwThreadId, dwContinueStatus)
			
		Case EXIT_THREAD_DEBUG_EVENT: 
         #Ifdef fulldbg_prt
        		dbg_prt ("exit thread "+Str(DebugEv.dwProcessId)+" " +Str(DebugEv.dwThreadId)+" "+Str(debugev.exitthread.dwexitcode))
        	#EndIf
         If flagkill=false Then thread_del(DebugEv.dwThreadId)
         ContinueDebugEvent(DebugEv.dwProcessId,DebugEv.dwThreadId, dwContinueStatus)
         
		Case EXIT_PROCESS_DEBUG_EVENT: 
         fb_message("","END OF DEBUGGED PROCESS",MB_SYSTEMMODAL)
         #Ifdef fulldbg_prt
	         dbg_prt ("exit process"+Str(debugev.exitprocess.dwexitcode))
         #EndIf
         closehandle(dbghand)'25/01/2013
	      closehandle(dbghfile)
	      closehandle(dbghthread)
	      For i As Integer=1 To dllnb '25/01/2013
				closehandle dlldata(i).hdl 'close all the dll handles
	      Next
         watch_sav:brk_sav '27/02/2013
         ContinueDebugEvent(DebugEv.dwProcessId,DebugEv.dwThreadId, dwContinueStatus)
         prun=FALSE
      	runtype=RTEND
         but_enable()
         menu_enable()
         If dsptyp>99 Then PostMessage(windmain,WM_COMMAND,IDBUTMINI,0) 'restore full display !!!
         Exit While
         
		Case LOAD_DLL_DEBUG_EVENT  '24/01/2013
     		Dim loaddll As LOAD_DLL_DEBUG_INFO=DebugEv.loaddll
     		Dim As String dllfn
     		Dim As Integer d,delta
      	#Ifdef fulldbg_prt
      	   dbg_prt(""):dbg_prt("Load dll event Pid/Tid "+Str(DebugEv.dwProcessId)+" "+Str(DebugEv.dwThreadId))
      		dbg_prt ("hFile="+Str(loaddll.hFile)+" lpBaseOfDll="+Str(loaddll.lpBaseOfDll)+" "+dll_name(loaddll.hFile))
			#EndIf
			'check yet loaded '01/02/2013
			dllfn=dll_name(loaddll.hFile)			
			For i As Integer= 1 To dllnb
				If dllfn=dlldata(i).fnm Then d=i:Exit For
			Next
			
			If d=0 Then 'not found
				If dllnb>=DLLMAX Then 'limit reached
	      		fb_message("New dll","Number of dll ("+Str(DLLMAX)+") exceeded , change the DLLMAX value."+Chr(10)+Chr(10)+"CLOSING FBDEBUGGER, SORRY",MB_SYSTEMMODAL Or MB_ICONSTOP)
	      		postmessage(windmain,WM_DESTROY,0,0)	
				EndIf
				dllnb+=1
	      	dlldata(dllnb).hdl=loaddll.hfile
	      	dlldata(dllnb).bse=Cast(UInteger,loaddll.lpBaseOfDll)
      		stab_extract(Cast(UInteger,loaddll.lpBaseOfDll),DLL)
      		If (linenb-linenbprev)=0 Then 'not debugged so not taking in account
      			dllnb-=1
      		Else
					dlldata(dllnb).fnm=dllfn
	      		dlldata(dllnb).gbln=vrbgbl-vrbgblprev
	      		dlldata(dllnb).gblb=vrbgblprev+1 
	      		dlldata(dllnb).lnb=linenbprev+1
	      		dlldata(dllnb).lnn=linenb
      		End If
			Else
				dlldata(d).hdl=loaddll.hfile
      		delta=Cast(Integer,loaddll.lpBaseOfDll-dlldata(d).bse)
      		If delta<>0 Then 'different address so need to change some thing
      			'lines
      			For i As Integer=dlldata(dllnb).lnb To dlldata(dllnb).lnb+dlldata(dllnb).lnb-1
						rline(i).ad+=delta
      			Next
					'globals
      			For i As Integer=dlldata(dllnb).gblb To dlldata(dllnb).gblb+dlldata(dllnb).gbln-1
      				vrb(i).adr+=delta
      			Next
      		End If
      		'normally done during stab_extract
      		For i As Integer=dlldata(dllnb).lnb To dlldata(dllnb).lnb+dlldata(dllnb).lnb-1
      			ReadProcessMemory(dbghand,Cast(LPCVOID,rline(i).ad),@rLine(i).sv,1,0) 'sav 1 byte before writing &CC
              	WriteProcessMemory(dbghand,Cast(LPVOID,rline(i).ad),@breakcpu,1,0)
     			Next
      		globals_load(d)
      		brk_apply
			EndIf	
      	ContinueDebugEvent(DebugEv.dwProcessId,DebugEv.dwThreadId, dwContinueStatus)

		Case UNLOAD_DLL_DEBUG_EVENT  '01/02/2013
			Dim unloaddll As UNLOAD_DLL_DEBUG_INFO =DebugEv.unloaddll
			#Ifdef fulldbg_prt
				dbg_prt(""):dbg_prt("UnLoad dll event "+Str(DebugEv.dwProcessId)+" "+Str(DebugEv.dwThreadId))
				dbg_prt ("lpBaseOfDll "+Str(unloaddll.lpBaseOfDll))
			#EndIf
			cpt=0
			For i As Integer=1 To dllnb
				If dlldata(i).bse=unloaddll.lpBaseOfDll Then
					closehandle dlldata(i).hdl
					dlldata(i).hdl=0
					For m As Integer =2 To procrnb
						If procr(m).tv=dlldata(i).tv Then proc_del(m,2):Exit For 'delete procr().tv 
					Next
					
					'For m As Integer =1 To brknb 'delete brkpoint but before trying to save it in brkexe
					Dim As Integer m=1
					While m<=brknb
						If brkol(m).index>=dlldata(i).lnb AndAlso brkol(m).index<=dlldata(i).lnn Then 'inside rline of dll
							'create in brkexe for use in next dll loading
							For n As Integer = BRKMAX To 1 Step-1 'search by the last slot, later if there are BRKMAX brkpt this one will be loose
								If brkexe(0,n)="" Then 'find an empty slot if not data is loose
									brkexe(0,n)=name_extract(source(brkol(m).isrc))+","+Str(brkol(m).nline)+","+Str(brkol(m).typ)
								EndIf
								Exit For
							Next
							brk_del(m)
						EndIf
						m+=1
					Wend
					Exit For
				EndIf
			Next
         ContinueDebugEvent(DebugEv.dwProcessId,DebugEv.dwThreadId, dwContinueStatus)
         
		Case OUTPUT_DEBUG_STRING_EVENT
			#Ifdef fulldbg_prt
    			dbg_prt( "OUTPUT DEBUG")
    		#EndIf
    		debugstring_read(debugev)
    		ContinueDebugEvent(DebugEv.dwProcessId,DebugEv.dwThreadId, dwContinueStatus)
    		
		Case RIP_EVENT
			#Ifdef fulldbg_prt
				dbg_prt( "RIP EVENT")
			#EndIf
			ContinueDebugEvent(DebugEv.dwProcessId,DebugEv.dwThreadId, dwContinueStatus)
	end Select
Wend
Return 0 'not really used
end Function
'======================================================
sub gest_brk(ad as uinteger)
Dim As UInteger i,debut=1,fin=linenb+1,adr,iold
dim vcontext as CONTEXT
'24/01/2013 egality added in case attach (example access violation) without -g option, ad=procfn=0....
If ad>=procfn Then thread_rsm():Exit Sub 'out of normal area, the first exception breakpoint is dummy or in case of use of debugbreak
 
'dbg_prt2("AD "+Str(ad)+" "+Str(threadcur))

i=thread(threadcur).sv+1
proccurad=ad
If rline(i).ad<>ad Then 'hope next source line is next executed line (optimization)
	While 1
		iold=i '04/02/2013
		i=(debut+fin)\2 'first consider that the addresses are sorted increasing order
		If i=iold Then 'loop
			For j As Integer =1 to linenb
				If rline(j).ad=ad then i=j:Exit While
			Next
		End If	
		If ad>rLine(i).ad Then
			debut=i
		ElseIf ad<rLine(i).ad Then
			fin=i
		Else
			Exit While
		End If
	Wend
EndIf
'restore CC previous line
If thread(threadcur).sv<>-1 then WriteProcessMemory(dbghand,Cast(LPVOID,rLine(thread(threadcur).sv).ad),@breakcpu,1,0)
'thread changed by threadcreate or by mutexunlock
If threadcur<>threadprv Then
	If thread(threadprv).sv<>i Then 'don't do it if same line otherwise all is blocked.....not sure it's usefull
		WriteProcessMemory(dbghand,Cast(LPVOID,rLine(thread(threadprv).sv).ad),@breakcpu,1,0) 'restore CC 
	EndIf
	stopcode=CSNEWTHRD  'status HALT NEW THREAD
	runtype=RTSTEP
	thread_text(threadprv) 'not next executed
	thread_text(threadcur) 'next executed
	threadprv=threadcur
EndIf

thread(threadcur).od=thread(threadcur).sv:thread(threadcur).sv=i
procsv=rline(i).pr
'get and update registers
vcontext.contextflags=CONTEXT_CONTROL
GetThreadContext(threadcontext,@vcontext)
If proccurad=proc(procsv).db Then 'is first proc instruction
	If rline(i).sv=85 Then'check if the first instruction is push ebp opcode=85
		'in this case there is a prologue
      'at the beginning of proc EBP not updated so use ESP
		procsk=vcontext.esp-4 'ESP-4 for respecting prologue : push EBP then mov ebp,esp
	Else' no prologue so naked proc
	   procsk=vcontext.esp
	   thread(threadcur).nk=procsk
	End If
Else
	 'only for naked, check if return by comparing top of stack because no epilog
    If thread(threadcur).nk then
	    If vcontext.esp>thread(threadcur).nk Then '
	    	thread(threadcur).pe=TRUE
	    	thread(threadcur).nk=0
	    EndIf
    End If
EndIf
vcontext.Eip=ad
setThreadContext(threadcontext,@vcontext)
If thread(threadcur).pe Then 'if previous instruction was the last of proc
   procsk=vcontext.ebp 'reload procsk with ebp 
	proc_end():thread(threadcur).pe=FALSE
EndIf
If proccurad=proc(procsv).db Then 'is first instruction ?
	If proctop Then runtype=RTSTEP:procad=0:procin=0:proctop=FALSE:procbot=0' step call execute one step to reach first line 02/03/2013
	proc_new:thread_rsm:Exit Sub '12/12/2012
ElseIf proccurad=proc(procsv).fn Then
	thread(threadcur).pe=TRUE        'is last instruction ?
EndIf

If runtype=RTRUN Then
	' test breakpoint on line
	if brk_test(proccurad) then runtype=RTSTEP:procad=0:procin=0:proctop=FALSE:procbot=0:dsp_change(i):Exit Sub
	'test beakpoint on var
	if brkv.adr<>0 Then
        if brkv_test() then runtype=RTSTEP:procad=0:procin=0:proctop=FALSE:procbot=0:dsp_change(i):exit Sub
	end If
	if procad Then 	'test out
		if proc(procad).fn=proccurad Then procad=0:procin=0:proctop=FALSE:procbot=0:runtype=RTSTEP 'still running ONE step before stopping
	ElseIf procin Then 'test over
		If procsk>=procin Then procad=0:procin=0:proctop=FALSE:procbot=0:runtype=RTSTEP:dsp_change(i):exit sub
	ElseIf procbot Then 'test end of proc 26/02/2013
      If proc(procbot).fn=proccurad Then procad=0:procin=0:proctop=FALSE:procbot=0:runtype=RTSTEP:dsp_change(i):Exit Sub 'stop on end of proc STEPRETURN
	end If
	thread_rsm()
ElseIf runtype=RTFRUN Then
		fasttimer=Timer-fasttimer
   	For i As Integer = 1 To linenb 'restore CC
			WriteProcessMemory(dbghand,Cast(LPVOID,rline(i).ad),@breakcpu,1,0)
   	Next
   	'WriteProcessMemory(dbghand,Cast(LPVOID,rLine(i).ad),@rLine(i).sv,1,0) 'restore old value for execution
		brk_test(proccurad) ' cancel breakpoint on line, if command halt not really used
		proc_newfast   'creating running proc tree 
		var_sh			'updating informations about variables
		runtype=RTSTEP:dsp_change(i)
Else 'RTSTEP or RTAUTO
	If flagattach Then proc_newfast:flagattach=FALSE  '12/12/2012
	dsp_change(i)
	if runtype=RTAUTO Then '15/03/2013
		sleep(autostep)
		If threadaut>1 Then 'at least 2 threads
			dim As Integer c=threadcur
			Do
				c+=1:If c>threadnb Then c=0
			Loop Until thread(c).exc
			thread_change(c)
		EndIf
		thread_rsm
	EndIf

	If threadsel<>threadcur AndAlso fb_message("New Thread","Previous thread "+Str(thread(threadsel).id)+" changed by "+Str(thread(threadcur).id) _
			+Chr(10)+Chr(13)+" Keep new one ?",MB_SYSTEMMODAL or MB_YESNO OR MB_ICONQUESTION)=IDNO Then
			thread_change(threadsel)
	Else
		threadsel=threadcur
	EndIf
End if
End sub
'====================== new sub ou func ===============
sub proc_new()
dim libel as String
Dim tv As HTREEITEM
	If procrnb=PROCRMAX Then fb_message ("CLOSING DEBUGGER","Max number of sub/func reached"):DestroyWindow (windmain):Exit Sub
	procrnb+=1'new proc ADD A POSSIBILITY TO INCREASE THIS ARRAY
	procr(procrnb).sk=procsk
	procr(procrnb).thid=thread(threadcur).id
	procr(procrnb).idx=procsv
	
	'test if first proc of thread  '04/12/2012
	If thread(threadcur).plt=0 Then
		procr(procrnb).cl=-1  ' no real calling line
		libel="ThID="+Str(procr(procrnb).thid)+" "
		tv=TVI_LAST 'insert in last position
		
		thread(threadcur).tv= Tree_AddItem(null,"Not filled", 0, tviewthd)'create item '13/12/2012
		thread(threadcur).ptv=thread(threadcur).tv 'last proc 
		thread_text()'put text not only current but all to reset previous thread text 
		
	Else
		procr(procrnb).cl=thread(threadcur).od
		tv=thread(threadcur).plt 'insert after the last item of thread
	EndIf
		
	'add manage LIST
	If flagtrace Then dbg_prt ("NEW proc "+proc(procsv).nm)
	libel+=proc(procsv).nm+":"+proc_retval(procsv)
	If flagverbose Then libel+=" ["+Str(proc(procsv).db)+"]"
	
	procr(procrnb).tv=Tree_AddItem(0,libel,tv,tviewvar)
	thread(threadcur).plt=procr(procrnb).tv 'keep handle last item
	
	'add new proc to thread treeview '13/12/2012
	thread(threadcur).ptv=Tree_AddItem(thread(threadcur).ptv,"Proc : "+proc(procsv).nm,TVI_FIRST,tviewthd)
	thread_text(threadcur)
	RedrawWindow tviewthd, 0, 0, 1
		
	var_ini(procrnb,proc(procr(procrnb).idx).vr,proc(procr(procrnb).idx+1).vr-1)
	procr(procrnb+1).vr=vrrnb+1
	proc_watch(procrnb) 'reactivate watched var
	RedrawWindow tviewvar, 0, 0, 1
end Sub

'============================= end of proc ============
sub proc_end()
Dim  As Integer j
'find running proc
For j=procrnb To 1 Step -1
	If procr(j).thid = thread(threadcur).id Then Exit for
Next
'delete all elements (treeview, varr, )
proc_del(j)
'update name of current proc
If flagtrace Then dbg_prt ("RETURN proc "+proc(procsv).nm)
end Sub
sub proc_watch(procridx as integer) 'called with running proc index
Dim As Integer prcidx=procr(procridx).idx,vridx

if procridx=1 Then
   If flagwtch=0 AndAlso wtchexe(0,0)<>"" Then watch_check(wtchexe(0,0))
   flagwtch=0
EndIf
If wtchcpt=0 then exit Sub
for i as integer= 0 to WTCHMAX
   If wtch(i).psk=-3 Then 'local var
        if wtch(i).idx=prcidx then 
           wtch(i).adr=wtch(i).dlt+procr(procridx).sk
           wtch(i).psk=procr(procridx).sk
        EndIf
   ElseIf wtch(i).psk=-4 Then 'session watch
   	If wtch(i).idx=prcidx Then
			vridx=var_search(procridx,wtch(i).vnm(),wtch(i).vnb,wtch(i).var,wtch(i).pnt)
			if vridx=-1 then fb_message("Proc watch","Running var not found"):Continue For
			var_fill(vridx)
	      watch_add(wtch(i).tad,i)
   	EndIf
   EndIf
Next
End Sub
Sub procvar_list(t As Integer=0)
	Dim tvi as TVITEM,text as zstring *100, pr as Integer
	Dim as Integer hitem,temp,level,iparent,inext
	If t=1 Then
		'get current hitem in tree
		hitem=sendmessage(tviewvar,TVM_GETNEXTITEM,TVGN_CARET,null)
		iparent=SendMessage(tviewvar,TVM_GETNEXTITEM,TVGN_PARENT,hitem)
		inext=SendMessage(tviewvar,TVM_GETNEXTITEM,TVGN_NEXT,hitem)
	Else
		'root
		hitem=sendmessage(tviewvar,TVM_GETNEXTITEM,TVGN_ROOT,null)
		iparent=0
		inext=0
	EndIf
	
	While hitem<>0
		tvI.mask       = TVIF_TEXT or TVIF_STATE
		tvI.hitem      = Cast(HTREEITEM,hitem)
		tvI.pszText    = @(text)
		tvI.cchTextMax = 99
		sendmessage(tviewvar,TVM_GETITEM,0,Cast(LPARAM,@tvi))
		#Ifdef fulldbg_prt
			dbg_prt(space(level*4)+text)
		#EndIf
		temp=SendMessage(tviewvar,TVM_GETNEXTITEM,TVGN_CHILD,hitem)
		level+=1
	   While temp=0
			temp=SendMessage(tviewvar,TVM_GETNEXTITEM,TVGN_NEXT,hitem)
			If temp<>0 Then
				If inext=temp Then Exit While,While 
				level-=1:exit While
			EndIf
			hitem=SendMessage(tviewvar,TVM_GETNEXTITEM,TVGN_PARENT,hitem)
			level-=1
			If hitem=iparent Then Exit While,While
	   Wend
	   hitem=temp
	Wend
End Sub
Sub globals_load(d As Integer=0) 'load shared and common variables, input default=no dll number '01/02/2013
Dim temp As HTREEITEM
Dim As Integer vb,ve 'begin/end index global vars
Dim As Integer vridx '08/02/2013
	If vrbgblprev<>vrbgbl Then 'need to do ?
		If vrbgblprev=0 Then
			procr(procrnb).tv= Tree_AddItem(null,"Globals (shared/common) in : main ", 0, tviewvar) 'only first time
			var_ini(procrnb,1,vrbgbl)'26/01/2013 add vrbgblprev instead 1
		Else
			procrnb+=1 '28/01/2013
			temp=Cast(HTREEITEM,SendMessage(tviewvar,TVM_GETNEXTITEM,TVGN_PREVIOUS,Cast(LPARAM,procr(1).tv)))'29/01/2013
			If temp=0 Then 'no item before main
				temp=TVI_FIRST
			EndIf
			If d=0 Then 'called from extract stabs
				d=dllnb
				vb=vrbgblprev+1
				ve=vrbgbl
			Else
				vb=dlldata(d).gblb
				ve=dlldata(d).gblb+dlldata(d).gbln-1
			End If
			procr(procrnb).tv= Tree_AddItem(null,"Globals in : "+dll_name(dlldata(d).hdl,2),temp, tviewvar)
			procr(procrnb).sk=dlldata(d).bse
			dlldata(d).tv=procr(procrnb).tv
			var_ini(procrnb,vb,ve)
			procr(procrnb+1).vr=vrrnb+1 'put lower limit for next procr 28/01/2013
			procr(procrnb).idx=0
			
			'08/02/2013
			If wtchcpt Then
				For i as integer= 0 to WTCHMAX
   				If wtch(i).psk=-3 Then 'restart
   					If wtch(i).idx=0 then 'shared dll
           				wtch(i).adr=wtch(i).dlt+procr(procrnb).sk
           				wtch(i).psk=procr(procrnb).sk
   					EndIf
   				ElseIf wtch(i).psk=-4 Then 'session watch
   					If wtch(i).idx=0 Then 'shared dll
							vridx=var_search(procrnb,wtch(i).vnm(),wtch(i).vnb,wtch(i).var,wtch(i).pnt)
							If vridx=-1 then fb_message("Proc watch","Running var not found"):Continue For
							var_fill(vridx)
	     					watch_add(wtch(i).tad,i)
   					EndIf
   				EndIf
				Next
			EndIf
			
		EndIf
		RedrawWindow tviewvar, 0, 0, 1
	EndIf
End Sub
Function var_sh1(i as integer) as string
Dim adr As UInteger,text As String,soffset As String
Dim as integer temp1,temp2,temp3,vlbound(4),vubound(4)
      If vrr(i).vr<0 then
            With cudt(abs(vrr(i).vr))
                text=.nm+" "
                If .arr then
                    text+=" [ "
                    For j As Integer =0 To .arr->dm-1
                        text+=Str(.arr->nlu(j).lb)+"-"+Str(.arr->nlu(j).ub)+":"+Str(vrr(i).ix(j))+" "
                    Next
                    text+="] "
                end if
                if .typ=TYPEMAX Then 'bitfield
                    text+="<BITF"+var_sh2(2,vrr(i).ad,.pt,str(.ofs)+" / ")
                    temp1=valint(right(text,1)) 'byte value
                    temp1=temp1 shr .ofb        'shifts to get the concerned bit on the right
                    temp1=temp1 and ((2*.lg)-1) 'clear others bits
                    MID(text,len(text)) =str(temp1) 'exchange byte value by bit value
                    Mid(text,InStr(text,"<BITF")+5)="IELD"  'exchange 'byte' by IELD
                else
                    text+="<"+var_sh2(.typ,vrr(i).ad,.pt,str(.ofs)+" / ")
                end If
                'Tree_upditem(vrr(i).tv,text,tviewvar)
                return text
            end with
        else
			With vrb(vrr(i).vr)
			text=.nm+" "
			soffset=""

			If .arr=-1 Then 'dynamic array ?
				adr=vrr(i).ini
				ReadProcessMemory(dbghand,Cast(LPCVOID,adr),@adr,4,0)
				If adr Then 'sized ?
					text+=" [ Dyn "
					temp2=vrr(i).ini+16 'adr nb dim
					ReadProcessMemory(dbghand,Cast(LPCVOID,temp2),@temp3,4,0)
					temp3-=1
					For k As Integer =0 To temp3
						temp2+=8
						ReadProcessMemory(dbghand,Cast(LPCVOID,temp2),@temp1,4,0)
						If vrr(i).ad=0 Then 'init index ubound
							vrr(i).ix(k)=temp1
						Else	
							If vrr(i).ix(k)<temp1 Then vrr(i).ix(k)=temp1 'index can't be <lbound
						End If
						text+=Str(temp1)+"-"
						vlbound(k)=temp1
						temp2+=4
						ReadProcessMemory(dbghand,Cast(LPCVOID,temp2),@temp1,4,0)
						If vrr(i).ix(k)>temp1 Then vrr(i).ix(k)=temp1 'index can't be >ubound
						text+=Str(temp1)+":"+Str(vrr(i).ix(k))+" "
						vubound(k)=temp1
					Next
					text+="]"
					'compute DELTA
					temp1=vrr(i).ix(0)-vlbound(0)
					For k as integer = 1 to temp3
						temp1+=temp1*(vubound(k)-vlbound(k)+1)+vrr(i).ix(k)-vlbound(k)
					Next
					
					If vrr(i).ad Then 'still sized
						temp1=adr+temp1*udt(vrb(vrr(i).vr).typ).lg 
						temp2=temp1-vrr(i).ad:vrr(i).ad=temp1
						If .typ>15 then 'update new adress of udt components
							temp1=sendmessage(tviewvar,TVM_GETNEXTITEM,TVGN_NEXT,Cast(LPARAM,vrr(i).tv))'next same level
							temp3=i+1
							While temp3<=vrrnb and vrr(temp3).tv<>temp1
								vrr(temp3).ad+=temp2
								temp3+=1
							Wend
						End If

					Else 'first time sized
						vrr(i).ad=adr 'real address
						If .typ>15 then 'update new adress of udt components
							temp1=sendmessage(tviewvar,TVM_GETNEXTITEM,TVGN_NEXT,Cast(LPARAM,vrr(i).tv))'next same level
							temp3=i+1
							While temp3<=vrrnb and vrr(temp3).tv<>temp1
								vrr(temp3).ad=vrr(temp3).ini+adr
								vrr(temp3).ini=vrr(temp3).ad
								temp3+=1
							Wend
						End If
					End If
				Else
					text+=" [ Dyn array not defined]"
				End if
			ElseIf .arr then
            text+=" [ "
            For k As Integer =0 To .arr->dm-1
               text+=Str(.arr->nlu(k).lb)+"-"+Str(.arr->nlu(k).ub)+":"+Str(vrr(i).ix(k))+" "
            Next
            text+="]"
			End if

         adr=vrr(i).ad

			Select Case .mem
				Case 1
					text+="<Local / "
					soffset=Str(.adr)+" / " 'offset
				Case 2
					text+="<Shared / "
				Case 3
					text+="<Static / "
				Case 4 'use *adr
					text+="<Byref param / "
					 ' ini kept the stack adr but not for param array() in this case always dyn so structure
					If .arr<>-1 Then soffset=Str(.adr)+" / "+Str(vrr(i).ini)+" / "
				Case 5
					text+="<Byval param / "
					soffset=Str(.adr)+" / "
				Case 6
					text+="<Common / "
			End Select
				If .arr=-1 Then soffset+=Str(vrr(i).ini)+" >> " 
            text+=var_sh2(.typ,adr,.pt,soffset) 
            'Tree_upditem(vrr(i).tv,text,tviewvar)
            return text
        End With
        End if
end Function
Sub var_sh() 'show master var
    For i As integer =1 to vrrnb
        Tree_upditem(vrr(i).tv,var_sh1(i),tviewvar)
    next
   watch_array()
   watch_sh
End Sub
Sub watch_array() 
'compute watch for dyn array
Dim As UInteger adr,temp2,temp3
For k as integer = 0 to WTCHMAX
	 If wtch(k).psk=-1 Orelse wtch(k).psk=-3 Orelse wtch(k).psk=-4 Then Continue for
    if wtch(k).arr Then 'watching dyn array element ?
        adr=vrr(wtch(k).ivr).ini
        ReadProcessMemory(dbghand,Cast(LPCVOID,adr),@adr,4,0)
        if adr<>wtch(k).arr then wtch(k).adr+=wtch(k).arr-adr:wtch(k).arr=adr 'compute delta then add it if needed
        temp2=vrr(wtch(k).ivr).ini+8 'adr global size
        ReadProcessMemory(dbghand,Cast(LPCVOID,temp2),@temp3,4,0)
        If wtch(k).adr>adr+temp3 Then 'out of limit ?
            watch_del(k) ' then erase
        End If
    End If
Next
End Sub
'==============================================
'fill treeview and real address
Sub var_ini(j As UInteger ,bg As Integer ,ed As integer) 'store informations For master var
	Dim adr As UInteger
		For i As Integer = bg To ed
			With vrb(i)
            If .mem<>2 andalso .mem<>3 AndAlso .mem<>6 Then
					adr=.adr+procr(j).sk 'real adr
            Else
					adr=.adr
            EndIf
				If vrrnb=VRRMAX Then fb_message("Too much variables","--> lost"):Exit Sub
				vrrnb+=1:vrr(vrrnb).vr=i
				vrr(vrrnb).ad=adr
				If .arr Then
					vrr(vrrnb).ini=adr 'keep adr for [0] or structure for dyn
					'dynamic array not yet known so initialise address with null
            	If .arr=-1 Then
            		vrr(vrrnb).ad=0
            		if .mem <>4 then adr=0:WriteProcessMemory(dbghand,Cast(LPVOID,vrr(vrrnb).ini),@adr,4,0)
            	Else
						For k As Integer =0 To 4 'clear index puting lbound
							vrr(vrrnb).ix(k)=.arr->nlu(k).lb
						Next
            	End If
				EndIf
				If .mem =4 Then 'modif for byref only real address
					vrr(vrrnb).ini=adr
            	ReadProcessMemory(dbghand,Cast(LPCVOID,adr),@adr,4,0)
            	If .arr=-1 Then vrr(vrrnb).ini=adr Else vrr(vrrnb).ad=adr
				End If
				vrr(vrrnb).tv=Tree_AddItem(procr(j).tv,"Not filled", TVI_LAST, tviewvar)
				If .pt=0 And .typ>15 Andalso .typ<>TYPEMAX AndAlso udt(.typ).en=0 Then 'show components for bitfield
               var_iniudt(.typ,adr,vrr(vrrnb).tv,0)
				End If
			End With
		Next
End Sub
Sub var_iniudt(Vrbe As UInteger,adr As UInteger,tv As HTREEITEM,voffset As UInteger)'store udt components
	Dim ad As UInteger,text As String
	For i As Integer =udt(Vrbe).lb To udt(vrbe).ub
		With cudt(i)
         vrrnb+=1:vrr(vrrnb).vr=-i
         ad=.ofs+voffset
        	if adr=0 Then 
             vrr(vrrnb).ad=0 'element in dyn array not defined
             vrr(vrrnb).ini=ad  
         else
             vrr(vrrnb).ad=adr+ad 'real address
             vrr(vrrnb).ini=adr+ad 'use when change index
        	end If
        	If .arr then 'clear index puting ubound
	        	For k As Integer =0 To 4
					vrr(vrrnb).ix(k)=.arr->nlu(k).lb
	        	Next
	      End If
         vrr(vrrnb).tv=Tree_AddItem(tv,"L", TVI_LAST, tviewvar)
         If .pt=0 andalso .typ>15 Andalso .typ<>TYPEMAX  AndAlso udt(.typ).en=0 Then 'show components for bitfield 
             var_iniudt(.typ,adr,vrr(vrrnb).tv,ad)
         End If
		End With
	Next
End Sub
Function var_sh2(t As Integer,pany As UInteger,p As UByte,sOffset As String) As String
	dim adr As UInteger,varlib As string
	Union pointers
	pinteger As Integer Ptr
	pbyte As Byte Ptr
	pubyte As UByte Ptr
	pzstring As ZString Ptr
	pshort As Short Ptr
	pushort As uShort Ptr
	'7 void ?
	puinteger As uInteger Ptr
	pLongint As LongInt Ptr
	puLongint As ULongInt Ptr
	psingle As Single Ptr
	pdouble As double ptr
	pstring As String Ptr
	pfstring As ZString Ptr
	pany As Any ptr
	End Union
	Dim Ptrs As pointers,recup(71) As Byte
	ptrs.pany=@recup(0)
	If p Then
     	If p>220 Then
			varlib=string(p-220,"*")+" Function>"
		elseIf p>200 Then 
			varlib=string(p-200,"*")+" Sub>"
     	Else
     		varlib=string(p,"*")+" "+udt(t).nm+">"
		End If
		
		If flagverbose then varlib+="[sz 4 / "+sOffset+Str(pany)+"]"
		If pany then
			ReadProcessMemory(dbghand,Cast(LPCVOID,pany),@recup(0),4,0)
     		If p>200 Then
     			varlib+="="+proc_name(*ptrs.puinteger) 'proc name
     		Else
				varlib+="="+Str(*ptrs.puinteger) 'just the value
     		EndIf
		End If
	Else
		varlib=udt(t).nm+">"
      If flagverbose then varlib+="[sz "+Str(udt(t).lg)+" / "+sOffset+Str(pany)+"]"
      If pany then
         If t>0 and t<15 Then
         	varlib+="="
				Select Case t
					Case 1 'integer
						ReadProcessMemory(dbghand,Cast(LPCVOID,pany),@recup(0),4,0)
						varlib+=Str(*ptrs.pinteger)
					Case 2 'byte
						ReadProcessMemory(dbghand,Cast(LPCVOID,pany),@recup(0),1,0)
						varlib+=Str(*ptrs.pbyte)
					Case 3 'ubyte
						ReadProcessMemory(dbghand,Cast(LPCVOID,pany),@recup(0),1,0)
						varlib+=Str(*ptrs.pubyte)
					Case 4,13,14 'stringSSSS
						if t=13 then  ' normal string
		   				ReadProcessMemory(dbghand,Cast(LPCVOID,pany),@adr,4,0) 'address ptr
						Else 
							adr=pany
						end if
		   			clear recup(0),0,71 'max 70 char
		   			ReadProcessMemory(dbghand,Cast(LPCVOID,adr),@recup(0),70,0) 'value
					   varlib+=*ptrs.pzstring
					Case 5 'short
						ReadProcessMemory(dbghand,Cast(LPCVOID,pany),@recup(0),2,0)
						varlib+=Str(*ptrs.pshort)
					Case 6 'ushort
						ReadProcessMemory(dbghand,Cast(LPCVOID,pany),@recup(0),2,0)
						varlib+=Str(*ptrs.pushort)
					Case 7,8 'uinteger
						ReadProcessMemory(dbghand,Cast(LPCVOID,pany),@recup(0),4,0)
						varlib+=Str(*ptrs.puinteger)
					Case 9 'longint
						ReadProcessMemory(dbghand,Cast(LPCVOID,pany),@recup(0),8,0)
						varlib+=Str(*ptrs.plongint)
					Case 10 'ulongint
						ReadProcessMemory(dbghand,Cast(LPCVOID,pany),@recup(0),8,0)
						varlib+=Str(*ptrs.pulongint)
					Case 11 'single
						ReadProcessMemory(dbghand,Cast(LPCVOID,pany),@recup(0),4,0)
						varlib+=Str(*ptrs.psingle)
					Case 12 'double
						ReadProcessMemory(dbghand,Cast(LPCVOID,pany),@recup(0),8,0)
						varlib+=Str(*ptrs.pdouble)
					'Case Else
						'Return "Unmanaged Type>"
				End Select
         Else
         	If udt(t).en Then
         		If pany Then ReadProcessMemory(dbghand,Cast(LPCVOID,pany),@recup(0),4,0)
         		varlib+="="+Str(*ptrs.pinteger)+" >> "+enum_find(t,*ptrs.pinteger) 'value/enum text
         	endif
         End If
      Else
         varlib+=" No valid value"
      End If
	End If
	Return varlib
End Function
Function Val_string(strg As String)As String
	Dim strg2 As String,vl As Integer
	For i As Integer=1 To Len(strg) Step 2
		vl=Valint("&h"+Mid(strg,i,2))
		If vl>31 Then
			strg2+=Chr(vl)
		Else
			strg2+="."
		EndIf
	Next
	Return strg2
End Function
Function Val_byte(strg As String)As String
	Dim strg2 As String,vl As Integer
	For i As Integer=1 To Len(strg) Step 2
		vl=Valint("&h"+Mid(strg,i,2))
		strg2+=Str(vl)+","
	Next
	Return Left(strg2,Len(strg2)-1)
End Function
Function Val_word(strg As String)As String
	Dim strg2 As String,vl As Integer
	For i As Integer=1 To Len(strg) Step 4
		vl=Valint("&h"+Mid(strg,i,4))
		strg2+=Str(vl)+","
	Next
	Return Left(strg2,Len(strg2)-1)
End Function
Function var_add(strg As String,t As Integer,d As integer)As String
	Dim As Integer ValueInt
	Dim As LongInt valuelng

	Select Case As Const t
		Case 2,3 'byte,ubyte
			Valueint=ValInt(strg)
			Select Case  As Const d
				Case 1'hex
					Return Hex(valueint,2)
				Case 2'binary
					Return Bin(valueint,8)
				Case 3'ascii
					Return Val_string(Hex(valueint,2))
			End Select
		Case 5,6 'Short,ushort
			valueint=ValInt(strg)
			Select Case  As Const d
				Case 1'hex
					Return Hex(valueint,4)
				Case 2'binary
					Return Bin(valueint,16)
				Case 3'ascii
					Return Val_string(Hex(valueint,4))
				Case 4'byte
					Return val_byte(Hex(valueint,4))
			End Select
		Case 1,7,8 'integer,void,uinteger
			valueint=ValInt(strg)
			Select Case  As Const d
				Case 1'hex
					Return Hex(valueint)
				Case 2'binary
					Return Bin(valueint)
				Case 3'ascii
					Return Val_string(Hex(valueint))
				Case 4'byte
					Return val_byte(Hex(valueint))
				Case 5'word
					Return val_word(Hex(valueint))
			End Select
		Case 9,10 'longint,ulongint
			valuelng=ValInt(strg)
			Select Case  As Const d
				Case 1'hex
					Return Hex(valuelng)
				Case 2'binary
					Return Bin(valuelng)
				Case 3'ascii
					Return Val_string(Hex(valuelng))
				Case 4'byte
					Return val_byte(Hex(valuelng))
				Case 5'word
					Return val_word(Hex(valuelng))
			End Select
	End Select
End Function

Function var_search(pproc as integer,text() as string,vnb as integer,varr as Integer,vpnt As Integer=0) As Integer
    dim as integer begv=procr(pproc).vr,endv=procr(pproc+1).vr,tvar=1,flagvar

    flagvar=TRUE 'either only a var either var then its components
    while begv<endv and tvar<=vnb 'inside the local vars and all the elements (see parsing)
        if flagvar then
            if vrr(begv).vr>0 then 'var ok
                if vrb(vrr(begv).vr).nm=text(tvar) then 'name ok
                    'testing array or not
                        flagvar=0 'only one time
                        if tvar=vnb Then
  	                  		If (varr=1 andalso vrb(vrr(begv).vr).arr<>0 ) orelse (varr=0 and vrb(vrr(begv).vr).arr=0) then
	                        	return begv 'main level happy found !!!
  	                  		EndIf

                        EndIf
                        tvar+=1 'next element, a component
                endif
            endif
        else
            'component level
            if vrr(begv).vr<0 Then
                if cudt(abs(vrr(begv).vr)).nm=text(tvar) Then
                  If tvar=vnb Then
                    	If (varr=1 andalso cudt(abs(vrr(begv).vr)).arr<>0 ) orelse (varr=0 and cudt(abs(vrr(begv).vr)).arr=0) Then
                    		Return begv'happy found !!!
                    	EndIf  
                  EndIf
                  tvar+=1 'next element
                end if
            else
                exit while 'not found inside the UDT
            endif
        end if
        begv+=1 'next running  var or component
    wend
    return -1
end function
'=======================
sub var_tip(ope As Integer)
    dim as integer nline,lclproc,lclprocr,p,n,i,j,d,l,idx=-1
    dim text as zstring *200
    dim range as charrange
    Dim tv As HTREEITEM
    n=SendMessage(dbgrichedit,EM_LINEINDEX,-1,0) 'nb char until current line
    sendmessage(dbgrichedit,EM_EXGETSEL,0, Cast(LPARAM,@range)) 'get pos cursor
    nline=sendmessage(dbgrichedit,EM_EXLINEFROMCHAR,0,-1)
    text=Chr(150)+chr(0)
    sendmessage(dbgrichedit,EM_GETLINE,nline,Cast(LPARAM,@text)) 'get line text
    if right(text,1)=Chr(13) then text=left(text,len(text)-1) 'suppress chr$(13) at the end
    text=ucase(text)
    p=range.cpmin-n+1
    'select only var name characters
    for i =p-1 to 1 step-1
        dim c as integer
        c=asc(text,i)
        if ( c>=asc("0") and c<=asc("9") ) orelse ( c>=asc("A") and c<=asc("Z") ) orelse c=asc("_") orelse c=asc(".") then continue for
        exit for
    next
    i+=1
   for j=p to len(text)
        dim c as integer
        c=asc(text,j)
        if ( c>=asc("0") and c<=asc("9") ) orelse ( c>=asc("A") and c<=asc("Z") ) orelse c=asc("_") orelse c=asc(".") then continue for
        exit for
   next

   if asc(text,j)<>asc("(") then j-=1 'if last character is  a '(' take it in account (case array)


   if i>j then
      text=""
   else
      text=mid(text,i,j-i+1) 'extract from text
   end if

    if text="" or left(text,1)="." then 
        fb_message("Selection variable error",""""+text+""" : Empty string or incomplete name (udt components)")
        exit sub
    endif

'parsing
    dim vname(10) as string,varray as integer,vnb as integer =0
    text+=".":l=len(text):d=1

    while d<l
        vnb+=1
        p=instr(d,text,".")
        vname(vnb)=mid(text,d,p-d)
        if right(vname(vnb),1)="(" then
            varray=1:vname(vnb)=mid(text,d,p-d-1):d=p+2 'array
        else
            varray=0:d=p+1
        end if
    wend



	 nline+=1'in source 1 to n <> inside richedit 0 to n-1
     lclproc=0
   for i As Integer =1 to linenb
		if rline(i).nu=nline AndAlso proc(rline(i).pr).sr=shwtab Then 'is executable (known) line ?
			lclproc=rline(i).pr:exit For ' with known line we know also the proc...
		EndIf
   Next 
    
    
    
    'search inside 
    'if no lclproc --> should be in main
    if lclproc then
	    for i as integer =procrnb to 1 Step -1
	        if procr(i).idx=lclproc then lclprocr=i:exit for ' proc running 
	    Next

    'search the variable taking in account name and array or not
    
        if lclprocr Then idx=var_search(lclprocr,vname(),vnb,varray) 'inside proc ?
    End If
    if idx=-1 then
        idx=var_search(1,vname(),vnb,varray) 'inside main ?
        if idx=-1 then fb_message("Selection variable error",""""+Left(text,Len(text)-1)+""" is not a running variable"):exit sub
    end If
    tv=vrr(idx).tv
    If ope=PROCVAR Then
    	If tviewcur<>tviewvar Then
	  		ShowWindow(tviewcur,SW_HIDE)
			tviewcur=tviewvar
	   	ShowWindow(tviewcur,SW_SHOW)
	   	SendMessage(htab2,TCM_SETCURSEL,0,0)
	   EndIf
    	SendMessage(tviewvar,TVM_SELECTITEM,TVGN_CARET,Cast(LPARAM,tv))
    	SetFocus(tviewcur)
    ElseIf ope=WATCHED then   
    	If tviewcur<>tviewwch then
	  		ShowWindow(tviewcur,SW_HIDE)
			tviewcur=tviewwch
	   	ShowWindow(tviewcur,SW_SHOW)
	   	SendMessage(htab2,TCM_SETCURSEL,3,0)
	   EndIf
	   'TRICK !! select the var for varfind2 like if user did that
    	SendMessage(tviewvar,TVM_SELECTITEM,TVGN_CARET,Cast(LPARAM,tv))
    	If var_find2(tviewvar)<>-1 Then watch_set()
    EndIf
end Sub
Function enum_find(t as integer,v as integer) as String
	'find the text associated with an enum value
    For i as integer =udt(t).lb to udt(t).ub
        if cudt(i).val=v then  return cudt(i).nm
    next
    return "Unknown Enum value"
end Function
Sub enum_check(idx as integer)
	for i as integer =1 to udtcptmax-1
	  	if udt(i).en then 'enum
	      if udt(idx).nm=udt(i).nm then 'same name
	         If udt(idx).ub-udt(idx).lb=udt(i).ub-udt(i).lb then 'same number of elements
              	if cudt(udt(idx).ub).nm=cudt(udt(i).ub).nm then 'same name for last element
                  if cudt(udt(idx).lb).nm=cudt(udt(i).lb).nm then 'same name for first element
		                'enum are considered same
		                udt(idx).lb=udt(i).lb:udt(idx).ub=udt(i).ub
		                udt(idx).en=i
		                cudtnb=cudtnbsav
		                exit sub
                  endif
              	endif
	         EndIf
	      endif
	  	endif
	next
End Sub
Sub enum_show(hwnd as HWND)
DIM lvCol   AS LVCOLUMN,lvI  AS LVITEM,il as integer, tmp as string
dim as HWND listview=fb_listview(hwnd,0,3,4,514,488) 'revoir paramètres

  
  lvCol.mask      =  LVCF_FMT OR LVCF_WIDTH OR LVCF_TEXT OR LVCF_SUBITEM
  lvCol.fmt       =  LVCFMT_LEFT
  lvcol.cx=0
  lvI.mask     =  LVIF_TEXT

  lvCol.pszText   = strptr("ENUM NAME")
  lvCol.iSubItem  = 0
  sendmessage(listview,LVM_INSERTCOLUMN,0,Cast(LPARAM,@lvCol))
  'LVSCW_AUTOSIZE_USEHEADER = -2 ou AUTOSIZE= -1)
  sendmessage(listview,LVM_SETCOLUMNWIDTH,0,150)  '?????
  
 lvCol.pszText   = strptr("ITEM")
 lvCol.iSubItem  =  1
 sendmessage(listview,LVM_INSERTCOLUMN,1,Cast(LPARAM,@lvCol))
 sendmessage(listview,LVM_SETCOLUMNWIDTH,1,250)
 lvCol.pszText   = strptr("VALUE")
 lvCol.iSubItem  =  2
 sendmessage(listview,LVM_INSERTCOLUMN,2,Cast(LPARAM,@lvCol))
 sendmessage(listview,LVM_SETCOLUMNWIDTH,2,90)
''''to avoid display update every update
  'SendMessage(listview, WM_SETREDRAW, FALSE, 0)
'   sendmessage(listview,LVM_SETCOLUMNWIDTH,lvnbcol+1,LVSCW_AUTOSIZE)'_USEHEADER)
 sendmessage(listview,LVM_SETTEXTCOLOR,0,RGB(128,0,0))
lvI.mask     = LVIF_TEXT

for i as integer = 1 to udtcptmax
    if udt(i).en=i Then ' to avoid duplicate
        lvi.iitem    = il 'index line
        lvi.isubitem = 0 'index colonn
        lvi.pszText  = strptr(udt(i).nm)
        sendmessage(listview,LVM_INSERTITEM,0,Cast(LPARAM,@lvi))
        for j as integer = udt(i).lb to udt(i).ub
            lvi.iitem    = il 'index line
            lvi.isubitem = 1
            lvi.pszText  = strptr(cudt(j).nm)
            sendmessage(listview,LVM_SETITEMTEXT,il,Cast(LPARAM,@lvi))
            'sendmessage(listview,LVM_SETCOLUMNWIDTH,lvnbcol,LVSCW_AUTOSIZE)
            lvi.isubitem = 2
            tmp=str(cudt(j).val)
            lvi.pszText  = strptr(tmp) 
            sendmessage(listview,LVM_SETITEMTEXT,il,Cast(LPARAM,@lvi))
            il+=1
            lvi.iitem    = il 'index line
            lvi.isubitem = 0 'index colonn
            lvi.pszText  = 0 'empty line
            sendmessage(listview,LVM_INSERTITEM,0,Cast(LPARAM,@lvi))
        next
        il+=1
    end if
Next
end Sub
Function shwexp_box(byval hWnd As HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
dim rc as RECT => (0, 0, 4, 8)
dim  As Integer scalex,scaley
Dim nm As String,pt As Integer,ty As Integer,ad As UInteger,tview As HWND
Dim shwexpidx As Integer,lb As HWND,pnt As Point
        
	for shwexpidx =1 to SHWEXPMAX
		If shwexp(shwexpidx).bx=hwnd Then 'find if hwnd already existing 
			tview=shwexp(shwexpidx).tv 'only to be more simple and readable
			nm=vrp(shwexpidx,1).nm 
			ty=vrp(shwexpidx,1).ty
			pt=vrp(shwexpidx,1).pt
			ad=vrp(shwexpidx,1).ad
			Exit For 
		EndIf
	Next
        
   Select CASE Msg
   	Case WM_INITDIALOG    'All of your controls are created here in the same
			MapDialogRect (hwnd,@rc)
			ScaleX = rc.right/4
			ScaleY = rc.bottom/8
			fb_modstyle(hwnd,0,WS_EX_NOPARENTNOTIFY,1)
 
         fb_button("Add Watched",         hWnd,113,260*scalex, 10*scaley, 60*scalex, 10*scaley)
         fb_button("Dump",                hWnd,114,260*scalex, 20*scaley, 60*scalex, 10*scaley)
         fb_button("Edit",                hWnd,115,260*scalex, 30*scaley, 60*scalex, 10*scaley)
         fb_button("Show String",         hWnd,116,260*scalex, 40*scaley, 60*scalex, 10*scaley)
         fb_button("New Show/Expand",     hWnd,117,260*scalex, 50*scaley, 60*scalex, 10*scaley)
         fb_button("Replace Current",     hWnd,118,260*scalex, 60*scaley, 60*scalex, 10*scaley)
         
         lb=fb_Label("Delta : "+Str(0)+" x size of type",_
                                          hwnd,120,260*scalex, 80*scaley, 80*scalex, 10*scaley,,0)
         fb_button("Delta -1",            hWnd,121,260*scalex, 90*scaley, 60*scalex, 10*scaley)
         fb_button("Delta +1",            hWnd,122,260*scalex, 100*scaley, 60*scalex, 10*scaley)
			fb_button("Set Delta",           hWnd,123,260*scalex, 110*scaley, 60*scalex, 10*scaley)
         
         fb_button("Close all shw/exp",   hWnd,130,260*scalex, 130*scaley, 60*scalex, 10*scaley)
         fb_button("Arrange windows",     hWnd,131,260*scalex, 140*scaley, 60*scalex, 10*scaley)
         
         fb_Label("About update",         hwnd,140,260*scalex, 160*scaley, 60*scalex, 10*scaley)
         fb_button("Update",              hWnd,141,260*scalex, 170*scaley, 60*scalex, 10*scaley)
         
         
         tview=fb_Treeview(hwnd,1000,2*scalex,2*scaley,250*scalex,195*scaley)
         SendMessage(tview,WM_SETFONT,Cast(WPARAM,fonthdl),0)
         
			For shwexpidx =1 to SHWEXPMAX
				If shwexp(shwexpidx).bx=0 Then Exit For 'first free slot
			Next        
         shwexpnb+=1
         shwexp(shwexpidx).bx=hwnd
         shwexp(shwexpidx).tv=tview
         shwexp(shwexpidx).dl=0
         shwexp(shwexpidx).lb=lb
         
   		shwexp_ini(shwexpidx,varfind.nm,varfind.ad,varfind.ty,varfind.pt)
   	Case WM_COMMAND
         Select case loword(wparam)
         	Case 113   'watched
          		var_find2(tview)
          		varfind.iv=-1
          		varfind.nm=varfind.nm+" ["+str(varfind.ad)+"]<"
		         watch_set()
          	case 114   'dump
          		var_dump(tview)
         	case 115   'edit
          		var_find2(tview)
          		fb_MDialog(@edit_box,"Edit var value (Be carefull)",hwnd,283,25,350,50)
          		shwexp_ini(shwexpidx,nm,ad,ty,pt)'update after editing
         	case 116   'show string
          		string_sh(tview)
         	Case 117 'new shw/exp
          		shwexp_new(tview)
         	Case 118 'Replace current show/expand
          		var_find2(tview)
          		nm="Show/expand : "+varfind.nm
          		setwindowtext(hwnd,StrPtr(nm))
          		nm=varfind.nm:ad=varfind.ad:ty=varfind.ty:pt=varfind.pt
					shwexp_ini(shwexpidx,nm,ad,ty,pt)
         	Case 121 'move backward	
					If pt=0 Then
						shwexp(shwexpidx).dl-=1
						setwindowtext(shwexp(shwexpidx).lb,"Delta : "+Str(shwexp(shwexpidx).dl)+" x size of type")
						ad-=udt(ty).lg
						If ty>15 AndAlso (ad Mod 4) Then ad=(ad\4)*4 'workaround the erroneous size of udt
						shwexp_ini(shwexpidx,nm,ad,ty,pt)
					Else
						fb_message("Move","Not possible with pointer"+Chr(13)+"Select (new shw/exp) the pointed value")
					EndIf
         	Case 122 'move forward	
					If pt=0 Then
						shwexp(shwexpidx).dl+=1
						setwindowtext(shwexp(shwexpidx).lb,"Delta : "+Str(shwexp(shwexpidx).dl)+" x size of type")
						ad+=udt(ty).lg
						If ty>15 Andalso (ad Mod 4) Then ad=(ad\4+1)*4 'workaround the erroneous size of udt
						shwexp_ini(shwexpidx,nm,ad,ty,pt)
					Else
						fb_message("Move","Not possible with pointer"+Chr(13)+"Select (new shw/exp) the pointed value")
					EndIf
         	Case 123 'set delta
					GetCursorPos(@pnt)
					MapDialogRect (hwnd,@rc)
					ScaleX = rc.right/4
					ScaleY = rc.bottom/8
					inputval=Str(shwexp(shwexpidx).dl)
					inputtyp=1
					fb_MDialog(@input_box,"Key the new value of delta",hwnd,pnt.x/scalex,pnt.y/scaley,90,30)'283,25
					if inputval<>"" Then
						ad+=(ValInt(inputval)-shwexp(shwexpidx).dl)*udt(ty).lg
						If ty>15 Andalso (ad Mod 4) Then ad=(ad\4+1)*4 'workaround the erroneous size of udt
						shwexp(shwexpidx).dl=ValInt(inputval)
						setwindowtext(shwexp(shwexpidx).lb,"Delta : "+Str(shwexp(shwexpidx).dl)+" x size of type")
						shwexp_ini(shwexpidx,nm,ad,ty,pt)
					end If
         	Case 130 'close all
          		shwexp_del()
         	Case 131 'arrange all
          		shwexp_arrange()
         	Case 140
         		fb_message("Only manual Update in show/expand","Original variables could have been deleted or replaced"_
         		+Chr(13)+"giving inconsistant results."+Chr(13)+"BE CAREFULL")
         	Case 141 'update, don't remember why a such test !!!
          		'If varptd_ini(nm,ad,ty,pt) Then vrptdbx=0:DestroyWindow(hwnd):Exit Function 'uninitialized
          		shwexp_ini(shwexpidx,nm,ad,ty,pt)
         End select
   	Case WM_CLOSE
			destroywindow(hwnd)
			shwexpnb-=1
			shwexp(shwexpidx).bx=0
         Return 0 'not really used
   End Select
end Function
Function shwexp_ini(idx As Integer,nm As string,ad As UInteger,ty As Integer,pt As Integer) As Integer
	Dim As HTREEITEM htv
	Dim As Integer temp
	Dim As UInteger adr
   Dim as string text
	Dim As HWND tview=shwexp(idx).tv
	Dim As Integer vrpnb=shwexp(idx).nb
	SendMessage(tview,TVM_DELETEITEM,0,Cast(LPARAM,TVI_ROOT)) 'delete all
	text="--> "+nm+" <"+var_sh2(ty,ad,pt,"")
	htv=Tree_AddItem(null,text,0, tview)
	vrpnb=1:shwexp(idx).nb=vrpnb
	vrp(idx,vrpnb).nm=nm
	vrp(idx,vrpnb).ty=ty
	vrp(idx,vrpnb).pt=pt
	vrp(idx,vrpnb).ad=ad
	vrp(idx,vrpnb).tl=htv
	''' USE ??? vrp(idx,vrpnb).iv=vrpnb
	adr=ad
	If pt>221 Or (pt>201 And pt<220) Or (pt And pt<200) Or (ty>15 And udt(ty).en=0) Then
		If pt Then temp=pt-1:ReadProcessMemory(dbghand,Cast(LPCVOID,ad),@adr,4,0)
		shwexp_det(idx,adr,ty,htv,temp)
		SendMessage(tview,TVM_EXPAND,TVE_EXPAND,Cast(LPARAM,htv))
	EndIf
	Return 0 'not really used
End Function
Sub shwexp_det(idx As Integer,adr As UInteger,typ As Integer,tv As HTREEITEM,pt As integer)
	dim as string text
	dim as uinteger ad,temp1
	Dim As HTREEITEM tvchild
	Dim As HWND tview=shwexp(idx).tv
	Dim As Integer vrpnb
	If pt>221 Or (pt>201 And pt<220) Or (pt And pt<200) Then
		If shwexp(idx).nb=VRPMAX Then fb_message("Creating data for show/expand","To much lines"):Exit Sub
		shwexp(idx).nb+=1
		ReadProcessMemory(dbghand,Cast(LPCVOID,adr),@ad,4,0)
		text="<"+var_sh2(typ,ad,pt,"")
		tvchild=Tree_AddItem(tv,text,TVI_LAST, tview)
		vrpnb=shwexp(idx).nb
		vrp(idx,vrpnb).ty=typ
		vrp(idx,vrpnb).pt=pt
		vrp(idx,vrpnb).ad=ad
		vrp(idx,vrpnb).tl=tvchild
		'''''''vrp(idx,vrpnb).iv=vrptdnb
		shwexp_det(idx,ad,typ,tvchild,pt-1)
		vrpnb=shwexp(idx).nb 'counter updated in the executed proc
		SendMessage(tview,TVM_EXPAND,TVE_EXPAND,Cast(LPARAM,tvchild))
	Else	
		If typ>15 And udt(typ).en=0 Then
		   For i As Integer = udt(typ).lb To udt(typ).ub
		   	If shwexp(idx).nb=VRPMAX Then fb_message("Creating data for show/expand","To much lines"):Exit Sub
		   	shwexp(idx).nb+=1
		      With cudt(i)
		    	text=.nm+" "
		    	If .arr then
		        	text+=" [ "
		        	For j As Integer =0 To .arr->dm-1
		         	text+=Str(.arr->nlu(j).lb)+"-"+Str(.arr->nlu(j).ub)+" "
		        	Next
		        	text+="] "
		    	end If
		    	ad=adr+.ofs
		    	if .typ=TYPEMAX Then 'bitfield
					text+="<BITF"+var_sh2(2,ad,.pt,str(.ofs)+" / ")
					temp1=valint(right(text,1)) 'byte value
					temp1=temp1 shr .ofb        'shifts to get the concerned bit on the right
					temp1=temp1 and ((2*.lg)-1) 'clear others bits
					MID(text,len(text)) =str(temp1) 'exchange byte value by bit value
					Mid(text,InStr(text,"<BITF")+5)="IELD"  'exchange 'byte' by IELD
		    	else
		        	text+="<"+var_sh2(.typ,ad,.pt,str(.ofs)+" / ")
		    	end If
		    	tvchild=Tree_AddItem(tv,text,TVI_LAST, tview)
		    	vrpnb=shwexp(idx).nb
				vrp(idx,vrpnb).nm=.nm
				vrp(idx,vrpnb).ty=.typ
				vrp(idx,vrpnb).pt=.pt
				vrp(idx,vrpnb).ad=ad
				vrp(idx,vrpnb).tl=tvchild
				''''''''vrp(idx,vrpnb).iv=vrptdnb
				If .pt>221 Or (.pt>201 And .pt<220) Or (.pt And .pt<200) Or .pt=0 Then
					temp1=.pt
			   	If .pt>0 Then  readProcessMemory(dbghand,Cast(LPCVOID,ad),@ad,4,0):temp1-=1
			   
			   	If .pt>200 Or (.pt And .typ<16)  Or (.pt And .typ>15 And udt(.typ).en) Or (.pt=0 And .typ>15 And udt(.typ).en=0 And .typ<>TYPEMAX) Then
			   		shwexp_det(idx,ad,.typ,tvchild,temp1)
			   		vrpnb=shwexp(idx).nb 'counter updated in the executed proc
				    	SendMessage(tview,TVM_EXPAND,TVE_EXPAND,Cast(LPARAM,tvchild))
			   	EndIf
			   End if
		      End With
		   Next
		Else
		   If shwexp(idx).nb=VRPMAX Then fb_message("Creating data for show/expand","To much lines"):Exit Sub
	    	shwexp(idx).nb+=1
	      text="<"+var_sh2(typ,adr,0,"")
	      vrpnb=shwexp(idx).nb
			vrp(idx,vrpnb).ty=typ
			vrp(idx,vrpnb).pt=0
			vrp(idx,vrpnb).ad=adr
			vrp(idx,vrpnb).tl=Tree_AddItem(tv,text,TVI_LAST, tview)
			''''''vrp(idx,vrpnb).iv=vrpnb
		End If
	End If
End Sub
sub shwexp_del()'reset (destroy) all shwexp boxes
if shwexpnb then
    for i as integer=1 to SHWEXPMAX
        if shwexp(i).bx then destroywindow(shwexp(i).bx):shwexp(i).bx=0
    next
    shwexpnb=0
end if
end Sub
    
sub shwexp_arrange()'arrange all shwexp boxes
Dim rec as rect
if shwexpnb>1 Then 'at least two boxes !!
   For i as integer=1 to SHWEXPMAX
		if shwexp(i).bx Then
			getwindowrect(shwexp(i).bx,@rec)
			movewindow(shwexp(i).bx,500+i*20,500+i*20,rec.right-rec.left+1,rec.bottom-rec.top+1,TRUE)
		EndIf
   Next
end if
end Sub    
sub shwexp_new(tview as HWND)
	If var_find2(tview)=-1 Then Exit Sub 'found the variable ? no if -1
	if shwexpnb<SHWEXPMAX then  'is there a free slot ?
		fb_Dialog(@shwexp_box,"Show/expand : "+varfind.nm,windmain,283,25,350,200)
	Else
		'no free slot
		fb_message("Show/Expand variable or memory","Max number of windows reached ("+str(SHWEXPMAX)+chr(13)+"Close one window and try again")
	end if 
end Sub 
Function name_extract(a As String) As String 'extract file name for full name
	Dim i As Integer
	For i=Len(a) To 1 Step -1
		If a[i-1]=Asc(":") Or a[i-1]=Asc("\") Or a[i-1]=Asc("/") Then Exit for
	Next
	Return Mid(a,i+1)
End Function

Sub ini_write()
	Dim As Integer fileout
	Dim lineread As String
	If Dir(ExePath+"\fbdebugger.ini")<>"" Then
		If Dir(ExePath+"\fbdebuggersav.ini")<>"" Then Kill ExePath+"\fbdebuggersav.ini"
		Name (ExePath+"\fbdebugger.ini",ExePath+"\fbdebuggersav.ini")
    endif
    fileout=FreeFile
    Open ExePath+"\fbdebugger.ini" For output As fileout

    if fbcexe<>"" then Print #fileout,"[FBC]="+fbcexe
    if ideexe<>"" then Print #fileout,"[IDE]="+ideexe
    
	For i As Integer = 0 To 9
		If savexe(i)<>"" then
			Print #fileout,"[EXE]="+savexe(i)
			If cmdexe(i)<>"" then Print #fileout,"[CMD]="+cmdexe(i) '27/02/2013
			For j As Integer =0 To WTCHMAX
				If wtchexe(i,j)<>"" Then
					Print #fileout,"[WTC]="+wtchexe(i,j)
				Else
					Exit for
				EndIf
			Next
			
			For j As Integer =1 To BRKMAX '27/02/2013
				If brkexe(i,j)<>"" Then
					Print #fileout,"[BRK]="+brkexe(i,j)
				'Else
				'	Exit for
				EndIf
			Next
		End if
	Next
	If flagtooltip=TRUE Then
		Print #fileout,"[TTP]=TRUE"
	Else
		Print #fileout,"[TTP]=FALSE"
	EndIf
	If hgltflag=TRUE Then
		Print #fileout,"[HLK]=TRUE"
	Else
		Print #fileout,"[HLK]=FALSE"
	EndIf
	Print #fileout,"[FTN]="+fontname
	Print #fileout,"[FTS]="+Str(fontsize)
	Print #fileout,"[DPO]="+Str(dspofs)
	Print #fileout,"[CRE]="+Str(clrrichedit) 'color background richedit
	Print #fileout,"[CHK]="+Str(clrkeyword) 'color highlighted keywords
	Print #fileout,"[CCL]="+Str(clrcurline) 'color current line
	Print #fileout,"[CTB]="+Str(clrtmpbrk) 'color tempo breakpoint
	Print #fileout,"[CPB]="+Str(clrperbrk) 'color perm breakpoint
	If jitprev<>"" Then Print #fileout,"[JIT]="+jitprev
	Print #fileout,"[LOG]="+Str(flaglog) 'type of log
	Print #fileout,"[PST]="+Str(procsort) 'type of procs sort
	
	For i As Integer=0 To shcutnb-1 
		If shcut(i).sccur Then Print #fileout,"[SCK]="+Str(shcut(i).scidnt)+","+Str(shcut(i).sccur) 'customized (or default) shortcuts
	Next
	
	Close fileout
End Sub
'================
'// INDEXTOSTATEIMAGEMASK(2) is the checked state
'// INDEXTOSTATEIMAGEMASK(1) is the unchecked state
'// INDEXTOSTATEIMAGEMASK(0) removes the checkbox (no state)
Sub proc_sh()
   Dim libel as string
   Dim tvi as TVITEM
	SendMessage(tviewprc,TVM_DELETEITEM,0,Cast(LPARAM,TVI_ROOT)) 'zone proc
   tvI.mask      = TVIF_STATE
   tvI.statemask = TVIS_STATEIMAGEMASK
	For j As integer =1 To procnb
		With proc(j)
			If procsort=KMODULE Then 'sorted by module
				libel=name_extract(source(.sr))+">> "+.nm+":"+proc_retval(j)
			Else 'sorted by proc name
				libel=.nm+":"+proc_retval(j)+"   << "+name_extract(source(.sr))
			EndIf
			If flagverbose Then libel+=" ["+str(.db)+"]"
		   .tv=Tree_AddItem(null,libel, 0, tviewprc)
		   tvI.hitem= .tv
		   tvI.state= INDEXTOSTATEIMAGEMASK(.st)
		   sendmessage(tviewprc,TVM_SETITEM,0,Cast(LPARAM,@tvi))
		end With
	Next
	SendMessage(tviewprc,TVM_SORTCHILDREN ,0,0) 'Activate to sort elements
end Sub
'============
sub proc_activ(hitem as HTREEITEM)
'Retrieve the new checked state of the item and handle the notification.
' Get the state
' other possibility state=SendMessage(hwnd_treeview, TVM_GETITEMSTATE, (WPARAM)htreeitem, TVIS_STATEIMAGEMASK);

    dim tvi as TVITEM, p as integer =0
    tvI.mask       = TVIF_STATE
    tvI.hitem      = hitem
    sendmessage(tviewprc,TVM_GETITEM,0,Cast(LPARAM,@tvi))
    do
        p+=1
    loop while proc(p).tv<>hitem
    if left(hex(tvi.state),1)="2" then    'checked = not followed proc
    	  If proc_verif(p) Then
    	  		fb_message("Proc "+proc(p).nm+" is running","Can't be not followed")
    	  		tvI.statemask = TVIS_STATEIMAGEMASK
    	  		tvI.state= INDEXTOSTATEIMAGEMASK(1)
    	  		sendmessage(tviewprc,TVM_SETITEM,0,Cast(LPARAM,@tvi))
    	  else
        		proc(p).st=2
        		for i as integer =1 to linenb
            	if rline(i).pr=p then  WriteProcessMemory(dbghand,Cast(LPVOID,rline(i).ad),@rline(i).sv,1,0)
        		Next
        	End if
    else   'followed proc
    	  If fb_message("Reactivate Proc "+proc(p).nm,"If running --> big problem",MB_OKCANCEL Or MB_ICONWARNING)=IDOK then
        		proc(p).st=1
        		for i as integer =1 to linenb
            	if rline(i).pr=p then  WriteProcessMemory(dbghand,Cast(LPVOID,rline(i).ad),@breakcpu,1,0)
        		Next
    	  Else
    	  	   tvI.statemask = TVIS_STATEIMAGEMASK
    	  		tvI.state= INDEXTOSTATEIMAGEMASK(2)
    	  		sendmessage(tviewprc,TVM_SETITEM,0,Cast(LPARAM,@tvi))
        End if
    end if
end sub
'=========================
sub proc_flw(t as byte) 't=1-> followed /  t=2 -> not followed
    dim tvi as TVITEM
    tvI.mask      = TVIF_STATE
    tvI.statemask = TVIS_STATEIMAGEMASK
For j As integer =1 To procnb
    proc(j).st=t
    tvI.hitem= proc(j).tv
    tvI.state= INDEXTOSTATEIMAGEMASK(t)
    sendmessage(tviewprc,TVM_SETITEM,0,Cast(LPARAM,@tvi))
Next
fb_message("Activating or desactivating all procs is dangerous","After doing that change again some procs",MB_ICONWARNING)
if t=1 then
    for i as integer =1 to linenb
        WriteProcessMemory(dbghand,Cast(LPVOID,rline(i).ad),@breakcpu,1,0)
    next
else
    for i as integer =1 to linenb
        writeProcessMemory(dbghand,Cast(LPVOID,rline(i).ad),@rline(i).sv,1,0)
    next 
end if
end sub
'========================
Sub thread_text(th As Integer=-1)'update text of thread(s)
   Dim libel as String
   Dim As Integer thid,p,lo,hi
   If th=-1 Then
   	lo=0:hi=threadnb
   Else
   	lo=th:hi=th
   EndIf
   For i As Integer=lo To hi
		thid=thread(i).id
		p=proc_find(thid,KLAST)
		libel="threadID="+fmt2(str(thid),4)+" : "+proc(procr(p).idx).nm
		If flagverbose Then libel+=" HD: "+str(thread(i).hd)
		If threadhs=thread(i).hd Then libel+=" (next execution)"
		Tree_upditem(thread(i).tv,libel,tviewthd)
   Next
End Sub
Sub thread_change(th As Integer =-1)
 	Dim As Integer t,s
   If th=-1 Then t=thread_select() Else t=th
   s=threadcur' 12/12/2012
	'WriteProcessMemory(dbghand,Cast(LPVOID,rLine(thread(threadcur).sv).ad),@breakcpu,1,0) 'restore CC previous line current thread
	threadcur=t:threadprv=t '13/02/2013
	'WriteProcessMemory(dbghand,Cast(LPVOID,rLine(thread(threadcur).sv).ad),@rLine(thread(threadcur).sv).sv,1,0) 'restore old value for execution selected thread
	threadhs=thread(threadcur).hd
	procsv=rline(thread(threadcur).sv).pr
	thread_text(t)' 12/12/2012
	thread_text(s)
	threadsel=threadcur
	dsp_change(thread(threadcur).sv)
end Sub
sub thread_check(hitem as HTREEITEM) 'manage checkboxes for auto execution or not '16/03/2013
	Dim as HTREEITEM temp,temp2
	Dim tvi as TVITEM
	Dim As Integer th
	tvI.mask = TVIF_STATE
	tvI.statemask  = TVIS_STATEIMAGEMASK

	'search thread parent item
	temp2=hitem 
	Do 
		temp=temp2
		temp2=Cast(HTREEITEM,SendMessage(tviewcur,TVM_GETNEXTITEM,TVGN_PARENT,Cast(LPARAM,temp)))
	Loop While temp2

	If hitem<>temp Then 'not on thread item = on proc item
		tvI.hitem= hitem
		sendmessage(tviewthd,TVM_GETITEM,0,Cast(LPARAM,@tvi))
		'restore not checked (proc)
		tvi.state= INDEXTOSTATEIMAGEMASK(1) 'left(hex(tvi.state),1)="2" = checked = followed thread
      sendmessage(tviewthd,TVM_SETITEM,0,Cast(LPARAM,@tvi))
		'select thread item
		sendmessage(tviewthd,TVM_SELECTITEM,TVGN_CARET,Cast(LPARAM,temp))
		'get thread item state
		tvI.hitem= temp
		sendmessage(tviewthd,TVM_GETITEM,0,Cast(LPARAM,@tvi))
		'inverse
		If left(hex(tvi.state),1)="2" Then
			tvi.state=INDEXTOSTATEIMAGEMASK(1)
		Else
			tvi.state=INDEXTOSTATEIMAGEMASK(2)
		EndIf
		sendmessage(tviewthd,TVM_SETITEM,0,Cast(LPARAM,@tvi))
	EndIf
	th=thread_select()
	thread(th).exc=1-thread(th).exc
end Sub
Sub thread_procloc(t As integer)
Dim as Integer hitem,temp,cpt
Dim tvi as TVITEM,text as zstring *100, pr as Integer, thid As Integer
'get current hitem in tree
temp=sendmessage(tviewthd,TVM_GETNEXTITEM,TVGN_CARET,null)

Do 'search index thread
	hitem=temp
	temp=SendMessage(tviewcur,TVM_GETNEXTITEM,TVGN_PARENT,hitem)
	cpt+=1
Loop While temp
If cpt>1 Then  'thread item and first proc have same index in procr
	cpt-=1
Else
	cpt=1
EndIf

	tvI.mask       = TVIF_TEXT or TVIF_STATE
	tvI.hitem      = Cast(HTREEITEM,hitem)
	tvI.pszText    = @(text)
	tvI.cchTextMax = 99
	sendmessage(tviewthd,TVM_GETITEM,0,Cast(LPARAM,@tvi))
	thid=ValInt(mid(text,10,6))
	
	For pr =1 To procrnb 'finding proc index 13/12/2012
		If procr(pr).thid=thid Then
			cpt-=1
			If cpt=0 Then Exit For
		EndIf
	Next
If t=1 Then 'proc in proc/var
	ShowWindow(tviewcur,SW_HIDE)
	tviewcur=tviewvar
	ShowWindow(tviewcur,SW_SHOW)
	SendMessage(htab2,TCM_SETCURSEL,0,0)

 	SendMessage(tviewvar,TVM_SELECTITEM,TVGN_CARET,Cast(LPARAM,procr(pr).tv))
 	SetFocus(tviewcur)
ElseIf t=2 then'proc in source
	exrichedit(proc(procr(pr).idx).sr)    'display source
	sel_line(proc(procr(pr).idx).nu-1)'Select Line
Else 'info about running proc
	fb_message("Proc : "+proc(procr(pr).idx).nm,"Start address ="+Str(proc(procr(pr).idx).db)+"/&h"+Hex(proc(procr(pr).idx).db)+Chr(10)_
	                                           +"End   address ="+Str(proc(procr(pr).idx).fn)+"/&h"+Hex(proc(procr(pr).idx).fn)+Chr(10)_
	                                           +"Stack address ="+Str(procr(pr).sk)+"/&h"+Hex(procr(pr).sk))
End If
End Sub
Sub thread_expcol(v As Integer) '14/12/2012
	Dim As Integer th,hitem
	If v=TVE_EXPAND Then 'just one thread
		th=thread_select()
		hitem=Cast(Integer,thread(th).tv)
		Do 'items loop
			SendMessage(tviewthd,TVM_EXPAND,v,Cast(LPARAM,hitem))
			hitem=SendMessage(tviewcur,TVM_GETNEXTITEM,TVGN_CHILD,hitem)
		Loop While hitem
	Else 'all thread items
		for j As Integer =0 to threadnb
			SendMessage(tviewthd,TVM_EXPAND,v,Cast(LPARAM,thread(j).tv))
		Next
	EndIf
end Sub
Function proc_find(thid As integer,t As Byte) As integer 'find first/last proc for thread
	If t=KFIRST then
		For i As Integer =1 To procrnb
			If procr(i).thid = thid Then Return i
		Next
	Else
		For i As Integer = procrnb To 1 Step -1
			If procr(i).thid = thid Then Return i
		Next
	End If
End Function
Sub proc_update() 'change for verbose or not
	Dim libel As String
	Dim As Byte flag(THREADMAX)
	For i As integer=1 To procrnb
		If procr(i).idx Then 'if <>0 then not globals for dll 05/02/2013
			If proc_find(procr(i).thid,KFIRST)=i Then
				libel="ThID="+Str(procr(i).thid)+" "
			Else
				libel=""
			EndIf
			libel+=proc(procr(i).idx).nm+":"+proc_retval(procr(i).idx)
			If flagverbose Then libel+=" ["+Str(proc(procr(i).idx).db)+"]"
			Tree_upditem(procr(i).tv,libel,tviewvar)
		EndIf
	Next
End Sub
Sub proc_loc() 'locate proc in sources from selected line in treeview1
	Dim as Integer hitem,temp,t
	'get current hitem in tree
	temp=sendmessage(tviewcur,TVM_GETNEXTITEM,TVGN_CARET,null)

	If tviewcur=tviewvar then
		Do 'search index proc
			hitem=temp
			temp=SendMessage(tviewcur,TVM_GETNEXTITEM,TVGN_PARENT,hitem)
		Loop While temp
		'If hitem=procr(0).tv Then fb_message("Locate proc","Global variables no proc associated !!"):Exit Sub '29/11/2012
		temp=0
		For i As Integer =1 To procrnb
			If procr(i).tv=hitem Then
				temp=procr(i).idx
	         Exit For               
			EndIf
		Next
		If temp=0 Then fb_message("Locate proc","Global variables no proc associated !!"):Exit Sub '27/01/2013
	ElseIf tviewcur=tviewprc then
		hitem=temp
		For i As Integer =1 To procnb
			If proc(i).tv=hitem Then
				temp=i
	         Exit For               
			EndIf
		Next
	ElseIf tviewcur=tviewthd Then
		t=thread_select()
		If t=0 Then 'main, select first line
			temp=procr(1).idx
		Else
			temp=procr(proc_find(thread(t).id,KFIRST)).idx
		EndIf
	EndIf
	exrichedit(proc(temp).sr)    'display source
	sel_line(proc(temp).nu-1)'Select Line
End Sub
Sub proc_loccall()
Dim as Integer hitem,temp
'get current hitem in tree
temp=sendmessage(tviewcur,TVM_GETNEXTITEM,TVGN_CARET,null)

If temp=procr(1).tv Then fb_message("Locate calling line","Main so no call !!"):Exit Sub '29/11/2012


	Do 'search index proc
		hitem=temp
		temp=SendMessage(tviewcur,TVM_GETNEXTITEM,TVGN_PARENT,hitem)
	Loop While temp

	For i As Integer =1 To procrnb
		If procr(i).tv=hitem Then
			If procr(i).cl=-1 Then '29/11/2012
				'fb_message("Locate calling line","First proc of thread so no call !!"):Exit Sub
				thread_execline(2):Exit Sub '13/12/2012
			EndIf
			temp=procr(i).cl 'calling line
			exrichedit(proc(rline(temp).pr).sr) 'display source
         sel_line(rline(temp).nu-1)'Select Line
         Exit Sub '29/11/2012
  		EndIf
	Next
End Sub
Function proc_name(ad As uinteger) As String 'find name proc about address
	For i As Integer =1 To procnb
		If proc(i).db=ad Then Return Str(ad)+" >> "+proc(i).nm
	Next
	Return Str(ad)
End Function
'=============
Function proc_verif(p As UShort) As Byte 'return true if proc running
	For i As ushort =1 To procrnb
		If procr(i).idx = p Then Return true
	Next
	Return false
End Function
'===================================
Function proc_retval(prcnb As Integer) As String
	Dim p As Integer = proc(prcnb).pt
	If p Then
     	If p>220 Then
			Return string(p-220,"*")+" Function"
		elseIf p>200 Then 
			Return string(p-200,"*")+" Sub"
		Else
			Return string(p,"*")+" "+udt(proc(prcnb).rv).nm
     	End If
	End If
	Return udt(proc(prcnb).rv).nm
End Function
sub exe_mod() 'execution from cursor
dim l As Integer,i As Integer,range as charrange,b As Integer
dim vcontext as CONTEXT
range.cpmin=-1 :range.cpmax=0

sendmessage(dbgrichedit,EM_exsetsel,0,Cast(LPARAM,@range)) 'deselect
l=sendmessage(dbgrichedit,EM_EXLINEFROMCHAR,0,-1) 'get line

For i=1 to linenb  'check nline 
	if rline(i).nu=l+1 and proc(rline(i).pr).sr=shwtab Then 
	    if rline(i+1).nu=l+1 and proc(rline(i+1).pr).sr=shwtab Then i+=1 'weird case : first line main proc 
	    Exit For 
	end if 
Next 

if i>linenb then fb_message("Execution on cursor","Inaccessible line (not executable)") :exit Sub 

if curlig=l+1 and shwtab=curtab then 
    If fb_message("Execution on cursor","Same line, continue ?",MB_YESNO OR MB_ICONQUESTION)=IDNO then exit sub 
end if 

'check inside same proc if not msg 
If rLine(i).ad>proc(procsv).fn Or rLine(i).ad<=proc(procsv).db Then 
fb_message("Execution on cursor","Only inside current proc !!!") :exit Sub 
End If 
If rLine(i).ad=proc(procsv).fn then
	thread(threadcur).pe=TRUE        'is last instruction
EndIf
'WriteProcessMemory(dbghand,Cast(LPVOID,rLine(thread(threadcur).sv).ad),@breakcpu,1,0) 'restore CC previous line
'WriteProcessMemory(dbghand,Cast(LPVOID,rLine(i).ad),@rLine(i).sv,1,0) 'restore old value for execution
thread(threadcur).od=thread(threadcur).sv:thread(threadcur).sv=i
'get and update registers
vcontext.contextflags=CONTEXT_CONTROL
GetThreadContext(threadhs,@vcontext)
vcontext.Eip=rline(i).ad
setThreadContext(threadhs,@vcontext)

dsp_change(i)
end Sub
Function line_call(eip As UInteger) As Integer 'find the calling line for proc '29/11/2012
	For i As Integer=1 To linenb
		If eip<=rLine(i).ad Then
			Return i-1
		EndIf
	Next
	Return linenb	
End Function
'====================== new sub ou func ===============
sub proc_newfast()
   dim vcontext as CONTEXT
   dim libel as String
   dim as uinteger ebp,eip,j,k,ebpnb,ebpp(PROCRMAX),pridx(PROCRMAX),calin(PROCRMAX)
   Dim tv As HTREEITEM
   vcontext.contextflags=CONTEXT_CONTROL
   
   'loading with EBP and proc index
   for i as integer =0 to threadnb
   	ebpnb=0
		GetThreadContext(thread(i).hd,@vcontext)
		ebp=vcontext.ebp:eip=vcontext.eip 'current proc
		While 1
			For j =1 to procnb
			   if eip>=proc(j).db and eip<=proc(j).fn Then
			   	ebpnb+=1:ebpp(ebpnb)=ebp:pridx(ebpnb)=j
			   	Exit For
			   EndIf
			Next
			If j>procnb then exit while
			ReadProcessMemory(dbghand,Cast(LPCVOID,ebp+4),@eip,4,0) 'return EIP
			ReadProcessMemory(dbghand,Cast(LPCVOID,ebp),@ebp,4,0)   'previous EBP

			calin(ebpnb)=line_call(eip) ''29/11/2012
		Wend

'old way delete all and recreate all !!!
      'SendMessage(tviewvar,TVM_DELETEITEM,0,TVI_ROOT) 'delete treeview before loading
   	'procrnb=0:vrrnb=0
		'For k as integer = ebpnb To 1 Step -1
		'	If procrnb=PROCRMAX Then fb_message ("CLOSING DEBUGGER","Max number of sub/func reached"):DestroyWindow (windmain):Exit Sub
		'	procrnb+=1 
		'	procr(procrnb).sk=ebpp(k)
		'	procr(procrnb).th=i
		'	procr(procrnb).idx=pridx(k)
		'	libel="Thread "+Str(i)+" ["+Str(proc(pridx(k)).db)+"]"+proc(pridx(k)).nm
		'	Print libel
		'	procr(procrnb).tv= Tree_AddItem(null,libel, 0, tviewvar)
		'	var_ini(procrnb)
		'	procr(procrnb+1).vr=vrrnb+1
		'Next
		
		'delete only if needed
		j=ebpnb:k=0
		While k<procrnb
			k+=1
			If procr(k).thid <> thread(i).id Then Continue While
			If procr(k).idx=pridx(j) Then
				j-=1 'running proc still existing so kept
			Else
				proc_del(k) 'delete procr
				k-=1 'to take in account that a procr has been deleted
			EndIf
		Wend
		'create new procrs
		For k As Integer =j To 1 Step -1
			If procrnb=PROCRMAX Then fb_message ("CLOSING DEBUGGER","Max number of sub/func reached"):DestroyWindow (windmain):Exit Sub
			If proc(pridx(k)).st=2 Then Continue For 'proc state don't follow
			procrnb+=1 
			procr(procrnb).sk=ebpp(k)
			procr(procrnb).thid=thread(i).id
			procr(procrnb).idx=pridx(k)
			
			'test if first proc of thread  '04/12/2012
			If thread(i).plt=0 Then
				thread(i).tv= Tree_AddItem(null,"", 0, tviewthd)'create item '13/12/2012
				thread(i).ptv=thread(i).tv 'last proc 
				thread_text(i)'put text
				thread(i).st=0 'with fast no starting line could be gotten
				procr(procrnb).cl=-1  ' no real calling line 
				libel="ThID="+Str(procr(procrnb).thid)+" "
				tv=TVI_LAST 'insert in last position
			Else
				tv=thread(i).plt 'insert after the last item of thread
				procr(procrnb).cl=calin(k)  '29/11/2012
				libel="" '24/01/2012
			EndIf
			
			'add manage LIST
			If flagtrace Then dbg_prt ("NEW proc "+proc(pridx(k)).nm)
			libel+=proc(pridx(k)).nm+":"+proc_retval(pridx(k))
			If flagverbose Then libel+=" ["+Str(proc(pridx(k)).db)+"]"
			
			procr(procrnb).tv=Tree_AddItem(0,libel,tv,tviewvar)
			thread(i).plt=procr(procrnb).tv 'keep handle last item
			
			thread(i).ptv=Tree_AddItem(thread(i).ptv,proc(pridx(k)).nm,TVI_FIRST,tviewthd)

			var_ini(procrnb,proc(procr(procrnb).idx).vr,proc(procr(procrnb).idx+1).vr-1)
			procr(procrnb+1).vr=vrrnb+1
			proc_watch(procrnb) 'reactivate watched var
		Next
		RedrawWindow tviewthd, 0, 0, 1
		RedrawWindow tviewvar, 0, 0, 1
   Next
End Sub
'===============
sub fastrun() 'running until cursor or breakpoint !!! Be carefull
dim l As Integer,i As Integer,range as charrange,b As Integer
range.cpmin=-1 :range.cpmax=0

sendmessage(dbgrichedit,EM_exsetsel,0,Cast(LPARAM,@range)) 'deselect          utilite ????
l=sendmessage(dbgrichedit,EM_EXLINEFROMCHAR,0,-1) 'get line
for i=1 to linenb
	if rline(i).nu=l+1 And proc(rline(i).pr).sr=shwtab Then Exit For 'check nline 
Next
if i>linenb then fb_message("Fast run Not possible","Inaccessible line (not executable)") :exit Sub
For j As Integer =1 To procnb 'first line of proc
	If rline(i).ad=proc(j).db Then fb_message("Fast run Not possible","Inaccessible line (not executable)") :exit Sub
Next
if curlig=l+1 and shwtab=curtab Then fb_message("Fast run Not possible","Same line"): exit sub
For j As Integer = 1 To linenb 'restore all instructions
  WriteProcessMemory(dbghand,Cast(LPVOID,rline(j).ad),@rLine(j).sv,1,0)
Next
'create run to cursor
brkol(0).ad=rline(i).ad
brkol(0).typ=2 'to clear when reached
For j As Integer = 0 To brknb 'breakpoint
	If brkol(j).typ<3 Then WriteProcessMemory(dbghand,Cast(LPVOID,brkol(j).ad),@breakcpu,1,0) 'only enabled 27/02/2013
Next
runtype=RTFRUN
but_enable()
fasttimer=timer
thread_rsm()
end sub

Function fb_Set_Font (Font As string,Size As integer,Bold As Integer,Italic As Integer,Underline As Integer,StrikeThru As Integer) As HFONT
  Dim As HDC hDC=GetDC(HWND_DESKTOP)
  Dim As Integer CyPixels=GetDeviceCaps(hDC,LOGPIXELSY)
  ReleaseDC(HWND_DESKTOP,hDC) 'RUSSIAN_CHARSET 
  return CreateFont(0-(Size*CyPixels)/72,0,0,0,Bold,Italic,Underline,StrikeThru,0 _
  ,OUT_TT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,FF_DONTCARE,Font)
End Function
Function fb_FontDlg (hwnd As HWND) As Integer

 Dim As CHOOSEFONT cf
 Dim As LOGFONT lf
 Dim As Integer rc
 Clear(@cf,0,sizeof(cf))
 Clear(@lf,0,sizeof(lf))

 GetObject(fonthdl,sizeof(lf),@lf)
 cf.lStructSize=sizeof(CHOOSEFONT)
 cf.lpLogFont=@lf
 cf.Flags=CF_INITTOLOGFONTSTRUCT Or CF_SCREENFONTS Or CF_NOSCRIPTSEL 'Or CF_EFFECTS 
 cf.hwndOwner=hwnd
 rc=ChooseFont(@cf)
 If rc Then
   fontname=lf.lfFaceName
   fontsize=cf.iPointSize/10
   'lf.lfItalic lf.lfWeight lf.lfUnderline lf.lfStrikeOut cf.rgbColors
 End If
 return rc
end Function
'selection index 6 maxi
function index_box(byval hWnd as HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) AS Integer
  static Txt as zstring *301,tvi as TVITEM
  dim rc as RECT => (0, 0, 4, 8)
  dim as integer scalex,scaley,delta,temp1,temp2,temp3
  static as HWND updown(4),hubound(4),hlbound(4),hbutdel,hbutapl,hbutp,hbutn
  Static As Integer vubound(4),vlbound(4),i
  Static As Integer nbdim,size,flagvar
  Dim As uinteger adr
SELECT CASE Msg
	CASE WM_INITDIALOG
    	MapDialogRect (hwnd,@rc)
    	ScaleX = rc.right/4
    	ScaleY = rc.bottom/8
    	fb_modstyle(hwnd,0,WS_EX_NOPARENTNOTIFY,1)
   	erase updown
		i=var_find() 'search index variable under cursor
   	if i=0 then enddialog(hwnd,0):exit Function
	If i>0 Then 'type var
		flagvar=TRUE
    	If vrb(vrr(i).vr).arr=-1 Then 'dynamic array"
         ReadProcessMemory(dbghand,Cast(LPCVOID,vrr(i).ini),@adr,4,0)
         If adr Then
				adr=vrr(i).ini+16 'nb dim
				readProcessMemory(dbghand,Cast(LPCVOID,adr),@nbdim,4,0)
				For k As Integer =0 To nbdim-1
					adr+=8
					ReadProcessMemory(dbghand,Cast(LPCVOID,adr),@vlbound(k),4,0)
					adr+=4
					readProcessMemory(dbghand,Cast(LPCVOID,adr),@vubound(k),4,0)
				Next
         Else
            fb_message("Dynamic array not yet defined","Try later"):EndDialog(hwnd,0):exit function
         End if
    	ElseIf vrb(vrr(i).vr).arr Then
    		nbdim=vrb(vrr(i).vr).arr->dm
			For k As Integer =0 To nbdim-1
				vlbound(k)=vrb(vrr(i).vr).arr->nlu(k).lb
				vubound(k)=vrb(vrr(i).vr).arr->nlu(k).ub
			Next
    	Else
			fb_message("Index selection","Not an array, Select an other variable"):EndDialog(hwnd,0):exit Function
    	End if
      size=udt(vrb(vrr(i).vr).typ).lg 
	Else 'type cudt
		flagvar=false:i=Abs(i)
      With cudt(abs(vrr(i).vr))
         If .arr Then
            nbdim=.arr->dm:size=udt(.typ).lg
            For k As Integer =0 To nbdim-1
            	vlbound(k)=.arr->nlu(k).lb
            	vubound(k)=.arr->nlu(k).ub
            Next
         Else
          	fb_message("Index selection","Not an array, Select an other variable"):enddialog(hwnd,0):exit Function
         End if
      end With
	EndIf 
	For k As Integer =0 To nbdim-1
		hlbound(k)=fb_Label(Str(vlbound(k)),hwnd,300,2*scalex,(20+k*15)*scaley,50*scalex,12*scaley)
   	hubound(k)=fb_Label(Str(vubound(k)),hwnd,300,60*scalex,(20+k*15)*scaley,50*scalex,12*scaley)
   	updown(k)=fb_updown(hwnd,120*scalex,(20+k*15)*scaley,75*scalex,12*scaley,vlbound(k),vubound(k),vrr(i).ix(k))
	Next
	tvI.mask       = TVIF_TEXT
   tvI.pszText    = @(txt)
   tvI.hitem      = vrr(i).tv
   tvI.cchTextMax = 300
   SendMessage(tviewvar,TVM_GETITEM,0,Cast(LPARAM,@tvi))
   fb_Label (txt,hWnd,101,2*scalex,5*scaley,200*scalex,10*scaley)
        
	hbutp=fb_BUTTON("--",hWnd,1,30*scalex, 100*scaley, 18*scalex, 10*scaley)
	hbutn=fb_BUTTON("+",hWnd,1,50*scalex, 100*scaley, 18*scalex, 10*scaley)
	hButapl = fb_BUTTON("Apply",hWnd,1,110*scalex, 100*scaley, 36*scalex, 10*scaley)
	fb_ModStyle(hbutapl,0,WS_EX_NOPARENTNOTIFY,1)
	hButdel=fb_BUTTON("Cancel",hWnd,2, 150*scalex, 100*scaley, 36*scalex, 10*scaley)
	fb_ModStyle(hbutdel,0,WS_EX_NOPARENTNOTIFY,1)

	hindexbx=hwnd
CASE WM_COMMAND
  select case lparam
  	case hButapl    'clicked apply
        if hiword(wparam)=BN_CLICKED Then
        	For k As Integer =0 To 4' 5 maxi
        		If updown(k) Then
        			'getwindowtext(sendmessage(updown(k),UDM_GETBUDDY,0,0),txt,299)
        			'vrr(i).ix(k)=ValInt(txt)
        			vrr(i).ix(k)=SendMessage(updown(k),UDM_GETPOS32,0,0)
        		EndIf
        	Next
        	       	
        	delta=vrr(i).ix(0)-vlbound(0)
        	for k as integer = 1 to nbdim-1
        		delta+=delta*(vubound(k)-vlbound(k)+1)+vrr(i).ix(k)-vlbound(k)
        	Next

        	if flagvar Then 'variable
        		If vrb(vrr(i).vr).arr<>-1 Then 'not dyn array (do later in var_sh)
	        		adr=vrr(i).ad 'store previous value
	            vrr(i).ad=vrr(i).ini+delta*size
	            If vrb(vrr(i).vr).typ>15 then
	               'update new adress of udt components
	               temp1=sendmessage(tviewvar,TVM_GETNEXTITEM,TVGN_NEXT,Cast(LPARAM,vrr(i).tv))
	               temp2=i+1:temp3=vrr(i).ad-adr
	               While temp2<=vrrnb and vrr(temp2).tv<>temp1
	                  vrr(temp2).ad+=temp3
	                  vrr(temp2).ini+=temp3 'just for arr
	                  temp2+=1
	               Wend
	            end If
	         End if
        	Else 'component
        		temp2=delta*size+vrr(i).ini:temp3=temp2-vrr(i).ad
     			vrr(i).ad=temp2
        		If cudt(Abs(vrr(i).vr)).typ>15 Then
        		   'update new adress of udt components
               temp1=sendmessage(tviewvar,TVM_GETNEXTITEM,TVGN_NEXT,Cast(LPARAM,vrr(i).tv))
               If temp1=0 Then
               	temp2=sendmessage(tviewvar,TVM_GETNEXTITEM,TVGN_PARENT,Cast(LPARAM,vrr(i).tv))
               	temp1=sendmessage(tviewvar,TVM_GETNEXTITEM,TVGN_NEXT,temp2)
               EndIf
               temp2=i+1
               While temp2<=vrrnb and vrr(temp2).tv<>temp1
                  vrr(temp2).ad+=temp3
                  vrr(temp2).ini+=temp3 'just for arr
                  temp2+=1
               Wend
        		EndIf
        	End If
			var_sh
			hindexbx=0
			EndDialog(hwnd,0)
        end if
    case hButdel     'clicked delete
        if hiword(wparam)=BN_CLICKED Then
        		hindexbx=0
            EndDialog(hwnd,0)
        end If
  	Case hbutn 'next element
  		For k As Integer = nbdim-1 To 0 Step -1
  			If vubound(k)<>vrr(i).ix(k) Then
  				SendMessage(updown(k),UDM_SETPOS32,0,vrr(i).ix(k)+1) 'increase
  				For j As Integer = k+1 To nbdim-1
  					SendMessage(updown(j),UDM_SETPOS32,0,vlbound(j)) 'init lower
  				Next
  				postMessage(hindexbx,WM_COMMAND,BN_CLICKED,Cast(LPARAM,hbutapl))'simulate click on aplly
  				Exit select
  			EndIf
  		Next
  		For k As Integer = 0 to nbdim 'loop so all index at the beginning
  			SendMessage(updown(k),UDM_SETPOS32,0,vlbound(k)) 
  			postMessage(hindexbx,WM_COMMAND,BN_CLICKED,Cast(LPARAM,hbutapl))'simulate click on aplly
  		Next
  	Case hbutp 'previous element
  		For k As Integer = nbdim-1 To 0 Step -1
  			If vlbound(k)<>vrr(i).ix(k) Then
  				SendMessage(updown(k),UDM_SETPOS32,0,vrr(i).ix(k)-1) 'increase
  				For j As Integer = k+1 To nbdim-1
  					SendMessage(updown(j),UDM_SETPOS32,0,vubound(j)) 'init upper
  				Next
  				postMessage(hindexbx,WM_COMMAND,BN_CLICKED,Cast(LPARAM,hbutapl))'simulate click on aplly
  				Exit select
  			EndIf
  		Next
  		For k As Integer = 0 to nbdim 'loop so all index at the beginning
  			SendMessage(updown(k),UDM_SETPOS32,0,vubound(k)) 
  			postMessage(hindexbx,WM_COMMAND,BN_CLICKED,Cast(LPARAM,hbutapl))'simulate click on aplly
  		Next
  END select
case WM_NOTIFY
	   Dim lpud as NM_UPDOWN ptr=Cast(NM_UPDOWN Ptr,lparam)
	   If lpud->hdr.code=&hFFFFFD2E  then 'UDN_DELTAPOS
	      ''print lpud->hdr.hwndFrom;lpud->ipos;lpud->idelta
	   End if
	case WM_CLOSE
		hindexbx=0
    	enddialog(hwnd,0)
END Select
Return 0 'not really used just for avoid warning or change with sub
END function
'====================
'
'dim coefL as double
'dim coefH as double
'dim shared MyhBmp as HBITMAP
'MyhBmp = fb_LOADBMP(COMMAND$)
'
'H0 = fb_BMPHEIGHT(MyhBmp)
'L0 = fb_BMPWIDTH(MyhBmp)
'
'fb_message ("",str$(L0)+" "+str$(H0))
'
'coefL=cdbl(L0)/640.0
'coefH=cdbl(H0)/480.0
'if coefH>coefL then
'    'fb_message("","H"+str$(coefH))
'    H=480
'    L=L0/coefH
'else
'    'fb_message("","L"+str$(coefL))
'    L=640
'    H=H0/coefL
'end if
''fb_message("",str$(L)+" "+str$(H))
'    dim rec as RECT,s as uinteger
'    rec.nleft=0
'    rec.ntop=0
'    rec.nright=l
'    rec.nbottom=h
'    s=WS_MINIMIZEBOX  or _
'        WS_SIZEBOX      or _
'        WS_CAPTION      or _
'        WS_MAXIMIZEBOX  or _
'        WS_POPUP        or _
'        WS_SYSMENU
'    if AdjustWindowRectEx(rec,s,0,256)=0 then
'       fb_message("ERROR","ADJUSTwindow")
'    end if
'   ' fb_message("Window",str$(rec.nleft)+" "+str$(rec.ntop)+" "+str$(rec.nright)+" "+str$(rec.nbottom)+" "+str$(s))
'   Form1   = fb_FORM     ("BMP Demo" ,0,0,rec.nright-rec.nleft,rec.nbottom-rec.ntop)


'  CASE WM_PAINT
''========================================================================
'static  ps       AS   PAINTSTRUCT
'static  hdc      AS   long
'static  hdcMem   AS   long
'  hdc = BeginPaint (hWnd, ps)
'  hdcMem = CreateCompatibleDC (hdc)
''-----------------------------------
'  SelectObject (hdcMem, MyhBmp)
' 
'
' StretchBlt (hdc,1,1,L,H,hdcMem,0,0,L0,H0,SRCCOPY)
' bitblt(hdc,1,1,L,H,hdcMem,0,0,SRCCOPY)
''-----------------------------------
'  DeleteDC (hdcMem)
'  EndPaint (hWnd, ps)
'========================================================================
' hBmp as HBITMAP
function fb_BmpWidth (hBmp As HBITMAP) As Integer
   dim bm as BITMAP
   if(hBmp) then
        GetObject(hBmp,len(bm),@bm)
        fb_BmpWidth=bm.bmWidth
   else
        fb_BmpWidth=0
   end if
end function
'===================================================================
function fb_BmpHeight (hBmp As HBITMAP) As Integer
   dim bm as BITMAP
   if(hBmp) then
      GetObject(hBmp,len(bm),@bm)
      fb_BmpHeight=bm.bmHeight
    else
      fb_BmpHeight=0
end if
end function
'===================================================================
function fb_LoadBMP (F As string,i As Integer) As HBITMAP '--> HBITMAP
   if i then
  ' (HBITMAP)LoadImage(GetModuleHandle(0), MAKEINTRESOURCE(i),IMAGE_BITMAP,0,0,0)
   else
      fb_LoadBMP=LoadImage(GetModuleHandle(0),F,IMAGE_BITMAP,0,0,LR_LOADFROMFILE)
   end if
end Function
'=========
Sub dsp_size() 'if 0 then normal display
	
Dim rec as rect,tempo As Integer
if dsptyp>99 Then exit sub 'mini window do nothing

getclientrect(windmain,@rec)

If rec.right=0 And rec.bottom=0 Then Exit Sub
'If rec.right<792 Then MoveWindow(windmain,0,0,800,590,TRUE)	

'buttons 26 -->28
'current line
MoveWindow (hcurline,0,28,rec.right,18,TRUE)

Select Case dsptyp
	Case 0
		'tab1
		MoveWindow (htab1,0,46,rec.right*3/5,20,TRUE)
		'tab2
		MoveWindow (htab2,rec.right*3/5,46,rec.right*2/5,20,TRUE)
		
		tempo=rec.bottom-196 'rec.bottom-28-18-20-18-36-18-40
		'sources ALL!!! 
		For i As Integer=0 To MAXSRC:MoveWindow (richedit(i),0,66,rec.right*3/5,tempo,FALSE):Next		
		
		'variables/proc/thread/watch
		MoveWindow (tviewvar,rec.right*3/5,66,rec.right*2/5,tempo,TRUE)
		MoveWindow (tviewprc,rec.right*3/5,66,rec.right*2/5,tempo,TRUE)
		MoveWindow (tviewthd,rec.right*3/5,66,rec.right*2/5,tempo,TRUE)
		MoveWindow (tviewwch,rec.right*3/5,66,rec.right*2/5,tempo,TRUE)
		tempo+=66
		'bookmark1 
		MoveWindow (bmkh,0,tempo,rec.right,18,false)

		tempo+=18
		'watch1 watch2
		MoveWindow (wtch(0).hnd,0,tempo,rec.right/2,18,false)
		MoveWindow (wtch(1).hnd,rec.right/2,tempo,rec.right/2,18,false)
		
		tempo+=18
		'watch3 watch4
		MoveWindow (wtch(2).hnd,0,tempo,rec.right/2,18,false)
		MoveWindow (wtch(3).hnd,rec.right/2,tempo,rec.right/2,18,false)
		
		tempo+=18
		'break
		MoveWindow (brkvhnd,0,tempo,rec.right,18,false)
		
		tempo+=18
		'Memory
		MoveWindow (listview1,0,tempo,rec.right,40,false)
		dumplig=1
		

	Case 1 'full Source
		'tab1
		MoveWindow (htab1,0,46,rec.right,20,TRUE)
		'sources
		tempo=rec.bottom-84 '28-18-20-18
		For i As Integer=0 To MAXSRC:MoveWindow (richedit(i),0,66,rec.right,tempo,FALSE):Next
	case 2 'full var
		'tab2
		MoveWindow (htab2,0,46,rec.right,20,TRUE)
		'variables/proc/thread
		tempo=rec.bottom-84
		MoveWindow (tviewvar,0,66,rec.right,tempo,TRUE)
		MoveWindow (tviewprc,0,66,rec.right,tempo,TRUE)
		MoveWindow (tviewthd,0,66,rec.right,tempo,TRUE)
		MoveWindow (tviewwch,0,66,rec.right,tempo,TRUE)
	Case 3 'notes
		'tab1
		MoveWindow (htab1,0,46,rec.right*3/5,20,TRUE)
		'tab2
		MoveWindow (htab2,rec.right*3/5,46,rec.right*2/5,20,TRUE)
		
		tempo=rec.bottom-196 'rec.bottom-28-18-20-18-36-18-40
		'sources ALL!!! 
		For i As Integer=0 To sourcenb:MoveWindow (richedit(i),0,66,rec.right*3/5,tempo,FALSE):Next		
		
		'variables/proc/thread
		MoveWindow (tviewvar,rec.right*3/5,66,rec.right*2/5,tempo,TRUE)
		MoveWindow (tviewprc,rec.right*3/5,66,rec.right*2/5,tempo,TRUE)
		MoveWindow (tviewthd,rec.right*3/5,66,rec.right*2/5,tempo,TRUE)
		MoveWindow (tviewwch,rec.right*3/5,66,rec.right*2/5,tempo,TRUE)
		'notes
		tempo+=66
		MoveWindow (dbgEdit1,0,tempo,rec.right,112,false)
	Case 4
		'Memory
		tempo=rec.bottom-66
		MoveWindow (listview1,0,46,rec.right,tempo,false)
		dumplig=(tempo-23)\14
		dump_sh
End Select
SendMessage(dbgstatus,WM_SIZE,0,0)
End Sub
Function excep_lib(e As integer) As String 'exception non traitée
	Select Case e
		Case EXCEPTION_GUARD_PAGE_VIOLATION
			Return "EXCEPTION_GUARD_PAGE_VIOLATION"  '&H80000001
		Case EXCEPTION_DATATYPE_MISALIGNMENT
			Return "EXCEPTION_DATATYPE_MISALIGNMENT" '&H80000002
		Case EXCEPTION_SINGLE_STEP
			Return "EXCEPTION_SINGLE_STEP" '&H80000004
		Case EXCEPTION_IN_PAGE_ERROR
			return "EXCEPTION_IN_PAGE_ERROR" '&HC0000006
		Case EXCEPTION_INVALID_HANDLE
			return "EXCEPTION_INVALID_HANDLE" '&HC0000008
		Case EXCEPTION_NO_MEMORY
			return "EXCEPTION_NO_MEMORY" '&HC0000017
		Case EXCEPTION_ILLEGAL_INSTRUCTION
			return "EXCEPTION_ILLEGAL_INSTRUCTION" '&HC000001D
		Case EXCEPTION_NONCONTINUABLE_EXCEPTION
			return "EXCEPTION_NONCONTINUABLE_EXCEPTION" '&HC0000025
		Case EXCEPTION_INVALID_DISPOSITION
			return "EXCEPTION_INVALID_DISPOSITION" '&HC0000026
		Case EXCEPTION_ARRAY_BOUNDS_EXCEEDED
			return "EXCEPTION_ARRAY_BOUNDS_EXCEEDED" '&HC000008C
		Case EXCEPTION_FLOAT_DENORMAL_OPERAND
			return "EXCEPTION_FLOAT_DENORMAL_OPERAND" '&HC000008D
		Case EXCEPTION_FLOAT_DIVIDE_BY_ZERO
			return "EXCEPTION_FLOAT_DIVIDE_BY_ZERO" '&HC000008E
		Case EXCEPTION_FLOAT_INEXACT_RESULT
			return "EXCEPTION_FLOAT_INEXACT_RESULT" '&HC000008F
		Case EXCEPTION_FLOAT_INVALID_OPERATION
			return "EXCEPTION_FLOAT_INVALID_OPERATION" '&HC0000090
		Case EXCEPTION_FLOAT_OVERFLOW
			return "EXCEPTION_FLOAT_OVERFLOW" '&HC0000091
		Case EXCEPTION_FLOAT_STACK_CHECK
			return "EXCEPTION_FLOAT_STACK_CHECK" '&HC0000092
		Case EXCEPTION_FLOAT_UNDERFLOW
			return "EXCEPTION_FLOAT_UNDERFLOW" '&HC0000093
		Case EXCEPTION_INTEGER_DIVIDE_BY_ZERO
			return "EXCEPTION_INTEGER_DIVIDE_BY_ZERO" '&HC0000094
		Case EXCEPTION_INTEGER_OVERFLOW
			return "EXCEPTION_INTEGER_OVERFLOW" '&HC0000095
		Case EXCEPTION_PRIVILEGED_INSTRUCTION
			return "EXCEPTION_PRIVILEGED_INSTRUCTION" '&HC0000096
		Case EXCEPTION_STACK_OVERFLOW
			return "EXCEPTION_STACK_OVERFLOW" '&HC00000FD
		Case EXCEPTION_CONTROL_C_EXIT
			return "EXCEPTION_CONTROL_C_EXIT" '&HC000013A
		Case DBG_CONTROL_C
			Return "DBG_CONTROL_C" '&h40010005
		Case DBG_TERMINATE_PROCESS
			Return "DBG_TERMINATE_PROCESS" '&h40010004
		Case DBG_TERMINATE_THREAD
			Return "DBG_TERMINATE_THREAD"  '&h40010003
		Case DBG_CONTROL_BREAK
			return "DBG_CONTROL_BREAK"  '&h40010008
		Case Else
			Return Str(e)+" "+Hex(e)
	End Select
End Function
Sub dbg_attach(p As Any ptr)
dim as zstring *150 zsrtg=space(149) 
re_ini 
dbghand=openprocess(PROCESS_ALL_ACCESS,false,dbgprocid) 
If dbghand=0 Then fb_message("Attach error open","error : "+ Str(GetLastError)):Exit Sub 
If debugactiveprocess(dbgprocid)=0 Then fb_message("Attachment error","error : "+ Str(GetLastError)):Exit Sub 
prun=true 
#Ifdef fulldbg_prt
	dbg_prt ("hand "+Str(dbghand)+" Pid "+Str(dbgprocid))
#EndIf 
runtype=RTSTEP 
flagattach=TRUE 
but_enable() 
menu_enable() 
getmodulefilenameex(dbghand,0,@zsrtg,len(zsrtg))'executable name 
exename=zsrtg 
'no needed --> exedate=FileDateTime (exename) 'exec date for test with sources date 
exe_sav(exename,"")
wait_debug 
End Sub 
Sub jit_write(regstr as string,auto as string) 
Dim as integer result 
Dim reg as string="HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\AeDebug" 'for 64bits OS 
Dim as HKEY hkey 

result=regopenkeyex(HKEY_LOCAL_MACHINE,str(reg),0,KEY_ALL_ACCESS,@hkey) 
If result<>ERROR_SUCCESS Then 
reg="SOFTWARE\Microsoft\Windows NT\CurrentVersion\AeDebug" 'for 32 bits OS 
result=regopenkeyex(HKEY_LOCAL_MACHINE,str(reg),0,KEY_ALL_ACCESS,@hkey) 
If result<>ERROR_SUCCESS Then Exit Sub 
End If 
result=regsetvalueex(hkey,strptr("Debugger"),0,REG_SZ,strptr(regstr),len(regstr)+1) 
result=regsetvalueex(hkey,strptr("Auto"),0,REG_SZ,strptr(auto),len(regstr)+1) 
'if result<>ERROR_SUCCESS then print "ERROR SET ";result 
result=regclosekey(hkey) 
'if result<>ERROR_SUCCESS then print "ERROR CLOSE ";result 
End Sub 
'======= 
function jit_read() as String 
Dim regstr as string="HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\AeDebug" 'for 64bits OS 
Dim as integer result,lgt,typ 
dim as zstring *150 zsrtg=space(149) 
dim as HKEY hkey 

result=regopenkeyex(HKEY_LOCAL_MACHINE,str(regstr),0,KEY_ALL_ACCESS,@hkey) 
If result<>ERROR_SUCCESS Then 
regstr="SOFTWARE\Microsoft\Windows NT\CurrentVersion\AeDebug" 
result=regopenkeyex(HKEY_LOCAL_MACHINE,str(regstr),0,KEY_ALL_ACCESS,@hkey) 
If result<>ERROR_SUCCESS Then Exit Function 
EndIf 
lgt=len(zsrtg) 
result=RegQueryValueEx(hkey,strptr("Debugger"),0,@typ,@zsrtg,@lgt) 
result=regclosekey(hkey) 
'if result<>ERROR_SUCCESS then print "ERROR CLOSE ";result 
regstr=zsrtg 
return regstr 
end function 
'======= 
function jit_box(byval hWnd As HWND,byval Msg AS UINTeger,byval wparam as integer,byval lParam AS integer) as integer 
    dim rc as RECT => (0, 0, 4, 8) 
    dim As Integer scalex ,scaley 
    dim  as string txtcur,txt 
    dim As HWND hbut1,hbut2,hbut3 
    SELECT CASE Msg 
    CASE WM_INITDIALOG    'All of your controls are created here in the same 
        MapDialogRect (hwnd,@rc) 
        ScaleX = rc.right/4 
        ScaleY = rc.bottom/8 
        fb_modstyle(hwnd,0,WS_EX_NOPARENTNOTIFY,1) 

        txtcur=lcase(jit_read) 'current 
        fb_label("Current : "+txtcur,hwnd,100,2*scalex,2*scaley,320*scalex,10*scaley,SS_LEFT) 
         
        if txtcur<>"drwtsn32 -p %ld -e %ld -g" then 
            txt="Restore default JITdebugger Dr Watson : DRWTSN32 -p %ld -e %ld -g" 
            hbut1=fb_BUTTON(txt,hWnd,101,2*scalex, 15*scaley, 320*scalex, 10*scaley) 
        end if 
         
        if jitprev<>"drwtsn32 -p %ld -e %ld -g" andalso jitprev<>"" then 
            txt="Restore previous JITdebugger : "+jitprev 
            hbut2=fb_BUTTON(txt,hWnd,102,2*scalex, 28*scaley, 320*scalex, 10*scaley) 
        EndIf 
         
        if txtcur<>lcase(exepath)+"\fbdebugger"+" -p %ld -e %ld -g" then 
            txt="Replace by : "+lcase(exepath)+"\fbdebugger.exe -p %ld -e %ld -g" 
            hbut3=fb_BUTTON(txt,hWnd,103,2*scalex, 41*scaley, 320*scalex, 10*scaley) 
        end If 
    CASE WM_COMMAND 
        select case loword(wparam) 
            case 101   'restore Drwatson 
                jit_write("DRWTSN32 -p %ld -e %ld -g","1") 
                enddialog(hwnd,0) 
            case 102     'restore previous 
                jit_write(jitprev,"1") 
                enddialog(hwnd,0) 
            case 103     'replace by fbdebugger 
                jitprev=lcase(jit_read) 'get again as no static used for txtcur 
                jit_write(lcase(exepath)+"\fbdebugger"+" -p %ld -e %ld -g","1") 
                enddialog(hwnd,0) 
        end select 
    case WM_CLOSE 
            enddialog(hwnd,0) 
            Return 0 
    end select 
end Function 
Sub dsp_access(shwtab as integer) 
	SendMessage(richedit(shwtab),EM_HIDESELECTION,1,0) 'no move
	For i as integer =1 to linenb  
   	If proc(rline(i).pr).sr=shwtab then 'current tab 
      	If proc(rline(i).pr).db<>rline(i).ad then 'first line of proc not executable 
         	sel_line(rline(i).nu-1,&hA000,3,richedit(shwtab),FALSE)'green color 
      	End if 
   	End if 
	Next 
	SendMessage(richedit(shwtab),EM_HIDESELECTION,0,0)
	fb_message("Executable lines (current tab)","All these lines are temporarily colored in green"+chr(13)+"Caution : POTENTIALLY executable but not necessarily reachable") 
	sel_line(curlig-1) 
end Sub
                
sub dsp_noaccess() 'no accessible lines
   Dim d As Integer,f As Integer,range as charrange
   Dim as HWND h=richedit(shwtab)
   Dim as integer acc(30000)

   For j as integer=1 to linenb 'flag accessible lines
      If proc(rline(j).pr).sr=shwtab then 
        	
        	For i As Integer =1 To procnb 'beginning of proc
				If rline(j).ad=proc(i).db Then Continue For,For
        	Next
        	
        	If rline(j).nu<=30000 Then 'check out of ubound
        		acc(rline(j).nu)=1
        	endif
      EndIf
   Next
    
   setfocus(tviewvar) 'done to avoid the move at every selection
   SendMessage(h,EM_HIDESELECTION,1,0) 'no move
   For j as integer =0 to sendmessage(h,EM_GETLINECOUNT,0,0)-1
      if acc(j+1)=0 then
         range.cpmin=SendMessage ( h , EM_LINEINDEX,j, 0):range.cpmax=SendMessage ( h , EM_LINEINDEX,j+1, 0)-1
         SendMessage ( h , EM_exSETSEL,0,Cast(LPARAM,@range))
         fb_setcolor(h,2,&hA000,3)
      endif    
   Next
   SendMessage(h,EM_HIDESELECTION,0,0)
   setfocus(h) 'restore focus
   sel_line(curlig-1) 
end Sub
Sub help_manage(index As Integer=0) '05/06/2013
'index =0 show first page of help / -1 --> unload / otherwise shows page by index
static As Any Ptr library
Static HtmlHelpA As Function (hwndCaller As HWND,pszFile As LPCSTR,uCommand As UINT,dwData As DWORD_PTR) As HWND

If index=-1 Then 
	If library Then DylibFree(library):library=0
	Exit Sub
EndIf

If library=0 Then
	library= DyLibLoad( "hhctrl.ocx" )
	if library=0  Then fb_message("Starting help","Hhctrl.ocx not found"):Exit sub
	HtmlHelpA = DyLibSymbol( library, "HtmlHelpA" )
	If HtmlHelpA=0  Then fb_message("Starting help","HtmlHelpA, address not found"):help_manage(-1):Exit Sub
	If Dir (ExePath+"\fbdebugger_help.chm")=""  Then fb_message("Starting help",ExePath+"\fbdebugger_help.chm"+" not found"):help_manage(-1):Exit Sub
EndIf

'''Open the help and show the topic
htmlhelpA(0,ExePath+"\fbdebugger_help.chm",HH_DISPLAY_TOPIC,NULL) '::/tools.html or ::/tools.html#dellog

'HtmlHelpA(0,ExePath+"\fbdebugger_help.chm"+"::/execbuttons.html",HH_DISPLAY_TOPIC,NULL) 
'
'''two other pages other opened by their index number
'HtmlHelpA(GetDesktopWindow(),"C:\HTML Help Workshop\testfb.chm",HH_HELP_CONTEXT,65536)
'
'HtmlHelpA(GetDesktopWindow(),"C:\HTML Help Workshop\testfb.chm",HH_HELP_CONTEXT,1000)
End Sub
Sub help_start  'NO MORE USED 05/06/2013
   Dim  As Integer pclass
   Dim  as string cmdl
   Dim sinfo As STARTUPINFO
   dim pinfo As PROCESS_INFORMATION
   'cmdl=""""+exename+""" "+cmdexe(0)
 	cmdl=""""+Environ("windir")+"\hh.exe"+""" """+ExePath+"\fbdebugger_help.chm"+""""
    sinfo.cb = Len(sinfo)
'Set the flags
    sinfo.dwFlags = STARTF_USESHOWWINDOW
'Set the window's startup position
    sinfo.wShowWindow = SW_NORMAL
'Set the priority class
    pclass = NORMAL_PRIORITY_CLASS
'Start the program
    If CreateProcess(Environ("windir")+"\hh.exe",strptr(cmdl),byval null,byval null, False, pclass, _
    null, NULL, @sinfo, @pinfo)=0 Then
        fb_message("PROBLEM","Help file launcher (hh.exe) not found",MB_ICONERROR or MB_SYSTEMMODAL)
    End If
End Sub
Function color_change(rgbcur As Integer) As Integer 'in case of no choice return initail value
Dim as CHOOSECOLOR colch
dim as COLORREF acrCustClr(16)
clear @colch,,sizeof(CHOOSECOLOR)
colch.lStructSize=sizeof(CHOOSECOLOR)
colch.rgbresult=rgbcur'bgr(RGBA_R(rgbcur),RGBA_G(rgbcur),RGBA_B(rgbcur))
colch.Flags = CC_FULLOPEN or CC_RGBINIT
colch.hwndOwner=windmain
colch.lpCustColors = @acrCustClr(0)
if choosecolor(@colch) Then 'color choosen, inverse of FBC
    Return colch.rgbresult'RGB(RGBA_B(colch.rgbresult),RGBA_G(colch.rgbresult),RGBA_R(colch.rgbresult))
Else
	Return rgbcur
EndIf
End Function
Sub decode_help(dData As  HELPINFO Ptr)
'} HELPINFO, *LPHELPINFO;
'dbg_prt2(Str(ddata->iContextType))
'dbg_prt2(Str(ddata->iCtrlId))
'dbg_prt2(Str(ddata->hItemHandle))
'dbg_prt2(Str(ddata->dwContextId))
'dbg_prt2(Str(ddata->MousePos.x)+" "+Str(ddata->MousePos.y))
'dbg_prt2("")
 surround(ddata->hItemHandle) 'If ddata->iCtrlId<>0 Then
 If ddata->iCtrlId=IDBUTSTEP Then fb_message("On screen help","This button execute the current (underlined or highlighted) line")
 redrawwindow(ddata->hItemHandle,0,0, RDW_INVALIDATE)
End Sub
Sub surround(hdl As HWND,x As Integer=-1,y As Integer=0,w As Integer=0,h As Integer=0)  'surround in red any window or specific area 02/01/2013
	Dim As Point myrect(4)
	Dim As RECT prect  
 	If x=-1 Then 
		GetClientRect(hdl,@pRect)
	 	myrect(0).x=pRect.left+1        	 :myrect(0).y=pRect.top+1
	  	myrect(1).x=pRect.left+pRect.Right-1:myrect(1).y=pRect.top+1
	  	myrect(2).x=pRect.Left+pRect.Right-1:myrect(2).y=pRect.top+pRect.bottom-1
	  	myrect(3).x=pRect.left+1            :myrect(3).y=pRect.top+pRect.bottom-1
	  	myrect(4).x=pRect.left+1            :myrect(4).y=pRect.top+1
 	Else
	 	myrect(0).x=x:myrect(0).y=y
	  	myrect(1).x=x+w:myrect(1).y=y
	  	myrect(2).x=x+w:myrect(2).y=y+h
	  	myrect(3).x=x:myrect(3).y=y+h
	  	myrect(4).x=x:myrect(4).y=y
 	EndIf

   Dim As HDC   hdcdest = GetDC(hdl)
   Dim As LOGBRUSH lb
   Dim As HGDIOBJ hPen = NULL
   Dim As HGDIOBJ hPenOld  
	lb.lbStyle = BS_SOLID'HATCHED 
	lb.lbColor = 255     
	lb.lbHatch = 0 
	hPen = ExtCreatePen(PS_GEOMETRIC Or PS_JOIN_MITER Or PS_ENDCAP_SQUARE Or PS_INSIDEFRAME,2, @lb, 0, NULL) 
	hPenOld = SelectObject(hdcdest, hPen) 
  
   polyline(hdcdest,@myrect(0),5)
   SelectObject(hdcdest, hPenOld) 
   DeleteObject(hPen) 
   ReleaseDC(hdl, hdcDest)
End Sub 

	    	
