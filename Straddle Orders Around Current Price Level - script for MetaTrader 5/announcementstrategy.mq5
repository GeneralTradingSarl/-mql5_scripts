//+------------------------------------------------------------------+
//|                                         AnnouncementStrategy.mq5 |
//|                                     Copyright 2013, Marcus Wyatt |
//|                                        http://www.exceptionz.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, Marcus Wyatt"
#property link      "http://www.exceptionz.com"
#property version   "1.00"

#property script_show_inputs

//--- input parameters
input int      Step = 50;               // Straddle Distance
input bool     HasExpiry = true;        // Has Expiry
input double   Minutes = 2;             // Expiry (Minutes)
input int      RiskPercentage = 10;     // Risk Percentage

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
    int    digits       = m_symbol.Digits();
    double spread       = m_symbol.Spread();
    double ask          = m_symbol.Ask();
    double bid          = m_symbol.Bid();
    double price        = 0.0;
    double sl           = 0.0;
    datetime expiration = TimeCurrent() + (int)(Minutes * 60);
    
    if(m_position_info.Select(Symbol())){
        if(m_position_info.PositionType() == POSITION_TYPE_SELL) {
            sl = NormalizeDouble(bid + (Step - 1) * point, digits);
            if(!m_trade.PositionModify(m_position_info.Symbol(), sl, m_position_info.TakeProfit())) {
                Print("PositionModify() Sell FAILED!!. Return code=",m_trade.ResultRetcode(), ". Code description: ",m_trade.ResultRetcodeDescription());
                m_trade.PositionClose(m_position_info.Symbol());
            }         
        } 
        if(m_position_info.PositionType() == POSITION_TYPE_BUY) {
            sl = NormalizeDouble(ask - (Step - 1) * point, digits);
            if(!m_trade.PositionModify(m_position_info.Symbol(), sl, m_position_info.TakeProfit())) {
                Print("PositionModify() Sell FAILED!!. Return code=",m_trade.ResultRetcode(), ". Code description: ",m_trade.ResultRetcodeDescription());
                m_trade.PositionClose(m_position_info.Symbol());
            }         
        }      
    }
    
    CreateBuyStop(ask, point, digits, expiration);
    CreateSellStop(bid, point, digits, expiration);
    
    if(m_position_info != NULL)
        delete m_position_info;  
    
    if(m_symbol != NULL)
        delete m_symbol;  
    
    if(m_trade != NULL)
        delete m_trade;  
    
    if(m_account != NULL)
        delete m_account; 
}

bool CreateBuyStop(double ask, double point, int digits, datetime expiration) {
    bool   result     = true;
    double price      = NormalizeDouble(ask + Step * point, digits);
    double sl         = NormalizeDouble(price - Step * point, digits);
    if(!m_trade.BuyStop(TradeSize(), price, Symbol(), sl, 0.0, ORDER_TIME_SPECIFIED, expiration)) {
        Print("PositionOpen() Buy FAILED!!. Return code=",m_trade.ResultRetcode(), ". Code description: ",m_trade.ResultRetcodeDescription());
        result = false;
    }
    return result;
}

bool CreateSellStop(double bid, double point, int digits, datetime expiration) {
    bool   result     = true;
    double price      = NormalizeDouble(bid - Step * point, digits);
    double sl         = NormalizeDouble(price + Step * point, digits);
    if(!m_trade.SellStop(TradeSize(), price, Symbol(), sl, 0.0, ORDER_TIME_SPECIFIED, expiration)) {
        Print("PositionOpen() Buy FAILED!!. Return code=",m_trade.ResultRetcode(), ". Code description: ",m_trade.ResultRetcodeDescription()); 
        result = false; 
    }
    return result;
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
//+------------------------------------------------------------------+

