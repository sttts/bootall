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
	?debug	S "copy.c"
	?debug	C E92DA2A62206636F70792E63
	?debug	C E929A2A622102E2F696E636C7564652F636F70792E68
	?debug	C E9B4A97424112E2F696E636C7564652F746F6F6C732E68
	?debug	C E9B6A6AB2608636F70792E736372
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
COPYRIGHT	label	byte
	db	15
	db	16
	db	24
	db	24
	db	24
	db	24
	db	24
	db	25
	db	2
	db	9
	db	218
	db	1
	db	26
	db	5
	db	196
	db	9
	db	196
	db	15
	db	191
	db	32
	db	32
	db	9
	db	218
	db	1
	db	26
	db	5
	db	196
	db	9
	db	196
	db	15
	db	191
	db	32
	db	32
	db	9
	db	218
	db	1
	db	26
	db	5
	db	196
	db	9
	db	196
	db	15
	db	191
	db	32
	db	32
	db	9
	db	218
	db	1
	db	26
	db	5
	db	196
	db	9
	db	196
	db	15
	db	191
	db	25
	db	7
	db	9
	db	66
	db	15
	db	111
	db	111
	db	116
	db	32
	db	9
	db	65
	db	15
	db	108
	db	108
	db	32
	db	9
	db	57
	db	15
	db	55
	db	24
	db	25
	db	2
	db	192
	db	9
	db	196
	db	1
	db	26
	db	5
	db	196
	db	9
	db	217
	db	32
	db	32
	db	15
	db	192
	db	9
	db	196
	db	1
	db	26
	db	5
	db	196
	db	9
	db	217
	db	32
	db	32
	db	15
	db	192
	db	9
	db	196
	db	1
	db	26
	db	5
	db	196
	db	9
	db	217
	db	32
	db	32
	db	15
	db	192
	db	9
	db	196
	db	1
	db	26
	db	5
	db	196
	db	9
	db	217
	db	24
	db	25
	db	2
	db	1
	db	218
	db	26
	db	5
	db	196
	db	9
	db	196
	db	15
	db	191
	db	32
	db	32
	db	1
	db	218
	db	196
	db	191
	db	25
	db	2
	db	218
	db	9
	db	196
	db	15
	db	191
	db	32
	db	32
	db	1
	db	218
	db	196
	db	191
	db	25
	db	2
	db	218
	db	9
	db	196
	db	15
	db	191
	db	25
	db	4
	db	1
	db	218
	db	9
	db	196
	db	15
	db	191
	db	25
	db	10
	db	9
	db	80
	db	15
	db	114
	db	111
	db	103
	db	114
	db	97
	db	109
	db	109
	db	105
	db	110
	db	103
	db	58
	db	24
	db	25
	db	2
	db	1
	db	179
	db	32
	db	9
	db	218
	db	1
	db	196
	db	196
	db	9
	db	196
	db	15
	db	191
	db	32
	db	9
	db	179
	db	32
	db	32
	db	1
	db	179
	db	32
	db	9
	db	179
	db	25
	db	2
	db	1
	db	179
	db	32
	db	9
	db	179
	db	32
	db	32
	db	1
	db	179
	db	32
	db	9
	db	179
	db	25
	db	2
	db	1
	db	179
	db	32
	db	9
	db	179
	db	25
	db	4
	db	1
	db	179
	db	32
	db	9
	db	179
	db	25
	db	11
	db	83
	db	15
	db	46
	db	32
	db	9
	db	83
	db	15
	db	99
	db	104
	db	105
	db	109
	db	97
	db	110
	db	115
	db	107
	db	105
	db	24
	db	25
	db	2
	db	9
	db	179
	db	32
	db	15
	db	192
	db	9
	db	196
	db	1
	db	196
	db	196
	db	9
	db	217
	db	32
	db	1
	db	179
	db	32
	db	32
	db	9
	db	179
	db	32
	db	15
	db	192
	db	9
	db	196
	db	1
	db	196
	db	196
	db	217
	db	32
	db	179
	db	32
	db	32
	db	9
	db	179
	db	32
	db	15
	db	192
	db	9
	db	196
	db	1
	db	196
	db	196
	db	217
	db	32
	db	179
	db	25
	db	4
	db	9
	db	179
	db	32
	db	1
	db	179
	db	25
	db	11
	db	9
	db	49
	db	15
	db	115
	db	116
	db	101
	db	105
	db	110
	db	64
	db	103
	db	109
	db	120
	db	46
	db	110
	db	101
	db	116
	db	24
	db	25
	db	2
	db	192
	db	9
	db	196
	db	1
	db	26
	db	5
	db	196
	db	217
	db	32
	db	32
	db	15
	db	192
	db	9
	db	196
	db	1
	db	26
	db	5
	db	196
	db	217
	db	32
	db	32
	db	15
	db	192
	db	9
	db	196
	db	1
	db	26
	db	5
	db	196
	db	217
	db	25
	db	4
	db	15
	db	192
	db	9
	db	196
	db	1
	db	217
	db	24
	db	9
	db	218
	db	1
	db	26
	db	5
	db	196
	db	9
	db	196
	db	15
	db	191
	db	32
	db	32
	db	9
	db	218
	db	196
	db	15
	db	191
	db	25
	db	7
	db	9
	db	218
	db	196
	db	15
	db	191
	db	25
	db	7
	db	2
	db	218
	db	26
	db	4
	db	196
	db	10
	db	196
	db	15
	db	191
	db	10
	db	218
	db	2
	db	26
	db	4
	db	196
	db	10
	db	196
	db	15
	db	191
	db	25
	db	3
	db	9
	db	76
	db	15
	db	97
	db	121
	db	111
	db	117
	db	116
	db	58
	db	24
	db	192
	db	9
	db	196
	db	1
	db	26
	db	5
	db	196
	db	9
	db	217
	db	32
	db	32
	db	15
	db	192
	db	9
	db	196
	db	217
	db	25
	db	7
	db	15
	db	192
	db	9
	db	196
	db	217
	db	25
	db	7
	db	2
	db	179
	db	32
	db	10
	db	218
	db	2
	db	196
	db	10
	db	196
	db	15
	db	191
	db	32
	db	10
	db	179
	db	15
	db	192
	db	10
	db	196
	db	2
	db	196
	db	196
	db	10
	db	196
	db	15
	db	191
	db	32
	db	10
	db	179
	db	25
	db	4
	db	9
	db	74
	db	15
	db	46
	db	32
	db	9
	db	72
	db	15
	db	101
	db	105
	db	108
	db	103
	db	101
	db	105
	db	115
	db	116
	db	24
	db	1
	db	218
	db	26
	db	5
	db	196
	db	9
	db	196
	db	15
	db	191
	db	32
	db	32
	db	1
	db	218
	db	9
	db	196
	db	15
	db	191
	db	25
	db	7
	db	1
	db	218
	db	9
	db	196
	db	15
	db	191
	db	25
	db	7
	db	10
	db	179
	db	32
	db	15
	db	192
	db	10
	db	196
	db	2
	db	196
	db	10
	db	217
	db	32
	db	2
	db	179
	db	25
	db	3
	db	218
	db	10
	db	217
	db	2
	db	218
	db	217
	db	25
	db	4
	db	9
	db	104
	db	15
	db	101
	db	105
	db	108
	db	103
	db	101
	db	105
	db	115
	db	116
	db	64
	db	116
	db	45
	db	111
	db	110
	db	108
	db	105
	db	110
	db	101
	db	46
	db	100
	db	101
	db	24
	db	1
	db	179
	db	32
	db	218
	db	196
	db	196
	db	196
	db	191
	db	32
	db	9
	db	179
	db	32
	db	32
	db	1
	db	179
	db	32
	db	9
	db	179
	db	25
	db	7
	db	1
	db	179
	db	32
	db	9
	db	179
	db	25
	db	7
	db	15
	db	192
	db	10
	db	196
	db	2
	db	196
	db	196
	db	10
	db	196
	db	15
	db	191
	db	32
	db	2
	db	179
	db	25
	db	2
	db	218
	db	217
	db	218
	db	217
	db	24
	db	9
	db	179
	db	32
	db	1
	db	179
	db	25
	db	2
	db	9
	db	179
	db	32
	db	1
	db	179
	db	32
	db	32
	db	9
	db	179
	db	32
	db	1
	db	192
	db	26
	db	3
	db	196
	db	9
	db	196
	db	15
	db	191
	db	32
	db	32
	db	9
	db	179
	db	32
	db	1
	db	192
	db	26
	db	3
	db	196
	db	9
	db	196
	db	15
	db	191
	db	32
	db	32
	db	10
	db	218
	db	2
	db	26
	db	3
	db	196
	db	10
	db	217
	db	32
	db	2
	db	179
	db	32
	db	32
	db	10
	db	218
	db	2
	db	217
	db	218
	db	217
	db	25
	db	5
	db	9
	db	82
	db	15
	db	101
	db	103
	db	105
	db	115
	db	116
	db	101
	db	114
	db	101
	db	100
	db	32
	db	9
	db	116
	db	15
	db	111
	db	58
	db	24
	db	192
	db	9
	db	196
	db	1
	db	217
	db	25
	db	2
	db	15
	db	192
	db	9
	db	196
	db	1
	db	217
	db	32
	db	32
	db	15
	db	192
	db	9
	db	196
	db	1
	db	26
	db	5
	db	196
	db	9
	db	217
	db	32
	db	32
	db	15
	db	192
	db	9
	db	196
	db	1
	db	26
	db	5
	db	196
	db	9
	db	217
	db	32
	db	32
	db	15
	db	192
	db	10
	db	196
	db	2
	db	26
	db	4
	db	196
	db	217
	db	32
	db	32
	db	15
	db	192
	db	10
	db	196
	db	2
	db	217
	db	25
	db	7
	db	15
	db	82
	db	97
	db	105
	db	110
	db	101
	db	114
	db	32
	db	78
	db	97
	db	117
	db	115
	db	101
	db	100
	db	97
	db	116
	db	24
	db	24
	db	25
	db	3
	db	86
	db	105
	db	115
	db	105
	db	116
	db	32
	db	117
	db	115
	db	32
	db	97
	db	116
	db	58
	db	32
	db	104
	db	116
	db	116
	db	112
	db	58
	db	47
	db	47
	db	49
	db	83
	db	116
	db	101
	db	105
	db	110
	db	46
	db	104
	db	111
	db	109
	db	101
	db	46
	db	112
	db	97
	db	103
	db	101
	db	115
	db	46
	db	100
	db	101
	db	24
	db	24
	db	24
	db	24
	db	24
	db	24
	db	24
