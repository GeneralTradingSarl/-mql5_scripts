//+------------------------------------------------------------------+
//|                                            Demo_BitmapOffset.mq5 |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#define X_left_top      50
#define Y_left_top      50
#define show_frame_time 20

#resource "\\Files\\thousands_rubies_galaxy.bmp";
#resource "\\Files\\space_wind.wav";
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//--- file name with photo of "M85 Lenticular Galaxy"
   string image_resource="::Files\\thousands_rubies_galaxy.bmp";
   string bitmap_label="bitmap";
//--- create object
   ObjectCreate(0,bitmap_label,OBJ_BITMAP_LABEL,0,0,0,0,0);
//--- set coordinates of the left upper corner
   ObjectSetInteger(0,bitmap_label,OBJPROP_XDISTANCE,X_left_top);
   ObjectSetInteger(0,bitmap_label,OBJPROP_YDISTANCE,Y_left_top);

//--- load image from the resource
   bool set=ObjectSetString(0,bitmap_label,OBJPROP_BMPFILE,0,image_resource);
//--- report if failed
   if(!set)
     {
      PrintFormat("Error in loading of image from file %s. Error %d",
                  image_resource,
                  GetLastError());
     }
//--- get image size (it's needed when specifying the visible area of the image)
   long x_size=ObjectGetInteger(0,bitmap_label,OBJPROP_XSIZE);
   long y_size=ObjectGetInteger(0,bitmap_label,OBJPROP_YSIZE);
   PrintFormat("Loaded an image with size %d x %d pixels",
               x_size,
               y_size);
//--- chart redraw
   ChartRedraw();
//--- 1 second pause to see the whole image
   Sleep(1000);
//--- set frame size to show a fragment of the image
   ObjectSetInteger(0,bitmap_label,OBJPROP_XSIZE,x_size);
//--- calculate the vertical size of the visible (as 1/3 of the image height)
   long visual_y_size=y_size/3;
//--- set visible height 
   ObjectSetInteger(0,bitmap_label,OBJPROP_YSIZE,visual_y_size);
//--- set the vertical frame shift inside the image
   ObjectSetInteger(0,bitmap_label,OBJPROP_XOFFSET,0);
//--- set as backround
   ObjectSetInteger(0,bitmap_label,OBJPROP_BACK,true);
//--- play sound
   PlaySound("::Files\\space_wind.wav");
//--- begin
   for(int j=0;j<5 && !_StopFlag;j++)
     {
      int i; // used for a shift of the visible area relative to the upper left corner of the image
      //--- go down
      for(i=0;i<y_size-visual_y_size;i++)
        {
         ObjectSetInteger(0,bitmap_label,OBJPROP_YDISTANCE,Y_left_top+i);
         //--- the the vertical frame shift inside the image (Y)
         ObjectSetInteger(0,bitmap_label,OBJPROP_YOFFSET,i);
         ChartRedraw();
         //--- маленькая пауза перед следующим кадром
         Sleep(show_frame_time);
        }
      //--- go up
      for(;i>=0;i--)
        {
         ObjectSetInteger(0,bitmap_label,OBJPROP_YDISTANCE,Y_left_top+i);
         //--- set the vertical frame shift inside the image
         ObjectSetInteger(0,bitmap_label,OBJPROP_YOFFSET,i);
         ChartRedraw();
         //--- small pause before the next frame
         Sleep(show_frame_time);
        }
     }
   //--- final show of the last frame
   Sleep(3000);
   //--- delete object
   ObjectDelete(0,bitmap_label);
  }
//+------------------------------------------------------------------+
