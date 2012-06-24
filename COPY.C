/*

Copyright message

(c) by Stefan Schimanski '1997

*/


#include "./include/copy.h"
#include "./include/tools.h"
#include "copy.scr"


/*#define COPYRIGHT_WIDTH 80
#define COPYRIGHT_DEPTH 25
#define COPYRIGHT_LENGTH 303
unsigned char COPYRIGHT [] = */


//==================================================

/*
 Data Structure:  <current byte>[<x>[<y>]]

    0..15 = New Foreground Color
   16..23 = New Background Color
       24 = Go down to next line, return to same horizontal position as when
            routine was started (akin to a c/r).
       25 = Displays <x> number of spaces.
       26 = Displays <x> number of <y>.  Also used to display ANY characters
            below #32.  This function is the only way to do this although it
            uses three bytes.  Otherwise the code would be interpreted as
            another command.
       27 = Toggles on/off the foreground attribute blink flag.
   28..31 = reserved
*/

void ShowCopyright()
{
  clrscr();

  char f=7; // Foreground
  char b=0; // Background
  char x=0;
  char y=0;

  for (int p=0; p<COPYRIGHT_LENGTH; p++)
  {
    unsigned char c=COPYRIGHT[p];

    if (c>=32)
    {
      VRAM(x,y)=c;
      CVRAM(x,y)=f+b*16;
      x++;
      if (x>=80) x=0;
    } else
    if (c<16)
    {
      f=c;
    } else
    if (c<24)
    {
      b=(b & 0x08)+c-16;
    } else
    switch (c)
    {
     case 24: x=0; y++; break;
     case 25: p++;
              for (int z=COPYRIGHT[p]+1; z>0; z--)
              {
                VRAM(x,y)=' ';
                CVRAM(x,y)=f+b*16;
                x++;
                if (x>=80) x=0;
              }
              break;
     case 26: p++;
              z=COPYRIGHT[p]+1;
              p++;
              c=COPYRIGHT[p];
              for (; z>0; z--)
              {
                VRAM(x,y)=c;
                CVRAM(x,y)=f+b*16;
                x++;
                if (x>=80) x=0;
              }
              break;
     case 27: b^=0x08; break;
     default: p++;
    }
  }

  /*char r=random();

  if (r==0)
  {
    print("Please enter the word \"Register\"");
    ret();

    Register:

    if (getch()!='R') goto Register;
    if (getch()!='e') goto Register;
    if (getch()!='g') goto Register;
    if (getch()!='i') goto Register;
    if (getch()!='s') goto Register;
    if (getch()!='t') goto Register;
    if (getch()!='e') goto Register;
    if (getch()!='r') goto Register;
  } else
  {
    print("Please wait...");
    ret();
    delay(3*18);
  } */

  unsigned long Target=*Timer+18*30;
  while (1)
  {
    if (*Timer>=Target) break;
    if (kbhit() && getch()==13 && (*((char far*)0x00400017) & 3)==3) break;
  }
}