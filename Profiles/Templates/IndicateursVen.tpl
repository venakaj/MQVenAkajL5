<chart>
id=133635319492522838
symbol=XTIUSD
description=Crude Oil vs US Dollar
period_type=0
period_size=5
digits=2
tick_size=0.000000
position_time=1720720680
scale_fix=0
scale_fixed_min=81.600000
scale_fixed_max=83.500000
scale_fix11=0
scale_bar=0
scale_bar_val=1.000000
scale=4
mode=1
fore=0
grid=1
volume=1
scroll=1
shift=1
shift_size=19.850653
fixed_pos=0.000000
ticker=1
ohlc=0
one_click=1
one_click_btn=1
bidline=1
askline=0
lastline=0
days=0
descriptions=0
tradelines=1
tradehistory=1
window_left=104
window_top=104
window_right=1562
window_bottom=597
window_type=3
floating=0
floating_left=0
floating_top=0
floating_right=0
floating_bottom=0
floating_type=1
floating_toolbar=1
floating_tbstate=
background_color=16777215
foreground_color=0
barup_color=10135078
bardown_color=5264367
bullcandle_color=10135078
bearcandle_color=5264367
chartline_color=8698454
volumes_color=10135078
grid_color=15920369
bidline_color=10135078
askline_color=5264367
lastline_color=15776412
stops_color=5264367
windows_total=1

<window>
height=100.000000
objects=300

<indicator>
name=Main
path=
apply=1
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=0
fixed_height=-1
</indicator>

<indicator>
name=Custom Indicator
path=Indicators\Market\Smart Trend Trading System MT5.ex5
apply=0
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=32
fixed_height=-1

<graph>
name=UpTrend Signal
draw=3
style=0
width=1
arrow=233
color=3329330
</graph>

<graph>
name=DnTrend Signal
draw=3
style=0
width=1
arrow=234
color=5275647
</graph>

<graph>
name=Upper Band
draw=0
style=0
width=1
arrow=251
color=32768
</graph>

<graph>
name=Lower Band
draw=0
style=0
width=1
arrow=251
color=2237106
</graph>

<graph>
name=
draw=3
style=0
width=1
arrow=251
color=5275647
</graph>

<graph>
name=
draw=3
style=0
width=1
arrow=251
color=3329330
</graph>

<graph>
name=
draw=1
style=0
width=3
arrow=251
color=16748574
</graph>

<graph>
name=
draw=1
style=0
width=3
arrow=251
color=42495
</graph>

<graph>
name=Arrow BULL
draw=3
style=0
width=2
arrow=233
shift_y=15
color=16748574
</graph>

<graph>
name=Arrow BEAR
draw=3
style=0
width=2
arrow=234
shift_y=-15
color=255
</graph>

<graph>
name=Trend Up
draw=0
style=0
width=2
arrow=251
color=32768
</graph>

<graph>
name=Trend Down
draw=0
style=0
width=2
arrow=251
color=255
</graph>

<graph>
name=MA
draw=0
style=0
width=2
arrow=251
color=2139610
</graph>

<graph>
name=Alpha Line;Offset Line
draw=7
style=4
width=1
arrow=251
color=32768,255
</graph>

<graph>
name=Buy Signal
draw=3
style=0
width=1
arrow=225
shift_y=20
color=16748574
</graph>

<graph>
name=Sell Signal
draw=3
style=0
width=1
arrow=226
shift_y=-20
color=4678655
</graph>

<graph>
name=upper filling
draw=7
style=0
width=1
arrow=251
color=13628367
</graph>

<graph>
name=lower filling
draw=7
style=0
width=1
arrow=251
color=13492732
</graph>

<graph>
name=Upper band
draw=1
style=0
width=1
arrow=251
color=7451452
</graph>

<graph>
name=Lower band
draw=1
style=0
width=1
arrow=217
shift_y=-10
color=6333684
</graph>

<graph>
name=Average
draw=1
style=2
width=1
arrow=218
shift_y=10
color=-1
</graph>

<graph>
name=Break up
draw=3
style=0
width=1
arrow=159
color=32768
</graph>

<graph>
name=Break down
draw=3
style=0
width=1
arrow=159
color=36095
</graph>

<graph>
name=Open;High;Low;Close
draw=17
style=0
width=1
arrow=251
color=8388736,65280,255
</graph>

<graph>
name=Price channel stop
draw=7
style=0
width=1
arrow=251
color=15130800,12180223
</graph>

<graph>
name=Price channel stop
draw=10
style=0
width=1
arrow=251
color=16760576,36095
</graph>

<graph>
name=Open;High;Low;Close
draw=0
style=0
width=1
arrow=251
color=15786048,15327301,14803274,14278991,13820500,13296217,12772190,12247908,11789417,11265134,10741107,10216824,9758333,9234051,8710024,8185741,7727250,7202967,6678940,6154658,5696167,5171884,4647857,4123574,3665083,3140801,2616774,2092491,1634000,1109717,585690,61664,125664,189410,253155,317156,380900,444646,508647,572392,636136,699882,763883,827628,891372,955374,1019119,1082864,1146609,1210609,1274355,1338100,1402101,1465846,1529591,1593336,1657337,1721082,1784827,1848828,1912573,1976318,2105599
</graph>
<inputs>
IndVis=====< Show and hide Indicators>====
Use_MTFTrend=false
Use_Line_trend=true
Use_Band_trend=true
Use_BB_Zones=true
Use_Cloud=true
DrawMAEnabled=false
Use_Spread=true
Use_Timer=true
CandColor=====< Smart Candles Coloring Modes>====
CandColorMode1=Set All to false to Enable Metatrader Native Candles Coloring
Use_Candle_Color1=true
Use_Candle_Color2=false
iShowGradient=false
IND1=====<Trend Breakout Catcher>====
CountBars=5000
Smoothing=1
Amplitude=1
str4= Settings for  Alerts :
ShowAlert=true
SendPush=false
SendMailInfo=false
ShowSound=true
SoundNameBull=buy.wav
SoundNameBear=sell.wav
str5= Settings for  Arrows :
ShowArrowsHT=true
BullArrows=16748574
BearArrows=255
SizeArrows=2
ShiftArrow=15
uparrowCode=233
dnarrowCode=234
str6= Settings for  Trade Analysis :
ShowAnalysis=false
ShowStatsComment=false
ShowArrows=true
ShowProfit=true
ShowExits=true
WinColor=3329330
LossColor=4678655
sIND2=
IND2=====< Smart Trailing Stop >====
inp_length=14
inp_atr_multiplier=1.386
inp_price=1
inp_change_calc=1
inp_signals=1
TriggerCandle=1
EnableNativeAlerts=false
EnableSoundAlerts=false
EnableEmailAlerts=false
EnablePushAlerts=false
AlertEmailSubject=
AlertText=
SoundFileName=alert.wav
sIND3=
IND3=====< Smart Reversal Zones >====
inpPeriod=386
inpPrice=1
inpDeviations=5.0
inpZonesPercent=40.0
sIND4=
IND4=====< Smart Trend Candles Coloring >====
ChannelPeriods=9
MoneyRisk=1.0
sIND5=
IND5=====< Smart Volume Candles Coloring >====
iSensitivity=1.0
ENUM_APPLIED_VOLUMEInp=0
sIND6=
IND6=====< Smart Cloud >====
inpChannelPeriod=60
inpRisk=0.386
sIND8=
IND8=====< Multi Timeframes Trend Panel >====
Corner=3
ATRPeriod=14
ATRMultiplier=5.0
ATRMaxBars=1000
=
NumSigBar=0
Repeating=false
=
ShowAlerts=true
SendPushs=false
SendMailInfos=false
ShowSounds=false
SoundNameBulls=buy.wav
SoundNameBears=sell.wav
=
FontTypes=0
BullValClr=65280
BearValClr=255
FlatColors=5197615
=
Keyboard_Symbol=x
soundBT=tick.wav
=
FontSize=10
IND11=====< Moving Average >====
MAPeriods=200
MAShift=0
MAMethod=0
MAAppliedPrice=1
sIND9=
IND9=====< Spread >====
font_color=8388736
font_size=15
font_face=Arial
Corners=2
AlertIfSpreadAbove=0.0
sIND10=
IND10=====< Candle Timer >====
ValuesPositiveColor=7451452
ValuesNegativeColor=9662683
TimeFontSize=10
TimerShift=7
</inputs>
</indicator>

<indicator>
name=Moving Average
path=
apply=1
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=0
fixed_height=-1

<graph>
name=
draw=129
style=0
width=3
arrow=251
color=255
</graph>
period=200
method=1
</indicator>

<indicator>
name=Moving Average
path=
apply=1
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=0
fixed_height=-1

<graph>
name=
draw=129
style=0
width=3
arrow=251
color=16711680
</graph>
period=50
method=1
</indicator>

<indicator>
name=Custom Indicator
path=Indicators\Market\Pivot Point Fibo RSJ.ex5
apply=1
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=32
fixed_height=-1

<graph>
name=R7
draw=1
style=1
width=2
arrow=251
shift=324
color=2237106
</graph>

<graph>
name=R6
draw=1
style=1
width=2
arrow=251
shift=324
color=2970272
</graph>

<graph>
name=R5
draw=1
style=1
width=2
arrow=251
shift=324
color=16711680
</graph>

<graph>
name=R4
draw=1
style=1
width=2
arrow=251
shift=324
color=15631086
</graph>

<graph>
name=R3
draw=1
style=1
width=2
arrow=251
shift=324
color=128
</graph>

<graph>
name=R2
draw=1
style=1
width=2
arrow=251
shift=324
color=17919
</graph>

<graph>
name=R1
draw=1
style=1
width=2
arrow=251
shift=324
color=42495
</graph>

<graph>
name=PP
draw=1
style=1
width=2
arrow=251
shift=324
color=3329434
</graph>

