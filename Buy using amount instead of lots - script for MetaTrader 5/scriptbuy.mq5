//+------------------------------------------------------------------+
//|                                                    ScriptBuy.mq5 |
//|                                                         B Gabela |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property strict
#property script_show_inputs

#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\AccountInfo.mqh>

#include "TradeHelper.mqh"

input double   FIXED_DEAL_AMOUNT = 10000.00; //FIXED_DEAL_AMOUNT: Fixed amount to use per trade
input bool     USE_SL_ON_BUY = true; //USE_SL_ON_BUY: Use stop loss on Long position

//--- Global Variables
/*
_Symbol+_MAX_SPREAD              //Max spread for given symbol
*/

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   init();

   int spread = SymbolInfoInteger(_Symbol,SYMBOL_SPREAD);
   printHelper(LOG_INFO, StringFormat("Script: About to execute buy on %s with spread %d ", _Symbol, spread));

//Check spread
   int maxSpread = GlobalVariableGet(_Symbol+"_MAX_SPREAD");
   if((maxSpread > 0) && (spread > maxSpread))
     {
      printHelper(LOG_INFO, StringFormat("Script: Can't execute buy on %s as spread is above %d ", _Symbol, maxSpread));
      return;
     }

   int barIndex = findLastRedBar(20);
   double sl = iLow(NULL,0,barIndex) - (getAdjustedPoint()*0.60);
   if(!USE_SL_ON_BUY)
     {
      sl = 0.00;
     }

     placeBuyOrder(m_trade, sl, 0.00, FIXED_DEAL_AMOUNT, "[M] ");
  }

//+------------------------------------------------------------------+
//| Initialisation of script                                                                 |
//+------------------------------------------------------------------+
void init()
  {
   m_trade.SetExpertMagicNumber(getMagicWithTimeframe());
   m_trade.SetMarginMode();
   m_trade.SetTypeFillingBySymbol(_Symbol);
   m_trade.SetDeviationInPoints(m_slippage);
  }

//+------------------------------------------------------------------+
