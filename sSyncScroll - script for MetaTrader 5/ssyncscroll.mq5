//+------------------------------------------------------------------+
//|                                                  sSyncScroll.mq5 |
//|                          https://login.mql5.com/en/users/Integer |
//+------------------------------------------------------------------+
#property copyright "Integer"
#property link      "https://login.mql5.com/en/users/Integer"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   datetime TmpTime;
   long h[];
   long th[];
   ChartGetIDList(h);
   datetime TimeAtMarker[];
   ArrayResize(TimeAtMarker,ArraySize(h));

   long MainChartID=ChartID();
   datetime CurTime=ChartTimeAtMarker(MainChartID,1);

   for(int i=0;i<ArraySize(h);i++)
     {
      if(ChartGetInteger(h[i],CHART_AUTOSCROLL))
        {
         ChartSetInteger(h[i],CHART_AUTOSCROLL,false);
        }
      if(ChartTimeAtMarker(h[i],2)!=CurTime)
        {
         ScrollToTime(h[i],CurTime);
         ChartRedraw(h[i]);
        }
      TimeAtMarker[i]=ChartTimeAtMarker(h[i],3);
     }

   while(!IsStopped())
     {
      //--- turning off auto scrolling
      for(int i=0;i<ArraySize(h);i++)
        {
         if(ChartGetInteger(h[i],CHART_AUTOSCROLL))
           {
            ChartSetInteger(h[i],CHART_AUTOSCROLL,false);
           }
        }
      //--- checking for a chart adding/removing                         
      ChartGetIDList(th);
      //--- removing   
      for(int i=ArraySize(h)-1;i>=0;i--)
        {
         bool exist=false;
         for(int j=0;j<ArraySize(th);j++)
           {
            if(h[i]==th[j])
              {
               exist=true;
               break;
              }
           }
         if(!exist)
           {
            for(int j=i;j<ArraySize(h)-1;j++)
              {
               h[j]=h[j+1];
               TimeAtMarker[j]=TimeAtMarker[j+1];
              }
            ArrayResize(h,ArraySize(h)-1);
            ArrayResize(TimeAtMarker,ArraySize(h));
           }
        }
      //--- adding
      for(int i=0;i<ArraySize(th);i++)
        {
         bool exist=false;
         for(int j=0;j<ArraySize(h);j++)
           {
            if(th[i]==h[j])
              {
               exist=true;
               break;
              }
           }
         if(!exist)
           {
            ScrollToTime(th[i],CurTime);
            TmpTime=ChartTimeAtMarker(th[i],6);
            if(TmpTime!=0)
              {
               ArrayResize(h,ArraySize(h)+1);
               ArrayResize(TimeAtMarker,ArraySize(h));
               h[ArraySize(h)-1]=th[i];
               TimeAtMarker[ArraySize(h)-1]=TmpTime;
              }
           }
        }
      //--- main part
      bool DoScroll=false;
      //--- checking for a position change
      for(int i=0;i<ArraySize(h);i++)
        {
         TmpTime=ChartTimeAtMarker(h[i],4);
         if(TmpTime==0)
           {
            break;
           }
         if(TmpTime!=TimeAtMarker[i])
           {
            TimeAtMarker[i]=TmpTime;
            MainChartID=h[i];
            CurTime=TmpTime;
            DoScroll=true;
            break;
           }
        }
      //--- scrolling all the charts to a new position
      if(DoScroll)
        {
         for(int i=0;i<ArraySize(h);i++)
           {
            TmpTime=ChartTimeAtMarker(h[i],5);
            if(TmpTime!=0 && TmpTime!=CurTime)
              {
               if(MainChartID!=h[i])
                 {
                  ScrollToTime(h[i],CurTime);
                  ChartRedraw(h[i]);
                  TmpTime=ChartTimeAtMarker(h[i],6);
                  if(TmpTime!=0)
                    {
                     TimeAtMarker[i]=TmpTime;
                    }
                 }
              }
           }
        }
      //--- setting the lines
      for(int i=0;i<ArraySize(h);i++)
        {
         fObjVLine(h[i],PeriodSeconds(ChartPeriod(h[i]))*(CurTime/PeriodSeconds(ChartPeriod(h[i]))));
         ChartRedraw(h[i]);
        }
      Sleep(200);
     }

