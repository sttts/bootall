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
	?debug	S "bootall.c"
	?debug	C E90398912609626F6F74616C6C2E63
	?debug	C E9B4A97424112E2F696E636C7564652F746F6F6C732E68
	?debug	C E91A989126102E2F696E636C7564652F706172742E68
	?debug	C E929A2A622102E2F696E636C7564652F636F70792E68
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
MBR	label	word
	db	512 dup (?)
CONFIG	label	word
	db	512 dup (?)
_BSS	ends
_DATA	segment word public 'DATA'
CONFIGURED	label	word
	db	0
	db	0
REGISTERED	label	word
	db	0
	db	0
BOOTREC	label	dword
	db	0
	db	124
	db	0
	db	0
_DATA	ends
_TEXT	segment byte public 'CODE'
   ;	
   ;	void Boot(char Drive, char Head, char Track, char Sec)
   ;	
	assume	cs:_TEXT
@BOOT$QZCZCZCZC	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  HDDRead(Drive, Head, Track, Sec, 1, BootRec);
   ;	
	mov	al,byte ptr [bp+10]
	push	ax
	mov	al,byte ptr [bp+8]
	push	ax
	mov	al,byte ptr [bp+6]
	push	ax
	mov	al,byte ptr [bp+4]
	push	ax
	mov	al,1
	push	ax
	push	word ptr DGROUP:BOOTREC+2
	push	word ptr DGROUP:BOOTREC
	call	near ptr @HDDREAD$QZCZCZCZCZCNV
   ;	
   ;	  asm jmp dword ptr BootRec
   ;	
 	jmp	 dword ptr DGROUP:BOOTREC
   ;	
   ;	}
   ;	
	pop	bp
	ret	8
@BOOT$QZCZCZCZC	endp
   ;	
   ;	void Exclusive(char n)
   ;	
	assume	cs:_TEXT
