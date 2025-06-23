//+------------------------------------------------------------------+
//|                                               Bar Prediction.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                       saeed.h.mashhadi@gmail.com |
//+------------------------------------------------------------------+
#property link        "Author: saeed.h.mashhadi@gmail.com"
#property version     "1.00"
#property description "The script estimates the bar's High-Low-Close, based on the past."
#property script_show_inputs

#define NAME "Bar Prediction"

//+------------------------------------------------------------------+
//| Script inputs & global variables                                 |
//+------------------------------------------------------------------+
input int Prediction_Bar =0;  // Prediction Bar >= -1
input int Win            =10; // Comparision Length > 0
input int Num            =7;  // Prediction Bars # > 0

datetime time[];
MqlRates Rates[];

//+------------------------------------------------------------------+
//| Script "Start" event handler function                            |
//+------------------------------------------------------------------+
void OnStart()
  {
//Print("OnStart");
   MathSrand(GetTickCount());
   double Objects_Identifier=MathRand();

   ArraySetAsSeries(time,true);
   ArraySetAsSeries(Rates,true);
   int Series_Bars=(int)SeriesInfoInteger(Symbol(),0,SERIES_BARS_COUNT);
   CopyTime(Symbol(),NULL,0,MathMin(1000000,Series_Bars),time);
   int rates_total=ArraySize(time);
   CopyRates(NULL,0,0,rates_total,Rates);

   double Array_Ref[][4];
   double Array_Test[][4];
   double Array_Error[][2];
   ArrayResize(Array_Ref,Win);
   ArrayResize(Array_Test,Win);
   ArrayResize(Array_Error,rates_total-Prediction_Bar-Win-1);
   ArrayFill(Array_Error,0,ArraySize(Array_Error),0);

   for(int ii=0; ii<Win; ii++)
     {
      Array_Ref[ii][0]=Rates[Prediction_Bar+1+ii].open/Rates[Prediction_Bar+1].close;
      Array_Ref[ii][1]=Rates[Prediction_Bar+1+ii].high/Rates[Prediction_Bar+1].close;
      Array_Ref[ii][2]=Rates[Prediction_Bar+1+ii].low/Rates[Prediction_Bar+1].close;
      Array_Ref[ii][3]=Rates[Prediction_Bar+1+ii].close/Rates[Prediction_Bar+1].close;
      //Print(ii," | ",Array_Ref[ii][0]," | ",Array_Ref[ii][1]," | ",Array_Ref[ii][2]," | ",Array_Ref[ii][3]);
     }

   for(int jj=0; jj<rates_total-Prediction_Bar-Win-1; jj++)
     {
      Array_Error[jj][1]=jj;
      for(int ii=0; ii<Win; ii++)
        {
         Array_Test[ii][0]=Rates[Prediction_Bar+1+jj+ii].open/Rates[Prediction_Bar+1+jj].close;
         Array_Test[ii][1]=Rates[Prediction_Bar+1+jj+ii].high/Rates[Prediction_Bar+1+jj].close;
         Array_Test[ii][2]=Rates[Prediction_Bar+1+jj+ii].low/Rates[Prediction_Bar+1+jj].close;
         Array_Test[ii][3]=Rates[Prediction_Bar+1+jj+ii].close/Rates[Prediction_Bar+1+jj].close;
         Array_Error[jj][0]=Array_Error[jj][0]+0.0*MathAbs(Array_Test[ii][0]-Array_Ref[ii][0])+1.0*MathAbs(Array_Test[ii][1]-Array_Ref[ii][1])
                            +1.0*MathAbs(Array_Test[ii][2]-Array_Ref[ii][2])+1.0*MathAbs(Array_Test[ii][3]-Array_Ref[ii][3]);
         //Print(jj," | ",ii," | ",Array_Test[ii][0]," | ",Array_Test[ii][1]," | ",Array_Test[ii][2]," | ",Array_Test[ii][3]);
        }
      //Print(jj," | ",Array_Error[jj][0]);
     }
   ArraySort(Array_Error);

   double High, Low, Close;
   int Index=(int)Array_Error[1][1];
   for(int ii=0; ii<rates_total-1-(Prediction_Bar+1+Index); ii++)
     {
      High=Rates[Prediction_Bar+1+Index+ii].high/Rates[Prediction_Bar+1+Index].close*Rates[Prediction_Bar+1].close;
      Low=Rates[Prediction_Bar+1+Index+ii].low/Rates[Prediction_Bar+1+Index].close*Rates[Prediction_Bar+1].close;
      Close=Rates[Prediction_Bar+1+Index+ii].close/Rates[Prediction_Bar+1+Index].close*Rates[Prediction_Bar+1].close;

      ObjectCreate(0,StringFormat("%g_%s_Bar1_%g",Objects_Identifier,NAME,ii),OBJ_TREND,0,time[Prediction_Bar+1+ii],High,time[Prediction_Bar+1+ii],Low);
      ObjectSetInteger(0,StringFormat("%g_%s_Bar1_%g",Objects_Identifier,NAME,ii),OBJPROP_WIDTH,5);
      ObjectSetInteger(0,StringFormat("%g_%s_Bar1_%g",Objects_Identifier,NAME,ii),OBJPROP_COLOR,clrAqua);
      ObjectSetInteger(0,StringFormat("%g_%s_Bar1_%g",Objects_Identifier,NAME,ii),OBJPROP_BACK,true);
      ObjectSetInteger(0,StringFormat("%g_%s_Bar1_%g",Objects_Identifier,NAME,ii),OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,StringFormat("%g_%s_Bar1_%g",Objects_Identifier,NAME,ii),OBJPROP_SELECTED,false);

      ObjectCreate(0,StringFormat("%g_%s_Close1_%g",Objects_Identifier,NAME,ii),OBJ_TREND,0,time[Prediction_Bar+1+ii],Close,time[Prediction_Bar+1+ii],Close);
      ObjectSetInteger(0,StringFormat("%g_%s_Close1_%g",Objects_Identifier,NAME,ii),OBJPROP_WIDTH,7);
      ObjectSetInteger(0,StringFormat("%g_%s_Close1_%g",Objects_Identifier,NAME,ii),OBJPROP_COLOR,clrDarkOrange);
      ObjectSetInteger(0,StringFormat("%g_%s_Close1_%g",Objects_Identifier,NAME,ii),OBJPROP_BACK,true);
      ObjectSetInteger(0,StringFormat("%g_%s_Close1_%g",Objects_Identifier,NAME,ii),OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,StringFormat("%g_%s_Close1_%g",Objects_Identifier,NAME,ii),OBJPROP_SELECTED,false);
     }

   datetime Time, dt=MathMin(time[0]-time[1],MathMin(time[1]-time[2],MathMin(time[2]-time[3],MathMin(time[3]-time[4],MathMin(time[4]-time[5],time[5]-time[6])))));
   for(int ii=1; ii<=Num; ii++)
     {
      Index=(int)Array_Error[ii][1];
      Time=time[Prediction_Bar+1]+ii*dt;
      High=Rates[Prediction_Bar+Index].high/Rates[Prediction_Bar+1+Index].close*Rates[Prediction_Bar+1].close;
      Low=Rates[Prediction_Bar+Index].low/Rates[Prediction_Bar+1+Index].close*Rates[Prediction_Bar+1].close;
      Close=Rates[Prediction_Bar+Index].close/Rates[Prediction_Bar+1+Index].close*Rates[Prediction_Bar+1].close;

      if(ii==1)
        {
         ObjectCreate(0,StringFormat("%g_%s_Ref_%g",Objects_Identifier,NAME,ii),OBJ_VLINE,0,Time,Close);
         ObjectSetInteger(0,StringFormat("%g_%s_Ref_%g",Objects_Identifier,NAME,ii),OBJPROP_WIDTH,2);
         ObjectSetInteger(0,StringFormat("%g_%s_Ref_%g",Objects_Identifier,NAME,ii),OBJPROP_COLOR,clrDarkOrange);
         ObjectSetInteger(0,StringFormat("%g_%s_Ref_%g",Objects_Identifier,NAME,ii),OBJPROP_BACK,true);
         ObjectSetInteger(0,StringFormat("%g_%s_Ref_%g",Objects_Identifier,NAME,ii),OBJPROP_SELECTABLE,false);
         ObjectSetInteger(0,StringFormat("%g_%s_Ref_%g",Objects_Identifier,NAME,ii),OBJPROP_SELECTED,false);
        }

      ObjectCreate(0,StringFormat("%g_%s_Bar2_%g",Objects_Identifier,NAME,ii),OBJ_TREND,0,Time,High,Time,Low);
      ObjectSetInteger(0,StringFormat("%g_%s_Bar2_%g",Objects_Identifier,NAME,ii),OBJPROP_WIDTH,5);
      ObjectSetInteger(0,StringFormat("%g_%s_Bar2_%g",Objects_Identifier,NAME,ii),OBJPROP_COLOR,clrLime);
      ObjectSetInteger(0,StringFormat("%g_%s_Bar2_%g",Objects_Identifier,NAME,ii),OBJPROP_BACK,true);
      ObjectSetInteger(0,StringFormat("%g_%s_Bar2_%g",Objects_Identifier,NAME,ii),OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,StringFormat("%g_%s_Bar2_%g",Objects_Identifier,NAME,ii),OBJPROP_SELECTED,false);

      ObjectCreate(0,StringFormat("%g_%s_Close2_%g",Objects_Identifier,NAME,ii),OBJ_TREND,0,Time,Close,Time,Close);
      ObjectSetInteger(0,StringFormat("%g_%s_Close2_%g",Objects_Identifier,NAME,ii),OBJPROP_WIDTH,7);
      ObjectSetInteger(0,StringFormat("%g_%s_Close2_%g",Objects_Identifier,NAME,ii),OBJPROP_COLOR,clrDarkOrange);
      ObjectSetInteger(0,StringFormat("%g_%s_Close2_%g",Objects_Identifier,NAME,ii),OBJPROP_BACK,true);
      ObjectSetInteger(0,StringFormat("%g_%s_Close2_%g",Objects_Identifier,NAME,ii),OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,StringFormat("%g_%s_Close2_%g",Objects_Identifier,NAME,ii),OBJPROP_SELECTED,false);
     }
   return;
  }
//+------------------------------------------------------------------+
