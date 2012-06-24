/*

PART.H

(c) by Stefan Schimanski '1997

*/

#ifndef PART_H_INCLUDED
#define PART_H_INCLUDED


  #define BYTE unsigned char
  #define WORD unsigned int
  #define DWORD unsigned long


  struct CBIOSPart
  {
    BYTE BootSig;
    BYTE StartHead;
    BYTE StartSec;
    BYTE StartTrack;
    BYTE SysSig;
    BYTE EndHead;
    BYTE EndSec;
    BYTE EndTrack;
    DWORD PrecSec;
    DWORD PartLen;
  };

  struct CMbr
  {
    BYTE Code[446];
    CBIOSPart Part[4];
    WORD EndSig;
  };

  #define PART_MAKEPRIMARY 1

  struct CPartition
  {
   char Text[16];
   BYTE Head;
   BYTE Sec;
   BYTE Track;
   BYTE SysSig;
   BYTE Drive;
   BYTE Flags;
  };



  #define ID 0x1234
  #define CONFIG_VERSION 0x0103
  #define VERSION 0x0108
  #define VERSION_S "1.08"
  #define BUILDYEAR "1999"
  #define BOOTALL "BOOTALL 97"

  struct CConfig
  {
   int Id;
   WORD Version;

   BYTE Seconds;
   char Message[80];

   int PartNum;
   CPartition Part[16];
   BYTE Default;

   BYTE Registered;

   char Dummy[512-91-16*sizeof(CPartition)];
   WORD Checksum;
  };


#endif