@EXCLUSIVE$QZC	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
   ;	
   ;	{
   ;	  int Activated=0;
   ;	
	xor	di,di
   ;	
   ;	
   ;	  for (int p=0; p<4; p++)
   ;	
	xor	si,si
	jmp	@2@646
@2@58:
   ;	
   ;	  {
   ;	    if (Config.Part[n].Drive==0x80 &&
   ;	
   ;	
   ;	        MBR.Part[p].StartTrack==Config.Part[n].Track &&
   ;		MBR.Part[p].StartSec==Config.Part[n].Sec)
   ;	
	mov	al,byte ptr [bp+4]
	cbw	
	mov	dx,22
	imul	dx
	mov	bx,ax
	cmp	byte ptr DGROUP:CONFIG[bx+107],128
	je	@@0
	jmp	@2@394
@@0:
	mov	al,byte ptr [bp+4]
	cbw	
	mov	dx,22
	imul	dx
	mov	bx,ax
	mov	al,byte ptr DGROUP:CONFIG[bx+105]
	mov	bx,si
	mov	cl,4
	shl	bx,cl
	cmp	al,byte ptr DGROUP:MBR[bx+449]
	je	@@1
	jmp	@2@394
@@1:
	mov	al,byte ptr [bp+4]
	cbw	
	mov	dx,22
	imul	dx
	mov	bx,ax
	mov	al,byte ptr DGROUP:CONFIG[bx+104]
	mov	bx,si
	mov	cl,4
	shl	bx,cl
	cmp	al,byte ptr DGROUP:MBR[bx+448]
	je	@@2
	jmp	@2@394
@@2:
   ;	
   ;	    {
   ;	      Activated = 1;
   ;	
	mov	di,1
   ;	
   ;	      MBR.Part[p].BootSig=0x80;
   ;	
	mov	bx,si
	mov	cl,4
	shl	bx,cl
	mov	byte ptr DGROUP:MBR[bx+446],128
   ;	
   ;	      if (MBR.Part[p].SysSig==0x11) MBR.Part[p].SysSig=0x01; else
   ;	
	mov	bx,si
	mov	cl,4
	shl	bx,cl
	cmp	byte ptr DGROUP:MBR[bx+450],17
	jne	short @2@198
	mov	bx,si
	mov	cl,4
	shl	bx,cl
	mov	byte ptr DGROUP:MBR[bx+450],1
	jmp	short @2@366
@2@198:
   ;	
   ;	      if (MBR.Part[p].SysSig==0x14) MBR.Part[p].SysSig=0x04; else
   ;	
	mov	bx,si
	mov	cl,4
	shl	bx,cl
	cmp	byte ptr DGROUP:MBR[bx+450],20
	jne	short @2@254
	mov	bx,si
	mov	cl,4
	shl	bx,cl
	mov	byte ptr DGROUP:MBR[bx+450],4
	jmp	short @2@366
@2@254:
   ;	
   ;	      if (MBR.Part[p].SysSig==0x1b) MBR.Part[p].SysSig=0x0b; else
   ;	
	mov	bx,si
	mov	cl,4
	shl	bx,cl
	cmp	byte ptr DGROUP:MBR[bx+450],27
	jne	short @2@310
	mov	bx,si
	mov	cl,4
	shl	bx,cl
	mov	byte ptr DGROUP:MBR[bx+450],11
	jmp	short @2@366
@2@310:
   ;	
   ;	      if (MBR.Part[p].SysSig==0x16) MBR.Part[p].SysSig=0x06;
   ;	
	mov	bx,si
	mov	cl,4
	shl	bx,cl
	cmp	byte ptr DGROUP:MBR[bx+450],22
	jne	short @2@366
	mov	bx,si
	mov	cl,4
	shl	bx,cl
	mov	byte ptr DGROUP:MBR[bx+450],6
@2@366:
   ;	
   ;	    } else
   ;	
	jmp	@2@618
@2@394:
   ;	
   ;	    {
   ;	      MBR.Part[p].BootSig=0x0;
   ;	
	mov	bx,si
	mov	cl,4
	shl	bx,cl
	mov	byte ptr DGROUP:MBR[bx+446],0
   ;	
   ;	      if (MBR.Part[p].SysSig==0x01) MBR.Part[p].SysSig=0x11; else
   ;	
	mov	bx,si
	mov	cl,4
	shl	bx,cl
	cmp	byte ptr DGROUP:MBR[bx+450],1
	jne	short @2@450
	mov	bx,si
	mov	cl,4
	shl	bx,cl
	mov	byte ptr DGROUP:MBR[bx+450],17
	jmp	short @2@618
@2@450:
   ;	
   ;	      if (MBR.Part[p].SysSig==0x04) MBR.Part[p].SysSig=0x14; else
   ;	
	mov	bx,si
	mov	cl,4
	shl	bx,cl
	cmp	byte ptr DGROUP:MBR[bx+450],4
	jne	short @2@506
	mov	bx,si
	mov	cl,4
	shl	bx,cl
	mov	byte ptr DGROUP:MBR[bx+450],20
	jmp	short @2@618
@2@506:
   ;	
   ;	      if (MBR.Part[p].SysSig==0x0b) MBR.Part[p].SysSig=0x1b; else
   ;	
	mov	bx,si
	mov	cl,4
	shl	bx,cl
	cmp	byte ptr DGROUP:MBR[bx+450],11
	jne	short @2@562
	mov	bx,si
	mov	cl,4
	shl	bx,cl
	mov	byte ptr DGROUP:MBR[bx+450],27
	jmp	short @2@618
@2@562:
   ;	
   ;	      if (MBR.Part[p].SysSig==0x06) MBR.Part[p].SysSig=0x16;
   ;	
	mov	bx,si
	mov	cl,4
	shl	bx,cl
	cmp	byte ptr DGROUP:MBR[bx+450],6
	jne	short @2@618
	mov	bx,si
	mov	cl,4
	shl	bx,cl
	mov	byte ptr DGROUP:MBR[bx+450],22
@2@618:
	inc	si
@2@646:
	cmp	si,4
	jge	@@3
	jmp	@2@58
@@3:
   ;	
   ;	    }
   ;	  }
   ;	
   ;	  if (!Activated)
   ;	
	or	di,di
	jne	short @2@842
   ;	
   ;	  {
   ;	    for (int p=0; p<4; p++)
   ;	
	xor	ax,ax
	jmp	short @2@814
@2@730:
   ;	
   ;	    {
   ;	      if (MBR.Part[p].SysSig==0x05) MBR.Part[p].BootSig=0x80;
   ;	
	mov	bx,ax
	mov	cl,4
	shl	bx,cl
	cmp	byte ptr DGROUP:MBR[bx+450],5
	jne	short @2@786
	mov	bx,ax
	mov	cl,4
	shl	bx,cl
	mov	byte ptr DGROUP:MBR[bx+446],128
@2@786:
	inc	ax
@2@814:
	cmp	ax,4
	jl	short @2@730
@2@842:
   ;	
   ;	    }
   ;	  }
   ;	
   ;	  HDDWrite(0x80, 0, 0, 1, 1, &MBR);
   ;	
	mov	al,128
	push	ax
	mov	al,0
	push	ax
	mov	al,0
	push	ax
	mov	al,1
	push	ax
	mov	al,1
	push	ax
	push	ds
	mov	ax,offset DGROUP:MBR
	push	ax
	call	near ptr @HDDWRITE$QZCZCZCZCZCNV
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	2
@EXCLUSIVE$QZC	endp
   ;	
   ;	void BootActive()
   ;	
	assume	cs:_TEXT
@BOOTACTIVE$QV	proc	near
	push	bp
	mov	bp,sp
	sub	sp,2
   ;	
   ;	{
   ;	  clrscr();
   ;	
	call	near ptr @CLRSCR$QV
   ;	
   ;	
   ;	  for (int n=0; n<4; n++)
   ;	
	mov	word ptr [bp-2],0
	jmp	short @3@170
@3@58:
   ;	
   ;	  {
   ;	    if ( (MBR.Part[n].SysSig!=0) && (MBR.Part[n].BootSig==0x80) ) break;
   ;	
	mov	bx,word ptr [bp-2]
	mov	cl,4
	shl	bx,cl
	cmp	byte ptr DGROUP:MBR[bx+450],0
	je	short @3@142
	mov	bx,word ptr [bp-2]
	mov	cl,4
	shl	bx,cl
	cmp	byte ptr DGROUP:MBR[bx+446],128
	jne	short @3@142
	jmp	short @3@198
@3@142:
	inc	word ptr [bp-2]
@3@170:
	cmp	word ptr [bp-2],4
	jl	short @3@58
@3@198:
   ;	
   ;	  }
   ;	
   ;	  if (n<4)
   ;	
	cmp	word ptr [bp-2],4
	jge	short @3@254
   ;	
   ;	  {
   ;	    Exclusive(n);
   ;	
	mov	al,byte ptr [bp-2]
	push	ax
	call	near ptr @EXCLUSIVE$QZC
   ;	
   ;	    Boot(0x80, MBR.Part[n].StartHead,
   ;	
   ;	
   ;		       MBR.Part[n].StartTrack,
   ;		       MBR.Part[n].StartSec);
   ;	
	mov	al,128
	push	ax
	mov	bx,word ptr [bp-2]
	mov	cl,4
	shl	bx,cl
	mov	al,byte ptr DGROUP:MBR[bx+447]
	push	ax
	mov	bx,word ptr [bp-2]
	mov	cl,4
	shl	bx,cl
	mov	al,byte ptr DGROUP:MBR[bx+449]
	push	ax
	mov	bx,word ptr [bp-2]
	mov	cl,4
	shl	bx,cl
	mov	al,byte ptr DGROUP:MBR[bx+448]
	push	ax
	call	near ptr @BOOT$QZCZCZCZC
   ;	
   ;	  } else
   ;	
	jmp	short @3@310
@3@254:
   ;	
   ;	  {
   ;	    print("Booting active partition failed...");
   ;	
	mov	ax,offset DGROUP:s@
	push	ax
	call	near ptr @PRINT$QPZC
@3@282:
	jmp	short @3@282
@3@310:
   ;	
   ;	    while (1);
   ;	  }
   ;	}
   ;	
	mov	sp,bp
	pop	bp
	ret	
@BOOTACTIVE$QV	endp
   ;	
   ;	void Error(char* Msg)
   ;	
	assume	cs:_TEXT
@ERROR$QPZC	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  print(Msg);
   ;	
	push	word ptr [bp+4]
	call	near ptr @PRINT$QPZC
   ;	
   ;	  print("\n\rTo load active partition please press a key!\n\r");
   ;	
	mov	ax,offset DGROUP:s@+35
	push	ax
	call	near ptr @PRINT$QPZC
   ;	
   ;	  getch();
   ;	
	call	near ptr @GETCH$QV
   ;	
   ;	  BootActive();
   ;	
	call	near ptr @BOOTACTIVE$QV
   ;	
   ;	}
   ;	
	pop	bp
	ret	2
