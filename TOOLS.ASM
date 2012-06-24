	ifndef	??version
?debug	macro
	endm
publicdll macro	name
	public	name
	endm
$comm	macro	name,dist,size,count
	comm	dist name:BYTE:count*size
	endm
	else
$comm	macro	name,dist,size,count
	comm	dist name[size]:BYTE:count
	endm
	endif
	?debug	V 300h
	?debug	S "tools.c"
	?debug	C E9C3A9742407746F6F6C732E63
	?debug	C E9B4A97424112E2F696E636C7564652F746F6F6C732E68
_TEXT	segment byte public 'CODE'
_TEXT	ends
DGROUP	group	_DATA,_BSS
	assume	cs:_TEXT,ds:DGROUP
_DATA	segment word public 'DATA'
d@	label	byte
d@w	label	word
_DATA	ends
_BSS	segment word public 'BSS'
b@	label	byte
b@w	label	word
_BSS	ends
_DATA	segment word public 'DATA'
_VRAM	label	dword
	db	0
	db	0
	db	0
	db	184
TIMER	label	dword
	db	108
	db	0
	db	64
	db	0
_DATA	ends
_TEXT	segment byte public 'CODE'
   ;	
   ;	void print(char* Text)
   ;	
	assume	cs:_TEXT
@PRINT$QPZC	proc	near
	push	bp
	mov	bp,sp
	push	si
   ;	
   ;	{
   ;	    asm mov si, Text
   ;	
 	mov	 si, [bp+4]
   ;	
   ;	    asm mov bl, 7
   ;	
 	mov	 bl, 7
@1@86:
   ;	
   ;	  Weiter:
   ;	    asm lodsb
   ;	
 	lodsb	
   ;	
   ;	    asm cmp al, 0
   ;	
 	cmp	 al, 0
   ;	
   ;	    asm je raus
   ;	
	je	short @1@254
   ;	
   ;	    asm mov ah, 0x0e
   ;	
 	mov	 ah, 00eH
   ;	
   ;	    asm int 0x10
   ;	
 	int	 010H
   ;	
   ;	    asm jmp Weiter
   ;	
	jmp	short @1@86
@1@254:
   ;	
   ;	  raus:
   ;	}
   ;	
	pop	si
	pop	bp
	ret	2
@PRINT$QPZC	endp
   ;	
   ;	void printz(char Ziffer)
   ;	
	assume	cs:_TEXT
@PRINTZ$QZC	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	    asm mov bl, 7
   ;	
 	mov	 bl, 7
   ;	
   ;	    asm mov al, Ziffer
   ;	
 	mov	 al, [bp+4]
   ;	
   ;	    asm add al, 48
   ;	
 	add	 al, 48
   ;	
   ;	    asm mov ah, 0x0e
   ;	
 	mov	 ah, 00eH
   ;	
   ;	    asm int 0x10
   ;	
 	int	 010H
   ;	
   ;	}
   ;	
	pop	bp
	ret	2
@PRINTZ$QZC	endp
   ;	
   ;	void printb(char Byte)
   ;	
	assume	cs:_TEXT
@PRINTB$QZC	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
   ;	
   ;	{
   ;	  char h = Byte/100;
   ;	
	mov	al,byte ptr [bp+4]
	cbw	
	mov	bx,100
	cwd	
	idiv	bx
	mov	byte ptr [bp-1],al
   ;	
   ;	  char z = (Byte%100)/10;
   ;	
	mov	al,byte ptr [bp+4]
	cbw	
	mov	bx,100
	cwd	
	idiv	bx
	mov	bx,10
	mov	ax,dx
	cwd	
	idiv	bx
	mov	byte ptr [bp-2],al
   ;	
   ;	  char e = Byte % 10;
   ;	
	mov	al,byte ptr [bp+4]
	cbw	
	mov	bx,10
	cwd	
	idiv	bx
	mov	byte ptr [bp-3],dl
   ;	
   ;	
   ;	  if (h>0) printz(h);
   ;	
	cmp	byte ptr [bp-1],0
	jle	short @3@86
	mov	al,byte ptr [bp-1]
	push	ax
	call	near ptr @PRINTZ$QZC
@3@86:
   ;	
   ;	  if (z>0) printz(z);
   ;	
	cmp	byte ptr [bp-2],0
	jle	short @3@142
	mov	al,byte ptr [bp-2]
	push	ax
	call	near ptr @PRINTZ$QZC
@3@142:
   ;	
   ;	  printz(e);
   ;	
	mov	al,byte ptr [bp-3]
	push	ax
	call	near ptr @PRINTZ$QZC
   ;	
   ;	}
   ;	
	mov	sp,bp
	pop	bp
	ret	2
