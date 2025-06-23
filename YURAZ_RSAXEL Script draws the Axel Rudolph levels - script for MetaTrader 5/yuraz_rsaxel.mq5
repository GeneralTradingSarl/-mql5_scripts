//+------------------------------------------------------------------+
//|                                                 YURAZ_RSAXEL.mq5 |
//|                        Copyright 2009, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "2009, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"


#include "YURAZ_ClassRSAXEL.MQH"


//
// Рисуем уровни РУДОЛЬФА АКСЕЛЯ 
// ООП

void OnStart()
  {
   Parsing *Pars=new Parsing;
   datetime  td=D'1999.01.01';
   Pars.begin(td);
   delete Pars;

  }