@ERROR$QPZC	endp
   ;	
   ;	void ReadConfig()
   ;	
	assume	cs:_TEXT
@READCONFIG$QV	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
   ;	
   ;	{
   ;	  HDDRead(0x80, 0, 0, 1, 1, &MBR);
   ;	
	mov	al,128
	push	ax
	mov	al,0
	push	ax
	mov	al,0
	push	ax
	mov	al,1
	push	ax
	mov	al,1
	push	ax
	push	ds
	mov	ax,offset DGROUP:MBR
	push	ax
	call	near ptr @HDDREAD$QZCZCZCZCZCNV
   ;	
   ;	
   ;	  if (MBR.EndSig!=0xaa55) Error("No valid MBR found");
   ;	
	cmp	word ptr DGROUP:MBR+510,-21931
	je	short @5@86
	mov	ax,offset DGROUP:s@+84
	push	ax
	call	near ptr @ERROR$QPZC
@5@86:
   ;	
   ;	
   ;	  HDDRead(0x80, 0, 0, 16, 1, &Config);
   ;	
	mov	al,128
	push	ax
	mov	al,0
	push	ax
	mov	al,0
	push	ax
	mov	al,16
	push	ax
	mov	al,1
	push	ax
	push	ds
	mov	ax,offset DGROUP:CONFIG
	push	ax
	call	near ptr @HDDREAD$QZCZCZCZCZCNV
   ;	
   ;	  if (Config.Id==ID)
   ;	
	cmp	word ptr DGROUP:CONFIG,4660
	jne	short @5@170
   ;	
   ;	  {
   ;	    Configured = 1;
   ;	
	mov	word ptr DGROUP:CONFIGURED,1
   ;	
   ;	    if (Config.Version!=CONFIG_VERSION) Error("Wrong version of configuration");
   ;	
	cmp	word ptr DGROUP:CONFIG+2,259
	je	short @5@170
	mov	ax,offset DGROUP:s@+103
	push	ax
	call	near ptr @ERROR$QPZC
@5@170:
   ;	
   ;	  }
   ;	
   ;	  Registered=Config.Registered;
   ;	
	mov	al,byte ptr DGROUP:CONFIG+440
	mov	ah,0
	mov	word ptr DGROUP:REGISTERED,ax
   ;	
   ;	
   ;	  WORD Checksum=0x1234;
   ;	
	mov	di,4660
   ;	
   ;	  for (int p=0; p<sizeof(Config)-2; p++)
   ;	
	xor	si,si
	jmp	short @5@254
@5@198:
   ;	
   ;	  {
   ;	    Checksum+=*(((BYTE*)&Config)+p);
   ;	
	mov	al,byte ptr DGROUP:CONFIG[si]
	mov	ah,0
	add	di,ax
   ;	
   ;	    Checksum^=*(((BYTE*)&Config)+p);
   ;	
	mov	al,byte ptr DGROUP:CONFIG[si]
	mov	ah,0
	xor	di,ax
	inc	si
@5@254:
	cmp	si,510
	jl	short @5@198
   ;	
   ;	  }
   ;	
   ;	  if (Checksum!=Config.Checksum) Registered=0;
   ;	
	cmp	di,word ptr DGROUP:CONFIG+510
	je	short @5@338
	mov	word ptr DGROUP:REGISTERED,0
@5@338:
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
@READCONFIG$QV	endp
_TEXT	ends
_DATA	segment word public 'DATA'
QUIT	label	word
	db	0
	db	0
LINE	label	word
	db	0
	db	0
OLDLINE	label	word
	db	0
	db	0
SECONDS	label	word
	db	0
	db	0
_DATA	ends
_TEXT	segment byte public 'CODE'
   ;	
   ;	void StartBalken()
   ;	
	assume	cs:_TEXT
@STARTBALKEN$QV	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  invert(Line+4);
   ;	
	mov	ax,word ptr DGROUP:LINE
	add	ax,4
	push	ax
	call	near ptr @INVERT$QI
   ;	
   ;	}
   ;	
	pop	bp
	ret	
