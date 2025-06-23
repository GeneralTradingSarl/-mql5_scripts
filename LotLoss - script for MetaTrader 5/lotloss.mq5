#property copyright           "Mokara"
#property link                "https://www.mql5.com/en/users/mokara"
#property description         "LotLoss"
#property version             "1.0"
#property script_show_inputs

input int vLoss = 50;   //Risk Money
input int pLoss = 500;  //Stop-Loss Points

void OnStart()
{   
   double pValue = SymbolInfoDouble(NULL, SYMBOL_TRADE_TICK_VALUE_PROFIT);
   double Lots = vLoss / (pLoss * pValue);
   
   if(Lots < 0.01)
   {
      Print("Error: under micro lots.");
      return;
   }
   
   string Message = "Point Value: " + DoubleToString(pValue, 2) + "\n" +
                    "Point: " + DoubleToString(_Point, _Digits) + "\n" +
                    "Lots: " + DoubleToString(Lots, 2);
   
   MessageBox(Message, "LotLoss v1.0", MB_ICONINFORMATION|MB_OK);
}