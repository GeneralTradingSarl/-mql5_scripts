//+------------------------------------------------------------------+
//|                                          EconomicCalendar_OP.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property service
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Service program start function                                   |
//+------------------------------------------------------------------+
void OnStart()
   {
//---
   CreateTextFile();

   }


void CreateTextFile()
   {
   if (FileIsExist("test.txt"))
      {
      FileDelete("test.txt");
      }
           
   int textFile=FileOpen("test.txt",FILE_READ|FILE_WRITE|FILE_ANSI|FILE_TXT);
   if(textFile==INVALID_HANDLE)
      {
      Alert("Error opening file");
      }
   WriteTextFile(textFile,"[");
   MqlCalendarCountry countries [];
   
   int countries_count=CalendarCountries(countries);
   //count=ArraySize(events);

      
   for (int country_idx=0;country_idx<countries_count;country_idx++)
      {
      MqlCalendarEvent events[];
      int events_count=CalendarEventByCountry(countries[country_idx].code,events);
      
      if (events_count>0)
         {
         for(int event_idx=0; event_idx<events_count;event_idx++)
            {
            datetime date_from=D'30.05.2022';
            datetime date_to=D'30.06.2022';
            
            MqlCalendarValue values [];
            int values_count = CalendarValueHistoryByEvent(events[event_idx].id,values,date_from,date_to);


            for(int value_idx=0;value_idx<values_count;value_idx++)
               {        
               WriteTextFile(textFile,"{'country_id':"+IntegerToString(countries[country_idx].id)+",");
               WriteTextFile(textFile,"'country_name':'"+countries[country_idx].name+"',");   
               WriteTextFile(textFile,"'country_code':'"+countries[country_idx].code+"',");   
               WriteTextFile(textFile,"'country_currency':'"+countries[country_idx].currency+"',");
               WriteTextFile(textFile,"'country_currency_symbol':'"+countries[country_idx].currency_symbol+"',");
               WriteTextFile(textFile,"'country_url_name':'"+countries[country_idx].url_name+"',");
               WriteTextFile(textFile,"'event_id':"+IntegerToString(events[event_idx].id)+",");
               WriteTextFile(textFile,"'event_type':"+IntegerToString(events[event_idx].type)+",");
               WriteTextFile(textFile,"'event_sector':"+IntegerToString(events[event_idx].sector)+",");
               WriteTextFile(textFile,"'event_frequency':"+IntegerToString(events[event_idx].frequency)+",");
               WriteTextFile(textFile,"'event_time_mode':"+IntegerToString(events[event_idx].time_mode)+",");
               WriteTextFile(textFile,"'event_unit':"+IntegerToString(events[event_idx].unit)+",");
               WriteTextFile(textFile,"'event_importance':"+IntegerToString(events[event_idx].importance)+",");
               WriteTextFile(textFile,"'event_multiplier':"+IntegerToString(events[event_idx].multiplier)+",");
               WriteTextFile(textFile,"'event_digits':"+IntegerToString(events[event_idx].digits)+",");
               WriteTextFile(textFile,"'event_source_url':'"+events[event_idx].source_url+"',");
               WriteTextFile(textFile,"'event_code':'"+events[event_idx].event_code+"',");
               WriteTextFile(textFile,"'event_name':'"+events[event_idx].name+"',");
               WriteTextFile(textFile,"'event_time':"+IntegerToString(values[value_idx].time)+",");
               WriteTextFile(textFile,"'event_time':"+TimeToString(values[value_idx].time)+",");
               WriteTextFile(textFile,"'event_period':"+IntegerToString(values[value_idx].period)+",");
               WriteTextFile(textFile,"'event_revision':"+IntegerToString(values[value_idx].revision)+",");
               WriteTextFile(textFile,"'actual_value':"+IntegerToString(values[value_idx].actual_value)+",");
               WriteTextFile(textFile,"'prev_value':"+IntegerToString(values[value_idx].prev_value)+",");
               WriteTextFile(textFile,"'revised_prev_value':"+IntegerToString(values[value_idx].revised_prev_value)+",");
               WriteTextFile(textFile,"'forecast_value':"+IntegerToString(values[value_idx].forecast_value)+",");
               WriteTextFile(textFile,"'impact_type':"+IntegerToString(values[value_idx].impact_type)+"},");
               
               }
               


            }
         
         }
   
         //PrintFormat("Received event events for country_code= : %s)",countries[country_idx].name);
      
         //ArrayResize(values,3);
      
         //ArrayPrint(values);
      

         //PrintFormat("Successfully wrote country events");
      //}   

      
      }
   WriteTextFile(textFile,"]");
   FileClose(textFile);
   
  }
  
  
void WriteTextFile(int textFile, string text)
   {
   FileSeek(textFile,0,SEEK_END);
   FileWrite(textFile,text);   
   }

//+------------------------------------------------------------------+
