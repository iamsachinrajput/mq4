#property copyright "Sachin Rajput"
#property version   "2.00"
#property strict
#include <stdlib.mqh>
//INPUTS 
   input double sktakeprofit=2;
   input double sksl=30;
   input int losspositionsupport=1;
   input double Lots = 0.01;
   input int maxlots = 4;
   input int onprofit_quit_or_trail = 1;
   input int increaselots=0;
   input int maxlots_check_foreachorder=0;
   input double linegap=1.2;
   input int modifyorderinloss=0;
   input double minprofitinr=3;
   input int buyselltogether=1;
   input int onloss_action=0;
   input int complementry_order=3;
   input int alwayscomporder=1;
   input int quickstart=1;
   input int buysellstrategy=1;
   input int band_length=24;
   input int band_deviation=2;
   input double maxloss_allowed_inr=1000;
   input double maxloss_perday_inr=10;
   input int sksleeptime=500;
   double usdtopoints=.001;

//end inputs

// Variables 
   int n = 10;
   int totalorderscount=0;
   int total=0;
   int MagicNumber = 2808;
   int Slippage = 30;
   int POPYTKY = 10;
   bool  gbDisabled = False;
   datetime currenttime=TimeCurrent();
   double minpricegap=1.5*MarketInfo( Symbol(), MODE_STOPLEVEL )*Point();
//end variables

