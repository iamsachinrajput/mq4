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
extern string baseline=",,first_candle_open,";
extern string baseline_info="daily_open,first_candle_open,hourly_open";
extern double lots_to_start_input=0.02;
extern double gapinput_pips_input=20;
double gapinput_pips=gapinput_pips_input;
extern double pips_near_open=1;
extern double take_profit_usd_input=-1;
extern double per_pip_profit_usd=.1;
extern double lots_multiplier=1.5;
extern bool Timed_Closing=True;
extern int time_close_minutes=10;
extern bool trail_profit_input=False;
bool trail_profit=trail_profit_input;
extern double trail_profit_usd_input=1;
double trail_profit_usd=trail_profit_usd_input;
extern int max_orders_depth=50;
extern bool stop_working=False;
extern bool close_all_orders_on_init=False;
extern int starting_hour=0;
extern int closing_hour=25;

#include "telegram_messages.mqh"

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
double current_session_profit=0;
bool trail_stated=False;
bool lower_profit_just_close=False;
double max_lot_size=0;
int max_equity,min_equity;
int current_session_profit_max;
int old_msg_sent_time=0;
string message_to_send;


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
   max_equity=0;
   min_equity=equity_at_start;
   old_msg_sent_time=0;
   
   set_open_line_value();      
   if(close_all_orders_on_init==True)
      close_all_orders("on init");
   
   printf("baseline="+baseline+" searchresult="+StringFind(",,"+ baseline,",daily_open,"));
   
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
   //skind_open_currentvalue_last=skind_open_currentvalue;
   int thisminute=TimeMinute(TimeCurrent());
   
   //if(TimeMinute(TimeCurrent()>55))
   //if(total_orders_open_live==0)
   if(gapinput_pips_input<0)
      gapinput_pips=get_high_low_diff(MathAbs(gapinput_pips_input)) * 1.5/Point();
      
      pips_near_open=gapinput_pips*(.2 );
   
   if(skind_open_currentvalue==0)
       set_open_line_value();
         
   if(skind_open_currentvalue!=0)
      if(current_hour>=starting_hour && current_hour<closing_hour ) 
         place_order(decide_action() );
   if(current_hour>=closing_hour)
      close_all_orders("closing hour");
   closing_of_orders();
   
   TimedClosing();
   max_equity=MathMax(max_equity,AccountEquity());
   min_equity=MathMin(min_equity,AccountEquity());
   current_session_profit_max=MathMax(current_session_profit_max,current_session_profit);
 }

   display_tasks();
   
   old_msg_sent_time=send_telegram_msg(message_to_send,"registered","hourly",old_msg_sent_time,send_telgram_message_flag);

  }
//+------------------------------------------------------------------+

double get_high_low_diff(int highlow_diff_level_1)
   {
      int higest_bar=iHighest(NULL,0,MODE_HIGH,highlow_diff_level_1,0);
      int lowest_bar=iLowest(NULL,0,MODE_LOW,highlow_diff_level_1,0);
      double highlow_diff_1=iHigh(NULL, 0, higest_bar) - iLow(NULL, 0, lowest_bar) ; 
      return(highlow_diff_1);
   }

void update_session_profit()
{
traverse_orders();
  current_session_profit = AccountEquity() -  equity_start_for_this_session ;
   if((total_orders_open_live)==0)
      {
         if(int(current_session_profit)!=0)
            {sessionid++;
            session_list=(int)current_session_profit+","+session_list;
            set_open_line_value();
            current_session_profit=0;
            }
      equity_start_for_this_session=AccountEquity();
      //skind_open_currentvalue_last=skind_open_currentvalue;
      lot_size_to_trade=lots_to_start_input;
      trail_stated=False;
   old_msg_sent_time=send_telegram_msg(message_to_send,"registered","adhoc",old_msg_sent_time,send_telgram_message_flag);
   skind_open_currentvalue=0;
      
      }
}

