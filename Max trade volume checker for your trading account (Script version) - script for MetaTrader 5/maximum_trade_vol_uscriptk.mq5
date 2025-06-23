#define OBJ_PREFIX MQLInfoString(MQL_PROGRAM_NAME)

int fontSize = 10;

string objName, panelName;

void OnStart(){

    double maxBuyLot = LotCheckBuy();
    double maxSellLot = LotCheckSell();
    
    double priceMax =  ChartGetDouble(0, CHART_PRICE_MAX) - 200*_Point;
    double priceMin = ChartGetDouble(0, CHART_PRICE_MIN);
    datetime timeStart = iTime(_Symbol, _Period, 10);
    datetime timeEnd = TimeCurrent();
    
    panelName = OBJ_PREFIX + "TradeVolumePanel";
    
    ObjectCreate(0, panelName, OBJ_RECTANGLE, 0, timeStart, priceMax, timeEnd, priceMin);

    ObjectSetInteger(0, panelName, OBJPROP_COLOR, clrYellow); // Background color
    ObjectSetInteger(0, panelName, OBJPROP_STYLE, STYLE_SOLID);
    ObjectSetInteger(0, panelName, OBJPROP_WIDTH, 4);       // Border width
    ObjectSetInteger(0, panelName, OBJPROP_FILL, true);
    ObjectSetInteger(0, panelName, OBJPROP_BACK, false);
        
    string info_1 = "Max Buy Lot: " + DoubleToString(maxBuyLot, 2);
    string info_2 = "Max Sell Lot: " + DoubleToString(maxSellLot, 2);

    makeLabel(170, 70, CORNER_RIGHT_UPPER, fontSize, clrBlack, info_1, 1);
    makeLabel(170, 90, CORNER_RIGHT_UPPER, fontSize, clrBlack, info_2, 2);
    
    double lot;
    string str;
    
    if(NormalizeDouble(maxBuyLot, 2) == NormalizeDouble(maxSellLot, 2)){
    
      lot = maxBuyLot;
      str = "Max lot permitted: " + DoubleToString(lot, 2);
    }
    else{
    
      str = "Max buy lot: " +  DoubleToString(maxBuyLot, 2) + "\n" + "Max sell lot: " +  DoubleToString(maxSellLot, 2);  
    }
    
    Comment(str);

    Sleep(3000);  // Keep panel visible for 3 seconds

    ObjectsDeleteAll(0, OBJ_PREFIX);  
    Comment("");

}

//+------------------------------------------------------------------+
//| Calculate max Lot Size                                           |
//+------------------------------------------------------------------+
double LotCheckBuy(){

    double margin_for_one_lot;
    static double lotSize;

    double currentMargin = AccountInfoDouble(ACCOUNT_MARGIN_FREE);

    if (!OrderCalcMargin(ORDER_TYPE_BUY, _Symbol, 1.0, SymbolInfoDouble(_Symbol, SYMBOL_ASK), margin_for_one_lot))
        Print("Could not obtain the margin required to open 1 lot");

    lotSize = currentMargin / margin_for_one_lot;

    double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
    double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
    double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);

    lotSize = MathMax(minLot, MathFloor(lotSize / lotStep) * lotStep);

    return lotSize;
}

double LotCheckSell(){

    double margin_for_one_lot;
    static double lotSize;

    double currentMargin = AccountInfoDouble(ACCOUNT_MARGIN_FREE);

    if (!OrderCalcMargin(ORDER_TYPE_SELL, _Symbol, 1.0, SymbolInfoDouble(_Symbol, SYMBOL_BID), margin_for_one_lot))
        Print("Could not obtain the margin required to open 1 lot");

    lotSize = currentMargin / margin_for_one_lot;

    double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
    double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
    double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);

    lotSize = MathMax(minLot, MathFloor(lotSize / lotStep) * lotStep);

    return lotSize;
}

void makeLabel(int xPos, int yPos, ENUM_BASE_CORNER corner, int textFontSize, color fontColor, string info, int index){

   objName = OBJ_PREFIX + "InfoPanel" + IntegerToString(index);

    if (ObjectFind(0, objName) < 0) {
        ObjectCreate(0, objName, OBJ_LABEL, 0, 0, 0);
    }

    ObjectSetInteger(0, objName, OBJPROP_XDISTANCE, xPos);
    ObjectSetInteger(0, objName, OBJPROP_YDISTANCE, yPos);
    ObjectSetInteger(0, objName, OBJPROP_CORNER, corner);
    ObjectSetInteger(0, objName, OBJPROP_FONTSIZE, textFontSize);
    ObjectSetInteger(0, objName, OBJPROP_COLOR, fontColor);
    ObjectSetString(0, objName, OBJPROP_TEXT, info);
    ObjectSetInteger(0, objName, OBJPROP_BACK, false);
}