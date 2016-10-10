' 
' PacketHandler module for Gods and Idols
' Copyright (c) 2014 Johannes Pihl, all rights reserved.
' 
' Revision 4, 2015-01-15
' 

#include "crt.bi"

 '// ERROR constants
#define PH_OK               0
#define PH_ERROR_OVERFLOW   32001
'// DATA constants
#define PH_DATA_NOTHING     0
#define PH_DATA_INTEGER     4
#define PH_DATA_SHORT       8
#define PH_DATA_BYTE1       2
#define PH_DATA_FLOAT       16
#define PH_DATA_DOUBLE      20
#define PH_DATA_STRING      24
#define PH_DATA_VECTOR      28
#define PH_DATA_LONGINT     32

#define mem_copy(f,t,l) memcpy(t,f,l)

type __VECTOR__
    as single x,y,z
end type

dim shared as __VECTOR__ NULL_VECTOR = (0,0,0)

type PH_Packet
	data as any ptr
	size as integer
	maxSize as integer
	maxRead as integer
	readPtr as integer
	error as integer
end type

function mem_dumpstr(memorya as any ptr, byval mlen as uinteger, byval rethex as integer = FALSE) as string
    dim memory as ubyte ptr = memorya
    dim i as integer
    dim as string t, a
    if rethex then
        for i = 1 to mlen
            t = hex(memory[i-1])
            a = a + string$(2-len(t), 48) + t
        next
    else
        for i = 1 to mlen
            a = a + chr(memory[i-1])
        next
    end if
    mem_dumpstr = a
end function

sub mem_fill ( memorya as any ptr, value as ubyte, byval mlen as uinteger )
    dim i as integer
    dim memory as uinteger ptr = memorya
    dim memoryb as ubyte ptr = memorya
    dim ll as uinteger
    dim lli as uinteger
    ll = mlen \ 4
    lli = mlen mod 4
    if ll then
        dim valuei as uinteger
        dim vp as ubyte ptr
        vp = cptr(ubyte ptr, @valuei)
        vp[0] = value: vp[1] = value: vp[2] = value: vp[3] = value
        for i = 1 to ll
            memory[i-1] = valuei
        next
        end if
        if lli then
        lli -= 1
        for i = (ll*4) to (ll*4) + lli
            memoryb[i] = value
        next
    end if
end sub

'Basically a seek function
sub PH_Reset(byval i as PH_Packet ptr, byval _seek as integer = 0)
	i->readPtr=_seek
	i->error=PH_OK
end sub

sub PH_SetMaxRead(byval i as PH_Packet ptr, byval m as integer)
	i->maxRead = m
end sub

function PH_CreatePacket(byval m as integer = 512, byval add_data as integer = TRUE) as PH_Packet
	dim as PH_Packet r
	if add_data then r.data = callocate(m)
	r.size = 0
	r.maxRead = m
	r.maxSize = m
	r.readPtr = 0
	r.error = PH_OK
	return r
end function

function PH_CreatePacketFromStream(byval i as any ptr, byval m as integer) as PH_Packet
	dim as PH_Packet r = PH_CreatePacket(m, FALSE)
	r.data = i
	return r
end function

function PH_Error overload(byval i as PH_Packet ptr) as integer
	return i->error
end function
function PH_Error(byval i as PH_Packet) as integer
	return i.error
end function

function PH_ReadLongint(byval i as PH_Packet ptr) as ulongint
	if i->readPtr + 8 > i->maxSize or i->readPtr + 8 > i->maxRead then i->error = PH_ERROR_OVERFLOW: return 0
	dim as longint ret = cast(longint ptr, i->data+i->readPtr)[0]
	i->readPtr+=8
	return ret
end function

function PH_ReadInteger(byval i as PH_Packet ptr) as integer
	if i->readPtr + 4 > i->maxSize or i->readPtr + 4 > i->maxRead then i->error = PH_ERROR_OVERFLOW: return 0
	dim as integer ret = cast(integer ptr, i->data+i->readPtr)[0]
	i->readPtr+=4
	return ret
end function

