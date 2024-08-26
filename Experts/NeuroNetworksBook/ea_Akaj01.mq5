//+------------------------------------------------------------------+
//|                                                  ea_template.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//| Improved Expert Advisor with enhanced trading logic               |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.01"
//--- input parameters
sinput string          Model = "gpt_not_norm.net";
sinput int             BarsToPattern = 5;
sinput bool            Common = true;
input ENUM_TIMEFRAMES  TimeFrame = PERIOD_M5;
input double           TradeLevel = 0.78;
input double           RiskPercent = 1.0;
input int              MaxTP = 50;
input double           ProfitMultiply = 0.8;
input int              MinTarget = 45;
input int              StopLoss = 500;
input int              TrailingStop = 20;
sinput bool            UseOpenCL = false;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <NeuroNetworksBook\realization\neuronnet.mqh>
#include <Trade\Trade.mqh>

CNet *net;
CTrade *trade;
datetime lastbar = 0;
int h_RSI;
int h_MACD;
int h_MA;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   if(!(net = new CNet()))
     {
      PrintFormat("Error of create Net: %d", GetLastError());
      return INIT_FAILED;
     }
   if(!net.Load(Model, Common))
     {
      PrintFormat("Error of load mode %s: %d", Model, GetLastError());
      return INIT_FAILED;
     }
   net.UseOpenCL(UseOpenCL);
//---
   h_RSI = iRSI(_Symbol, TimeFrame, 12, PRICE_TYPICAL);
   if(h_RSI == INVALID_HANDLE)
     {
      PrintFormat("Error of load indicator %s", "RSI");
      return INIT_FAILED;
     }
   h_MACD = iMACD(_Symbol, TimeFrame, 14, 30, 9, PRICE_TYPICAL);
   if(h_MACD == INVALID_HANDLE)
     {
      PrintFormat("Error of load indicator %s", "MACD");
      return INIT_FAILED;
     }
   h_MA = iMA(_Symbol, TimeFrame, 50, 0, MODE_SMA, PRICE_CLOSE);
   if(h_MA == INVALID_HANDLE)
     {
      PrintFormat("Error of load indicator %s", "MA");
      return INIT_FAILED;
     }
//---
   if(!(trade = new CTrade()))
     {
      PrintFormat("Error of create CTrade: %d", GetLastError());
      return INIT_FAILED;
     }
   if(!trade.SetTypeFillingBySymbol(_Symbol))
      return INIT_FAILED;
//---
   lastbar = TimeCurrent();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(!!net)
      delete net;
   if(!!trade)
      delete trade;
   IndicatorRelease(h_RSI);
   IndicatorRelease(h_MACD);
   IndicatorRelease(h_MA);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(lastbar >= iTime(_Symbol, TimeFrame, 0))
      return;
   lastbar = iTime(_Symbol, TimeFrame, 0);
//---
   double macd_main[], macd_signal[], rsi[], ma[];
   if(h_RSI == INVALID_HANDLE || CopyBuffer(h_RSI, 0, 1, BarsToPattern, rsi) <= 0)
     {
      PrintFormat("Error loading indicator %s data", "RSI");
      return;
     }
   if(h_MACD == INVALID_HANDLE || CopyBuffer(h_MACD, MAIN_LINE, 1, BarsToPattern, macd_main) <= 0 ||
      CopyBuffer(h_MACD, SIGNAL_LINE, 1, BarsToPattern, macd_signal) <= 0)
     {
      PrintFormat("Error loading indicator %s data", "MACD");
      return;
     }
   if(h_MA == INVALID_HANDLE || CopyBuffer(h_MA, 0, 1, BarsToPattern, ma) <= 0)
     {
      PrintFormat("Error loading indicator %s data", "MA");
      return;
     }
   CBufferType *input_data = new CBufferType();
   if(!input_data)
     {
      PrintFormat("Error of create Input data array: %d", GetLastError());
      return;
     }
   if(!input_data.BufferInit(BarsToPattern, 5, 0))
      return;
   for(int i = 0; i < BarsToPattern; i++)
     {
      if(!input_data.Update(i, 0, (TYPE)rsi[i]))
        {
         PrintFormat("Error of add Input data to array: %d", GetLastError());
         delete input_data;
         return;
        }
      if(!input_data.Update(i, 1, (TYPE)macd_main[i]))
        {
         PrintFormat("Error of add Input data to array: %d", GetLastError());
         delete input_data;
         return;
        }
      if(!input_data.Update(i, 2, (TYPE)macd_signal[i]))
        {
         PrintFormat("Error of add Input data to array: %d", GetLastError());
         delete input_data;
         return;
        }
      if(!input_data.Update(i, 3, (TYPE)(macd_main[i] - macd_signal[i])))
        {
         PrintFormat("Error of add Input data to array: %d", GetLastError());
         delete input_data;
         return;
        }
      if(!input_data.Update(i, 4, (TYPE)ma[i]))
        {
         PrintFormat("Error of add Input data to array: %d", GetLastError());
         delete input_data;
         return;
        }
     }
   if(!input_data.Reshape(1,input_data.Total()))
     return;
