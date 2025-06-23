//+------------------------------------------------------------------+
//|                                         AccountHistoryExport.mq5 |
//|                                      Copyright 2021, Yuriy Bykov |
//|                               https://www.mql5.com/ru/code/37495 |
//|                               https://www.mql5.com/en/code/38976 |
//|                               https://www.mql5.com/en/code/38935 |
//|                               https://www.mql5.com/en/code/38975 |
//|                     https://www.mql5.com/ru/market/product/75526 |
//+------------------------------------------------------------------+
#property description   "Export deals history for current account to CSV-file"
#property copyright     "Copyright 2021, Yuriy Bykov"
#property link          "https://www.mql5.com/ru/code/37495"
#property link          "https://www.mql5.com/ru/code/38976"
#property link          "https://www.mql5.com/en/code/38935"
#property link          "https://www.mql5.com/en/code/38975"
#property link          "https://www.mql5.com/ru/market/product/75526"
#property version       "1.2"

#property strict
#property script_show_inputs

enum ENUM_EXRORT_DATA_FORMAT {
   EDF_COMMA_POINT,  // For data: ',' (comma) / For Decimal: '.' (dot)
   EDF_COMMA_COMMA,  // For data: ',' (comma) / For Decimal: ',' (comma)
   EDF_SEMI_POINT,   // For data: ';' (semicolon) / For Decimal: '.' (dot)
   EDF_SEMI_COMMA,   // For data: ';' (semicolon) / For Decimal: ',' (comma)
};

#include <ExpertHistory.mqh>

input string accountName = "";   // Name for file. Auto-generating if it is blank
input ENUM_EXRORT_DATA_FORMAT exportDataFormat = EDF_COMMA_POINT; // Separators
input bool useCommonFolder = false; // Save file to Common Folder

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart() {
//---
   string separator = ",";
   string decimalPoint = ".";
   uint commonFlag = 0;

   if(exportDataFormat == EDF_SEMI_COMMA || exportDataFormat == EDF_SEMI_POINT) {
      separator = ";";
   }

   if(exportDataFormat == EDF_COMMA_COMMA || exportDataFormat == EDF_SEMI_COMMA) {
      decimalPoint = ",";
   }

   if(useCommonFolder) {
      commonFlag = FILE_COMMON;
   }

   CExpertHistory accountHistory(accountName, "", separator, decimalPoint);

   accountHistory.Export(accountName, HEF_CSV_DEALS, HFF_ACCOUNT_PERIOD, commonFlag);
}
//+------------------------------------------------------------------+
