//+------------------------------------------------------------------+
//|                                         Demo_FileWriteDouble.mq5 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//--- show the window of input parameters when launching the script
#property script_show_inputs
//--- parameters for receiving data from the terminal
input string             InpSymbolName="EURJPY";           // currency pair
input ENUM_TIMEFRAMES    InpSymbolPeriod=PERIOD_M15;       // time frame
input int                InpMAPeriod=10;                   // smoothing period
input int                InpMAShift=0;                     // indicator shift
input ENUM_MA_METHOD     InpMAMethod=MODE_SMA;             // smoothing type
input ENUM_APPLIED_PRICE InpAppliedPrice=PRICE_CLOSE;      // price type
input datetime           InpDateStart=D'2013.01.01 00:00'; // data copying start date
//--- parameters for writing data to the file
input string             InpFileName="MA.csv";    // file name
input string             InpDirectoryName="Data"; // directory name
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   datetime date_finish=TimeCurrent();
   double   ma_buff[];
   datetime time_buff[];
   int      size;
//--- receive MA indicator handle
   ResetLastError();
   int ma_handle=iMA(InpSymbolName,InpSymbolPeriod,InpMAPeriod,InpMAShift,InpMAMethod,InpAppliedPrice);
   if(ma_handle==INVALID_HANDLE)
     {
      //--- failed to receive the indicator handle
      PrintFormat("Error when receiving indicator handle. Error code = %d",GetLastError());
      return;
     }
//--- being in the loop until the indicator calculates all its values
   while(BarsCalculated(ma_handle)==-1)
      Sleep(20); // a pause to allow the indicator to calculate all its values
   PrintFormat("Indicator values starting from %s will be written to the file",TimeToString(InpDateStart));
//--- copy the indicator values
   ResetLastError();
   if(CopyBuffer(ma_handle,0,InpDateStart,date_finish,ma_buff)==-1)
     {
      PrintFormat("Failed to copy the indicator values. Error code = %d",GetLastError());
      return;
     }
//--- copy the time of the appropriate bars' arrival
   ResetLastError();
   if(CopyTime(InpSymbolName,InpSymbolPeriod,InpDateStart,date_finish,time_buff)==-1)
     {
      PrintFormat("Failed to copy time values. Error code = %d",GetLastError());
      return;
     }
//--- receive the buffer size
   size=ArraySize(ma_buff);
//--- free the memory occupied by the indicator
   IndicatorRelease(ma_handle);
//--- open the file for writing the indicator values (if the file is absent, it will be created automatically)
   ResetLastError();
   int file_handle=FileOpen(InpDirectoryName+"//"+InpFileName,FILE_READ|FILE_WRITE|FILE_BIN);
   if(file_handle!=INVALID_HANDLE)
     {
      PrintFormat("%s file is available for writing",InpFileName);
      PrintFormat("File path: %s\\Files\\",TerminalInfoString(TERMINAL_DATA_PATH));
      //--- first, write the size of data sample
      FileWriteDouble(file_handle,(double)size);
      //--- write the indicator time and value to the file
      for(int i=0;i<size;i++)
        {
         FileWriteDouble(file_handle,(double)time_buff[i]);
         FileWriteDouble(file_handle,ma_buff[i]);
        }
      //--- close the file
      FileClose(file_handle);
      PrintFormat("Data is written, %s file is closed",InpFileName);
     }
   else
      PrintFormat("Failed to open %s file, Error code = %d",InpFileName,GetLastError());
  }
//+------------------------------------------------------------------+
