//+------------------------------------------------------------------+
//|                                  open_level_ea_25mar22_test1.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

// INPUTS 
 string baseline=",daily_open,";
 string baseline_info="daily_open,first_candle_open,hourly_open";
extern double lots_to_start_input=0.02;
extern double gapinput_pips=20;
extern double pips_near_open=19;
extern double take_profit_usd_input=-1;
extern double per_pip_profit_usd=.1;
extern double lots_multiplier=1.5;
extern bool Timed_Closing=True;
extern int time_close_minutes=10;
extern bool trail_profit=False;
extern double trail_profit_usd=1;
extern int max_orders_depth=50;
extern bool stop_working=False;
extern bool close_all_orders_on_init=False;
extern int starting_hour=0;
extern int closing_hour=25;



int profit_total,G_slippage_264,MagicNumber;
int action,last_action,equity_start_for_this_session,max_orders,max_orders_active;
string lots_to_work;
double skind_open_currentvalue,equity_at_start;
double lot_size_to_trade=lots_to_start_input;
   int total_orders_open_active=0;
   int total_orders_open_pending=0;
   int total_orders_open_live=0;
double take_profit_usd=take_profit_usd_input;
string session_list;
int sessionid=0;
string   pending_lots="";
string   active_lots="";
double TotalrunningProfit=0;
double buyprice,sellprice;
double skind_open_currentvalue_last;
double total_open_lots,total_open_lots_buy,total_open_lots_sell;
string message_display;






//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

   profit_total=0;
   equity_at_start=AccountEquity();
   equity_start_for_this_session=equity_at_start;
   G_slippage_264=0;
   MagicNumber=887791;
   max_orders=0;
   max_orders_active=0;
   take_profit_usd=take_profit_usd_input;
   session_list="";
   
   set_open_line_value();      
   if(close_all_orders_on_init==True)
      close_all_orders("on init");
   
   
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
   printf(message_display);

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
if( stop_working==False )
{
   int current_hour=TimeHour(TimeCurrent()); 
   skind_open_currentvalue_last=skind_open_currentvalue;
   //if(StringFind( baseline,",daily_open,")>0)
   int thisminute=TimeMinute(TimeCurrent());
   
   //if(TimeMinute(TimeCurrent()>55))
   //if(total_orders_open_live==0)
         //set_open_line_value();
         
   if(current_hour>=starting_hour && current_hour<closing_hour ) 
      place_order(decide_action() );
   if(current_hour>=closing_hour)
      close_all_orders("closing hour");
   closing_of_orders();
   
   TimedClosing();
   
 }
 
   display_tasks();
   

  }
//+------------------------------------------------------------------+

void closing_of_orders()
{

if(take_profit_usd_input==-1)
   //take_profit_usd=MathAbs((total_open_lots_buy-total_open_lots_sell)*100);
   take_profit_usd=total_open_lots*100*per_pip_profit_usd;
   
int current_session_profit = AccountEquity() -  equity_start_for_this_session ;

   if(total_orders_open_live==0)
      {
         if(current_session_profit!=0)
            {sessionid++;
            session_list=current_session_profit+","+session_list;
            set_open_line_value();
            }
      equity_start_for_this_session=AccountEquity();
      return;
      }
      
      
   if( skind_open_currentvalue != skind_open_currentvalue_last ) 
      {
      printf("open line changed from "+skind_open_currentvalue_last+" to "+skind_open_currentvalue );
      close_all_orders("day changed");
      skind_open_currentvalue_last=skind_open_currentvalue;
      
      }

   if(trail_profit==False)
      {  
     
      if(  current_session_profit > take_profit_usd ) 
         {
         close_all_orders(  current_session_profit +" > "+take_profit_usd);
         lot_size_to_trade=lots_to_start_input;
         }
      }
   else
         {
            if(  current_session_profit > take_profit_usd_input ) 
              {
                     if(  current_session_profit > take_profit_usd ) 
                       {
                           take_profit_usd=take_profit_usd+trail_profit_usd;
                       }
                     if(  current_session_profit < ( take_profit_usd-trail_profit_usd) ) 
                       {
                           close_all_orders("trail tp");
                       }
                       
              } 
                  
         
         }
 
}

