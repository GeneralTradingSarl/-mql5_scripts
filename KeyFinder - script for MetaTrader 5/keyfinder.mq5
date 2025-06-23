//+------------------------------------------------------------------+
//|                                                    KeyFinder.mq5 |
//|                                                   Trofimov Pavel |
//|                                               trofimovpp@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Trofimov Pavel"
#property link      "trofimovpp@mail.ru"
#property version   "1.00"
#property description "Внимание! Данный алгоритм использует в расчетах циклы!"
#property description "Настоятельно рекомендуется задавать для обработки не более 1000 баров!"
#property script_show_inputs
//--- input parameters
input int      MinDimesion=5;//Минимальная размерность точек
input int      MaxBars=300;//Количество обрабатываемых баров
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
//проверка доступности истории для установленного количества баров
   int SMaxBars=Bars(Symbol(),0),iMaxBars=MaxBars;
   if(SMaxBars<MaxBars) 
     {
      iMaxBars=SMaxBars;
      Comment("Параметр MaxBars задан слишком большим."+"\n"+"Для расчетов будет использовано "+IntegerToString(SMaxBars)+" баров.");
     };
   int clean=CleanChart();//чистим график при повторном применении
   MqlRates  rates_array[];
   string Com="";
   int iCod=CopyRates(Symbol(),Period(),0,iMaxBars,rates_array);//количество элементов массива
   iCod=iCod-1;//Индекс максимального элемента в массиве
   Com="Работаю...Ждите!";
   Comment(Com);
   if(iCod>0)
     {
      FindUpKeyPoints(iCod,rates_array);//Поиск верхних ключевых точек
      Com=Com+"\n"+"Обработаны верхние точки."+"\n";
      Comment(Com);
      FindLowKeyPoints(iCod,rates_array);//Поиск нижних ключевых точек
      Comment("Обработка завершена");
     }
   else Comment("Отсутствуют бары для обработки!!!");
  }
//+------------------------------------------------------------------+
//|                  Поиск верхних ключевых точек                    |
//+------------------------------------------------------------------+
void FindUpKeyPoints(int temp_iCod,MqlRates &temp_rates[])
  {
   int HD=1;
   for(int i=temp_iCod-MinDimesion; i>(MinDimesion-1); i--)//цикл по барам от конечного - MinDimension до нулевого + MinDimension
     {
      HD=getHighDimension(temp_rates,i,temp_iCod);//получаем размерность точек
      if((HD>=MinDimesion) || (HD==-1))
        {//создаем марку если попадает под условия MinDimension
         string Ob_Name="KF_Label"+IntegerToString(i);
         if(HD!=-1)
           {
            ObjectCreate(0,Ob_Name,OBJ_TEXT,0,temp_rates[i].time,temp_rates[i].high);
            ObjectSetInteger(0,Ob_Name,OBJPROP_ANCHOR,0,ANCHOR_LOWER);
            ObjectSetString(0,Ob_Name,OBJPROP_TEXT,0,IntegerToString(HD));
            ObjectSetInteger(0,Ob_Name,OBJPROP_COLOR,clrRed);
           }
         else 
           { //Если не можем определить размерность маркируем шариком
            ObjectCreate(0,Ob_Name,OBJ_ARROW,0,temp_rates[i].time,temp_rates[i].high);
            ObjectSetInteger(0,Ob_Name,OBJPROP_ARROWCODE,0,159);
            ObjectSetInteger(0,Ob_Name,OBJPROP_ANCHOR,0,ANCHOR_BOTTOM);
            ObjectSetInteger(0,Ob_Name,OBJPROP_COLOR,clrRed);
           };
        };
     };
  }
//+------------------------------------------------------------------+
//|                    Поиск нижних ключевых точек                   |
//+------------------------------------------------------------------+   
void FindLowKeyPoints(int temp_iCod,MqlRates &temp_rates[])
  {
   int LD=1;//инициализируем размерности точек
   bool iCreate;
   for(int i=temp_iCod-MinDimesion; i>(MinDimesion-1); i--)
     {
      LD=getLowDimension(temp_rates,i,temp_iCod);
      if((LD>=MinDimesion) || (LD==-1))
        {
         string Ob_Name="KF_Label"+IntegerToString(i)+"_1";//Страхуемся от баров где лой и хай могут быть ключевыми точками
         if(LD!=-1) 
           {
            iCreate=ObjectCreate(0,Ob_Name,OBJ_TEXT,0,temp_rates[i].time,temp_rates[i].low);
            if(iCreate) 
              {
               ObjectSetInteger(0,Ob_Name,OBJPROP_ANCHOR,0,ANCHOR_UPPER);
               ObjectSetString(0,Ob_Name,OBJPROP_TEXT,0,IntegerToString(LD));
               ObjectSetInteger(0,Ob_Name,OBJPROP_COLOR,clrGreen);
              }
            else Comment("Не могу создать объект");
           }
         else 
           {
            iCreate=ObjectCreate(0,Ob_Name,OBJ_ARROW,0,temp_rates[i].time,temp_rates[i].low);
            if(iCreate) 
              {
               ObjectSetInteger(0,Ob_Name,OBJPROP_ARROWCODE,0,159);
               ObjectSetInteger(0,Ob_Name,OBJPROP_ANCHOR,0,ANCHOR_TOP);
               ObjectSetInteger(0,Ob_Name,OBJPROP_COLOR,clrGreen);
              }
            else Comment("Не могу создать объект");
           };
        };
     };
  }
//+------------------------------------------------------------------+
//|                Определение размерности верхней точки             |
//+------------------------------------------------------------------+
int getHighDimension(MqlRates &tmpRates[],int tmp_i,int tmp_iCod)
  {
   int k=1;
   while((tmpRates[tmp_i].high>tmpRates[tmp_i+k].high) && (tmpRates[tmp_i].high>tmpRates[tmp_i-k].high) && ((tmp_i+k)<(tmp_iCod)) && ((tmp_i-k)>0)) k++;
   if(((tmp_i+k)==tmp_iCod) || ((tmp_i-k)==0)) k=-1;
   return(k);
  }
//+------------------------------------------------------------------+
//|                Определение размерности нижней точки              |
//+------------------------------------------------------------------+
int getLowDimension(MqlRates &tmpRates[],int tmp_i,int tmp_iCod)
  {
   int k=1;
   while((tmpRates[tmp_i].low<tmpRates[tmp_i+k].low) && (tmpRates[tmp_i].low<tmpRates[tmp_i-k].low) && ((tmp_i+k)<(tmp_iCod)) && ((tmp_i-k)>0)) k++;
   if(((tmp_i+k)==tmp_iCod) || ((tmp_i-k)==0)) k=-1;
   return(k);
  }
//+-------------------------------------------------------------------------------+
//| Очистка графика от созданных скриптом объектов в случае повторного применения |
//+-------------------------------------------------------------------------------+
int CleanChart()
  {
   string Label="KF_Label";
   int obj_total=ObjectsTotal(0,0,-1),n=0;
   for(int obj=obj_total-1; obj>=0; obj--)
     {
      string objname=ObjectName(0,obj,0,-1);
      if(StringFind(objname,Label)>=0) ObjectDelete(0,objname);
      n++;
     }
   return(n);
  }
//+------------------------------------------------------------------+
