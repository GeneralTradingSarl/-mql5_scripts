#property copyright "Copyright 2024, Kursustrading.my.id"
#property link      "https://belajarfx.my.id"
#property version   "1.038"

#property script_show_inputs

#include <Trade/Trade.mqh>

enum ENUM_ORDER_TYPES
{
    ALL_ORDERS = 1, // ALL ORDERS
    ONLY_BUY = 2,   // BUY ONLY
    ONLY_SELL = 3   // SELL ONLY
};

input bool OnlyCurrentSymbol = false; // Only current chart's symbol
input ENUM_ORDER_TYPES OrderTypeFilter = ALL_ORDERS; // Type of orders to move SL to BE
input int MinimumProfit = 0;          // Minimum current profit in points to apply BE
input int AdditionalProfit = 0;       // Additional profit in points to add to BE
input bool OnlyMagicNumber = false;   // Only orders matching the magic number
input int MagicNumber = 0;            // Matching magic number
input bool OnlyWithComment = false;   // Only orders with the following comment
input string MatchingComment = "";    // Matching comment

void OnStart()
{
    if (!TerminalInfoInteger(TERMINAL_CONNECTED))
    {
        Print("Not connected to the trading server. Exiting.");
        return;
    }

    if ((!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) || (!MQLInfoInteger(MQL_TRADE_ALLOWED)))
    {
        Print("Autotrading is disable. Please enable. Exiting.");
        return;
    }

    CTrade *Trade;
    Trade = new CTrade;

    int positions_total = PositionsTotal();
    for (int i = positions_total - 1; i >= 0; i--) // Going backwards in case one or more positions are closed during the cycle.
    {
        ulong ticket = PositionGetTicket(i);
        if (ticket <= 0)
        {
            Print("ERROR - Unable to select the position - ", GetLastError());
            continue;
        }
        
        if (PositionGetDouble(POSITION_PROFIT) <= 0) continue; // Unprofitable positions are always skipped.
        // Check if the position matches the filter and if not, skip the position and move to the next one.
        if ((OrderTypeFilter == ONLY_SELL) && (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)) continue;
        if ((OrderTypeFilter == ONLY_BUY)  && (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)) continue;
        if ((OnlyCurrentSymbol) && (PositionGetString(POSITION_SYMBOL) != Symbol())) continue;
        if ((OnlyMagicNumber) && (PositionGetInteger(POSITION_MAGIC) != MagicNumber)) continue;
        if ((OnlyWithComment) && (StringCompare(PositionGetString(POSITION_COMMENT), MatchingComment) != 0)) continue;

        double point = SymbolInfoDouble(PositionGetString(POSITION_SYMBOL), SYMBOL_POINT);
        // Compare doubles by calculating difference. If this difference is greater than Point / 2, the position's profit is below the MinimumProfit parameter.
        if ((MinimumProfit > 0) && ((double)MinimumProfit - MathAbs(PositionGetDouble(POSITION_PRICE_OPEN) - PositionGetDouble(POSITION_PRICE_CURRENT)) / point > point / 2)) continue;

        if (SymbolInfoInteger(PositionGetString(POSITION_SYMBOL), SYMBOL_TRADE_MODE) == SYMBOL_TRADE_MODE_DISABLED)
        {
            Print("Trading is disabled for ", PositionGetString(POSITION_SYMBOL), ". Skipping.");
            continue;
        }

        double extra_be_distance = AdditionalProfit * point;
        int digits = (int)SymbolInfoInteger(PositionGetString(POSITION_SYMBOL), SYMBOL_DIGITS);
        double tick_size = SymbolInfoDouble(PositionGetString(POSITION_SYMBOL), SYMBOL_TRADE_TICK_SIZE);
        if (tick_size > 0)
        {
            // Adjust for tick size granularity.
            extra_be_distance = NormalizeDouble(MathRound(extra_be_distance / tick_size) * tick_size, digits);
        }
        else
        {
            Print("Zero tick size for ", PositionGetString(POSITION_SYMBOL), ". Skipping.");
            continue;
        }
        
        if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
        {
            double BE_price = NormalizeDouble(PositionGetDouble(POSITION_PRICE_OPEN) + extra_be_distance, digits);
            if ((SymbolInfoDouble(PositionGetString(POSITION_SYMBOL), SYMBOL_BID) >= BE_price) && (BE_price > PositionGetDouble(POSITION_SL))) // Only move to BE if the price is above the calculated BE price, and the current stop-loss is lower.
            {
                double prev_sl = PositionGetDouble(POSITION_SL); // Remember old SL for reporting.
                // Write BE price to the SL field.
                if (!Trade.PositionModify(ticket, BE_price, PositionGetDouble(POSITION_TP)))
                    Print("PositionModify Buy BE failed ", GetLastError(),  " for ", PositionGetString(POSITION_SYMBOL));
                else
                    Print("Breakeven was applied to position - " + PositionGetString(POSITION_SYMBOL) + " BUY #" + IntegerToString(ticket) + " Lotsize = ", PositionGetDouble(POSITION_VOLUME), ", OpenPrice = " + DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN), digits) + ", Stop-Loss was moved from " + DoubleToString(prev_sl, digits) + ".");
            }
        }
        else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
        {
            double BE_price = NormalizeDouble(PositionGetDouble(POSITION_PRICE_OPEN) - extra_be_distance, digits);
            if  ((SymbolInfoDouble(PositionGetString(POSITION_SYMBOL), SYMBOL_ASK) <= BE_price) && ((BE_price < PositionGetDouble(POSITION_SL)) || (PositionGetDouble(POSITION_SL) == 0))) // Only move to BE if the price below the calculated BE price, and the current stop-loss is higher (or zero).
            {
                double prev_sl = PositionGetDouble(POSITION_SL); // Remember old SL for reporting.
                // Write BE price to the SL field.
                if (!Trade.PositionModify(ticket, BE_price, PositionGetDouble(POSITION_TP)))
                    Print("PositionModify Buy BE failed ", GetLastError(),  " for ", PositionGetString(POSITION_SYMBOL));
                else
                    Print("Breakeven was applied to position - " + PositionGetString(POSITION_SYMBOL) + " SELL #" + IntegerToString(ticket) + " Lotsize = ", PositionGetDouble(POSITION_VOLUME), ", OpenPrice = " + DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN), digits) + ", Stop-Loss was moved from " + DoubleToString(prev_sl, digits) + ".");
            }
        }
    }
    delete Trade;
    return;
}
//+------------------------------------------------------------------+