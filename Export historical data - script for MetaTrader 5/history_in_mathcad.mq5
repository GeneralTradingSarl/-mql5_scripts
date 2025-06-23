//+------------------------------------------------------------------+
//|                                           History_in_MathCAD.mq5 |
//|                                                    Privalov S.V. |
//|                           https://login.mql5.com/en/users/Prival |
//+------------------------------------------------------------------+
#property copyright "Privalov S.V."
#property link      "https://login.mql5.com/en/users/Prival"
#property version   "1.08"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---- 
   WriteFile( 1,5,2010); // day, month, year 
   WriteFile( 1,6,2010); //
   return;// script completed
  }
//+------------------------------------------------------------------+
//| WriteFile                                                        |
//+------------------------------------------------------------------+
int WriteFile(int Day,int Month,int Year)
  {
//--- if Day<1, then we get data from the beginning of month
   if(Day<1) Day=1;

   string FileName="";
   int copied=0;
   int FileHandle=0;

//--- file name formation, (Symbol+Period+Month) EURUSD_M1_09.txt
   FileName=Symbol()+"_"+fTimeFrameName(_Period)+"_"+IntegerToString(Month,2,'0')+".TXT";
   MqlRates rates[];
   MqlDateTime tm;
   ArraySetAsSeries(rates,true);

   string   start_time=IntegerToString(Year)+"."+IntegerToString(Month,2,'0')+"."+IntegerToString(Day,2,'0');  // с какой даты

   ResetLastError();

   copied=CopyRates(Symbol(),_Period,StringToTime(start_time),TimeCurrent(),rates);

   if(copied>0)
     {
      //--- open file for writing, ANSI codepage
      FileHandle=FileOpen(FileName,FILE_WRITE|FILE_ANSI);
      if(FileHandle!=INVALID_HANDLE)
        {
         for(int i=copied-1;i>=0;i--)
           {
            TimeToStruct(rates[i].time,tm);
            if(tm.day>=Day && tm.mon==Month && tm.year==Year) // check for the specified range
               FileWrite(FileHandle,// write data to file
                         DoubleToString(rates[i].time,0),    // number of seconds, passed from 1st January 1970
                         rates[i].open,                      // Open
                         rates[i].high,                      // High
                         rates[i].low,                       // Low
                         rates[i].close,                     // Close
                         rates[i].tick_volume,               // Tick Volume
                         tm.year,                            // your
                         tm.mon,                             // month
                         tm.day,                             // day
                         tm.hour,                            // hour
                         tm.min,                             // minutes
                         tm.day_of_week,                     // week day (0-sunday, 1-monday)
                         tm.day_of_year);                    // day index in the year (1st January is the 0-th day of the year)
           }
         Print("Data of the ",IntegerToString(Month,2,'0')," month ",Year," year written to file ",FileName);
        }
      else Print("Error in call of CopyRates for the Symols",Symbol()," err=",GetLastError());
     }

//--- close file (free handle), to make it available for other programs
   FileClose(FileHandle);

   return(0);
  }
//+------------------------------------------------------------------+
//| fTimeFrameName                                                   |
//+------------------------------------------------------------------+
string fTimeFrameName(int arg)
  {
   int v;
   if(arg==0)
     {
      v=_Period;
     }
   else
     {
      v=arg;
     }
   switch(v)
     {
      case PERIOD_M1:    return("M1");
      case PERIOD_M2:    return("M2");
      case PERIOD_M3:    return("M3");
      case PERIOD_M4:    return("M4");
      case PERIOD_M5:    return("M5");
      case PERIOD_M6:    return("M6");
      case PERIOD_M10:   return("M10");
      case PERIOD_M12:   return("M12");
      case PERIOD_M15:   return("M15");
      case PERIOD_M20:   return("M20");
      case PERIOD_M30:   return("M30");
      case PERIOD_H1:    return("H1");
      case PERIOD_H2:    return("H2");
      case PERIOD_H3:    return("H3");
      case PERIOD_H4:    return("H4");
      case PERIOD_H6:    return("H6");
      case PERIOD_H8:    return("H8");
      case PERIOD_H12:   return("H12");
      case PERIOD_D1:    return("D1");
      case PERIOD_W1:    return("W1");
      case PERIOD_MN1:   return("MN1");
      default:    return("?");
     }
  } // end fTimeFrameName
