//+------------------------------------------------------------------+
//|                                       ReadPositionCommission.mq5 |
//|                               Copyright 2023, Mian Farrukh Aleem |
//|                            https://www.mql5.com/en/users/farrukh |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Mian Farrukh Aleem"
#property link      "https://www.mql5.com/en/users/farrukh"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   for(int i=0;i<PositionsTotal();i++){
      ulong tmpticket =  PositionGetTicket(i);
      Print((string)tmpticket + " Commission = " + (string)PositionCommission(tmpticket) );
   }
  }
//+------------------------------------------------------------------+

double PositionCommission(ulong pTicket){
   //Mql5 dont provide a way to look for position related commissions easliy 
   //Purpose of this function is to access commission of the position easily
   //we need to select history and find the commission for it

   double RetVal = 0;
   
   PositionSelectByTicket(pTicket);   
   HistorySelectByPosition(PositionGetInteger(POSITION_IDENTIFIER));
   
   for (int i = HistoryDealsTotal()-1; i >= 0; i--)
   {
      ulong ticket = HistoryDealGetTicket(i);
      if (ticket > 0 && HistoryDealGetInteger(ticket, DEAL_POSITION_ID) == PositionGetInteger(POSITION_IDENTIFIER)
          && (ENUM_DEAL_ENTRY)HistoryDealGetInteger(ticket, DEAL_ENTRY) == DEAL_ENTRY_IN
         )
      {
         RetVal += HistoryDealGetDouble(ticket,DEAL_COMMISSION);
         break;
      }
   }
   return(RetVal);
}