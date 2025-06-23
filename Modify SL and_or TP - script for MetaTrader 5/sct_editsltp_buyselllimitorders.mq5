//+------------------------------------------------------------------+
//|                                                SCT_EDITSLTP2.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property script_show_inputs

//--- input parameters
input double   SL_BuyLimitOrder;
input double   TP_BuyLimitOrder;
input double   SL_SellLimitOrder;
input double   TP_SellLimitOrder;

#include <Trade\Trade.mqh>
CTrade c_trade;

void OnStart()
  {

   // MODIFY SL AND TP OF BUY LIMIT ORDERS :
   for (int j=OrdersTotal()-1; j>=0; --j) {
      ulong ticket=OrderGetTicket(j);
      if (OrderGetString(ORDER_SYMBOL)==Symbol() && OrderGetInteger(ORDER_TYPE)==2) {
         c_trade.OrderModify(ticket,OrderGetDouble(ORDER_PRICE_OPEN),SL_BuyLimitOrder,TP_BuyLimitOrder,ORDER_TIME_DAY,0);
      }
	}

   // MODIFY SL AND TP OF SELL LIMIT ORDERS :
   for (int j=OrdersTotal()-1; j>=0; --j) {
      ulong ticket=OrderGetTicket(j);
      if (OrderGetString(ORDER_SYMBOL)==Symbol() && OrderGetInteger(ORDER_TYPE)==3) {
         c_trade.OrderModify(ticket,OrderGetDouble(ORDER_PRICE_OPEN),SL_SellLimitOrder,TP_SellLimitOrder,ORDER_TIME_DAY,0);
      }
	}
}