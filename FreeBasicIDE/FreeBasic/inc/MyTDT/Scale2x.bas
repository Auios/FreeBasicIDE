'#define SC2X_X 320
'#define SC2X_Y 240
'#define MYBPP 32
namespace bpp8

sub Resize2x(PTORG as any ptr,PTDST as any ptr)
  
  const OPI = 1
  const OPIB = OPI*2
  const PILI = SC2X_X*2
  
  asm
    mov ESI,[PTORG]
    mov EDI,[PTDST]
    mov EBX,SC2X_X
    mov EDX,SC2X_Y
    _R2X8_NEXTLINE_:
    mov ECX,EBX
    _R2X8_NEXTPOINT_:
    lodsb
    mov AH,AL    
    mov [EDI],AX
    mov [EDI+PILI],AX
    add EDI,OPIB
    dec ecx
    jnz _R2X8_NEXTPOINT_
    add EDI,PILI
    dec edx
    jnz _R2X8_NEXTLINE_
  end asm
  
end sub

sub scale2x(PTORG as any ptr, PTDST as any ptr)
  static as integer Y  
  Y = SC2X_Y
  
  const PILI = SC2X_X
  const OPI = 1
  const TPI = OPI*2
  const PILIS = PILI-1
  const OLIS = PILI-1
  const OLIA = PILI+1
  const TLISS = (PILI*2)-2
  const TLIS = (PILI*2)-1
  const TLI = (PILI*2)
  const TLIA = (PILI*2)+1
  
  ' **** Inicio do código asm fixo para dobrar 256x192 ****
  asm        
    mov ESI,[PTORG]     ' ESI = Ponteiro de Origem
    mov EDI,[PTDST]     ' EDI = Ponteiro de Destino
    lodsb               ' \
    stosb               ' | Copia e aumenta
    stosb               ' | o primeiro Pixel
    mov [EDI+TLISS],AL   ' | (borda)
    mov [EDI+TLIS],AL   ' /
    ' *************** Primeira Linha (borda) **************
    mov ECX,PILIS         ' (255 pixels na linha (256-borda))
    _S2X8_FLNEXTPOINT_:      ' Label de Próximo Pixel
    lodsb                ' Carrega Pixel central (E)
    mov BL,[ESI]        ' Carrega Pixel Superior (B)
    mov DL,[ESI]        ' Carrega Pixel Direito (F)
    cmp BL,[ESI+OLIS]    ' \ Compara igualdade dos pixels B & H
    je _S2X8_FLBEHODEF_      ' | Iguais? Entom pula para escala normal
    cmp [ESI-TPI],DL      ' | Compara igualgade dos pixels D & F
    je _S2X8_FLBEHODEF_      ' / Iguais? Entom pula para escala normal
    ' ************ 4 pontos da escala especial ************
    cmp BL,[ESI-TPI]      ' Compara Pixels B & D       \
    je _S2X8_FLNOCHGE0_      ' iguais entom E0 = D        | iif(B=D,D,E)
    mov BL,AL           ' diferentes entom E0 = E    |
    _S2X8_FLNOCHGE0_:        ' Label Qndo Iguais (ignora) /
    mov [EDI],BL        ' Coloca ponto E0 (superior esquerdo) no buffer de destino 
    cmp [ESI],DL        ' Compara Pixels B & F       \
    je _S2X8_FLNOCHGE1_      ' Iguais? entom E1=F         | iif(B=F,F,E)
    mov DL,AL           ' Diferentes? entom E1 = E   |
    _S2X8_FLNOCHGE1_:        ' Label qndo iguais (ignora) /
    mov [EDI+OPI],DL      ' Coloca ponto E1 (superior direito) no buffer de destino
    mov BL,[ESI-TPI]      ' Carrega Pixel Esquerdo (D)
    mov DL,[ESI+OLIS]    ' Carrega Pixel Inferior (H)
    cmp BL,DL           ' Compara Pixels H & D       \
    je _S2X8_FLNOCHGE2_      ' Iguais? entom E2=D         | iif(H=D,D,E)
    mov BL,AL           ' Diferentes? entom E2=E     |
    _S2X8_FLNOCHGE2_:        ' Label qndo iguais (ignora) /
    mov [EDI+TLI],BL   ' Coloca ponto E2 (inferior esquerdo) no buffer de destino
    cmp DL,[ESI]        ' Compara Pixels H & F       \
    je _S2X8_FLNOCHGE3_      ' Iguais entom E3=F          | iif(H=F,F,E)
    mov DL,AL           ' Diferentes? entom E3=E     |
    _S2X8_FLNOCHGE3_:        ' Label qndo iguais (ignora) /
    mov [EDI+TLIA],DL   ' Coloca ponto E3 (inferior direito) no buffer de destino
    add EDI,TPI           ' Aponta para próximo pixel de destino
    dec ECX             ' \ Próximo pixel da linha
    jnz _S2X8_FLNEXTPOINT_   ' / até que termine
    add EDI,TLI        ' Aponta para próxima linha de destino
    dec dword ptr [Y]   ' \ Próximo linha
    jnz _S2X8_NEXTLINE_      ' / (adianta pq 1ª linha = borda)
    ' ************ 4 pontos da escala normal ************
    _S2X8_FLBEHODEF_:        ' Label para escala normal
    stosb               ' \
    stosb               ' | Coloca os 4 pontos no buffer de destino
    mov [EDI+TLISS],AL   ' | E0,E1,E2,E3 ( = E (ponto central )
    mov [EDI+TLIS],AL   ' /
    dec ECX             ' \ Próximo pixel da linha
    jnz _S2X8_FLNEXTPOINT_   ' / até que termine   
    add EDI,TLI        ' Aponta para próxima linha de destino
    dec dword ptr [Y]   ' \ Próximo linha
    ' ***************** Linhas Seguintes *****************
    _S2X8_NEXTLINE_:         ' Label de próxima linha
    mov ECX,PILI         ' 256 pixels (borda provisória)
    _S2X8_NEXTPOINT_:        ' Label de Próximo Ponto
    lodsb               ' Carrega Pixel central (E)
    mov BL,[ESI-OLIA]    ' Carrega Pixel Superior (B)
    mov DL,[ESI]        ' Carrega Pixel Direito (F)
    cmp BL,[ESI+OLIS]    ' \ Compara igualdade dos pixels B & H
    je _S2X8_BEHODEF_        ' | Iguais? Entom pula para escala normal
    cmp [ESI-TPI],DL      ' | Compara igualgade dos pixels D & F
    je _S2X8_BEHODEF_        ' / Iguais? Entom pula para escala normal
    ' ************ 4 pontos da escala especial ************
    cmp BL,[ESI-TPI]      ' Compara Pixels B & D       \
    je _S2X8_NOCHGE0_        ' iguais entom E0 = D        | iif(B=D,D,E)
    mov BL,AL           ' diferentes entom E0 = E    |
    _S2X8_NOCHGE0_:          ' Label Qndo Iguais (ignora) /
    mov [EDI],BL        ' Coloca ponto E0 (superior esquerdo) no buffer de destino
    cmp [ESI-OLIA],DL    ' Compara Pixels B & F       \
    je _S2X8_NOCHGE1_        ' Iguais? entom E1=F         | iif(B=F,F,E)
    mov DL,AL           ' Diferentes? entom E1 = E   |
    _S2X8_NOCHGE1_:          ' Label qndo iguais (ignora) /
    mov [EDI+OPI],DL      ' Coloca ponto E1 (superior direito) no buffer de destino
    mov BL,[ESI-TPI]      ' Carrega Pixel Esquerdo (D)
    mov DL,[ESI+OLIS]    ' Carrega Pixel Inferior (H)
    cmp BL,DL           ' Compara Pixels H & D       \
    je _S2X8_NOCHGE2_        ' Iguais? entom E2=D         | iif(H=D,D,E)
    mov BL,AL           ' Diferentes? entom E2 = E   |
    _S2X8_NOCHGE2_:          ' Label qndo iguais (ignora) /
    mov [EDI+TLI],BL   ' Coloca ponto E2 (inferior esquerdo) no buffer de destino
    cmp DL,[ESI]        ' Compara Pixels H & F       \
    je _S2X8_NOCHGE3_        ' Iguais entom E3=F          | iif(H=F,F,E)
    mov DL,AL           ' Diferentes? entom E3 = E   |
    _S2X8_NOCHGE3_:          ' Label qndo iguais (ignora) /
    mov [EDI+TLIA],DL   ' Coloca ponto E3 (inferior direito) no buffer de destino
    add EDI,TPI           ' Aponta para próximo pixel de destino
    dec ECX             ' \ Próximo pixel da linha
    jnz _S2X8_NEXTPOINT_     ' / até que termine
    add EDI,TLI        ' Aponta para próxima linha de destino
    dec dword ptr [Y]   ' \ Próxima linha
    jnz _S2X8_NEXTLINE_      ' / das 191 restantes (menos borda)
    jmp _S2X8_FINALEND_      ' Vai para o fim caso termine com escala especial
    ' ************ 4 pontos da escala normal ************
    _S2X8_BEHODEF_:          ' Label de Escala Normal
    stosb               ' \
    stosb               ' | Coloca os 4 pontos no buffer de destino
    mov [EDI+TLISS],AL   ' | E0,E1,E2,E3 ( = E (ponto central )
    mov [EDI+TLIS],AL   ' /
    dec ECX             ' \ Próximo pixel da linha
    jnz _S2X8_NEXTPOINT_     ' / até que termine
    add EDI,TLI        ' Aponta para próxima linha de destino
    dec dword ptr [Y]   ' \ Próxima linha
    jnz _S2X8_NEXTLINE_      ' / das 191 restantes (menos borda)
    _S2X8_FINALEND_:         ' Label de fim =)
  end asm  
