//+------------------------------------------------------------------+
//|                                                        MA_CrossEA|
//|                        Copyright 2024, Akaj                      |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
CTrade trade;
input int    MA_Period1 = 100;               // Période pour la première MA
input int    MA_Period2 = 200;               // Période pour la deuxième MA
input double Lots = 1;                       // Taille des lots
input double StopLoss = 70;                  // Stop Loss en pips
input double TakeProfit = 90;                // Take Profit en pips
input double BreakEvenStart = 20;            // Début du BreakEven pips
input double TrailingSart = 50;              // Début du Trailing Stop en pips
input double TrailingStop = 90;              // Distance du Trailing Stop en pips

double ma50[], ma200[];            // Tampons pour les valeurs des MA
int    handle_ma50, handle_ma200;  // Handles des indicateurs

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   // Création des handles pour les moyennes mobiles
   handle_ma50 = iMA(_Symbol, _Period, MA_Period1, 0, MODE_SMA, PRICE_CLOSE);
   handle_ma200 = iMA(_Symbol, _Period, MA_Period2, 0, MODE_SMA, PRICE_CLOSE);

   if (handle_ma50 == INVALID_HANDLE || handle_ma200 == INVALID_HANDLE)
     {
      Print("Erreur lors de la création des handles MA : ", GetLastError());
      return(INIT_FAILED);
     }
   
   Print("EA initialized");
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(handle_ma50 != INVALID_HANDLE)
      IndicatorRelease(handle_ma50);
   if(handle_ma200 != INVALID_HANDLE)
      IndicatorRelease(handle_ma200);

   Print("EA deinitialized");
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    // Vérifier si une position est déjà ouverte
    if (PositionsTotal() > 0)
    {
        ManagePositions(); // Gérer les positions existantes
        Print("Une position est déjà ouverte, aucune nouvelle position ne sera prise.");
        return;  // Ne pas continuer si une position est déjà ouverte
    }

    // Reste du code pour calculer les moyennes mobiles et ouvrir des positions
    handle_ma50 = iMA(_Symbol, _Period, MA_Period1, 0, MODE_SMA, PRICE_CLOSE);
    handle_ma200 = iMA(_Symbol, _Period, MA_Period2, 0, MODE_SMA, PRICE_CLOSE);
    
    if (handle_ma50 == INVALID_HANDLE || handle_ma200 == INVALID_HANDLE)
    {
        Print("Erreur lors de la création des handles MA : ", GetLastError());
        return;
    }

    ArraySetAsSeries(ma50, true);
    ArraySetAsSeries(ma200, true);

    if (CopyBuffer(handle_ma50, 0, 0, 2, ma50) < 2 || CopyBuffer(handle_ma200, 0, 0, 2, ma200) < 2)
    {
        Print("Erreur lors de la copie des données MA : ", GetLastError());
        return;
    }

    double current_ma50 = ma50[0];
    double prev_ma50 = ma50[1];
    double current_ma200 = ma200[0];
    double prev_ma200 = ma200[1];

    if (prev_ma50 < prev_ma200 && current_ma50 > current_ma200)
    {
        Print("Signal d'achat détecté");
        OpenBuy();
    }
    else if (prev_ma50 > prev_ma200 && current_ma50 < current_ma200)
    {
        Print("Signal de vente détecté");
        OpenSell();
    }
}


//+------------------------------------------------------------------+
//| Fonction pour ouvrir un ordre d'achat                            |
//+------------------------------------------------------------------+
void OpenBuy()
  {
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    double sl = ask - StopLoss * _Point;
    double tp = ask + TakeProfit * _Point;

    if (!trade.Buy(Lots, _Symbol, ask, sl, tp))
    {
        Print("Erreur lors de l'ouverture d'un ordre d'achat : ", GetLastError());
    }
  }

//+------------------------------------------------------------------+
//| Fonction pour ouvrir un ordre de vente                           |
//+------------------------------------------------------------------+
void OpenSell()
  {
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    double sl = bid + StopLoss * _Point;
    double tp = bid - TakeProfit * _Point;

    if (!trade.Sell(Lots, _Symbol, bid, sl, tp))
    {
        Print("Erreur lors de l'ouverture d'un ordre de vente : ", GetLastError());
    }
  }
  
//+------------------------------------------------------------------+
//| Gérer les positions existantes                                   |
//+------------------------------------------------------------------+
void ManagePositions()
{
    for (int i = 0; i < PositionsTotal(); i++)
    {
        ulong ticket = PositionGetTicket(i);
        if (PositionSelectByTicket(ticket))
        {
            double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
            double currentPrice = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ?
                                  SymbolInfoDouble(_Symbol, SYMBOL_BID) :
                                  SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            double sl = PositionGetDouble(POSITION_SL);
            double tp = PositionGetDouble(POSITION_TP);
            double profit = PositionGetDouble(POSITION_PROFIT);

            // Break-Even Stop
            if ((profit >= (BreakEvenStart * _Point)) && (profit < (TrailingSart * _Point)) && sl < openPrice)
            {
                double new_sl = openPrice;
                if (!trade.PositionModify(ticket, new_sl, tp))
                {
                    Print("Erreur lors de la mise à jour du Stop Loss au niveau du break-even : ", GetLastError());
                }
            }

            // Trailing Stop Dynamique
            if (profit >= (TrailingSart * _Point))
            {
                double trailingStopDistance = TrailingStop * _Point;
                double new_sl = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ?
                                MathMax(sl, currentPrice - trailingStopDistance) :
                                MathMin(sl, currentPrice + trailingStopDistance);

                if ((PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY && new_sl > sl) ||
                    (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL && new_sl < sl))
                {
                    if (!trade.PositionModify(ticket, new_sl, tp))
                    {
                        Print("Erreur lors de la mise à jour du Trailing Stop : ", GetLastError());
                    }
                }
            }
        }
    }
}
