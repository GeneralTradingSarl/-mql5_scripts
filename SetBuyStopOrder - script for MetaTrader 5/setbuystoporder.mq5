//+------------------------------------------------------------------+
//|                                              SetBuyStopOrder.mq5 |
//|                           Copyright © 2012,     Nikolay Kositsin | 
//|                              Khabarovsk,   farria@mail.redcom.ru | 
//+------------------------------------------------------------------+  
#property copyright "Copyright © 2012, Nikolay Kositsin"
#property link "farria@mail.redcom.ru" 
//---- script version number
#property version   "1.00" 
//---- show the input parameters
#property script_show_inputs
//+----------------------------------------------+
//| INPUT PARAMETERS OF THE SCRIPT               |
//+----------------------------------------------+
input double  MM=0.1;       // Money Management
input uint  LEVEL=300;      // Trigger level in points from the current price
input uint  STOPLOSS=300;   // Stop loss in points from the trigger level
input uint  TAKEPROFIT=800; // Take profit in points from the trigger level
input uint  EXPIRED=0;      // The duration of the order in hours (0 - without time of cancellation)
input uint  RTOTAL=4;       // The number of repeats on unsuccessful transactions
input uint  SLEEPTIME=1;    // Pause time in seconds between repeats
//+------------------------------------------------------------------+ 
//| start function                                                   |
//+------------------------------------------------------------------+
void OnStart()
  {
//----
   for(uint count=0; count<=RTOTAL && !IsStopped(); count++)
     {
      uint result=SetBuyStopOrder(Symbol(),MM,LEVEL,STOPLOSS,TAKEPROFIT,EXPIRED);
      if(ResultRetcodeCheck(result)) break;
      else Sleep(SLEEPTIME*1000);
     }
//----
  }
//+------------------------------------------------------------------+
//| We put a pending order                                           |
//+------------------------------------------------------------------+
uint SetBuyStopOrder
(
 const string symbol,
 double Money_Management,
 uint level,
 uint StopLoss,
 uint Takeprofit,
 uint Expired
 )
//SetBuyStopOrder(symbol, Money_Management, level, StopLoss, Takeprofit, Expired);
//+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+
  {
//----
   int digit=int(SymbolInfoInteger(symbol,SYMBOL_DIGITS));
   double point=SymbolInfoDouble(symbol,SYMBOL_POINT);
   double price=SymbolInfoDouble(symbol, SYMBOL_ASK);
   datetime time=TimeCurrent();
   if(!digit || !point || !price || !time) return(TRADE_RETCODE_ERROR);
   if(!Expired) time=0;
//----  
   if(!StopCorrect(symbol,level)) return(TRADE_RETCODE_ERROR);
   double dlevel=level*point;
   double lprice=NormalizeDouble(price+dlevel,digit);
   double volume=LotCount(symbol,Money_Management,ORDER_TYPE_BUY,lprice);
   if(volume<=0)
     {
      Print(__FUNCTION__,"(): Incorrect volume for a trade request structure");
      return(TRADE_RETCODE_INVALID_VOLUME);
     }

//---- Declare structures of trade request and result of trade request
   MqlTradeRequest request;
   MqlTradeCheckResult check;
   MqlTradeResult result;

//---- nulling the structures
   ZeroMemory(request);
   ZeroMemory(result);
   ZeroMemory(check);

//---- initializing structure of the MqlTradeRequest to open BUY position
   request.type=ORDER_TYPE_BUY_STOP;
   if(Expired) request.type_time=ORDER_TIME_SPECIFIED;
   else request.type_time=ORDER_TIME_GTC;
   request.expiration=time+Expired*3600;

//---- Determine distance to the intervention level (in price chart units)
   request.price=lprice;
   request.action = TRADE_ACTION_PENDING;
   request.symbol = symbol;
   request.volume = volume;
//----
   if(StopLoss)
     {
      //---- Determine distance to Stop Loss (in price chart units)
      if(!StopCorrect(symbol,StopLoss)) return(TRADE_RETCODE_ERROR);
      double dStopLoss=StopLoss*point;
      request.sl=NormalizeDouble(request.price-dStopLoss,digit);
     }
   else request.sl=0.0;

   if(Takeprofit)
     {
      //---- Determine distance to Take Profit (in price chart units)
      if(!StopCorrect(symbol,Takeprofit)) return(TRADE_RETCODE_ERROR);
      double dTakeprofit=Takeprofit*point;
      request.tp=NormalizeDouble(request.price+dTakeprofit,digit);
     }
   else request.tp=0.0;
//----
   request.deviation=0;
   request.type_filling=ORDER_FILLING_FOK;

//---- Checking correctness of a trade request
   if(!OrderCheck(request,check))
     {
      Print(__FUNCTION__,"(): OrderCheck(): ",ResultRetcodeDescription(check.retcode));
      return(TRADE_RETCODE_INVALID);
     }

   string word="";
   StringConcatenate(word,__FUNCTION__,"(): <<< Set BuyStop order by ",symbol,"! >>>");
   Print(word);

   word=__FUNCTION__+"(): OrderSend(): ";

//---- open BUY position and check the result of trade request
   if(!OrderSend(request,result) || result.retcode!=TRADE_RETCODE_DONE)
     {
      Print(word,"<<< Failed to set BuyStop order by ",symbol,"!!! >>>");
      Print(word,ResultRetcodeDescription(result.retcode));
      PlaySound("timeout.wav");
      return(result.retcode);
     }
   else
   if(result.retcode==TRADE_RETCODE_DONE)
     {
      Print(word,"<<< BuyStop order by ",symbol," is set! >>>");
      PlaySound("ok.wav");
     }
   else
     {
      Print(word,"<<< Failed to set BuyStop order by ",symbol,"!!! >>>");
      PlaySound("timeout.wav");
      return(TRADE_RETCODE_ERROR);
     }
//----
   return(TRADE_RETCODE_DONE);
  }
