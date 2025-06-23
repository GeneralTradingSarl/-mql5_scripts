//+------------------------------------------------------------------+
//|                                                ChartNavigate.mq5 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//--- get handle of the current chart
   long handle=ChartID();
   string comm="";
   if(handle>0) // if successful, configure it
     {
      //--- disable autoscroll
      ChartSetInteger(handle,CHART_AUTOSCROLL,false);
      //--- set chart shift
      ChartSetInteger(handle,CHART_SHIFT,true);
      //--- show as candles
      ChartSetInteger(handle,CHART_MODE,CHART_CANDLES);
      //--- show tick volumes
      ChartSetInteger(handle,CHART_SHOW_VOLUMES,CHART_VOLUME_TICK);

      //--- prepare text for Comment()
      comm="Let's scroll the chart 10 bars right from the beggining of the history)";
      //--- print comment
      Comment(comm);
      //--- scroll 10 bars right
      ChartNavigate(handle,CHART_BEGIN,10);
      //--- get first bar index (indexing as timeseries)
      long first_bar=ChartGetInteger(0,CHART_FIRST_VISIBLE_BAR,0);
      //--- add CR/LF
      comm=comm+"\r\n";
      //--- add to comment
      comm=comm+"First bar has index "+IntegerToString(first_bar)+"\r\n";
      //--- print comment
      Comment(comm);
      //--- wait 5 seconds to see how ChartNavigate works
      Sleep(5000);

      //--- add to comment
      comm=comm+"\r\n"+"Scroll 10 bars left (from the right border of the chart)";
      Comment(comm);
      //--- scroll 10 bars left
      ChartNavigate(handle,CHART_END,-10);
      //--- get first bar index (indexing as timeseries)
      first_bar=ChartGetInteger(0,CHART_FIRST_VISIBLE_BAR,0);
      comm=comm+"\r\n";
      comm=comm+"First bar has index "+IntegerToString(first_bar)+"\r\n";
      Comment(comm);
      //--- wait 5 seconds to see how ChartNavigate works
      Sleep(5000);

      //--- new scrolling
      comm=comm+"\r\n"+"Scroll 1000 bars right from the beggining of the history";
      Comment(comm);
      //--- scroll 1000 bars right
      ChartNavigate(handle,CHART_BEGIN,1000);
      first_bar=ChartGetInteger(0,CHART_FIRST_VISIBLE_BAR,0);
      comm=comm+"\r\n";
      comm=comm+"First bar has index "+IntegerToString(first_bar)+"\r\n";
      Comment(comm);
      //--- wait 5 seconds to see how ChartNavigate works
      Sleep(5000);

      //--- new demo
      comm=comm+"\r\n"+"Scroll 1000 bars left from the right border of the chart";
      Comment(comm);
      //--- scroll -100 bars left from the right border of the chart
      ChartNavigate(handle,CHART_END,-1000);
      first_bar=ChartGetInteger(0,CHART_FIRST_VISIBLE_BAR,0);
      comm=comm+"\r\n";
      comm=comm+"First bar has index "+IntegerToString(first_bar)+"\r\n";
      Comment(comm);
     }
  }
//+------------------------------------------------------------------+
