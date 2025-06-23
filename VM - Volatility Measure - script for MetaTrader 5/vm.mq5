//+------------------------------------------------------------------+
//|                                                           VM.mq5 |
//|                                                 Azotskiy Aktiniy |
//|                                                    ICQ:695710750 |
//+------------------------------------------------------------------+
#property copyright "Azotskiy Aktiniy"
#property link      "ICQ:695710750"
#property version   "1.00"
#property script_show_inputs
//--- input parameters
input datetime DataBegin=D'2013.02.01'; // The start date of scanning.
input datetime DataEnd=D'2013.03.01'; // The end date of scanning.

input color w=clrBlack; // Table Background
input color wf=clrMagenta; // Table frame

input color string1=clrAqua; // The color of the first string
input color string2=clrRed; // The color of the second string
input color string3=clrAntiqueWhite; // The color of the third string
input color string4=clrYellowGreen; // The color of the fourth string
input color string5=clrGreenYellow; // The color of the fifth string
input color string6=clrMagenta; // The color of the sixth string
input color string7=clrMediumAquamarine; // The color of the seventh string
input color string8=clrGold; // the color of the eighth string
input color string9=clrAzure; // The color of the ninth string
input color string10=clrRed; // The color of the tenth string
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---

// Get to learn tick size
   double Tick=SymbolInfoDouble(Symbol(),SYMBOL_TRADE_TICK_SIZE);

// Get to learn the number of bars for each timeframe
   int BarsMN=Bars(Symbol(),PERIOD_MN1,DataBegin,DataEnd);
   int BarsW1=Bars(Symbol(),PERIOD_W1,DataBegin,DataEnd);
   int BarsD1=Bars(Symbol(),PERIOD_D1,DataBegin,DataEnd);
   int BarsH4=Bars(Symbol(),PERIOD_H4,DataBegin,DataEnd);
   int BarsH1=Bars(Symbol(),PERIOD_H1,DataBegin,DataEnd);
   int BarsM30=Bars(Symbol(),PERIOD_M30,DataBegin,DataEnd);
   int BarsM15=Bars(Symbol(),PERIOD_M15,DataBegin,DataEnd);
   int BarsM5=Bars(Symbol(),PERIOD_M5,DataBegin,DataEnd);
   int BarsM1=Bars(Symbol(),PERIOD_M1,DataBegin,DataEnd);

// Declare dynamic arrays for copying data about bars
   double OpenMN[],OpenW1[],OpenD1[],OpenH4[],OpenH1[],OpenM30[],OpenM15[],OpenM5[],OpenM1[];
   double CloseMN[],CloseW1[],CloseD1[],CloseH4[],CloseH1[],CloseM30[],CloseM15[],CloseM5[],CloseM1[];
   double HighMN[],HighW1[],HighD1[],HighH4[],HighH1[],HighM30[],HighM15[],HighM5[],HighM1[];
   double LowMN[],LowW1[],LowD1[],LowH4[],LowH1[],LowM30[],LowM15[],LowM5[],LowM1[];

// Set the size of the arrays
   ArrayResize(OpenMN,BarsMN); ArrayResize(CloseMN,BarsMN); ArrayResize(HighMN,BarsMN); ArrayResize(LowMN,BarsMN);
   ArrayResize(OpenW1,BarsW1); ArrayResize(CloseW1,BarsW1); ArrayResize(HighW1,BarsW1); ArrayResize(LowW1,BarsW1);
   ArrayResize(OpenD1,BarsD1); ArrayResize(CloseD1,BarsD1); ArrayResize(HighD1,BarsD1); ArrayResize(LowD1,BarsD1);
   ArrayResize(OpenH4,BarsH4); ArrayResize(CloseH4,BarsH4); ArrayResize(HighH4,BarsH4); ArrayResize(LowH4,BarsH4);
   ArrayResize(OpenH1,BarsH1); ArrayResize(CloseH1,BarsH1); ArrayResize(HighH1,BarsH1); ArrayResize(LowH1,BarsH1);
   ArrayResize(OpenM30,BarsM30); ArrayResize(CloseM30,BarsM30); ArrayResize(HighM30,BarsM30); ArrayResize(LowM30,BarsM30);
   ArrayResize(OpenM15,BarsM15); ArrayResize(CloseM15,BarsM15); ArrayResize(HighM15,BarsM15); ArrayResize(LowM15,BarsM15);
   ArrayResize(OpenM5,BarsM5); ArrayResize(CloseM5,BarsM5); ArrayResize(HighM5,BarsM5); ArrayResize(LowM5,BarsM5);
   ArrayResize(OpenM1,BarsM1); ArrayResize(CloseM1,BarsM1); ArrayResize(HighM1,BarsM1); ArrayResize(LowM1,BarsM1);