void closing_of_orders()
{
trail_profit=trail_profit_input;
traverse_orders();
  //current_session_profit= AccountEquity() -  equity_start_for_this_session ;
  current_session_profit=TotalrunningProfit;
if(take_profit_usd_input==-1 && trail_stated==False   )
   take_profit_usd=total_open_lots*100*per_pip_profit_usd;
   
   
if(trail_profit_usd_input<0)  // trail profit with percentage of profit . 
   trail_profit_usd=current_session_profit*MathAbs(trail_profit_usd_input)/100;
   
if( lower_profit_just_close==True  )
   {
      trail_profit==False;
      take_profit_usd=total_open_lots*100*per_pip_profit_usd/10;
   }
   
   if((total_orders_open_live)==0)
      return;
         
      
   if( skind_open_currentvalue != skind_open_currentvalue_last ) 
      {
      printf("open line changed from "+skind_open_currentvalue_last+" to "+skind_open_currentvalue );
      close_all_orders("day changed");
      }

   if(trail_profit==False)
      {  
     
      if(  current_session_profit > take_profit_usd ) 
         {
         close_all_orders(  current_session_profit +" > "+take_profit_usd);
         update_session_profit();
         }
      }
   else
         {
            if(  current_session_profit > take_profit_usd_input ) 
              {
                     if(  current_session_profit > take_profit_usd+trail_profit_usd ) 
                       {
                           take_profit_usd=take_profit_usd+trail_profit_usd;
                           trail_stated=True;
                       }
                       
              
           
                     if(  current_session_profit < ( take_profit_usd-trail_profit_usd) && trail_stated==True ) 
                       {
                           close_all_orders("trail tp Profit="+current_session_profit);
                           update_session_profit();
                           trail_stated=False;
                       }
               }
         
         }
 
}

