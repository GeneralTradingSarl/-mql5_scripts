//+------------------------------------------------------------------+
//|                                    SCT_CurrencyStrengthMeter.mq5 |
//|                                        Copyright 2021, FxWeirdos |
//|                                               info@fxweirdos.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2021, FxWeirdos. Mario Gharib. Forex Jarvis. info@fxweirdos.com"
#property link      "https://fxweirdos.com"
#property version   "1.01"
#property script_show_inputs

input int iStart = 1;     //Start
input int iPeriod = 12;   //Period

double dAUD=0, dCAD=0, dCHF=0, dEUR=0, dGBP=0, dJPY=0, dNZD=0, dUSD=0;
double dArray1[8];
string sArray1[8]={"AUD","CAD", "CHF", "EUR", "GBP", "JPY", "NZD", "USD"};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class cCandlestick {

   public:

      double dOpenPrice;
      double dClosePrice;
            
      void mvGetCandleStickCharateristics (string s, int i) {
         
         dOpenPrice = iOpen(s, PERIOD_CURRENT,i);
         dClosePrice = iClose(s, PERIOD_CURRENT,i);
         
      }
};

void vfunction (string ss, string sCountry, double dPrice1, double dPricen, int iSwitch) {

   if (sCountry == "AUD") {
      dAUD=dAUD+(dPrice1-dPricen)/dPrice1*100*iSwitch;
   } else if (sCountry == "CAD") {
      dCAD=dCAD+(dPrice1-dPricen)/dPrice1*100*iSwitch;
   } else if (sCountry == "CHF") {
      dCHF=dCHF+(dPrice1-dPricen)/dPrice1*100*iSwitch;
   } else if (sCountry == "EUR") {
      dEUR=dEUR+(dPrice1-dPricen)/dPrice1*100*iSwitch;
   } else if (sCountry == "GBP") {
      dGBP=dGBP+(dPrice1-dPricen)/dPrice1*100*iSwitch;
   } else if (sCountry == "JPY") {
      dJPY=dJPY+(dPrice1-dPricen)/dPrice1*100*iSwitch;
   } else if (sCountry == "NZD") {
      dNZD=dNZD+(dPrice1-dPricen)/dPrice1*100*iSwitch;
   } else if (sCountry == "USD") {
      dUSD=dUSD+(dPrice1-dPricen)/dPrice1*100*iSwitch;
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

   int HowManySymbols=SymbolsTotal(true);
   
   string sCurrency1, sCurrency2;
   int iPos=0;
   
   for(int i=0;i<HowManySymbols;i++) {
         
      cCandlestick cCS1, cCS2;
      cCS1.mvGetCandleStickCharateristics(SymbolName(i,true),iStart);
      cCS2.mvGetCandleStickCharateristics(SymbolName(i,true),iPeriod);
      
      if (StringLen(SymbolName(i,true))==7)
         iPos=1;
      
      sCurrency1 = StringSubstr(SymbolName(i,true),0,3);
      sCurrency2 = StringSubstr(SymbolName(i,true),3+iPos,3);
            
      vfunction(SymbolName(i,true),sCurrency1,cCS1.dClosePrice,cCS2.dOpenPrice,1);
      vfunction(SymbolName(i,true),sCurrency2,cCS1.dClosePrice,cCS2.dOpenPrice,-1);
      
   }

	int i,j;
	double dtemp;
	string stemp;

   dArray1[0]=dAUD;
   dArray1[1]=dCAD;
   dArray1[2]=dCHF;
   dArray1[3]=dEUR;
   dArray1[4]=dGBP;
   dArray1[5]=dJPY;
   dArray1[6]=dNZD;
   dArray1[7]=dUSD;
	   
	for(i=0;i<8;i++) {
		for(j=i+1;j<8;j++) {
			if(dArray1[i]>dArray1[j]) {
				dtemp = dArray1[i];
				stemp = sArray1[i];
				dArray1[i]=dArray1[j];
				sArray1[i]=sArray1[j];
				dArray1[j]=dtemp;
				sArray1[j]=stemp;
			}
		}
	}

   Alert("===========");
   Alert( "Timeframe is ", GetTimeFrame(Period()));
   Alert("===========");

   for (i=0;i<8;i++)
      Alert(sArray1[i], " = ",DoubleToString(dArray1[i],2));

}