// Copy the data arrays
   int CheckBarsOpenMN=CopyOpen(Symbol(),PERIOD_MN1,DataBegin,DataEnd,OpenMN); if(CheckBarsOpenMN!=BarsMN)Print("Error copy Open MN");
   int CheckBarsCloseMN=CopyClose(Symbol(),PERIOD_MN1,DataBegin,DataEnd,CloseMN); if(CheckBarsCloseMN!=BarsMN)Print("Error copy Close MN");
   int CheckBarsHighMN=CopyHigh(Symbol(),PERIOD_MN1,DataBegin,DataEnd,HighMN); if(CheckBarsHighMN!=BarsMN)Print("Error copy High MN");
   int CheckBarsLowMN=CopyLow(Symbol(),PERIOD_MN1,DataBegin,DataEnd,LowMN); if(CheckBarsLowMN!=BarsMN)Print("Error copy Low MN");

   int CheckBarsOpenW1=CopyOpen(Symbol(),PERIOD_W1,DataBegin,DataEnd,OpenW1); if(CheckBarsOpenW1!=BarsW1)Print("Error copy Open W1");
   int CheckBarsCloseW1=CopyClose(Symbol(),PERIOD_W1,DataBegin,DataEnd,CloseW1); if(CheckBarsCloseW1!=BarsW1)Print("Error copy Close W1");
   int CheckBarsHighW1=CopyHigh(Symbol(),PERIOD_W1,DataBegin,DataEnd,HighW1); if(CheckBarsHighW1!=BarsW1)Print("Error copy High W1");
   int CheckBarsLowW1=CopyLow(Symbol(),PERIOD_W1,DataBegin,DataEnd,LowW1); if(CheckBarsLowW1!=BarsW1)Print("Error copy Low W1");

   int CheckBarsOpenD1=CopyOpen(Symbol(),PERIOD_D1,DataBegin,DataEnd,OpenD1); if(CheckBarsOpenD1!=BarsD1)Print("Error copy Open D1");
   int CheckBarsCloseD1=CopyClose(Symbol(),PERIOD_D1,DataBegin,DataEnd,CloseD1); if(CheckBarsCloseD1!=BarsD1)Print("Error copy Close D1");
   int CheckBarsHighD1=CopyHigh(Symbol(),PERIOD_D1,DataBegin,DataEnd,HighD1); if(CheckBarsHighD1!=BarsD1)Print("Error copy High D1");
   int CheckBarsLowD1=CopyLow(Symbol(),PERIOD_D1,DataBegin,DataEnd,LowD1); if(CheckBarsLowD1!=BarsD1)Print("Error copy Low D1");

   int CheckBarsOpenH4=CopyOpen(Symbol(),PERIOD_H4,DataBegin,DataEnd,OpenH4); if(CheckBarsOpenH4!=BarsH4)Print("Error copy Open H4");
   int CheckBarsCloseH4=CopyClose(Symbol(),PERIOD_H4,DataBegin,DataEnd,CloseH4); if(CheckBarsCloseH4!=BarsH4)Print("Error copy Close H4");
   int CheckBarsHighH4=CopyHigh(Symbol(),PERIOD_H4,DataBegin,DataEnd,HighH4); if(CheckBarsHighH4!=BarsH4)Print("Error copy High H4");
   int CheckBarsLowH4=CopyLow(Symbol(),PERIOD_H4,DataBegin,DataEnd,LowH4); if(CheckBarsLowH4!=BarsH4)Print("Error copy Low H4");

   int CheckBarsOpenH1=CopyOpen(Symbol(),PERIOD_H1,DataBegin,DataEnd,OpenH1); if(CheckBarsOpenH1!=BarsH1)Print("Error copy Open H1");
   int CheckBarsCloseH1=CopyClose(Symbol(),PERIOD_H1,DataBegin,DataEnd,CloseH1); if(CheckBarsCloseH1!=BarsH1)Print("Error copy Close H1");
   int CheckBarsHighH1=CopyHigh(Symbol(),PERIOD_H1,DataBegin,DataEnd,HighH1); if(CheckBarsHighH1!=BarsH1)Print("Error copy High H1");
   int CheckBarsLowH1=CopyLow(Symbol(),PERIOD_H1,DataBegin,DataEnd,LowH1); if(CheckBarsLowH1!=BarsH1)Print("Error copy Low H1");

   int CheckBarsOpenM30=CopyOpen(Symbol(),PERIOD_M30,DataBegin,DataEnd,OpenM30); if(CheckBarsOpenM30!=BarsM30)Print("Error copy Open M30");
   int CheckBarsCloseM30=CopyClose(Symbol(),PERIOD_M30,DataBegin,DataEnd,CloseM30); if(CheckBarsCloseM30!=BarsM30)Print("Error copy Close M30");
   int CheckBarsHighM30=CopyHigh(Symbol(),PERIOD_M30,DataBegin,DataEnd,HighM30); if(CheckBarsHighM30!=BarsM30)Print("Error copy High M30");
   int CheckBarsLowM30=CopyLow(Symbol(),PERIOD_M30,DataBegin,DataEnd,LowM30); if(CheckBarsLowM30!=BarsM30)Print("Error copy Low M30");

   int CheckBarsOpenM15=CopyOpen(Symbol(),PERIOD_M15,DataBegin,DataEnd,OpenM15); if(CheckBarsOpenM15!=BarsM15)Print("Error copy Open M15");
   int CheckBarsCloseM15=CopyClose(Symbol(),PERIOD_M15,DataBegin,DataEnd,CloseM15); if(CheckBarsCloseM15!=BarsM15)Print("Error copy Close M15");
   int CheckBarsHighM15=CopyHigh(Symbol(),PERIOD_M15,DataBegin,DataEnd,HighM15); if(CheckBarsHighM15!=BarsM15)Print("Error copy High M15");
   int CheckBarsLowM15=CopyLow(Symbol(),PERIOD_M15,DataBegin,DataEnd,LowM15); if(CheckBarsLowM15!=BarsM15)Print("Error copy Low M15");

   int CheckBarsOpenM5=CopyOpen(Symbol(),PERIOD_M5,DataBegin,DataEnd,OpenM5); if(CheckBarsOpenM5!=BarsM5)Print("Error copy Open M5");
   int CheckBarsCloseM5=CopyClose(Symbol(),PERIOD_M5,DataBegin,DataEnd,CloseM5); if(CheckBarsCloseM5!=BarsM5)Print("Error copy Close M5");
   int CheckBarsHighM5=CopyHigh(Symbol(),PERIOD_M5,DataBegin,DataEnd,HighM5); if(CheckBarsHighM5!=BarsM5)Print("Error copy High M5");
   int CheckBarsLowM5=CopyLow(Symbol(),PERIOD_M5,DataBegin,DataEnd,LowM5); if(CheckBarsLowM5!=BarsM5)Print("Error copy Low M5");

   int CheckBarsOpenM1=CopyOpen(Symbol(),PERIOD_M1,DataBegin,DataEnd,OpenM1); if(CheckBarsOpenM1!=BarsM1)Print("Error copy Open M1");
   int CheckBarsCloseM1=CopyClose(Symbol(),PERIOD_M1,DataBegin,DataEnd,CloseM1); if(CheckBarsCloseM1!=BarsM1)Print("Error copy Close M1");
   int CheckBarsHighM1=CopyHigh(Symbol(),PERIOD_M1,DataBegin,DataEnd,HighM1); if(CheckBarsHighM1!=BarsM1)Print("Error copy High M1");
   int CheckBarsLowM1=CopyLow(Symbol(),PERIOD_M1,DataBegin,DataEnd,LowM1); if(CheckBarsLowM1!=BarsM1)Print("Error copy Low M1");

// Declare dynamic arrays for calculated data
   double BodyMN[],BodyW1[],BodyD1[],BodyH4[],BodyH1[],BodyM30[],BodyM15[],BodyM5[],BodyM1[];
   double UpShadowMN[],UpShadowW1[],UpShadowD1[],UpShadowH4[],UpShadowH1[],UpShadowM30[],UpShadowM15[],UpShadowM5[],UpShadowM1[];
   double DownShadowMN[],DownShadowW1[],DownShadowD1[],DownShadowH4[],DownShadowH1[],DownShadowM30[],DownShadowM15[],DownShadowM5[],DownShadowM1[];

// Set the size for the dynamic arrays
   ArrayResize(BodyMN,BarsMN); ArrayResize(UpShadowMN,BarsMN); ArrayResize(DownShadowMN,BarsMN);
   ArrayResize(BodyW1,BarsW1); ArrayResize(UpShadowW1,BarsW1); ArrayResize(DownShadowW1,BarsW1);
   ArrayResize(BodyD1,BarsD1); ArrayResize(UpShadowD1,BarsD1); ArrayResize(DownShadowD1,BarsD1);
   ArrayResize(BodyH4,BarsH4); ArrayResize(UpShadowH4,BarsH4); ArrayResize(DownShadowH4,BarsH4);
   ArrayResize(BodyH1,BarsH1); ArrayResize(UpShadowH1,BarsH1); ArrayResize(DownShadowH1,BarsH1);
   ArrayResize(BodyM30,BarsM30); ArrayResize(UpShadowM30,BarsM30); ArrayResize(DownShadowM30,BarsM30);
   ArrayResize(BodyM15,BarsM15); ArrayResize(UpShadowM15,BarsM15); ArrayResize(DownShadowM15,BarsM15);
   ArrayResize(BodyM5,BarsM5); ArrayResize(UpShadowM5,BarsM5); ArrayResize(DownShadowM5,BarsM5);
   ArrayResize(BodyM1,BarsM1); ArrayResize(UpShadowM1,BarsM1); ArrayResize(DownShadowM1,BarsM1);

