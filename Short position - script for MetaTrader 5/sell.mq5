//+------------------------------------------------------------------+
//|                                                         Sell.mq5 |
//|                                     Copyright 2013, Marcus Wyatt |
//|                                        http://www.exceptionz.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, Marcus Wyatt"
#property link      "http://www.exceptionz.com"
#property version   "1.00"

#property script_show_inputs

//--- input parameters
input int      RiskPercentage = 1; // Risk Percentage
input int      RewardRatio    = 2; // Reward Ratio

#include <Trade\Trade.mqh>                                
#include <Trade\PositionInfo.mqh>                         
#include <Trade\SymbolInfo.mqh>
#include <Trade\AccountInfo.mqh>

CTrade         *m_trade;
CSymbolInfo    *m_symbol;
CPositionInfo  *m_position_info; 
CAccountInfo   *m_account;

#define MAX_PERCENT 0.2

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart() {
    m_trade = new CTrade();
    m_symbol = new CSymbolInfo();   
    m_position_info = new CPositionInfo();   
    m_account = new CAccountInfo();
    
    m_symbol.Name(Symbol());
    m_symbol.RefreshRates();
    
    double point        = m_symbol.Point();     
    double digits       = m_symbol.Digits();
    double spread       = m_symbol.Spread();
    
    double lots = TradeSize();
    double sl = NormalizeDouble(m_symbol.Bid() + AccountPercentStopPips(lots) * point, (int)digits);
    double tp = NormalizeDouble(m_symbol.Bid() - (AccountPercentStopPips(lots) * RewardRatio) * point, (int)digits);  
    if(!m_trade.PositionOpen(Symbol(), ORDER_TYPE_SELL, lots, m_symbol.Bid(), sl, tp))
        Print("PositionOpen() Sell FAILED!!. Return code=",m_trade.ResultRetcode(), ". Code description: ",m_trade.ResultRetcodeDescription());    
    
    if(m_position_info != NULL)
    delete m_position_info;  
    
    if(m_symbol != NULL)
    delete m_symbol;  
    
    if(m_trade != NULL)
    delete m_trade;  
    
    if(m_account != NULL)
    delete m_account; 
}

//+-------------------------------------------------------------------------+
//|                      Money Managment                                    |   
//+-------------------------------------------------------------------------+   
double TradeSize() {

   double lots_min     = m_symbol.LotsMin();
   double lots_max     = m_symbol.LotsMax();
   long   leverage     = m_account.Leverage();
   double lots_size    = SymbolInfoDouble(Symbol(),SYMBOL_TRADE_CONTRACT_SIZE);
   double lots_step    = m_symbol.LotsStep();;
   double percentage   = RiskPercentage / 100;
   
   if(percentage > MAX_PERCENT) percentage = MAX_PERCENT;
   
   double final_account_balance =  MathMin(m_account.Balance(), m_account.Equity());
   int normalization_factor = 0;
   double lots = 0.0;
   
   if(lots_step == 0.01) { normalization_factor = 2; }
   if(lots_step == 0.1)  { normalization_factor = 1; }
   
   lots = (final_account_balance*(RiskPercentage/100.0))/(lots_size/leverage);
   lots = NormalizeDouble(lots, normalization_factor);
   
   if (lots < lots_min) { lots = lots_min; }
   if (lots > lots_max) { lots = lots_max; }
   //----
   return( lots );
}

double AccountPercentStopPips(double lots) {
    double balance      = MathMin(m_account.Balance(), m_account.Equity());
    double moneyrisk    = balance * RiskPercentage / 100;
    double spread       = m_symbol.Spread();
    double point        = m_symbol.Point();
    double ticksize     = m_symbol.TickSize();
    double tickvalue    = m_symbol.TickValue();
    double tickvaluefix = tickvalue * point / ticksize; // A fix for an extremely rare occasion when a change in ticksize leads to a change in tickvalue
    
    double stoploss = moneyrisk / (lots * tickvaluefix ) - spread;
    
    if (stoploss < m_symbol.StopsLevel())
        stoploss = m_symbol.StopsLevel(); // This may rise the risk over the requested
        
    stoploss = NormalizeDouble(stoploss, 0);
    
    return (stoploss);
}

//+------------------------------------------------------------------+
