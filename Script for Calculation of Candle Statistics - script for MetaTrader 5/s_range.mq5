//+------------------------------------------------------------------+
//|                                                      s_Range.mq5 |
//|                                           Copyright 2013, Silent |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, Silent"
#property version   "1.00"
#property script_show_inputs
//+------------------------------------------------------------------+
//| inputs                                                           |
//+------------------------------------------------------------------+
input datetime start_date="2013.01.01 00:00:00";         // date start
input datetime finish_date="2013.08.01 00:00:00";        // date finish
input string   start_line="q1";                          // name start line
input string   finish_line="q2";                         // name finish line
input int      barsC=0;                                  // bars for calculation
input bool     sfd=true;                                 // 4 digits - true, 5 digits - false
input color    colorBullish=clrGreen;                    // color: bullish candles
input color    colorBearish=clrRed;                      // color: bearish candles
input color    colorAll=clrBlue;                         // color: all candles
input int      fontSize=9;                               // font size
input bool     delLabel=false;                           // only delete 
//+------------------------------------------------------------------+
//| puts                                                             |
//+------------------------------------------------------------------+
datetime start_dt=NULL,finish_dt=NULL;
double   O_HLC[],O_H_LC[],OH_L_C[],OHL_C[];
int      i,Oi=0,Ci=0,barsCt1=0,barsCt2=0;
string   s_sfd,s_tdt;
//--- interpretation of variable names
//-- c(andle), b(ody), sh(adow), h(igh), l(ow),
//-- O(pen), C(lose), A(ll),
//-- max(imum), min(imum), a(rithmetical)
//- example: chAhmax - shadow All high maximum
double   cOmax=NULL,cOmin=EMPTY_VALUE,cOa=NULL,cCmax=NULL,cCmin=EMPTY_VALUE,cCa=NULL,cAmax=NULL,cAmin=EMPTY_VALUE,cAa=NULL,
bOmax=NULL,bOmin=EMPTY_VALUE,bOa=NULL,bCmax=NULL,bCmin=EMPTY_VALUE,bCa=NULL,bAmax=NULL,bAmin=EMPTY_VALUE,bAa=NULL,
chOhmax=NULL,chOhmin=EMPTY_VALUE,chOha=NULL,chOlmax=NULL,chOlmin=EMPTY_VALUE,chOla=NULL,
chChmax=NULL,chChmin=EMPTY_VALUE,chCha=NULL,chClmax=NULL,chClmin=EMPTY_VALUE,chCla=NULL,
chAhmax=NULL,chAhmin=EMPTY_VALUE,chAha=NULL,chAlmax=NULL,chAlmin=EMPTY_VALUE,chAla=NULL;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//--- if bars for calculation < 0 - exit
   if(barsC<0) {Print("bars for calculation < 0"); return;};
