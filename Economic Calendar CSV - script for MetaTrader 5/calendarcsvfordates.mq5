//+------------------------------------------------------------------+
//|                                          CalendarCSVForDates.mq5 |
//|                             Copyright 2022-2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2022-2024, MetaQuotes Ltd."
#property link        "https://www.mql5.com"
#property description "Saves a table of calendar records, with a filter for country and/or currency and for specific range of days, into a CSV-file.\n"
#property description "Can read data directly from the built-in calendar or from an archived cal-file saved by CalendarMonitorCached[TZ].mq5 indicator."
#property script_show_inputs

#include <MQL5Book/Defines.mqh>
#include <MQL5Book/StringUtils.mqh>
#include <MQL5Book/TimeServerDST.mqh> // including before Calendar cache enables timezone fix-up support
#include <MQL5Book/CalendarFilterCached.mqh>
#include <MQL5Book/PRTF.mqh>

input group "General"
input string CountryCode = "EU"; // CountryCode (2-chars code)
input string Currency = ""; // Currency (3-chars code)
input ENUM_CALENDAR_SCOPE Scope = SCOPE_DAY; // Scope (timespan into the past and future)
input string CSVname = ""; // CSVname ('*' to generate filename automatically)
input string CalendarCacheFile = ""; // CalendarCacheFile (optional, *.cal-file from CalendarMonitorCached.mq5)

input group "Advanced"
input bool FixCachedTimesBySymbolHistory = false;
input int UpgradeCacheVersion = 0;
input int ForceCachedServerTimeOffset = INT_MIN;

AutoPtr<CalendarCache> cache;

//+------------------------------------------------------------------+
//| Extended struct with user-friendly data from MqlCalendarValue    |
//+------------------------------------------------------------------+
struct MqlCalendarRecord: public MqlCalendarValue
{
   string importance;
   string name;
   string currency;
   string code;
   string mode;
   double actual, previous, revised, forecast;
   
   MqlCalendarRecord() { ZeroMemory(this); }
   
   MqlCalendarRecord(const MqlCalendarValue &value, CalendarCache *c = NULL)
   {
      this = value;
      extend(c);
   }
   
   void extend(CalendarCache *c)
   {
      static const string importances[] = {"N"/* None */, "L"/* Low */, "M"/* Medium */, "H"/* High */};
      static const string modes[] = {"T"/* exact Time */, "A"/* All day */, "N"/* No time */, "E"/* Estimate */};

      MqlCalendarEvent event;
      if(!(!c ? CalendarEventById(event_id, event) : c.calendarEventById(event_id, event)))
      {
         SetUserError(1);
         return;
      }
      
      name = event.name;
      importance = importances[event.importance];
      mode = modes[event.time_mode];
      
      MqlCalendarCountry country;
      if(!(!c ? CalendarCountryById(event.country_id, country) : c.calendarCountryById(event.country_id, country)))
      {
         SetUserError(2);
         return;
      }
      
      currency = country.currency;
      code = country.code;
      
      MqlCalendarValue value = this;
      
      // Neither one of the following works:
      //   GetActualValue();
      //   this.GetActualValue();
      //   MqlCalendarValue::GetActualValue();
      
      actual = value.GetActualValue();
      previous = value.GetPreviousValue();
      revised = value.GetRevisedValue();
      forecast = value.GetForecastValue();
   }
   
   void asStringArray(string &data[], const bool header = false)
   {
      if(header)
      {
         const static string caption[] =
         {
           "id", "event", "time", "mode", "period", "revision",
           "impact", "importance", "name", "currency", "code", "actual", "previous", "revised", "forecast"
         };
         ArrayCopy(data, caption);
         return;
      }
      
      PUSH(data, (string)id);
      PUSH(data, (string)event_id);
      PUSH(data, (string)time);
      PUSH(data, mode);
      PUSH(data, TimeToString(period, TIME_DATE));
      PUSH(data, (string)revision);
      const string impacts[] = {"", "+", "-"};
      PUSH(data, impacts[impact_type]);
      PUSH(data, (string)importance);
      if(StringFind(name, ",") > -1)
      {
         StringReplace(name, "\"", "\"\"");
         name = "\"" + name + "\"";
      }
      PUSH(data, name);
      PUSH(data, currency);
      PUSH(data, code);
      PUSH(data, (string)actual);
      PUSH(data, (string)previous);
      PUSH(data, (string)revised);
      PUSH(data, (string)forecast);
   }
};

