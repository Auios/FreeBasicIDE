'AuVec.bi (Auios Vectors)

#ifndef __AUIOS_VECTOR__
#define __AUIOS_VECTOR__
    
    'inclib "auvec"

    namespace Auios
        type AuVectorInt2
            as integer x,y
        end type
        type AuVectorUInt2
            as uinteger x,y
        end type
        type AuVectorInt3
            as integer x,y,z
        end type
        type AuVectorUInt3
            as uinteger x,y,z
        end type
    end namespace
#endif