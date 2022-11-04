 // properties 
   #property copyright "SKRAJ"
   #import "stdlib.ex4"
   string ErrorDescription(int a0); 
   #import

extern bool stopworkingflag_input=False;
extern bool no_new_trades=True;
bool stopworkingflag=stopworkingflag_input;

// ================== variables 
//input string yourtelegramchannel="thisisforsachin"; 
//input string yourlicensekey="thisisforsachin";
//input datetime licesevaliddate;
extern bool send_telgram_message_flag=True;
int old_msg_sent_time=0;
extern  bool bothside=True;
extern bool fresh_invest_everytime=True;
extern int profit_percentage_tobeused_fortrade=10;
extern int max_orders_count_input = 2;
int MaxTrades=MathMax(1,max_orders_count_input );
extern double risk_percentage_input = 50;  // org 60
double Risk=MathMax(1,risk_percentage_input );

int brokerage_perlot=0;

input int equity_allocated_touse_input=100;
extern int acceptable_equity_loss=100;
extern int total_equity_at_start=0;
double average_spread;
input string info3="---- below inputs in USD. use wisely for diffirent currencies ";

extern bool trail_target_also=True;
extern double tp_input_usd=0 ; 

// for BTCUSD 
/*
extern double filter_input_usd = 270;
extern double SL_for_pendingorders_usd = 50;  //this is for our BUY/SELL STOP SL 2.3 pips modify, can not put 200 pips, will lose !!!
extern  double sl_trail_active_orders_input_usd = 10; // not used !!! 30
extern  double noprofit_sl_trail_active_orders_input_usd = 30;  // 20 
extern  double withprofit_sl_trail_active_orders_input_usd = 20;  // 30
extern  double distance_for_pending_order_usd = 33;    // 20 will cause order130 error  //23

// end variables for BTCUSD 
*/
/// for EURUSD 
/*
extern double filter_input_usd = 1;
extern double SL_for_pendingorders_usd = .2;  //this is for our BUY/SELL STOP SL 2.3 pips modify, can not put 200 pips, will lose !!!
extern  double sl_trail_active_orders_input_usd = .01; // not used !!! 30
extern  double noprofit_sl_trail_active_orders_input_usd = .03;  // 20 
extern  double withprofit_sl_trail_active_orders_input_usd = .02;  // 30
extern  double distance_for_pending_order_usd = .033;    // 20 will cause order130 error  //23

// end variables for EURUSD 
*/

/// for XAUUSD /*
extern double filter_input_usd = 5;
extern double SL_for_pendingorders_usd = 1;  //this is for our BUY/SELL STOP SL 2.3 pips modify, can not put 200 pips, will lose !!!
extern  double sl_trail_active_orders_input_usd = .1; // not used !!! 30
extern  double noprofit_sl_trail_active_orders_input_usd = .3;  // 20 
extern  double withprofit_sl_trail_active_orders_input_usd = .2;  // 30
extern  double distance_for_pending_order_usd = .33;    // 20 will cause order130 error  //23
// end variables for XAUUSD */

double filter,tp_input,sl_for_pendingorders,current_spread,sl_trail_active_orders_input,noprofit_sl_trail_active_orders_input,withprofit_sl_trail_active_orders_input
,distance_for_pending_order,maxspreadpluscommission,maxspread;
extern int highlow_diff_level=2;


int MagicNumber = 678234;
string TradeComment = "SKRAJ";


// so keep well to have proper gap between the current price and open price of pending order . 

extern bool Use_TrailingStep = TRUE;
extern double Start_Trailing_At = 1.1;  // org 2.9 meaning keep bid/ask sl_trail_active_orders_input by x PIPS
extern  double TrailingStep = 0.1;        // org 0.3

 bool Use_Set_BreakEven = TRUE;
extern double LockPips =  0.3;           // org 0.3
extern double Set_BreakEvenAt = 2.3;   // org 2.3

 double MinLots = 0.01;
 double MaxLots = 200000.0;//100000.0;
extern bool lots_auto_managed = True;
extern double FixedLots = 0.01;//0.1;

extern double MaxSpreadPlusCommission_usd = 50 ;//6.3 ok !
extern double MaxSpread_usd = 50  ;//6.3 ok !

 int MAPeriod = 15;
 int MAMethod = 1;

 string Timefilter = "---------- Time filter ----------";
 int StartHour = 0;
 int StartMinute = 0;
 int EndHour = 23;
 int EndMinute = 59;

 string IndicatorSetting = "=== Indicator Settings ===";
 int IndicatorToUse_input = 1;  // 0 = Moving Average ( iMA ), 1 = Envelope (iEnvelope)
 int Env_period = 10;
 double Env_deviation = 0.07; // 0.05
 int Env_shift = 0;
 
extern bool Timed_Closing = TRUE;  
extern int Minutes_limit_for_order=5;
int Minutes_Buy =  Minutes_limit_for_order; //Minute
int Minutes_Sell = Minutes_limit_for_order; 
//------ variables ----------- 



int Env_low_band_price = PRICE_HIGH;
int Env_high_band_price = PRICE_LOW;

//bool Timed_Closing = TRUE;  
//int Minutes_Buy =  40; //Minute
//int Minutes_Sell = 40; 
int Timed_Buy_TakeProfit =  -5;  
int Timed_Sell_TakeProfit = -5;  

int input_for_maperiod = 0;
double pips_input = 0.0;
int GS_digits = 0;
double GS_point = 0.0;
int GS_step_logvalue;
double GS_allowed_minlots_for_symbol;
double GS_allowed_maxlots_for_symbol;
double riskpercent;
double normalized_distance_for_stop_order;
double normalized_sl_trail_activeorders;
double given_filter_normalized;
int G_slippage_264 = 3;
bool boolvar_to_run_once;
double commision_forpip;
double array_of_spreads[30];
int counter_instart_upto30 = 0;
string Gs_dummy_288;
string Gs_unused_316 = "";
string Gs_unused_324 = "";
double Gd_336;
double Gd_344;
int G_time_352;
int Gi_356;
int G_datetime_360;

int Gi_380;
int Gi_384;
int Gi_388;
int Gi_392 = 40;
double G_timeframe_396 = 240.0;
bool Gi_404 = TRUE;
color G_color_408 = DimGray;
color G_color_428 = Red;
color G_color_432 = DarkGray;
color G_color_436 = SpringGreen;
bool Gi_440 = TRUE;
double G_ihigh_444;
double G_ilow_452;
double Gd_460;
int G_datetime_468;
int Dfactor_basedondigits;

string symbol_name;
double SL_points_touse;
double TP_tobeused_inorder;
string message_to_display="msg";
double GS_allowed_SL_size_for_symbol;
int equity_at_start;
int equity_allocated_touse=equity_allocated_touse_input;
int total_orders_open_live;

  int min_equity;
  int max_equity=0;
  int min_equity_usable=equity_allocated_touse;
  int max_equity_usable=0;
  int min_equity_nobrokerage=equity_allocated_touse;
  int max_equity_nobrokerage=0;
  int balance_equity=equity_allocated_touse;
  int usable_equity;
  int current_equity;
  int brokerage_current;
  int investment_counter=0;
  int total_invested_money;
  double lots_in_this_session=0;
  double last_lots_size=0;
  int brokerage_total;
  double highlow_diff;
  
  int last_msg_value=0;
  string datewise_profit;
  int total_orders_executed=0;
  int total_orders_executed_prev=0;
  datetime first_order_time;
  datetime last_order_time;
  
  string peak_name="start";
  string peak_name_last="start";
  string peak_details="";
  string peak_details_last="";
  string peak_details_wins="";
  string peak_details_lost="";

string peak_names_list="";
string peak_profits_list="";
string equity_msg="";
  int profit_in_this_peak=0;
  int profit_till_last_peak=0;
  int profit_total=0;
  int peaks_count=0;
  
  int peaks_max_loss=0;
  int peaks_max_profit=0;
  int peaks_with_profit=0;
  int peaks_with_loss=0;
  int peaks_average_profit=0;
  int peaks_average_loss=0;
  int peaks_lost_amount=0;
  int peaks_won_amount=0;
   double total_traded_lots_tillnow=0;
   int lost_investment_counter=-1;
   int equity_seen_min;
   
   double highlow_diff_avg=0;
   double highlow_diff_max=0;
   
   double average_spread_withcommision;

color clr_pending_order_open_buy=clrBlue;//clrBlue;
color clr_pending_order_open_sell=clrBrown;//clrBrown;
color clr_pending_order_close=clrYellow;
color clr_pending_order_modify=clrNONE;
color clr_confirm_order_open=clrLimeGreen;
color clr_confirm_order_modify_buy=clrLimeGreen;
color clr_confirm_order_modify_sell=clrRosyBrown;
color clr_confirm_order_close=clrRed; 


double usd_points;


string message_to_send;

