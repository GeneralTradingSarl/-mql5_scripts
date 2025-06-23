//+------------------------------------------------------------------+
//|                                        Market_Watch_Launcher.mq5 |
//+------------------------------------------------------------------+
//| This file is free software; you can redistribute it and/or       |
//| modify it under the terms of the GNU General Public License as   |
//| published by the Free Software Foundation (www.fsf.org); either  |
//| version 2 of the License, or (at your option) any later version. |
//|                                                                  |
//| This program is distributed in the hope that it will be useful,  |
//| but WITHOUT ANY WARRANTY; without even the implied warranty of   |
//| MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the     |
//| GNU General Public License for more details.                     |
//+------------------------------------------------------------------+
#property script_show_inputs
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#property description " This script opens all market watch symbols with the default template"
#property  description "using the selected period. Save prefferred template as default.tpl to have all"
#property description " charts open with same template of your choice. Happy Trading."
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <Trade\SymbolInfo.mqh>
enum spread {
     up_to_10, // 10 or less
     up_to_20, // 20 or less
     up_to_30, // 30 or less
     up_to_40, // 40 or less
     up_to_50, //50 or less
     up_to_100,     // 100 or less
     all_values     // Full marketwatch
};
//---
input ENUM_TIMEFRAMES Time_frame = NULL;
input spread Max_spread         = all_values;
CSymbolInfo    m_symbol;
string Pair;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart() {
//    loop through market watch and open symbols fitting specifications
     for(int i = 0; i < SymbolsTotal(true); i++) {
          Pair = SymbolName(i, true);
          if(Pair == SymbolName(i, true)) {
               if(m_symbol.Name(Pair)) {
                    int spread_limit = maxSpread(Max_spread);
                    //---
                    if(spread_limit == -1)
                         ChartOpen(Pair, Time_frame);
                    else if(m_symbol.Spread() < spread_limit)
                         ChartOpen(Pair, Time_frame);
               }
          }
          if(i == 0) {
               ChartClose(0);
          }
     }
//---     The task was completed successfully.
//---     Close the script and print some info for the user
     Print("Task Complete. Closing...");
     return;
}
//+------------------------------------------------------------------+
//|               process user input              n                  |
//+------------------------------------------------------------------+
const int maxSpread(spread value) {
     int result;
     switch(value) {
     case  up_to_10:
          result = 10;
          break;
     case up_to_20:
          result = 20;
          break;
     case up_to_30:
          result = 30;
          break;
     case up_to_40:
          result = 40;
          break;
     case up_to_50:
          result = 50;
          break;
     case up_to_100:
          result = 100;
          break;
     default:
          result = -1;
          break;
     }
//--- return value
     return result;
}
//+------------------------------------------------------------------+
