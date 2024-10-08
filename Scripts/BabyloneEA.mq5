//+------------------------------------------------------------------+
//|                                                   BabyloneEA.mq5 |
//|                                                    Gerard Fevill |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh>
#include <..\Libraries\MayLib\index.mqh>

//+------------------------------------------------------------------+
//| Script pour prendre des trades entre une plage horaire définie   |
//+------------------------------------------------------------------+
// Paramètres d'entrée pour l'utilisateur
input int startHour   = 7;   // Heure de début (07h)
input int startMinute = 0;   // Minute de début (00min)
input int endHour     = 21;  // Heure de fin (21h)
input int endMinute   = 0;   // Minute de fin (00min)

string STTS = "Market\\Smart Trend Trading System MT5.ex5";
double sttsHandle;
int OldNumBars, OldNumBars2;
int bufferSmartCloud = 32;
double currentSmartCloudM15,currentSmartCloudM5,currentSmartCloudM1,closePrice;
double smartCloudValue[];
CTrade trade;
input double Lots = 1;

input double LotStep = 0.5;  // Pas de lot minimum
input double PointsToBreakEven = 30;  // Points pour déplacer le SL au break-even
input double PointsToPartialClose1 = 40;  // Points pour fermer 1/3 de la position
input double PointsToPartialClose2 = 80;  // Points pour fermer 1/2 de la position restante
input double StopLossDistanceAfterClose2 = 40;  // Points pour déplacer le SL après la fermeture de 1/2
input int divisor = 1000;

int number, part1, part2, part3;

bool breakEvenMoved = false;
bool partialClosed = false;

input ENUM_TIMEFRAMES timetop = PERIOD_M15;
input ENUM_TIMEFRAMES timemid = PERIOD_M5;
input ENUM_TIMEFRAMES timebot = PERIOD_M1;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
  Print("BabyloneEA initialized.");
  sttsHandle = iCustom(_Symbol, timetop, STTS,"",false,true,false,false,true,false,false,false,"");
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

     if (!NewBar(_Symbol, PERIOD_M5, OldNumBars))
        return;
    closePosition();
    number = GetAccountBalanceDividedBy(divisor);
    
    X();
    if (IsWithinTradingHours())
    {
       
       
         Print("Nous sommes dans la plage horaire. Prêt à prendre un trade.");
    currentSmartCloudM15 = getSmartCloudValue(timetop) ;
    currentSmartCloudM5 = getSmartCloudValue(timemid);
    currentSmartCloudM1 = getSmartCloudValue(timebot);
    
    OpenTrade();
    }
    else
    {
        Print("Nous sommes en dehors de la plage horaire.");
    }
    
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Fonction pour vérifier si l'heure actuelle est dans la plage     |
//| horaire définie                                                  |
//+------------------------------------------------------------------+
bool IsWithinTradingHours()
{
    // Heure actuelle du serveur
    datetime currentTime = TimeCurrent();
    
    // Structure pour décomposer la date et l'heure actuelle
    MqlDateTime currentTimeStruct;
    TimeToStruct(currentTime, currentTimeStruct);
    
    // Extraction des heures et minutes actuelles
    int currentHour = currentTimeStruct.hour;
    int currentMinute = currentTimeStruct.min;
    
    // Calculer l'heure actuelle en minutes depuis minuit
    int currentTimeInMinutes = currentHour * 60 + currentMinute;
    
    // Calculer l'heure de début et de fin en minutes depuis minuit
    int startTimeInMinutes = startHour * 60 + startMinute;
    int endTimeInMinutes = endHour * 60 + endMinute;

    // Retourner vrai si l'heure actuelle est dans la/µ plage de temps
    return (currentTimeInMinutes >= startTimeInMinutes && currentTimeInMinutes < endTimeInMinutes);
}

