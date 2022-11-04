//+------------------------------------------------------------------+
//|                                                     sell&buy.mq4 |
//+------------------------------------------------------------------+

extern double lots=0.01;
extern double targetsingle=4;
extern double targetperlot=1;
extern bool close_all_together=False;

int cbars=0;
int magic=9348670;
int dist=24;
extern double martingle=1;
extern string reverseinput=False;
double lots_tobuy=0;
double lots_tosell=0;
double target=0;
double profit_buylots,profit_selllots,total_buylots,total_selllots,target_buy,target_sell;
double indrsi,indsar,sigup,sigdown;
string skaction="none";



double calculate_lot_size(double lastlots)
   {
   double returnvalue=0;
   
   returnvalue=lastlots*martingle;
   if(martingle == 1)
   returnvalue=lastlots  + lots;
   if(martingle == 0)
   returnvalue=lots;
   
   if(returnvalue==0)
   returnvalue=lots;
   return(returnvalue);
   
   }

string action_on_rsi(int rsibars,int rsidownlevel,int rsiuplevel)
   {
   string returnvalue="none";
    indrsi=iRSI(NULL,0,rsibars,PRICE_CLOSE,0);
    if( ( indrsi>50 && indrsi<rsiuplevel ) || indrsi<rsidownlevel )
      returnvalue="buy";
    else if( ( indrsi<50 && indrsi>rsidownlevel ) ||  indrsi>rsiuplevel )
      returnvalue="sell";
   return(returnvalue);
   }
   
string action_on_sar()
   {
   string returnvalue="none";
 indsar=iSAR(NULL,0,0.02,0.2,0);
    if( indsar < Close[0] )
      returnvalue="buy";
    else if( indsar < Close[0])
      returnvalue="sell";
   return(returnvalue);
   }

   
string action_on_macd(int input12,int input26,int input9)
   {
   string returnvalue="none";
double indmacd=iMACD(NULL,0,input12,input26,input9,PRICE_CLOSE,MODE_MAIN,0);
double indmacd_sig=iMACD(NULL,0,input12,input26,input9,PRICE_CLOSE,MODE_SIGNAL,0);
double indmacd_prev=iMACD(NULL,0,input12,input26,input9,PRICE_CLOSE,MODE_MAIN,1);
double indmacd_sig_prev=iMACD(NULL,0,input12,input26,input9,PRICE_CLOSE,MODE_SIGNAL,1);
    if( indmacd > indmacd_sig  && indmacd_prev < indmacd_sig_prev)
      returnvalue="buy";
    else if( indmacd < indmacd_sig && indmacd_prev > indmacd_sig_prev )
      returnvalue="sell";
   return(returnvalue);
   }
   
string action_on_atr(int atrsmall,int atrbig)
   {
   string returnvalue="none";
double indatr1=iATR(NULL,0,atrsmall,0);
double indatr2=iATR(NULL,0,atrbig,0);
    if( indatr1 > indatr2 )
      returnvalue="onesided";
    else if( indatr1 < indatr2)
      returnvalue="zigzag";
   return(returnvalue);
   }

string action_on_highlow()
   {
   string returnvalue="none";
    if( Highest(NULL,0,MODE_HIGH,dist,0) ==1 )
      returnvalue="buy";
    else if( Lowest(NULL,0,MODE_LOW,dist,0) ==1 )
      returnvalue="sell";
   return(returnvalue);
   }





