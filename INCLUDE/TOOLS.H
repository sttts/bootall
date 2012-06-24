/*

TOOLS.H

(c) by Stefan Schimanski '1997

*/

#ifndef TOOLS_H_INCLUDED
#define TOOLS_H_INCLUDED


  extern void print(char* Text);
  extern void printz(char Ziffer);
  extern void printb(char Byte);
  extern void invert(int line);
  extern void color(int line, char c);
  extern void ret();

  void gotoxy(char x, char y);
  char cursorx();
  char cursory();

  extern void clrscr();

  extern char (far * _VRAM)[];
  #define VRAM(x,y) ((*_VRAM)[y*160+2*x])
  #define CVRAM(x,y) ((*_VRAM)[y*160+2*x+1])

  extern unsigned long far * Timer;
  extern delay(int Ticks);
  extern char random();

  #define KB_ENTER       13
  #define KB_ESC         27
  #define KB_DOWN        0x5000
  #define KB_UP          0x4800
  #define KB_SHIFTTAB    0x0f00
  #define KB_STRGF10     0x6700

  extern int getch();
  extern int kbhit();

  extern strcpy(char* dest, char* src);

  int HDDRead(char drv, char head, char zyl, char sec, char num,
              void far* Buf);
  int HDDWrite(char drv, char head, char zyl, char sec, char num,
               void far* Buf);



#endif