void OpenTrade(){
   
   if(bodyCheckGreatAll(currentSmartCloudM15,currentSmartCloudM5,currentSmartCloudM1))
     {
      // Sell trade
      DistributeDifference(number, part1, part2, part3);
       ManagePosition(ORDER_TYPE_SELL);
     }
     
     if(bodyCheckLessAll(currentSmartCloudM15,currentSmartCloudM5,currentSmartCloudM1))
     {
      // Buy trade
      DistributeDifference(number, part1, part2, part3);
       ManagePosition(ORDER_TYPE_BUY);
     }
}

void X(){
    ulong ticket = PositionGetTicket(0); // Obtenir le ticket de la position
      if(PositionSelectByTicket(ticket))
        {
         double points = CalculatePoints(ticket); // Calculer les points gagnés/perdus
         
         // Déplacer le stop loss à break-even si 30 points sont atteints
         /*if(points >= PointsToBreakEven && !breakEvenMoved)
           {
            MoveStopLossToBreakEven(ticket);
            ClosePartialPosition(part1);
            breakEvenMoved = true;
           }

         // Fermer 1/3 de la position si 40 points sont atteints
         if(points >= PointsToPartialClose1)
           {
            ClosePartialPosition(ticket, 3.0 / 3.0);
           }
         // Fermer 1/2 de la position restante à 80 points et déplacer le SL à 40 points du prix d'ouverture
         if(points >= PointsToPartialClose2 && !partialClosed)
           {
             ClosePartialPosition(part2);
             partialClosed = true;
           }*/

        }
}

void ClosePartialPosition(double closeVolume)
{
    // Ensure the volume to close is positive
    if (closeVolume <= 0)
    {
        Print("Invalid close volume.");
        return;
    }

    // Select the position
    if (!PositionSelect(Symbol()))
    {
        Print("No position selected or error occurred.");
        return;
    }

    // Get the position size
    double positionVolume = PositionGetDouble(POSITION_VOLUME);

    // Check if the close volume is valid
    if (closeVolume > positionVolume)
    {
        Print("Close volume exceeds the current position volume.");
        return;
    }

    // Determine the type of the position
    int positionType = PositionGetInteger(POSITION_TYPE);
    double price = SymbolInfoDouble(Symbol(), SYMBOL_BID);

    double result = trade.PositionClosePartial(Symbol(), closeVolume);

    if (result)
    {
        Print("Partial position closed successfully. Volume: ", closeVolume);
    }
    else
    {
        Print("Failed to close partial position. Error: ", GetLastError());
    }
}

//+------------------------------------------------------------------+
//| Fonction pour ouvrir une position                                |
//+------------------------------------------------------------------+
void OpenPosition(int type)
  {
   double lotSize = GetAccountBalanceDividedBy(divisor); // Taille du lot
   double stopLoss = 0; // Stop Loss en points
   double takeProfit = 0; // Take Profit en points

   // Calcul des niveaux de Stop Loss et Take Profit
   double price = (type == ORDER_TYPE_BUY) ? SymbolInfoDouble(_Symbol, SYMBOL_ASK) : SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double sl = (type == ORDER_TYPE_BUY) ? price - stopLoss * _Point : price + stopLoss * _Point;
   double tp = (type == ORDER_TYPE_BUY) ? price + takeProfit * _Point : price - takeProfit * _Point;

   // Ouvrir une position
   
   if(type == ORDER_TYPE_BUY)
     {
      trade.Buy(lotSize, _Symbol, price, 0, 0);
     }
     else
     {
      trade.Sell(lotSize, _Symbol, price, 0, 0);
     }
     
     breakEvenMoved  = false;
     partialClosed = false;
  }
  
  
  //+------------------------------------------------------------------+