//+------------------------------------------------------------------+
//| Lot size calculation for opening a long position                 |  
//+------------------------------------------------------------------+
double LotCount
(
 string symbol,
 double Money_Management,
 ENUM_ORDER_TYPE order_type,
 double price
 )
// (string symbol, double Money_Management, double price)
//+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+
  {
//----
   double margin,Lot;

//---- Lot calculation considering account balance
   margin=AccountInfoDouble(ACCOUNT_BALANCE)*Money_Management;
   if(!margin) return(-1);

   Lot=GetLotForOpeningPos(symbol,order_type,margin,price);

//---- normalizing the lot size to the nearest standard value 
   if(!LotCorrect(symbol,Lot,order_type,price)) return(-1);
//----
   return(Lot);
  }
//+------------------------------------------------------------------+
//| correction of a pending order size to an acceptable value        |
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
 ENUM_ORDER_TYPE order_type,
 double price
 )
//LotCorrect(string symbol, double& Lot, ENUM_ORDER_TYPE order_type, double price)
//+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+
  {

   double LOTSTEP=SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);
   double MaxLot=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);
   double MinLot=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);
   if(!LOTSTEP || !MaxLot || !MinLot) return(0);

//---- normalizing the lot size to the nearest standard value 
   Lot=LOTSTEP*MathFloor(Lot/LOTSTEP);

//---- checking the lot for the minimum allowable value
   if(Lot<MinLot) Lot=MinLot;
//---- checking the lot for the maximum allowable value       
   if(Lot>MaxLot) Lot=MaxLot;

//---- checking the funds sufficiency
   if(!LotFreeMarginCorrect(symbol,Lot,order_type,price))return(false);
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
 ENUM_ORDER_TYPE order_type,
 double price
 )
//(string symbol, double& Lot, ENUM_ORDER_TYPE order_type, double price)
//+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+
  {
//----  
//---- checking the funds sufficiency
   double freemargin=AccountInfoDouble(ACCOUNT_FREEMARGIN);
   if(freemargin<=0) return(false);
   double LOTSTEP=SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);
   double MinLot=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);
   if(!LOTSTEP || !MinLot) return(0);
   double maxLot=GetLotForOpeningPos(symbol,order_type,freemargin,price);
