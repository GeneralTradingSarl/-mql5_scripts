//+------------------------------------------------------------------+
//|                                        Demo_FileWriteInteger.mq5 |
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
input ENUM_TIMEFRAMES    InpSymbolPeriod=PERIOD_H1;        // timeframe
input datetime           InpDateStart=D'2013.01.01 00:00'; // data copying start date
//--- parameters for writing data to the file
input string             InpFileName="Trend.bin"; // file name
input string             InpDirectoryName="Data"; // directory name
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   datetime date_finish=TimeCurrent();
   double   close_buff[];
   datetime time_buff[];
   int      size;
//--- reset the error value
   ResetLastError();
//--- copy the close price for each bar
   if(CopyClose(InpSymbolName,InpSymbolPeriod,InpDateStart,date_finish,close_buff)==-1)
     {
      PrintFormat("Failed to copy the values of close prices. Error code = %d",GetLastError());
      return;
     }
//--- copy the time for each bar
   if(CopyTime(InpSymbolName,InpSymbolPeriod,InpDateStart,date_finish,time_buff)==-1)
     {
      PrintFormat("Failed to copy time values. Error code = %d",GetLastError());
      return;
     }
//--- receive the buffer size
   size=ArraySize(close_buff);
//--- open the file for writing the values (if the file is absent, it will be created automatically)
   ResetLastError();
   int file_handle=FileOpen(InpDirectoryName+"//"+InpFileName,FILE_READ|FILE_WRITE|FILE_BIN);
   if(file_handle!=INVALID_HANDLE)
     {
      PrintFormat("%s file is available for writing",InpFileName);
      PrintFormat("File path: %s\\Files\\",TerminalInfoString(TERMINAL_DATA_PATH));
      //--- 
      int   up_down=0; // trend flag
      int   arr_size;  // arr array size
      uchar arr[];     // uchar type array
      //--- write time values to the file
      for(int i=0;i<size-1;i++)
        {
         //--- compare close prices of the current and next bars
         if(close_buff[i]<=close_buff[i+1])
           {
            if(up_down!=1)
              {
               //--- write date value to the file using FileWriteInteger
               StringToCharArray(TimeToString(time_buff[i]),arr);
               arr_size=ArraySize(arr);
               //--- first, write the number of symbols in the array
               FileWriteInteger(file_handle,arr_size,INT_VALUE);
               //--- write the symbols
               for(int j=0;j<arr_size;j++)
                  FileWriteInteger(file_handle,arr[j],CHAR_VALUE);
               //--- change the trend flag
               up_down=1;
              }
           }
         else
           {
            if(up_down!=-1)
              {
               //--- write the date value to the file using FileWriteInteger
               StringToCharArray(TimeToString(time_buff[i]),arr);
               arr_size=ArraySize(arr);
               //--- first, write the number of symbols in the array
               FileWriteInteger(file_handle,arr_size,INT_VALUE);
               //--- write the symbols
               for(int j=0;j<arr_size;j++)
                  FileWriteInteger(file_handle,arr[j],CHAR_VALUE);
               //--- change the trend flag
               up_down=-1;
              }
           }
        }
      //--- close the file
      FileClose(file_handle);
      PrintFormat("Data is written, %s file is closed",InpFileName);
     }
   else
      PrintFormat("Failed to open %s file, Error code = %d",InpFileName,GetLastError());
  }
//+------------------------------------------------------------------+