function PH_ReadShort(byval i as PH_Packet ptr) as ushort
	if i->readPtr + 2 > i->maxSize or i->readPtr + 2 > i->maxRead then i->error = PH_ERROR_OVERFLOW: return 0
	dim as ushort ret = cast(ushort ptr, i->data+i->readPtr)[0]
	i->readPtr+=2
	return ret
end function

function PH_ReadByte(byval i as PH_Packet ptr) as ubyte
	if i->readPtr + 1 > i->maxSize or i->readPtr + 1 > i->maxRead then i->error = PH_ERROR_OVERFLOW: return 0
	dim as ubyte ret = cast(ubyte ptr, i->data+i->readPtr)[0]
	i->readPtr+=1
	return ret
end function

function PH_ReadFloat(byval i as PH_Packet ptr) as single
	if i->readPtr + 4 > i->maxSize or i->readPtr + 4 > i->maxRead then i->error = PH_ERROR_OVERFLOW: return 0
	dim as single ret = cast(single ptr, i->data+i->readPtr)[0]
	i->readPtr+=4
	return ret
end function

function PH_ReadDouble(byval i as PH_Packet ptr) as double
	if i->readPtr + 8 > i->maxSize or i->readPtr + 8 > i->maxRead then i->error = PH_ERROR_OVERFLOW: return 0
	dim as double ret = cast(double ptr, i->data+i->readPtr)[0]
	i->readPtr+=8
	return ret
end function

function PH_ReadString(byval i as PH_Packet ptr) as string
	dim as ushort _strLen = PH_ReadShort(i)
	dim as string ret
	if _strLen > 0 then
		if i->readPtr + _strLen > i->maxSize or i->readPtr + _strLen > i->maxRead then i->error = PH_ERROR_OVERFLOW: return ""
		ret = space(_strLen)
		mem_copy(i->data+i->readPtr, strptr(ret), _strLen)
		i->readPtr+=_strLen
	end if
	return ret
end function

function PH_ReadVector(byval i as PH_Packet ptr) as __VECTOR__
	if i->readPtr + 12 > i->maxSize or i->readPtr + 12 > i->maxRead then i->error = PH_ERROR_OVERFLOW: return NULL_VECTOR
	dim as __VECTOR__ ret
	ret.x = PH_ReadFloat(i)
	ret.y = PH_ReadFloat(i)
	ret.z = PH_ReadFloat(i)
	return ret
end function

function PH_ReadRaw(byval i as PH_Packet ptr, byval l as integer) as any ptr
	if i->readPtr + l > i->maxSize or i->readPtr + l > i->maxRead then i->error = PH_ERROR_OVERFLOW: return 0
	dim as any ptr ret = callocate(l)
	mem_copy(i->data+i->readPtr, ret, l)
	i->readPtr+=l
	return ret
end function

function PH_ReadHashBinary(byval i as PH_Packet ptr) as any ptr
	if i->readPtr + 20 > i->maxSize or i->readPtr + 20 > i->maxRead then i->error = PH_ERROR_OVERFLOW: return 0
	dim as any ptr ret = callocate(20)
	mem_copy(i->data+i->readPtr, ret, 20)
	i->readPtr+=20
	return ret
end function

function PH_ReadHashHex(byval i as PH_Packet ptr) as string
	if i->readPtr + 20 > i->maxSize or i->readPtr + 20 > i->maxRead then i->error = PH_ERROR_OVERFLOW: return ""
	PH_ReadHashHex = mem_dumpstr(i->data+i->readPtr, 20, TRUE)
	i->readPtr+=20
end function

function PH_GetType(byval i as PH_Packet ptr) as integer
	return PH_ReadShort(i)
end function

'Deletes all properties
sub PH_DeletePacket(byval p as PH_Packet ptr)
	if p->data then deallocate(p->data)
	p->data = 0
	p->maxSize = 0
	p->maxRead = 0
	p->size = 0
	p->readPtr = 0
	p->error = PH_OK
end sub

'Clears all data
sub PH_ResetPacket(byval p as PH_Packet ptr)
	p->size = 0
	if p->data<>0 and p->maxSize>0 then mem_fill(p->data, 0, p->maxSize)
