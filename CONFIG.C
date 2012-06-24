/*

CONFIG.C

(c) by Stefan Schimanski '1997

*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <conio.h>
#include <dos.h>
#include <dir.h>
#include <process.h>
#include "include/cwindow.h"
#include "include/driver.h"
#include "include/part.h"

#define REGISTERED 1

//#define MAKEPRIMARY

//======================================================


CConfig Config;
CMbr MBR;
int Saved=1;


//======================================================


int HDDRead(char drv, char head, char zyl, char sec, char num,
	      void far* Buf)
{
  int o=FP_OFF(Buf);
  int s=FP_SEG(Buf);
  int Err=0;

  asm {
    mov dx, s
    mov es, dx

    mov dl, drv
    mov dh, head
    mov ch, zyl
    mov cl, sec
    mov al, num
    mov bx, o
    mov ah, 2
    int 0x13
    jc KeinFehler
    mov al, ah
    mov ah, 0
    mov Err, ax
  }

 KeinFehler:
  return Err;
}


int HDDWrite(char drv, char head, char zyl, char sec, char num,
	      void far* Buf)
{
  int o=FP_OFF(Buf);
  int s=FP_SEG(Buf);
  int Err=0;
  asm {
    mov dx, s
    mov es, dx

    mov dl, drv
    mov dh, head
    mov ch, zyl
    mov cl, sec
    mov al, num
    mov bx, o
    mov ah, 3
    int 0x13
    jc KeinFehler
    mov al, ah
    mov ah, 0
    mov Err, ax
  }

 KeinFehler:
  return Err;
}



int LoadMBR(char drv, char head, char zyl, char sec)
{
  for (int n=0; n<4; n++) MBR.Part[n].SysSig = 0;
  return HDDRead(drv, head, zyl, sec, 1, &MBR);
};


void NewConfig()
{
  Config.Id = ID;
  Config.Version = CONFIG_VERSION;
  Config.Seconds = 10;
  strcpy(Config.Message, "Welcome...");
  Config.PartNum = 0;
  Config.Default = 255;
  Config.Registered = 0;

  Saved=0;
}


void SaveConfig()
{
  Config.Registered=REGISTERED;
  WORD Checksum=0x1234;
  for (int p=0; p<sizeof(Config)-2; p++)
  {
    Checksum+=*(((BYTE*)&Config)+p);
    Checksum^=*(((BYTE*)&Config)+p);
  }

  Config.Checksum=Checksum;

  if (HDDWrite(0x80, 0, 0, 16, 1, &Config)==0)
  {
    Saved=1;
    Message("Config saved");
  }
  else Message("Saving failed");
}


void LoadConfig()
{
  HDDRead(0x80, 0, 0, 16, 1, &Config);

  if (Config.Id!=ID) NewConfig(); else
  {
    WORD Checksum=0x1234;
    for (int p=0; p<sizeof(Config)-2; p++)
    {
      Checksum+=*(((BYTE*)&Config)+p);
      Checksum^=*(((BYTE*)&Config)+p);
    }

    if (Config.Checksum!=Checksum)
    {
      Message("Corrupt or no configuration found.\nI will create a new configuration");
      NewConfig();
      return;
    }

    if (Config.Version!=CONFIG_VERSION)
    {
      Message("Configuration has wrong version.\nI will create a new configuration");
      NewConfig();
    } else Message("Configuration loaded");
  }
}


//======================================================


char* SysType(int SysSig)
{
      switch(SysSig)
      {
       case 0x00:  return "empty";
       case 0x01:  return "DOS-12";
       case 0x02:  return "XENIX";
       case 0x03:  return "XENIX/usr";
       case 0x04:  return "DOS-16";
       case 0x05:  return "Extended";
       case 0x06:  return "DOS large";
       case 0x07:  return "QNX, HPFS";
       case 0x08:  return "AIX boot";
       case 0x09:  return "AIX data";
       case 0x0b:  return "FAT32";
       case 0x11:  return "hidden DOS-12";
       case 0x14:  return "hidden DOS-16";
       case 0x15:  return "Extended > 8GB";
       case 0x16:  return "hidden DOS large";
       case 0x1b:  return "hidden FAT32";
       case 0x51:  return "Disk Manager";
       case 0x0a:  return "Boot Manager";
       case 0x52:  return "CP/M";
       case 0x56:  return "GB";
       case 0x61:  return "SpeedStor";
       case 0x63:  return "SysV/386";
       case 0x64:  return "Netware";
       case 0x75:  return "PC/IX";
       case 0x80:  return "Minix 1.3";
       case 0x81:  return "Minix 1.5";
       case 0x83:  return "Linux";
       case 0x82:  return "Linux swap";
       case 0xdb:  return "CP/M";
       case 0xe1:  return "SpeedStor-12";
       case 0xe4:  return "SpeedStor-16";
       case 0xfe:  return "LANstep";
       case 0xff:  return "Bad blocks";
       default:	return itoa(SysSig, "       ", 16);
      }
}


//======================================================


char Drive=0x80;

char StrBuf[256];

char* GetPartition(int n)
{
  sprintf(StrBuf, "%-3u%-15s   C%-6u H%-6u S%-6u",
	    n,
	    SysType(MBR.Part[n].SysSig),
	    MBR.Part[n].StartTrack,
	    MBR.Part[n].StartHead,
	    MBR.Part[n].StartSec);
  return StrBuf;
}


int GetExtended()
{
  for (int n=0; n<4; n++)
  {
    if (MBR.Part[n].SysSig==5 || MBR.Part[n].SysSig==15) return n;
  }

  return -1;
}


char* GetAdded(int n)
{
  char Flags[3]="  ";

  if (n>=Config.PartNum) return NULL; else
  {
    if (Config.Default==n) Flags[0] = '*';
    if (Config.Part[n].Flags & PART_MAKEPRIMARY) Flags[1] = 'P';

    sprintf(StrBuf, "%s %-3u%-17s%-7cC%-6uH%-6uS%-6u%-12s", Flags,
       n, Config.Part[n].Text, Config.Part[n].Drive-61,
       Config.Part[n].Track, Config.Part[n].Head, Config.Part[n].Sec,
       SysType(Config.Part[n].SysSig));

    return StrBuf;
  }
}


void ShowPartitions()
{
  LoadMBR(Drive, 0, 0, 1);

  int Quit=0;

  while (!Quit)
  {
    CMenu Menu;
    for (int n=0; n<4; n++)
      Menu.InsertItem(GetPartition(n));

    Menu.Run();
    int Selected=Menu.GetSelected();
    if (Selected==99) return;
    if (MBR.Part[Selected].SysSig==5 || MBR.Part[Selected].SysSig==15)
    {
      LoadMBR(Drive, MBR.Part[Selected].StartHead,
		     MBR.Part[Selected].StartTrack,
		     MBR.Part[Selected].StartSec);

    } else Message("%s",GetPartition(Selected));
  }
}


void AddPartition()
{
  if (Config.PartNum>=16)
  {
    Message("Only 16 partitions can be added");
    return;
  }

  LoadMBR(Drive, 0, 0, 1);

  int Quit=0;

  while (!Quit)
  {
    CMenu Menu;
    for (int n=0; n<4; n++)
      Menu.InsertItem(GetPartition(n));

    Menu.Run();
    int Selected=Menu.GetSelected();
    if (Selected==99) return;
    if (MBR.Part[Selected].SysSig==5 || MBR.Part[Selected].SysSig==15)
    {
      LoadMBR(Drive, MBR.Part[Selected].StartHead,
		     MBR.Part[Selected].StartTrack,
		     MBR.Part[Selected].StartSec);

    } else
    {
      int New=Selected;
      CEdit Edit("Name: ", "", 15);
      Edit.Run();

      int n=Config.PartNum;
      strcpy(Config.Part[n].Text, Edit.GetInput());
      Config.Part[n].Head = MBR.Part[New].StartHead;
      Config.Part[n].Sec = MBR.Part[New].StartSec;
      Config.Part[n].Track = MBR.Part[New].StartTrack;
      if (MBR.Part[New].SysSig==0x11) MBR.Part[New].SysSig=0x01; else
      if (MBR.Part[New].SysSig==0x14) MBR.Part[New].SysSig=0x04;
      Config.Part[n].SysSig = MBR.Part[New].SysSig;
      Config.Part[n].Drive = Drive;
      Config.Part[n].Flags = 0;

      Config.PartNum++;
      return;
    }
  }
}


void RemovePartition()
{
  if (Config.PartNum>0)
  {
    CMenu Menu;
    for (int n=0; n<Config.PartNum; n++)
      Menu.InsertItem(GetAdded(n));

    Menu.Run();
    int Selected=Menu.GetSelected();
    if (Selected==99) return;

    if (Config.Default>Selected && Config.Default<255) Config.Default--;
    if (Config.Default==Selected) Config.Default=255;

    memcpy(&Config.Part[Selected], &Config.Part[Selected+1],
           sizeof(CPartition)*(Config.PartNum-Selected-1));
    Config.PartNum--;
  } else Message("No partitions added");
}


void ModifyPartition()
{
  if (Config.PartNum>0)
  {
    CMenu Menu;
    for (int n=0; n<Config.PartNum; n++)
      Menu.InsertItem(GetAdded(n));

    Menu.Run();
    int Selected=Menu.GetSelected();
    if (Selected==99) return;

    if (Selected<Config.PartNum)
    {
      CEdit Edit("Name: ", Config.Part[Selected].Text, 15);
      Edit.Run();
      strcpy(Config.Part[Selected].Text, Edit.GetInput());
    }
  } else Message("No partitions added");
}


int DriveExist(char aId)
{
  int Err=0;

  asm {
    mov ah, 0x15
    mov dl, aId
    int 0x13
    jc Raus
    mov al, ah
    mov ah, 0
    mov Err, ax
  }

 Raus:
  return Err;
}


void ChangeDrive()
{
/* char Def[4];
  CEdit Edit("Drive: ",itoa(Drive,Def,10),3,"0123456789");
  Edit.Run();

  int New = atoi(Edit.GetInput());
  if (New!=0x80 && New!=0x81)
  {
    Message("Only drive 128 and 129 allowed");
  } else Drive = New;*/

  CMenu* Menu=new CMenu;
  Menu->SetTitle("Drive selection");
  if (DriveExist(0x80+0)) Menu->InsertItem("Drive 1"); else Menu->InsertLine();
  if (DriveExist(0x80+1)) Menu->InsertItem("Drive 2"); else Menu->InsertLine();
  if (DriveExist(0x80+2)) Menu->InsertItem("Drive 3"); else Menu->InsertLine();
  if (DriveExist(0x80+3)) Menu->InsertItem("Drive 4"); else Menu->InsertLine();
  Menu->Run();

  int Result=Menu->GetSelected();
  if (Result!=99)
	Drive = Result+0x80;
  delete Menu;
}


