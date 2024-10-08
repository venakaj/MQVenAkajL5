//+------------------------------------------------------------------+
//|                                          Create_Initial_Data.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                https://www.mql5.com/en/users/dng |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com/en/users/dng"
#property version   "1.08"
#property script_show_inputs
//+------------------------------------------------------------------+
//| External parameters for script operation                         |
//+------------------------------------------------------------------+
input datetime Start = D'2017.04.17 00:00:00';           // Start of the population period
input datetime End = D'2023.12.31 23:59:00';             // End of the population period
input ENUM_TIMEFRAMES TimeFrame = PERIOD_M5;             // Timeframe for loading data
input int      BarsToLine = 60;                          // Number of historical bars in one pattern
input int      MaxBarsToLine = 60;                      // Maximum number of historical bars in one pattern
input string   StudyFileName = "study_data.csv";         // File name to write the training dataset
input string   TestFileName  = "test_data.csv";          // File name to write the testing dataset
input string   OutputDirectory = "";        // Directory for output files
input bool     NormalizeData = true;                     // Data normalization flag
input bool     UseMinMaxNormalization = true;            // Min-Max normalization flag
input double   TestSetPercentage = 0.2;                  // Percentage of data to be used for testing
input int      KFold = 5;                                // Number of folds for cross-validation
input bool     UseCrossValidation = false;               // Flag to use k-fold cross-validation
input bool     FeatureSelection = false;                 // Flag to enable feature selection
input int      LogLevel = 1;                             // Log level (0=No logs, 1=Info, 2=Debug)
input bool     DataAugmentation = false;                 // Flag to enable data augmentation
//+------------------------------------------------------------------+
//| Script program start                                             |
//+------------------------------------------------------------------+
void OnStart(void)
  {
   // Log initialization
   if(LogLevel >= 1)
      Print("Script execution started.");
   double startTime = GetTickCount();
   
   // Set output file paths
   string studyFilePath = OutputDirectory + StudyFileName;
   string testFilePath = OutputDirectory + TestFileName;

   // Load indicators
   int h_EMA50 = iMA(_Symbol, TimeFrame, 50, 0, MODE_EMA, PRICE_CLOSE);
   int h_EMA200 = iMA(_Symbol, TimeFrame, 200, 0, MODE_EMA, PRICE_CLOSE);
   int h_RSI = iRSI(_Symbol, TimeFrame, 14, PRICE_CLOSE);
   int h_MACD = iMACD(_Symbol, TimeFrame, 12, 26, 9, PRICE_CLOSE);
   int h_BBands = iBands(_Symbol, TimeFrame, 20, 2.0, 0, PRICE_CLOSE);
   int h_ATR = iATR(_Symbol, TimeFrame, 14);

   if(h_EMA50 == INVALID_HANDLE || h_EMA200 == INVALID_HANDLE || h_RSI == INVALID_HANDLE || 
      h_MACD == INVALID_HANDLE || h_BBands == INVALID_HANDLE || h_ATR == INVALID_HANDLE)
   {
      Print("Error: One or more indicators failed to load.");
      return;
   }
   
   // Load close prices
   double close[];
   if(CopyClose(_Symbol, TimeFrame, Start, End, close) <= 0)
     {
      Print("Error: Failed to load close prices.");
      return;
     }
   
   // Load indicator data into dynamic arrays
   double ema50[], ema200[], rsi[], macd_main[], macd_signal[], bb_upper[], bb_lower[], atr[];
   
   if(CopyBuffer(h_EMA50, 0, Start, End, ema50) <= 0 ||
      CopyBuffer(h_EMA200, 0, Start, End, ema200) <= 0 ||
      CopyBuffer(h_RSI, 0, Start, End, rsi) <= 0 ||
      CopyBuffer(h_MACD, MAIN_LINE, Start, End, macd_main) <= 0 ||
      CopyBuffer(h_MACD, SIGNAL_LINE, Start, End, macd_signal) <= 0 ||
      CopyBuffer(h_BBands, 0, Start, End, bb_upper) <= 0 ||
      CopyBuffer(h_BBands, 1, Start, End, bb_lower) <= 0 ||
      CopyBuffer(h_ATR, 0, Start, End, atr) <= 0)
   {
      Print("Error: Failed to load indicator data.");
      return;
   }
   
   int total = ArraySize(close);
   double target1[], target2[], macd_delta[], test[];
   
   if(ArrayResize(target1, total) <= 0 || ArrayResize(target2, total) <= 0 ||
      ArrayResize(test, total) <= 0 || ArrayResize(macd_delta, total) <= 0)
     {
      Print("Error: Failed to resize arrays.");
      return;
     }
   
   // Calculate MACD delta
   for(int i = 0; i < total; i++)
   {
      macd_delta[i] = macd_main[i] - macd_signal[i];
   }

   // Data normalization
   if(NormalizeData)
   {
      if(UseMinMaxNormalization)
      {
         NormalizeIndicatorDataMinMax(ema50, ema200, rsi, macd_main, macd_signal, macd_delta, bb_upper, bb_lower, atr);
      }
      else
      {
         NormalizeIndicatorDataZScore(ema50, ema200, rsi, macd_main, macd_signal, macd_delta, bb_upper, bb_lower, atr);
      }
   }
   
   // Stratified random selection for the test dataset
   int for_test = (int)((total - BarsToLine) * TestSetPercentage);
   GenerateTestSetIndexes(for_test, BarsToLine, total, test);
   
   // Open the training dataset file for writing
   int Study = FileOpen(studyFilePath, FILE_WRITE | FILE_CSV | FILE_ANSI, ",", CP_UTF8);
   if(Study == INVALID_HANDLE)
     {
      PrintFormat("Error opening file %s: %d", studyFilePath, GetLastError());
      return;
     }
   
   // Open the testing dataset file for writing
   int Test = FileOpen(testFilePath, FILE_WRITE | FILE_CSV | FILE_ANSI, ",", CP_UTF8);
   if(Test == INVALID_HANDLE)
     {
      PrintFormat("Error opening file %s: %d", testFilePath, GetLastError());
      return;
     }
   
   // Write datasets to files
   for(int i = BarsToLine - 1; i < total; i++)
   {
      Comment(StringFormat("%.2f%%", i * 100.0 / (double)(total - BarsToLine)));
      if(!WriteData(target1, target2, ema50, ema200, rsi, macd_main, macd_signal, macd_delta, bb_upper, bb_lower, atr, i, BarsToLine, (test[i] == 1 ? Test : Study)))
      {
         PrintFormat("Error writing data at index %d: %d", i, GetLastError());
         break;
      }
   }
   
   // Close files and cleanup
   Comment("");
   FileFlush(Study);
   FileClose(Study);
   FileFlush(Test);
   FileClose(Test);
   
   double endTime = GetTickCount();
   if(LogLevel >= 1)
   {
      PrintFormat("Study data saved to file %s", studyFilePath);
      PrintFormat("Test data saved to file %s", testFilePath);
      PrintFormat("Script execution completed in %.2f seconds.", (endTime - startTime) / 1000.0);
   }
  }
