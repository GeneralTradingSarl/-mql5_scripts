//+------------------------------------------------------------------+
//|                                                  MultiCharts.mq5 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//--- include the ChartObjectSubChart library
#include <ChartObjects\ChartObjectSubChart.mqh>
//--- size of OBJ_Chart
#define chart_width  318
#define chart_height 288
//--- start point for charts table drawing
#define start_x      0
#define start_y      0
#property script_show_inputs
//--- input parameters
input datetime start=D'2012.11.26 00:00:00';
input datetime stop=D'2012.12.01 00:00:00';
//+------------------------------------------------------------------+
//| Class for short and long lines levels                            |
//+------------------------------------------------------------------+
class CLines
  {
public:
   string            m_name;  // name of currency pair
   double            m_short; // level value for the "short" line
   double            m_long;  // level value for the "long" line
   //--- constructor, destructor
                     CLines(void) { };
                    ~CLines(void) { };
  };
//+------------------------------------------------------------------+
//| Class for draw a chart with rectangul area                       |
//| and short & long lines                                           |
//+------------------------------------------------------------------+
class CSubChartExtended: public CChartObjectSubChart
  {
private:
   long              m_subchartID;   // subchart ID
   static bool       m_lines_loaded; // flag of lines loading
   static CLines     m_linesData[];  // array for the lines

public:
                     CSubChartExtended(void);
                    ~CSubChartExtended(void);
   //--- subchart create
   bool              CreateSubChart(const long chart_id,const string name,const int window,
                                    const int X,const int Y,const int sizeX,const int sizeY);
   //--- changing of  display settings   
   void              ChangeSettings(void);
   void              SubChartNavigate(void);
   //--- drawing of graphical objects
   void              DrawRectangle(void);
   void              DrawLines(void);
   //--- redraw
   void              ReDraw(void);
   //--- loading lines data
   bool              LoadLines(const string path);
   virtual bool      Load(const int file_handle);
   //--- calculate the location of the point relative to the interval
   void              SetChartMaxMin(const double short_value,const double long_value);
   int               InRange(const double top,const double bottom,const double pos,const double indent);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSubChartExtended::CSubChartExtended(void)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSubChartExtended::~CSubChartExtended(void)
  {
  }
//+------------------------------------------------------------------+
//| Subchart create                                                  |
//+------------------------------------------------------------------+
bool CSubChartExtended::CreateSubChart(const long chart_id,const string name,
                                       const int window,const int X,const int Y,
                                       const int sizeX,const int sizeY)
  {
//--- creating of chart object
   if(!Create(0,name,0,X,Y,sizeX,sizeY))
      return(false);
//--- get subchart ID
   m_subchartID=ObjectGetInteger(0,name,OBJPROP_CHART_ID);
//--- successful creating
   return(true);
  }
//+------------------------------------------------------------------+
//| Changing of  display settings                                    |
//+------------------------------------------------------------------+
void CSubChartExtended::ChangeSettings(void)
  {
//--- disable chart autoscroll
   ChartSetInteger(m_subchartID,CHART_AUTOSCROLL,false);
//--- set the background color
   if(!ChartSetInteger(m_subchartID,CHART_COLOR_BACKGROUND,C'245,255,250'))
      Print("Failed to set the background color for the chart. Code ",GetLastError());
   ResetLastError();
//--- color of axes, scale and OHLC line
   ChartSetInteger(m_subchartID,CHART_COLOR_FOREGROUND,clrBlack);
//--- disable Ask, Bid and Last lines
   ChartSetInteger(m_subchartID,CHART_SHOW_BID_LINE,false);
   ChartSetInteger(m_subchartID,CHART_SHOW_BID_LINE,false);
   ChartSetInteger(m_subchartID,CHART_SHOW_BID_LINE,false);
//--- disable OHLC
   ChartSetInteger(m_subchartID,CHART_SHOW_OHLC,false);
//--- use candles
   ChartSetInteger(m_subchartID,CHART_MODE,CHART_CANDLES);
//--- bullish candle color
   ChartSetInteger(m_subchartID,CHART_COLOR_CANDLE_BULL,clrWhite);
//--- bullish bur color
   ChartSetInteger(m_subchartID,CHART_COLOR_CHART_UP,clrBlack);
//--- bearish candle color
   ChartSetInteger(m_subchartID,CHART_COLOR_CANDLE_BEAR,clrBlack);
//--- bearish bar color
   ChartSetInteger(m_subchartID,CHART_COLOR_CHART_DOWN,clrBlack);
//--- line color
   ChartSetInteger(m_subchartID,CHART_COLOR_CHART_LINE,clrBlack);
//--- disable the grid
   if(!ChartSetInteger(m_subchartID,CHART_SHOW_GRID,0))
      Print("Failed to set property \"Grid \"\ for the chart. Code ",GetLastError());
   ResetLastError();
//--- disable the shift of the right edge of the chart
   ChartSetInteger(m_subchartID,CHART_SHIFT,0);
//--- set the shift equal to 30% of the chart width
   ChartSetDouble(m_subchartID,CHART_SHIFT_SIZE,10);
//--- disable the trade levels display
   if(!ChartSetInteger(m_subchartID,CHART_SHOW_TRADE_LEVELS,0))
      Print("Failed to set property \"Grid \"\ for the chart. Code ",GetLastError());
   ResetLastError();
  }
//+------------------------------------------------------------------+
//| Chart shift to the left to the desired dates                     |
//+------------------------------------------------------------------+
void CSubChartExtended::SubChartNavigate(void)
  {
//--- chart shift
   ChartNavigate(m_subchartID,CHART_END,GetShift(Name(),PERIOD_H4,m_subchartID));
  }
//+------------------------------------------------------------------+
//| Draw a rectangle on the subchart                                 |
//+------------------------------------------------------------------+
void CSubChartExtended::DrawRectangle(void)
  {
//--- create rectangle by start-stop dates
   if(ObjectCreate(m_subchartID,"rect",OBJ_RECTANGLE,0,start,200,stop,0.01))
     {
      //--- fill rectangle
      ObjectSetInteger(m_subchartID,"rect",OBJPROP_FILL,true);
      //--- rectangle color
      ObjectSetInteger(m_subchartID,"rect",OBJPROP_COLOR,White);
     }
   else
     {
      //--- error
      PrintFormat("Failed to create a rectangle, error code %d",GetLastError());
      ResetLastError();
     }
  }
//+------------------------------------------------------------------+
//| Draw short and long lines on the subchart                        |
//+------------------------------------------------------------------+
void CSubChartExtended::DrawLines(void)
  {
//--- check the flag of data loading
   if(m_lines_loaded)
     {
      //--- create variables
      double short_value=0;
      double long_value=0;
      int size=ArraySize(m_linesData);
      //--- find lines data by name of currency pair
      for(int j=0;j<size;j++)
         if(Name()==m_linesData[j].m_name)
           {
            short_value=m_linesData[j].m_short;
            long_value=m_linesData[j].m_long;
           }
      //--- create the short line on the chart
      if(ObjectCreate(m_subchartID,"short",OBJ_HLINE,0,start,short_value))
        {
         //--- line color
         ObjectSetInteger(m_subchartID,"short",OBJPROP_COLOR,Red);
        }
      else
        {
         //--- error
         PrintFormat("Failed to create a line, error code %d",GetLastError());
         ResetLastError();
        }
      //--- create the long line on the chart
      if(ObjectCreate(m_subchartID,"long",OBJ_HLINE,0,start,long_value))
        {
         //--- line color
         ObjectSetInteger(m_subchartID,"long",OBJPROP_COLOR,Blue);
        }
      else
        {
         //--- error
         PrintFormat("Failed to create a line, error code %d",GetLastError());
         ResetLastError();
        }
      //--- find and set the top and bottom boundaries, that the lines will be entered on the chart mapping area
      SetChartMaxMin(short_value,long_value);
     }
  }
//+------------------------------------------------------------------+
//| Subchart redraw                                                  |
//+------------------------------------------------------------------+
void CSubChartExtended::ReDraw(void)
  {
//--- A standard method of redrawing
   ChartRedraw(m_subchartID);
  }
//+------------------------------------------------------------------+
//| Getting handle for loading the lines from file                   |
//+------------------------------------------------------------------+
bool CSubChartExtended::LoadLines(const string path)
  {
//--- reset error
   ResetLastError();
//--- opening the file
   int file_handle=FileOpen(path,FILE_READ|FILE_TXT|FILE_ANSI);
//--- check
   if(file_handle==INVALID_HANDLE)
      return(false);
//--- loading the data
   Load(file_handle);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Lines loading                                                    |
//+------------------------------------------------------------------+
bool CSubChartExtended::Load(const int file_handle)
  {
//--- variable to read a strings from the file
   string str=" ";
//--- buffer to split the string
   string buf[3];
//--- allocation
   ArrayResize(m_linesData,50);
//--- counter of rows
   int i=0;
//--- read until the end of file
   while(!FileIsEnding(file_handle))
     {
      //--- read the current string
      str=FileReadString(file_handle);
      //--- split it into 3 parts
      StringSplit(str,StringGetCharacter(" ",0),buf);
      //--- replace commas to points
      StringReplace(buf[1],",",".");
      StringReplace(buf[2],",",".");
      //--- store data
      m_linesData[i].m_name=buf[0];
      m_linesData[i].m_short=StringToDouble(buf[1]);
      m_linesData[i].m_long=StringToDouble(buf[2]);
      //--- increase the counter
      i++;
     }
//--- close file
   FileClose(file_handle);
   m_lines_loaded=true;
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Change the maximal and minimal chart boundaries                  |
//+------------------------------------------------------------------+
void CSubChartExtended::SetChartMaxMin(const double short_value,const double long_value)
  {
//--- current values of boundaries
   double chart_fixed_max=ChartGetDouble(m_subchartID,CHART_FIXED_MAX);
   double chart_fixed_min=ChartGetDouble(m_subchartID,CHART_FIXED_MIN);
//--- indent
   double indent=(chart_fixed_max-chart_fixed_min)*40/chart_height;
//--- calculate the values location relative to the interval
   int ind_short=InRange(chart_fixed_max,chart_fixed_min,short_value,indent);
   int ind_long=InRange(chart_fixed_max,chart_fixed_min,long_value,indent);
//--- If the both lines are inside the boundaries should not be changed
   if(ind_short==0 && ind_long==0)
      return;
//--- otherwise, you need to change the boundaries.
   ChartSetInteger(m_subchartID,CHART_SCALEFIX,true);
//--- both above
   if(ind_short==1 && ind_long==1)
      ChartSetDouble(m_subchartID,CHART_FIXED_MAX,MathMax(short_value,long_value)+indent);
//--- short above, long inside
   if(ind_short==1 && ind_long==0)
      ChartSetDouble(m_subchartID,CHART_FIXED_MAX,short_value+indent);
//--- short above, long below
   if(ind_short==1 && ind_long==-1)
     {
      ChartSetDouble(m_subchartID,CHART_FIXED_MAX,short_value+indent);
      ChartSetDouble(m_subchartID,CHART_FIXED_MIN,long_value-indent);
     }
//--- short inside, long above
   if(ind_short==0 && ind_long==1)
      ChartSetDouble(m_subchartID,CHART_FIXED_MAX,long_value+indent);
//--- short inside, long below
   if(ind_short==0 && ind_long==-1)
      ChartSetDouble(m_subchartID,CHART_FIXED_MIN,long_value-indent);
//--- short below, long above
   if(ind_short==-1 && ind_long==1)
     {
      ChartSetDouble(m_subchartID,CHART_FIXED_MAX,long_value+indent);
      ChartSetDouble(m_subchartID,CHART_FIXED_MIN,short_value-indent);
     }
//--- short below, long inside
   if(ind_short==-1 && ind_long==0)
      ChartSetDouble(m_subchartID,CHART_FIXED_MIN,short_value-indent);
//--- both below
   if(ind_short==-1 && ind_long==-1)
      ChartSetDouble(m_subchartID,CHART_FIXED_MIN,MathMin(short_value,long_value)-indent);
  }
//+------------------------------------------------------------------+
//| "pos" location relative to interval (bottom,top)                 |
//+------------------------------------------------------------------+
int CSubChartExtended::InRange(const double top,const double bottom,
                               const double pos,const double indent)
  {
//--- if above, return 1
   if(pos>=top-indent)
      return(1);
//--- if below, return -1
   if(pos<=bottom+indent)
      return(-1);
//--- inside
   return(0);
  }
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//--- number of currency pairs
   int               symbols;
//--- name of currency pairs
   string            name;
//--- variables of row and column numbers for the chart drawing
   int               col;
   int               row;
//--- get the number of currency pairs
   symbols=SymbolsTotal(true);
//--- subchart object
   CSubChartExtended SubChart[];
   ArrayResize(SubChart,symbols);
//--- loading lines data
   if(SubChart[0].LoadLines("linesdata.txt")) Print("Data successfully loaded");
   else                                       Print("Failed to load data: ",GetLastError());
//--- loop over all pairs
   for(int i=0;i<symbols;i++)
     {
      //--- get the name of currency pair
      name=SymbolName(i,true);
      //--- get the position for the current chart
      GetPosition(2,i,row,col);
      //--- create a new subchart
      if(SubChart[i].CreateSubChart(0,name,0,start_x+col*chart_width,start_x+row*chart_height,chart_width,chart_height))
        {
         //--- set the symbol
         SubChart[i].Symbol(name);
         //--- time frame
         SubChart[i].Period(PERIOD_H4);
         //--- scale
         SubChart[i].Scale(3);
         //--- change the display properties
         SubChart[i].ChangeSettings();
         //--- redraw
         SubChart[i].ReDraw();
        }
      else
        {
         Print("Failed to create a chart, the error: ",GetLastError());
         ResetLastError();
        }
     }
//--- loop over all pairs again
   for(int i=0;i<symbols;i++)
     {
      //--- shift the visible area of ??the chart
      SubChart[i].SubChartNavigate();
      SubChart[i].ReDraw();
      //--- delay
      Sleep(1000);
      //--- draw a white rectangle
      SubChart[i].DrawRectangle();
      //--- redraw
      SubChart[i].ReDraw();
      //--- draw the short and long lines
      SubChart[i].DrawLines();
      //--- redraw
      SubChart[i].ReDraw();
     }
   Sleep(100000);
  }
//+------------------------------------------------------------------+
//|  Returns the row and column position in the table by number      |
//+------------------------------------------------------------------+
void GetPosition(const int cols,int abs_pos,int &row_pos,int &col_pos)
  {
//--- get the row and column numbers
   col_pos=abs_pos%cols;
   row_pos=abs_pos/cols;
  }
//+------------------------------------------------------------------+
//|  Returns the shift                                               |
//+------------------------------------------------------------------+
int GetShift(string name,ENUM_TIMEFRAMES timeframe,long chartID)
  {
//--- number of visible bars on the chart
   int visible_bars=32;
//--- variable for the shift
   int shift=0;
//--- array of dates
   datetime DATA_TIME[];
//--- determine the total number of dates for the currency pair
   int bars=Bars(name,timeframe);
//--- get the number of the retrieved dates
   int count=CopyTime(name,timeframe,0,bars,DATA_TIME);
//--- check if there is a data in array
   if(count!=-1)
     {
      //--- find the index number for the "start" date
      int index=0;
      for(int j=count-1;j>=0;j--)
         if(DATA_TIME[j]==start)
            index=j;
      //--- get the shift, 2 - indent for the rectangle
      shift=-count+index+visible_bars-2;
     }
//--- return shift
   return(shift);
  }
//+------------------------------------------------------------------+
