//+------------------------------------------------------------------+
//|                                               Map Symbol.mq5     |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com/en/users/envex"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
// Declaration of an input parameter to specify the base symbol

string inputSymbol = "EURUSD"; // Base symbol entered by the user

// The main function of the script
void OnStart()
  {
// Retrieve all visible symbols in the Market Watch window
   string marketWatchSymbols[];
   int totalSymbols = SymbolsTotal(true); // Total number of symbols visible in Market Watch
   ArrayResize(marketWatchSymbols, totalSymbols); // Resize the array to store the symbols

// Fill the array with symbol names
   for(int i = 0; i < totalSymbols; i++)
      marketWatchSymbols[i] = SymbolName(i, true);

// Find the most similar symbol to the one specified by the user
   string mappedSymbol = FindMostSimilarSymbol(inputSymbol, marketWatchSymbols);

// Display the result as a comment on the chart
   Comment("The entered symbol is: ", inputSymbol, "\n",
           "The most similar symbol found is: ", mappedSymbol);
  }

//+------------------------------------------------------------------+
//| Function to calculate the Levenshtein distance between strings   |
//+------------------------------------------------------------------+
// This function implements the Levenshtein algorithm to calculate the minimum difference
// (insertions, deletions, substitutions) between two strings.
int LevenshteinDistance(string s, string t)
  {
   int len_s = StringLen(s); // Length of the first string
   int len_t = StringLen(t); // Length of the second string

// Handle empty strings: if one is empty, the distance equals the length of the other
   if(len_s == 0)
      return len_t;
   if(len_t == 0)
      return len_s;

// Declare and resize a dynamic array to store the distance matrix
   int total_size = (len_s + 1) * (len_t + 1);
   int dist_matrix[];
   ArrayResize(dist_matrix, total_size);

// Initialize the first column of the matrix
   for(int i = 0; i <= len_s; i++)
      dist_matrix[i * (len_t + 1)] = i;

// Initialize the first row of the matrix
   for(int j = 0; j <= len_t; j++)
      dist_matrix[j] = j;

// Fill the matrix by calculating the minimum distances
   for(int i = 1; i <= len_s; i++)
     {
      for(int j = 1; j <= len_t; j++)
        {
         // Calculate the substitution cost
         int cost = (StringGetCharacter(s, i - 1) == StringGetCharacter(t, j - 1)) ? 0 : 1;

         // Calculate the costs of deletion, insertion, and substitution
         int deletion = dist_matrix[(i - 1) * (len_t + 1) + j] + 1;
         int insertion = dist_matrix[i * (len_t + 1) + (j - 1)] + 1;
         int substitution = dist_matrix[(i - 1) * (len_t + 1) + (j - 1)] + cost;

         // Choose the minimum cost and assign it to the current cell
         dist_matrix[i * (len_t + 1) + j] = MathMin(deletion, MathMin(insertion, substitution));
        }
     }

// Return the value in the last cell of the matrix as the total distance
   return dist_matrix[len_s * (len_t + 1) + len_t];
  }

//+------------------------------------------------------------------+
//| Function to find the most similar symbol                         |
//+------------------------------------------------------------------+
// Compares a base symbol with a list of symbols and returns the most similar one
string FindMostSimilarSymbol(string baseSymbol, string &symbolList[])
  {
   int minDistance = INT_MAX; // Minimum distance initialized to the maximum integer value
   string closestSymbol = ""; // Variable to store the closest symbol

// Iterate over the symbol list and calculate the distance for each
   for(int i = 0; i < ArraySize(symbolList); i++)
     {
      int distance = LevenshteinDistance(baseSymbol, symbolList[i]); // Calculate the distance

      // If a smaller distance is found, update the values
      if(distance < minDistance)
        {
         minDistance = distance;
         closestSymbol = symbolList[i];
        }
     }

// Return the closest symbol found
   return closestSymbol;
  }
//+------------------------------------------------------------------+
