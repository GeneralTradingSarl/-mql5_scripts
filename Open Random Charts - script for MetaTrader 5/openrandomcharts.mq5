#property script_show_inputs  true

input ENUM_TIMEFRAMES timeFrame = PERIOD_MN1; //Timeframe
input string tplName = "B01.tpl"; //Template
input int ptsSpread = 50; //Spread Filter
input int numCharts = 10; //Chart Count

void OnStart()
{
   int i, j, k, symSpread, Charts[];
   long chartID;
   string symName = "", symPath[];
   
   if(numCharts > SymbolsTotal(false) || numCharts <= 0)
   {
      Alert("ERROR: invalid chart count.");
      return;
   }
   
   ArrayResize(Charts, numCharts);
   ZeroMemory(Charts);
   
   i = 0;
   k = 0;
   while(i < numCharts)
   {
      //random index from symbol pool
      MathSrand(GetTickCount());
      Charts[i] = MathRand() % SymbolsTotal(false);
      symName = SymbolName(Charts[i], false);
      
      //only tradeable instruments
      if(SymbolInfoInteger(symName, SYMBOL_TRADE_MODE) == SYMBOL_TRADE_MODE_DISABLED) continue;      
      
      //only forex instruments
      StringSplit(SymbolInfoString(symName, SYMBOL_PATH), '\\', symPath);
      if(symPath[0] != "Forex") continue;
      
      //must show on marketwatch for processing
      if(SymbolInfoInteger(symName, SYMBOL_SELECT) == false) SymbolSelect(symName, true);
      Sleep(100);
      
      //wait for refresh after selection
      j = 0; //time-out limitor     
      while(SymbolInfoDouble(symName, SYMBOL_ASK) == 0)
      {
         Sleep(100);
         j++;
         if(j == 50) break;
      }
      if(j == 50) continue;
      
      //unselect and try again if spread is above specified
      symSpread = SymbolInfoInteger(symName, SYMBOL_SPREAD);      
      if(symSpread > ptsSpread)
      {
         SymbolSelect(symName, false);
         Sleep(100);
         continue;
      }      
      i++;
   }   
   
   ArraySort(Charts);
   for(i = 0; i < ArraySize(Charts); i++)
   {
      //randomization may select same symbol again
      //so don't open same chart.
      if(i > 0 && Charts[i] == Charts[i-1]) continue;
      
      symName = SymbolName(Charts[i], false);
      chartID = ChartOpen(symName, timeFrame);
      ChartApplyTemplate(chartID, "//Profiles//Templates//" + tplName);
      ChartSetInteger(chartID, CHART_SHIFT, 0, true);
   }
}