//| Fonction pour gérer les positions en fonction du type d'ordre    |
//+------------------------------------------------------------------+
void ManagePosition(int orderType)
  {
   // Vérifier s'il existe une position ouverte
   if (PositionsTotal() == 1)
     {
      // Récupérer le ticket de la position ouverte
      ulong ticket = PositionGetTicket(0);

      // Vérifier le type de la position existante
      int existingOrderType = PositionGetInteger(POSITION_TYPE);

      if (existingOrderType == orderType)
        {
         return; // Ne rien faire d'autre si la position est du même type
        }
      else
        {
         // Si une position opposée est ouverte, la fermer
         trade.PositionClose(ticket);
        }
     }

   // Ouvrir une nouvelle position après la fermeture de l'ancienne (si elle existait)
   OpenPosition(orderType);
  }
  
  //| Fonction pour gérer les positions en fonction du type d'ordre    |
//+------------------------------------------------------------------+
void closePosition()
  {
       printf("1 -----------");
   // Vérifier s'il existe une position ouverte
   if (PositionsTotal() == 1)
     {
     printf("2 -----------");
      // Récupérer le ticket de la position ouverte
      ulong ticket = PositionGetTicket(0);

      // Vérifier le type de la position existante
      int existingOrderType = PositionGetInteger(POSITION_TYPE);

         if ((existingOrderType == ORDER_TYPE_BUY && currentSmartCloudM5 > iClose(_Symbol,PERIOD_M5,1)) ||
             (existingOrderType == ORDER_TYPE_SELL && currentSmartCloudM5 < iClose(_Symbol,PERIOD_M5,1)))
           {
            trade.PositionClose(ticket); // Fermer la position selon la condition
         } 
     }
  }
  
  double getSmartCloudValue(ENUM_TIMEFRAMES period){
   
   double _smartCloudValue[];
   int _sttsHandle = iCustom(_Symbol, period, STTS,"",false,true,false,false,true,false,false,false,"");
   CopyBuffer(_sttsHandle, bufferSmartCloud, 0, 1, _smartCloudValue);
   return NormalizeDouble(_smartCloudValue[0], 2);
   
}

bool bodyCheckGreat(double _currentSmartCloudM,ENUM_TIMEFRAMES period){
   return _currentSmartCloudM > iClose(_Symbol,period,1) && _currentSmartCloudM > iOpen(_Symbol,period,1);
}

bool bodyCheckLess(double _currentSmartCloudM,ENUM_TIMEFRAMES period){
   return _currentSmartCloudM < iClose(_Symbol,period,1) && _currentSmartCloudM < iOpen(_Symbol,period,1);
}

bool bodyCheckGreatAll(double _currentSmartCloudM15,double _currentSmartCloudM5,double _currentSmartCloudM1){
   return bodyCheckGreat(_currentSmartCloudM15,timetop) && bodyCheckGreat(_currentSmartCloudM5,timemid) && bodyCheckGreat(_currentSmartCloudM1,timebot);
}

bool bodyCheckLessAll(double _currentSmartCloudM15,double _currentSmartCloudM5,double _currentSmartCloudM1){
   return bodyCheckLess(_currentSmartCloudM15,timetop) && bodyCheckLess(_currentSmartCloudM5,timemid) && bodyCheckLess(_currentSmartCloudM1,timebot);
}

//+------------------------------------------------------------------+
//| Fonction pour calculer le nombre de points gagnés/perdus         |
//+------------------------------------------------------------------+
double CalculatePoints(ulong ticket)
  {
   double openPrice = PositionGetDouble(POSITION_PRICE_OPEN); // Prix d'ouverture
   double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID); // Prix actuel
   int positionType = PositionGetInteger(POSITION_TYPE); // Type de position (achat ou vente)
   
   double points = 0;
   
   if(positionType == POSITION_TYPE_BUY)
     {
      points = (currentPrice - openPrice) / _Point;
     }
   else if(positionType == POSITION_TYPE_SELL)
     {
      points = (openPrice - currentPrice) / _Point;
     }
   
   return points;
  }

//+------------------------------------------------------------------+
//| Fonction pour déplacer le stop loss au niveau de break-even      |
//+------------------------------------------------------------------+
void MoveStopLossToBreakEven(ulong ticket)
  {
   double openPrice = PositionGetDouble(POSITION_PRICE_OPEN); // Prix d'ouverture
   double stopLoss = PositionGetDouble(POSITION_SL); // Niveau actuel du stop loss
   
   if(stopLoss == openPrice) // Déjà au niveau du break-even
      return;
   
   trade.PositionModify(ticket, openPrice, PositionGetDouble(POSITION_TP));
  }