//--- if you do not select delete objects
   if(delLabel==false)
     {
      //--- search lines, setting the dates of the beginning and the end
      for(i=ObjectsTotal(0,0,OBJ_VLINE)-1;i>=0;i--)
        {
         s_tdt=ObjectName(0,i,0,OBJ_VLINE);
         if(StringFind(s_tdt,start_line,0)==0)
           {
            start_dt=(datetime)ObjectGetInteger(0,start_line,OBJPROP_TIME,0);
           }
         if(StringFind(s_tdt,finish_line,0)==0)
           {
            finish_dt=(datetime)ObjectGetInteger(0,finish_line,OBJPROP_TIME,0);
           }
        };
      //--- fill arrays OHLC
      //--- if found only one linem or the date of the start line > date of the finish line - exit
      if((start_dt==NULL && finish_dt!=NULL) || (start_dt!=NULL && finish_dt==NULL) || (start_dt>finish_dt)) {Print("start/finish lines error"); return;};
      //--- if bars for calculation of 0 and lines not found
      if(barsC==0 && start_dt==NULL && finish_dt==NULL)
        {
         if(CopyOpen(_Symbol,PERIOD_CURRENT,start_date,finish_date,O_HLC)) {barsCt1=ArraySize(O_HLC);};
         CopyHigh(_Symbol,PERIOD_CURRENT,start_date,finish_date,O_H_LC);
         CopyLow(_Symbol,PERIOD_CURRENT,start_date,finish_date,OH_L_C);
         CopyClose(_Symbol,PERIOD_CURRENT,start_date,finish_date,OHL_C);
         ArraySetAsSeries(O_HLC,true); ArraySetAsSeries(O_H_LC,true);
         ArraySetAsSeries(OH_L_C,true); ArraySetAsSeries(OHL_C,true);
         s_tdt=TimeToString(start_date)+" - "+TimeToString(finish_date)+" (on time)";
         LabelCreate("strlab_s_tdt",s_tdt,20,20,colorAll,fontSize);
        };
      //--- if bars for calculation of 0 and there is a line of start and finish line
      if(barsC==0 && start_dt!=NULL && finish_dt!=NULL)
        {
         if(CopyOpen(_Symbol,PERIOD_CURRENT,start_dt,finish_dt,O_HLC)) {barsCt1=ArraySize(O_HLC);};
         CopyHigh(_Symbol,PERIOD_CURRENT,start_dt,finish_dt,O_H_LC);
         CopyLow(_Symbol,PERIOD_CURRENT,start_dt,finish_dt,OH_L_C);
         CopyClose(_Symbol,PERIOD_CURRENT,start_dt,finish_dt,OHL_C);
         ArraySetAsSeries(O_HLC,true); ArraySetAsSeries(O_H_LC,true);
         ArraySetAsSeries(OH_L_C,true); ArraySetAsSeries(OHL_C,true);
         s_tdt=TimeToString(start_dt)+" - "+TimeToString(finish_dt)+" (on line)";
         LabelCreate("strlab_s_tdt",s_tdt,20,20,colorAll,fontSize);
        };
      //--- if bars for calculation > 0
      if(barsC!=0)
        {
         if(CopyOpen(_Symbol,PERIOD_CURRENT,1,barsC+1,O_HLC)) {barsCt1=ArraySize(O_HLC);};
         CopyHigh(_Symbol,PERIOD_CURRENT,1,barsC+1,O_H_LC);
         CopyLow(_Symbol,PERIOD_CURRENT,1,barsC+1,OH_L_C);
         CopyClose(_Symbol,PERIOD_CURRENT,1,barsC+1,OHL_C);
         ArraySetAsSeries(O_HLC,true); ArraySetAsSeries(O_H_LC,true);
         ArraySetAsSeries(OH_L_C,true); ArraySetAsSeries(OHL_C,true);
         s_tdt=IntegerToString(barsC)+" bars";
         LabelCreate("strlab_s_tdt",s_tdt,20,20,colorAll,fontSize);
        };
      //--- if there is an error report
      if(_LastError>0) {Print("Error "+IntegerToString(_LastError));};
      //--- if there are no errors
      if(_LastError==0)
        {
         //--- set the number for the counter
         if(barsCt1>0) {barsCt2=barsCt1;}
         else {barsCt2=barsC;};
         //--- calculate variables double
         for(i=0;i<barsCt2;i++)
           {
            //--- for open candles
            if(O_HLC[i]<OHL_C[i])
              {
               if(O_H_LC[i]-OH_L_C[i]>cOmax) cOmax=O_H_LC[i]-OH_L_C[i];
               if(O_H_LC[i]-OH_L_C[i]<cOmin) cOmin=O_H_LC[i]-OH_L_C[i];
               if(O_H_LC[i]-OH_L_C[i]>cAmax) cAmax=O_H_LC[i]-OH_L_C[i];
               if(O_H_LC[i]-OH_L_C[i]<cAmin) cAmin=O_H_LC[i]-OH_L_C[i];
               if(OHL_C[i]-O_HLC[i]>bOmax) bOmax=OHL_C[i]-O_HLC[i];
               if(OHL_C[i]-O_HLC[i]<bOmin) bOmin=OHL_C[i]-O_HLC[i];
               if(OHL_C[i]-O_HLC[i]>bAmax) bAmax=OHL_C[i]-O_HLC[i];
               if(OHL_C[i]-O_HLC[i]<bAmin) bAmin=OHL_C[i]-O_HLC[i];
               if(O_H_LC[i]-OHL_C[i]>chOhmax) chOhmax=O_H_LC[i]-OHL_C[i];
               if(O_H_LC[i]-OHL_C[i]<chOhmin) chOhmin=O_H_LC[i]-OHL_C[i];
               if(O_H_LC[i]-OHL_C[i]>chAhmax) chAhmax=O_H_LC[i]-OHL_C[i];
               if(O_H_LC[i]-OHL_C[i]<chAhmin) chAhmin=O_H_LC[i]-OHL_C[i];
               if(O_HLC[i]-OH_L_C[i]>chOlmax) chOlmax=O_HLC[i]-OH_L_C[i];
               if(O_HLC[i]-OH_L_C[i]<chOhmin) chOlmin=O_HLC[i]-OH_L_C[i];
               if(O_HLC[i]-OH_L_C[i]>chAlmax) chAlmax=O_HLC[i]-OH_L_C[i];
               if(O_HLC[i]-OH_L_C[i]<chAhmin) chAlmin=O_HLC[i]-OH_L_C[i];
               cOa+=O_H_LC[i]-OH_L_C[i];
               cAa+=O_H_LC[i]-OH_L_C[i];
               bOa+=OHL_C[i]-O_HLC[i];
               bAa+=OHL_C[i]-O_HLC[i];
               chOha+=O_H_LC[i]-OHL_C[i];
               chAha+=O_H_LC[i]-OHL_C[i];
               chOla+=O_HLC[i]-OH_L_C[i];
               chAla+=O_HLC[i]-OH_L_C[i];
               Oi++;
              };
            //--- for the closed candles
            if(O_HLC[i]>OHL_C[i])
              {
               if(O_H_LC[i]-OH_L_C[i]>cCmax) cCmax=O_H_LC[i]-OH_L_C[i];
               if(O_H_LC[i]-OH_L_C[i]<cOmin) cCmin=O_H_LC[i]-OH_L_C[i];
               if(O_H_LC[i]-OH_L_C[i]>cAmax) cAmax=O_H_LC[i]-OH_L_C[i];
               if(O_H_LC[i]-OH_L_C[i]<cAmin) cAmin=O_H_LC[i]-OH_L_C[i];
               if(O_HLC[i]-OHL_C[i]>bCmax) bCmax=O_HLC[i]-OHL_C[i];
               if(O_HLC[i]-OHL_C[i]<bCmin) bCmin=O_HLC[i]-OHL_C[i];
               if(O_HLC[i]-OHL_C[i]>bAmax) bAmax=O_HLC[i]-OHL_C[i];
               if(O_HLC[i]-OHL_C[i]<bAmin) bAmin=O_HLC[i]-OHL_C[i];
               if(O_H_LC[i]-O_HLC[i]>chChmax) chChmax=O_H_LC[i]-O_HLC[i];
               if(O_H_LC[i]-O_HLC[i]<chChmin) chChmin=O_H_LC[i]-O_HLC[i];
               if(O_H_LC[i]-O_HLC[i]>chAhmax) chAhmax=O_H_LC[i]-O_HLC[i];
               if(O_H_LC[i]-O_HLC[i]<chAhmin) chAhmin=O_H_LC[i]-O_HLC[i];
               if(OHL_C[i]-OH_L_C[i]>chClmax) chClmax=OHL_C[i]-OH_L_C[i];
               if(OHL_C[i]-OH_L_C[i]<chClmin) chClmin=OHL_C[i]-OH_L_C[i];
               if(OHL_C[i]-OH_L_C[i]>chAlmax) chAlmax=OHL_C[i]-OH_L_C[i];
               if(OHL_C[i]-OH_L_C[i]<chAlmin) chAlmin=OHL_C[i]-OH_L_C[i];
               cCa+=O_H_LC[i]-OH_L_C[i];
               cAa+=O_H_LC[i]-OH_L_C[i];
               bCa+=O_HLC[i]-OHL_C[i];
               bAa+=O_HLC[i]-OHL_C[i];
               chCha+=O_H_LC[i]-O_HLC[i];
               chAha+=O_H_LC[i]-O_HLC[i];
               chCla+=OHL_C[i]-OH_L_C[i];
               chAla+=OHL_C[i]-OH_L_C[i];
               Ci++;
              };
           };
         if(cOmin==EMPTY_VALUE) cOmin=0.0;
         if(cCmin==EMPTY_VALUE) cCmin=0.0;
         if(cAmin==EMPTY_VALUE) cAmin=0.0;
         if(bOmin==EMPTY_VALUE) bOmin=0.0;
         if(bCmin==EMPTY_VALUE) bCmin=0.0;
         if(bAmin==EMPTY_VALUE) bAmin=0.0;
         if(chOhmin==EMPTY_VALUE) chOhmin=0.0;
         if(chOlmin==EMPTY_VALUE) chOlmin=0.0;
         if(chChmin==EMPTY_VALUE) chChmin=0.0;
         if(chClmin==EMPTY_VALUE) chClmin=0.0;
         if(chAhmin==EMPTY_VALUE) chAhmin=0.0;
         if(chAlmin==EMPTY_VALUE) chAlmin=0.0;
         if(Oi>0)
           {
            cOa=cOa/Oi;
            bOa=bOa/Oi;
            chOha=chOha/Oi;
            chOla=chOla/Oi;
           };
         if(Ci>0)
           {
            cCa=cCa/Ci;
            bCa=bCa/Ci;
            chCha=chCha/Ci;
            chCla=chCla/Ci;
           };
         if(barsCt2>0)
           {
            cAa=cAa/barsCt2;
            bAa=bAa/barsCt2;
            chAha=chAha/barsCt2;
            chAla=chAla/barsCt2;
           };
         //--- normalization of all the variables and formatting the output string
         if(sfd==true)
           {
            NormalizeDouble(cOmax,4); NormalizeDouble(cOmin,4); NormalizeDouble(cOa,4);
            NormalizeDouble(cCmax,4); NormalizeDouble(cCmin,4); NormalizeDouble(cCa,4);
            NormalizeDouble(cAmax,4); NormalizeDouble(cAmin,4); NormalizeDouble(cAa,4);
            NormalizeDouble(bOmax,4); NormalizeDouble(bOmin,4); NormalizeDouble(bOa,4);
            NormalizeDouble(bCmax,4); NormalizeDouble(bCmin,4); NormalizeDouble(bCa,4);
            NormalizeDouble(bAmax,4); NormalizeDouble(bAmin,4); NormalizeDouble(bAa,4);
            NormalizeDouble(chOhmax,4); NormalizeDouble(chOhmin,4); NormalizeDouble(chOha,4);
            NormalizeDouble(chOlmax,4); NormalizeDouble(chOlmin,4); NormalizeDouble(chOla,4);
            NormalizeDouble(chChmax,4); NormalizeDouble(chChmin,4); NormalizeDouble(chCha,4);
            NormalizeDouble(chClmax,4); NormalizeDouble(chClmin,4); NormalizeDouble(chCla,4);
            NormalizeDouble(chAhmax,4); NormalizeDouble(chAhmin,4); NormalizeDouble(chAha,4);
            NormalizeDouble(chAlmax,4); NormalizeDouble(chAlmin,4); NormalizeDouble(chAla,4);
            s_sfd="%06.4f";
           };
         if(sfd==false)
           {
            NormalizeDouble(cOmax,5); NormalizeDouble(cOmin,5); NormalizeDouble(cOa,5);
            NormalizeDouble(cCmax,5); NormalizeDouble(cCmin,5); NormalizeDouble(cCa,5);
            NormalizeDouble(cAmax,5); NormalizeDouble(cAmin,5); NormalizeDouble(cAa,5);
            NormalizeDouble(bOmax,5); NormalizeDouble(bOmin,5); NormalizeDouble(bOa,5);
            NormalizeDouble(bCmax,5); NormalizeDouble(bCmin,5); NormalizeDouble(bCa,5);
            NormalizeDouble(bAmax,5); NormalizeDouble(bAmin,5); NormalizeDouble(bAa,5);
            NormalizeDouble(chOhmax,5); NormalizeDouble(chOhmin,5); NormalizeDouble(chOha,5);
            NormalizeDouble(chOlmax,5); NormalizeDouble(chOlmin,5); NormalizeDouble(chOla,5);
            NormalizeDouble(chChmax,5); NormalizeDouble(chChmin,5); NormalizeDouble(chCha,5);
            NormalizeDouble(chClmax,5); NormalizeDouble(chClmin,5); NormalizeDouble(chCla,5);
            NormalizeDouble(chAhmax,5); NormalizeDouble(chAhmin,5); NormalizeDouble(chAha,5);
            NormalizeDouble(chAlmax,5); NormalizeDouble(chAlmin,5); NormalizeDouble(chAla,5);
            s_sfd="%07.5f";
           };
         //--- creating text labels
         //--- OPEN
         LabelCreate("strlab_OPEN","BULLISH",20,50,colorBullish,fontSize);
         LabelCreate("strlab_Omin","min",140,50,colorBullish,fontSize);
         LabelCreate("strlab_Omax","max",220,50,colorBullish,fontSize);
         LabelCreate("strlab_Omean","mean",300,50,colorBullish,fontSize);
         string s_cOmin=StringFormat(s_sfd,cOmin);
         string s_cOmax=StringFormat(s_sfd,cOmax);
         string s_cOa=StringFormat(s_sfd,cOa);
         LabelCreate("strlab_Ocandle","candle",20,70,colorBullish,fontSize);
         LabelCreate("strlab_s_cOmin",s_cOmin,140,70,colorBullish,fontSize);
         LabelCreate("strlab_s_cOmax",s_cOmax,220,70,colorBullish,fontSize);
         LabelCreate("strlab_s_cOa",s_cOa,300,70,colorBullish,fontSize);
         string s_bOmin=StringFormat(s_sfd,bOmin);
         string s_bOmax=StringFormat(s_sfd,bOmax);
         string s_bOa=StringFormat(s_sfd,bOa);
         LabelCreate("strlab_Obody","body",20,90,colorBullish,fontSize);
         LabelCreate("strlab_s_bOmin",s_bOmin,140,90,colorBullish,fontSize);
         LabelCreate("strlab_s_bOmax",s_bOmax,220,90,colorBullish,fontSize);
         LabelCreate("strlab_s_bOa",s_bOa,300,90,colorBullish,fontSize);
         string s_chOhmin=StringFormat(s_sfd,chOhmin);
         string s_chOhmax=StringFormat(s_sfd,chOhmax);
         string s_chOha=StringFormat(s_sfd,chOha);
         LabelCreate("strlab_Oshadowhigh","shadow high",20,110,colorBullish,fontSize);
         LabelCreate("strlab_s_chOhmin",s_chOhmin,140,110,colorBullish,fontSize);
         LabelCreate("strlab_s_chOhmax",s_chOhmax,220,110,colorBullish,fontSize);
         LabelCreate("strlab_s_chOha",s_chOha,300,110,colorBullish,fontSize);
         string s_chOlmin=StringFormat(s_sfd,chOlmin);
         string s_chOlmax=StringFormat(s_sfd,chOlmax);
         string s_chOla=StringFormat(s_sfd,chOla);
         LabelCreate("strlab_Oshadowlow","shadow low",20,130,colorBullish,fontSize);
         LabelCreate("strlab_s_chOlmin",s_chOlmin,140,130,colorBullish,fontSize);
         LabelCreate("strlab_s_chOlmax",s_chOlmax,220,130,colorBullish,fontSize);
         LabelCreate("strlab_s_chOla",s_chOla,300,130,colorBullish,fontSize);
         //--- CLOSE
         LabelCreate("strlab_CLOSE","BEARISH",20,160,colorBearish,fontSize);
         LabelCreate("strlab_Cmin","min",140,160,colorBearish,fontSize);
         LabelCreate("strlab_Cmax","max",220,160,colorBearish,fontSize);
         LabelCreate("strlab_Cmean","mean",300,160,colorBearish,fontSize);
         string s_cCmin=StringFormat(s_sfd,cCmin);
         string s_cCmax=StringFormat(s_sfd,cCmax);
         string s_cCa=StringFormat(s_sfd,cCa);
         LabelCreate("strlab_Ccandle","candle",20,180,colorBearish,fontSize);
         LabelCreate("strlab_s_cCmin",s_cCmin,140,180,colorBearish,fontSize);
         LabelCreate("strlab_s_cCmax",s_cCmax,220,180,colorBearish,fontSize);
         LabelCreate("strlab_s_cCa",s_cCa,300,180,colorBearish,fontSize);
         string s_bCmin=StringFormat(s_sfd,bCmin);
         string s_bCmax=StringFormat(s_sfd,bCmax);
         string s_bCa=StringFormat(s_sfd,bCa);
         LabelCreate("strlab_Cbody","body",20,200,colorBearish,fontSize);
         LabelCreate("strlab_s_bCmin",s_bCmin,140,200,colorBearish,fontSize);
         LabelCreate("strlab_s_bCmax",s_bCmax,220,200,colorBearish,fontSize);
         LabelCreate("strlab_s_bCa",s_bCa,300,200,colorBearish,fontSize);
         string s_chChmin=StringFormat(s_sfd,chChmin);
         string s_chChmax=StringFormat(s_sfd,chChmax);
         string s_chCha=StringFormat(s_sfd,chCha);
         LabelCreate("strlab_Cshadowhigh","shadow high",20,220,colorBearish,fontSize);
         LabelCreate("strlab_s_chChmin",s_chChmin,140,220,colorBearish,fontSize);
         LabelCreate("strlab_s_chChmax",s_chChmax,220,220,colorBearish,fontSize);
         LabelCreate("strlab_s_chCha",s_chCha,300,220,colorBearish,fontSize);
         string s_chClmin=StringFormat(s_sfd,chClmin);
         string s_chClmax=StringFormat(s_sfd,chClmax);
         string s_chCla=StringFormat(s_sfd,chCla);
         LabelCreate("strlab_Cshadowlow","shadow low",20,240,colorBearish,fontSize);
         LabelCreate("strlab_s_chClmin",s_chClmin,140,240,colorBearish,fontSize);
         LabelCreate("strlab_s_chClmax",s_chClmax,220,240,colorBearish,fontSize);
         LabelCreate("strlab_s_chCla",s_chCla,300,240,colorBearish,fontSize);
         //--- All
         LabelCreate("strlab_ALL","ALL",20,270,colorAll,fontSize);
         LabelCreate("strlab_Amin","min",140,270,colorAll,fontSize);
         LabelCreate("strlab_Amax","max",220,270,colorAll,fontSize);
         LabelCreate("strlab_Amean","mean",300,270,colorAll,fontSize);
         string s_cAmin=StringFormat(s_sfd,cAmin);
         string s_cAmax=StringFormat(s_sfd,cAmax);
         string s_cAa=StringFormat(s_sfd,cAa);
         LabelCreate("strlab_Acandle","candle",20,290,colorAll,fontSize);
         LabelCreate("strlab_s_cAmin",s_cAmin,140,290,colorAll,fontSize);
         LabelCreate("strlab_s_cAmax",s_cAmax,220,290,colorAll,fontSize);
         LabelCreate("strlab_s_cAa",s_cAa,300,290,colorAll,fontSize);
         string s_bAmin=StringFormat(s_sfd,bAmin);
         string s_bAmax=StringFormat(s_sfd,bAmax);
         string s_bAa=StringFormat(s_sfd,bAa);
         LabelCreate("strlab_Abody","body",20,310,colorAll,fontSize);
         LabelCreate("strlab_s_bAmin",s_bAmin,140,310,colorAll,fontSize);
         LabelCreate("strlab_s_bAmax",s_bAmax,220,310,colorAll,fontSize);
         LabelCreate("strlab_s_bAa",s_bAa,300,310,colorAll,fontSize);
         string s_chAhmin=StringFormat(s_sfd,chAhmin);
         string s_chAhmax=StringFormat(s_sfd,chAhmax);
         string s_chAha=StringFormat(s_sfd,chAha);
         LabelCreate("strlab_Ashadowhigh","shadow high",20,330,colorAll,fontSize);
         LabelCreate("strlab_s_chAhmin",s_chAhmin,140,330,colorAll,fontSize);
         LabelCreate("strlab_s_chAhmax",s_chAhmax,220,330,colorAll,fontSize);
         LabelCreate("strlab_s_chAha",s_chAha,300,330,colorAll,fontSize);
         string s_chAlmin=StringFormat(s_sfd,chAlmin);
         string s_chAlmax=StringFormat(s_sfd,chAlmax);
         string s_chAla=StringFormat(s_sfd,chAla);
         LabelCreate("strlab_Ashadowlow","shadow low",20,350,colorAll,fontSize);
         LabelCreate("strlab_s_chAlmin",s_chAlmin,140,350,colorAll,fontSize);
         LabelCreate("strlab_s_chAlmax",s_chAlmax,220,350,colorAll,fontSize);
         LabelCreate("strlab_s_chAla",s_chAla,300,350,colorAll,fontSize);
        };
     };
//--- remove text labels
   if(delLabel==true)
     {
      for(i=ObjectsTotal(0,0,OBJ_LABEL)-1;i>=0;i--)
        {
         string name_lab=ObjectName(0,i,0,OBJ_LABEL);
         if(StringFind(name_lab,"strlab_",0)==0)
           {ObjectDelete(0,name_lab);};
        };
      ChartRedraw(); return;
     };
  }
//+------------------------------------------------------------------+
//| Creates a text label (as is the documentation)                   |
//+------------------------------------------------------------------+
bool LabelCreate(const string            name="Label",
                 const string            text="Label",
                 const int               x=0,
                 const int               y=0,
                 const color             clr=clrRed,
                 const int               font_size=10,
                 const string            font="Arial",
                 const double            angle=0.0,
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER,
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER,
                 const long              chart_ID=0,
                 const int               sub_window=0,
                 const bool              back=false,
                 const bool              selection=false,
                 const bool              hidden=true,
                 const long              z_order=0)
  {
   ResetLastError();
   if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create a text label! Error code = ",GetLastError());
      return(false);
     }
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
   return(true);
  }
//+------------------------------------------------------------------+
