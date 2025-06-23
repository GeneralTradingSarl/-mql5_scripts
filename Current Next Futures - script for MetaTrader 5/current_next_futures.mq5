//+------------------------------------------------------------------+
//|                                         Current Next Futures.mq5 |
//|                                         Copyright 2016, Serj_Che |
//|                           https://www.mql5.com/ru/users/serj_che |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Serj_Che"
#property link      "https://www.mql5.com/ru/users/serj_che"
#property version   "1.00"
#property script_show_inputs

input string name="";
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   Comment(
           "\n Last Futures: ",LastFutures(name),
           "\n Current Futures: ",CurrFutures(name),
           "\n Next Futures: ",NextFutures(name),
           "");
  }
//+------------------------------------------------------------------+
string CurrFutures(string short_name)
  {
   StringToUpper(short_name);
   string long_name;
   MqlDateTime time;
   TimeCurrent(time);
   int year=time.year;
   int mon=time.mon;
   for(int i=0; i<12; i++)
     {
      if(mon>12) { mon=1; year++; }
      StringConcatenate(long_name,short_name,"-",mon,".",year%100);
      if(SymbolSelect(long_name,true))
        {
         if(SymbolInfoInteger(long_name,SYMBOL_EXPIRATION_TIME)>TimeCurrent()) break;
        }
      mon++;
      long_name="";
     }
   return(long_name);
  }
//+------------------------------------------------------------------+
string NextFutures(string short_name)
  {
   StringToUpper(short_name);
   string long_name;
   MqlDateTime time;
   TimeCurrent(time);
   int year=time.year;
   int mon=time.mon;
   datetime currtime=0;
   for(int i=0; i<12; i++)
     {
      if(mon>12) { mon=1; year++; }
      StringConcatenate(long_name,short_name,"-",mon,".",year%100);
      if(SymbolSelect(long_name,true))
        {
         int expirat=(int)SymbolInfoInteger(long_name,SYMBOL_EXPIRATION_TIME);
         Print("expires: ",(datetime)expirat);
         
         if(currtime==0)
           if(expirat>TimeCurrent()) { currtime=expirat; mon++; continue; }
         if(currtime!=0) if(expirat>currtime) break;
        }
      mon++;
      long_name="";
     }
   return(long_name);
  }
//+------------------------------------------------------------------+
string LastFutures(string short_name)
  {
   StringToUpper(short_name);
   string long_name;
   MqlDateTime time;
   TimeCurrent(time);
   int year=time.year;
   int mon=time.mon;
   for(int i=0; i<12; i++)
     {
      if(mon<1) { mon=12; year--; }
      StringConcatenate(long_name,short_name,"-",mon,".",year%100);
      if(SymbolSelect(long_name,true))
        {
         if(SymbolInfoInteger(long_name,SYMBOL_EXPIRATION_TIME)<TimeCurrent()) break;
        }
      long_name="";
      mon--;
     }
   return(long_name);
  }
//+------------------------------------------------------------------+
