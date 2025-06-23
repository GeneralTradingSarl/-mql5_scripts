//+------------------------------------------------------------------+
//|                                                MN1_W1_Levels.mq4 |
//|                                                  © Tecciztecatl  |
//+------------------------------------------------------------------+
#property copyright     "© Tecciztecatl 2016"
#property link          "113411@bk.ru"
#property version       "1.00"
#property description   "The script shows the highs and lows of weeks and months."
#property script_show_inputs
#property strict

input  int      days=200;                    //Number of days
extern string   comm0="";                    //-     -   -- ---- Weeks ---- --   -     -
extern color    W1_Color=LimeGreen;          //W1 Color of lines
input  int      W1_Width=3;                  //W1 Line Width
extern ENUM_LINE_STYLE W1_style=STYLE_SOLID; //W1 Style of lines 
extern string   comm1="";                    //-     -   -- ---- Months ---- --   -     -
extern color    MN1_Color=Orange;            //MN1 Color of lines
input  int      MN1_Width=3;                 //MN1 Line Width
extern ENUM_LINE_STYLE MN1_style=STYLE_SOLID;//MN1 Style of lines 

enum  choice0 {Trend_Line=0,Horizontal_Line=1};
input choice0 object=Trend_Line;             //Trend or Horizontal line

datetime    ArrDate[1];
double      ArrDouble[1];
MqlDateTime time;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   DelObject();

   int weeks=(int)MathCeil(days/7)+1;
   if(weeks>Bars(_Symbol,PERIOD_W1)) weeks=Bars(_Symbol,PERIOD_W1)-1;
   if(weeks<0) {Alert("No historical data!"); return;}
   for(int i=weeks; i>=0; i--)
     {
      datetime w1=iTime(_Symbol,PERIOD_W1,i);
      TimeToStruct(w1,time);
      if(object==Trend_Line)
        {
         SetTrendLine("W1_High_"+(string)i+"_ln",
                      w1+86400,
                      iHigh(_Symbol,PERIOD_W1,i),
                      w1+7*86400,
                      W1_Color,
                      W1_Width,
                      W1_style,
                      0x0007ffff);
         SetTrendLine("W1_Low_"+(string)i+"_ln",
                      w1+86400,
                      iLow(_Symbol,PERIOD_W1,i),
                      w1+7*86400,
                      W1_Color,
                      W1_Width,
                      W1_style,
                      0x0007ffff);
        }
      else
        {
         SetHLine("W1_High_"+(string)i+"_ln",
                  iHigh(_Symbol,PERIOD_W1,i),
                  W1_Color,
                  W1_Width,
                  W1_style);
         SetHLine("W1_Low_"+(string)i+"_ln",
                  iLow(_Symbol,PERIOD_W1,i),
                  W1_Color,
                  W1_Width,
                  W1_style);
        }
     }

   TimeToStruct(TimeCurrent(),time);
   int month=(int)MathCeil((days-time.day)/30)+1;
   if(month>Bars(_Symbol,PERIOD_MN1)) month=Bars(_Symbol,PERIOD_MN1)-1;
   if(month<0) {Alert("No historical data!"); return;}
   for(int i=month; i>=0; i--)
     {

      datetime mn=iTime(_Symbol,PERIOD_MN1,i);
      TimeToStruct(mn,time);

      if(object==Trend_Line)
        {
         SetTrendLine("MN1_High_"+(string)i+"_ln",
                      mn,
                      iHigh(_Symbol,PERIOD_MN1,i),
                      mn+DayMonth(time.mon,mn)*86400,
                      MN1_Color,
                      MN1_Width,
                      MN1_style,
                      0x000fffff);
         SetTrendLine("MN1_Low_"+(string)i+"_ln",
                      mn,
                      iLow(_Symbol,PERIOD_MN1,i),
                      mn+DayMonth(time.mon,mn)*86400,
                      MN1_Color,
                      MN1_Width,
                      MN1_style,
                      0x000fffff);
        }
      else
        {
         SetHLine("MN1_High_"+(string)i+"_ln",
                  iHigh(_Symbol,PERIOD_MN1,i),
                  MN1_Color,
                  MN1_Width,
                  MN1_style);
         SetHLine("MN1_Low_"+(string)i+"_ln",
                  iLow(_Symbol,PERIOD_MN1,i),
                  MN1_Color,
                  MN1_Width,
                  MN1_style);
        }

     }

   ChartRedraw();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int DayMonth(int mon,datetime ttime)
  {
   int leap_year;
   TimeToStruct(ttime,time);
   switch(mon)
     {
      case  1:
      case  3:
      case  5:
      case  7:
      case  8:
      case 10:
      case 12:
         return(31);
      case  2:
         leap_year=time.year;
         if(time.year%100==0)
            leap_year/=100;
         return((leap_year%4==0)? 29 : 28);
      case  4:
      case  6:
      case  9:
      case 11:
         return(30);
     }
   return(0);
  }
