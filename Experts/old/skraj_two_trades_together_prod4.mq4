#property copyright "Sachin Rajput"
#property version   "2.00"
#property strict
#include <stdlib.mqh>
//INPUTS 
   input double sktakeprofit=2;
   input int sklevel_gap=2;
   input double sksl=500;
   input int losspositionsupport=3;
   input double supportiflossinr=2;
   input double Lots = 0.01;
   input int maxlots = 20;
   input int onprofit_quit_or_trail = 1;
   input int increaselots=1;
   input int increaselots_support=1;
   input int maxlots_check_foreachorder=0;
   input double linegap=0;
   input int complementry_order=3;
   input int quickstart=3;
   input bool closeallcondition=False;
   input string skdebuglevel="check1,comp1,supp1,err,oinfo,close1,onew";
      int buysellstrategy=1;
       int alwayscomporder=1;
       int band_length=24;
       int band_deviation=2;
       double maxloss_allowed_inr=1000;
       double maxloss_perday_inr=10;
       int sksleeptime=500;
       int modifyorderinloss=0;
       double minprofitinr=3;
       int buyselltogether=0;
       int onloss_action=0;
       int opening_balance=0;
       int skbuy_lotsize=0, sksell_lotsize=0;
       int lastbuy_order=0,lastsell_order=0;

       double lastbuy_lots=0,lastsell_lots=0;
       string ordercomment="";
       int tp=0,sl=0,tpr=0,slr=0;
       double sklevel_newup,sklevel_newdown;
       string lastaction="";
       bool sklevel_switched=False;
       double sklevel_up_value=0,sklevel_down_value=0;
        int sklevel_gap_touse=sklevel_gap;
        bool oktotrade=True;

 
   
// debug string constants 
   const string dbgsqoff="sqoff";
   const string dbgonew="onew";
   const string dbgoinfo="oinfo";
   const string dbgerr="err";
   const string dbgmodify1="modify1";
   const string dbgmodify2="modify2";
   const string dbgcomp1="comp1";
   const string dbgcomp2="comp2";
   const string dbgsupport1="supp1";
   const string dbgsupport2="supp2";
   const string dbgclose1="close1";
   const string dbgclose2="close2";
   const string dbgcheck1="check1";
   const string dbgcheck2="check2";

//end inputs

// Variables 
   int n = 10;
   double usdtopoints=.001;
   int totalorderscount=0;
   int total=0;
   int MagicNumber = 2808;
   int Slippage = 30;
   int POPYTKY = 10;
   bool  gbDisabled = False;
   datetime currenttime=TimeCurrent();
   datetime lastupdatedtime=TimeCurrent();
   string randomname;
   double minpricegap=1.5*MarketInfo( Symbol(), MODE_STOPLEVEL )*Point();
   int sklevel=0,sklevel_prev=0 , sklevel_current=0;
   double sklevel_start_price=0 , sklevel_lotsize=0,sklevel_lotsize2=0;
//end variables

//+----------------------------

   double  ma=iMA(NULL,0,5,2,MODE_SMA,PRICE_CLOSE,0);
   double smax=iBands(NULL,0,band_length,band_deviation,0,PRICE_CLOSE,MODE_UPPER,0);
	double smin=iBands(NULL,0,band_length,band_deviation,0,PRICE_CLOSE,MODE_LOWER,0);

void init()
{

      if(Symbol()=="BTCUSD")
       usdtopoints=100;  
       int opening_balance=AccountBalance();

}


void skdebug(string msg1, string level)
   {
      //if(level <=skdebuglevel)
      if(StringFind(skdebuglevel,level) >=0 ) 
         Print( Bars,":",Ask," ",msg1," ",level);
    }

bool check_buy_conditions()
   {
      bool buy_0=True,buy_1;

      if(buysellstrategy==1)
         if(Open[1]<ma && Close[1]>ma)
            buy_1=True;
      if(buysellstrategy==2)
         if(Close[1]>smax)
            buy_1=True;
      return(buy_0 && buy_1);
   }

void skcloseorder(int tickettoclose)
   {
      if(onprofit_quit_or_trail==1 || OrderProfit()<0 )
         {
            //close the order 
            skdebug("will sqoff order # "+tickettoclose+" in loss "+OrderProfit() , dbgsqoff);
            if(OrderType()==OP_BUY)
            OrderClose(tickettoclose,OrderLots(),Ask,Slippage,clrAqua);
            if(OrderType()==OP_SELL)
            OrderClose(tickettoclose,OrderLots(),Bid,Slippage,clrAqua);
         }
      else   
      if(onprofit_quit_or_trail==2)
         {
            //modify stoploss
            //double trailprofit=int(OrderProfit()/sktakeprofit)*sktakeprofit*Point();
            double trailprofit=(int(OrderProfit()/sktakeprofit))*sktakeprofit*usdtopoints;
            double newsl_sell=OrderOpenPrice() - trailprofit+minpricegap*2;
            double newsl_buy=OrderOpenPrice() + trailprofit-minpricegap*2;
            if(OrderType()==OP_SELL) 
               {
                  if(OrderStopLoss()>newsl_sell )
                     { 
                        skdebug("For sell Order # "+tickettoclose+" setting newsl ="+newsl_sell+ " CrPrice="+Ask+" lastsl="+OrderStopLoss(),dbgclose2);
                        skdebug( " trailprofit="+trailprofit+" OrderProfit="+OrderProfit()+" sktakeprofit="+sktakeprofit+" point="+Point()
                        + " usdtopoints="+usdtopoints +" minpricegap="+minpricegap ,dbgclose2);
                        if(OrderModify(tickettoclose,OrderOpenPrice(),newsl_sell,0,0,clrRed) )
                           { skdebug("Order #"+OrderTicket()+" modified with newsl="+newsl_sell,dbgmodify1); }
                         else
                           {
                           skdebug("Order #"+OrderTicket()+" modification failed with newsl="+newsl_sell,dbgmodify2);
                           if(StringFind(skdebuglevel,dbgoinfo) >=0) OrderPrint();
                           }
                         
                     }
                    else
                     {
                        skdebug("current SL of order #"+tickettoclose+" = "+ OrderStopLoss()+" is better then new sl "+newsl_sell, dbgsqoff);
                     }
               }
            if(OrderType()==OP_BUY) 
               {
                  if(OrderStopLoss()>newsl_buy )
                  {
                  skdebug("For buy Order # "+ tickettoclose+" setting newsl ="+newsl_buy+ ", CrPrice="+Bid+" lastsl="+OrderStopLoss(),dbgclose2);
                  if(OrderModify(tickettoclose,OrderOpenPrice(),newsl_buy,0,0,clrGreen) )
                        skdebug("Order #"+OrderTicket()+" modified with newsl_buy="+newsl_buy,dbgmodify1);
                      else
                      {
                        skdebug("Order #"+OrderTicket()+" modification failed with newsl_buy="+newsl_buy,dbgmodify2);
                        if(StringFind(skdebuglevel,dbgoinfo) >=0) OrderPrint();
                      }

                  }
                    else
                     {
                        skdebug("current SL of order #"+tickettoclose+" = "+ OrderStopLoss()+" is better then new sl"+ newsl_sell,4);
                     }
               }
               
         }
      }


