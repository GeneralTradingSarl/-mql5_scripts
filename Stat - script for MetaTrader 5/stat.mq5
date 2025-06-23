//+------------------------------------------------------------------+
//|                                                         Stat.mq5 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Aliaksandr Yemialyanau"
#property version   "1.00"
#property script_show_inputs
//--- input parameters
input datetime Start_Date=D'2014.08.18';
input datetime End_Date=D'2015.08.18';
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   double result,profit=0,loss=0;
   ulong ticket=0,trades=0;

   HistorySelect(Start_Date,End_Date);
   uint total=HistoryDealsTotal();
   for(uint i=0;i<total;i++)
     {
      if((ticket=HistoryDealGetTicket(i))>0)
        {
         if(HistoryDealGetString(ticket,DEAL_SYMBOL)==Symbol())
           {
            trades++;
            result=HistoryDealGetDouble(ticket,DEAL_PROFIT);
            if(result<0) loss-=result;
            else profit+=result;
           }
        }
     }
   if(trades>0)
     {
      if(loss>0) Comment("Trades=",trades,"  Profit=",DoubleToString(profit-loss,2),"  PF=",DoubleToString(profit/loss,2));
      else Comment("Trades=",trades,"  Profit=",DoubleToString(profit-loss,2),"  PF=++");
     }
   else Comment("Trades=0");
   Sleep(60000);
   Comment("");
  }
//+------------------------------------------------------------------+
