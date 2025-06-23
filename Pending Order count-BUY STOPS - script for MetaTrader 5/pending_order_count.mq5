//+------------------------------------------------------------------+
//|                                                       Test_2.mq5 |
//|                                 Copyright 2023, Obunadike Chioma |
//|                                  https://www.wa.me/2349124641304 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Obunadike Chioma"
#property link      "https://www.wa.me/2349124641304"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

int   count =0; 
void OnStart() 
  { 
//--- variables for returning values from order properties 
   ulong    ticket; 
   double   open_price; 
   double   initial_volume; 
   datetime time_setup; 
   string   symbol; 
   string   type; 
   long     order_magic; 
   long     positionID; 
//--- number of current pending orders 
   uint     total=OrdersTotal(); 
   
//--- go through orders in a loop 
   for(uint i=0;i<total;i++) 
     {  
      //--- return order ticket by its position in the list 
      if((ticket=OrderGetTicket(i))>0) 
        { 
         //--- return order properties 
         open_price    =OrderGetDouble(ORDER_PRICE_OPEN); 
         time_setup    =(datetime)OrderGetInteger(ORDER_TIME_SETUP); 
         symbol        =OrderGetString(ORDER_SYMBOL); 
         order_magic   =OrderGetInteger(ORDER_MAGIC); 
         positionID    =OrderGetInteger(ORDER_POSITION_ID); 
         initial_volume=OrderGetDouble(ORDER_VOLUME_INITIAL); 
         type          =EnumToString(ENUM_ORDER_TYPE(OrderGetInteger(ORDER_TYPE))); 
 
                
 
         //--- If order type = buystop increase and symbol = current symbol, increase counter
         
         if((symbol==_Symbol)&&(type== EnumToString(ORDER_TYPE_BUY_STOP)))
        
            count++;
            
       
        }


     }
  
  Print ("There are", " ", count, " ", "Buy stop orders in", " ", _Symbol);
 }