void SetDefault()
{
  if (Config.PartNum>0)
  {
    CMenu Menu;
    for (int n=0; n<Config.PartNum; n++)
      Menu.InsertItem(GetAdded(n));

    Menu.InsertLine();
    Menu.InsertItem("No default");

    Menu.Run();
    int New=Menu.GetSelected();
    if (New==99) return;

    if (New<Config.PartNum) Config.Default=New; else
      Config.Default=255;
  } else Message("No partitions added");
}


void SetFlags()
{
  if (Config.PartNum>0)
  {
    CMenu Menu;
    for (int n=0; n<Config.PartNum; n++)
      Menu.InsertItem(GetAdded(n));

    Menu.Run();
    int New=Menu.GetSelected();
    if (New==99) return;

    if (New<Config.PartNum)
    {
      Config.Part[New].Flags ^= PART_MAKEPRIMARY;
    }
  }
}



void EditPartitions()
{
  CMenu Menu;
  Menu.InsertItem("Show partitions");
  Menu.InsertItem("Add partition");
  Menu.InsertItem("Remove partition");
  Menu.InsertItem("Modify partition");
  Menu.InsertItem("Change drive");
  Menu.InsertItem("Set default");
#ifdef MAKEPRIMARY
  Menu.InsertItem("Make primary");
#endif

  int Selected=0;

  do
  {
    if (Config.PartNum>0)
    {
      CList Added;
      for (int n=0; n<Config.PartNum; n++)
	Added.InsertItem(GetAdded(n));

      Added.MoveTo(1,2);
      Added.SizeTo(78,Config.PartNum+2);

      Added.Show();
      Menu.Run();
      Added.Hide();
    } else Menu.Run();

    Selected=Menu.GetSelected();

    LoadMBR(Drive,0,0,1);

    switch(Selected)
    {
     case 0: ShowPartitions(); break;
     case 1: AddPartition(); break;
     case 2: RemovePartition(); break;
     case 3: ModifyPartition(); break;
     case 4: ChangeDrive(); break;
     case 5: SetDefault(); break;
     case 6: SetFlags(); break;
    }
  } while (Selected!=99);
}


