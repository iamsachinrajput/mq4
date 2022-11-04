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
extern string baseline=",,,";
extern string baseline_info="monthly_open,4hour_open,open_15min,daily_open,first_candle_open,hourly_open,weekly_open,";
extern double lots_to_start_input=0.01;
extern double lots_multiplier=-5;
extern double set_take_profit_pip_input=0;
extern double set_sl_pip_input=0;
extern double sl_usd_input=0;
extern int barsgap=5;
extern int mavolshort=3;
extern int mavollong=3;
extern double mavoldiff_multiplier=2;
extern int mavolshifted=3;
extern bool same_position_ok=False;
extern bool lower_profit_just_close=False;
extern bool chang_gap_for_martingle=False;
extern double take_profit_usd_input=0;
extern double per_lot_profit_usd=1;
extern bool trail_profit_input=False;
extern bool add_extra_on_trail=False;
extern double trail_profit_usd_input=0;
extern int max_orders_depth=100;
extern bool close_all_on_new_lines=False;
extern int newline_wait_minutes=15;
extern bool reverse_input=False;
bool reverse=reverse_input;
bool close_on_opposit=True;
bool trail_profit=trail_profit_input;
int barcountnow,lastbarscount;

extern double gapinput_pips_input=20;
double gapinput_pips=gapinput_pips_input;
extern double gap_multiplier=1;
extern double pips_near_open=1;


extern bool Timed_Closing=False;
extern int time_close_minutes=10;


double trail_profit_usd=trail_profit_usd_input;
extern bool stop_working=False;
extern bool close_all_orders_on_init=False;
extern int starting_hour=0;
extern int closing_hour=25;

#include "telegram_messages.mqh"

int profit_total,G_slippage_264,MagicNumber;
int action,max_orders,max_orders_active;
int last_action=10;
double equity_start_for_this_session;
string lots_to_work;
double skind_open_currentvalue,equity_at_start;
double lot_size_to_trade=lots_to_start_input;
   int total_orders_open_active=0;
   int total_orders_open_pending=0;
   int total_orders_open_live=0;
double take_profit_usd=take_profit_usd_input;
double sl_usd;
double daily_first15_min_high=0;
double daily_first15_min_low=0;

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
bool trail_stared=False;
double max_lot_size=0;
int max_equity,min_equity;
int current_session_profit_max;
int old_msg_sent_time=0;
string message_to_send,message_to_print;
double open_today,open_1hour,open_15min;
double closeprice,openprice;
double trades_inloss,trades_inprofit;
int current_session_orders_count=0;
       //ADI indicator 
            input int skind_adi_input1_SIGNAL_PERIOD=12;
            input int skind_adi_input2_ARROW_PERIOD=2;
            input int skind_adi_input3_SL_PIPS=100;
            input int skind_adi_input4_AlertON=False;
            input int skind_adi_input5_Email=False;
            

        // variables for indicator aditya_indicator02 
        const string skind_adi="aditya_indicator02";
        const double skind_adi_output1_uptrend_stop=0;
        const double skind_adi_output2_downtrend_stop=1;
        const double skind_adi_output3_uptrend_signal=2;
        const double skind_adi_output4_downtrend_signal=3;
        const double skind_adi_output5_uptrend_line=4;
        const double skind_adi_output6_downtrend_line=5;

        double skind_adi_uptrend_value_prev=0,skind_adi_uptrend_value=0;
        double skind_adi_downtrend_value_prev=0,skind_adi_downtrend_value=0;


       //ssl gann indicator 
            input int skind_ssl_gann_input1_LB=11;
            input int skind_ssl_gann_input2_MA=2;
            input bool skind_ssl_gann_input3_alert_on_current=False;

        // variables for indicator ssl gann 
        const string skind_ssl_gann="ssl_gann_indic_6sep";
        const double skind_ssl_gann_output1_buy_value=0;
        const double skind_ssl_gann_output2_sell_value=1;
        const double skind_ssl_gann_output3=2;

        double skind_ssl_gann_uptrend_value_prev=0,skind_ssl_gann_uptrend_value=0;
        double skind_ssl_gann_downtrend_value_prev=0,skind_ssl_gann_downtrend_value=0;
        
        double skind_vjsnipper_out1_value_prev=0,skind_vjsnipper_out1_value=0;
        double skind_vjsnipper_out2_value_prev=0,skind_vjsnipper_out2_value=0;


double mavolshortval,mavollongval;

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
      close_all_orders(100,"on init");
   
  // printf("baseline="+baseline+" searchresult="+StringFind(",,"+ baseline,",daily_open,"));
      
      
      sl_usd=sl_usd_input*-1;
      if(sl_usd_input<0)
         sl_usd=AccountEquity()*sl_usd_input/100;
      if(sl_usd_input==0)
         sl_usd=AccountEquity()*sl_usd_input/100;
         
   traverse_orders();
   if(total_open_lots >0 ) 
      lot_size_to_trade=total_open_lots;
   
   
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
   int thisminute=TimeMinute(TimeCurrent());
   mavolshortval=mavol(mavolshort,0);
   mavollongval=mavol(mavollong,mavolshifted);
   
         closeprice=iClose(Symbol(),0,1);
         openprice=iOpen(Symbol(),0,1);
   
   if(gapinput_pips_input<0)
      gapinput_pips=get_high_low_diff(MathAbs(gapinput_pips_input)) * gap_multiplier/Point();
      
      pips_near_open=gapinput_pips*(.2 );
   
       set_open_line_value();
         
   if(skind_open_currentvalue!=0 && 1==0 )
      if(current_hour>=starting_hour && current_hour<closing_hour ) 
         place_order(decide_action_gap() );
         
  place_order(decide_action_adi() );
         
   if(current_hour>=closing_hour)
      close_all_orders(100,"closing hour");
   closing_of_orders();
   
   TimedClosing();
   max_equity=MathMax(max_equity,AccountEquity());
   min_equity=MathMin(min_equity,AccountEquity());
   current_session_profit_max=MathMax(current_session_profit_max,current_session_profit);
 }
   update_session_profit();
   display_tasks();
   
   old_msg_sent_time=send_telegram_msg(message_to_send,"registered","hourly",old_msg_sent_time,send_telgram_message_flag);

  }