<graph>
name=S1
draw=1
style=1
width=2
arrow=251
shift=324
color=42495
</graph>

<graph>
name=S2
draw=1
style=1
width=2
arrow=251
shift=324
color=17919
</graph>

<graph>
name=S3
draw=1
style=1
width=2
arrow=251
shift=324
color=128
</graph>

<graph>
name=S4
draw=1
style=1
width=2
arrow=251
shift=324
color=15631086
</graph>

<graph>
name=S5
draw=1
style=1
width=2
arrow=251
shift=324
color=16711680
</graph>

<graph>
name=S6
draw=1
style=1
width=2
arrow=251
shift=324
color=2970272
</graph>

<graph>
name=S7
draw=1
style=1
width=2
arrow=251
shift=324
color=2237106
</graph>
<inputs>
=
InpPivotType=1
MinLevelPivots=4
</inputs>
</indicator>
<object>
type=109
name=2024.06.24 10:00 Discours du gouverneur de la Réserve Fédérale,
hidden=1
descr=Discours du gouverneur de la Réserve Fédérale, Waller
color=16119285
selectable=0
date1=1719223200
</object>

<object>
type=109
name=2024.06.24 17:30 Indice manufacturier de la Réserve Fédérale de
hidden=1
descr=Indice manufacturier de la Réserve Fédérale de Dallas -15.1 / -
color=13353215
selectable=0
date1=1719250200
</object>

<object>
type=109
name=2024.06.24 18:30 Vente aux Enchères de billets de 3 mois
hidden=1
descr=Vente aux Enchères de billets de 3 mois
color=16119285
selectable=0
date1=1719253800
</object>

<object>
type=109
name=2024.06.24 18:30 Vente des enchères de billets de 6 mois
hidden=1
descr=Vente des enchères de billets de 6 mois
color=16119285
selectable=0
date1=1719253800
</object>

<object>
type=109
name=2024.06.24 22:30 Positions nettes non commerciales de CFTC Copp
hidden=1
descr=Positions nettes non commerciales de CFTC Copper
color=16119285
selectable=0
date1=1719268200
</object>

<object>
type=109
name=2024.06.24 22:30 Positions nettes non commerciales de CFTC Silv
hidden=1
descr=Positions nettes non commerciales de CFTC Silver
color=16119285
selectable=0
date1=1719268200
</object>

<object>
type=109
name=2024.06.24 22:30 Positions nettes non commerciales de CFTC Gold
hidden=1
descr=Positions nettes non commerciales de CFTC Gold
color=16119285
selectable=0
date1=1719268200
</object>

<object>
type=109
name=2024.06.24 22:30 Positions nettes non commerciales du pétrole b
hidden=1
descr=Positions nettes non commerciales du pétrole brut CFTC
color=16119285
selectable=0
date1=1719268200
</object>

<object>
type=109
name=2024.06.24 22:30 CFTC S&amp;P 500 Positions nettes non commerci
hidden=1
descr=CFTC S&amp;P 500 Positions nettes non commerciales
color=16119285
selectable=0
date1=1719268200
</object>

<object>
type=109
name=2024.06.24 22:30 CFTC Aluminium Positions nettes non commercial
hidden=1
descr=CFTC Aluminium Positions nettes non commerciales
color=16119285
selectable=0
date1=1719268200
</object>

<object>
type=109
name=2024.06.24 22:30 CFTC Positions nettes non commerciales du maïs
hidden=1
descr=CFTC Positions nettes non commerciales du maïs
color=16119285
selectable=0
date1=1719268200
</object>

<object>
type=109
name=2024.06.24 22:30 CFTC Gaz naturel Positions nettes non commerci
hidden=1
descr=CFTC Gaz naturel Positions nettes non commerciales
color=16119285
selectable=0
date1=1719268200
</object>

<object>
type=109
name=2024.06.24 22:30 CFTC Graines de soja Positions nettes non comm
hidden=1
descr=CFTC Graines de soja Positions nettes non commerciales
color=16119285
selectable=0
date1=1719268200
</object>

<object>
type=109
name=2024.06.24 22:30 CFTC Positions nettes non commerciales du blé
hidden=1
descr=CFTC Positions nettes non commerciales du blé
color=16119285
selectable=0
date1=1719268200
</object>

<object>
type=109
name=2024.06.24 22:30 CFTC Nasdaq 100 Positions nettes non commercia
hidden=1
descr=CFTC Nasdaq 100 Positions nettes non commerciales
color=16119285
selectable=0
date1=1719268200
</object>

<object>
type=109
name=2024.06.25 14:00 Discours du gouverneur de la Réserve Fédérale 
hidden=1
descr=Discours du gouverneur de la Réserve Fédérale Bowman
color=16119285
selectable=0
date1=1719324000
</object>

<object>
type=109
name=2024.06.25 15:30 Indice d’activité nationale de la Réserve Fédé
hidden=1
descr=Indice d’activité nationale de la Réserve Fédérale de Chicago 0
color=15658671
selectable=0
date1=1719329400
</object>

<object>
type=109
name=2024.06.25 16:00 HPI m/m
hidden=1
descr=HPI m/m
color=16119285
selectable=0
date1=1719331200
</object>

<object>
type=109
name=2024.06.25 16:00 HPI a/a
hidden=1
descr=HPI a/a
color=16119285
selectable=0
date1=1719331200
</object>

<object>
type=109
name=2024.06.25 16:00 HPI
hidden=1
descr=HPI
color=16119285
selectable=0
date1=1719331200
</object>

<object>
type=109
name=2024.06.25 16:00 S&amp;P/CS HPI Composite-20 ans/a
hidden=1
descr=S&amp;P/CS HPI Composite-20 ans/a
color=16119285
selectable=0
date1=1719331200
</object>

<object>
type=109
name=2024.06.25 16:00 S&amp;P/CS HPI Composite-20 n.s.a. m/m
hidden=1
descr=S&amp;P/CS HPI Composite-20 n.s.a. m/m
color=16119285
selectable=0
date1=1719331200
</object>

<object>
type=109
name=2024.06.25 16:00 S&amp;P/CS HPI Composite-20 s.a. m/m
hidden=1
descr=S&amp;P/CS HPI Composite-20 s.a. m/m
color=16119285
selectable=0
date1=1719331200
</object>

<object>
type=109
name=2024.06.25 17:00 Indice CB de confiance des consommateurs 
hidden=1
descr=Indice CB de confiance des consommateurs  100.4 / 107.5
color=13353215
selectable=0
date1=1719334800
</object>

<object>
type=109
name=2024.06.25 17:00 Indice manufacturier de la Réserve Fédérale de
hidden=1
descr=Indice manufacturier de la Réserve Fédérale de Richmond -10 / -
color=13353215
selectable=0
date1=1719334800
</object>

<object>
type=109
name=2024.06.25 17:00 Expéditions de fabrication de la Réserve Fédér
hidden=1
descr=Expéditions de fabrication de la Réserve Fédérale de Richmond
color=16119285
selectable=0
date1=1719334800
</object>

<object>
type=109
name=2024.06.25 17:00 Revenus des services de la Réserve Fédérale de
hidden=1
descr=Revenus des services de la Réserve Fédérale de Richmond -11 / -
color=13353215
selectable=0
date1=1719334800
</object>

<object>
type=109
name=2024.06.25 17:30 Revenus des services de la Réserve Fédérale de
hidden=1
descr=Revenus des services de la Réserve Fédérale de Dallas 1.9 / 27.
color=13353215
selectable=0
date1=1719336600
</object>

<object>
type=109
name=2024.06.25 17:30 Activité des services de la Réserve Fédérale d
hidden=1
descr=Activité des services de la Réserve Fédérale de Dallas -4.1 / -
color=15658671
selectable=0
date1=1719336600
</object>

<object>
type=109
name=2024.06.25 19:00 Discours du gouverneur Cook de la Fed
hidden=1
descr=Discours du gouverneur Cook de la Fed
color=16119285
selectable=0
date1=1719342000
</object>

<object>
type=109
name=2024.06.25 20:00 Vente des enchères de billet de banque de 2 an
hidden=1
descr=Vente des enchères de billet de banque de 2 ans
color=16119285
selectable=0
date1=1719345600
</object>

<object>
type=109
name=2024.06.25 21:10 Discours du gouverneur de la Réserve Fédérale 
hidden=1
descr=Discours du gouverneur de la Réserve Fédérale Bowman
color=16119285
selectable=0
date1=1719349800
</object>

<object>
type=109
name=2024.06.26 17:00 Ventes de Logements Neufs
hidden=1
descr=Ventes de Logements Neufs 0.619 M / 0.669 M
color=13353215
selectable=0
date1=1719421200
</object>

<object>
type=109
name=2024.06.26 17:00 Ventes de Logements Neufs m/m
hidden=1
descr=Ventes de Logements Neufs m/m -11.3% / 1.3%
color=13353215
selectable=0
date1=1719421200
</object>

<object>
type=109
name=2024.06.26 20:00 Vente des enchères de billets de banque de 5 a
hidden=1
descr=Vente des enchères de billets de banque de 5 ans
color=16119285
selectable=0
date1=1719432000
</object>

<object>
type=109
name=2024.06.26 23:30 Résultats DFAST de la Réserve Fédérale
hidden=1
descr=Résultats DFAST de la Réserve Fédérale
color=16119285
selectable=0
date1=1719444600
</object>

<object>
type=109
name=2024.06.27 15:30 GDP q/q
hidden=1
descr=GDP q/q 1.4% / 1.3%
color=15658671
selectable=0
date1=1719502200
</object>

<object>
type=109
name=2024.06.27 15:30 Indice des prix du PIB q/q
hidden=1
descr=Indice des prix du PIB q/q 3.1% / 3.0%
color=15658671
selectable=0
date1=1719502200
</object>

