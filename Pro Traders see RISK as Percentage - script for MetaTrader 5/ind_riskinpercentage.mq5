//+------------------------------------------------------------------+
//|                                         IND_RiskInPercentage.mq5 |
//|                                    Copyright 2020, Mario Gharib. |
//|                                              fxweirdos@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Mario Gharib. fxweirdos@gmail.com"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_plots 0

int PositionFilled;

double dCurrentAmtRisking;
double dCurrentAmtRewarding;
input color cFontClr = C'255,166,36';                    // FONT COLOR

void vSetLabel(string sName,int sub_window, int xx, int yy, color cFontColor, int iFontSize, string sText) {
   ObjectCreate(0,sName,OBJ_LABEL,sub_window,0,0);
   ObjectSetInteger(0,sName, OBJPROP_YDISTANCE, xx);
   ObjectSetInteger(0,sName, OBJPROP_XDISTANCE, yy);
   ObjectSetInteger(0,sName, OBJPROP_COLOR,cFontColor);
   ObjectSetInteger(0,sName, OBJPROP_WIDTH,FW_BOLD);   
   ObjectSetInteger(0,sName, OBJPROP_FONTSIZE, iFontSize);
   ObjectSetString(0,sName,OBJPROP_TEXT, 0,sText);
   
}

double dValuePips(string sSymbol, double dPrice, double dSLTP, double dVolume) {

   double dp=0;

   if (SymbolInfoInteger(sSymbol,SYMBOL_DIGITS)==1 || SymbolInfoInteger(sSymbol,SYMBOL_DIGITS)==3 || SymbolInfoInteger(sSymbol,SYMBOL_DIGITS)==5)
      dp=10;
   else 
      dp=1;   
   
   double pipPos = SymbolInfoDouble(sSymbol,SYMBOL_POINT)*dp;

	double dNbPips = NormalizeDouble(MathAbs((dPrice-dSLTP)/pipPos),1);

   double PipValue = SymbolInfoDouble(sSymbol,SYMBOL_TRADE_TICK_VALUE)*pipPos/SymbolInfoDouble(sSymbol,SYMBOL_TRADE_TICK_SIZE);
   
   if (StringFind(sSymbol,"XAU")>=0 && StringFind(sSymbol,"USD")>=0 && PipValue==0.1)
      PipValue=PipValue*10;
   else if (StringFind(sSymbol,"XAG")>=0 && StringFind(sSymbol,"USD")>=0 && PipValue==5.0)
      PipValue=PipValue*10;

	return NormalizeDouble(dNbPips*PipValue*dVolume,2);

}


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   
     	dCurrentAmtRisking=0.0;
     	dCurrentAmtRewarding=0.0;
     	
   	// TOTAL NUMBER OF OPEN POSITIONS
   	PositionFilled = PositionsTotal();
   	
   	for (int i=0 ; i < PositionsTotal() ; i++) {
   	   
   	   // GET THE TICKET OF i OPEN POSITION
   	   ulong PositionTicket = PositionGetTicket(i);
   
         // SELECT THIS OPEN POSITION
   	   if (PositionSelectByTicket(PositionTicket)) {
   
            double price   = PositionGetDouble(POSITION_PRICE_OPEN);
            double sl      = PositionGetDouble(POSITION_SL);
            double tp      = PositionGetDouble(POSITION_TP);  
            double vol     = PositionGetDouble(POSITION_VOLUME);
            string symbol  = PositionGetString(POSITION_SYMBOL);
   
   			dCurrentAmtRisking =    dCurrentAmtRisking +    dValuePips(symbol, price, sl, vol);
   			dCurrentAmtRewarding =  dCurrentAmtRewarding +  dValuePips(symbol, price, tp, vol);
   
   		}
   	}

         vSetLabel("CurrentProfit",0,25,20,cFontClr,8,"Current Profit: "+ DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE),2)+" "+AccountInfoString(ACCOUNT_CURRENCY));         
         vSetLabel("CurrentRisked",0,45,20,cFontClr,8,"Current Risked : "+ DoubleToString(dCurrentAmtRisking/AccountInfoDouble(ACCOUNT_BALANCE)*100*(-1),1)+"%");
         vSetLabel("CurrentReward",0,65,20,cFontClr,8,"Current Reward : "+ DoubleToString(dCurrentAmtRewarding/AccountInfoDouble(ACCOUNT_BALANCE)*100,1)+"%");

   return(rates_total);
  }

