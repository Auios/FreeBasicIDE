'AuHelper.bi
'1/22/2017

#IFNDEF _AUHELPER_BI_
#DEFINE _AUHELPER_BI_

#include "crt.bi"

nameSpace AuLib
    function getWord(byval text as string, wordIndex as integer, delimiter as string) as string
        dim as zstring ptr word
        dim as integer wordsPassed
        word = strtok(text, delimiter)
        while(word <> NULL)
            wordsPassed+=1
            if(wordsPassed = wordIndex) then
                exit while
            end if
            word = strtok(NULL, delimiter)
        wend
        return(*word)
    end function
    
    function getWordCount(byval text as string, delimiter as string) as integer
        dim as zstring ptr word
        dim as integer wordsPassed
        word = strtok(text, delimiter)
        while(word <> NULL)
            wordsPassed+=1
            word = strtok(NULL, delimiter)
        wend
        return(wordsPassed)
    end function
    
    sub AuLibPrintBar(charVar as zstring*1, charCount as long)
        for printCount as integer = 1 to charCount
            printf(!"%s",charVar)
        next printCount
        printf(!"\n")
    end sub
end nameSpace

#ENDIF