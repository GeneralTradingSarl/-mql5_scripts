//+------------------------------------------------------------------+
//|                                                    buy+sl+tp.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade/Trade.mqh>
#include <Trade\SymbolInfo.mqh>
//#include <Trade\PositionInfo.mqh>
//#include <Trade\AccountInfo.mqh>

CTrade         *m_trade;
CSymbolInfo    *m_symbol;
//CPositionInfo  *m_position_info;
//CAccountInfo   *m_account;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Lots = 0.01;      // Lots (in pips)
double StopLoss = 200;   // stop loss (in pips)
double TakeProfit = 400; // take profit (in pips)

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   m_trade = new CTrade();
   m_symbol = new CSymbolInfo();
//m_position_info = new CPositionInfo();
//m_account = new CAccountInfo();

   m_symbol.Name(Symbol());
   m_symbol.RefreshRates();

   double point        = m_symbol.Point();
   double digits       = m_symbol.Digits();
   double spread       = m_symbol.Spread();

//---
//+------------------------------------------------------------------+
//| get/set global variable                                          |
//+------------------------------------------------------------------+
   if(!GlobalVariableCheck("LOT"))
      GlobalVariableSet("LOT",Lots);
   Lots = GlobalVariableGet("LOT");
   if(!GlobalVariableCheck("STOPLOSS"))
      GlobalVariableSet("STOPLOSS", StopLoss);
   StopLoss =  GlobalVariableGet("STOPLOSS");
   if(!GlobalVariableCheck("TAKEPROFIT"))
      GlobalVariableSet("TAKEPROFIT",TakeProfit);
   TakeProfit =  GlobalVariableGet("TAKEPROFIT");

   double sl = NormalizeDouble(m_symbol.Ask() - StopLoss * point, (int)digits);
   double tp = NormalizeDouble(m_symbol.Ask() + TakeProfit * point, (int)digits);
   m_trade.PositionOpen(_Symbol, ORDER_TYPE_BUY, Lots, SymbolInfoDouble(_Symbol, SYMBOL_ASK), sl, tp);
   
   delete m_trade;
   m_trade = NULL;
   delete m_symbol;
   m_symbol = NULL;

  }
//+------------------------------------------------------------------+
