#property copyright "Integer"
#property link      "http://dmffx.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   long h[];
   int Charts;

   Charts=fChartGetIDList(h);

   long FVBFL[];
   long MSH[];
   long LS[];
   datetime tm[1];
   datetime tm2[];

   ArrayResize(FVBFL,Charts);
   ArrayResize(MSH,Charts);
   ArrayResize(LS,Charts);

   for(int i=0;i<Charts;i++)
     {
      ChartSetInteger(h[i],CHART_AUTOSCROLL,false);
      ChartSetInteger(h[i],CHART_SHIFT,true);
      ChartRedraw(h[i]);
      FVBFL[i]=fChartGetLeftVisBarFromLeft(h[i]);
      MSH[i]=fChartGetMarkerShift(h[i]);
      LS[i]=ChartGetInteger(h[i],CHART_SCALE);
     }

   long MainChartID=ChartID();
   long MainChartMarkerShift=fChartGetMarkerShift(ChartID());
   int MainIndex;

   MainIndex=0;
   for(int i=0;i<Charts;i++)
     {
      if(MainChartID==h[i])
        {
         MainIndex=i;
         break;
        }
     }

   datetime LT=0;

   while(!IsStopped())
     {

      bool f=false;

      for(int i=0;i<Charts;i++)
        {
         ChartRedraw(h[i]);
         if(LS[i]!=ChartGetInteger(h[i],CHART_SCALE))
           {
            LS[i]=ChartGetInteger(h[i],CHART_SCALE);
            MSH[i]=fChartGetMarkerShift(h[i]);
            f=true;
           }
         long fvbfl=fChartGetLeftVisBarFromLeft(h[i]);
         if(fvbfl>0 && fvbfl!=FVBFL[i])
           {
            if(MainChartID!=h[i])
              {
               MainChartID=h[i];
               MainChartMarkerShift=MSH[i];
               MainIndex=i;
              }
            FVBFL[i]=fvbfl;
           }
        }

      MainChartMarkerShift=MSH[MainIndex];
      long MainIndexAtMarker=ChartGetInteger(MainChartID,CHART_FIRST_VISIBLE_BAR)-MainChartMarkerShift;
      if(MainIndexAtMarker<0)MainIndexAtMarker=0;
      CopyTime(ChartSymbol(MainChartID),ChartPeriod(MainChartID),int(MainIndexAtMarker),1,tm);
      fObjVLine(MQL5InfoString(MQL5_PROGRAM_NAME)+"_1_"+IntegerToString(MainIndex),tm[0],"",0,Blue,1,STYLE_SOLID,MainChartID,true,true,false,OBJ_ALL_PERIODS);
      fObjVLine(MQL5InfoString(MQL5_PROGRAM_NAME)+"_2_"+IntegerToString(MainIndex),tm[0],"",0,Red,1,STYLE_DOT,MainChartID,false,true,false,OBJ_ALL_PERIODS);
      ChartRedraw(MainChartID);
      if(LT!=tm[0] || f)
        {
         LT=tm[0];
         for(int j=0;j<Charts;j++)
           {
            if(MainChartID!=h[j])
              {
               ArrayResize(tm2,Bars(ChartSymbol(h[j]),ChartPeriod(h[j])));
               CopyTime(ChartSymbol(h[j]),ChartPeriod(h[j]),0,Bars(ChartSymbol(h[j]),ChartPeriod(h[j])),tm2);
               int p=ArrayBsearch(tm2,tm[0]);
               if(p<0)
                 {
                  p=0;
                 }
               if(p>=ArraySize(tm2))
                 {
                  p=ArraySize(tm2)-1;
                 }
               if(tm2[p]>tm[0])
                 {
                  p--;
                 }
               if(p<0)
                 {
                  p=0;
                 }
               long a=Bars(ChartSymbol(h[j]),ChartPeriod(h[j]))-p-1;
               ChartNavigate(h[j],CHART_END,int(a));
               fObjVLine(MQL5InfoString(MQL5_PROGRAM_NAME)+"_1_"+IntegerToString(j),tm2[p],"",0,Blue,1,STYLE_SOLID,h[j],true,true,false,OBJ_ALL_PERIODS);
               fObjVLine(MQL5InfoString(MQL5_PROGRAM_NAME)+"_2_"+IntegerToString(j),tm2[p],"",0,Red,1,STYLE_DOT,h[j],false,true,false,OBJ_ALL_PERIODS);
               ChartRedraw(h[j]);
               long x=fChartGetLeftVisBarFromLeft(h[j]);
               if(x>0)FVBFL[j]=x;

              }
           }
        }

      Sleep(1);

     }

   Comment("");

   for(int i=0;i<Charts;i++)
     {
      fObjDeleteByPrefix(MQL5InfoString(MQL5_PROGRAM_NAME),h[i]);
     }

   return;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long fChartGetMarkerShift(long aChartID)
  {
   long LeftBar=ChartGetInteger(aChartID,CHART_FIRST_VISIBLE_BAR);
   ChartNavigate(aChartID,CHART_END,0);
   ChartRedraw(aChartID);
   long MarkerShift=ChartGetInteger(aChartID,CHART_FIRST_VISIBLE_BAR);
   ChartNavigate(aChartID,CHART_END,int(LeftBar-MarkerShift));
   ChartRedraw(aChartID);
   return(MarkerShift);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long fChartGetLeftVisBarFromLeft(long aChartID)
  {
   return(Bars(ChartSymbol(aChartID),ChartPeriod(aChartID))-1-ChartGetInteger(aChartID,CHART_FIRST_VISIBLE_BAR));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int fChartGetIDList(long  &aList[])
  {
   ArrayResize(aList,0);
   long p_handle=0;
   long handle=ChartNext(p_handle);
   while(handle!=-1)
     {
      p_handle=handle;
      ArrayResize(aList,ArraySize(aList)+1);
      aList[ArraySize(aList)-1]=handle;
      handle=ChartNext(p_handle);
     }
   return(ArraySize(aList));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int fObjVLine(string   aObjName,
              datetime aTime,
              string   aText       =  "",
              int      aWindow     =  0,
              color    aColor      =  Red,
              color    aWidth      =  1,
              color    aStyle      =  0,
              long     aChartID    =  0,
              bool     aBack       =  true,
              bool     aSelectable =  true,
              bool     aSelected   =  false,
              long     aTimeFrames =  OBJ_ALL_PERIODS
              )
  {
   if(aText=="")
     {
      aText=TimeToString(aTime);
     }
   int Rv=0;
   int wn=ObjectFind(aChartID,aObjName);
   if(wn!=aWindow)
     {
      Rv=1;
      if(wn>=0)
        {
         ObjectDelete(aChartID,aObjName);
         Rv=2;
        }
      ObjectCreate(aChartID,aObjName,OBJ_VLINE,aWindow,aTime,0);
     }

   ObjectSetInteger(aChartID,aObjName,OBJPROP_BACK,aBack);
   ObjectSetInteger(aChartID,aObjName,OBJPROP_COLOR,aColor);
   ObjectSetInteger(aChartID,aObjName,OBJPROP_SELECTABLE,aSelectable);
   ObjectSetInteger(aChartID,aObjName,OBJPROP_SELECTED,aSelected);
   ObjectSetInteger(aChartID,aObjName,OBJPROP_TIMEFRAMES,aTimeFrames);
   ObjectSetString(aChartID,aObjName,OBJPROP_TEXT,aText);
   ObjectSetInteger(aChartID,aObjName,OBJPROP_WIDTH,aWidth);
   ObjectSetInteger(aChartID,aObjName,OBJPROP_STYLE,aStyle);
   ObjectMove(aChartID,aObjName,0,aTime,0);
   return(Rv);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string fNameChartByID(long aChartID)
  {
   return(ChartSymbol(aChartID)+" "+fNameTimeFrame(ChartPeriod(aChartID)));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string fNameTimeFrame(int arg)
  {
   if(arg==0)
     {
      arg=Period();
     }
   switch(arg)
     {
      case PERIOD_M1:return("M1");
      case PERIOD_M2:return("M2");
      case PERIOD_M3:return("M3");
      case PERIOD_M4:return("M4");
      case PERIOD_M5:return("M5");
      case PERIOD_M6:return("M6");
      case PERIOD_M10:return("M10");
      case PERIOD_M12:return("M12");
      case PERIOD_M15:return("M15");
      case PERIOD_M20:return("M20");
      case PERIOD_M30:return("M30");
      case PERIOD_H1:return("H1");
      case PERIOD_H2:return("H2");
      case PERIOD_H3:return("H3");
      case PERIOD_H4:return("H4");
      case PERIOD_H6:return("H6");
      case PERIOD_H8:return("H8");
      case PERIOD_H12:return("H12");
      case PERIOD_D1:return("D1");
      case PERIOD_W1:return("W1");
      case PERIOD_MN1:return("MN1");
      default:return("M"+IntegerToString(arg));
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void fObjDeleteByPrefix(string aPrefix,long aChartID=0)
  {
   for(int i=ObjectsTotal(aChartID)-1;i>=0;i--)
     {
      if(StringFind(ObjectName(aChartID,i),aPrefix,0)==0)
        {
         ObjectDelete(aChartID,ObjectName(aChartID,i));
        }
     }
  }
//+------------------------------------------------------------------+
