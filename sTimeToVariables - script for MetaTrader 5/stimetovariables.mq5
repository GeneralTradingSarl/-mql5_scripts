//+------------------------------------------------------------------+
//|                                             sTimeToVariables.mq5 |
//+------------------------------------------------------------------+

#property copyright "http://dmffx.com"
#property link      "http://dmffx.com"
//+------------------------------------------------------------------+
//| Script start function                                            |
//+------------------------------------------------------------------+
int OnStart()
  {
   datetime TimeNow=TimeCurrent();
   int Y,M,D,h,m,s;
   fTimeToVariables(TimeNow,Y,M,D,h,m,s);
   MqlDateTime tm;
   TimeToStruct(TimeNow,tm);

   Alert("TimeCurrent = "+
         IntegerToString(tm.year)+"."+IntegerToString(tm.mon)+"."+IntegerToString(tm.day)+" "+
         IntegerToString(tm.hour)+":"+IntegerToString(tm.min)+":"+IntegerToString(tm.sec)+
         ", TimeToVariables = "+
         IntegerToString(Y)+"."+IntegerToString(M)+"."+IntegerToString(D)+" "+
         IntegerToString(h)+":"+IntegerToString(m)+":"+IntegerToString(s));
   return(0);
  }
//+------------------------------------------------------------------+
//| fTimeToVariables                                                 |
//+------------------------------------------------------------------+
void fTimeToVariables(datetime TIME,int  &YEAR,int  &MONTH,int  &DAY,int  &HOUR,int  &MINUTE,int  &SECOND)
  {
   int dst=(int)TIME%86400;
   HOUR=dst/3600;
   dst-=(HOUR*3600);
   MINUTE=dst/60;
   SECOND=dst%60;
   int dn=(int)TIME/86400;
   int edn=dn+365;
   int qen=edn/1461;
   int dfqs=edn-(qen*1461);
   int yfqs;
   int dfys;
   if(dfqs<1095)
     {
      yfqs=dfqs/365;
      YEAR=1969+qen*4+yfqs;
      dfys=dfqs-(yfqs*365);
     }
   else
     {
      yfqs=3;
      YEAR=1969+qen*4+yfqs;
      dfys=dfqs-(yfqs*365);
      if(dfys==59)
        {
         MONTH=2;
         DAY=29;
         return;
        }
      else if(dfys>59)
        {
         dfys--;
        }
     }
   int mei[]={-1,30,58,89,119,150,180,211,242,272,303,333,364};
   for(MONTH=1;MONTH<13;MONTH++)
     {
      if(dfys<=mei[MONTH])
        {
         DAY=dfys-mei[MONTH-1];
         return;
        }
     }
  }
//+------------------------------------------------------------------+
