//+------------------------------------------------------------------+
//|                                                        Sekio.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>

enum ENUM_HOUR
  {
   Inactive=0,_0100=1,_0200=2,_0300=3,_0400=4,_0500=5,_0600=6,_0700=7,_0800=8,_0900=9,_1000=10,_1100=11,_1200=12,_1300=13,_1400=14,_1500=15,_1600=16,_1700=17,_1800=18,_1900=19,_2000=20,_2100=21,_2200=22,_2300=23,
  };
  

input group "=== Trading Inputs ==="
input double               RiskPercent          = 3;                 // Risk as % of trading Capital
input int                  TpPoints             = 200;               // Take Profit 
input int                  SlPoints             = 200;               // Stop Loss
input int                  TslTriggersPoints    = 15;                // Pointd in profit befor Trailling SL is activated
input int                  TslPoints            = 10;                // Trailing stop loss
input ENUM_TIMEFRAMES      Timeframe            = PERIOD_CURRENT;    // Time frame to run
input int                  InpMagic             = 59845;             // EA identification no
input string               TradeComment         = "Scalping Robot";
input ENUM_HOUR            SHInput              = 0;                 // Start hour
input ENUM_HOUR            EndInput             = 0;                 // End hour
input int                  BarsN                = 5;
input int                  ExpirationBars       = 100;
input int                  OrderDistPoints      = 100;
input int                  InpSpread            = 0;               // Si le spreed est négatif (spreed deactivi), Si egale zero ask-bid, si non c'est le spreed  en point.'
input bool                 EnableSpread         = false;  

int SHChoice;
int EHChoice;
double spread;

CTrade trade;
CPositionInfo pos;
COrderInfo ord;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   trade.SetExpertMagicNumber(InpMagic);
   ChartSetInteger(0,CHART_SHOW_GRID,false);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

   if(EnableSpread){   
      CalculSpread();
   }
   
   TrailStop();
   
   if(!IsNewBar())
     {
      return;
     }
     
     MqlDateTime time;
     TimeToStruct(TimeCurrent(),time);
     
     int Hournow = time.hour;
     
     SHChoice = SHInput;
     EHChoice = EndInput;
     
     if(Hournow<SHChoice)
       {
        CloseAllOrder();
        return;
       }
       
       if(Hournow>=EHChoice && EHChoice!=0)
         {
          CloseAllOrder();
        return;
         }
         
      int BuyTotal=0;
      int SellTotal=0;
      
      for(int i=PositionsTotal()-1;i>=0;i--)
        {
         pos.SelectByIndex(i);
         if(pos.PositionType()==POSITION_TYPE_BUY && pos.Symbol()==_Symbol && pos.Magic()==InpMagic)
           {
            BuyTotal++;
           }
            if(pos.PositionType()==POSITION_TYPE_SELL && pos.Symbol()==_Symbol && pos.Magic()==InpMagic)
           {
            SellTotal++;
           }
        }
        
        for(int i=OrdersTotal()-1;i>=0;i--)
        {
         ord.SelectByIndex(i);
         if(ord.OrderType()==ORDER_TYPE_BUY_STOP && ord.Symbol()==_Symbol && ord.Magic()==InpMagic)
           {
            BuyTotal++;
           }
            if(ord.OrderType()==ORDER_TYPE_SELL_STOP && ord.Symbol()==_Symbol && ord.Magic()==InpMagic)
           {
            SellTotal++;
           }
        }
        
        if(BuyTotal<=0)
          {
            double high = findHigh();
            if(high>0)
              {
               SendBuyOrder(high);
              }
          }
          
          if(SellTotal<=0)
          {
            double low = findLow();
            if(low>0)
              {
               SendSellOrder(low);
              }
          }
     
  }
//+------------------------------------------------------------------+

double findHigh(){
   double highestHigh = 0;
   for(int i=0;i<200;i++)
     {
      double high = iHigh(_Symbol,Timeframe,i);
      if(i>BarsN && iHighest(_Symbol,Timeframe,MODE_HIGH,BarsN*2+1,i-BarsN)==i)
        {
         if(high>highestHigh)
           {
            return high;
           }
        }
      highestHigh = MathMax(high,highestHigh);
     }
     return -1;
}

