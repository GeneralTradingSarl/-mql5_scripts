//+------------------------------------------------------------------+
//|                                                 CandlesticksData |
//|                                Copyright 2024, Alpha Phoenix ICT |
//|                                             http://www.APICT.net |
//+------------------------------------------------------------------+

#property copyright "2024 @Alpha Phoenix Intelligent Computer Technology"
#property script_show_inputs

string timeframe;
ENUM_TIMEFRAMES H_timeframes;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
for(int i=0;i<21;i++)
  {
   
   CandlesticksData(H_timeframes,i);
  }

}
//+------------------------------------------------------------------+
void CandlesticksData(ENUM_TIMEFRAMES timeframes, int i)
{
TimeFrameHandle(i);
//--- Identify Timeframe
   if(H_timeframes == PERIOD_D1) {
      timeframe = "Daily";
   } else if(H_timeframes == PERIOD_W1) {
      timeframe = "Weekly";
   } else if(H_timeframes == PERIOD_MN1) {
      timeframe = "Monthly";
   } else if(H_timeframes == PERIOD_H12) {
      timeframe = "H12";
   } else if(H_timeframes == PERIOD_H8) {
      timeframe = "H8";
   } else if(H_timeframes == PERIOD_H6) {
      timeframe = "H6";
   } else if(H_timeframes == PERIOD_H4) {
      timeframe = "H4";
   } else if(H_timeframes == PERIOD_H3) {
      timeframe = "H3";
   } else if(H_timeframes == PERIOD_H2) {
      timeframe = "H2";
   } else if(H_timeframes == PERIOD_H1) {
      timeframe = "H1";
   } else {
      timeframe = (string)H_timeframes + " Minutes";
   }

   int digits = (int) SymbolInfoInteger(Symbol(), SYMBOL_DIGITS);
   int bars = iBars(Symbol(), timeframes);
   string output_file_name =(string) Symbol() + "_" + timeframe + ".csv";
   
   ResetLastError();
   int handle_write = FileOpen(output_file_name, FILE_WRITE | FILE_BIN | FILE_COMMON);
   
   if(handle_write == INVALID_HANDLE) {
      int error = GetLastError();
      Print("Error " + (string) error + ", Failed to write the results to CSV.");
      return;
   }

//--- Write the header row to CSV
   FileWriteString(handle_write, "INDEX,DATE,TIME,OPEN,HIGH,LOW,CLOSE,TICKVOLUME,VOLUME,SPREAD,Full_Size,Body_Size,Wick_Size,Nose_Size,Candle_Type,Candle_Gap,Candle_Range_Diff,Previous_Close\r");

   for(int i = 0; i <= bars - 1; i++) {
      //--- Get the data for the current bar
      datetime _time = iTime(Symbol(), timeframes, i);
      string date = TimeToString(_time, TIME_DATE);
      string time = TimeToString(_time, TIME_MINUTES);
      double open = NormalizeDouble(iOpen(Symbol(), timeframes, i), digits);
      double high = NormalizeDouble(iHigh(Symbol(), timeframes, i), digits);
      double low = NormalizeDouble(iLow(Symbol(), timeframes, i), digits);
      double close = NormalizeDouble(iClose(Symbol(), timeframes, i), digits);
      long tick_volume = iTickVolume(Symbol(), timeframes, i);
      long volume = iVolume(Symbol(), timeframes, i);
      double spread = iSpread(Symbol(), timeframes, i);
      int index = i;
      double candlestick_full_size = NormalizeDouble(((iHigh(_Symbol, timeframes, i)) - (iLow(_Symbol, timeframes, i))), digits);
      double body_size, wick_size, nose_size;
      int candlestick_type;

      // Define candle body sizes and types
      if((open - close) < 0) {
         candlestick_type = 1; // Bullish candle
         body_size = NormalizeDouble((close - open), digits);
         wick_size = NormalizeDouble((high - close), digits);
         nose_size = NormalizeDouble((open - low), digits);
      } else {
         candlestick_type = 0; // Bearish candle
         body_size = NormalizeDouble((open - close), digits);
         wick_size = NormalizeDouble((close - low), digits);
         nose_size = NormalizeDouble((high - open), digits);
      }

      //--- Additional Data
      double previous_close = (i > 0) ? NormalizeDouble(iClose(Symbol(), timeframes, i-1), digits) : 0.0;
      double candle_gap = (i > 0) ? NormalizeDouble((open - previous_close), digits) : 0.0;
      double candle_range_diff = (i > 0) ? NormalizeDouble((candlestick_full_size - NormalizeDouble(iHigh(Symbol(), timeframes, i-1) - iLow(Symbol(), timeframes, i-1), digits)), digits) : 0.0;

      //--- Write the data to CSV
      FileWriteString(handle_write, IntegerToString(index) + ",");
      FileWriteString(handle_write, date + ",");
      FileWriteString(handle_write, time + ",");
      FileWriteString(handle_write, DoubleToString(open, digits) + ",");
      FileWriteString(handle_write, DoubleToString(high, digits) + ",");
      FileWriteString(handle_write, DoubleToString(low, digits) + ",");
      FileWriteString(handle_write, DoubleToString(close, digits) + ",");
      FileWriteString(handle_write, (string)(tick_volume) + ",");
      FileWriteString(handle_write, (string)(volume) + ",");
      FileWriteString(handle_write, DoubleToString(spread, digits) + ",");
      FileWriteString(handle_write, DoubleToString(candlestick_full_size, digits) + ",");
      FileWriteString(handle_write, DoubleToString(body_size, digits) + ",");
      FileWriteString(handle_write, DoubleToString(wick_size, digits) + ",");
      FileWriteString(handle_write, DoubleToString(nose_size, digits) + ",");
      FileWriteString(handle_write, IntegerToString(candlestick_type) + ",");
      FileWriteString(handle_write, DoubleToString(candle_gap, digits) + ",");
      FileWriteString(handle_write, DoubleToString(candle_range_diff, digits) + ",");
      FileWriteString(handle_write, DoubleToString(previous_close, digits));
      FileWriteString(handle_write, "\r");
   }

   FileClose(handle_write);
   Alert("Saved the price data successfully. Find the file in '<User>\\AppData\\Roaming\\MetaQuotes\\Terminal\\Common\\Files\\" + output_file_name + "'");


}
void TimeFrameHandle(int i)
{

   if(i==0)
     {
      H_timeframes=PERIOD_M1;
     }
     if(i==1)
     {
      H_timeframes=PERIOD_W1;
     }if(i==2)
     {
      H_timeframes=PERIOD_D1;
     }if(i==3)
     {
      H_timeframes=PERIOD_H12;
     }if(i==4)
     {
      H_timeframes=PERIOD_H8;
     }if(i==5)
     {
      H_timeframes=PERIOD_H6;
     }if(i==6)
     {
      H_timeframes=PERIOD_H4;
     }if(i==7)
     {
      H_timeframes=PERIOD_H3;
     }if(i==8)
     {
      H_timeframes=PERIOD_H2;
     }if(i==9)
     {
      H_timeframes=PERIOD_H1;
     }if(i==10)
     {
      H_timeframes=PERIOD_M30;
     }if(i==11)
     {
      H_timeframes=PERIOD_M20;
     }if(i==12)
     {
      H_timeframes=PERIOD_M15;
     }if(i==13)
     {
      H_timeframes=PERIOD_M12;
     }if(i==14)
     {
      H_timeframes=PERIOD_M10;
     }if(i==15)
     {
      H_timeframes=PERIOD_M6;
     }if(i==16)
     {
      H_timeframes=PERIOD_M5;
     }if(i==17)
     {
      H_timeframes=PERIOD_M4;
     }if(i==18)
     {
      H_timeframes=PERIOD_M3;
     }if(i==19)
     {
      H_timeframes=PERIOD_M2;
     }if(i==20)
     {
      H_timeframes=PERIOD_M1;
     }
    
  

}