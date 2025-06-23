//+------------------------------------------------------------------+
//|                                                 transparency.mq5 |
//|                              Copyright © 2014, Vladimir Karputov |
//|                                           http://wmua.ru/slesar/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2014, Vladimir Karputov"
#property link      "http://wmua.ru/slesar/"
#property version   "1.10"
#import "user32.dll"
//+------------------------------------------------------------------+
//| Retrieves the handle to the ancestor of the specified window.    |
//+------------------------------------------------------------------+
int GetAncestor(int hwnd,int gaFlags);
//+------------------------------------------------------------------+
//| Retrieves information about the specified window.                |
//+------------------------------------------------------------------+
int GetWindowLongW(int hWnd,
                   int nIndex);          // GWL_EXSTYLE
//+------------------------------------------------------------------+
//| Changes an attribute of the specified window                     |
//+------------------------------------------------------------------+
int SetWindowLongW(int hWnd,
                   char nIndex,        // GWL_EXSTYLE
                   int dwNewLong);     // WS_EX_LAYERED
//+------------------------------------------------------------------+
//| Sets the opacity and transparency color key of a layered window. |
//+------------------------------------------------------------------+
bool SetLayeredWindowAttributes(int hwnd,     // A handle to the layered window
                                int crKey,    // 0
                                int bAlpha,   // opacity 0-255
                                int dwFlags); // 0x00000002
#import
#define GA_ROOT            0x0002      // Retrieves the root window by walking the chain of parent windows.
#define GWL_EXSTYLE        -20         // Sets a new extended window style
#define WS_EX_LAYERED      0x00080000  // Style. The window is a layered window.
#define LWA_ALPHA          0x00000002  // Use bAlpha to determine the opacity of the layered window.
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//--- get ID of the current chart
   long mainChartID=ChartID();
   int hdlmainChartID=ChartWindowsHandle(mainChartID);
   int hdlRoot=GetAncestor(hdlmainChartID,GA_ROOT);
   int SetWindowLongW_func;
//--- set WS_EX_LAYERED on the ROOT window
   SetWindowLongW_func=SetWindowLongW(hdlRoot,GWL_EXSTYLE,
                                      GetWindowLongW(hdlRoot,GWL_EXSTYLE)|WS_EX_LAYERED);
   GetWindowLongW(hdlRoot,GWL_EXSTYLE);
   SetLayeredWindowAttributes(hdlRoot,0,(255*70)/100,LWA_ALPHA);
   return;
  }
//+------------------------------------------------------------------+
//| The function gets the chart handle                               |
//+------------------------------------------------------------------+
int ChartWindowsHandle(long chart_ID)
  {
//--- prepare the variable to get the property value
   long result=-1;
//--- reset the error value
   ResetLastError();
//--- receive the property value
   if(!ChartGetInteger(chart_ID,CHART_WINDOW_HANDLE,0,result))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__+", Error Code = ",GetLastError());
     }
//--- return the value of the chart property
   return((int)result);
  }
//+------------------------------------------------------------------+