//+------------------------------------------------------------------+

    void indicator_adi_fill_details()
        {
            //values filling for New Indicator from aditya  
            double
                skind_adi_uptrend_value_prev=skind_adi_uptrend_value;
                skind_adi_downtrend_value_prev=skind_adi_downtrend_value;

                // fill only previous value current using 0 will not work.
                skind_adi_uptrend_value=iCustom(Symbol(),Period(),skind_adi,
                                                        skind_adi_input1_SIGNAL_PERIOD,skind_adi_input2_ARROW_PERIOD,skind_adi_input3_SL_PIPS,skind_adi_input4_AlertON,skind_adi_input5_Email,
                                                        skind_adi_output3_uptrend_signal,1);
                skind_adi_downtrend_value=iCustom(Symbol(),Period(),skind_adi,
                                                        skind_adi_input1_SIGNAL_PERIOD,skind_adi_input2_ARROW_PERIOD,skind_adi_input3_SL_PIPS,skind_adi_input4_AlertON,skind_adi_input5_Email,
                                                        skind_adi_output4_downtrend_signal,1);
                
                if(skind_adi_uptrend_value>0 || skind_adi_downtrend_value>0 )
                    {
                    printf("UP="+skind_adi_uptrend_value+" Down="+skind_adi_downtrend_value);
                    }

      }

    void indicator_ssl_gann_fill_details()
        {
            //values filling for New Indicator from aditya  
            
                skind_ssl_gann_uptrend_value_prev=skind_ssl_gann_uptrend_value;
                skind_ssl_gann_downtrend_value_prev=skind_ssl_gann_downtrend_value;

                // fill only previous value current using 0 will not work.
                //skind_ssl_gann : timeframe , LB, Ma , multicolor , note,alertson,alertsoncurrent ,alertsonmsg,alertsonsound,alertsemail ,soundfile, 
                
                //sknewind_adi_16sep22
               
               /* 
                skind_ssl_gann_uptrend_value=iCustom(Symbol(),Period(),skind_ssl_gann,
                                                        0,skind_ssl_gann_input1_LB,skind_ssl_gann_input2_MA,True,"none",True,skind_ssl_gann_input3_alert_on_current,True,False,"alert.wav",
                                                        skind_ssl_gann_output1_buy_value,1);
                skind_ssl_gann_downtrend_value=iCustom(Symbol(),Period(),skind_ssl_gann,
                                                        0,skind_ssl_gann_input1_LB,skind_ssl_gann_input2_MA,True,"none",True,skind_ssl_gann_input3_alert_on_current,True,False,"alert.wav",
                                                        skind_ssl_gann_output2_sell_value,1);
                */
                skind_ssl_gann_uptrend_value=iCustom(Symbol(),Period(),"sknewind_adi_16sep22",1,0);
                skind_ssl_gann_downtrend_value=iCustom(Symbol(),Period(),"sknewind_adi_16sep22",2,0);
                
               /*
                if(skind_ssl_gann_uptrend_value>0 || skind_ssl_gann_downtrend_value>0 )
                    {
                    printf("Ask="+Ask+" Bid="+Bid+"closeprice="+closeprice+" ssl gann : UP="+skind_ssl_gann_uptrend_value+" Down="+skind_ssl_gann_downtrend_value);
                    }
                */

      }
      
    void indicator_vjsnipper()
        {
            //values filling for New Indicator from aditya  
            
                skind_vjsnipper_out1_value_prev=skind_vjsnipper_out1_value;
                skind_vjsnipper_out2_value_prev=skind_vjsnipper_out2_value;

                skind_vjsnipper_out1_value=iCustom(Symbol(),Period(),"vjsnipper",0,0);
                skind_vjsnipper_out2_value=iCustom(Symbol(),Period(),"vjsnipper",1,0);
                
                if(skind_vjsnipper_out1_value!=skind_vjsnipper_out2_value)
                    printf("Bid="+Bid+" Ask="+Ask+"closeprice="+closeprice+" vjsnipper : O1="+skind_vjsnipper_out1_value+" O2="+skind_vjsnipper_out2_value);

      }
    string buy_sell_with_vjsnipper()
        {
            indicator_vjsnipper();
            string returnvalue="none";
            if(skind_vjsnipper_out1_value!=skind_vjsnipper_out2_value && skind_vjsnipper_out1_value<Bid )
                returnvalue="buy";
            else if(skind_vjsnipper_out1_value!=skind_vjsnipper_out2_value && skind_vjsnipper_out2_value>Ask)
                returnvalue="sell";
            if(returnvalue!="none" ) 
            printf("22 : vjsnipper : out1="+skind_vjsnipper_out1_value+" out2="+skind_vjsnipper_out2_value + " Action ="+returnvalue );
         
            return(returnvalue);
        }

    string buy_sell_with_adionly()
        {
            indicator_adi_fill_details();
            string returnvalue="none";
            if(skind_adi_uptrend_value>1 )
                returnvalue="buy";
            if(skind_adi_downtrend_value>1 )
                returnvalue="sell";

            return(returnvalue);
        }
    string buy_sell_with_ssl_gann()
        {
            indicator_ssl_gann_fill_details();
            string returnvalue="none";
            if(skind_ssl_gann_uptrend_value<skind_ssl_gann_downtrend_value )
                returnvalue="sell";
            else if(skind_ssl_gann_downtrend_value<skind_ssl_gann_uptrend_value)
                returnvalue="buy";
           
            //printf("22 : ssl gann : UP="+skind_ssl_gann_uptrend_value+" Down="+skind_ssl_gann_downtrend_value + " Action ="+returnvalue );
         
            return(returnvalue);
        }
 
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
   if((total_orders_open_active)==0  )
      {
         current_session_profit = AccountEquity() -  equity_start_for_this_session ;
         if((current_session_profit)!=0)
            {
            sessionid++;
            //session_list=(int)current_session_profit+","+session_list;
            session_list=digit1(current_session_profit)+","+session_list;
            if(current_session_profit>0)
               trades_inprofit++;
            if(current_session_profit<0)
               trades_inloss++;
            current_session_profit=0;
         equity_start_for_this_session=AccountEquity();
            }
      //skind_open_currentvalue_last=skind_open_currentvalue;
      lot_size_to_trade=lots_to_start_input;
      //trail_stared=False;
   old_msg_sent_time=send_telegram_msg(message_to_send,"registered","adhoc",old_msg_sent_time,send_telgram_message_flag);
   //skind_open_currentvalue=0;
      
      }
}

