//+------------------------------------------------------------------+
//|                           Scirpt-Count-Consecutive-Bull-Bear.mq5 |
//|                                      Copyright 2024,Rosh Jardine |
//|                        https://www.mql5.com/en/users/roshjardine |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024,Rosh Jardine"
#property link      "https://www.mql5.com/en/users/roshjardine"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
   {
      //---
      int count_in = 0;
      count_in = CONSECUTIVE_BB(true,150);
      Print("highest bull consecutive = ",IntegerToString(count_in));
      count_in = CONSECUTIVE_BB(false,150);
      Print("highest bear consecutive = ",IntegerToString(count_in));

   }
//+------------------------------------------------------------------+
int CONSECUTIVE_BB(bool param_count_bull_bo,int param_look_back_in)
   {
      int look_back_in = (param_look_back_in<2) ? 3 : param_look_back_in;
      //--- for testing purpose only
      string pattern_text = "";
      for (int i=1;i<=look_back_in;i++)
         {
            if (iClose(_Symbol,PERIOD_CURRENT,i)>iOpen(_Symbol,PERIOD_CURRENT,i))
               {
                  pattern_text += "a";
               }
            else 
               {
                  if (iClose(_Symbol,PERIOD_CURRENT,i)<iOpen(_Symbol,PERIOD_CURRENT,i))
                     {
                        pattern_text += "b";
                     }
                  else 
                     {
                        pattern_text += "c";
                     }  
               }                 
         }
      Print("pattern_text=",pattern_text); 
      string consecutive_text = ""; string last_consecutive_text = ""; string highest_consecutive_text = "";
      if (param_count_bull_bo)
         {
            for (int i=1;i<look_back_in-1;i++)
               {
                  if (
                        iClose(_Symbol,PERIOD_CURRENT,i)>iOpen(_Symbol,PERIOD_CURRENT,i) &&
                        iClose(_Symbol,PERIOD_CURRENT,i+1)>iOpen(_Symbol,PERIOD_CURRENT,i+1)
                     )
                     {
                        consecutive_text += "a";
                        last_consecutive_text = consecutive_text;
                     }
                  else 
                     {
                        if (StringLen(last_consecutive_text)>StringLen(highest_consecutive_text))
                           {
                              Print("last_consecutive_text bull=",last_consecutive_text);     
                              highest_consecutive_text = last_consecutive_text;
                           }
                        consecutive_text = "";
                        i++;
                     }   
                  
               }
            Print("highest_consecutive_text bull=",highest_consecutive_text);     
         }
      else 
         {
            for (int i=1;i<look_back_in-1;i++)
               {
                  if (
                        iClose(_Symbol,PERIOD_CURRENT,i)<iOpen(_Symbol,PERIOD_CURRENT,i) &&
                        iClose(_Symbol,PERIOD_CURRENT,i+1)<iOpen(_Symbol,PERIOD_CURRENT,i+1)
                     )
                     {
                        consecutive_text += "b";
                        last_consecutive_text = consecutive_text;
                     }
                  else 
                     {
                        if (StringLen(last_consecutive_text)>StringLen(highest_consecutive_text))
                           {
                              Print("last_consecutive_text bear=",last_consecutive_text);     
                              highest_consecutive_text = last_consecutive_text;
                           }
                        consecutive_text = "";
                        i++;
                     }   
                  
               }
            Print("highest_consecutive_text bear=",highest_consecutive_text);     
         }   
      //--- include the first predecessor +1, count only successors return string length
      return(StringLen(highest_consecutive_text)+1);
   }
  
     
 