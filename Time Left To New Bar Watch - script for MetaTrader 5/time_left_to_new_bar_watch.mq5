//+------------------------------------------------------------------+
//|                                   Time Left To New Bar Watch.mq5 |
//|                                  Copyright 2023, Igor Gerasimov. |
//|                                                 tgwls2@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Igor Gerasimov."
#property link      "tgwls2@gmail.com"
#property version   "1.00"
#property script_show_inputs
input string name="Arrow_";     // Object Prfx
input uchar font_size=25;       // Object Size
input color clr0=clrDarkGreen,  // Marker Color
            clr1=clrOlive;      // Arrow  Color
uchar dpi=font_size;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
    const int x0=(int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0),
              y0=(int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0),
              x=(int)(x0/(double)2),
              y=(int)(y0/(double)2),
              z3=(int)(MathMax(x0,y0)/(double)3),
              z6=(int)(MathMax(x0,y0)/(double)6);
    dpi*=(uchar)(MathMax(TerminalInfoInteger(TERMINAL_SCREEN_DPI)/(double)96,MathMax(x0,y0)/(double)566)); 
    double time=0;
    for(int i=0; i<12 && !IsStopped(); i++)
        {
            Label(name+(string)i,(int)(x+MathSin(time*M_PI)*z3),(int)(y+MathSin((time-0.5)*M_PI)*z3),dpi,0-360*time/2,"|",clr0);
            time+=2/(double)12;
        }
    time=0;
    Label(name+(string)12,(int)(x+MathSin(time*M_PI)*z6),(int)(y+MathSin((time-0.5)*M_PI)*z6),dpi*4,0-360*time,"|",clr1);
    ChartRedraw(0);
    while(!IsStopped())
        {
            time=((int)TimeCurrent()-(int)iTime(_Symbol,PERIOD_CURRENT,0)+1)*2/(double)PeriodSeconds(PERIOD_CURRENT);
            ObjectSetInteger(0,name+(string)12,OBJPROP_XDISTANCE,(int)(x+MathSin(time*M_PI)*z6));
            ObjectSetInteger(0,name+(string)12,OBJPROP_YDISTANCE,(int)(y+MathSin((time-0.5)*M_PI)*z6));
            ObjectSetDouble(0,name+(string)12,OBJPROP_ANGLE,0-360*time/2);
            ChartRedraw(0);
            Sleep(99);
        }
    for(int i=0; i<13; i++) ObjectDelete(0,name+(string)i);
    ChartRedraw(0);
}
//+------------------------------------------------------------------+
//| Label                                                            |
//+------------------------------------------------------------------+
void Label(const string n,
           const int x,
           const int y,
           const int z,
           const double a,
           const string t,
           const color c)
{
    if(ObjectCreate(0,n,OBJ_LABEL,0,0,0))
        {
            ObjectSetInteger(0,n,OBJPROP_XDISTANCE,x);
            ObjectSetInteger(0,n,OBJPROP_YDISTANCE,y);
            ObjectSetInteger(0,n,OBJPROP_CORNER,CORNER_LEFT_UPPER);
            ObjectSetString(0,n,OBJPROP_TEXT,t);
            ObjectSetString(0,n,OBJPROP_FONT,"Arial Black");
            ObjectSetInteger(0,n,OBJPROP_FONTSIZE,z);
            ObjectSetDouble(0,n,OBJPROP_ANGLE,a);
            ObjectSetInteger(0,n,OBJPROP_ANCHOR,ANCHOR_CENTER);
            ObjectSetInteger(0,n,OBJPROP_COLOR,c);
            ObjectSetInteger(0,n,OBJPROP_BACK,true);
            ObjectSetInteger(0,n,OBJPROP_SELECTABLE,false);
            ObjectSetInteger(0,n,OBJPROP_SELECTED,false);
            ObjectSetInteger(0,n,OBJPROP_HIDDEN,true);
            ObjectSetInteger(0,n,OBJPROP_ZORDER,LONG_MAX);
        }
    return;
}
//+------------------------------------------------------------------+
