//+------------------------------------------------------------------+
//|                                                tester4Define.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
 
#property strict

// declare variables used in the DEFINET_statement.mqh file
// User may change them as needed.
MqlRates g_rates[];
MqlTick g_tick;
double g_MA20_arr[];
double g_MA40_arr[];
double g_MA50_arr[];
double g_MA200_arr[];
double g_atr_arr[];


// Next, programmer selects the level of debugging.
//#define DEBUG_LEVEL0
//#define DEBUG_LEVEL1
#define DEBUG_LEVEL2


// include DEFINE statements:
#include <DEFINE_statements.mqh>
void OnStart(){
//+------------------------------------------------------------------+
// this is demonstration on how to use the DEFINE statements
//+------------------------------------------------------------------+

// here you insert rates for g_rates[];
// here you insert values for moving average indicator, ATR, etc.

   double x=1;
   double y,z;

   y=EVALLINE(x,-10,-10, 20,40,0,5);
   PRINTVAR(EVALLINE(x,-10,-10, 20,40,0,5));
   PRINTVAR(y);

   z=CONVEXCOMB(0.5, 10,20);
   PRINTVAR(z);

   datetime dt=TimeCurrent();
   PRINTVAR1(dt);

   VPRINTVAR(ASK);


   return;
}
//+------------------------------------------------------------------+