@PRINTB$QZC	endp
   ;	
   ;	void ret()
   ;	
	assume	cs:_TEXT
@RET$QV	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  print("\n\r");
   ;	
	mov	ax,offset DGROUP:s@
	push	ax
	call	near ptr @PRINT$QPZC
   ;	
   ;	}
   ;	
	pop	bp
	ret	
@RET$QV	endp
   ;	
   ;	void clrscr()
   ;	
	assume	cs:_TEXT
@CLRSCR$QV	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  asm {
   ;	    mov ah, 0x0f
   ;	
	mov	 ah, 00fH
   ;	
   ;	    int 0x10 // Get video mode (in al)
   ;	
	int	 010H 
   ;	
   ;	
   ;	    mov ah, 0
   ;	
	mov	 ah, 0
   ;	
   ;	    int 0x10
   ;	
	int	 010H
   ;	
   ;	  }
   ;	}
   ;	
	pop	bp
	ret	
@CLRSCR$QV	endp
   ;	
   ;	int kbhit()
   ;	
	assume	cs:_TEXT
@KBHIT$QV	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  asm mov ah, 1
   ;	
 	mov	 ah, 1
   ;	
   ;	  asm int 16h
   ;	
 	int	 16h
   ;	
   ;	  asm jnz Vorhanden
   ;	
	jne	short @6@170
   ;	
   ;	
   ;	 NichtVorhanden:
   ;	  return 0;
   ;	
	xor	ax,ax
@6@142:
	jmp	short @6@198
@6@170:
   ;	
   ;	
   ;	 Vorhanden:
   ;	  return 1;
   ;	
	mov	ax,1
	jmp	short @6@142
@6@198:
   ;	
   ;	}
   ;	
	pop	bp
	ret	
@KBHIT$QV	endp
   ;	
   ;	int getch()
   ;	
	assume	cs:_TEXT
@GETCH$QV	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  asm mov ah, 0
   ;	
 	mov	 ah, 0
   ;	
   ;	  asm int 16h
   ;	
 	int	 16h
   ;	
   ;	  asm cmp al, 0
   ;	
 	cmp	 al, 0
   ;	
   ;	  asm je Extended
   ;	
	je	short @7@170
   ;	
   ;	  asm xor ah, ah /* Scancode verwerfen */
   ;	
 	xor	 ah, ah 
@7@170:
   ;	
   ;	
   ;	  Extended:
   ;	
   ;	}
   ;	
	pop	bp
	ret	
@GETCH$QV	endp
   ;	
   ;	void invert(int line)
   ;	
	assume	cs:_TEXT
@INVERT$QI	proc	near
	push	bp
	mov	bp,sp
	sub	sp,2
	push	si
	push	di
	mov	di,word ptr [bp+4]
   ;	
   ;	{
   ;	  int x=0;
   ;	
	xor	si,si
	jmp	short @8@114
@8@58:
   ;	
   ;	
   ;	  for (; x<80; x++)
   ;	  {
   ;	    char Old = *(&VRAM(x,line)+1);
   ;	
	mov	ax,di
	mov	dx,160
	imul	dx
	mov	dx,si
	shl	dx,1
	add	ax,dx
	mov	es,word ptr DGROUP:_VRAM+2
	add	ax,word ptr DGROUP:_VRAM
	mov	bx,ax
	mov	al,byte ptr es:[bx+1]
	mov	byte ptr [bp-1],al
   ;	
   ;	    *(&VRAM(x,line)+1) = (Old >> 4) + 16*(Old & 15);
   ;	
	mov	al,byte ptr [bp-1]
	cbw	
	mov	cl,4
	sar	ax,cl
	mov	dl,byte ptr [bp-1]
	and	dl,15
	mov	cl,4
	shl	dl,cl
	add	al,dl
	push	ax
	mov	ax,di
	mov	dx,160
	imul	dx
	mov	dx,si
	shl	dx,1
	add	ax,dx
	mov	es,word ptr DGROUP:_VRAM+2
	add	ax,word ptr DGROUP:_VRAM
	mov	bx,ax
	pop	ax
	mov	byte ptr es:[bx+1],al
	inc	si
@8@114:
	cmp	si,80
	jl	short @8@58
   ;	
   ;	  }
   ;	}
   ;	
	pop	di
	pop	si
	mov	sp,bp
	pop	bp
	ret	2
@INVERT$QI	endp
   ;	
   ;	void color(int line, char c)
   ;	
	assume	cs:_TEXT
@COLOR$QIZC	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  int x=0;
   ;	
	xor	cx,cx
	jmp	short @9@114