void closing_of_orders()
{
trail_profit=trail_profit_input;
traverse_orders();
if((total_orders_open_live)==0 || (take_profit_usd_input)==0 )
   return;

  //current_session_profit= AccountEquity() -  equity_start_for_this_session ;
current_session_profit=TotalrunningProfit;
if(take_profit_usd_input==-1 && trail_stared==False   )
   take_profit_usd=total_open_lots*100*per_lot_profit_usd;
   else if(take_profit_usd_input==-2 && trail_stared==False   )
         take_profit_usd=2*total_open_lots*100*per_lot_profit_usd;
      else if(trail_profit_usd_input<0)  // trail profit with percentage of profit . 
               trail_profit_usd=current_session_profit*MathAbs(trail_profit_usd_input)/100;
 
if( lower_profit_just_close==True  )
{
   trail_profit==False;
   take_profit_usd=total_open_lots*100*per_lot_profit_usd/10;
}
        
      
   if( skind_open_currentvalue != skind_open_currentvalue_last ) 
      {
      printf("open line changed from "+skind_open_currentvalue_last+" to "+skind_open_currentvalue );
      close_all_orders(100,"Area changed ");
      }

   if(trail_profit==False)
      {  
     
      if(  current_session_profit > take_profit_usd ) 
         {
         close_all_orders(100, "TP without trail "+ current_session_profit +" > "+take_profit_usd);
         //update_session_profit();
         }
      }
   else
         {
            if(  current_session_profit > take_profit_usd_input ) 
              {
                     if(  current_session_profit > take_profit_usd+trail_profit_usd ) 
                       {
                           take_profit_usd=take_profit_usd+trail_profit_usd*MathAbs(total_open_lots_sell-total_open_lots_buy);
                           trail_stared=True;
                           if(add_extra_on_trail==True)
                             {
                              place_order(add_extra() );
                              printf(" %%%%%%% adding extra for trail : CRP= "+current_session_profit);
                              }
                              
                       }
                       
              
           
                     if(  current_session_profit < ( take_profit_usd-trail_profit_usd*MathAbs(total_open_lots_sell-total_open_lots_buy)) && trail_stared==True ) 
                       {
                           close_all_orders(100,"trail tp Profit="+current_session_profit);
                           take_profit_usd=0;
                           //update_session_profit();
                           trail_stared=False;
                       }
               }
               
                
         }
         
   if(  current_session_profit <= (sl_usd) && sl_usd!=0 ) 
      {
                  close_all_orders(100,"SL closing orders as profit "+current_session_profit +" is less then SL"+sl_usd);
                  //update_session_profit();
      }
      
      
 
}

void display_tasks()
{
   traverse_orders();
   max_orders=MathMax(max_orders,OrdersTotal());
   max_orders_active=MathMax(max_orders_active,total_orders_open_active);

   message_display=("price Now : "+Ask+baseline+skind_open_currentvalue+"hight="+buyprice+" low="+sellprice+" last="+skind_open_currentvalue_last+ " start="+digit2(equity_at_start)+"/"+digit2(equity_start_for_this_session)+" Pr="+digit2(AccountEquity()-equity_at_start)+ " rt="+TotalrunningProfit+" Eqt="+digit2(AccountEquity()) + " free="+digit2(AccountFreeMargin()) 
   +" Max="+max_equity+" Min="+min_equity
   +" orders="+total_orders_open_active+"/"+total_orders_open_live+"/"+max_orders_active+"/"+max_orders 
   +"\n Crpr="+(TotalrunningProfit)+"("+(current_session_profit_max)+")/"+take_profit_usd_input +" Orders="+total_orders_open_active+" Lots active="+active_lots+" pending="+pending_lots
   + "\nSpread="+digit2((Ask-Bid)/Point())+" buyprice="+buyprice+"/"+digit2(buyprice-Ask)+" sellprice="+sellprice+"/"+digit2(Bid-sellprice)+" Ask="+Ask+" Bid="+Bid
   +"\n Maxlots="+max_lot_size+" NextLot="+lot_size_to_trade +" total running_lots="+digit2(total_open_lots)+"(B"+digit2(total_open_lots_buy)+"S"+digit2(total_open_lots_sell)+"="+digit2((total_open_lots_buy-total_open_lots_sell))+") SL="+sl_usd+" TP="+digit2(take_profit_usd)+" MTP="+digit2(take_profit_usd-trail_profit_usd*MathAbs(total_open_lots_sell-total_open_lots_buy) )+" trail_stared="+trail_stared
   +" Gap="+gapinput_pips +" MNP="+(per_lot_profit_usd*total_open_lots/Point())
   +"\n#"+sessionid+"(P="+trades_inprofit+" L="+trades_inloss+") profits:"+session_list
   +"\n reverse="+reverse+" mavol-S="+digit1(mavolshortval)+" mavol-L="+digit1(mavollongval)
   ) ;
   
   message_to_print=("Pr="+digit2(AccountEquity()-equity_at_start)+" Max="+max_equity+" Min="+min_equity+" #"+sessionid+"(P="+trades_inprofit+" L="+trades_inloss+") profits:"+session_list);
   
   message_to_send="Eqt="+(int)AccountEquity()+"(Max="+max_equity+" Min="+min_equity+")"+" orders="+total_orders_open_active+"/"+total_orders_open_live+"/"+max_orders_active
   +"\n Maxlots="+max_lot_size+" NextLot="+lot_size_to_trade +" total running_lots="+digit2(total_open_lots)+"(B"+digit2(total_open_lots_buy)+"S"+digit2(total_open_lots_sell)+"="+digit2(MathAbs(total_open_lots_buy-total_open_lots_sell))+") TP="+digit2(take_profit_usd)+" MTP="+digit2(take_profit_usd-trail_profit_usd)+" trail_stared="+trail_stared +" MNP="+(per_lot_profit_usd*total_open_lots/Point())
   +"\n Crpr="+digit2(TotalrunningProfit)+"/"+digit2(current_session_profit_max) +" Lots active="+active_lots+" pending="+pending_lots
   +"\n#"+sessionid+"(P="+trades_inprofit+" L="+trades_inloss+") profits:"+session_list;
   
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
 
if(OrdersTotal()==0)
   current_session_orders_count=0;

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
   if(lots_multiplier>0)
      lot_size_to_trade=lot_size_to_trade*lots_multiplier;
  
  if(lots_multiplier==-1) // will use add . 
      lot_size_to_trade=lots_to_start_input*(total_orders_open_active+1);
  if(lots_multiplier==-3) // will use total of open lots  . 
      lot_size_to_trade=total_open_lots+lots_to_start_input;
  if(lots_multiplier==-4) // will use total of open lots  . 
      lot_size_to_trade=MathMax(total_open_lots_buy,total_open_lots_sell)+lots_to_start_input;

  if(lots_multiplier==-6) // will use total of open lots  . 
      lot_size_to_trade=current_session_orders_count*lots_to_start_input+lots_to_start_input;


  if(lots_multiplier==-5) // will use custom lots   . 
      if(lot_size_to_trade < 1 )
         lot_size_to_trade=lot_size_to_trade*3+lots_to_start_input;
       else if(lot_size_to_trade<10)
         lot_size_to_trade=lot_size_to_trade*2;
       else if(lot_size_to_trade<50)
         lot_size_to_trade=lot_size_to_trade+10;
         else
            lot_size_to_trade=lot_size_to_trade+50;


  if(lots_multiplier==-2) // will use add . 
      lot_size_to_trade=lots_to_start_input*(total_orders_open_active+1);
  
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
         close_all_orders(100,"Bad Luck; reached max count : Loss="+current_session_profit );
         lot_size_to_trade=lots_to_start_input;
         // lower_profit_just_close=True;
      }
         
      return (MathMin(200,digit2(lot_size_to_trade)));
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
 
