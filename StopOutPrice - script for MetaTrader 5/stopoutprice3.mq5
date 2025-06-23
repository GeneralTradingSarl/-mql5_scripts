//+------------------------------------------------------------------+
//|                                                 StopOutPrice.mq5 |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.03"
#property script_show_inputs
#property description "Calculate StopOut and LockOut price."
#property description " EnterVolume :"
#property description " =0.0 : Calculete for existing position volume"
#property description " >0.0 : Calculete for entered BUY volume"
#property description " <0.0 : Calculate for entered SELL volume"

input double EnterVolume=0.0;

double YourVolume;
//+------------------------------------------------------------------+
//| Delta                                                            |
//+------------------------------------------------------------------+
double Delta(double Level)
  {
   return(_Point*
          ( AccountInfoDouble(ACCOUNT_EQUITY)                   // Money available
          -Level/100.0                                          // Calculated Level %
          *MathAbs(YourVolume)                                  // Volume to calculate
          *SymbolInfoDouble(_Symbol,SYMBOL_TRADE_CONTRACT_SIZE) // Lot size
          /AccountInfoInteger(ACCOUNT_LEVERAGE)                 // Leverage
          )/
          (SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE)    // Price per tick
          *MathAbs(YourVolume)                                  // Volume to calculate
          ));
  }
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   if(EnterVolume!=0.0) YourVolume=EnterVolume;
   else
     {
      if(PositionSelect(_Symbol))
        {
         if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
           {
            YourVolume=+PositionGetDouble(POSITION_VOLUME);
           }
         else
           {
            YourVolume=-PositionGetDouble(POSITION_VOLUME);
           }
        }
      else
        {
         YourVolume=0.0;
        }
     }
   if(YourVolume!=0.0)
     {
      double dStop=Delta(AccountInfoDouble(ACCOUNT_MARGIN_SO_SO));
      double dLock=Delta(100.0);
      if(YourVolume>0.0)
        {
         if(SymbolInfoDouble(_Symbol,SYMBOL_BID)<dStop)
           {
            Alert("INFO : No Stop Out :-)");
           }
         else
           {
            Alert("INFO : VOLUME=",DoubleToString(YourVolume,2),
                  "  StopOutPrice=",DoubleToString(SymbolInfoDouble(_Symbol,SYMBOL_BID)-dStop,_Digits),
                  "  LockOutPrice=",DoubleToString(SymbolInfoDouble(_Symbol,SYMBOL_BID)-dLock,_Digits));
           }
        }
      else
        {
         Alert("INFO : VOLUME=",DoubleToString(YourVolume,2),
               "  StopOutPrice=",DoubleToString(SymbolInfoDouble(_Symbol,SYMBOL_ASK)+dStop,_Digits),
               "  LockOutPrice=",DoubleToString(SymbolInfoDouble(_Symbol,SYMBOL_ASK)+dLock,_Digits));
        }
     }
   else
     {
      Alert("NO POSITION and VOLUME for this SYMBOL !");
     }
  }
//+------------------------------------------------------------------+
