//+------------------------------------------------------------------+
//|                                                Trap News MT5.mq5 |
//|                                                  rezarahmad 2024 |
//|                                             rezarahmad@gmail.com |
//+------------------------------------------------------------------+
#property copyright "rezarahmad 2024"
#property link      "rezarahmad@gmail.com"
#property version   "1.00"
#property script_show_inputs

// Input parameters for the orders
input double BuyStopPrice = 50;     // Price at which to place the Buy Stop order
input double SellStopPrice = 50;    // Price at which to place the Sell Stop order
input double LotSize = 0.01;             // Size of the orders
input double BuyStopLoss = 25;      // Stop Loss level for Buy Stop order
input double BuyTakeProfit = 100;    // Take Profit level for Buy Stop order
input double SellStopLoss = 25;     // Stop Loss level for Sell Stop order
input double SellTakeProfit = 100;   // Take Profit level for Sell Stop order
input double MagicNumber = 1234;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
void OnStart()
  {
   string symbol = Symbol();
// Get current Ask and Bid prices
   double Ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
   double Bid = SymbolInfoDouble(symbol, SYMBOL_BID);
   double point=SymbolInfoDouble(_Symbol,SYMBOL_POINT);
// Define the symbol


// Check if the Buy Stop price is above the current Ask price
   if(BuyStopPrice <= Ask)
     {
      Print("Error: Buy Stop price must be above the current market price.");

     }

// Check if the Sell Stop price is below the current Bid price
   if(SellStopPrice >= Bid)
     {
      Print("Error: Sell Stop price must be below the current market price.");

     }

// Define the deviation for order placement
   int deviation = 10; // The maximum price deviation in points

// Place the Buy Stop order
   MqlTradeRequest buy_request;
   MqlTradeResult buy_result;

   ZeroMemory(buy_request);
   ZeroMemory(buy_result);

   buy_request.action = TRADE_ACTION_PENDING;
   buy_request.symbol = symbol;
   buy_request.volume = LotSize;
   buy_request.type = ORDER_TYPE_BUY_STOP;
   buy_request.price = Bid + (BuyStopPrice*point);
   buy_request.sl = Bid - (BuyStopLoss*point);
   buy_request.tp = Bid + (BuyTakeProfit*point);
   buy_request.deviation = deviation;
   buy_request.magic = MagicNumber;
   buy_request.comment = "Buy Stop Order";

// Send the trade request for Buy Stop
   if(!OrderSend(buy_request, buy_result))
     {
      Print("Error placing Buy Stop order: ", buy_result.retcode);
     }
   else
     {
      Print("Buy Stop order placed successfully. Ticket: ", buy_result.order);
     }

// Place the Sell Stop order
   MqlTradeRequest sell_request;
   MqlTradeResult sell_result;

   ZeroMemory(sell_request);
   ZeroMemory(sell_result);

   sell_request.action = TRADE_ACTION_PENDING;
   sell_request.symbol = symbol;
   sell_request.volume = LotSize;
   sell_request.type = ORDER_TYPE_SELL_STOP;
   sell_request.price =   Ask - (SellStopPrice*point) ;
   sell_request.sl = Ask + (SellStopLoss*point) ;
   sell_request.tp = Ask - (SellTakeProfit*point);
   sell_request.deviation = deviation;
   sell_request.magic = MagicNumber;
   sell_request.comment = "Sell Stop Order";

// Send the trade request for Sell Stop
   if(!OrderSend(sell_request, sell_result))
     {
      Print("Error placing Sell Stop order: ", sell_result.retcode);
     }
   else
     {
      Print("Sell Stop order placed successfully. Ticket: ", sell_result.order);
     }


  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