//+------------------------------------------------------------------+
//| Normalize indicator data using Min-Max method                    |
//+------------------------------------------------------------------+
void NormalizeIndicatorDataMinMax(double &ema50[], double &ema200[], double &rsi[], double &macd_main[], double &macd_signal[], double &macd_delta[], double &bb_upper[], double &bb_lower[], double &atr[])
{
   double max_ema50 = ArrayMaximum(ema50, WHOLE_ARRAY, 0);
   double min_ema50 = ArrayMinimum(ema50, WHOLE_ARRAY, 0);
   
   double max_ema200 = ArrayMaximum(ema200, WHOLE_ARRAY, 0);
   double min_ema200 = ArrayMinimum(ema200, WHOLE_ARRAY, 0);

   double max_rsi = ArrayMaximum(rsi, WHOLE_ARRAY, 0);
   double min_rsi = ArrayMinimum(rsi, WHOLE_ARRAY, 0);
   
   double max_macd_main = ArrayMaximum(macd_main, WHOLE_ARRAY, 0);
   double min_macd_main = ArrayMinimum(macd_main, WHOLE_ARRAY, 0);
   
      double max_macd_signal = ArrayMaximum(macd_signal, WHOLE_ARRAY, 0);
   double min_macd_signal = ArrayMinimum(macd_signal, WHOLE_ARRAY, 0);

   double max_macd_delta = ArrayMaximum(macd_delta, WHOLE_ARRAY, 0);
   double min_macd_delta = ArrayMinimum(macd_delta, WHOLE_ARRAY, 0);

   double max_bb_upper = ArrayMaximum(bb_upper, WHOLE_ARRAY, 0);
   double min_bb_upper = ArrayMinimum(bb_upper, WHOLE_ARRAY, 0);

   double max_bb_lower = ArrayMaximum(bb_lower, WHOLE_ARRAY, 0);
   double min_bb_lower = ArrayMinimum(bb_lower, WHOLE_ARRAY, 0);

   double max_atr = ArrayMaximum(atr, WHOLE_ARRAY, 0);
   double min_atr = ArrayMinimum(atr, WHOLE_ARRAY, 0);

   // Trouver la taille minimale parmi tous les tableaux
   int minSize = ArraySize(ema50); // Initialisez avec la taille d'un des tableaux
   minSize = MathMin(minSize, ArraySize(ema200));
   minSize = MathMin(minSize, ArraySize(rsi));
   minSize = MathMin(minSize, ArraySize(macd_main));
   minSize = MathMin(minSize, ArraySize(macd_signal));
   minSize = MathMin(minSize, ArraySize(macd_delta));
   minSize = MathMin(minSize, ArraySize(bb_upper));
   minSize = MathMin(minSize, ArraySize(bb_lower));
   minSize = MathMin(minSize, ArraySize(atr));

   for(int i = 0; i < minSize; i++)
   {
      if(max_ema50 != min_ema50) ema50[i] = (ema50[i] - min_ema50) / (max_ema50 - min_ema50);
      if(max_ema200 != min_ema200) ema200[i] = (ema200[i] - min_ema200) / (max_ema200 - min_ema200);
      if(max_rsi != min_rsi) rsi[i] = (rsi[i] - min_rsi) / (max_rsi - min_rsi);
      if(max_macd_main != min_macd_main) macd_main[i] = (macd_main[i] - min_macd_main) / (max_macd_main - min_macd_main);
      if(max_macd_signal != min_macd_signal) macd_signal[i] = (macd_signal[i] - min_macd_signal) / (max_macd_signal - min_macd_signal);
      if(max_macd_delta != min_macd_delta) macd_delta[i] = (macd_delta[i] - min_macd_delta) / (max_macd_delta - min_macd_delta);
      if(max_bb_upper != min_bb_upper) bb_upper[i] = (bb_upper[i] - min_bb_upper) / (max_bb_upper - min_bb_upper);
      if(max_bb_lower != min_bb_lower) bb_lower[i] = (bb_lower[i] - min_bb_lower) / (max_bb_lower - min_bb_lower);
      if(max_atr != min_atr) atr[i] = (atr[i] - min_atr) / (max_atr - min_atr);
   }
}
//+------------------------------------------------------------------+
//| Normalize indicator data using Z-Score method                    |
//+------------------------------------------------------------------+
void NormalizeIndicatorDataZScore(double &ema50[], double &ema200[], double &rsi[], double &macd_main[], double &macd_signal[], double &macd_delta[], double &bb_upper[], double &bb_lower[], double &atr[])
{
   double mean_ema50 = ArrayMean(ema50);
   double std_ema50 = ArrayStandardDeviation(ema50, mean_ema50);
   
   double mean_ema200 = ArrayMean(ema200);
   double std_ema200 = ArrayStandardDeviation(ema200, mean_ema200);

   double mean_rsi = ArrayMean(rsi);
   double std_rsi = ArrayStandardDeviation(rsi, mean_rsi);
   
   double mean_macd_main = ArrayMean(macd_main);
   double std_macd_main = ArrayStandardDeviation(macd_main, mean_macd_main);
   
   double mean_macd_signal = ArrayMean(macd_signal);
   double std_macd_signal = ArrayStandardDeviation(macd_signal, mean_macd_signal);
   
   double mean_macd_delta = ArrayMean(macd_delta);
   double std_macd_delta = ArrayStandardDeviation(macd_delta, mean_macd_delta);
   
   double mean_bb_upper = ArrayMean(bb_upper);
   double std_bb_upper = ArrayStandardDeviation(bb_upper, mean_bb_upper);
   
   double mean_bb_lower = ArrayMean(bb_lower);
   double std_bb_lower = ArrayStandardDeviation(bb_lower, mean_bb_lower);
   
   double mean_atr = ArrayMean(atr);
   double std_atr = ArrayStandardDeviation(atr, mean_atr);

   // Trouver la taille minimale parmi tous les tableaux
   int minSize = ArraySize(ema50);
   minSize = MathMin(minSize, ArraySize(ema200));
   minSize = MathMin(minSize, ArraySize(rsi));
   minSize = MathMin(minSize, ArraySize(macd_main));
   minSize = MathMin(minSize, ArraySize(macd_signal));
   minSize = MathMin(minSize, ArraySize(macd_delta));
   minSize = MathMin(minSize, ArraySize(bb_upper));
   minSize = MathMin(minSize, ArraySize(bb_lower));
   minSize = MathMin(minSize, ArraySize(atr));

   // Boucle sur la taille minimale pour éviter l'erreur "array out of range"
   for(int i = 0; i < minSize; i++)
   {
      if(std_ema50 != 0) ema50[i] = (ema50[i] - mean_ema50) / std_ema50;
      if(std_ema200 != 0) ema200[i] = (ema200[i] - mean_ema200) / std_ema200;
      if(std_rsi != 0) rsi[i] = (rsi[i] - mean_rsi) / std_rsi;
      if(std_macd_main != 0) macd_main[i] = (macd_main[i] - mean_macd_main) / std_macd_main;
      if(std_macd_signal != 0) macd_signal[i] = (macd_signal[i] - mean_macd_signal) / std_macd_signal;
      if(std_macd_delta != 0) macd_delta[i] = (macd_delta[i] - mean_macd_delta) / std_macd_delta;
      if(std_bb_upper != 0) bb_upper[i] = (bb_upper[i] - mean_bb_upper) / std_bb_upper;
      if(std_bb_lower != 0) bb_lower[i] = (bb_lower[i] - mean_bb_lower) / std_bb_lower;
      if(std_atr != 0) atr[i] = (atr[i] - mean_atr) / std_atr;
   }
}

