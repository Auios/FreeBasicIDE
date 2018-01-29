#include once "fltk-tools.bi"
#include once "crt/stdlib.bi"
#include once "crt/string.bi"

#define FONTSIZE 15

dim as Style_Table_Entry StyleTable(...) => _
{(FL_BLACK     ,FL_COURIER       ,FONTSIZE), _ ' style 'A'
 (FL_BLACK     ,Fl_COURIER_BOLD  ,FONTSIZE), _ ' style 'B'
 (FL_RED       ,Fl_COURIER       ,FONTSIZE), _ ' style 'C'
 (Fl_LIGHT3    ,Fl_COURIER_ITALIC,FONTSIZE), _ ' style 'D'
 (FL_DARK_BLUE ,Fl_COURIER_BOLD  ,FONTSIZE), _ ' style 'E'
 (FL_DARK_GREEN,Fl_COURIER       ,FONTSIZE), _ ' style 'F'
 (FL_BLUE      ,Fl_COURIER_BOLD  ,FONTSIZE), _ ' style 'G'
 (&H00808000   ,Fl_COURIER_BOLD  ,FONTSIZE), _ ' style 'H'
 (FL_DARK_RED  ,Fl_COURIER       ,FONTSIZE)}   ' style 'I'

#define STYLE_PLAIN    asc("A")
#define STYLE_KEYWORD  asc("B")
#define STYLE_STRING   asc("C")
#define STYLE_COMMENT  asc("D")
#define STYLE_NUMBER   asc("E")
#define STYLE_PREPROC  asc("F")
#define STYLE_DATATYPE asc("G")
#define STYLE_OTHER    asc("H")
#define STYLE_USERLIB  asc("I")


' test of single line comment

/' test of multi
   line
   comment '/

' test of simple float (without E notation)
dim as single f1 = 1.234
dim as single f2 = .123
' test of dec, hex, oct, bin numbers
dim as integer d = 123456, h = &h123abc, o = &o1234567, b = &b00110010

function IsWhite(byval c as ubyte) as long
  if c=32 then return 1
  if c= 9 then return 1
  return 0
end function

function IsAlpha(byval c as ubyte) as long
  select case as const c
  case asc("a") to asc("z") : return 1
  case asc("A") to asc("Z") : return 1
  case asc("_") : return 1
  end select
  return 0
end function

function IsNumber(byval c as ubyte) as long
  select case as const c
  case asc("0") to asc("9") : return 1
  end select
  return 0
end function

function IsHex(byval c as ubyte) as long
  select case as const c
  case asc("a") to asc("f") : return 1
  case asc("A") to asc("F") : return 1
  end select
  return IsNumber(c)
end function

function IsOct(byval c as ubyte) as long
  select case as const c
  case asc("0") to asc("7") : return 1
  end select
  return 0
end function

function IsBin(byval c as ubyte) as long
  select case as const c
  case asc("0"),asc("1") : return 1
  end select
  return 0
end function

function IsAlphaNum(byval c as ubyte) as long
  If IsAlpha(c) then return 1
  If IsNumber(c) then return 1
  return 0
end function

function IsOperator(byval c as ubyte) as long
  return instr("=<>-+*/\@",chr(c))
end function

function IsDelimiter(byval c as ubyte) as long
  if c=10 then return 1
  if c=13 then return 1
  if c=34 then return 1
  if instr(",:()[]{}",chr(c)) then return 1
  return IsOperator(c)
end function

