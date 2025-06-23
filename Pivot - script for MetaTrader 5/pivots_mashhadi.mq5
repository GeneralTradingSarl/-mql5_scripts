//+------------------------------------------------------------------+
//|                                                       Pivots.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                       saeed.h.mashhadi@gmail.com |
//+------------------------------------------------------------------+
#property link        "Author: saeed.h.mashhadi@gmail.com"
#property version     "1.1"
#property description "Pivots based on the stream similarity."
#property script_show_inputs

#define NAME "Pivots"

//+------------------------------------------------------------------+
//| Script inputs & global variables                                 |
//+------------------------------------------------------------------+
input int Pivot_Num =5;  // Pivot # > 0
input int Win       =10; // Comparision Length > 0
input int Width     =1;  // Line Width

datetime time[];
MqlRates Rates[];

//+------------------------------------------------------------------+
//| Script "Start" event handler function                            |
//+------------------------------------------------------------------+
void OnStart()
  {
   MathSrand(GetTickCount());
   double Objects_Identifier=MathRand();
   
   ArraySetAsSeries(time,true);
   ArraySetAsSeries(Rates,true);
   int Series_Bars=(int)SeriesInfoInteger(Symbol(),0,SERIES_BARS_COUNT);
   CopyTime(Symbol(),Period(),0,MathMin(Series_Bars,INT_MAX),time);
   int rates_total=ArraySize(time);
   CopyRates(Symbol(),Period(),0,rates_total,Rates);

   for (int kk=-1; kk<=MathMin(INT_MAX,rates_total-Win-Pivot_Num-2); kk++)
     {
      int Prediction_Bar=kk;
      double Array_Ref[][4];
      double Array_Test[][4];
      double Array_Error[][2];
      ArrayResize(Array_Ref,Win);
      ArrayResize(Array_Test,Win);
      ArrayResize(Array_Error,rates_total-Prediction_Bar-Win-1);
      ArrayFill(Array_Error,0,ArraySize(Array_Error),0);

      for (int ii=0; ii<Win; ii++)
        {
         Array_Ref[ii][0]=Rates[Prediction_Bar+1+ii].open/Rates[Prediction_Bar+1].close;
         Array_Ref[ii][1]=Rates[Prediction_Bar+1+ii].high/Rates[Prediction_Bar+1].close;
         Array_Ref[ii][2]=Rates[Prediction_Bar+1+ii].low/Rates[Prediction_Bar+1].close;
         Array_Ref[ii][3]=Rates[Prediction_Bar+1+ii].close/Rates[Prediction_Bar+1].close;
         //Print(ii," | ",Array_Ref[ii][0]," | ",Array_Ref[ii][1]," | ",Array_Ref[ii][2]," | ",Array_Ref[ii][3]);
        }

      for (int jj=0; jj<rates_total-Prediction_Bar-Win-1; jj++)
        {
         Array_Error[jj][1]=jj;
         for (int ii=0; ii<Win; ii++)
           {
            Array_Test[ii][0]=Rates[Prediction_Bar+1+jj+ii].open/Rates[Prediction_Bar+1+jj].close;
            Array_Test[ii][1]=Rates[Prediction_Bar+1+jj+ii].high/Rates[Prediction_Bar+1+jj].close;
            Array_Test[ii][2]=Rates[Prediction_Bar+1+jj+ii].low/Rates[Prediction_Bar+1+jj].close;
            Array_Test[ii][3]=Rates[Prediction_Bar+1+jj+ii].close/Rates[Prediction_Bar+1+jj].close;
            Array_Error[jj][0]=Array_Error[jj][0]+(0.0*MathAbs(Array_Test[ii][0]-Array_Ref[ii][0])+1.0*MathAbs(Array_Test[ii][1]-Array_Ref[ii][1])
                                                  +1.0*MathAbs(Array_Test[ii][2]-Array_Ref[ii][2])+1.0*MathAbs(Array_Test[ii][3]-Array_Ref[ii][3]))/(0.0+1.0+1.0+1.0);
            //Print(jj," | ",ii," | ",Array_Test[ii][0]," | ",Array_Test[ii][1]," | ",Array_Test[ii][2]," | ",Array_Test[ii][3]);
           }
         Array_Error[jj][0]=Array_Error[jj][0]/((double)Win);
         //Print(jj," | ",Array_Error[jj][0]);
        }
      ArraySort(Array_Error);

      int Index=(int)Array_Error[1][1];
      double High, Low, HHigh=-DBL_MAX, LLow=+DBL_MAX;
      for (int ii=0; ii<rates_total-1-(Prediction_Bar+1+Index); ii++)
        {
         High=Rates[Prediction_Bar+1+Index+ii].high/Rates[Prediction_Bar+1+Index].close*Rates[Prediction_Bar+1].close;
         Low=Rates[Prediction_Bar+1+Index+ii].low/Rates[Prediction_Bar+1+Index].close*Rates[Prediction_Bar+1].close;
        }

      datetime dt=MathMin(time[0]-time[1],MathMin(time[1]-time[2],MathMin(time[2]-time[3],MathMin(time[3]-time[4],MathMin(time[4]-time[5],time[5]-time[6])))));
      datetime Time1=iTime(NULL,0,MathMax(Prediction_Bar,0))+(datetime)(MathMax(-Prediction_Bar,0)*dt);
      datetime Time2=iTime(NULL,0,MathMax(Prediction_Bar-1,0))+(datetime)(MathMax(-Prediction_Bar+1,0)*dt);

      for (int ii=1; ii<=Pivot_Num; ii++)
        {
         Index=(int)Array_Error[ii][1];
         High=Rates[Prediction_Bar+Index].high/Rates[Prediction_Bar+1+Index].close*Rates[Prediction_Bar+1].close;
         Low=Rates[Prediction_Bar+Index].low/Rates[Prediction_Bar+1+Index].close*Rates[Prediction_Bar+1].close;
         HHigh=MathMax(HHigh,High);
         LLow=MathMin(LLow,Low);

         if (ii==Pivot_Num)
           {
            ObjectCreate(0,StringFormat("%g_%s_Area1_%g_%g",Objects_Identifier,NAME,kk,ii),OBJ_RECTANGLE,0,Time1,LLow,Time2,HHigh);
            ObjectSetInteger(0,StringFormat("%g_%s_Area1_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_FILL,true);
            ObjectSetInteger(0,StringFormat("%g_%s_Area1_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_WIDTH,1);
            ObjectSetInteger(0,StringFormat("%g_%s_Area1_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_COLOR,clrYellow);
            ObjectSetInteger(0,StringFormat("%g_%s_Area1_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_BACK,true);
            ObjectSetInteger(0,StringFormat("%g_%s_Area1_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_SELECTABLE,false);
            ObjectSetInteger(0,StringFormat("%g_%s_Area1_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_SELECTED,false);
         
            ObjectCreate(0,StringFormat("%g_%s_Area2_%g_%g",Objects_Identifier,NAME,kk,ii),OBJ_RECTANGLE,0,Time1,LLow,Time2,HHigh);
            ObjectSetInteger(0,StringFormat("%g_%s_Area2_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_FILL,false);
            ObjectSetInteger(0,StringFormat("%g_%s_Area2_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_WIDTH,1);
            ObjectSetInteger(0,StringFormat("%g_%s_Area2_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_COLOR,clrDarkOrange);
            ObjectSetInteger(0,StringFormat("%g_%s_Area2_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_BACK,true);
            ObjectSetInteger(0,StringFormat("%g_%s_Area2_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_SELECTABLE,false);
            ObjectSetInteger(0,StringFormat("%g_%s_Area2_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_SELECTED,false);
           }
   
         ObjectCreate(0,StringFormat("%g_%s_High_%g_%g",Objects_Identifier,NAME,kk,ii),OBJ_TREND,0,Time1,High,Time2,High);
         ObjectSetInteger(0,StringFormat("%g_%s_High_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_WIDTH,Width);
         ObjectSetInteger(0,StringFormat("%g_%s_High_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_COLOR,clrRed); //clrRed
         ObjectSetInteger(0,StringFormat("%g_%s_High_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_BACK,false);
         ObjectSetInteger(0,StringFormat("%g_%s_High_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_SELECTABLE,false);
         ObjectSetInteger(0,StringFormat("%g_%s_High_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_SELECTED,false);
      
         ObjectCreate(0,StringFormat("%g_%s_Low_%g_%g",Objects_Identifier,NAME,kk,ii),OBJ_TREND,0,Time1,Low,Time2,Low);
         ObjectSetInteger(0,StringFormat("%g_%s_Low_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_WIDTH,Width);
         ObjectSetInteger(0,StringFormat("%g_%s_Low_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_COLOR,clrBlue); //clrBlue
         ObjectSetInteger(0,StringFormat("%g_%s_Low_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_BACK,false);
         ObjectSetInteger(0,StringFormat("%g_%s_Low_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_SELECTABLE,false);
         ObjectSetInteger(0,StringFormat("%g_%s_Low_%g_%g",Objects_Identifier,NAME,kk,ii),OBJPROP_SELECTED,false);
        }
      ArrayFree(Array_Ref);
      ArrayFree(Array_Test);
      ArrayFree(Array_Error);
     }
   PlaySound("\\Sounds\\wait.wav");
   return;
  }