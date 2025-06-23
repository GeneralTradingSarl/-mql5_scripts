//+------------------------------------------------------------------+
//|                                                     Historex.mq5 |
//|                               Copyright (c) 2020-2024, Marketeer |
//|                          https://www.mql5.com/en/users/marketeer |
//|                   Based on https://www.mql5.com/en/articles/8226 |
//+------------------------------------------------------------------+

#property script_show_inputs
#property description "Export rates and ticks of current chart's symbol into CSV-files compatible with MT5's export/import format."

input datetime FilterStart = 0;
input datetime FilterStop = 0;

const long DAY_LONG = 60 * 60 * 24;

#define TTSM(x) TimeToString((datetime)(x), TIME_DATE|TIME_MINUTES)

interface TickPlayer
{
  bool accept(const MqlTick &t);
};

class TickProvider
{
  public:
    virtual bool hasNext() = 0;
    virtual void getTick(MqlTick &t) = 0;
    virtual void getAllTicks(MqlTick &out[]) = 0;

    bool read(MqlTick &out[])
    {
      while(hasNext() && !IsStopped())
      {
        MqlTick part[];
        getAllTicks(part);
        ArrayCopy(out, part, ArraySize(out));
      }
      
      return IsStopped();
    }
    
    bool read(TickPlayer *p)
    {
      while(hasNext() && !IsStopped())
      {
        MqlTick t;
        getTick(t);
        if(!p.accept(t)) break;
      }
      
      return IsStopped();
    }
};

class HistoryTickProvider : public TickProvider
{
  private:
    datetime origin;
    datetime start;
    datetime stop;
    ulong length;     // in seconds
    MqlTick array[];
    int size;
    int cursor;
    
    int numberOfDays;
    int daysCount;
    
  protected:
    void fillArray()
    {
      cursor = 0;
      do
      {
        const datetime _stop = (datetime)MathMin(start + length, stop);
        size = CopyTicksRange(_Symbol, array, COPY_TICKS_ALL, start * 1000, _stop * 1000);
        
        static datetime lastKnownTime = 0;
        
        if(start == origin) lastKnownTime = 0;
        
        if(size > 0)
        {
          lastKnownTime = array[size - 1].time;
        }
        const float estimated = lastKnownTime ? (float)((lastKnownTime - origin) / DAY_LONG) : daysCount;
        
        const double percent = estimated * 100.0 / (numberOfDays + 1);
        Print("Processing ", TTSM(start), " - ", TTSM(_stop), " ", size, " ",
          DoubleToString(percent, 0), "%, days:[actual=", daysCount, ", calendar=", estimated, "]");
        Comment("Processing: ", DoubleToString(percent, 0), "% ", TTSM(start));
        
        if(size == -1)
        {
          Print("CopyTicksRange failed: ", GetLastError());
        }
        else
        {
          if(size > 0 && array[0].time_msc < start * 1000) // MT5 bug is suspected: older than requested data returned
          {
            start = stop;
            size = 0;
          }
          else
          {
            start = (datetime)MathMin(start + length, stop);
            if(size > 0) daysCount++;
          }
        }
      }
      while(size == 0 && start < stop);
    }
  
  public:
    HistoryTickProvider(const datetime from, const long secs, const datetime to = 0): start(from), stop(to), length(secs), cursor(0), size(0)
    {
      if(start == 0) start = (datetime)SeriesInfoInteger(_Symbol, _Period, SERIES_FIRSTDATE);
      start = (datetime)(start / DAY_LONG * DAY_LONG);
      origin = start;
      if(stop == 0) stop = TimeCurrent();
      numberOfDays = (int)((stop - start) / DAY_LONG);
      PrintFormat("History processing started for %d calendar days [%s - %s]",
        numberOfDays, TTSM(start), TTSM(stop));
      daysCount = 0;
      fillArray();
    }

    bool hasNext() override
    {
      return cursor < size;
    }

