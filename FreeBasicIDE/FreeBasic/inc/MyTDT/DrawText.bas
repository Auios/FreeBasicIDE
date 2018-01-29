sub OutlinedText(TARGET as any ptr ptr=0,PX as integer,PY as integer,TEXT as string,COR as integer,BORDER as integer=0)  
  draw string TARGET,(PX-1,PY-1),TEXT,BORDER
  draw string TARGET,(PX+1,PY-1),TEXT,BORDER
  draw string TARGET,(PX-1,PY+1),TEXT,BORDER
  draw string TARGET,(PX+1,PY+1),TEXT,BORDER
  draw string TARGET,(PX-1,PY),TEXT,BORDER
  draw string TARGET,(PX+1,PY),TEXT,BORDER
  draw string TARGET,(PX,PY-1),TEXT,BORDER
  draw string TARGET,(PX,PY+1),TEXT,BORDER
  draw string TARGET,(PX,PY),TEXT,COR
end sub
