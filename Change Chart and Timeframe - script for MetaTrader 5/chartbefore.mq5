//+------------------------------------------------------------------+
//|                                                  ChartBefore.mq5 |
//|                                                        J.S. 2013 |
//|                                     http://www.eselstreckdich.de |
//+------------------------------------------------------------------+
#property copyright "J.S. 2013"
#property link      "http://www.eselstreckdich.de"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   long current=ChartID();
   long before=current;

   while(true) 
     {
      long id=ChartNext(before);
      if(id==-1) id=ChartFirst();
      if(id==current) break;
      before=id;
     }

   ChartBringToTop(before);
  }
//+----------------------------------------------------------------------+
//| Send command to the terminal to display the chart above all others.  |
//+----------------------------------------------------------------------+
bool ChartBringToTop(const long chart_ID=0)
  {
//--- reset the error value
   ResetLastError();
//--- show the chart on top of all others
   if(!ChartSetInteger(chart_ID,CHART_BRING_TO_TOP,0,true))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__+", Error Code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
