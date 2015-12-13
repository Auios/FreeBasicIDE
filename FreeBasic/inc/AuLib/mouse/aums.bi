'AuMs.bi (Auios Mouse)

#ifndef __AUIOS_MOUSE__
#define __AUIOS_MOUSE__
    
    #inclib "aums"
    
    namespace Auios
        type AuMouse
            as long state
            as long x,y
            as long wheel
            as long buttons
            as long clip
            as long visible
        end type
        
        declare function dump() as integer
        declare function set(as long, as long, as long, as long) as integer
        declare function AuMouseGet(byref thisMs as AuMouse) as integer
        
        declare function AuMouseCompare(thisMs1 as AuMouse, thisMs2 as AuMouse) as integer 'Return 0 if they are the same
        
        declare function AuMousePrintBar(charVar as zstring*1, cnt as long) as integer
    end namespace
#endif