'AuFile.bi
'1/23/2017

#IFNDEF _AUFILE_BI_
#DEFINE _AUFILE_BI_

#include once "crt.bi"

nameSpace AuLib
    type AuFile
        as boolean isOpen
        as long endOfFile
        as ubyte mode
        as long fileNumber
        as zstring*255 fileName
        
        declare function openRead(fileName as zstring*255) as boolean
        declare function openWrite(fileName as zstring*255) as boolean
        declare sub closeFile()
        declare sub reset()
        declare function readLine() as string
    end type
    
    function AuFile.openRead(fileName as zstring*255) as boolean
        if(this.isOpen) then return false
        this.fileNumber = freeFile()
        this.fileName = fileName
        this.mode = 1
        if(NOT open(this.fileName for input as #this.fileNumber)) then this.isOpen = true
        return this.isOpen
    end function
    
    function AuFile.openWrite(fileName as zstring*255) as boolean
        if(this.isOpen) then return false
        this.fileNumber = freeFile()
        this.fileName = fileName
        this.mode = 2
        if(NOT open(this.fileName for output as #this.fileNumber)) then this.isOpen = true
        return this.isOpen
    end function
    
    sub AuFile.closeFile()
        if(this.isOpen) then
            close #this.fileNumber
            this.isOpen = 0
            this.fileNumber = 0
            this.mode = 0
        end if
    end sub
    
    sub AuFile.reset()
        if(this.isOpen) then
            close #this.fileNumber
            if(this.mode = 1) then this.openRead(this.fileName)
            if(this.mode = 2) then this.openWrite(this.fileName)
        end if
    end sub
    
    function AuFile.readLine() as string
        dim as string text
        if(this.isOpen) then
            line input #this.fileNumber, text
            this.endOfFile = EoF(this.fileNumber)
        end if
        return text
    end function
    
end nameSpace

#ENDIF