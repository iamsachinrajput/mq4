#property copyright "Sachin Rajput"
#property version   "2.00"
#property strict
#include <stdlib.mqh>

   //input double TakeProfit = 310;
   //input double trailingpoints=30;
   input double tgtfirstinr=3;
   input double minprofitinr=3;
   input int losspositionsupport=1;
   input int modifyorderinloss=0;
   //input double modifytargetpoints=300;
   //input double tgtsecondpoints=500;
   input int increaselots=1;
   input double maxloss_allowed_inr=1000;
   input double maxloss_perday_inr=10;
   input int buyselltogether=1;
   input int complementry_order=1;
   input int alwayscomporder=0;
   input int sksleeptime=500;
   input int quickstart=1;
   //input double Sl = 400;
   input double Lots = 0.01;
   input int maxlots = 4;
   datetime currenttime=TimeCurrent();
   // Variables 
   int n = 10;
   int total=0;
   int MagicNumber = 2808;
   int Slippage = 30;
   int POPYTKY = 10;
   bool  gbDisabled = False;
   input double linegap=1.5;
 //+----------------------------

bool check_buy_sell_conditions(string buyorsell)
{
if(buyorsell=="buy")
{

}

if(buyorsell=="sell")
{

}
}


 double get_pip_value()
     {
     
     
     double returnvalue=.0001;
     if(Symbol()=="BTCUSD")
      returnvalue=.01;
     Print(Symbol()," ki Pipvalue=",returnvalue);
     return(returnvalue);
     }
  
   double usdtopoints=.001;


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
                     Print("two orders for comment :",commenttocheck," :",skorderid," & " , skorderid2);
                     }
                  //count++;
             }

           }

         }
      //Print("str to check:",commenttocheck,"|count:",count);

return(skorderid2);
}

 //+------------------
 // COmplementary order for ongoing loss order .

 //+------------------------------------------------------------------+
 //|                                                                  |
 //+------------------------------------------------------------------+