//// —оздаЄм линию
void SetTrendLine(
                  const string         name,
                  datetime             time1,
                  double               price1,
                  datetime             time2,
                  color                cvet,
                  int                  widthL,
                  ENUM_LINE_STYLE      styleL,
                  int                  hide_TF
                  )
  {
   if(ObjectFind(0,name)<0) ObjectCreate(0,name,OBJ_TREND,0,time1,price1,time2,price1);
   ObjectMove(0,name,0,time1,price1);
   ObjectMove(0,name,1,time2,price1);
   ObjectSetInteger(0,name,OBJPROP_COLOR,cvet);
   ObjectSetInteger(0,name,OBJPROP_STYLE,styleL);
   ObjectSetInteger(0,name,OBJPROP_WIDTH,widthL);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,name,OBJPROP_BACK,false);
   ObjectSetInteger(0,name,OBJPROP_ZORDER,1);
   ObjectSetInteger(0,name,OBJPROP_RAY_RIGHT,false);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
   ObjectSetInteger(0,name,OBJPROP_TIMEFRAMES,hide_TF);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime iTime(string symbol,ENUM_TIMEFRAMES timeframe,int index)
  {
   if(index<0) index=0;
   if(CopyTime(symbol, timeframe, index, 1, ArrDate)>0) return(ArrDate[0]);
   else return(-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double iLow(string symbol,ENUM_TIMEFRAMES timeframe,int index)
  {
   if(index < 0) return(-1);
   if(CopyLow(symbol, timeframe, index, 1, ArrDouble)>0) return(ArrDouble[0]);
   else return(-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double iHigh(string symbol,ENUM_TIMEFRAMES timeframe,int index)
  {
   if(index < 0) return(-1);
   if(CopyHigh(symbol, timeframe, index, 1, ArrDouble)>0) return(ArrDouble[0]);
   else return(-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetHLine(
              const string         name,
              double               price1,
              color                cvet,
              int                  widthL,
              ENUM_LINE_STYLE      styleL,
              )
  {
   if(ObjectFind(0,name)<0) ObjectCreate(0,name,OBJ_HLINE,0,0,price1);
   ObjectSetDouble(0,name,OBJPROP_PRICE,price1);
   ObjectSetInteger(0,name,OBJPROP_COLOR,cvet);
   ObjectSetInteger(0,name,OBJPROP_STYLE,styleL);
   ObjectSetInteger(0,name,OBJPROP_WIDTH,widthL);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,name,OBJPROP_BACK,false);
   ObjectSetInteger(0,name,OBJPROP_ZORDER,1);
   ObjectSetInteger(0,name,OBJPROP_RAY_RIGHT,false);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DelObject()
  {
   for(int i=ObjectsTotal(0,0,-1)-1;i>=0;i--)
     {
      string temp=ObjectName(0,i,0,-1);
      if(StringFind(temp,"_ln",0)>=0)
         ObjectDelete(0,temp);
     }
  }
//+------------------------------------------------------------------+
