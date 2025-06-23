//------------------------------------------------------------------------------------
//                                                                        EMDcotir.mq5
//                                                                       2012, victorg
//                                                                 http://www.mql5.com
//------------------------------------------------------------------------------------
#property script_show_inputs
#property copyright   "2012, victorg"
#property link        "http://www.mql5.com"
#property version     "1.00"
#property description "Empirical Mode Decomposition (EMD)"

#include "CEMD_2.mqh"
#include "ChartTools\CLinDrawMulti.mqh"

input int Len=300;     // DataLength. Len>5.
input int AScale=1;    // 1=AutoScale, 0=w/o AutoScale.
input int ADraw=1;     // 1=AutoDraw, 0=w/o AutoDraw.
//------------------------------------------------------------------------------------
// Script program start function
//------------------------------------------------------------------------------------
void OnStart()
  {
  int i,j,n,ret;
  double a,b,xx[],yy[],Sum[];
//-------------------------- Preparation of the input sequence
  n=Len;                                              // Data Length
  ArrayResize(xx,n);
  ArrayResize(yy,n);
  ArrayResize(Sum,n);

  CopyOpen(_Symbol,PERIOD_CURRENT,0,n,yy);
  for(i=0;i<n;i++)xx[i]=i;
//-------------------------- EMD
  CEMD *emd=new CEMD();
  ret=emd.Decomp(yy);
//-------------------------- Visualization
  CLinDrawMu *ld=new CLinDrawMu;
  ld.Legend("false");
  ld.SubTitle(_Symbol+", "+periodname(_Period)+", Data Length = "+(string)Len);
  a=DBL_MIN; b=DBL_MAX;
  for(j=0;j<emd.nIMF;j++)
    {
    emd.GetIMF(yy,j);
    for(i=0;i<n;i++)
      {
      if(yy[i]>a)a=yy[i];
      if(yy[i]<b)b=yy[i];
      }
    }
  if(AScale==1){ld.YMax=0; ld.YMin=0;}                // Auto Scale
  else {ld.YMax=a+(a-b)*0.1; ld.YMin=b-(a-b)*0.1;}
  ld.YTitle("Data");
  emd.GetIMF(yy,0);
  ld.AddGraph(xx,yy,"line","",2);
  for(i=1;i<=emd.nIMF-1;i++)
    {
    ld.YTitle("IMF "+(string)i);
    emd.GetIMF(yy,i);
    ld.AddGraph(xx,yy,"line","",2,"180,110,50,1");
    }
  ld.YTitle("Residue");
  ld.SpBot=2;
  ld.XLab="true";
  emd.GetIMF(yy,emd.nIMF);
  ld.AddGraph(xx,yy,"line","",2,"130,150,180,1");

  if(ADraw==1)ld.LDraw(1);                            // With autodraw
  else ld.LDraw(0);                                   // Without autodraw
  delete(ld);
  delete(emd);
  }
//------------------------------------------------------------------------------------
string periodname(ENUM_TIMEFRAMES per)
  {
  int m;
  
  switch(per)
     {
     case PERIOD_M1: return("M1");
     case PERIOD_M2: return("M2");
     case PERIOD_M3: return("M3");
     case PERIOD_M4: return("M4");
     case PERIOD_M5: return("M5");
     case PERIOD_M6: return("M6");
     case PERIOD_M10: return("M10");
     case PERIOD_M12: return("M12");
     case PERIOD_M15: return("M15");
     case PERIOD_M20: return("M20");
     case PERIOD_M30: return("M30");
     case PERIOD_H1: return("H1");
     case PERIOD_H2: return("H2");
     case PERIOD_H3: return("H3");
     case PERIOD_H4: return("H4");
     case PERIOD_H6: return("H6");
     case PERIOD_H8: return("H8");
     case PERIOD_H12: return("H12");
     case PERIOD_D1: return("D1");
     case PERIOD_W1: return("W1");
     case PERIOD_MN1: return("MN1");
     default:
             m=PeriodSeconds()/60;
             return("M"+(string)m);
     }
  }
//------------------------------------------------------------------------------------