#property copyright     "Integer"
#property link          "https://login.mql5.com/ru/users/Integer"
#property description   " "
#property description   "      http://dmffx.com"
#property description   " "
#property description   "      mailto:for-good-letters@yandex.ru"
#property description   " "
//+------------------------------------------------------------------+
//| cIntChart                                                        |
//+------------------------------------------------------------------+
class cIntChart
  {
private:
   long              m_id;
public:
   void Attach(long aID){m_id=aID;}
   long Mode(){return(ChartGetInteger(m_id,CHART_MODE));} // CHART_BARS, CHART_CANDLES, HART_LINE
   bool ForeGround(){return(ChartGetInteger(m_id,CHART_FOREGROUND));} // Chart foreground
   bool Shift(){return(ChartGetInteger(m_id,CHART_SHIFT));} // Chart shift pressed
   bool AutoScroll(){return(ChartGetInteger(m_id,CHART_AUTOSCROLL));} // Autoscroll pressed
   int Scale(){return((int)ChartGetInteger(m_id,CHART_SCALE));} // Scale 0-5. 0 - small bars, 5 - high bars
   bool ScaleFix(){return(ChartGetInteger(m_id,CHART_SCALEFIX));} // Fixed scale
   bool ScaleFix_11(){return(ChartGetInteger(m_id,CHART_SCALEFIX_11));} // Fixed scale 1:1
   bool ScalePtPerBar(){return(ChartGetInteger(m_id,CHART_SCALE_PT_PER_BAR));} // Scale in Points per bar
   bool ShowOHLC(){return(ChartGetInteger(m_id,CHART_SHOW_OHLC));} // Show OHLC
   bool ShowBidLine(){return(ChartGetInteger(m_id,CHART_SHOW_BID_LINE));}
   bool ShowAskLine(){return(ChartGetInteger(m_id,CHART_SHOW_ASK_LINE));}
   bool ShowLastLine(){return(ChartGetInteger(m_id,CHART_SHOW_LAST_LINE));}
   bool ShowPeriodSep(){return(ChartGetInteger(m_id,CHART_SHOW_PERIOD_SEP));}
   bool ShowGrid(){return(ChartGetInteger(m_id,CHART_SHOW_GRID));}
   int ShowVolumes(){return((int)ChartGetInteger(m_id,CHART_SHOW_VOLUMES));} // CHART_VOLUME_HIDE, CHART_VOLUME_TICK, CHART_VOLUME_REAL
   bool ShowObjDesc(){return(ChartGetInteger(m_id,CHART_SHOW_OBJECT_DESCR));}
   long VisibleBars(){return(ChartGetInteger(m_id,CHART_VISIBLE_BARS));} // Visible bars on the chart
   int WindowsTotal(){return((int)ChartGetInteger(m_id,CHART_WINDOWS_TOTAL));} // Total chart windows
   bool WindowIsVisible(int aNWindow=0){return(ChartGetInteger(m_id,CHART_WINDOW_IS_VISIBLE,aNWindow));}
   long WindowHandle(){return(ChartGetInteger(m_id,CHART_WINDOW_HANDLE));}
   int FistVisibleBar(){return((int)ChartGetInteger(m_id,CHART_FIRST_VISIBLE_BAR));}
   long WidthInBars(){return(ChartGetInteger(m_id,CHART_WIDTH_IN_BARS));}
   int WidthInPixels(){return((int)ChartGetInteger(m_id,CHART_WIDTH_IN_PIXELS));}
   int HeightInPixels(int aNWindow=0){return((int)ChartGetInteger(m_id,CHART_HEIGHT_IN_PIXELS,aNWindow));}
   color ColorBG(){return((color)ChartGetInteger(m_id,CHART_COLOR_BACKGROUND));}
   color ColorFG(){return((color)ChartGetInteger(m_id,CHART_COLOR_FOREGROUND));} // Color of axes, scale and OHLC line
   color ColorGrid(){return((color)ChartGetInteger(m_id,CHART_COLOR_GRID));}
   color ColorVolume(){return((color)ChartGetInteger(m_id,CHART_COLOR_VOLUME));}
   color ColorChartUp(){return((color)ChartGetInteger(m_id,CHART_COLOR_CHART_UP));}
   color ColorChartDoun(){return((color)ChartGetInteger(m_id,CHART_COLOR_CHART_DOWN));}
   color ColorChartLine(){return((color)ChartGetInteger(m_id,CHART_COLOR_CHART_LINE));}
   color ColorCandleBull(){return((color)ChartGetInteger(m_id,CHART_COLOR_CANDLE_BULL));}
   color ColorCandleBear(){return((color)ChartGetInteger(m_id,CHART_COLOR_CANDLE_BEAR));}
   color ColorBid(){return((color)ChartGetInteger(m_id,CHART_COLOR_BID));}
   color ColorAsk(){return((color)ChartGetInteger(m_id,CHART_COLOR_ASK));}
   color ColorLast(){return((color)ChartGetInteger(m_id,CHART_COLOR_LAST));}
   color ColorStopLevel(){return((color)ChartGetInteger(m_id,CHART_COLOR_STOP_LEVEL));}
   bool ShowTradeLevels(){return(ChartGetInteger(m_id,CHART_SHOW_TRADE_LEVELS));}
   double ShiftSize(){return(ChartGetDouble(m_id,CHART_SHIFT_SIZE));}
   double FixedMax(){return(ChartGetDouble(m_id,CHART_FIXED_MAX));}
   double FixedMin(){return(ChartGetDouble(m_id,CHART_FIXED_MIN));}
   double PtPerBar(){return(ChartGetDouble(m_id,CHART_POINTS_PER_BAR));}
   double PriceMin(int aNWindow=0){return(ChartGetDouble(m_id,CHART_PRICE_MIN,aNWindow));}
   double PriceMax(int aNWindow=0){return(ChartGetDouble(m_id,CHART_PRICE_MAX,aNWindow));}
   string Comment(){return(ChartGetString(m_id,CHART_COMMENT));}
   string Symbol(){return(ChartSymbol(m_id));}
   ENUM_TIMEFRAMES TimeFrame(){return(ChartPeriod(m_id));}
   long ID(){return(m_id);}

   void SetMode(int aValue){ChartSetInteger(m_id,CHART_MODE,aValue);}
   void SetForeGround(bool aValue){ChartSetInteger(m_id,CHART_FOREGROUND,aValue);}
   void SetShift(bool aValue){ChartSetInteger(m_id,CHART_SHIFT,aValue);}
   void SetAutoScroll(bool aValue){ChartSetInteger(m_id,CHART_AUTOSCROLL,aValue);}
   void SetScale(int aValue){ChartSetInteger(m_id,CHART_SCALE,aValue);}
   void SetScaleFix(bool aValue){ChartSetInteger(m_id,CHART_SCALEFIX,aValue);}
   void SetScaleFix_11(bool aValue){ChartSetInteger(m_id,CHART_SCALEFIX_11,aValue);}
   void SetScalePtPerBar(bool aValue){ChartSetInteger(m_id,CHART_SCALE_PT_PER_BAR,aValue);}
   void SetShowOHLC(bool aValue){ChartSetInteger(m_id,CHART_SHOW_OHLC,aValue);}
   void SetShowBidLine(bool aValue){ChartSetInteger(m_id,CHART_SHOW_BID_LINE,aValue);}
   void SetShowAskLine(bool aValue){ChartSetInteger(m_id,CHART_SHOW_ASK_LINE,aValue);}
   void SetShowLastLine(bool aValue){ChartSetInteger(m_id,CHART_SHOW_LAST_LINE,aValue);}
   void SetShowPeriodSep(bool aValue){ChartSetInteger(m_id,CHART_SHOW_PERIOD_SEP,aValue);}
   void SetShowGrid(bool aValue){ChartSetInteger(m_id,CHART_SHOW_GRID,aValue);}
   void SetShowVolumes(int aValue){ChartSetInteger(m_id,CHART_SHOW_VOLUMES,aValue);}
   void SetShowObjDesc(bool aValue){ChartSetInteger(m_id,CHART_SHOW_OBJECT_DESCR,aValue);}
   void SetColorBG(color aValue){ChartSetInteger(m_id,CHART_COLOR_BACKGROUND,aValue);}
   void SetColorFG(color aValue){ChartSetInteger(m_id,CHART_COLOR_FOREGROUND,aValue);}
   void SetColorGrid(color aValue){ChartSetInteger(m_id,CHART_COLOR_GRID,aValue);}
   void SetColorVolume(color aValue){ChartSetInteger(m_id,CHART_COLOR_VOLUME,aValue);}
   void SetColorChartUp(color aValue){ChartSetInteger(m_id,CHART_COLOR_CHART_UP,aValue);}
   void SetColorChartDoun(color aValue){ChartSetInteger(m_id,CHART_COLOR_CHART_DOWN,aValue);}
   void SetColorChartLine(color aValue){ChartSetInteger(m_id,CHART_COLOR_CHART_LINE,aValue);}
   void SetColorCandleBull(color aValue){ChartSetInteger(m_id,CHART_COLOR_CANDLE_BULL,aValue);}
   void SetColorCandleBear(color aValue){ChartSetInteger(m_id,CHART_COLOR_CANDLE_BEAR,aValue);}
   void SetColorBid(color aValue){ChartSetInteger(m_id,CHART_COLOR_BID,aValue);}
   void SetColorAsk(color aValue){ChartSetInteger(m_id,CHART_COLOR_ASK,aValue);}
   void SetColorLast(color aValue){ChartSetInteger(m_id,CHART_COLOR_LAST,aValue);}
   void SetColorStopLevel(color aValue){ChartSetInteger(m_id,CHART_COLOR_STOP_LEVEL,aValue);}
   void SetShowTradeLevels(bool aValue){ChartSetInteger(m_id,CHART_SHOW_TRADE_LEVELS,aValue);}
   void SetShiftSize(double aValue){ChartSetDouble(m_id,CHART_SHIFT_SIZE,aValue);}
   void SetFixedMax(double aValue){ChartSetDouble(m_id,CHART_FIXED_MAX,aValue);}
   void SetFixedMin(double aValue){ChartSetDouble(m_id,CHART_FIXED_MIN,aValue);}
   void SetPtPerBar(double aValue){ChartSetDouble(m_id,CHART_POINTS_PER_BAR,aValue);}
   void SetComment(string aValue){ChartSetString(m_id,CHART_COMMENT,aValue);}
   bool SetSymbolPeriod(string aSymbol,ENUM_TIMEFRAMES aTimeFrame){return(ChartSetSymbolPeriod(m_id,aSymbol,aTimeFrame));}

   long First(){return(ChartFirst());}
   long Next(long aID){return(ChartNext(aID));}

   void Redraw(){ChartRedraw(m_id);}
   long Open(string aSymbol,ENUM_TIMEFRAMES  aTimeFrame)
     {
      long tmp=ChartOpen(aSymbol,aTimeFrame);
      if(tmp==0)return(0);
      m_id=tmp;
      return(m_id);
     }
   bool Close()
     {
      return(ChartClose(m_id));
     }

   bool Navigate(ENUM_CHART_POSITION aPosition,int aShift){return(ChartNavigate(m_id,aPosition,aShift));}
   bool ScreenShot(string aFileName,int aWidth,int aHeight,ENUM_ALIGN_MODE aAlign=ALIGN_RIGHT){return(ChartScreenShot(m_id,aFileName+".png",aWidth,aHeight,aAlign));}

   bool ApplyTemplate(string aFileName){return(ChartApplyTemplate(m_id,aFileName));}
   int IndicatorWindowFind(string aIndShortName){return(ChartWindowFind(m_id,aIndShortName));}
   bool IndicatorAdd(int aNWindow,int aIndHandle){return(ChartIndicatorAdd(m_id,aNWindow,aIndHandle));}
   bool IndicatorDelete(int aNWindow,string aShortName){return(ChartIndicatorDelete(m_id,aNWindow,aShortName));}
   string IndicatorName(int aNWindow,int aIndex){return(ChartIndicatorName(m_id,aNWindow,aIndex));}
   int IndicatorsTotal(int aNWindow){return(ChartIndicatorsTotal(m_id,aNWindow));}

   int DroppedWindow(){return(ChartWindowOnDropped());}
   double DroppedPrice(){return(ChartPriceOnDropped());}
   datetime DroppedTime(){return(ChartTimeOnDropped());}
   int DroppedX(){return(ChartXOnDropped());}
   int DroppedY(){return(ChartYOnDropped());}

   void Event(int aLparam,int aDparam,int  &aWindow,int  &aX,int  &aY)
     {
      aX=aLparam-3;
      int hs=0;
      int ps=0;
      for(int i=0;i<ChartGetInteger(0,CHART_WINDOWS_TOTAL);i++)
        {
         hs+=3+(int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,i);
         if(hs>=aDparam)
           {
            aY=(aDparam-ps-3);
            aWindow=i;
            break;
           }
         ps=hs;
        }
     }

   int ChartsList(long  &aList[])
     {
      ArrayResize(aList,0);
      long tmp=First();
      while(tmp!=-1)
        {
         ArrayResize(aList,ArraySize(aList)+1);
         aList[ArraySize(aList)-1]=tmp;
         tmp=Next(tmp);
        }
      return(ArraySize(aList));
     }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class cIntGO
  {
protected:
   long              m_id;
   string            m_name;
public:
   void Attach(string aName,long aChartID=0)
     {
      m_name=aName;
      m_id=aChartID;
     }
   // attached
   void SetPosX(long aValue){ObjectSetInteger(m_id,m_name,OBJPROP_XDISTANCE,aValue);}
   void SetPosY(long aValue){ObjectSetInteger(m_id,m_name,OBJPROP_YDISTANCE,aValue);}
   void SetPosXY(long aX,long aY){ObjectSetInteger(m_id,m_name,OBJPROP_XDISTANCE,aX);ObjectSetInteger(m_id,m_name,OBJPROP_YDISTANCE,aY);}
   void SetTime(int aIndex,long aValue){ObjectSetInteger(m_id,m_name,OBJPROP_TIME,aIndex,aValue);}
   void SetPrice(int aIndex,double aValue){ObjectSetDouble(m_id,m_name,OBJPROP_PRICE,aIndex,aValue);}
   void Move(int aIndex,datetime aTime,double aPrice){ObjectMove(m_id,m_name,aIndex,aTime,aPrice);}
   void SetSizeX(long aValue){ObjectSetInteger(m_id,m_name,OBJPROP_XSIZE,aValue);}
   void SetSizeY(long aValue){ObjectSetInteger(m_id,m_name,OBJPROP_YSIZE,aValue);}
   void SetSizeXY(long aX,long aY){ObjectSetInteger(m_id,m_name,OBJPROP_XSIZE,aX);ObjectSetInteger(m_id,m_name,OBJPROP_YSIZE,aY);}
   void SetText(string aValue){ObjectSetString(m_id,m_name,OBJPROP_TEXT,aValue);}
   void SetArrowCode(int aValue){ObjectSetInteger(m_id,m_name,OBJPROP_ARROWCODE,aValue);}
   void SetWidth(int aValue){ObjectSetInteger(m_id,m_name,OBJPROP_WIDTH,aValue);};
   void SetAngle(double aValue){ObjectSetDouble(m_id,m_name,OBJPROP_ANGLE,aValue);}
   void SetDeviation(double aValue){ObjectSetDouble(m_id,m_name,OBJPROP_DEVIATION,aValue);}
   void SetScale(double aValue){ObjectSetDouble(m_id,m_name,OBJPROP_SCALE,aValue);}
   void SetBack(bool aValue){ObjectSetInteger(m_id,m_name,OBJPROP_BACK,aValue);}
   void SetSelectable(bool aValue){ObjectSetInteger(m_id,m_name,OBJPROP_SELECTABLE,aValue);}
   void SetSelected(bool aValue){ObjectSetInteger(m_id,m_name,OBJPROP_SELECTED,aValue);}
   void SetReadOnly(bool aValue){ObjectSetInteger(m_id,m_name,OBJPROP_READONLY,aValue);}
   void SetState(bool aValue){ObjectSetInteger(m_id,m_name,OBJPROP_STATE,aValue);}
   void SetStyle(long aValue){ObjectSetInteger(m_id,m_name,OBJPROP_STYLE,aValue);}
   void SetRayLeft(bool aValue){ObjectSetInteger(m_id,m_name,OBJPROP_RAY_LEFT,aValue);}
   void SetRayRight(bool aValue){ObjectSetInteger(m_id,m_name,OBJPROP_RAY_RIGHT,aValue);}
   void SetBmpFileOn(string aValue){ObjectSetString(m_id,m_name,OBJPROP_BMPFILE,0,aValue);}
   void SetBmpFileOff(string aValue){ObjectSetString(m_id,m_name,OBJPROP_BMPFILE,1,aValue);}
   void SetFontSize(int aValue){ObjectSetInteger(m_id,m_name,OBJPROP_FONTSIZE,aValue);}
   void SetFontFace(string aValue){ObjectSetString(m_id,m_name,OBJPROP_FONT,aValue);}
   void SetChartDataScale(bool aValue){ObjectSetInteger(m_id,m_name,OBJPROP_DATE_SCALE,aValue);}
   void SetChartPriceScale(bool aValue){ObjectSetInteger(m_id,m_name,OBJPROP_PRICE_SCALE,aValue);}
   void SetChartScale(int aValue){ObjectSetInteger(m_id,m_name,OBJPROP_CHART_SCALE,aValue);}
   void SetChartSymbol(string aValue){ObjectSetString(m_id,m_name,OBJPROP_SYMBOL,aValue);}
   void SetChartTimeFrame(long Value){ObjectSetInteger(m_id,m_name,OBJPROP_PERIOD,Value);}
   bool SetElliotLines(bool aValue){return(ObjectSetInteger(m_id,m_name,OBJPROP_DRAWLINES,aValue));}
   void SetElliotDegree(long aValue){ObjectSetInteger(m_id,m_name,OBJPROP_DEGREE,aValue);}
   void SetEllipse(bool aValue){ObjectSetInteger(m_id,m_name,OBJPROP_ELLIPSE,aValue);}
   void SetGannDirection(long aValue){ObjectSetInteger(m_id,m_name,OBJPROP_DIRECTION,aValue);}
   void SetCorner(long aValue){ObjectSetInteger(m_id,m_name,OBJPROP_CORNER,aValue);}
   void SetAnchor(long aValue){ObjectSetInteger(m_id,m_name,OBJPROP_ANCHOR,aValue);}
   void SetTimeFrames(long aValue){ObjectSetInteger(m_id,m_name,OBJPROP_TIMEFRAMES,aValue);}
   void SetLevelValue(int aIndex,double aValue){ObjectSetDouble(m_id,m_name,OBJPROP_LEVELVALUE,aIndex,aValue);}
   void SetLevelStyle(int aIndex,long aValue){ObjectSetInteger(m_id,m_name,OBJPROP_LEVELSTYLE,aIndex,aValue);}
   void SetLevelColor(int aIndex,long aValue){ObjectSetInteger(m_id,m_name,OBJPROP_LEVELCOLOR,aIndex,aValue);}
   void SetBGColor(long aValue){ObjectSetInteger(m_id,m_name,OBJPROP_BGCOLOR,aValue);}
   void SetColor(long aValue){ObjectSetInteger(m_id,m_name,OBJPROP_COLOR,aValue);}

   // by name on working chart
   void SetPosX(string aName,long aValue){ObjectSetInteger(0,aName,OBJPROP_XDISTANCE,aValue);}
   void SetPosY(string aName,long aValue){ObjectSetInteger(0,aName,OBJPROP_YDISTANCE,aValue);}
   void SetPosXY(string aName,long aX,long aY){ObjectSetInteger(0,aName,OBJPROP_XDISTANCE,aX);ObjectSetInteger(0,aName,OBJPROP_YDISTANCE,aY);}
   void SetTime(string aName,int aIndex,long aValue){ObjectSetInteger(0,aName,OBJPROP_TIME,aIndex,aValue);}
   void SetPrice(string aName,int aIndex,double aValue){ObjectSetDouble(0,aName,OBJPROP_PRICE,aIndex,aValue);}
   void Move(string aName,int aIndex,datetime aTime,double aPrice){ObjectMove(0,aName,aIndex,aTime,aPrice);}
   void SetSizeX(string aName,long aValue){ObjectSetInteger(0,aName,OBJPROP_XSIZE,aValue);}
   void SetSizeY(string aName,long aValue){ObjectSetInteger(0,aName,OBJPROP_YSIZE,aValue);}
   void SetSizeXY(string aName,long aX,long aY){ObjectSetInteger(0,aName,OBJPROP_XSIZE,aX);ObjectSetInteger(0,aName,OBJPROP_YSIZE,aY);}
   void SetText(string aName,string aValue){ObjectSetString(0,aName,OBJPROP_TEXT,aValue);}
   void SetArrowCode(string aName,int aValue){ObjectSetInteger(0,aName,OBJPROP_ARROWCODE,aValue);}
   void SetWidth(string aName,int aValue){ObjectSetInteger(0,aName,OBJPROP_WIDTH,aValue);};
   void SetAngle(string aName,double aValue){ObjectSetDouble(0,aName,OBJPROP_ANGLE,aValue);}
   void SetDeviation(string aName,double aValue){ObjectSetDouble(0,aName,OBJPROP_DEVIATION,aValue);}
   void SetScale(string aName,double aValue){ObjectSetDouble(0,aName,OBJPROP_SCALE,aValue);}
   void SetBack(string aName,bool aValue){ObjectSetInteger(0,aName,OBJPROP_BACK,aValue);}
   void SetSelectable(string aName,bool aValue){ObjectSetInteger(0,aName,OBJPROP_SELECTABLE,aValue);}
   void SetSelected(string aName,bool aValue){ObjectSetInteger(0,aName,OBJPROP_SELECTED,aValue);}
   void SetReadOnly(string aName,bool aValue){ObjectSetInteger(0,aName,OBJPROP_READONLY,aValue);}
   void SetState(string aName,bool aValue){ObjectSetInteger(0,aName,OBJPROP_STATE,aValue);}
   void SetStyle(string aName,long aValue){ObjectSetInteger(0,aName,OBJPROP_STYLE,aValue);}
   void SetRayLeft(string aName,bool aValue){ObjectSetInteger(0,aName,OBJPROP_RAY_LEFT,aValue);}
   void SetRayRight(string aName,bool aValue){ObjectSetInteger(0,aName,OBJPROP_RAY_RIGHT,aValue);}
   void SetBmpFileOn(string aName,string aValue){ObjectSetString(0,aName,OBJPROP_BMPFILE,0,aValue);}
   void SetBmpFileOff(string aName,string aValue){ObjectSetString(0,aName,OBJPROP_BMPFILE,1,aValue);}
   void SetFontSize(string aName,int aValue){ObjectSetInteger(0,aName,OBJPROP_FONTSIZE,aValue);}
   void SetFontFace(string aName,string aValue){ObjectSetString(0,aName,OBJPROP_FONT,aValue);}
   void SetChartDataScale(string aName,bool aValue){ObjectSetInteger(0,aName,OBJPROP_DATE_SCALE,aValue);}
   void SetChartPriceScale(string aName,bool aValue){ObjectSetInteger(0,aName,OBJPROP_PRICE_SCALE,aValue);}
   void SetChartScale(string aName,int aValue){ObjectSetInteger(0,aName,OBJPROP_CHART_SCALE,aValue);}
   void SetChartSymbol(string aName,string aValue){ObjectSetString(0,aName,OBJPROP_SYMBOL,aValue);}
   void SetChartTimeFrame(string aName,long Value){ObjectSetInteger(0,aName,OBJPROP_PERIOD,Value);}
   bool SetElliotLines(string aName,bool aValue){return(ObjectSetInteger(0,aName,OBJPROP_DRAWLINES,aValue));}
   void SetElliotDegree(string aName,long aValue){ObjectSetInteger(0,aName,OBJPROP_DEGREE,aValue);}
   void SetEllipse(string aName,bool aValue){ObjectSetInteger(0,aName,OBJPROP_ELLIPSE,aValue);}
   void SetGannDirection(string aName,long aValue){ObjectSetInteger(0,aName,OBJPROP_DIRECTION,aValue);}
   void SetCorner(string aName,long aValue){ObjectSetInteger(0,aName,OBJPROP_CORNER,aValue);}
   void SetAnchor(string aName,long aValue){ObjectSetInteger(0,aName,OBJPROP_ANCHOR,aValue);}
   void SetTimeFrames(string aName,long aValue){ObjectSetInteger(0,aName,OBJPROP_TIMEFRAMES,aValue);}
   void SetLevelValue(string aName,int aIndex,double aValue){ObjectSetDouble(0,aName,OBJPROP_LEVELVALUE,aIndex,aValue);}
   void SetLevelStyle(string aName,int aIndex,long aValue){ObjectSetInteger(0,aName,OBJPROP_LEVELSTYLE,aIndex,aValue);}
   void SetLevelColor(string aName,int aIndex,long aValue){ObjectSetInteger(0,aName,OBJPROP_LEVELCOLOR,aIndex,aValue);}
   void SetBGColor(string aName,long aValue){ObjectSetInteger(0,aName,OBJPROP_BGCOLOR,aValue);}
   void SetColor(string aName,long aValue){ObjectSetInteger(0,aName,OBJPROP_COLOR,aValue);}

   // by name on chart
   void SetPosX(long aID,string aName,long aValue){ObjectSetInteger(aID,aName,OBJPROP_XDISTANCE,aValue);}
   void SetPosY(long aID,string aName,long aValue){ObjectSetInteger(aID,aName,OBJPROP_YDISTANCE,aValue);}
   void SetPosXY(long aID,string aName,long aX,long aY){ObjectSetInteger(aID,aName,OBJPROP_XDISTANCE,aX);ObjectSetInteger(aID,aName,OBJPROP_YDISTANCE,aY);}
   void SetTime(long aID,string aName,int aIndex,long aValue){ObjectSetInteger(aID,aName,OBJPROP_TIME,aIndex,aValue);}
   void SetPrice(long aID,string aName,int aIndex,double aValue){ObjectSetDouble(aID,aName,OBJPROP_PRICE,aIndex,aValue);}
   void Move(long aID,string aName,int aIndex,datetime aTime,double aPrice){ObjectMove(aID,aName,aIndex,aTime,aPrice);}
   void SetSizeX(long aID,string aName,long aValue){ObjectSetInteger(aID,aName,OBJPROP_XSIZE,aValue);}
   void SetSizeY(long aID,string aName,long aValue){ObjectSetInteger(aID,aName,OBJPROP_YSIZE,aValue);}
   void SetSizeXY(long aID,string aName,long aX,long aY){ObjectSetInteger(aID,aName,OBJPROP_XSIZE,aX);ObjectSetInteger(aID,aName,OBJPROP_YSIZE,aY);}
   void SetText(long aID,string aName,string aValue){ObjectSetString(aID,aName,OBJPROP_TEXT,aValue);}
   void SetArrowCode(long aID,string aName,int aValue){ObjectSetInteger(aID,aName,OBJPROP_ARROWCODE,aValue);}
   void SetWidth(long aID,string aName,int aValue){ObjectSetInteger(aID,aName,OBJPROP_WIDTH,aValue);};
   void SetAngle(long aID,string aName,double aValue){ObjectSetDouble(aID,aName,OBJPROP_ANGLE,aValue);}
   void SetDeviation(long aID,string aName,double aValue){ObjectSetDouble(aID,aName,OBJPROP_DEVIATION,aValue);}
   void SetScale(long aID,string aName,double aValue){ObjectSetDouble(aID,aName,OBJPROP_SCALE,aValue);}
   void SetBack(long aID,string aName,bool aValue){ObjectSetInteger(aID,aName,OBJPROP_BACK,aValue);}
   void SetSelectable(long aID,string aName,bool aValue){ObjectSetInteger(aID,aName,OBJPROP_SELECTABLE,aValue);}
   void SetSelected(long aID,string aName,bool aValue){ObjectSetInteger(aID,aName,OBJPROP_SELECTED,aValue);}
   void SetReadOnly(long aID,string aName,bool aValue){ObjectSetInteger(aID,aName,OBJPROP_READONLY,aValue);}
   void SetState(long aID,string aName,bool aValue){ObjectSetInteger(aID,aName,OBJPROP_STATE,aValue);}
   void SetStyle(long aID,string aName,long aValue){ObjectSetInteger(aID,aName,OBJPROP_STYLE,aValue);}
   void SetRayLeft(long aID,string aName,bool aValue){ObjectSetInteger(aID,aName,OBJPROP_RAY_LEFT,aValue);}
   void SetRayRight(long aID,string aName,bool aValue){ObjectSetInteger(aID,aName,OBJPROP_RAY_RIGHT,aValue);}
   void SetBmpFileOn(long aID,string aName,string aValue){ObjectSetString(aID,aName,OBJPROP_BMPFILE,0,aValue);}
   void SetBmpFileOff(long aID,string aName,string aValue){ObjectSetString(aID,aName,OBJPROP_BMPFILE,1,aValue);}
   void SetFontSize(long aID,string aName,int aValue){ObjectSetInteger(aID,aName,OBJPROP_FONTSIZE,aValue);}
   void SetFontFace(long aID,string aName,string aValue){ObjectSetString(aID,aName,OBJPROP_FONT,aValue);}
   void SetChartDataScale(long aID,string aName,bool aValue){ObjectSetInteger(aID,aName,OBJPROP_DATE_SCALE,aValue);}
   void SetChartPriceScale(long aID,string aName,bool aValue){ObjectSetInteger(aID,aName,OBJPROP_PRICE_SCALE,aValue);}
   void SetChartScale(long aID,string aName,int aValue){ObjectSetInteger(aID,aName,OBJPROP_CHART_SCALE,aValue);}
   void SetChartSymbol(long aID,string aName,string aValue){ObjectSetString(aID,aName,OBJPROP_SYMBOL,aValue);}
   void SetChartTimeFrame(long aID,string aName,long Value){ObjectSetInteger(aID,aName,OBJPROP_PERIOD,Value);}
   bool SetElliotLines(long aID,string aName,bool aValue){return(ObjectSetInteger(aID,aName,OBJPROP_DRAWLINES,aValue));}
   void SetElliotDegree(long aID,string aName,long aValue){ObjectSetInteger(aID,aName,OBJPROP_DEGREE,aValue);}
   void SetEllipse(long aID,string aName,bool aValue){ObjectSetInteger(aID,aName,OBJPROP_ELLIPSE,aValue);}
   void SetGannDirection(long aID,string aName,long aValue){ObjectSetInteger(aID,aName,OBJPROP_DIRECTION,aValue);}
   void SetCorner(long aID,string aName,long aValue){ObjectSetInteger(aID,aName,OBJPROP_CORNER,aValue);}
   void SetAnchor(long aID,string aName,long aValue){ObjectSetInteger(aID,aName,OBJPROP_ANCHOR,aValue);}
   void SetTimeFrames(long aID,string aName,long aValue){ObjectSetInteger(aID,aName,OBJPROP_TIMEFRAMES,aValue);}
   void SetLevelValue(long aID,string aName,int aIndex,double aValue){ObjectSetDouble(aID,aName,OBJPROP_LEVELVALUE,aIndex,aValue);}
   void SetLevelStyle(long aID,string aName,int aIndex,long aValue){ObjectSetInteger(aID,aName,OBJPROP_LEVELSTYLE,aIndex,aValue);}
   void SetLevelColor(long aID,string aName,int aIndex,long aValue){ObjectSetInteger(aID,aName,OBJPROP_LEVELCOLOR,aIndex,aValue);}
   void SetBGColor(long aID,string aName,long aValue){ObjectSetInteger(aID,aName,OBJPROP_BGCOLOR,aValue);}
   void SetColor(long aID,string aName,long aValue){ObjectSetInteger(aID,aName,OBJPROP_COLOR,aValue);}

   // chart update
   void Redraw(){ChartRedraw(m_id);}
   void Redraw(int aID){ChartRedraw(aID);}
   void RedrawThis(){ChartRedraw();}

   // get properties
   string Name(){return(m_name);}
   long ChartID(){return(m_id);}

   // for attached
   int PosX(){return((int)ObjectGetInteger(m_id,m_name,OBJPROP_XDISTANCE));}
   int PosY(){return((int)ObjectGetInteger(m_id,m_name,OBJPROP_YDISTANCE));}
   datetime Time(int aIndex){return((datetime)ObjectGetInteger(m_id,m_name,OBJPROP_TIME,aIndex));}
   double Price(int aIndex){return(ObjectGetDouble(m_id,m_name,OBJPROP_PRICE,aIndex));}
   int SizeX(){return((int)ObjectGetInteger(m_id,m_name,OBJPROP_XSIZE));}
   int SizeY(){return((int)ObjectGetInteger(m_id,m_name,OBJPROP_YSIZE));}
   string Text(){return(ObjectGetString(m_id,m_name,OBJPROP_TEXT));}
   int ArrowCode(){return((int)ObjectGetInteger(m_id,m_name,OBJPROP_ARROWCODE));}
   int Width(){return((int)ObjectGetInteger(m_id,m_name,OBJPROP_WIDTH));};
   double Angle(){return(ObjectGetDouble(m_id,m_name,OBJPROP_ANGLE));}
   double Deviation(){return(ObjectGetDouble(m_id,m_name,OBJPROP_DEVIATION));}
   double Scale(){return(ObjectGetDouble(m_id,m_name,OBJPROP_SCALE));}
   bool Back(){return(ObjectGetInteger(m_id,m_name,OBJPROP_BACK));}
   bool Selectable(){return(ObjectGetInteger(m_id,m_name,OBJPROP_SELECTABLE));}
   bool Selected(){return(ObjectGetInteger(m_id,m_name,OBJPROP_SELECTED));}
   bool ReadOnly(){return(ObjectGetInteger(m_id,m_name,OBJPROP_READONLY));}
   bool State(){return(ObjectGetInteger(m_id,m_name,OBJPROP_STATE));}
   int Style(){return((int)ObjectGetInteger(m_id,m_name,OBJPROP_STYLE));}
   bool RayLeft(){return(ObjectGetInteger(m_id,m_name,OBJPROP_RAY_LEFT));}
   bool RayRight(){return(ObjectGetInteger(m_id,m_name,OBJPROP_RAY_RIGHT));}
   string BmpFileOn(){return(ObjectGetString(m_id,m_name,OBJPROP_BMPFILE,0));}
   string BmpFileOff(){return(ObjectGetString(m_id,m_name,OBJPROP_BMPFILE,1));}
   int FontSize(){return((int)ObjectGetInteger(m_id,m_name,OBJPROP_FONTSIZE));}
   string FontFace(){return(ObjectGetString(m_id,m_name,OBJPROP_FONT));}
   bool ChartDataScale(){return(ObjectGetInteger(m_id,m_name,OBJPROP_DATE_SCALE));}
   bool ChartPriceScale(){return(ObjectGetInteger(m_id,m_name,OBJPROP_PRICE_SCALE));}
   int ChartScale(){return((int)ObjectGetInteger(m_id,m_name,OBJPROP_CHART_SCALE));}
   string ChartSymbol(){return(ObjectGetString(m_id,m_name,OBJPROP_SYMBOL));}
   int ChartTimeFrame(){return((int)ObjectGetInteger(m_id,m_name,OBJPROP_PERIOD));}
   bool ElliotLines(){return((int)ObjectGetInteger(m_id,m_name,OBJPROP_DRAWLINES));}
   int ElliotDegree(){return((int)ObjectGetInteger(m_id,m_name,OBJPROP_DEGREE));}
   bool Ellipse(){return(ObjectGetInteger(m_id,m_name,OBJPROP_ELLIPSE));}
   int GannDirection(){return((int)ObjectGetInteger(m_id,m_name,OBJPROP_DIRECTION));}
   int Corner(){return((int)ObjectGetInteger(m_id,m_name,OBJPROP_CORNER));}
   int Anchor(){return((int)ObjectGetInteger(m_id,m_name,OBJPROP_ANCHOR));}
   long TimeFrames(){return(ObjectGetInteger(m_id,m_name,OBJPROP_TIMEFRAMES));}
   double LevelValue(int aIndex){return(ObjectGetDouble(m_id,m_name,OBJPROP_LEVELVALUE,aIndex));}
   int LevelStyle(int aIndex){return((int)ObjectGetInteger(m_id,m_name,OBJPROP_LEVELSTYLE,aIndex));}
   color LevelColor(int aIndex){return((color)ObjectGetInteger(m_id,m_name,OBJPROP_LEVELCOLOR,aIndex));}
   color BGColor(){return((color)ObjectGetInteger(m_id,m_name,OBJPROP_BGCOLOR));}
   color Color(){return((color)ObjectGetInteger(m_id,m_name,OBJPROP_COLOR));}

   // by name on working chart
   int PosX(string aName){return((int)ObjectGetInteger(0,aName,OBJPROP_XDISTANCE));}
   int PosY(string aName){return((int)ObjectGetInteger(0,aName,OBJPROP_YDISTANCE));}
   datetime Time(string aName,int aIndex){return((datetime)ObjectGetInteger(0,aName,OBJPROP_TIME,aIndex));}
   double Price(string aName,int aIndex){return(ObjectGetDouble(0,aName,OBJPROP_PRICE,aIndex));}
   int SizeX(string aName){return((int)ObjectGetInteger(0,aName,OBJPROP_XSIZE));}
   int SizeY(string aName){return((int)ObjectGetInteger(0,aName,OBJPROP_YSIZE));}
   string Text(string aName){return(ObjectGetString(0,aName,OBJPROP_TEXT));}
   int ArrowCode(string aName){return((int)ObjectGetInteger(0,aName,OBJPROP_ARROWCODE));}
   int Width(string aName){return((int)ObjectGetInteger(0,aName,OBJPROP_WIDTH));};
   double Angle(string aName){return(ObjectGetDouble(0,aName,OBJPROP_ANGLE));}
   double Deviation(string aName){return(ObjectGetDouble(0,aName,OBJPROP_DEVIATION));}
   double Scale(string aName){return(ObjectGetDouble(0,aName,OBJPROP_SCALE));}
   bool Back(string aName){return(ObjectGetInteger(0,aName,OBJPROP_BACK));}
   bool Selectable(string aName){return(ObjectGetInteger(0,aName,OBJPROP_SELECTABLE));}
   bool Selected(string aName){return(ObjectGetInteger(0,aName,OBJPROP_SELECTED));}
   bool ReadOnly(string aName){return(ObjectGetInteger(0,aName,OBJPROP_READONLY));}
   bool State(string aName){return(ObjectGetInteger(0,aName,OBJPROP_STATE));}
   int Style(string aName){return((int)ObjectGetInteger(0,aName,OBJPROP_STYLE));}
   bool RayLeft(string aName){return(ObjectGetInteger(0,aName,OBJPROP_RAY_LEFT));}
   bool RayRight(string aName){return(ObjectGetInteger(0,aName,OBJPROP_RAY_RIGHT));}
   string BmpFileOn(string aName){return(ObjectGetString(0,aName,OBJPROP_BMPFILE,0));}
   string BmpFileOff(string aName){return(ObjectGetString(0,aName,OBJPROP_BMPFILE,1));}
   int FontSize(string aName){return((int)ObjectGetInteger(0,aName,OBJPROP_FONTSIZE));}
   string FontFace(string aName){return(ObjectGetString(0,aName,OBJPROP_FONT));}
   bool ChartDataScale(string aName){return(ObjectGetInteger(0,aName,OBJPROP_DATE_SCALE));}
   bool ChartPriceScale(string aName){return(ObjectGetInteger(0,aName,OBJPROP_PRICE_SCALE));}
   int ChartScale(string aName){return((int)ObjectGetInteger(0,aName,OBJPROP_CHART_SCALE));}
   string ChartSymbol(string aName){return(ObjectGetString(0,aName,OBJPROP_SYMBOL));}
   int ChartTimeFrame(string aName){return((int)ObjectGetInteger(0,aName,OBJPROP_PERIOD));}
   bool ElliotLines(string aName){return((int)ObjectGetInteger(0,aName,OBJPROP_DRAWLINES));}
   int ElliotDegree(string aName){return((int)ObjectGetInteger(0,aName,OBJPROP_DEGREE));}
   bool Ellipse(string aName){return(ObjectGetInteger(0,aName,OBJPROP_ELLIPSE));}
   int GannDirection(string aName){return((int)ObjectGetInteger(0,aName,OBJPROP_DIRECTION));}
   int Corner(string aName){return((int)ObjectGetInteger(0,aName,OBJPROP_CORNER));}
   int Anchor(string aName){return((int)ObjectGetInteger(0,aName,OBJPROP_ANCHOR));}
   long TimeFrames(string aName){return(ObjectGetInteger(0,aName,OBJPROP_TIMEFRAMES));}
   double LevelValue(string aName,int aIndex){return(ObjectGetDouble(0,aName,OBJPROP_LEVELVALUE,aIndex));}
   int LevelStyle(string aName,int aIndex){return((int)ObjectGetInteger(0,aName,OBJPROP_LEVELSTYLE,aIndex));}
   color LevelColor(string aName,int aIndex){return((color)ObjectGetInteger(0,aName,OBJPROP_LEVELCOLOR,aIndex));}
   color BGColor(string aName){return((color)ObjectGetInteger(0,aName,OBJPROP_BGCOLOR));}
   color Color(string aName){return((color)ObjectGetInteger(0,aName,OBJPROP_COLOR));}

   // by name on any chart
   int PosX(long aID,string aName){return((int)ObjectGetInteger(aID,aName,OBJPROP_XDISTANCE));}
   int PosY(long aID,string aName){return((int)ObjectGetInteger(aID,aName,OBJPROP_YDISTANCE));}
   datetime Time(long aID,string aName,int aIndex){return((datetime)ObjectGetInteger(aID,aName,OBJPROP_TIME,aIndex));}
   double Price(long aID,string aName,int aIndex){return(ObjectGetDouble(aID,aName,OBJPROP_PRICE,aIndex));}
   int SizeX(long aID,string aName){return((int)ObjectGetInteger(aID,aName,OBJPROP_XSIZE));}
   int SizeY(long aID,string aName){return((int)ObjectGetInteger(aID,aName,OBJPROP_YSIZE));}
   string Text(long aID,string aName){return(ObjectGetString(aID,aName,OBJPROP_TEXT));}
   int ArrowCode(long aID,string aName){return((int)ObjectGetInteger(aID,aName,OBJPROP_ARROWCODE));}
   int Width(long aID,string aName){return((int)ObjectGetInteger(aID,aName,OBJPROP_WIDTH));};
   double Angle(long aID,string aName){return(ObjectGetDouble(aID,aName,OBJPROP_ANGLE));}
   double Deviation(long aID,string aName){return(ObjectGetDouble(aID,aName,OBJPROP_DEVIATION));}
   double Scale(long aID,string aName){return(ObjectGetDouble(aID,aName,OBJPROP_SCALE));}
   bool Back(long aID,string aName){return(ObjectGetInteger(aID,aName,OBJPROP_BACK));}
   bool Selectable(long aID,string aName){return(ObjectGetInteger(aID,aName,OBJPROP_SELECTABLE));}
   bool Selected(long aID,string aName){return(ObjectGetInteger(aID,aName,OBJPROP_SELECTED));}
   bool ReadOnly(long aID,string aName){return(ObjectGetInteger(aID,aName,OBJPROP_READONLY));}
   bool State(long aID,string aName){return(ObjectGetInteger(aID,aName,OBJPROP_STATE));}
   int Style(long aID,string aName){return((int)ObjectGetInteger(aID,aName,OBJPROP_STYLE));}
   bool RayLeft(long aID,string aName){return(ObjectGetInteger(aID,aName,OBJPROP_RAY_LEFT));}
   bool RayRight(long aID,string aName){return(ObjectGetInteger(aID,aName,OBJPROP_RAY_RIGHT));}
   string BmpFileOn(long aID,string aName){return(ObjectGetString(aID,aName,OBJPROP_BMPFILE,0));}
   string BmpFileOff(long aID,string aName){return(ObjectGetString(aID,aName,OBJPROP_BMPFILE,1));}
   int FontSize(long aID,string aName){return((int)ObjectGetInteger(aID,aName,OBJPROP_FONTSIZE));}
   string FontFace(long aID,string aName){return(ObjectGetString(aID,aName,OBJPROP_FONT));}
   bool ChartDataScale(long aID,string aName){return(ObjectGetInteger(aID,aName,OBJPROP_DATE_SCALE));}
   bool ChartPriceScale(long aID,string aName){return(ObjectGetInteger(aID,aName,OBJPROP_PRICE_SCALE));}
   int ChartScale(long aID,string aName){return((int)ObjectGetInteger(aID,aName,OBJPROP_CHART_SCALE));}
   string ChartSymbol(long aID,string aName){return(ObjectGetString(aID,aName,OBJPROP_SYMBOL));}
   int ChartTimeFrame(long aID,string aName){return((int)ObjectGetInteger(aID,aName,OBJPROP_PERIOD));}
   bool ElliotLines(long aID,string aName){return((int)ObjectGetInteger(aID,aName,OBJPROP_DRAWLINES));}
   int ElliotDegree(long aID,string aName){return((int)ObjectGetInteger(aID,aName,OBJPROP_DEGREE));}
   bool Ellipse(long aID,string aName){return(ObjectGetInteger(aID,aName,OBJPROP_ELLIPSE));}
   int GannDirection(long aID,string aName){return((int)ObjectGetInteger(aID,aName,OBJPROP_DIRECTION));}
   int Corner(long aID,string aName){return((int)ObjectGetInteger(aID,aName,OBJPROP_CORNER));}
   int Anchor(long aID,string aName){return((int)ObjectGetInteger(aID,aName,OBJPROP_ANCHOR));}
   long TimeFrames(long aID,string aName){return(ObjectGetInteger(aID,aName,OBJPROP_TIMEFRAMES));}
   double LevelValue(long aID,string aName,int aIndex){return(ObjectGetDouble(aID,aName,OBJPROP_LEVELVALUE,aIndex));}
   int LevelStyle(long aID,string aName,int aIndex){return((int)ObjectGetInteger(aID,aName,OBJPROP_LEVELSTYLE,aIndex));}
   color LevelColor(long aID,string aName,int aIndex){return((color)ObjectGetInteger(aID,aName,OBJPROP_LEVELCOLOR,aIndex));}
   color BGColor(long aID,string aName){return((color)ObjectGetInteger(aID,aName,OBJPROP_BGCOLOR));}
   color Color(long aID,string aName){return((color)ObjectGetInteger(aID,aName,OBJPROP_COLOR));}

   // create          
   void CreateLabel(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_LABEL,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateVerticalLine(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_VLINE,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateHorizontalLine(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_HLINE,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateTrendLine(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_TREND,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateTrendByAngle(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_TRENDBYANGLE,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateEquiDistantChannel(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_CHANNEL,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateStdDevChannel(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_STDDEVCHANNEL,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateRegressionChannel(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_REGRESSION,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreatePitchfork(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_PITCHFORK,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateGannLine(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_GANNLINE,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateGannFan(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_GANNFAN,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateGannGrid(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_GANNGRID,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateFibo(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_FIBO,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateFiboTimes(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_FIBOTIMES,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateFiboFun(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_FIBOFAN,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateFiboArc(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_FIBOARC,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateFiboChannel(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_FIBOCHANNEL,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateFiboExpansion(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_EXPANSION,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateEllioteWave5(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_ELLIOTWAVE5,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateEllioteWave3(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_ELLIOTWAVE3,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateRectangle(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_RECTANGLE,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateTriangle(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_TRIANGLE,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateEllipse(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_ELLIPSE,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateCycles(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_CYCLES,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateArrow(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_ARROW,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateArrow_ThumbUp(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_ARROW_THUMB_UP,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateArrow_ThumbDn(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_ARROW_THUMB_DOWN,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateArrow_Up(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_ARROW_UP,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateArrow_Dn(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_ARROW_DOWN,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateArrow_Stop(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_ARROW_STOP,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateArrow_Check(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_ARROW_CHECK,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreatePriceMarkerLeft(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_ARROW_LEFT_PRICE,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreatePriceMarkerRight(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_ARROW_RIGHT_PRICE,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateArrow_Buy(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_ARROW_BUY,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateArrow_Sell(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_ARROW_SELL,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateArrowedLine(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_ARROWED_LINE,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateEvent(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_EVENT,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateText(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_TEXT,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateButton(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_BUTTON,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateEdit(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_EDIT,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateBmpLabel(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_BITMAP_LABEL,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateBmp(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_BITMAP,aSubWindow,0,0);Attach(aName,aChartID);}
   void CreateChart(string aName,int aSubWindow=0,long aChartID=0){ObjectCreate(aChartID,aName,OBJ_CHART,aSubWindow,0,0);Attach(aName,aChartID);}

   // delete
   void Delete(){ObjectDelete(m_id,m_name);}
   void Delete(string aName){ObjectDelete(0,aName);}
   void Delete(long aID,string aName){ObjectDelete(aID,aName);}
  };
//+------------------------------------------------------------------+
//| cIntPrices                                                       |
//+------------------------------------------------------------------+
class cIntPrices
  {
public:
   datetime dTime(string aSymbol,ENUM_TIMEFRAMES aTimeFrame,int aShift)
     {
      datetime dt[1];
      if(aShift<0)
        {
         CopyTime(aSymbol,aTimeFrame,0,1,dt);
         return(dt[0]-PeriodSeconds(aTimeFrame)*aShift);
        }
      CopyTime(aSymbol,aTimeFrame,aShift,1,dt);
      return(dt[0]);
     }
   int BarShift(string aSymbol,ENUM_TIMEFRAMES aTimeFrame,datetime aTime,bool aExactly,int  &aShift)
     {
      datetime dt[1];
      int from=0,count=1;
      if(CopyTime(aSymbol,aTimeFrame,0,1,dt)==-1)return(false);
      aShift=Bars(aSymbol,aTimeFrame,aTime,dt[0])-1;
      if(CopyTime(aSymbol,aTimeFrame,aShift,1,dt)==-1)return(false);
      if(aExactly)
        {
         if(dt[0]!=aTime)
           {
            aShift=-1;
           }
        }
      else
        {
         if(dt[0]>aTime)
           {
            aShift++;
           }
         else if(dt[0]<aTime)
           {
            aShift=(int)(dt[0]-aTime)/PeriodSeconds(aTimeFrame);
           }
        }
      return(true);
     }

  };

cIntPrices pr;
cIntGO g;
cIntChart ch;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct MyChart
  {
   datetime          TimeOnMarker;
   double            ShiftSize;
  };

string LineName;
long List[];
long List2[];
MyChart mc[];
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {

   LineName=MQL5InfoString(MQL5_PROGRAM_NAME)+"_VLine";
   int BarOnMarker;
   datetime TimeOnMarker,CurTimeOnMarker;
   double ShiftSize;
   int Shift;

   ch.ChartsList(List);
   ArrayResize(mc,ArraySize(List));

//====

   datetime st=0;
   string str="Integer's "+MQL5InfoString(MQL5_PROGRAM_NAME);
   for(int j=0;j<5;j++)
     {
      for(int i=0;i<ArraySize(List);i++)
        {
         ch.Attach(List[i]);
         ch.SetComment("");
         ch.Redraw();
        }
      Sleep(100);
      for(int i=0;i<ArraySize(List);i++)
        {
         ch.Attach(List[i]);
         ch.SetComment(str);
         ch.Redraw();
        }
      Sleep(100);
     }

//====

//--- attached chart
   ch.Attach(ChartID());
//--- disable autoscroll if it enabled
   if(ch.AutoScroll())
     {
      ch.SetAutoScroll(false);
     }
// если не включен отступ, включаем и устанавливаем его                  
   if(!ch.Shift())
     {
      ch.SetShift(true);
      ch.SetShiftSize(25);
     }
//--- if autshift disabled, enable it
   ShiftSize=ch.ShiftSize();

//====
//--- disable autoscroll for all charts,set the same shift
   for(int i=0;i<ArraySize(List);i++)
     {
      ch.Attach(List[i]);
      //--- autoscroll
      if(ch.AutoScroll())
        {
         ch.SetAutoScroll(false);
        }
      //--- shift
      if(!ch.Shift())
        {
         ch.SetShift(true);

        }
      ch.SetShiftSize(ShiftSize);
      //--- navigate
      ch.Navigate(CHART_END,0);
      ch.Redraw();
      //--- marker time
      BarOnMarker=fBarOnMarker();
      mc[i].TimeOnMarker=pr.dTime(ch.Symbol(),ch.TimeFrame(),BarOnMarker);
      mc[i].ShiftSize=ch.ShiftSize();
     }

//=== 

//--- marker time
   ch.Attach(ChartID());
   BarOnMarker=fBarOnMarker();
   CurTimeOnMarker=pr.dTime(ch.Symbol(),ch.TimeFrame(),BarOnMarker);

//====

//--- track the change of the shift/change marker time
   while(!IsStopped())
     {
      //--- if chart closed
      for(int i=ArraySize(List)-1;i>=0;i--)
        {
         ch.Attach(List[i]);
         if(ch.WindowHandle()==0)
           {
            for(int j=i;j<ArraySize(List)-1;j++)
              {
               List[j]=List[j+1];
               mc[j]=mc[j+1];
              }
            ArrayResize(List,ArraySize(List)-1);
           }

        }
      //--- add new chart
      ch.ChartsList(List2);
      for(int i=0;i<ArraySize(List2);i++)
        {
         bool exist=false;
         for(int j=0;j<ArraySize(List);j++)
           {
            if(List2[i]==List[j])
              {
               exist=true;
              }
           }
         if(!exist)
           {
            ArrayResize(List,ArraySize(List)+1);
            ArrayResize(mc,ArraySize(mc)+1);
            List[ArraySize(List)-1]=List2[i];
            ch.Attach(List2[i]);
            ch.SetAutoScroll(false);
            ch.SetShift(true);
            ch.SetShiftSize(ShiftSize);
           }
        }
      //--- disable autoscroll, set shift
      for(int i=0;i<ArraySize(List);i++)
        {
         ch.Attach(List[i]);
         if(ch.AutoScroll())
           {
            ch.SetAutoScroll(false);
           }
         if(!ch.Shift())
           {
            ch.SetShift(true);
           }
        }
      //--- track change of the position
      double NewShiftSize=-1;
      for(int i=0;i<ArraySize(List);i++)
        {
         ch.Attach(List[i]);
         if(ch.ShiftSize()!=mc[i].ShiftSize)
           {
            NewShiftSize=ch.ShiftSize();
            ShiftSize=NewShiftSize;
            break;
           }
        }
      if(NewShiftSize!=-1)
        {
         for(int i=0;i<ArraySize(List);i++)
           {
            ch.Attach(List[i]);
            ch.SetShiftSize(NewShiftSize);
            ch.Redraw();
            mc[i].ShiftSize=ch.ShiftSize();
           }
        }

      //--- track the change of the time under the marker
      datetime NewTime=0;
      for(int i=0;i<ArraySize(List);i++)
        {
         ch.Attach(List[i]);
         ShiftSize=ch.ShiftSize();
         BarOnMarker=fBarOnMarker();
         TimeOnMarker=pr.dTime(ch.Symbol(),ch.TimeFrame(),BarOnMarker);
         if(TimeOnMarker!=mc[i].TimeOnMarker)
           {
            NewTime=TimeOnMarker;
            mc[i].TimeOnMarker=NewTime;
            CurTimeOnMarker=NewTime;
            if(st<2)
              {
               st++;
               if(st==2)
                 {
                  for(int j=0;j<ArraySize(List);j++)
                    {
                     ch.Attach(List[j]);
                     ch.SetComment("");
                     ch.Redraw();
                    }
                 }
              }
            break;
           }
        }
      if(NewTime!=0)
        {
         for(int i=0;i<ArraySize(List);i++)
           {
            ch.Attach(List[i]);
            if(mc[i].TimeOnMarker!=NewTime)
              {
               //--- scroll to new time
               BarOnMarker=fBarOnMarker();
               pr.BarShift(ch.Symbol(),ch.TimeFrame(),NewTime,false,Shift);
               ch.Navigate(CHART_CURRENT_POS,Shift-BarOnMarker);
               ch.Redraw();
               BarOnMarker=fBarOnMarker();
              }
           }
         for(int i=0;i<ArraySize(List);i++)
           {
            ch.Attach(List[i]);
            if(mc[i].TimeOnMarker!=NewTime)
              {
               //--- save new position
               BarOnMarker=fBarOnMarker();
               mc[i].TimeOnMarker=pr.dTime(ch.Symbol(),ch.TimeFrame(),BarOnMarker);
              }
           }
        }
      //--- lines
      for(int i=0;i<ArraySize(List);i++)
        {
         ch.Attach(List[i]);
         if(ObjectFind(ch.ID(),LineName)==-1)
           {
            g.CreateVerticalLine(LineName,0,ch.ID());
            g.SetBack(false);
            g.SetColor(Red);
            g.SetSelected(false);
            g.SetSelectable(false);
           }
         g.Attach(LineName,ch.ID());
         g.SetTime(0,CurTimeOnMarker);
         ch.Redraw();
        }
      Sleep(1);
     }

//====

//--- delete lines
   for(int i=0;i<ArraySize(List);i++)
     {
      ObjectDelete(List[i],LineName);
      ChartRedraw(List[i]);
     }

  }
//+------------------------------------------------------------------+
int fBarOnMarker()
  {
   return(-(int)MathFloor((100.0-ch.ShiftSize())/100.0*ch.WidthInBars())+ch.FistVisibleBar());
  }
//+------------------------------------------------------------------+
