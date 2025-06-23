//+------------------------------------------------------------------+
//|                                              SCT_RiskOverall.mq5 |
//|                                        Copyright 2021, FxWeirdos |
//|                                               info@fxweirdos.com |
//+------------------------------------------------------------------+
#property copyright "Video tutorial"
#property link      "https://www.youtube.com/c/fxweirdos/videos"
#property version   "1.00"
#property strict
#property script_show_inputs

#property description "Copyright 2021, FxWeirdos. Mario Gharib. Forex Jarvis. info@fxweirdos.com"
#property description " "
#property description "RISK DISCLAIMER : Investing involves risks. Any decision to invest in either real estate or stock markets is a personal decision that should be made after thorough research, including an assessment of your personal risk tolerance and your personal financial condition and goals. Results are based on market conditions and on each personal and the action they take and the time and effort they put in"

#include <FxWeirdos\createObjects.mqh>    // Functions for creating objects
#include <FxWeirdos\pipValue.mqh>         // Functions for pip values

//--- Inputs
input color cROAFontClr = C'255,166,36';  // Font color

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart() {

   double dROAAmtRisking;           // Used to calculate the overall risk
   double dROAAmtRewarding;         // Used to calculate the overall target
   int kROA;                        // Used to loop all open orders to get the overall risk

   //--- Delete these objects from chart
   ObjectDelete(0,"ROAOverallPercentRisked");
   ObjectDelete(0,"ROAOverallPercentTarget");

   //--- Always reset these parameters at the beginning
  	dROAAmtRisking=0.0;
  	dROAAmtRewarding=0.0;

   //--- Loop all open position in order to calculate the overall risk
	for (kROA=0 ; kROA<PositionsTotal() ; kROA++) { 	
	   
      //--- Select the open position	   
	   if (PositionSelectByTicket(PositionGetTicket(kROA))) 
	         
         //--- Get the risks of Buys and Sells orders
   	   if (PositionGetInteger(POSITION_TYPE)==0 || PositionGetInteger(POSITION_TYPE)==1) {
   	   
   	      //--- Add the risk of this open order to the overall risk
   			dROAAmtRisking = dROAAmtRisking + dValuePips(PositionGetString(POSITION_SYMBOL), PositionGetDouble(POSITION_PRICE_OPEN), PositionGetDouble(POSITION_SL), PositionGetDouble(POSITION_VOLUME));
   	      
   	      //--- Add the target of this open order to the overall target
   	      dROAAmtRewarding = dROAAmtRewarding + dValuePips(PositionGetString(POSITION_SYMBOL), PositionGetDouble(POSITION_PRICE_OPEN), PositionGetDouble(POSITION_TP), PositionGetDouble(POSITION_VOLUME));

   		}
   }

   //--- Hide the OneClick panel
   ChartSetInteger(0,CHART_SHOW_ONE_CLICK,false);

   //--- Create the OverallRisk & OverallTarget objects
   vSetLabel(0, "ROAOverallPercentRisked",0,25,20,8,cROAFontClr,"Overall % Risked: "+ DoubleToString(dROAAmtRisking/AccountInfoDouble(ACCOUNT_BALANCE)*100,2)+"%");
   vSetLabel(0, "ROAOverallPercentTarget",0,45,20,8,cROAFontClr,"Overall % Target: "+ DoubleToString(dROAAmtRewarding/AccountInfoDouble(ACCOUNT_BALANCE)*100,2)+"%");  
}