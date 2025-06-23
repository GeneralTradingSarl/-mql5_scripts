//+------------------------------------------------------------------+
//| Simple News Filter for XAUUSD Trading                            |
//+------------------------------------------------------------------+
#property copyright "Duy Van NGUY"
#property link      "https://www.mql5.com/en/market/product/your_product_id"
#property version   "1.00"

input int MinutesBeforeNews = 15; // Minutes before news to pause trading
input int MinutesAfterNews  = 15; // Minutes after news to resume trading

// Simulated news times (for demo purposes, replace with real news data source)
datetime newsTimes[] = {D'2025.05.07 14:30:00'}; // Example: News at 14:30 on May 7, 2025

//+------------------------------------------------------------------+
//| Check if trading should be paused due to news                    |
//+------------------------------------------------------------------+
bool IsNewsTime()
{
   datetime currentTime = TimeCurrent();
   
   for(int i = 0; i < ArraySize(newsTimes); i++)
   {
      datetime newsTime = newsTimes[i];
      datetime startPause = newsTime - MinutesBeforeNews * 60; // Pause X minutes before news
      datetime endPause = newsTime + MinutesAfterNews * 60;   // Resume X minutes after news
      
      if(currentTime >= startPause && currentTime <= endPause)
      {
         Print("News Filter: Trading paused due to upcoming news at ", newsTime);
         return true; // Pause trading
      }
   }
   
   return false; // Safe to trade
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   if(IsNewsTime())
   {
      return; // Skip trading during news time
   }
   
   // Add your XAUUSD trading logic here
   Print("Safe to trade XAUUSD");
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Clean-up code if needed
}
//+------------------------------------------------------------------+