<object>
type=109
name=2024.06.27 15:30 Indice des prix PCE de base q/q
hidden=1
descr=Indice des prix PCE de base q/q 3.7% / 3.6%
color=15658671
selectable=0
date1=1719502200
</object>

<object>
type=109
name=2024.06.27 15:30 Indice des prix PCE q/q
hidden=1
descr=Indice des prix PCE q/q 3.4% / 3.3%
color=15658671
selectable=0
date1=1719502200
</object>

<object>
type=109
name=2024.06.27 15:30 PCE réel t/t 
hidden=1
descr=PCE réel t/t  1.5% / 2.0%
color=13353215
selectable=0
date1=1719502200
</object>

<object>
type=109
name=2024.06.27 15:30 Bénéfices des Entreprises q/q
hidden=1
descr=Bénéfices des Entreprises q/q -2.7% / -1.7%
color=13353215
selectable=0
date1=1719502200
</object>

<object>
type=109
name=2024.06.27 15:30 PIB Ventes t/t 
hidden=1
descr=PIB Ventes t/t  1.8% / 1.7%
color=15658671
selectable=0
date1=1719502200
</object>

<object>
type=109
name=2024.06.27 15:30 Stocks des Grossistes m/m
hidden=1
descr=Stocks des Grossistes m/m 0.6% / 0.0%
color=13353215
selectable=0
date1=1719502200
</object>

<object>
type=109
name=2024.06.27 15:30 Commandes de Marchandises Durables
hidden=1
descr=Commandes de Marchandises Durables 0.1% / 0.9%
color=13353215
selectable=0
date1=1719502200
</object>

<object>
type=109
name=2024.06.27 15:30 Commandes de Marchandises Durables de Base m/m
hidden=1
descr=Commandes de Marchandises Durables de Base m/m -0.1% / 0.2%
color=13353215
selectable=0
date1=1719502200
</object>

<object>
type=109
name=2024.06.27 15:30 Commandes de Marchandises Durables à l’exclusi
hidden=1
descr=Commandes de Marchandises Durables à l’exclusion de Défense m/m
color=13353215
selectable=0
date1=1719502200
</object>

<object>
type=109
name=2024.06.27 15:30 Commandes de biens d’investissement non liés à
hidden=1
descr=Commandes de biens d’investissement non liés à la défense,à l’e
color=13353215
selectable=0
date1=1719502200
</object>

<object>
type=109
name=2024.06.27 15:30 Balance commerciale de Marchandises
hidden=1
descr=Balance commerciale de Marchandises $-100.617 B / $-97.628 B
color=13353215
selectable=0
date1=1719502200
</object>

<object>
type=109
name=2024.06.27 15:30 Expéditions de marchandises d’équipement non l
hidden=1
descr=Expéditions de marchandises d’équipement non liés à la défense,
color=13353215
selectable=0
date1=1719502200
</object>

<object>
type=109
name=2024.06.27 15:30 Stocks de détail m/m
hidden=1
descr=Stocks de détail m/m 0.7% / 0.6%
color=13353215
selectable=0
date1=1719502200
</object>

<object>
type=109
name=2024.06.27 15:30 Stocks de détail à l’exclusion de Autos m/m
hidden=1
descr=Stocks de détail à l’exclusion de Autos m/m
color=16119285
selectable=0
date1=1719502200
</object>

<object>
type=109
name=2024.06.27 15:30 Allocations Initiales de Chômage
hidden=1
descr=Allocations Initiales de Chômage 233 K / 234 K
color=15658671
selectable=0
date1=1719502200
</object>

<object>
type=109
name=2024.06.27 15:30 Allocations de chômage en continu.
hidden=1
descr=Allocations de chômage en continu. 1.839 M / 1.831 M
color=13353215
selectable=0
date1=1719502200
</object>

<object>
type=109
name=2024.06.27 15:30 Allocations Initiales de Chômage Moyennes sur 
hidden=1
descr=Allocations Initiales de Chômage Moyennes sur 4 semaines 236.00
color=15658671
selectable=0
date1=1719502200
</object>

<object>
type=109
name=2024.06.27 17:00 Ventes à domicile en attente m/m
hidden=1
descr=Ventes à domicile en attente m/m -2.1% / 1.6%
color=13353215
selectable=0
date1=1719507600
</object>

<object>
type=109
name=2024.06.27 17:00 Ventes de maisons en attente a/a
hidden=1
descr=Ventes de maisons en attente a/a -6.6% / -1.6%
color=13353215
selectable=0
date1=1719507600
</object>

<object>
type=109
name=2024.06.27 17:00 Indice des ventes de maisons en cours.
hidden=1
descr=Indice des ventes de maisons en cours.
color=16119285
selectable=0
date1=1719507600
</object>

<object>
type=109
name=2024.06.27 17:30 Changement de stockage de gaz naturel de l’EIA
hidden=1
descr=Changement de stockage de gaz naturel de l’EIA 52 B / 86 B
color=15658671
selectable=0
date1=1719509400
</object>

<object>
type=109
name=2024.06.27 18:00 Indice composite manufacturier de la Réserve F
hidden=1
descr=Indice composite manufacturier de la Réserve Fédérale de Kansas
color=16119285
selectable=0
date1=1719511200
</object>

<object>
type=109
name=2024.06.27 18:00 Production manufacturière de Kansas City Réser
hidden=1
descr=Production manufacturière de Kansas City Réserve Fédérale
color=16119285
selectable=0
date1=1719511200
</object>

<object>
type=109
name=2024.06.27 18:30 Vente des enchères de billets de 4 semaines
hidden=1
descr=Vente des enchères de billets de 4 semaines
color=16119285
selectable=0
date1=1719513000
</object>

<object>
type=109
name=2024.06.27 18:30 Vente des enchères de billets de 8 semaines
hidden=1
descr=Vente des enchères de billets de 8 semaines
color=16119285
selectable=0
date1=1719513000
</object>

<object>
type=109
name=2024.06.27 20:00 Vente des enchères de billets de banque de 7 a
hidden=1
descr=Vente des enchères de billets de banque de 7 ans
color=16119285
selectable=0
date1=1719518400
</object>

<object>
type=109
name=2024.06.28 15:30 Indice des prix PCE de base m/m
hidden=1
descr=Indice des prix PCE de base m/m
color=16119285
selectable=0
date1=1719588600
</object>

<object>
type=109
name=2024.06.28 15:30 Indice des prix PCE de base a/a
hidden=1
descr=Indice des prix PCE de base a/a
color=16119285
selectable=0
date1=1719588600
</object>

<object>
type=109
name=2024.06.28 15:30 Indice des prix PCE m/m
hidden=1
descr=Indice des prix PCE m/m
color=16119285
selectable=0
date1=1719588600
</object>

<object>
type=109
name=2024.06.28 15:30 Indice des prix PCE a/a
hidden=1
descr=Indice des prix PCE a/a
color=16119285
selectable=0
date1=1719588600
</object>

<object>
type=109
name=2024.06.28 15:30 Dépenses Personnelles m/m
hidden=1
descr=Dépenses Personnelles m/m
color=16119285
selectable=0
date1=1719588600
</object>

<object>
type=109
name=2024.06.28 15:30 Revenu Personnel m/m
hidden=1
descr=Revenu Personnel m/m
color=16119285
selectable=0
date1=1719588600
</object>

<object>
type=109
name=2024.06.28 15:30 PCE réel m/m
hidden=1
descr=PCE réel m/m
color=16119285
selectable=0
date1=1719588600
</object>

<object>
type=109
name=2024.06.28 16:45 Baromètre des entreprises MNI Chicago 
hidden=1
descr=Baromètre des entreprises MNI Chicago 
color=16119285
selectable=0
date1=1719593100
</object>

<object>
type=109
name=2024.06.28 17:00 La Réserve Fédérale de Dallas a réduit le taux
hidden=1
descr=La Réserve Fédérale de Dallas a réduit le taux d’inflation moye
color=16119285
selectable=0
date1=1719594000
</object>

<object>
type=109
name=2024.06.28 17:00 Sentiment des consommateurs du Michigan
hidden=1
descr=Sentiment des consommateurs du Michigan
color=16119285
selectable=0
date1=1719594000
</object>

<object>
type=109
name=2024.06.28 17:00 prévisions des consommateurs du Michigan
hidden=1
descr=prévisions des consommateurs du Michigan
color=16119285
selectable=0
date1=1719594000
</object>

<object>
type=109
name=2024.06.28 17:00 Conditions actuelles du Michigan
hidden=1
descr=Conditions actuelles du Michigan
color=16119285
selectable=0
date1=1719594000
</object>

<object>
type=109
name=2024.06.28 17:00 prévisions d’inflation au Michigan
hidden=1
descr=prévisions d’inflation au Michigan
color=16119285
selectable=0
date1=1719594000
</object>

<object>
type=109
name=2024.06.28 17:00 prévisions d’inflation sur 5 ans au Michigan
hidden=1
descr=prévisions d’inflation sur 5 ans au Michigan
color=16119285
selectable=0
date1=1719594000
</object>

<object>
type=109
name=2024.06.28 19:00 Discours du gouverneur de la Réserve Fédérale 
hidden=1
descr=Discours du gouverneur de la Réserve Fédérale Bowman
color=16119285
selectable=0
date1=1719601200
</object>

<object>
type=109
name=2024.06.28 20:00 Baker Hughes Nombre de plates-formes pétrolièr
hidden=1
descr=Baker Hughes Nombre de plates-formes pétrolières américaines
color=16119285
selectable=0
date1=1719604800
</object>

<object>
type=109
name=2024.06.28 20:00 Baker Hughes Nombre total de plates-formes aux
hidden=1
descr=Baker Hughes Nombre total de plates-formes aux États-Unis
color=16119285
selectable=0
date1=1719604800
</object>

