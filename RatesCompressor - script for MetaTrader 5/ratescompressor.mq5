//+------------------------------------------------------------------+
//|                                              RatesCompressor.mq5 |
//|                                    Copyright (c) 2020, Marketeer |
//|                                        Modified by Dark Ryd3r    |
//|                                    https://twitter.com/DarkRyd3r |
//+------------------------------------------------------------------+

#include <RatesCompressor.mqh>

#define PRT(A) Print(#A, " ", (A))

void OnStart()
{
  PRT(sizeof(MqlRates));
  PRT(sizeof(MqlRatesOHLC));

  // 1-element arrays are used for pretty-printing via ArrayPrint
  
  MqlRates rates[1];
  int data = CopyRates(_Symbol,PERIOD_M1,0,1,rates); 
  ArrayPrint(rates);


    MqlRatesOHLC rohlc[1];
    RatesCompressor::compress(rates, rohlc); // array notation
    // other way for a single tick can be used as well
    // rohlc[0] = MqlRatesOHLC::compress(rates[0]);
    ArrayPrint(rohlc);
  
    MqlRates result[1];
    result[0] = MqlRatesOHLC::decompress(rohlc[0]); // single tick notation
    // other way for arrays can be used as well
    // RatesCompressor::decompress(rohlc, result);
    
    ArrayPrint(result);

}