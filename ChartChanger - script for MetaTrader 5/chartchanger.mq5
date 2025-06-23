//+------------------------------------------------------------------+
//|                                                     ChartChanger |
//|                                           Copyright 2013,Karlson |
//+------------------------------------------------------------------+

void OnStart()
  { 
    long id=ChartNext(ChartID());
    if(id==-1) {id=ChartFirst();}
    
    ChartBringToTop(id);
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