end sub

end namespace

namespace bpp16

sub Resize2x(PTORG as any ptr,PTDST as any ptr)
  
  #define ESZ 2
  
  const OPI = ESZ
  const OPIB = OPI*2
  const PILI = (SC2X_X*2)*ESZ
  
  asm
    mov ESI,[PTORG]
    mov EDI,[PTDST]
    mov BX,SC2X_Y
    shl EBX,16
    mov CX,SC2X_X
    _R2X16_NEXTLINE_:
    mov BX,CX
    _R2X16_NEXTPOINT_:
    lodsw
    mov DX,AX
    shl EAX,16
    mov AX,DX    
    mov [EDI],EAX
    mov [EDI+PILI],EAX
    add EDI,OPIB
    dec BX
    jnz _R2X16_NEXTPOINT_
    add EDI,PILI
    sub EBX,65536    
    jnz _R2X16_NEXTLINE_
  end asm
  
end sub

sub scale2x(PTORG as any ptr, PTDST as any ptr)
  static as integer Y  
  Y = SC2X_Y
  
  #define ESZ 2  
  
  const PILI = SC2X_X
  const PILIS = SC2X_X-1
  const OPI = ESZ
  const TPI = ESZ*2  
  const OLIS = (SC2X_X-1)*ESZ
  const OLIA = (SC2X_X+1)*ESZ
  const TLISS = ((SC2X_X*2)-2)*ESZ
  const TLIS = ((SC2X_X*2)-1)*ESZ
  const TLI = ((SC2X_X*2))*ESZ
  const TLIA = ((SC2X_X*2)+1)*ESZ
  
  ' **** Inicio do código asm fixo para dobrar 256x192 ****
  asm        
    mov ESI,[PTORG]     ' ESI = Ponteiro de Origem
    mov EDI,[PTDST]     ' EDI = Ponteiro de Destino
    lodsw               ' \
    stosw               ' | Copia e aumenta
    stosw               ' | o primeiro Pixel
    mov [EDI+TLISS],AX   ' | (borda)
    mov [EDI+TLIS],AX   ' /
    ' *************** Primeira Linha (borda) **************
    mov ECX,PILIS         ' (255 pixels na linha (256-borda))
    _S2X16_FLNEXTPOINT_:      ' Label de Próximo Pixel
    lodsw                ' Carrega Pixel central (E)
    mov BX,[ESI]        ' Carrega Pixel Superior (B)
    mov DX,[ESI]        ' Carrega Pixel Direito (F)
    cmp BX,[ESI+OLIS]    ' \ Compara igualdade dos pixels B & H
    je _S2X16_FLBEHODEF_      ' | Iguais? Entom pula para escala normal
    cmp [ESI-TPI],DX      ' | Compara igualgade dos pixels D & F
    je _S2X16_FLBEHODEF_      ' / Iguais? Entom pula para escala normal
    ' ************ 4 pontos da escala especial ************
    cmp BX,[ESI-TPI]      ' Compara Pixels B & D       \
    je _S2X16_FLNOCHGE0_      ' iguais entom E0 = D        | iif(B=D,D,E)
    mov BX,AX           ' diferentes entom E0 = E    |
    _S2X16_FLNOCHGE0_:        ' Label Qndo Iguais (ignora) /
    mov [EDI],BX        ' Coloca ponto E0 (superior esquerdo) no buffer de destino 
    cmp [ESI],DX        ' Compara Pixels B & F       \
    je _S2X16_FLNOCHGE1_      ' Iguais? entom E1=F         | iif(B=F,F,E)
    mov DX,AX           ' Diferentes? entom E1 = E   |
    _S2X16_FLNOCHGE1_:        ' Label qndo iguais (ignora) /
    mov [EDI+OPI],DX      ' Coloca ponto E1 (superior direito) no buffer de destino
    mov BX,[ESI-TPI]      ' Carrega Pixel Esquerdo (D)
    mov DX,[ESI+OLIS]    ' Carrega Pixel Inferior (H)
    cmp BX,DX           ' Compara Pixels H & D       \
    je _S2X16_FLNOCHGE2_      ' Iguais? entom E2=D         | iif(H=D,D,E)
    mov BX,AX           ' Diferentes? entom E2=E     |
    _S2X16_FLNOCHGE2_:        ' Label qndo iguais (ignora) /
    mov [EDI+TLI],BX   ' Coloca ponto E2 (inferior esquerdo) no buffer de destino
    cmp DX,[ESI]        ' Compara Pixels H & F       \
    je _S2X16_FLNOCHGE3_      ' Iguais entom E3=F          | iif(H=F,F,E)
    mov DX,AX           ' Diferentes? entom E3=E     |
    _S2X16_FLNOCHGE3_:        ' Label qndo iguais (ignora) /
    mov [EDI+TLIA],DX   ' Coloca ponto E3 (inferior direito) no buffer de destino
    add EDI,TPI           ' Aponta para próximo pixel de destino
    dec ECX             ' \ Próximo pixel da linha
    jnz _S2X16_FLNEXTPOINT_   ' / até que termine
    add EDI,TLI        ' Aponta para próxima linha de destino
    dec dword ptr [Y]   ' \ Próximo linha
    jnz _S2X16_NEXTLINE_      ' / (adianta pq 1ª linha = borda)
    ' ************ 4 pontos da escala normal ************
    _S2X16_FLBEHODEF_:        ' Label para escala normal
    stosw               ' \
    stosw               ' | Coloca os 4 pontos no buffer de destino
    mov [EDI+TLISS],AX   ' | E0,E1,E2,E3 ( = E (ponto central )
    mov [EDI+TLIS],AX   ' /
    dec ECX             ' \ Próximo pixel da linha
    jnz _S2X16_FLNEXTPOINT_   ' / até que termine   
    add EDI,TLI        ' Aponta para próxima linha de destino
    dec dword ptr [Y]   ' \ Próximo linha
    ' ***************** Linhas Seguintes *****************
    _S2X16_NEXTLINE_:         ' Label de próxima linha
    mov ECX,PILI         ' 256 pixels (borda provisória)
    _S2X16_NEXTPOINT_:        ' Label de Próximo Ponto
    lodsw               ' Carrega Pixel central (E)
    mov BX,[ESI-OLIA]    ' Carrega Pixel Superior (B)
    mov DX,[ESI]        ' Carrega Pixel Direito (F)
    cmp BX,[ESI+OLIS]    ' \ Compara igualdade dos pixels B & H
    je _S2X16_BEHODEF_        ' | Iguais? Entom pula para escala normal
    cmp [ESI-TPI],DX      ' | Compara igualgade dos pixels D & F
    je _S2X16_BEHODEF_        ' / Iguais? Entom pula para escala normal
    ' ************ 4 pontos da escala especial ************
    cmp BX,[ESI-TPI]      ' Compara Pixels B & D       \
    je _S2X16_NOCHGE0_        ' iguais entom E0 = D        | iif(B=D,D,E)
    mov BX,AX           ' diferentes entom E0 = E    |
    _S2X16_NOCHGE0_:          ' Label Qndo Iguais (ignora) /
    mov [EDI],BX        ' Coloca ponto E0 (superior esquerdo) no buffer de destino
    cmp [ESI-OLIA],DX    ' Compara Pixels B & F       \
    je _S2X16_NOCHGE1_        ' Iguais? entom E1=F         | iif(B=F,F,E)
    mov DX,AX           ' Diferentes? entom E1 = E   |
    _S2X16_NOCHGE1_:          ' Label qndo iguais (ignora) /
    mov [EDI+OPI],DX      ' Coloca ponto E1 (superior direito) no buffer de destino
    mov BX,[ESI-TPI]      ' Carrega Pixel Esquerdo (D)
    mov DX,[ESI+OLIS]    ' Carrega Pixel Inferior (H)
    cmp BX,DX           ' Compara Pixels H & D       \
    je _S2X16_NOCHGE2_        ' Iguais? entom E2=D         | iif(H=D,D,E)
    mov BX,AX           ' Diferentes? entom E2 = E   |
    _S2X16_NOCHGE2_:          ' Label qndo iguais (ignora) /
    mov [EDI+TLI],BX   ' Coloca ponto E2 (inferior esquerdo) no buffer de destino
    cmp DX,[ESI]        ' Compara Pixels H & F       \
    je _S2X16_NOCHGE3_        ' Iguais entom E3=F          | iif(H=F,F,E)
    mov DX,AX           ' Diferentes? entom E3 = E   |
    _S2X16_NOCHGE3_:          ' Label qndo iguais (ignora) /
    mov [EDI+TLIA],DX   ' Coloca ponto E3 (inferior direito) no buffer de destino
    add EDI,TPI           ' Aponta para próximo pixel de destino
    dec ECX             ' \ Próximo pixel da linha
    jnz _S2X16_NEXTPOINT_     ' / até que termine
    add EDI,TLI        ' Aponta para próxima linha de destino
    dec dword ptr [Y]   ' \ Próxima linha
    jnz _S2X16_NEXTLINE_      ' / das 191 restantes (menos borda)
    jmp _S2X16_FINALEND_      ' Vai para o fim caso termine com escala especial
    ' ************ 4 pontos da escala normal ************
    _S2X16_BEHODEF_:          ' Label de Escala Normal
    stosw               ' \
    stosw               ' | Coloca os 4 pontos no buffer de destino
    mov [EDI+TLISS],AX   ' | E0,E1,E2,E3 ( = E (ponto central )
    mov [EDI+TLIS],AX   ' /
    dec ECX             ' \ Próximo pixel da linha
    jnz _S2X16_NEXTPOINT_     ' / até que termine
    add EDI,TLI        ' Aponta para próxima linha de destino
    dec dword ptr [Y]   ' \ Próxima linha
    jnz _S2X16_NEXTLINE_      ' / das 191 restantes (menos borda)
    _S2X16_FINALEND_:         ' Label de fim =)
  end asm  