end sub

'Manually resize packet
sub PH_PacketReallocate(byval p as PH_Packet ptr, byval size as integer)
	if size > p->maxSize then
		p->maxSize = size
		p->data = reallocate(p->data, p->maxSize)
	end if
end sub

sub PH_PacketGrow(byval p as PH_Packet ptr, byval size as integer)
	p->maxSize += size
	p->data = reallocate(p->data, p->maxSize)
end sub

sub PH_AddShort(byval p as PH_Packet ptr, byval s as ushort)
	if p->size + 2 > p->maxSize then PH_PacketGrow(p, 128)
	cast(ushort ptr, p->data + p->size)[0] = s
	p->size+=2
end sub

sub PH_AddHeader(byval p as PH_Packet ptr, byval s as ushort)
	PH_AddShort(p, s)
end sub

sub PH_AddByte(byval p as PH_Packet ptr, byval s as ubyte)
	if p->size + 1 > p->maxSize then PH_PacketGrow(p, 128)
	cast(ubyte ptr, p->data + p->size)[0] = s
	p->size+=1
end sub

sub PH_AddLongint(byval p as PH_Packet ptr, byval s as ulongint)
	if p->size + 8 > p->maxSize then PH_PacketGrow(p, 128)
	cast(longint ptr, p->data + p->size)[0] = s
	p->size+=8
end sub

sub PH_AddInteger(byval p as PH_Packet ptr, byval s as integer)
	if p->size + 4 > p->maxSize then PH_PacketGrow(p, 128)
	cast(integer ptr, p->data + p->size)[0] = s
	p->size+=4
end sub

sub PH_AddFloat(byval p as PH_Packet ptr, byval s as single)
	if p->size + 4 > p->maxSize then PH_PacketGrow(p, 128)
	cast(single ptr, p->data + p->size)[0] = s
	p->size+=4
end sub

sub PH_AddDouble(byval p as PH_Packet ptr, byval s as double)
	if p->size + 8 > p->maxSize then PH_PacketGrow(p, 128)
	cast(double ptr, p->data + p->size)[0] = s
	p->size+=8
end sub

sub PH_AddVector(byval p as PH_Packet ptr, byval v as __VECTOR__)
	if p->size + 12 > p->maxSize then PH_PacketGrow(p, 128)
	PH_AddFloat(p, v.x)
	PH_AddFloat(p, v.y)
	PH_AddFloat(p, v.z)
end sub

'sub PH_AddHash(byval p as PH_Packet ptr, byval s as string)
'	if p->size + 20 > p->maxSize then PH_PacketGrow(p, 128)
'	SHA1Reset(@hash_sha1)
'	SHA1Input(@hash_sha1, strptr(s), len(s))
'	SHA1Result(@hash_sha1, hash_sha1_digest)
'	mem_copy(hash_sha1_digest, p->data+p->size, SHA1HashSize)
'	p->size+=20
'end sub

sub PH_AddRawFromHex(byval p as PH_Packet ptr, byval s as string)
	dim as integer l = len(s)
	if l mod 2 <> 0 then exit sub
	if p->size + l > p->maxSize then PH_PacketGrow(p, l)
	dim as ubyte ptr nd = callocate(l)
	for i as integer = 0 to l-1 step 2
		nd[i/2] = val("&H"& mid(s, i+1, 2))
	next
	mem_copy(nd, p->data+p->size, l/2)
	p->size+=l/2
end sub

sub PH_AddRaw(byval p as PH_Packet ptr, byval d as any ptr, byval l as integer)
	if p->size + l > p->maxSize then PH_PacketGrow(p, l)
	mem_copy(d, p->data+p->size, l)
	p->size+=l
end sub

sub PH_AddString(byval p as PH_Packet ptr, byval s as string)
	dim as integer l = len(s)
	if p->size + l + 2 > p->maxSize then PH_PacketGrow(p, l+2)
	PH_AddShort(p, l)
	if l > 0 then mem_copy(strptr(s), p->data+p->size, l)
	p->size+=l
end sub