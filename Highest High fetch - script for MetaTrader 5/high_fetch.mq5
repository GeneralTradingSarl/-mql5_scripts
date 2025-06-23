//+------------------------------------------------------------------+
//|                                                   High Fetch.mq5 |
//|                                                               Sj |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Sj"
#property link      "https://www.mql5.com"
#property version   "1.00"

// ---- Global variables ----
   int StartHour = 12;
   int StartMins = 0; 
   int EndHour = 16; 
   int EndMins = 0; 
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+ 
void OnStart()
  {
   double highPrice = RangeHighs(StartHour,StartMins,EndHour,EndMins);
   Print(highPrice);
  }
//+------------------------------------------------------------------+  
    double RangeHighs(int pStartHour,int pStartMins, int pEndHour,int pEndMins)
     {
      MqlDateTime time{};
      TimeCurrent(time);
      time.sec  = 0;
      time.hour = pStartHour;
      time.min  = pStartMins;
      datetime timeStart = StructToTime(time);
      //-------------------
      time.hour = pEndHour;
      time.min  = pEndMins;
      datetime timeEnd   = StructToTime(time);
      //-------------------  
      double high[]; 
      ArraySetAsSeries(high,true);
      CopyHigh(_Symbol,PERIOD_CURRENT,timeStart,timeEnd,high);
      int highestbar = ArrayMaximum(high,0,WHOLE_ARRAY);  
      return high[highestbar];
     }
     
