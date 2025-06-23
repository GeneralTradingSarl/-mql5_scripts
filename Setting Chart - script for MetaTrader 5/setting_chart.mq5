//+------------------------------------------------------------------+
//|                                                Setting Chart.mq5 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property script_show_inputs

#include <Charts\Chart.mqh>


input ENUM_CHART_MODE  ChartMode=CHART_CANDLES;//Chart Mode

input char    ChartScale=3; // Chart Scale

input bool    ChartShowAskLine= true; //Show Ask Line
input color   ChartColorAsk = clrRed; //Ask Color
input color   ChartColorBid= clrCyan; //Bid Color


input bool    ChartScaleFix = true; //Scale Fix
input bool    ChartShowGrid = false;//Show Grid
input bool    ChartShift=true;//Chart Shift
input bool    ChartAutoScroll = true;//Auto Scroll
input bool    ChartShowOHLC = false; //Show OHLC
input bool    ChartShowPeriodSep=true;//Show Period Separator
input bool    ChartForeground=true;//Foreground

long  currChart;
long  prevChart=ChartFirst();

int i=0,limit=100;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//--- variables for chart ID

   while(i<limit)// We have certainly not more than 100 open charts
     {
      ChartSetInteger(prevChart,CHART_FOREGROUND,ChartForeground);
      ChartSetInteger(prevChart,CHART_SHIFT,ChartShift);
      ChartSetInteger(prevChart,CHART_AUTOSCROLL,ChartAutoScroll);
      ChartSetInteger(prevChart,CHART_SCALEFIX,ChartScaleFix);
      ChartSetInteger(prevChart,CHART_SCALE,ChartScale);
      ChartSetInteger(prevChart,CHART_SHOW_ASK_LINE,ChartShowAskLine);
      ChartSetInteger(prevChart,CHART_COLOR_ASK,ChartColorAsk);
      ChartSetInteger(prevChart,CHART_COLOR_BID,ChartColorBid);
      ChartSetInteger(prevChart,CHART_SHOW_PERIOD_SEP,ChartShowPeriodSep);
      ChartSetInteger(prevChart,CHART_SHOW_GRID,ChartShowGrid);
      ChartSetInteger(prevChart,CHART_SHOW_OHLC,ChartShowOHLC);
      ChartSetInteger(prevChart,CHART_MODE,ChartMode);

      //==========================================================================
      currChart=ChartNext(prevChart); // Get the new chart ID by using the previous chart ID
      if(currChart<0) break;          // Have reached the end of the chart list

      prevChart=currChart;// let's save the current chart ID for the ChartNext()
      i++;// Do not forget to increase the counter
     }
   return;
//---
  }
//+------------------------------------------------------------------+