double findLow(){
   double lowestLow = DBL_MAX;
   for(int i=0;i<200;i++)
     {
      double low = iLow(_Symbol,Timeframe,i);
      if(i>BarsN && iLowest(_Symbol,Timeframe,MODE_LOW,BarsN*2+1,i-BarsN)==i)
        {
         if(low<lowestLow)
           {
            return low;
           }
        }
      lowestLow = MathMax(low,lowestLow);
     }
     return -1;
}

bool IsNewBar(){
   static datetime previousTime = 0;
   datetime currentTime = iTime(_Symbol,Timeframe,0);
   if(previousTime!=currentTime)
     {
      previousTime=currentTime;
      return true;
     }
     return false;
}

void SendBuyOrder(double entry){
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   ask = ask + spread;

   if(ask> entry-OrderDistPoints*_Point)
     {
      return;
     }
     
     double tp = entry+ TpPoints * _Point;
     double sl = entry- SlPoints * _Point;
     
     double lots = 0.01;
     if(RiskPercent>0)
       {
        lots = calcLots(entry-sl);
       }
       
       datetime expiration = iTime(_Symbol,Timeframe,0)+ExpirationBars*PeriodSeconds(Timeframe);
       trade.BuyStop(lots,entry,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,expiration);
}

void SendSellOrder(double entry){
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   bid = bid - spread;

   if(bid< entry+OrderDistPoints*_Point)
     {
      return;
     }
     
     double tp = entry- TpPoints * _Point;
     double sl = entry+ SlPoints * _Point;
     
     double lots = 0.01;
     if(RiskPercent>0)
       {
        lots = calcLots(sl-entry);
       }
       
       datetime expiration = iTime(_Symbol,Timeframe,0)+ExpirationBars*PeriodSeconds(Timeframe);
       trade.SellStop(lots,entry,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,expiration);
}


double calcLots(double slPoints){
   double risk = AccountInfoDouble(ACCOUNT_BALANCE) * RiskPercent / 100;
   
   double ticksize = SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   double tickvalue = SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
   double lotstep = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   double minvolume = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double maxvolume = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double volumeLimit = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_LIMIT);
   
   double moneyPerLotstep = slPoints / ticksize * tickvalue * lotstep;
   double lots = MathFloor(risk/moneyPerLotstep) * lotstep;
   
   if(volumeLimit!=0)
     {
      lots = MathMin(lots,volumeLimit);
     }
   if(maxvolume!=0)
     {
      lots = MathMin(lots,SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX));
     }
      if(minvolume!=0)
     {
      lots = MathMax(lots,SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN));
     }
     lots = NormalizeDouble(lots,2);
   return lots;
}

 void CloseAllOrder(){
      for(int i=OrdersTotal()-1;i>=0;i--)
        {
          ord.SelectByIndex(i);
          ulong ticket = ord.Ticket();
          if(ord.Symbol()==_Symbol && ord.Magic() == InpMagic)
            {
             trade.OrderDelete(ticket);
            }
        }
 }
 
 
 void TrailStop(){
      double sl = 0;
      double tp = 0;
      
      double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
      
      for(int i=PositionsTotal()-1;i>=0;i--)
        {
         if(pos.SelectByIndex(i))
           {
             ulong ticket = pos.Ticket();
             
             if(pos.Magic()==InpMagic && pos.Symbol()==_Symbol)
               {
                  if(pos.PositionType()==POSITION_TYPE_BUY)
                    {
                      if((bid-pos.PriceOpen()-spread) > TslTriggersPoints*_Point)
                        {
                         tp = pos.TakeProfit();
                         sl = bid - (TslPoints*_Point);
                         if(sl>pos.StopLoss() && sl!=0)
                           {
                            trade.PositionModify(ticket,sl,tp);
                           }
                        }
                    }else if(pos.PositionType()==POSITION_TYPE_SELL)
                            {
                            
                        if((ask+(TslTriggersPoints*_Point)+spread) <pos.PriceOpen())
                        {
                         tp = pos.TakeProfit();
                         sl = ask + (TslPoints*_Point);
                         if(sl<pos.StopLoss() && sl!=0)
                           {
                            trade.PositionModify(ticket,sl,tp);
                           }
                        }
                             
                    }
               }
           }
        }
 }
 
 void CalculSpread(){
   if(InpSpread <= 0)
             {
   spread = SymbolInfoDouble(_Symbol,SYMBOL_ASK) - SymbolInfoDouble(_Symbol,SYMBOL_BID);
   }else
      {
       spread = InpSpread * _Point;
      }
      
      Print("**** spread ****",spread);

 }