' some but by far not all keywords
function IsKeyword(byval s as string) as long
  dim as string search = "," & lcase(s) & ","
  dim as ubyte char=search[1]
  select case as const char
  case asc("a")
    char=search[2]
    select case as const char '    | |
    case asc("b") : return instr(",abs,abstract,", search)
    case asc("c") : return instr(",access,", search)
    case asc("l") : return instr(",alias,allocate,", search)
    case asc("n") : return instr(",and,andalso,", search)
    case asc("p") : return instr(",append,", search)
    case asc("s") : return instr(",asc,ascii,", search)
    end select
  case asc("b") 
    char=search[2]
    select case as const char '    | |
    case asc("a") : return instr(",base,boolean,", search)
    case asc("i") : return instr(",bin,binary,", search)
    case asc("o") : return instr(",boolean,", search)
    end select
  case asc("c") 
    char=search[2]
    select case as const char '    | |
    case asc("a") : return instr(",case,", search)
    case asc("d") : return instr(",cdecl,", search)
    case asc("h") : return instr(",chdir,chr,", search)
    case asc("i") : return instr(",circle,", search)
    end select
  case asc("d") 
    char=search[2]
    select case as const char '    | |
    case asc("a") : return instr(",data,", search)
    case asc("e") : return instr(",delete,", search)
    case asc("i") : return instr(",dim,", search)
    case asc("o") : return instr(",do,", search)
    end select
  case asc("e") 
    char=search[2]
    select case as const char '    | |
    case asc("l") : return instr(",else,elseif,", search)
    case asc("n") : return instr(",end,enum,", search)
    case asc("x") : return instr(",exepath,exit,extern,", search)
    end select
  case asc("f") 
    char=search[2]
    select case as const char '    | |
    case asc("o") : return instr(",for,", search)
    case asc("u") : return instr(",function,", search)
    end select
  case asc("g")
    char=search[2]
    select case as const char '    | |
    case asc("e") : return instr(",get,", search)
    case asc("o") : return instr(",gosub,goto,", search)
    end select
  case asc("h")
    char=search[2]
    select case as const char
    case asc("e") : return instr(",hex,", search)
    end select
  case asc("i") 
    char=search[2]
    select case as const char '    | |
    case asc("f") : return instr(",if,", search)
    case asc("m") : return instr(",imagecreate,imagedestroy,imageinfo,", search)
    case asc("n") : return instr(",input,instr,int,", search)
    end select
  case asc("k") : return instr(",kill,", search)
  case asc("l")
    char=search[2]
    select case as const char '    | |
    case asc("b") : return instr(",lbound,", search)
    case asc("c") : return instr(",lcase,", search)
    case asc("e") : return instr(",left,len,", search)
    case asc("i") : return instr(",line,", search)
    case asc("o") : return instr(",loop,", search)
    end select
  case asc("m") : return instr(",mid,", search)
  case asc("n")
    char=search[2]
    select case as const char '    | |
    case asc("e") : return instr(",next,", search)
    case asc("o") : return instr(",not,", search)
    end select
  case asc("o")
    char=search[2]
    select case as const char '    | |
    case asc("p") : return instr(",open,operator,", search)
    case asc("r") : return instr(",or,orelse,", search)
    end select
  case asc("p")
    char=search[2]
    select case as const char
    case asc("r")
      char=search[3]
      select case as const char '     | |
      case asc("i") : return instr(",print,private,", search)
      case asc("o") : return instr(",property,protected,", search)
      end select
    case asc("s") : return instr(",pset,", search)
    case asc("u") : return instr(",public,put,", search)
    end select
  case asc("q") : return 0
  case asc("r")
    char=search[2]
    select case as const char '    | |
    case asc("e") : return instr(",read,reset,return,", search)
    case asc("i") : return instr(",right,", search)
    end select
  case asc("s")
    char=search[2]
    select case as const char '    | |
    case asc("c") : return instr(",screen,screeninfo,screenres,screensync", search)
    case asc("e") : return instr(",select,", search)
    case asc("u") : return instr(",sub,", search)
    end select
  case asc("t") : return instr(",then,to,type,", search)
  case asc("u") : return instr(",ubound,ucase,", search)
  case asc("v") : return instr(",val,var,view", search)
  case asc("w") : return instr(",wchr,wend,while,window", search)
  case asc("x") : return instr(",xor,", search)
  end select
  return 0
end function

