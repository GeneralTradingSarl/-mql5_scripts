//+------------------------------------------------------------------+
//|                                           20 indicators data.mq5 |
//|                                     Copyright 2023, Omega Joctan |
//|                        https://www.mql5.com/en/users/omegajoctan |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Omega Joctan"
#property link      "https://www.mql5.com/en/users/omegajoctan"
#property version   "1.00"
//#property script_show_inputs

//The script collects all (37) builtin indicator data at default indicator values and the current chart timeframe;

#define INDICATORS 38

input uint buffer_size = 100;

struct buffer_info //Carry all the buffer information and values 
  {
    matrix values;
    string names;
    
    int GetNames(string names_str, string &NamesArr[])
      {
       ushort sep = StringGetCharacter(",", 0);
       return StringSplit(names_str,sep,NamesArr);
      }
  };

struct buffers_struct:public buffer_info
  {   
  
   buffer_info _CopyRates(long handle, string buff_names, int start, int count) //Copy all buffers given available buffers from an indicatpr
     { 
       string names_arr[];
       
       int total_buffers = GetNames(buff_names, names_arr); //Buffer names == total buffers | this function extracts the number of buffers
       
        buffer_info buffers;
        buffers.values.Resize(count, total_buffers);
        
        vector v(count);
        v.Fill(0.0);
        
         for (int i=0; i<total_buffers; i++)
          {
           if (!v.CopyIndicatorBuffer(handle, i, start, count))
             {
               printf("Failed to copy %s Buffer %d Err = %d ",names_arr[i],i,GetLastError());
               continue;
             }
            buffers.values.Col(v, i); //Store each buffer into a values matrix
          } 
        return buffers;
      };
  };   
  
