//+------------------------------------------------------------------+
//|                                                  StopAndTake.mq5 |
//|                                           Copyright 2016, melnik |
//|                             https://www.mql5.com/ru/users/melnik |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, melnik"
#property link      "https://www.mql5.com/ru/users/melnik"
#property version   "1.00"
#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>
CPositionInfo pos;
CTrade trade;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   double price = NormalizeDouble(ChartPriceOnDropped(), _Digits);
   double bid=SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask=SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   for(int i=PositionsTotal()-1; i>=0; i--)
   {
      if(pos.SelectByIndex(i)==false)continue;
      if((pos.Type()==POSITION_TYPE_BUY) && (pos.Symbol()==_Symbol) && (price<bid))
         trade.PositionModify(pos.Ticket(), price, pos.TakeProfit());
      if((pos.Type()==POSITION_TYPE_BUY) && (pos.Symbol()==_Symbol) && (price>ask))
         trade.PositionModify(pos.Ticket(), pos.StopLoss(), price);
      
      if((pos.Type()==POSITION_TYPE_SELL) && (pos.Symbol()==_Symbol) && (price<bid))
         trade.PositionModify(pos.Ticket(), pos.StopLoss(), price);
      if((pos.Type()==POSITION_TYPE_SELL) && (pos.Symbol()==_Symbol) && (price>ask))
         trade.PositionModify(pos.Ticket(), price, pos.TakeProfit());
   }
  }
//+------------------------------------------------------------------+
