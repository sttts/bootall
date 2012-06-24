/*

BOOTMAN.C

(c) by Stefan Schimanski '1997

*/


#include "./include/tools.h"
#include "./include/part.h"
#include "./include/copy.h"

//define THOMAS


// MBR stuff ===========================================


CMbr MBR;


// Config stuff ========================================


CConfig Config;
int Configured=0;
int Registered=0;


// Booting stuff =======================================


void far* BootRec=(void far*)0x00007c00;

void Boot(char Drive, char Head, char Track, char Sec)
{
  HDDRead(Drive, Head, Track, Sec, 1, BootRec);
  asm jmp dword ptr BootRec
}


void Exclusive(char n)
{
  int Activated=0;

  for (int p=0; p<4; p++)
  {
    if (Config.Part[n].Drive==0x80 &&
        MBR.Part[p].StartTrack==Config.Part[n].Track &&
	MBR.Part[p].StartSec==Config.Part[n].Sec)
    {
      Activated = 1;
      MBR.Part[p].BootSig=0x80;
      if (MBR.Part[p].SysSig==0x11) MBR.Part[p].SysSig=0x01; else
      if (MBR.Part[p].SysSig==0x14) MBR.Part[p].SysSig=0x04; else
      if (MBR.Part[p].SysSig==0x1b) MBR.Part[p].SysSig=0x0b; else
      if (MBR.Part[p].SysSig==0x16) MBR.Part[p].SysSig=0x06;
    } else
    {
      MBR.Part[p].BootSig=0x0;
      if (MBR.Part[p].SysSig==0x01) MBR.Part[p].SysSig=0x11; else
      if (MBR.Part[p].SysSig==0x04) MBR.Part[p].SysSig=0x14; else
      if (MBR.Part[p].SysSig==0x0b) MBR.Part[p].SysSig=0x1b; else
      if (MBR.Part[p].SysSig==0x06) MBR.Part[p].SysSig=0x16;
    }
  }

  if (!Activated)
  {
    for (int p=0; p<4; p++)
    {
      if (MBR.Part[p].SysSig==0x05) MBR.Part[p].BootSig=0x80;
    }
  }

  HDDWrite(0x80, 0, 0, 1, 1, &MBR);
}

void BootActive()
{
  clrscr();

  for (int n=0; n<4; n++)
  {
    if ( (MBR.Part[n].SysSig!=0) && (MBR.Part[n].BootSig==0x80) ) break;
  }

  if (n<4)
  {
    Exclusive(n);
    Boot(0x80, MBR.Part[n].StartHead,
	       MBR.Part[n].StartTrack,
	       MBR.Part[n].StartSec);
  } else
  {
    print("Booting active partition failed...");
    while (1);
  }
}



// Error handling ======================================


void Error(char* Msg)
{
  print(Msg);
  print("\n\rTo load active partition please press a key!\n\r");
  getch();
  BootActive();
}


// Part ================================================


void ReadConfig()
{
  HDDRead(0x80, 0, 0, 1, 1, &MBR);

  if (MBR.EndSig!=0xaa55) Error("No valid MBR found");

  HDDRead(0x80, 0, 0, 16, 1, &Config);
  if (Config.Id==ID)
  {
    Configured = 1;
    if (Config.Version!=CONFIG_VERSION) Error("Wrong version of configuration");
  }

  Registered=Config.Registered;

  WORD Checksum=0x1234;
  for (int p=0; p<sizeof(Config)-2; p++)
  {
    Checksum+=*(((BYTE*)&Config)+p);
    Checksum^=*(((BYTE*)&Config)+p);
  }

  if (Checksum!=Config.Checksum) Registered=0;
}


// Menu ================================================


int Quit=0;
int Line=0;
int OldLine=0;
int Seconds=0;


void StartBalken()
{
  invert(Line+4);
}


void EndBalken()
{
  invert(OldLine+4);
}


void UpdateBalken()
{
  if (OldLine!=Line)
  {
    invert(OldLine+4);
    invert(Line+4);
  }

  OldLine = Line;
}


void BalkenHoch()
{
  if (Line>0) Line--;
}


void BalkenRunter()
{
  if (Line<Config.PartNum-1) Line++;
}


int RealBoot()
{
  int r=0;

  asm {
    mov ax, cs
    cmp ax, 0x6c00
    jne Dos
    mov word ptr r, 1
  }
  Dos:

  return r;
}


void ShowSeconds()
{
  if (Config.Seconds<255)
  {
    gotoxy(0, 24);
    printb(Seconds);
    print(" seconds until boot  ");
  }
}


int Menu()
{
  clrscr();

  print(BOOTALL " v"VERSION_S" (c) by Stefan Schimanski & Janko Heilgeist '"BUILDYEAR"\n\r");
  color(0, 0x1f);
  ret();
  print(Config.Message); ret();
  ret();

  if (!Configured) Error("No configuration loaded");
  if (Config.PartNum==0) Error("No partition found in configuration");

  for (int n=0; n<Config.PartNum; n++)
  {
    print(Config.Part[n].Text);
    ret();
  }

  if(Config.Seconds==255)
  {
    ret();
    print("Press SHIFT+TAB to boot default-partition");
  }

  ret();
  print("Press ESC to boot active partition");
  ret();

  int key = 0;
  int Selected = 0;
  Seconds = Config.Seconds;
  unsigned long NextSecondTime = *Timer+18;

  Line = Config.Default;
  if (Line==255) Line=0;
  OldLine = Line;

  StartBalken();
  ShowSeconds();

  while (!Selected && !Quit)
  {
    UpdateBalken();

    if (kbhit())
    {
      key = getch();

      switch(key)
      {
       case KB_UP: BalkenHoch(); break;
       case KB_DOWN: BalkenRunter(); break;
       case KB_ENTER: Selected=1; break;
       case KB_ESC: BootActive(); break;
       case KB_SHIFTTAB: Line = Config.Default;
			 if (Line==255) BootActive();
			 Selected = 1; break;
       case KB_STRGF10: if (!RealBoot())
			{
			  asm {
			    mov ax, 0x4c00
			    int 0x21
			  }
			}
			break;
      }

      Seconds = Config.Seconds;
      NextSecondTime = *Timer+18;
      ShowSeconds();

      key = 0;
    }

    if(Config.Seconds < 255)
    {
      if (*Timer > NextSecondTime || *Timer<18)
      {
        NextSecondTime+=18;
        Seconds--;
        if (Seconds==0)
        {
	  Line = Config.Default;
	  if (Line==255) BootActive();
	  Selected = 1;
        }

        ShowSeconds();
      }
    }
  }

  EndBalken();

  clrscr();

  return Line;
}


//======================================================

char far* SysKeys=(char far*)0x00400017;

void main()
{
  ReadConfig();

  #ifdef THOMAS
  if ( ((*SysKeys) & 4)==0 )
  {
    int n = Config.Default;

    Exclusive(n);
    Boot(Config.Part[n].Drive,
         Config.Part[n].Head,
         Config.Part[n].Track,
         Config.Part[n].Sec);
  } else
  #endif

  {
    //if (Registered!=1) ShowCopyright();

    while (!Quit)
    {
      int n=Menu();
      if (!Quit)
      {
        clrscr();
        Exclusive(n);
        Boot(Config.Part[n].Drive,
   	     Config.Part[n].Head,
             Config.Part[n].Track,
             Config.Part[n].Sec);
      }
    }
  }
}