struct Indicators 
  {
    long handle[];
    string name[];
        
    buffers_struct buffers[];
      
    Indicators::Indicators(string symbol,ENUM_TIMEFRAMES timeframe)
     {
        ArrayResize(handle, INDICATORS);
        ArrayResize(name, INDICATORS);
        ArrayResize(buffers, INDICATORS);

        // Trend following(13)
        name[0] = "Adaptive Moving Averate"; 
        name[1] = "Average Directional Movement Index";
        name[2] = "Average Directional Movement Index Wilder";
        name[3] = "Bollinger Bands";
        name[4] = "Double Exponential Moving Average";
        name[5] = "Envelopes";
        name[6] = "Fractal Adaptive Moving Average";
        name[7] = "Ichimoku Kinko Hyo";
        name[8] = "Moving Average";
        name[9] = "Parabolic SAR";
        name[10] = "Standard Deviation";
        name[11] = "Tripple Exponential Moving Average";
        name[12] = "Variable Index Dynamic Average";

        // Oscillators (15)
        name[13] = "Average True Range";
        name[14] = "Bears Power";
        name[15] = "Bulls Power";
        name[16] = "Chainkin Oscillator";
        name[17] = "Commodity Channel Index";
        name[18] = "De Marker";
        name[19] = "Force Index";
        name[20] = "MACD";
        name[21] = "Momentum";
        name[22] = "Moving Average of Oscillator";
        name[23] = "Relative Strength Index";
        name[24] = "Relative Vigor Index";
        name[25] = "Stochastic Oscillator";
        name[26] = "Tripple Exponential Average";
        name[27] = "Williams' Percent Range";

        // Volumes(4)
        name[28] = "Accumulator Distributor";
        name[29] = "Money Flow Index";
        name[30] = "On Balance Volume";
        name[31] = "Volumes";

        // Bill Williams(6)
        name[32] = "Accelerator Oscillator";
        name[33] = "Alligator";
        name[34] = "Awesome Oscillator";
        name[35] = "Fractals";
        name[36] = "Gator Oscillator";
        name[37] = "Market Facilitation Index";
        
//--- Declaring and assigning the handles
        
//--- Trend
   
       handle[0] = iAMA(symbol, timeframe, 9 , 2 , 30, 0, PRICE_OPEN);
       buffers[0].names = " AMA";
       
       handle[1] = iADX(symbol, timeframe, 14);
       buffers[1].names = " ADX-MAIN_LINE, ADX-PLUSDI_LINE, ADX-MINUSDI_LINE";
       
       handle[2] = iADXWilder(symbol, timeframe, 14);
       buffers[2].names = " ADXWilder-MAIN_LINE, ADXWilder-PLUSDI_LINE, ADXWilder-MINUSDI_LINE";
       
       handle[3] = iBands(symbol, timeframe, 20, 0, 2.0, PRICE_OPEN);
       buffers[3].names = " BB-BASE_LINE, BB-UPPER_BAND, BB-LOWER_BAND";
       
       handle[4] = iDEMA(symbol, timeframe, 14, 0, PRICE_OPEN);
       buffers[4].names = " DEMA";
       
       handle[5] = iEnvelopes(symbol, timeframe, 14, 0, MODE_SMA, PRICE_OPEN, 0.1);
       buffers[5].names = " Envelopes-UPPER_LINE, Envelopes-LOWER_LINE";
       
       handle[6] = iFrAMA(symbol, timeframe, 14, 0, PRICE_OPEN);
       buffers[6].names = " FRAMA";
       
       handle[7] = iIchimoku(symbol, timeframe, 9, 26, 52);
       buffers[7].names = " Ichimoku-TENKANSEN_LINE, Ichimoku-KIJUNSEN_LINE, Ichimoku-SENKOUSPANA_LINE, Ichimoku-SENKOUSPANB_LINE, Ichimoku-CHIKOUSPAN_LINE";
       
       handle[8] = iMA(symbol, timeframe, 10, 0, MODE_SMA, PRICE_OPEN);
       buffers[8].names = " MA";
       
       handle[9] = iSAR(symbol, timeframe, 0.02, 0.2);
       buffers[9].names = " SAR";
       
       handle[10] = iStdDev(symbol, timeframe, 10000, 0, MODE_SMA, PRICE_OPEN);
       buffers[10].names = " StdDev";
       
       handle[11] = iTEMA(symbol, timeframe, 14, 0, PRICE_CLOSE);
       buffers[11].names = " TEMA";
       
       
       handle[12] = iVIDyA(symbol, timeframe, 9, 12, 0, PRICE_OPEN);
       buffers[12].names = " ViDyA";
       
//--- Oscillators
      
      handle[13] = iATR(symbol, timeframe, 14);
      buffers[13].names = " ATR";
      
      handle[14] = iBearsPower(symbol, timeframe, 13);
      buffers[14].names = " BearsPower";
      
      handle[15] = iBullsPower(symbol, timeframe, 13);
      buffers[15].names = " BullsPower";
      
      handle[16] = iChaikin(symbol, timeframe, 3, 10, MODE_EMA, VOLUME_TICK);
      buffers[16].names = " Chainkin";
      
      handle[17] = iCCI(symbol, timeframe, 14, PRICE_OPEN);
      buffers[17].names = " CCI"; 
      
      handle[18] = iDeMarker(symbol, timeframe, 14);
      buffers[18].names = " Demarker";
      
      handle[19] = iForce(symbol, timeframe, 13, MODE_SMA, VOLUME_TICK);
      buffers[19].names = " Force";
      
      handle[20] = iMACD(symbol, timeframe, 12, 26, 9, PRICE_OPEN);
      buffers[20].names = " MACD-MAIN_LINE, MACD-SIGNAL_LINE";
      
      handle[21] = iMomentum(symbol, timeframe, 14, PRICE_OPEN);
      buffers[21].names = " Momentum";
      
      handle[22] = iOsMA(symbol, timeframe, 12, 26, 9, PRICE_OPEN);
      buffers[22].names = " OsMA";
      
      handle[23] = iRSI(symbol, timeframe, 14, PRICE_OPEN);
      buffers[23].names = " RSI";
      
      handle[24] = iRVI(symbol, timeframe, 10);
      buffers[24].names = " RVI-MAIN_LINE, RVI-SIGNAL_LINE";
      
      handle[25] = iStochastic(symbol, timeframe, 5, 3,3,MODE_SMA,STO_LOWHIGH);
      buffers[25].names = " Stochastic-MAIN_LINE, Stochastic-SIGNAL_LINE";
      
      handle[26] = iTriX(symbol, timeframe, 14, PRICE_OPEN);
      buffers[26].names = " TEMA";
      
      handle[27] = iWPR(symbol, timeframe, 14);
      buffers[27].names = " WPR";
      
   
//--- Volumes
   
      handle[28] = iAD(symbol, timeframe, VOLUME_TICK);
      buffers[28].names = " AD";
      
      handle[29] = iMFI(symbol, timeframe, 14, VOLUME_TICK);
      buffers[29].names = " MFI";
      
      handle[30] = iOBV(symbol, timeframe, VOLUME_TICK);
      buffers[30].names = " OBV";
      
      handle[31] = iVolumes(symbol, timeframe, VOLUME_TICK);
      buffers[31].names = " Tick-Volumes";
      
   
//--- Bill williams;
      
      handle[32] = iAC(symbol, timeframe);
      buffers[32].names = " AC";
      
      handle[33] = iAlligator(symbol, timeframe, 13, 8,8,5,5,3, MODE_SMMA, PRICE_OPEN);
      buffers[33].names = " Alligator-GATORJAW_LINE, Alligator-GATORTEETH_LINE, Alligator-GATORLIPS_LINE";
      
      handle[34] = iAO(symbol, timeframe);
      buffers[34].names = " AO";
      
      handle[35] = iFractals(symbol, timeframe);
      buffers[35].names = " Fractals-UPPER_LINE, Fractals-LOWER_LINE";
      
      handle[36] = iGator(symbol, timeframe,13,8,8,5,5,3, MODE_SMMA, PRICE_OPEN);
      buffers[36].names = " Gator-UPPER_HISTOGRAM, Gator-LOWER_HISTOGRAM";
      
      handle[37] = iBWMFI(symbol, timeframe, VOLUME_TICK);
      buffers[37].names = " BWMFI";
      
      Print("Indicators total =",ArraySize(handle));
   }
   
   matrix GetAllBuffers(string &buffer_names, int start, int count)
    {
      matrix data = {};
      buffer_info indicator_info;
      
      for (int i=0; i<ArraySize(buffers); i++)
        {
          indicator_info = buffers[i]._CopyRates(handle[i],buffers[i].names, start, count);
          data = concatenate(data, indicator_info.values, 1); 
          
          buffer_names+= (buffers[i].names + (i==ArraySize(buffers)-1 ? "":","));
        }       
      return data;
    }
};