double mavol(int periode,int shifted)
   {
   double buffer[100];
   int i,limit=ArraySize(buffer);
   ArraySetAsSeries(buffer,true);
   
   for(i=0; i<limit; i++)
   buffer[i]=Volume[i];
   
   double ma=iMAOnArray(buffer,limit,periode,0,MODE_SMA,shifted);
   return (ma);
   } 	 			  	   	  	  	 				    	  	 					    	  	   	   	 	 	   	 	 		  		 					 			 		  	   				 		 		  	      			   			 	 	 	 					  	 			  	 

int decide_action_adi()
   {
      int action1=20;
      double last_high=iHigh(NULL,0,1);
      double last_low=iLow(NULL,0,1);     
      //if(total_orders_open_live==0 && StringFind( baseline,",first_candle_open,")<1 )
      traverse_orders();
         barcountnow=Bars;
      if(total_orders_open_live<=max_orders_depth )
      if(barcountnow>=lastbarscount+barsgap || total_orders_open_live==0  ) 
       {
        string action_decided=buy_sell_with_vjsnipper();
        
        
        
        //### for drawing lines . 
        //if( ( reverse==False && action_decided=="buy" && ( last_action==OP_SELL ) )  || ( reverse==True && action_decided=="sell" && last_action==OP_BUY ) )
        if(action_decided=="buy" )
            draw_vline("buy"+barcountnow +" PR="+current_session_profit,"buystart",closeprice,clrGreen,2);
               else if(action_decided=="sell" )
                  draw_vline("sell"+barcountnow+" PR="+current_session_profit,"sellstart",closeprice,clrRed,2);
        
        //### shuffle reverse order based on mavol 
        if(reverse_input==True && mavoldiff_multiplier!=-1)
        {
            reverse=True ;
        if ( mavolshortval > mavoldiff_multiplier*  mavollongval ) 
         reverse=False;
        else if ( mavolshortval * mavoldiff_multiplier <  mavollongval ) 
            reverse=True ;
        }    
                 
        // for main buy sell signals 
            //if(buy_sell_with_ssl_gann()=="buy" && ( True || last_action==OP_SELL || total_orders_open_live==0 || same_position_ok==True ) && barcountnow!=lastbarscount)
        if(    ( reverse==False && action_decided=="sell" && ( total_orders_open_live==0 || ( same_position_ok==True || last_action==OP_BUY ) )) || ( reverse==True && action_decided=="buy" &&  ( total_orders_open_live==0 || (same_position_ok==True || last_action==OP_BUY ) )  )  )
               {  
                 action1=OP_SELL;
                 printf("will do sell  of "+lot_size_to_trade+" lots lastaction= "+last_action +" TOrders="+total_orders_open_live+" Ask:"+ Ask + " action_decided="+action_decided+" reverse="+reverse  );
                 lastbarscount=barcountnow;

               } 
           else if( ( reverse==False  && action_decided=="buy" && ( total_orders_open_live==0 || ( same_position_ok==True || last_action==OP_SELL ) ) )   || ( reverse==True && action_decided=="sell" &&  ( total_orders_open_live==0 || (same_position_ok==True || last_action==OP_SELL ) ) ) ) 
                  {  
                  action1=OP_BUY; printf("will do buy  of "+lot_size_to_trade+" lots lastaction was "+last_action+" TOrders="+total_orders_open_live +" Bid:"+ Bid+ " action_decided="+action_decided+" reverse="+reverse  ) ;
                  lastbarscount=barcountnow;
                  }
               
        // printf("action got = "+action1 + " barcountnow="+barcountnow +" lastactbar="+(lastbarscount+barsgap )+ " action_decided="+action_decided + " last_action="+last_action);
        }
   return(action1);
  }


