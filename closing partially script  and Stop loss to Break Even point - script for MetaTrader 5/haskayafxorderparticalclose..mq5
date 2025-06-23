//+------------------------------------------------------------------+
//|                                 HaskayafxOrderParticalClose..mq5 |
//|                                                 Copyright 2021,  |
//|                                   https://www.haskayayazilim.net |
//+------------------------------------------------------------------+

#property copyright "Copyright 2021, Haskaya"
#property link      "https://www.haskayayazilim.net"
#property version   "1.00"

#property script_show_inputs
//--- input parameters
#include <trade/trade.mqh>
input bool ParticalClosed=false;
input int ClosedVolume=50;//Percentage of Lots to Close %
input string ack="Type 50 for 50%";
input bool  StopMoveToBE=false;
input int   AddBreakEventPips=10;// opening price +1 Pips




//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   bool resres;
   CTrade trade;
  for (int i = PositionsTotal() - 1; i >= 0; i--)
   {
   
      ulong  Position_Ticket = PositionGetTicket(i);
      double Position_Volume = PositionGetDouble(POSITION_VOLUME);
      string Position_Symbol = PositionGetString(POSITION_SYMBOL);
      int    Position_Digits = (int)SymbolInfoInteger(Position_Symbol, SYMBOL_DIGITS);
      double Position_Points =  SymbolInfoDouble(Position_Symbol,SYMBOL_POINT);
      
      double Position_Volume_Closed=NormalizeDouble((Position_Volume*ClosedVolume/100),2);
      double Position_OpenPrice= NormalizeDouble(PositionGetDouble(POSITION_PRICE_OPEN),Position_Digits);
      if( AddBreakEventPips>0) Position_OpenPrice=NormalizeDouble((Position_OpenPrice+AddBreakEventPips*Position_Points),Position_Digits);
      double Position_SL = NormalizeDouble(PositionGetDouble(POSITION_SL),Position_Digits);
      double Position_TP = NormalizeDouble(PositionGetDouble(POSITION_TP),Position_Digits);
      
   
      if(StopMoveToBE && (Position_SL>0 ||  Position_SL==0))
      {
      resres=trade.PositionModify(Position_Ticket,Position_OpenPrice,Position_TP);
      }
     
     if(ParticalClosed && Position_Volume>0.01)
     {
      resres=trade.PositionClosePartial(Position_Ticket,Position_Volume_Closed,-1);
       
     }
  }
  }
//+------------------------------------------------------------------+