// Calculation of data
// Monthly
   for(int x=0; x<BarsMN; x++)
     {
      BodyMN[x]=MathRound(fabs(OpenMN[x]-CloseMN[x])/Tick);
      if(OpenMN[x]>=CloseMN[x])
        {
         UpShadowMN[x]=MathRound(fabs(HighMN[x]-OpenMN[x])/Tick);
         DownShadowMN[x]=MathRound(fabs(LowMN[x]-CloseMN[x])/Tick);
        }
      if(OpenMN[x]<CloseMN[x])
        {
         UpShadowMN[x]=MathRound(fabs(HighMN[x]-CloseMN[x])/Tick);
         DownShadowMN[x]=MathRound(fabs(LowMN[x]-OpenMN[x])/Tick);
        }
     }

// Weekly
   for(int x=0; x<BarsW1; x++)
     {
      BodyW1[x]=MathRound(fabs(OpenW1[x]-CloseW1[x])/Tick);
      if(OpenW1[x]>=CloseW1[x])
        {
         UpShadowW1[x]=MathRound(fabs(HighW1[x]-OpenW1[x])/Tick);
         DownShadowW1[x]=MathRound(fabs(LowW1[x]-CloseW1[x])/Tick);
        }
      if(OpenW1[x]<CloseW1[x])
        {
         UpShadowW1[x]=MathRound(fabs(HighW1[x]-CloseW1[x])/Tick);
         DownShadowW1[x]=MathRound(fabs(LowW1[x]-OpenW1[x])/Tick);
        }
     }

// Daily
   for(int x=0; x<BarsD1; x++)
     {
      BodyD1[x]=MathRound(fabs(OpenD1[x]-CloseD1[x])/Tick);
      if(OpenD1[x]>=CloseD1[x])
        {
         UpShadowD1[x]=MathRound(fabs(HighD1[x]-OpenD1[x])/Tick);
         DownShadowD1[x]=MathRound(fabs(LowD1[x]-CloseD1[x])/Tick);
        }
      if(OpenD1[x]<CloseD1[x])
        {
         UpShadowD1[x]=MathRound(fabs(HighD1[x]-CloseD1[x])/Tick);
         DownShadowD1[x]=MathRound(fabs(LowD1[x]-OpenD1[x])/Tick);
        }
     }

// Four-hour
   for(int x=0; x<BarsH4; x++)
     {
      BodyH4[x]=MathRound(fabs(OpenH4[x]-CloseH4[x])/Tick);
      if(OpenH4[x]>=CloseH4[x])
        {
         UpShadowH4[x]=MathRound(fabs(HighH4[x]-OpenH4[x])/Tick);
         DownShadowH4[x]=MathRound(fabs(LowH4[x]-CloseH4[x])/Tick);
        }
      if(OpenH4[x]<CloseH4[x])
        {
         UpShadowH4[x]=MathRound(fabs(HighH4[x]-CloseH4[x])/Tick);
         DownShadowH4[x]=MathRound(fabs(LowH4[x]-OpenH4[x])/Tick);
        }
     }

// Time
   for(int x=0; x<BarsH1; x++)
     {
      BodyH1[x]=MathRound(fabs(OpenH1[x]-CloseH1[x])/Tick);
      if(OpenH1[x]>=CloseH1[x])
        {
         UpShadowH1[x]=MathRound(fabs(HighH1[x]-OpenH1[x])/Tick);
         DownShadowH1[x]=MathRound(fabs(LowH1[x]-CloseH1[x])/Tick);
        }
      if(OpenH1[x]<CloseH1[x])
        {
         UpShadowH1[x]=MathRound(fabs(HighH1[x]-CloseH1[x])/Tick);
         DownShadowH1[x]=MathRound(fabs(LowH1[x]-OpenH1[x])/Tick);
        }
     }

// Thirty-minute
   for(int x=0; x<BarsM30; x++)
     {
      BodyM30[x]=MathRound(fabs(OpenM30[x]-CloseM30[x])/Tick);
      if(OpenM30[x]>=CloseM30[x])
        {
         UpShadowM30[x]=MathRound(fabs(HighM30[x]-OpenM30[x])/Tick);
         DownShadowM30[x]=MathRound(fabs(LowM30[x]-CloseM30[x])/Tick);
        }
      if(OpenM30[x]<CloseM30[x])
        {
         UpShadowM30[x]=MathRound(fabs(HighM30[x]-CloseM30[x])/Tick);
         DownShadowM30[x]=MathRound(fabs(LowM30[x]-OpenM30[x])/Tick);
        }
     }

// Fifteen-minute
   for(int x=0; x<BarsM15; x++)
     {
      BodyM15[x]=MathRound(fabs(OpenM15[x]-CloseM15[x])/Tick);
      if(OpenM15[x]>=CloseM15[x])
        {
         UpShadowM15[x]=MathRound(fabs(HighM15[x]-OpenM15[x])/Tick);
         DownShadowM15[x]=MathRound(fabs(LowM15[x]-CloseM15[x])/Tick);
        }
      if(OpenM15[x]<CloseM15[x])
        {
         UpShadowM15[x]=MathRound(fabs(HighM15[x]-CloseM15[x])/Tick);
         DownShadowM15[x]=MathRound(fabs(LowM15[x]-OpenM15[x])/Tick);
        }
     }

// Five-minute
   for(int x=0; x<BarsM5; x++)
     {
      BodyM5[x]=MathRound(fabs(OpenM5[x]-CloseM5[x])/Tick);
      if(OpenM5[x]>=CloseM5[x])
        {
         UpShadowM5[x]=MathRound(fabs(HighM5[x]-OpenM5[x])/Tick);
         DownShadowM5[x]=MathRound(fabs(LowM5[x]-CloseM5[x])/Tick);
        }
      if(OpenM5[x]<CloseM5[x])
        {
         UpShadowM5[x]=MathRound(fabs(HighM5[x]-CloseM5[x])/Tick);
         DownShadowM5[x]=MathRound(fabs(LowM5[x]-OpenM5[x])/Tick);
        }
     }

// Minute
   for(int x=0; x<BarsM1; x++)
     {
      BodyM1[x]=MathRound(fabs(OpenM1[x]-CloseM1[x])/Tick);
      if(OpenM1[x]>=CloseM1[x])
        {
         UpShadowM1[x]=MathRound(fabs(HighM1[x]-OpenM1[x])/Tick);
         DownShadowM1[x]=MathRound(fabs(LowM1[x]-CloseM1[x])/Tick);
        }
      if(OpenM1[x]<CloseM1[x])
        {
         UpShadowM1[x]=MathRound(fabs(HighM1[x]-CloseM1[x])/Tick);
         DownShadowM1[x]=MathRound(fabs(LowM1[x]-OpenM1[x])/Tick);
        }
     }

