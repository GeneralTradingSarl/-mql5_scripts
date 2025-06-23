//+------------------------------------------------------------------+
//|                                                      Advanced EA | 
//+------------------------------------------------------------------+
#property strict
#include <Trade\Trade.mqh>

input double RiskPercent      = 5.0;      // Persentase risiko per transaksi
input int    StochKPeriod     = 14;       // Periode Stochastic K
input int    StochDPeriod     = 3;        // Periode Stochastic D
input int    Slowing          = 7;        // Slowing Stochastic
input int    CooldownMinutes  = 60;       // Cooldown untuk entry
input int    StopLossPoints   = 300;      // Stop Loss dalam poin
input int    TakeProfitPoints = 300;      // Take Profit dalam poin

CTrade trade;
datetime lastTradeTime = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   | 
//+------------------------------------------------------------------+
int OnInit()
{
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 | 
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
}

//+------------------------------------------------------------------+
//| Hitung lot berdasarkan risiko                                    | 
//+------------------------------------------------------------------+
double CalculateRiskLotSize(double stopLossPoints)
{
   // Ukuran lot tetap 0.1 untuk kemudahan
   return 0.1;
}

//+------------------------------------------------------------------+
//| Normalisasi lot                                                  | 
//+------------------------------------------------------------------+
double NormalizeLotSize(double lot)
{
   double minLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   lot = MathMax(MathMin(lot, maxLot), minLot);
   return MathFloor(lot / lotStep) * lotStep;
}

//+------------------------------------------------------------------+
//| Cek posisi terbuka                                               | 
//+------------------------------------------------------------------+
bool HasOpenPosition(bool isBuy)
{
   for (int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if (PositionGetTicket(i) > 0)
      {
         if ((isBuy && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ||
             (!isBuy && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL))
            return true;
      }
   }
   return false;
}

//+------------------------------------------------------------------+
//| Tutup semua posisi                                               | 
//+------------------------------------------------------------------+
void CloseOpenPositions()
{
   for (int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if (PositionGetTicket(i) > 0)
      {
         ulong ticket = PositionGetTicket(i);
         trade.PositionClose(ticket);
      }
   }
}

//+------------------------------------------------------------------+
//| Fungsi utama EA                                                  | 
//+------------------------------------------------------------------+
void OnTick()
{
   // Menghindari eksekusi jika cooldown belum selesai
   if (TimeCurrent() - lastTradeTime < CooldownMinutes * 60)
      return;

   // Mendapatkan data Stochastic
   int stochHandle = iStochastic(_Symbol, PERIOD_H1, StochKPeriod, Slowing, StochDPeriod, MODE_SMA, STO_LOWHIGH);
   if (stochHandle == INVALID_HANDLE)
      return;

   double kBuffer[2], dBuffer[2];
   if (CopyBuffer(stochHandle, 0, 0, 2, kBuffer) < 2)
      return;
   if (CopyBuffer(stochHandle, 1, 0, 2, dBuffer) < 2)
      return;

   double k     = kBuffer[0];
   double d     = dBuffer[0];
   double kPrev = kBuffer[1];
   double dPrev = dBuffer[1];

   // Menentukan harga
   double ask     = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid     = SymbolInfoDouble(_Symbol, SYMBOL_BID);

   // Ukuran lot tetap 0.1
   double lotSize = 0.1;

   // Menghitung Stop Loss dan Take Profit (TP tetap 300 poin)
   double slBuy   = ask - StopLossPoints * _Point;
   double tpBuy   = ask + TakeProfitPoints * _Point;  // TP tetap 300 poin
   double slSell  = bid + StopLossPoints * _Point;
   double tpSell  = bid - TakeProfitPoints * _Point;  // TP tetap 300 poin

   // Entry Buy (Stochastic crossing signal)
   if (kPrev < dPrev && k > d && !HasOpenPosition(true))
   {
      CloseOpenPositions();
      trade.Buy(lotSize, _Symbol, ask, slBuy, tpBuy, "Buy");
      lastTradeTime = TimeCurrent();
   }

   // Entry Sell (Stochastic crossing signal)
   if (kPrev > dPrev && k < d && !HasOpenPosition(false))
   {
      CloseOpenPositions();
      trade.Sell(lotSize, _Symbol, bid, slSell, tpSell, "Sell");
      lastTradeTime = TimeCurrent();
   }

   // Periksa jika ada posisi terbuka dan lakukan penutupan jika ada persilangan berlawanan
   if (HasOpenPosition(true) && kPrev > dPrev && k < d)
   {
      // Menutup posisi Buy jika sinyal Sell muncul
      CloseOpenPositions();
      // Menjalankan posisi Sell baru dengan SL dan TP tetap 300 poin
      slSell = bid + StopLossPoints * _Point;
      tpSell = bid - TakeProfitPoints * _Point;  // TP tetap 300 poin
      trade.Sell(lotSize, _Symbol, bid, slSell, tpSell, "Sell");
      lastTradeTime = TimeCurrent();
   }

   if (HasOpenPosition(false) && kPrev < dPrev && k > d)
   {
      // Menutup posisi Sell jika sinyal Buy muncul
      CloseOpenPositions();
      // Menjalankan posisi Buy baru dengan SL dan TP tetap 300 poin
      slBuy = ask - StopLossPoints * _Point;
      tpBuy = ask + TakeProfitPoints * _Point;  // TP tetap 300 poin
      trade.Buy(lotSize, _Symbol, ask, slBuy, tpBuy, "Buy");
      lastTradeTime = TimeCurrent();
   }
}