void display_tasks()
{
   traverse_orders();
   max_orders=MathMax(max_orders,OrdersTotal());
   max_orders_active=MathMax(max_orders_active,total_orders_open_active);

   message_display=("price Now : "+(string)Ask+" today open ="+(string)skind_open_currentvalue +" last="+skind_open_currentvalue_last+ "Equity="+equity_at_start+"+"+(int)(AccountEquity()-equity_at_start)+"="+(int)AccountEquity()
   +" orders="+total_orders_open_live+"/"+OrdersTotal()+"/"+max_orders_active+"/"+max_orders
   +"\n#"+sessionid+" profits:"+session_list
   +"\n Crpr="+digit2(TotalrunningProfit) +" Lots active="+active_lots+" pending="+pending_lots
   + "\nSpread="+((Ask-Bid)/Point())+" buyprice="+buyprice+"/"+digit2(buyprice-Ask)+" sellprice="+sellprice+"/"+digit2(Bid-sellprice)+" Ask="+Ask+" Bid="+Bid
   +"\nNextLot="+lot_size_to_trade +" total running_lots="+digit2(total_open_lots)+"(B"+digit2(total_open_lots_buy)+"S"+digit2(total_open_lots_sell)+"="+digit2(MathAbs(total_open_lots_buy-total_open_lots_sell))+") TP="+digit2(take_profit_usd)
   ) ;
   
   
   Comment(message_display);
   printf(message_display);
   //printf("price Now : "+(string)Ask+" today open ="+(string)skind_open_currentvalue + "Equity="+equity_at_start+"+"+(int)(AccountEquity()-equity_at_start)+"="+(int)AccountEquity()
  // +" orders="+OrdersTotal()+"/"+max_orders_active+"/"+max_orders+"\n#"+session_list+"\n#Crpr="+TotalrunningProfit +" Lots active="+active_lots+"pending="+pending_lots
  // ) ;
   
 
}

void traverse_orders()
{
   total_orders_open_live = 0;
   total_orders_open_active=0;
   total_orders_open_pending=0;
   total_open_lots=0;
   total_open_lots_buy=0;
   total_open_lots_sell=0;
   
   int open_order_type;
   pending_lots="";
   active_lots="";
 TotalrunningProfit = 0.0; 

   for (int order_position_for_selecting = 0; order_position_for_selecting < OrdersTotal(); order_position_for_selecting++) 
   {
      if (OrderSelect(order_position_for_selecting, SELECT_BY_POS, MODE_TRADES)) 
      {
         if (OrderMagicNumber() == MagicNumber  && Symbol()==OrderSymbol()) 
         {
             open_order_type = OrderType();
           // if (open_order_type == OP_BUYLIMIT || open_order_type == OP_SELLLIMIT) 
             //  continue; //skip this !
               
            if (OrderSymbol() == Symbol()) 
            {
               int current_ticket_number=OrderTicket();
               total_orders_open_live++;

               switch (open_order_type) 
               {
               case OP_BUY:
               
                  total_orders_open_active++;
                  TotalrunningProfit+=OrderProfit();
                  active_lots+="b"+digit2(OrderLots());
                  total_open_lots+=OrderLots();
                  total_open_lots_buy+=OrderLots();
                  break;
               case OP_SELL:
               
                  total_orders_open_active++;
                  TotalrunningProfit+=OrderProfit();
                  active_lots+="s"+digit2(OrderLots());
                  total_open_lots+=OrderLots();
                  total_open_lots_sell+=OrderLots();
                  break;
                  
               case OP_BUYSTOP:
               
                  total_orders_open_pending++;
               pending_lots+="b"+digit2(OrderLots());
                  break;
               case OP_SELLSTOP:
                  total_orders_open_pending++;
               pending_lots+="s"+digit2(OrderLots());
                  break;
                   
               case OP_BUYLIMIT:
               
                  total_orders_open_pending++;
               pending_lots+="b"+digit2(OrderLots());
                  break;
               case OP_SELLLIMIT:
                  total_orders_open_pending++;
               pending_lots+="s"+digit2(OrderLots());
                  break;
              }
            }
          }
        }
      }
}


