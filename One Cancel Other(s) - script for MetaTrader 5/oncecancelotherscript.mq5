//+------------------------------------------------------------------+
//|                                        OnceCancelOtherScript.mq5 |
//|                                            Copyright 2012, Rone. |
//|                                            rone.sergey@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, Rone."
#property link      "rone.sergey@gmail.com"
#property version   "1.00"
#property description "One Cancel Other(s) Script"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool     end = false;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int symbolOrders() {
   int total = OrdersTotal();
   
   if ( total == 0 ) {
      return(0);
   }
//---
   int symTotal = 0;
   for ( int i = 0; i < total; i++ ) {
      ulong ticket;
      
      if ( (ticket = OrderGetTicket(i)) > 0 ) {
         if ( OrderGetString(ORDER_SYMBOL) == _Symbol ) {
            symTotal += 1;
         }
      }
   }
//---
   return(symTotal);
}
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart() {
//---
   for ( ; !IsStopped() && !end; ) {
      if ( PositionSelect(_Symbol) ) {
         int total = OrdersTotal();
         
         for ( int i = 0; i < total; i++ ) {
            ulong ticket;
            
            if ( (ticket = OrderGetTicket(i)) > 0 ) {
               if ( OrderGetString(ORDER_SYMBOL) == _Symbol ) {
                  CTrade trade;
                  
                  ResetLastError();
                  if ( !trade.OrderDelete(ticket) ) {
                     Print("OrderDelete of ", ticket, " is failed. Error #", GetLastError());
                  }
               }
            }
         }
      }
      if ( symbolOrders() == 0 ) {
         end = true;
      }
   }
//---   
}
//+------------------------------------------------------------------+
