//+------------------------------------------------------------------+
//|                                                Move StopLoss.mq5 |
//|                                  Copyright 2023,Obunadike Chioma |
//|                                           https://t.me/devbidden |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023,Obunadike Chioma"
#property link      "https://t.me/devbidden"
#property version   "1.00"
#include  <Trade/Trade.mqh>
CTrade trade;
CPositionInfo  m_position;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   double Price = ChartPriceOnDropped();
   if(Price > 0)
      for(int i = PositionsTotal() - 1; i >= 0; i--) // loop all Open Positions
         if(m_position.SelectByIndex(i))  // select a position
           {
              trade.PositionModify(m_position.Ticket(),Price,m_position.TakeProfit());
           }
}
//+------------------------------------------------------------------+
   
