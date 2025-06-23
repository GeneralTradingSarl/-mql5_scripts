/*
  Скрипт для загрузки исторических данных по текущему символу
*/
#property copyright "Copyright 2014, Fleder"
#property link      "https://login.mql5.com/ru/users/fleder"
#property version   "1.00"
#property description "Скрипт для загрузки исторических данных по текущему символу"
#property script_show_inputs
#include  "Library\CAggregator.mqh"

input datetime date=D'01.01.2007';   //дата
//---------------------------------------------------------------------
// Script program start function
//---------------------------------------------------------------------
void OnStart()
{
  Print("=======================================");
  CAggregator a;
  a.Download(date);
}