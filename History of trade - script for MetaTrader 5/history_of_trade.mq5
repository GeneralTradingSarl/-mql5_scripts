//+------------------------------------------------------------------+
//|                                             History of trade.mq5 |
//|                                                     Yuriy Tokman |
//|                                         http://www.mql-design.ru |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman"
#property link      "http://www.mql-design.ru"
#property version   "1.00"
#property  description "The script adds deals history (using the graphic objects) on the chart"
#property description " "
#property description "www.mql-design.ru"
#property description " "
#property description "yuriytokman@gmail.com "
#property description " "
#property description "Skype - yuriy.g.t"
#property script_show_inputs
MqlTick last_tick;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   string nam;string txt;
   int i;int count = 0, coun2=0;
   ulong tic =0;ulong deal_ticket; 
   double volums = 0;double open_price;double p2;
   datetime open_time; datetime t2;
   long pos_id;
   color colir;
   ENUM_OBJECT type_obj = OBJ_ARROW;   
     
   HistorySelect(0,TimeCurrent());    
   int deals=HistoryDealsTotal();
   
   for(i=0;i<deals;i++)
    {
     tic        = HistoryDealGetTicket(i);
     volums     = HistoryDealGetDouble(tic,DEAL_VOLUME);
     open_time  = (datetime) HistoryDealGetInteger(tic,DEAL_TIME);
     open_price = HistoryDealGetDouble(tic,DEAL_PRICE);
     pos_id     = HistoryDealGetInteger(tic,DEAL_POSITION_ID);
     
     if(HistoryDealGetInteger(tic,DEAL_TYPE) == DEAL_TYPE_BUY ) {type_obj = OBJ_ARROW_BUY;txt = " BUY ";}
     else if(HistoryDealGetInteger(tic,DEAL_TYPE) == DEAL_TYPE_SELL ){ type_obj = OBJ_ARROW_SELL; txt = " SELL ";}
     //----
     nam = "pos "+DoubleToString(pos_id,0)+" "+txt; 
     ObjectCreate(0,nam,type_obj,0,open_time,open_price);
     nam = "   IN "+txt+" LOT = "+DoubleToString(volums,2);
     TxT(DoubleToString(tic,0),nam,open_time, open_price,DodgerBlue);
     //----
     if(SymbolInfoTick(Symbol(),last_tick))
      {
       p2=last_tick.bid;
       t2=last_tick.time;
      }
     //----
     if(HistoryDealGetInteger(tic,DEAL_ENTRY)==DEAL_ENTRY_IN)
      { 
       count++;
       for(int ii=0;ii<deals;ii++)
        {
         deal_ticket=HistoryDealGetTicket(ii);
         if( HistoryDealGetInteger(deal_ticket,DEAL_POSITION_ID) == pos_id && HistoryDealGetInteger(deal_ticket,DEAL_ENTRY) == DEAL_ENTRY_OUT )
          { 
            if(HistoryDealGetDouble(deal_ticket,DEAL_PROFIT)<0)colir = Red;
            else{colir = Green; coun2++;}
            p2 = HistoryDealGetDouble(deal_ticket,DEAL_PRICE);
            t2 = (datetime) HistoryDealGetInteger(deal_ticket,DEAL_TIME);  
            nam = "line "+DoubleToString(pos_id,0);
            ObjectCreate(0,nam,OBJ_TREND,0,open_time,open_price,t2,p2);
            ObjectSetInteger(0,nam,OBJPROP_WIDTH,2);
            ObjectSetInteger(0,nam,OBJPROP_COLOR,colir);
            nam = "   OUT "+"PROFIT = "+DoubleToString(HistoryDealGetDouble(deal_ticket,DEAL_PROFIT),1)+" $";            
            TxT(DoubleToString(deal_ticket,0),nam,t2, p2,colir);            
          }
        }     
      }
   }
   //----
   nam = "Total deals = "+DoubleToString(count,0);   
   OnSUM(20, nam);
   nam = "Profitable deals = "+DoubleToString(coun2,0);   
   OnSUM(40, nam);OnSUM(65, "yuriytokman@gmail.com");   
   //----   
  }
//+------------------------------------------------------------------+
void TxT(string tx, string txt, datetime t, double p, color c)
  {
   string label_name="Text "+tx;
   if(ObjectFind(0,label_name)<0)
     {
      Print("Object ",label_name," not found. Error code = ",GetLastError());
      ObjectCreate(0,label_name,OBJ_TEXT,0,0,0);           
      ObjectSetInteger(0,label_name,OBJPROP_TIME,t);
      ObjectSetDouble(0,label_name,OBJPROP_PRICE,p);
      ObjectSetInteger(0,label_name,OBJPROP_COLOR,c);
      ObjectSetString(0,label_name,OBJPROP_TEXT,txt);
      ObjectSetString(0,label_name,OBJPROP_FONT,"Arial");
      ObjectSetInteger(0,label_name,OBJPROP_FONTSIZE,10);
      ObjectSetDouble(0,label_name,OBJPROP_ANGLE,90);                                    
     }
  }
//+------------------------------------------------------------------+
void OnSUM(int x, string tx)
  {
   string label_name=tx;
   if(ObjectFind(0,label_name)<0)
     {
      Print("Object ",label_name," not found. Error code = ",GetLastError());
      ObjectCreate(0,label_name,OBJ_LABEL,0,0,0);           
      ObjectSetInteger(0,label_name,OBJPROP_XDISTANCE,20);
      ObjectSetInteger(0,label_name,OBJPROP_YDISTANCE,x);
      ObjectSetInteger(0,label_name,OBJPROP_COLOR,Blue);
      ObjectSetString(0,label_name,OBJPROP_TEXT,tx);
      ObjectSetString(0,label_name,OBJPROP_FONT,"Arial");
      ObjectSetInteger(0,label_name,OBJPROP_FONTSIZE,14);                                           
     }
  }