@STARTBALKEN$QV	endp
   ;	
   ;	void EndBalken()
   ;	
	assume	cs:_TEXT
@ENDBALKEN$QV	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  invert(OldLine+4);
   ;	
	mov	ax,word ptr DGROUP:OLDLINE
	add	ax,4
	push	ax
	call	near ptr @INVERT$QI
   ;	
   ;	}
   ;	
	pop	bp
	ret	
@ENDBALKEN$QV	endp
   ;	
   ;	void UpdateBalken()
   ;	
	assume	cs:_TEXT
@UPDATEBALKEN$QV	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  if (OldLine!=Line)
   ;	
	mov	ax,word ptr DGROUP:OLDLINE
	cmp	ax,word ptr DGROUP:LINE
	je	short @8@86
   ;	
   ;	  {
   ;	    invert(OldLine+4);
   ;	
	mov	ax,word ptr DGROUP:OLDLINE
	add	ax,4
	push	ax
	call	near ptr @INVERT$QI
   ;	
   ;	    invert(Line+4);
   ;	
	mov	ax,word ptr DGROUP:LINE
	add	ax,4
	push	ax
	call	near ptr @INVERT$QI
@8@86:
   ;	
   ;	  }
   ;	
   ;	  OldLine = Line;
   ;	
	mov	ax,word ptr DGROUP:LINE
	mov	word ptr DGROUP:OLDLINE,ax
   ;	
   ;	}
   ;	
	pop	bp
	ret	
@UPDATEBALKEN$QV	endp
   ;	
   ;	void BalkenHoch()
   ;	
	assume	cs:_TEXT
@BALKENHOCH$QV	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  if (Line>0) Line--;
   ;	
	cmp	word ptr DGROUP:LINE,0
	jle	short @9@86
	dec	word ptr DGROUP:LINE
@9@86:
   ;	
   ;	}
   ;	
	pop	bp
	ret	
@BALKENHOCH$QV	endp
   ;	
   ;	void BalkenRunter()
   ;	
	assume	cs:_TEXT
@BALKENRUNTER$QV	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  if (Line<Config.PartNum-1) Line++;
   ;	
	mov	ax,word ptr DGROUP:CONFIG+85
	dec	ax
	cmp	ax,word ptr DGROUP:LINE
	jle	short @10@86
	inc	word ptr DGROUP:LINE