// Find the maximum and minimum number of arrays
// View the candlestick bodies
   int BodyMaxMN=ArrayMaximum(BodyMN);
   int BodyMinMN=ArrayMinimum(BodyMN);
   int BodyMaxW1=ArrayMaximum(BodyW1);
   int BodyMinW1=ArrayMinimum(BodyW1);
   int BodyMaxD1=ArrayMaximum(BodyD1);
   int BodyMinD1=ArrayMinimum(BodyD1);
   int BodyMaxH4=ArrayMaximum(BodyH4);
   int BodyMinH4=ArrayMinimum(BodyH4);
   int BodyMaxH1=ArrayMaximum(BodyH1);
   int BodyMinH1=ArrayMinimum(BodyH1);
   int BodyMaxM30=ArrayMaximum(BodyM30);
   int BodyMinM30=ArrayMinimum(BodyM30);
   int BodyMaxM15=ArrayMaximum(BodyM15);
   int BodyMinM15=ArrayMinimum(BodyM15);
   int BodyMaxM5=ArrayMaximum(BodyM5);
   int BodyMinM5=ArrayMinimum(BodyM5);
   int BodyMaxM1=ArrayMaximum(BodyM1);
   int BodyMinM1=ArrayMinimum(BodyM1);

// View the Upper shadow
   int UpShadowMaxMN=ArrayMaximum(UpShadowMN);
   int UpShadowMinMN=ArrayMinimum(UpShadowMN);
   int UpShadowMaxW1=ArrayMaximum(UpShadowW1);
   int UpShadowMinW1=ArrayMinimum(UpShadowW1);
   int UpShadowMaxH4=ArrayMaximum(UpShadowH4);
   int UpShadowMinH4=ArrayMinimum(UpShadowH4);
   int UpShadowMaxH1=ArrayMaximum(UpShadowH1);
   int UpShadowMinH1=ArrayMinimum(UpShadowH1);
   int UpShadowMaxM30=ArrayMaximum(UpShadowM30);
   int UpShadowMinM30=ArrayMinimum(UpShadowM30);
   int UpShadowMaxM15=ArrayMaximum(UpShadowM15);
   int UpShadowMinM15=ArrayMinimum(UpShadowM15);
   int UpShadowMaxM5=ArrayMaximum(UpShadowM5);
   int UpShadowMinM5=ArrayMinimum(UpShadowM5);
   int UpShadowMaxM1=ArrayMaximum(UpShadowM1);
   int UpShadowMinM1=ArrayMinimum(UpShadowM1);

// View the Lower shadow
   int DownShadowMaxMN=ArrayMaximum(DownShadowMN);
   int DownShadowMinMN=ArrayMinimum(DownShadowMN);
   int DownShadowMaxW1=ArrayMaximum(DownShadowW1);
   int DownShadowMinW1=ArrayMinimum(DownShadowW1);
   int DownShadowMaxH4=ArrayMaximum(DownShadowH4);
   int DownShadowMinH4=ArrayMinimum(DownShadowH4);
   int DownShadowMaxH1=ArrayMaximum(DownShadowH1);
   int DownShadowMinH1=ArrayMinimum(DownShadowH1);
   int DownShadowMaxM30=ArrayMaximum(DownShadowM30);
   int DownShadowMinM30=ArrayMinimum(DownShadowM30);
   int DownShadowMaxM15=ArrayMaximum(DownShadowM15);
   int DownShadowMinM15=ArrayMinimum(DownShadowM15);
   int DownShadowMaxM5=ArrayMaximum(DownShadowM5);
   int DownShadowMinM5=ArrayMinimum(DownShadowM5);
   int DownShadowMaxM1=ArrayMaximum(DownShadowM1);
   int DownShadowMinM1=ArrayMinimum(DownShadowM1);

// Enter variables for the calculation of arithmetic mean values
   double SBodyMN=0,SBodyW1=0,SBodyH4=0,SBodyH1=0,SBodyM30=0,SBodyM15=0,SBodyM5=0,SBodyM1=0;
   double SUpShadowMN=0,SUpShadowW1=0,SUpShadowH4=0,SUpShadowH1=0,SUpShadowM30=0,SUpShadowM15=0,SUpShadowM5=0,SUpShadowM1=0;
   double SDownShadowMN=0,SDownShadowW1=0,SDownShadowH4=0,SDownShadowH1=0,SDownShadowM30=0,SDownShadowM15=0,SDownShadowM5=0,SDownShadowM1=0;

// Find the arithmetic mean value of arrays
// Candlestick body
   for(int x=0; x<BarsMN; x++){SBodyMN=SBodyMN+BodyMN[x];}
   if(BarsMN>0)SBodyMN=SBodyMN/BarsMN;
   for(int x=0; x<BarsW1; x++){SBodyW1=SBodyW1+BodyW1[x];}
   if(BarsW1>0)SBodyW1=SBodyW1/BarsW1;
   for(int x=0; x<BarsH4; x++){SBodyH4=SBodyH4+BodyH4[x];}
   if(BarsH4>0)SBodyH4=SBodyH4/BarsH4;
   for(int x=0; x<BarsH1; x++){SBodyH1=SBodyH1+BodyH1[x];}
   if(BarsH1>0)SBodyH1=SBodyH1/BarsH1;
   for(int x=0; x<BarsM30; x++){SBodyM30=SBodyM30+BodyM30[x];}
   if(BarsM30>0)SBodyM30=SBodyM30/BarsM30;
   for(int x=0; x<BarsM15; x++){SBodyM15=SBodyM15+BodyM15[x];}
   if(BarsM15>0)SBodyM15=SBodyM15/BarsM15;
   for(int x=0; x<BarsM5; x++){SBodyM5=SBodyM5+BodyM5[x];}
   if(BarsM5>0)SBodyM5=SBodyM5/BarsM5;
   for(int x=0; x<BarsM1; x++){SBodyM1=SBodyM1+BodyM1[x];}
   if(BarsM1>0)SBodyM1=SBodyM1/BarsM1;

// Upper shadow
   for(int x=0; x<BarsMN; x++){SUpShadowMN=SUpShadowMN+UpShadowMN[x];}
   if(BarsMN>0)SUpShadowMN=SUpShadowMN/BarsMN;
   for(int x=0; x<BarsW1; x++){SUpShadowW1=SUpShadowW1+UpShadowW1[x];}
   if(BarsW1>0)SUpShadowW1=SUpShadowW1/BarsW1;
   for(int x=0; x<BarsH4; x++){SUpShadowH4=SUpShadowH4+UpShadowH4[x];}
   if(BarsH4>0)SUpShadowH4=SUpShadowH4/BarsH4;
   for(int x=0; x<BarsH1; x++){SUpShadowH1=SUpShadowH1+UpShadowH1[x];}
   if(BarsH1>0)SUpShadowH1=SUpShadowH1/BarsH1;
   for(int x=0; x<BarsM30; x++){SUpShadowM30=SUpShadowM30+UpShadowM30[x];}
   if(BarsM30>0)SUpShadowM30=SUpShadowM30/BarsM30;
   for(int x=0; x<BarsM15; x++){SUpShadowM15=SUpShadowM15+UpShadowM15[x];}
   if(BarsM15>0)SUpShadowM15=SUpShadowM15/BarsM15;
   for(int x=0; x<BarsM5; x++){SUpShadowM5=SUpShadowM5+UpShadowM5[x];}
   if(BarsM5>0)SUpShadowM5=SUpShadowM5/BarsM5;
   for(int x=0; x<BarsM1; x++){SUpShadowM1=SUpShadowM1+UpShadowM1[x];}
   if(BarsM1>0)SUpShadowM1=SUpShadowM1/BarsM1;