int decide_action_gap()
{
   int action1=20;
      double last_high=iHigh(NULL,0,1);
      double last_low=iLow(NULL,0,1);     
      //if(total_orders_open_live==0 && StringFind( baseline,",first_candle_open,")<1 )
      traverse_orders();
      if(total_orders_open_live<=max_orders_depth )
       {
       
         double buylimitprice=(skind_open_currentvalue+(pips_near_open)*Point());
         double selllimitprice=(skind_open_currentvalue-(pips_near_open)*Point());
        //double upline=(skind_open_currentvalue+(pips_near_open*Point() ));
        //double downline=(skind_open_currentvalue-(pips_near_open*Point() ));
        double upline=buyprice;
        double downline=sellprice;
        barcountnow=Bars;
         
            
            if(closeprice > buyprice && openprice < buyprice && ( last_action==OP_SELL || total_orders_open_live==0 || same_position_ok==True ) && barcountnow<=lastbarscount+barsgap)
               {  
                  if(reverse==True)
                     {action1=OP_SELL;printf("will do sell  of "+lot_size_to_trade+" lots lastaction was "+last_action +" Ask:"+ Ask +"<"+ sellprice+" cp="+closeprice +" op="+openprice  ); }
                     else
                     {action1=OP_BUY;printf("will do buy  of "+lot_size_to_trade+" lots lastaction was "+last_action +" Bid:"+ Bid +">"+ buyprice+" cp="+closeprice +" op="+openprice ) ; }
                lastbarscount=barcountnow;

               }
            //if(Ask < selllimitprice  )
            if(closeprice < sellprice && openprice > sellprice && ( last_action==OP_BUY || total_orders_open_live==0 || same_position_ok==True  ) && barcountnow<=lastbarscount+barsgap )
               {  
                  if(reverse==True)
                     { action1=OP_BUY; printf("will do buy  of "+lot_size_to_trade+" lots lastaction was "+last_action +" Bid:"+ Bid +">"+ buyprice+" cp="+closeprice +" op="+openprice ) ; }
                     else
                     { action1=OP_SELL;printf("will do sell of "+lot_size_to_trade+" lots lastaction was "+last_action +" Ask:"+ Ask +"<"+ sellprice+" cp="+closeprice +" op="+openprice  ); }
               
                lastbarscount=barcountnow;
               }
        }
   return(action1);
}


int add_extra()
{
   int action1=20;
      double last_high=iHigh(NULL,0,1);
      double last_low=iLow(NULL,0,1);     
      //if(total_orders_open_live==0 && StringFind( baseline,",first_candle_open,")<1 )
      traverse_orders();
      if(total_orders_open_live<=max_orders_depth )
       {
       
      
            if( total_open_lots_buy > total_open_lots_sell)
               {  
                  if(reverse==True)
                     {action1=OP_SELL;printf("will do sell  of "+lot_size_to_trade+" lots lastaction was "+last_action +" Ask:"+ Ask +"<"+ sellprice+" cp="+closeprice +" op="+openprice  ); }
                     else
                     {action1=OP_BUY;printf("will do buy  of "+lot_size_to_trade+" lots lastaction was "+last_action +" Bid:"+ Bid +">"+ buyprice+" cp="+closeprice +" op="+openprice ) ; }
               }
            //if(Ask < selllimitprice  )
            if( total_open_lots_sell > total_open_lots_buy )
               {  
                  if(reverse==True)
                     { action1=OP_BUY; printf("will do buy  of "+lot_size_to_trade+" lots lastaction was "+last_action +" Bid:"+ Bid +">"+ buyprice+" cp="+closeprice +" op="+openprice ) ; }
                     else
                     { action1=OP_SELL;printf("will do sell of "+lot_size_to_trade+" lots lastaction was "+last_action +" Ask:"+ Ask +"<"+ sellprice+" cp="+closeprice +" op="+openprice  ); }
               
               }
        
        }

        
   return(action1);
}




double digit3(double val1)
{
return(NormalizeDouble(val1,3));
}
double digit2(double val1)
{
return(NormalizeDouble(val1,2));
}
double digit1(double val1)
{
return(NormalizeDouble(val1,1));
}