end sub

end namespace

namespace bpp32

sub Resize2x(PTORG as any ptr,PTDST as any ptr)
  
  #define ESZ 4
  
  const OPI = ESZ
  const OPIB = OPI*2
  const PILI = (SC2X_X*2)*ESZ
  const PILIB = PILI+OPI
  
  asm
    mov ESI,[PTORG]
    mov EDI,[PTDST]
    mov EDX,SC2X_Y    
    mov EBX,SC2X_X
    _R2X32_NEXTLINE_:
    mov ECX,EBX
    _R2X32_NEXTPOINT_:
    lodsd    
    mov [EDI],EAX
    mov [EDI+OPI],EAX
    mov [EDI+PILI],EAX
    mov [EDI+PILIB],EAX
    add EDI,OPIB
    dec ECX
    jnz _R2X32_NEXTPOINT_
    add EDI,PILI
    dec EDX
    jnz _R2X32_NEXTLINE_
  end asm
  
end sub

sub scale2x(PTORG as any ptr, PTDST as any ptr)
  static as integer Y  
  Y = SC2X_Y
  
  #define ESZ 4  
  
  const PILI = SC2X_X
  const PILIS = SC2X_X-1
  const OPI = ESZ
  const TPI = ESZ*2  
  const OLIS = (SC2X_X-1)*ESZ
  const OLIA = (SC2X_X+1)*ESZ
  const TLISS = ((SC2X_X*2)-2)*ESZ
  const TLIS = ((SC2X_X*2)-1)*ESZ
  const TLI = ((SC2X_X*2))*ESZ
  const TLIA = ((SC2X_X*2)+1)*ESZ
  
  ' **** Inicio do código asm fixo para dobrar 256x192 ****
  asm        
    mov ESI,[PTORG]     ' ESI = Ponteiro de Origem
    mov EDI,[PTDST]     ' EDI = Ponteiro de Destino
    lodsd               ' \
    stosd               ' | Copia e aumenta
    stosd               ' | o primeiro Pixel
    mov [EDI+TLISS],EAX   ' | (borda)
    mov [EDI+TLIS],EAX   ' /
    ' *************** Primeira Linha (borda) **************
    mov ECX,PILIS         ' (255 pixels na linha (256-borda))
    _FLNEXTPOINT_:      ' Label de Próximo Pixel
    lodsd                ' Carrega Pixel central (E)
    mov EBX,[ESI]        ' Carrega Pixel Superior (B)
    mov EDX,[ESI]        ' Carrega Pixel Direito (F)
    cmp EBX,[ESI+OLIS]    ' \ Compara igualdade dos pixels B & H
    je _FLBEHODEF_      ' | Iguais? Entom pula para escala normal
    cmp [ESI-TPI],EDX      ' | Compara igualgade dos pixels D & F
    je _FLBEHODEF_      ' / Iguais? Entom pula para escala normal
    ' ************ 4 pontos da escala especial ************
    cmp EBX,[ESI-TPI]      ' Compara Pixels B & D       \
    je _FLNOCHGE0_      ' iguais entom E0 = D        | iif(B=D,D,E)
    mov EBX,EAX           ' diferentes entom E0 = E    |
    _FLNOCHGE0_:        ' Label Qndo Iguais (ignora) /
    mov [EDI],EBX        ' Coloca ponto E0 (superior esquerdo) no buffer de destino 
    cmp [ESI],EDX        ' Compara Pixels B & F       \
    je _FLNOCHGE1_      ' Iguais? entom E1=F         | iif(B=F,F,E)
    mov EDX,EAX           ' Diferentes? entom E1 = E   |
    _FLNOCHGE1_:        ' Label qndo iguais (ignora) /
    mov [EDI+OPI],EDX      ' Coloca ponto E1 (superior direito) no buffer de destino
    mov EBX,[ESI-TPI]      ' Carrega Pixel Esquerdo (D)
    mov EDX,[ESI+OLIS]    ' Carrega Pixel Inferior (H)
    cmp EBX,EDX           ' Compara Pixels H & D       \
    je _FLNOCHGE2_      ' Iguais? entom E2=D         | iif(H=D,D,E)
    mov EBX,EAX           ' Diferentes? entom E2=E     |
    _FLNOCHGE2_:        ' Label qndo iguais (ignora) /
    mov [EDI+TLI],EBX   ' Coloca ponto E2 (inferior esquerdo) no buffer de destino
    cmp EDX,[ESI]        ' Compara Pixels H & F       \
    je _FLNOCHGE3_      ' Iguais entom E3=F          | iif(H=F,F,E)
    mov EDX,EAX           ' Diferentes? entom E3=E     |
    _FLNOCHGE3_:        ' Label qndo iguais (ignora) /
    mov [EDI+TLIA],EDX   ' Coloca ponto E3 (inferior direito) no buffer de destino
    add EDI,TPI           ' Aponta para próximo pixel de destino
    dec ECX             ' \ Próximo pixel da linha
    jnz _FLNEXTPOINT_   ' / até que termine
    add EDI,TLI        ' Aponta para próxima linha de destino
    dec dword ptr [Y]   ' \ Próximo linha
    jnz _SC32NEXTLINE_      ' / (adianta pq 1ª linha = borda)
    ' ************ 4 pontos da escala normal ************
    _FLBEHODEF_:        ' Label para escala normal
    stosd               ' \
    stosd               ' | Coloca os 4 pontos no buffer de destino
    mov [EDI+TLISS],EAX   ' | E0,E1,E2,E3 ( = E (ponto central )
    mov [EDI+TLIS],EAX   ' /
    dec ECX             ' \ Próximo pixel da linha
    jnz _FLNEXTPOINT_   ' / até que termine   
    add EDI,TLI        ' Aponta para próxima linha de destino
    dec dword ptr [Y]   ' \ Próximo linha
    ' ***************** Linhas Seguintes *****************
    _SC32NEXTLINE_:         ' Label de próxima linha
    mov ECX,PILI         ' 256 pixels (borda provisória)
    _NEXTPOINT_:        ' Label de Próximo Ponto
    lodsd               ' Carrega Pixel central (E)
    mov EBX,[ESI-OLIA]    ' Carrega Pixel Superior (B)
    mov EDX,[ESI]        ' Carrega Pixel Direito (F)
    cmp EBX,[ESI+OLIS]    ' \ Compara igualdade dos pixels B & H
    je _BEHODEF_        ' | Iguais? Entom pula para escala normal
    cmp [ESI-TPI],EDX      ' | Compara igualgade dos pixels D & F
    je _BEHODEF_        ' / Iguais? Entom pula para escala normal
    ' ************ 4 pontos da escala especial ************
    cmp EBX,[ESI-TPI]      ' Compara Pixels B & D       \
    je _NOCHGE0_        ' iguais entom E0 = D        | iif(B=D,D,E)
    mov EBX,EAX           ' diferentes entom E0 = E    |
    _NOCHGE0_:          ' Label Qndo Iguais (ignora) /
    mov [EDI],EBX        ' Coloca ponto E0 (superior esquerdo) no buffer de destino
    cmp [ESI-OLIA],EDX    ' Compara Pixels B & F       \
    je _NOCHGE1_        ' Iguais? entom E1=F         | iif(B=F,F,E)
    mov EDX,EAX           ' Diferentes? entom E1 = E   |
    _NOCHGE1_:          ' Label qndo iguais (ignora) /
    mov [EDI+OPI],EDX      ' Coloca ponto E1 (superior direito) no buffer de destino
    mov EBX,[ESI-TPI]      ' Carrega Pixel Esquerdo (D)
    mov EDX,[ESI+OLIS]    ' Carrega Pixel Inferior (H)
    cmp EBX,EDX           ' Compara Pixels H & D       \
    je _NOCHGE2_        ' Iguais? entom E2=D         | iif(H=D,D,E)
    mov EBX,EAX           ' Diferentes? entom E2 = E   |
    _NOCHGE2_:          ' Label qndo iguais (ignora) /
    mov [EDI+TLI],EBX   ' Coloca ponto E2 (inferior esquerdo) no buffer de destino
    cmp EDX,[ESI]        ' Compara Pixels H & F       \
    je _NOCHGE3_        ' Iguais entom E3=F          | iif(H=F,F,E)
    mov EDX,EAX           ' Diferentes? entom E3 = E   |
    _NOCHGE3_:          ' Label qndo iguais (ignora) /
    mov [EDI+TLIA],EDX   ' Coloca ponto E3 (inferior direito) no buffer de destino
    add EDI,TPI           ' Aponta para próximo pixel de destino
    dec ECX             ' \ Próximo pixel da linha
    jnz _NEXTPOINT_     ' / até que termine
    add EDI,TLI        ' Aponta para próxima linha de destino
    dec dword ptr [Y]   ' \ Próxima linha
    jnz _SC32NEXTLINE_      ' / das 191 restantes (menos borda)
    jmp _FINALEND_      ' Vai para o fim caso termine com escala especial
    ' ************ 4 pontos da escala normal ************
    _BEHODEF_:          ' Label de Escala Normal
    stosd               ' \
    stosd               ' | Coloca os 4 pontos no buffer de destino
    mov [EDI+TLISS],EAX   ' | E0,E1,E2,E3 ( = E (ponto central )
    mov [EDI+TLIS],EAX   ' /
    dec ECX             ' \ Próximo pixel da linha
    jnz _NEXTPOINT_     ' / até que termine
    add EDI,TLI        ' Aponta para próxima linha de destino
    dec dword ptr [Y]   ' \ Próxima linha
    jnz _SC32NEXTLINE_      ' / das 191 restantes (menos borda)
    _FINALEND_:         ' Label de fim =)
  end asm  
end sub
end namespace