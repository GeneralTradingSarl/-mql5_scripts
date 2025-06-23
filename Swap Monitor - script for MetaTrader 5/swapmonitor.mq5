//+------------------------------------------------------------------+
//|                                                  SwapMonitor.mq5 |
//|                                    Copyright (c) 2024, Marketeer |
//|                          https://www.mql5.com/en/users/marketeer |
//+------------------------------------------------------------------+

#property service
#property copyright "Copyright (c) 2024 Marketeer"
#property link      "https://www.mql5.com/en/users/marketeer"
#property version   "1.0"
#property script_show_inputs

#include <MQL5Book/ArrayUtils.mqh>
#include <MQL5Book/Defines.mqh>

//+------------------------------------------------------------------+
//| I N P U T S                                                      |
//+------------------------------------------------------------------+

input string SymbolList = "";  // SymbolList (comma,separated)
input string Folder = "Swaps";
input uint Beat = 10;          // Beat (seconds)
input bool AutoSelect = false;

//+------------------------------------------------------------------+
//| Global definitions                                               |
//+------------------------------------------------------------------+

const string Program = EnumToString((ENUM_PROGRAM_TYPE)MQLInfoInteger(MQL_PROGRAM_TYPE)) + " " + MQLInfoString(MQL_PROGRAM_NAME);

string SymbolArray[];

struct Swaps // could be null-ed on creation by compiler if static and global (not the case)
{
   datetime dt;
   double L;
   double S;
   int N;
   
   Swaps()
   {
      ZeroMemory(this);
   }
   
   Swaps(const datetime t, const double l, const double s, const int n = 0): dt(t), L(l), S(s), N(n) { }
   
   string csv() const
   {
      return StringFormat("%s,%g,%g", TimeToString(dt, TIME_DATE | TIME_SECONDS), L, S);
   }
};

struct Position
{
   ulong ticket;
   double swap;
};

Swaps cache[];
Position positions[];

//+------------------------------------------------------------------+
//| Service program start function                                   |
//+------------------------------------------------------------------+

void OnStart()
{
   if(StringSplit(SymbolList, ',', SymbolArray) < 1)
   {
      Print("No symbols given");
      if(AutoSelect)
      {
         for(int i = 0; i < SymbolsTotal(true); i++)
         {
            const string symbol = SymbolName(i, true);
            if(!SymbolInfoInteger(symbol, SYMBOL_CUSTOM)
            && SymbolInfoInteger(symbol, SYMBOL_TRADE_MODE) != SYMBOL_TRADE_MODE_DISABLED)
            {
               PUSH(SymbolArray, symbol);
            }
         }
         Print("MarketWatch symbols autoselected:");
         ArrayPrint(SymbolArray);
      }
   }

   for(int i = 0; i < ArraySize(SymbolArray); i++)
   {
      if(!SymbolInfoInteger(SymbolArray[i], SYMBOL_EXIST))
      {
         Print("Unknown symbol: ", SymbolArray[i]);
         SymbolArray[i] = "";
      }
      else if(!SymbolInfoInteger(SymbolArray[i], SYMBOL_VISIBLE))
      {
         if(AutoSelect && SymbolSelect(SymbolArray[i], true))
         {
            // ok
         }
         else
         {
            PrintFormat("Can't select symbol: %s [%d]", SymbolArray[i], _LastError);
            SymbolArray[i] = "";
         }
      }
   }
   
   ArrayPurge(SymbolArray, "");
   ArrayResize(cache, ArraySize(SymbolArray));
   
   Print(Program + " started");
   bool active = true;
   
   for(; !IsStopped() ;)
   {
      // wait for connected and logged in state
      if(!(TerminalInfoInteger(TERMINAL_CONNECTED) && AccountInfoInteger(ACCOUNT_LOGIN)))
      {
         if(active)
         {
            Print(Program + " is waiting for connection");
            active = false;
         }
         
         Sleep(1000);
         continue;
      }
      
      if(!active)
      {
         Print(Program + " connected");
         active = true;
      }
   
      // check swaps in symbols properties and save changes (if any)
      const string filename = GetTimeStamp();
      for(int i = 0; i < ArraySize(SymbolArray); i++)
      {
         if(StringLen(SymbolArray[i]) && !SaveSymbolSwap(SymbolArray[i], filename, cache[i]))
         {
            SymbolArray[i] = "";
         }
      }
      
      // check if positions still exist
      for(int i = 0; i < ArraySize(positions); i++)
      {
         if(!PositionSelectByTicket(positions[i].ticket))
         {
            Alert(StringFormat("Position %llu closed with swap %g", positions[i].ticket, positions[i].swap));
            positions[i].ticket = 0;
         }
      }
      
      ArrayPurger<Position> purger(positions, IsClosedPosition);
      
      // compare positions swaps and alert changes (if any)
      const int n = PositionsTotal();
      for(int i = 0; i < n; i++)
      {
         const ulong ticket = PositionGetTicket(i);
         if(ticket)
         {
            FindPositionSwap(ticket);
         }
      }

      Sleep(Beat * 1000);
   }
   Print(Program + " stopped");
}

