#property copyright           "Mokara"
#property link                "https://www.mql5.com/en/users/mokara"
#property description         "Scalp All"
#property version             "1.0"
#property script_show_inputs  true
#define MAGIC 999

input double rTP = 5;      //Take Profit Ratio
input double rSL = 10;     //Stop Loss Ratio
input double vol = 0.1;    //Volume
input long spread = 20;    //Maximum Spread
input int count = 0;       //Maximum Trades (0 for unlimited)

enum TRADE
{
   BUY = 0,
   SELL = 1
};

void OnStart()
{
   MqlTradeRequest tReq = {0};
   MqlTradeResult tRes = {0};
   int t = -1, i, d, s, c = 0; //type, index, digits, spread, count
   double p; //point
   string n; //symbol name
   
   for(i = 0; i < SymbolsTotal(true); i++)
   {
      n = SymbolName(i, true);
      s = SymbolInfoInteger(n, SYMBOL_SPREAD);
      p = SymbolInfoDouble(n, SYMBOL_POINT);
      d = SymbolInfoInteger(n, SYMBOL_DIGITS);      
      
      if(s > spread) continue; //spread filter      
      MathSrand(GetTickCount());
      Sleep(MathRand()%100);
      
      ZeroMemory(tReq);
      ZeroMemory(tRes);
      tReq.symbol = n;
      tReq.volume = vol;
      tReq.action = TRADE_ACTION_DEAL;
      tReq.deviation = 5;
      tReq.magic = MAGIC;
      
      MathSrand(GetTickCount());
      t = int(MathRand()%2);
      switch(t)
      {
         case BUY: 
               tReq.type = ORDER_TYPE_BUY; 
               tReq.price = SymbolInfoDouble(n, SYMBOL_ASK); 
               tReq.tp = tReq.price + NormalizeDouble(s * p * rTP, d);
               tReq.sl = tReq.price - NormalizeDouble(s * p * rSL, d);
               break;
         case SELL: 
               tReq.type = ORDER_TYPE_SELL; 
               tReq.price = SymbolInfoDouble(n, SYMBOL_BID); 
               tReq.tp = tReq.price - NormalizeDouble(s * p * rTP, d);
               tReq.sl = tReq.price + NormalizeDouble(s * p * rSL, d);
               break;
      }
   
      if(!OrderSend(tReq, tRes))
      {
         Print("ERROR: order send. Error Code: " + GetLastError());         
         continue;
      }
      
      c++;
      if(c >= count && count != 0) break;
   }
}