void place_order(int action1 )
{
      color clr_pending_order_open_buy=clrBlue;
      color clr_pending_order_open_sell=clrBrown;
      
      string TradeComment="PR="+(string)profit_total+"_SPR="+(string)(int)((Ask-Bid)/Point())+"_eq"+(int)AccountEquity();
      // buyprice=NormalizeDouble((skind_open_currentvalue+(Ask-Bid+gapinput_pips)*Point()),Digits());
      // sellprice=NormalizeDouble((skind_open_currentvalue-(Ask-Bid+gapinput_pips)*Point()),Digits());
      
      if(total_orders_open_live==0)
         {
         calculate_lots_to_trade();
         current_session_orders_count=0;
         }
      
     
      if (action1==OP_BUYSTOP ) 
      {
         double price_tobeused = buyprice;
         double SL_tobeused_inorder = 0;
         double TP_tobeused_inorder=0;
         if(set_take_profit_pip_input >0 )
         TP_tobeused_inorder=price_tobeused+set_take_profit_pip_input*Point();
         if(set_sl_pip_input >0 )
         SL_tobeused_inorder=price_tobeused-set_sl_pip_input*Point();
         
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
         current_session_orders_count+=1;
            }
       }
      if (action1==OP_SELLSTOP ) 
      {
         double price_tobeused = sellprice;
         double SL_tobeused_inorder = 0;
         double TP_tobeused_inorder=0;
         if(set_take_profit_pip_input >0 )
         TP_tobeused_inorder=price_tobeused-set_take_profit_pip_input*Point();
         if(set_sl_pip_input >0 )
         SL_tobeused_inorder=price_tobeused+set_sl_pip_input*Point();
         
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
         current_session_orders_count+=1;
            }
       }      
       
     if (action1==OP_BUYLIMIT ) 
      {
         double price_tobeused = buyprice;
         double SL_tobeused_inorder = 0;
         double TP_tobeused_inorder=0;
         if(set_take_profit_pip_input >0 )
         TP_tobeused_inorder=price_tobeused+set_take_profit_pip_input*Point();
         if(set_sl_pip_input >0 )
         SL_tobeused_inorder=price_tobeused-set_sl_pip_input*Point();
         
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
         current_session_orders_count+=1;
            }
       }
      if (action1==OP_SELLLIMIT ) 
      {
         double price_tobeused = sellprice;
         double SL_tobeused_inorder = 0;
         double TP_tobeused_inorder=0;
         if(set_take_profit_pip_input >0 )
         TP_tobeused_inorder=price_tobeused-set_take_profit_pip_input*Point();
         if(set_sl_pip_input >0 )
         SL_tobeused_inorder=price_tobeused+set_sl_pip_input*Point();
         
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
         current_session_orders_count+=1;
            }
       }
       
      if (action1==OP_BUY ) 
      {
         double price_tobeused = Ask;
         double SL_tobeused_inorder = 0;
         double TP_tobeused_inorder=0;
         int ticket_20;
         if(set_take_profit_pip_input >0 )
         TP_tobeused_inorder=price_tobeused+set_take_profit_pip_input*Point();
         if(set_sl_pip_input >0 )
         SL_tobeused_inorder=price_tobeused-set_sl_pip_input*Point();
         
         //int ticket_20 = OrderSend(Symbol(), OP_BUY, lot_size_to_trade, price_tobeused, G_slippage_264, SL_tobeused_inorder, TP_tobeused_inorder, TradeComment, MagicNumber, 0, clr_pending_order_open_buy);
         
         double adjustedlots=adjust_close_for_new_order("buy",lot_size_to_trade);
         printf(" buy order adjustedlots="+adjustedlots);
         if(adjustedlots>0)
         ticket_20 = OrderSend(Symbol(), OP_BUY, adjust_close_for_new_order("buy",lot_size_to_trade), price_tobeused, G_slippage_264, SL_tobeused_inorder, TP_tobeused_inorder, TradeComment, MagicNumber, 0, clr_pending_order_open_buy);
         if (ticket_20 <= 0) 
          {
            printf("OP_BUY Send Error Code: " + (string)GetLastError()   +"Used P="+price_tobeused+" sl="+ SL_tobeused_inorder+" tp="+TP_tobeused_inorder+" Ask="+Ask+" Bid="+Bid+" Lot="+(string)adjustedlots );
          }
         else 
            {
            if(adjustedlots>0)
               {
               calculate_lots_to_trade();
               current_session_orders_count+=1; 
               }
            last_action=OP_BUY;
            PlaySound("Alert.wav");
            printf("Success : buy order id = "+(string)ticket_20+" price="+(string)price_tobeused+" SL="+(string)SL_tobeused_inorder);
            }
       }
      if (action1==OP_SELL ) 
      {
         
         double price_tobeused = Bid;
         double SL_tobeused_inorder = 0;
         double TP_tobeused_inorder=0;
         int ticket_20;
         if(set_take_profit_pip_input >0 )
         TP_tobeused_inorder=price_tobeused-set_take_profit_pip_input*Point();
         if(set_sl_pip_input >0 )
         SL_tobeused_inorder=price_tobeused+set_sl_pip_input*Point();
         //int ticket_20 = OrderSend(Symbol(), OP_SELL, lot_size_to_trade, price_tobeused, G_slippage_264, SL_tobeused_inorder, TP_tobeused_inorder, TradeComment, MagicNumber, 0, clr_pending_order_open_sell);
         double adjustedlots=adjust_close_for_new_order("sell",lot_size_to_trade);
         printf(" sell order adjustedlots="+adjustedlots);
         if(adjustedlots>0)
         ticket_20 = OrderSend(Symbol(), OP_SELL, adjustedlots , price_tobeused, G_slippage_264, SL_tobeused_inorder, TP_tobeused_inorder, TradeComment, MagicNumber, 0, clr_pending_order_open_sell);
         if (ticket_20 <= 0) 
          {
            printf("OP_SELL Send Error Code: " + (string)GetLastError()   +"Used P="+price_tobeused+" sl="+ SL_tobeused_inorder+" tp="+TP_tobeused_inorder+" Ask="+Ask+" Bid="+Bid+" Lot="+(string)adjustedlots );
         current_session_orders_count+=1;
          }
         else 
            {
            if(adjustedlots>0)
               {
               calculate_lots_to_trade();
               current_session_orders_count+=1; 
               }
            last_action=OP_SELL;
            PlaySound("Alert.wav");
            printf("Success : sell order id = "+(string)ticket_20+" price="+(string)price_tobeused+" SL="+(string)SL_tobeused_inorder + " adjustedlots="+adjustedlots);
         
            }
       }         
       
}

