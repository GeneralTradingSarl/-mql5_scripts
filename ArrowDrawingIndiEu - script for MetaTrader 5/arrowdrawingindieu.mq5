//+------------------------------------------------------------------+
//|                                             ArrowDrawingIndi.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
int MA_handle;

//-----------------------------------------------------
input string IndName="";  // Indicator name
input string ArrowUp="MyArrowUp"; // Name of up Signal
input string ArrowDown="MyArrowDown"; // Name of down Signal
input int upbuffer=1; // Number of up buffer
input int downbuffer=0; // Number of down buffer

//-----------------------------------------------------------------
double         Label1Buffer[];
double         Label1Buffer2[];
int timerup=0;
int timerdown=0;
datetime CurTime=0;
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

   MA_handle=iCustom(Symbol(),0,IndName,17,0,2,0,false,false,false);

//MA_handle=iCustom(Symbol(),0,IndName,param1, param2, param3, param4);   // <-----------------Example of adding your params here



//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnDeinit()
  {
//--- indicator buffers mapping
   ObjectDelete(0,ArrowUp);
   ObjectDelete(0,ArrowDown);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   CurTime=time[rates_total-1];
   if(timerup>0)
     {timerup --;}
   else
     {
      ObjectDelete(0,ArrowUp);

     }
   if(timerdown>0)
     {timerdown --;}
   else
     {

      ObjectDelete(0,ArrowDown);
     }
//---
   if(rates_total==prev_calculated)
     {
      return(rates_total);
     }

   int i=rates_total-2;

   CopyBuffer(MA_handle,upbuffer,0,rates_total,Label1Buffer);
   CopyBuffer(MA_handle,downbuffer,0,rates_total,Label1Buffer2);
   while(i<rates_total-1)
     {
      if(Label1Buffer[i]>0 /*&& CurTime<=time[i]*/)
        {
         ObjectCreate(0,ArrowUp,OBJ_ARROW_BUY,0,time[i],low[i]);timerup=5;
        }
      if(Label1Buffer2[i]>0 /*&& CurTime<=time[i]*/)
        {
         ObjectCreate(0,ArrowDown,OBJ_ARROW_SELL,0,time[i],high[i]);timerdown=5;
        }
      i++;
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+
