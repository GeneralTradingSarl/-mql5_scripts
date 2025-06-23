#property copyright "*"
#property link      "*"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {

   double d=DotToLineDist(78,251,138,226,346,208);
   Alert(d);


}
//+------------------------------------------------------------------+

double DotToLineDist(double LX1,double LY1,double LX2,double LY2,double DX, double DY){
   double K=(LY2-LY1)/(LX2-LX1);
   double LA=LY1-K*LX1;
   double DA=DX+K*DY; 
   double CX=(DA-K*LA)/(1.0+K*K); 
   double CY=LA+K*CX;
   return(MathSqrt(MathPow(DX-CX,2)+MathPow(DY-CY,2)));
}