//+------------------------------------------------------------------+
//| Auxiliary functions                                              |
//+------------------------------------------------------------------+

string GetTimeStamp()
{
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   return StringFormat("%04d%02d", dt.year, dt.mon) + ".csv";
}

template<typename T>
bool Contains(const T &a[], const T v)
{
  for(int i = 0; i < ArraySize(a); i++)
  {
    if(a[i] == v) return true;
  }
  return false;
}

string Escape(const string s)
{
  uchar a[];
  uchar forbidden[] = {'<', '>', '/', '\\', '"', ':', '|', '*', '?'};
  int n = StringToCharArray(s, a);
  for(int i = 0; i < n - 1; i++)
  {
    if(a[i] < 32 || Contains(forbidden, a[i]))
    {
      a[i] = '_';
    }
  }
  return CharArrayToString(a);
}

bool IsClosedPosition(const Position &p)
{
   return !p.ticket;
}

void FindPositionSwap(const ulong ticket)
{
   const double swap = PositionGetDouble(POSITION_SWAP);
   const double volume = PositionGetDouble(POSITION_VOLUME);
   const string symbol = PositionGetString(POSITION_SYMBOL);
   const int digits = (int)MathLog10(1.0 / SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP));
   const string type = PositionGetInteger(POSITION_TYPE) ? "Sell" : "Buy";
   
   for(int i = 0; i < ArraySize(positions); i++)
   {
      if(positions[i].ticket == ticket)
      {
         if(positions[i].swap != swap)
         {
            Alert(StringFormat("Position %llu (%s %.*f %s) swap: %g -> %g",
               ticket, type, digits, volume, symbol, positions[i].swap, swap));
            positions[i].swap = swap;
         }
         return;
      }
   }
   
   Position p = {ticket, swap};
   PUSH(positions, p);
   Alert(StringFormat("New position %llu (%s %.*f %s) swap: %g",
      ticket, type, digits, volume, symbol, swap));
}

//+------------------------------------------------------------------+
//| Persistent storage (CSV-files)                                   |
//+------------------------------------------------------------------+

bool SaveSymbolSwap(const string &s, const string &f, Swaps &last)
{
   const Swaps now
   (
      TimeCurrent(),
      SymbolInfoDouble(s, SYMBOL_SWAP_LONG),
      SymbolInfoDouble(s, SYMBOL_SWAP_SHORT),
      last.N
   );
   
   if(now.L == last.L && now.S == last.S) return true; // up to date
   
   const string name = Folder + "/" + Escape(s) + "/" + f;
   int h = FileOpen(name, FILE_ANSI | FILE_TXT | FILE_READ | FILE_WRITE, ",", CP_UTF8);
   if(h == INVALID_HANDLE)
   {
      PrintFormat("Can't open file '%s' [%d]", name, _LastError);
      return false;
   }
   if(!FileSize(h))
   {
      FileWrite(h, "T,L,S");
   }
   else
   {
      FileSeek(h, 0, SEEK_END);
   }
   
   FileWrite(h, now.csv());
   
   FileClose(h);

   PrintFormat("%s swap changed %d-th time", s, last.N + 1);
   if(last.dt)
   {
      PrintFormat("- Old: %s L=%g S=%g", TimeToString(last.dt, TIME_DATE | TIME_SECONDS), last.L, last.S);
   }
   PrintFormat("+ New: %s L=%g S=%g", TimeToString(now.dt, TIME_DATE | TIME_SECONDS), now.L, now.S);
   Alert(StringFormat("%s swaps: L=%g S=%g", s, now.L, now.S));
   
   last = now;
   last.N++;
   
   return true;
}

//+------------------------------------------------------------------+