' some but not all data things
function IsDatatype(byval s as string) as long
  dim as string search = "," & lcase(s) & ","
  dim as ubyte char=search[1]
  select case as const char '   | |
  case asc("a") : return instr(",as,", search)
  case asc("b") : return instr(",byref,byte,byval,", search)
  case asc("c") : return instr(",const,", search)
  case asc("d") : return instr(",double,", search)
  case asc("i") : return instr(",long,", search)
  case asc("l") : return instr(",long,longint,", search)
  case asc("p") : return instr(",ptr,pointer,", search)
  case asc("s") : return instr(",short,single,string,", search)
  case asc("u") : return instr(",ubyte,ulong,ulong,ulongint,ushort,", search)
  case asc("w") : return instr(",wstring,", search)
  case asc("z") : return instr(",zstring,", search)
  end select
  return 0
end function

' some preproc by far not all
function IsPreproc(byval s as string) as long
  dim as string search = "," & ucase(s) & ","
  dim as ubyte char=search[1]
  select case as const char
  case asc("#") : return instr(",#DEFINE,#ELSE,#ENDIF,#ENDMACRO,#IF,#IFDEF,#INCLUDE,#MACRO,#UNDEF,", search)
  case asc("_") : return instr(",__FB_ARGC__,__FB_ARGV__,__FB_BUILD_DATE__,__FB_DEBUG__,__FB_GCC__,__FB_WIN32__,__FB_LINUX__,__FB_UNIX__,", search)
  case else     : return instr(",DEFINED,ONCE,", search)
  end select
end function

' some FLTK stuff
function IsUserlib(byval s as string) as long
  if len(s)<5 then return 0
  dim as string search = "," & lcase(s) & ","
  dim as ubyte char=search[4]
  select case as const char '      | |
  case asc("g") : return instr(",fl_geth,fl_getw,fl_groupsetresizable,", search)
  case asc("r") : return instr(",fl_run,",search)
  case asc("t")
    char=search[9]
    select case as const char
    case asc("b")
      char=search[15]
      select case as const char '                 | |
      case asc("a") : return instr(",fl_text_bufferaddmodifycallback,", search)
      case asc("l") : return instr(",fl_text_bufferlength,fl_text_bufferlineend,fl_text_bufferlinestart,fl_text_bufferloadfile,", search)
      case asc("n") : return instr(",fl_text_buffernew,", search)
      case asc("r") : return instr(",fl_text_bufferremove,fl_text_bufferreplace,", search)
      case asc("s") : return instr(",fl_text_bufferselect,fl_text_buffersettext,", search)
      case asc("t") : return instr(",fl_text_buffertextrange,", search)
      case asc("u") : return instr(",fl_text_bufferunselect,", search)
      end select
    case asc("d"): 
      char=search[16]
      select case as const char '                  | |
      case asc("g") : return instr(",fl_text_displaygetbuffer,", search)
      case asc("h") : return instr(",fl_text_displayhighlightdata,", search)
      case asc("r") : return instr(",fl_text_displayredisplayrange,", search)
      case asc("s") : return instr(",fl_text_displaysetbuffer,", search)
      end select
    case asc("e"): return instr(",fl_text_editornew,", search)
    end select
  case asc("w")
    char=search[6]
    select case as const char '        | |
    case asc("d") : return instr(",fl_widgetgeth,fl_widgetgetw,fl_widgetgetuserdata,fl_widgetsetuserdata,", search)
    case asc("n") : return instr(",fl_windownew,fl_windowshow,", search)
    end select
  end select
end function