//+------------------------------------------------------------------+
//| Fonction pour déplacer le stop loss à un niveau spécifique       |
//+------------------------------------------------------------------+
void MoveStopLoss(ulong ticket, double points)
  {
   double openPrice = PositionGetDouble(POSITION_PRICE_OPEN); // Prix d'ouverture
   double newStopLoss = openPrice + points * _Point;
   
   trade.PositionModify(ticket, newStopLoss, PositionGetDouble(POSITION_TP));
  }

//+------------------------------------------------------------------+
//| Fonction pour fermer une partie de la position                   |
//+------------------------------------------------------------------+
bool ClosePartialPosition(ulong ticket, double fraction) {
    // Validate fraction value
    if (fraction <= 0.0 || fraction >= 0.5) {
        Print("Invalid fraction value. It must be between 0.0 (exclusive) and 1.0 (exclusive).");
        return false;
    }

    // Select the position by ticket
    if (!PositionSelectByTicket(ticket)) {
        Print("Failed to select position with ticket: ", ticket);
        return false;
    }

    // Get the volume of the position
    double volume = PositionGetDouble(POSITION_VOLUME);
    double volumeToClose = volume * fraction;

    // Check and adjust volume step to be a multiple of 0.5
    double stepSize = 0.5;
    volumeToClose = MathFloor(volumeToClose / stepSize) * stepSize;

    // Ensure the volume to close is not greater than the available volume
    if (volumeToClose <= 0 || volumeToClose > volume) {
        Print("No valid volume to close.");
        return false;
    }

    // Send the order to close part of the position
    bool result = trade.PositionClosePartial(ticket, volumeToClose);

    if (!result) {
        Print("Failed to close partial position. Error code: ", GetLastError());
        return false;
    }

    Print("Successfully closed ", volumeToClose, " of position with ticket: ", ticket);
    return true;
}

//+------------------------------------------------------------------+
//| Fonction pour vérifier si une position a déjà été fermée à un niveau |
//+------------------------------------------------------------------+
bool HasClosedAtLevel(ulong ticket, double level)
  {
   // Cette fonction est un espace réservé. 
   // Tu devras implémenter une gestion d'état pour suivre les niveaux de fermeture si nécessaire.
   return false;
  }
  
// Fonction pour trouver le plus petit multiple de 3 inférieur ou égal à un nombre donné
int MinMultipleOfThree(int number) {
    return 3 * (number / 3);
}

// Fonction pour calculer la différence et la répartir sur trois parts égales
void DistributeDifference(int number, int &part1, int &part2, int &part3) {
    int multiple = MinMultipleOfThree(number);
    int difference = number - multiple;
    int basePart = multiple / 3; // Division du multiple par 3 pour obtenir les parts de base
    int extra = difference / 3;  // Répartition égale de la différence sur les trois parts

    // Calcul des trois parts
    part1 = basePart + extra;
    part2 = basePart + extra;
    part3 = basePart + extra;
    
    // Si la différence n'est pas exactement divisible par 3, répartir le reste
    int remainder = difference % 3;
    if (remainder >= 1) part1++;
    if (remainder == 2) part2++;
}

/*// Exemple d'utilisation
void OnStart() {
    int number = 13; // Exemple de valeur
    int part1, part2, part3;
    
    DistributeDifference(number, part1, part2, part3);
    
    Print("Répartition pour la valeur initiale ", number, ": ");
    Print("Part 1: ", part1);
    Print("Part 2: ", part2);
    Print("Part 3: ", part3);
}*/


// Fonction pour obtenir le solde du compte divisé par un diviseur
int GetAccountBalanceDividedBy(int divisor) {
    double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    return (int)(accountBalance / divisor);
}