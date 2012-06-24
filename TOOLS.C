/*

TOOLS.C

(c) by Stefan Schimanski '1997

*/


#include "./include/tools.h"

char (far * _VRAM)[] = (char (far *)[])0xb8000000;
#define VRAM(x,y) ((*_VRAM)[y*160+2*x])

unsigned long far * Timer= (unsigned long far *)0x0040006c;


void print(char* Text)
{
    asm mov si, Text
    asm mov bl, 7
  Weiter:
    asm lodsb
    asm cmp al, 0
    asm je raus
    asm mov ah, 0x0e
    asm int 0x10
    asm jmp Weiter
  raus:
}


void printz(char Ziffer)
{
    asm mov bl, 7
    asm mov al, Ziffer
    asm add al, 48
    asm mov ah, 0x0e
    asm int 0x10
}


void printb(char Byte)
{
  char h = Byte/100;
  char z = (Byte%100)/10;
  char e = Byte % 10;

  if (h>0) printz(h);
  if (z>0) printz(z);
  printz(e);
}


void ret()
{
  print("\n\r");
}


void clrscr()
{
  asm {
    mov ah, 0x0f
    int 0x10 // Get video mode (in al)

    mov ah, 0
    int 0x10
  }
}


int kbhit()
{
  asm mov ah, 1
  asm int 16h
  asm jnz Vorhanden

 NichtVorhanden:
  return 0;

 Vorhanden:
  return 1;
}


int getch()
{
  asm mov ah, 0
  asm int 16h
  asm cmp al, 0
  asm je Extended
  asm xor ah, ah /* Scancode verwerfen */

  Extended:

}


void invert(int line)
{
  int x=0;

  for (; x<80; x++)
  {
    char Old = *(&VRAM(x,line)+1);
    *(&VRAM(x,line)+1) = (Old >> 4) + 16*(Old & 15);
  }
}


void color(int line, char c)
{
  int x=0;

  for (; x<80; x++)
  {
    *(&VRAM(x,line)+1) = c;
  }
}


strcpy(char* dest, char* src)
{
  while (*src!=0)
  {
    *dest = *src;
    dest++;
    src++;
  }

  *dest = *src; // 0 kopieren
}

struct Ptr
{
  int o;
  int s;
};


int HDDRead(char drv, char head, char zyl, char sec, char num, void far* Buf)
{
  asm {
  mov dx, word ptr Buf+2
  mov es, dx

  mov dl, drv
  mov dh, head
  mov ch, zyl
  mov cl, sec
  mov al, num
  mov bx, word ptr Buf
  mov ah, 2
  int 0x13
  mov al, ah
  mov ah, 0
  jnc Fehler
  xor ax, ax
  }

 Fehler:
}


int HDDWrite(char drv, char head, char zyl, char sec, char num,
             void far* Buf)
{
  asm mov dx, word ptr Buf+2
  asm mov es, dx

  asm mov dl, drv
  asm mov dh, head
  asm mov ch, zyl
  asm mov cl, sec
  asm mov al, num
  asm mov bx, word ptr Buf
  asm mov ah, 3
  asm int 13h
  asm mov al, ah
  asm mov ah, 0
  asm jnc Fehler
  asm xor ax, ax

 Fehler:
}


delay(int Ticks)
{
  unsigned long Target=*Timer + Ticks;

  while (*Timer<Target);
}


char random()
{
  return *Timer & 0x03;
}


void gotoxy(char x, char y)
{
  asm {
    mov ah, 2
    mov bh, 0
    mov dh, y
    mov dl, x
    int 0x10
  }
}


char cursorx()
{
  asm {
    mov ah, 3
    mov bh, 0
    int 0x10
    mov al, dl
  }
}


char cursory()
{
  asm {
    mov ah, 3
    mov bh, 0
    int 0x10
    mov al, dh
  }
}