int new_complementry_order() // place new complementry orders while closing another order .
  {
   double ll=0,tp=0,sl=0,slr=0,tpr=0;
   double  ma=iMA(NULL,0,12,6,MODE_SMA,PRICE_CLOSE,0);
   int totalorderscount=CalculateCurrentOrders();
   currenttime=TimeCurrent();
   string ordercomment="comp"+totalorderscount+"+"+currenttime;
   string ordercomment1="support"+totalorderscount+"+"+currenttime;
   tp =Ask+NormalizeDouble((tgtfirstinr*usdtopoints)*linegap,1);
   tpr=Bid-NormalizeDouble((tgtfirstinr*usdtopoints)*linegap,1);
   //if(OrdersTotal()<maxlots)
   if(totalorderscount<maxlots)
     {
      ll=Lots;
      if(increaselots==1)
         //ll=Lots*(1+OrdersTotal());
         ll=Lots*(1+totalorderscount);
      Print("New Complementry buy ",ordercomment);
      if(complementry_order==2 || (complementry_order==1 && OrderType()==OP_SELL) || (complementry_order==3 && OrderType()==OP_BUY))
         //if(Open[1]<ma && Close[1]>ma )
           {
            if(OpenPosition(Symbol(), OP_BUY, ll, sl, tp, MagicNumber,ordercomment))
               Print("complementry Buy order placed successfully");
               else
               Print("complementry buy order failed to be placed");
               
            if(losspositionsupport==1 && OrderType()==OP_SELL )
               if(OpenPosition(Symbol(), OP_BUY, ll, sl, tp, MagicNumber,ordercomment1))
               Print(" support buy order placed successfully");
               else
               Print("support buy order failed to be placed");
            
            }
      Sleep(500);
      Print("New Complementry Sell ",ordercomment);
      if(complementry_order==2 || (complementry_order==1 && OrderType()==OP_BUY) || (complementry_order==3 && OrderType()==OP_SELL))
         //if(Open[1]>ma && Close[1]<ma)
            if(OpenPosition(Symbol(), OP_SELL, ll, slr,tpr, MagicNumber,ordercomment))
               Print("complementry sell order placed successfully");
               else
               Print("complementry sell order failed to be placed");

            if(losspositionsupport==1 && OrderType()==OP_BUY )
              if(OpenPosition(Symbol(), OP_SELL, ll, slr,tpr, MagicNumber,ordercomment1))
               Print("support sell order placed successfully");
               else
               Print("support sell buy order failed to be placed");

     }

   return(0);

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
   tp =Ask+NormalizeDouble((tgtfirstinr*usdtopoints)*linegap,1);
   tpr=Bid-NormalizeDouble((tgtfirstinr*usdtopoints)*linegap,1);
   int totalorderscount=CalculateCurrentOrders();

   ll=Lots;
   currenttime=TimeCurrent();
   //Print("currenttime:",currenttime);
   string ordercomment="new1+"+currenttime;
   //Print("first comment",ll);
   total=totalorderscount;
    //Print("Start 1 : lets check conditions for new order as sktotal orders : ",total," &  ",maxlots);
   if(total<1)
     {
      //Print("lets check conditions for new order as sktotal orders : ",total," < ",maxlots);
      if(AccountFreeMargin()<(1000*Lots) || Lots<=0)
        {
         Print("Insufficient funds = ", AccountFreeMargin());
         return(0);
        }
        
        
        if (quickstart==1)
        {
            Print("first buy,Size:",ll,":SL:",sl,":TP:",tp,":msg:",ordercomment);
            OpenPosition(Symbol(), OP_BUY, ll, sl, tp, MagicNumber,ordercomment);
            if(doubleorder==1)
            {
               Print("first SELL ,Size:",ll,":SL:",sl,":TP:",tp,":msg:",ordercomment);
               OpenPosition(Symbol(), OP_SELL, ll, slr,tpr, MagicNumber,ordercomment);
             }
        }
        else
        {
         if(check_buy_sell_conditions(buy)) // buy order 
           {
            Print("first buy,TP:",tp);
            OpenPosition(Symbol(), OP_BUY, ll, sl, tp, MagicNumber,ordercomment);
            if(doubleorder==1)
               OpenPosition(Symbol(), OP_SELL, ll, slr,tpr, MagicNumber,ordercomment);
           }
         if(check_buy_sell_conditions(sell)) // sell order 
           {
            Print("first sell ,TP:",tpr);
            OpenPosition(Symbol(), OP_SELL, ll, sl, tpr, MagicNumber,ordercomment);
            //Sleep(5000);
            if(doubleorder==1)
               OpenPosition(Symbol(), OP_BUY, ll, slr,tp, MagicNumber,ordercomment);
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
    //neworder_check(1);
   if(Symbol()=="BTCUSD")
   usdtopoints=100;
   int totalorderscount=CalculateCurrentOrders();
    //Print("total Orders :",OrdersTotal());
    if(totalorderscount==0) // place new order as per condition .
     {
       //Print("NO Orders created so placing orders ");
       //neworder_buy_sell_both();
       neworder_check(buyselltogether);
     }


    totalorderscount=CalculateCurrentOrders();
    
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

                //if(OrderType()==OP_BUY && ( OrderProfit() > (tgtfirstinr*OrderLots()) ) && Close[1]<Open[1])
                if(OrderType()==OP_BUY && ( OrderProfit() > (tgtfirstinr*OrderLots()/Lots) || OrderProfit() < ( -1*maxloss_allowed_inr ) ) )
                 {
                     Print("SK ORDER CLOSE :CurrentProfit:",OrderProfit()," tgtfirst : ",(tgtfirstinr*OrderLots()/Lots ) );
                     OrderPrint();
                     check1=skbothordersopen(OrderComment(),OrderTicket());
                     Print("bothorders: for ",OrderComment()," =",check1);
                     OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
                     OrderClose(OrderTicket(),OrderLots(),Bid,Slippage,clrAqua);
                     Sleep(sksleeptime);
                     if (check1!=0 || alwayscomporder==1 )
                     {
                        new_complementry_order();
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

                if(OrderType()==OP_SELL && (OrderProfit() > (tgtfirstinr*OrderLots()/Lots)  || OrderProfit() < ( -1*maxloss_allowed_inr ) ) )
                    {
                      Print("SK ORDER CLOSE :CurrentProfit:",OrderProfit()," tgtfirst : ",(tgtfirstinr*OrderLots()/Lots ));
                      OrderPrint();
                      //Print("SKINTRAIL:CurrentProfit",OrderProfit(),"tgtfirst",tgtfirst);
                      check2=skbothordersopen(OrderComment(),OrderTicket());
                      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
                     Print("bothorders: for ",OrderComment()," =",check2);
                      OrderClose(OrderTicket(),OrderLots(),Ask,Slippage,clrAqua);
                      Sleep(sksleeptime);
                      if (check2!=0 || alwayscomporder==1)
                      {
                        new_complementry_order();
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
         if(AccountFreeMarginCheck(Symbol(),op, ll)<=0 || GetLastError()==134)
            return(0);
         //----+
         Print(op,"just before putting order :Symbol:",sy,":what:", op,":size:", ll,":price:", pp, "SL:",sl,"TP:", tp,":msg:",skmsg);
         ticket=OrderSend(sy, op, ll, pp, Slippage, sl, tp, skmsg, mn, 0, clOpen);

         if(ticket>0)
           {
            PlaySound("ok.wav");
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
   int total_open_profit_loss()
     {
      int skprofit=0;
      //---
      for(int i=0; i<OrdersTotal(); i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
            break;
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
           {
            skprofit+=OrderProfit();
           }
        }
      //--- return orders volume
      //if(buys>0)
       //  return(buys);
      //else
         return(skprofit);
     }
