//+------------------------------------------------------------------+
//|                                              ytg_Percent_Lot.mq5 |
//|                                                     Yuriy Tokman |
//|                                         http://www.mql-design.ru |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman"
#property link      "http://www.mql-design.ru"
#property version   "1.00"

#property description "www.mql-design.ru"
#property description ""
#property description "yuriytokman@gmail.com "
#property description ""
#property description "Skype - yuriy.g.t"

#property script_show_inputs

input double Risk=33.3;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   Alert("Free margin=",AccountInfoDouble(ACCOUNT_FREEMARGIN)," ",AccountInfoString(ACCOUNT_CURRENCY),
         "   Risk percent=",Risk,
         "%  Lots=",GetLot());
//---   
  }
//+------------------------------------------------------------------+
//| GetLot                                                           |
//+------------------------------------------------------------------+
double GetLot()
  {
   double price=0.0;
   double margin=0.0;
   double MaximumRisk=Risk/100;

   if(!SymbolInfoDouble(_Symbol,SYMBOL_ASK,price))               return(0.0);
   if(!OrderCalcMargin(ORDER_TYPE_BUY,_Symbol,1.0,price,margin)) return(0.0);
   if(margin<=0.0)                                               return(0.0);

   double min_volume=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
   double max_volume=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MAX);

   double lot=NormalizeDouble(AccountInfoDouble(ACCOUNT_FREEMARGIN)*MaximumRisk/margin,2);

//if(Volume>0)lot=Volume;   
   if(lot<min_volume)lot=min_volume;
   if(lot>max_volume)lot=max_volume;
   return(lot);
  }
//+------------------------------------------------------------------+
