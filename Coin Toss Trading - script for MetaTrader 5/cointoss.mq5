#property copyright           "Mokara"
#property link                "https://www.mql5.com/en/users/mokara"
#property description         "Coin Toss"
#property version             "1.0"
#property script_show_inputs  true

#define MAGIC 5050;

enum TYPE_TRADE
{
   TRADE_SELL = 0,
   TRADE_BUY = 1
};

input int Range = 500;     //Range in Pips
input double Lots = 0.01;  //Lots

void DrawHLine(string n, int c, int s, double y)
{
   if(ObjectFind(0, n) == 0) ObjectDelete(0, n);
   ObjectCreate(0, n, OBJ_HLINE, 0, 0, y);
   ObjectSetInteger(0, n, OBJPROP_COLOR, c);
   ObjectSetInteger(0, n, OBJPROP_STYLE, s);
}

void OnStart()
{
   MqlTradeRequest tReq = {0};
   MqlTradeResult tRes = {0};
   int tType = -1;   
   
   MathSrand(GetTickCount());
   tType = int(MathRand() % 2);
   
   ZeroMemory(tReq);
   tReq.symbol = _Symbol;
   tReq.volume = Lots;
   tReq.action = TRADE_ACTION_DEAL;
   tReq.deviation = 5;
   tReq.magic = MAGIC;
   
   switch(tType)
   {
      case TRADE_SELL: 
            tReq.type = ORDER_TYPE_SELL; 
            tReq.price = SymbolInfoDouble(_Symbol, SYMBOL_BID); 
            tReq.tp = tReq.price - NormalizeDouble(Range * _Point, _Digits);
            tReq.sl = tReq.price + NormalizeDouble(Range * _Point, _Digits);
            break;
      case TRADE_BUY: 
            tReq.type = ORDER_TYPE_BUY; 
            tReq.price = SymbolInfoDouble(_Symbol, SYMBOL_ASK); 
            tReq.tp = tReq.price + NormalizeDouble(Range * _Point, _Digits);
            tReq.sl = tReq.price - NormalizeDouble(Range * _Point, _Digits);
            break;
      default: Print("ERROR: order type. " + GetLastError()); return;
   }
   
   if(!OrderSend(tReq, tRes))
   {
      Print("ERROR: order send. " + GetLastError());
      Print(tReq.price);
      Print(tReq.tp);
      Print(tReq.sl);
      return;
   }
   
   DrawHLine("ENTRY", clrAqua, STYLE_DOT, tReq.price);
   DrawHLine("TP", clrLime, STYLE_SOLID, tReq.tp);
   DrawHLine("SL", clrRed, STYLE_SOLID, tReq.sl);  
}