void display_tasks()
{
   traverse_orders();
   max_orders=MathMax(max_orders,OrdersTotal());
   max_orders_active=MathMax(max_orders_active,total_orders_open_active);

   message_display=("price Now : "+Ask+" today open ="+skind_open_currentvalue +" last="+skind_open_currentvalue_last+ " start="+digit2(equity_at_start)+"/"+equity_start_for_this_session+" Pr="+digit2(AccountEquity()-equity_at_start)+" Eqt="+digit2(AccountEquity()) + " free="+digit2(AccountFreeMargin()) 
   +" Max="+max_equity+" Min="+min_equity
   +" orders="+total_orders_open_active+"/"+total_orders_open_live+"/"+max_orders_active+"/"+max_orders
   +"\n Crpr="+digit2(TotalrunningProfit)+"/"+digit2(current_session_profit_max) +" Lots active="+active_lots+" pending="+pending_lots
   + "\nSpread="+((Ask-Bid)/Point())+" buyprice="+buyprice+"/"+digit2(buyprice-Ask)+" sellprice="+sellprice+"/"+digit2(Bid-sellprice)+" Ask="+Ask+" Bid="+Bid
   +"\n Maxlots="+max_lot_size+" NextLot="+lot_size_to_trade +" total running_lots="+digit2(total_open_lots)+"(B"+digit2(total_open_lots_buy)+"S"+digit2(total_open_lots_sell)+"="+digit2(MathAbs(total_open_lots_buy-total_open_lots_sell))+") TP="+digit2(take_profit_usd)+" trail_stated="+trail_stated
   +" Gap="+gapinput_pips
   +"\n#"+sessionid+" profits:"+session_list
   ) ;
   
   message_to_send="Eqt="+(int)AccountEquity()+"(Max="+max_equity+" Min="+min_equity+")"+" orders="+total_orders_open_active+"/"+total_orders_open_live+"/"+max_orders_active
   +"\n Maxlots="+max_lot_size+" NextLot="+lot_size_to_trade +" total running_lots="+digit2(total_open_lots)+"(B"+digit2(total_open_lots_buy)+"S"+digit2(total_open_lots_sell)+"="+digit2(MathAbs(total_open_lots_buy-total_open_lots_sell))+") TP="+digit2(take_profit_usd)+" trail_stated="+trail_stated
   +"\n Crpr="+digit2(TotalrunningProfit)+"/"+digit2(current_session_profit_max) +" Lots active="+active_lots+" pending="+pending_lots
   +"\n#"+sessionid+" profits:"+session_list;
   
   Comment(message_display);
   //printf(message_display);
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
             max_lot_size=MathMax(max_lot_size,OrderLots());
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
                  TotalrunningProfit+=OrderProfit()-OrderCommission();
                  active_lots+="b"+digit2(OrderLots());
                  total_open_lots+=OrderLots();
                  total_open_lots_buy+=OrderLots();
                  break;
               case OP_SELL:
               
                  total_orders_open_active++;
                  TotalrunningProfit+=OrderProfit()-OrderCommission();
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
   lower_profit_just_close=False;
   //lot_size_to_trade=lots_to_start_input*MathPow((total_orders_open_live+1),2);
   lot_size_to_trade=lot_size_to_trade*lots_multiplier;
  
  if(lots_multiplier==-1) // will use add . 
      lot_size_to_trade=lots_to_start_input*(total_orders_open_active+1);
  if(lots_multiplier==-2) // will use add . 
      lot_size_to_trade=lots_to_start_input*(total_orders_open_active+2);
  
   if(total_orders_open_live==0 )
         lot_size_to_trade=lots_to_start_input;
      
   if( total_orders_open_live>max_orders_depth)
      {
         //close_all_orders("Bad Luck; reached max count : Loss="+current_session_profit );
         lot_size_to_trade=lots_to_start_input;
         lower_profit_just_close=True;
      }

   if( total_orders_open_live>max_orders_depth+2)
      {
         close_all_orders("Bad Luck; reached max count : Loss="+current_session_profit );
         lot_size_to_trade=lots_to_start_input;
         // lower_profit_just_close=True;
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
      //if(total_orders_open_live==0 && StringFind( baseline,",first_candle_open,")<1 )
      if(total_orders_open_live==0 )
       {
       
         double buylimitprice=(skind_open_currentvalue+(pips_near_open)*Point());
         double selllimitprice=(skind_open_currentvalue-(pips_near_open)*Point());
        
            if(Bid > buylimitprice )
               {  action1=OP_BUYLIMIT; printf("will do buy :lastaction was "+last_action +" Bid:"+ Bid +">"+ buylimitprice ) ; }
            if(Ask < selllimitprice  )
               {  action1=OP_SELLLIMIT;printf("will do sell :lastaction was "+last_action +" Ask:"+ Ask +"<"+ selllimitprice  ); }
        
        }
     else
        
        {
        double upline=(skind_open_currentvalue+(pips_near_open*Point() ));
        double downline=(skind_open_currentvalue-(pips_near_open*Point() ));
       //buyprice=NormalizeDouble((skind_open_currentvalue+(Ask-Bid+gapinput_pips)*Point()),Digits());
       //sellprice=NormalizeDouble((skind_open_currentvalue-(Ask-Bid+gapinput_pips)*Point()),Digits());
        
        remove_line("buyline_1");
        remove_line("sellline_1");
        draw_hline("buyline_1","nextbuylots="+lot_size_to_trade+" CV="+skind_open_currentvalue+" upline="+buyprice+" downline="+sellprice,upline,clrBlue,1);
        draw_hline("sellline_1","nextselllots="+lot_size_to_trade+" CV="+skind_open_currentvalue+" upline="+buyprice+" downline="+sellprice,downline,clrYellow,1);
        
       buyprice=NormalizeDouble((skind_open_currentvalue+(Ask-Bid+gapinput_pips)*Point()),Digits());
       sellprice=NormalizeDouble((skind_open_currentvalue-(Ask-Bid+gapinput_pips)*Point()),Digits());
   
        remove_line("buyline");
        remove_line("sellline");
        draw_hline("buyline","nextbuylots="+lot_size_to_trade+" CV="+skind_open_currentvalue+" upline="+buyprice+" downline="+sellprice,buyprice,clrBlue,3);
        draw_hline("sellline","nextselllots="+lot_size_to_trade+" CV="+skind_open_currentvalue+" upline="+buyprice+" downline="+sellprice,sellprice,clrYellow,3);
         
            if(Ask > downline && Ask < buyprice )
             if ( last_action==OP_SELLSTOP || last_action==OP_SELLLIMIT  ) 
               if(total_orders_open_pending <1)
               {  action1=OP_BUYSTOP; printf("will do buy :lastaction was "+last_action); }
            if(Bid < upline && Bid > sellprice )
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
 
     void remove_line(string linename)
        {
            ObjectDelete(0,linename);
        }

    void draw_hline(string linename,string sometext,double location ,color linecolor,int thickness)
        {
                //ObjectDelete("startline");
                //if(check_input(linename,"next_"))
                   {
                    ObjectDelete(linename);
                    ObjectCreate(0,linename,OBJ_HLINE,0,Time[0],location);
                    ObjectSetInteger(0,linename,OBJPROP_COLOR,linecolor);
                    ObjectSetInteger(0,linename,OBJPROP_STYLE,STYLE_DASHDOTDOT);
                    ObjectSetInteger(0,linename,OBJPROP_WIDTH,thickness);
                    ObjectSetText(linename,sometext,3,0,clrAqua);
                    ObjectSetInteger(0,linename,OBJPROP_BACK,TRUE);

                   }

        }



void set_open_line_value()
{

   //printf("openlinesetting:baseline="+baseline+" searchresult="+StringFind( baseline,",daily_open,") ) ;
   
   
   if(StringFind( baseline,",daily_open,")>0)
      skind_open_currentvalue=iCustom(Symbol(),Period(),"open_price_indicator",0,1);
   if(StringFind( baseline,",weekly_open,")>0)
      skind_open_currentvalue=iCustom(Symbol(),Period(),"open_price_indicator",0,1);
      
   if(StringFind( baseline,",first_candle_open,")>0)
      skind_open_currentvalue=(Ask+Bid)/2;
  
  if(skind_open_currentvalue_last!=skind_open_currentvalue)
   {
   
         remove_line("openline");
      draw_hline("openline",skind_open_currentvalue,skind_open_currentvalue,clrAliceBlue,1);


       buyprice=NormalizeDouble((skind_open_currentvalue+(Ask-Bid+gapinput_pips)*Point()),Digits());
       sellprice=NormalizeDouble((skind_open_currentvalue-(Ask-Bid+gapinput_pips)*Point()),Digits());
   
        remove_line("buyline");
        remove_line("sellline");
        draw_hline("buyline","nextbuylots="+lot_size_to_trade+" CV="+skind_open_currentvalue+" upline="+buyprice+" downline="+sellprice,buyprice,clrBlue,4);
        draw_hline("sellline","nextselllots="+lot_size_to_trade+" CV="+skind_open_currentvalue+" upline="+buyprice+" downline="+sellprice,sellprice,clrYellow,4);
        
      
      skind_open_currentvalue_last=skind_open_currentvalue;
   }
      
}
   
   
/*

2022.03.28 13:35:57.863	open_level_ea_25mar22_test1 BTCUSD,M1: price Now : 46976.47 today open =46984.055 last=46984.055Equity=575.21+0=574 orders=1/1/1/1
#0 profits:
 Crpr=-0.79 Lots active=b0.02 pending=
Spread=2559.999999999854 buyprice=46984.61/8.140000000000001 sellprice=46983.5/-32.63 Ask=46976.47 Bid=46950.87
NextLot=0.03 total running_lots=0.02(B0.02S0=0.02) TP=2

2022.03.28 18:29:12.381	2022.03.24 23:59:09  open_level_ea_25mar22_good1 EURUSD,M1: price Now : 1.10093 today open =1.099945 last=1.099945 start=1000/3800 Pr=2800.02 Eqt=3800.02 free=3798.37 orders=5/5/20/20
#281 profits:1,525,-2530,1,4,13,2,2,1,1,1,19,-2710,68,1,1,3,12,1,2,1,155,2,3,1,19,29,29,8,30,8,1,19,3,2,1,1,5,8,1778,1,30,1,3,1,1,4,1,5,5,1,1,1,1,1,1,1,2,1,6,2,1,8,1,1,1,1,1,5,1,45,2,1,3,1,1,5,1,155,46,1,103,45,5,3,99,1,157,1,68,45,2,1,1,8,1,12,44,45,5,2,1,2,19,1,-2709,1,154,1,1,103,5,1,1,2,2,1,1,1,68,1,1,5,30,1,1,1,1,1,69,1,


2022.03.28 18:34:53.296	2022.03.24 23:59:09  open_level_ea_25mar22_good1 EURUSD,M1: price Now : 1.10093 today open =1.099945 last=1.099945 start=1000/3800 Pr=2800.02 Eqt=3800.02 free=3798.37 orders=5/5/20/20
#281 profits:1,525,-2530,1,4,13,2,2,1,1,1,19,-2710,68,1,1,3,12,1,2,1,155,2,3,1,19,29,29,8,30,8,1,19,3,2,1,1,5,8,1778,1,30,1,3,1,1,4,1,5,5,1,1,1,1,1,1,1,2,1,6,2,1,8,1,1,1,1,1,5,1,45,2,1,3,1,1,5,1,155,46,1,103,45,5,3,99,1,157,1,68,45,2,1,1,8,1,12,44,45,5,2,1,2,19,1,-2709,1,154,1,1,103,5,1,1,2,2,1,1,1,68,1,1,5,30,1,1,1,1,1,69,1,

2022.03.28 22:26:09.005	2022.03.24 16:35:16  open_level_ea_25mar22_good1 EURUSD,M1: price Now : 1.09975 today open =1.1006 last=1.1006 start=1000/4346 Pr=-993.8200000000001 Eqt=6.18 free=-1496.22 orders=12/12/12/13
#70 profits:1,1,3,1,3,1,1,1,3,821,13,1,1,51,1,1,206,1,1,3,3,12,1,3,1,6,3,13,1,1,1,1,1,820,210,6,1,1,3,6,1,33,1,1,3,3,1,1,206,1,1,1,3,6,1,209,2,6,3,423,50,3,3,105,1,13,3,1,51,1,
 Crpr=-4340.7/-4340.7 Lots active=s0.02b0.04s0.08b0.16s0.32b0.64s1.28b2.56s5.12b10.24s20.48b40.96 pending=
Spread=7.000000000001449 buyprice=1.


2022.03.28 22:38:33.793	2022.03.07 07:16:03  open_level_ea_25mar22_good1 GBPUSD,M1: price Now : 1.32235 today open =1.32118 last=1.32118 start=10000/10405 Pr=-9916.16 Eqt=83.84 free=-3524.16 orders=13/13/13/14
#17 profits:3,6,3,6,102,1,26,3,1,1,1,3,3,26,1,213,6,
 Crpr=-10322.14/-10322.14 Lots active=s0.02b0.04s0.08b0.16s0.32b0.64s1.28b2.56s5.12b10.24s20.48b40.96s81.92 pending=
Spread=11.99999999998979 buyprice=1.32138/0 sellprice=1.32098/0 Ask=1.32235 Bid=1.32223
 Maxlots=163.84 NextLot=327.68 total running_lots=163.82(B54.6S109.

2022.03.28 22:42:41.673	2022.03.08 17:18:27  open_level_ea_25mar22_good1 GBPUSD,M1: price Now : 1.3122 today open =1.31136 last=1.31136 start=10000/10104 Pr=-9972.84 Eqt=27.16 free=-1790.36 orders=45/45/44/45
#8 profits:2,30,2,1,36,1,1,31,
 Crpr=-10077.08/-10077.08 Lots active=b0.02s0.02b0.02s0.03b0.04s0.04b0.05s0.07000000000000001b0.08s0.1b0.12s0.14b0.17s0.21b0.25s0.3b0.36s0.44b0.53s0.63b0.76s0.92b1.1s1.32b1.58s1.9b2.28s2.74b3.29s3.95b4.74s5.69b6.83s8.199999999999999b9.84s11.81b14.17s17.01b20.41s24.49b29.39s35.27b42.32s50.79 pen

2022.03.29 12:58:23.464	2022.03.27 23:59:51  open_level_ea_25mar22_good1 GBPUSD,M1: price Now : 1.31737 today open =1.32659 last=1.32659 start=10000/10436 Pr=422.67 Eqt=10422.67 free=10419.36 orders=2/2/10/10
#55 profits:115,2,2,1,1,3,1,3,1,1,183,2,2,2,1,25,3,1,2,1,3,3,1,1,2,2,7,6,2,1,2,1,5,2,2,1,2,1,2,2,2,2,1,2,2,1,1,4,1,1,9,2,3,2,3,
 Crpr=-11.9/-11.9 Lots active=b0.1s0.15 pending=
Spread=7.000000000001449 buyprice=1.32728/0.01 sellprice=1.3259/-0.01 Ask=1.31737 Bid=1.3173
 Maxlots=3.84 NextLot=0.225 total running_lots=0.25(B0.1


2022.03.29 13:08:28.601	2022.03.27 23:59:51  open_level_ea_25mar22_good1 GBPUSD,M1: price Now : 1.31737 today open =1.32659 last=1.32659 start=10000/10100 Pr=0.6899999999999999 Eqt=10000.69 free=9994.059999999999 orders=1/1/1/1
#58 profits:4,1,3,1,1,1,1,1,1,1,1,2,4,3,2,2,2,2,2,1,2,1,1,3,1,1,1,2,2,1,1,2,2,1,3,3,1,1,2,2,2,2,1,2,2,2,1,1,1,1,1,2,1,2,2,3,2,3,
 Crpr=-99.5/-99.5 Lots active=b0.1 pending=
Spread=7.000000000001449 buyprice=1.32728/0.01 sellprice=1.3259/-0.01 Ask=1.31737 Bid=1.3173
 Maxlots=0.1 NextLot=0.15 total running_l

2022.03.29 13:49:46.966	2022.03.27 23:59:51  open_level_ea_25mar22_good1 GBPUSD,M1: price Now : 1.31737 today open =1.32659 last=1.32659 start=10000/16076 Pr=5941.49 Eqt=15941.49 free=15908.37 orders=2/2/10/10
#187 profits:1340,25,30,8,11,10,37,16,41,10,14,21,663,11,22,15,14,14,10,13,15,170,19,11,21,16,31,50,14,13,16,19,21,10,18,21,10,23,53,11,90,11,10,17,12,11,10,15,17,18,15,23,18,13,13,16,11,53,14,14,9,30,10,10,18,35,203,10,11,52,10,14,20,16,12,10,17,17,10,11,33,18,20,14,10,11,10,22,21,10,17,17,12,13,9,37,19,14,66,23,20,10,21,1







*/