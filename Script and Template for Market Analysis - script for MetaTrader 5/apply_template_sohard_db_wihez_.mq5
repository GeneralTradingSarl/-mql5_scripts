//+------------------------------------------------------------------+
//|                              apply_template_SoHarD_dB_w@®Ez_.mq5 |
//|                             Copyright 2014, by _SoHarD_dB_w@®Ez_ |
//|                https://www.google.com/+RicardoPenders_SoHarD_dB_ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, by _SoHarD_dB_w@®Ez_"
#property link      "https://www.google.com/+RicardoPenders_SoHarD_dB_"
#property version   "1.00"
#property script_show_inputs
#property description "Script to apply my template and current timeframe in all charts opened"
#include  <Charts\Chart.mqh>;

input ENUM_TIMEFRAMES TimeFrame; // Change TimeFrame - Current = dont changed
input string Template="_SoHarD_dB_wyuEz_"; // Name of Template (without '.tpl')
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   long currChart,prevChart=ChartFirst();
   int i=0,limit=100;
   bool errTemplate;
   while(i<limit)
     {
      currChart=ChartNext(prevChart);
      if(TimeFrame!=PERIOD_CURRENT)
        {
         ChartSetSymbolPeriod(prevChart,ChartSymbol(prevChart),TimeFrame);
        }
      errTemplate=ChartApplyTemplate(prevChart,Template+".tpl");
      if(!errTemplate)
        {
         Print("Error ",ChartSymbol(prevChart),"-> ",GetLastError());
        }
      if(currChart<0) break;
      Print(i,ChartSymbol(currChart)," ID =",currChart);
      prevChart=currChart;
      i++;

     }

  }
//+------------------------------------------------------------------+
