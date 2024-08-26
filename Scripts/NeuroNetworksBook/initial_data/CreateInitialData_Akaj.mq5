//+------------------------------------------------------------------+
//|                                          Create_Initial_Data.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                https://www.mql5.com/en/users/dng |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com/en/users/dng"
#property version   "1.07"
#property script_show_inputs
//+------------------------------------------------------------------+
//| External parameters for script operation                         |
//+------------------------------------------------------------------+
input datetime Start = D'2016.01.01 00:00:00';           // Start of the population period
input datetime End = D'2023.12.31 23:59:00';             // End of the population period
input ENUM_TIMEFRAMES TimeFrame = PERIOD_M5;             // Timeframe for loading data
input int      BarsToLine = 40;                          // Number of historical bars in one pattern
input int      MaxBarsToLine = 120;                      // Maximum number of historical bars in one pattern
input string   StudyFileName = "study_data.csv";         // File name to write the training dataset
input string   TestFileName  = "test_data.csv";          // File name to write the testing dataset
input string   OutputDirectory = "MQL5\\Files\\";        // Directory for output files
input bool     NormalizeData = true;                     // Data normalization flag
input bool     UseMinMaxNormalization = true;            // Min-Max normalization flag
input double   TestSetPercentage = 0.2;                  // Percentage of data to be used for testing
input int      KFold = 5;                                // Number of folds for cross-validation
input bool     UseCrossValidation = false;               // Flag to use k-fold cross-validation
input string   Indicators = "ZigZag,RSI,MACD";           // Comma-separated list of indicators to use
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

   // Load indicators based on the input list
   int h_ZZ = INVALID_HANDLE, h_RSI = INVALID_HANDLE, h_MACD = INVALID_HANDLE;
   string indicatorList[]; 
   int indicatorCount = StringSplit(Indicators, ',', indicatorList);

   for(int i = 0; i < indicatorCount; i++)
     {
      string indicatorName = TrimSpaces(indicatorList[i]);
      if(indicatorName == "ZigZag")
         h_ZZ = iCustom(_Symbol, TimeFrame, "Examples\\ZigZag.ex5", 12, 5, 3);
      else if(indicatorName == "RSI")
         h_RSI = iRSI(_Symbol, TimeFrame, 14, PRICE_TYPICAL);
      else if(indicatorName == "MACD")
         h_MACD = iMACD(_Symbol, TimeFrame, 12, 26, 9, PRICE_TYPICAL);
     }
   
   if(h_ZZ == INVALID_HANDLE && StringFind(Indicators, "ZigZag") >= 0)
     {
      Print("Error: ZigZag indicator failed to load.");
      return;
     }
   if(h_RSI == INVALID_HANDLE && StringFind(Indicators, "RSI") >= 0)
     {
      Print("Error: RSI indicator failed to load.");
      return;
     }
   if(h_MACD == INVALID_HANDLE && StringFind(Indicators, "MACD") >= 0)
     {
      Print("Error: MACD indicator failed to load.");
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
   double zz[], macd_main[], macd_signal[], rsi[];
   datetime end_zz = End + PeriodSeconds(TimeFrame) * 500;
   
   if(h_ZZ != INVALID_HANDLE && CopyBuffer(h_ZZ, 0, Start, end_zz, zz) <= 0)
     {
      Print("Error: Failed to load ZigZag data.");
      return;
     }
   if(h_RSI != INVALID_HANDLE && CopyBuffer(h_RSI, 0, Start, End, rsi) <= 0)
     {
      Print("Error: Failed to load RSI data.");
      return;
     }
   if(h_MACD != INVALID_HANDLE && (CopyBuffer(h_MACD, MAIN_LINE, Start, End, macd_main) <= 0 ||
      CopyBuffer(h_MACD, SIGNAL_LINE, Start, End, macd_signal) <= 0))
     {
      Print("Error: Failed to load MACD data.");
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
   
   // Calculate targets: direction and distance to the nearest extremum
   ArrayInitialize(test, 0);
   double extremum = -1;
   
   for(int i = ArraySize(zz) - 2; i >= 0; i--)
     {
      if(zz[i + 1] > 0 && zz[i + 1] != EMPTY_VALUE)
         extremum = zz[i + 1];
      if(i >= total)
         continue;
      target2[i] = extremum - close[i];
      target1[i] = (target2[i] >= 0 ? 1 : -1);
      macd_delta[i] = macd_main[i] - macd_signal[i];
     }
   
   // Data normalization
   if(NormalizeData)
     {
      if (UseMinMaxNormalization)
        NormalizeIndicatorDataMinMax(macd_main, macd_signal, macd_delta, rsi);
      else
        NormalizeIndicatorDataZScore(macd_main, macd_signal, macd_delta, rsi);
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
      if(!WriteData(target1, target2, rsi, macd_main, macd_signal, macd_delta, i, BarsToLine, (test[i] == 1 ? Test : Study)))
        {
         PrintFormat("Error writing data at index %d: %d", i, GetLastError());
         break;
        }
     }
   
   // Close files and cleanup
   FileFlush(Study);
   FileClose(Study);
   FileFlush(Test);
   FileClose(Test);
   
   double endTime = GetTickCount();
   if(LogLevel >= 1)
      PrintFormat("Study data saved to file %s", studyFilePath);
   if(LogLevel >= 1)
      PrintFormat("Test data saved to file %s", testFilePath);
   if(LogLevel >= 1)
      PrintFormat("Script execution completed in %.2f seconds.", (endTime - startTime) / 1000.0);
   Comment("");
  }
//+------------------------------------------------------------------+
//| Normalize indicator data using Min-Max method                    |
//+------------------------------------------------------------------+
void NormalizeIndicatorDataMinMax(double &macd_main[], double &macd_signal[], double &macd_delta[], double &rsi[])
  {
   double main_norm = MathMax(MathAbs(macd_main[ArrayMinimum(macd_main)]),
                              macd_main[ArrayMaximum(macd_main)]);
   double sign_norm = MathMax(MathAbs(macd_signal[ArrayMinimum(macd_signal)]),
                              macd_signal[ArrayMaximum(macd_signal)]);
   double delt_norm = MathMax(MathAbs(macd_delta[ArrayMinimum(macd_delta)]),
                              macd_delta[ArrayMaximum(macd_delta)]);
   for(int i = 0; i < ArraySize(macd_main); i++)
     {
      rsi[i] = (rsi[i] - 50.0) / 50.0;
      macd_main[i] /= main_norm;
      macd_signal[i] /= sign_norm;
      macd_delta[i] /= delt_norm;
     }
  }
//+------------------------------------------------------------------+
//| Normalize indicator data using Z-Score method                    |
//+------------------------------------------------------------------+
void NormalizeIndicatorDataZScore(double &macd_main[], double &macd_signal[], double &macd_delta[], double &rsi[])
  {
   double main_mean = ArrayMean(macd_main);
   double main_std = ArrayStandardDeviation(macd_main, main_mean);
   double signal_mean = ArrayMean(macd_signal);
   double signal_std = ArrayStandardDeviation(macd_signal, signal_mean);
   double delta_mean = ArrayMean(macd_delta);
   double delta_std = ArrayStandardDeviation(macd_delta, delta_mean);
   
   for(int i = 0; i < ArraySize(macd_main); i++)
     {
      rsi[i] = (rsi[i] - 50.0) / 50.0;
      macd_main[i] = (macd_main[i] - main_mean) / main_std;
      macd_signal[i] = (macd_signal[i] - signal_mean) / signal_std;
      macd_delta[i] = (macd_delta[i] - delta_mean) / delta_std;
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
bool WriteData(double &target1[], double &target2[], double &data1[], double &data2[], double &data3[], double &data4[], int cur_bar, int bars, int handle)
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
      pattern += StringFormat("%.6f,%.6f,%.6f,%.6f,", (i < ArraySize(data1) ? data1[i] : 0.0),
                              (i < ArraySize(data2) ? data2[i] : 0.0),
                              (i < ArraySize(data3) ? data3[i] : 0.0),
                              (i < ArraySize(data4) ? data4[i] : 0.0));
     }
   pattern += StringFormat("%.6f,%.6f", (cur_bar < ArraySize(target1) ? target1[cur_bar] : 0.0),
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
//| Trim spaces from both ends of a string                           |
//+------------------------------------------------------------------+
string TrimSpaces(string str)
  {
   int start = 0;
   int end = StringLen(str) - 1;

   // Find the first non-space character
   while(start <= end && StringSubstr(str, start, 1) == " ")
      start++;

   // Find the last non-space character
   while(end >= start && StringSubstr(str, end, 1) == " ")
      end--;

   return StringSubstr(str, start, end - start + 1);
}
//+------------------------------------------------------------------+
