.MODEL TINY
DGROUP          GROUP   _DATA,_BSS
_TEXT           SEGMENT PUBLIC  'CODE'
                ASSUME  CS:_TEXT ,DS:DGROUP,SS:DGROUP

                PUBLIC  Start

EXTRN main:PROC
EXTRN TextEnd:PROC

org 100h
Start:
	push ds
	mov ax, cs
	mov ds, ax

        call main

	pop ds
        mov ax, 4c00h
	int 21h

_TEXT           ENDS

_DATA           SEGMENT WORD PUBLIC  'DATA'
db	"DATA"
_DATA           ENDS

_BSS            SEGMENT WORD PUBLIC  'BSS'
_BSS            ENDS

                END Start
