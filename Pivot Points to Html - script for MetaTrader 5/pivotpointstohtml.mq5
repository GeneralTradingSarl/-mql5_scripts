//+------------------------------------------------------------------+
//|                                             PivotPointToHtml.mq5 |
//|                                            Copyright 2012, Rone. |
//|                                            rone.sergey@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, Rone."
#property link      "rone.sergey@gmail.com"
#property version   "1.00"
#property script_show_inputs
//---
input string            InpFileName = "PivotPoints";  // File name
input ENUM_TIMEFRAMES   InpTimeFrame = PERIOD_W1;     // Time Frame for the calculation
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CSymPivot {
   public:
      string   name;
      double   close;
      double   high;
      double   low;
      int      digits;
      double   pivot;
      double   res1;
      double   sup1;
      double   res2;
      double   sup2;
      double   res3;
      double   sup3;
      
               CSymPivot();
              ~CSymPivot() {};
      void     setData(string sym, double initClose, double initHigh, double initLow, int initDigits);
      void     calculatePivot();          
};
//---
CSymPivot::CSymPivot(void) {
   name = "";
   close = high = low = 0.0;
   pivot = 0.0;
   res1 = res2 = res3 = 0.0;
   sup1 = sup2 = sup3 = 0.0;
}
//---
void CSymPivot::setData(string sym, double initClose,double initHigh,double initLow, int initDigits) {
   name = sym;
   digits = initDigits;
   close = initClose;
   high = initHigh;
   low = initLow;
}
//---
void CSymPivot::calculatePivot(void) {
   pivot = (high + low + close) / 3;
   res1 = 2 * pivot - low;
   sup1 = 2 * pivot - high;
   res2 = pivot + (res1 - sup1);
   sup2 = pivot - (res1 - sup1);
   res3 = high + 2 * (pivot - low);
   sup3 = low - 2 * (high - pivot);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string getCSS() {
//---
   string css;
   
   css = "<style type=\"text/css\">";
   css += "html, body { margin: 0; padding: 0; font-family: Arial, Helvetica, sans-serif; -webkit-print-color-adjust: exact; }";
   css += "body { width: 600px; margin: auto; }";
   css += "table { border: 2px solid #000; border-collapse: collapse; }";
   css += "th, td { border: 1px solid #000; text-align: center; margin: 0; padding: 4px; }";
   css += "th { border-bottom-width: 2px; }";
   css += "caption { margin: 5px; font-weight: bold; font-size: 120%; }";
   css += "table tr th { background: #3cc; }";
   css += "table tr.row0 { background: #fff; }";
   css += "table tr.row1 { background: #ccc; }";
   css += "</style>";
//---
   return(css);
}
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart() {
//---   
   int symTotal = SymbolsTotal(true);
   CSymPivot symPivot[];
   
   ArrayResize(symPivot, symTotal);
   
   for ( int i = symTotal - 1; i >= 0; i-- ) {
      string sym = SymbolName(i, true);
      int digits = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
      MqlRates rates[2];
      //---
      if ( CopyRates(sym, InpTimeFrame, 0, 2, rates) != 2 ) {
         Print("Symbol data copy error ", sym, ". Error #", GetLastError());
         return;
      }
      //---
      symPivot[i].setData(sym, rates[0].close, rates[0].high, rates[0].low, digits);
      symPivot[i].calculatePivot();
   }
   
   string content;
   datetime time[2];
   
   if ( CopyTime(symPivot[0].name, InpTimeFrame, 0, 2, time) != 2 ) {
      Print("Time copy error. Error #", GetLastError());
      return;
   }

   content = "<!DOCTYPE html><html>";
   content += "<head>";
   content += "<title>Pivot Points Table</title><meta charset=\"utf-8\">";
   content += getCSS();
   content += "</head>";   
   content += "<body>";
   content += "<table>";
   content += "<caption>Pivot Points (" + EnumToString(InpTimeFrame) + ", " + TimeToString(time[1]) + ")</caption>"; 
   content += "<tr><th>Symbol</th><th>Res 3</th><th>Res 2</th><th>Res 3</th>";
   content += "<th>Pivot</th><th>Sup 1</th><th>Sup 2</th><th>Sup 3</th></tr>";
   for ( int i = 0; i < symTotal; i++ ) {
      int row = i % 2;
      content += "<tr class=\"row"+(string)row+"\">";
      content += "<td>" + symPivot[i].name + "</td>";
      content += "<td>" + DoubleToString(symPivot[i].res3, symPivot[i].digits) + "</td>";
      content += "<td>" + DoubleToString(symPivot[i].res2, symPivot[i].digits) + "</td>";
      content += "<td>" + DoubleToString(symPivot[i].res1, symPivot[i].digits) + "</td>";
      content += "<td>" + DoubleToString(symPivot[i].pivot, symPivot[i].digits) + "</td>";
      content += "<td>" + DoubleToString(symPivot[i].sup1, symPivot[i].digits) + "</td>";
      content += "<td>" + DoubleToString(symPivot[i].sup2, symPivot[i].digits) + "</td>";
      content += "<td>" + DoubleToString(symPivot[i].sup3, symPivot[i].digits) + "</td>";
      content += "</tr>";
   }
   content += "</table></body></html>";
   //---
   int fileHandle = FileOpen(InpFileName+".html", FILE_WRITE|FILE_TXT|FILE_ANSI, ' ', CP_UTF8);
   if ( fileHandle < 0 ) {
      Print("File open failed, error ",GetLastError());
      return;
   }
   uint result = FileWrite(fileHandle, content);
   if ( result <= 0 ) {
      Print("File writing error. Error #", GetLastError());
   }
   FileClose(fileHandle);
//---   
}
//+------------------------------------------------------------------+
