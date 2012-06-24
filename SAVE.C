/*

SAVE.C

(c) by Stefan Schimanski '1997

*/


#include <stdio.h>
#include <stdlib.h>
#include <iostream.h>

int Size;
char Buffer[8192];


Read()
{
  cout << "Loading..." << endl;
  FILE* f=fopen("BOOTALL.DAT", "rb");
  if (f==NULL)
  {
    cout << "Couldn't open BOOTALL.DAT" << endl;
    exit(1);
  }

  fseek(f, 0, SEEK_END);
  Size=ftell(f);

  fseek(f, 0, SEEK_SET);
  fread(Buffer, 1, Size, f);

  fclose(f);
}


Crypt()
{
  cout << "Crypting file..." << endl;

  for (int p=0; p<Size; p++)
  {
    Buffer[p] ^= 0x7f;
  }
}


Save()
{
  cout << "Saving..." << endl;
  FILE* f=fopen("BOOTALL.DAT", "wb+");
  if (f==NULL)
  {
    cout << "Couldn't open BOOTALL.DAT" << endl;
    exit(1);
  }

  fwrite(Buffer, 1, Size, f);

  fclose(f);
}


main()
{
  cout << "Save 1.0 (c) by Stefan Schimanski" << endl;

  Read();
  Crypt();
  Save();
}