//---- normalizing the lot size to the nearest standard value 
   maxLot=LOTSTEP*MathFloor(maxLot/LOTSTEP);
   if(maxLot<MinLot) return(false);
   if(Lot>maxLot) Lot=maxLot;
//----
   return(true);
  }
//+------------------------------------------------------------------+
//| Lot size calculation for opening a position with lot_margin      |
//+------------------------------------------------------------------+
double GetLotForOpeningPos(string symbol,ENUM_ORDER_TYPE order_type,double lot_margin,double price)
  {
//----
   double n_margin;
   if(!OrderCalcMargin(order_type,symbol,1,price,n_margin) || !n_margin) return(0);
   double lot=lot_margin/n_margin;

//---- get trade constants
   double LOTSTEP=SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);
   double MaxLot=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);
   double MinLot=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);
   if(!LOTSTEP || !MaxLot || !MinLot) return(0);

//---- normalizing the lot size to the nearest standard value 
   lot=LOTSTEP*MathFloor(lot/LOTSTEP);

//---- checking the lot for the minimum allowable value
   if(lot<MinLot) lot=0;
//---- checking the lot for the maximum allowable value       
   if(lot>MaxLot) lot=MaxLot;
//----
   return(lot);
  }
//+------------------------------------------------------------------+
//| Returning a string result of a trading operation by its code     |
//+------------------------------------------------------------------+
string ResultRetcodeDescription(int retcode)
  {
   string str;
//----
   switch(retcode)
     {
      case TRADE_RETCODE_REQUOTE: str="Requote"; break;
      case TRADE_RETCODE_REJECT: str="Request rejected"; break;
      case TRADE_RETCODE_CANCEL: str="Request cancelled by trader"; break;
      case TRADE_RETCODE_PLACED: str="Order is placed"; break;
      case TRADE_RETCODE_DONE: str="Request is executed"; break;
      case TRADE_RETCODE_DONE_PARTIAL: str="Request is executed partially"; break;
      case TRADE_RETCODE_ERROR: str="Request processing error"; break;
      case TRADE_RETCODE_TIMEOUT: str="Request is cancelled because of a time out";break;
      case TRADE_RETCODE_INVALID: str="Invalid request"; break;
      case TRADE_RETCODE_INVALID_VOLUME: str="Invalid request volume"; break;
      case TRADE_RETCODE_INVALID_PRICE: str="Invalid request price"; break;
      case TRADE_RETCODE_INVALID_STOPS: str="Invalid request stops"; break;
      case TRADE_RETCODE_TRADE_DISABLED: str="Trading is forbidden"; break;
      case TRADE_RETCODE_MARKET_CLOSED: str="Market is closed"; break;
      case TRADE_RETCODE_NO_MONEY: str="Insufficient funds for request execution"; break;
      case TRADE_RETCODE_PRICE_CHANGED: str="Prices have changed"; break;
      case TRADE_RETCODE_PRICE_OFF: str="No quotes for request processing"; break;
      case TRADE_RETCODE_INVALID_EXPIRATION: str="Invalid order expiration date in the request"; break;
      case TRADE_RETCODE_ORDER_CHANGED: str="Order state has changed"; break;
      case TRADE_RETCODE_TOO_MANY_REQUESTS: str="Too many requests"; break;
      case TRADE_RETCODE_NO_CHANGES: str="No changes in the request"; break;
      case TRADE_RETCODE_SERVER_DISABLES_AT: str="Autotrading is disabled by the server"; break;
      case TRADE_RETCODE_CLIENT_DISABLES_AT: str="Autotrading is disabled by the client terminal"; break;
      case TRADE_RETCODE_LOCKED: str="Request is blocked for processing"; break;
      case TRADE_RETCODE_FROZEN: str="Order or position has been frozen"; break;
      case TRADE_RETCODE_INVALID_FILL: str="Unsupported type of order execution for the balance is specified "; break;
      case TRADE_RETCODE_CONNECTION: str="No connection with trade server"; break;
      case TRADE_RETCODE_ONLY_REAL: str="Operation is allowed only for real accounts"; break;
      case TRADE_RETCODE_LIMIT_ORDERS: str="Limit for the number of pending orders has been reached"; break;
      case TRADE_RETCODE_LIMIT_VOLUME: str="Limit for orders and positions volume for this symbol has been reached"; break;
      default: str="Unknown result";
     }
//----
   return(str);
  }
