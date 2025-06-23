//+------------------------------------------------------------------+
//|                                Objects Description Activator.mq5 |
//+------------------------------------------------------------------+

#property copyright "tom-next.com community - Blog MetaTraders"
#property link  "http://www.tom-next.com/community/blog/34-metatraders/"

#property script_show_inputs
#property version   "1.00"
#property description "Enables the 'Chart Objects Description' for non-programmers."
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   long currChart=ChartFirst();
   int i=0;
   while(i<CHARTS_MAX)
     {
      ChartSetInteger(currChart,CHART_SHOW_OBJECT_DESCR,true);
      ChartRedraw(currChart);
      currChart=ChartNext(currChart);
      if(currChart==-1) break;
      i++;
     }

  }
//+------------------------------------------------------------------+
