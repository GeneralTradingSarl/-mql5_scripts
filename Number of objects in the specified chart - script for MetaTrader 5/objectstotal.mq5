//+------------------------------------------------------------------+
//|                                                 ObjectsTotal.mq5 |
//|                              Copyright © 2015, Vladimir Karputov |
//|                                           http://wmua.ru/slesar/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2015, Vladimir Karputov"
#property link      "http://wmua.ru/slesar/"
#property version   "1.00"
#property description "Returns the number of objects of the specified type."
#property script_show_inputs
//--- input
input ENUM_OBJECT inpObject=OBJ_ARROW_THUMB_UP; // object type
input int         inpSub_Window=-1;             // window index ("-1" all subwindows)
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   int intCount=ObjectsTotal(0,inpSub_Window,inpObject);
   string count_windows="";
   if(inpSub_Window==-1)
      count_windows="all subwindows";
   else
      count_windows="subwindow ¹ "+IntegerToString(inpSub_Window);
   string text="In "+count_windows+" is "+IntegerToString(intCount)+" "+EnumToString(inpObject);
   Alert(text);
  }
//+------------------------------------------------------------------+
