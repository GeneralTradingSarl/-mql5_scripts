//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                   TestScript.mq5 |
//|                                                  KiteBoarder Pro |
//|                                                       nolinkHere |
//+------------------------------------------------------------------+
#property copyright "KiteBoarder Pro"
#property link      "nolinkHere"
#property version   "1.00"
#property strict
#property script_show_inputs

input double MinROI=0;                          //Minimum acceptable ROI
input double MaxDrawDown=10;                    //Max Acceptable DrawDown 
input double MinGain=50;                        //Min Acceptable Gain
input double MaxPrice=50;                       //Max Acceptable Price
input datetime StartedBefore="2019.01.01";      //Signals Started on or before
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//--- get total amount of signals in the terminal
   int total=SignalBaseTotal();
   PrintFormat("Searching %i Signals for the specified parameters.", total);
   int count=0;

//--- process all signals, one by one, to seek what User wants
   for(int i=0; i<total; i++)
     {
      //--- select the signal by index
      if(SignalBaseSelect(i))
        {
         //--- get signal properties
         long   id    =SignalBaseGetInteger(SIGNAL_BASE_ID);          // signal id
         long   pips  =SignalBaseGetInteger(SIGNAL_BASE_PIPS);        // profit in pips
         long   subscr=SignalBaseGetInteger(SIGNAL_BASE_SUBSCRIBERS); // number of subscribers
         string name  =SignalBaseGetString(SIGNAL_BASE_NAME);         // signal name
         double price =SignalBaseGetDouble(SIGNAL_BASE_PRICE);        // signal price
         string curr  =SignalBaseGetString(SIGNAL_BASE_CURRENCY);     // signal currency
         double dd    =SignalBaseGetDouble(SIGNAL_BASE_MAX_DRAWDOWN);  // DrawDown
         double roi  = SignalBaseGetDouble(SIGNAL_BASE_ROI);
         double gain  =SignalBaseGetDouble(SIGNAL_BASE_GAIN);
         datetime   DatePublished=SignalBaseGetInteger(SIGNAL_BASE_DATE_PUBLISHED);
         datetime   DateStarted =SignalBaseGetInteger(SIGNAL_BASE_DATE_STARTED);
         long  rating= SignalBaseGetInteger(SIGNAL_BASE_RATING);
         int Leverage = SignalBaseGetInteger(SIGNAL_BASE_LEVERAGE);
         int Rating = SignalBaseGetInteger(SIGNAL_BASE_RATING);
         int TradeMode = SignalBaseGetInteger(SIGNAL_BASE_TRADE_MODE);

         double equitylimit=SignalInfoGetDouble(SIGNAL_INFO_EQUITY_LIMIT);
         //--- print ONLY screened Signals
         if((price<=MaxPrice)&&(curr=="USD")&&(roi>=MinROI)&&(dd<=MaxDrawDown) && (gain>=MinGain) && (DateStarted<=StartedBefore))
           {
            count=count+1;
            Print(count+" Gain="+gain+" roi="+roi+" subs="+subscr+" dd="+dd+" Started "+TimeToString(DateStarted,TIME_DATE)+" - id="+id+" name="+name);
           }
        }
      else
         PrintFormat("Error in call of SignalBaseSelect. Error code=%d",GetLastError());
     }


  }
//+------------------------------------------------------------------+
