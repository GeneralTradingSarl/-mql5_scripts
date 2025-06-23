//+------------------------------------------------------------------+
//|                                                        PnLAt.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//|                                          Author: Yashar Seyyedin |
//|       Web Address: https://www.mql5.com/en/users/yashar.seyyedin |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property script_show_inputs

//input parameters
input datetime time=NULL;

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   double TotalUnrealizedProfit=0;
   Print("Your chosen time stamp= " , (time));
   Print("Total Unrealized Profit: " ,(PrintOpenPositionsPnLAt(TotalUnrealizedProfit))?(string)TotalUnrealizedProfit:"NaN");  
  }
//+------------------------------------------------------------------+

bool PrintOpenPositionsPnLAt(double &TotalUnrealizedProfit)
{
   if(HistorySelect(0, TimeCurrent())==false)
   {
      Print("Error History Select...");
      return false;
   }

   int total = HistoryDealsTotal();
   TotalUnrealizedProfit=0;
   for(int i = 0; i < total; i++) //iterate to find the out deals
   {
      ulong out_dealTicket = HistoryDealGetTicket(i);
      if(HistoryDealGetInteger(out_dealTicket, DEAL_ENTRY) != DEAL_ENTRY_OUT) continue;
      if(HistoryDealGetInteger(out_dealTicket, DEAL_TIME) < time) continue;
      ulong positionTicket=HistoryDealGetInteger(out_dealTicket, DEAL_POSITION_ID);
      if(HistorySelectByPosition(positionTicket)==true)
      {
         int _total = HistoryDealsTotal();
         for(int j = 0; j < _total; j++) //iterate to find the coressponding in deal
         {
            ulong in_dealTicket = HistoryDealGetTicket(j);
            if(HistoryDealGetInteger(in_dealTicket, DEAL_ENTRY) != DEAL_ENTRY_IN) continue;
            if(HistoryDealGetInteger(in_dealTicket, DEAL_TIME) > time) continue;
            double pnl = 0;
            PrintInfo(in_dealTicket);
            if(PnL(in_dealTicket, pnl)==false) return false;
            TotalUnrealizedProfit+=pnl;
            break;
         }
      }
      HistorySelect(0, TimeCurrent());
   }
   
   for(int i=0;i<PositionsTotal();i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket<=0) continue;
      if(PositionGetInteger(POSITION_TIME)>time) continue;
      if(HistorySelectByPosition(ticket)==true)
      {
         int _total = HistoryDealsTotal();
         for(int j = 0; j < _total; j++) //iterate to find the coressponding in deal
         {
            ulong in_dealTicket = HistoryDealGetTicket(j);
            if(HistoryDealGetInteger(in_dealTicket, DEAL_ENTRY) != DEAL_ENTRY_IN) continue;
            double pnl = 0;
            PrintInfo(in_dealTicket);
            if(PnL(in_dealTicket, pnl)==false) return false;
            TotalUnrealizedProfit+=pnl;
            break;
         }
      }
   }
   
   return true;
}



bool PnL(ulong in_dealTicket, double &profit)
{
   string symbol=HistoryDealGetString(in_dealTicket, DEAL_SYMBOL);

   //copy one tick from the input time stamp
   MqlTick tick_array[1];
   if(CopyTicks(symbol,tick_array,COPY_TICKS_ALL,time*1000,1)!=1)
   {
      Print("Error Copying Ticks for: " , symbol);
      return false;
   }
  
   //retrieve deal info
   ENUM_ORDER_TYPE order_type = HistoryDealGetInteger(in_dealTicket, DEAL_TYPE)==DEAL_TYPE_BUY?ORDER_TYPE_BUY:ORDER_TYPE_SELL;
   double volume = HistoryDealGetDouble(in_dealTicket, DEAL_VOLUME);
   double open_price = HistoryDealGetDouble(in_dealTicket, DEAL_PRICE);
   double close_price = order_type==ORDER_TYPE_BUY?tick_array[0].bid:tick_array[0].ask;

   //calculate profit from the very specific tick at timestamp  
   profit=0;
   if(OrderCalcProfit(order_type, symbol, volume, open_price, close_price, profit)== false)
   {
      Print("Error OrderCalcProfit for deal ticket: ", in_dealTicket);
      return false;
   }
  
   // Add swap and comission
   profit = profit+HistoryDealGetDouble(in_dealTicket, DEAL_SWAP)  +
                  HistoryDealGetDouble(in_dealTicket, DEAL_COMMISSION);
  
   //round two digits double format
   profit=MathFloor(profit*100)/100;
   return true;
}

void PrintInfo(ulong ticket)
{
   double PNL=0;
   Print("Ticket= " , ticket,
   ", Symbol= " , HistoryDealGetString(ticket,DEAL_SYMBOL),
   ", Type= " , EnumToString((ENUM_DEAL_TYPE) HistoryDealGetInteger(ticket,DEAL_TYPE)),
   ", Time= " , TimeToString(HistoryDealGetInteger(ticket,DEAL_TIME)),
   ", Unrealized Profit= ", PnL(ticket, PNL)?(string)PNL:"NaN"
   );
}