//+------------------------------------------------------------------+
//|                                                 PivotsPoints.mq5 |
//|                                    Copyright 2020, Mario Gharib. |
//|                                         mario.gharib@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Mario Gharib. mario.gharib@hotmail.com"
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Candlestick.mqh>

string sArrowBuy1 = "";
string sArrowBuy2 = "";
string sArrowSell1 = "";
string sArrowSell2 = "";

datetime dtBarTimeZ = 0;

cCandlestick cCS0, cCS1, cCS2, cCS3, cCS4, cCS5, cCS6, cCS7, cCS8;

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart() {

   for(int z=2;z<=1000;z++) {
   
      sArrowBuy1 = "";
      sArrowBuy2 = "";
      sArrowSell1 = "";
      sArrowSell2 = "";

      // OHLC, Characteristics and type of Candles

      cCS0.mvGetCandleStickCharateristics(_Symbol,z);
      cCS1.mvGetCandleStickCharateristics(_Symbol,z-1);
      cCS2.mvGetCandleStickCharateristics(_Symbol,z-2);
      cCS3.mvGetCandleStickCharateristics(_Symbol,z-3);
      cCS4.mvGetCandleStickCharateristics(_Symbol,z-4);
      cCS5.mvGetCandleStickCharateristics(_Symbol,z+1);
      cCS6.mvGetCandleStickCharateristics(_Symbol,z+2);
      cCS7.mvGetCandleStickCharateristics(_Symbol,z+3);
      cCS8.mvGetCandleStickCharateristics(_Symbol,z+4);
            
      dtBarTimeZ = iTimeMQL4(NULL,PERIOD_CURRENT,z);  // Return the datetime of the z bar of the current symbol on the current timeframe

      if (cCS0.dHighPrice>cCS1.dHighPrice && cCS0.dHighPrice>cCS2.dHighPrice &&
          cCS0.dHighPrice>cCS3.dHighPrice && cCS0.dHighPrice>cCS4.dHighPrice &&
          cCS0.dHighPrice>cCS5.dHighPrice && cCS0.dHighPrice>cCS6.dHighPrice &&
          cCS0.dHighPrice>cCS7.dHighPrice && cCS0.dHighPrice>cCS8.dHighPrice) {
      
         StringConcatenate(sArrowSell1,"sArrowSell1",string(dtBarTimeZ));
         ObjectCreate(0,sArrowSell1,OBJ_ARROW_SELL,0,dtBarTimeZ,cCS0.dHighPrice);
         
      } else if (cCS0.dLowPrice<cCS1.dLowPrice && cCS0.dLowPrice<cCS2.dLowPrice &&
                 cCS0.dLowPrice<cCS3.dLowPrice && cCS0.dLowPrice<cCS4.dLowPrice &&
                 cCS0.dLowPrice<cCS5.dLowPrice && cCS0.dLowPrice<cCS6.dLowPrice &&
                 cCS0.dLowPrice<cCS7.dLowPrice && cCS0.dLowPrice<cCS8.dLowPrice) {
      
         StringConcatenate(sArrowBuy1,"sArrowBuy1",string(dtBarTimeZ));
         ObjectCreate(0,sArrowBuy1,OBJ_ARROW_BUY,0,dtBarTimeZ,cCS0.dLowPrice);
      
      }
   }
}