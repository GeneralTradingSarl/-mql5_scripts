//+------------------------------------------------------------------+
//|                               Traders Toolbox Licence Create.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property script_show_inputs

#include </CLicence.mqh>

//--- input parameters
input string      EncyptionKey;         // Encryption Key
input string      BrServer;              // Broker Server
input string      AccountNo;            // Account Number
input string      FileName;             // File Name
input bool        CommonFolder = true;  // Put in Common Folder


//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
   {
//---
    string KeyStr = "This is the Master Key";
    string AccountStr = IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN));
    string BrokerServStr = AccountInfoString(ACCOUNT_SERVER);
    string FileStr = "EAIndicator.lic";

// if no input was specified defaults to Setttings above...
    if(EncyptionKey != "")
        KeyStr = EncyptionKey;
    if(AccountNo != "")
        AccountStr = AccountNo;
    if(BrServer != "")
        BrokerServStr = BrServer;
    if(FileName != "")
        FileStr = FileName;

    CLicence *CEALicence;
    CEALicence = new CLicence(FileStr,KeyStr, true); // true if file must be placed in common folder...
    if(CEALicence.m_Write(AccountStr, BrokerServStr))
       {
        Alert("Licence Created...");
       };
    delete CEALicence;
   }
//+------------------------------------------------------------------+