void EditSeconds()
{
  char Def[4];
  CEdit Edit("Seconds: ",itoa(Config.Seconds,Def,10),3,"0123456789");

  Edit.Run();
  int New=atoi(Edit.GetInput());
  if (New>0 && New<256) Config.Seconds = New; else
  {
    Message("Must be between 1 and 255");
  }
}


void EditMessage()
{
  CEdit Edit("Message: ",Config.Message,60);
  Edit.Run();

  strcpy(Config.Message, Edit.GetInput());
}


void ShowMenu()
{
  Saved=0;

  CMenu Menu;
  Menu.InsertItem("Edit message");
  Menu.InsertItem("Edit seconds");
  Menu.InsertItem("Edit partitions");

  int Selected=0;

  do
  {
    CMessage Info(1,2,78,4, "Message: %s\nSeconds: %u",
                            Config.Message, Config.Seconds);
    Info.Show();
    Menu.Run();
    Info.Hide();

    Selected=Menu.GetSelected();
    switch(Selected)
    {
     case 0: EditMessage(); break;
     case 1: EditSeconds(); break;
     case 2: EditPartitions(); break;
    }
  } while (Selected!=99);
}


char Buf[8192];


void SaveTrack()
{
  CMenu Menu;
  Menu.SetTitle("Do you really want to save track 0 head 0 to disk?");
  Menu.InsertItem("Yes :-)");
  Menu.InsertItem("No  :-(");
  Menu.Run();

  if (Menu.GetSelected()==0)
  {
    if (HDDRead(0x80, 0, 0, 1, 16, Buf)!=0)
    {
      Message("Error while reading track");
      return;
    }

    CEdit Edit("Filename: ", "BACKUP", 8);
    Edit.Run();
    char* Input=Edit.GetInput();
    char FName[11];
    strcpy(FName, Input);
    strcat(FName, ".SAV");


    FILE* f=fopen(FName, "w+b");
    if (f==NULL)
    {
      Message("Couldn't create %s", FName);
      return;
    }

    if (fwrite(Buf, 1, 8192, f)!=8192)
    {
      Message("Couldn't write to file %s", FName);
      return;
    }

    fclose(f);

    Message("Successful");
  }
}