bool check_sell_conditions()
   {
      bool sell_0=True,sell_1;
      if(buysellstrategy==1)
         if(Open[1]>ma && Close[1]<ma)
            sell_1=True;
      if(buysellstrategy==2)
         if(Close[1]<smin)
            sell_1=True;

      return(sell_0 && sell_1);
   }

 double get_pip_value()
   {
     double returnvalue=.0001;
     if(Symbol()=="BTCUSD")
         returnvalue=.01;
     skdebug(Symbol()+" ki Pipvalue="+returnvalue,7);
     return(returnvalue);
   }


int skbothordersopen(string commenttocheck,int skorderid)
   {
         int ii,kk,count=0,skorderid2=0;
         //kk=OrdersTotal();
         kk=CalculateCurrentOrders();
         skdebug("str to check:"+commenttocheck,7);
         for(ii=0; ii<kk; ii++)
         {
            if(OrderSelect(ii, SELECT_BY_POS, MODE_TRADES))
            {
               if(OrderSymbol()==Symbol() && (OrderMagicNumber()==MagicNumber))
               { 
                  skdebug("comment in order :"+OrderComment(),dbgcheck2);
                  if(OrderComment()==commenttocheck)
                     if(OrderTicket()!=skorderid)
                        {
                        skorderid2=OrderTicket();
                        skdebug("two orders for comment :"+commenttocheck+"= "+skorderid+" & "+ skorderid2,dbgcheck1);
                        }
                     //count++;
               }
            }
            }
         skdebug("str to check:"+commenttocheck+"|count:"+count,9);
      return(skorderid2);
   }

int iscomplementry_open(string commenttocheck,int skorderid)
   {
         int ii,kk;
         bool return_value;
         string ccc="c_"+commenttocheck;
         kk=CalculateCurrentOrders();

         skdebug("str to check:"+commenttocheck,7);
         for(ii=0; ii<kk; ii++)
         {
            if(OrderSelect(ii, SELECT_BY_POS, MODE_TRADES))
            {
               if(OrderSymbol()==Symbol() && (OrderMagicNumber()==MagicNumber))
               { 
                  skdebug("comment in order :"+OrderComment(),dbgcheck2);
                  if(StringFind(OrderComment(),ccc) >=0 )
                        {
                        return_value=True;
                        }
               }
            }
            }
      return(return_value);
   }


int getsupportorderid(string commenttocheck,int skorderid)
   {
         int ii,kk,count=0,skorderid2=0;
         kk=CalculateCurrentOrders();
         string current_comment;

         skdebug("str to check:"+commenttocheck,8);
         for(ii=0; ii<kk; ii++)
         {
            if(OrderSelect(ii, SELECT_BY_POS, MODE_TRADES))
            {
               if(OrderSymbol()==Symbol() && (OrderMagicNumber()==MagicNumber))
               {  
                  if(StringFind(skdebuglevel,"info2")>=0) OrderPrint();
                  current_comment=OrderComment();
                  skdebug("Cr Cmt="+current_comment+" cmt to check="+commenttocheck+" Orderid="+skorderid+" found id ="+skorderid2 , dbgsupport2);
                  if(   ( StringFind(current_comment,"s_",0) >=0 ) && 
                        (StringFind(current_comment,commenttocheck,0) >=0 )  )
                     if(OrderTicket()!=skorderid)
                        {
                        skorderid2=OrderTicket();
                        skdebug("CHECK Support orders for comment :"+commenttocheck+" :"+skorderid+" & " + skorderid2+" with comment:"+current_comment,dbgsupport2);
                        }
                     //count++;
               }

            }

            }
         
      return(skorderid2);
   }


 //+------------------
 // COmplementary order for ongoing loss order .
 //+------------------------------------------------------------------+
 //|                                                                  |
 //+------------------------------------------------------------------+
