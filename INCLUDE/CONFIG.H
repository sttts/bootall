/*

CONFIG.H

(c) by Stefan Schimanski '1997

*/

#ifndef CONFIG_H_INCLUDED
#define CONFIG_H_INCLUDED


  #define ID 0x1234

  struct CConfig
  {
   int Id;

   BYTE Seconds;
   char Message[80];

   int PartNum;
   CPartition Part[16];

   char Dummy[512-85-16*sizeof(CPartition)];
  };


#endif