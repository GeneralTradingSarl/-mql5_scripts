//+------------------------------------------------------------------+
//|                                                   MinMargins.mq5 |
//|                                   Copyright 2024, Ayib(Pvt) Ltd. |
//|                                           https://www.ayib.co.zw |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, Ayib(Pvt) Ltd."
#property link      "https://www.ayib.co.zw"
#property version   "1.00"
//+------------------------------------------------------------------+
//| SaveMinMargins.mq5                                               |
//| Script to calculate min margins for all symbols and save to CSV  |
//+------------------------------------------------------------------+
#property strict

//#include <stderror.mqh> // Standard library for error handling

void OnStart()
{
   // Define the output file name
   string fileName = "MinMargins.csv";
   
   // Open the file for writing in the "Files" folder
   int fileHandle = FileOpen(fileName, FILE_CSV | FILE_WRITE, ';');
   
   if (fileHandle == INVALID_HANDLE)
   {
      Print("Failed to create file: ", GetLastError());
      return;
   }
   
   // Write the header row
   FileWrite(fileHandle, "Symbol", "Min Lot Size", "Min Margin","Sym Path");
   
   // Get the total number of symbols in the Market Watch
   int totalSymbols = SymbolsTotal(false); // False for not selected
   
   for (int i = 0; i < totalSymbols; i++)
   {
      // Get the symbol name
      string symbolName = SymbolName(i, false);
      
      if (symbolName == "")
      {
         Print("Failed to retrieve symbol name for index: ", i);
         continue;
      }
      
      // Get the minimum margin for the symbol
      string category = SymbolInfoString(symbolName,SYMBOL_PATH);
      double minLotSize = SymbolInfoDouble(symbolName, SYMBOL_VOLUME_MIN);
      double contractSize = SymbolInfoDouble(symbolName, SYMBOL_TRADE_CONTRACT_SIZE);
      double price = SymbolInfoDouble(symbolName, SYMBOL_BID);
      double leverage = AccountInfoInteger(ACCOUNT_LEVERAGE);
      double leverageFraction = 1.0 / leverage;
      
      double margin = minLotSize * contractSize * price * leverageFraction;

      // Check for errors in retrieving margin info
      if (minLotSize <= 0 || contractSize <= 0 || price <= 0 || leverage <= 0)
      {
         Print("Failed to retrieve necessary data for symbol: ", symbolName);
         continue;
      }
      printf(category);
      // Write the symbol and its margin to the CSV file
      FileWrite(fileHandle, symbolName, DoubleToString(minLotSize, 2), DoubleToString(margin, 2),category);
   }
   
   // Close the file
   FileClose(fileHandle);
   Print("Min margins saved to file: ", fileName);
}