double calculate_lots_to_trade()
{

traverse_orders();
//lot_size_to_trade=lots_to_start_input*MathPow((total_orders_open_live+1),2);
lot_size_to_trade=lot_size_to_trade*lots_multiplier;

if(total_orders_open_live==0 || total_orders_open_live>max_orders_depth)
   {
      lot_size_to_trade=lots_to_start_input;
   }
   return (lot_size_to_trade);
}

double get_direction(int howmanybars)
   {
      int direction=0;
      int higest_bar=iHighest(NULL,0,MODE_HIGH,howmanybars,0);
      int lowest_bar=iLowest(NULL,0,MODE_LOW,howmanybars,0);
      double highprice=iHigh(NULL, 0, higest_bar);
      double lowprice=iLow(NULL, 0, lowest_bar) ; 
      
      if(Ask > highprice ) direction=1;
      if(Bid < lowprice ) direction=-1;
      
      
      return(direction);
   }
  	 			  	   	  	  	 				    	  	 					    	  	   	   	 	 	   	 	 		  		 					 			 		  	   				 		 		  	      			   			 	 	 	 					  	 			  	 


int decide_action()
{
   int action1=0;
      double last_high=iHigh(NULL,0,1);
      double last_low=iLow(NULL,0,1);     
      if(total_orders_open_live==0)
       {
        
            if(Bid > (skind_open_currentvalue+(pips_near_open)*Point()) )
               {  action1=OP_BUYLIMIT; printf("will do buy :lastaction was "+last_action); }
            if(Ask < (skind_open_currentvalue-(pips_near_open)*Point())  )
               {  action1=OP_SELLLIMIT;printf("will do sell :lastaction was "+last_action); }
        
        }
     else
        
        {
            if(Ask > (skind_open_currentvalue-(pips_near_open)*Point()) && Ask < (skind_open_currentvalue+(pips_near_open)*Point()))
             if ( last_action==OP_SELLSTOP || last_action==OP_SELLLIMIT  ) 
               if(total_orders_open_pending <1)
               {  action1=OP_BUYSTOP; printf("will do buy :lastaction was "+last_action); }
            if(Bid < (skind_open_currentvalue+(pips_near_open)*Point()) && Bid > (skind_open_currentvalue-(pips_near_open)*Point()) )
             if (   last_action==OP_BUYLIMIT || last_action==OP_BUYSTOP ) 
               if(total_orders_open_pending <1)
               {  action1=OP_SELLSTOP;printf("will do sell :lastaction was "+last_action); }
        
        }
        
   return(action1);
}

double digit2(double val1)
{
return(NormalizeDouble(val1,2));
}

