//+------------------------------------------------------------------+
//|                                             OpenSellPosition.mq5 |
//|                           Copyright © 2012,     Nikolay Kositsin | 
//|                              Khabarovsk,   farria@mail.redcom.ru | 
//+------------------------------------------------------------------+  
#property copyright "Copyright © 2012, Nikolay Kositsin"
#property link "farria@mail.redcom.ru" 
//---- script version number
#property version   "1.01" 
//---- display input parameters
#property script_show_inputs
//+----------------------------------------------+
//| SCRIPT INPUT PARAMETERS                      |
//+----------------------------------------------+
input double  MM=0.1;       // Money Management
input int  DEVIATION=10;    // Price deviation
input int  STOPLOSS=300;    // Stop Loss in points from the current price
input int  TAKEPROFIT=800;  // Take Profit in points from the current price
input uint RTOTAL=4;        // Number of repeats in case of unsuccessful deals
input uint SLEEPTIME=1;     // Pause duration between repeats in seconds
//+------------------------------------------------------------------+ 
//| Start function                                                   |
//+------------------------------------------------------------------+
void OnStart()
  {
//----
   for(uint count=0; count<=RTOTAL && !IsStopped(); count++)
     {
      uint result=SellPositionOpen(Symbol(),MM,DEVIATION,STOPLOSS,TAKEPROFIT);
      if(ResultRetcodeCheck(result)) break;
      else Sleep(SLEEPTIME*1000);
     }
//----
  }
//+------------------------------------------------------------------+
//|  Open sell position                                              |
//+------------------------------------------------------------------+
uint SellPositionOpen
(
 const string symbol,
 double Money_Management,
 uint deviation,
 int StopLoss,
 int Takeprofit
 )
//SellPositionOpen(symbol, Money_Management, deviation, StopLoss, Takeprofit);
//+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+
  {
//----
   double volume=SellLotCount(symbol,Money_Management);
   if(volume<=0)
     {
      Print(__FUNCTION__,"(): Incorrect volume for trading request structure");
      return(TRADE_RETCODE_INVALID_VOLUME);
     }

//---- Declare structures of trade request and result of trade request
   MqlTradeRequest request;
   MqlTradeCheckResult check;
   MqlTradeResult result;

//---- Nulling structures
   ZeroMemory(request);
   ZeroMemory(result);
   ZeroMemory(check);
//----
   int digit=int(SymbolInfoInteger(symbol,SYMBOL_DIGITS));
   double point=SymbolInfoDouble(symbol,SYMBOL_POINT);
   double price=SymbolInfoDouble(symbol, SYMBOL_BID);
   if(!digit || !point || !price) return(TRADE_RETCODE_ERROR);
   
//---- Initializing structure of the MqlTradeRequest to open SELL position
   request.type   = ORDER_TYPE_SELL;
   request.price  = price;
   request.action = TRADE_ACTION_DEAL;
   request.symbol = symbol;
   request.volume = volume;
//----
   if(StopLoss)
     {
      //---- Determine distance to Stop Loss (in price chart units)
      if(!StopCorrect(symbol,StopLoss)) return(TRADE_RETCODE_ERROR);
      double dStopLoss=StopLoss*point;
      request.sl=NormalizeDouble(request.price+dStopLoss,digit);
     }
   else request.sl=0.0;

   if(Takeprofit)
     {
      //---- Determine distance to Take Profit (in price chart units)
      if(!StopCorrect(symbol,Takeprofit)) return(TRADE_RETCODE_ERROR);
      double dTakeprofit=Takeprofit*point;
      request.tp=NormalizeDouble(request.price-dTakeprofit,digit);
     }
   else request.tp=0.0;
//----
   request.deviation=deviation;
   request.type_filling=ORDER_FILLING_FOK;

//---- Check correctness of a trade request
   if(!OrderCheck(request,check))
     {
      Print(__FUNCTION__,"(): OrderCheck(): ",ResultRetcodeDescription(check.retcode));
      return(TRADE_RETCODE_INVALID);
     }

   string word="";
   StringConcatenate(word,__FUNCTION__,"(): <<< Open Sell position at ",symbol,"! >>>");
   Print(word);

   word=__FUNCTION__+"(): OrderSend(): ";

//---- Open SELL position and check the result of trade request
   if(!OrderSend(request,result) || result.retcode!=TRADE_RETCODE_DONE)
     {
      Print(word,"<<< Failed to open Sell position at ",symbol,"!!! >>>");
      Print(word,ResultRetcodeDescription(result.retcode));
      PlaySound("timeout.wav");
      return(result.retcode);
     }
   else
   if(result.retcode==TRADE_RETCODE_DONE)
     {
      Print(word,"<<< Sell position at ",symbol," opened! >>>");
      PlaySound("ok.wav");
     }
   else
     {
      Print(word,"<<< Failed to open Sell position at ",symbol,"!!! >>>");
      PlaySound("timeout.wav");
      return(TRADE_RETCODE_ERROR);
     }
//----
   return(TRADE_RETCODE_DONE);
  }
