//+------------------------------------------------------------------+
//|                                                KobRequisites.mq5 |
//|                                     Copyright 2020, Jordi Llonch |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Jordi Llonch"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property description   "This script automates EURUSD bars and ticks download for the correct execution of Kiss on Billions on EURUSD."
#property description   "It is required to run in a EURUSD chart"
#property script_show_inputs

/*

This script downloads bars and ticks required for the correct
execution of "Kiss on Billions on EURUSD" EA from Saeid Irani.


*/

//--- input parameters
input datetime StartDate = D'2018.01.01 00:00:00'; //Retrieve data since
input int getticks = 100000000; // The number of required ticks

input group "In case of error..."
input int retries = 3;     //Retry attempts
input int retrypause = 1000; //Delay between retries in Milliseconds


ENUM_TIMEFRAMES timeframes[] = {
   PERIOD_M1,
   PERIOD_M5,
   PERIOD_M15,
   PERIOD_M30,
   PERIOD_H1,
   PERIOD_H4,
   PERIOD_D1,
   PERIOD_MN1
};

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart() {
//---
   int     attempt = 0;   // Count of attempts
   bool    success = false; // The flag of a successful copying of ticks
   MqlTick ticks[];   // Tick receiving array
   MqlTick lasttick;       // To receive last tick data

//--- Receive bars with retry
   for (int i = 0; i < ArraySize(timeframes); i++) {
      attempt = 0;
      while(attempt < retries) {
         ResetLastError();
         Bars(Symbol(), timeframes[i], StartDate, TimeCurrent());
         if(GetLastError() == 0) {
            success = true;
            break;
         }
         PrintFormat("%s: downloading bars:attempt %d/%d:error code:%d",
                     Symbol(), attempt, retries, _LastError);

         attempt++;
         Sleep(retrypause);
      }
   }
   if(!success) {
      PrintFormat("Error! Failed to receive bars of %s", Symbol());
      Alert("Error! " + (string)_LastError + " retrieving bars for " + Symbol());
      return;
   }

   attempt = 0;
//--- Make 3 attempts to receive ticks
   while(attempt < retries) {

      SymbolInfoTick(Symbol(), lasttick);
      //--- Measuring start time before receiving the ticks
      uint start = GetTickCount();

      //--- Requesting the tick history since StartDate (parameter from=1 ms)
      ResetLastError();
      int received = CopyTicks(Symbol(), ticks, COPY_TICKS_ALL, 1, getticks);
      if(received != -1) {
         //--- Showing information about the number of ticks and spent time
         PrintFormat("%s: received %d ticks in %d ms", Symbol(), received, GetTickCount() - start);
         //--- If the tick history is synchronized, the error code is equal to zero
         if(GetLastError() == 0) {
            success = true;
            break;
         }
         PrintFormat("%s: ticks are not synchronized yet, %d ticks received for %d ms. Error=%d",
                     Symbol(), received, GetTickCount() - start, _LastError);
      }
      //--- Counting attempts
      attempt++;
      //--- A retrypause pause to wait for the end of synchronization of the tick database
      Sleep(retrypause);
   }
//--- Receiving the requested ticks from the beginning of the tick history failed after attempts
   if(!success) {
      PrintFormat("Error! Failed to receive %d ticks of %s",
                  getticks, Symbol());
      Alert("Error! " + (string)_LastError + " retrieving ticks for " + Symbol());
      return;
   }
   Alert("Bars and Ticks succesfully downloaded.");
}
//+------------------------------------------------------------------+
