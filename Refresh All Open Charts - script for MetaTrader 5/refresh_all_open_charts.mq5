//+------------------------------------------------------------------+
//|                                      Refresh All Open Charts.mq5 |
//|                               Copyright 2023, Muhammad Ali Akbar |
//|                                     https://t.me/maakbarofficial |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Muhammad Ali Akbar"
#property link      "https://t.me/maakbarofficial"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
      long FirstChart = ChartFirst();
      while(FirstChart>0)
      {            
         ChartSetSymbolPeriod(FirstChart, ChartSymbol(FirstChart), PERIOD_CURRENT);
         ChartRedraw();
         
         FirstChart = ChartNext(FirstChart);      
      }
}
//+------------------------------------------------------------------+