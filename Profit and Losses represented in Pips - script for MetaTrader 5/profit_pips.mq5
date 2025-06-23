//Script to represent current Profit/Loss in Pips for FOREX
#property copyright    "Open Source 2020, by Arturo Minor"
#property description  "free of copyright to the MQL community"

#include <Trade\PositionInfo.mqh>
#include <Trade\OrderInfo.mqh>
CPositionInfo m_position;

double Position_Pips_P_L = 0;
double Total_Pips_P_L = 0;
double Total_Pips_P = 0;
double Total_Pips_L = 0;
int ExpPips = 0;
int Is_JPY = 0;
int Type = 0;
string Symb;

//+------------------------------------------------------------------+
//|Main function                                                     |
//+------------------------------------------------------------------+
void OnStart()
  {
   for(int i = PositionsTotal()-1; i >= 0; i--)
     {
      m_position.SelectByIndex(i);
      Symb = m_position.Symbol();
      Type = m_position.PositionType();

      Is_JPY = StringFind(m_position.Symbol(), "JPY", 0);
      if(Is_JPY == 3)
         ExpPips = 100;
      else
         ExpPips = 10000;

      CalcPips();
      Total_Pips_P_L = Total_Pips_P_L + Position_Pips_P_L;
      Print("Symbol: " + Symb + "(" + (string)i + ")" + "Position P/L in Pips: " + DoubleToString(Position_Pips_P_L,1));
     }
   Print("Total P/L in Pips: " + DoubleToString(Total_Pips_P_L,1) + "; " + "Total Profit in Pips: " + DoubleToString(Total_Pips_P,1) + "; " + "Total Loss in Pips: " + DoubleToString(Total_Pips_L,1));
  }

//+------------------------------------------------------------------+
//|Calculates Profit or Losses of positions and makes the totals     |
//+------------------------------------------------------------------+
void CalcPips()
  {
   if(Type == 0) //BUY Position
     {
      Position_Pips_P_L = (m_position.PriceCurrent() - m_position.PriceOpen()) * ExpPips;
      if(Position_Pips_P_L > 0)
         Total_Pips_P = Total_Pips_P + Position_Pips_P_L;
      else
         Total_Pips_L = Total_Pips_L + Position_Pips_P_L;
     }
   if(Type == 1) //Sell position
     {
      Position_Pips_P_L = (m_position.PriceOpen() - m_position.PriceCurrent()) * ExpPips;
      if(Position_Pips_P_L > 0)
         Total_Pips_P = Total_Pips_P + Position_Pips_P_L;
      else
         Total_Pips_L = Total_Pips_L + Position_Pips_P_L;
     }
  }
//+------------------------------------------------------------------+