void place_order(int action1 )
{
      color clr_pending_order_open_buy=clrBlue;
      color clr_pending_order_open_sell=clrBrown;
      
      string TradeComment="PR="+(string)profit_total+"_SPR="+(string)(int)((Ask-Bid)/Point())+"_eq"+(int)AccountEquity();
       buyprice=NormalizeDouble((skind_open_currentvalue+(Ask-Bid+gapinput_pips)*Point()),Digits());
       sellprice=NormalizeDouble((skind_open_currentvalue-(Ask-Bid+gapinput_pips)*Point()),Digits());
      
      if(total_orders_open_live==0)
         calculate_lots_to_trade();
      
     
      if (action1==OP_BUYSTOP ) 
      {
         double price_tobeused = buyprice;
         double SL_tobeused_inorder = 0;
         double TP_tobeused_inorder=0;
         
         int ticket_20 = OrderSend(Symbol(), OP_BUYSTOP, lot_size_to_trade, price_tobeused, G_slippage_264, SL_tobeused_inorder, TP_tobeused_inorder, TradeComment, MagicNumber, 0, clr_pending_order_open_buy);
         if (ticket_20 <= 0) 
          {
            printf("BUYSTOP Send Error Code: " + (string)GetLastError()  +" OP="+price_tobeused +" Ask="+Ask+" Bid="+Bid+" Lot="+(string)lot_size_to_trade );
          }
         else 
            {
            calculate_lots_to_trade();
            last_action=OP_BUYSTOP;
            PlaySound("Alert.wav");
            printf("Success : buy order id = "+(string)ticket_20+" price="+(string)price_tobeused+" SL="+(string)SL_tobeused_inorder);
            }
       }
      if (action1==OP_SELLSTOP ) 
      {
         double price_tobeused = sellprice;
         double SL_tobeused_inorder = 0;
         double TP_tobeused_inorder=0;
         
         int ticket_20 = OrderSend(Symbol(), OP_SELLSTOP, lot_size_to_trade, price_tobeused, G_slippage_264, SL_tobeused_inorder, TP_tobeused_inorder, TradeComment, MagicNumber, 0, clr_pending_order_open_sell);
         if (ticket_20 <= 0) 
          {
            printf("SELLSTOP Send Error Code: " + (string)GetLastError()   +" OP="+price_tobeused +" Ask="+Ask+" Bid="+Bid+" Lot="+(string)lot_size_to_trade );
          }
         else 
            {
            calculate_lots_to_trade();
            last_action=OP_SELLSTOP;
            PlaySound("Alert.wav");
            printf("Success : sell order id = "+(string)ticket_20+" price="+(string)price_tobeused+" SL="+(string)SL_tobeused_inorder);
            }
       }      
       
     if (action1==OP_BUYLIMIT ) 
      {
         double price_tobeused = buyprice;
         double SL_tobeused_inorder = 0;
         double TP_tobeused_inorder=0;
         
         int ticket_20 = OrderSend(Symbol(), OP_BUYLIMIT, lot_size_to_trade, price_tobeused, G_slippage_264, SL_tobeused_inorder, TP_tobeused_inorder, TradeComment, MagicNumber, 0, clr_pending_order_open_buy);
         if (ticket_20 <= 0) 
          {
            printf("OP_BUYLIMIT Send Error Code: " + (string)GetLastError()  +" OP="+price_tobeused +" Ask="+Ask+" Bid="+Bid+" Lot="+(string)lot_size_to_trade );
          }
         else 
            {
            calculate_lots_to_trade();
            last_action=OP_BUYLIMIT;
            PlaySound("Alert.wav");
            printf("Success : OP_BUYLIMIT order id = "+(string)ticket_20+" price="+(string)price_tobeused+" SL="+(string)SL_tobeused_inorder);
            }
       }
      if (action1==OP_SELLLIMIT ) 
      {
         double price_tobeused = sellprice;
         double SL_tobeused_inorder = 0;
         double TP_tobeused_inorder=0;
         
         int ticket_20 = OrderSend(Symbol(), OP_SELLLIMIT, lot_size_to_trade, price_tobeused, G_slippage_264, SL_tobeused_inorder, TP_tobeused_inorder, TradeComment, MagicNumber, 0, clr_pending_order_open_sell);
         if (ticket_20 <= 0) 
          {
            printf("OP_SELLLIMIT Send Error Code: " + (string)GetLastError()   +" OP="+price_tobeused +" Ask="+Ask+" Bid="+Bid+" Lot="+(string)lot_size_to_trade );
          }
         else 
            {
            calculate_lots_to_trade();
            last_action=OP_SELLLIMIT;
            PlaySound("Alert.wav");
            printf("Success : OP_SELLLIMIT order id = "+(string)ticket_20+" price="+(string)price_tobeused+" SL="+(string)SL_tobeused_inorder);
            }
       }
}


