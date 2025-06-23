//+------------------------------------------------------------------+
//|                                                    Clipboard.mq4 |
//|                                              PavelIvanovich(api) |
//|                                              p231970@hotmail.com |
//|               MQL5 version and unicode support by Alexey Sergeev |
//|                                              profy.mql@gmail.com |
//+------------------------------------------------------------------+
#property version "1.00"
#property description "Getting contents of the clipboard"

#import "user32.dll"
bool  OpenClipboard(int hwnd);
int   GetClipboardData(int uFormat);
bool  CloseClipboard();
int   GetAncestor(long hWnd,int gaFlags);
int   GetAncestor(int  hWnd,int gaFlags);
#import "kernel32.dll"
int   GlobalLock(int hMem);
bool  GlobalUnlock(int hMem);
string lstrcatW(int dst,string src);
#import
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
int OnStart()
  {
   int    hMain;
   string clip="";
//---
   if(_IsX64)
      hMain=GetAncestor(ChartGetInteger(ChartID(),CHART_WINDOW_HANDLE),2);
   else
      hMain=GetAncestor((int)ChartGetInteger(ChartID(),CHART_WINDOW_HANDLE),2);
//---
   if(OpenClipboard(hMain))
     {
      int hglb=GetClipboardData(1/*CF_TEXT*/);
      if(hglb!=0)
        {
         int lptstr=GlobalLock(hglb);

         if(lptstr!=0) { clip=lstrcatW(lptstr,""); GlobalUnlock(hglb); }
        }
      CloseClipboard();
     }

// translate ANSI to UNICODE
   ushort chW; uchar chA; string rez;
   for(int i=0; i<StringLen(clip); i++)
     {
      chW=StringGetCharacter(clip, i);
      chA=uchar(chW&255); rez=rez+CharToString(chA);
      chA=uchar(chW>>8&255); rez=rez+CharToString(chA);
     }

   MessageBox("Clipboard: \n"+rez,"Clipboard");
   return(0);
  }
//+------------------------------------------------------------------+
