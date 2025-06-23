//+------------------------------------------------------------------+
//|                                    VPS Trailing Stop Service.mq5 |
//|                                  Copyright 2023, Igor Gerasimov. |
//|                                                 tgwls2@gmail.com |
//+------------------------------------------------------------------+
#property    service
#property    copyright              "Copyright 2023, Igor Gerasimov."
#property    link                   "tgwls2@gmail.com"
#property    version                "1.00"
input bool   S=true,                // Remove Unused Object
             C=true,                // Remove Unused Symbol
             W=true,                // Real Stop Loss Trail
             U=true;                // Virtual Object Trail
input string V="VPS Trailing Stop"; // Trailing Object Name
input ushort B=15000;               // Sleep Time
//+------------------------------------------------------------------+
//| To use Real SL Trailing - when you open a trade order            |
//| in the comment indicate the real stop loss distance in points.   |
//| To use Virtual SL Trailing - create horizontal line on           |
//| same symbol chart then rename it to the name you used before     |
//| launching the program and in the description of the object       |
//| indicate the virtual stop loss distance in points.               |
//| !!! Be careful !!! When placing an object on chart               |
//| use correct SL distance depending on trade direction.            |
//| To disable virtual trailing just delete created horizontal line. |
//| To disable real trailing you have to stop this program.          |
//+------------------------------------------------------------------+
void OnStart()
{
    while(!IsStopped())
        {
            string e[];
            int x=PositionsTotal();
            for(int z=0; z<x && !IsStopped(); z++)
                {
                    const ulong t=PositionGetTicket(z);
                    const long c=(long)StringToInteger(PositionGetString(POSITION_COMMENT));
                    const string w=PositionGetString(POSITION_SYMBOL);
                    if((C && TerminalInfoInteger(TERMINAL_VPS)) || (S && !TerminalInfoInteger(TERMINAL_VPS))) A(e,w);
                    if(((W && !TerminalInfoInteger(TERMINAL_VPS)) || TerminalInfoInteger(TERMINAL_VPS)) && c>0)
                        {
                            const ENUM_POSITION_TYPE y=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
                            if(SymbolSelect(w,true))
                                {
                                    const double p=y==POSITION_TYPE_BUY?SymbolInfoDouble(w,SYMBOL_BID):SymbolInfoDouble(w,SYMBOL_ASK),
                                                 s=PositionGetDouble(POSITION_SL),
                                                 v=SymbolInfoDouble(w,SYMBOL_POINT);
                                    const long u=(long)SymbolInfoInteger(w,SYMBOL_TRADE_STOPS_LEVEL);
                                    if(MathIsValidNumber(p) && MathIsValidNumber(v) && p>=v && (s>=v?(y==POSITION_TYPE_BUY?(p-s)>(c*v+(u>0?u*v:v)):(s-p)>(c*v+(u>0?u*v:v))):true))
                                        {
                                            const uchar d=(uchar)SymbolInfoInteger(w,SYMBOL_DIGITS);
                                            MqlTradeRequest a;
                                            MqlTradeResult b;
                                            ZeroMemory(a);
                                            ZeroMemory(b);
                                            a.action=TRADE_ACTION_SLTP;
                                            a.position=t;
                                            a.symbol=w;
                                            a.sl=StringToDouble(DoubleToString(y==POSITION_TYPE_BUY?p-c*v:p+c*v,d));
                                            a.tp=PositionGetDouble(POSITION_TP)>0?StringToDouble(DoubleToString(PositionGetDouble(POSITION_TP),d)):0;
                                            if(!OrderSend(a,b)) Print(b.retcode);
                                        }
                                }
                        }
                    if(U && !TerminalInfoInteger(TERMINAL_VPS))
                        {
                            long a,b=ChartFirst();
                            if(b>=0)
                                {
                                    uchar i=0;
                                    while(i<255 && !IsStopped())
                                        {
                                            if(w==ChartSymbol(b) && ObjectFind(b,V)==0)
                                                {
                                                    const int f=(int)StringToInteger(ObjectGetString(b,V,OBJPROP_TEXT));
                                                    if(f>0)
                                                        {
                                                            const ENUM_POSITION_TYPE y=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
                                                            const double p=y==POSITION_TYPE_BUY?SymbolInfoDouble(w,SYMBOL_BID):SymbolInfoDouble(w,SYMBOL_ASK),
                                                                         s=ObjectGetDouble(b,V,OBJPROP_PRICE),
                                                                         v=SymbolInfoDouble(w,SYMBOL_POINT);
                                                            if(MathIsValidNumber(p) && MathIsValidNumber(v) && p>=v)
                                                                {
                                                                    if(y==POSITION_TYPE_BUY?(p-s)>(f*v):(s-p)>(f*v))
                                                                        {
                                                                            if(ObjectSetDouble(b,V,OBJPROP_PRICE,
                                                                                               StringToDouble(DoubleToString(y==POSITION_TYPE_BUY?p-f*v:p+f*v,(int)SymbolInfoInteger(w,SYMBOL_DIGITS))))) ChartRedraw(b);
                                                                        }
                                                                    else if(y==POSITION_TYPE_BUY?p<=s:p>=s)
                                                                        {
                                                                            const uchar d=(uchar)SymbolInfoInteger(w,SYMBOL_DIGITS);
                                                                            MqlTradeRequest j;
                                                                            MqlTradeResult k;
                                                                            ZeroMemory(j);
                                                                            ZeroMemory(k);
                                                                            j.action=TRADE_ACTION_DEAL;
                                                                            j.position=t;
                                                                            j.volume=PositionGetDouble(POSITION_VOLUME);
                                                                            j.deviation=ULONG_MAX;
                                                                            j.price=StringToDouble(DoubleToString(p,d));
                                                                            j.type=POSITION_TYPE_BUY?ORDER_TYPE_SELL:ORDER_TYPE_BUY;
                                                                            j.symbol=w;
                                                                            if(OrderSend(j,k))
                                                                                {
                                                                                    ObjectDelete(b,V);
                                                                                    ChartRedraw(b);
                                                                                }
                                                                            else Print(k.retcode);
                                                                        }
                                                                }
                                                        }
                                                }
                                            a=ChartNext(b);
                                            if(a<0) break;
                                            b=a;
                                            i++;
                                        }
                                }
                        }
                }
            if(C && TerminalInfoInteger(TERMINAL_VPS))
                {
                    x=SymbolsTotal(true);
                    for(int z=0; z<x && !IsStopped(); z++)
                        {
                            const string y=SymbolName(z,true);
                            bool b=false;
                            for(int a=0; a<ArraySize(e) && !IsStopped(); a++)
                                {
                                    if(y==e[a])
                                        {
                                            b=true;
                                            break;
                                        }
                                }
                            if(!b && SymbolSelect(y,b)) break;
                        }
                }
            if(S && !TerminalInfoInteger(TERMINAL_VPS))
                {
                    long a,b=ChartFirst();
                    if(b>=0)
                        {
                            uchar i=0;
                            while(i<255 && !IsStopped())
                                {
                                    bool c=false;
                                    for(int z=0; z<ArraySize(e) && !IsStopped(); z++)
                                        {
                                            if(e[z]==ChartSymbol(b) && ObjectFind(b,V)==0)
                                                {
                                                    c=true;
                                                    break;
                                                }
                                        }
                                    if(!c)
                                        {
                                            ObjectDelete(b,V);
                                            ChartRedraw(b);
                                        }
                                    a=ChartNext(b);
                                    if(a<0) break;
                                    b=a;
                                    i++;
                                }
                        }
                }
            Sleep(B);
        }
}
//+------------------------------------------------------------------+
//| A                                                                |
//+------------------------------------------------------------------+
void A(string &e[],const string w)
{
    if(ArraySize(e)<1) if(ArrayResize(e,1)==1) e[0]=w;
        else
            {
                bool b=false;
                for(int a=0; a<ArraySize(e) && !IsStopped(); a++)
                    {
                        if(w==e[a])
                            {
                                b=true;
                                break;
                            }
                    }
                if(!b)
                    {
                        const int a=ArraySize(e);
                        if(ArrayResize(e,a+1)==(a+1)) e[a]=w;
                    }
            }
    return;
}
//+------------------------------------------------------------------+
