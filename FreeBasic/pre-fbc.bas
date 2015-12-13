#include "windows.bi"
#include "file.bi"

dim as string EXTRA,PARM,LST(9)
dim as integer COUNT,FND,RESU,POSI
dim as PROCESS_INFORMATION MYPINFO
dim as STARTUPINFO MYINIT

COUNT = 1
do
  PARM = command$(COUNT)  
  if PARM = "" then 
    exit do
  elseif instr(1,lcase$(PARM),".bas") then    
    if dir$(PARM)<>"" then
      open PARM for input as #1
      while not eof(1)
        line input #1,PARM      
        FND = instr(1,lcase$(PARM),"#define fbc")        
        if FND then
          EXTRA += mid$(PARM,FND+11)
        end if
      wend
      close #1
    end if
  end if
  COUNT += 1
loop

#if 0
if dir$("fbc.exe") = "" then
  shell "copy f:\fb15\fbc.atu f:\fb15\fbc.exe >nul"
  shell "copy f:\fb15\bin\win32\*.atu f:\fb15\bin\win32\*.exe >nul"
end if
#endif

POSI = 1
PARM = ""
FND = 0
do
  RESU = instr(POSI,EXTRA,"&")
  if RESU = 0 then
    if POSI = 1 then 
      PARM = trim$(EXTRA)
    else
      LST(FND) = trim$(mid$(EXTRA,POSI))
      FND += 1
    end if
    exit do
  end if
  if POSI = 1 then 
    PARM = trim$(left$(EXTRA,RESU-1))
    POSI = RESU+1
  else
    LST(FND) = mid$(EXTRA,POSI,RESU-POSI)
    POSI = RESU+1
    FND += 1
    if FND > 9 then exit do    
  end if
  sleep 1
loop

'print EXTRA
'print command$,PARM
'for POSI = 0 to FND-1
'  print LST(POSI)
'next POSI

EXTRA = "" 'command$
COUNT = 1
do
  var STemp = command$(COUNT)  
  if sTemp = "" then 
    exit do
  else
    if FileExists(sTemp) then
      sTemp = """"+sTemp+""""
    end if
  end if
  EXTRA += sTemp+" ": COUNT += 1
loop

RESU = exec(exepath+"\fbc.exe",EXTRA+" "+PARM)
if RESU = 0 then
  for POSI = 0 to FND-1
    print "Executando: " & LST(POSI)
    with MYINIT
      .cb = sizeof(startupinfo)
      .dwflags = STARTF_USESTDHANDLES
    end with
    CreateProcess(null,strptr(LST(POSI)),null,null,false, _
    CREATE_NEW_CONSOLE or CREATE_NEW_PROCESS_GROUP,null,null,@MYINIT,@MYPINFO)    
  next POSI
  if FND>0 then 
    print "Completado..."
    if instr(1,lcase$(EXTRA),"fbidetemp.bas") then
      shell "copy "+exepath+"\bin\null.app .\fbidetemp.exe >nul"
    end if
    end RESU
  end if
end if
end RESU



