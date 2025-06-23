//+------------------------------------------------------------------+
//|                                              ForAfterTesting.mq5 |
//|                                                          Sigma7i |
//|                                                   sigma7i@mail.ru|
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Sigma7i"
#property link      "sigma7i@mail.ru"
#property version   "2.01"

#property description "Script ForAfterTesting for changing the display"
#property description " of graphical objects created by the strategy tester."
#property description " Simplifies the analysis of profitable (parameter ChangeWinners) and" 
#property description " losing (parameter ChangeLosses) trades"
#property description "Note: It is recommended that for every new change"
#property description "you open a new chart."
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

#property script_show_inputs
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ShowModification
  {
   ChangeOnly,
   ChangeWinners,
   ChangeLosses,
   DontChange
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum TypeOfArrow
  {
   BuyArrow,
   SellArrow,
   DonotChange
  };

sinput string textr="Line Modifiers"; // Line Modifiers
input ShowModification ShowCondition=ChangeOnly; //What to change
input int Width=2; // Width
input ENUM_LINE_STYLE Style=STYLE_SOLID; // Style 
input color BuyColor=C'3,95,172'; // Buy color
input color SellColor=C'225,68,29'; // Sell color
sinput string texty="Arrow Modifiers"; // Line Modifiers
input TypeOfArrow chTypeOfArrow=DonotChange; // An arrow to change
input color clrArrow=Blue; // Color
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
  {
   int objectall=ObjectsTotal(0,0,-1);
   double Line1,Line2;
   color clrBuy=C'3,95,172',
   clrSell=C'225,68,29';
   long getcolor;
   string objName;

//+------------------------------------------------------------------+
//|Change the line parameters                                        |
//+------------------------------------------------------------------+




   for(int i=0;i<objectall;i++)
     {
      objName=ObjectName(0,i,0,OBJ_TREND);
      Line1 = ObjectGetDouble(0,objName,OBJPROP_PRICE,0);
      Line2 = ObjectGetDouble(0,objName,OBJPROP_PRICE,1);
      getcolor=(color)ObjectGetInteger(0,objName,OBJPROP_COLOR);
      if(getcolor==clrBuy)
        {
         if(ShowCondition==0)
           {
            ObjectSetInteger(0,objName,OBJPROP_WIDTH,Width);
            ObjectSetInteger(0,objName,OBJPROP_COLOR,BuyColor);
            ObjectSetInteger(0,objName,OBJPROP_STYLE,Style);
           }

         if(ShowCondition==1 && Line1<Line2) // If the starting point is lower and the final one is higher - profit
           {
            ObjectSetInteger(0,objName,OBJPROP_WIDTH,Width);
            ObjectSetInteger(0,objName,OBJPROP_COLOR,BuyColor);
            ObjectSetInteger(0,objName,OBJPROP_STYLE,Style);
           }
         else if(ShowCondition==2 && Line1>Line2)// If the starting point is higher and the final one is lower - loss
           {
            ObjectSetInteger(0,objName,OBJPROP_WIDTH,Width);
            ObjectSetInteger(0,objName,OBJPROP_COLOR,BuyColor);
            ObjectSetInteger(0,objName,OBJPROP_STYLE,Style);
           }
        }

      if(getcolor==clrSell)
        {
         if(ShowCondition==0)
           {
            ObjectSetInteger(0,objName,OBJPROP_WIDTH,Width);
            ObjectSetInteger(0,objName,OBJPROP_COLOR,SellColor);
            ObjectSetInteger(0,objName,OBJPROP_STYLE,Style);
           }

         if(ShowCondition==1 && Line1>Line2) // If the starting point is higher and the final one is lower - profit
           {
            ObjectSetInteger(0,objName,OBJPROP_WIDTH,Width);
            ObjectSetInteger(0,objName,OBJPROP_COLOR,BuyColor);
            ObjectSetInteger(0,objName,OBJPROP_STYLE,Style);
           }
         else if(ShowCondition==2 && Line1<Line2)// If the starting point is lower and the final one is higher - loss
           {
            ObjectSetInteger(0,objName,OBJPROP_WIDTH,Width);
            ObjectSetInteger(0,objName,OBJPROP_COLOR,BuyColor);
            ObjectSetInteger(0,objName,OBJPROP_STYLE,Style);
           }
        }
     }

//+------------------------------------------------------------------+
//|  Change the arrow parameters                                     |
//+------------------------------------------------------------------+

   int objectArrayBuy=ObjectsTotal(0,0,OBJ_ARROW_BUY);
   int objectArraySell=ObjectsTotal(0,0,OBJ_ARROW_SELL);

   string objName2;
   long get,get2;
   for(int i=0;i<objectall;i++)
     {//  

      objName=ObjectName(0,i,0,OBJ_ARROW_BUY);
      objName2=ObjectName(0,i,0,OBJ_ARROW_SELL);
      get=ObjectGetInteger(0,objName,OBJPROP_TYPE,0);
      get2=ObjectGetInteger(0,objName2,OBJPROP_TYPE,0);
      if(chTypeOfArrow==0 && get==OBJ_ARROW_BUY)
        {
         ObjectSetInteger(0,objName,OBJPROP_COLOR,clrArrow);
        }
      if(chTypeOfArrow==1 && get2==OBJ_ARROW_SELL)
        {
         ObjectSetInteger(0,objName2,OBJPROP_COLOR,clrArrow);
        }
     }

  }
//+------------------------------------------------------------------+
