//+------------------------------------------------------------------+
//|                                              Multi_BuyOrders.mq5 |
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

//--- input parameters
input double   Lots=0.01;
input int      TakeProfit=400;
input int      StopLoss=200;
input int      Num_Of_Buy=1;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---

   if(TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
     {
      int pick = MessageBox("You are about to open "+DoubleToString(Num_Of_Buy,0)+" buy order(s)\n","Buy",0x00000001);
      if(pick==1)
         for(int i =0 ; i< Num_Of_Buy; i++)
            place_order();

     }
   else
      MessageBox("Please enable AutoTrading");

  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|      Place order                                                 |
//+------------------------------------------------------------------+
void place_order()
  {

   double stoplosslevel, takeprofitlevel,
          Ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);

   if(StopLoss == 0)
      stoplosslevel=0;
   else
      stoplosslevel=Ask - StopLoss*_Point;

   if(TakeProfit == 0)
      takeprofitlevel=0;
   else
      takeprofitlevel =Ask + TakeProfit*_Point;

   bool TB= trade.Buy(Lots,_Symbol,Ask,stoplosslevel,takeprofitlevel);

   if(TB ==false)
      Alert("OrderSend failed with error #",GetLastError());


  }

