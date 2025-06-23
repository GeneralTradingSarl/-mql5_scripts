//+------------------------------------------------------------------+
//|                                SCT_FibonacciPotentialEntries.mq5 |
//|                                    Copyright 2020, Forex Jarvis. |
//|                                               info@fxweirdos.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Forex Jarvis. info@fxweirdos.com"
#property link      "https://fxweirdos.com"
#property version   "1.00"
#property script_show_inputs
#include <Trade\Trade.mqh>

CTrade trade;

input double dP50Level=0; // Price on 50% Level on M5 TF
input double dP61Level=0; // Price on 61% Level on M5 TF
input double dP100Level=0; // Price on 100% Level on M5 TF
input double dTarget2=0;  // Second Target on H1 TF

input double dRisk = 2; // RISK in %

double dVolTradeBL1;
double dVolTradeBL2;

double dVolTradeSL1;
double dVolTradeSL2;

// INPUT TYPE PRICE ACTION
enum boolTypeMarket{
   A1 = 1,  // Bull
   A2 = 2,  // Bear
};
input boolTypeMarket bType = A1; // Bull/Bear

double dLotSize(string sSymbol, double dPrice, double dSL, double dRiskAmount) {

   double dp=0;
   if (SymbolInfoInteger(sSymbol,SYMBOL_DIGITS)==1 || SymbolInfoInteger(sSymbol,SYMBOL_DIGITS)==3 || SymbolInfoInteger(sSymbol,SYMBOL_DIGITS)==5)
      dp=10;
   else 
      dp=1;   
   double pipPos   = SymbolInfoDouble(sSymbol,SYMBOL_POINT)*dp;
   double dNbPips  = NormalizeDouble(MathAbs((dPrice-dSL)/pipPos),1); 
   double PipValue = SymbolInfoDouble(sSymbol,SYMBOL_TRADE_TICK_VALUE)*pipPos/SymbolInfoDouble(sSymbol,SYMBOL_TRADE_TICK_SIZE);
   double dAmountRisk = AccountInfoDouble(ACCOUNT_BALANCE)*dRiskAmount/100;

   return NormalizeDouble(dAmountRisk/(dNbPips*PipValue), 2);

}

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {

   double dAsk = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double dBid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   double dSpread = dAsk-dBid;

   dVolTradeBL1 = dLotSize(_Symbol, dP50Level, dP61Level-3*dSpread, dRisk*0.33);
   dVolTradeBL2 = dLotSize(_Symbol, dP61Level, (dP61Level+dP100Level)/2-(3*dSpread), dRisk*0.67);

   dVolTradeSL1 = dLotSize(_Symbol, dP50Level, dP61Level+3*dSpread, dRisk*0.33);
   dVolTradeSL2 = dLotSize(_Symbol, dP61Level, (dP61Level+dP100Level)/2+(3*dSpread), dRisk*0.67);

   if (bType==1) {
      trade.BuyLimit(dVolTradeBL1,dP50Level, _Symbol, dP61Level-3*dSpread, dTarget2,0,0,"1st Trade");
      trade.BuyLimit(dVolTradeBL2,dP61Level, _Symbol, (dP61Level+dP100Level)/2-(3*dSpread), dTarget2,0,0,"2nd Trade");

   } else if (bType==2) {
      trade.SellLimit(dVolTradeSL1,dP50Level, _Symbol, dP61Level+3*dSpread, dTarget2,0,0,"1st Trade");
      trade.SellLimit(dVolTradeSL2,dP61Level, _Symbol, (dP61Level+dP100Level)/2+(3*dSpread), dTarget2,0,0,"2nd Trade");
   }


   
}