// E37F0136AA3FFAF149B351F6A4C948E9
int init() 
    {


      printf("Init function start ");
      stopworkingflag=stopworkingflag_input;    if(stopworkingflag==True ) 
      { printf("Stop working flag enabled " );
      return(0);
      }
      
     MaxTrades=MathMax(1,max_orders_count_input );
     Risk=MathMax(1,risk_percentage_input );


      equity_allocated_touse=equity_allocated_touse_input;
      investment_counter=0;
      current_equity=AccountEquity();
      equity_seen_min=equity_at_start=current_equity;
         if(total_equity_at_start>0)
            equity_seen_min=equity_at_start=total_equity_at_start;
        //int timeframe_8;
         init_investment();
         min_equity=current_equity;
         
        ArrayInitialize(array_of_spreads, 0);
        GS_digits = Digits;
        GS_point = Point;
        Print("System_Digits: " + GS_digits + " Point: " + DoubleToStr(GS_point, GS_digits));
        double current_oGS_allowed_lotstep_size_for_symbolrder_price = MarketInfo(Symbol(), MODE_LOTSTEP);
        GS_allowed_SL_size_for_symbol = MarketInfo(Symbol(),MODE_STOPLEVEL) *1.1;
        GS_step_logvalue = MathLog(current_oGS_allowed_lotstep_size_for_symbolrder_price) / MathLog(0.1);
        GS_allowed_minlots_for_symbol = MathMax(MinLots, MarketInfo(Symbol(), MODE_MINLOT));
        GS_allowed_maxlots_for_symbol = MathMin(MaxLots, MarketInfo(Symbol(), MODE_MAXLOT));
        symbol_name = StringSubstr (Symbol(),0,6);
        
        
        usd_points=.001;
        if (symbol_name == "EURUSD" || symbol_name == "XAUUSD" || symbol_name == "BTCUSD" ) 
         usd_points=.01;
        
         filter=filter_input_usd/usd_points;
         sl_for_pendingorders=SL_for_pendingorders_usd/usd_points;
         tp_input=tp_input_usd/usd_points;
         sl_for_pendingorders = SL_for_pendingorders_usd/usd_points;
         sl_trail_active_orders_input = sl_trail_active_orders_input_usd/usd_points;
         noprofit_sl_trail_active_orders_input = noprofit_sl_trail_active_orders_input_usd/usd_points;
         withprofit_sl_trail_active_orders_input = withprofit_sl_trail_active_orders_input_usd/usd_points;
         distance_for_pending_order = distance_for_pending_order_usd/usd_points;
         maxspread=MaxSpread_usd/usd_points;
         maxspreadpluscommission=MaxSpreadPlusCommission_usd/usd_points;



        SL_points_touse=MathMax(MathMax(1,GS_allowed_SL_size_for_symbol),sl_for_pendingorders) ; 
        
        printf("filter value given in usd="+filter_input_usd+" in points="+filter +" usd_point="+usd_points);
        printf("SL_points_touse="+SL_points_touse+" allowed_SL_size="+GS_allowed_SL_size_for_symbol+" sl_for_pendingorders="+sl_for_pendingorders);

        /*
        if (symbol_name == "EURUSD" || symbol_name == "EURUSDc" ) 
        {
        maxspread  = MaxSpread_EU; filter = filter_EU;
        }
        else if (symbol_name == "GBPUSD" || symbol_name == "GBPUSDc" ) 
           {
              maxspread  = MaxSpread_GU; 
              filter = filter_GU;
              distance_for_pending_order=MathMax(GS_allowed_SL_size_for_symbol,distance_for_pending_order) ; 
              sl_trail_active_orders_input=MathMax(GS_allowed_SL_size_for_symbol,sl_trail_active_orders_input) ; 
   
           }
         else if (symbol_name == "USDJPY" || symbol_name == "USDJPYc" ) 
           {
           maxspread  = MaxSpread_UJ; 
           filter = filter_UJ;
           distance_for_pending_order=MathMax(GS_allowed_SL_size_for_symbol,distance_for_pending_order) ; 
           sl_trail_active_orders_input=MathMax(GS_allowed_SL_size_for_symbol,sl_trail_active_orders_input) ; 
           }
           else if (symbol_name == "BTCUSD" || symbol_name == "BTCUSDc" ) 
           {
           //filter=150;
           //GS_point=1;
           distance_for_pending_order=MathMax(GS_allowed_SL_size_for_symbol,distance_for_pending_order) ; 
           //maxspread  = 500; 
           //maxspreadpluscommission=3500;
           sl_trail_active_orders_input=MathMax(GS_allowed_SL_size_for_symbol,sl_trail_active_orders_input) ; 
           }
           else if (symbol_name == "XAUUSD" || symbol_name == "XAUUSDc" ) 
           {
               symbol_name=Symbol();
               if(IsTesting()==True)
               if(symbol_name == "BTCUSDc" || symbol_name == "XAUUSDc" )
                     Risk = Risk *100;
               riskpercent = Risk / 100.0;
            
           //distance_for_pending_order=MathMax(GS_allowed_SL_size_for_symbol,distance_for_pending_order) ; 
           //maxspread  = 2500; 
           //maxspreadpluscommission=3500;
           //sl_trail_active_orders_input=MathMax(GS_allowed_SL_size_for_symbol,sl_trail_active_orders_input) ; 
           }
           else
              {
              distance_for_pending_order=MathMax(GS_allowed_SL_size_for_symbol,distance_for_pending_order) ; 
              sl_trail_active_orders_input=MathMax(GS_allowed_SL_size_for_symbol,sl_trail_active_orders_input) ; 
              }
      
      */
      


        riskpercent = Risk / 100.0;
        normalized_distance_for_stop_order = NormalizeDouble(distance_for_pending_order * GS_point, GS_digits);
        normalized_sl_trail_activeorders = NormalizeDouble(sl_trail_active_orders_input * GS_point, GS_digits);
        given_filter_normalized = NormalizeDouble(filter * GS_point , GS_digits);
        boolvar_to_run_once = FALSE;
        commision_forpip = NormalizeDouble(pips_input * GS_point, GS_digits + 1); 

        Dfactor_basedondigits = 1;
        
            if(GS_digits == 3|| GS_digits == 5) Dfactor_basedondigits = 10;        
        
        return (0);
    }
	
int init_investment()
   {
   
      if ( total_orders_open_live > 0 ) 
         {
         printf("waiting for all orders to close before making new investment ") ; 
         return(0);
         }
         
      if( balance_equity <  equity_allocated_touse ) 
         {
         printf("All amount finished can not reinvest. current equity ="+(current_equity-brokerage_total) + " balance_equity="+balance_equity ) ; 
         if(OrdersTotal() == 0 ) 
            //stopworkingflag=True;
         return(0);
         } 
      current_equity=AccountEquity();
      //equity_at_start=current_equity;
      lots_in_this_session=0;
      if(equity_allocated_touse_input<=0) 
         equity_allocated_touse=equity_at_start;
      
            investment_counter++;
      total_invested_money=(equity_allocated_touse*investment_counter);
      balance_equity=equity_at_start-total_invested_money;
      if(investment_counter<=0)
      printf("making first investment of "+equity_allocated_touse_input + " investment_count="+investment_counter);
      else
      printf("making a reinvestment of "+equity_allocated_touse_input + " investment_count="+investment_counter);

      lost_investment_counter++;
     return(0);
   }

	 	
double get_filter_value(int highlow_diff_level_1)
   {
      int higest_bar=iHighest(NULL,0,MODE_HIGH,highlow_diff_level_1,0);
      int lowest_bar=iLowest(NULL,0,MODE_LOW,highlow_diff_level_1,0);
      double highlow_diff_1=iHigh(NULL, 0, higest_bar) - iLow(NULL, 0, lowest_bar) ; 
      return(highlow_diff_1);
   }
  	 			  	   	  	  	 				    	  	 					    	  	   	   	 	 	   	 	 		  		 					 			 		  	   				 		 		  	      			   			 	 	 	 					  	 			  	 
