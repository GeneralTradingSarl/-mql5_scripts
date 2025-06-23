//+------------------------------------------------------------------+
//|                                Demo_Create_OBJ_BITMAP_Script.mq5 |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property script_show_inputs
//--- input parameters
input string   picture_filename="\\Images\\mql5_logo.bmp";
//--- object name
string bitmap_name="Demo_Bitmap";        // OBJ_BITMAP object name
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//--- create the object of OBJ_BITMAP type, if not found
   if(ObjectFind(0,bitmap_name)<0)
     {
      double high_price=ChartGetDouble(0,CHART_PRICE_MAX);
      double low_price=ChartGetDouble(0,CHART_PRICE_MIN);
      long first_bar=ChartGetInteger(0,CHART_FIRST_VISIBLE_BAR);
      datetime time[];
      int copied=CopyTime(_Symbol,PERIOD_CURRENT,0,(int)first_bar+1,time);
      if(copied<0)
        {
         PrintFormat("Error in CopyTime call. Error code %d",GetLastError());
         return;
        }
      else
        {
        ArraySetAsSeries(time,true);
        }
      double price=high_price-(high_price-low_price)*0.1;
      //--- try to create an object of OBJ_BITMAP type
      bool created=ObjectCreate(0,bitmap_name,OBJ_BITMAP,0,time[(int)first_bar],price);
      if(created)
        {
         ResetLastError();
         //--- load image from the specified file
         bool set=ObjectSetString(0,bitmap_name,OBJPROP_BMPFILE,0,picture_filename);
         //--- check result
         if(!set)
           {
            PrintFormat("Error loading image from file %s. Error code %d",picture_filename,GetLastError());
           }
         ResetLastError();
         //--- redraw the chart to draw the button immediately
         ChartRedraw(0);
        }
      else
        {
         //--- error in object creation, print it
         PrintFormat("Error creating the object of OBJ_BITMAP type. Error code %d",GetLastError());
        }
     }
   Sleep(10000);

  }
//+------------------------------------------------------------------+