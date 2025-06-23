//+------------------------------------------------------------------+
//|                                                Candle_Signs`.mq5 |
//|                                Copyright 2025, Rajesh Kumar Nait |
//|                  https://www.mql5.com/en/users/rajeshnait/seller |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Rajesh Kumar Nait"
#property link      "https://www.mql5.com/en/users/rajeshnait/seller"
#property version   "1.00"

#include <Generic/HashMap.mqh>

class CandlePatternDetector {
 private:
   CHashMap<string, string> patternDatabase;
   double tolerance;

   string GenerateSignature(double open, double high, double low, double close) {
      // Normalize candle dimensions
      double bodySize = MathAbs(close - open);
      double upperWick = high - MathMax(open, close);
      double lowerWick = MathMin(open, close) - low;
      double totalSize = high - low;

      // Avoid division by zero
      if(totalSize == 0) return "DOJI";

      // Calculate ratios
      double bodyRatio = bodySize / totalSize;
      double upperWickRatio = upperWick / totalSize;
      double lowerWickRatio = lowerWick / totalSize;

      // Generate fuzzy signature
      string signature = "";

      // Body classification
      if(bodyRatio < 0.1) signature += "DOJI_";
      else if(bodyRatio < 0.3) signature += "SMALL_";
      else if(bodyRatio < 0.7) signature += "MEDIUM_";
      else signature += "LONG_";

      // Wick classification
      if(upperWickRatio < 0.1) signature += "NO_UPPER_WICK_";
      else if(upperWickRatio < 0.3) signature += "SHORT_UPPER_WICK_";
      else if(upperWickRatio < 0.7) signature += "MEDIUM_UPPER_WICK_";
      else signature += "LONG_UPPER_WICK_";

      if(lowerWickRatio < 0.1) signature += "NO_LOWER_WICK_";
      else if(lowerWickRatio < 0.3) signature += "SHORT_LOWER_WICK_";
      else if(lowerWickRatio < 0.7) signature += "MEDIUM_LOWER_WICK_";
      else signature += "LONG_LOWER_WICK_";

      // Direction
      signature += (close > open) ? "BULLISH" : "BEARISH";

      return signature;
   }

   void LoadDemoPatterns() {
      // Common bullish patterns
      AddCustomPattern(1.0, 1.1, 0.95, 1.08, "Bullish Engulfing");
      AddCustomPattern(1.0, 1.05, 0.98, 1.03, "Hammer");
      AddCustomPattern(1.0, 1.02, 0.99, 1.01, "Doji Star");
      AddCustomPattern(1.0, 1.15, 0.9, 1.14, "Long Bullish Marubozu");

      // Common bearish patterns
      AddCustomPattern(1.0, 1.05, 0.9, 0.92, "Bearish Engulfing");
      AddCustomPattern(1.0, 1.02, 0.85, 0.86, "Hanging Man");
      AddCustomPattern(1.0, 1.01, 0.99, 1.0, "Gravestone Doji");
      AddCustomPattern(1.0, 1.02, 0.8, 0.81, "Long Bearish Marubozu");

      // Neutral patterns
      AddCustomPattern(1.0, 1.01, 0.99, 1.0, "Perfect Doji");
      AddCustomPattern(1.0, 1.05, 0.95, 1.0, "Spinning Top");
   }

 public:
   CandlePatternDetector(double tol=0.2) {
      tolerance = tol;
      LoadDemoPatterns();
      Print("Loaded ", patternDatabase.Count(), " demo candle patterns");
   }

   string FindCandleSign(int index) {
      double open = iOpen(NULL, 0, index);
      double high = iHigh(NULL, 0, index);
      double low = iLow(NULL, 0, index);
      double close = iClose(NULL, 0, index);

      string currentSignature = GenerateSignature(open, high, low, close);
      string value;

      // Exact match
      if(patternDatabase.TryGetValue(currentSignature, value))
         return value;

      // Fuzzy match with tolerance
      string bestMatch = "";
      double bestScore = 0;

      // Correct HashMap iteration using CopyTo
      string keys[];
      string values[];
      patternDatabase.CopyTo(keys, values);

      for(int i = 0; i < ArraySize(keys); i++) {
         double similarity = CompareSignatures(currentSignature, keys[i]);
         if(similarity > bestScore && similarity >= (1.0 - tolerance)) {
            bestScore = similarity;
            bestMatch = values[i];
         }
      }

      if(bestMatch != "")
         return "SIMILAR_TO: " + bestMatch + " (Confidence: " + DoubleToString(bestScore*100, 1) + "%)";

      return "UNKNOWN_PATTERN";
   }

   double CompareSignatures(string sig1, string sig2) {
      string parts1[], parts2[];
      StringSplit(sig1, '_', parts1);
      StringSplit(sig2, '_', parts2);

      if(ArraySize(parts1) != ArraySize(parts2))
         return 0.0;

      int matches = 0;
      for(int i = 0; i < ArraySize(parts1); i++) {
         if(parts1[i] == parts2[i])
            matches++;
      }

      return (double)matches / ArraySize(parts1);
   }

   void AddCustomPattern(double open, double high, double low, double close, string comment) {
      string signature = GenerateSignature(open, high, low, close);
      patternDatabase.Add(signature, comment);
   }
};

// Global instance
CandlePatternDetector *detector;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

// Example usage
void OnStart() {
   detector = new CandlePatternDetector(0.3); // 30% tolerance
   int currentCandle = 1; // Most recent closed candle
   string patternInfo = detector.FindCandleSign(currentCandle);
   Print("Candle Pattern: ", patternInfo);
   delete detector;
}
//+------------------------------------------------------------------+