int new_complementry_order(int skclosedordertype1,int orginalticket,string msg1) // place new complementry orders while closing another order .
  {
   double ll=0,tp=0,sl=0,slr=0,tpr=0,llbuy=0,llsell=0;
   double  ma=iMA(NULL,0,12,6,MODE_SMA,PRICE_CLOSE,0);
   totalorderscount=CalculateCurrentOrders();
   currenttime=TimeCurrent();
   string ordercomment="c_"+msg1;
   //string ordercomment1="support"+totalorderscount+"+"+currenttime;
   //sl and target setting 
      if(sktakeprofit!=0 && linegap!=0) 
         {
         tp =Ask+((sktakeprofit*usdtopoints)*linegap);
         tpr=Bid-((sktakeprofit*usdtopoints)*linegap);
         }
      if(sksl!=0 && linegap!=0) 
         {
         sl =Bid-((sksl*usdtopoints)*linegap);
         slr=Ask+((sksl*usdtopoints)*linegap);
         }
   
   
   //if(OrdersTotal()<maxlots)
   if(totalorderscount>=maxlots)
      skdebug("Max orders allowed = "+maxlots+" and current orders count = "+totalorderscount,dbgcomp2);
   if(totalorderscount<=maxlots)
      {
         //if(increaselots==1)     ll=sklevel_lotsize;
         llbuy=llsell=Lots;
         if(increaselots==1)    { llbuy=Lots*skbuy_lotsize; llsell=Lots*sksell_lotsize;}
            //ll=Lots*(1+totalorderscount);
            
         skdebug("last closed order #"+orginalticket+" type "+skclosedordertype1+" New Complementry Order comment will be :"+ordercomment,dbgcomp2);
         if(complementry_order==2 || 
            (complementry_order==1 && skclosedordertype1==OP_SELL) || 
            (complementry_order==3 && skclosedordertype1==OP_BUY))
            {
               skdebug("random number from caller = "+randomname,dbgcomp2);
               if(OpenPosition(Symbol(), OP_BUY, llbuy, sl, tp, MagicNumber,ordercomment))
                  skdebug("for order #"+orginalticket+" complementry Buy order placed successfully with comment="+ordercomment,dbgcomp1);
               else
                  skdebug("for order #"+orginalticket+" complementry buy order failed to be placed",dbgcomp1);
            }
         Sleep(500);
         if(complementry_order==2 || 
            (complementry_order==1 && skclosedordertype1==OP_BUY) || 
            (complementry_order==3 && skclosedordertype1==OP_SELL))
            {
               skdebug("random number from caller = "+randomname,dbgcomp2);
                  if(OpenPosition(Symbol(), OP_SELL, llsell, slr,tpr, MagicNumber,ordercomment))
                     skdebug("for order #"+orginalticket+" complementry sell order placed successfully with comment"+ordercomment,dbgcomp1);
                     else
                     skdebug("for order #"+orginalticket+" complementry sell order failed to be placed",dbgcomp1);
            }
      }
   return(0);
  }

int new_support_order(int skclosedordertype1, string comment1, double lotsize1,int ticketnumber1 ) // place new complementry orders while closing another order .
  {
   double ll=0,tp=0,sl=0,slr=0,tpr=0,llbuy=0,llsell=0;
   double  ma=iMA(NULL,0,12,6,MODE_SMA,PRICE_CLOSE,0);
   int neworderticket;
   totalorderscount=CalculateCurrentOrders();
   skdebug("Inside support order creation",dbgsupport2);
   //sl and target setting 
      if(sktakeprofit!=0 && linegap!=0) 
         {
         tp =Ask+((sktakeprofit*usdtopoints)*linegap);
         tpr=Bid-((sktakeprofit*usdtopoints)*linegap);
         }
      if(sksl!=0 && linegap!=0) 
         {
         sl =Bid-((sksl*usdtopoints)*linegap);
         slr=Ask+((sksl*usdtopoints)*linegap);
         }
   
   
   //if(OrdersTotal()<maxlots)
   if(totalorderscount>=maxlots)
      skdebug("Max orders allowed = "+maxlots+" and current orders count = "+totalorderscount,dbgsupport2);
   if(totalorderscount<maxlots)
     {
         currenttime=TimeCurrent();
         string ordercomment1="s_"+comment1;
         ll=lotsize1;
         //if(increaselots_support==1) ll=Lots*(lotsize1/Lots+1);
         //if(increaselots_support==1) ll=sklevel_lotsize;
         llbuy=llsell=Lots;
         if(increaselots_support==1)    { llbuy=Lots*skbuy_lotsize; llsell=Lots*sksell_lotsize;}
         skdebug("Order in loss : 0 for buy 1 for sell :"+skclosedordertype1+" #"+ticketnumber1+": New support order comment="+ordercomment1+": lotsize:"+lotsize1,2);
         if( (losspositionsupport==1 && skclosedordertype1==OP_SELL ) ||
              (losspositionsupport==3 && skclosedordertype1==OP_BUY ) ||
             (losspositionsupport==2 && skclosedordertype1==OP_BUY )       ) 
               neworderticket=(OpenPosition(Symbol(), OP_BUY, llbuy, sl, tp, MagicNumber,ordercomment1));
               if(neworderticket>0)
               skdebug(" support buy order placed successfully for order #"+ticketnumber1,dbgsupport1);
              else
               skdebug("for order #"+OrderTicket()+" support buy order failed to be placed",dbgsupport2);
            
            
         if( (losspositionsupport==1 && skclosedordertype1==OP_BUY ) || 
              ( losspositionsupport==3 && skclosedordertype1==OP_SELL ) ||
             (losspositionsupport==2 && skclosedordertype1==OP_SELL )      ) // if 1 then reverse orders .if 2 then both orders . if 3 then same direction support.
              neworderticket=(OpenPosition(Symbol(), OP_SELL, llsell, slr,tpr, MagicNumber,ordercomment1));
              if(neworderticket>0)
               {
               skdebug("support sell order placed successfully for order #"+ticketnumber1,dbgsupport1);
               }
              else
               skdebug("for order #"+OrderTicket()+" support sell buy order failed to be placed",dbgsupport2);
            

     }

   return(0);

  }

int check_mkt_movement()
{
    int movingupward=0,movingdownward=0,zigzag=0;
    // indicators array fill 
     Print("checking mkt movement");  

return(1);

}

void createvline(int location)
   {
      ObjectCreate(0,"vline",OBJ_VLINE,0,Time[0],High[0]);
   }