@9@58:
   ;	
   ;	
   ;	  for (; x<80; x++)
   ;	  {
   ;	    *(&VRAM(x,line)+1) = c;
   ;	
	mov	ax,word ptr [bp+6]
	mov	dx,160
	imul	dx
	mov	dx,cx
	shl	dx,1
	add	ax,dx
	mov	es,word ptr DGROUP:_VRAM+2
	add	ax,word ptr DGROUP:_VRAM
	mov	dl,byte ptr [bp+4]
	mov	bx,ax
	mov	byte ptr es:[bx+1],dl
	inc	cx
@9@114:
	cmp	cx,80
	jl	short @9@58
   ;	
   ;	  }
   ;	}
   ;	
	pop	bp
	ret	4
@COLOR$QIZC	endp
   ;	
   ;	strcpy(char* dest, char* src)
   ;	
	assume	cs:_TEXT
@STRCPY$QPZCT1	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	di,word ptr [bp+6]
	mov	si,word ptr [bp+4]
	jmp	short @10@86
@10@58:
   ;	
   ;	{
   ;	  while (*src!=0)
   ;	  {
   ;	    *dest = *src;
   ;	
	mov	al,byte ptr [si]
	mov	byte ptr [di],al
   ;	
   ;	    dest++;
   ;	
	inc	di
   ;	
   ;	    src++;
   ;	
	inc	si
@10@86:
	cmp	byte ptr [si],0
	jne	short @10@58
   ;	
   ;	  }
   ;	
   ;	  *dest = *src; // 0 kopieren
   ;	
	mov	al,byte ptr [si]
	mov	byte ptr [di],al
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	4
@STRCPY$QPZCT1	endp
   ;	
   ;	int HDDRead(char drv, char head, char zyl, char sec, char num, void far* Buf)
   ;	
	assume	cs:_TEXT
@HDDREAD$QZCZCZCZCZCNV	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  asm {
   ;	  mov dx, word ptr Buf+2
   ;	
	mov	 dx, word ptr [bp+4]+2
   ;	
   ;	  mov es, dx
   ;	
	mov	 es, dx
   ;	
   ;	
   ;	  mov dl, drv
   ;	
	mov	 dl, [bp+16]
   ;	
   ;	  mov dh, head
   ;	
	mov	 dh, [bp+14]
   ;	
   ;	  mov ch, zyl
   ;	
	mov	 ch, [bp+12]
   ;	
   ;	  mov cl, sec
   ;	
	mov	 cl, [bp+10]
   ;	
   ;	  mov al, num
   ;	
	mov	 al, [bp+8]
   ;	
   ;	  mov bx, word ptr Buf
   ;	
	mov	 bx, word ptr [bp+4]
   ;	
   ;	  mov ah, 2
   ;	
	mov	 ah, 2
   ;	
   ;	  int 0x13
   ;	
	int	 013H
   ;	
   ;	  mov al, ah
   ;	
	mov	 al, ah
   ;	
   ;	  mov ah, 0
   ;	
	mov	 ah, 0
   ;	
   ;	  jnc Fehler
   ;	
	jnc	short @11@422
   ;	
   ;	  xor ax, ax
   ;	
	xor	 ax, ax
@11@422:
   ;	
   ;	  }
   ;	
   ;	 Fehler:
   ;	}
   ;	
	pop	bp
	ret	14
@HDDREAD$QZCZCZCZCZCNV	endp
   ;	
   ;	int HDDWrite(char drv, char head, char zyl, char sec, char num,
   ;	
	assume	cs:_TEXT
@HDDWRITE$QZCZCZCZCZCNV	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	             void far* Buf)
   ;	{
   ;	  asm mov dx, word ptr Buf+2
   ;	
 	mov	 dx, word ptr [bp+4]+2
   ;	
   ;	  asm mov es, dx
   ;	
 	mov	 es, dx
   ;	
   ;	
   ;	  asm mov dl, drv
   ;	
 	mov	 dl, [bp+16]
   ;	
   ;	  asm mov dh, head
   ;	
 	mov	 dh, [bp+14]
   ;	
   ;	  asm mov ch, zyl
   ;	
 	mov	 ch, [bp+12]
   ;	
   ;	  asm mov cl, sec
   ;	
 	mov	 cl, [bp+10]
   ;	
   ;	  asm mov al, num
   ;	
 	mov	 al, [bp+8]
   ;	
   ;	  asm mov bx, word ptr Buf
   ;	
 	mov	 bx, word ptr [bp+4]
   ;	
   ;	  asm mov ah, 3
   ;	
 	mov	 ah, 3
   ;	
   ;	  asm int 13h
   ;	
 	int	 13h
   ;	
   ;	  asm mov al, ah
   ;	
 	mov	 al, ah
   ;	
   ;	  asm mov ah, 0
   ;	
 	mov	 ah, 0
   ;	
   ;	  asm jnc Fehler
   ;	
	jnc	short @12@422
   ;	
   ;	  asm xor ax, ax
   ;	
 	xor	 ax, ax
@12@422:
   ;	
   ;	
   ;	 Fehler:
   ;	}
   ;	
	pop	bp
	ret	14