    void getTick(MqlTick &t) override
    {
      if(cursor < size)
      {
        t = array[cursor++];
        if(cursor == size)
        {
          fillArray();
        }
      }
    }
    
    void getAllTicks(MqlTick &out[]) override
    {
      if(cursor < size)
      {
        ArraySwap(array, out);
        cursor = size;
        fillArray();
      }
    }
};



void OnStart()
{
  string s1 = TTSM(FilterStart);
  string s2 = TTSM(FilterStop ? FilterStop : LONG_MAX);
  StringReplace(s1, ":", ""); StringReplace(s1, ".", ""); StringReplace(s1, " ", "");
  StringReplace(s2, ":", ""); StringReplace(s2, ".", ""); StringReplace(s2, " ", "");
  const string prefix = _Symbol + "-" + s1 + "-" + s2;

  HistoryTickProvider htp(FilterStart, DAY_LONG, FilterStop);
  
  MqlTick ticks[];
  htp.read(ticks);
  if(!IsStopped())
  {
    Comment("Writing ticks...");
    ExportTicks(prefix + "-ticks.csv", ticks);
    Comment("Writing rates...");
    ExportRates(prefix + "-" + StringSubstr(EnumToString(_Period), StringLen("PERIOD_")) + "-rates.csv");
  }
  Comment("");
}

void OutputTick(const int handle, const MqlTick &tick)
{
  FileWrite(handle,
    TimeToString(tick.time, TIME_DATE),
    TimeToString(tick.time, TIME_SECONDS) + "." + StringFormat("%03d", tick.time_msc % 1000),
    !!(tick.flags & TICK_FLAG_BID) ? DoubleToString(tick.bid, _Digits) : "",
    !!(tick.flags & TICK_FLAG_ASK) ? DoubleToString(tick.ask, _Digits) : "",
    !!(tick.flags & TICK_FLAG_LAST) ? DoubleToString(tick.last, _Digits) : "",
    !!(tick.flags & TICK_FLAG_VOLUME) ? (string)tick.volume : "",
    tick.flags);
}

void ExportTicks(const string filename, const MqlTick &ticks[])
{
  int handle = FileOpen(filename, FILE_ANSI | FILE_CSV | FILE_WRITE, "\t");
  FileWrite(handle, "<DATE>", "<TIME>", "<BID>", "<ASK>", "<LAST>", "<VOLUME>", "<FLAGS>");
  for(int i = 0; i < ArraySize(ticks) && !IsStopped(); ++i)
  {
    OutputTick(handle, ticks[i]);
  }
  FileClose(handle);
  PrintFormat("%ld ticks saved into %s", ArraySize(ticks), filename);
}

void OutputRate(const int handle, const MqlRates &rate)
{
  FileWrite(handle,
    TimeToString(rate.time, TIME_DATE),
    TimeToString(rate.time, TIME_SECONDS),
    DoubleToString(rate.open, _Digits),
    DoubleToString(rate.high, _Digits),
    DoubleToString(rate.low, _Digits),
    DoubleToString(rate.close, _Digits),
    IntegerToString(rate.tick_volume),
    IntegerToString(rate.real_volume),
    IntegerToString(rate.spread));
}

void ExportRates(const string filename)
{
  MqlRates rates[];
  CopyRates(_Symbol, PERIOD_CURRENT, FilterStart, FilterStop ? FilterStop : (datetime)LONG_MAX, rates);
  int handle = FileOpen(filename, FILE_ANSI | FILE_CSV | FILE_WRITE, "\t");
  FileWrite(handle, "<DATE>", "<TIME>", "<OPEN>", "<HIGH>", "<LOW>", "<CLOSE>", "<TICKVOL>", "<VOL>", "<SPREAD>");
  for(int i = 0; i < ArraySize(rates) && !IsStopped(); ++i)
  {
    OutputRate(handle, rates[i]);
  }
  FileClose(handle);
  PrintFormat("%ld rates saved into %s", ArraySize(rates), filename);
}