<object>
type=109
name=2024.06.28 22:30 Positions nettes non commerciales de CFTC Copp
hidden=1
descr=Positions nettes non commerciales de CFTC Copper
color=16119285
selectable=0
date1=1719613800
</object>

<object>
type=109
name=2024.06.28 22:30 Positions nettes non commerciales de CFTC Silv
hidden=1
descr=Positions nettes non commerciales de CFTC Silver
color=16119285
selectable=0
date1=1719613800
</object>

<object>
type=109
name=2024.06.28 22:30 Positions nettes non commerciales de CFTC Gold
hidden=1
descr=Positions nettes non commerciales de CFTC Gold
color=16119285
selectable=0
date1=1719613800
</object>

<object>
type=109
name=2024.06.28 22:30 Positions nettes non commerciales du pétrole b
hidden=1
descr=Positions nettes non commerciales du pétrole brut CFTC
color=16119285
selectable=0
date1=1719613800
</object>

<object>
type=109
name=2024.06.28 22:30 CFTC S&amp;P 500 Positions nettes non commerci
hidden=1
descr=CFTC S&amp;P 500 Positions nettes non commerciales
color=16119285
selectable=0
date1=1719613800
</object>

<object>
type=109
name=2024.06.28 22:30 CFTC Aluminium Positions nettes non commercial
hidden=1
descr=CFTC Aluminium Positions nettes non commerciales
color=16119285
selectable=0
date1=1719613800
</object>

<object>
type=109
name=2024.06.28 22:30 CFTC Positions nettes non commerciales du maïs
hidden=1
descr=CFTC Positions nettes non commerciales du maïs
color=16119285
selectable=0
date1=1719613800
</object>

<object>
type=109
name=2024.06.28 22:30 CFTC Gaz naturel Positions nettes non commerci
hidden=1
descr=CFTC Gaz naturel Positions nettes non commerciales
color=16119285
selectable=0
date1=1719613800
</object>

<object>
type=109
name=2024.06.28 22:30 CFTC Graines de soja Positions nettes non comm
hidden=1
descr=CFTC Graines de soja Positions nettes non commerciales
color=16119285
selectable=0
date1=1719613800
</object>

<object>
type=109
name=2024.06.28 22:30 CFTC Positions nettes non commerciales du blé
hidden=1
descr=CFTC Positions nettes non commerciales du blé
color=16119285
selectable=0
date1=1719613800
</object>

<object>
type=109
name=2024.06.28 22:30 CFTC Nasdaq 100 Positions nettes non commercia
hidden=1
descr=CFTC Nasdaq 100 Positions nettes non commerciales
color=16119285
selectable=0
date1=1719613800
</object>

<object>
type=109
name=2024.06.30 16:00 Discours de Williams, Membre du FOMC
hidden=1
descr=Discours de Williams, Membre du FOMC
color=16119285
selectable=0
date1=1719763200
</object>

<object>
type=109
name=2024.07.01 16:45 Fabrication de PMI de Markit
hidden=1
descr=Fabrication de PMI de Markit 51.6 / 50.1
color=15658671
selectable=0
date1=1719852300
</object>

<object>
type=109
name=2024.07.01 17:00 Dépenses de Construction m/m
hidden=1
descr=Dépenses de Construction m/m -0.1% / -0.3%
color=15658671
selectable=0
date1=1719853200
</object>

<object>
type=109
name=2024.07.01 17:00 PMI manufacturier ISM
hidden=1
descr=PMI manufacturier ISM 48.5 / 49.2
color=13353215
selectable=0
date1=1719853200
</object>

<object>
type=109
name=2024.07.01 17:00 ISM Prix manufacturiers payés
hidden=1
descr=ISM Prix manufacturiers payés 52.1 / 54.3
color=13353215
selectable=0
date1=1719853200
</object>

<object>
type=109
name=2024.07.01 17:00 ISM Emploi manufacturier
hidden=1
descr=ISM Emploi manufacturier 49.3 / 51.4
color=13353215
selectable=0
date1=1719853200
</object>

<object>
type=109
name=2024.07.01 17:00 ISM Fabrication Nouvelles commandes
hidden=1
descr=ISM Fabrication Nouvelles commandes 49.3 / 49.4
color=13353215
selectable=0
date1=1719853200
</object>

<object>
type=109
name=2024.07.01 18:30 Vente aux Enchères de billets de 3 mois
hidden=1
descr=Vente aux Enchères de billets de 3 mois
color=16119285
selectable=0
date1=1719858600
</object>

<object>
type=109
name=2024.07.01 18:30 Vente des enchères de billets de 6 mois
hidden=1
descr=Vente des enchères de billets de 6 mois
color=16119285
selectable=0
date1=1719858600
</object>

<object>
type=109
name=2024.07.02 16:30 Discours du président de la Réserve Fédérale, 
hidden=1
descr=Discours du président de la Réserve Fédérale, M. Powell
color=16119285
selectable=0
date1=1719937800
</object>

<object>
type=109
name=2024.07.02 17:00 Offres d’emploi JOLTS
hidden=1
descr=Offres d’emploi JOLTS
color=16119285
selectable=0
date1=1719939600
</object>

<object>
type=109
name=2024.07.03 14:00 Discours de Williams, Membre du FOMC
hidden=1
descr=Discours de Williams, Membre du FOMC
color=16119285
selectable=0
date1=1720015200
</object>

<object>
type=109
name=2024.07.03 14:30 Suppressions d’emplois Challenger
hidden=1
descr=Suppressions d’emplois Challenger
color=16119285
selectable=0
date1=1720017000
</object>

<object>
type=109
name=2024.07.03 14:30 Suppressions d’emplois Challenger a/a
hidden=1
descr=Suppressions d’emplois Challenger a/a
color=16119285
selectable=0
date1=1720017000
</object>

<object>
type=109
name=2024.07.03 15:15 ADP Variation de l’Emploi Non-Agricole
hidden=1
descr=ADP Variation de l’Emploi Non-Agricole
color=16119285
selectable=0
date1=1720019700
</object>

<object>
type=109
name=2024.07.03 15:30 Balance Commerciale
hidden=1
descr=Balance Commerciale
color=16119285
selectable=0
date1=1720020600
</object>

<object>
type=109
name=2024.07.03 15:30 Exportations
hidden=1
descr=Exportations
color=16119285
selectable=0
date1=1720020600
</object>

<object>
type=109
name=2024.07.03 15:30 Importations
hidden=1
descr=Importations
color=16119285
selectable=0
date1=1720020600
</object>

<object>
type=109
name=2024.07.03 15:30 Allocations Initiales de Chômage
hidden=1
descr=Allocations Initiales de Chômage
color=16119285
selectable=0
date1=1720020600
</object>

<object>
type=109
name=2024.07.03 15:30 Allocations de chômage en continu.
hidden=1
descr=Allocations de chômage en continu.
color=16119285
selectable=0
date1=1720020600
</object>

<object>
type=109
name=2024.07.03 15:30 Allocations Initiales de Chômage Moyennes sur 
hidden=1
descr=Allocations Initiales de Chômage Moyennes sur 4 semaines
color=16119285
selectable=0
date1=1720020600
</object>

<object>
type=109
name=2024.07.03 16:45 Services PMI de Markit
hidden=1
descr=Services PMI de Markit
color=16119285
selectable=0
date1=1720025100
</object>

<object>
type=109
name=2024.07.03 16:45 Composite PMI de Markit
hidden=1
descr=Composite PMI de Markit
color=16119285
selectable=0
date1=1720025100
</object>

<object>
type=109
name=2024.07.03 17:00 Commandes d'Usine m/m
hidden=1
descr=Commandes d'Usine m/m
color=16119285
selectable=0
date1=1720026000
</object>

<object>
type=109
name=2024.07.03 17:00 Commandes d’usine excl. Transports m/m
hidden=1
descr=Commandes d’usine excl. Transports m/m
color=16119285
selectable=0
date1=1720026000
</object>

<object>
type=109
name=2024.07.03 17:00 Expéditions de marchandises d’équipement non l
hidden=1
descr=Expéditions de marchandises d’équipement non liés à la défense,
color=16119285
selectable=0
date1=1720026000
</object>

<object>
type=109
name=2024.07.03 17:00 PMI non manufacturier de l’ISM
hidden=1
descr=PMI non manufacturier de l’ISM
color=16119285
selectable=0
date1=1720026000
</object>

<object>
type=109
name=2024.07.03 17:00 ISM Emploi non manufacturier
hidden=1
descr=ISM Emploi non manufacturier
color=16119285
selectable=0
date1=1720026000
</object>

<object>
type=109
name=2024.07.03 17:00 Nouvelles commandes non manufacturières ISM
hidden=1
descr=Nouvelles commandes non manufacturières ISM
color=16119285
selectable=0
date1=1720026000
</object>

<object>
type=109
name=2024.07.03 17:00 Prix non manufacturiers payés par l’ISM
hidden=1
descr=Prix non manufacturiers payés par l’ISM
color=16119285
selectable=0
date1=1720026000
</object>

<object>
type=109
name=2024.07.03 17:00 activité économique non manufacturière de l’IS
hidden=1
descr=activité économique non manufacturière de l’ISM
color=16119285
selectable=0
date1=1720026000
</object>

<object>
type=109
name=2024.07.03 18:30 Vente des enchères de billets de 4 semaines
hidden=1
descr=Vente des enchères de billets de 4 semaines
color=16119285
selectable=0
date1=1720031400
</object>

<object>
type=109
name=2024.07.03 18:30 Vente des enchères de billets de 8 semaines
hidden=1
descr=Vente des enchères de billets de 8 semaines
color=16119285
selectable=0
date1=1720031400
</object>

<object>
type=109
name=2024.07.03 19:00 Changement de stockage de gaz naturel de l’EIA
hidden=1
descr=Changement de stockage de gaz naturel de l’EIA
color=16119285
selectable=0
date1=1720033200
</object>

