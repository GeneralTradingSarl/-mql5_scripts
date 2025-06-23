//+------------------------------------------------------------------+
//|                                    SCT_BestTimeStrategyWorks.mq5 |
//|                                    Copyright 2020, Forex Jarvis. |
//|                                            forexjarvis@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Forex Jarvis. forexjarvis@gmail.com"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property script_show_inputs

input datetime dStartingDate = D'2020.01.01 00:00:00';   // START DATE
input double   dWL = 40;                                 // Win/Loss ratio
input double   dRR = 2;                                  // Reward/Risk ratio

#define SIZE 5
double dAmtWon[24][SIZE];      // AMOUNT WON
double dAmtWonTotal;
double dAmtLoss[24][SIZE];     // AMOUNT LOSS
double dAmtLossTotal;
double dWins[24][SIZE];        // TRADES WON
double dWinsTotal;
double dLoss[24][SIZE];        // TRADES LOST
double dLossTotal;

int TimeDayOfWeekMQL4(datetime date)
  {
   MqlDateTime tm;
   TimeToStruct(date,tm);
   return(tm.day_of_week);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
{

   int handle = FileOpen("BestTimeStrategyWorks"+".csv",FILE_CSV|FILE_READ|FILE_WRITE,',');

   HistorySelect(dStartingDate,TimeCurrent());

   ulong ticket;
   int total = HistoryDealsTotal();
   int i;
   int j;
   
   int iDayOfWeek;
   string sDayOfWeek;
   
   if(handle>0) {

      FileSeek(handle,0,SEEK_SET);
      FileWrite(handle, "Day of week", "Hour of Day", "Sum of Wins", "Sum of Losses", "Sum of AmountWon", "Sum of AmountLost", "Win/Loss Ratio", "Reward/Risk Ratio");
      
      for(j=0;j<total;j++) {
            
         if((ticket=HistoryDealGetTicket(j))>0) {
         
            double price      = HistoryDealGetDouble(ticket,DEAL_PRICE);
            long entry        = HistoryDealGetInteger(ticket,DEAL_ENTRY);
            datetime dtime    = (datetime)HistoryDealGetInteger(ticket,DEAL_TIME);
            double profit     = HistoryDealGetDouble(ticket,DEAL_PROFIT);
            double commission = HistoryDealGetDouble(ticket,DEAL_COMMISSION);

            if (price && dtime && entry==DEAL_ENTRY_OUT) {

               iDayOfWeek = TimeDayOfWeekMQL4(dtime)-1;
                
               ulong DealTicket=HistoryDealGetTicket(j);
               
               i=(int)StringSubstr(TimeToString(dtime, TIME_MINUTES),0,2);

   				if(HistoryDealGetDouble(DealTicket,DEAL_PROFIT)>=0){
                  dWins[i][iDayOfWeek] = dWins[i][iDayOfWeek]+1;
   					dAmtWon[i][iDayOfWeek] = dAmtWon[i][iDayOfWeek]+profit+2*commission;

   				} else {
   					dLoss[i][iDayOfWeek] = dLoss[i][iDayOfWeek]+1;
   					dAmtLoss[i][iDayOfWeek] = dAmtLoss[i][iDayOfWeek]+profit+2*commission;
   				}
            }
         }
      }
      
      double percent=0.0, percenttotal=0.0;
      double rr=0.0, rrtotal=0.0;
      int k, v;

      for (v=0; v<5; v++) {
         for (k=0; k<24; k++) {
            if (dWins[k][v]>0)
               percent = (dWins[k][v]/(dWins[k][v]+dLoss[k][v]))*100;
            else 
               percent = 0;
               
            if (dAmtLoss[k][v]!=0)
               rr= MathAbs(dAmtWon[k][v]/dAmtLoss[k][v]);
            else if (dAmtWon[k][v]!=0)
               rr=100;

            if (v==0) sDayOfWeek="Monday";
            else if (v==1) sDayOfWeek="Tuesday";
            else if (v==2) sDayOfWeek="Wednesday";
            else if (v==3) sDayOfWeek="Thursday";
            else if (v==4) sDayOfWeek="Friday";
            
            if(percent>dWL && rr>=dRR) {
               dWinsTotal=dWinsTotal+dWins[k][v];
               dLossTotal=dLossTotal+dLoss[k][v];
               dAmtWonTotal=dAmtWonTotal+dAmtWon[k][v];
               dAmtLossTotal=dAmtLossTotal+dAmtLoss[k][v];
               FileWrite(handle, sDayOfWeek, k, DoubleToString(dWins[k][v],0), DoubleToString(dLoss[k][v],0), DoubleToString(dAmtWon[k][v],1), DoubleToString(dAmtLoss[k][v],1), DoubleToString(percent,0), DoubleToString(rr,1));
               
            }
         }
      }
      
      if (dWinsTotal>0)
         percenttotal = (dWinsTotal/(dWinsTotal+dLossTotal))*100;
      else 
         percenttotal = 0;
         
      if (dAmtLossTotal!=0)
         rrtotal= MathAbs(dAmtWonTotal/dAmtLossTotal);
      else if (dAmtWonTotal!=0)
         rrtotal=100;
      
      FileWrite(handle, "\nBest strategy's performance with :\n* At least "+DoubleToString(dWL,0)+"% W/L Ratio and\n* At least "+DoubleToString(dRR,0)+"|1 R/R Ratio", "", DoubleToString(dWinsTotal,0), DoubleToString(dLossTotal,0), DoubleToString(dAmtWonTotal,1), DoubleToString(dAmtLossTotal,1), DoubleToString(percenttotal,0), DoubleToString(rrtotal,1));
 
   }
   
   FileClose(handle);

}