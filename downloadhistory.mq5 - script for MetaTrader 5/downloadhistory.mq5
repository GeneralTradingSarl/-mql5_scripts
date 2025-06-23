//+------------------------------------------------------------------+
//|                                              downloadhistory.mq5 |
//|                                                    2011, etrader |
//|                                             http://efftrading.ru |
//+------------------------------------------------------------------+
#property copyright "2011, etrader"
#property link      "http://efftrading.ru"
#property version   "1.00"
#property description "The script downloads the available historical data for the current symbol"

#include <ClassProgressBar.mqh> // http://www.mql5.com/en/articles/17
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   string sym=Symbol();
// get first date of the history on the server
   datetime begserver=(datetime)SeriesInfoInteger(sym,PERIOD_D1,SERIES_SERVER_FIRSTDATE);
   Print("first date on server for symbol ",sym," ",begserver," processing ...");
   MqlDateTime tm;
   TimeToStruct(begserver,tm);
   CProgressBar progress;
   progress.Create(0,"Loading",0,150,20);
   progress.Text("Complete ");
   progress.Value( (int)0.00001 );
   MqlDateTime fromtime;
   TimeLocal(fromtime);
//loop on years, starting from current to the year of the server's first history date
   for(int i=fromtime.year; i>=tm.year; i--,progress.Value((int)((0.+fromtime.year-i)/(-tm.year+fromtime.year)*100)))
     {
      string sd=IntegerToString(i)+".01.01";
      //check and load history for sd
      int res=CheckLoadHistory(sym,PERIOD_D1,StringToTime(sd));
      if(res<0)
        {
         Print("error of load history, result = ",res);
         break;
        }
     }

   Print("end");
  }
//+------------------------------------------------------------------+
//| Checks presence of the history starting from start_date,         |
//| if the history is not exist, it will try to download it          |
//| INPUT : symbol                                                   |
//|         period - timeframe                                       |
//|         start_date - starting date                               |
//| OUTPUT: Result code                                              |
//|         see http://www.mql5.com/en/docs/series/timeseries_access |
//| Note  : none                                                     |
//+------------------------------------------------------------------+
int CheckLoadHistory(string symbol,ENUM_TIMEFRAMES period,datetime start_date)
  {
   datetime first_date=0;
   datetime times[100];
//--- check symbol & period
   if(symbol==NULL || symbol=="") symbol=Symbol();
   if(period==PERIOD_CURRENT)     period=Period();
//--- check if symbol is selected in the MarketWatch
   if(!SymbolInfoInteger(symbol,SYMBOL_SELECT))
     {
      if(GetLastError()==ERR_MARKET_UNKNOWN_SYMBOL) return(-1);
      SymbolSelect(symbol,true);
     }
//--- check if data is present
   SeriesInfoInteger(symbol,period,SERIES_FIRSTDATE,first_date);
   if(first_date>0 && first_date<=start_date) return(1);
//--- don't ask for load of its own data if it is an indicator
   if(MQL5InfoInteger(MQL5_PROGRAM_TYPE)==PROGRAM_INDICATOR && Period()==period && Symbol()==symbol)
      return(-4);
//--- second attempt
   if(SeriesInfoInteger(symbol,PERIOD_M1,SERIES_TERMINAL_FIRSTDATE,first_date))
     {
      //--- there is loaded data to build timeseries
      if(first_date>0)
        {
         //--- force timeseries build
         CopyTime(symbol,period,first_date+PeriodSeconds(period),1,times);
         //--- check date
         if(SeriesInfoInteger(symbol,period,SERIES_FIRSTDATE,first_date))
            if(first_date>0 && first_date<=start_date) return(2);
        }
     }
//--- max bars in chart from terminal options
   int max_bars=TerminalInfoInteger(TERMINAL_MAXBARS);
//--- load symbol history info
   datetime first_server_date=0;
   while(!SeriesInfoInteger(symbol,PERIOD_M1,SERIES_SERVER_FIRSTDATE,first_server_date) && !IsStopped())
      Sleep(5);
//--- fix start date for loading
   if(first_server_date>start_date) start_date=first_server_date;
   if(first_date>0 && first_date<first_server_date)
      Print("Warning: first server date",first_server_date,"for",symbol,"does not match to first series date",first_date);
//--- load data step by step

   int fail_cnt=0;
   while(!IsStopped())
     {
      //--- wait for timeseries build
      while(!SeriesInfoInteger(symbol,period,SERIES_SYNCHRONIZED) && !IsStopped())
         Sleep(5);
      //--- ask for built bars
      int bars=Bars(symbol,period);
      if(bars>0)
        {
         if(bars>=max_bars) return(-2);
         //--- ask for first date
         if(SeriesInfoInteger(symbol,period,SERIES_FIRSTDATE,first_date))
            if(first_date>0 && first_date<=start_date) return(0);
        }
      //--- copying of next part forces data loading
      int copied=CopyTime(symbol,period,bars,100,times);
      if(copied>0)
        {
         //--- check for data
         if(times[0]<=start_date)  return(0);
         if(bars+copied>=max_bars) return(-2);
         fail_cnt=0;
        }
      else
        {
         //--- no more than 100 failed attempts
         fail_cnt++;
         if(fail_cnt>=100) return(-5);
         Sleep(10);
        }
     }
//--- stopped
   return(-3);
  }

//+------------------------------------------------------------------+