int close_all_orders(string called_by)
   {
   
   int total = total_orders_open_live;
      
   if(total==0)
      return(0);
      
   color clr_confirm_order_close=clrNONE;
   color clr_pending_order_close=clrNONE;
   printf("Going to Close all orders now count= "+(string)OrdersTotal() + " called by="+called_by );
   int returnvalue=1;
      for (int i = total - 1; i >= 0; i--) 
      {
          if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE) 
          { 
            if ( OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber ) 
            {
                  RefreshRates();
                  if(OrderType() == OP_SELL || OrderType() == OP_BUY )
                     if( !OrderClose(OrderTicket(), OrderLots(), Bid, G_slippage_264 , clr_confirm_order_close))
                     {
                        if(!OrderClose(OrderTicket(), OrderLots(), Ask, G_slippage_264 , clr_confirm_order_close))
                     	   printf("There was an error closing buy/sell order#"+(string)OrderTicket()+". Error is:" + (string)GetLastError() );
                       returnvalue=0;
                    
                     }
                     else 
                     	   printf("Closed buy/sell("+(string)OrderType()+") order#"+(string)OrderTicket() +" PR="+(string)profit_total + "orders#"+(string)OrdersTotal() );
                     	   
                     	   
                  if(OrderType() == OP_SELLSTOP || OrderType() == OP_BUYSTOP )
                     if( !remove_pending_order(OrderTicket(),clr_pending_order_close) )
                     {
                        if( !remove_pending_order(OrderTicket(),clr_pending_order_close) )
                     	   printf("There was an error closing pending stop order#"+(string)OrderTicket()+". Error is:" + (string)GetLastError() );
                       returnvalue=0;
                     }
                     else 
                     	   printf("Deleted Pending limit order ("+(string)OrderType()+") order#"+(string)OrderTicket() +" PR="+(string)profit_total + "orders#"+(string)OrdersTotal() );
                  
                  if(OrderType() == OP_SELLLIMIT || OrderType() == OP_BUYLIMIT )
                     if( !remove_pending_order(OrderTicket(),clr_pending_order_close) )
                     {
                        if( !remove_pending_order(OrderTicket(),clr_pending_order_close) )
                     	   printf("There was an error closing pending limit order#"+(string)OrderTicket()+". Error is:" + (string)GetLastError() );
                       returnvalue=0;
                     }
                     else 
                     	   printf("Deleted Pending limit order ("+(string)OrderType()+") order#"+(string)OrderTicket() +" PR="+(string)profit_total + "orders#"+(string)OrdersTotal() );
            }
         }
      }

      set_open_line_value();    
    return(returnvalue);
   }
   
bool remove_pending_order(int ticket_number,color clr1)
   {
      bool returnvalue;
      // will work on current selected order 
      double lots_in_this_order=OrderLots();
      if( OrderDelete(ticket_number,clrWhite) )
         {
            
        printf("Closed pending order #"+(string)ticket_number);
            returnvalue=True;
         }
        else
        {
        printf("Failed to close order #"+(string)ticket_number);
            returnvalue=False;
        }
        
     return(returnvalue);

   }

void TimedClosing() 
{
   if(total_orders_open_active>0)
      return;

   int total = total_orders_open_pending;
     if (!Timed_Closing || total<=0 ) 
       return;  

      for (int i = total - 1; i >= 0; i--) 
      {
         
       if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE) 
       { 
         if ( ( OrderType() == OP_SELLSTOP || OrderType() == OP_BUYSTOP || OrderType() == OP_SELLLIMIT || OrderType() == OP_BUYLIMIT) && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) 
         {
            if (TimeCurrent() - OrderOpenTime() >= 60 * time_close_minutes ) 
            {
               OrderDelete(OrderTicket(),clrNONE);
               set_open_line_value();
            }
         }
       }
      }
 }
 
   
void set_open_line_value()
{
      skind_open_currentvalue=(Ask+Bid)/2;
      //skind_open_currentvalue=iCustom(Symbol(),Period(),"open_price_indicator",0,1);
}
   
   
/*

2022.03.28 13:35:57.863	open_level_ea_25mar22_test1 BTCUSD,M1: price Now : 46976.47 today open =46984.055 last=46984.055Equity=575.21+0=574 orders=1/1/1/1
#0 profits:
 Crpr=-0.79 Lots active=b0.02 pending=
Spread=2559.999999999854 buyprice=46984.61/8.140000000000001 sellprice=46983.5/-32.63 Ask=46976.47 Bid=46950.87
NextLot=0.03 total running_lots=0.02(B0.02S0=0.02) TP=2




*/