int start() {


double reverse=reverseinput;


// find wheather to buy or sell 

skaction=action_on_macd(12,26,9);


//action change based on reverse input signal 
if(reverseinput=="auto" )
  // if(MathMod(int(OrdersTotal()/20),2) ==1 )
   if(action_on_atr(12,20) == "zigzag" )
      reverse=False;
      else
         reverse=True;

if(reverse==True)
{
if(skaction=="buy")
   skaction="sell";
   else if(skaction=="sell")
      skaction="buy";
}

double profit=0;
// calculate profit 
int j=OrdersTotal()-1;
profit_selllots=0;
profit_buylots=0;
total_buylots=0;
total_selllots=0;

 for (int i=j;i>=0;i--)
  {
   OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
     if(OrderType()==OP_BUY && OrderMagicNumber()==magic && OrderSymbol()==Symbol())
      {
      profit_buylots+=OrderProfit()+OrderSwap();
      total_buylots+=OrderLots();
      }
     if(OrderType()==OP_SELL && OrderMagicNumber()==magic && OrderSymbol()==Symbol())
      {
      profit_selllots+=OrderProfit()+OrderSwap();
      total_selllots+=OrderLots();
      }
  }


//   close_all_together=False;



// calculate target based on current open lots 
   target_buy=targetsingle;
   target_sell=targetsingle;

if(targetperlot>0 )
   {
      target_buy=targetperlot*total_buylots*100;
      target_sell=targetperlot*total_selllots*100;
   }
 
 // make a new buy if sig=1
 if(cbars!=Bars && skaction=="buy")
  {
   printf("profit = " + (profit_buylots+profit_selllots) ) ;
   RefreshRates();
   lots_tobuy=calculate_lot_size(lots_tobuy);
   OrderSend(Symbol(),OP_BUY,lots_tobuy,Ask,3,0,0,"buy",magic,0,Blue);
   string AN="ArrBuy "+TimeToStr(CurTime());
   ObjectCreate(AN,OBJ_ARROW,0,Time[1],Low[1]-6*Point,0,0,0,0);
   ObjectSet(AN, OBJPROP_ARROWCODE, 233);
   ObjectSet(AN, OBJPROP_COLOR , Blue);
  }


 // new sell order if signal 
 if(cbars!=Bars && skaction=="sell")
  {
   printf("profit = " + (profit_buylots+profit_selllots) ) ;
   RefreshRates();
   lots_tosell=calculate_lot_size(lots_tosell);
   lots_tobuy=calculate_lot_size(lots_tobuy);
   OrderSend(Symbol(),OP_SELL,lots_tobuy,Bid,3,0,0,"sell",magic,0,Magenta);
   AN="ArrSell "+TimeToStr(CurTime());
   ObjectCreate(AN,OBJ_ARROW,0,Time[1],High[1]+6*Point,0,0,0,0);
   ObjectSet(AN, OBJPROP_ARROWCODE, 234);
   ObjectSet(AN, OBJPROP_COLOR , Magenta);
  }
  
 // close if buy profit more then target
 if (profit_buylots>target_buy && close_all_together==False)
  {
   lots_tobuy=0;
   j=OrdersTotal()-1;
   for (i=j;i>=0;i--)
    {
     OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
     RefreshRates();
     if(OrderType()==OP_BUY && OrderMagicNumber()==magic && OrderSymbol()==Symbol())
      OrderClose(OrderTicket(),OrderLots(),Bid,3,Blue);
    }
  }
 
 // close sell positions if profit more then target 
 if (profit_selllots>target_sell && close_all_together==False)
  {
   j=OrdersTotal()-1;
   lots_tosell=0;
   for (i=j;i>=0;i--)
    {
     OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
     RefreshRates();
     if(OrderType()==OP_SELL && OrderMagicNumber()==magic && OrderSymbol()==Symbol())
      OrderClose(OrderTicket(),OrderLots(),Ask,3,Magenta);
    }
  } 
  
  // close all positions if profit more then target 
 if ((profit_selllots+profit_buylots)>(target_buy+target_sell)/2 && close_all_together==True )
  {
   j=OrdersTotal()-1;
   lots_tosell=0;
   for (i=j;i>=0;i--)
    {
     OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
     RefreshRates();
     if(OrderType()==OP_SELL && OrderMagicNumber()==magic && OrderSymbol()==Symbol())
      OrderClose(OrderTicket(),OrderLots(),Ask,3,Magenta);
     if(OrderType()==OP_BUY && OrderMagicNumber()==magic && OrderSymbol()==Symbol())
      OrderClose(OrderTicket(),OrderLots(),Bid,3,Blue);
    }
  }
 


 cbars=Bars;
 string skmsg=  " equity ="+AccountEquity()+" pft="+AccountProfit() 
               + " lots buy="+total_buylots + "target_buy:"+target_buy + " profit_buylots:"+profit_buylots
               +" sell="+total_selllots + " target_sell:"+target_sell + " profit_selllots:"+ profit_selllots
               +" orders="+OrdersTotal()+" reverse="+ reverse 
               +" Ask="+Ask+" Bid="+Bid+" Rsi="+indrsi +" Sar="+indsar
 
        ; 
 
 Comment(skmsg);
 
 return(0);
}