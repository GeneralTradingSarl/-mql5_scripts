//+------------------------------------------------------------------+
//|                                          s-LastPinkEventDate.mq5 |
//|                                              Alexander Piechotta |
//|                                       http://www.metatraders.de/ |
//+------------------------------------------------------------------+
#property script_show_inputs
#property copyright   "Alexander Piechotta"
#property link        "http://www.metatraders.de/"
#property version     "1.00"
#property description "Ein Skript welches als Demonstration aus dem" 
#property description "Economic Calendar mit aktuelle Wirtschaftsdaten" 
#property description "das Datum vom letzten wichtigen(Pink) Ereignis ausgibt."
#property description "Wenn vorhanden und aktiviert."
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   datetime date=last_pink_event_date(); // ermittelt das Datum des letzten Pink Event
   if(date>0) MessageBox("LastPinkEventDate = "+string(date),"Information",0); //wenn ein event vorhanden gib mir das Datum aus
   else MessageBox("Sorry, Kein 'Last Pink Event' vorhanden.","Information",0); // Sorry
  }
//+------------------------------------------------------------------+
//| Funktion gibt das Datum vom letzten Pink Ereignis zuruck         |
//+------------------------------------------------------------------+
datetime last_pink_event_date()
  {
   string  name="";
   int total=ObjectsTotal(0)-1;

   for(int i=total; i>=0; i --)
     {
      name=ObjectName(0,i);

      if(ObjectGetInteger(0,name,OBJPROP_TYPE,0)  !=  109) continue; // Objekt Typ muss eine event sein
      if(ObjectGetInteger(0,name,OBJPROP_COLOR,0) != Pink) continue; // Objekt muss Farbe Pink haben

      datetime date=(datetime)StringSubstr(name,0,16); // extrahiere das Datum aus dem Objekt Namen

      return(date); //gibt das Datum zuruck
     }

   return(0);
  }
//+------------------------------------------------------------------+
