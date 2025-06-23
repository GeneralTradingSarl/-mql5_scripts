//+------------------------------------------------------------------+
//|                                           Read data from csv.mq5 |
//|                                                    Lazarev Denis |
//|                                                 vk.com/lazarevdm |
//+------------------------------------------------------------------+
#property copyright "Lazarev Denis"
#property link      "vk.com/lazarevdm"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
int filehandle;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
  {
   filehandle=FileOpen("News.csv",FILE_READ|FILE_CSV|FILE_ANSI,';');
   string column1=FileReadString(filehandle);
   Alert("column1=",column1);
   string column2=FileReadString(filehandle);
   Alert("column2=",column2);
   string column3=FileReadString(filehandle);
   Alert("column3=",column3);
   string column4=FileReadString(filehandle);
   Alert("column4=",column4);
   while(column4!="true")
     {
      column1=FileReadString(filehandle);
      column2=FileReadString(filehandle);
      column3=FileReadString(filehandle);
      column4=FileReadString(filehandle);
     }
   Alert("Needed value in the",column1," line");
  }
//+------------------------------------------------------------------+