' a litle bit syntax highlighting
sub Highlight(byval Text as const zstring ptr,byval Style as zstring ptr,byval length as long)
  #ifdef __FB_DEBUG__
  if Text=0 then flMessageBox("ModifyCb","Text=0")
  if Style=0 then flMessageBox("ModifyCb","Style=0")
  if length<1 then flMessageBox("ModifyCb","length<1")
  #endif
  #define FILLSTYLE(_style_) Style[e]=_style_:e+=1:length-=1:c=Text[e]
  #define RANGESTYLE(_style_) while s<e:Style[s]=_style_:s+=1:wend
  dim as long s,e
  dim as string  w
  print "Highlight " & length
  dim as ubyte   c = Text[e]:length-=1
  while length>0
    ' white chars ?
    while IsWhite(c) andalso length>0
      FILLSTYLE(STYLE_PLAIN)
    wend

    ' single line comment ?
    if c=asc("'") andalso length>0 then
      FILLSTYLE(STYLE_COMMENT)
      while c<>&H0A andalso length>0
        FILLSTYLE(STYLE_COMMENT)
      wend
      if c=&H0D then FILLSTYLE(STYLE_COMMENT)
    end if

    ' multi line comment ?
    if c=asc("/") andalso length>0 then
      if Text[e+1]=asc("'") then
        FILLSTYLE(STYLE_COMMENT): FILLSTYLE(STYLE_COMMENT)
        while c<>asc("'") andalso Text[e]<>asc("/") andalso length>0
          FILLSTYLE(STYLE_COMMENT)
        wend
        FILLSTYLE(STYLE_COMMENT):FILLSTYLE(STYLE_COMMENT)
      end if
    end if

    ' string ?
    if c=34 then
      FILLSTYLE(STYLE_STRING)
      while c<>34 andalso c<>&H0A andalso length>0
        FILLSTYLE(STYLE_STRING)
      wend
      if c=34 then FILLSTYLE(STYLE_STRING)
    end if


    ' string ?
    if c=34 Then
      dim As Long cpt
      FILLSTYLE(STYLE_STRING)
      cpt=1
      while cpt andalso c<>&H0A andalso length>0
        if c=34 then
          FILLSTYLE(STYLE_STRING)
          cpt=1-cpt
          if c=34 then cpt=1-cpt:FILLSTYLE(STYLE_STRING)
        else
          FILLSTYLE(STYLE_STRING)
        end if
      wend
    end if

    ' dec number ?
    if IsNumber(c) then
      FILLSTYLE(STYLE_NUMBER)
      while IsNumber(c) andalso length>0
        FILLSTYLE(STYLE_NUMBER)
      wend
    end if

    ' a part of a float number ? (no E notation)
    if c=asc(".") then
      FILLSTYLE(STYLE_NUMBER)
      while IsNumber(c) andalso length>0
        FILLSTYLE(STYLE_NUMBER)
      wend
    end if

    ' &H &O &B
    if c=asc("&") andalso length>2 then
      if Text[e+1]=asc("h") or Text[e+1]=asc("H") then
        FILLSTYLE(STYLE_NUMBER) : FILLSTYLE(STYLE_NUMBER)
        while IsHex(c) andalso length>0
          FILLSTYLE(STYLE_NUMBER)
        wend
      elseif Text[e+1]=asc("o") or Text[e+1]=asc("O") then
        FILLSTYLE(STYLE_NUMBER) : FILLSTYLE(STYLE_NUMBER)
        while IsOct(c) andalso length>0
          FILLSTYLE(STYLE_NUMBER)
        wend
      elseif Text[e+1]=asc("b") or Text[e+1]=asc("B") then
        FILLSTYLE(STYLE_NUMBER) : FILLSTYLE(STYLE_NUMBER)
        while IsBin(c) andalso length>0
          FILLSTYLE(STYLE_NUMBER)
        wend 
      end if
    end if

    ' get a word
    if c=asc("#") or IsAlpha(c) then
      s=e : w=""
      while c=asc("#") or IsAlphaNum(c) andalso length>0
        w &= chr(c) : e+=1 : length-=1 : c=Text[e]
      wend
      'print "|" & w & "|"
      if IsDatatype(w) then
        RANGESTYLE(STYLE_DATATYPE)
      elseif IsKeyword(w) then
        RANGESTYLE(STYLE_KEYWORD)
      elseif IsPreproc(w) then
        RANGESTYLE(STYLE_PREPROC)
      elseif IsUserlib(w) then
        RANGESTYLE(STYLE_USERLIB)
      else
        RANGESTYLE(STYLE_PLAIN)
      end if

    elseif IsOperator(c) then
      FILLSTYLE(STYLE_OTHER)
    elseif IsDelimiter(c) then
      FILLSTYLE(STYLE_OTHER)
    else
      FILLSTYLE(STYLE_PLAIN)
    end if
  wend
  #undef FILLSTYLE
  #undef RANGESTYLE