//+------------------------------------------------------------------+
//| returning the result of a trading operation to repeat the        |
//| transaction                                                      |
//+------------------------------------------------------------------+
bool ResultRetcodeCheck(int retcode)
  {
   string str;
//----
   switch(retcode)
     {
      case TRADE_RETCODE_REQUOTE: /*Requote*/ return(false); break;
      case TRADE_RETCODE_REJECT: /*Request rejected*/ return(false); break;
      case TRADE_RETCODE_CANCEL: /*Request cancelled by trader*/ return(true); break;
      case TRADE_RETCODE_PLACED: /*Order is placed*/ return(true); break;
      case TRADE_RETCODE_DONE: /*Request is executed*/ return(true); break;
      case TRADE_RETCODE_DONE_PARTIAL: /*Request is executed partially*/ return(true); break;
      case TRADE_RETCODE_ERROR: /*Request processing error*/ return(false); break;
      case TRADE_RETCODE_TIMEOUT: /*Request is cancelled because of a time out*/ return(false); break;
      case TRADE_RETCODE_INVALID: /*Invalid request*/ return(true); break;
      case TRADE_RETCODE_INVALID_VOLUME: /*Invalid request volume*/ return(true); break;
      case TRADE_RETCODE_INVALID_PRICE: /*Invalid request price*/ return(true); break;
      case TRADE_RETCODE_INVALID_STOPS: /*Invalid request stops*/ return(true); break;
      case TRADE_RETCODE_TRADE_DISABLED: /*Trading is forbidden*/ return(true); break;
      case TRADE_RETCODE_MARKET_CLOSED: /*Market is closed*/ return(true); break;
      case TRADE_RETCODE_NO_MONEY: /*Insufficient funds for request execution*/ return(true); break;
      case TRADE_RETCODE_PRICE_CHANGED: /*Prices have changed*/ return(false); return(true); break;
      case TRADE_RETCODE_PRICE_OFF: /*No quotes for request processing*/ return(true); break;
      case TRADE_RETCODE_INVALID_EXPIRATION: /*Invalid order expiration date in the request*/ return(true); break;
      case TRADE_RETCODE_ORDER_CHANGED: /*Order state has changed*/ return(true); break;
      case TRADE_RETCODE_TOO_MANY_REQUESTS: /*Too many requests*/ return(false); break;
      case TRADE_RETCODE_NO_CHANGES: /*No changes in the request*/ return(false); break;
      case TRADE_RETCODE_SERVER_DISABLES_AT: /*Autotrading is disabled by the server*/ return(true); break;
      case TRADE_RETCODE_CLIENT_DISABLES_AT: /*Autotrading is disabled by the client terminal*/ return(true); break;
      case TRADE_RETCODE_LOCKED: /*Request is blocked for processing*/ return(true); break;
      case TRADE_RETCODE_FROZEN: /*Order or position has been frozen*/ return(true); break;
      case TRADE_RETCODE_INVALID_FILL: /*Unsupported type of order execution for the balance is specified */ return(true); break;
      case TRADE_RETCODE_CONNECTION: /*No connection with trade server*/ return(true); break;
      case TRADE_RETCODE_ONLY_REAL: /*Operation is allowed only for real accounts*/ return(true); break;
      case TRADE_RETCODE_LIMIT_ORDERS: /*Limit for the number of pending orders has been reached*/ return(true); break;
      case TRADE_RETCODE_LIMIT_VOLUME: /*Limit for orders and positions volume for this symbol has been reached*/ return(true); break;
      default: /*Unknown result*/ return(false);
     }
//----
   return(true);
  }
//+------------------------------------------------------------------+
