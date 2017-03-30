'AuFile.bi
'1/23/2017

#IFNDEF _AUFILE_BI_
#DEFINE _AUFILE_BI_

#include once "crt.bi"

nameSpace AuLib
    type AuFile
        as ubyte isOpen
        as long EoF
        as zstring*2 mode
        as long fileNumber
        as zstring*255 fileName
    end type
    
    function AuFileOpen(fileName as zstring*255, mode as string) as AuFile
        dim as ubyte check
        dim as AuFile file
        file.fileNumber = freeFile()
        file.fileName = fileName
        file.mode = mode
        if(file.mode = "r") then
            if(open(file.fileName for input as #file.fileNumber)) then
                check = 1
            else
                file.isOpen = 1
            end if
        elseif(file.mode = "w") then
            if(open(file.fileName for output as #file.fileNumber)) then
                check = 1
            else
                file.isOpen = 1
            end if
        end if
        return file
    end function
    
    sub AuFileClose(file as AuFile)
        if(file.isOpen) then
            close #file.fileNumber
            file.isOpen = 0
            file.fileNumber = 0
        end if
    end sub
    
    sub AuFileReset(file as AuFile)
        if(file.isOpen) then
            close #file.fileNumber
            file = AuFileOpen(file.fileName, file.mode)
        end if
    end sub
    
    function AuFileReadLine(file as AuFile) as string
        dim as string text
        if(file.isOpen) then
            line input #file.fileNumber, text
            file.EoF = EoF(file.fileNumber)
        end if
        return text
    end function
    
end nameSpace

#ENDIF