//+------------------------------------------------------------------+
//| Calculating a lot size for buying                                |  
//+------------------------------------------------------------------+
double SellLotCount
(
 string symbol,
 double Money_Management
 )
// (string symbol, double Money_Management)
//+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+
  {
//----
   double margin,Lot;

//---- Calculating a lot based on the account's funds balance
   margin=AccountInfoDouble(ACCOUNT_BALANCE)*Money_Management;
   if(!margin) return(-1);

   Lot=GetLotForOpeningPos(symbol,POSITION_TYPE_SELL,margin);

//---- Normalize a lot size up to the nearest standard value 
   if(!LotCorrect(symbol,Lot,POSITION_TYPE_SELL)) return(-1);
//----
   return(Lot);
  }
//+------------------------------------------------------------------+
//| Correct a pending order size up to an acceptable value           |
//+------------------------------------------------------------------+
bool StopCorrect(string symbol,int &Stop)
  {
//----
   int Extrem_Stop=int(SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL));
   if(!Extrem_Stop) return(false);
   if(Stop<Extrem_Stop) Stop=Extrem_Stop;
//----
   return(true);
  }
//+------------------------------------------------------------------+
//| LotCorrect() function                                            |
//+------------------------------------------------------------------+
bool LotCorrect
(
 string symbol,
 double &Lot,
 ENUM_POSITION_TYPE trade_operation
 )
//LotCorrect(string symbol, double& Lot, ENUM_POSITION_TYPE trade_operation)
//+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+
  {

   double LOTSTEP=SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);
   double MaxLot=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);
   double MinLot=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);
   if(!LOTSTEP || !MaxLot || !MinLot) return(0);

//---- Normalize a lot size up to the nearest standard value 
   Lot=LOTSTEP*MathFloor(Lot/LOTSTEP);

//---- Check the lot for the minimum allowable value
   if(Lot<MinLot) Lot=MinLot;
//---- Check the lot for the maximum allowable value       
   if(Lot>MaxLot) Lot=MaxLot;

//---- Check the funds sufficiency
   if(!LotFreeMarginCorrect(symbol,Lot,trade_operation))return(false);
//----
   return(true);
  }
//+------------------------------------------------------------------+
//| LotFreeMarginCorrect() function                                  |
//+------------------------------------------------------------------+
bool LotFreeMarginCorrect
(
 string symbol,
 double &Lot,
 ENUM_POSITION_TYPE trade_operation
 )
//(string symbol, double& Lot, ENUM_POSITION_TYPE trade_operation)
//+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+
  {
//----  
//---- Check the funds sufficiency
   double freemargin=AccountInfoDouble(ACCOUNT_FREEMARGIN);
   if(freemargin<=0) return(false);
   double LOTSTEP=SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);
   double MinLot=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);
   if(!LOTSTEP || !MinLot) return(0);
   double maxLot=GetLotForOpeningPos(symbol,trade_operation,freemargin);