end sub

sub ModifyCb cdecl (byval p as long,byval nInserted as long,byval nDeleted as long, _
                    byval nRestyled as long,byval deletedText as const zstring ptr,byval pUserdata as any ptr)
  
  dim as zstring ptr Text,Style
  dim as long e,s=p
  dim as Fl_Text_Editor ptr Editor      = pUserdata
  dim as Fl_Text_Buffer ptr TextBuffer  = Fl_Text_DisplayGetBuffer(Editor)
  dim as Fl_Text_Buffer ptr StyleBuffer = Fl_WidgetGetUserData(Editor)
  
  #ifdef __FB_DEBUG__
  if puserdata=0 then flMessageBox("ModifyCb","puserdata=0")
  if TextBuffer=0 then flMessageBox("ModifyCb","TextBuffer=0")
  if StyleBuffer=0 then flMessageBox("ModifyCb","StyleBuffer=0")
  #endif
  
  print "ModifyCb " & p,nInserted,nDeleted,nRestyled
  if nInserted=0 andalso nDeleted=0 then 
    Fl_Text_BufferUnselect StyleBuffer
    return
  end if

  if (nInserted > 0) then
    e = s + nInserted
    Style = malloc(nInserted + 1)
    memset(Style, STYLE_PLAIN, nInserted)
    Style[nInserted] = 0
    Fl_Text_BufferReplace(StyleBuffer,s,e,Style)
    free Style
  end if
  
  if (nDeleted>0) then
    e = s + nDeleted
    Fl_Text_BufferRemove(StyleBuffer,s,e)
  end if
  Fl_Text_BufferSelect(StyleBuffer,s,e)

  s = Fl_Text_BufferLineStart(TextBuffer,s)
  e = Fl_Text_BufferLength(TextBuffer)
  'e = Fl_Text_BufferLineEnd(TextBuffer,e)

  Text  = Fl_Text_BufferTextRange(TextBuffer ,s,e)
  Style = Fl_Text_BufferTextRange(StyleBuffer,s,e)
  Highlight(Text,Style,e-s)
  Fl_Text_BufferReplace(StyleBuffer,s,e,Style)
  Fl_Text_DisplayRedisplayRange(Editor,s,e)
  free Text
  free Style
end sub

'
' main
'
var win = Fl_WindowNew(Fl_GetW()*0.75,Fl_GetH()*0.75, "Fl_Text_Editor03.bas")
var edt = Fl_Text_EditorNew(5,5,Fl_WidgetGetW(win)-10,Fl_WidgetGetH(win)-10)
var TextBuffer  = Fl_Text_BufferNew()
var StyleBuffer = Fl_Text_BufferNew()
Fl_WidgetSetUserdata(edt,StyleBuffer)

Fl_Text_DisplaySetLinenumberWidth(edt,6*8) '0 = line numbers off
Fl_Text_DisplaySetBuffer(edt,TextBuffer)
Fl_Text_DisplayHighlightData(edt,StyleBuffer,@StyleTable(0),ubound(StyleTable)+1)
Fl_Text_BufferAddModifyCallback(TextBuffer,@ModifyCB,edt)
if Fl_Text_BufferLoadFile(TextBuffer,"Fl_Text_Editor03.bas")<>0 then
  Fl_Text_BufferSetText(TextBuffer,!"print \"type your stuff\"")
end if
Fl_GroupSetResizable(win,edt)
Fl_WindowShow(win)
Fl_Run()
