//+------------------------------------------------------------------+
//|                                             Get Last History.mq5 |
//|                             Developed by Donald Reeves Sihombing |
//|                              https://www.mql5.com/en/users/dspro |
//|                                                         20200925 |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.00"

input ulong    m_magic = 0; // Magic Number
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   long dtype;
   double dprofit;
   GetLastHistory(dtype,dprofit);

  }
//+------------------------------------------------------------------+
void GetLastHistory(long& dtype, double& dprofit)
  {
//get the history data
   if(!HistorySelect(0,TimeCurrent()))
     {
      Print("__FUNCTION__ "+__FUNCTION__+", Failed to select History");
      return;
     }

   uint total = HistoryDealsTotal();
   ulong dticket = 0;
   datetime dtime = 0;
   string dsymbol;
   double dprice = 0;
   double dfee=0, dswap=0, dcommission=0;
   long dealentry;
   ulong dmagic = 0;
   string dealtype = "";

   for(uint i=total-1; i>=0; i--) //start from the last history
     {
      dticket = HistoryDealGetTicket(i);
      if(dticket<=0)
         continue;
      //check the symbol
      dsymbol = HistoryDealGetString(dticket,DEAL_SYMBOL);
      if(dsymbol!=Symbol())
         continue;
      //check deal entry
      dealentry = HistoryDealGetInteger(dticket,DEAL_ENTRY);
      if(dealentry!=DEAL_ENTRY_OUT) //position closed
         continue;
      //check magic number
      dmagic = HistoryDealGetInteger(dticket,DEAL_MAGIC);
      if(dmagic!=m_magic)
         continue;
      //deal type must be buy or sell
      dtype = HistoryDealGetInteger(dticket,DEAL_TYPE);
      if(dtype!=DEAL_TYPE_BUY && dtype!=DEAL_TYPE_SELL)
         continue;

      dealtype = "Buy";
      if(dtype==DEAL_TYPE_BUY) //if a position closed by Buy, then the original is Sell
         dealtype = "Sell";

      dprice = HistoryDealGetDouble(dticket,DEAL_PRICE); //close price, because we get the DEAL_ENTRY_OUT
      dprofit = HistoryDealGetDouble(dticket,DEAL_PROFIT);
      dfee = HistoryDealGetDouble(dticket,DEAL_FEE);
      dswap = HistoryDealGetDouble(dticket,DEAL_SWAP);
      dcommission = HistoryDealGetDouble(dticket,DEAL_COMMISSION);

      dtime = (datetime)HistoryDealGetInteger(dticket,DEAL_TIME); //close time
      break; //after get the last history, exit the loop
     }
   Comment("tot hist = ",total,
           "\nticket = ",dticket,
           "\nprice = ",dprice,
           "\nprofit = ",dprofit,
           "\nfee = ",dfee,
           "\nswap = ",dswap,
           "\ncommission = ",dcommission,
           "\nsymbol = ",dsymbol,
           "\ntype = ",dealtype,
           "\ntime = ",dtime);
  }
//+------------------------------------------------------------------+