//---- Normalize a lot size up to the nearest standard value 
   maxLot=LOTSTEP*MathFloor(maxLot/LOTSTEP);
   if(maxLot<MinLot) return(false);
   if(Lot>maxLot) Lot=maxLot;
//----
   return(true);
  }
//+------------------------------------------------------------------+
//| Calculating a lot size for opening a position with lot_margin    |
//+------------------------------------------------------------------+
double GetLotForOpeningPos(string symbol,ENUM_POSITION_TYPE direction,double lot_margin)
  {
//----
   double price=0.0,n_margin;
   if(direction==POSITION_TYPE_BUY)  price=SymbolInfoDouble(symbol,SYMBOL_ASK);
   if(direction==POSITION_TYPE_SELL) price=SymbolInfoDouble(symbol,SYMBOL_BID);
   if(!price) return(NULL);

   if(!OrderCalcMargin(ENUM_ORDER_TYPE(direction),symbol,1,price,n_margin) || !n_margin) return(0);
   double lot=lot_margin/n_margin;

//---- Get trade constants
   double LOTSTEP=SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);
   double MaxLot=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);
   double MinLot=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);
   if(!LOTSTEP || !MaxLot || !MinLot) return(0);

//---- Normalize a lot size up to the nearest standard value 
   lot=LOTSTEP*MathFloor(lot/LOTSTEP);

//---- Check the lot for the minimum allowable value
   if(lot<MinLot) lot=0;
//---- Check the lot for the maximum allowable value       
   if(lot>MaxLot) lot=MaxLot;
//----
   return(lot);
  }
//+------------------------------------------------------------------+
//| Return a string result of a trade operation by its code          |
//+------------------------------------------------------------------+
string ResultRetcodeDescription(int retcode)
  {
   string str;
//----
   switch(retcode)
     {
      case TRADE_RETCODE_REQUOTE: str="Requote"; break;
      case TRADE_RETCODE_REJECT: str="Request rejected"; break;
      case TRADE_RETCODE_CANCEL: str="Request canceled by trader"; break;
      case TRADE_RETCODE_PLACED: str="Order placed"; break;
      case TRADE_RETCODE_DONE: str="Request executed"; break;
      case TRADE_RETCODE_DONE_PARTIAL: str="Request executed partially"; break;
      case TRADE_RETCODE_ERROR: str="Request handling error"; break;
      case TRADE_RETCODE_TIMEOUT: str="Request canceled by timeout";break;
      case TRADE_RETCODE_INVALID: str="Invalid request"; break;
      case TRADE_RETCODE_INVALID_VOLUME: str="Invalid volume"; break;
      case TRADE_RETCODE_INVALID_PRICE: str="Invalid price"; break;
      case TRADE_RETCODE_INVALID_STOPS: str="Invalid stops"; break;
      case TRADE_RETCODE_TRADE_DISABLED: str="Trading disabled"; break;
      case TRADE_RETCODE_MARKET_CLOSED: str="Market closed"; break;
      case TRADE_RETCODE_NO_MONEY: str="Insufficient funds for request execution"; break;
      case TRADE_RETCODE_PRICE_CHANGED: str="Prices changed"; break;
      case TRADE_RETCODE_PRICE_OFF: str="No quotes for request handling"; break;
      case TRADE_RETCODE_INVALID_EXPIRATION: str="Invalid order expiration date"; break;
      case TRADE_RETCODE_ORDER_CHANGED: str="Order state changed"; break;
      case TRADE_RETCODE_TOO_MANY_REQUESTS: str="Too many requests"; break;
      case TRADE_RETCODE_NO_CHANGES: str="No changes in request"; break;
      case TRADE_RETCODE_SERVER_DISABLES_AT: str="Automated trading disabled by server"; break;
      case TRADE_RETCODE_CLIENT_DISABLES_AT: str="Automated trading disabled by client terminal"; break;
      case TRADE_RETCODE_LOCKED: str="Request blocked for handling"; break;
      case TRADE_RETCODE_FROZEN: str="Order or position frozen"; break;
      case TRADE_RETCODE_INVALID_FILL: str="Invalid order execution type by remainder "; break;
      case TRADE_RETCODE_CONNECTION: str="No connection with trade server"; break;
      case TRADE_RETCODE_ONLY_REAL: str="Operation is allowed only for real accounts"; break;
      case TRADE_RETCODE_LIMIT_ORDERS: str="Pending orders limit exceeded"; break;
      case TRADE_RETCODE_LIMIT_VOLUME: str="Orders and positions limit for the symbol exceeded"; break;
      default: str="Unknown result";
     }
//----
   return(str);
  }
