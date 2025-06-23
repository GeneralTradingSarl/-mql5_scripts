#property copyright           "Mokara"
#property link                "https://www.mql5.com/en/users/mokara"
#property description         "ComeBacker Trading"
#property version             "1.0"
#property script_show_inputs  true

input int lastBars = 20; //Bar Count for Limits
input double ratePL = 2.0; //Profit/Loss Ratio
input int profitOffset = 0; //Additional Profit
input double lots = 0.1; //Lots

int bHighest, bLowest;
double pHighest, pLowest, pCurrent, pTakeProfit, pStopLoss;
string objName = "";
MqlRates Rates[];
MqlTradeRequest tReq = {0};
MqlTradeResult tRes = {0};

enum TYPE_POS{
   POS_LONG,
   POS_SHORT
}tPos;

void DrawVLine(string n, int c, int s, datetime x){ //name, color, style, x-coordinate
   if(ObjectFind(0, n) == 0) ObjectDelete(0, n);
   ObjectCreate(0, n, OBJ_VLINE, 0, x, 0);
   ObjectSetInteger(0, n, OBJPROP_COLOR, c);
   ObjectSetInteger(0, n, OBJPROP_STYLE, s);
}

void DrawHLine(string n, int c, int s, double y){ //name, color, style, y-coordinate
   if(ObjectFind(0, n) == 0) ObjectDelete(0, n);
   ObjectCreate(0, n, OBJ_HLINE, 0, 0, y);
   ObjectSetInteger(0, n, OBJPROP_COLOR, c);
   ObjectSetInteger(0, n, OBJPROP_STYLE, s);
}

void OnStart(){
   ArraySetAsSeries(Rates, true);
   ArrayResize(Rates, lastBars);
   CopyRates(_Symbol, _Period, 0, lastBars, Rates);
   bHighest = iHighest(_Symbol, _Period, MODE_HIGH, lastBars, 0);
   bLowest = iLowest(_Symbol, _Period, MODE_LOW, lastBars, 0);
   pHighest = NormalizeDouble(Rates[bHighest].high, _Digits);
   pLowest = NormalizeDouble(Rates[bLowest].low, _Digits);
   if(bHighest < bLowest){ //highest occured last
      tPos = POS_LONG;
      pCurrent = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      pTakeProfit = pHighest + profitOffset * _Point;
      pStopLoss = pCurrent - (pTakeProfit - pCurrent) / ratePL;
      DrawVLine("ComeBacker - Start", clrAqua, STYLE_DOT, Rates[bHighest].time);
      DrawHLine("ComeBacker - Entry", clrAqua, STYLE_DOT, pCurrent);
      DrawHLine("ComeBacker - Take Profit", clrLimeGreen, STYLE_SOLID, pTakeProfit);
      DrawHLine("ComeBacker - Stop Loss", clrRed, STYLE_SOLID, pStopLoss);
      tReq.symbol = _Symbol;
      tReq.type = ORDER_TYPE_BUY;
      tReq.volume = lots;
      tReq.action = TRADE_ACTION_DEAL;
      tReq.deviation = 5;
      tReq.magic = 999;
      tReq.price = SymbolInfoDouble(_Symbol, SYMBOL_ASK); 
      tReq.tp = pTakeProfit;
      tReq.sl = pStopLoss;
      if(!OrderSend(tReq, tRes)){
         Print("ERROR: order send. "+ _Symbol  + " / " + IntegerToString(GetLastError()));
         return;
      }
   }
   else{ //lowest occcured last or highest/lowest on same bar
      tPos = POS_SHORT;
      pCurrent = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      pTakeProfit = pLowest - profitOffset * _Point;;
      pStopLoss = pCurrent + (pCurrent - pTakeProfit) / ratePL;
      DrawVLine("ComeBacker - Start", clrAqua, STYLE_DOT, Rates[bLowest].time);
      DrawHLine("ComeBacker - Entry", clrAqua, STYLE_DOT, pCurrent);
      DrawHLine("ComeBacker - Take Profit", clrLimeGreen, STYLE_SOLID, pTakeProfit);
      DrawHLine("ComeBacker - Stop Loss", clrRed, STYLE_SOLID, pStopLoss);
      tReq.symbol = _Symbol;
      tReq.type = ORDER_TYPE_SELL;
      tReq.volume = lots;
      tReq.action = TRADE_ACTION_DEAL;
      tReq.deviation = 5;
      tReq.magic = 999;
      tReq.price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      tReq.tp = pTakeProfit;
      tReq.sl = pStopLoss;
      if(!OrderSend(tReq, tRes)){
         Print("ERROR: order send. "+ _Symbol  + " / " + IntegerToString(GetLastError()));
         return;      
      }
   }
}