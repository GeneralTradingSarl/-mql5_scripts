//+------------------------------------------------------------------+
//|                                                   News VLine.mq5 |
//|                                            Copyright 2010, Urain |
//|                            https://login.mql5.com/ru/users/Urain |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, Urain"
#property link      "https://login.mql5.com/ru/users/Urain"
#property version   "1.00"
#property script_show_inputs
//---
input color           color_line=clrOrange;     // Цвет линий
input ENUM_LINE_STYLE style_line=STYLE_DASHDOT; // Стиль рисования линий
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   long chid=ChartID();
   int total=ObjectsTotal(chid,0,OBJ_EVENT);
   for(int i=0;i<total;i++)
      ObjectNews(chid,i,ObjectName(chid,i,0,OBJ_EVENT));
  }
//+------------------------------------------------------------------+
//| ObjectNews                                                       |
//+------------------------------------------------------------------+
void ObjectNews(long chid,int num,string tool)
  {
   datetime time=StringToTime(tool);
   string name="news"+(num>99?(string)num:num>9?"0"+(string)num:"00"+(string)num);
   if(ObjectFind(chid,name)<0)
      ObjectCreate(chid,name,OBJ_VLINE,0,time,0);
   ObjectSetString(chid,name,OBJPROP_TOOLTIP,tool);
   ObjectSetInteger(chid,name,OBJPROP_COLOR,color_line);
   ObjectSetInteger(chid,name,OBJPROP_STYLE,style_line);
   ObjectSetInteger(chid,name,OBJPROP_BACK,true);
   ObjectSetInteger(chid,name,OBJPROP_SELECTED,false);
  }
//+------------------------------------------------------------------+