void RestoreTrack()
{
  CMessage Info(2,2,76,5,"If you have changed the master boot record after saving track 0\n"
                         "it's not save to restore.\n"
                         "All changes will be lost!");
  Info.Show();

  CMenu Menu;
  Menu.SetTitle("Do you want to restore track 0 head 0 to disk?");
  Menu.InsertItem("Yes");
  Menu.InsertItem("No");

  Menu.Run();
  if (Menu.GetSelected()==0)
  {
    CMenu Dir;
    Dir.SetTitle("Available files");

    ffblk ffblk;
    int done = findfirst("*.SAV",&ffblk,0);
    while (!done)
    {
      Dir.InsertItem("%s", ffblk.ff_name);
      done = findnext(&ffblk);
    }
    Dir.Run();

    if (Dir.GetSelected()==99) return;
    char* FName=Dir.GetText();

    FILE* f=fopen(FName, "rb");
    if (f==NULL)
    {
      Message("Couldn't open %s", FName);
      return;
    }

    if (fread(Buf, 1, 8192, f)!=8192)
    {
      Message("Couldn't read from %s or invalid file format", FName);
      return;
    }

    fclose(f);

    if (HDDWrite(0x80, 0, 0, 1, 16, Buf)!=0)
    {
      Message("Error while writing track");
      return;
    }

    Message("Successful");
  }

  Info.Hide();
}