<object>
type=109
name=2024.07.03 20:00 Baker Hughes Nombre de plates-formes pétrolièr
hidden=1
descr=Baker Hughes Nombre de plates-formes pétrolières américaines
color=16119285
selectable=0
date1=1720036800
</object>

<object>
type=109
name=2024.07.03 20:00 Baker Hughes Nombre total de plates-formes aux
hidden=1
descr=Baker Hughes Nombre total de plates-formes aux États-Unis
color=16119285
selectable=0
date1=1720036800
</object>

<object>
type=109
name=2024.07.03 21:00 Procès-verbal du FOMC
hidden=1
descr=Procès-verbal du FOMC
color=16119285
selectable=0
date1=1720040400
</object>

<object>
type=109
name=2024.07.04 Toute la journée Jour de l’indépendance
hidden=1
descr=Jour de l’indépendance
color=16119285
selectable=0
date1=1720062000
</object>

<object>
type=109
name=2024.07.05 12:40 Discours de Williams, Membre du FOMC
hidden=1
descr=Discours de Williams, Membre du FOMC
color=16119285
selectable=0
date1=1720183200
</object>

<object>
type=109
name=2024.07.05 15:30 Taux de Chômage
hidden=1
descr=Taux de Chômage
color=16119285
selectable=0
date1=1720193400
</object>

<object>
type=109
name=2024.07.05 15:30 Salaires non-agricoles
hidden=1
descr=Salaires non-agricoles
color=16119285
selectable=0
date1=1720193400
</object>

<object>
type=109
name=2024.07.05 15:30 Taux de Participation
hidden=1
descr=Taux de Participation
color=16119285
selectable=0
date1=1720193400
</object>

<object>
type=109
name=2024.07.05 15:30 Rémunération Horaire Moyenne m/m
hidden=1
descr=Rémunération Horaire Moyenne m/m
color=16119285
selectable=0
date1=1720193400
</object>

<object>
type=109
name=2024.07.05 15:30 Rémunération Horaire Moyenne a/a
hidden=1
descr=Rémunération Horaire Moyenne a/a
color=16119285
selectable=0
date1=1720193400
</object>

<object>
type=109
name=2024.07.05 15:30 Heures Hebdomadaires Moyennes
hidden=1
descr=Heures Hebdomadaires Moyennes
color=16119285
selectable=0
date1=1720193400
</object>

<object>
type=109
name=2024.07.05 15:30 Masse Salariale du gouvernement
hidden=1
descr=Masse Salariale du gouvernement
color=16119285
selectable=0
date1=1720193400
</object>

<object>
type=109
name=2024.07.05 15:30 Masses Salariales Privées Non-Agricoles
hidden=1
descr=Masses Salariales Privées Non-Agricoles
color=16119285
selectable=0
date1=1720193400
</object>

<object>
type=109
name=2024.07.05 15:30 Taux de Chômage U6
hidden=1
descr=Taux de Chômage U6
color=16119285
selectable=0
date1=1720193400
</object>

<object>
type=109
name=2024.07.05 15:30 Masse salariale du secteur de la fabrication
hidden=1
descr=Masse salariale du secteur de la fabrication
color=16119285
selectable=0
date1=1720193400
</object>

<object>
type=109
name=2024.07.09 19:00 Perspectives énergétiques à court terme de l’E
hidden=1
descr=Perspectives énergétiques à court terme de l’EIE
color=16119285
selectable=0
date1=1720551600
</object>

<object>
type=109
name=2024.07.08 17:00 Indice CB des tendances de l’emploi
hidden=1
descr=Indice CB des tendances de l’emploi 110.27 / 110.71
color=13353215
selectable=0
date1=1720458000
</object>

<object>
type=109
name=2024.07.08 18:30 Vente aux Enchères de billets de 3 mois
hidden=1
descr=Vente aux Enchères de billets de 3 mois
color=16119285
selectable=0
date1=1720463400
</object>

<object>
type=109
name=2024.07.08 18:30 Vente des enchères de billets de 6 mois
hidden=1
descr=Vente des enchères de billets de 6 mois
color=16119285
selectable=0
date1=1720463400
</object>

<object>
type=109
name=2024.07.08 22:00 Crédit à la consommation de la Réserve Fédéral
hidden=1
descr=Crédit à la consommation de la Réserve Fédérale m/m $11.35 B / 
color=15658671
selectable=0
date1=1720476000
</object>

<object>
type=109
name=2024.07.08 22:30 Positions nettes non commerciales de CFTC Copp
hidden=1
descr=Positions nettes non commerciales de CFTC Copper
color=16119285
selectable=0
date1=1720477800
</object>

<object>
type=109
name=2024.07.08 22:30 Positions nettes non commerciales de CFTC Silv
hidden=1
descr=Positions nettes non commerciales de CFTC Silver
color=16119285
selectable=0
date1=1720477800
</object>

<object>
type=109
name=2024.07.08 22:30 Positions nettes non commerciales de CFTC Gold
hidden=1
descr=Positions nettes non commerciales de CFTC Gold
color=16119285
selectable=0
date1=1720477800
</object>

<object>
type=109
name=2024.07.08 22:30 Positions nettes non commerciales du pétrole b
hidden=1
descr=Positions nettes non commerciales du pétrole brut CFTC
color=16119285
selectable=0
date1=1720477800
</object>

<object>
type=109
name=2024.07.08 22:30 CFTC S&amp;P 500 Positions nettes non commerci
hidden=1
descr=CFTC S&amp;P 500 Positions nettes non commerciales
color=16119285
selectable=0
date1=1720477800
</object>

<object>
type=109
name=2024.07.08 22:30 CFTC Aluminium Positions nettes non commercial
hidden=1
descr=CFTC Aluminium Positions nettes non commerciales
color=16119285
selectable=0
date1=1720477800
</object>

<object>
type=109
name=2024.07.08 22:30 CFTC Positions nettes non commerciales du maïs
hidden=1
descr=CFTC Positions nettes non commerciales du maïs
color=16119285
selectable=0
date1=1720477800
</object>

<object>
type=109
name=2024.07.08 22:30 CFTC Gaz naturel Positions nettes non commerci
hidden=1
descr=CFTC Gaz naturel Positions nettes non commerciales
color=16119285
selectable=0
date1=1720477800
</object>

<object>
type=109
name=2024.07.08 22:30 CFTC Graines de soja Positions nettes non comm
hidden=1
descr=CFTC Graines de soja Positions nettes non commerciales
color=16119285
selectable=0
date1=1720477800
</object>

<object>
type=109
name=2024.07.08 22:30 CFTC Positions nettes non commerciales du blé
hidden=1
descr=CFTC Positions nettes non commerciales du blé
color=16119285
selectable=0
date1=1720477800
</object>

<object>
type=109
name=2024.07.08 22:30 CFTC Nasdaq 100 Positions nettes non commercia
hidden=1
descr=CFTC Nasdaq 100 Positions nettes non commerciales
color=16119285
selectable=0
date1=1720477800
</object>

<object>
type=109
name=2024.07.09 16:15 Discours du Vice-Président Barr de la Fed pour
hidden=1
descr=Discours du Vice-Président Barr de la Fed pour la Supervision
color=16119285
selectable=0
date1=1720541700
</object>

<object>
type=109
name=2024.07.09 17:00 Témoignage du président de la Réserve Fédérale
hidden=1
descr=Témoignage du président de la Réserve Fédérale, M. Powell
color=16119285
selectable=0
date1=1720544400
</object>

<object>
type=109
name=2024.07.09 18:30 Vente des enchères de billets de 52 semaines
hidden=1
descr=Vente des enchères de billets de 52 semaines
color=16119285
selectable=0
date1=1720549800
</object>

<object>
type=109
name=2024.07.09 20:00 Vente des enchères de billets de banque de 3 a
hidden=1
descr=Vente des enchères de billets de banque de 3 ans
color=16119285
selectable=0
date1=1720555200
</object>

<object>
type=109
name=2024.07.09 20:30 Discours du gouverneur de la Réserve Fédérale 
hidden=1
descr=Discours du gouverneur de la Réserve Fédérale Bowman
color=16119285
selectable=0
date1=1720557000
</object>

<object>
type=109
name=2024.07.10 17:00 Stocks des Grossistes m/m
hidden=1
descr=Stocks des Grossistes m/m 0.6% / 0.6%
color=16119285
selectable=0
date1=1720630800
</object>

<object>
type=109
name=2024.07.10 17:00 Ventes en Gros
hidden=1
descr=Ventes en Gros 0.4% / -1.4%
color=15658671
selectable=0
date1=1720630800
</object>

<object>
type=109
name=2024.07.10 17:00 Témoignage du président de la Réserve Fédérale
hidden=1
descr=Témoignage du président de la Réserve Fédérale, M. Powell
color=16119285
selectable=0
date1=1720630800
</object>

<object>
type=109
name=2024.07.10 20:00 Vente des enchères de billets de banque de 10 
hidden=1
descr=Vente des enchères de billets de banque de 10 ans
color=16119285
selectable=0
date1=1720641600
</object>

<object>
type=109
name=2024.07.10 21:30 Discours du gouverneur de la Réserve Fédérale 
hidden=1
descr=Discours du gouverneur de la Réserve Fédérale Bowman
color=16119285
selectable=0
date1=1720647000
</object>

<object>
type=109
name=2024.07.11 02:30 Discours du gouverneur Cook de la Fed
hidden=1
descr=Discours du gouverneur Cook de la Fed
color=16119285
selectable=0
date1=1720665000
</object>

<object>
type=109
name=2024.07.11 15:30 CPI m/m
hidden=1
descr=CPI m/m -0.1% / 0.1%
color=13353215
selectable=0
date1=1720711800
</object>

