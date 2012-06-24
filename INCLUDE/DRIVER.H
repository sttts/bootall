/*

DRIVER.H

(c) by Stefan Schimanski '1997

*/

#ifndef DRIVER_H_INCLUDED
#define DRIVER_H_INCLUDED

  void* GetRect(int px, int py, int asx, int asy);
  void PutRect(void* Rect, int px, int py, int asx, int asy);

  void PutChar(int x, int y, char c, char Col);
  void PutString(int x, int y, char* s, char Col);
  void PutCursor(int x, int y);
  void GetCursor(int &x, int &y);

  int GetMaxX();
  int GetMaxY();

#endif