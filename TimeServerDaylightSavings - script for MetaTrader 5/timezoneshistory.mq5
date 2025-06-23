//+------------------------------------------------------------------+
//|                                             TimeZonesHistory.mq5 |
//|                                    Copyright (c) 2024, marketeer |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property script_show_inputs

// optionally adjust internal logic via #defines before #include

// enable detailed output to log 
// #define PRINT_DST_DETAILS
// enable prompt detection of time-zone in exchange to possible false alerts on non-standard weeks after holidays
#define TZDST_THRESHOLD 0
#include "TimeServerDST.mqh"
#include <MQL5Book/PRTF.mqh>

input double LookupYears = 3.0;
input double LookupOffset = 0.5;
input int LookupThreshold = TZDST_THRESHOLD;

struct ServerTimeZoneExt : public ServerTimeZone
{
   datetime date;
};

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
   Print("Estimation of the server's TZ and DST offsets based on week opening hours in history");
   
   if((SymbolInfoString(_Symbol, SYMBOL_CURRENCY_BASE) != "EUR"
      || SymbolInfoString(_Symbol, SYMBOL_CURRENCY_PROFIT) != "USD")
      && StringFind(SymbolInfoString(_Symbol, SYMBOL_DESCRIPTION), "Gold") != 0)
   {
      Alert("It's recommended to apply this script to EURUSD or XAUUSD as most common instruments traded 24/5");
   }

   PrintFormat("%s ~ %s", AccountInfoString(ACCOUNT_COMPANY), AccountInfoString(ACCOUNT_SERVER));
   Print("1 ~ Built-in functions ~");
   PRTF(TimeLocal());
   PRTF(TimeCurrent());
   PRTF(TimeTradeServer());
   PRTF(TimeGMT());
   PRTF(TimeGMTOffset());
   PRTF(TimeDaylightSavings());

   Print("2 ~ Add-on over built-in functions ~");
   PRTF(TimeServerGMTOffset());

   const int year = 365 * 24 * 60 * 60;
   const int step = (int)(year * LookupOffset);
   const datetime past = TimeCurrent() - (int)step;
   PrintFormat("3' ~ Server DST offset in past at %s on %g lookup years ~", TimeToString(past, TIME_DATE), LookupYears);
   PRTF(TimeServerDaylightSavings(past, TZDST_THRESHOLD, LookupYears));
   // for demo purposes only, the following line returns error because datetime is earlier than cached LookupYears
   PRTF(TimeServerDaylightSavings(past - (int)(365 * 24 * 60 * 60 * LookupYears), TZDST_THRESHOLD, LookupYears));
   Print("3\" ~ Server current DST offset (with building timezone cache on all bars) ~");
   PRTF(TimeServerDaylightSavings());
   
   // now all history is cached
   
   // check for multiple times in past, with a fraction of year step
   Print("4 ~ Server TZ and DST offsets in past ~");
   ServerTimeZoneExt st[];
   ArrayResize(st, 6); // use dynamic allocation for "series" ordering to work
   for(int i = 5; i >= 0; i--)
   {
      st[i].date = TimeCurrent() - (year / 2 * i);
      st[i] = TimeServerZone(st[i].date, LookupThreshold, LookupYears);
   }
   ArraySetAsSeries(st, true);
   ArrayPrint(st, _Digits, "|", 0, WHOLE_ARRAY, ARRAYPRINT_DATE | ARRAYPRINT_HEADER);
}
//+------------------------------------------------------------------+
/*
   example output without PRINT_DST_DETAILS

   Estimation of the server's TZ and DST offsets based on week opening hours in history
   MetaQuotes Ltd. ~ MetaQuotes-Demo
   1 ~ Built-in functions ~
   TimeLocal()=2024.11.17 17:22:06 / ok
   TimeCurrent()=2024.11.15 23:59:59 / ok
   TimeTradeServer()=2024.11.17 16:22:06 / ok
   TimeGMT()=2024.11.17 14:22:06 / ok
   TimeGMTOffset()=-10800 / ok
   TimeDaylightSavings()=0 / ok
   2 ~ Add-on over built-in functions ~
   TimeServerGMTOffset()=-7200 / ok
   3' ~ Server DST offset in past at 2024.05.17 on 3 lookup years ~
   TimeServerDaylightSavings(past, TZDST_THRESHOLD, LookupYears)=-3600 / ok
   TimeServerDaylightSavings(past - (int)(365 * 24 * 60 * 60 * LookupYears), TZDST_THRESHOLD, LookupYears)=-2147483648 / MQL_ERROR::65538(65538)
   3" ~ Server current DST offset (with building timezone cache on all bars) ~
   TimeServerDaylightSavings()=0 / ok
   4 ~ Server TZ and DST offsets in past ~
   [offsetGMT] [offsetDST] [supportDST]     [date]
        -10800|      -3600|        true|2022.05.18
         -7200|          0|        true|2022.11.16
        -10800|      -3600|        true|2023.05.18
         -7200|          0|        true|2023.11.16
        -10800|      -3600|        true|2024.05.17
         -7200|          0|        true|2024.11.15

*/
