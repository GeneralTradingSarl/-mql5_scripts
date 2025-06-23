//+------------------------------------------------------------------+
//|                                    SCT_BreakoutStrengthMeter.mq5 |
//|                                        Copyright 2021, FxWeirdos |
//|                                               info@fxweirdos.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2021, FxWeirdos. Mario Gharib. Forex Jarvis. info@fxweirdos.com"
#property link      "https://fxweirdos.com"
#property version   "1.01"
#property script_show_inputs

int iAUD=0, iCAD=0, iCHF=0, iEUR=0, iGBP=0, iJPY=0, iNZD=0, iUSD=0;
int iArray1[8];
string sArray1[8]={"AUD","CAD", "CHF", "EUR", "GBP", "JPY", "NZD", "USD"};

input int iStart = 1;     //Start

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class cCandlestick {

   public:

      double dHighPrice;
      double dLowPrice;
      double dClosePrice;
            
      void mvGetCandleStickCharateristics (string s, int i) {
         
         dHighPrice = iHigh(s, PERIOD_CURRENT,i);
         dLowPrice = iLow(s, PERIOD_CURRENT,i);
         dClosePrice = iClose(s, PERIOD_CURRENT,i);
         
      }
};

void vfunction (string sCountry, int iVal) {

   if (sCountry == "AUD") {
      if (iVal==1)
         iAUD++; 
      else if (iVal==0)
         iAUD--; 
   } else if (sCountry == "CAD") {
      if (iVal==1)
         iCAD++; 
      else if (iVal==0)
         iCAD--; 
   } else if (sCountry == "CHF") {
      if (iVal==1)
         iCHF++; 
      else if (iVal==0)
         iCHF--; 
   } else if (sCountry == "EUR") {
      if (iVal==1)
         iEUR++; 
      else if (iVal==0)
         iEUR--; 
   } else if (sCountry == "GBP") {
      if (iVal==1)
         iGBP++; 
      else if (iVal==0)
         iGBP--; 
   } else if (sCountry == "JPY") {
      if (iVal==1)
         iJPY++; 
      else if (iVal==0)
         iJPY--; 
   } else if (sCountry == "NZD") {
      if (iVal==1)
         iNZD++; 
      else if (iVal==0)
         iNZD--; 
   } else if (sCountry == "USD") {
      if (iVal==1)
         iUSD++; 
      else if (iVal==0)
         iUSD--; 
   }
}    


//+---------------------------------------------------------------------+
//| GetTimeFrame function - returns the textual timeframe               |
//+---------------------------------------------------------------------+
string GetTimeFrame(int lPeriod) {

   switch(lPeriod)
     {
      case 0: return("PERIOD_CURRENT");
      case 1: return("M1");
      case 5: return("M5");
      case 15: return("M15");
      case 30: return("M30");
      case 60: return("H1");
      case 240: return("H4");
      case 1440: return("D1");
      case 10080: return("W1");
      case 43200: return("MN1");
      case 2: return("M2");
      case 3: return("M3");
      case 4: return("M4");      
      case 6: return("M6");
      case 10: return("M10");
      case 12: return("M12");
      case 16385: return("H1");
      case 16386: return("H2");
      case 16387: return("H3");
      case 16388: return("H4");
      case 16390: return("H6");
      case 16392: return("H8");
      case 16396: return("H12");
      case 16408: return("D1");
      case 32769: return("W1");
      case 49153: return("MN1");      
      default: return("PERIOD_CURRENT");
     }
}

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart() {
   
   long chartid=0;
   int HowManySymbols=SymbolsTotal(true);
   
   string sCurrency1, sCurrency2;
   int iPos=0;
   
   for(int i=0;i<HowManySymbols;i++) {
         
      cCandlestick cCS1, cCS2;
      cCS1.mvGetCandleStickCharateristics(SymbolName(i,true),iStart);
      cCS2.mvGetCandleStickCharateristics(SymbolName(i,true),iStart+1);
      
      if (StringLen(SymbolName(i,true))==7)
         iPos=1;
      
      sCurrency1 = StringSubstr(SymbolName(i,true),0,3);
      sCurrency2 = StringSubstr(SymbolName(i,true),3+iPos,3);
            
      if (cCS1.dClosePrice>cCS2.dHighPrice) {
         vfunction(sCurrency1,1);
         vfunction(sCurrency2,0);
      }
      
      if (cCS1.dClosePrice<cCS2.dLowPrice) {
         vfunction(sCurrency1,0);
         vfunction(sCurrency2,1);
      }

   }

	int i,j,itemp;
	string stemp;

   iArray1[0]=iAUD;
   iArray1[1]=iCAD;
   iArray1[2]=iCHF;
   iArray1[3]=iEUR;
   iArray1[4]=iGBP;
   iArray1[5]=iJPY;
   iArray1[6]=iNZD;
   iArray1[7]=iUSD;
	   
	for(i=0;i<8;i++) {		
		for(j=i+1;j<8;j++) {
			if(iArray1[i]>iArray1[j]) {
				itemp = iArray1[i];
				stemp = sArray1[i];
				iArray1[i]=iArray1[j];
				sArray1[i]=sArray1[j];
				iArray1[j]=itemp;
				sArray1[j]=stemp;
			}
		}
	}

   Alert("===========");
   Alert( "Timeframe is ", GetTimeFrame(Period()));
   Alert("===========");

   for (i=0;i<8;i++)
      Alert(sArray1[i], " = ",iArray1[i]);

}