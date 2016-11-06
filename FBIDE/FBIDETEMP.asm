	.intel_syntax noprefix

.section .text
.balign 16
_fb_ctor__FBIDETEMP:
.Lt_0002:
push 1
push 12
push offset _Lt_0004
call _fb_StrAllocTempDescZEx@8
push eax
push 0
call _fb_PrintString@12
.Lt_0003:
ret

.section .data
.balign 4
_Lt_0004:	.ascii	"Hello world!\0"

.section .ctors
.int _fb_ctor__FBIDETEMP
