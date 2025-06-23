//+------------------------------------------------------------------+
//|                                               Demo_FileWrite.mq5 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//--- show the window of input parameters when launching the script
#property script_show_inputs
//--- parameters for receiving data from the terminal
input string             InpSymbolName="EURUSD";           // currency pair
input ENUM_TIMEFRAMES    InpSymbolPeriod=PERIOD_H1;        // time frame
input int                InpFastEMAPeriod=12;              // fast EMA period
input int                InpSlowEMAPeriod=26;              // slow EMA period
input int                InpSignalPeriod=9;                // difference averaging period
input ENUM_APPLIED_PRICE InpAppliedPrice=PRICE_CLOSE;      // price type
input datetime           InpDateStart=D'2012.01.01 00:00'; // data copying start date
//--- parameters for writing data to file
input string             InpFileName="MACD.csv";  // file name
input string             InpDirectoryName="Data"; // directory name
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   datetime date_finish; // data copying end date
   bool     sign_buff[]; // signal array (true - buy, false - sell)
   datetime time_buff[]; // array of signals' arrival time
   int      sign_size=0; // signal array size
   double   macd_buff[]; // array of indicator values
   datetime date_buff[]; // array of indicator dates
   int      macd_size=0; // size of indicator arrays
//--- end time is the current time
   date_finish=TimeCurrent();
//--- receive MACD indicator handle
   ResetLastError();
   int macd_handle=iMACD(InpSymbolName,InpSymbolPeriod,InpFastEMAPeriod,InpSlowEMAPeriod,InpSignalPeriod,InpAppliedPrice);
   if(macd_handle==INVALID_HANDLE)
     {
      //--- failed to receive indicator handle
      PrintFormat("Error when receiving indicator handle. Error code = %d",GetLastError());
      return;
     }
//--- being in the loop until the indicator calculates all its values
   while(BarsCalculated(macd_handle)==-1)
      Sleep(10); // pause to allow the indicator to calculate all its values
//--- copy the indicator values for a certain period of time
   ResetLastError();
   if(CopyBuffer(macd_handle,0,InpDateStart,date_finish,macd_buff)==-1)
     {
      PrintFormat("Failed to copy indicator values. Error code = %d",GetLastError());
      return;
     }
//--- copy the appropriate time for the indicator values
   ResetLastError();
   if(CopyTime(InpSymbolName,InpSymbolPeriod,InpDateStart,date_finish,date_buff)==-1)
     {
      PrintFormat("Failed to copy time values. Error code = %d",GetLastError());
      return;
     }
//--- free the memory occupied by the indicator
   IndicatorRelease(macd_handle);
//--- receive the buffer size
   macd_size=ArraySize(macd_buff);
//--- analyze the data and save the indicator signals to the arrays
   ArrayResize(sign_buff,macd_size-1);
   ArrayResize(time_buff,macd_size-1);
   for(int i=1;i<macd_size;i++)
     {
      //--- buy signal
      if(macd_buff[i-1]<0 && macd_buff[i]>=0)
        {
         sign_buff[sign_size]=true;
         time_buff[sign_size]=date_buff[i];
         sign_size++;
        }
      //--- sell signal
      if(macd_buff[i-1]>0 && macd_buff[i]<=0)
        {
         sign_buff[sign_size]=false;
         time_buff[sign_size]=date_buff[i];
         sign_size++;
        }
     }
//--- open the file for writing the indicator values (if the file is absent, it will be created automatically)
   ResetLastError();
   int file_handle=FileOpen(InpDirectoryName+"//"+InpFileName,FILE_READ|FILE_WRITE|FILE_CSV);
   if(file_handle!=INVALID_HANDLE)
     {
      PrintFormat("%s file is available for writing",InpFileName);
      PrintFormat("File path: %s\\Files\\",TerminalInfoString(TERMINAL_DATA_PATH));
      //--- first, write the number of signals
      FileWrite(file_handle,sign_size);
      //--- write the time and values of signals to the file
      for(int i=0;i<sign_size;i++)
         FileWrite(file_handle,time_buff[i],sign_buff[i]);
      //--- close the file
      FileClose(file_handle);
      PrintFormat("Data is written, %s file is closed",InpFileName);
     }
   else
      PrintFormat("Failed to open %s file, Error code = %d",InpFileName,GetLastError());
  }