void OnTick() {

   if(stopworkingflag)
   {
      Comment("Stop working flag enabled ||open_orders="+OrdersTotal());
      return;
      
      }
      

      {  // defind variables
         datetime tick_start_time=TimeCurrent();
         int error_code;
         string error_details;
         int ticket_20;
         double price_tobeused;
         bool boolvar_modify_done;
         double current_order_price;
         double order_SL_normalized;
         double SL_tobeused_inorder;
         double factor_commision;
         int buyorsell;
         int sk_high_movement;
         int open_order_type;
         double Ld_196;
         double lot_size_to_trade;
         double High_array = iHigh(NULL, 0, 0);
         double Low_array = iLow(NULL, 0, 0);

         double indicator_low;
         double indicator_high;
         double indicator_highlow_diff;
      }
     
     
           current_spread=(Ask-Bid)/GS_point;
           
           if(filter_input_usd==0)
            {
            //filter=average_spread/GS_point*10;
            filter=MathMin(3500,MathMax(1500,average_spread_withcommision/GS_point*10));
              given_filter_normalized = NormalizeDouble(filter * GS_point , GS_digits);
              }
              else
              filter=filter_input_usd;

    brokerage_total=( total_traded_lots_tillnow * brokerage_perlot );
    brokerage_current=( lots_in_this_session * brokerage_perlot );
    
    current_equity=AccountEquity();
    usable_equity=current_equity-balance_equity - brokerage_total; // balance equity is managed by init investment 
    profit_total=(current_equity-equity_at_start-brokerage_total );
      equity_seen_min=MathMin(current_equity,equity_seen_min);

	
	// If indicator setting is 1 then we use Envelope
	if ( IndicatorToUse_input == 1 )
	{
		indicator_low = iEnvelopes ( NULL, 0, Env_period, MODE_SMA, Env_shift, Env_low_band_price, Env_deviation, MODE_LOWER, 0 );
		indicator_high = iEnvelopes ( NULL,0, Env_period, MODE_SMA, Env_shift, Env_high_band_price, Env_deviation, MODE_UPPER, 0 );
	}	
	// If indicator setting is 0 or any other number then use the default mMoving Average
	else
	{
		indicator_low = iMA ( NULL, 0, MAPeriod, input_for_maperiod, MAMethod, PRICE_LOW, 0 );
		indicator_high = iMA ( NULL, 0, MAPeriod, input_for_maperiod, MAMethod, PRICE_HIGH, 0 );
	}
	indicator_highlow_diff = indicator_low - indicator_high;	

    // filling pip size information from order history .
   if (!boolvar_to_run_once) {
      for (int order_position_for_selecting = OrdersHistoryTotal() - 1; order_position_for_selecting >= 0; order_position_for_selecting--) {
         if (OrderSelect(order_position_for_selecting, SELECT_BY_POS, MODE_HISTORY)) {
            if (OrderProfit() != 0.0) {
               if (OrderClosePrice() != OrderOpenPrice()) {
                  if (OrderSymbol() == Symbol()) {
                     boolvar_to_run_once = TRUE;
                     factor_commision = MathAbs(OrderProfit() / (OrderClosePrice() - OrderOpenPrice()));
                     commision_forpip = (-OrderCommission()) / factor_commision;
                     break;
                     
                  }
               }
            }
         }
      }
   }
   
   // points to usd 
   // btcusd has 2 decimal digits : both digits after point . so multiplier with no zero  =1 
   // eurusd has 5 decimal digits : 2 digits of paise : so multiplier 3 zero =1000
   // xauusd has 3 decimal digits : 2 digits of paise : so multiplier 1 zero = 10 
   

    // get average spread 
    double spread_calculated = Ask - Bid;
        ArrayCopy(array_of_spreads, array_of_spreads, 0, 1, 29);
        array_of_spreads[29] = spread_calculated;
        if (counter_instart_upto30 < 30) counter_instart_upto30++;
    double sum_of_gda_array = 0;
        order_position_for_selecting = 29;
        for (int forloop_counter1 = 0; forloop_counter1 < counter_instart_upto30; forloop_counter1++) 
        {
            sum_of_gda_array += array_of_spreads[order_position_for_selecting];
            order_position_for_selecting--;
        }
    average_spread = sum_of_gda_array / counter_instart_upto30;

    // normalise with the commision called brokerage ( it is taken from order so it is accurate )
   double ask_with_commision = NormalizeDouble(Ask + commision_forpip, GS_digits);  //Ask + comission
   double bid_with_commision = NormalizeDouble(Bid - commision_forpip, GS_digits);  //Bid - comission
   average_spread_withcommision = NormalizeDouble(average_spread + commision_forpip, GS_digits + 1);


//################  Main calculation to trade decision check if high movement is there 
//################  Main calculation to trade decision check if high movement is there 
//################  Main calculation to trade decision check if high movement is there 
   //highlow_diff = High_array - Low_array;   // original 
   
   //int higest_bar=iHighest(NULL,0,MODE_HIGH,highlow_diff_level,0);
   //int lowest_bar=iLowest(NULL,0,MODE_LOW,highlow_diff_level,0);
   //highlow_diff=iHigh(NULL, 0, higest_bar) - iLow(NULL, 0, lowest_bar) ; 
   
   
   highlow_diff=get_filter_value(highlow_diff_level);
   
   buyorsell=0;
   sk_high_movement=0;
   highlow_diff_avg=(highlow_diff_avg+highlow_diff)/2;
   highlow_diff_max=MathMax(highlow_diff,highlow_diff_max);
   if (highlow_diff > given_filter_normalized && no_new_trades==False ) 
   {
   
      
      if(total_orders_open_live==0 && usable_equity<equity_allocated_touse )
       if(fresh_invest_everytime==True)
         {
         printf("fresh investment again usable_equity="+usable_equity );
         fresh_invest_everytime_function();
         }

      sk_high_movement=1;
      
      if (Ask < indicator_low) buyorsell = 1;  // for BUY
      else
         if (Bid > indicator_high) buyorsell = -1; // for SELL

    if(bothside==True) 
        {
            buyorsell=2;
        }
   
   
   datetime timenow=TimeCurrent();
   //peak_name=""+TimeDay(timenow)+TimeMonth(timenow)+"."+TimeHour(timenow);
   peak_name=""+TimeDay(timenow)+TimeMonth(timenow)+"."+TimeHour(timenow)+TimeMinute(timenow)+"."+int(highlow_diff/GS_point);
   //printf("Got Peak :"+highlow_diff/GS_point+">"+given_filter_normalized/GS_point);
   
   
       highlow_diff_max=0;
       

   }
   
   
   
   

   // traverse all the open orders for modifying the SL for live orders and price for pending orders . 
   int total_orders_open_active=0;
   int total_orders_open_pending=0;
   total_orders_open_live = 0;
   for (order_position_for_selecting = 0; order_position_for_selecting < OrdersTotal(); order_position_for_selecting++) 
   {
      if (OrderSelect(order_position_for_selecting, SELECT_BY_POS, MODE_TRADES)) 
      {
         if (OrderMagicNumber() == MagicNumber  && Symbol()==OrderSymbol()) 
         {
            open_order_type = OrderType();
            if (open_order_type == OP_BUYLIMIT || open_order_type == OP_SELLLIMIT) continue; //skip this !
         
            double TotalProfit = 0.0; 
            if (OrderSymbol() == Symbol()) 
            {

          	   	  sl_trail_active_orders_input = withprofit_sl_trail_active_orders_input ; 
            
               int current_ticket_number=OrderTicket();
               total_orders_open_live++;
               //printf("SK check order#"+ current_ticket_number + " type="+OrderType() +" CRP="+OrderProfit()+" current SL=" +OrderStopLoss()+ " OP_BUY="+ OP_BUY+" OP_SELL="+ OP_SELL+" OP_BUYSTOP"+ OP_BUYSTOP + " OP_SELLSTOP" + OP_SELLSTOP+ " OP_BUYLIMIT="+OP_BUYLIMIT+" OP_SELLLIMIT="+OP_SELLLIMIT   );
               switch (open_order_type) {
               case OP_BUY:
               
                  total_orders_open_active++;
                  if (sl_trail_active_orders_input < 0) break;
                  
                 TotalProfit = (Bid - OrderOpenPrice()) /Point/Dfactor_basedondigits;
                
   	           if (TotalProfit <=1) 
   	           {
          	   	  sl_trail_active_orders_input = noprofit_sl_trail_active_orders_input; 
   	           }      	

                  normalized_sl_trail_activeorders = NormalizeDouble(sl_trail_active_orders_input * GS_point, GS_digits);
          	
                  order_SL_normalized = NormalizeDouble(OrderStopLoss(), GS_digits);
                  SL_tobeused_inorder = NormalizeDouble(Bid - normalized_sl_trail_activeorders, GS_digits);  // Bid - sl_trail_active_orders_input
                  //SL_tobeused_inorder = NormalizeDouble(Bid - SL_points_touse*GS_point, GS_digits);  // Bid - sl_trail_active_orders_input
                  
                  //Print("*****TotalProfit=",TotalProfit, ", sl_trail_active_orders_input=", sl_trail_active_orders_input, ", Bid - sl_trail_active_orders_input", SL_tobeused_inorder, ", sl_for_pendingorders=",order_SL_normalized );
                  
                  if ( order_SL_normalized == 0.0 ||  SL_tobeused_inorder < order_SL_normalized )
                  {
                  //printf(" no need to modify SL ");
                  break;   // Bid - sl_trail_active_orders_input > sl_for_pendingorders 
                  }
                  
                  if (tp_input>0 && trail_target_also==True)
                     TP_tobeused_inorder = NormalizeDouble(Ask +  tp_input * Point, GS_digits);
                   else
                      TP_tobeused_inorder=OrderTakeProfit();
                      
                      //TP_tobeused_inorder=OrderTakeProfit();


                  boolvar_modify_done = OrderModify(OrderTicket(), OrderOpenPrice(), SL_tobeused_inorder, TP_tobeused_inorder, 0, clr_confirm_order_modify_sell);
                  if(boolvar_modify_done) 
                  {
                  //Print("Modify success : "+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                     break;
                  }
                  error_code = GetLastError();
                  error_details = ErrorDescription(error_code);
                  printf("#"+current_ticket_number+" normalized_distance_for_stop_order="+normalized_distance_for_stop_order+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
                  Print("BUY Modify Error Code: " + error_code + " Message: " + error_details + " OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  //Print("Modify error order#"+ current_ticket_number+" type: "+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  break;
                  
               case OP_SELL:
               
                  total_orders_open_active++;
                  if (sl_trail_active_orders_input < 0) break;
                  
                 TotalProfit = (OrderOpenPrice()- Ask)/Point/Dfactor_basedondigits;
                
   	           if (TotalProfit <= 1) 
   	           {
          	   	 sl_trail_active_orders_input = noprofit_sl_trail_active_orders_input; 
   	             }      	
          
                  normalized_sl_trail_activeorders = NormalizeDouble(sl_trail_active_orders_input * GS_point, GS_digits);
                  order_SL_normalized = NormalizeDouble(OrderStopLoss(), GS_digits);
                  
                  SL_tobeused_inorder = NormalizeDouble(Ask + normalized_sl_trail_activeorders, GS_digits);
                  //SL_tobeused_inorder = NormalizeDouble(Ask + SL_points_touse*GS_point, GS_digits);
                  
                  if ( order_SL_normalized == 0.0 || SL_tobeused_inorder > order_SL_normalized ) 
                  {
                  //printf(" no need to modify SL ");
                  break;   // Bid - sl_trail_active_orders_input > sl_for_pendingorders 
                  }
                  
                  if (tp_input>0 && trail_target_also==True)
                     TP_tobeused_inorder = NormalizeDouble(Bid -  tp_input * Point, GS_digits);
                   else
                      TP_tobeused_inorder=OrderTakeProfit();
                   //   TP_tobeused_inorder=OrderTakeProfit();

                  boolvar_modify_done = OrderModify(OrderTicket(), OrderOpenPrice(), SL_tobeused_inorder, TP_tobeused_inorder, 0, clr_confirm_order_modify_sell);
                  if(boolvar_modify_done) 
                  {
                  //Print("Modify : "+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                     break;
                  }
                                    error_code = GetLastError();
                  error_details = ErrorDescription(error_code);
                  printf("#"+current_ticket_number+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
                  Print("SELL Modify Error Code: " + error_code + " Message: " + error_details + " OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  //Print("Modify error  order#"+ current_ticket_number+" type:: "+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  break;
                  
               case OP_BUYSTOP:
                  price_tobeused = NormalizeDouble(Ask + normalized_distance_for_stop_order, GS_digits);  // Ask + distance_for_pending_order
                  current_order_price = NormalizeDouble(OrderOpenPrice(), GS_digits);
                  if (!((price_tobeused <= current_order_price))) break;  // If Ask + distance_for_pending_order > Buystop OpenPrice , Go to modify...  
                  //SL_tobeused_inorder = NormalizeDouble(Bid - SL_points_touse * Point, GS_digits);
                  SL_tobeused_inorder = NormalizeDouble(price_tobeused - SL_points_touse * Point, GS_digits);
                  boolvar_modify_done = OrderModify(OrderTicket(), price_tobeused, SL_tobeused_inorder, OrderTakeProfit(), 0, clr_pending_order_modify);
                  if(boolvar_modify_done) 
                  {
                  //Print("Modify : "+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                     break;
                  }
                  error_code = GetLastError();
                  error_details = ErrorDescription(error_code);
                  printf("#"+current_ticket_number+" normalized_distance_for_stop_order="+normalized_distance_for_stop_order+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
                  Print("BUYSTOP Modify Error Code: " + error_code + " Message: " + error_details + " OP: " + DoubleToStr(price_tobeused, GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  //Print("Modify error order#"+ current_ticket_number+" type: "+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  break;
               case OP_SELLSTOP:
                  current_order_price = NormalizeDouble(OrderOpenPrice(), GS_digits);
                  price_tobeused = NormalizeDouble(Bid - normalized_distance_for_stop_order, GS_digits);
                  if (!((price_tobeused >= current_order_price))) break;
                  //SL_tobeused_inorder = NormalizeDouble(Ask + SL_points_touse * Point, GS_digits);
                      SL_tobeused_inorder = NormalizeDouble(price_tobeused +  SL_points_touse  * Point, GS_digits);
                  boolvar_modify_done = OrderModify(OrderTicket(), price_tobeused, SL_tobeused_inorder, OrderTakeProfit(), 0, clr_pending_order_modify);
                  if(boolvar_modify_done) 
                  {
                  //Print("Modify : "+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                     break;
                  }
                  error_code = GetLastError();
                  error_details = ErrorDescription(error_code);
                  printf("#"+current_ticket_number+" normalized_distance_for_stop_order="+normalized_distance_for_stop_order+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
                  Print("SELLSTOP Modify Error Code: " + error_code + " Message: " + error_details + " OP: " + DoubleToStr(price_tobeused, GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  //Print("Modify error  order#"+ current_ticket_number+" type: "+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  break;

               }
            }
         }
      }
   }
   
   
   

   
  double pp, pd;
// work with GS_digits 
    if (GS_digits < 4) 
        {
                pp = 0.01;
                pd = 2;
            } 
            else 
               {
                  pp = 0.0001;
                  pd = 4;
               }
   
   /* OLD    // calculate the lots to trade 
      //Ld_196 = AccountBalance() * AccountLeverage() * riskpercent;
      Ld_196 = ( usable_equity - brokerage_total)  * AccountLeverage() * riskpercent;
      if (!lots_auto_managed) Ld_196 = FixedLots;
      lot_size_to_trade = NormalizeDouble(Ld_196 / MarketInfo(Symbol(), MODE_LOTSIZE), GS_step_logvalue);
      lot_size_to_trade = MathMax(GS_allowed_minlots_for_symbol, lot_size_to_trade);
      lot_size_to_trade = MathMin(GS_allowed_maxlots_for_symbol, lot_size_to_trade);
      
      */
      
      //Ld_196 =  usable_equity   * AccountLeverage() * riskpercent   ; // original 
      //Ld_196 =  usable_equity   * ( AccountLeverage()/ (1+ current_equity/(1+usable_equity)) )  * riskpercent   ; // original 
      //Ld_196 =  total_invested_money * Risk   ;
      //if (!lots_auto_managed) Ld_196 = FixedLots ; 
      //lot_size_to_trade = NormalizeDouble(Ld_196 / MarketInfo(Symbol(), MODE_LOTSIZE), GS_step_logvalue);
      
      //lot_size_to_trade = NormalizeDouble(riskpercent* usable_equity / ( 5 * MaxTrades ) , GS_step_logvalue);
      //symbol_name=Symbol();
      //if(symbol_name == "USDJPYc"  || symbol_name == "EURUSDc"  || symbol_name == "GBPUSDc" )
        // lot_size_to_trade = NormalizeDouble(100* riskpercent* usable_equity / ( (SL_points_touse ) * MaxTrades ) , GS_step_logvalue);
      Ld_196 =  usable_equity   *  AccountLeverage()  * riskpercent / MaxTrades  ; // original 
      //lot_size_to_trade = NormalizeDouble(riskpercent* usable_equity / ( (SL_points_touse ) * MaxTrades ) , GS_step_logvalue);
      lot_size_to_trade = NormalizeDouble(riskpercent* usable_equity / ( 100* MaxTrades )   , GS_step_logvalue);
      if (!lots_auto_managed) lot_size_to_trade = FixedLots ; 
      lot_size_to_trade = MathMax(GS_allowed_minlots_for_symbol, lot_size_to_trade);
      lot_size_to_trade = MathMin(GS_allowed_maxlots_for_symbol, lot_size_to_trade);
      
      last_lots_size=lot_size_to_trade;
   
   // placing the order here . 
   //if (total_orders_open_live <= MaxTrades -1 && buyorsell != 0 /*&& average_spread_withcommision <= maxspreadpluscommission*/ && NormalizeDouble(Ask - Bid, GS_digits) < NormalizeDouble(maxspread * pp, pd + 1) && workinghours_check_function()) 
   //if((usable_equity - brokerage_current  ) <=0   )  // if current equity with brokerage is low 
   if(  usable_equity   < ( equity_allocated_touse - acceptable_equity_loss ) || int(usable_equity)==0  )  // if current equity with brokerage is low 
      {
         printf("##Equity from "+equity_allocated_touse+ "*" +investment_counter+"="+total_invested_money+" to " + ( usable_equity +brokerage_current) +"/"+ (usable_equity  )+" brokerage_cr="+brokerage_current );
         if(OrdersTotal()>0)
         {
            printf("## orders = "+OrdersTotal()+" usable_equity="+usable_equity+" <=  ( equity_allocated_touse - acceptable_equity_loss )="+( equity_allocated_touse - acceptable_equity_loss ));
            if(  usable_equity   <= ( equity_allocated_touse - acceptable_equity_loss ) )  
              {
               printf("Closing all orders due to all money lost this time will do reinvestement " + equity_msg );
               close_all_orders();
               }
            return;
           }
              else
               {
                  init_investment();
                  return;
                  
               }
               
          if( equity_at_start < total_invested_money + equity_allocated_touse ) 
            return;
      }
      
      
   if (total_orders_open_live <= MaxTrades -1 && buyorsell != 0  && usable_equity   > ( equity_allocated_touse - acceptable_equity_loss -(2*lot_size_to_trade * brokerage_perlot ) )  ) 
   {  // New BUY STOP & SELL STOP Orders placed here..
      ////skcomment printf("order type ( 1 for sell , -1 for buy , 2 for both )= "+buyorsell) ;
      ////skcomment printf(message_to_display);
       printf("New order conditions met ");
      /*if(!workinghours_check_function())
         { 
         printf("conditions are fine but not placing order due to off working hours ="); 
         return ;
         }
      */
      
      if( AccountFreeMargin()<=0 )
         { 
         printf("conditions are fine but not placing order due to No Free Margin ="+AccountFreeMargin()); 
         close_all_orders();
         return ;
         }
         
      if( usable_equity   <=0 )
         { 
         //printf("conditions are fine but not placing order due to low usable equity ="+usable_equity); 
         return ;
         }
      if(average_spread_withcommision > maxspreadpluscommission)
         { 
         printf("conditions are fine but not placing order due to high maxspread commision ="+average_spread_withcommision); 
         return ;
         }
      if(NormalizeDouble(Ask - Bid, GS_digits) > NormalizeDouble(maxspread * pp, pd + 1))
         { 
         printf("conditions are fine but not placing order due to high Spread ="+( (Ask - Bid) / GS_point) + ">" + (maxspread  ) + " | "+NormalizeDouble(Ask - Bid, GS_digits) +" > "+ NormalizeDouble(maxspread * pp, pd + 1)  ); 
         return ;
         }
      
      //printf("########faCHECK== Traded lots="+ total_traded_lots_tillnow+"/"+lots_in_this_session+ " Brokerage="+brokerage_total +"/"+brokerage_current+" Profit = " + (current_equity-equity_at_start )+"/"+(current_equity-equity_at_start -brokerage_total) + " equity from " +equity_at_start+"/"+total_invested_money+"/"+ equity_allocated_touse +" to "+ current_equity+"/"+(current_equity-brokerage_total) +"/"+ usable_equity + "------#####--- "  );
      
       TradeComment="PEK:"+(highlow_diff/GS_point)+"_PR="+profit_total+"_SPR="+(spread_calculated/GS_point);
      if (buyorsell == -1 || buyorsell == 2 ) 
      {
         price_tobeused = NormalizeDouble(Ask + normalized_distance_for_stop_order, GS_digits);
         //SL_tobeused_inorder = NormalizeDouble(price_tobeused -  3 * sl_for_pendingorders * Point, GS_digits);
         SL_tobeused_inorder = NormalizeDouble(price_tobeused -  SL_points_touse * Point, GS_digits);
        TP_tobeused_inorder=0;
        //SL_tobeused_inorder=0;
         if (tp_input>0)
            TP_tobeused_inorder = NormalizeDouble(price_tobeused +  tp_input * Point, GS_digits);
         //ticket_20 = OrderSend(Symbol(), OP_BUYSTOP, lot_size_to_trade, price_tobeused, G_slippage_264, SL_tobeused_inorder, 0, TradeComment, MagicNumber, 0, Lime);
         ticket_20 = OrderSend(Symbol(), OP_BUYSTOP, lot_size_to_trade, price_tobeused, G_slippage_264, SL_tobeused_inorder, TP_tobeused_inorder, TradeComment, MagicNumber, 0, clr_pending_order_open_buy);
         if (ticket_20 <= 0) {
            error_code = GetLastError();
            error_details = ErrorDescription(error_code);
                  printf(" #"+ticket_20 + " normalized_distance_for_stop_order="+normalized_distance_for_stop_order+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
            printf("BUYSTOP Send Error Code: " + error_code + " Message: " + error_details + " LT: " + DoubleToStr(lot_size_to_trade, GS_step_logvalue) + " OP: " + DoubleToStr(price_tobeused, GS_digits) + " SL:"+DoubleToStr(SL_tobeused_inorder-Bid,GS_digits)+"=" + DoubleToStr(SL_tobeused_inorder, GS_digits)+" TP:" + TP_tobeused_inorder + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
          }
         else 
            {
            PlaySound("Alert.wav");
            printf("BUYSTOP Send Success LT: " + DoubleToStr(lot_size_to_trade, GS_step_logvalue) + " OP: " + DoubleToStr(price_tobeused, GS_digits) + " SL:"+DoubleToStr(SL_tobeused_inorder-price_tobeused,GS_digits)+"=" + DoubleToStr(SL_tobeused_inorder, GS_digits)+" TP:" + TP_tobeused_inorder + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
               printf("Success : buy order id = "+ticket_20+" price="+price_tobeused+" SL="+SL_tobeused_inorder);
               total_traded_lots_tillnow+=lot_size_to_trade;
               lots_in_this_session+=lot_size_to_trade;
               //printf(message_to_display);
               total_orders_executed++;
               last_order_time=TimeCurrent();
               if(total_orders_executed==1)
               first_order_time=TimeCurrent();

            }
       }  
      if (buyorsell == 1 || buyorsell == 2 ) {
          price_tobeused = NormalizeDouble(Bid - normalized_distance_for_stop_order, GS_digits);
          //SL_tobeused_inorder = NormalizeDouble(price_tobeused +  3 *sl_for_pendingorders  * Point, GS_digits);
          SL_tobeused_inorder = NormalizeDouble(price_tobeused +  SL_points_touse  * Point, GS_digits);
        TP_tobeused_inorder=0;
        //SL_tobeused_inorder=0;
         if (tp_input>0)
            TP_tobeused_inorder = NormalizeDouble(price_tobeused -  tp_input * Point, GS_digits);
          //SL_tobeused_inorder = NormalizeDouble(price_tobeused +  sl_for_pendingorders  * Point, GS_digits);
          //ticket_20 = OrderSend(Symbol(), OP_SELLSTOP, lot_size_to_trade, price_tobeused, G_slippage_264, SL_tobeused_inorder, 0, TradeComment, MagicNumber, 0, Orange);
          ticket_20 = OrderSend(Symbol(), OP_SELLSTOP, lot_size_to_trade, price_tobeused, G_slippage_264, SL_tobeused_inorder, TP_tobeused_inorder, TradeComment, MagicNumber, 0, clr_pending_order_open_sell);
          if (ticket_20 <= 0) {
            error_code = GetLastError();
            error_details = ErrorDescription(error_code);
                  printf(" #"+ticket_20 + " normalized_distance_for_stop_order="+normalized_distance_for_stop_order+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
            printf("SELLSTOP Send Error Code: " + error_code + " Message: " + error_details + " LT: " + DoubleToStr(lot_size_to_trade, GS_step_logvalue) + " OP: " + DoubleToStr(price_tobeused, GS_digits) + " SL: "+DoubleToStr(SL_tobeused_inorder-Ask,GS_digits)+"=" +  DoubleToStr(SL_tobeused_inorder, GS_digits)+" TP:" + TP_tobeused_inorder + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
         }
         else 
            {
            PlaySound("Alert.wav");
            printf("SELLSTOP succes LT: " + DoubleToStr(lot_size_to_trade, GS_step_logvalue) + " OP: " + DoubleToStr(price_tobeused, GS_digits) + " SL: "+DoubleToStr(SL_tobeused_inorder-price_tobeused,GS_digits)+"=" +  DoubleToStr(SL_tobeused_inorder, GS_digits)+" TP:" + TP_tobeused_inorder + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
               printf("Success : sell order id = "+ticket_20+" price="+price_tobeused+" SL="+SL_tobeused_inorder);
               
               total_traded_lots_tillnow+=lot_size_to_trade;
               lots_in_this_session+=lot_size_to_trade;
               //printf(message_to_display);
                  total_orders_executed++;
               last_order_time=TimeCurrent();
               if(total_orders_executed==1)
               first_order_time= TimeCurrent() ;

            }
      }
   }
  
 if(OrdersTotal()>0 )
   if(last_msg_value != (current_equity-equity_at_start -brokerage_total) ) 
      {
    brokerage_total=( total_traded_lots_tillnow * brokerage_perlot );
    brokerage_current=( lots_in_this_session * brokerage_perlot );
    
    current_equity=AccountEquity();
    usable_equity=current_equity-balance_equity - brokerage_total;
      printf("##"+(current_equity-equity_at_start -brokerage_total)+"##Orders #"+OrdersTotal()+"/"+MaxTrades+" Risk="+Risk+" lots(N/T/S)="+ (lot_size_to_trade)+"/"+int(total_traded_lots_tillnow)+"/"+int(lots_in_this_session)+ " Brkg="+brokerage_total +"/"+brokerage_current+"/"+ " EQT " +equity_at_start+"/"+total_invested_money+"/"+ equity_allocated_touse +" to "+ current_equity+"/"+(current_equity-brokerage_total) +"/"+ usable_equity +"sprd="+((Ask-Bid)/GS_point)+ " Pft#" + (current_equity-equity_at_start-brokerage_total )+ "##-- "  );
      last_msg_value=(current_equity-equity_at_start -brokerage_total);
    printf("##"+(current_equity-equity_at_start -brokerage_total)+"##2 PEAK#"+peaks_count+"#"+peak_details_last);
    printf("##"+(current_equity-equity_at_start -brokerage_total)+"##2 PEAK#"+peaks_count+"#"+peak_details);
      }
      
      
//// Calculations for peaks 
 if(OrdersTotal()==0)
 //if(peak_name_last != peak_name ||  profit_till_last_peak != profit_total )
 if( ( profit_till_last_peak != profit_total && total_orders_executed!=total_orders_executed_prev ) || profit_total==0 )
 //if(profit_total-profit_till_last_peak!=0)
 {
   total_orders_executed_prev=total_orders_executed;
    profit_in_this_peak=profit_total-profit_till_last_peak;
     
          if(profit_in_this_peak>0)
            {
               peaks_with_profit++;
               peaks_max_profit=MathMax(profit_in_this_peak,peaks_max_profit);
               if(peaks_average_profit==0) peaks_average_profit=profit_in_this_peak;
                  else peaks_average_profit=(peaks_average_profit+profit_in_this_peak)/2;
               peaks_won_amount+=profit_in_this_peak;
          peak_details_wins+=peak_name+"("+profit_in_this_peak +"/"+profit_total +")";
            }
          if(profit_in_this_peak<0)
            {
               peaks_with_loss++;
               peaks_max_loss=MathMax(-1*profit_in_this_peak,peaks_max_loss);
               if(peaks_average_loss==0) peaks_average_loss=profit_in_this_peak;
                 else peaks_average_loss=(peaks_average_loss+profit_in_this_peak)/2;
               peaks_lost_amount+=profit_in_this_peak;
          peak_details_lost+=peak_name+"("+profit_in_this_peak +"/"+profit_total +")";
            }
    if(profit_in_this_peak!=0)
    {
        peaks_count++;

    profit_till_last_peak=profit_total;
    //peak_details=peak_name+"("+profit_in_this_peak +"/"+profit_total +")"+peak_details;
    peak_names_list=peak_names_list+","+peak_name;
    peak_profits_list=peak_profits_list+","+profit_in_this_peak ;
    peak_details=peak_name+"("+profit_in_this_peak +"/"+profit_total +")"+peak_details;
    peak_details_last+=peak_name+"("+profit_in_this_peak +"/"+profit_total +")";
    peak_name_last=peak_name;
        printf("##"+(current_equity-equity_at_start -brokerage_total)+"#1 PEAK#"+peaks_count+"#"+peak_details);
        printf("##"+(current_equity-equity_at_start -brokerage_total)+"#1 PEAK#"+peaks_count+"#"+peak_details_last);
        printf("SKRMAIN \n Peaks total="+peaks_count+"="+profit_total+" Wins="+peaks_won_amount+"("+peaks_with_profit+"*"+peaks_average_profit+" max:"+peaks_max_profit+") Lost="+peaks_lost_amount+"("+peaks_with_loss+"*"+peaks_average_loss+" max"+peaks_max_loss+")"
              +" EQT IC="+lost_investment_counter+"(min="+equity_seen_min+"): " +equity_at_start+"/"+total_invested_money+"/"+ equity_allocated_touse +" to "+ current_equity+"/"+(current_equity-brokerage_total) +"/"+ usable_equity +" brkg="+brokerage_total+" Sprd="+((Ask-Bid)/GS_point) 
              +"\n Params :filter="+filter+" SL="+SL_points_touse+" TP="+ tp_input+" MaxTrades="+max_orders_count_input+"/"+ MaxTrades +" Risk="+risk_percentage_input+"/"+ Risk +" HL_df_lvl="+ highlow_diff_level + " useprofits="+profit_percentage_tobeused_fortrade+" fresh_invest="+fresh_invest_everytime+" bothside="+bothside+" timeclose="+Timed_Closing +"np_sl="+ noprofit_sl_trail_active_orders_input_usd+" wp_sl="+withprofit_sl_trail_active_orders_input_usd+" distance="+distance_for_pending_order_usd+" Start_Trailing_At="+ Start_Trailing_At+" TrailingStep="+TrailingStep
              +"\n Time Period="+TimeToStr(first_order_time)+"-"+TimeToStr(last_order_time) + " Orders/Lots="+total_orders_executed+"/"+total_traded_lots_tillnow
              //+"\n#wins#"+peaks_with_profit+"="+peak_details_wins+" \n#lost#"+peaks_with_loss +"="+peak_details_lost
              );
        printf("\n"+peak_names_list);
        printf("\n"+peak_profits_list);
    
   //send telegram message for update 
    message_to_send="SK#"+Symbol()+equity_msg
                  +" Orders="+ total_orders_open_live +"/"+ total_orders_executed
                  +" Peaks total="+peaks_count+"="+profit_total+" Wins="+peaks_won_amount+"("+peaks_with_profit+"*"+peaks_average_profit+" max:"+peaks_max_profit+") Lost="+peaks_lost_amount+"("+peaks_with_loss+"*"+peaks_average_loss+" max"+peaks_max_loss+")"
                  +" "+TimeLocal() + " "+peak_details;
   old_msg_sent_time=send_telegram_msg(message_to_send,"registered","adhoc",old_msg_sent_time,send_telgram_message_flag);
   
       
    //if(fresh_invest_everytime==True)
      //{
        // fresh_invest_everytime_function();
     // }
   }
          
  }

      
     
   // Display details on chart 
   min_equity_usable=MathMin(min_equity_usable,( usable_equity) );
   max_equity_usable=MathMax(max_equity_usable,( usable_equity) );
   min_equity=MathMin(min_equity,( current_equity ) );
   max_equity=MathMax(max_equity,( current_equity) );
   min_equity_nobrokerage=MathMin(min_equity_nobrokerage,( current_equity-brokerage_total  ) );
   max_equity_nobrokerage=MathMax(max_equity_nobrokerage,( current_equity-brokerage_total ) );
   
   equity_msg=" EQT "+equity_at_start+"/"+total_invested_money+"/"+ equity_allocated_touse +" to "+ current_equity+"/"+(current_equity-brokerage_total) +"/"+ usable_equity +" Pft=" + profit_total +" min="+equity_seen_min;
   
   
   
   message_to_display = "SK# " + quick_if_function((no_new_trades==False && stopworkingflag==False),"Working","Not working")
   + "\n\n Orders#"+total_orders_open_active+"/"+OrdersTotal()+"/"+total_orders_executed+" Traded_lots="+ int(total_traded_lots_tillnow)+"/"+int(lots_in_this_session)+ " Brkg="+brokerage_total +"/"+brokerage_current+"/"
   //+ " EQT " +equity_at_start+"/"+total_invested_money+"/"+ equity_allocated_touse +" to "+ current_equity+"/"+(current_equity-brokerage_total) +"/"+ usable_equity +" Pft=" + profit_total 
   + equity_msg
   +  "\n Equity min="+min_equity_nobrokerage+"/"+min_equity +" max_equity="+max_equity_nobrokerage+"/"+max_equity + " Free=" + AccountFreeMargin()+" Lvrg="+AccountLeverage()
   + "\n Current Spread: " + int((Ask-Bid)/usd_points  ) +"/"+int(maxspread*usd_points)
   + quick_if_function((MarketInfo(Symbol(), MODE_SPREAD) / MathPow(10, Digits - pd))> maxspread, "    **BLOCKED HIGH SPREAD  " + DoubleToStr(maxspread, Digits -pd )  , quick_if_function(average_spread_withcommision > maxspreadpluscommission, "    *******BLOCKED HIGH SPREAD AND COMMISION=" + average_spread_withcommision+"/"+maxspreadpluscommission  ,"|") )
   + "   Avg Sprd: " + int(average_spread/usd_points) +" brkg actual:" + int(commision_forpip/usd_points) + " spread+comision: " + int(average_spread_withcommision/ usd_points) + "/" + (MaxSpreadPlusCommission_usd)
   + "  \n Params :filter="+filter+" SL="+SL_points_touse+"/"+GS_allowed_SL_size_for_symbol+"/"+sl_for_pendingorders+" TP="+ tp_input+" MaxTrades="+ MaxTrades +" Risk="+ Risk +" HL_df_lvl="+ highlow_diff_level
   + " maxspread="+DoubleToStr(maxspread, Digits - pd)+"/"+DoubleToStr(maxspreadpluscommission, Digits - pd)+" HL_df_lvl="+ highlow_diff_level+ "normalized_sl_trail_activeorders"+ normalized_sl_trail_activeorders 
  // + "\n Lots:usable eq="+( usable_equity )  +" * leverage="+ AccountLeverage() +" * riskpercent="+ riskpercent + "="+( usable_equity * AccountLeverage() * riskpercent)
   + " \n filter="+(highlow_diff/GS_point)+"/"+ (given_filter_normalized /GS_point ) +"(avg="+int(highlow_diff_avg/GS_point)+" max="+int(highlow_diff_max/GS_point)+")"+" 1/2/3/4/5/10="+get_filter_value(1)/GS_point+"/"+get_filter_value(2)/GS_point+"/"+get_filter_value(3)/GS_point+"/"+get_filter_value(4)/GS_point+"/"+get_filter_value(5)/GS_point+"/"+get_filter_value(10)/GS_point+"|"
   + "\n Ld_196="+Ld_196+" Next Lot=" + DoubleToStr(lot_size_to_trade, GS_step_logvalue)+"/"+MarketInfo(Symbol(), MODE_MAXLOT) + " Time Period="+TimeToStr(first_order_time)+"-"+TimeToStr(last_order_time)+ " point="+GS_point+" digit="+GS_digits
   + "\n ## Peaks total="+peaks_count+" Wins="+peaks_won_amount+"("+peaks_with_profit+"*"+peaks_average_profit+"max:"+peaks_max_profit+") Lost="+peaks_lost_amount+"("+peaks_with_loss+"*"+peaks_average_loss+" max"+peaks_max_loss+")" 
   + "\n peaks#"+peaks_count+"="+peak_details
   ;

   
   if (average_spread_withcommision > maxspreadpluscommission) {
      message_to_display = message_to_display 
         + "\n\n" 
         + "  **The EA can not run with this spread ( " + (average_spread_withcommision/ GS_point ) + " > " + (maxspreadpluscommission ) + " )";
   }

   Comment(message_to_display);
   //Comment("this is me sk ");
   
    message_to_send="SK#"+Symbol()+equity_msg
                  +" Orders="+ total_orders_open_live +"/"+ total_orders_executed
                  +" Peaks total="+peaks_count+"="+profit_total+" Wins="+peaks_won_amount+"("+peaks_with_profit+"*"+peaks_average_profit+" max:"+peaks_max_profit+") Lost="+peaks_lost_amount+"("+peaks_with_loss+"*"+peaks_average_loss+" max"+peaks_max_loss+")"
                  +" "+TimeLocal() + " "+peak_details;

   
   old_msg_sent_time=send_telegram_msg(message_to_send,"registered","hourly",old_msg_sent_time,send_telgram_message_flag);

   
   RapidTrailingStop();
   
   
   
   
}


int fresh_invest_everytime_function()
   {
      if ( total_orders_open_live > 0 ) 
         {
         printf("fresh investment : waiting for all orders to close before making new investment ") ; 
         return(0);
         }
         
      current_equity=AccountEquity();
      //equity_at_start=current_equity;
      if(  current_equity < equity_at_start)
         {
            //if(investment_counter<=0)
               investment_counter=1;
            //investment_counter++;
            total_invested_money=(equity_allocated_touse*investment_counter);
            balance_equity=equity_at_start-total_invested_money;
            
         }
        else
        {
            investment_counter=1;
            total_invested_money=(equity_allocated_touse*investment_counter);
            if( current_equity > equity_at_start && profit_percentage_tobeused_fortrade > 0  )
               {
               int profit_touse=profit_total*profit_percentage_tobeused_fortrade/100;
               total_invested_money=( equity_allocated_touse + profit_touse );
               //MaxTrades=MathMin(100,current_equity/(equity_at_start/MaxTrades));
               //Risk=MathMin(100,current_equity/(equity_at_start/Risk) );
               //if(max_orders_count_input==0)
                  MaxTrades=MathMin(100,MathMax(MaxTrades,total_invested_money/100));
               //if(risk_percentage_input==0)
                  Risk=MathMin(10000000,MathMax(Risk,total_invested_money/100) );
               

               riskpercent = Risk / 100.0;
               }
         
            balance_equity=current_equity-total_invested_money;
            usable_equity=current_equity-balance_equity;
        }
      lots_in_this_session=0;
      
      if(equity_allocated_touse_input<=0) // if it is not set in options to use 
         equity_allocated_touse=equity_at_start;
         
      //total_invested_money=(equity_allocated_touse*investment_counter);
      printf("making a fresh investment of "+equity_allocated_touse_input + " investment_count="+investment_counter + " usable_equity="+usable_equity+" balance_equity="+balance_equity);
      printf("1##"+(current_equity-equity_at_start -brokerage_total)+"##Orders #"+OrdersTotal()+"/"+MaxTrades+" Risk="+Risk+" lots(T/S)="+ int(total_traded_lots_tillnow)+"/"+int(lots_in_this_session)+ " Brkg="+brokerage_total +"/"+brokerage_current+"/"+ " EQT " +equity_at_start+"/"+total_invested_money+"/"+ equity_allocated_touse +" to "+ current_equity+"/"+(current_equity-brokerage_total) +"/"+ usable_equity +"sprd="+((Ask-Bid)/GS_point)+ " Pft#" + (current_equity-equity_at_start-brokerage_total )+ "##-- "  );
     return(0);
   }
   
bool remove_pending_order(int ticket_number,color clr1)
   {
      bool returnvalue;
      // will work on current selected order 
      double lots_in_this_order=OrderLots();
      if( OrderDelete(ticket_number,clrWhite) )
         {
            
            total_traded_lots_tillnow-=lots_in_this_order;
            lots_in_this_session-=lots_in_this_order;
        printf("Closed pending order #"+ticket_number);
            returnvalue=True;
         }
        else
        {
        printf("Failed to close order #"+ticket_number);
            returnvalue=False;
        }
        
     return(returnvalue);

   }
   

int close_all_orders()
   {
   
   int total = OrdersTotal();
   printf("Going to Close all orders now count= "+OrdersTotal() );
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
                     	   printf("There was an error closing buy/sell order#"+OrderTicket()+". Error is:" + GetLastError() );
                       returnvalue=0;
                    
                     }
                     else 
                     	   printf("Closed buy/sell("+OrderType()+") order#"+OrderTicket() +" PR="+profit_total + "orders#"+OrdersTotal() );
                     	   
                     	   
                  if(OrderType() == OP_SELLSTOP || OrderType() == OP_BUYSTOP )
                     if( !remove_pending_order(OrderTicket(),clr_pending_order_close) )
                     {
                        if( !remove_pending_order(OrderTicket(),clr_pending_order_close) )
                     	   printf("There was an error closing pending order#"+OrderTicket()+". Error is:" + GetLastError() );
                       returnvalue=0;
                     }
                     else 
                     	   printf("Deleted Pending order ("+OrderType()+") order#"+OrderTicket() +" PR="+profit_total + "orders#"+OrdersTotal() );
                     

            }
         }


      }
      
    brokerage_total=( total_traded_lots_tillnow * brokerage_perlot );
    brokerage_current=( lots_in_this_session * brokerage_perlot );
    
    current_equity=AccountEquity();
    usable_equity=current_equity-balance_equity - brokerage_total+brokerage_current;
    printf("##Equity from "+equity_allocated_touse+ "*" +investment_counter+"="+total_invested_money+" to " + ( usable_equity +brokerage_current) +"/"+ (usable_equity  )+" brokerage_cr="+brokerage_current );
    return(returnvalue);
   }
      
void TimedClosing() {

   int total = OrdersTotal();

     if (!Timed_Closing || total<=0 ) 
       return;  
  
   int DC_Digits;  
   bool TicketClose;  
   int ExpirationBuyTime,ExpirationSellTime,MinBuyProfit,MinSellProfit;


  if (GS_digits == 4 || GS_digits == 2) DC_Digits = 1;
   else
      if (GS_digits == 5 || GS_digits == 3) DC_Digits = 10;
   
    ExpirationBuyTime=Minutes_Buy;
    ExpirationSellTime=Minutes_Sell;
    MinBuyProfit=Timed_Buy_TakeProfit*DC_Digits;
    MinSellProfit=Timed_Sell_TakeProfit*DC_Digits;

   for (int i = total - 1; i >= 0; i--) {
      
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE) { 
      if (OrderType() == OP_BUY && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber ) 
      {
         if (TimeCurrent() - OrderOpenTime() >= 60 * ExpirationBuyTime && Bid >= OrderOpenPrice() + MinBuyProfit * Point) 
         {
            RefreshRates();
            //skcomment printf("closing the op_Buy order#"+ OrderTicket()+" due to time distance_for_pending_order of  "+Minutes_Buy + " Minutes ");
            TicketClose = OrderClose(OrderTicket(), OrderLots(), Bid, G_slippage_264 , Blue);
            if (!TicketClose) 
             {
            	//skcomment printf("There was an error closing the order#"+OrderTicket()+". Error is:", GetLastError());
              return;
             }
           }
         }
       }
         
      if (OrderType() == OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) 
      {
         if (TimeCurrent() - OrderOpenTime() >= 60 * ExpirationSellTime && Ask <= OrderOpenPrice() - MinSellProfit * Point) 
         {
            RefreshRates();
            //skcomment printf("closing the op_sell order#"+ OrderTicket()+" due to time over  "+Minutes_Buy + " Minutes ");
            TicketClose = OrderClose(OrderTicket(), OrderLots(), Ask, G_slippage_264, Red);
            //---
            if (!TicketClose) {
              //skcomment printf("There was an error closing the order#"+OrderTicket()+". Error is:", GetLastError());
              return;
             }
          }
        }
        
         
      if ( ( OrderType() == OP_SELLSTOP || OrderType() == OP_BUYSTOP) && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) 
      {
         if (TimeCurrent() - OrderOpenTime() >= 60 * ExpirationSellTime ) 
         {
            //RefreshRates();
            //skcomment printf("closing the Pending order#"+ OrderTicket()+" due to time over of  "+Minutes_Buy + " Minutes ");
            TicketClose = OrderDelete(OrderTicket(),clrNONE);
            //---
            if (!TicketClose) {
              //skcomment printf("There was an error closing the order#"+OrderTicket()+". Error is:", GetLastError());
              return;
             }
          }
        }


        
      }
  }
      
			 	   	    	 			 						 				 			 		 	 	   				    	  	   		  	   		 		  	   	 				 		  		 			 	  	 		  		 		 	  				  	  		     		   					 	   
// 3B8B9927CE5F3E077818404E64D1C252
int workinghours_check_function() {
   if ((Hour() > StartHour && Hour() < EndHour) || (Hour() == StartHour && Minute() >= StartMinute) || (Hour() == EndHour && Minute() < EndMinute)) return (1);
   return (0);
}
	  				  			  		  	 	  	 	  	 		  	 		   				  												 							 		 			 	 	          	  		    		     	  		 				  	 	  		 			 		   			      	 	 	 	 	  	   			   			 	 							   		    	  		 			  	 				 		 				 		  				       		 	  	 	 		   	 	 	  	 	 											  	 		 	 				  		  		 		 		 			       		 	 		  	  			 		 	 			      	  		   					  						  			 		 	  	   			    			 	      	    			 	 			 			 	    				 	 		 			 			  	 			  	  	   	  			 	  			 		   			 	 		 	     		     	 	   	 	 	   	 			  	 			 					 	  		   	 	  		 	  		    	  		    	  	 	    				 						    		  	 	  		    	  	 		 	 		    		   	 		  			 							  						  		 					 	    	     	 			    	      	 			 					 	 	  	  			 			  			  	   	 		 			   		 	 	 		   							 		 		   	 	 		 					 	 		  	 	  	  	 	  	 		 			  	 	 	  		   					 		   		   				 	 		 		  		  	    		    		 	  	  	 	 			  	    		   		  	 				 		   			   	  	  			  						 							 			 				  	    		    	 	 	    	 	    	 	 	 							 	  	 				 				 			  		  	
string quick_if_function(bool condition, string ifTrue, string ifFalse) {
 
  if (condition) return(ifTrue); else return(ifFalse);
}

void RapidTrailingStop() {

   double l_point_36;
   double order_SL_normalized;
   double ld_52;
   double ld_60;
   double ld_68;
   
   bool result;
   for (int l_pos_100 = 0; l_pos_100 < OrdersTotal(); l_pos_100++) {
      
      if(OrderSelect(l_pos_100, SELECT_BY_POS, MODE_TRADES)== false) break;
      if (OrderSymbol() == Symbol() ) {
         if (MarketInfo(OrderSymbol(), MODE_POINT) == 0.00001) l_point_36 = 0.0001;
         else {
            if (MarketInfo(OrderSymbol(), MODE_POINT) == 0.001) l_point_36 = 0.01;
            else l_point_36 = MarketInfo(OrderSymbol(), MODE_POINT)/0.1;
         }
         ld_52 = Start_Trailing_At * l_point_36;   /// 20 PIPS 
         order_SL_normalized = TrailingStep * l_point_36;        /// 5 PIPS

         ld_68 = Set_BreakEvenAt * l_point_36;
         ld_60 = LockPips * l_point_36;
         
         
         if (OrderType() == OP_BUY && (OrderMagicNumber() == MagicNumber)) {
            if (Use_TrailingStep && Bid - OrderOpenPrice() >= ld_52) 
            {
             
               if (Bid - OrderStopLoss() >= ld_52 + order_SL_normalized) 
               {
                  result = OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss() + order_SL_normalized, OrderTakeProfit(), 0, DodgerBlue);
                  if ( GetLastError()!=0) Print(Symbol()+ ": Trail BUY OrderModify PROBLEM ! order_SL_normalized="+order_SL_normalized+" Start_Trailing_At="+Start_Trailing_At+" l_point_36"+l_point_36 );   
               }
            }

            if (Use_Set_BreakEven && Bid - OrderOpenPrice() >= ld_68) {
               if (OrderStopLoss() < OrderOpenPrice()) {
                  result= OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice() + ld_60, OrderTakeProfit(),0, DodgerBlue);
                  if ( GetLastError()!=0) Print(Symbol()+ ": BreakEven BUY OrderModify PROBLEM ! order_SL_normalized="+order_SL_normalized+" Start_Trailing_At="+Start_Trailing_At+" l_point_36"+l_point_36 );   

               }
            }
            
            
         } else {
            if (OrderType() == OP_SELL && (OrderMagicNumber() == MagicNumber)) {
               if (Use_TrailingStep && OrderOpenPrice() - Ask >= ld_52) {
                 
                  if (OrderStopLoss() - Ask >= ld_52 + order_SL_normalized) {
                 
                   result= OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss() - order_SL_normalized, OrderTakeProfit(),0, Yellow);
                   if (GetLastError()!=0) Print(Symbol()+ ": Trail SELL OrderModify PROBLEM ! " );
                  }
               }
              
               if (Use_Set_BreakEven && OrderOpenPrice() - Ask >= ld_68) {
                  if (OrderStopLoss() > OrderOpenPrice()) {
                     result= OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice() - ld_60, OrderTakeProfit(),0, Yellow);
                    if ( GetLastError()!=0) Print(Symbol()+ ": BreakEven SELL OrderModify PROBLEM ! " );   

                  }
               }
            }
         }
      }
   }
}



int send_telegram_msg(string message1,string user_status , string frequencey , int msg_last_sent, bool send_telgram_message_flag1 )
      {

        if(user_status == "testing")
             return(-1);
             
        if(send_telgram_message_flag1 == False)
             return(-1);
        
        datetime sknow=TimeCurrent();
        int skcurrent=0;
        if(frequencey=="eachorder")   
            skcurrent+= OrdersTotal(); 
        if(frequencey=="hourly")   
            skcurrent+=TimeHour(TimeCurrent());   
        if(frequencey=="everyminute")   
            skcurrent+=TimeMinute(TimeCurrent());   
        if(frequencey=="adhoc")   
            skcurrent+=TimeMinute(TimeCurrent());   

         string mytocken="1978145861:AAHRAD0hYnwjI3uP4nQx_jopMwkweSwqdx4";
         string chat_id="602973674";
         string acname=AccountName();
         if(IsDemo()==True) acname="D."+acname;
                    else  acname="R."+acname;
         
         string message="SKR:"+acname+":"+AccountEquity()+":"+message1+"END"+msg_last_sent;
         string base_url="https://api.telegram.org";
         string url=base_url+"/bot"+mytocken+"/sendMessage?chat_id="+chat_id+"&text="+message;
         string cookie=NULL,headers;
         char post[],result[];
         
      //printf ( " url = "+ url ) ;
         ResetLastError();
         int timeout=2000;
         int result1,returnvalue=0;

                if(skcurrent!=msg_last_sent && skcurrent!=0 )   // msg_last_sent is global variable 
                    {
                    msg_last_sent=skcurrent;
                    result1=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
                    }
    

  // printf("skcurrent="+skcurrent +" result1="+result1);
         if(result1==-1)
            {
               returnvalue=-1;
               int errorcode=GetLastError();
               string errordescription=ErrorDescription(errorcode);
               printf("Error in sending telegram msg code="+errorcode + " | "+errordescription ); 
               if(errorcode==4060)
                {
                  printf("ERROR : EXITING : Add URL https://api.telegram.org in mt4 settings(tools -> options -> Expert -> Add the urls ) ");
                  
                }
                  
            }
            else
                {
                    returnvalue=msg_last_sent;
                    //skdebug("Status update msg sent "+message,dbgcheck2);
                }
        return(returnvalue);
               
      }


int deinit()
   {
   printf("######################## END #####################");
   printf(message_to_display);
   printf("\n#filter="+filter+" Pft=" + (current_equity-equity_at_start-brokerage_total ) +" "+TimeToStr(first_order_time)+"-"+TimeToStr(last_order_time)+" Traded lots="+ int(total_traded_lots_tillnow)+"/"+int(lots_in_this_session)+ " Brkg="+brokerage_total +"/"+brokerage_current+"/"+ " EQT " +equity_at_start+"/"+total_invested_money+"/"+ equity_allocated_touse +" to "+ current_equity+"/"+(current_equity-brokerage_total) +"/"+ usable_equity +"sprd="+(Ask-Bid)+ " Pft=" + (current_equity-equity_at_start-brokerage_total )+ "###--- "  );
   printf("peak_details#\n"+peaks_count+"="+peak_details);
   printf("\n#peak_details_wins#"+peaks_with_profit+"="+peak_details_wins);
   
   
   printf("\n#peak_details_lost#"+peaks_with_loss +"="+peak_details_lost);
        printf("SKRMAIN \n Peaks total="+peaks_count+"="+profit_total+" Wins="+peaks_won_amount+"("+peaks_with_profit+"*"+peaks_average_profit+" max:"+peaks_max_profit+") Lost="+peaks_lost_amount+"("+peaks_with_loss+"*"+peaks_average_loss+" max"+peaks_max_loss+")"
              +" EQT IC="+lost_investment_counter+"(min="+equity_seen_min+"): " +equity_at_start+"/"+total_invested_money+"/"+ equity_allocated_touse +" to "+ current_equity+"/"+(current_equity-brokerage_total) +"/"+ usable_equity +" brkg="+brokerage_total+" Sprd="+((Ask-Bid)/GS_point) 
              +"\n Params :filter="+filter+" SL="+SL_for_pendingorders_usd+" TP="+ tp_input_usd+" MaxTrades="+max_orders_count_input+"/"+ MaxTrades +" Risk="+risk_percentage_input+"/"+ Risk +" HL_df_lvl="+ highlow_diff_level + " useprofits="+profit_percentage_tobeused_fortrade+" fresh_invest="+fresh_invest_everytime+" bothside="+bothside+" timeclose="+Timed_Closing +"np_sl="+ noprofit_sl_trail_active_orders_input_usd+" wp_sl="+withprofit_sl_trail_active_orders_input_usd+" distance="+distance_for_pending_order_usd+" Start_Trailing_At="+ Start_Trailing_At+" TrailingStep="+TrailingStep
              +"\n Time Period="+TimeToStr(first_order_time)+"-"+TimeToStr(last_order_time) + " Orders/Lots="+total_orders_executed+"/"+total_traded_lots_tillnow
              //+"\n#wins#"+peaks_with_profit+"="+peak_details_wins+" \n#lost#"+peaks_with_loss +"="+peak_details_lost
              );
    // for(int kk=1;kk<peaks_count;kk++)  Print(array_of_peaks[kk]);
   printf("######################## END #####################");
   return(1);
   }
   
   
   /*
   
2022.02.11 11:48:29.636	2022.02.10 23:59:46  BU_10222_final1_update1 EURUSD,M1: ##highlow_diff=0.00019 given_filter_normalized=0.0013
2022.02.11 11:48:29.636	2022.02.10 23:59:46  BU_10222_final1_update1 EURUSD,M1: ##Account level Equity from 1000 to 983/966 Profit=-34 min=974 max_equity=1001
2022.02.11 11:48:29.636	2022.02.10 23:59:46  BU_10222_final1_update1 EURUSD,M1: ##SL_points_touse=26.4 allowed_SL_size=26.4 sl_for_pendingorders=30 Real avg.spread:0.000000 maxlotsize=200 Next Lot=0.07
2022.02.11 11:48:29.636	2022.02.10 23:59:46  BU_10222_final1_update1 EURUSD,M1: ##Params :filter=130 SL=26.4 TP=100 MaxTrades=20 Risk=5
2022.02.11 11:48:29.636	2022.02.10 23:59:46  BU_10222_final1_update1 EURUSD,M1: ##total_lots_traded=3.6 Orders=20/26 Brokerage = 17
2022.02.11 11:48:29.636	2022.02.10 23:59:46  BU_10222_final1_update1 EURUSD,M1: ##Profit = -17 after brokerage = -34
2022.02.11 11:48:29.636	2022.02.10 23:59:46  BU_10222_final1_update1 EURUSD,M1: ##Equity from 100*1=100 to 83 - brokerage=66 min=58/74 max_equity=100/101
2022.02.11 11:48:19.482	2022.02.03 13:56:15  BU_10222_final1_update1 EURUSD,M1: ++#46 normalized_distance_for_stop_order=0.00022OP: 1.13398/-0.00002 SL: 1.13424/-0.00026 Bid: 1.13420/-0.00004 Ask: 1.13420/-0.00004
   
   
   
2022.02.11 10:15:16.672	2022.02.10 23:59:46  sk_prod11_user3 EURUSD,M1: highlow_diff=0.00019 given_filter_normalized=0.0013
2022.02.11 10:15:16.672	2022.02.10 23:59:46  sk_prod11_user3 EURUSD,M1: Account level Equity from 1000 to 2708/2097 Profit=1097 min=980 max_equity=2365
2022.02.11 10:15:16.672	2022.02.10 23:59:46  sk_prod11_user3 EURUSD,M1: SL_points_touse=26.4 allowed_SL_size=26.4 sl_for_pendingorders=30
2022.02.11 10:15:16.672	2022.02.10 23:59:46  sk_prod11_user3 EURUSD,M1: Params :filter=130 SL=26.4 TP=100 MaxTrades=20 Risk=5
2022.02.11 10:15:16.672	2022.02.10 23:59:46  sk_prod11_user3 EURUSD,M1: total_lots_traded=122.25 Orders=0/371 Brokerage = 611
2022.02.11 10:15:16.672	2022.02.10 23:59:46  sk_prod11_user3 EURUSD,M1: Profit = 1708 after brokerage = 1097
2022.02.11 10:15:16.672	2022.02.10 23:59:46  sk_prod11_user3 EURUSD,M1: Equity from 100*1=100 to 1808 - brokerage=1197 min=80/89 max_equity=1465/2076
2022.02.11 11:50:55.244	2022.02.10 17:47:50  sk_prod11_user3 EURUSD,M1: SELL Modify Error Code: 1 Message: no error, trade conditions not changed OP: 1.14540 SL: 1.14507 Bid: 1.14487 Ask: 1.14487
2022.02.11 11:50:55.244	2022.02.10 17:47:50  sk_prod11_user3 EURUSD,M1: #368 normalized_distance_for_stop_order=0.00022OP: 0.00000/0 SL: 1.14507/-1.14507 Bid: 1.14487/-0.0002 Ask: 1.14487/-0.0002

   
   */