// Lower shadow
   for(int x=0; x<BarsMN; x++){SDownShadowMN=SDownShadowMN+DownShadowMN[x];}
   if(BarsMN>0)SDownShadowMN=SDownShadowMN/BarsMN;
   for(int x=0; x<BarsW1; x++){SDownShadowW1=SDownShadowW1+DownShadowW1[x];}
   if(BarsW1>0)SDownShadowW1=SDownShadowW1/BarsW1;
   for(int x=0; x<BarsH4; x++){SDownShadowH4=SDownShadowH4+DownShadowH4[x];}
   if(BarsH4>0)SDownShadowH4=SDownShadowH4/BarsH4;
   for(int x=0; x<BarsH1; x++){SDownShadowH1=SDownShadowH1+DownShadowH1[x];}
   if(BarsH1>0)SDownShadowH1=SDownShadowH1/BarsH1;
   for(int x=0; x<BarsM30; x++){SDownShadowM30=SDownShadowM30+DownShadowM30[x];}
   if(BarsM30>0)SDownShadowM30=SDownShadowM30/BarsM30;
   for(int x=0; x<BarsM15; x++){SDownShadowM15=SDownShadowM15+DownShadowM15[x];}
   if(BarsM15>0)SDownShadowM15=SDownShadowM15/BarsM15;
   for(int x=0; x<BarsM5; x++){SDownShadowM5=SDownShadowM5+DownShadowM5[x];}
   if(BarsM5>0)SDownShadowM5=SDownShadowM5/BarsM5;
   for(int x=0; x<BarsM1; x++){SDownShadowM1=SDownShadowM1+DownShadowM1[x];}
   if(BarsM1>0)SDownShadowM1=SDownShadowM1/BarsM1;

// Create the objects
// The main window for the table
   ObjectCreate(0,"w",OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,"w",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"w",OBJPROP_XDISTANCE,0);
   ObjectSetInteger(0,"w",OBJPROP_YDISTANCE,0);
   ObjectSetInteger(0,"w",OBJPROP_XSIZE,292);
   ObjectSetInteger(0,"w",OBJPROP_YSIZE,180);
   ObjectSetInteger(0,"w",OBJPROP_BGCOLOR,w);
   ObjectSetInteger(0,"w",OBJPROP_BORDER_COLOR,wf);
   ObjectSetInteger(0,"w",OBJPROP_READONLY,1);

// Horizontal lines
   ObjectCreate(0,"v1",OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,"v1",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"v1",OBJPROP_XDISTANCE,0);
   ObjectSetInteger(0,"v1",OBJPROP_YDISTANCE,18);
   ObjectSetInteger(0,"v1",OBJPROP_XSIZE,292);
   ObjectSetInteger(0,"v1",OBJPROP_YSIZE,1);
   ObjectSetInteger(0,"v1",OBJPROP_BGCOLOR,w);
   ObjectSetInteger(0,"v1",OBJPROP_BORDER_COLOR,wf);
   ObjectSetInteger(0,"v1",OBJPROP_READONLY,1);

   ObjectCreate(0,"v2",OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,"v2",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"v2",OBJPROP_XDISTANCE,0);
   ObjectSetInteger(0,"v2",OBJPROP_YDISTANCE,36);
   ObjectSetInteger(0,"v2",OBJPROP_XSIZE,292);
   ObjectSetInteger(0,"v2",OBJPROP_YSIZE,1);
   ObjectSetInteger(0,"v2",OBJPROP_BGCOLOR,w);
   ObjectSetInteger(0,"v2",OBJPROP_BORDER_COLOR,wf);
   ObjectSetInteger(0,"v2",OBJPROP_READONLY,1);

   ObjectCreate(0,"v3",OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,"v3",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"v3",OBJPROP_XDISTANCE,0);
   ObjectSetInteger(0,"v3",OBJPROP_YDISTANCE,54);
   ObjectSetInteger(0,"v3",OBJPROP_XSIZE,292);
   ObjectSetInteger(0,"v3",OBJPROP_YSIZE,1);
   ObjectSetInteger(0,"v3",OBJPROP_BGCOLOR,w);
   ObjectSetInteger(0,"v3",OBJPROP_BORDER_COLOR,wf);
   ObjectSetInteger(0,"v3",OBJPROP_READONLY,1);

   ObjectCreate(0,"v4",OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,"v4",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"v4",OBJPROP_XDISTANCE,0);
   ObjectSetInteger(0,"v4",OBJPROP_YDISTANCE,72);
   ObjectSetInteger(0,"v4",OBJPROP_XSIZE,292);
   ObjectSetInteger(0,"v4",OBJPROP_YSIZE,1);
   ObjectSetInteger(0,"v4",OBJPROP_BGCOLOR,w);
   ObjectSetInteger(0,"v4",OBJPROP_BORDER_COLOR,wf);
   ObjectSetInteger(0,"v4",OBJPROP_READONLY,1);

   ObjectCreate(0,"v5",OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,"v5",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"v5",OBJPROP_XDISTANCE,0);
   ObjectSetInteger(0,"v5",OBJPROP_YDISTANCE,90);
   ObjectSetInteger(0,"v5",OBJPROP_XSIZE,292);
   ObjectSetInteger(0,"v5",OBJPROP_YSIZE,1);
   ObjectSetInteger(0,"v5",OBJPROP_BGCOLOR,w);
   ObjectSetInteger(0,"v5",OBJPROP_BORDER_COLOR,wf);
   ObjectSetInteger(0,"v5",OBJPROP_READONLY,1);

   ObjectCreate(0,"v6",OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,"v6",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"v6",OBJPROP_XDISTANCE,0);
   ObjectSetInteger(0,"v6",OBJPROP_YDISTANCE,108);
   ObjectSetInteger(0,"v6",OBJPROP_XSIZE,292);
   ObjectSetInteger(0,"v6",OBJPROP_YSIZE,1);
   ObjectSetInteger(0,"v6",OBJPROP_BGCOLOR,w);
   ObjectSetInteger(0,"v6",OBJPROP_BORDER_COLOR,wf);
   ObjectSetInteger(0,"v6",OBJPROP_READONLY,1);

   ObjectCreate(0,"v7",OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,"v7",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"v7",OBJPROP_XDISTANCE,0);
   ObjectSetInteger(0,"v7",OBJPROP_YDISTANCE,126);
   ObjectSetInteger(0,"v7",OBJPROP_XSIZE,292);
   ObjectSetInteger(0,"v7",OBJPROP_YSIZE,1);
   ObjectSetInteger(0,"v7",OBJPROP_BGCOLOR,w);
   ObjectSetInteger(0,"v7",OBJPROP_BORDER_COLOR,wf);
   ObjectSetInteger(0,"v7",OBJPROP_READONLY,1);

   ObjectCreate(0,"v8",OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,"v8",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"v8",OBJPROP_XDISTANCE,0);
   ObjectSetInteger(0,"v8",OBJPROP_YDISTANCE,144);
   ObjectSetInteger(0,"v8",OBJPROP_XSIZE,292);
   ObjectSetInteger(0,"v8",OBJPROP_YSIZE,1);
   ObjectSetInteger(0,"v8",OBJPROP_BGCOLOR,w);
   ObjectSetInteger(0,"v8",OBJPROP_BORDER_COLOR,wf);
   ObjectSetInteger(0,"v8",OBJPROP_READONLY,1);

   ObjectCreate(0,"v9",OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,"v9",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"v9",OBJPROP_XDISTANCE,0);
   ObjectSetInteger(0,"v9",OBJPROP_YDISTANCE,162);
   ObjectSetInteger(0,"v9",OBJPROP_XSIZE,292);
   ObjectSetInteger(0,"v9",OBJPROP_YSIZE,1);
   ObjectSetInteger(0,"v9",OBJPROP_BGCOLOR,w);
   ObjectSetInteger(0,"v9",OBJPROP_BORDER_COLOR,wf);
   ObjectSetInteger(0,"v9",OBJPROP_READONLY,1);