void neworder_quick(int whichorder)
{
   if(quickstart>=1)
   {

    sklevel_switched=True;
    sklevel_current=0;
      if(whichorder==1)
         OpenPosition(Symbol(), OP_BUY, Lots, 0, 0, MagicNumber,"newbuy");

      if(whichorder==2)
         OpenPosition(Symbol(), OP_SELL, Lots, 0, 0, MagicNumber,"newsell");
      if(whichorder==3)
      {
         OpenPosition(Symbol(), OP_BUY, Lots, 0, 0, MagicNumber,"newbuy");
         OpenPosition(Symbol(), OP_SELL, Lots, 0, 0, MagicNumber,"newsell");
      }
   }
}

void set_sklevel()
{ 
   //if(sklevel_current!=sklevel_prev)
      //skdebug("start : levels,p,c,nu,nd="+sklevel_prev+","+sklevel_current+","+sklevel_newup+","+sklevel_newdown,dbgcheck1);
  
      if(sklevel_gap == 0)
      {
        sklevel_gap_touse=MathAbs(sklevel_current);
            if(sklevel_current==0)
            sklevel_gap_touse=1;
      }
  
  if(sklevel_switched)
  { 
      sklevel_up_value=Ask+(sklevel_gap_touse * usdtopoints);
      sklevel_down_value=Ask-(sklevel_gap_touse * usdtopoints);
    sklevel_switched=False;
    skdebug("Level changed to "+sklevel_current+" and gap="+sklevel_gap_touse,dbgcheck1);
  }

  if(Ask > sklevel_up_value) 
    {
        sklevel_current+=1;
        sklevel_switched=True;
    }

  if(Ask < sklevel_down_value) 
  {
      sklevel_current-=1;
      sklevel_switched=True;
  }

  //sklevel_prev = sklevel_current;
  sklevel_newup=int((Ask-sklevel_start_price)/(sklevel_gap_touse * usdtopoints));
  sklevel_newdown=round(NormalizeDouble((Ask-sklevel_start_price)/(sklevel_gap_touse * usdtopoints),2 ));
   // if (sklevel_prev<sklevel_current) 
     // sklevel_current=sklevel_newdown;
    //else
    //sklevel_current=sklevel_newup;
  //if(tradingmode==1)
    int riskfactor=1;
    sklevel_lotsize=NormalizeDouble( Lots*(MathAbs(2*sklevel_current)+1),2);
    sklevel_lotsize2=Lots;
    sklevel_lotsize2=sklevel_lotsize/2;
    sklevel_lotsize2= NormalizeDouble( Lots*(MathAbs(2*sklevel_current)-1),2);
    oktotrade=True;

 if(MathAbs(sklevel_current)>4 && riskfactor >5 )   // only if riskfactor is high .
  {
    sklevel_lotsize2=NormalizeDouble( Lots*(MathAbs(2*sklevel_current)+1),2);
    sklevel_lotsize=Lots;
    //oktotrade=False;
  }


 
  sl=tp=0;
  string current_leveltransition="from_"+sklevel_prev+"_to_"+sklevel_current;

  if( ( OrdersTotal()>=maxlots && closeallcondition ) )
  {
      skdebug("max lots touched so will close all open orders ",dbgcheck1);
      closeall_orders();
  }

  if( sklevel_current!=sklevel_prev && oktotrade )
  {
    skdebug("end : levels,p,c,nu,nd="+sklevel_prev+","+sklevel_current+","+sklevel_newup+","+sklevel_newdown,dbgcheck1);

    if(sklevel_current == 0)   // mkt back to position where started 
    {
        if(sklevel_prev < sklevel_current)
            {
                skdebug("downward sqoff : levels,p,c,nu,nd="+sklevel_prev+","+sklevel_current+","+sklevel_newup+","+sklevel_newdown,dbgcheck1);
                //remove 1 sell lot ( last one )
                if(OrderClose(lastsell_order,lastsell_lots,Bid,Slippage,clrAqua) )
                    skdebug("Success last sell order closed with lots ="+lastsell_lots,dbgcheck1);
                else
                    skdebug("Failed last sell order closed with lots ="+lastsell_lots,dbgcheck1);
                    
                // remove level+1 buy lots 
                if(OrderClose(lastbuy_order,lastbuy_lots,Ask,Slippage,clrAqua) )
                    skdebug("Success last buy order closed with lots ="+lastbuy_lots,dbgcheck1);
                else
                    skdebug("Failed last buy order closed with lots ="+lastbuy_lots,dbgcheck1);

            }  
        if(sklevel_prev > sklevel_current)
            {
                skdebug("upward sqoff : levels,p,c,nu,nd="+sklevel_prev+","+sklevel_current+","+sklevel_newup+","+sklevel_newdown,dbgcheck1);
                //remove 1 buy lot 
                if(OrderClose(lastbuy_order,lastbuy_lots,Ask,Slippage,clrAqua) )
                    skdebug("Success last buy order closed with lots ="+lastbuy_lots,dbgcheck1);
                else
                    skdebug("Failed last buy order closed with lots ="+lastbuy_lots,dbgcheck1);
                    
                // remove level+1 sell lots 
                if(OrderClose(lastsell_order,lastsell_lots,Bid,Slippage,clrAqua) )
                    skdebug("Success last sell order closed with lots ="+lastsell_lots,dbgcheck1);
                else
                    skdebug("Failed last sell order closed with lots ="+lastsell_lots,dbgcheck1);

            }
    }

    if(sklevel_current > 0) // mkt going up so book buy profits 
    {
        if(sklevel_prev < sklevel_current && OrdersTotal()<maxlots)
        {
            skdebug("upward : levels,p,c,nu,nd="+sklevel_prev+","+sklevel_current+","+sklevel_newup+","+sklevel_newdown,dbgcheck1);
            //add 1 more buy standard lot
                //lastbuy_lots=Lots;
                lastbuy_lots=sklevel_lotsize2;
                ordercomment="buy"+lastbuy_lots;
               if(lastbuy_order=OpenPosition(Symbol(), OP_BUY, lastbuy_lots, sl, tp, MagicNumber,ordercomment))
                  skdebug("Success 2 new buy order placed with lots ="+lastbuy_lots,dbgcheck1);
               else
                  skdebug("Faild 2 New buy order with lots ="+lastbuy_lots+GetLastError(),dbgerr);
            //add level+1 sell lots 
                lastsell_lots=sklevel_lotsize;
                ordercomment="sell"+lastsell_lots;
               if(lastsell_order=OpenPosition(Symbol(), OP_SELL, lastsell_lots, sl, tp, MagicNumber,ordercomment))
                  skdebug("Success new sell order placed with lots ="+lastsell_lots,dbgcheck1);
               else
                  skdebug("Faild New sell order with lots ="+lastsell_lots+GetLastError(),dbgerr);
        }
        if(sklevel_prev > sklevel_current)
        {
            skdebug("upward sqoff : levels,p,c,nu,nd="+sklevel_prev+","+sklevel_current+","+sklevel_newup+","+sklevel_newdown,dbgcheck1);
            //remove 1 buy lot 
               if(OrderClose(lastbuy_order,lastbuy_lots,Ask,Slippage,clrAqua) )
                  skdebug("Success last buy order closed with lots ="+lastbuy_lots,dbgcheck1);
               else
                  skdebug("Failed last buy order closed with lots ="+lastbuy_lots,dbgcheck1);
                
            // remove level+1 sell lots 
               if(OrderClose(lastsell_order,lastsell_lots,Bid,Slippage,clrAqua) )
                skdebug("Success last sell order closed with lots ="+lastsell_lots,dbgcheck1);
               else
                  skdebug("Failed last sell order closed with lots ="+lastsell_lots,dbgcheck1);

        }
    }

    if(sklevel_current < 0)   // mkt going down so book profit from sell 
    {
        if(sklevel_prev > sklevel_current && OrdersTotal()<maxlots)
        {
            skdebug("downward : levels,p,c,nu,nd="+sklevel_prev+","+sklevel_current+","+sklevel_newup+","+sklevel_newdown,dbgcheck1);
            //add 1 more sell standard lot
                //lastsell_lots=Lots;
                lastsell_lots=sklevel_lotsize2;
                ordercomment="sell"+lastsell_lots;
               if(lastsell_order=OpenPosition(Symbol(), OP_SELL, lastsell_lots, sl, tp, MagicNumber,ordercomment))
                  skdebug("Success new sell order placed with lots ="+lastsell_lots,dbgcheck1);
               else
                  skdebug("Faild New sell order with lots ="+lastsell_lots+GetLastError(),dbgerr);
            //add level+1 buy lots 
                lastbuy_lots=sklevel_lotsize;
                ordercomment="buy"+lastbuy_lots;
               if(lastbuy_order=OpenPosition(Symbol(), OP_BUY, lastbuy_lots, sl, tp, MagicNumber,ordercomment))
                  skdebug("Success 3 new buy order placed with lots ="+lastbuy_lots,dbgcheck1);
               else
                  skdebug("Faild 3 New buy order with lots ="+lastbuy_lots+GetLastError(),dbgerr);
        }
        if(sklevel_prev < sklevel_current)
        {
            skdebug("downward sqoff : levels,p,c,nu,nd="+sklevel_prev+","+sklevel_current+","+sklevel_newup+","+sklevel_newdown,dbgcheck1);
            //remove 1 sell lot ( last one )
               if(OrderClose(lastsell_order,lastsell_lots,Bid,Slippage,clrAqua) )
                  skdebug("Success last sell order closed with lots ="+lastsell_lots,dbgcheck1);
               else
                  skdebug("Failed last sell order closed with lots ="+lastsell_lots,dbgcheck1);
                
            // remove level+1 buy lots 
               if(OrderClose(lastbuy_order,lastbuy_lots,Ask,Slippage,clrAqua) )
                skdebug("Success last buy order closed with lots ="+lastbuy_lots,dbgcheck1);
               else
                  skdebug("Failed last buy order closed with lots ="+lastbuy_lots,dbgcheck1);

        }
    }

    sklevel_prev = sklevel_current;

  }
     //if(sklevel_current!=sklevel_prev)
         //skdebug("end : levels,p,c,nu,nd="+sklevel_prev+","+sklevel_current+","+sklevel_newup+","+sklevel_newdown,dbgcheck1);

}
int neworder_check(int doubleorder)
   {
      double  ma=iMA(NULL,0,12,6,MODE_SMA,PRICE_CLOSE,0);
      //double x1=iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,1);
      //double x2=iMA(NULL,0,12,0,MODE_EMA,PRICE_CLOSE,1);
      //double x3=MathAbs((x1-x2)/Point);
      //double x4=iADX(NULL,0,6,0,MODE_PLUSDI,0);
      //double x5=iADX(NULL,0,6,0,MODE_MINUSDI,0);
      //double x6=iADX(NULL,0,6,0,MODE_PLUSDI,1);
      //double x7=iADX(NULL,0,6,0,MODE_MINUSDI,1);
      //double x8=iADX(NULL,0,6,0,MODE_PLUSDI,0);
      //double x9=iADX(NULL,0,6,0,MODE_MINUSDI,0);
         //if (x1<x2 && x3>n && x6<5 && x4>10 && x8>x9 ) then buy

          //if (x1>x2 && x3>n && x7<5 && x5>10 && x8<x9 ) // then sell 
      double ll=0,tp=0,sl=0,slr=0,tpr=0;
      
      if(sktakeprofit!=0 && linegap!=0) 
         {
         tp =Ask+((sktakeprofit*usdtopoints)*linegap);
         tpr=Bid-((sktakeprofit*usdtopoints)*linegap);
         }
      if(sksl!=0 && linegap!=0) 
         {
         sl =Bid-((sksl*usdtopoints)*linegap);
         slr=Ask+((sksl*usdtopoints)*linegap);
         }
      
      int totalorderscount=CalculateCurrentOrders();

      ll=Lots;
      currenttime=TimeCurrent();
      string ordercomment="n1_"+currenttime;
      total=totalorderscount;
      if(totalorderscount>=maxlots)
         skdebug("Max orders allowed = "+maxlots+" and current orders count = "+totalorderscount,4);
      
      if(total<=maxlots)
      {
         skdebug("lets check conditions for new order as sktotal orders : "+total+" < "+maxlots,7);
         if(AccountFreeMargin()<(1000*Lots) || Lots<=0)
         {
            skdebug("Insufficient funds = "+AccountFreeMargin(),1);
            return(0);
         }
         
         
         if (quickstart>=1)
         {
               skdebug("first buy,Size:"+ll+":SL:"+sl+":TP:"+tp+":msg:"+ordercomment,2);
               OpenPosition(Symbol(), OP_BUY, ll, sl, tp, MagicNumber,ordercomment);
               if(doubleorder==1)
               {
                  skdebug("first SELL ,Size:"+ll+":SL:"+sl+":TP:"+tp+":msg:"+ordercomment,2);
                  OpenPosition(Symbol(), OP_SELL, ll, slr,tpr, MagicNumber,ordercomment);
                  
               }
                  if (quickstart==2)
                   {
                     skdebug("first SELL ,Size:"+ll+":SL:"+sl+":TP:"+tp+":msg:"+ordercomment,2);
                     OpenPosition(Symbol(), OP_SELL, ll, slr,tpr, MagicNumber,ordercomment);
                     if(doubleorder==1)
                     {
                        skdebug("first buy,Size:"+ll+":SL:"+sl+":TP:"+tp+":msg:"+ordercomment,2);
                        OpenPosition(Symbol(), OP_BUY, ll, sl, tp, MagicNumber,ordercomment);
                        
                     }
                    }
               
               
         }
         else
         {
            if(check_buy_conditions()) // buy order 
            {
               skdebug("first buy,TP:"+tp,2);
               OpenPosition(Symbol(), OP_BUY, ll, sl, tp, MagicNumber,ordercomment);
               if(doubleorder==1)
                  OpenPosition(Symbol(), OP_SELL, ll, slr,tpr, MagicNumber,ordercomment);
            }
            if(check_sell_conditions()) // sell order 
            {
               skdebug("first sell ,TP:"+tpr,2);
               OpenPosition(Symbol(), OP_SELL, ll, slr, tpr, MagicNumber,ordercomment);
               //Sleep(5000);
               if(doubleorder==1)
                  OpenPosition(Symbol(), OP_BUY, ll, sl,tp, MagicNumber,ordercomment);
            }
         }
         
         
         
         
      }
      else
         skdebug("required orders already in place"+totalorderscount+" > "+maxlots,4);
      return(0);
   }

 //+=====================
 // ON TICK actions

