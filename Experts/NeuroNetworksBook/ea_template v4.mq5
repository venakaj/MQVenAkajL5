//+------------------------------------------------------------------+
//|                                                  ea_template.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//| Example of Expert Advisor to use with neural network models      |
//| from book "Neural Networks for algorithmic trading in MQL5"      |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//--- input parameters
sinput string          Model = "gpt_not_norm_v4.net";
sinput int             BarsToPattern = 5;
sinput bool            Common = true;
input ENUM_TIMEFRAMES  TimeFrame = PERIOD_M5;
input double           TradeLevel = 0.78;
input double           Lot = 4;
input int              MaxTP = 900;
input double           ProfitMultiply = 0.8;
input int              MinTarget = 45;
input int              StopLoss = 130;
sinput bool            UseOpenCL = false;
input double BreakEvenPoints = 42; // Distance en points avant de déplacer le SL à BE
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
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   // Appel de la fonction de Break Even
   //MoveToBreakEven();
   
   if(lastbar >= iTime(_Symbol, TimeFrame, 0))
      return;
   lastbar = iTime(_Symbol, TimeFrame, 0);
//---
   double macd_main[], macd_signal[], rsi[];
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
   CBufferType *input_data = new CBufferType();
   if(!input_data)
     {
      PrintFormat("Error of create Input data array: %d", GetLastError());
      return;
     }
   if(!input_data.BufferInit(BarsToPattern, 4, 0))
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
   if(input_data.At(0) > 0.0)
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
      double tp = SymbolInfoDouble(_Symbol, SYMBOL_BID) + MathMin(input_data.At(1) * ProfitMultiply, MaxTP * SymbolInfoDouble(_Symbol, SYMBOL_POINT));
      double sl = SymbolInfoDouble(_Symbol, SYMBOL_BID) - StopLoss * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      trade.Buy(Lot, _Symbol, 0, sl, tp);
     }
   if(input_data.At(0) < 0)
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
      double tp = SymbolInfoDouble(_Symbol, SYMBOL_BID) + MathMax(input_data.At(1) * ProfitMultiply, -MaxTP * SymbolInfoDouble(_Symbol, SYMBOL_POINT));
      double sl = SymbolInfoDouble(_Symbol, SYMBOL_BID) + StopLoss * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      trade.Sell(Lot, _Symbol, 0, sl, tp);
     }
   delete input_data;
   
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void MoveToBreakEven()
{
   for(int i = 0; i < PositionsTotal(); i++)
   {
      if(PositionGetSymbol(i) != _Symbol)
         continue;

      double entry_price = PositionGetDouble(POSITION_PRICE_OPEN);
      double current_price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double stop_loss = PositionGetDouble(POSITION_SL);
      ulong ticket = PositionGetTicket(i);

      // Vérifier si la position est BUY et gagnante
      if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
      {
         if((current_price - entry_price) >= (BreakEvenPoints * SymbolInfoDouble(_Symbol, SYMBOL_POINT)) && stop_loss < entry_price)
         {
            trade.PositionModify(ticket, entry_price, PositionGetDouble(POSITION_TP));
            Print("Stop Loss déplacé au Break Even pour la position BUY.");
         }
      }
      // Vérifier si la position est SELL et gagnante
      else if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
      {
         if((entry_price - current_price) >= (BreakEvenPoints * SymbolInfoDouble(_Symbol, SYMBOL_POINT)) && stop_loss > entry_price)
         {
            trade.PositionModify(ticket, entry_price, PositionGetDouble(POSITION_TP));
            Print("Stop Loss déplacé au Break Even pour la position SELL.");
         }
      }
   }
}