_DATA	ends
_TEXT	segment byte public 'CODE'
   ;	
   ;	void ShowCopyright()
   ;	
	assume	cs:_TEXT
@SHOWCOPYRIGHT$QV	proc	near
	push	bp
	mov	bp,sp
	sub	sp,10
	push	si
	push	di
   ;	
   ;	{
   ;	  clrscr();
   ;	
	call	near ptr @CLRSCR$QV
   ;	
   ;	
   ;	  char f=7; // Foreground
   ;	
	mov	byte ptr [bp-1],7
   ;	
   ;	  char b=0; // Background
   ;	
	mov	byte ptr [bp-2],0
   ;	
   ;	  char x=0;
   ;	
	mov	byte ptr [bp-3],0
   ;	
   ;	  char y=0;
   ;	
	mov	byte ptr [bp-4],0
   ;	
   ;	
   ;	  for (int p=0; p<COPYRIGHT_LENGTH; p++)
   ;	
	xor	si,si
	jmp	@1@842
@1@58:
   ;	
   ;	  {
   ;	    unsigned char c=COPYRIGHT[p];
   ;	
	mov	al,byte ptr DGROUP:COPYRIGHT[si]
	mov	byte ptr [bp-9],al
   ;	
   ;	
   ;	    if (c>=32)
   ;	
	cmp	byte ptr [bp-9],32
	jb	short @1@170
   ;	
   ;	    {
   ;	      VRAM(x,y)=c;
   ;	
	mov	al,byte ptr [bp-4]
	cbw	
	mov	dx,160
	imul	dx
	push	ax
	mov	al,byte ptr [bp-3]
	cbw	
	shl	ax,1
	pop	bx
	add	bx,ax
	mov	es,word ptr DGROUP:_VRAM+2
	add	bx,word ptr DGROUP:_VRAM
	mov	al,byte ptr [bp-9]
	mov	byte ptr es:[bx],al
   ;	
   ;	      CVRAM(x,y)=f+b*16;
   ;	
	mov	al,byte ptr [bp-4]
	cbw	
	mov	dx,160
	imul	dx
	push	ax
	mov	al,byte ptr [bp-3]
	cbw	
	shl	ax,1
	pop	bx
	add	bx,ax
	mov	es,word ptr DGROUP:_VRAM+2
	add	bx,word ptr DGROUP:_VRAM
	mov	al,byte ptr [bp-2]
	mov	cl,4
	shl	al,cl
	mov	dl,byte ptr [bp-1]
	add	dl,al
	mov	byte ptr es:[bx+1],dl
   ;	
   ;	      x++;
   ;	
	inc	byte ptr [bp-3]
   ;	
   ;	      if (x>=80) x=0;
   ;	
	cmp	byte ptr [bp-3],80
	jl	short @1@142
	mov	byte ptr [bp-3],0
@1@142:
   ;	
   ;	    } else
   ;	
	jmp	@1@814
@1@170:
   ;	
   ;	    if (c<16)
   ;	
	cmp	byte ptr [bp-9],16
	jae	short @1@226
   ;	
   ;	    {
   ;	      f=c;
   ;	
	mov	al,byte ptr [bp-9]
	mov	byte ptr [bp-1],al
   ;	
   ;	    } else
   ;	
	jmp	@1@814
@1@226:
   ;	
   ;	    if (c<24)
   ;	
	cmp	byte ptr [bp-9],24
	jae	short @1@282
   ;	
   ;	    {
   ;	      b=(b & 0x08)+c-16;
   ;	
	mov	al,byte ptr [bp-2]
	and	al,8
	add	al,byte ptr [bp-9]
	add	al,240
	mov	byte ptr [bp-2],al
   ;	
   ;	    } else
   ;	
	jmp	@1@814
@1@282:
   ;	
   ;	    switch (c)
   ;	
	mov	al,byte ptr [bp-9]
	mov	ah,0
	sub	ax,24
	mov	bx,ax
	cmp	bx,3
	jbe	@@0
	jmp	@1@786
@@0:
	shl	bx,1
	jmp	word ptr cs:@1@C1298[bx]
@1@366:
   ;	
   ;	    {
   ;	     case 24: x=0; y++; break;
   ;	
	mov	byte ptr [bp-3],0
	inc	byte ptr [bp-4]
	jmp	@1@814
@1@394:
   ;	
   ;	     case 25: p++;
   ;	
	inc	si
   ;	
   ;	              for (int z=COPYRIGHT[p]+1; z>0; z--)
   ;	
	mov	al,byte ptr DGROUP:COPYRIGHT[si]
	mov	ah,0
	inc	ax
	mov	di,ax
	jmp	short @1@534
@1@450:
   ;	
   ;	              {
   ;	                VRAM(x,y)=' ';
   ;	
	mov	al,byte ptr [bp-4]
	cbw	
	mov	dx,160
	imul	dx
	push	ax
	mov	al,byte ptr [bp-3]
	cbw	
	shl	ax,1
	pop	bx
	add	bx,ax
	mov	es,word ptr DGROUP:_VRAM+2
	add	bx,word ptr DGROUP:_VRAM
	mov	byte ptr es:[bx],32
   ;	
   ;	                CVRAM(x,y)=f+b*16;
   ;	
	mov	al,byte ptr [bp-4]
	cbw	
	mov	dx,160
	imul	dx
	push	ax
	mov	al,byte ptr [bp-3]
	cbw	
	shl	ax,1
	pop	bx
	add	bx,ax
	mov	es,word ptr DGROUP:_VRAM+2
	add	bx,word ptr DGROUP:_VRAM
	mov	al,byte ptr [bp-2]
	mov	cl,4
	shl	al,cl
	mov	dl,byte ptr [bp-1]
	add	dl,al
	mov	byte ptr es:[bx+1],dl
   ;	
   ;	                x++;
   ;	
	inc	byte ptr [bp-3]
   ;	
   ;	                if (x>=80) x=0;
   ;	
	cmp	byte ptr [bp-3],80
	jl	short @1@506
	mov	byte ptr [bp-3],0
@1@506:
	dec	di
@1@534:
	or	di,di
	jg	short @1@450
   ;	
   ;	              }
   ;	              break;
   ;	
	jmp	@1@814
@1@590:
   ;	
   ;	     case 26: p++;
   ;	
	inc	si
   ;	
   ;	              z=COPYRIGHT[p]+1;
   ;	
	mov	al,byte ptr DGROUP:COPYRIGHT[si]
	mov	ah,0
	inc	ax
	mov	di,ax
   ;	
   ;	              p++;
   ;	
	inc	si
   ;	
   ;	              c=COPYRIGHT[p];
   ;	
	mov	al,byte ptr DGROUP:COPYRIGHT[si]
	mov	byte ptr [bp-9],al
	jmp	short @1@702
@1@618:
   ;	
   ;	              for (; z>0; z--)
   ;	              {
   ;	                VRAM(x,y)=c;
   ;	
	mov	al,byte ptr [bp-4]
	cbw	
	mov	dx,160
	imul	dx
	push	ax
	mov	al,byte ptr [bp-3]
	cbw	
	shl	ax,1
	pop	bx
	add	bx,ax
	mov	es,word ptr DGROUP:_VRAM+2
	add	bx,word ptr DGROUP:_VRAM
	mov	al,byte ptr [bp-9]
	mov	byte ptr es:[bx],al
   ;	
   ;	                CVRAM(x,y)=f+b*16;
   ;	
	mov	al,byte ptr [bp-4]
	cbw	
	mov	dx,160
	imul	dx
	push	ax
	mov	al,byte ptr [bp-3]
	cbw	
	shl	ax,1
	pop	bx
	add	bx,ax
	mov	es,word ptr DGROUP:_VRAM+2
	add	bx,word ptr DGROUP:_VRAM
	mov	al,byte ptr [bp-2]
	mov	cl,4
	shl	al,cl
	mov	dl,byte ptr [bp-1]
	add	dl,al
	mov	byte ptr es:[bx+1],dl
   ;	
   ;	                x++;
   ;	
	inc	byte ptr [bp-3]
   ;	
   ;	                if (x>=80) x=0;
   ;	
	cmp	byte ptr [bp-3],80
	jl	short @1@674
	mov	byte ptr [bp-3],0
@1@674:
	dec	di
@1@702:
	or	di,di
	jg	short @1@618
   ;	
   ;	              }
   ;	              break;
   ;	
	jmp	short @1@814
@1@758:
   ;	
   ;	     case 27: b^=0x08; break;
   ;	
	xor	byte ptr [bp-2],8
	jmp	short @1@814
@1@786:
   ;	
   ;	     default: p++;
   ;	
	inc	si
@1@814:
	inc	si
@1@842:
	cmp	si,829
	jge	@@1
	jmp	@1@58
@@1:
   ;	
   ;	    }
   ;	  }
   ;	
   ;	  /*char r=random();
   ;	
   ;	  if (r==0)
   ;	  {
   ;	    print("Please enter the word \"Register\"");
   ;	    ret();
   ;	
   ;	    Register:
   ;	
   ;	    if (getch()!='R') goto Register;
   ;	    if (getch()!='e') goto Register;
   ;	    if (getch()!='g') goto Register;
   ;	    if (getch()!='i') goto Register;
   ;	    if (getch()!='s') goto Register;
   ;	    if (getch()!='t') goto Register;
   ;	    if (getch()!='e') goto Register;
   ;	    if (getch()!='r') goto Register;
   ;	  } else
   ;	  {
   ;	    print("Please wait...");
   ;	    ret();
   ;	    delay(3*18);
   ;	  } */
   ;	
   ;	  unsigned long Target=*Timer+18*30;
   ;	
	les	bx,dword ptr DGROUP:TIMER
	mov	ax,word ptr es:[bx+2]
	mov	dx,word ptr es:[bx]
	add	dx,540
	adc	ax,0
	mov	word ptr [bp-6],ax
	mov	word ptr [bp-8],dx
@1@898:
   ;	
   ;	  while (1)
   ;	  {
   ;	    if (*Timer>=Target) break;
   ;	
	les	bx,dword ptr DGROUP:TIMER
	mov	ax,word ptr es:[bx+2]
	mov	dx,word ptr es:[bx]
	cmp	ax,word ptr [bp-6]
	jb	short @1@1010
	jne	short @1@982
	cmp	dx,word ptr [bp-8]
	jb	short @1@1010
@1@982:
	jmp	short @1@1150
@1@1010:
   ;	
   ;	    if (kbhit() && getch()==13 && (*((char far*)0x00400017) & 3)==3) break;
   ;	
	call	near ptr @KBHIT$QV
	or	ax,ax
	je	short @1@1122
	call	near ptr @GETCH$QV
	cmp	ax,13
	jne	short @1@1122
	mov	ax,64
	mov	es,ax
	mov	al,byte ptr es:[23]
	cbw	
	and	ax,3
	cmp	ax,3
	jne	short @1@1122
	jmp	short @1@1150
@1@1122:
	jmp	short @1@898
@1@1150:
   ;	
   ;	  }
   ;	}
   ;	
	pop	di
	pop	si
	mov	sp,bp
	pop	bp
	ret	
@SHOWCOPYRIGHT$QV	endp
@1@C1298	label	word
	dw	@1@366
	dw	@1@394
	dw	@1@590
	dw	@1@758
	?debug	C E9
	?debug	C FA00000000
_TEXT	ends
_DATA	segment word public 'DATA'
s@	label	byte
_DATA	ends
_TEXT	segment byte public 'CODE'
_TEXT	ends
	public	COPYRIGHT
	extrn	@KBHIT$QV:near
	extrn	@GETCH$QV:near
	extrn	TIMER:dword
	extrn	_VRAM:dword
	extrn	@CLRSCR$QV:near
	public	@SHOWCOPYRIGHT$QV
_s@	equ	s@
	end