@10@86:
   ;	
   ;	}
   ;	
	pop	bp
	ret	
@BALKENRUNTER$QV	endp
   ;	
   ;	int RealBoot()
   ;	
	assume	cs:_TEXT
@REALBOOT$QV	proc	near
	push	bp
	mov	bp,sp
	sub	sp,2
   ;	
   ;	{
   ;	  int r=0;
   ;	
	mov	word ptr [bp-2],0
   ;	
   ;	
   ;	  asm {
   ;	    mov ax, cs
   ;	
	mov	 ax, cs
   ;	
   ;	    cmp ax, 0x6c00
   ;	
	cmp	 ax, 06c00H
   ;	
   ;	    jne Dos
   ;	
	jne	short @11@170
   ;	
   ;	    mov word ptr r, 1
   ;	
	mov	 word ptr [bp-2], 1
@11@170:
   ;	
   ;	  }
   ;	  Dos:
   ;	
   ;	  return r;
   ;	
	mov	ax,word ptr [bp-2]
	jmp	short @11@198
@11@198:
   ;	
   ;	}
   ;	
	mov	sp,bp
	pop	bp
	ret	
@REALBOOT$QV	endp
   ;	
   ;	void ShowSeconds()
   ;	
	assume	cs:_TEXT
@SHOWSECONDS$QV	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  if (Config.Seconds<255)
   ;	
	cmp	byte ptr DGROUP:CONFIG+4,255
	jae	short @12@86
   ;	
   ;	  {
   ;	    gotoxy(0, 24);
   ;	
	mov	al,0
	push	ax
	mov	al,24
	push	ax
	call	near ptr @GOTOXY$QZCZC
   ;	
   ;	    printb(Seconds);
   ;	
	mov	al,byte ptr DGROUP:SECONDS
	push	ax
	call	near ptr @PRINTB$QZC
   ;	
   ;	    print(" seconds until boot  ");
   ;	
	mov	ax,offset DGROUP:s@+134
	push	ax
	call	near ptr @PRINT$QPZC
@12@86:
   ;	
   ;	  }
   ;	}
   ;	
	pop	bp
	ret	
@SHOWSECONDS$QV	endp
   ;	
   ;	int Menu()
   ;	
	assume	cs:_TEXT
