//+------------------------------------------------------------------+
//|                                         LimitStopOrderScript.mq5 |
//|                                            Copyright 2013, Rone. |
//|                                            rone.sergey@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, Rone."
#property link      "rone.sergey@gmail.com"
#property version   "1.00"
#property description "Limit Stop Order Script"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#property script_show_inputs
//--- input parameters
input double   InpLot = 0.1;              // Lot
input double   InpLimitPrice = 1.33000;   // Limit Price
input double   InpStopPrice = 1.33750;    // Stop Order Price
input int      InpStopLoss = 300;         // Stop Loss (pips)
input int      InpTakeProfit = 500;       // Take Profit (pips)
input int      InpSleep = 3;              // Sleep
//--- global variables
double         lot;
double         limitPrice;
double         stopPrice;
int            stopLoss;
int            takeProfit;
int            sleep;
bool           init = false;
bool           end = false;
//---
ENUM_ORDER_TYPE   orderType = WRONG_VALUE;
int               stopLevel;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
void checkParameter(T inp, T &param, T compValue, string name) {
   if ( inp <= compValue ) {
      Print("Incorrected input parameter ", name, " = ", inp, ". Correct parameter and try one more time.");
      end = true;
   } else {
      param = inp;
   }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double checkVolume(double volume) {
//---
   double minVolume = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxVolume = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double volumeStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
//---
   if ( volume < minVolume ) {
      volume = minVolume;
   } else if ( volume > maxVolume ) {
      volume = maxVolume;
   }
//---
   int digits = (int)MathCeil(MathLog10(1/volumeStep));
//---
   return(NormalizeDouble(volume, digits));
//---
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool initialize() {
//--- check input parameters
   stopLevel = (int)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
   
   checkParameter(InpLot, lot, 0.0, "Lot");
   checkParameter(InpLimitPrice, limitPrice, 0.0, "Limit Price");
   checkParameter(InpStopPrice, stopPrice, 0.0, "Stop Price");
   checkParameter(InpStopLoss, stopLoss, stopLevel, "Stop Loss");
   checkParameter(InpTakeProfit, takeProfit, stopLevel, "Take Profit");
   checkParameter(InpSleep, sleep, 0, "Sleep");
//---
   if ( MathAbs(stopPrice-limitPrice) < stopLevel * _Point ) {
      Print("Incorrected input prices parameter");
      end = true;
   }
   
   if ( stopPrice > limitPrice ) {
      orderType = ORDER_TYPE_BUY_STOP;
   } else {
      orderType = ORDER_TYPE_SELL_STOP;
   }
   if ( !end ) {
      Print("Order Type: ", EnumToString(orderType), "; Lot: ", lot, "; Limit Price: ", DoubleToString(limitPrice, _Digits), 
         "; Stop Price: ", DoubleToString(stopPrice, _Digits));
   }
//---
   return(true);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool sendOrder(ENUM_ORDER_TYPE type, MqlTick &lastTick) {
//---
   double sl, tp;
   double spread = SymbolInfoInteger(_Symbol, SYMBOL_SPREAD) * _Point;
//---
   if ( type == ORDER_TYPE_BUY_STOP ) {
      sl = NormalizeDouble(MathMin(stopPrice-stopLoss*_Point, stopPrice-spread-stopLevel*_Point), _Digits);
      tp = NormalizeDouble(stopPrice+takeProfit*_Point, _Digits);
   } else {
      sl = NormalizeDouble(MathMax(stopPrice+stopLoss*_Point, stopPrice+spread+stopLevel*_Point), _Digits);
      tp = NormalizeDouble(stopPrice-takeProfit*_Point, _Digits);
   }
//---
   double margin;
   
   if ( !OrderCalcMargin(type, _Symbol, lot, stopPrice, margin) ) {
      Print("Not enough margin to open order.");
      return(false);
   }  
//---
   CTrade trade;
   
   return(trade.OrderOpen(_Symbol, type, lot, stopPrice, stopPrice, sl, tp));
}
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart() {
//---
   if ( !init ) {
      if ( initialize() ) {
         init = true;
      }
   }
//---
   for ( ; !IsStopped() && !end; ) {
      //---
      MqlTick lastTick;
      
      ResetLastError();
      if ( !SymbolInfoTick(_Symbol, lastTick) ) {
         Print("SymbolInfoTick is failed. Error #", GetLastError());
         return;
      }
      if ( (orderType == ORDER_TYPE_BUY_STOP && lastTick.ask <= limitPrice) ||
         (orderType == ORDER_TYPE_SELL_STOP && lastTick.bid >= limitPrice) ) 
      {
         if ( sendOrder(orderType, lastTick) ) {
            end = true;
         }
      }
      Sleep(sleep);
   }
//---   
}
//+------------------------------------------------------------------+