//---
   if(!net)
     {
      delete input_data;
      return;
     }
   if(!net.FeedForward(input_data))
     {
      PrintFormat("Error of Feed Forward: %d", GetLastError());
      delete input_data;
      return;
     }
   if(!net.GetResults(input_data))
     {
      PrintFormat("Error of Get Result: %d", GetLastError());
      delete input_data;
      return;
     }
   double calculated_lot = CalculateLotSize(RiskPercent, StopLoss);
   double current_price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ma_current = ma[0];

   if(input_data.At(0) > 0.0 && current_price > ma_current) // Achat uniquement si le prix est au-dessus de la MA
     {
      bool opened = false;
      for(int i = 0; i < PositionsTotal(); i++)
        {
         if(PositionGetSymbol(i) != _Symbol)
            continue;
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
            opened = true;
        }
      if(opened)
        {
         delete input_data;
         return;
        }
      if(input_data.At(0) < TradeLevel ||
         input_data.At(1) < (MinTarget * SymbolInfoDouble(_Symbol, SYMBOL_POINT)))
        {
         delete input_data;
         return;
        }
      double tp = current_price + MathMin(input_data.At(1) * ProfitMultiply, MaxTP * SymbolInfoDouble(_Symbol, SYMBOL_POINT));
      double sl = current_price - StopLoss * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      trade.Buy(calculated_lot, _Symbol, 0, sl, tp);
     }
   else if(input_data.At(0) < 0.0 && current_price < ma_current) // Vente uniquement si le prix est en dessous de la MA
     {
      bool opened = false;
      for(int i = 0; i < PositionsTotal(); i++)
        {
         if(PositionGetSymbol(i) != _Symbol)
            continue;
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
            opened = true;
        }
      if(opened)
        {
         delete input_data;
         return;
        }
      if(input_data.At(0) > -TradeLevel ||
         input_data.At(1) > -(MinTarget * SymbolInfoDouble(_Symbol, SYMBOL_POINT)))
        {
         delete input_data;
         return;
        }
      double tp = current_price - MathMin(input_data.At(1) * ProfitMultiply, MaxTP * SymbolInfoDouble(_Symbol, SYMBOL_POINT));
      double sl = current_price + StopLoss * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      trade.Sell(calculated_lot, _Symbol, 0, sl, tp);
     }
   delete input_data;
   ApplyTrailingStop();
  }
//+------------------------------------------------------------------+
//| Function to calculate lot size based on risk                     |
//+------------------------------------------------------------------+
double CalculateLotSize(double riskPercent, double stopLossPips)
  {
   double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskAmount = accountBalance * (riskPercent / 100.0);
   double stopLossValue = stopLossPips * SymbolInfoDouble(_Symbol, SYMBOL_POINT) * SymbolInfoDouble(_Symbol, SYMBOL_TRADE_CONTRACT_SIZE);
   return riskAmount / stopLossValue;
  }
//+------------------------------------------------------------------+
//| Function to apply trailing stop                                  |
//+------------------------------------------------------------------+
void ApplyTrailingStop()
  {
   for(int i = 0; i < PositionsTotal(); i++)
     {
      if(PositionGetSymbol(i) != _Symbol)
         continue;
      double positionType = PositionGetInteger(POSITION_TYPE);
      double priceCurrent = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double priceOpen = PositionGetDouble(POSITION_PRICE_OPEN);
      double slCurrent = PositionGetDouble(POSITION_SL);
      
      if(positionType == POSITION_TYPE_BUY)
        {
         double newSL = priceCurrent - TrailingStop * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
         if(newSL > slCurrent)
            trade.PositionModify(PositionGetInteger(POSITION_TICKET), newSL, PositionGetDouble(POSITION_TP));
        }
      else if(positionType == POSITION_TYPE_SELL)
        {
         double newSL = priceCurrent + TrailingStop * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
         if(newSL < slCurrent)
            trade.PositionModify(PositionGetInteger(POSITION_TICKET), newSL, PositionGetDouble(POSITION_TP));
        }
     }
  }
//+------------------------------------------------------------------+
