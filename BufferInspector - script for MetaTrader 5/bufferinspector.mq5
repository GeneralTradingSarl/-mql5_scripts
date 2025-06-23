//+------------------------------------------------------------------+
//defines
   #define VERSION "1.00"
//properties
   #property copyright "Copyright 2017, Diogo 'Quebralim' Seca"
   #property link      "https://www.mql5.com/en/users/quebralim"
   #property version   VERSION
   #property description "The following Script iterates throughout all indicators attached to a given Chart."
   #property description "The output is in the following form:\n"
   #property description "INDICATOR_NAME [BUFFER_INDEX] [POSITION_INDEX] = VALUE"
   #property script_show_inputs
//inputs
   input int ValuesPerBuffer  = 1; //Values Per Buffer
   input uint DigitsToShow    = 5; //Digits to Show
   
//+------------------------------------------------------------------+
//| Start
//+------------------------------------------------------------------+
void OnStart(){
   //verifiy the input ValuesPerBuffer
   if (ValuesPerBuffer < 1 || ValuesPerBuffer > 10){
      MessageBox("BufferInspector Input Error!\n\n"+
                 "Please input a 'Values Per Buffer' between 1 and 10.", 
                 "BufferInspector "+VERSION, MB_ICONERROR|MB_OK);
      return;
   }
   
   //compute DigitsToShow_
   int Digits = DigitsToShow ? (int)DigitsToShow : _Digits;

   //initialize buffer & chart
   double buffer[];
   ArrayResize(buffer,ValuesPerBuffer);
   long chart = ChartID();
   
   //loop until stopped by user 
   while(!_StopFlag){
      string result_output = "";
      //iterate throughout all windows
      long n_windows = ChartGetInteger(ChartID(),CHART_WINDOWS_TOTAL);
      for(int w=0; w<n_windows && !_StopFlag; ++w){ 
         //iterate throughout all indicators
         long n_indicators = ChartIndicatorsTotal(chart,w);
         for(int i=0; i<n_indicators && !_StopFlag; i++){
            string name = ChartIndicatorName(chart,w,i);
            int ind_handle = ChartIndicatorGet(chart,w,name);
            //iterate throughout buffers
            int buffer_index = 0;
            while (CopyBuffer(ind_handle,buffer_index,0,ValuesPerBuffer,buffer) == ValuesPerBuffer && !_StopFlag){
               //iterate throughout all requested values
               for (int v=0; v<ValuesPerBuffer; ++v)
                  result_output +="\n"+name 
                                +"["+IntegerToString(buffer_index)+"]"
                                +"["+IntegerToString(v)+"]"
                                +"="+DoubleToString(NormalizeDouble(buffer[v],Digits),Digits);
               ++buffer_index;
            }
            result_output += "\n";
         }
      }
      //comment the result
      if (result_output != "")
         Comment("BufferInspector "+VERSION+":\n"+result_output);
      else 
         Comment("BufferInspector "+VERSION+":\n\nNo Buffers have been found.");
      //rerun every 1000 milisecs
      Sleep(1000);
   }
   
   //clean up
   Comment("");
}
//+------------------------------------------------------------------+
