#property copyright           "Mokara"
#property link                "https://www.mql5.com/en/users/mokara"
#property description         "Kamikaze"
#property version             "1.0"
#property script_show_inputs  true

enum ORDER
{
   BUY,
   SELL
};

input ORDER order = BUY;   //Order Type
input int profit = 100;    //Take Profit in Pips

double RequiredMargin(string sym, double vol, ORDER or)
{
   string currencyAccount, currencyBase, currencyQuote, symTemp;
   double symbolContract, symbolBid, symbolAsk;
   int accountLeverage;
   bool symbolType;
   currencyAccount = AccountInfoString(ACCOUNT_CURRENCY);
   currencyBase = SymbolInfoString(sym, SYMBOL_CURRENCY_BASE);
   currencyQuote = SymbolInfoString(sym, SYMBOL_CURRENCY_PROFIT);
   symbolContract = SymbolInfoDouble(sym, SYMBOL_TRADE_CONTRACT_SIZE);
   symbolBid = SymbolInfoDouble(sym, SYMBOL_BID);
   symbolAsk = SymbolInfoDouble(sym, SYMBOL_ASK);
   accountLeverage = AccountInfoInteger(ACCOUNT_LEVERAGE);   
   
   if(currencyAccount == currencyBase)
   {
      return(vol * symbolContract / accountLeverage);
   }
   else if(currencyAccount == currencyQuote)
   {
      return((or==BUY?symbolAsk:symbolBid)*vol*symbolContract/accountLeverage);
   }
   else
   {      
      if(SymbolExist(currencyBase+currencyAccount, symbolType))
      {
         symTemp = currencyBase+currencyAccount;
         if(!SymbolInfoInteger(symTemp, SYMBOL_SELECT)) SymbolSelect(symTemp, true);
         Sleep(100);
         symbolBid = SymbolInfoDouble(symTemp, SYMBOL_BID);
         symbolAsk = SymbolInfoDouble(symTemp, SYMBOL_ASK);
         return((or==BUY?symbolAsk:symbolBid)*vol*symbolContract/accountLeverage); 
      }
      else if(SymbolExist(currencyAccount+currencyBase, symbolType))
      {
         symTemp = currencyAccount+currencyBase;
         if(!SymbolInfoInteger(symTemp, SYMBOL_SELECT)) SymbolSelect(symTemp, true);
         Sleep(100);
         symbolBid = SymbolInfoDouble(symTemp, SYMBOL_BID);
         symbolAsk = SymbolInfoDouble(symTemp, SYMBOL_ASK);
         return((1/(or==BUY?symbolAsk:symbolBid))*vol*symbolContract/accountLeverage); 
      }
      else
      {
         MessageBox("Unable to calculate required margin.", "ERROR", MB_ICONERROR|MB_OK);
         return(0);
      }
   }
}

double GetMaxVol(string sym, double mar)
{
   double marginFree = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   double volStep = SymbolInfoDouble(sym, SYMBOL_VOLUME_STEP);
   double volOut = MathFloor((marginFree/mar)/volStep)*volStep;
   if(volOut < SymbolInfoDouble(sym, SYMBOL_VOLUME_MIN)) volOut = 0;
   if(volOut > SymbolInfoDouble(sym, SYMBOL_VOLUME_MAX)) volOut = SymbolInfoDouble(sym, SYMBOL_VOLUME_MAX);
   return(volOut);
}

void OnStart()
{
   MqlTradeRequest tReq = {0};
   MqlTradeResult tRes = {0};
   double mar, vol;
   
   //Custom Calculation------------------------------
   //double mar = RequiredMargin(_Symbol, 1, order);
   //double vol = GetMaxVol(_Symbol, mar);
   //------------------------------------------------
   
   //MQL5 Built-In Function--------------------------
   if(!OrderCalcMargin((order == BUY)?ORDER_TYPE_BUY:ORDER_TYPE_SELL, _Symbol, 1, (order == BUY)?SymbolInfoDouble(_Symbol, SYMBOL_ASK):SymbolInfoDouble(_Symbol, SYMBOL_BID), mar))
   {
      Alert("ERROR: margin cannot be calculated.");
      return;
   }
   vol = GetMaxVol(_Symbol, mar);
   //------------------------------------------------
   
   ZeroMemory(tReq);
   ZeroMemory(tRes);
   tReq.symbol = _Symbol;
   tReq.volume = vol;
   tReq.action = TRADE_ACTION_DEAL;
   tReq.deviation = 20;
   switch(order)
   {
      case SELL: 
            tReq.type = ORDER_TYPE_SELL; 
            tReq.price = SymbolInfoDouble(_Symbol, SYMBOL_BID); 
            tReq.tp = tReq.price - NormalizeDouble(profit * _Point, _Digits);
            break;
      case BUY: 
            tReq.type = ORDER_TYPE_BUY; 
            tReq.price = SymbolInfoDouble(_Symbol, SYMBOL_ASK); 
            tReq.tp = tReq.price + NormalizeDouble(profit * _Point, _Digits);
            break;
   }
   
   if(!OrderSend(tReq, tRes))
   {
      Alert("ERROR: order cannot be sent. Error Code: " + GetLastError());
      return;
   }
}