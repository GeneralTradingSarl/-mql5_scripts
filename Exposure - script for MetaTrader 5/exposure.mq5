//+------------------------------------------------------------------+
//|                                                     Exposure.mq5 |
//|                                                               iv |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "iv"
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
int ValuToIndex(string SIndex) // in=Valu_string; out=Index_of_Valu;
  {
   if(SIndex=="EUR") return(0);
   if(SIndex=="USD") return(1);
   if(SIndex=="JPY") return(2);
   if(SIndex=="CHF") return(3);
   if(SIndex=="GBP") return(4);
   if(SIndex=="CAD") return(5);
   return(-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string IndexToValu(int VIndex) // in=Index_of_Valu; out=Valu_string;
  {
   if(VIndex==0) return("EUR");
   if(VIndex==1) return("USD");
   if(VIndex==2) return("JPY");
   if(VIndex==3) return("CHF");
   if(VIndex==4) return("GBP");
   if(VIndex==5) return("CAD");
   return("ANY");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart() // Exposure() : result is V[] and LotV
  {
   int EI,EJ;        // Local index
   const int Vmax=5; // index of last used valu +1 , first index=0 !
   double V[5];      // Valu exposure ; 0=EUR,1=USD,2=JPY,3=CHF,4=GBP,5=CAD ... no other for now.
   string Val1,Val2; // Current Symbol ( valu-pair == Val1/Val2 )
   double LotV;      // Sum all lots
   string Out;       // Text on the screen

   for(EI=0;EI<Vmax;EI++) V[EI]=0.0;
   for(EI=0;EI<PositionsTotal();EI++)
     {
      Val1=StringSubstr(PositionGetSymbol(EI),0,3);
      Val2=StringSubstr(PositionGetSymbol(EI),3,3); // here position is selected !!!
      EJ=ValuToIndex(Val1);
      switch(PositionGetInteger(POSITION_TYPE))
        {
         case POSITION_TYPE_BUY :
           {
            if(Val1=="EUR") V[EJ]=V[EJ]+PositionGetDouble(POSITION_VOLUME);
            else          V[EJ]=V[EJ]+PositionGetDouble(POSITION_VOLUME)/SymbolInfoDouble("EUR"+Val1,SYMBOL_ASK); break;
           }
         case POSITION_TYPE_SELL :
           {
            if(Val1=="EUR") V[EJ]=V[EJ]-PositionGetDouble(POSITION_VOLUME);
            else          V[EJ]=V[EJ]-PositionGetDouble(POSITION_VOLUME)/SymbolInfoDouble("EUR"+Val1,SYMBOL_ASK); break;
           }
        }
      EJ=ValuToIndex(Val2);
      switch(PositionGetInteger(POSITION_TYPE))
        {
         case POSITION_TYPE_SELL :
           {
            if(Val1=="EUR") V[EJ]=V[EJ]+PositionGetDouble(POSITION_VOLUME);
            else          V[EJ]=V[EJ]+PositionGetDouble(POSITION_VOLUME)/SymbolInfoDouble("EUR"+Val1,SYMBOL_ASK); break;
           }
         case POSITION_TYPE_BUY :
           {
            if(Val1=="EUR") V[EJ]=V[EJ]-PositionGetDouble(POSITION_VOLUME);
            else          V[EJ]=V[EJ]-PositionGetDouble(POSITION_VOLUME)/SymbolInfoDouble("EUR"+Val1,SYMBOL_ASK);
           }
        }
     } // for
   LotV=0.0;
   for(EI=0;EI<Vmax;EI++) LotV=LotV+MathAbs(V[EI]);
   Out=Out+"\n EXPOSURE "+DoubleToString(LotV,2)+" [EUR-lot] =";
   for(EJ=0;EJ<Vmax;EJ++) Out=Out+"  "+IndexToValu(EJ)+"="+DoubleToString(V[EJ],3);
   Print(Out+"\n"); // Result printed in expert log (toolbox)
                    // Comment(Out); // Result on screen 
  }
//+------------------------------------------------------------------+