//+----------------------------

   double  ma=iMA(NULL,0,5,2,MODE_SMA,PRICE_CLOSE,0);
   double smax=iBands(NULL,0,band_length,band_deviation,0,PRICE_CLOSE,MODE_UPPER,0);
	double smin=iBands(NULL,0,band_length,band_deviation,0,PRICE_CLOSE,MODE_LOWER,0);

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
            PrintFormat("will sqoff order # %d in loss %f",tickettoclose,OrderProfit());
            if(OrderType()==OP_BUY)
            OrderClose(tickettoclose,OrderLots(),Ask,Slippage,clrAqua);
            if(OrderType()==OP_SELL)
            OrderClose(tickettoclose,OrderLots(),Bid,Slippage,clrAqua);
         }
      else   
      if(onprofit_quit_or_trail==2)
         {
            //modify stoploss
            double trailprofit=int(OrderProfit()/sktakeprofit)*sktakeprofit*usdtopoints;
            double newsl_sell=OrderOpenPrice() - trailprofit;
            double newsl_buy=OrderOpenPrice() + trailprofit;
            if(OrderType()==OP_SELL) 
               {
                  if(OrderStopLoss()>newsl_sell )
                     {
                        PrintFormat("For sell Order # %d setting newsl =%f , CrPrice=%f",tickettoclose,newsl_sell , Ask);
                        OrderModify(tickettoclose,OrderOpenPrice(),newsl_sell,0,0,clrRed);
                     }
                    else
                     {
                        PrintFormat("current SL of order #%d= %f is better then new sl %f",tickettoclose,OrderStopLoss(),newsl_sell);
                     }
               }
            if(OrderType()==OP_BUY) 
               {
                  if(OrderStopLoss()>newsl_buy )
                  {
                  PrintFormat("For buy Order # %d setting newsl =%f , CrPrice=%f",tickettoclose,newsl_buy , Bid);
                  OrderModify(tickettoclose,OrderOpenPrice(),newsl_buy,0,0,clrGreen);
                  }
                    else
                     {
                        PrintFormat("current SL of order #%d= %f is better then new sl %f",tickettoclose,OrderStopLoss(),newsl_sell);
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
     Print(Symbol()," ki Pipvalue=",returnvalue);
     return(returnvalue);
   }


int skbothordersopen(string commenttocheck,int skorderid)
   {
         int ii,kk,count=0,skorderid2=0;
         //kk=OrdersTotal();
         kk=CalculateCurrentOrders();

         //Print("str to check:",commenttocheck);
         for(ii=0; ii<kk; ii++)
         {
            if(OrderSelect(ii, SELECT_BY_POS, MODE_TRADES))
            {
               if(OrderSymbol()==Symbol() && (OrderMagicNumber()==MagicNumber))
               { 
                  //Print("comment in order :",OrderComment());
                  if(OrderComment()==commenttocheck)
                     if(OrderTicket()!=skorderid)
                        {
                        skorderid2=OrderTicket();
                        //Print("two orders for comment :",commenttocheck," :",skorderid," & " , skorderid2);
                        }
                     //count++;
               }

            }

            }
         //Print("str to check:",commenttocheck,"|count:",count);

      return(skorderid2);
   }

int getsupportorderid(string commenttocheck,int skorderid)
   {
         int ii,kk,count=0,skorderid2=0;
         kk=CalculateCurrentOrders();
         string current_comment;

         //Print("str to check:",commenttocheck);
         for(ii=0; ii<kk; ii++)
         {
            if(OrderSelect(ii, SELECT_BY_POS, MODE_TRADES))
            {
               if(OrderSymbol()==Symbol() && (OrderMagicNumber()==MagicNumber))
               {  
                  OrderPrint();
                  current_comment=OrderComment();
                  //Print("Cr Cmt=",current_comment," cmt to check=",commenttocheck," Orderid=",skorderid," found id =",skorderid2);
                  if(   ( StringFind(current_comment,"s_",0) >=0 ) && 
                        (StringFind(current_comment,commenttocheck,0) >=0 )  )
                     if(OrderTicket()!=skorderid)
                        {
                        skorderid2=OrderTicket();
                        //Print("CHECK Support orders for comment :",commenttocheck," :",skorderid," & " , skorderid2," with comment:",current_comment);
                        }
                     //count++;
               }

            }

            }
          //if(skorderid2>0)
            //Print("str to check:",commenttocheck,"|ticket:",skorderid," Found ticket =",skorderid2);
         
      return(skorderid2);
   }


 //+------------------
 // COmplementary order for ongoing loss order .
 //+------------------------------------------------------------------+
 //|                                                                  |
 //+------------------------------------------------------------------+
int new_complementry_order(int skclosedordertype1) // place new complementry orders while closing another order .
  {
   double ll=0,tp=0,sl=0,slr=0,tpr=0;
   double  ma=iMA(NULL,0,12,6,MODE_SMA,PRICE_CLOSE,0);
   totalorderscount=CalculateCurrentOrders();
   currenttime=TimeCurrent();
   string ordercomment="c_"+totalorderscount+"_"+currenttime;
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
      PrintFormat("Max orders allowed = %d and current orders count = %d ",maxlots,totalorderscount);
   if(totalorderscount<maxlots)
      {
         ll=Lots;
         if(increaselots==1)
            ll=Lots*(1+totalorderscount);
         Print("last closed order type ",skclosedordertype1," (0 is buy and 1 is sell ) New Complementry Order comment :",ordercomment);
         if(complementry_order==2 || (complementry_order==1 && skclosedordertype1==OP_SELL) || (complementry_order==3 && skclosedordertype1==OP_BUY))
            {
               if(OpenPosition(Symbol(), OP_BUY, ll, sl, tp, MagicNumber,ordercomment))
                  Print("complementry Buy order placed successfully");
               else
                  Print("complementry buy order failed to be placed");
            }
         Sleep(500);
         //Print("last closed order ",skclosedordertype1,"New Complementry sell ",ordercomment);
         if(complementry_order==2 || (complementry_order==1 && skclosedordertype1==OP_BUY) || (complementry_order==3 && skclosedordertype1==OP_SELL))
            {
                  if(OpenPosition(Symbol(), OP_SELL, ll, slr,tpr, MagicNumber,ordercomment))
                     Print("complementry sell order placed successfully");
                     else
                     Print("complementry sell order failed to be placed");
            }
      }
   return(0);
  }

int new_support_order(int skclosedordertype1, string comment1, double lotsize1,int ticketnumber1 ) // place new complementry orders while closing another order .
  {
   double ll=0,tp=0,sl=0,slr=0,tpr=0;
   double  ma=iMA(NULL,0,12,6,MODE_SMA,PRICE_CLOSE,0);
   totalorderscount=CalculateCurrentOrders();
   Print("Inside support order creation");
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
      PrintFormat("Max orders allowed = %d and current orders count = %d ",maxlots,totalorderscount);
   if(totalorderscount<maxlots)
     {
         currenttime=TimeCurrent();
         string ordercomment1="s_"+comment1;
         ll=lotsize1;
         Print("Order in loss : 0 for buy 1 for sell :",skclosedordertype1," #",ticketnumber1,": New support order comment=",ordercomment1,": lotsize:",lotsize1);
         if( (losspositionsupport==1 && skclosedordertype1==OP_SELL ) ||
             (losspositionsupport==2 && skclosedordertype1==OP_BUY )       ) 
               if(OpenPosition(Symbol(), OP_BUY, ll, sl, tp, MagicNumber,ordercomment1))
               Print(" support buy order placed successfully:",skclosedordertype1 ," for order #",ticketnumber1);
              else
               Print("support buy order failed to be placed");
            
            
         if( (losspositionsupport==1 && skclosedordertype1==OP_BUY ) || 
             (losspositionsupport==2 && skclosedordertype1==OP_SELL )      )
              if(OpenPosition(Symbol(), OP_SELL, ll, slr,tpr, MagicNumber,ordercomment1))
               Print("support sell order placed successfully:",skclosedordertype1," for order #",ticketnumber1);
              else
               Print("support sell buy order failed to be placed");
            

     }

   return(0);

  }


void createvline(int location)
   {
      ObjectCreate(0,"vline",OBJ_VLINE,0,Time[0],High[0]);
   }

  //+------------------------------------------------------------------+
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
      //Print("currenttime:",currenttime);
      string ordercomment="n1_"+currenttime;
      //Print("first comment",ll);
      total=totalorderscount;
      //Print("Start 1 : lets check conditions for new order as sktotal orders : ",total," &  ",maxlots);
      if(totalorderscount>=maxlots)
         PrintFormat("Max orders allowed = %d and current orders count = %d ",maxlots,totalorderscount);
      
      if(total<=maxlots)
      {
         //Print("lets check conditions for new order as sktotal orders : ",total," < ",maxlots);
         if(AccountFreeMargin()<(1000*Lots) || Lots<=0)
         {
            Print("Insufficient funds = ", AccountFreeMargin());
            return(0);
         }
         
         
         if (quickstart>=1)
         {
               Print("first buy,Size:",ll,":SL:",sl,":TP:",tp,":msg:",ordercomment);
               OpenPosition(Symbol(), OP_BUY, ll, sl, tp, MagicNumber,ordercomment);
               if(doubleorder==1)
               {
                  Print("first SELL ,Size:",ll,":SL:",sl,":TP:",tp,":msg:",ordercomment);
                  OpenPosition(Symbol(), OP_SELL, ll, slr,tpr, MagicNumber,ordercomment);
                  
               }
                  if (quickstart==2)
                   {
                     Print("first SELL ,Size:",ll,":SL:",sl,":TP:",tp,":msg:",ordercomment);
                     OpenPosition(Symbol(), OP_SELL, ll, slr,tpr, MagicNumber,ordercomment);
                     if(doubleorder==1)
                     {
                        Print("first buy,Size:",ll,":SL:",sl,":TP:",tp,":msg:",ordercomment);
                        OpenPosition(Symbol(), OP_BUY, ll, sl, tp, MagicNumber,ordercomment);
                        
                     }
                    }
               
               
         }
         else
         {
            if(check_buy_conditions()) // buy order 
            {
               Print("first buy,TP:",tp);
               OpenPosition(Symbol(), OP_BUY, ll, sl, tp, MagicNumber,ordercomment);
               if(doubleorder==1)
                  OpenPosition(Symbol(), OP_SELL, ll, slr,tpr, MagicNumber,ordercomment);
            }
            if(check_sell_conditions()) // sell order 
            {
               Print("first sell ,TP:",tpr);
               OpenPosition(Symbol(), OP_SELL, ll, slr, tpr, MagicNumber,ordercomment);
               //Sleep(5000);
               if(doubleorder==1)
                  OpenPosition(Symbol(), OP_BUY, ll, sl,tp, MagicNumber,ordercomment);
            }
         }
         
         
         
         
      }
      else
         Print("required orders already in place",totalorderscount," > ",maxlots);
      return(0);
   }

 //+=====================
 // ON TICK actions

void OnTick()
   {
      if(Symbol()=="BTCUSD")
      usdtopoints=100;
      totalorderscount=CalculateCurrentOrders();
      display_details_onchart();
      //Print("total Orders :",OrdersTotal());
      if(totalorderscount==0) // place new order as per condition .
      {
         //Print("NO Orders created so placing orders ");
         //neworder_buy_sell_both();
         neworder_check(buyselltogether);
      }
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
                        int cr_ord_type=OrderType();
                        string cr_ord_comment=OrderComment();
                        int cr_ord_ticket=OrderTicket();
                        double cr_ord_lots=OrderLots();
                        double cr_ord_profit=OrderProfit();
                        bool sksl_triggered=cr_ord_profit < (-1*sksl*cr_ord_lots/Lots);
                        bool skprofit_triggered=cr_ord_profit > (sktakeprofit*cr_ord_lots/Lots);
                        bool skmaxloss_triggered=cr_ord_profit < ( -1*maxloss_allowed_inr );
                        bool skorderinloss_needsupport=cr_ord_profit*2 < (-1*sksl*cr_ord_lots/Lots);

                           //if(skorderinloss_needsupport && (StringFind(cr_ord_comment,"s_",0) <0 ) && totalorderscount<maxlots  )
                           if(skorderinloss_needsupport  && totalorderscount<maxlots  )
                              {
                                 int support_ticket=0;
                                 //OrderPrint();
                                 support_ticket=getsupportorderid(cr_ord_comment,cr_ord_ticket);
                                 Print("Order in loss #",cr_ord_ticket," Support Ticke=",support_ticket," cr_ord_profit=",cr_ord_profit,"-1*sksl*cr_ord_lots/Lots",sksl,"*",cr_ord_lots,"/",Lots);
                                 OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
                                 if( support_ticket == 0)
                                    {  
                                       //Print("before placing support order : support ticket =",support_ticket);
                                       //Print("to open support order against Profit=",cr_ord_profit," with comment",cr_ord_comment ,"ticket:",cr_ord_ticket);
                                       //Print("cr_ord_type:",cr_ord_type," cr_ord_comment",cr_ord_comment,"  cr_ord_ticket:",cr_ord_ticket," cr_ord_lots",cr_ord_lots);
                                       //new_support_order(OrderType(),OrderComment(),OrderLots());
                                       new_support_order(cr_ord_type,cr_ord_comment,cr_ord_lots,cr_ord_ticket);
                                    }


                              }

                              //OrderPrint();
                           //if(OrderType()==OP_BUY && ( OrderProfit() > (sktakeprofit*OrderLots()) ) && Close[1]<Open[1])
                           if( sksl_triggered || skprofit_triggered || skmaxloss_triggered ) 
                           {
                              string close_reason="none";
                              if(sksl_triggered) close_reason="SL";
                              if(skprofit_triggered) close_reason="PR";
                              if(skmaxloss_triggered) close_reason="MXLoss";
                              
                              if(OrderType()==OP_BUY )
                              {
                                 Print("SK Close BUY ORDER #",OrderTicket()," Reason=",close_reason," :CurrentProfit:",OrderProfit()," tgtfirst : ",(sktakeprofit*OrderLots()/Lots ) ,OrderComment());
                                 //OrderPrint();
                                 check1=skbothordersopen(OrderComment(),OrderTicket());
                                 Print("bothorders: for ",OrderComment()," =",check1);
                                 OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
                                 int skclosedordertype=OP_BUY;
                                 if(sksl_triggered || skmaxloss_triggered) 
                                    {
                                       skclosedordertype=OP_SELL;
                                       Print("Loss triggered:sltriggered=",sksl_triggered);
                                    }
                                 Print("will close buy order :",skclosedordertype,"#",OrderTicket());
                                 //OrderClose(OrderTicket(),OrderLots(),Bid,Slippage,clrAqua);
                                 skcloseorder(OrderTicket());
                                 Sleep(sksleeptime);
                                 
                                 if (check1!=0 || alwayscomporder==1 )
                                 if(StringFind(OrderComment(),"s_",0) >= 0 ) ;
                                 {
                                    if( (sksl_triggered || skmaxloss_triggered) )
                                       {
                                       if(onloss_action==2)
                                          {
                                             Print("will open 2 New orders for LOSS booking against Order #",OrderTicket());
                                             neworder_check(1);
                                          }
                                       if(onloss_action==1)
                                          {
                                             Print("will open complementry order for LOSS booking against Order #",OrderTicket());
                                             new_complementry_order(skclosedordertype);
                                          }
                                       }
                                    else
                                       { 
                                       Print("will open complementry order for Profit booking against Order #",OrderTicket());
                                       new_complementry_order(skclosedordertype);
                                       if(modifyorderinloss==1)
                                          {
                                          OrderSelect(check1, SELECT_BY_TICKET, MODE_TRADES);
                                          double newtarget=NormalizeDouble(OrderOpenPrice()-(minprofitinr*usdtopoints),0);
                                          Print("will modify the other sell order which is in loss :",check1,":Price:",OrderOpenPrice(),":newtgt:",newtarget,":usdtopoint:",usdtopoints,"*minprofit:",minprofitinr,"=",minprofitinr*usdtopoints);
                                          OrderPrint();
                                          OrderModify(OrderTicket(),OrderOpenPrice(),0,newtarget,0,Red);
                                          }
                                       }
                                 }
                              }

                              //if(OrderType()==OP_SELL && (OrderProfit() > (sktakeprofit*OrderLots()/Lots)  || OrderProfit() < ( -1*maxloss_allowed_inr ) ) )
                              
                              else 
                              if(OrderType()==OP_SELL  )
                              {
                                 Print("SK Close SELL ORDER #",OrderTicket()," Reason=",close_reason,":CurrentProfit:",OrderProfit()," tgtfirst : ",(sktakeprofit*OrderLots()/Lots ),OrderComment() );
                                 OrderPrint();
                                 //Print("SKINTRAIL:CurrentProfit",OrderProfit(),"tgtfirst",tgtfirst);
                                 check2=skbothordersopen(OrderComment(),OrderTicket());
                                 OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
                                 Print("bothorders: for ",OrderComment()," =",check2);
                                 int skclosedordertype=OP_SELL;
                                 if(sksl_triggered || skmaxloss_triggered) 
                                    {
                                       skclosedordertype=OP_BUY;
                                       Print("Loss triggered:sltriggered=",sksl_triggered);
                                    }
                                 Print("will close sell order :",skclosedordertype,"#",OrderTicket());
                                 //OrderClose(OrderTicket(),OrderLots(),Ask,Slippage,clrAqua);
                                 skcloseorder(OrderTicket());

                                 Sleep(sksleeptime);
                                 if (check2!=0 || alwayscomporder==1)
                                  if(StringFind(OrderComment(),"s_",0) >= 0 ) ;
                                 {
                                    if( (sksl_triggered || skmaxloss_triggered) )
                                       {
                                       if(onloss_action==2)
                                          {
                                             neworder_check(1);
                                             Print("will open 2 New orders for LOSS booking against Order #",OrderTicket());
                                          }
                                       if(onloss_action==1)
                                          {
                                             new_complementry_order(skclosedordertype);
                                             Print("will open complementry order for LOSS booking against Order #",OrderTicket());
                                          }
                                       }

                                    else
                                    {
                                          Print("will open complementry order for Profit booking against Order #",OrderTicket());
                                          new_complementry_order(skclosedordertype);
                                          if(modifyorderinloss==1)
                                          {
                                          OrderSelect(check2, SELECT_BY_TICKET, MODE_TRADES);
                                          double newtarget=NormalizeDouble(OrderOpenPrice()+(minprofitinr*usdtopoints),1);
                                          Print("will modify the other buy order which is in loss : ",check2 ,":Price:",OrderOpenPrice(),":newtgt:",newtarget);
                                          OrderPrint();
                                          OrderModify(OrderTicket(),OrderOpenPrice(),0,newtarget,0,Green);
                                          }
                                       }
                                 }
                              }
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
            Print("OpenPosition(): Остановка работы функции");
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
            Print("order not sent to terminal : Total orders : ",totalorderscount);
            return(0);
            }
           
         //----+
         Print(op,"just before putting order :Symbol:",sy,":what:", op,":size:", ll,":price:", pp, "SL:",sl,"TP:", tp,":msg:",skmsg);
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
            Print("Error(",err,") opening position: ",ErrorDescription(err),", try ",it);
            Print("Ask=",pa," Bid=",pb," sy=",sy," ll=",ll," op=",GetNameOP(op),
                  " pp=",pp," sl=",sl," tp=",tp," mn=",mn);
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
                  Print("order exist so exiting ");
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
         Print(m);
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
            Print("current PR:",OrderProfit()," total:",skprofit);
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
      double sktotalprofit=0,crprofit=0,spreadsize=0;
      int positivecount=0,negativecount=0,totalorderscount1=0;
      totalorderscount1=OrdersTotal();
      spreadsize=NormalizeDouble(Ask-Bid,1);
      double ap=NormalizeDouble(AccountProfit(),1);
      
      
         //---
         for(int x=0; x<totalorderscount1; x++)
            {
               if(OrderSelect(x,SELECT_BY_POS,MODE_TRADES)==false)
                  break;
               if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
               {
                  crprofit=OrderProfit();
                  sktotalprofit+=crprofit;
                  if(crprofit>0)
                     positivecount+=1;
                  if(crprofit<=0)
                     negativecount+=1;
                  //Print("current PR:",OrderProfit()," total:",skprofit);
               }
            }
        
       Comment("     Orders T(P+N)=",(negativecount+positivecount),
             "(",positivecount,"+",negativecount,") Profit=",NormalizeDouble(sktotalprofit,1),"(",ap,")",
             " spread=",spreadsize);
     }
