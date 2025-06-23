#property copyright "Your Name"
#property link      "Your Contact"
#property version   "1.00"
#property description "Script to set Stop Loss and Take Profit based on Risk:Reward ratio"

// Include the Trade.mqh file to use CTrade class
#include <Trade\Trade.mqh>

// Input parameters
input double RiskRewardRatio = 2.0; // Risk:Reward Ratio (e.g., 2.0 for 1:2)
input double StopLossPips = 20;     // Stop Loss in pips

void OnStart()
{
   // Get current symbol
   string symbol = Symbol();
   double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
   double pip_value = point * 10; // Adjust for 5-digit brokers

   // Calculate Stop Loss and Take Profit in price units
   double sl = StopLossPips * pip_value;
   double tp = sl * RiskRewardRatio;

   // Get current market price
   double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
   double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);

   // Create a CTrade object
   CTrade trade;

   // Example: Modify an open position (assumes one open position for simplicity)
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(PositionSelectByTicket(ticket))
      {
         if(PositionGetString(POSITION_SYMBOL) == symbol)
         {
            double current_sl = PositionGetDouble(POSITION_SL);
            double current_tp = PositionGetDouble(POSITION_TP);
            double open_price = PositionGetDouble(POSITION_PRICE_OPEN);

            // Set SL and TP based on position type (Buy or Sell)
            if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
            {
               current_sl = open_price - sl;
               current_tp = open_price + tp;
            }
            else if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
            {
               current_sl = open_price + sl;
               current_tp = open_price - tp;
            }

            // Modify position
            trade.PositionModify(ticket, current_sl, current_tp);
            Print("SL and TP set for ticket #", ticket, ": SL=", current_sl, ", TP=", current_tp);
         }
      }
   }
}