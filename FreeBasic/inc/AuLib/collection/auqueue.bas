'AuQueue.bi
'1/5/2018

#IFNDEF _AUQUEUE_BI_
#DEFINE _AUQUEUE_BI_

#include once "crt.bi"

#DEFINE QUEUEALLOCSIZE 32

nameSpace AuLib
    #MACRO DeclareQueue(_T)
    type _T##Queue
        as uinteger allocated, count
        as _T ptr item
        
        declare constructor()
        declare sub allocate()
        declare sub deallocate()
        declare sub push(newItem as _T)
        declare function pop() as _T
        declare function length() as uinteger
    end type
    
    constructor _T##Queue
        item = new _T[QUEUEALLOCSIZE]
        allocated = QUEUEALLOCSIZE
    end constructor
    
    sub _T##Queue.allocate()
        allocated+=QUEUEALLOCSIZE
        dim as _T ptr temp = new _T[allocated]
        memmove(temp, item, (allocated-QUEUEALLOCSIZE)*sizeof(_T))
        delete[] item
        item = temp
    end sub
    
    sub _T##Queue.deallocate()
        allocated-=QUEUEALLOCSIZE
        dim as _T ptr temp = new _T[allocated]
        memmove(temp, item, (allocated-QUEUEALLOCSIZE)*sizeof(_T))
        delete[] item
        item = temp
    end sub
    
    sub _T##Queue.push(newItem as _T)
        if(count >= allocated) then this.allocate()
        count+=1
        item[count-1] = newItem
    end sub
    
    function _T##Queue.pop() as _T
        if(count = 0) then return 0
        dim as _T ret = item[0]
        count-=1
        memmove(@cptr(_T ptr,item)[0], @cptr(_T ptr,item)[1], sizeof(_T)*(count))
        if(count+(QUEUEALLOCSIZE\2)) < (allocated-QUEUEALLOCSIZE) then this.deallocate()
        return ret
    end function
    
    function _T##Queue.length() as uinteger
        return this.count
    end function
    #ENDMACRO
end nameSpace

#ENDIF