<object>
type=109
name=2024.07.11 15:30 IPC de base m/m
hidden=1
descr=IPC de base m/m 0.1% / 0.2%
color=13353215
selectable=0
date1=1720711800
</object>

<object>
type=109
name=2024.07.11 15:30 IPC a/a
hidden=1
descr=IPC a/a 3.0% / 3.6%
color=13353215
selectable=0
date1=1720711800
</object>

<object>
type=109
name=2024.07.11 15:30 IPC de base a/a
hidden=1
descr=IPC de base a/a 3.3% / 3.4%
color=13353215
selectable=0
date1=1720711800
</object>

<object>
type=109
name=2024.07.11 15:30 CPI n.s.a.
hidden=1
descr=CPI n.s.a. 314.175 / 314.445
color=13353215
selectable=0
date1=1720711800
</object>

<object>
type=109
name=2024.07.11 15:30 IPC de Base
hidden=1
descr=IPC de Base 318.346 / 318.697
color=13353215
selectable=0
date1=1720711800
</object>

<object>
type=109
name=2024.07.11 15:30 Gains réels m/m
hidden=1
descr=Gains réels m/m 0.3% / 0.0%
color=15658671
selectable=0
date1=1720711800
</object>

<object>
type=109
name=2024.07.11 15:30 CPI n.s.a. m/m
hidden=1
descr=CPI n.s.a. m/m
color=16119285
selectable=0
date1=1720711800
</object>

<object>
type=109
name=2024.07.11 15:30  CPI de base n.s.a. m/m
hidden=1
descr= CPI de base n.s.a. m/m
color=16119285
selectable=0
date1=1720711800
</object>

<object>
type=109
name=2024.07.11 15:30 CPI
hidden=1
descr=CPI 313.049 / 314.124
color=13353215
selectable=0
date1=1720711800
</object>

<object>
type=109
name=2024.07.11 15:30  CPI de base n.s.a.
hidden=1
descr= CPI de base n.s.a.
color=16119285
selectable=0
date1=1720711800
</object>

<object>
type=109
name=2024.07.11 15:30 Allocations Initiales de Chômage
hidden=1
descr=Allocations Initiales de Chômage 222 K / 244 K
color=15658671
selectable=0
date1=1720711800
</object>

<object>
type=109
name=2024.07.11 15:30 Allocations de chômage en continu.
hidden=1
descr=Allocations de chômage en continu. 1.852 M / 1.873 M
color=15658671
selectable=0
date1=1720711800
</object>

<object>
type=109
name=2024.07.11 15:30 Allocations Initiales de Chômage Moyennes sur 
hidden=1
descr=Allocations Initiales de Chômage Moyennes sur 4 semaines 233.50
color=15658671
selectable=0
date1=1720711800
</object>

<object>
type=109
name=2024.07.11 17:30 Changement de stockage de gaz naturel de l’EIA
hidden=1
descr=Changement de stockage de gaz naturel de l’EIA 65 B / 45 B
color=13353215
selectable=0
date1=1720719000
</object>

<object>
type=109
name=2024.07.11 18:00 IPC médian de la Réserve Fédérale de Cleveland
hidden=1
descr=IPC médian de la Réserve Fédérale de Cleveland m/m 0.2% / 0.3%
color=13353215
selectable=0
date1=1720720800
</object>

<object>
type=109
name=2024.07.11 20:00 Vente aux enchères d’obligations à 30 ans
hidden=1
descr=Vente aux enchères d’obligations à 30 ans
color=16119285
selectable=0
date1=1720728000
</object>

<object>
type=109
name=2024.07.11 21:00 Solde Budgétaire Fédéral
hidden=1
descr=Solde Budgétaire Fédéral
color=16119285
selectable=0
date1=1720731600
</object>

<object>
type=109
name=2024.07.12 15:30 PPI m/m
hidden=1
descr=PPI m/m
color=16119285
selectable=0
date1=1720798200
</object>

<object>
type=109
name=2024.07.12 15:30 IPP de base m/m
hidden=1
descr=IPP de base m/m
color=16119285
selectable=0
date1=1720798200
</object>

<object>
type=109
name=2024.07.12 15:30 IPP a/a
hidden=1
descr=IPP a/a
color=16119285
selectable=0
date1=1720798200
</object>

<object>
type=109
name=2024.07.12 15:30 IPP de base a/a
hidden=1
descr=IPP de base a/a
color=16119285
selectable=0
date1=1720798200
</object>

<object>
type=109
name=2024.07.12 17:00 Sentiment des consommateurs du Michigan
hidden=1
descr=Sentiment des consommateurs du Michigan
color=16119285
selectable=0
date1=1720803600
</object>

<object>
type=109
name=2024.07.12 17:00 prévisions des consommateurs du Michigan
hidden=1
descr=prévisions des consommateurs du Michigan
color=16119285
selectable=0
date1=1720803600
</object>

<object>
type=109
name=2024.07.12 17:00 Conditions actuelles du Michigan
hidden=1
descr=Conditions actuelles du Michigan
color=16119285
selectable=0
date1=1720803600
</object>

<object>
type=109
name=2024.07.12 17:00 prévisions d’inflation au Michigan
hidden=1
descr=prévisions d’inflation au Michigan
color=16119285
selectable=0
date1=1720803600
</object>

<object>
type=109
name=2024.07.12 17:00 prévisions d’inflation sur 5 ans au Michigan
hidden=1
descr=prévisions d’inflation sur 5 ans au Michigan
color=16119285
selectable=0
date1=1720803600
</object>

<object>
type=109
name=2024.07.12 19:00 Rapport WASDE
hidden=1
descr=Rapport WASDE
color=16119285
selectable=0
date1=1720810800
</object>

<object>
type=109
name=2024.07.12 20:00 Baker Hughes Nombre de plates-formes pétrolièr
hidden=1
descr=Baker Hughes Nombre de plates-formes pétrolières américaines
color=16119285
selectable=0
date1=1720814400
</object>

<object>
type=109
name=2024.07.12 20:00 Baker Hughes Nombre total de plates-formes aux
hidden=1
descr=Baker Hughes Nombre total de plates-formes aux États-Unis
color=16119285
selectable=0
date1=1720814400
</object>

<object>
type=109
name=2024.07.12 22:30 Positions nettes non commerciales de CFTC Copp
hidden=1
descr=Positions nettes non commerciales de CFTC Copper
color=16119285
selectable=0
date1=1720823400
</object>

<object>
type=109
name=2024.07.12 22:30 Positions nettes non commerciales de CFTC Silv
hidden=1
descr=Positions nettes non commerciales de CFTC Silver
color=16119285
selectable=0
date1=1720823400
</object>

<object>
type=109
name=2024.07.12 22:30 Positions nettes non commerciales de CFTC Gold
hidden=1
descr=Positions nettes non commerciales de CFTC Gold
color=16119285
selectable=0
date1=1720823400
</object>

<object>
type=109
name=2024.07.12 22:30 Positions nettes non commerciales du pétrole b
hidden=1
descr=Positions nettes non commerciales du pétrole brut CFTC
color=16119285
selectable=0
date1=1720823400
</object>

<object>
type=109
name=2024.07.12 22:30 CFTC S&amp;P 500 Positions nettes non commerci
hidden=1
descr=CFTC S&amp;P 500 Positions nettes non commerciales
color=16119285
selectable=0
date1=1720823400
</object>

<object>
type=109
name=2024.07.12 22:30 CFTC Aluminium Positions nettes non commercial
hidden=1
descr=CFTC Aluminium Positions nettes non commerciales
color=16119285
selectable=0
date1=1720823400
</object>

<object>
type=109
name=2024.07.12 22:30 CFTC Positions nettes non commerciales du maïs
hidden=1
descr=CFTC Positions nettes non commerciales du maïs
color=16119285
selectable=0
date1=1720823400
</object>

<object>
type=109
name=2024.07.12 22:30 CFTC Gaz naturel Positions nettes non commerci
hidden=1
descr=CFTC Gaz naturel Positions nettes non commerciales
color=16119285
selectable=0
date1=1720823400
</object>

<object>
type=109
name=2024.07.12 22:30 CFTC Graines de soja Positions nettes non comm
hidden=1
descr=CFTC Graines de soja Positions nettes non commerciales
color=16119285
selectable=0
date1=1720823400
</object>

<object>
type=109
name=2024.07.12 22:30 CFTC Positions nettes non commerciales du blé
hidden=1
descr=CFTC Positions nettes non commerciales du blé
color=16119285
selectable=0
date1=1720823400
</object>

<object>
type=109
name=2024.07.12 22:30 CFTC Nasdaq 100 Positions nettes non commercia
hidden=1
descr=CFTC Nasdaq 100 Positions nettes non commerciales
color=16119285
selectable=0
date1=1720823400
</object>

<object>
type=109
name=2024.07.11 18:30 Vente des enchères de billets de 4 semaines
hidden=1
descr=Vente des enchères de billets de 4 semaines
color=16119285
selectable=0
date1=1720722600
</object>

<object>
type=109
name=2024.07.11 18:30 Vente des enchères de billets de 8 semaines
hidden=1
descr=Vente des enchères de billets de 8 semaines
color=16119285
selectable=0
date1=1720722600
</object>

<object>
type=31
name=autotrade #656608051 buy 0.5 XTIUSD at 82.02, XTIUSD
hidden=1
color=11296515
selectable=0
date1=1719332893
value1=82.020000
</object>

<object>
type=31
name=autotrade #656620413 buy 0.5 XTIUSD at 81.86, XTIUSD
hidden=1
color=11296515
selectable=0
date1=1719333991
value1=81.860000
</object>

<object>
type=32
name=autotrade #656663012 sell 0.5 XTIUSD at 82.34, TP, profit 24.00
hidden=1
descr=[tp 82.34]
color=1918177
selectable=0
date1=1719339626
value1=82.340000
</object>

