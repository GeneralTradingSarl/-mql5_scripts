//+------------------------------------------------------------------+
//|                                                     WideShootrer |
//|                                           Copyright 2012,Karlson |
//+------------------------------------------------------------------+
#property copyright   "2012, Karlson."
#property link        "https://login.mql5.com/ru/users/Karlson"
#property description "WideShootrer"
#property version "1.00"
//-------------------------------------------------------------------+
double High[],Low[];
int bars=1500,KF=1; // скрин будет отображать 1500 баров от левого края графика направо
//-------------------------------------------------------------------+
void OnStart()
  {
   if(_Digits==5 || _Digits==3) {KF=10;} else {KF=1;}

// определяем первый левый бар.От него будем делать скриншот

   int first_bar=(int)ChartGetInteger(0,CHART_FIRST_VISIBLE_BAR);

// определяем сколько показывает на графике баров - потребуется для определения ширины скриншота

   int vis_bar=(int)ChartGetInteger(0,CHART_VISIBLE_BARS);Print("По ширине графика отображено баров=",vis_bar);

// получаем цены в массив на промежутке с нашего бара и 1500 баров для установки хай-лоу графика

   if(first_bar<bars) {bars=first_bar;} // если график смещен менее чем требуется баров,тогда берем все что есть вправо до текущего времени

   int ch=CopyHigh(_Symbol,_Period,first_bar-bars,bars,High);
   int cl=CopyLow(_Symbol,_Period,first_bar-bars,bars,Low);

// определяем хай лоу на нашем промежутке и устанавливаем верх низ шкалы цены

   double min_price=Low[ArrayMinimum(Low,0,bars)];

   double max_price=High[ArrayMaximum(High,0,bars)];

// зафиксируем шкалу и установим верх низ

   ChartSetInteger(0,CHART_SCALEFIX,0,1);
   ChartSetDouble(0,CHART_FIXED_MAX,max_price+20*KF*_Point);
   ChartSetDouble(0,CHART_FIXED_MIN,min_price-20*KF*_Point);
   ChartSetInteger(0,CHART_AUTOSCROLL,false);

// получим текущую дату в простом формате для фомирования имени файла

   MqlDateTime day;

   TimeToStruct(TimeCurrent(),day);

   string file=_Symbol+(string)day.year+"_"+(string)day.mon+"_"+(string)day.day+"_"+(string)day.hour+"_"+(string)day.min+"_"+(string)day.sec+".png";

// определим высоту и ширину будущего скрина

   int screen_width=1000*bars/vis_bar;Print("Ширина скрина=",screen_width);

   int scr_height=(int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS);

// сделаем скриншот

   ChartScreenShot(0,file,screen_width,scr_height,ALIGN_LEFT);

   if(GetLastError()>0) {Print("Error  (",GetLastError(),") ");} ResetLastError();

  }

//+------------------------------------------------------------------+
