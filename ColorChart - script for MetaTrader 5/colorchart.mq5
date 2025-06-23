//+------------------------------------------------------------------+
//|                                                   ColorChart.mq5 |
//|                                                       OpenSource |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "OpenSource"
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   RandomColor rndColor;
   ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,rndColor.GetColor());
   ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,rndColor.GetColor());
   ChartSetInteger(0,CHART_COLOR_BACKGROUND,rndColor.GetColor());
   ChartSetInteger(0,CHART_COLOR_ASK,rndColor.GetColor());
   ChartSetInteger(0,CHART_COLOR_BID,rndColor.GetColor());
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN,rndColor.GetColor());
   ChartSetInteger(0,CHART_COLOR_CHART_LINE,rndColor.GetColor());
   ChartSetInteger(0,CHART_COLOR_CHART_UP,rndColor.GetColor());
   ChartSetInteger(0,CHART_COLOR_FOREGROUND,rndColor.GetColor());
   ChartSetInteger(0,CHART_COLOR_GRID,rndColor.GetColor());
   ChartSetInteger(0,CHART_COLOR_LAST,rndColor.GetColor());
   ChartSetInteger(0,CHART_COLOR_STOP_LEVEL,rndColor.GetColor());
   ChartSetInteger(0,CHART_COLOR_VOLUME,rndColor.GetColor());
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Random
  {
public:
   int Rand(int from,int to)
     {
      long rnd=(long)this.Rand()*((long)to-(long)from)/(long)SHORT_MAX;
      return(int)rnd;
     }
   int Rand()
     {
      return MathRand();
     }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class RandomColor : Random
  {
public:
   color GetColor()
     {
      int red=Rand(0x0000FFFF,0x00FF0000);
      int green= Rand(0x000000FF,0x0000FF00);
      int blue = Rand(0x00000000,0x000000FF);
      return(color)(red+green+blue);
     }
  };
//+------------------------------------------------------------------+
