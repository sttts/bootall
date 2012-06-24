/*

CWINDOW.H

(c) by Stefan Schimanski '1997

*/

#ifndef CWINDOW_H_INCLUDED
#define CWINDOW_H_INCLUDED


  #include <stdlib.h> 
  #include <stdarg.h>


  #define CWINDOW_STRING "CWindow"
  #define CWINDOW_VERSIONSTR "0.4"
  #define CWINDOW_VERSION 0x0040


  class CView
  {
   public:
    CView(int apx, int apy, int asx, int asy);
    virtual ~CView();

    void Run();
    void Show();
    void Hide();
    void Redraw();
    virtual void Action();

    void MoveTo(int x, int y){px=x; py=y;}
    void SizeTo(int x, int y){sx=x; sy=y;}
    void Move(int x, int y){px+=x; py+=y;}
    void Size(int x, int y){sx+=x; sy+=y;}

   protected:
    void SaveBackground();
    void RestoreBackground();

    virtual void Draw();
    virtual void UpdateCursor();
    virtual inline char ColorIndex(char Num);
    inline char Color(char Num);

    int px, py, sx, sy;

   private:
    void* Background;
    int OldCursorX, OldCursorY;
  };


  class CDesktop:public CView
  {
   public:
    CDesktop(char* Top, char* Bottom);
    virtual ~CDesktop();

   protected:
    virtual void Draw();

    virtual void DrawBackground();
    virtual void DrawTop();
    virtual void DrawBottom();
    virtual inline char ColorIndex(char Num);

   private:
    char* TopMsg;
    char* BottomMsg;
  };


  class CWindow:public CView
  {
   public:
    CWindow(int apx, int apy, int asx, int asy);
    virtual ~CWindow();

    virtual void SetTitle(char* aTitle);
    void SetBorder(char* aBorder);

   protected:
    virtual void Draw();
    virtual void DrawBorder();
    virtual void DrawContent();
    virtual inline char ColorIndex(char Num);

    char* Title;
    char* Border;
  };


  class CMessage:public CWindow
  {
   public:
    CMessage(char* Msg, ...);
    CMessage(char* Msg, va_list arg);
    CMessage(int apx, int apy, int asx, int asy, char* Msg, ...);
    CMessage(int apx, int apy, char* Msg, ...);
    virtual ~CMessage();

    SetMessage(char* Msg,...);
    virtual void Action();

   protected:
    virtual void DrawContent();
    virtual inline char ColorIndex(char Num);

    char* Message;
    int Lines;
    int Cols;

   private:
    void CheckMessage();
  };


  class CList:public CWindow
  {
   public:
    CList(int aMaxHeight=23);
    virtual ~CList();

    void InsertItem(char* Msg, ...);
    void InsertLine();
    virtual void SetTitle(char* aTitle);
    void SetCenter(int On);
    void ScrollTo(int aPos);
    void Scroll(int aPos);

   protected:
    virtual void DrawContent();
    virtual inline char ColorIndex(char Num);

    char* Items[256];
    int Pos;
    int Num;
    int MaxLen;
    int Center;
    int MaxHeight;
  };


  class CMenu:public CList
  {
   public:
    CMenu(int aWarping=1, int aMaxHeight=23);
    virtual ~CMenu();

    int GetSelected();
    void SetSelected(int New);
    char* GetText();
    virtual void Action();

    void Up();
    void Down();

   protected:
    virtual void DrawContent();
    virtual inline char ColorIndex(char Num);

    int Selected;
    int Escaped;
    int Warping;
  };


  class CEdit:public CWindow
  {
   public:
    CEdit(char* Msg, char* Default, int aMaxLen, char* aKeys=NULL, int aSecret=0);
    virtual ~CEdit();

    char* GetInput();
    virtual void Action();

   protected:
    virtual void DrawContent();
    virtual inline char ColorIndex(char Num);

   private:
    void Insert(char c);
    void BackSpace();
    void Delete();
    virtual void UpdateCursor();

    char* Input;
    char* Message;
    int MaxLen;
    char* Keys;
    int Pos;
    int MsgLen;
    int Secret;
  };


  class CCrunchWindow:public CWindow
  {
   public:
    CCrunchWindow(int apx, int apy, int asx, int asy, unsigned char* aCrunch, int aLen);
    virtual ~CCrunchWindow();

   protected:
    virtual void DrawContent();
    virtual inline char ColorIndex(char Num);

   private:
    char* Crunch;
    int Length;
  };


  class CBar:public CWindow
  {
   public:
    CBar(int apx, int apy, int asx, int aMin, int aMax, int aValue=0);
    virtual ~CBar();

    void Update(int aValue);
    void Update();

   private:
    int Min;
    int Max;
    int Value;

    virtual void DrawContent();
    virtual inline char ColorIndex(char Num);
  };


  class CSave:public CView
  {
   public:
    CSave();
    virtual ~CSave();
  };


  //===============================================


  char Message(char* Msg, ...);
  char TitleMessage(char* Title, char* Msg,...);

  extern char stdBorder[];
  extern char dblBorder[];
  extern char stdColor[];

  const ColView        =0;
  const ColDesktop     =0;
  const ColWindow      =3;
  const ColMessage     =6;
  const ColMenu        =9;
  const ColList	       =13;
  const ColEdit        =16;
  const ColBar         =20;
  const ColCrunchWin   =25;

  char Color(char Num);
  void SetColors(char* Palette);

#endif