<object>
type=32
name=autotrade #656663013 sell 0.5 XTIUSD at 82.34, TP, profit 16.00
hidden=1
descr=[tp 82.34]
color=1918177
selectable=0
date1=1719339626
value1=82.340000
</object>

<object>
type=31
name=autotrade #656670693 buy 0.5 XTIUSD at 81.98, XTIUSD
hidden=1
color=11296515
selectable=0
date1=1719340634
value1=81.980000
</object>

<object>
type=32
name=autotrade #656675053 sell 0.5 XTIUSD at 81.65, profit -16.50, X
hidden=1
color=1918177
selectable=0
date1=1719341604
value1=81.650000
</object>

<object>
type=32
name=autotrade #656793871 sell 0.5 XTIUSD at 81.61, XTIUSD
hidden=1
color=1918177
selectable=0
date1=1719399559
value1=81.610000
</object>

<object>
type=32
name=autotrade #656802799 sell 0.5 XTIUSD at 81.57, XTIUSD
hidden=1
color=1918177
selectable=0
date1=1719401829
value1=81.570000
</object>

<object>
type=32
name=autotrade #656806149 sell 0.5 XTIUSD at 81.67, XTIUSD
hidden=1
color=1918177
selectable=0
date1=1719403043
value1=81.670000
</object>

<object>
type=31
name=autotrade #656809176 buy 0.5 XTIUSD at 81.87, profit -10.00, XT
hidden=1
color=11296515
selectable=0
date1=1719404279
value1=81.870000
</object>

<object>
type=31
name=autotrade #656809182 buy 0.5 XTIUSD at 81.87, profit -15.00, XT
hidden=1
color=11296515
selectable=0
date1=1719404280
value1=81.870000
</object>

<object>
type=31
name=autotrade #656809193 buy 0.5 XTIUSD at 81.87, profit -13.00, XT
hidden=1
color=11296515
selectable=0
date1=1719404283
value1=81.870000
</object>

<object>
type=32
name=autotrade #656840615 sell 0.5 XTIUSD at 81.91, XTIUSD
hidden=1
color=1918177
selectable=0
date1=1719410896
value1=81.910000
</object>

<object>
type=31
name=autotrade #656858263 buy 0.5 XTIUSD at 81.88, SL, profit 1.50, 
hidden=1
descr=[sl 81.88]
color=11296515
selectable=0
date1=1719414235
value1=81.880000
</object>

<object>
type=32
name=autotrade #656862252 sell 0.5 XTIUSD at 81.89, XTIUSD
hidden=1
color=1918177
selectable=0
date1=1719414973
value1=81.890000
</object>

<object>
type=31
name=autotrade #656864165 buy 0.5 XTIUSD at 81.99, profit -5.00, XTI
hidden=1
color=11296515
selectable=0
date1=1719415387
value1=81.990000
</object>

<object>
type=31
name=autotrade #657031222 buy 0.5 XTIUSD at 81.32, XTIUSD
hidden=1
color=11296515
selectable=0
date1=1719477849
value1=81.320000
</object>

<object>
type=32
name=autotrade #657074441 sell 0.5 XTIUSD at 81.94, TP, profit 31.00
hidden=1
descr=[tp 81.94]
color=1918177
selectable=0
date1=1719490211
value1=81.940000
</object>

<object>
type=31
name=autotrade #657097264 buy 0.5 XTIUSD at 81.81, XTIUSD
hidden=1
color=11296515
selectable=0
date1=1719495710
value1=81.810000
</object>

<object>
type=32
name=autotrade #657148467 sell 0.5 XTIUSD at 82.45, TP, profit 32.00
hidden=1
descr=[tp 82.45]
color=1918177
selectable=0
date1=1719504338
value1=82.450000
</object>

<object>
type=32
name=autotrade #657383490 sell 0.5 XTIUSD at 82.71, XTIUSD
hidden=1
color=1918177
selectable=0
date1=1719588606
value1=82.710000
</object>

<object>
type=31
name=autotrade #657432707 buy 0.5 XTIUSD at 81.97, TP, profit 37.00,
hidden=1
descr=[tp 81.97]
color=11296515
selectable=0
date1=1719593948
value1=81.970000
</object>

<object>
type=31
name=autotrade #657601952 buy 0.5 XTIUSD at 82.39, XTIUSD
hidden=1
color=11296515
selectable=0
date1=1719822339
value1=82.390000
</object>

<object>
type=31
name=autotrade #657685172 buy 0.5 XTIUSD at 82.51, XTIUSD
hidden=1
color=11296515
selectable=0
date1=1719844090
value1=82.510000
</object>

<object>
type=32
name=autotrade #657728177 sell 0.5 XTIUSD at 82.72, TP, profit 16.50
hidden=1
descr=[tp 82.73]
color=1918177
selectable=0
date1=1719851870
value1=82.720000
</object>

<object>
type=32
name=autotrade #657728776 sell 0.5 XTIUSD at 82.71, profit 10.00, XT
hidden=1
color=1918177
selectable=0
date1=1719851935
value1=82.710000
</object>

<object>
type=31
name=autotrade #657880715 buy 0.5 XTIUSD at 84.00, XTIUSD
hidden=1
color=11296515
selectable=0
date1=1719911091
value1=84.000000
</object>

<object>
type=32
name=autotrade #657895268 sell 0.5 XTIUSD at 83.81, profit -9.50, XT
hidden=1
color=1918177
selectable=0
date1=1719915500
value1=83.810000
</object>

<object>
type=32
name=autotrade #657902286 sell 0.5 XTIUSD at 83.76, XTIUSD
hidden=1
color=1918177
selectable=0
date1=1719916805
value1=83.760000
</object>

<object>
type=31
name=autotrade #657912891 buy 0.5 XTIUSD at 84.01, profit -12.50, XT
hidden=1
color=11296515
selectable=0
date1=1719918884
value1=84.010000
</object>

<object>
type=31
name=autotrade #657918458 buy 0.5 XTIUSD at 84.31, XTIUSD
hidden=1
color=11296515
selectable=0
date1=1719920175
value1=84.310000
</object>

<object>
type=32
name=autotrade #657924898 sell 0.5 XTIUSD at 84.33, SL, profit 1.00,
hidden=1
descr=[sl 84.32]
color=1918177
selectable=0
date1=1719921786
value1=84.330000
</object>

<object>
type=31
name=autotrade #658273374 buy 0.5 XTIUSD at 83.36, XTIUSD
hidden=1
color=11296515
selectable=0
date1=1720020902
value1=83.360000
</object>

<object>
type=31
name=autotrade #658274261 buy 0.5 XTIUSD at 83.36, XTIUSD
hidden=1
color=11296515
selectable=0
date1=1720020956
value1=83.360000
</object>

<object>
type=32
name=autotrade #658352877 sell 0.5 XTIUSD at 83.82, TP, profit 23.00
hidden=1
descr=[tp 83.83]
color=1918177
selectable=0
date1=1720027804
value1=83.820000
</object>

<object>
type=32
name=autotrade #658410835 sell 0.5 XTIUSD at 83.42, profit 3.00, XTI
hidden=1
color=1918177
selectable=0
date1=1720035080
value1=83.420000
</object>

<object>
type=31
name=autotrade #658521450 buy 1 XTIUSD at 83.69, XTIUSD
hidden=1
color=11296515
selectable=0
date1=1720093843
value1=83.690000
</object>

<object>
type=32
name=autotrade #658588013 sell 1 XTIUSD at 84.24, TP, profit 55.00, 
hidden=1
descr=[tp 84.24]
color=1918177
selectable=0
date1=1720115374
value1=84.240000
</object>

<object>
type=31
name=autotrade #658609589 buy 1 XTIUSD at 84.30, XTIUSD
hidden=1
color=11296515
selectable=0
date1=1720122258
value1=84.300000
</object>

<object>
type=32
name=autotrade #658614480 sell 1 XTIUSD at 84.52, profit 22.00, XTIU
hidden=1
color=1918177
selectable=0
date1=1720126572
value1=84.520000
</object>

<object>
type=32
name=autotrade #658727818 sell 1 XTIUSD at 84.21, XTIUSD
hidden=1
color=1918177
selectable=0
date1=1720183808
value1=84.210000
</object>

<object>
type=31
name=autotrade #658740391 buy 1 XTIUSD at 84.29, profit -8.00, XTIUS
hidden=1
color=11296515
selectable=0
date1=1720187426
value1=84.290000
</object>

<object>
type=31
name=autotrade #658796430 buy 1 XTIUSD at 84.36, XTIUSD
hidden=1
color=11296515
selectable=0
date1=1720194309
value1=84.360000
</object>

<object>
type=31
name=autotrade #658801045 buy 1 XTIUSD at 84.29, XTIUSD
hidden=1
color=11296515
selectable=0
date1=1720194850
value1=84.290000
</object>

<object>
type=32
name=autotrade #658871938 sell 1 XTIUSD at 84.66, TP, profit 30.00, 
hidden=1
descr=[tp 84.65]
color=1918177
selectable=0
date1=1720202870
value1=84.660000
</object>

<object>
type=32
name=autotrade #658883124 sell 1 XTIUSD at 84.73, profit 44.00, XTIU
hidden=1
color=1918177
selectable=0
date1=1720204563
value1=84.730000
</object>

<object>
type=31
name=autotrade #659132640 buy 1 XTIUSD at 82.83, XTIUSD
hidden=1
color=11296515
selectable=0
date1=1720451566
value1=82.830000
</object>

<object>
type=31
name=autotrade #659132852 buy 1 XTIUSD at 82.90, XTIUSD
hidden=1
color=11296515
selectable=0
date1=1720451647
value1=82.900000
</object>

<object>
type=31
name=autotrade #659132855 buy 1 XTIUSD at 82.90, XTIUSD
hidden=1
color=11296515
selectable=0
date1=1720451648
value1=82.900000
</object>