double adjust_close_for_new_order(string actiontodo,double lotsneeded )
{
double remaininglots=0;
traverse_orders();
double current_session_profit_now=TotalrunningProfit;
string whichcondition="none";
printf(" pre lots adjusted from : "+ lotsneeded+" to "+ remaininglots + " current_session_profit="+current_session_profit_now+" whichcondition:"+whichcondition+" lots b="+total_open_lots_buy+" s="+total_open_lots_sell);
if(total_orders_open_active==0 )
   {
   remaininglots=lotsneeded;
   whichcondition="0 order";
   }
else if ( lots_multiplier==1 ) 
    {
      whichcondition="for lots multiplier 1 no action ";
      if( (actiontodo=="buy" && total_open_lots_sell>0 ) ||  (actiontodo=="sell" && total_open_lots_buy>0 )  )
      {
            close_all_orders(100,"for lots multiplier 1 close other orders and open diffirent one ");
            update_session_profit();
            remaininglots=lotsneeded;
            whichcondition="for lots multiplier 1";
            
       }
     }
else if(take_profit_usd_input==0 && ( current_session_profit_now > (per_lot_profit_usd*total_open_lots/Point()) ) && ( (actiontodo=="buy" && total_open_lots_sell>0 ) || (actiontodo=="sell" && total_open_lots_buy>0 ) )  )
      {
      close_all_orders(100,"for action in profit as crpr="+current_session_profit_now + " > expr=" + (per_lot_profit_usd*total_open_lots/Point())  ) ;
      printf("adjustement but no further action of "+actiontodo ) ;
      remaininglots=0;
      whichcondition="action with profit ";
      }
      
else if (actiontodo=="buy" && ( close_on_opposit || lotsneeded>total_open_lots_sell ) )
      {
      if(actiontodo=="buy" && total_open_lots_sell>0)
         close_all_orders(OP_SELL,"adjust new buy order");
      remaininglots=lotsneeded-total_open_lots_sell;
      whichcondition="for buy";
      }
     
else if (actiontodo=="sell" && ( close_on_opposit || lotsneeded>total_open_lots_buy ) )
     {
      if(actiontodo=="sell" && total_open_lots_buy>0)
         close_all_orders(OP_BUY,"adjust new sell order ");
      remaininglots=lotsneeded-total_open_lots_buy;
      whichcondition="for sell";
      }
      

   
printf("post lots adjusted from : "+ lotsneeded+" to "+ remaininglots + " current_session_profit="+current_session_profit_now+" whichcondition:"+whichcondition);


remaininglots=(MathMin(200,remaininglots));

return(NormalizeDouble(remaininglots,2));

}


