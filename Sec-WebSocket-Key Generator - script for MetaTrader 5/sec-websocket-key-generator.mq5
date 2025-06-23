//+------------------------------------------------------------------+
//|                                  Sec-WebSocket-Key-Generator.mq5 |
//|                                Copyright 2024, Rajesh Kumar Nait |
//|                  https://www.mql5.com/en/users/rajeshnait/seller |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, Rajesh Kumar Nait"
#property link      "https://www.mql5.com/en/users/rajeshnait/seller"
#property version   "1.00"
#property description "Generated Sec-WebSocket-Key as described in https://datatracker.ietf.org/doc/html/rfc6455#section-11.3.3"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart() {
//---
   MathSrand(GetTickCount());

   // Call the function to generate and print the key
   string generatedKey = GenerateKey();
   Print("Generated Key: ", generatedKey);
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string Base64EncodeChar(int value) {
   string base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

   if (value >= 0 && value <= 63)
      return StringSubstr(base64Chars, value, 1);
   else
      return "=";
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GenerateKey() {
   uchar randomBytes[16];

   // Generate 16 random bytes using MathRand
   for (int i = 0; i < ArraySize(randomBytes); i++) {
      randomBytes[i] =  MathRand() % 256;
   }

   // Base64 encode the random bytes
   string base64Key = "";
   for (int i = 0; i < ArraySize(randomBytes); i += 3) {
      int byte1 = randomBytes[i];
      int byte2 = i + 1 < ArraySize(randomBytes) ? randomBytes[i + 1] : 0;
      int byte3 = i + 2 < ArraySize(randomBytes) ? randomBytes[i + 2] : 0;

      int combinedValue = (byte1 << 16) | (byte2 << 8) | byte3;

      base64Key += Base64EncodeChar((combinedValue >> 18) & 0x3F);
      base64Key += Base64EncodeChar((combinedValue >> 12) & 0x3F);
      base64Key += i + 1 < ArraySize(randomBytes) ? Base64EncodeChar((combinedValue >> 6) & 0x3F) : "=";
      base64Key += i + 2 < ArraySize(randomBytes) ? Base64EncodeChar(combinedValue & 0x3F) : "=";
   }

   return base64Key;
}
//+------------------------------------------------------------------+
