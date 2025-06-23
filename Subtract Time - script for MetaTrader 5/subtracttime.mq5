

int tickCont = 0;    // ticks counter
datetime tempDate = TimeCurrent();
datetime myDateTime = "1970.01.01 00:10:00";
string compareDates = "Nothing yet";


void OnTick()
  {

   datetime timeCurrent = TimeCurrent();
   string hourCurrent = StringSubstr(timeCurrent,11,2);
   datetime timeLocal = TimeLocal();
   string hourLocal = StringSubstr(timeLocal,11,2);
   
   if (tickCont == 100)
   {
      tempDate = timeCurrent;
   }
   
   if (tickCont == 200)
   {
      tempDate = timeCurrent - tempDate;
   }
   
   if (tickCont == 300)
   {
      tickCont = 0;
   }
   
   if (tempDate < myDateTime)
      compareDates = "Temp Date < 1970.01.01 00:10:00";
   else
      compareDates = "Temp Date > 1970.01.01 00:10:00";
   
   Comment("Current Time: ", timeCurrent,
           "\nCurrent Hour: ",  hourCurrent,
           "\nLocal Time: ", timeLocal,
           "\nLocal Hour: ", hourLocal,
           "\nTemporary Date: ", tempDate,
           "\nTick Counter: ", tickCont,
           "\nCompare Dates   : ", compareDates);
           
   tickCont++;
  }


