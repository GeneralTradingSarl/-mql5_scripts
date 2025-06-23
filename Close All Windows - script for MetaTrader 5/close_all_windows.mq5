//+------------------------------------------------------------------+
//|                                            Close_All_Windows.mq5 |
//|     Copyright 2015, Daniel Osuna de la Rosa, Alias: _de_la_Rosa. |
//|                        https://www.mql5.com/en/users/_de_la_rosa |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Daniel Osuna de la Rosa, Alias: _de_la_Rosa"
#property link      "https://www.mql5.com/en/users/_de_la_rosa"
#property version   "1.00"
#property script_show_inputs

//--- Inputs
input string NameSymbol="EURUSD";// Close Windows of this Symbol
input bool   CloseAllSymbols=false; //Close All Windows
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//--- Chart Id.
   long idchart=ChartFirst();
//--- Check Window Symbol, close and get the next Window Id
   while(idchart!=-1)
     {
      if(CloseAllSymbols==true)ChartClose(idchart);
      else if(ChartSymbol(idchart)==NameSymbol) ChartClose(idchart);
      idchart=ChartNext(idchart);
     }
  }
//+------------------------------------------------------------------+
