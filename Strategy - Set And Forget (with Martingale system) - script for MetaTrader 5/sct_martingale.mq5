//+------------------------------------------------------------------+
//|                                                   Martingale.mq5 |
//|                                    Copyright 2020, Mario Gharib. |
//|                                         mario.gharib@hotmail.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2020, Mario Gharib. mario.gharib@hotmail.com"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property script_show_inputs

#include <Trade/Trade.mqh>
CTrade trade;

input int iNbStopOrders=5; // Number of limit orders (Buy limit Or Sell limit)
input double dEntryPrice;  // The initial entry price
input double dStopLoss;   // The initial stop loss
input double dTakeProfit;   // The initial Take profit
input double dLotSize=0.01;   // The position size of each trade.

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
   string sSymbol = Symbol();
   
   if (dEntryPrice>SymbolInfoDouble(sSymbol,SYMBOL_ASK)) {
      double dGrid=dStopLoss-dEntryPrice;
      for (int i=1 ; i<=iNbStopOrders ; i++)
         trade.SellLimit(dLotSize,dEntryPrice-(i-1)*dGrid,sSymbol,dStopLoss,dTakeProfit);
   }
   else {
      double dGrid=dEntryPrice-dStopLoss;
      for (int i=1 ; i<=iNbStopOrders ; i++)
         trade.BuyLimit(dLotSize,dEntryPrice+(i-1)*dGrid,sSymbol,dStopLoss,dTakeProfit);
   }
}