//--- deleting the lines when the script finishes its work
   for(int i=0;i<ArraySize(h);i++)
     {
      ObjectDelete(h[i],"CHSS_VL");
      ChartRedraw(h[i]);
     }

  }
//+------------------------------------------------------------------+
//| fObjVLine                                                        |
//+------------------------------------------------------------------+
void fObjVLine(long aChartID,datetime aTime)
  {
   if(ObjectFind(aChartID,"CHSS_VL")==-1)
     {
      ObjectCreate(aChartID,"CHSS_VL",OBJ_VLINE,0,aTime,0);
      ObjectSetInteger(aChartID,"CHSS_VL",OBJPROP_COLOR,clrRed);
      ObjectSetInteger(aChartID,"CHSS_VL",OBJPROP_WIDTH,1);
      ObjectSetInteger(aChartID,"CHSS_VL",OBJPROP_STYLE,STYLE_SOLID);
      ObjectSetInteger(aChartID,"CHSS_VL",OBJPROP_BACK,false);
      ObjectSetInteger(aChartID,"CHSS_VL",OBJPROP_SELECTABLE,true);
      ObjectSetInteger(aChartID,"CHSS_VL",OBJPROP_SELECTED,false);
     }
   if(ObjectGetInteger(aChartID,"CHSS_VL",OBJPROP_TIME,0)!=aTime)
     {
      ObjectSetInteger(aChartID,"CHSS_VL",OBJPROP_TIME,0,aTime);

     }
  }
//+------------------------------------------------------------------+
//| ScrollToTime                                                     |
//+------------------------------------------------------------------+
void ScrollToTime(long aChartID,datetime aTime)
  {
   datetime tm[1];
   aTime/=PeriodSeconds(ChartPeriod(aChartID));
   aTime*=PeriodSeconds(ChartPeriod(aChartID));
   int rv=CopyTime(ChartSymbol(aChartID),ChartPeriod(aChartID),0,1,tm);
   int NewPos=Bars(ChartSymbol(aChartID),ChartPeriod(aChartID),aTime,tm[0])-1;
   NewPos=MathMin(NewPos,Bars(ChartSymbol(aChartID),ChartPeriod(aChartID))-1);
   ChartNavigate(aChartID,CHART_END,-NewPos);
  }
//+------------------------------------------------------------------+
//| ChartBarAtMarker                                                 |
//+------------------------------------------------------------------+
int ChartBarAtMarker(long aChartID)
  {
   long WidthInBars=ChartGetInteger(aChartID,CHART_WIDTH_IN_BARS);
   long LeftBar=ChartGetInteger(aChartID,CHART_FIRST_VISIBLE_BAR);
   double MarkerShift=0;
   if(ChartGetInteger(aChartID,CHART_SHIFT))
     {
      MarkerShift=ChartGetDouble(aChartID,CHART_SHIFT_SIZE);
     }
   double tmp=MathCeil(0.01*MarkerShift*WidthInBars+(double)LeftBar-double(WidthInBars));
   if(tmp<0)tmp=0;
   return((int)tmp);
  }
//+------------------------------------------------------------------+
//| ChartTimeAtMarker                                                |
//+------------------------------------------------------------------+
datetime ChartTimeAtMarker(long aChartID,int z)
  {
   int shift=ChartBarAtMarker(aChartID);
   datetime tm[1];
   int rv=CopyTime(ChartSymbol(aChartID),ChartPeriod(aChartID),shift,1,tm);
   if(rv==-1)
     {
      return(0);
     }
   return(tm[0]);
  }
//+------------------------------------------------------------------+
//| ChartGetIDList                                                   |
//+------------------------------------------------------------------+
int ChartGetIDList(long   &aList[])
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