@MENU$QV	proc	near
	push	bp
	mov	bp,sp
	sub	sp,8
	push	si
	push	di
   ;	
   ;	{
   ;	  clrscr();
   ;	
	call	near ptr @CLRSCR$QV
   ;	
   ;	
   ;	  print(BOOTALL " v"VERSION_S" (c) by Stefan Schimanski & Janko Heilgeist '"BUILDYEAR"\n\r");
   ;	
	mov	ax,offset DGROUP:s@+156
	push	ax
	call	near ptr @PRINT$QPZC
   ;	
   ;	  color(0, 0x1f);
   ;	
	xor	ax,ax
	push	ax
	mov	al,31
	push	ax
	call	near ptr @COLOR$QIZC
   ;	
   ;	  ret();
   ;	
	call	near ptr @RET$QV
   ;	
   ;	  print(Config.Message); ret();
   ;	
	mov	ax,offset DGROUP:CONFIG+5
	push	ax
	call	near ptr @PRINT$QPZC
	call	near ptr @RET$QV
   ;	
   ;	  ret();
   ;	
	call	near ptr @RET$QV
   ;	
   ;	
   ;	  if (!Configured) Error("No configuration loaded");
   ;	
	cmp	word ptr DGROUP:CONFIGURED,0
	jne	short @13@86
	mov	ax,offset DGROUP:s@+224
	push	ax
	call	near ptr @ERROR$QPZC
@13@86:
   ;	
   ;	  if (Config.PartNum==0) Error("No partition found in configuration");
   ;	
	cmp	word ptr DGROUP:CONFIG+85,0
	jne	short @13@142
	mov	ax,offset DGROUP:s@+248
	push	ax
	call	near ptr @ERROR$QPZC
@13@142:
   ;	
   ;	
   ;	  for (int n=0; n<Config.PartNum; n++)
   ;	
	xor	si,si
	jmp	short @13@226
@13@170:
   ;	
   ;	  {
   ;	    print(Config.Part[n].Text);
   ;	
	mov	ax,si
	mov	dx,22
	imul	dx
	add	ax,offset DGROUP:CONFIG+87
	push	ax
	call	near ptr @PRINT$QPZC
   ;	
   ;	    ret();
   ;	
	call	near ptr @RET$QV
	inc	si
@13@226:
	cmp	si,word ptr DGROUP:CONFIG+85
	jl	short @13@170
   ;	
   ;	  }
   ;	
   ;	  if(Config.Seconds==255)
   ;	
	cmp	byte ptr DGROUP:CONFIG+4,255
	jne	short @13@310
   ;	
   ;	  {
   ;	    ret();
   ;	
	call	near ptr @RET$QV
   ;	
   ;	    print("Press SHIFT+TAB to boot default-partition");
   ;	
	mov	ax,offset DGROUP:s@+284
	push	ax
	call	near ptr @PRINT$QPZC
@13@310:
   ;	
   ;	  }
   ;	
   ;	  ret();
   ;	
	call	near ptr @RET$QV
   ;	
   ;	  print("Press ESC to boot active partition");
   ;	
	mov	ax,offset DGROUP:s@+326
	push	ax
	call	near ptr @PRINT$QPZC
   ;	
   ;	  ret();
   ;	
	call	near ptr @RET$QV
   ;	
   ;	
   ;	  int key = 0;
   ;	
	mov	word ptr [bp-2],0
   ;	
   ;	  int Selected = 0;
   ;	
	xor	di,di
   ;	
   ;	  Seconds = Config.Seconds;
   ;	
	mov	al,byte ptr DGROUP:CONFIG+4
	mov	ah,0
	mov	word ptr DGROUP:SECONDS,ax
   ;	
   ;	  unsigned long NextSecondTime = *Timer+18;
   ;	
	les	bx,dword ptr DGROUP:TIMER
	mov	ax,word ptr es:[bx+2]
	mov	dx,word ptr es:[bx]
	add	dx,18
	adc	ax,0
	mov	word ptr [bp-4],ax
	mov	word ptr [bp-6],dx
   ;	
   ;	
   ;	  Line = Config.Default;
   ;	
	mov	al,byte ptr DGROUP:CONFIG+439
	mov	ah,0
	mov	word ptr DGROUP:LINE,ax
   ;	
   ;	  if (Line==255) Line=0;
   ;	
	cmp	word ptr DGROUP:LINE,255
	jne	short @13@366
	mov	word ptr DGROUP:LINE,0
@13@366:
   ;	
   ;	  OldLine = Line;
   ;	
	mov	ax,word ptr DGROUP:LINE
	mov	word ptr DGROUP:OLDLINE,ax
   ;	
   ;	
   ;	  StartBalken();
   ;	
	call	near ptr @STARTBALKEN$QV
   ;	
   ;	  ShowSeconds();
   ;	
	call	near ptr @SHOWSECONDS$QV
	jmp	@13@1290
@13@394:
   ;	
   ;	
   ;	  while (!Selected && !Quit)
   ;	  {
   ;	    UpdateBalken();
   ;	
	call	near ptr @UPDATEBALKEN$QV
   ;	
   ;	
   ;	    if (kbhit())
   ;	
	call	near ptr @KBHIT$QV
	or	ax,ax
	jne	@@4
	jmp	@13@954
@@4:
   ;	
   ;	    {
   ;	      key = getch();
   ;	
	call	near ptr @GETCH$QV
	mov	word ptr [bp-2],ax
   ;	
   ;	
   ;	      switch(key)
   ;	
	mov	ax,word ptr [bp-2]
	mov	word ptr [bp-8],ax
	mov	cx,6
	mov	bx,offset @13@C1218
@13@506:
	mov	ax,word ptr cs:[bx]
	cmp	ax,word ptr [bp-8]
	je	short @13@590
	add	bx,2
	loop	short @13@506
	jmp	short @13@926
@13@590:
	jmp	word ptr cs:[bx+12]
@13@618:
   ;	
   ;	      {
   ;	       case KB_UP: BalkenHoch(); break;
   ;	
	call	near ptr @BALKENHOCH$QV
	jmp	short @13@926
@13@646:
   ;	
   ;	       case KB_DOWN: BalkenRunter(); break;
   ;	
	call	near ptr @BALKENRUNTER$QV
	jmp	short @13@926
@13@674:
	jmp	short @13@786
@13@702:
   ;	
   ;	       case KB_ENTER: Selected=1; break;
   ;	       case KB_ESC: BootActive(); break;
   ;	
	call	near ptr @BOOTACTIVE$QV
	jmp	short @13@926
@13@730:
   ;	
   ;	       case KB_SHIFTTAB: Line = Config.Default;
   ;	
	mov	al,byte ptr DGROUP:CONFIG+439
	mov	ah,0
	mov	word ptr DGROUP:LINE,ax
   ;	
   ;				 if (Line==255) BootActive();
   ;	
	cmp	word ptr DGROUP:LINE,255
	jne	short @13@786
	call	near ptr @BOOTACTIVE$QV
@13@786:
   ;	
   ;				 Selected = 1; break;
   ;	
	mov	di,1
	jmp	short @13@926
@13@814:
   ;	
   ;	       case KB_STRGF10: if (!RealBoot())
   ;	
	call	near ptr @REALBOOT$QV
	or	ax,ax
	jne	short @13@898
   ;	
   ;				{
   ;				  asm {
   ;				    mov ax, 0x4c00
   ;	
	mov	 ax, 04c00H
   ;	
   ;				    int 0x21
   ;	
	int	 021H
@13@898:
   ;	
   ;				  }
   ;				}
   ;				break;
   ;	
	jmp	short @13@926
@13@926:
   ;	
   ;	      }
   ;	
   ;	      Seconds = Config.Seconds;
   ;	
	mov	al,byte ptr DGROUP:CONFIG+4
	mov	ah,0
	mov	word ptr DGROUP:SECONDS,ax
   ;	
   ;	      NextSecondTime = *Timer+18;
   ;	
	les	bx,dword ptr DGROUP:TIMER
	mov	ax,word ptr es:[bx+2]
	mov	dx,word ptr es:[bx]
	add	dx,18
	adc	ax,0
	mov	word ptr [bp-4],ax
	mov	word ptr [bp-6],dx
   ;	
   ;	      ShowSeconds();
   ;	
	call	near ptr @SHOWSECONDS$QV
   ;	
   ;	
   ;	      key = 0;
   ;	
	mov	word ptr [bp-2],0
@13@954:
   ;	
   ;	    }
   ;	
   ;	    if(Config.Seconds < 255)
   ;	
	cmp	byte ptr DGROUP:CONFIG+4,255
	jae	short @13@1290
   ;	
   ;	    {
   ;	      if (*Timer > NextSecondTime || *Timer<18)
   ;	
	les	bx,dword ptr DGROUP:TIMER
	mov	ax,word ptr es:[bx+2]
	mov	dx,word ptr es:[bx]
	cmp	ax,word ptr [bp-4]
	ja	short @13@1150
	jne	short @13@1066
	cmp	dx,word ptr [bp-6]
	ja	short @13@1150
@13@1066:
	les	bx,dword ptr DGROUP:TIMER
	cmp	word ptr es:[bx+2],0
	ja	short @13@1290
	jb	short @13@1150
	cmp	word ptr es:[bx],18
	jae	short @13@1290
@13@1150:
   ;	
   ;	      {
   ;	        NextSecondTime+=18;
   ;	
	add	word ptr [bp-6],18
	adc	word ptr [bp-4],0
   ;	
   ;	        Seconds--;
   ;	
	dec	word ptr DGROUP:SECONDS
   ;	
   ;	        if (Seconds==0)
   ;	
	cmp	word ptr DGROUP:SECONDS,0
	jne	short @13@1262
   ;	
   ;	        {
   ;		  Line = Config.Default;
   ;	
	mov	al,byte ptr DGROUP:CONFIG+439
	mov	ah,0
	mov	word ptr DGROUP:LINE,ax
   ;	
   ;		  if (Line==255) BootActive();
   ;	
	cmp	word ptr DGROUP:LINE,255
	jne	short @13@1234
	call	near ptr @BOOTACTIVE$QV
@13@1234:
   ;	
   ;		  Selected = 1;
   ;	
	mov	di,1
@13@1262:
   ;	
   ;	        }
   ;	
   ;	        ShowSeconds();
   ;	
	call	near ptr @SHOWSECONDS$QV
@13@1290:
	or	di,di
	jne	short @13@1346
	cmp	word ptr DGROUP:QUIT,0
	jne	@@5
	jmp	@13@394
@@5:
@13@1346:
   ;	
   ;	      }
   ;	    }
   ;	  }
   ;	
   ;	  EndBalken();
   ;	
	call	near ptr @ENDBALKEN$QV
   ;	
   ;	
   ;	  clrscr();
   ;	
	call	near ptr @CLRSCR$QV
   ;	
   ;	
   ;	  return Line;
   ;	
	mov	ax,word ptr DGROUP:LINE
	jmp	short @13@1374
@13@1374:
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	mov	sp,bp
	pop	bp
	ret	
@MENU$QV	endp
@13@C1218	label	word
	db	13
	db	0
	db	27
	db	0
	db	0
	db	15
	db	0
	db	72
	db	0
	db	80
	db	0
	db	103
	dw	@13@674
	dw	@13@702
	dw	@13@730
	dw	@13@618
	dw	@13@646
	dw	@13@814
_TEXT	ends
_DATA	segment word public 'DATA'
SYSKEYS	label	dword
	db	23
	db	0
	db	64
	db	0
_DATA	ends
_TEXT	segment byte public 'CODE'
   ;	
   ;	void main()
   ;	
	assume	cs:_TEXT
MAIN	proc	near
	push	bp
	mov	bp,sp
	sub	sp,2
   ;	
   ;	{
   ;	  ReadConfig();
   ;	
	call	near ptr @READCONFIG$QV
	jmp	short @14@114
@14@58:
   ;	
   ;	
   ;	  #ifdef THOMAS
   ;	  if ( ((*SysKeys) & 4)==0 )
   ;	  {
   ;	    int n = Config.Default;
   ;	
   ;	    Exclusive(n);
   ;	    Boot(Config.Part[n].Drive,
   ;	         Config.Part[n].Head,
   ;	         Config.Part[n].Track,
   ;	         Config.Part[n].Sec);
   ;	  } else
   ;	  #endif
   ;	
   ;	  {
   ;	    //if (Registered!=1) ShowCopyright();
   ;	
   ;	    while (!Quit)
   ;	    {
   ;	      int n=Menu();
   ;	
	call	near ptr @MENU$QV
	mov	word ptr [bp-2],ax
   ;	
   ;	      if (!Quit)
   ;	
	cmp	word ptr DGROUP:QUIT,0
	jne	short @14@114
   ;	
   ;	      {
   ;	        clrscr();
   ;	
	call	near ptr @CLRSCR$QV
   ;	
   ;	        Exclusive(n);
   ;	
	mov	al,byte ptr [bp-2]
	push	ax
	call	near ptr @EXCLUSIVE$QZC
   ;	
   ;	        Boot(Config.Part[n].Drive,
   ;	
   ;	
   ;	   	     Config.Part[n].Head,
   ;	             Config.Part[n].Track,
   ;	             Config.Part[n].Sec);
   ;	
	mov	ax,word ptr [bp-2]
	mov	dx,22
	imul	dx
	mov	bx,ax
	mov	al,byte ptr DGROUP:CONFIG[bx+107]
	push	ax
	mov	ax,word ptr [bp-2]
	mov	dx,22
	imul	dx
	mov	bx,ax
	mov	al,byte ptr DGROUP:CONFIG[bx+103]
	push	ax
	mov	ax,word ptr [bp-2]
	mov	dx,22
	imul	dx
	mov	bx,ax
	mov	al,byte ptr DGROUP:CONFIG[bx+105]
	push	ax
	mov	ax,word ptr [bp-2]
	mov	dx,22
	imul	dx
	mov	bx,ax
	mov	al,byte ptr DGROUP:CONFIG[bx+104]
	push	ax
	call	near ptr @BOOT$QZCZCZCZC
@14@114:
	cmp	word ptr DGROUP:QUIT,0
	je	short @14@58
   ;	
   ;	      }
   ;	    }
   ;	  }
   ;	}
   ;	
	mov	sp,bp
	pop	bp
	ret	
MAIN	endp
	?debug	C E9
	?debug	C FA00000000
_TEXT	ends
_DATA	segment word public 'DATA'
s@	label	byte
	db	'Booting active partition failed...'
	db	0
	db	10
	db	13
	db	'To load active partition please press a key!'
	db	10
	db	13
	db	0
	db	'No valid MBR found'
	db	0
	db	'Wrong version of configuration'
	db	0
	db	' seconds until boot  '
	db	0
	db	'BOOTALL 97 v1.08 (c) by Stefan Schimanski & Janko Heilgeist '
	db	39
	db	'1999'
	db	10
	db	13
	db	0
	db	'No configuration loaded'
	db	0
	db	'No partition found in configuration'
	db	0
	db	'Press SHIFT+TAB to boot default-partition'
	db	0
	db	'Press ESC to boot active partition'
	db	0
_DATA	ends
_TEXT	segment byte public 'CODE'
_TEXT	ends
	public	MAIN
	public	SYSKEYS
	public	@MENU$QV
	public	@SHOWSECONDS$QV
	public	@REALBOOT$QV
	public	@BALKENRUNTER$QV
	public	@BALKENHOCH$QV
	public	@UPDATEBALKEN$QV
	public	@ENDBALKEN$QV
	public	@STARTBALKEN$QV
	public	SECONDS
	public	OLDLINE
	public	LINE
	public	QUIT
	public	@READCONFIG$QV
	public	@ERROR$QPZC
	public	@BOOTACTIVE$QV
	public	@EXCLUSIVE$QZC
	public	@BOOT$QZCZCZCZC
	public	BOOTREC
	public	REGISTERED
	public	CONFIGURED
	public	CONFIG
	public	MBR
	extrn	@HDDWRITE$QZCZCZCZCZCNV:near
	extrn	@HDDREAD$QZCZCZCZCZCNV:near
	extrn	@KBHIT$QV:near
	extrn	@GETCH$QV:near
	extrn	TIMER:dword
	extrn	@CLRSCR$QV:near
	extrn	@GOTOXY$QZCZC:near
	extrn	@RET$QV:near
	extrn	@COLOR$QIZC:near
	extrn	@INVERT$QI:near
	extrn	@PRINTB$QZC:near
	extrn	@PRINT$QPZC:near
_s@	equ	s@
	end
