//+------------------------------------------------------------------+
//|                                               TickCompressor.mq5 |
//|                                    Copyright (c) 2020, Marketeer |
//|                          https://www.mql5.com/en/users/marketeer |
//|                              https://www.mql5.com/en/code/30791/ |
//+------------------------------------------------------------------+

#include <TickCompressor.mqh>

#define PRT(A) Print(#A, " ", (A))

void OnStart()
{
  PRT(sizeof(MqlTick));
  PRT(sizeof(MqlTickBidAsk));
  PRT(sizeof(MqlTickBidAskLastVolume));

  // 1-element arrays are used for pretty-printing via ArrayPrint
  
  MqlTick tick[1];
  SymbolInfoTick(_Symbol, tick[0]);
  ArrayPrint(tick);

  if(SymbolInfoInteger(_Symbol, SYMBOL_TRADE_CALC_MODE) < SYMBOL_CALC_MODE_EXCH_STOCKS)
  {
    MqlTickBidAsk tba[1];
    TickCompressor::compress(tick, tba); // array notation
    // other way for a single tick can be used as well
    // tba[0] = MqlTickBidAsk::compress(tick[0]);
    ArrayPrint(tba);
  
    MqlTick result[1];
    result[0] = MqlTickBidAsk::decompress(tba[0]); // single tick notation
    // other way for arrays can be used as well
    // TickCompressor::decompress(tba, result);
    
    ArrayPrint(result);
  }
  else
  {
    MqlTickBidAskLastVolume tbalv[1];
    // TickCompressor::compress(tick, tbalv);
    tbalv[0] = MqlTickBidAskLastVolume::compress(tick[0]);
    ArrayPrint(tbalv);
  
    MqlTick result[1];
    TickCompressor::decompress(tbalv, result);
    // result[0] = MqlTickBidAskLastVolume::decompress(tbalv[0]);
    ArrayPrint(result);
  }
}