// will be in MQL5 soon
bool StringEndsWith(const string text, const string suffix)
{
  return StringLen(text) >= StringLen(suffix) && StringFind(text, suffix) == StringLen(text) - StringLen(suffix);
}

string DateTimeToTimestamp(const datetime dt)
{
   MqlDateTime mdt;
   TimeToStruct(dt, mdt);
   return StringFormat("%04d%02d%02d%02d%02d%02d", mdt.year, mdt.mon, mdt.day, mdt.hour, mdt.min, mdt.sec);
}

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
   MqlCalendarValue values[];
   MqlCalendarRecord records[];
   CalendarCache *extender = NULL;
   datetime from = fmax(TimeCurrent() - Scope, 0);
   datetime to = Scope == SCOPE_ALL ? D'3000.12.31' : TimeCurrent() + Scope;
   // NB: first call to the calendar history with complete scope may take a while or even time out
   
   int tzoffset = 0;
   int count = 0;
   cache = new CalendarCache(CalendarCacheFile, true, 0, false/* we don't ask for sorting by default (by time), cause will sort below by 2 columns */);
   if(cache[].isLoaded())
   {
      if(cache[].getVersion() == 0)
      {
         Print("Version 1.0 of cal-file has no time-zone info!");
         tzoffset = -1;
         if(UpgradeCacheVersion > 0)
         {
            cache[].save(CalendarCacheFile + "-upgrade" + (string)UpgradeCacheVersion + ".cal", 0, ForceCachedServerTimeOffset);
         }
      }
      else
      {
         tzoffset = cache[].getTZOffset();
         PrintFormat("Current server TZ offset: %+d; calendar cached TZ offset: %+d",
            TimeServerGMTOffset(), tzoffset);
            
         if(FixCachedTimesBySymbolHistory)
         {
            PrintFormat("Calendar records adjusted by time: %d", cache[].adjustTZonHistory(_Symbol, true));
         }
      }
      extender = cache[];
      count = PRTF(cache[].calendarValueHistory(values, from, to, CountryCode, Currency));
      PrintFormat("Relevant records retrieved from cache: %d", count);
   }
   else
   {
      Print("Loading built-in calendar (via caching)");
      cache = new CalendarCache(NULL, from, to, false);
      if(cache[].isLoaded())
      {
         tzoffset = TimeServerGMTOffset();
         if(FixCachedTimesBySymbolHistory)
         {
            PrintFormat("Calendar records adjusted by time: %d", cache[].adjustTZonHistory(_Symbol, true));
         }
         count = PRTF(cache[].calendarValueHistory(values, from, to, CountryCode, Currency));
      }
   }
   
   if(count > 0)
   {
      PrintFormat("Found %d calendar records in scope, sorting...", ArraySize(values));
      SORT_STRUCT_REF_2(MqlCalendarValue, values, time, id);

      for(int i = 0; i < ArraySize(values); ++i)
      {
         PUSH(records, MqlCalendarRecord(values[i], extender));
      }
      
      if(StringLen(CSVname) || StringLen(CalendarCacheFile))
      {
         string fname = "";

         if(StringLen(CalendarCacheFile) && !StringLen(CSVname))
         {
            fname = CalendarCacheFile;
            if(StringEndsWith(fname, ".cal"))
            {
               StringReplace(fname, ".cal", ".csv");
            }
         }
         else if(StringLen(CSVname) && CSVname != "*")
         {
            fname = CSVname;
         }
         else
         {
            fname = StringFormat("%s-%s-%s-%s-%s-%s", DateTimeToTimestamp(TimeCurrent()),
               CountryCode, Currency,
               from ? DateTimeToTimestamp(from) : "",
               to == D'3000.12.31' ? "" : DateTimeToTimestamp(to),
               EnumToString(Scope));
         }
         string data[];
         const string f = StringEndsWith(fname, ".csv") ? fname : fname + ".csv";
         PrintFormat("Saving file '%s'", f);
         int h = PRTF(FileOpen(f, FILE_WRITE | FILE_CSV | FILE_ANSI, ",", CP_UTF8));
         for(int i = 0; i < ArraySize(records); ++i)
         {
            if(!i)
            {
               records[i].asStringArray(data, true);
               FileWriteString(h, StringCombine(data, ',') + "\n");
               ArrayFree(data);
            }
            records[i].asStringArray(data);
            FileWriteString(h, StringCombine(data, ',') + "\n");
            ArrayFree(data);
         }
         
         if(tzoffset != -1)
         {
            MqlCalendarRecord tz;
            tz.revision = tzoffset;
            tz.name = "(Server Time-Zone Offset)";
            tz.asStringArray(data);
            FileWriteString(h, StringCombine(data, ',') + "\n");
         }
         
         FileClose(h);
      }
      else
      {
         ArrayPrint(records);
      }
      Print("Done");
   }
   else
   {
      PrintFormat("Calendar history is not accessible (yet?) or there are no records in the given context. Error: %s (%d)", E2S(_LastError), _LastError);
   }
}
//+------------------------------------------------------------------+
/*

CalendarValueHistory(values,from,to,CountryCode,Currency)=6 / ok
Near past and future calendar records (extended): 
      [id] [event_id]              [time]            [period] [revision]       [actual_value]         [prev_value] [revised_prev_value]     [forecast_value] [impact_type] [reserved] [importance]                                                [name] [currency] [code] [actual] [previous] [revised] [forecast]
[0] 162723  999020003 2022.06.23 03:00:00 1970.01.01 00:00:00          0 -9223372036854775808 -9223372036854775808 -9223372036854775808 -9223372036854775808             0        ... "High"       "EU Leaders Summit"                                   "EUR"      "EU"        nan        nan       nan        nan
[1] 162724  999020003 2022.06.24 03:00:00 1970.01.01 00:00:00          0 -9223372036854775808 -9223372036854775808 -9223372036854775808 -9223372036854775808             0        ... "High"       "EU Leaders Summit"                                   "EUR"      "EU"        nan        nan       nan        nan
[2] 168518  999010034 2022.06.24 11:00:00 1970.01.01 00:00:00          0 -9223372036854775808 -9223372036854775808 -9223372036854775808 -9223372036854775808             0        ... "Medium"     "ECB Supervisory Board Member McCaul Speech"          "EUR"      "EU"        nan        nan       nan        nan
[3] 168515  999010031 2022.06.24 13:10:00 1970.01.01 00:00:00          0 -9223372036854775808 -9223372036854775808 -9223372036854775808 -9223372036854775808             0        ... "Medium"     "ECB Supervisory Board Member Fernandez-Bollo Speech" "EUR"      "EU"        nan        nan       nan        nan
[4] 168509  999010014 2022.06.24 14:30:00 1970.01.01 00:00:00          0 -9223372036854775808 -9223372036854775808 -9223372036854775808 -9223372036854775808             0        ... "Medium"     "ECB Vice President de Guindos Speech"                "EUR"      "EU"        nan        nan       nan        nan
[5] 161014  999520001 2022.06.24 22:30:00 2022.06.21 00:00:00          0 -9223372036854775808             -6000000 -9223372036854775808 -9223372036854775808             0        ... "Low"        "CFTC EUR Non-Commercial Net Positions"               "EUR"      "EU"        nan   -6.00000       nan        nan

*/
//+------------------------------------------------------------------+
