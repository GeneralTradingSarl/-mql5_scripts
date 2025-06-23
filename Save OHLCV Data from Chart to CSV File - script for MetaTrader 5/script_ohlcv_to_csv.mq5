//+------------------------------------------------------------------+
//|                                             Script_OHLCV_CSV.mq5 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      "shmtrading3000@gmail.com"
#property version   "1.01"
#property description "This script saves the available OHLCV data from the chart to a CSV file inside '<User>\\AppData\\Roaming\\MetaQuotes\\Terminal\\Common\\Files'.\nMake sure 'Max bars in chart' is set to unlimited in 'Tools>Options>Chart'."

#property script_show_inputs

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   int digits = Digits();
   double tick_size = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE);
   int bars = iBars(Symbol(), PERIOD_CURRENT);
   string output_file_name = (string) Symbol() +
                             "-" +
                             (string) Period() +
                             "-" +
                             TimeToString(iTime(Symbol(), PERIOD_CURRENT, bars - 1), TIME_DATE) +
                             "-" +
                             TimeToString(iTime(Symbol(), PERIOD_CURRENT, 0), TIME_DATE) +
                             ".csv";

   ResetLastError();
   int handle_write = FileOpen(output_file_name, FILE_WRITE | FILE_BIN | FILE_COMMON);
   if(handle_write == INVALID_HANDLE)
     {
      int error = GetLastError();
      Print("Error " + (string) error + ", Failed to write the results to csv.");
      return;
     }

//--- Write the header row to csv
   FileWriteString(handle_write, "<DATE>" + ",");
   FileWriteString(handle_write, "<TIME>" + ",");
   FileWriteString(handle_write, "<OPEN>" + ",");
   FileWriteString(handle_write, "<High>" + ",");
   FileWriteString(handle_write, "<LOW>" + ",");
   FileWriteString(handle_write, "<CLOSE>" + ",");
   FileWriteString(handle_write, "<TICKVOLUME>" + ",");
   FileWriteString(handle_write, "<VOL>" + ",");
   FileWriteString(handle_write, "<SPREAD>");
   FileWriteString(handle_write, "\r\n");

   for(int i = bars - 1; i >= 0; i--)
     {
      //--- Get the data for the current bar
      datetime _time = iTime(Symbol(), PERIOD_CURRENT, i);
      string date = TimeToString(_time, TIME_DATE);
      string time = TimeToString(_time, TIME_MINUTES);
      string open = PriceToString(iOpen(Symbol(), PERIOD_CURRENT, i), tick_size, digits);
      string high = PriceToString(iHigh(Symbol(), PERIOD_CURRENT, i), tick_size, digits);
      string low = PriceToString(iLow(Symbol(), PERIOD_CURRENT, i), tick_size, digits);
      string close = PriceToString(iClose(Symbol(), PERIOD_CURRENT, i), tick_size, digits);
      string tick_volume = (string) iTickVolume(Symbol(), PERIOD_CURRENT, i);
      string volume = (string) iVolume(Symbol(), PERIOD_CURRENT, i);
      string spread = (string) iSpread(Symbol(), PERIOD_CURRENT, i);

      //--- Write the data to csv
      FileWriteString(handle_write, date + ",");
      FileWriteString(handle_write, time + ",");
      FileWriteString(handle_write, open + ",");
      FileWriteString(handle_write, high + ",");
      FileWriteString(handle_write, low + ",");
      FileWriteString(handle_write, close + ",");
      FileWriteString(handle_write, tick_volume + ",");
      FileWriteString(handle_write, volume + ",");
      FileWriteString(handle_write, spread);
      FileWriteString(handle_write, "\r\n");
     }

   FileClose(handle_write);
   Alert("Saved the price data successfully. Find the file in '<User>\\AppData\\Roaming\\MetaQuotes\\Terminal\\Common\\Files\\" + output_file_name + "'");
  }
//+------------------------------------------------------------------+
string PriceToString(double price, double tick_size, int digits)
  {

   double price_norm = NormalizeDouble((price / tick_size) * tick_size, digits);
   return DoubleToString(price_norm, digits);

  }
//+------------------------------------------------------------------+