//+------------------------------------------------------------------+
//| Generate stratified random indexes for the test set              |
//+------------------------------------------------------------------+
void GenerateTestSetIndexes(int for_test, int barsToLine, int total, double &test[])
{
   int count = 0;
   while(count < for_test)
   {
      int t = MathRand() % (total - barsToLine) + barsToLine;
      if(test[t] == 1)
         continue;
      test[t] = 1;
      count++;
   }
}
//+------------------------------------------------------------------+
//| Function for writing pattern to file                             |
//+------------------------------------------------------------------+
bool WriteData(double &target1[], double &target2[], double &ema50[], double &ema200[], double &rsi[], double &macd_main[], double &macd_signal[], double &macd_delta[], double &bb_upper[], double &bb_lower[], double &atr[], int cur_bar, int bars, int handle)
{
   if(handle == INVALID_HANDLE)
   {
      Print("Error: Invalid file handle.");
      return false;
   }
   
   int start = cur_bar - bars + 1;
   if(start < 0)
   {
      Print("Error: Current bar is too small.");
      return false;
   }
   
   string pattern = "";
   for(int i = start; i <= cur_bar; i++)
   {
      pattern += StringFormat("%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,", 
                              (i < ArraySize(ema50) ? ema50[i] : 0.0),
                              (i < ArraySize(ema200) ? ema200[i] : 0.0),
                              (i < ArraySize(rsi) ? rsi[i] : 0.0),
                              (i < ArraySize(macd_main) ? macd_main[i] : 0.0),
                              (i < ArraySize(macd_signal) ? macd_signal[i] : 0.0),
                              (i < ArraySize(macd_delta) ? macd_delta[i] : 0.0),
                              (i < ArraySize(bb_upper) ? bb_upper[i] : 0.0),
                              (i < ArraySize(bb_lower) ? bb_lower[i] : 0.0),
                              (i < ArraySize(atr) ? atr[i] : 0.0));
   }
      pattern += StringFormat("%.6f,%.6f", 
                           (cur_bar < ArraySize(target1) ? target1[cur_bar] : 0.0),
                           (cur_bar < ArraySize(target2) ? target2[cur_bar] : 0.0));
   
   if(FileWrite(handle, pattern) <= 0)
   {
      Print("Error: Failed to write to file.");
      return false;
   }
   return true;
}
//+------------------------------------------------------------------+
//| Helper functions for Array Mean and Standard Deviation           |
//+------------------------------------------------------------------+
double ArrayMean(double &array[])
{
   double sum = 0.0;
   int size = ArraySize(array);
   for(int i = 0; i < size; i++)
      sum += array[i];
   return sum / size;
}
//+------------------------------------------------------------------+
double ArrayStandardDeviation(double &array[], double mean)
{
   double sum = 0.0;
   int size = ArraySize(array);
   for(int i = 0; i < size; i++)
      sum += MathPow(array[i] - mean, 2);
   return MathSqrt(sum / size);
}
//+------------------------------------------------------------------+


