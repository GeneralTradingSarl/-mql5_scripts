//+------------------------------------------------------------------+
//|                                                  rates_total.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Sam Beatson, PhD."
#property link      "https://www.sambeatson.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   long bars_total = iBars(_Symbol, _Period);  //Get the total bars on the chart
   
   Print("Number of bars on the current chart: ", bars_total);
   Comment("No. bars: ", bars_total);
  }
//+------------------------------------------------------------------+