// Vertical lines
   ObjectCreate(0,"h1",OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,"h1",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"h1",OBJPROP_XDISTANCE,52);
   ObjectSetInteger(0,"h1",OBJPROP_YDISTANCE,0);
   ObjectSetInteger(0,"h1",OBJPROP_XSIZE,1);
   ObjectSetInteger(0,"h1",OBJPROP_YSIZE,180);
   ObjectSetInteger(0,"h1",OBJPROP_BGCOLOR,w);
   ObjectSetInteger(0,"h1",OBJPROP_BORDER_COLOR,wf);
   ObjectSetInteger(0,"h1",OBJPROP_READONLY,1);

   ObjectCreate(0,"h2",OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,"h2",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"h2",OBJPROP_XDISTANCE,82);
   ObjectSetInteger(0,"h2",OBJPROP_YDISTANCE,0);
   ObjectSetInteger(0,"h2",OBJPROP_XSIZE,1);
   ObjectSetInteger(0,"h2",OBJPROP_YSIZE,180);
   ObjectSetInteger(0,"h2",OBJPROP_BGCOLOR,w);
   ObjectSetInteger(0,"h2",OBJPROP_BORDER_COLOR,wf);
   ObjectSetInteger(0,"h2",OBJPROP_READONLY,1);

   ObjectCreate(0,"h3",OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,"h3",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"h3",OBJPROP_XDISTANCE,112);
   ObjectSetInteger(0,"h3",OBJPROP_YDISTANCE,0);
   ObjectSetInteger(0,"h3",OBJPROP_XSIZE,1);
   ObjectSetInteger(0,"h3",OBJPROP_YSIZE,180);
   ObjectSetInteger(0,"h3",OBJPROP_BGCOLOR,w);
   ObjectSetInteger(0,"h3",OBJPROP_BORDER_COLOR,wf);
   ObjectSetInteger(0,"h3",OBJPROP_READONLY,1);

   ObjectCreate(0,"h4",OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,"h4",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"h4",OBJPROP_XDISTANCE,142);
   ObjectSetInteger(0,"h4",OBJPROP_YDISTANCE,0);
   ObjectSetInteger(0,"h4",OBJPROP_XSIZE,1);
   ObjectSetInteger(0,"h4",OBJPROP_YSIZE,180);
   ObjectSetInteger(0,"h4",OBJPROP_BGCOLOR,w);
   ObjectSetInteger(0,"h4",OBJPROP_BORDER_COLOR,wf);
   ObjectSetInteger(0,"h4",OBJPROP_READONLY,1);

   ObjectCreate(0,"h5",OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,"h5",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"h5",OBJPROP_XDISTANCE,172);
   ObjectSetInteger(0,"h5",OBJPROP_YDISTANCE,0);
   ObjectSetInteger(0,"h5",OBJPROP_XSIZE,1);
   ObjectSetInteger(0,"h5",OBJPROP_YSIZE,180);
   ObjectSetInteger(0,"h5",OBJPROP_BGCOLOR,w);
   ObjectSetInteger(0,"h5",OBJPROP_BORDER_COLOR,wf);
   ObjectSetInteger(0,"h5",OBJPROP_READONLY,1);

   ObjectCreate(0,"h6",OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,"h6",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"h6",OBJPROP_XDISTANCE,202);
   ObjectSetInteger(0,"h6",OBJPROP_YDISTANCE,0);
   ObjectSetInteger(0,"h6",OBJPROP_XSIZE,1);
   ObjectSetInteger(0,"h6",OBJPROP_YSIZE,180);
   ObjectSetInteger(0,"h6",OBJPROP_BGCOLOR,w);
   ObjectSetInteger(0,"h6",OBJPROP_BORDER_COLOR,wf);
   ObjectSetInteger(0,"h6",OBJPROP_READONLY,1);

   ObjectCreate(0,"h7",OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,"h7",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"h7",OBJPROP_XDISTANCE,232);
   ObjectSetInteger(0,"h7",OBJPROP_YDISTANCE,0);
   ObjectSetInteger(0,"h7",OBJPROP_XSIZE,1);
   ObjectSetInteger(0,"h7",OBJPROP_YSIZE,180);
   ObjectSetInteger(0,"h7",OBJPROP_BGCOLOR,w);
   ObjectSetInteger(0,"h7",OBJPROP_BORDER_COLOR,wf);
   ObjectSetInteger(0,"h7",OBJPROP_READONLY,1);

   ObjectCreate(0,"h8",OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,"h8",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"h8",OBJPROP_XDISTANCE,262);
   ObjectSetInteger(0,"h8",OBJPROP_YDISTANCE,0);
   ObjectSetInteger(0,"h8",OBJPROP_XSIZE,1);
   ObjectSetInteger(0,"h8",OBJPROP_YSIZE,180);
   ObjectSetInteger(0,"h8",OBJPROP_BGCOLOR,w);
   ObjectSetInteger(0,"h8",OBJPROP_BORDER_COLOR,wf);
   ObjectSetInteger(0,"h8",OBJPROP_READONLY,1);

// Data
// The first column
   FuncObjectCreate("maxBody",1,19,"MAX B","MAX Body",string2);
   FuncObjectCreate("minBody",1,37,"MIN B","MIN Body",string3);
   FuncObjectCreate("midBody",1,55,"MID B","MID Body",string4);
   FuncObjectCreate("maxUpShadow",1,73,"MAX US","MAX Up Shadow",string5);
   FuncObjectCreate("minUpShadow",1,91,"MIN US","MIN Up Shadow",string6);
   FuncObjectCreate("midUpShadow",1,109,"MID US","MID Up Shadow",string7);
   FuncObjectCreate("maxDownShadow",1,127,"MAX DS","MAX Down Shadow",string8);
   FuncObjectCreate("minDownShadow",1,145,"MIN DS","MIN Down Shadow",string9);
   FuncObjectCreate("midDownShadow",1,163,"MID DS","MID Down Shadow",string10);

