//+------------------------------------------------------------------+
//|                                           Forex Colored Sessions |
//|                                          Last update: 25.06.2020 |
//|                                    Copyright 2020, M&N Investing |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2020, M&N Investing"
#property version     "1.01"
#property description "Highlight Forex sessions with colored rectangles."
#property description "Won't work for timeframes greater than H3."
#property script_show_inputs

// Opening session hours (h)
input group "Sessions opening hours"
input int openSydney = 18, openTokyo = 21, openLondon = 4, openNewYork = 9;

// Session durations (h)
input group "Sessions duration"
input int lastSydney = 9, lastTokyo = 9, lastLondon = 8, lastNewYork = 9;

// Session colors
input group "Rectangle colors"
input color clrSydney = clrLemonChiffon, clrTokyo = clrLavender,
   clrLondon = clrLinen, clrNewYork = clrAliceBlue;

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
int OnStart()
{
   ResetLastError();
   
   // Inputs verification
   ENUM_TIMEFRAMES chartPeriod = Period();
   if((int)chartPeriod > 30 && (int)chartPeriod != PERIOD_H1)
   {
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   // Initialization
   ObjectsDeleteAll(0,-1,-1);      // Clear objects from chart
   int numBars = Bars(Symbol(),0); // Number of bars in the chart
   
   // MqlRates
   MqlRates rates[];                         // History of trades
   ArraySetAsSeries(rates,true);             // rates[0] newest
   if(CopyRates(NULL,0,0,numBars,rates) < 0) // Get rates data
   {
      Alert("Error @CopyRates! ",GetLastError());    
   }
   
   // Closing times
   int closeSydney = GetClosingTime(openSydney,lastSydney);
   int closeTokyo = GetClosingTime(openTokyo,lastTokyo);
   int closeLondon = GetClosingTime(openLondon,lastLondon);
   int closeNewYork = GetClosingTime(openNewYork,lastNewYork);
   
   // Rectangles index
   int iSSydney = -1, iFSydney = -1;
   int iSTokyo = -1, iFTokyo = -1;
   int iSLondon = -1, iFLondon = -1;
   int iSNewYork = -1, iFNewYork = -1;
   
   // Sessions identification loop
   MqlDateTime ratesDateTime, prevDateTime; // rates dateTime structures
   
   for(int iRates = numBars - 2; iRates >= 0; iRates--) // From past to present
   {
      TimeToStruct(rates[iRates+1].time, prevDateTime);
      TimeToStruct(rates[iRates].time, ratesDateTime);
      
      //-- Identify sessions borders
      
      // Sydney
      if(ratesDateTime.hour == openSydney && prevDateTime.hour != openSydney)
      {
         iSSydney = iRates;
      }
      else if(ratesDateTime.hour == closeSydney && prevDateTime.hour != closeSydney)
      {
         iFSydney = iRates;
         if(iSSydney >= 0) // Complete window
         {
            CreateColoredRectangle(rates,iSSydney,iFSydney,clrSydney);
         }
      }
      
      // Tokyo
      if(ratesDateTime.hour == openTokyo && prevDateTime.hour != openTokyo)
      {
         iSTokyo = iRates;
      }
      else if(ratesDateTime.hour == closeTokyo && prevDateTime.hour != closeTokyo)
      {
         iFTokyo = iRates;
         if(iSTokyo >= 0) // Complete window
         {
            CreateColoredRectangle(rates,iSTokyo,iFTokyo,clrTokyo);
         }
      }
      
      // London
      if(ratesDateTime.hour == openLondon && prevDateTime.hour != openLondon)
      {
         iSLondon = iRates;
      }
      else if(ratesDateTime.hour == closeLondon && prevDateTime.hour != closeLondon)
      {
         iFLondon = iRates;
         if(iSLondon >= 0) // Complete window
         {
            CreateColoredRectangle(rates,iSLondon,iFLondon,clrLondon);
         }
      }
      
      // New York
      if(ratesDateTime.hour == openNewYork && prevDateTime.hour != openNewYork)
      {
         iSNewYork = iRates;
      }
      else if(ratesDateTime.hour == closeNewYork && prevDateTime.hour != closeNewYork)
      {
         iFNewYork = iRates;
         if(iSNewYork >= 0) // Complete window
         {
            CreateColoredRectangle(rates,iSNewYork,iFNewYork,clrNewYork);
         }
      }
   }
   return 0; // Success
}

void CreateColoredRectangle(MqlRates &mqlRates[],int iInitial,int iFinal,color clrSession)
{
   // Get minimum and maximum values
   double highRates[], lowRates[];
   CopyHigh(Symbol(),0,iFinal,iInitial-iFinal,highRates);
   CopyLow(Symbol(),0,iFinal,iInitial-iFinal,lowRates);
   
   int maxIndex = ArrayMaximum(highRates,0,WHOLE_ARRAY);
   int minIndex = ArrayMinimum(lowRates,0,WHOLE_ARRAY);
   
   if(maxIndex >= 0 && minIndex >= 0)
   {
      double maxValue = highRates[maxIndex];
      double minValue = lowRates[minIndex];  
      
      string name = IntegerToString(iInitial,0,' ');
      
      // Create rectangle
      if(!ObjectCreate(0,name,OBJ_RECTANGLE,0,mqlRates[iInitial].time,
         minValue,mqlRates[iFinal].time,maxValue))
      {
         Print("Error");
      }
         
      ObjectSetInteger(0,name,OBJPROP_COLOR,clrSession); // Color
      ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID); // Lines
      ObjectSetInteger(0,name,OBJPROP_WIDTH,1); // Lines width
      ObjectSetInteger(0,name,OBJPROP_FILL,true); // Fill
      ObjectSetInteger(0,name,OBJPROP_BACK,true); // To background
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true); // Highlighting
      ObjectSetInteger(0,name,OBJPROP_SELECTED,false); // Moving
      ObjectSetInteger(0,name,OBJPROP_HIDDEN,true); // Show name in list
      ObjectSetInteger(0,name,OBJPROP_ZORDER,0); // Mouse click order
   }
}

int GetClosingTime(int opening, int duration)
{
   int closeTime = opening + duration;
   if(closeTime > 23)
   {
      closeTime -= 24; 
   }
   return closeTime;
}