<object>
type=32
name=autotrade #659920582 sell 1 XTIUSD at 82.90, profit 0.00, XTIUS
hidden=1
color=1918177
selectable=0
date1=1720691854
value1=82.900000
</object>

<object>
type=32
name=autotrade #659920585 sell 1 XTIUSD at 82.90, profit 0.00, XTIUS
hidden=1
color=1918177
selectable=0
date1=1720691855
value1=82.900000
</object>

<object>
type=31
name=autotrade #660000165 buy 1 XTIUSD at 82.75, XTIUSD
hidden=1
color=11296515
selectable=0
date1=1720711815
value1=82.750000
</object>

<object>
type=31
name=autotrade #660054675 buy 1 XTIUSD at 82.67, XTIUSD
hidden=1
color=11296515
selectable=0
date1=1720714210
value1=82.670000
</object>

<object>
type=32
name=autotrade #660190803 sell 1 XTIUSD at 82.81, profit -2.00, XTIU
hidden=1
color=1918177
selectable=0
date1=1720731117
value1=82.810000
</object>

<object>
type=32
name=autotrade #660190804 sell 1 XTIUSD at 82.81, profit 6.00, XTIUS
hidden=1
color=1918177
selectable=0
date1=1720731118
value1=82.810000
</object>

<object>
type=32
name=autotrade #660190809 sell 1 XTIUSD at 82.81, profit 14.00, XTIU
hidden=1
color=1918177
selectable=0
date1=1720731119
value1=82.810000
</object>

<object>
type=32
name=autotrade #660256118 sell 0.5 XTIUSD at 83.08, XTIUSD
hidden=1
color=1918177
selectable=0
date1=1720769532
value1=83.080000
</object>

<object>
type=32
name=autotrade #660256155 sell 1 XTIUSD at 83.08, XTIUSD
hidden=1
color=1918177
selectable=0
date1=1720769566
value1=83.080000
</object>

<object>
type=32
name=autotrade #660256172 sell 1 XTIUSD at 83.07, XTIUSD
hidden=1
color=1918177
selectable=0
date1=1720769581
value1=83.070000
</object>

<object>
type=2
name=autotrade #656608051 -> #656663013, TP, profit 16.00, XTIUSD
hidden=1
descr=82.02 -> 82.34
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1719332893
date2=1719339626
value1=82.020000
value2=82.340000
</object>

<object>
type=2
name=autotrade #656620413 -> #656663012, TP, profit 24.00, XTIUSD
hidden=1
descr=81.86 -> 82.34
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1719333991
date2=1719339626
value1=81.860000
value2=82.340000
</object>

<object>
type=2
name=autotrade #656670693 -> #656675053, profit -16.50, XTIUSD
hidden=1
descr=81.98 -> 81.65
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1719340634
date2=1719341604
value1=81.980000
value2=81.650000
</object>

<object>
type=2
name=autotrade #656793871 -> #656809193, profit -13.00, XTIUSD
hidden=1
descr=81.61 -> 81.87
color=1918177
style=2
selectable=0
ray1=0
ray2=0
date1=1719399559
date2=1719404283
value1=81.610000
value2=81.870000
</object>

<object>
type=2
name=autotrade #656802799 -> #656809182, profit -15.00, XTIUSD
hidden=1
descr=81.57 -> 81.87
color=1918177
style=2
selectable=0
ray1=0
ray2=0
date1=1719401829
date2=1719404280
value1=81.570000
value2=81.870000
</object>

<object>
type=2
name=autotrade #656806149 -> #656809176, profit -10.00, XTIUSD
hidden=1
descr=81.67 -> 81.87
color=1918177
style=2
selectable=0
ray1=0
ray2=0
date1=1719403043
date2=1719404279
value1=81.670000
value2=81.870000
</object>

<object>
type=2
name=autotrade #656840615 -> #656858263, SL, profit 1.50, XTIUSD
hidden=1
descr=81.91 -> 81.88
color=1918177
style=2
selectable=0
ray1=0
ray2=0
date1=1719410896
date2=1719414235
value1=81.910000
value2=81.880000
</object>

<object>
type=2
name=autotrade #656862252 -> #656864165, profit -5.00, XTIUSD
hidden=1
descr=81.89 -> 81.99
color=1918177
style=2
selectable=0
ray1=0
ray2=0
date1=1719414973
date2=1719415387
value1=81.890000
value2=81.990000
</object>

<object>
type=2
name=autotrade #657031222 -> #657074441, TP, profit 31.00, XTIUSD
hidden=1
descr=81.32 -> 81.94
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1719477849
date2=1719490211
value1=81.320000
value2=81.940000
</object>

<object>
type=2
name=autotrade #657097264 -> #657148467, TP, profit 32.00, XTIUSD
hidden=1
descr=81.81 -> 82.45
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1719495710
date2=1719504338
value1=81.810000
value2=82.450000
</object>

<object>
type=2
name=autotrade #657383490 -> #657432707, TP, profit 37.00, XTIUSD
hidden=1
descr=82.71 -> 81.97
color=1918177
style=2
selectable=0
ray1=0
ray2=0
date1=1719588606
date2=1719593948
value1=82.710000
value2=81.970000
</object>

<object>
type=2
name=autotrade #657601952 -> #657728177, TP, profit 16.50, XTIUSD
hidden=1
descr=82.39 -> 82.72
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1719822339
date2=1719851870
value1=82.390000
value2=82.720000
</object>

<object>
type=2
name=autotrade #657685172 -> #657728776, profit 10.00, XTIUSD
hidden=1
descr=82.51 -> 82.71
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1719844090
date2=1719851935
value1=82.510000
value2=82.710000
</object>

<object>
type=2
name=autotrade #657880715 -> #657895268, profit -9.50, XTIUSD
hidden=1
descr=84.00 -> 83.81
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1719911091
date2=1719915500
value1=84.000000
value2=83.810000
</object>

<object>
type=2
name=autotrade #657902286 -> #657912891, profit -12.50, XTIUSD
hidden=1
descr=83.76 -> 84.01
color=1918177
style=2
selectable=0
ray1=0
ray2=0
date1=1719916805
date2=1719918884
value1=83.760000
value2=84.010000
</object>

<object>
type=2
name=autotrade #657918458 -> #657924898, SL, profit 1.00, XTIUSD
hidden=1
descr=84.31 -> 84.33
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1719920175
date2=1719921786
value1=84.310000
value2=84.330000
</object>

<object>
type=2
name=autotrade #658273374 -> #658352877, TP, profit 23.00, XTIUSD
hidden=1
descr=83.36 -> 83.82
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1720020902
date2=1720027804
value1=83.360000
value2=83.820000
</object>

<object>
type=2
name=autotrade #658274261 -> #658410835, profit 3.00, XTIUSD
hidden=1
descr=83.36 -> 83.42
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1720020956
date2=1720035080
value1=83.360000
value2=83.420000
</object>

<object>
type=2
name=autotrade #658521450 -> #658588013, TP, profit 55.00, XTIUSD
hidden=1
descr=83.69 -> 84.24
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1720093843
date2=1720115374
value1=83.690000
value2=84.240000
</object>

<object>
type=2
name=autotrade #658609589 -> #658614480, profit 22.00, XTIUSD
hidden=1
descr=84.30 -> 84.52
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1720122258
date2=1720126572
value1=84.300000
value2=84.520000
</object>

<object>
type=2
name=autotrade #658727818 -> #658740391, profit -8.00, XTIUSD
hidden=1
descr=84.21 -> 84.29
color=1918177
style=2
selectable=0
ray1=0
ray2=0
date1=1720183808
date2=1720187426
value1=84.210000
value2=84.290000
</object>

<object>
type=2
name=autotrade #658796430 -> #658871938, TP, profit 30.00, XTIUSD
hidden=1
descr=84.36 -> 84.66
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1720194309
date2=1720202870
value1=84.360000
value2=84.660000
</object>

<object>
type=2
name=autotrade #658801045 -> #658883124, profit 44.00, XTIUSD
hidden=1
descr=84.29 -> 84.73
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1720194850
date2=1720204563
value1=84.290000
value2=84.730000
</object>

<object>
type=2
name=autotrade #659132640 -> #660190803, profit -2.00, XTIUSD
hidden=1
descr=82.83 -> 82.81
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1720451566
date2=1720731117
value1=82.830000
value2=82.810000
</object>

<object>
type=2
name=autotrade #659132852 -> #659920585, profit 0.00, XTIUSD
hidden=1
descr=82.90 -> 82.90
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1720451647
date2=1720691855
value1=82.900000
value2=82.900000
</object>

<object>
type=2
name=autotrade #659132855 -> #659920582, profit 0.00, XTIUSD
hidden=1
descr=82.90 -> 82.90
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1720451648
date2=1720691854
value1=82.900000
value2=82.900000
</object>

<object>
type=2
name=autotrade #660000165 -> #660190804, profit 6.00, XTIUSD
hidden=1
descr=82.75 -> 82.81
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1720711815
date2=1720731118
value1=82.750000
value2=82.810000
</object>

<object>
type=2
name=autotrade #660054675 -> #660190809, profit 14.00, XTIUSD
hidden=1
descr=82.67 -> 82.81
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1720714210
date2=1720731119
value1=82.670000
value2=82.810000
</object>

<object>
type=102
name=Spread
hidden=1
descr=Spread: 2 points
color=8388736
selectable=0
angle=0
pos_x=10
pos_y=50
fontsz=15
fontnm=Arial
anchorpos=5
refpoint=2
</object>

<object>
type=101
name=CandleTimer
hidden=1
descr=1:09
color=7451452
selectable=0
angle=0
date1=1720778400
value1=83.409750
fontsz=10
fontnm=Arial
anchorpos=0
</object>

</window>
</chart>