void Install()
{
  CBar Bar(4, GetMaxY()-5, 72, 0, 100, 0);
  Bar.SetTitle("Process");
  Bar.Show();

  //=======================================================

  SaveTrack();
  Bar.Update(10);

  //=======================================================

  if (Message("I'm going to load current master boot record...")==27)
  {
    Message("Interrupted by user");
    Bar.Hide();
    return;
  }

  if (LoadMBR(0x80,0,0,1)!=0)
  {
    Message("Failed!!!\nCouldn't load MBR.");
    Bar.Hide();
    return;
  }

  Bar.Update(20);

  //=======================================================

  if (Message(
         "BOOTALL will be installed at 0/0/2 (Track/Head/Sector) at HDD 0.\n"
         "Normally this area isn't occupied by any partition.\n\n"
         "I'm going to check first 4 partitions...")==27)
  {
    Message("Interrupted by user");
    Bar.Hide();
    return;
  }

  for (int n=0; n<4; n++)
  {
    if (MBR.Part[n].SysSig!=0 &&
        MBR.Part[n].StartTrack==0 && MBR.Part[n].StartHead==0) break;
  }
  if (n<4)
  {
     Message("Failed!!!\n"
             "Sorry, but partition %u uses this area.\n\n"
             "Can't install BOOTALL on this harddisk.", n);
     Bar.Hide();
     return;
  }

  Bar.Update(30);

  //=======================================================

  CMenu Menu;
  Menu.SetTitle("Install BOOTALL on your harddisk?");
  Menu.InsertItem("Yes 8-)");
  Menu.InsertItem("No  8-(");
  Menu.Run();

  if(Menu.GetSelected()!=0)
  {
    Message("Interrupted by user");
    Bar.Hide();
    return;
  }
  Bar.Update(50);

  //=======================================================


  if (Message("Now I'm going to load BOOTALL.DAT...")==27)
  {
    Message("Interrupted by user");
    Bar.Hide();
    return;
  }

  FILE* f;
  f = fopen("BOOTALL.DAT", "rb");
  if (f==NULL)
  {
    Message("Failed!!!\nCouldn't open BOOTALL.DAT");
    Bar.Hide();
    return;
  }

  fseek(f, 0, SEEK_END);
  int size=ftell(f);
  fseek(f, 0, SEEK_SET);

  if (size+256>8129)
  {
    fclose(f);
    Message("Failed!!!\nBOOTALL.DAT too long.");
    Bar.Hide();
    return;
  }

  if (fread(&(Buf[256]), 1, size, f)!=size)
  {
    fclose(f);
    Message("Failed!!!\nError while reading BOOTALL.DAT");
    Bar.Hide();
    return;
  }

  fclose(f);

  Bar.Update(60);


  //=======================================================


  if (Message("Now I'm going to install BOOTALL...")==27)
  {
    Message("Interrupted by user");
    Bar.Hide();
    return;
  }

  if (HDDWrite(0x80, 0, 0, 2, (size+256+511)/512, Buf)!=0)
  {
    Message("Failed!!!\nError while writing to harddisk.");
    Bar.Hide();
    return;
  }

  Bar.Update(70);


  //=======================================================


  if (Message("Trying to load new MBR...")==27)
  {
    Message("Interrupted by user");
    Bar.Hide();
    return;
  }

  f = fopen("MBR.DAT", "rb");
  if (f==NULL)
  {
    Message("Failed!!!\nCouldn't open MBR.DAT.");
    Bar.Hide();
    return;
  }

  fseek(f, 0, SEEK_END);
  size=ftell(f);
  fseek(f, 0, SEEK_SET);

  if (size>446)
  {
    fclose(f);
    Message("Failed!!!\nMBR.DAT too long.");
    Bar.Hide();
    return;
  }

  if (fread(MBR.Code, 1, size, f)!=size)
  {
    fclose(f);
    Message("Failed!!!\nError while reading MBR.DAT.");
    Bar.Hide();
    return;
  }

  fclose(f);

  Bar.Update(80);


  //=======================================================


  if (Message("Trying to install new MBR...")==27)
  {
    Message("Interrupted by user");
    Bar.Hide();
    return;
  }


  if (HDDWrite(0x80, 0, 0, 1, 1, &MBR)!=0)
  {
    Message("Failed!!!\nError while writing to harddisk.");
    Bar.Hide();
    return;
  }

  Bar.Update(100);


  //======================================================


  Message("Congratulations!!!\nInstallation of BOOTALL has been finished\n\n"
          "If you haven't configured BOOTALL yet,\n"
          "you have to do it now!");

  Bar.Hide();
}


