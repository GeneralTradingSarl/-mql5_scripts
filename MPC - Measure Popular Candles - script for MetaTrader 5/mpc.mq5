//+------------------------------------------------------------------+
//|                                                          MPC.mq5 |
//|                                            Aktiniy ICQ:695710750 |
//|                                                    ICQ:695710750 |
//+------------------------------------------------------------------+
#property copyright "Aktiniy ICQ:695710750"
#property link      "ICQ:695710750"
#property version   "1.00"
#property script_show_inputs
//--- input parameters

//Measure Popular Candles

input int      CandleBegin=0;
input int      CandleEnd=1000;
input int      BodyBegin=0;
input int      BodyEnd=50;
input int      ShadowBegin=0;
input int      ShadowEnd=50;
input int      DivisionsNumber=25;
input color    BodyColor=clrRed;
input color    ShadowUpColor=clrRed;
input color    ShadowDownColor=clrRed;
input int      FactorBody=10;
input int      FactorShadow=10;
input int      XDistanceBody=5;
input int      XDistanceShadowUp=150;
input int      XDistanceShadowDown=300;
input int      TimeEnd=100000; // Parameter to run from MetaEditor, delay up to close the window
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---

   int CandleBuffer=CandleEnd-CandleBegin;

   double AOpen[];
   double AClose[];
   double AHigh[];
   double ALow[];

   ArrayResize(AOpen,CandleBuffer);
   ArrayResize(AClose,CandleBuffer);
   ArrayResize(AHigh,CandleBuffer);
   ArrayResize(ALow,CandleBuffer);

   CopyOpen(Symbol(),Period(),CandleBegin,CandleBuffer,AOpen);
   CopyClose(Symbol(),Period(),CandleBegin,CandleBuffer,AClose);
   CopyHigh(Symbol(),Period(),CandleBegin,CandleBuffer,AHigh);
   CopyLow(Symbol(),Period(),CandleBegin,CandleBuffer,ALow);

   double ABody[];
   double AShadowUp[];
   double AShadowDown[];

   ArrayResize(ABody,CandleBuffer);
   ArrayResize(AShadowUp,CandleBuffer);
   ArrayResize(AShadowDown,CandleBuffer);

// Tick size calculation
   double tick=SymbolInfoDouble(Symbol(),SYMBOL_TRADE_TICK_SIZE);

// Calculation with array filling which containing information about bodies and shadows of the candlesticks
   for(int x=0; x<CandleBuffer; x++)
     {
      if(AOpen[x]>AClose[x])
        {
         ABody[x]=(AOpen[x]-AClose[x])/tick;
         AShadowUp[x]=(AHigh[x]-AOpen[x])/tick;
         AShadowDown[x]=(AClose[x]-ALow[x])/tick;
        }
      if(AClose[x]>AOpen[x])
        {
         ABody[x]=(AClose[x]-AOpen[x])/tick;
         AShadowUp[x]=(AHigh[x]-AClose[x])/tick;
         AShadowDown[x]=(AOpen[x]-ALow[x])/tick;
        }
      if(AClose[x]==AOpen[x])
        {
         ABody[x]=0;
         AShadowUp[x]=(AHigh[x]-AOpen[x])/tick;
         AShadowDown[x]=(AOpen[x]-ALow[x])/tick;
        }
     }

   double AddBody=(BodyEnd-BodyBegin)/DivisionsNumber;
   double AddShadow=(ShadowEnd-ShadowBegin)/DivisionsNumber;

   double APBody[];
   double APShadowUp[];
   double APShadowDown[];

   ArrayResize(APBody,DivisionsNumber);
   ArrayResize(APShadowUp,DivisionsNumber);
   ArrayResize(APShadowDown,DivisionsNumber);

// Calculation a number of candlesticks by sizes
   for(int x=0; x<CandleBuffer; x++)
     {
      double Body=BodyBegin;
      double ShadowUp=ShadowBegin;
      double ShadowDown=ShadowBegin;
      for(int y=0; y<DivisionsNumber; y++)
        {
         if(ABody[x]>=Body && ABody[x]<Body+AddBody) APBody[y]++;
         Body=Body+AddBody;
         if(AShadowUp[x]>=ShadowUp && AShadowUp[x]<ShadowUp+AddShadow) APShadowUp[y]++;
         ShadowUp=ShadowUp+AddShadow;
         if(AShadowDown[x]>=ShadowDown && AShadowDown[x]<ShadowDown+AddShadow) APShadowDown[y]++;
         ShadowDown=ShadowDown+AddShadow;
        }
     }

// Candlesticks appearance percent calculation
   for(int x=0; x<DivisionsNumber; x++)
     {
      APBody[x]=APBody[x]/CandleBuffer*100;
      APShadowUp[x]=APShadowUp[x]/CandleBuffer*100;
      APShadowDown[x]=APShadowDown[x]/CandleBuffer*100;
     }

   string ADBody[];
   string ADShadowUp[];
   string ADShadowDown[];

   ArrayResize(ADBody,DivisionsNumber);
   ArrayResize(ADShadowUp,DivisionsNumber);
   ArrayResize(ADShadowDown,DivisionsNumber);

   double Body=BodyBegin;
   double ShadowUp=ShadowBegin;
   double ShadowDown=ShadowBegin;

