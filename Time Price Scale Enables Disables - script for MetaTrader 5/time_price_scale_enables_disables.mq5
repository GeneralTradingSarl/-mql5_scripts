//+------------------------------------------------------------------+
//|                            Time_Price_Scale_Enables_disables.mq5 |
//|                              Copyright © 2015, Vladimir Karputov |
//|                                           http://wmua.ru/slesar/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2015, Vladimir Karputov"
#property link      "http://wmua.ru/slesar/"
#property version   "1.00"
#property description "Enables/disables displaying of the time scale on chart"
#property description "Enables/disables displaying of the price scale on chart"
#property description "Apply for all/single charts"
#property script_show_inputs
//--- input parameters
input bool     DATE_SCALE     =false;  // Showing the time scale on a chart
input bool     PRICE_SCALE    =false;  // Showing the price scale on a chart
input bool     APPLY_TO_ALL   =true;   // Apply for all/single charts
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   if(APPLY_TO_ALL)
     {
      //--- Apply for all charts
      //--- variables for chart ID
      long currChart,prevChart=ChartFirst();
      int i=0,limit=100;
      ChartShowDateScaleSet(DATE_SCALE,prevChart);
      ChartShowPriceScaleSet(PRICE_SCALE,prevChart);
      while(i<limit)// We have certainly not more than 100 open charts
        {
         currChart=ChartNext(prevChart); // Get the new chart ID by using the previous chart ID
         if(currChart<0) break;          // Have reached the end of the chart list
                                         //Print(i,ChartSymbol(currChart)," ID =",currChart);
         ChartShowDateScaleSet(DATE_SCALE,currChart);
         ChartShowPriceScaleSet(PRICE_SCALE,currChart);
         prevChart=currChart;// let's save the current chart ID for the ChartNext()
         i++;// Do not forget to increase the counter
        }
     }
   else
     {
      //--- Apply for single chart
      ChartShowDateScaleSet(DATE_SCALE,0);
      ChartShowPriceScaleSet(PRICE_SCALE,0);
     }
  }
//+------------------------------------------------------------------+
//| Checks if the time scale is displayed on chart                   |
//+------------------------------------------------------------------+
bool ChartShowDateScaleGet(bool &result,const long chart_ID=0)
  {
//--- prepare the variable to get the property value
   long value;
//--- reset the error value
   ResetLastError();
//--- receive the property value
   if(!ChartGetInteger(chart_ID,CHART_SHOW_DATE_SCALE,0,value))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__+", Error Code = ",GetLastError());
      return(false);
     }
//--- store the value of the chart property in memory
   result=value;
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Enables/disables displaying of the time scale on chart           |
//+------------------------------------------------------------------+
bool ChartShowDateScaleSet(const bool value,const long chart_ID=0)
  {
//--- reset the error value
   ResetLastError();
//--- set property value
   if(!ChartSetInteger(chart_ID,CHART_SHOW_DATE_SCALE,0,value))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__+", Error Code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Checks if the price scale is displayed on chart                  |
//+------------------------------------------------------------------+
bool ChartShowPriceScaleGet(bool &result,const long chart_ID=0)
  {
//--- prepare the variable to get the property value
   long value;
//--- reset the error value
   ResetLastError();
//--- receive the property value
   if(!ChartGetInteger(chart_ID,CHART_SHOW_PRICE_SCALE,0,value))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__+", Error Code = ",GetLastError());
      return(false);
     }
//--- store the value of the chart property in memory
   result=value;
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Enables/disables displaying of the price scale on chart          |
//+------------------------------------------------------------------+
bool ChartShowPriceScaleSet(const bool value,const long chart_ID=0)
  {
//--- reset the error value
   ResetLastError();
//--- set property value
   if(!ChartSetInteger(chart_ID,CHART_SHOW_PRICE_SCALE,0,value))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__+", Error Code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
