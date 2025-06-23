//+------------------------------------------------------------------+
//|                                                  bulls_bears.mq5 |
//|                                       Copyright 2015,Viktor Moss |
//|                           https://login.mql5.com/ru/users/vicmos |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015,Viktor Moss"
#property link      "https://login.mql5.com/ru/users/vicmos"
#property version   "1.00"
#property script_show_inputs

input int NumCandles=1000;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   int bulls=0,bears=0;
   double op[],cl[];
   int sp[];
   if(CopyOpen(_Symbol,PERIOD_CURRENT,0,NumCandles,op)<0) return;
   if(CopyClose(_Symbol,PERIOD_CURRENT,0,NumCandles,cl)<0) return;
   if(CopySpread(_Symbol,PERIOD_CURRENT,0,NumCandles,sp)<0) return;
   for(int i=0; i<NumCandles; i++)
     {
      if(cl[i]-op[i]>sp[i]*_Point) bulls++; 
      if(op[i]-cl[i]>sp[i]*_Point) bears++; 
     }
   MessageBox(_Symbol+"   "+StringSubstr(EnumToString(_Period),7)+"\n"+
              "Candles "+IntegerToString(NumCandles)+"\n"+
              "Bulls "+IntegerToString(bulls)+"\n"+
              "Bears "+IntegerToString(bears));
  }
//+------------------------------------------------------------------+
