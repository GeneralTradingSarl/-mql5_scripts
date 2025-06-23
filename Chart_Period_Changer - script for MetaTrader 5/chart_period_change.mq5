//+------------------------------------------------------------------+
//|                                             Chart_Period_Changer |
//|                                           Copyright 2012,Karlson |
//+------------------------------------------------------------------+
#property copyright   "2012, Karlson."
#property link        "https://login.mql5.com/ru/users/Karlson"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   if(ChartPeriod(0)==PERIOD_M1)  {ChartSetSymbolPeriod(0,_Symbol,PERIOD_M5);return;}
   if(ChartPeriod(0)==PERIOD_M5)  {ChartSetSymbolPeriod(0,_Symbol,PERIOD_M15);return;}
   if(ChartPeriod(0)==PERIOD_M15) {ChartSetSymbolPeriod(0,_Symbol,PERIOD_M30);return;}
   if(ChartPeriod(0)==PERIOD_M30) {ChartSetSymbolPeriod(0,_Symbol,PERIOD_H1);return;}
   if(ChartPeriod(0)==PERIOD_H1)  {ChartSetSymbolPeriod(0,_Symbol,PERIOD_H4);return;}
   if(ChartPeriod(0)==PERIOD_H4)  {ChartSetSymbolPeriod(0,_Symbol,PERIOD_D1);return;}
   if(ChartPeriod(0)==PERIOD_D1)  {ChartSetSymbolPeriod(0,_Symbol,PERIOD_W1);return;}
   if(ChartPeriod(0)==PERIOD_W1)  {ChartSetSymbolPeriod(0,_Symbol,PERIOD_MN1);return;}
   if(ChartPeriod(0)>=PERIOD_MN1) {ChartSetSymbolPeriod(0,_Symbol,PERIOD_M1);return;}
   if(GetLastError()>0) {Print("Error  (",GetLastError(),") ");} ResetLastError();
  }
//+------------------------------------------------------------------+
