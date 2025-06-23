//properties
   #property copyright "Copyright 2016, Diogo Seca"
   #property link      "https://www.mql5.com/en/users/quebralim"
   #property version   "1.0"
   #property script_show_inputs
//includes
   #include <ChartObjects\ChartObjectsLines.mqh>
//inputs
   input string   time_string    = "00:30"; //Time of the Day
   input int      requested_days = 100;     //Number of Days
   input color    separator_clr  = clrBlue; //Color of the separators
//globals
   int time_h, time_m;
   CChartObjectVLine lines[];


//+------------------------------------------------------------------+
//|               Main Script Function                               |
//+------------------------------------------------------------------+
void OnStart()
  {
   //filter out higher timeframes - we don't want to plot timeframes higher than or equal to D1
   if(PeriodSeconds(PERIOD_CURRENT)>=PeriodSeconds(PERIOD_D1))
     {
      Print("You've chosen a timeframe which is too dense. Please change the timeframe to be less than D1");
      return;
     }
   
   //filter out invalid N of Days
   if(requested_days<1)
     {
      Print("You've inputed an invalid 'N of Days'. Please input a 'N of days higher than 0");
      return;
     }
   
   //convert the time from string into ints
   if(!ConvertTime(time_string,time_h,time_m))
     {
      Print("You've inputed a time format which is not supported. Please input the time in the following format: hh:mm");
      return;
     }
   
   //load time array
   datetime time[];
   int available_days=CopyTime(_Symbol,PERIOD_D1,0,requested_days,time);
   if(available_days<=0)
     {
      Print("Failed to load time array");
      return;
     }
   else if(available_days<requested_days)
     {
      Print("Could only load ",available_days," out of the ",requested_days," requested days");
     }
   
   //resize lines array to the available days
   ArrayResize(lines,available_days);
   
   //initialize the lines
   for(int i=available_days-1; i>=0; --i)
     {
      datetime line_time = time[i] + time_h*60*60 + time_m*60;
      lines[i].Create(0,"Line "+TimeToString(line_time),0,line_time);
      lines[i].Color(separator_clr);
     }
   
   //plot
   ChartRedraw();
   
   //close script on demand
   while(!_StopFlag)
     {
      Sleep(400);
     }

   //note:
   //  when the script dies, the lines are eficientely deleted via CChartObjectVLine's destructor.
   //  no need to call the implicit destructor / object delete
  }


//+------------------------------------------------------------------+
//|       Converts time string to hours and minutes                  |
//+------------------------------------------------------------------+
bool ConvertTime(string timeString, int &hours, int &minutes)
  {
   //string must be 5 characters long
   if(StringLen(timeString)==5)
     {
      //split the string
      string splits[];
      if(StringSplit(timeString,':',splits)==2)
        {
         hours   = (int)StringToInteger(splits[0]);
         minutes = (int)StringToInteger(splits[1]);

         //verifiy time validity
         if(hours>=0 && hours<=23 && minutes>=0 && minutes<=59)
           {
            return true;
           }
        }
     }
   
   //convertion failure
   hours   = -1;
   minutes = -1;
   return false;
  }
//+------------------------------------------------------------------+