// The second column
   if(BarsM1>0)FuncObjectCreate("M1",53,1,"M1","Time Frame M1",string1);
   if(BarsM1>0)FuncObjectCreate("maxBodyM1",53,19,DoubleToString(BodyM1[BodyMaxM1],0),"MAX Body M1",string2);
   if(BarsM1>0)FuncObjectCreate("minBodyM1",53,37,DoubleToString(BodyM1[BodyMinM1],0),"MIN Body M1",string3);
   if(BarsM1>0)FuncObjectCreate("midBodyM1",53,55,DoubleToString(SBodyM1,1),"MID Body M1",string4);
   if(BarsM1>0)FuncObjectCreate("maxUpShadowM1",53,73,DoubleToString(UpShadowM1[UpShadowMaxM1],0),"MAX Up Shadow M1",string5);
   if(BarsM1>0)FuncObjectCreate("minUpShadowM1",53,91,DoubleToString(UpShadowM1[UpShadowMinM1],0),"MIN Up Shadow M1",string6);
   if(BarsM1>0)FuncObjectCreate("midUpShadowM1",53,109,DoubleToString(SUpShadowM1,1),"MID Up Shadow M1",string7);
   if(BarsM1>0)FuncObjectCreate("maxDownShadowM1",53,127,DoubleToString(DownShadowM1[DownShadowMaxM1],0),"MAX Down Shadow M1",string8);
   if(BarsM1>0)FuncObjectCreate("minDownShadowM1",53,145,DoubleToString(DownShadowM1[DownShadowMinM1],0),"MIN Down Shadow M1",string9);
   if(BarsM1>0)FuncObjectCreate("midDownShadowM1",53,163,DoubleToString(SDownShadowM1,1),"MID Down Shadow M1",string10);

// The third column
   if(BarsM5>0)FuncObjectCreate("M5",83,1,"M5","Time Frame M5",string1);
   if(BarsM5>0)FuncObjectCreate("maxBodyM5",83,19,DoubleToString(BodyM5[BodyMaxM5],0),"MAX Body M5",string2);
   if(BarsM5>0)FuncObjectCreate("minBodyM5",83,37,DoubleToString(BodyM5[BodyMinM5],0),"MIN Body M5",string3);
   if(BarsM5>0)FuncObjectCreate("midBodyM5",83,55,DoubleToString(SBodyM5,1),"MID Body M5",string4);
   if(BarsM5>0)FuncObjectCreate("maxUpShadowM5",83,73,DoubleToString(UpShadowM5[UpShadowMaxM5],0),"MAX Up Shadow M5",string5);
   if(BarsM5>0)FuncObjectCreate("minUpShadowM5",83,91,DoubleToString(UpShadowM5[UpShadowMinM5],0),"MIN Up Shadow M5",string6);
   if(BarsM5>0)FuncObjectCreate("midUpShadowM5",83,109,DoubleToString(SUpShadowM5,1),"MID Up Shadow M5",string7);
   if(BarsM5>0)FuncObjectCreate("maxDownShadowM5",83,127,DoubleToString(DownShadowM5[DownShadowMaxM5],0),"MAX Down Shadow M5",string8);
   if(BarsM5>0)FuncObjectCreate("minDownShadowM5",83,145,DoubleToString(DownShadowM5[DownShadowMinM5],0),"MIN Down Shadow M5",string9);
   if(BarsM5>0)FuncObjectCreate("midDownShadowM5",83,163,DoubleToString(SDownShadowM5,1),"MID Down Shadow M5",string10);

// The fourth column
   if(BarsM15>0)FuncObjectCreate("M15",113,1,"M15","Time Frame M15",string1);
   if(BarsM15>0)FuncObjectCreate("maxBodyM15",113,19,DoubleToString(BodyM15[BodyMaxM15],0),"MAX Body M15",string2);
   if(BarsM15>0)FuncObjectCreate("minBodyM15",113,37,DoubleToString(BodyM15[BodyMinM15],0),"MIN Body M15",string3);
   if(BarsM15>0)FuncObjectCreate("midBodyM15",113,55,DoubleToString(SBodyM15,1),"MID Body M15",string4);
   if(BarsM15>0)FuncObjectCreate("maxUpShadowM15",113,73,DoubleToString(UpShadowM15[UpShadowMaxM15],0),"MAX Up Shadow M15",string5);
   if(BarsM15>0)FuncObjectCreate("minUpShadowM15",113,91,DoubleToString(UpShadowM15[UpShadowMinM15],0),"MIN Up Shadow M15",string6);
   if(BarsM15>0)FuncObjectCreate("midUpShadowM15",113,109,DoubleToString(SUpShadowM15,1),"MID Up Shadow M15",string7);
   if(BarsM15>0)FuncObjectCreate("maxDownShadowM15",113,127,DoubleToString(DownShadowM15[DownShadowMaxM15],0),"MAX Down Shadow M15",string8);
   if(BarsM15>0)FuncObjectCreate("minDownShadowM15",113,145,DoubleToString(DownShadowM15[DownShadowMinM15],0),"MIN Down Shadow M15",string9);
   if(BarsM15>0)FuncObjectCreate("midDownShadowM15",113,163,DoubleToString(SDownShadowM15,1),"MID Down Shadow M15",string10);

// The fifth column
   if(BarsM30>0)FuncObjectCreate("M30",143,1,"M30","Time Frame M30",string1);
   if(BarsM30>0)FuncObjectCreate("maxBodyM30",143,19,DoubleToString(BodyM30[BodyMaxM30],0),"MAX Body M30",string2);
   if(BarsM30>0)FuncObjectCreate("minBodyM30",143,37,DoubleToString(BodyM30[BodyMinM30],0),"MIN Body M30",string3);
   if(BarsM30>0)FuncObjectCreate("midBodyM30",143,55,DoubleToString(SBodyM30,1),"MID Body M30",string4);
   if(BarsM30>0)FuncObjectCreate("maxUpShadowM30",143,73,DoubleToString(UpShadowM30[UpShadowMaxM30],0),"MAX Up Shadow M30",string5);
   if(BarsM30>0)FuncObjectCreate("minUpShadowM30",143,91,DoubleToString(UpShadowM30[UpShadowMinM30],0),"MIN Up Shadow M30",string6);
   if(BarsM30>0)FuncObjectCreate("midUpShadowM30",143,109,DoubleToString(SUpShadowM30,1),"MID Up Shadow M30",string7);
   if(BarsM30>0)FuncObjectCreate("maxDownShadowM30",143,127,DoubleToString(DownShadowM30[DownShadowMaxM30],0),"MAX Down Shadow M30",string8);
   if(BarsM30>0)FuncObjectCreate("minDownShadowM30",143,145,DoubleToString(DownShadowM30[DownShadowMinM30],0),"MIN Down Shadow M30",string9);
   if(BarsM30>0)FuncObjectCreate("midDownShadowM30",143,163,DoubleToString(SDownShadowM30,1),"MID Down Shadow M30",string10);

// The sixth column
   if(BarsH1>0)FuncObjectCreate("H1",173,1,"H1","Time Frame H1",string1);
   if(BarsH1>0)FuncObjectCreate("maxBodyH1",173,19,DoubleToString(BodyH1[BodyMaxH1],0),"MAX Body H1",string2);
   if(BarsH1>0)FuncObjectCreate("minBodyH1",173,37,DoubleToString(BodyH1[BodyMinH1],0),"MIN Body H1",string3);
   if(BarsH1>0)FuncObjectCreate("midBodyH1",173,55,DoubleToString(SBodyH1,1),"MID Body H1",string4);
   if(BarsH1>0)FuncObjectCreate("maxUpShadowH1",173,73,DoubleToString(UpShadowH1[UpShadowMaxH1],0),"MAX Up Shadow H1",string5);
   if(BarsH1>0)FuncObjectCreate("minUpShadowH1",173,91,DoubleToString(UpShadowH1[UpShadowMinH1],0),"MIN Up Shadow H1",string6);
   if(BarsH1>0)FuncObjectCreate("midUpShadowH1",173,109,DoubleToString(SUpShadowH1,1),"MID Up Shadow H1",string7);
   if(BarsH1>0)FuncObjectCreate("maxDownShadowH1",173,127,DoubleToString(DownShadowH1[DownShadowMaxH1],0),"MAX Down Shadow H1",string8);
   if(BarsH1>0)FuncObjectCreate("minDownShadowH1",173,145,DoubleToString(DownShadowH1[DownShadowMinH1],0),"MIN Down Shadow H1",string9);
   if(BarsH1>0)FuncObjectCreate("midDownShadowH1",173,163,DoubleToString(SDownShadowH1,1),"MID Down Shadow H1",string10);