void Remove()
{
  CMenu Menu;
  Menu.SetTitle("Do you really want to remove BOOTALL?");
  Menu.InsertItem("No  :-)");
  Menu.InsertItem("Yes :-(");
  Menu.Run();

  if (Menu.GetSelected()==1)
  {
    Message("I'm go to run FDISK /MBR");
    CSave* Save=new CSave;
    clrscr();
    if (execlp("FDISK.EXE", "FDISK.EXE", "/MBR", NULL)!=0)
    {
      delete Save;
      Message("Error while running fdisk");
    } else delete Save;
  }
}


//=========================================================


int CanClose()
{
  if (!Saved) Message("Caution! You haven't written your configuration to disk!");

  CMenu* Menu=new CMenu;
  Menu->SetTitle("Do you really want to quit BOOTALL configuration?");
  Menu->InsertItem("No");
  Menu->InsertItem("Yes");
  Menu->Run();
  int Result=Menu->GetSelected()==1;
  delete Menu;
  return Result;
}


void MainMenu()
{
  CMenu* Menu=new CMenu;
  Menu->InsertItem("Edit configuration");
  Menu->InsertItem("New configuration");
  Menu->InsertItem("Load configuration");
  Menu->InsertItem("Write configuration");
  Menu->InsertLine();
  Menu->InsertItem("Install BOOTALL");
  Menu->InsertItem("Remove BOOTALL (fdisk /mbr)");
  Menu->InsertLine();
  Menu->InsertItem("Save track zero");
  Menu->InsertItem("Restore track zero");

  int Quit=0;

  do
  {
     Menu->Run();
     int Selected=Menu->GetSelected();

     switch (Selected)
     {
       case 0: ShowMenu(); break;
       case 1: NewConfig(); break;
       case 2: LoadConfig(); break;
       case 3: SaveConfig(); break;
       case 5: Install(); break;
       case 6: Remove(); break;
       case 8: SaveTrack(); break;
       case 9: RestoreTrack(); break;
       case 99: if (CanClose()) Quit=1; break;
     }
  } while (!Quit);

  delete Menu;
}


//=========================================================


#include "config.scr"


void CopyRight()
{
  CCrunchWindow Win(0,5,80,14,COPYRIGHT,COPYRIGHT_LENGTH);
  Win.Show();
  getch();
  Win.Hide();
}


//=========================================================


void main()
{

  CDesktop Desk(BOOTALL " Configuration (Version " VERSION_S ")",
                "(c) by Stefan Schimanski and Janko Heilgeist '" BUILDYEAR);
  Desk.Show();

  CopyRight();

  LoadConfig();
  MainMenu();

  Desk.Hide();
}