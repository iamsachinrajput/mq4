#property copyright "by Sachin Rajput(iamsachinrajput@gmail.com)"
#property version   "2.01"
#property strict
#property description "INPUTS allowed "
                       "\nindicators_touse:,macd,rsi,rsi_macd,"
                       "\nwhentobuysell:,none,macd(up/down),rsi(up/down/zigzag),mkt(up/down/zigzag),"
                       "\nwhentosqoff=,levelchange,"
                       "|profit_method=perlotsize,fullorder"
                       "\nskpoints_gap= for eurousd=10,for btcusd=100,"
                       "|howtoclose=,tp,sl,all"
                       "\nlotsize_increase=self_ordercount,other_ordercount,level&1,level&level,level&level-1,level-1&level"
                       "\nbuysell_conditions=,ma,gapupbuy,gapdownbuy,gapupsell,gapdownsell,zoneswitch,smax,smin,sklevel,"
                       "\nskdebuglevel=check1,comp1,supp1,err,oinfo,close1,onew" ;