//+------------------------------------------------------------------+
//| Return trade operation result to repeat the deal                 |
//+------------------------------------------------------------------+
bool ResultRetcodeCheck(int retcode)
  {
   string str;
//----
   switch(retcode)
     {
      case TRADE_RETCODE_REQUOTE: /*Requote*/ return(false); break;
      case TRADE_RETCODE_REJECT: /*Request rejected*/ return(false); break;
      case TRADE_RETCODE_CANCEL: /*Request canceled by trader*/ return(true); break;
      case TRADE_RETCODE_PLACED: /*Order placed*/ return(true); break;
      case TRADE_RETCODE_DONE: /*Request executed*/ return(true); break;
      case TRADE_RETCODE_DONE_PARTIAL: /*Request executed partially*/ return(true); break;
      case TRADE_RETCODE_ERROR: /*Request handling error*/ return(false); break;
      case TRADE_RETCODE_TIMEOUT: /*Request canceled by timeout*/ return(false); break;
      case TRADE_RETCODE_INVALID: /*Invalid request*/ return(true); break;
      case TRADE_RETCODE_INVALID_VOLUME: /*Invalid volume*/ return(true); break;
      case TRADE_RETCODE_INVALID_PRICE: /*Invalid price*/ return(true); break;
      case TRADE_RETCODE_INVALID_STOPS: /*Invalid stops*/ return(true); break;
      case TRADE_RETCODE_TRADE_DISABLED: /*Trading disabled*/ return(true); break;
      case TRADE_RETCODE_MARKET_CLOSED: /*Market closed*/ return(true); break;
      case TRADE_RETCODE_NO_MONEY: /*Insufficient funds for request execution*/ return(true); break;
      case TRADE_RETCODE_PRICE_CHANGED: /*Prices changed*/ return(false); break;
      case TRADE_RETCODE_PRICE_OFF: /*No quotes for request handling*/ return(false); break;
      case TRADE_RETCODE_INVALID_EXPIRATION: /*Invalid order expiration date*/ return(true); break;
      case TRADE_RETCODE_ORDER_CHANGED: /*Order state changed*/ return(true); break;
      case TRADE_RETCODE_TOO_MANY_REQUESTS: /*Too many requests*/ return(false); break;
      case TRADE_RETCODE_NO_CHANGES: /*No changes in request*/ return(false); break;
      case TRADE_RETCODE_SERVER_DISABLES_AT: /*Automated trading disabled by server*/ return(true); break;
      case TRADE_RETCODE_CLIENT_DISABLES_AT: /*Automated trading disabled by client terminal*/ return(true); break;
      case TRADE_RETCODE_LOCKED: /*Request blocked for handling*/ return(true); break;
      case TRADE_RETCODE_FROZEN: /*Order or position frozen*/ return(false); break;
      case TRADE_RETCODE_INVALID_FILL: /*Invalid order execution type by remainder */ return(true); break;
      case TRADE_RETCODE_CONNECTION: /*No connection with trade server*/ break;
      case TRADE_RETCODE_ONLY_REAL: /*Operation is allowed only for real accounts*/ return(true); break;
      case TRADE_RETCODE_LIMIT_ORDERS: /*Pending orders limit exceeded*/ return(true); break;
      case TRADE_RETCODE_LIMIT_VOLUME: /*Orders and positions limit for the symbol exceeded*/ return(true); break;
      default: /*Unknown result*/ return(false);
     }
//----
   return(true);
  }
//+------------------------------------------------------------------+
