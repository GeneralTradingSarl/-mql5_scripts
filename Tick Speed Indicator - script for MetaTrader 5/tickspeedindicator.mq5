#include<Trade\Trade.mqh>
CTrade trade;

int tickCont = 0;    // ticks counter
datetime tempDate = TimeCurrent();
datetime tickSpeed = "0";

void OnTick()
  {

   datetime timeCurrent = TimeCurrent();
   string strTickSpeed = StringSubstr(tickSpeed,14,5);

   if (tickCont == 100)
   {
      tickSpeed = timeCurrent - tempDate;
      tempDate = timeCurrent;
      tickCont = 0;
   }
      
   
   Comment("\nTick Counter: ", tickCont,
           "\nCurrent Time: ", timeCurrent,
           "\nTemporary Time: ", tempDate,
           "\n\nTick Speed (sec/centick):: ", strTickSpeed);
           
   tickCont++;
  }


