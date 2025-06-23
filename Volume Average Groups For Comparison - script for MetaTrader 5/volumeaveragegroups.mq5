// Learn how to manage the volume data, separate it in groups for comparison.
// Why is it important? Volume indicates commitment of the traders with the price movement.
// it may help you create strategies based on volume trading, trend and momentum.

// We separate this code in functions to help you understand it easily and apply it for your own use.

input int volQtyGroupOne = 3;            // Quantity of Volume bars to consider for group one
input int volQtyGroupTwo = 6;            // Quantity of Volume bars to consider Starting from the end of group one




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   int avgVolGroupOne = getVolAgv(1, volQtyGroupOne);
   int avgVolGroupTwo = getVolAgv(volQtyGroupOne+1, volQtyGroupTwo);

   Comment("Vol Avg G1: ", avgVolGroupOne,
           "\nVol Avg G2: ", avgVolGroupTwo);
  }


// This function below gets as parameter the quantity of bars you want to consider and return its average
int getVolAgv(int volQtyOfBarsStart, int volQtyOfBarsEnd)
  {
   double myPriceArray[];
   int VolumeDefinition = iVolumes(_Symbol, _Period, VOLUME_TICK);
   ArraySetAsSeries(myPriceArray, true);
   int qtyVolumeToGetFromBuffer = volQtyOfBarsStart+volQtyOfBarsEnd+1;
   CopyBuffer(VolumeDefinition,0,0,qtyVolumeToGetFromBuffer,myPriceArray);
   double volAverage = 0;
   int iVolAvg = 0;

   for(int i = volQtyOfBarsStart; i <= volQtyOfBarsEnd; i++)
     {
      volAverage += (myPriceArray[i]);
     }

   if(volQtyOfBarsStart == 1)
      volAverage /= volQtyOfBarsEnd;
   else
      volAverage /= (1+volQtyOfBarsEnd-volQtyOfBarsStart);

   iVolAvg = MathFloor(volAverage);

   return iVolAvg;
  }