// The seventh column
   if(BarsH4>0)FuncObjectCreate("H4",203,1,"H4","Time Frame H4",string1);
   if(BarsH4>0)FuncObjectCreate("maxBodyH4",203,19,DoubleToString(BodyH4[BodyMaxH4],0),"MAX Body H4",string2);
   if(BarsH4>0)FuncObjectCreate("minBodyH4",203,37,DoubleToString(BodyH4[BodyMinH4],0),"MIN Body H4",string3);
   if(BarsH4>0)FuncObjectCreate("midBodyH4",203,55,DoubleToString(SBodyH4,1),"MID Body H4",string4);
   if(BarsH4>0)FuncObjectCreate("maxUpShadowH4",203,73,DoubleToString(UpShadowH4[UpShadowMaxH4],0),"MAX Up Shadow H4",string5);
   if(BarsH4>0)FuncObjectCreate("minUpShadowH4",203,91,DoubleToString(UpShadowH4[UpShadowMinH4],0),"MIN Up Shadow H4",string6);
   if(BarsH4>0)FuncObjectCreate("midUpShadowH4",203,109,DoubleToString(SUpShadowH4,1),"MID Up Shadow H4",string7);
   if(BarsH4>0)FuncObjectCreate("maxDownShadowH4",203,127,DoubleToString(DownShadowH4[DownShadowMaxH4],0),"MAX Down Shadow H4",string8);
   if(BarsH4>0)FuncObjectCreate("minDownShadowH4",203,145,DoubleToString(DownShadowH4[DownShadowMinH4],0),"MIN Down Shadow H4",string9);
   if(BarsH4>0)FuncObjectCreate("midDownShadowH4",203,163,DoubleToString(SDownShadowH4,1),"MID Down Shadow H4",string10);

// The eighth column
   if(BarsW1>0)FuncObjectCreate("W1",233,1,"W1","Time Frame W1",string1);
   if(BarsW1>0)FuncObjectCreate("maxBodyW1",233,19,DoubleToString(BodyW1[BodyMaxW1],0),"MAX Body W1",string2);
   if(BarsW1>0)FuncObjectCreate("minBodyW1",233,37,DoubleToString(BodyW1[BodyMinW1],0),"MIN Body W1",string3);
   if(BarsW1>0)FuncObjectCreate("midBodyW1",233,55,DoubleToString(SBodyW1,0),"MID Body W1",string4);
   if(BarsW1>0)FuncObjectCreate("maxUpShadowW1",233,73,DoubleToString(UpShadowW1[UpShadowMaxW1],0),"MAX Up Shadow W1",string5);
   if(BarsW1>0)FuncObjectCreate("minUpShadowW1",233,91,DoubleToString(UpShadowW1[UpShadowMinW1],0),"MIN Up Shadow W1",string6);
   if(BarsW1>0)FuncObjectCreate("midUpShadowW1",233,109,DoubleToString(SUpShadowW1,0),"MID Up Shadow W1",string7);
   if(BarsW1>0)FuncObjectCreate("maxDownShadowW1",233,127,DoubleToString(DownShadowW1[DownShadowMaxW1],0),"MAX Down Shadow W1",string8);
   if(BarsW1>0)FuncObjectCreate("minDownShadowW1",233,145,DoubleToString(DownShadowW1[DownShadowMinW1],0),"MIN Down Shadow W1",string9);
   if(BarsW1>0)FuncObjectCreate("midDownShadowW1",233,163,DoubleToString(SDownShadowW1,0),"MID Down Shadow W1",string10);

// The ninth column
   if(BarsMN>0)FuncObjectCreate("MN",263,1,"MN","Time Frame MN",string1);
   if(BarsMN>0)FuncObjectCreate("maxBodyMN",263,19,DoubleToString(BodyMN[BodyMaxMN],0),"MAX Body MN",string2);
   if(BarsMN>0)FuncObjectCreate("minBodyMN",263,37,DoubleToString(BodyMN[BodyMinMN],0),"MIN Body MN",string3);
   if(BarsMN>0)FuncObjectCreate("midBodyMN",263,55,DoubleToString(SBodyMN,0),"MID Body MN",string4);
   if(BarsMN>0)FuncObjectCreate("maxUpShadowMN",263,73,DoubleToString(UpShadowMN[UpShadowMaxMN],0),"MAX Up Shadow MN",string5);
   if(BarsMN>0)FuncObjectCreate("minUpShadowMN",263,91,DoubleToString(UpShadowMN[UpShadowMinMN],0),"MIN Up Shadow MN",string6);
   if(BarsMN>0)FuncObjectCreate("midUpShadowMN",263,109,DoubleToString(SUpShadowMN,0),"MID Up Shadow MN",string7);
   if(BarsMN>0)FuncObjectCreate("maxDownShadowMN",263,127,DoubleToString(DownShadowMN[DownShadowMaxMN],0),"MAX Down Shadow MN",string8);
   if(BarsMN>0)FuncObjectCreate("minDownShadowMN",263,145,DoubleToString(DownShadowMN[DownShadowMinMN],0),"MIN Down Shadow MN",string9);
   if(BarsMN>0)FuncObjectCreate("midDownShadowMN",263,163,DoubleToString(SDownShadowMN,0),"MID Down Shadow MN",string10);

   ChartRedraw();

   Sleep(10000); // Falling asleep of the script, especially for the launching it from MetaEditor

  }
//+------------------------------------------------------------------+

// Function for drawing the labels

int FuncObjectCreate(
                     string nameOBJ,
                     int xdistanceOBJ,
                     int ydistanceOBJ,
                     string textOBJ,
                     string tooltipOBJ,
                     color colorOBJ
                     )
  {
   ObjectCreate(0,nameOBJ,OBJ_LABEL,0,0,0);
   ObjectSetInteger(0,nameOBJ,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,nameOBJ,OBJPROP_ANCHOR,ANCHOR_LEFT_UPPER);
   ObjectSetInteger(0,nameOBJ,OBJPROP_XDISTANCE,xdistanceOBJ);
   ObjectSetInteger(0,nameOBJ,OBJPROP_YDISTANCE,ydistanceOBJ);
   ObjectSetString(0,nameOBJ,OBJPROP_TEXT,textOBJ);
   ObjectSetString(0,nameOBJ,OBJPROP_TOOLTIP,tooltipOBJ);
   ObjectSetString(0,nameOBJ,OBJPROP_FONT,"Arial");
   ObjectSetInteger(0,nameOBJ,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,nameOBJ,OBJPROP_COLOR,colorOBJ);

   return(0);
  }
//+------------------------------------------------------------------+
