//+------------------------------------------------------------------+
//|                                                  gpt_trade.mq5   |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//| Expert Advisor using Neural Network predictions                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//--- input parameters
sinput string          Model = "gpt_norm_v3.net";       // Neural network model file
sinput int             BarsToPattern = 60;              // Number of bars for pattern
sinput bool            Common = true;                   // Use Common folder for network
input ENUM_TIMEFRAMES  TimeFrame = PERIOD_M5;           // Timeframe to trade on
input double           TradeLevel = 0.75;               // Decision threshold for opening trades
input double           Lot = 0.1;                       // Lot size
input int              MaxTP = 50;                      // Maximum Take Profit in points
input double           ProfitMultiply = 0.8;            // Factor to adjust the Take Profit
input int              MinTarget = 45;                  // Minimum Target for profit
input int              StopLoss = 500;                  // Stop Loss in points
sinput bool            UseOpenCL = false;               // Use OpenCL for neural network
//+------------------------------------------------------------------+
#include <NeuroNetworksBook\realization\neuronnet.mqh>
#include <Trade\Trade.mqh>

CNet *net;
CTrade *trade;
datetime lastbar = 0;
int h_EMA50, h_EMA200, h_RSI, h_MACD, h_ATR;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   // Load neural network
   if(!(net = new CNet()))
     {
      PrintFormat("Error creating Net: %d", GetLastError());
      return INIT_FAILED;
     }
   if(!net.Load(Model, Common))
     {
      PrintFormat("Error loading model %s: %d", Model, GetLastError());
      return INIT_FAILED;
     }
   net.UseOpenCL(UseOpenCL);
   
   // Initialize indicators
   h_EMA50 = iMA(_Symbol, TimeFrame, 50, 0, MODE_EMA, PRICE_CLOSE);
   h_EMA200 = iMA(_Symbol, TimeFrame, 200, 0, MODE_EMA, PRICE_CLOSE);
   h_RSI = iRSI(_Symbol, TimeFrame, 14, PRICE_CLOSE);
   h_MACD = iMACD(_Symbol, TimeFrame, 12, 26, 9, PRICE_CLOSE);
   h_ATR = iATR(_Symbol, TimeFrame, 14);
   
   if(h_EMA50 == INVALID_HANDLE || h_EMA200 == INVALID_HANDLE || h_RSI == INVALID_HANDLE || 
      h_MACD == INVALID_HANDLE || h_ATR == INVALID_HANDLE)
     {
      Print("Error loading indicators.");
      return INIT_FAILED;
     }
   
   // Initialize trading functions
   if(!(trade = new CTrade()))
     {
      PrintFormat("Error creating CTrade: %d", GetLastError());
      return INIT_FAILED;
     }
   if(!trade.SetTypeFillingBySymbol(_Symbol))
      return INIT_FAILED;
   
   lastbar = TimeCurrent();
   return INIT_SUCCEEDED;
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(!!net) delete net;
   if(!!trade) delete trade;
   IndicatorRelease(h_EMA50);
   IndicatorRelease(h_EMA200);
   IndicatorRelease(h_RSI);
   IndicatorRelease(h_MACD);
   IndicatorRelease(h_ATR);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   // Prevent reprocessing the same bar
   if(lastbar >= iTime(_Symbol, TimeFrame, 0))
      return;
   lastbar = iTime(_Symbol, TimeFrame, 0);

   // Prepare data for neural network
   double ema50[], ema200[], rsi[], macd_main[], macd_signal[], atr[];
   
   if(CopyBuffer(h_EMA50, 0, 1, BarsToPattern, ema50) <= 0 ||
      CopyBuffer(h_EMA200, 0, 1, BarsToPattern, ema200) <= 0 ||
      CopyBuffer(h_RSI, 0, 1, BarsToPattern, rsi) <= 0 ||
      CopyBuffer(h_MACD, MAIN_LINE, 1, BarsToPattern, macd_main) <= 0 ||
      CopyBuffer(h_MACD, SIGNAL_LINE, 1, BarsToPattern, macd_signal) <= 0 ||
      CopyBuffer(h_ATR, 0, 1, BarsToPattern, atr) <= 0)
     {
      Print("Error loading indicator data.");
      return;
     }

   // Initialize input data for the network
   CBufferType *input_data = new CBufferType();
   if(!input_data || !input_data.BufferInit(1, BarsToPattern * 5))
      return;
   
   // Normalize and update input data with all indicators
   for(int i = 0; i < BarsToPattern; i++)
     {
      input_data.Update(i * 5, 0, (TYPE)ema50[i]);
      input_data.Update(i * 5 + 1, (TYPE)ema200[i]);
      input_data.Update(i * 5 + 2, (TYPE)rsi[i]);
      input_data.Update(i * 5 + 3, (TYPE)macd_main[i]);
      input_data.Update(i * 5 + 4, (TYPE)(macd_main[i] - macd_signal[i]));
     }
   
   if(!input_data.Reshape(1, input_data.Total()))
      return;

   // Feed data into the network
   if(!net || !net.FeedForward(input_data))
     {
      Print("Error in Feed Forward.");
      delete input_data;
      return;
     }

   // Get prediction results
   if(!net.GetResults(input_data))
     {
      Print("Error getting network results.");
      delete input_data;
      return;
     }

   // Trading logic based on network output
   ExecuteTrades(input_data);
   delete input_data;
  }
//+------------------------------------------------------------------+
//| Execute trades based on predictions                              |
//+------------------------------------------------------------------+
void ExecuteTrades(CBufferType *input_data)
  {
   double prediction = input_data.At(0); // First result from network
   double target = input_data.At(1);     // Target for profit/loss
   
   // Buy trade logic
   if(prediction > TradeLevel)
     {
      if(IsPositionOpened(POSITION_TYPE_BUY))
         return;
      if(target < MinTarget * SymbolInfoDouble(_Symbol, SYMBOL_POINT))
         return;

      double tp = SymbolInfoDouble(_Symbol, SYMBOL_BID) + fmin(target * ProfitMultiply, MaxTP * SymbolInfoDouble(_Symbol, SYMBOL_POINT));
      double sl = SymbolInfoDouble(_Symbol, SYMBOL_BID) - StopLoss * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      trade.Buy(Lot, _Symbol, 0, sl, tp);
     }
   
   // Sell trade logic
   if(prediction < -TradeLevel)
     {
      if(IsPositionOpened(POSITION_TYPE_SELL))
         return;
      if(target > -(MinTarget * SymbolInfoDouble(_Symbol, SYMBOL_POINT)))
         return;

      double tp = SymbolInfoDouble(_Symbol, SYMBOL_BID) + fmax(target * ProfitMultiply, -MaxTP * SymbolInfoDouble(_Symbol, SYMBOL_POINT));
      double sl = SymbolInfoDouble(_Symbol, SYMBOL_BID) + StopLoss * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      trade.Sell(Lot, _Symbol, 0, sl, tp);
     }
  }
//+------------------------------------------------------------------+
//| Check if a position is opened                                    |
//+------------------------------------------------------------------+
bool IsPositionOpened(ENUM_POSITION_TYPE type)
  {
   for(int i = 0; i < PositionsTotal(); i++)
     {
      if(PositionGetSymbol(i) == _Symbol && PositionGetInteger(POSITION_TYPE) == type)
         return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
