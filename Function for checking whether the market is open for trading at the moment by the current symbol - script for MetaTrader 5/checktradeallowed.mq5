//+------------------------------------------------------------------+
//|                                            CheckTradeAllowed.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   if(CheckTradeAllowed())
      Print("Market for trading on symbol ", Symbol(), " is now opened");
   else
      Print("Market for trading on symbol ", Symbol(), " is now closed");
  }
//+------------------------------------------------------------------+
bool CheckTradeAllowed()
  {
   MqlDateTime date_cur;
   TimeTradeServer(date_cur);
   datetime seconds_cur = date_cur.hour * 3600 + date_cur.min * 60 + date_cur.sec;
   int i = 0;
   while(true)
     {
      datetime seconds_from = {}, seconds_to = {};
      if(!SymbolInfoSessionTrade(Symbol(), (ENUM_DAY_OF_WEEK)date_cur.day_of_week, i, seconds_from, seconds_to))
         break;
      if(seconds_cur > seconds_from && seconds_cur < seconds_to)
         return true;
      ++i;
     }
   return false;
  }

//+------------------------------------------------------------------+
