//+------------------------------------------------------------------+
//|                                        Multi_SellLimitOrders.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Wamek Script-2023"
#property link      "eawamek@gmail.com"
#property version   "1.00"
#property script_show_inputs


#include <Trade\Trade.mqh>

//create instance of the trade
CTrade trade;

enum ChooseOption {Target=1,NumOfPips=2};
//--- input parameters
input string   Option = "SELECT TargetPrice OR NumOfPips BELOW";
input string   NOTEWELL = "When TargetPrice is selected,Pips has no effect& Vice Versa";

input ChooseOption TargetOrPips = 2;
input int      Pips_4rm_BidPrice = 400;
input double   TargetPrice = 1.03350;
input double   Lots= .01;
input int      TakeProfit=400;
input int      StopLoss= 200;
input int      NumOfSellLimit =1;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---

   if(TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
     {
      int pick = MessageBox("You are about to open "+DoubleToString(NumOfSellLimit,0)+" SellLimit order(s)\n","SellLimit",0x00000001);
      if(pick==1)
         for(int i =0 ; i< NumOfSellLimit; i++)
            place_order();

     }
   else
      MessageBox("Please enable AutoTrading");

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
double WhereToSell()
  {
   if(TargetOrPips == 1)
      return(TargetPrice);
   else
      return(Bid+Pips_4rm_BidPrice*_Point);
  }


//+------------------------------------------------------------------+
//|      Place order                                                 |
//+------------------------------------------------------------------+
void place_order()
  {
   double stoplosslevel, takeprofitlevel;

   if(StopLoss == 0)
      stoplosslevel=0;
   else
      stoplosslevel=WhereToSell() + StopLoss*_Point;

   if(TakeProfit == 0)
      takeprofitlevel=0;
   else
      takeprofitlevel =  WhereToSell() - TakeProfit*_Point;


   bool TSL= trade.SellLimit(Lots,WhereToSell(),_Symbol,stoplosslevel,takeprofitlevel);

   if(TSL ==false)
      Alert("OrderSend failed with error #",GetLastError());


  }
//+------------------------------------------------------------------+
