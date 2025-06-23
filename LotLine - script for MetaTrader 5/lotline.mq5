//+------------------------------------------------------------------+
//|                                                      LotLine.mq5 |
//|                                       Copyright 2015,Viktor Moss |
//|                           https://login.mql5.com/ru/users/vicmos |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015,Viktor Moss"
#property link      "https://login.mql5.com/ru/users/vicmos"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   double line,lot=0;
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   if(PositionSelect(_Symbol))
     {
      if(PositionGetDouble(POSITION_PRICE_OPEN)<bid)
         line=(bid+PositionGetDouble(POSITION_PRICE_OPEN))/2;
      else
         line=(ask+PositionGetDouble(POSITION_PRICE_OPEN))/2;
     }
   else
     {
      line=(ChartGetDouble(0,CHART_PRICE_MAX)+ChartGetDouble(0,CHART_PRICE_MIN))/2;
     }
   if(ObjectFind(0,"LotLine")<0)
     {
      ObjectCreate(0,"LotLine",OBJ_HLINE,0,0,line);
      ObjectSetInteger(0,"LotLine",OBJPROP_SELECTABLE,true);
      ObjectSetInteger(0,"LotLine",OBJPROP_COLOR,clrYellowGreen);
     }
   ObjectSetDouble(0,"LotLine",OBJPROP_PRICE,line);
   ObjectSetInteger(0,"LotLine",OBJPROP_SELECTED,true);
//--- Loop 
   while(!IsStopped())
     {
      line=ObjectGetDouble(0,"LotLine",OBJPROP_PRICE);
      SetText("LotLine1","Line  "+DoubleToString(line,_Digits),130,65);
      if(PositionSelect(_Symbol))
        {
         bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
         ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         long pt=PositionGetInteger(POSITION_TYPE);
         double cur=pt==POSITION_TYPE_BUY?ask:bid;
         double pr_open=PositionGetDouble(POSITION_PRICE_OPEN);
         double lt=PositionGetDouble(POSITION_VOLUME);

         if(line-cur!=0)lot=(pr_open-line)/(line-cur)*lt;
         lot=lot<0?0:lot;
        }
      else
        {
         lot=0;
        }
      //---
      SetText("LotLine2","Lot    "+DoubleToString(lot,4),130,45);
      ChartRedraw();
      Sleep(50);
     }
//--- End loop
   ObjectDelete(0,"LotLine1");
   ObjectDelete(0,"LotLine2");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetText(string name,string text,int x,int y,color col=clrYellow,int r=11,long chid=0)
  {
   if(ObjectFind(chid,name)<0)
     {
      ObjectCreate(chid,name,OBJ_LABEL,0/*ChartWindowFind()*/,0,0);
      ObjectSetInteger(chid,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
     }
   ObjectSetInteger(chid,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chid,name,OBJPROP_YDISTANCE,y);
   ObjectSetString(chid,name,OBJPROP_TEXT,text);
   ObjectSetInteger(chid,name,OBJPROP_COLOR,col);
   ObjectSetInteger(chid,name,OBJPROP_FONTSIZE,r);
  }
//+------------------------------------------------------------------+
