//+------------------------------------------------------------------+
//|                                             NewYearCountdown.mq5 |
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
   MqlDateTime date_current;
   ObjectCreate(0, "new_year_text", OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, "new_year_text", OBJPROP_XDISTANCE, 30);
   ObjectSetInteger(0, "new_year_text", OBJPROP_YDISTANCE, 30);
   ObjectSetString(0, "new_year_text", OBJPROP_TEXT, "New Year will start in");
   ObjectCreate(0, "new_year_counter", OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, "new_year_counter", OBJPROP_XDISTANCE, 30);
   ObjectSetInteger(0, "new_year_counter", OBJPROP_YDISTANCE, 50);
   while(!IsStopped())
     {
      TimeLocal(date_current);
      datetime seconds_new_year = StringToTime((string)(date_current.year + 1) + ".01.01 [00:00:00]");
      ObjectSetString(0, "new_year_counter", OBJPROP_TEXT, GetTimeSpan(seconds_new_year - TimeLocal()));
      ChartRedraw();
      Sleep(1000);
     }
   ObjectDelete(0, "new_year_text");
   ObjectDelete(0, "new_year_counter");
  }
//+------------------------------------------------------------------+
string GetTimeSpan(datetime time_sec)
  {
   if(time_sec <= 0)
      return "0 seconds";
   string time_text = {};
   datetime remaining_sec = time_sec;
   int years = (int)remaining_sec / 31536000;
   remaining_sec %= 31536000;
   int months = (int)remaining_sec / 2592000;
   remaining_sec %= 2592000;
   int days = (int)remaining_sec / 86400;
   remaining_sec %= 86400;
   int hours = (int)remaining_sec / 3600;
   remaining_sec %= 3600;
   int minutes = (int)remaining_sec / 60;
   remaining_sec %= 60;
   int seconds = (int)remaining_sec;
   if(years > 0)
      time_text += (string)years + " years ";
   if(months > 0)
      time_text += (string)months + " months ";
   if(days > 0)
      time_text += (string)days + " days ";
   if(hours > 0)
      time_text += (string)hours + " hours ";
   if(minutes > 0)
      time_text += (string)minutes + " minutes ";
   if(seconds > 0)
      time_text += (string)seconds + " seconds ";
   return time_text;
  }
//+------------------------------------------------------------------+