int close_all_orders(int whichorders ,string called_by)
   {
   
   
   printf(message_to_print);
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
                  if(OrderType() == whichorders || whichorders == 100  )
                     if( !OrderClose(OrderTicket(), OrderLots(), Bid, G_slippage_264 , clr_confirm_order_close))
                     {
                        if(!OrderClose(OrderTicket(), OrderLots(), Ask, G_slippage_264 , clr_confirm_order_close))
                     	   printf("There was an error closing buy/sell order#"+(string)OrderTicket()+". Error is:" + (string)GetLastError() );
                       returnvalue=0;
                    
                     }
                     else 
                     	   printf("Closed buy/sell("+(string)OrderType()+") order#"+(string)OrderTicket() +" PR="+(string)profit_total + "orders#"+(string)OrdersTotal() );
                     	   
                     	   
                  if(OrderType() == OP_SELLSTOP || OrderType() == OP_BUYSTOP )
                  if(OrderType() == whichorders || whichorders == 100  )
                     if( !remove_pending_order(OrderTicket(),clr_pending_order_close) )
                     {
                        if( !remove_pending_order(OrderTicket(),clr_pending_order_close) )
                     	   printf("There was an error closing pending stop order#"+(string)OrderTicket()+". Error is:" + (string)GetLastError() );
                       returnvalue=0;
                     }
                     else 
                     	   printf("Deleted Pending limit order ("+(string)OrderType()+") order#"+(string)OrderTicket() +" PR="+(string)profit_total + "orders#"+(string)OrdersTotal() );
                  
                  if(OrderType() == OP_SELLLIMIT || OrderType() == OP_BUYLIMIT )
                  if(OrderType() == whichorders || whichorders == 100  )
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
               //set_open_line_value();
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
    void draw_vline (string linename,string sometext,double location ,color linecolor,int thickness)
        {
                //ObjectDelete("startline");
                //if(check_input(linename,"next_"))
                   {
                    ObjectDelete(linename);
                    ObjectCreate(0,linename,OBJ_VLINE,0,Time[0],location);
                    ObjectSetInteger(0,linename,OBJPROP_COLOR,linecolor);
                    ObjectSetInteger(0,linename,OBJPROP_STYLE,STYLE_DASHDOTDOT);
                    ObjectSetInteger(0,linename,OBJPROP_WIDTH,thickness);
                    ObjectSetText(linename,sometext,3,0,clrAqua);
                    ObjectSetInteger(0,linename,OBJPROP_BACK,TRUE);

                   }

        }



void set_open_line_value()
{

  // printf("openlinesetting:baseline="+baseline+" searchresult="+StringFind( baseline,",dailyopen1,") + " : " +skind_open_currentvalue+":"+ open_today ) ;

   if(StringFind( baseline,",first_candle_open,")>0)
      skind_open_currentvalue=(Ask+Bid)/2;
      
   if(StringFind( baseline,",first_candle_open,")>=0)
      { 
      if(  total_open_lots==0 ) 
         {
         skind_open_currentvalue=(Ask+Bid)/2;
         printf("SK1 this candle line set to : "+ Ask ) ;
         daily_first15_min_high=iHigh(NULL,newline_wait_minutes,1);
         daily_first15_min_low=iLow(NULL,newline_wait_minutes,1);     

         }
      }
      
    if(StringFind( baseline,",daily_open,")>=0)
      { 
      if(  TimeHour(TimeCurrent()) == 0 && TimeMinute(TimeCurrent())==newline_wait_minutes && TimeSeconds(TimeCurrent())==0) 
         {
         skind_open_currentvalue=Ask;
         printf("SK1 daily line set to : "+ Ask ) ;
         daily_first15_min_high=iHigh(NULL,newline_wait_minutes,1);
         daily_first15_min_low=iLow(NULL,newline_wait_minutes,1);     

         }
      }
      
     if(StringFind( baseline,",4hour_open,")>=0)
      { 
      if(  MathMod(TimeHour(TimeCurrent()),4) == 0 && TimeMinute(TimeCurrent())==newline_wait_minutes && TimeSeconds(TimeCurrent())==0) 
         {
         skind_open_currentvalue=Ask;
         printf("SK1 daily line set to : "+ Ask ) ;
         daily_first15_min_high=iHigh(NULL,newline_wait_minutes,1);
         daily_first15_min_low=iLow(NULL,newline_wait_minutes,1);     
      printf(" 4hour_open " + MathMod(TimeHour(TimeCurrent()),4) + " time hour = " + TimeHour(TimeCurrent()) + " skind_open_currentvalue="+skind_open_currentvalue+" daily_first15_min_low"+daily_first15_min_low+" skind_open_currentvalue="+skind_open_currentvalue);
         }
      }
      
     if(StringFind( baseline,",8hour_open,")>=0)
      { 
      if(  MathMod(TimeHour(TimeCurrent()),8) == 0 && TimeMinute(TimeCurrent())==newline_wait_minutes && TimeSeconds(TimeCurrent())==0) 
         {
         skind_open_currentvalue=Ask;
         printf("SK1 daily line set to : "+ Ask ) ;
         daily_first15_min_high=iHigh(NULL,newline_wait_minutes,1);
         daily_first15_min_low=iLow(NULL,newline_wait_minutes,1);     
      printf(" 4hour_open " + MathMod(TimeHour(TimeCurrent()),4) + " time hour = " + TimeHour(TimeCurrent()) + " skind_open_currentvalue="+skind_open_currentvalue+" daily_first15_min_low"+daily_first15_min_low+" skind_open_currentvalue="+skind_open_currentvalue);
         }
      }
      
     if(StringFind( baseline,",12hour_open,")>=0)
      { 
      if(  MathMod(TimeHour(TimeCurrent()),12) == 0 && TimeMinute(TimeCurrent())==newline_wait_minutes && TimeSeconds(TimeCurrent())==0) 
         {
         skind_open_currentvalue=Ask;
         printf("SK1 daily line set to : "+ Ask ) ;
         daily_first15_min_high=iHigh(NULL,newline_wait_minutes,1);
         daily_first15_min_low=iLow(NULL,newline_wait_minutes,1);     
      printf(" 4hour_open " + MathMod(TimeHour(TimeCurrent()),4) + " time hour = " + TimeHour(TimeCurrent()) + " skind_open_currentvalue="+skind_open_currentvalue+" daily_first15_min_low"+daily_first15_min_low+" skind_open_currentvalue="+skind_open_currentvalue);
         }
      }
      
   if(StringFind( baseline,",weekly_open,")>=0)
      { 
      if( DayOfWeek()== 1 && TimeHour(TimeCurrent()) == 0 && TimeMinute(TimeCurrent())==newline_wait_minutes && TimeSeconds(TimeCurrent())==0) 
         {
         skind_open_currentvalue=Ask;
         printf("SK1 daily line set to : "+ Ask ) ;
         daily_first15_min_high=iHigh(NULL,newline_wait_minutes,1);
         daily_first15_min_low=iLow(NULL,newline_wait_minutes,1);     

         }
      }
      
    if(StringFind( baseline,",monthly_open,")>=0)
      { 
      if( TimeDay(TimeCurrent())== 1 && TimeHour(TimeCurrent()) == 0 &&  DayOfWeek()== 1 && TimeHour(TimeCurrent()) == 0 && TimeMinute(TimeCurrent())==newline_wait_minutes && TimeSeconds(TimeCurrent())==0) 
         {
         skind_open_currentvalue=Ask;
         printf("SK1 daily line set to : "+ Ask ) ;
         daily_first15_min_high=iHigh(NULL,newline_wait_minutes,1);
         daily_first15_min_low=iLow(NULL,newline_wait_minutes,1);     

         }
      }
            
   if(StringFind( baseline,",hourly_open,")>=0)
      { 
      if( TimeMinute(TimeCurrent())==0 && TimeSeconds(TimeCurrent())==0 ) 
         {
         skind_open_currentvalue=Ask;
         printf("SK1 Hourly line set to : "+ Ask ) ;
         daily_first15_min_high=iHigh(NULL,newline_wait_minutes,1);
         daily_first15_min_low=iLow(NULL,newline_wait_minutes,1);     
         }
      }
      
   if(StringFind( baseline,",open_15min,")>=0)
      { 
      if( MathMod(TimeMinute(TimeCurrent()),15) == 0 && TimeSeconds(TimeCurrent())==0 ) 
         {
         skind_open_currentvalue=Ask;
         printf("SK1 15 minute line set to : "+ Ask ) ;
         daily_first15_min_high=iHigh(NULL,newline_wait_minutes,1);
         daily_first15_min_low=iLow(NULL,newline_wait_minutes,1);     
         }
      }
       
     if(chang_gap_for_martingle==True)
      {
       //buyprice=daily_first15_min_high +( total_orders_open_active*(iHigh(NULL,1,1)-iLow(NULL,1,1) )   ) ;
       //sellprice=daily_first15_min_low - ( total_orders_open_active*(iHigh(NULL,1,1)-iLow(NULL,1,1) )  ) ;
       
       buyprice=daily_first15_min_high +MathMin(( daily_first15_min_high-daily_first15_min_low),( daily_first15_min_high-daily_first15_min_low)*.05 *total_orders_open_active );
       sellprice=daily_first15_min_low - MathMin(( daily_first15_min_high-daily_first15_min_low),( daily_first15_min_high-daily_first15_min_low)*.05 *total_orders_open_active ) ;
      }
       
  if(daily_first15_min_high==0 || (skind_open_currentvalue_last!=skind_open_currentvalue && skind_open_currentvalue!=0)  )
   {
   
   //printf("setting new hline : open val : Last="+skind_open_currentvalue_last+" now="+skind_open_currentvalue+" 15minhigh = "+daily_first15_min_high) ;
      if(close_all_on_new_lines==True)
         close_all_orders(100,"closing all for new levels : Loss="+current_session_profit );
      
      remove_line("openline");
      draw_hline("openline",skind_open_currentvalue,skind_open_currentvalue,clrAliceBlue,1);


       //buyprice=NormalizeDouble((skind_open_currentvalue+(Ask-Bid+gapinput_pips)*Point()),Digits());
       //sellprice=NormalizeDouble((skind_open_currentvalue-(Ask-Bid+gapinput_pips)*Point()),Digits());
   
       buyprice=daily_first15_min_high ;
       sellprice=daily_first15_min_low ;
   
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