void OnTick()
   {
      totalorderscount=CalculateCurrentOrders();
      display_details_onchart();
      skdebug("total Orders :"+OrdersTotal(),7);
      if(totalorderscount==0) // place new order as per condition .
      {
         skdebug("NO Orders created so placing orders ",7);
         //neworder_buy_sell_both();
         //neworder_check(buyselltogether);
         neworder_quick(quickstart);
         sklevel=0;
         sklevel_start_price=Ask;
      }
      set_sklevel();
      
      //totalorderscount=CalculateCurrentOrders();
      // trail the profit if orders are more then 1
      if(totalorderscount>0)  // in loop keep checking all orders for exit 
         {
            int i,k,toalopenorders,check1=0,check2=0;
            k=toalopenorders=totalorderscount;
            //double maxlossallowedperorder=maxloss_allowed_inr/toalopenorders;

            for(i=0; i<k; i++)
               {
                  if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
                     {
                        if(OrderSymbol()==Symbol() && (OrderMagicNumber()==MagicNumber))
                        {
                           //definitions 
                              int cr_ord_type=OrderType();
                              string cr_ord_comment=OrderComment();
                              int cr_ord_ticket=OrderTicket();
                              double cr_ord_lots=OrderLots();
                              double cr_ord_profit=OrderProfit();
                              bool sksl_triggered=cr_ord_profit < (-1*sksl*cr_ord_lots/Lots);
                              bool skprofit_triggered=cr_ord_profit+minpricegap > (sktakeprofit*cr_ord_lots/Lots);
                              bool skmaxloss_triggered=cr_ord_profit < ( -1*maxloss_allowed_inr );
                              bool skorderinloss_needsupport=cr_ord_profit < (-1*supportiflossinr*cr_ord_lots/Lots);

                           //if(skorderinloss_needsupport && (StringFind(cr_ord_comment,"s_",0) <0 ) && totalorderscount<maxlots  )
                           if(skorderinloss_needsupport  && totalorderscount<maxlots && losspositionsupport>0 )
                           {
                              int support_ticket=0;
                              support_ticket=getsupportorderid(cr_ord_comment,cr_ord_ticket);
                              skdebug("Order in loss #"+cr_ord_ticket+" Support Ticke="+support_ticket
                                       + " cr_ord_profit="+cr_ord_profit+"-1*sksl*cr_ord_lots/Lots"+sksl+"*"+cr_ord_lots+"/"+Lots,4);
                              OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
                              if( support_ticket == 0)
                                 {  
                                    skdebug("to open support order against Profit="+cr_ord_profit+" with comment"+cr_ord_comment +"ticket:"+cr_ord_ticket,6);
                                    //new_support_order(OrderType(),OrderComment(),OrderLots());
                                    new_support_order(cr_ord_type,cr_ord_comment,cr_ord_lots,cr_ord_ticket);
                                 }


                           }

                           //if(OrderType()==OP_BUY && ( OrderProfit() > (sktakeprofit*OrderLots()) ) && Close[1]<Open[1])
                           if( skprofit_triggered ) 
                           {
                              if(OrderType()==OP_BUY )
                              {
                                  //if level postive 
                                 skdebug("SK Close BUY ORDER #"+OrderTicket()+" :CurrentProfit:"+OrderProfit()+" tgtfirst : "+(sktakeprofit*OrderLots()/Lots ) +" msg="+OrderComment() ,dbgclose2);
                                 check1=iscomplementry_open(cr_ord_comment,cr_ord_ticket);
                                 OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
                                 skcloseorder(cr_ord_ticket);
                                 if (check1==False && skprofit_triggered && OrdersTotal()<=maxlots ) 
                                       { 
                                          skdebug("complementry order for Profit booking against buy Order #"+cr_ord_ticket , dbgcomp1);
                                             if(StringFind(skdebuglevel,dbgcomp1) >=0) OrderPrint();
                                          randomname="comp2"+rand();
                                          new_complementry_order(OP_BUY,cr_ord_ticket,cr_ord_comment);
                                       }
                              }

                              if(OrderType()==OP_SELL  )
                              {
                                 skdebug("SK Close SELL ORDER #"+cr_ord_ticket+":CurrentProfit:"+cr_ord_profit+" tgtfirst : "
                                       +(sktakeprofit*OrderLots()/Lots )+" comment="+cr_ord_comment ,3 );
                                 check2=iscomplementry_open(cr_ord_comment,cr_ord_ticket);
                                 OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
                                 skcloseorder(cr_ord_ticket);
                                 if (check2==False && skprofit_triggered && OrdersTotal()<=maxlots )
                                 {
                                    {
                                          skdebug("complementry order for Profit booking against sell Order #"+cr_ord_ticket,dbgcomp1);
                                             if(StringFind(skdebuglevel,dbgcomp1) >=0) OrderPrint();
                                          randomname="comp4"+rand();
                                          new_complementry_order(OP_SELL,cr_ord_ticket,cr_ord_comment);
                                    }
                                 }
                              }
                           }

                           if( sksl_triggered ) 
                           {
                              skdebug("SL is triggered for one order so will exit all orders now ",dbgclose2);
                              int nextaction=2;
                              if(OrderType()==OP_SELL) nextaction=1;
                              if(quickstart==3) nextaction=3;
                              
                              while(CalculateCurrentOrders() >0 ) 
                                    closeall_orders();
                                 
                           if(CalculateCurrentOrders()==0) neworder_quick(nextaction);
                              
                           }

                        }

                     }
               }


         }
      
   }

 //+------------------------------------------------------------------+
   int OpenPosition(string sy, int op, double ll, double sl=0, double tp=0, int mn=0, string cm ="")
     {
       color    clOpen;
       datetime ot;
       double   pp, pa, pb;
       int      dg, err, it, ticket=0;
       //string   lsComm="http://ytg.com.ua/";
       string   skmsg=cm;

       if(sy=="" || sy=="0")
         sy=Symbol();
       if(op==OP_BUY)
         clOpen=Lime;
       else
         clOpen=Red;

       for(it=1; it<=POPYTKY; it++)
        {
         if(!IsTesting() && (!IsExpertEnabled() || IsStopped()))
           {
            skdebug("OpenPosition(): ",1);
            break;
           }
         while(!IsTradeAllowed())
            Sleep(5000);
         RefreshRates();
         dg=(int)MarketInfo(sy, MODE_DIGITS);
         pa=MarketInfo(sy, MODE_ASK);
         pb=MarketInfo(sy, MODE_BID);
         if(op==OP_BUY)
            pp=pa;
         else
            pp=pb;
         pp=NormalizeDouble(pp, dg);
         ot=TimeCurrent();
         //----+
         totalorderscount=CalculateCurrentOrders();
         if(AccountFreeMarginCheck(Symbol(),op, ll)<=0 || GetLastError()==134 || ( maxlots_check_foreachorder==1 && totalorderscount>maxlots ) )
            {
            skdebug("order not sent to terminal : Total orders : "+totalorderscount,dbgerr);
            return(0);
            }
           
         //----+
         skdebug(op+"just before putting order :Symbol:"+sy+":what:"+ op+":size:"+ ll+":price:"+ pp+ "SL:"+sl+"TP:"+ tp+":msg:"+skmsg,3);
         ticket=OrderSend(sy, op, ll, pp, Slippage, sl, tp, skmsg, mn, 0, clOpen);
         
         

         if(ticket>0)
           {
            PlaySound("ok.wav");
                           //createvline(Bars);

            break;
           }
          else
           {
            err=GetLastError();
            if(pa==0 && pb==0)
               Message("Проверьте в Обзоре рынка наличие символа "+sy);
            // Вывод сообщения об ошибке
            skdebug("Error("+err+") opening position: "+ErrorDescription(err)+", try "+it,dbgerr);
            skdebug("Ask="+pa+" Bid="+pb+" sy="+sy+" ll="+ll+" op="+GetNameOP(op)+
                  " pp="+pp+" sl="+sl+" tp="+tp+" mn="+mn,4);
            // Блокировка работы советника
            if(err==2 || err==64 || err==65 || err==133)
              {
               gbDisabled=True;
               break;
              }
            // Длительная пауза
            if(err==4 || err==131 || err==132)
              {
               Sleep(1000*300);
               break;
              }
            if(err==128 || err==142 || err==143)
              {
               Sleep(1000*66.666);
               if(ExistPositions(sy, op, mn, ot))
                 {
                  skdebug("order exist so exiting ",2);
                  PlaySound("ok.wav");
                  break;
                 }
              }
            if(err==140 || err==148 || err==4110 || err==4111)
               break;
            if(err==141)
               Sleep(1000*100);
            if(err==145)
               Sleep(1000*17);
            if(err==146)
               while(IsTradeContextBusy())
                  Sleep(1000*11);
            if(err!=135)
               Sleep(1000*7.7);
           }
        }
       return(ticket);
     }
 //----
   bool ExistPositions(string sy="", int op=-1, int mn=-1, datetime ot=0)
     {
      int i, k=OrdersTotal();

      if(sy=="0")
         sy=Symbol();
      for(i=0; i<k; i++)
        {
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
           {
            if(OrderSymbol()==sy || sy=="")
              {
               if(OrderType()==OP_BUY || OrderType()==OP_SELL)
                 {
                  if(op<0 || OrderType()==op)
                    {
                     if(mn<0 || OrderMagicNumber()==mn)
                       {
                        if(ot<=OrderOpenTime())
                           return(True);
                       }
                    }
                 }
              }
           }
        }
      return(False);
     }
 //----
   void Message(string m)
     {
       Comment(m);
       if(StringLen(m)>0)
         skdebug(m,1);
     }
 //----
   string GetNameOP(int op)
     {
      switch(op)
        {
         case OP_BUY      :
            return("Buy");
         case OP_SELL     :
            return("Sell");
         case OP_BUYLIMIT :
            return("Buy Limit");
         case OP_SELLLIMIT:
            return("Sell Limit");
         case OP_BUYSTOP  :
            return("Buy Stop");
         case OP_SELLSTOP :
            return("Sell Stop");
         default          :
            return("Unknown Operation");
        }
     }
 //----


 //+------------------------------------------------------------------+
 //| Calculate open positions                                         |
 //+------------------------------------------------------------------+
   int closeall_orders()
     {
      int returnvalue,kk;
      kk=OrdersTotal();

      //kk=CalculateCurrentOrders();
      while ( OrdersTotal() > 0)
      {
      kk=OrdersTotal();
      skdebug("will close all orders : count= "+kk,dbgclose1);
        for(int ii=0; ii< kk; ii++)
        {
            Print("order postion =",ii);
            if(OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
            {  //skdebug("1Closing the order :"+OrderTicket()+" at position #"+ii,dbgclose1);
                if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
                {  skdebug("Closing the order :"+OrderTicket()+" at position #"+ii,dbgclose1);
                    OrderPrint();
                    if(OrderType()==OP_BUY)
                    OrderClose(OrderTicket(),OrderLots(),Bid,Slippage,clrAqua);
                    else
                        OrderClose(OrderTicket(),OrderLots(),Ask,Slippage,clrBrown);
                }
            }
            else
            {
                skdebug("Order selection error for order#"+ii+" err="+GetLastError(),dbgcheck1);
            }
            
        }
      }          
       Print("current Orders =",CalculateCurrentOrders());          
      if(CalculateCurrentOrders() <=0 ) 
         returnvalue=1;
         else 
         returnvalue=0;
         
         return(returnvalue);
     }

   int CalculateCurrentOrders()
     {
      int buys=0,sells=0;
      //---
      for(int i=0; i<OrdersTotal(); i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
            break;
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()==OP_BUY)
               buys++;
            if(OrderType()==OP_SELL)
               sells++;
           }
        }
      //--- return orders volume
      //if(buys>0)
       //  return(buys);
      //else
         return(buys+sells);
     }