input ENUM_TIMEFRAMES tf = PERIOD_CURRENT; //timeframe

Indicators indicators(Symbol(), tf);
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   
   string names;
   matrix data = indicators.GetAllBuffers(names, 0, buffer_size);   
   
   WriteCsv("AllIndicators.csv",data,names);
   
//   string namesArr[]; 
//   GetNames(names, namesArr);
//   
//   printf("Data[%dx%d] names size = %d",data.Rows(), data.Cols(), ArraySize(namesArr));
//   ArrayPrint(namesArr);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*
int GetNames(string names, string &NamesArr[])
{
 ushort sep = StringGetCharacter(",", 0);
 return StringSplit(names,sep,NamesArr);
} */
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

template <typename T>
bool WriteCsv(string csv_name, matrix<T> &matrix_, string header_string, bool common=false, int digits=5)
  {
   FileDelete(csv_name);
   int handle = FileOpen(csv_name,FILE_WRITE|FILE_CSV|FILE_ANSI|(common?FILE_COMMON:FILE_ANSI),",",CP_UTF8);


   if(handle == INVALID_HANDLE)
     {
       printf("Invalid %s handle Error %d ",csv_name,GetLastError());
       return (false);
     }
            
   string concstring;
   vector<T> row = {};
   
   datetime time_start = GetTickCount(), current_time;
   
   string header[];
   
   ushort u_sep;
   u_sep = StringGetCharacter(",",0);
   StringSplit(header_string,u_sep, header);
   
   vector<T> colsinrows = matrix_.Row(0);
   
   if (ArraySize(header) != (int)colsinrows.Size())
      {
         printf("headers=%d and columns=%d from the matrix vary is size ",ArraySize(header),colsinrows.Size());
         return false;
      }

//---

   string header_str = "";
   for (int i=0; i<ArraySize(header); i++)
      header_str += header[i] + (i+1 == colsinrows.Size() ? "" : ",");
   
   FileWrite(handle,header_str);
   
   FileSeek(handle,0,SEEK_SET);
   
   for(ulong i=0; i<matrix_.Rows() && !IsStopped(); i++)
     {
      ZeroMemory(concstring);

      row = matrix_.Row(i);
      for(ulong j=0, cols =1; j<row.Size() && !IsStopped(); j++, cols++)
        {
         current_time = GetTickCount();
         
         concstring += (string)NormalizeDouble(row[j],digits) + (cols == matrix_.Cols() ? "" : ",");
        }

      FileSeek(handle,0,SEEK_END);
      FileWrite(handle,concstring);
     }
        
   FileClose(handle);
   
   return (true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
matrix concatenate(matrix &mat1, matrix &mat2, int axis = 0)
 {
     matrix m_out = {};

     if ((axis == 0 && mat1.Cols() != mat2.Cols() && mat1.Cols()>0) || (axis == 1 && mat1.Rows() != mat2.Rows() && mat1.Rows()>0)) 
       {
         Print(__FUNCTION__, "Err | Dimensions mismatch for concatenation");
         return m_out;
       }

     if (axis == 0) {
         m_out.Resize(mat1.Rows() + mat2.Rows(), MathMax(mat1.Cols(), mat2.Cols()));

         for (ulong row = 0; row < mat1.Rows(); row++) {
             for (ulong col = 0; col < m_out.Cols(); col++) {
                 m_out[row][col] = mat1[row][col];
             }
         }

         for (ulong row = 0; row < mat2.Rows(); row++) {
             for (ulong col = 0; col < m_out.Cols(); col++) {
                 m_out[row + mat1.Rows()][col] = mat2[row][col];
             }
         }
     } else if (axis == 1) {
         m_out.Resize(MathMax(mat1.Rows(), mat2.Rows()), mat1.Cols() + mat2.Cols());

         for (ulong row = 0; row < m_out.Rows(); row++) {
             for (ulong col = 0; col < mat1.Cols(); col++) {
                 m_out[row][col] = mat1[row][col];
             }

             for (ulong col = 0; col < mat2.Cols(); col++) {
                 m_out[row][col + mat1.Cols()] = mat2[row][col];
             }
         }
     }
   return m_out;
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
