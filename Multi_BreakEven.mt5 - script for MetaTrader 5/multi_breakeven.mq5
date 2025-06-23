//+------------------------------------------------------------------+
//|                                              Multi_BreakEven.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property script_show_inputs

#include <Trade/Trade.mqh>
//create instance of the trade
CTrade trade;
//+------------------------------------------------------------------+
//|      input parameters                                            |
//+------------------------------------------------------------------+
enum ChooseOption {Target=1,NumOfPips=2};
input string   Option = "SELECT TargetPrice OR NumOfPips BELOW";
input string   NOTEWELL = "When TargetPrice is selected,Pips has no effect&Vice Versa";

input ChooseOption TargetOrPips = 2;
input int      Pips2BreakEven = 100;
input double   TargetPrice = 1.03350;

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
 if( TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) )
   {      
    int pick = MessageBox("You are about to set StopLoss to BreakEven \n","BreakEven",0x00000001);               
         if (pick==1) BreakEvenFunc();
              
   }
  else MessageBox(" Enable AutoTrading !! ");
 

  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BreakEvenFunc()
  {
   bool mbd =true;

   for(int p=PositionsTotal()-1; p >=0; p--)
      if(PositionSelect(PositionGetSymbol(p)) && PositionGetString(POSITION_SYMBOL)== Symbol())
        {
         double opn = PositionGetDouble(POSITION_PRICE_OPEN),
                stl = PositionGetDouble(POSITION_SL),
                tp = PositionGetDouble(POSITION_TP);
         // Buy
         if(PositionGetInteger(POSITION_TYPE)== ORDER_TYPE_BUY)
           {
            double bid=SymbolInfoDouble(Symbol(),SYMBOL_BID);
            if(TargetOrPips==1)
               if(bid>TargetPrice && opn>stl)
                  mbd= trade.PositionModify(PositionGetSymbol(p),TargetPrice,tp);

            if(TargetOrPips==2)
               if(bid>opn+Pips2BreakEven*_Point && opn>stl)
                  mbd= trade.PositionModify(PositionGetSymbol(p),opn+Pips2BreakEven*_Point,tp);

            if(mbd==false)
               Alert("Buy modify. Err#",GetLastError());

           }
         /*----------------------------------------------------------------------------------------------------------------*/
         // Sell
         if(PositionGetInteger(POSITION_TYPE)== ORDER_TYPE_SELL)
           {
            double ask=SymbolInfoDouble(Symbol(),SYMBOL_ASK);
            if(TargetOrPips==1)
               if(ask<TargetPrice && (stl>opn || stl==0))
                  mbd =trade.PositionModify(PositionGetSymbol(p),TargetPrice,tp);

            if(TargetOrPips==2)
               if(ask<opn-Pips2BreakEven*_Point && (stl>opn || stl==0))
                  mbd =trade.PositionModify(PositionGetSymbol(p),opn-Pips2BreakEven*_Point,tp);

            if(mbd==false)
               Alert("Sell modify. Err#",GetLastError());
           }
        }

  }

//+------------------------------------------------------------------+