// calculate daily profit loss 
double total_open_profit_loss()
     {
      double skprofit=0;
      //---
      for(int x=0; x<OrdersTotal(); x++)
        {
         if(OrderSelect(x,SELECT_BY_POS,MODE_TRADES)==false)
            break;
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
           {
            skprofit+=OrderProfit();
            skdebug("current PR:"+OrderProfit()+" total:"+skprofit,5);
           }
        }
      //--- return orders volume
      //if(buys>0)
       //  return(buys);
      //else
         return(skprofit);
     }
     
void display_details_onchart()
     {
      double sktotalprofit=0,crprofit=0,spreadsize=0,buy_lots_total=0,sell_lots_total=0;
      int positivecount=0,negativecount=0,totalorderscount1=0,buycount=0,sellcount=0,size1;
      totalorderscount1=OrdersTotal();
      string buy_comment="",sell_comment="";
      spreadsize=NormalizeDouble(Ask-Bid,1);
      double ap=NormalizeDouble(AccountProfit(),1);
      int balance=AccountBalance();   
         
         //---
         for(int x=0; x<totalorderscount1; x++)
            {
               if(OrderSelect(x,SELECT_BY_POS,MODE_TRADES)==false)
                  break;
               if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
               {
                  if(OrderType()==OP_BUY) 
                  {
                     buycount++;
                     buy_lots_total+=OrderLots();
                     size1=int(OrderLots()*100  );
                     lastbuy_order=OrderTicket();
                     lastbuy_lots=OrderLots();
                     //buy_comment+=","+NormalizeDouble(OrderLots(),2);
                     buy_comment+=","+size1;
                  }
                  if(OrderType()==OP_SELL) 
                  {
                     size1=int(OrderLots()*100  );
                     sellcount++;
                     sell_lots_total+=OrderLots();
                     sell_comment+=","+size1;
                    lastsell_order=OrderTicket();
                    lastsell_lots=OrderLots();

                  }
                  crprofit=OrderProfit();
                  sktotalprofit+=crprofit;
                  if(crprofit>0)
                     positivecount+=1;
                  if(crprofit<=0)
                     negativecount+=1;
               }
            }
        skbuy_lotsize=buycount+1;
        sksell_lotsize=sellcount+1;
        buy_lots_total=NormalizeDouble(buy_lots_total,2);
        sell_lots_total=NormalizeDouble(sell_lots_total,2);
        
       Comment("     Orders T(P+N)=",(negativecount+positivecount),"(",positivecount,"+",negativecount,
               ") B+S = ",buycount,"+",sellcount," Lots B+S(",buy_lots_total,"+",sell_lots_total,") ",
               ") Profit=",NormalizeDouble(sktotalprofit,1),"(",ap,")/",balance,"  gross =",(balance+ap)," from ",opening_balance,
               " spread=",spreadsize,
               "\n                                     BUY:",buy_comment,
               "\n                                     SELL:",sell_comment,
               "\n                                    Level=",sklevel_current," prev level=",sklevel_prev,
               " Ask=",Ask," sklevel_start_price=",sklevel_start_price,
               "\n                                     Oktotrade",oktotrade
               );
       
     }
