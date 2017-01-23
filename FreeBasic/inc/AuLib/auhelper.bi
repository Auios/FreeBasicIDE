'AuHelper.bi
'1/22/2017

#IFNDEF _AUHELPER_BI_
#DEFINE _AUHELPER_BI_

#include "crt.bi"

nameSpace AuLib
    sub AuLibPrintBar(charVar as zstring*1, charCount as long)
        for printCount as integer = 1 to charCount
            printf(!"%s",charVar)
        next printCount
        printf(!"\n")
    end sub
end nameSpace

#ENDIF