// Create a description for the each line of sscales
   for(int x=0; x<DivisionsNumber; x++)
     {
      ADBody[x]="from "+DoubleToString(Body,2)+" to "+DoubleToString(Body+AddBody,2)+" Percent "+DoubleToString(APBody[x],2);
      Body=Body+AddBody;
      ADShadowUp[x]="from "+DoubleToString(ShadowUp,2)+" to "+DoubleToString(ShadowUp+AddShadow,2)+" Percent "+DoubleToString(APShadowUp[x],2);
      ShadowUp=ShadowUp+AddShadow;
      ADShadowDown[x]="from "+DoubleToString(ShadowDown,2)+" to "+DoubleToString(ShadowDown+AddShadow,2)+" Percent "+DoubleToString(APShadowDown[x],2);
      ShadowDown=ShadowDown+AddShadow;
     }

   int f=0;

// Scales names drawing
   ObjectCreate(0,"Body",OBJ_LABEL,0,XDistanceBody,14);
   ObjectSetInteger(0,"Body",OBJPROP_XDISTANCE,XDistanceBody);
   ObjectSetInteger(0,"Body",OBJPROP_YDISTANCE,14);
   ObjectSetString(0,"Body",OBJPROP_TEXT,"Body");
   ObjectSetString(0,"Body",OBJPROP_TOOLTIP,"Body");
   ObjectSetString(0,"Body",OBJPROP_FONT,"Arial");
   ObjectSetInteger(0,"Body",OBJPROP_COLOR,BodyColor);
   ObjectSetInteger(0,"Body",OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,"Body",OBJPROP_SELECTED,false);

   ObjectCreate(0,"ShadowUp",OBJ_LABEL,0,XDistanceShadowUp,14);
   ObjectSetInteger(0,"ShadowUp",OBJPROP_XDISTANCE,XDistanceShadowUp);
   ObjectSetInteger(0,"ShadowUp",OBJPROP_YDISTANCE,14);
   ObjectSetString(0,"ShadowUp",OBJPROP_TEXT,"ShadowUp");
   ObjectSetString(0,"ShadowUp",OBJPROP_TOOLTIP,"ShadowUp");
   ObjectSetString(0,"ShadowUp",OBJPROP_FONT,"Arial");
   ObjectSetInteger(0,"ShadowUp",OBJPROP_COLOR,ShadowUpColor);
   ObjectSetInteger(0,"ShadowUp",OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,"ShadowUp",OBJPROP_SELECTED,false);

   ObjectCreate(0,"ShadowDown",OBJ_LABEL,0,XDistanceShadowDown,14);
   ObjectSetInteger(0,"ShadowDown",OBJPROP_XDISTANCE,XDistanceShadowDown);
   ObjectSetInteger(0,"ShadowDown",OBJPROP_YDISTANCE,14);
   ObjectSetString(0,"ShadowDown",OBJPROP_TEXT,"ShadowDown");
   ObjectSetString(0,"ShadowDown",OBJPROP_TOOLTIP,"ShadowDown");
   ObjectSetString(0,"ShadowDown",OBJPROP_FONT,"Arial");
   ObjectSetInteger(0,"ShadowDown",OBJPROP_COLOR,ShadowDownColor);
   ObjectSetInteger(0,"ShadowDown",OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,"ShadowDown",OBJPROP_SELECTED,false);

// Scales drawing
   for(int x=0; x<DivisionsNumber; x++)
     {

      ObjectCreate(0,ADBody[x],OBJ_EDIT,0,XDistanceBody,32);
      ObjectSetInteger(0,ADBody[x],OBJPROP_XDISTANCE,XDistanceBody);
      ObjectSetInteger(0,ADBody[x],OBJPROP_YDISTANCE,32+f);
      ObjectSetInteger(0,ADBody[x],OBJPROP_BORDER_COLOR,BodyColor);
      ObjectSetInteger(0,ADBody[x],OBJPROP_YSIZE,1);
      ObjectSetInteger(0,ADBody[x],OBJPROP_XSIZE,APBody[x]*FactorBody);
      ObjectSetString(0,ADBody[x],OBJPROP_TOOLTIP,ADBody[x]);

      ObjectCreate(0,ADShadowUp[x],OBJ_EDIT,0,XDistanceShadowUp,32);
      ObjectSetInteger(0,ADShadowUp[x],OBJPROP_XDISTANCE,XDistanceShadowUp);
      ObjectSetInteger(0,ADShadowUp[x],OBJPROP_YDISTANCE,32+f);
      ObjectSetInteger(0,ADShadowUp[x],OBJPROP_BORDER_COLOR,ShadowUpColor);
      ObjectSetInteger(0,ADShadowUp[x],OBJPROP_YSIZE,1);
      ObjectSetInteger(0,ADShadowUp[x],OBJPROP_XSIZE,APShadowUp[x]*FactorBody);
      ObjectSetString(0,ADShadowUp[x],OBJPROP_TOOLTIP,ADShadowUp[x]);

      ObjectCreate(0,ADShadowDown[x],OBJ_EDIT,0,XDistanceShadowDown,32);
      ObjectSetInteger(0,ADShadowDown[x],OBJPROP_XDISTANCE,XDistanceShadowDown);
      ObjectSetInteger(0,ADShadowDown[x],OBJPROP_YDISTANCE,32+f);
      ObjectSetInteger(0,ADShadowDown[x],OBJPROP_BORDER_COLOR,ShadowDownColor);
      ObjectSetInteger(0,ADShadowDown[x],OBJPROP_YSIZE,1);
      ObjectSetInteger(0,ADShadowDown[x],OBJPROP_XSIZE,APShadowDown[x]*FactorBody);
      ObjectSetString(0,ADShadowDown[x],OBJPROP_TOOLTIP,ADShadowDown[x]);

      f=f+2;

     }

// Chart redrawing
ChartRedraw();

// Waiting until the window is closed, when start from MetaEditor
Sleep(TimeEnd);

  }
//+------------------------------------------------------------------+
