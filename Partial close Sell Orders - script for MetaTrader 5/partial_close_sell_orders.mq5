//+------------------------------------------------------------------+
//|                                    Partial Close Sell Orders.mq5 |
//|                                   Copyright 2025, MetaQuotes Ltd |
//|                              https://www.mql5.com/en/users/matfx |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd"
#property link      "https://www.mql5.com/en/users/matfx"
#property version   "1.00"

#property script_show_inputs
#property strict

// Input parameters
input double   PartialClosePercentage = 50.0;  // Percentage of position to close (0-100)
input bool     CloseAllIfSmall = true;         // Close entire position if remaining lots would be too small
input double   MinimumLotSize = 0.1;           // Minimum lot size to leave open (if CloseAllIfSmall=true)

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
    // Check input parameters
    if(PartialClosePercentage <= 0 || PartialClosePercentage > 100)
    {
        Alert("Error: PartialClosePercentage must be between 0 and 100");
        return;
    }
    
    if(MinimumLotSize <= 0)
    {
        Alert("Error: MinimumLotSize must be greater than 0");
        return;
    }
    
    // Get total open buy positions
    int total = PositionsTotal();
    if(total == 0)
    {
        Print("No open positions found");
        return;
    }
    
    // Process each position
    for(int i = total-1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket > 0)
        {
            if(PositionGetString(POSITION_SYMBOL) == _Symbol && 
               PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
            {
                ProcessSellPosition(ticket);
            }
        }
    }
    
    Print("Partial close script execution completed");
}

//+------------------------------------------------------------------+
//| Process a single sell position                                   |
//+------------------------------------------------------------------+
void ProcessSellPosition(ulong ticket)
{
    // Get position details
    double volume = PositionGetDouble(POSITION_VOLUME);
    string symbol = PositionGetString(POSITION_SYMBOL);
    double price = PositionGetDouble(POSITION_PRICE_OPEN);
    ulong magic = PositionGetInteger(POSITION_MAGIC);
    string comment = PositionGetString(POSITION_COMMENT);
    
    // Calculate lots to close
    double lotsToClose = NormalizeDouble(volume * (PartialClosePercentage / 100.0), 2);
    double remainingLots = NormalizeDouble(volume - lotsToClose, 2);
    
    // Check if we should close all instead
    if(CloseAllIfSmall && remainingLots < MinimumLotSize)
    {
        lotsToClose = volume;
        remainingLots = 0;
    }
    
    // Prepare trade request
    MqlTradeRequest request;
    MqlTradeResult result;
    ZeroMemory(request);
    ZeroMemory(result);
    
    request.action = TRADE_ACTION_DEAL;
    request.position = ticket;
    request.symbol = symbol;
    request.volume = lotsToClose;
    request.type = ORDER_TYPE_BUY;
    request.price = SymbolInfoDouble(symbol, SYMBOL_ASK);
    request.deviation = 5;
    request.magic = magic;
    request.type_filling = ORDER_FILLING_FOK; // Fill or Kill execution
    request.comment = "Partial close " + comment;
    
    // Send close request
    if(!OrderSend(request, result))
    {
        Print("Failed to close partial position ", ticket, 
              ", error: ", GetLastError(), 
              ", lots: ", lotsToClose);
    }
    else
    {
        Print("Successfully closed ", lotsToClose, 
              " lots of position ", ticket, 
              ", remaining: ", remainingLots);
    }
}
//+------------------------------------------------------------------+