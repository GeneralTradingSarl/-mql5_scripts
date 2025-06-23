//+------------------------------------------------------------------+
//|                                           SCT_BestDayToTrade.mq4 |
//|                                    Copyright 2020, . |
//|                                         mario.gharib@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright "
#property version   "1.00"
#property strict
#property script_show_inputs

input int iRange = 60;   // Period: Specify the number of days

int TimeDayOfWeekMQL4(datetime date)
  {
   MqlDateTime tm;
   TimeToStruct(date,tm);
   return(tm.day_of_week);
  }

double pipPos(string sSymbol) {

   if (SymbolInfoInteger(sSymbol,SYMBOL_DIGITS)==1 || SymbolInfoInteger(sSymbol,SYMBOL_DIGITS)==3 || SymbolInfoInteger(sSymbol,SYMBOL_DIGITS)==5)
      return SymbolInfoDouble(sSymbol,SYMBOL_POINT)*10;
   else 
      return SymbolInfoDouble(sSymbol,SYMBOL_POINT)*1;;   
   
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class cCandlestick {

   public:

      datetime dtTime;
      double dRangeCandle;
      double dHighPrice;
      double dLowPrice;
      int iDayOfWeek;
      string sDayOfWeek;
      
      void mvGetCandleStickCharateristics (string s, int i) {
         
         dtTime = iTime(s, PERIOD_D1, i);
         dHighPrice = iHigh(s, PERIOD_D1,i);
         dLowPrice = iLow(s, PERIOD_D1,i);
         
         dRangeCandle = NormalizeDouble(MathAbs(dHighPrice-dLowPrice)/pipPos(Symbol()),4);
         iDayOfWeek = TimeDayOfWeekMQL4(dtTime);
         
         if (iDayOfWeek==1) sDayOfWeek="Monday";
         else if (iDayOfWeek==2) sDayOfWeek="Tuesday";
         else if (iDayOfWeek==3) sDayOfWeek="Wednesday";
         else if (iDayOfWeek==4) sDayOfWeek="Thursday";
         else if (iDayOfWeek==5) sDayOfWeek="Friday";

      }
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
{
   int i;

   int handle = FileOpen(Symbol()+"_D1_history"+".csv",FILE_CSV|FILE_READ|FILE_WRITE,',');
   
   if(handle>0) {

      FileSeek(handle,0,SEEK_SET);
      FileWrite(handle,"Date","DayOfWeek","Range in Pips");
         
      cCandlestick cCS;
            
      for (i=1;i<=iRange;i++) {
         
         cCS.mvGetCandleStickCharateristics(_Symbol,i);
         FileWrite(handle, TimeToString(cCS.dtTime), cCS.sDayOfWeek, DoubleToString(cCS.dRangeCandle,5));

      }
   }
   FileClose(handle);

}