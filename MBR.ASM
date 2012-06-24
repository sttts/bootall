.MODEL TINY
_TEXT           SEGMENT PUBLIC  'CODE'
                ASSUME  CS:_TEXT

                PUBLIC  Start


org 100h
Start:
	mov ax, cs
	mov es, ax
	mov ah, 2
	mov dl, 80h
	mov dh, 0
	mov ch, 0
	mov cl, 2
	mov al, 8
	mov bx, 6c00h
	int 13h

	mov cx, 4096
	mov si, 6c00h
	Again:
	  xor byte ptr cs:[si], 7fh
	  inc si
	loop Again	
	
	jmp dword ptr cs:[l6c-100h+7c00h]
	l6c dw 100h
	dw 06c0h
Ende:
	

_TEXT           ENDS

                END Start