@HDDWRITE$QZCZCZCZCZCNV	endp
   ;	
   ;	delay(int Ticks)
   ;	
	assume	cs:_TEXT
@DELAY$QI	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
   ;	
   ;	{
   ;	  unsigned long Target=*Timer + Ticks;
   ;	
	mov	ax,word ptr [bp+4]
	cwd	
	les	bx,dword ptr DGROUP:TIMER
	mov	cx,word ptr es:[bx+2]
	mov	bx,word ptr es:[bx]
	add	bx,ax
	adc	cx,dx
	mov	word ptr [bp-2],cx
	mov	word ptr [bp-4],bx
	jmp	short @13@58
@13@58:
   ;	
   ;	
   ;	  while (*Timer<Target);
   ;	
	les	bx,dword ptr DGROUP:TIMER
	mov	ax,word ptr es:[bx+2]
	mov	dx,word ptr es:[bx]
	cmp	ax,word ptr [bp-2]
	jb	short @13@58
	jne	short @13@142
	cmp	dx,word ptr [bp-4]
	jb	short @13@58
@13@142:
   ;	
   ;	}
   ;	
	mov	sp,bp
	pop	bp
	ret	2
@DELAY$QI	endp
   ;	
   ;	char random()
   ;	
	assume	cs:_TEXT
@RANDOM$QV	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  return *Timer & 0x03;
   ;	
	les	bx,dword ptr DGROUP:TIMER
	mov	al,byte ptr es:[bx]
	and	al,3
	jmp	short @14@58
@14@58:
   ;	
   ;	}
   ;	
	pop	bp
	ret	
@RANDOM$QV	endp
   ;	
   ;	void gotoxy(char x, char y)
   ;	
	assume	cs:_TEXT
@GOTOXY$QZCZC	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  asm {
   ;	    mov ah, 2
   ;	
	mov	 ah, 2
   ;	
   ;	    mov bh, 0
   ;	
	mov	 bh, 0
   ;	
   ;	    mov dh, y
   ;	
	mov	 dh, [bp+4]
   ;	
   ;	    mov dl, x
   ;	
	mov	 dl, [bp+6]
   ;	
   ;	    int 0x10
   ;	
	int	 010H
   ;	
   ;	  }
   ;	}
   ;	
	pop	bp
	ret	4
@GOTOXY$QZCZC	endp
   ;	
   ;	char cursorx()
   ;	
	assume	cs:_TEXT
@CURSORX$QV	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  asm {
   ;	    mov ah, 3
   ;	
	mov	 ah, 3
   ;	
   ;	    mov bh, 0
   ;	
	mov	 bh, 0
   ;	
   ;	    int 0x10
   ;	
	int	 010H
   ;	
   ;	    mov al, dl
   ;	
	mov	 al, dl
   ;	
   ;	  }
   ;	}
   ;	
	pop	bp
	ret	
@CURSORX$QV	endp
   ;	
   ;	char cursory()
   ;	
	assume	cs:_TEXT
@CURSORY$QV	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  asm {
   ;	    mov ah, 3
   ;	
	mov	 ah, 3
   ;	
   ;	    mov bh, 0
   ;	
	mov	 bh, 0
   ;	
   ;	    int 0x10
   ;	
	int	 010H
   ;	
   ;	    mov al, dh
   ;	
	mov	 al, dh
   ;	
   ;	  }
   ;	}
   ;	
	pop	bp
	ret	
@CURSORY$QV	endp
	?debug	C E9
	?debug	C FA00000000
_TEXT	ends
_DATA	segment word public 'DATA'
s@	label	byte
	db	10
	db	13
	db	0
_DATA	ends
_TEXT	segment byte public 'CODE'
_TEXT	ends
	public	@HDDWRITE$QZCZCZCZCZCNV
	public	@HDDREAD$QZCZCZCZCZCNV
	public	@STRCPY$QPZCT1
	public	@KBHIT$QV
	public	@GETCH$QV
	public	@RANDOM$QV
	public	@DELAY$QI
	public	TIMER
	public	_VRAM
	public	@CLRSCR$QV
	public	@CURSORY$QV
	public	@CURSORX$QV
	public	@GOTOXY$QZCZC
	public	@RET$QV
	public	@COLOR$QIZC
	public	@INVERT$QI
	public	@PRINTB$QZC
	public	@PRINTZ$QZC
	public	@PRINT$QPZC
_s@	equ	s@
	end
