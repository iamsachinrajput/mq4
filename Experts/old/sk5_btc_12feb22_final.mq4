#property copyright "SKRAJ"
#import "stdlib.ex4"
string ErrorDescription(int a0); 
#import



// ================== variables common 
//input string yourtelegramchannel="thisisforsachin"; 
//input string yourlicensekey="thisisforsachin";
//input datetime licesevaliddate;
extern bool send_telgram_message_flag=False;
extern  bool bothside=True;
extern bool cancel_pending=False;
extern bool chase_stop_order=True;
extern bool trail_target_also=True;
extern int brokerage_perlot=7;
extern int equity_allocated_touse_input=100;
extern int acceptable_equity_loss=100;
extern int MaxTrades = 10;
extern double Risk = .1;  // org 60

extern double MinLots = 0.01;
extern double MaxLots = 50000.0;//100000.0;
extern double FixedLots = 0.01;//0.1;
extern bool UseMM = TRUE;
extern int MagicNumber = 678234;
extern string TradeComment = "SKRAJ";

extern string TimeFilter = "---------- Time Filter ----------";
extern int StartHour = 0;
extern int StartMinute = 0;
extern int EndHour = 23;
extern int EndMinute = 59;

extern string IndicatorSetting = "=== Indicator Settings ===";
extern int IndicatorToUse_input = 1;  // 0 = Moving Average ( iMA ), 1 = Envelope (iEnvelope)
extern int Env_period = 10;
extern double Env_deviation = 0.07; // 0.05
extern int Env_shift = 0;
extern int MAPeriod = 15;
extern int MAMethod = 1;

// ================== variables symbol specific 
extern int Filter = 27000;
extern int Filter_EU = 130; //org 140
extern int Filter_GU = 170;
extern int Filter_UJ = 190;
extern int target_input_points=0 ; 
extern double StopLoss = 4000;  //this is for our BUY/SELL STOP SL 2.3 pips modify, can not put 200 pips, will lose !!!
extern double Limit = 4000.0;    // 20 will cause order130 error
extern double Distance_input = 4000; // not used !!!
extern double NoTrade_Profit_Yet_StopLoss = 5000;  //30 pips
extern double NoTrade_Profit_Yet_Limit = 5000;  // can not play with this , 20 should be ok!!!
extern double NoTrade_Profit_Yet_Distance = 5000;
extern double InTrade_Profit_Distance = 5000;
extern double InTrade_Profit_StopLoss = 5000;       //2.3 pips
extern double InTrade_Profit_Limit = 5000;
extern bool Use_TrailingStep = TRUE;
extern double Start_Trailing_At = 5000.0;  // org 2.9 meaning keep bid/ask Distance_input by x PIPS
extern double TrailingStep = 50.0;        // org 0.3
extern bool Use_Set_BreakEven = TRUE;
extern double Set_BreakEvenAt = 5000.0;   // org 2.3
extern double LockPips =  30.0;           // org 0.3
extern double MaxSpreadPlusCommission = 3000 ;//6.3 ok !
extern double MaxSpreadPlusCommission_EU = 16.3;//0.6 ok !
extern double MaxSpreadPlusCommission_GU = 16.0;//1.0 ok !
extern double MaxSpreadPlusCommission_UJ = 16.0;//0.6 ok !

extern double MaxSpread = 2000  ;//6.3 ok !
extern double MaxSpread_EU = 12.6;//0.6 ok !
extern double MaxSpread_GU = 12.0;//1.0 ok !
extern double MaxSpread_UJ = 20.6;//0.6 ok !

//------ variables ----------- 

int old_msg_sent_time=0;
double total_traded_lots_tillnow=0;

int Env_low_band_price = PRICE_HIGH;
int Env_high_band_price = PRICE_LOW;

extern bool Timed_Closing = TRUE;  
extern int Minutes_limit_for_order=5;



int Minutes_Buy =  Minutes_limit_for_order; //Minute
int Minutes_Sell = Minutes_limit_for_order; 
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
double max_spreadandcommision;
double given_limit_normalized;
double given_distance_normalized;
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
  bool stopworkingflag=False;
  double lots_in_this_session=0;
  int brokerage_total;
  double highlow_diff;
  double last_lots_size=0;
  extern int highlow_diff_level=1;
  int last_msg_value=0;
  string datewise_profit;
  int total_orders_executed=0;
  datetime first_order_time;
  datetime last_order_time;


// E37F0136AA3FFAF149B351F6A4C948E9



int init() 
    {
    
    
      equity_allocated_touse=equity_allocated_touse_input;
      investment_counter=0;
      current_equity=AccountEquity();
      equity_at_start=current_equity;
        //int timeframe_8;
         init_investment();
         min_equity=current_equity;
        riskpercent = Risk / 100.0;
        ArrayInitialize(array_of_spreads, 0);
        GS_digits = Digits;
        GS_point = Point;
        printf("System_Digits: " + GS_digits + " Point: " + DoubleToStr(GS_point, GS_digits));
        double current_oGS_allowed_lotstep_size_for_symbolrder_price = MarketInfo(Symbol(), MODE_LOTSTEP);
        GS_allowed_SL_size_for_symbol = MarketInfo(Symbol(),MODE_STOPLEVEL)*1.2;
        GS_step_logvalue = MathLog(current_oGS_allowed_lotstep_size_for_symbolrder_price) / MathLog(0.1);
        GS_allowed_minlots_for_symbol = MathMax(MinLots, MarketInfo(Symbol(), MODE_MINLOT));
        GS_allowed_maxlots_for_symbol = MathMin(MaxLots, MarketInfo(Symbol(), MODE_MAXLOT));
        symbol_name = StringSubstr (Symbol(),0,6);
        
        if (symbol_name == "EURUSD" || symbol_name == "EURUSDc" ) 
        {
        

        MaxSpread  = MaxSpread_EU; 
        Filter = Filter_EU;
                StopLoss=MathMax(2*(Ask-Bid)/GS_point,SL_points_touse) ;
                //StopLoss=23 ;
                Limit = 23;// 20 will cause order130 error
                Distance_input = 30; // not used !!!
                NoTrade_Profit_Yet_StopLoss = 30;
                NoTrade_Profit_Yet_Limit = 22; // 22
                NoTrade_Profit_Yet_Distance = 20;  // can not play with this , 20 should be ok!!!
                InTrade_Profit_Distance = 30;
                InTrade_Profit_StopLoss = 60;
                InTrade_Profit_Limit = 25;
                Start_Trailing_At = 2.9;  // org 2.9 meaning keep bid/ask Distance_input by x PIPS
                Set_BreakEvenAt = 2.3;
                TrailingStep = 0.3;        // org 0.3
                LockPips =  0.3;           // org 0.3
         }
        else if (symbol_name == "GBPUSD" || symbol_name == "GBPUSDc" ) 
           {
              MaxSpread  = MaxSpread_GU; 
              Filter = Filter_GU;
              Limit=MathMax(GS_allowed_SL_size_for_symbol,Limit) ; 
              NoTrade_Profit_Yet_Limit=MathMax(GS_allowed_SL_size_for_symbol,NoTrade_Profit_Yet_Limit) ; 
              InTrade_Profit_Limit=MathMax(GS_allowed_SL_size_for_symbol,InTrade_Profit_Limit) ; 
              Distance_input=MathMax(GS_allowed_SL_size_for_symbol,Distance_input) ; 
   
           }
         else if (symbol_name == "USDJPY" || symbol_name == "USDJPYc" ) 
           {
           MaxSpread  = MaxSpread_UJ; 
           Filter = Filter_UJ;
           Limit=MathMax(GS_allowed_SL_size_for_symbol,Limit) ; 
           NoTrade_Profit_Yet_Limit=MathMax(GS_allowed_SL_size_for_symbol,NoTrade_Profit_Yet_Limit) ; 
           InTrade_Profit_Limit=MathMax(GS_allowed_SL_size_for_symbol,InTrade_Profit_Limit) ; 
           Distance_input=MathMax(GS_allowed_SL_size_for_symbol,Distance_input) ; 
           }
           else if (symbol_name == "BTCUSD" || symbol_name == "BTCUSDc" ) 
           {
              //Filter = Filter;
              riskpercent = Risk / 100/100/MaxTrades;
              
             // highlow_diff_level=2;
                StopLoss=2*(Ask-Bid)/GS_point ;
                Limit = StopLoss;
                Distance_input = StopLoss;
                NoTrade_Profit_Yet_StopLoss = StopLoss;
                NoTrade_Profit_Yet_Limit = StopLoss;
                NoTrade_Profit_Yet_Distance = StopLoss;
                InTrade_Profit_Distance = StopLoss;
                InTrade_Profit_StopLoss = StopLoss;
                InTrade_Profit_Limit = StopLoss;
                Start_Trailing_At = StopLoss;
                Set_BreakEvenAt = StopLoss;
                TrailingStep = 50.0;        // org 0.3
                Set_BreakEvenAt = 5000.0;   // org 2.3
                LockPips =  30.0;           // org 0.3
              printf("SL_points_touse="+SL_points_touse+" allowed_SL_size="+GS_allowed_SL_size_for_symbol+" StopLoss="+StopLoss);
           }
           else
              {
              Limit=MathMax(GS_allowed_SL_size_for_symbol,Limit) ; 
              NoTrade_Profit_Yet_Limit=MathMax(GS_allowed_SL_size_for_symbol,NoTrade_Profit_Yet_Limit) ; 
              InTrade_Profit_Limit=MathMax(GS_allowed_SL_size_for_symbol,InTrade_Profit_Limit) ; 
              Distance_input=MathMax(GS_allowed_SL_size_for_symbol,Distance_input) ; 


              }
      
        printf("SL_points_touse="+SL_points_touse+" allowed_SL_size="+GS_allowed_SL_size_for_symbol+" StopLoss="+StopLoss);
        SL_points_touse=MathMax(GS_allowed_SL_size_for_symbol,StopLoss) ; 

        max_spreadandcommision = NormalizeDouble(MaxSpreadPlusCommission * GS_point, GS_digits + 1);
        given_limit_normalized = NormalizeDouble(Limit * GS_point, GS_digits);
        given_distance_normalized = NormalizeDouble(Distance_input * GS_point, GS_digits);
        given_filter_normalized = NormalizeDouble(Filter * GS_point , GS_digits);
        boolvar_to_run_once = FALSE;
        commision_forpip = NormalizeDouble(pips_input * GS_point, GS_digits + 1); 

        Dfactor_basedondigits = 1;
        
            if(GS_digits == 3|| GS_digits == 5) Dfactor_basedondigits = 10;        
        
        // create a button to display 
           string skbutton_name="bar_height";
            long givenx=2000;
            long giveny=500;
            ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,True);
            ObjectCreate(0,skbutton_name,OBJ_BUTTON,0,0,0);
            ObjectSetInteger(0,skbutton_name,OBJPROP_SELECTABLE,True);
            ObjectSetInteger(0,skbutton_name,OBJPROP_XDISTANCE,givenx);
            ObjectSetInteger(0,skbutton_name,OBJPROP_YDISTANCE,giveny);
            ObjectSetInteger(0,skbutton_name,OBJPROP_XSIZE,20);
            
            ObjectSetText(skbutton_name,skbutton_name);

        
        return (0);
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
            returnvalue=True;
         }
        else
        {
        printf("Failed to close order #"+ticket_number);
            returnvalue=False;
        }
        
     return(returnvalue);

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
         printf("All amount finished can not reinvest. current equity ="+(current_equity-brokerage_total) ) ; 
         if(OrdersTotal() == 0 ) 
            stopworkingflag=True;
         return(0);
         } 
      current_equity=AccountEquity();
      //equity_at_start=current_equity;
      investment_counter+=1;
      lots_in_this_session=0;
      if(equity_allocated_touse_input<=0) 
         equity_allocated_touse=equity_at_start;
      total_invested_money=(equity_allocated_touse*investment_counter);
      balance_equity=equity_at_start-total_invested_money;
      printf("Money reinvestment of "+equity_allocated_touse_input + " investment_count="+investment_counter);
     return(0);
   }

	 	  	 			  	   	  	  	 				    	  	 					    	  	   	   	 	 	   	 	 		  		 					 			 		  	   				 		 		  	      			   			 	 	 	 					  	 			  	 
void OnTick() {

   if(stopworkingflag)
      return;


   if ( current_equity <=0 || AccountFreeMargin()<=0 ) 
      {
      //deinit();
      return;
      }
      
    // defind variables 
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
    double lot_size_to_trade=0;

    double indicator_low;
    double indicator_high;
    double indicator_highlow_diff;
    
   if (symbol_name == "BTCUSD" || symbol_name == "BTCUSDc" ) 
           {
                double skspread=(Ask-Bid)/GS_point;
                StopLoss=skspread*2 ;
                Limit = skspread*2;
                Distance_input = StopLoss;
                NoTrade_Profit_Yet_StopLoss = StopLoss;
                NoTrade_Profit_Yet_Limit = StopLoss;
                NoTrade_Profit_Yet_Distance = StopLoss;
                InTrade_Profit_Distance = StopLoss;
                InTrade_Profit_StopLoss = StopLoss;
                InTrade_Profit_Limit = StopLoss;
                Start_Trailing_At = StopLoss;
                Set_BreakEvenAt = StopLoss;
                TrailingStep = 50.0;        // org 0.3
                Set_BreakEvenAt = StopLoss;   // org 2.3
                LockPips =  30.0;           // org 0.3
           StopLoss=skspread*2 ;
           target_input_points=skspread*2;
                
                
        given_limit_normalized = NormalizeDouble(Limit * GS_point, GS_digits);
        given_distance_normalized = NormalizeDouble(Distance_input * GS_point, GS_digits);
        given_filter_normalized = NormalizeDouble(Filter * GS_point , GS_digits);
        SL_points_touse=MathMax(GS_allowed_SL_size_for_symbol,StopLoss) ; 
        
              ////skcomment printf("SL_points_touse="+SL_points_touse+" allowed_SL_size="+GS_allowed_SL_size_for_symbol+" StopLoss="+StopLoss);
           }    
    brokerage_total=( total_traded_lots_tillnow * brokerage_perlot );
    brokerage_current=( lots_in_this_session * brokerage_perlot );
    
    current_equity=AccountEquity();
    usable_equity=current_equity-balance_equity - brokerage_total;
    
    

    
	
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
   double average_spread = sum_of_gda_array / counter_instart_upto30;

    // normalise with the commision called brokerage ( it is taken from order so it is accurate )
   double ask_with_commision = NormalizeDouble(Ask + commision_forpip, GS_digits);  //Ask + comission
   double bid_with_commision = NormalizeDouble(Bid - commision_forpip, GS_digits);  //Bid - comission
   double average_spread_withcommision = NormalizeDouble(average_spread + commision_forpip, GS_digits + 1);

/*

 // check if high movement is there 
double High_array = iHigh(NULL, 0, 0);
double Low_array = iLow(NULL, 0, 0);
double High_array_last = iHigh(NULL,0,1);
double Low_array_last = iLow(NULL, 0, 1);
 
double highlow_diff_last2 = (MathMax(High_array_last, High_array) - MathMin(Low_array, Low_array_last) );
double highlow_diff_last = High_array_last - Low_array_last;
double highlow_diff_current = High_array - Low_array;
   
      highlow_diff=highlow_diff_current;
   if(highlow_diff_level==2)
      highlow_diff=highlow_diff_last2;
   */
 // highlow_diff_level=2; 
   
   int higest_bar=iHighest(NULL,0,MODE_HIGH,highlow_diff_level,0);
   int lowest_bar=iLowest(NULL,0,MODE_LOW,highlow_diff_level,0);
 highlow_diff=iHigh(NULL, 0, higest_bar) - iLow(NULL, 0, lowest_bar) ; 
   
   buyorsell=0;
   sk_high_movement=0;
   if (highlow_diff > given_filter_normalized) 
   {
   
   ////skcomment printf("highlow_diff="+(highlow_diff/ GS_point )+" given_filter_normalized="+ (given_filter_normalized/ GS_point )+" highlow_diff_current="+ (highlow_diff_current/ GS_point )+" last="+(highlow_diff_last/ GS_point )+" forlast2="+(highlow_diff_last2/ GS_point ) );
      sk_high_movement=1;
      if (Ask < indicator_low) buyorsell = 1;  // for BUY
      else
         if (Bid > indicator_high) buyorsell = -1; // for SELL
    if(bothside==True) 
        {
            buyorsell=2;
        }
   }
   
 
   
   // traverse all the open orders for modifying the SL for live orders and price for pending orders . 
   total_orders_open_live = 0;
   for (order_position_for_selecting = 0; order_position_for_selecting < OrdersTotal(); order_position_for_selecting++) 
   {
      if (OrderSelect(order_position_for_selecting, SELECT_BY_POS, MODE_TRADES)) 
      {
         if (OrderMagicNumber() == MagicNumber) 
         {
            open_order_type = OrderType();
            if (open_order_type == OP_BUYLIMIT || open_order_type == OP_SELLLIMIT) continue; //skip this !
         
            double TotalProfit = 0.0; 
            if (OrderSymbol() == Symbol()) 
            {
               int current_ticket_number=OrderTicket();
               total_orders_open_live++;
               ////skcomment printf("SK check order#"+ current_ticket_number + " type="+OrderType() +" CRP="+OrderProfit()+" current SL=" +OrderStopLoss()+ " OP_BUY="+ OP_BUY+" OP_SELL="+ OP_SELL+" OP_BUYSTOP"+ OP_BUYSTOP + " OP_SELLSTOP" + OP_SELLSTOP+ " OP_BUYLIMIT="+OP_BUYLIMIT+" OP_SELLLIMIT="+OP_SELLLIMIT   );
               switch (open_order_type) {
               case OP_BUY:
                  if (Distance_input < 0) break;
                 TotalProfit = (Bid - OrderOpenPrice()) /Point/Dfactor_basedondigits;
   	           if (TotalProfit <=1) 
   	           {
          	   	  Distance_input = NoTrade_Profit_Yet_Distance; 
   	              Limit = NoTrade_Profit_Yet_Limit;
   	              StopLoss= NoTrade_Profit_Yet_StopLoss; 
   	           }      	
                  given_distance_normalized = NormalizeDouble(Distance_input * GS_point, GS_digits);
                  given_limit_normalized = NormalizeDouble(Limit * GS_point, GS_digits); 
                  order_SL_normalized = NormalizeDouble(OrderStopLoss(), GS_digits);
                  SL_tobeused_inorder = NormalizeDouble(Bid - given_distance_normalized, GS_digits);  // Bid - Distance_input
                  //SL_tobeused_inorder = NormalizeDouble(Bid - SL_points_touse*GS_point, GS_digits);  // Bid - Distance_input
                  ////skcomment printf("*****TotalProfit=",TotalProfit, ", Distance_input=", Distance_input, ", Bid - Distance_input", SL_tobeused_inorder, ", Stoploss=",order_SL_normalized );
                  if ( order_SL_normalized == 0.0 ||  SL_tobeused_inorder < order_SL_normalized )
                  {
                  ////skcomment printf(" no need to modify SL ");
                  break;   // Bid - Distance_input > Stoploss 
                  }
                  if (target_input_points>0 && trail_target_also==True)
                     //TP_tobeused_inorder = NormalizeDouble(Ask +  given_distance_normalized, GS_digits);
                     TP_tobeused_inorder = NormalizeDouble(Ask +  target_input_points * Point, GS_digits);
                   else
                      TP_tobeused_inorder=OrderTakeProfit();
                      
                      //TP_tobeused_inorder=OrderTakeProfit();


                  boolvar_modify_done = OrderModify(current_ticket_number, OrderOpenPrice(), SL_tobeused_inorder, TP_tobeused_inorder, 0, Blue);
                  if(boolvar_modify_done) 
                  {
                  //skcomment printf("++Modify success#"+current_ticket_number+" buy:"+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  //skcomment printf("++#"+current_ticket_number+" given_limit_normalized="+given_limit_normalized+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
                     break;
                  }
                  error_code = GetLastError();
                  error_details = ErrorDescription(error_code);
                  //skcomment printf("--#"+current_ticket_number+" given_limit_normalized="+given_limit_normalized+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
                  //skcomment printf("--BUY Modify Error Code: " + error_code + " Message: " + error_details + " OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  ////skcomment printf("Modify error order#"+ current_ticket_number+" type: "+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  break;
                  
               case OP_SELL:
                  if (Distance_input < 0) break;
                 TotalProfit = (OrderOpenPrice()- Ask)/Point/Dfactor_basedondigits;
                
   	           if (TotalProfit <= 1) {
   	             
          	   	 Distance_input = NoTrade_Profit_Yet_Distance; 
   	             Limit = NoTrade_Profit_Yet_Limit;
   	             StopLoss= NoTrade_Profit_Yet_StopLoss; }      	
          
                  given_distance_normalized = NormalizeDouble(Distance_input * GS_point, GS_digits);
                  given_limit_normalized = NormalizeDouble(Limit * GS_point, GS_digits); 
          	          
                  order_SL_normalized = NormalizeDouble(OrderStopLoss(), GS_digits);
                  
                  SL_tobeused_inorder = NormalizeDouble(Ask + given_distance_normalized, GS_digits);
                  //SL_tobeused_inorder = NormalizeDouble(Ask + SL_points_touse*GS_point, GS_digits);
                  
                  if ( order_SL_normalized == 0.0 || SL_tobeused_inorder > order_SL_normalized ) 
                  {
                  ////skcomment printf(" no need to modify SL ");
                  break;   // Bid - Distance_input > Stoploss 
                  }
                  
                  if (target_input_points>0 && trail_target_also==True )
                     //TP_tobeused_inorder = NormalizeDouble(Bid -  given_distance_normalized, GS_digits);
                     TP_tobeused_inorder = NormalizeDouble(Bid -  target_input_points * Point, GS_digits);
                   else
                      TP_tobeused_inorder=OrderTakeProfit();
                      //TP_tobeused_inorder=OrderTakeProfit();

                  boolvar_modify_done = OrderModify(current_ticket_number, OrderOpenPrice(), SL_tobeused_inorder, TP_tobeused_inorder, 0, Red);
                  if(boolvar_modify_done) 
                  {
                  //skcomment printf("++Modify success#"+current_ticket_number+" sell:"+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  //skcomment printf("++#"+current_ticket_number+" given_limit_normalized="+given_limit_normalized+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
                     break;
                  }
                                    error_code = GetLastError();
                  error_details = ErrorDescription(error_code);
                  //skcomment printf("--#"+current_ticket_number+" given_limit_normalized="+given_limit_normalized+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
                  //skcomment printf("--SELL Modify Error Code: " + error_code + " Message: " + error_details + " OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  ////skcomment printf("Modify error  order#"+ current_ticket_number+" type:: "+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  break;
                  
               case OP_BUYSTOP:
                  
                  if(chase_stop_order==False)
                     break;
                  if(buyorsell==0 && cancel_pending==True ) 
                     {
                     //skcomment printf("check2 : removing the pending order because filter="+highlow_diff);
                     if( remove_pending_order(OrderTicket(),clrNONE)==True )
                     
                        break;
                     }
                     
                  price_tobeused = NormalizeDouble(Ask + given_limit_normalized, GS_digits);  // Ask + Limit
                  current_order_price = NormalizeDouble(OrderOpenPrice(), GS_digits);
                  if ( price_tobeused >= current_order_price ) break;  // If Ask + Limit > Buystop OpenPrice , Go to modify...  
                  
                  if (target_input_points>0)
                     //TP_tobeused_inorder = NormalizeDouble(Ask +  given_distance_normalized, GS_digits);
                     TP_tobeused_inorder = NormalizeDouble(price_tobeused +  target_input_points * Point, GS_digits);
                   else
                      TP_tobeused_inorder=OrderTakeProfit();
                      //TP_tobeused_inorder=OrderTakeProfit();

                  //SL_tobeused_inorder = NormalizeDouble(Bid - SL_points_touse * Point, GS_digits);
                  SL_tobeused_inorder = NormalizeDouble(price_tobeused - SL_points_touse * Point, GS_digits);
                  boolvar_modify_done = OrderModify(current_ticket_number, price_tobeused, SL_tobeused_inorder, TP_tobeused_inorder, 0, clrNONE);
                  if(boolvar_modify_done) 
                  {
                  //skcomment printf("++Modify success#"+current_ticket_number+"buystop:"+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  //skcomment printf("++#"+current_ticket_number+" given_limit_normalized="+given_limit_normalized+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
                     break;
                  }
                  
                  
                  error_code = GetLastError();
                  error_details = ErrorDescription(error_code);
                  //skcomment printf("--#"+current_ticket_number+" given_limit_normalized="+given_limit_normalized+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
                  //skcomment printf("--BUYSTOP Modify Error Code: " + error_code + " Message: " + error_details + " OP: " + DoubleToStr(price_tobeused, GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  ////skcomment printf("Modify error order#"+ current_ticket_number+" type: "+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  break;
               case OP_SELLSTOP:
               
                  if(chase_stop_order==False)
                     break;
                  if(buyorsell==0 && cancel_pending==True) 
                     {
                     //skcomment printf("check1 : removing the pending order because filter="+highlow_diff);
                     if( remove_pending_order(OrderTicket(),Black) )
                        break;
                     }

                  current_order_price = NormalizeDouble(OrderOpenPrice(), GS_digits);
                  price_tobeused = NormalizeDouble(Bid - given_limit_normalized, GS_digits);
                  if (!((price_tobeused <= current_order_price))) break;
                  //SL_tobeused_inorder = NormalizeDouble(Ask + SL_points_touse * Point, GS_digits);
                      SL_tobeused_inorder = NormalizeDouble(price_tobeused +  SL_points_touse  * Point, GS_digits);
                      
                  if (target_input_points>0)
                     //TP_tobeused_inorder = NormalizeDouble(Bid -  given_distance_normalized, GS_digits);
                     TP_tobeused_inorder = NormalizeDouble(price_tobeused -  target_input_points * Point, GS_digits);
                   else
                      TP_tobeused_inorder=OrderTakeProfit();
                      //TP_tobeused_inorder=OrderTakeProfit();

                  boolvar_modify_done = OrderModify(current_ticket_number, price_tobeused, SL_tobeused_inorder, TP_tobeused_inorder, 0, clrNONE);
                  if(boolvar_modify_done) 
                  {
                  //skcomment printf("++Modify success#"+current_ticket_number+" selstop:"+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  //skcomment printf("++#"+current_ticket_number+" given_limit_normalized="+given_limit_normalized+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
                     break;
                  }
                  error_code = GetLastError();
                  error_details = ErrorDescription(error_code);
                  //skcomment printf("--#"+current_ticket_number+" given_limit_normalized="+given_limit_normalized+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
                  //skcomment printf("--SELLSTOP Modify Error Code: " + error_code + " Message: " + error_details + " OP: " + DoubleToStr(price_tobeused, GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  ////skcomment printf("Modify error  order#"+ current_ticket_number+" type: "+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
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
   
   
   // calculate the lots to trade 
      //Ld_196 = AccountBalance() * AccountLeverage() * riskpercent;
      //Ld_196 =  usable_equity   * AccountLeverage() * riskpercent / ( equity_at_start/equity_allocated_touse)  ;
      Ld_196 =  usable_equity   * AccountLeverage() * riskpercent   ;
      if (!UseMM) Ld_196 = FixedLots;
      lot_size_to_trade = NormalizeDouble(Ld_196 / MarketInfo(Symbol(), MODE_LOTSIZE), GS_step_logvalue);
      lot_size_to_trade = MathMax(GS_allowed_minlots_for_symbol, lot_size_to_trade);
      lot_size_to_trade = MathMin(GS_allowed_maxlots_for_symbol, lot_size_to_trade);
      
      last_lots_size=lot_size_to_trade;

   
   // placing the order here . 
   //if (total_orders_open_live <= MaxTrades -1 && buyorsell != 0 /*&& average_spread_withcommision <= max_spreadandcommision*/ && NormalizeDouble(Ask - Bid, GS_digits) < NormalizeDouble(MaxSpread * pp, pd + 1) && workinghours_check_function()) 
   //if((usable_equity - brokerage_current  ) <=0   )  // if current equity with brokerage is low 
   if(  usable_equity   <= ( equity_allocated_touse - acceptable_equity_loss )  )  // if current equity with brokerage is low 
      {
         printf("##Equity from "+equity_allocated_touse+ "*" +investment_counter+"="+total_invested_money+" to " + ( usable_equity +brokerage_current) +"/"+ (usable_equity  )+" brokerage_cr="+brokerage_current );
         if(OrdersTotal()>0)
         {
         printf("## orders = "+OrdersTotal()+" usable_equity="+usable_equity+" <=  ( equity_allocated_touse - acceptable_equity_loss )="+( equity_allocated_touse - acceptable_equity_loss ));
         if(  usable_equity   <= ( equity_allocated_touse - acceptable_equity_loss ) )  
           {
            printf("Closing all orders due to all money lost this time will do reinvestement ");
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
      if(average_spread_withcommision > max_spreadandcommision)
         { 
         printf("conditions are fine but not placing order due to high maxspread commision ="+average_spread_withcommision); 
         return ;
         }
      if(NormalizeDouble(Ask - Bid, GS_digits) > NormalizeDouble(MaxSpread * pp, pd + 1))
         { 
         printf("conditions are fine but not placing order due to high Spread ="+NormalizeDouble(Ask - Bid, GS_digits) ); 
         return ;
         }
      
      //printf("########faCHECK== Traded lots="+ total_traded_lots_tillnow+"/"+lots_in_this_session+ " Brokerage="+brokerage_total +"/"+brokerage_current+" Profit = " + (current_equity-equity_at_start )+"/"+(current_equity-equity_at_start -brokerage_total) + " equity from " +equity_at_start+"/"+total_invested_money+"/"+ equity_allocated_touse +" to "+ current_equity+"/"+(current_equity-brokerage_total) +"/"+ usable_equity + "------#####--- "  );

      if (buyorsell == -1 || buyorsell == 2 ) 
      {
         price_tobeused = NormalizeDouble(Ask + given_limit_normalized, GS_digits);
         //SL_tobeused_inorder = NormalizeDouble(price_tobeused -  3 * StopLoss * Point, GS_digits);
         SL_tobeused_inorder = NormalizeDouble(price_tobeused -  SL_points_touse * Point, GS_digits);
         TP_tobeused_inorder=0;
         if (target_input_points>0)
            TP_tobeused_inorder = NormalizeDouble(price_tobeused +  target_input_points * Point, GS_digits);
         //ticket_20 = OrderSend(Symbol(), OP_BUYSTOP, lot_size_to_trade, price_tobeused, G_slippage_264, SL_tobeused_inorder, 0, TradeComment, MagicNumber, 0, Lime);
         ticket_20 = OrderSend(Symbol(), OP_BUYSTOP, lot_size_to_trade, price_tobeused, G_slippage_264, SL_tobeused_inorder, TP_tobeused_inorder, TradeComment, MagicNumber, 0, clrNONE);
         if (ticket_20 <= 0) {
            error_code = GetLastError();
            error_details = ErrorDescription(error_code);
                  //skcomment printf("###"+ticket_20 + " given_limit_normalized="+given_limit_normalized+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
            //skcomment printf("--BUYSTOP Send Error Code: " + error_code + " Message: " + error_details + " LT: " + DoubleToStr(lot_size_to_trade, GS_step_logvalue) + " OP: " + DoubleToStr(price_tobeused, GS_digits) + " SL:"+DoubleToStr(SL_tobeused_inorder-Bid,GS_digits)+"=" + DoubleToStr(SL_tobeused_inorder, GS_digits)+" TP:" + TP_tobeused_inorder + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
          }
         else 
            {
            //skcomment printf("BUYSTOP Send Success LT: " + DoubleToStr(lot_size_to_trade, GS_step_logvalue) + " OP: " + DoubleToStr(price_tobeused, GS_digits) + " SL:"+DoubleToStr(SL_tobeused_inorder-price_tobeused,GS_digits)+"=" + DoubleToStr(SL_tobeused_inorder, GS_digits)+" TP:" + TP_tobeused_inorder + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
               //skcomment printf("Success : buy order id = "+ticket_20+" price="+price_tobeused+" SL="+SL_tobeused_inorder);
               total_traded_lots_tillnow+=lot_size_to_trade;
               lots_in_this_session+=lot_size_to_trade;
               total_orders_executed++;
               last_order_time=TimeCurrent();
               if(total_orders_executed==1)
               first_order_time=TimeCurrent();


               
               //skcomment printf(message_to_display);
            }
       }  
      if (buyorsell == 1 || buyorsell == 2 ) {
          price_tobeused = NormalizeDouble(Bid - given_limit_normalized, GS_digits);
          //SL_tobeused_inorder = NormalizeDouble(price_tobeused +  3 *StopLoss  * Point, GS_digits);
          SL_tobeused_inorder = NormalizeDouble(price_tobeused +  SL_points_touse  * Point, GS_digits);
        TP_tobeused_inorder=0;
         if (target_input_points>0)
            TP_tobeused_inorder = NormalizeDouble(price_tobeused -  target_input_points * Point, GS_digits);
          //SL_tobeused_inorder = NormalizeDouble(price_tobeused +  StopLoss  * Point, GS_digits);
          //ticket_20 = OrderSend(Symbol(), OP_SELLSTOP, lot_size_to_trade, price_tobeused, G_slippage_264, SL_tobeused_inorder, 0, TradeComment, MagicNumber, 0, Orange);
          ticket_20 = OrderSend(Symbol(), OP_SELLSTOP, lot_size_to_trade, price_tobeused, G_slippage_264, SL_tobeused_inorder, TP_tobeused_inorder, TradeComment, MagicNumber, 0, clrNONE);
          if (ticket_20 <= 0) {
            error_code = GetLastError();
            error_details = ErrorDescription(error_code);
                  //skcomment printf(" #"+ticket_20 + " given_limit_normalized="+given_limit_normalized+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
            //skcomment printf("--SELLSTOP Send Error Code: " + error_code + " Message: " + error_details + " LT: " + DoubleToStr(lot_size_to_trade, GS_step_logvalue) + " OP: " + DoubleToStr(price_tobeused, GS_digits) + " SL: "+DoubleToStr(SL_tobeused_inorder-Ask,GS_digits)+"=" +  DoubleToStr(SL_tobeused_inorder, GS_digits)+" TP:" + TP_tobeused_inorder + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
         }
         else 
            {
            //skcomment printf("++SELLSTOP succes LT: " + DoubleToStr(lot_size_to_trade, GS_step_logvalue) + " OP: " + DoubleToStr(price_tobeused, GS_digits) + " SL: "+DoubleToStr(SL_tobeused_inorder-price_tobeused,GS_digits)+"=" +  DoubleToStr(SL_tobeused_inorder, GS_digits)+" TP:" + TP_tobeused_inorder + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
               //skcomment printf("++Success : sell order id = "+ticket_20+" price="+price_tobeused+" SL="+SL_tobeused_inorder);
               
               total_traded_lots_tillnow+=lot_size_to_trade;
               lots_in_this_session+=lot_size_to_trade;
               total_orders_executed++;
               last_order_time=TimeCurrent();
               if(total_orders_executed==1)
               first_order_time= TimeCurrent() ;


               ////skcomment printf(message_to_display);

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
      printf("##"+(current_equity-equity_at_start -brokerage_total)+"##CHECK #"+OrdersTotal()+" Traded lots="+ int(total_traded_lots_tillnow)+"/"+int(lots_in_this_session)+ " Brkg="+brokerage_total +"/"+brokerage_current+"/"+ " EQT " +equity_at_start+"/"+total_invested_money+"/"+ equity_allocated_touse +" to "+ current_equity+"/"+(current_equity-brokerage_total) +"/"+ usable_equity +"sprd="+(Ask-Bid)+ " Pft##" + (current_equity-equity_at_start-brokerage_total )+ "###--- "  );
      last_msg_value=(current_equity-equity_at_start -brokerage_total);
      }
     
   // Display details on chart 
   min_equity_usable=MathMin(min_equity_usable,( usable_equity) );
   max_equity_usable=MathMax(max_equity_usable,( usable_equity) );
   min_equity=MathMin(min_equity,( current_equity ) );
   max_equity=MathMax(max_equity,( current_equity) );
   min_equity_nobrokerage=MathMin(min_equity_nobrokerage,( current_equity-brokerage_total  ) );
   max_equity_nobrokerage=MathMax(max_equity_nobrokerage,( current_equity-brokerage_total ) );
   
   message_to_display = "\n\n Next Lot=" + DoubleToStr(lot_size_to_trade, GS_step_logvalue)+"/"+MarketInfo(Symbol(), MODE_MAXLOT) + " Time Period="+TimeToStr(first_order_time)+"-"+TimeToStr(last_order_time)+ " point="+GS_point+" digit="+GS_digits
   + "\n Orders#"+OrdersTotal()+"/"+total_orders_executed+" Traded_lots="+ int(total_traded_lots_tillnow)+"/"+int(lots_in_this_session)+ " Brkg="+brokerage_total +"/"+brokerage_current+"/"+ " EQT " +equity_at_start+"/"+total_invested_money+"/"+ equity_allocated_touse +" to "+ current_equity+"/"+(current_equity-brokerage_total) +"/"+ usable_equity +" Sprd="+(Ask-Bid)+ " Pft=" + (current_equity-equity_at_start-brokerage_total ) 
   +  "\n Equity min="+min_equity_nobrokerage+"/"+min_equity +" max_equity="+max_equity_nobrokerage+"/"+max_equity + " Free=" + AccountFreeMargin()

   + "\n Current Spread: " + DoubleToStr(MarketInfo(Symbol(), MODE_SPREAD) / MathPow(10, Digits - pd), Digits - pd) +"/"+DoubleToStr(MaxSpread, Digits - pd)
   + quick_if_function((MarketInfo(Symbol(), MODE_SPREAD) / MathPow(10, Digits - pd))> MaxSpread, "    **BLOCKED HIGH SPREAD  " + DoubleToStr(MaxSpread, Digits -pd )  , quick_if_function(average_spread_withcommision > max_spreadandcommision, "    *******BLOCKED HIGH SPREAD AND COMMISION=" + average_spread_withcommision+"/"+MaxSpreadPlusCommission  ,"|") )
   + "  \n AvgSprd: " + DoubleToStr(average_spread, GS_digits) +" brkg actual:" + DoubleToStr(commision_forpip, GS_digits + 1) + " Real avg spread+comision: " + DoubleToStr(average_spread_withcommision, GS_digits + 1)
   + "  \n Params :Filter="+Filter+" SL="+SL_points_touse+" TP="+ target_input_points+" MaxTrades="+ MaxTrades +" Risk="+ Risk 
   + " MaxSpread="+DoubleToStr(MaxSpread, Digits - pd)+"/"+DoubleToStr(MaxSpreadPlusCommission, Digits - pd)+" HL_df_lvl="+ highlow_diff_level+" Filter="+highlow_diff+"/"+ DoubleToStr(given_filter_normalized, GS_digits ) 
  // + "\n Lots:usable eq="+( usable_equity )  +" * leverage="+ AccountLeverage() +" * riskpercent="+ riskpercent + "="+( usable_equity * AccountLeverage() * riskpercent)
   ;
   
      ////skcomment printf("Params :Filter="+Filter+" SL="+SL_points_touse+" TP="+target_input_points +" MaxTrades="+ MaxTrades +" Risk="+ Risk );

   /*
   if (average_spread_withcommision > max_spreadandcommision) {
      message_to_display = message_to_display 
         + "\n\n" 
         + "  **BLOCKED HIGH SPREAD AND COMMISION ( " + DoubleToStr(average_spread_withcommision, GS_digits + 1) + " > " + DoubleToStr(max_spreadandcommision, GS_digits + 1) + " )";
   }

*/
   Comment(message_to_display);
   //Comment("this is me sk ");
   //if(OrdersTotal()>0)
      ////skcomment printf("Price="+Ask+message_to_display ) ;
   
   string message_to_send="Equity from "+ equity_allocated_touse+" to " + usable_equity +"  - brokerage = " + (usable_equity-brokerage_current  ) + " min="+min_equity+"/"+min_equity_nobrokerage  +" max_equity="+max_equity+"/"+max_equity_nobrokerage
                  +" Orders="+ OrdersTotal() +"/"+ OrdersHistoryTotal()
                  +" "+TimeLocal() ;

   
   old_msg_sent_time=send_telegram_msg(message_to_send,"registered","hourly",old_msg_sent_time,send_telgram_message_flag);

   
   RapidTrailingStop();
   TimedClosing();
   
}


int close_all_orders()
   {
   
   printf("Going to Close all orders now ");
   int total = OrdersTotal();
   int returnvalue=1;
      for (int i = total - 1; i >= 0; i--) 
      {
          if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE) 
          { 
            if ( OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber ) 
            {
                  RefreshRates();
                  if(OrderType() == OP_SELL || OrderType() == OP_BUY )
                     if( !OrderClose(OrderTicket(), OrderLots(), Bid, G_slippage_264 , Blue))
                     {
                        if(!OrderClose(OrderTicket(), OrderLots(), Ask, G_slippage_264 , Blue))
                     	   printf("There was an error closing buy/sell order#"+OrderTicket()+". Error is:" + GetLastError() );
                       returnvalue=0;
                     }
                  if(OrderType() == OP_SELLSTOP || OrderType() == OP_BUYSTOP )
                     if( !remove_pending_order(OrderTicket(),clrNONE) )
                     {
                        if( !remove_pending_order(OrderTicket(),clrNONE) )
                     	   printf("There was an error closing pending order#"+OrderTicket()+". Error is:" + GetLastError() );
                       returnvalue=0;
                     }

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
            //skcomment printf("closing the op_Buy order#"+ OrderTicket()+" due to time limit of  "+Minutes_Buy + " Minutes ");
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
            //skcomment printf("closing the op_sell order#"+ OrderTicket()+" due to time limit of  "+Minutes_Buy + " Minutes ");
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
            //skcomment printf("closing the Pending order#"+ OrderTicket()+" due to time limit of  "+Minutes_Buy + " Minutes ");
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
            else l_point_36 = MarketInfo(OrderSymbol(), MODE_POINT);
         }
         ld_52 = Start_Trailing_At * l_point_36;   /// 20 PIPS 
         order_SL_normalized = TrailingStep * l_point_36;        /// 5 PIPS

         ld_68 = Set_BreakEvenAt * l_point_36;
         ld_60 = LockPips * l_point_36;
         
         
         if (OrderType() == OP_BUY && (OrderMagicNumber() == MagicNumber)) {
            if (Use_TrailingStep && Bid - OrderOpenPrice() >= ld_52) {
             
               if (Bid - OrderStopLoss() >= ld_52 + order_SL_normalized) {
                  result = OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss() + order_SL_normalized, OrderTakeProfit(), 0, DodgerBlue);
                  if ( GetLastError()!=0) 
                     printf(Symbol()+ ": Trail BUY OrderModify PROBLEM ! " );   
               }
            }

            if (Use_Set_BreakEven && Bid - OrderOpenPrice() >= ld_68) {
               if (OrderStopLoss() < OrderOpenPrice()) {
                  result= OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice() + ld_60, OrderTakeProfit(),0, DodgerBlue);
                  if ( GetLastError()!=0) 
                     printf(Symbol()+ ": BreakEven BUY OrderModify PROBLEM ! " );   

               }
            }
            
            
         } else {
            if (OrderType() == OP_SELL && (OrderMagicNumber() == MagicNumber)) {
               if (Use_TrailingStep && OrderOpenPrice() - Ask >= ld_52) {
                 
                  if (OrderStopLoss() - Ask >= ld_52 + order_SL_normalized) {
                 
                   result= OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss() - order_SL_normalized, OrderTakeProfit(),0, Yellow);
                   if (GetLastError()!=0) 
                      printf(Symbol()+ ": Trail SELL OrderModify PROBLEM ! " );
                  }
               }
              
               if (Use_Set_BreakEven && OrderOpenPrice() - Ask >= ld_68) {
                  if (OrderStopLoss() > OrderOpenPrice()) {
                     result= OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice() - ld_60, OrderTakeProfit(),0, Yellow);
                    if ( GetLastError()!=0) 
                      printf(Symbol()+ ": BreakEven SELL OrderModify PROBLEM ! " );   

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

         string mytocken="1978145861:AAHRAD0hYnwjI3uP4nQx_jopMwkweSwqdx4";
         string chat_id="602973674";
         string message="SKR:"+message1+"END"+msg_last_sent;
         string base_url="https://api.telegram.org";
         string url=base_url+"/bot"+mytocken+"/sendMessage?chat_id="+chat_id+"&text="+message;
         string cookie=NULL,headers;
         char post[],result[];
         
         //skcomment printf ( " url = "+ url ) ;
         ResetLastError();
         int timeout=2000;
         int result1,returnvalue=0;

                if(skcurrent!=msg_last_sent && skcurrent!=0 )   // msg_last_sent is global variable 
                    {
                    msg_last_sent=skcurrent;
                    result1=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
                    }
    

   //skcomment printf("skcurrent="+skcurrent +" result1="+result1);
         if(result1==-1)
            {
               returnvalue=-1;
               int errorcode=GetLastError();
               string errordescription=ErrorDescription(errorcode);
               //skcomment printf("Error in sending telegram msg code="+errorcode + " | "+errordescription ); 
               if(errorcode==4060)
                {
                  //skcomment printf("ERROR : EXITING : Add URL https://api.telegram.org in mt4 settings(tools -> options -> Expert -> Add the urls ) ");
                  
                }
                  
            }
            else
                {
                    returnvalue=msg_last_sent;
                    //skdebug("Status update msg sent "+message,dbgcheck2);
                }
        return(returnvalue);
               
      }


void OnChartEvent( const int id,const long &lparam,const double &dparam,const string &sparam )
  {
            string skbutton_name="bar_height";
           
            ObjectSetText(skbutton_name,skbutton_name+highlow_diff);
            //highlow_diff = High_array - Low_array;

            //string_height=""+
  
 
  }


int deinit()
   {
   /*
   printf("##"+(current_equity-equity_at_start -brokerage_total)+"##CHECK #"+OrdersTotal()+" Traded lots="+ int(total_traded_lots_tillnow)+"/"+int(lots_in_this_session)+ " Brkg="+brokerage_total +"/"+brokerage_current+"/"+ " EQT " +equity_at_start+"/"+total_invested_money+"/"+ equity_allocated_touse +" to "+ current_equity+"/"+(current_equity-brokerage_total) +"/"+ usable_equity +"sprd="+(Ask-Bid)+ " Pft=" + (current_equity-equity_at_start-brokerage_total )+ "###--- "  );
   printf("##Equity from "+equity_allocated_touse+ "*" +investment_counter+"="+total_invested_money+" to " + ( usable_equity +brokerage_current) +"/"+ (usable_equity  )+" brokerage_cr="+brokerage_current );
   printf("##Profit = " + (current_equity- equity_at_start  ) + " after brokerage = " + (current_equity- equity_at_start - brokerage_total) );
   printf("##total_lots_traded="+total_traded_lots_tillnow +  " Orders="+ OrdersTotal() +"/"+ OrdersHistoryTotal() + " Brokerage = " + brokerage_total) ;
   printf("##Params :Filter="+Filter+" SL="+SL_points_touse+" TP="+target_input_points +" MaxTrades="+ MaxTrades +" Risk="+ Risk );
   printf("##SL_points_touse="+SL_points_touse+" allowed_SL_size="+GS_allowed_SL_size_for_symbol+" StopLoss="+StopLoss + " Real avg.spread:" + DoubleToStr(Ask-Bid, GS_digits + 1) +" maxlotsize="+( MarketInfo(Symbol(), MODE_MAXLOT) )+" Next Lot=" + DoubleToStr(last_lots_size, GS_step_logvalue) );
   printf("##Account level Equity from "+equity_at_start+" to "+current_equity+"/"+(current_equity-brokerage_total)+ " Profit="+ (current_equity-equity_at_start-brokerage_total) + " min="+min_equity +" max_equity="+max_equity  ) ;
   printf("highlow_diff="+(highlow_diff/ GS_point )+" given_filter_normalized="+ (given_filter_normalized/ GS_point )+" highlow_diff_level="+highlow_diff_level ) ;
   
   */
   printf("######################## END #####################");
   printf(message_to_display);
   printf("\n#Filter="+Filter+" Pft=" + (current_equity-equity_at_start-brokerage_total )+" "+TimeToStr(first_order_time)+"-"+TimeToStr(last_order_time)+" Traded lots="+ int(total_traded_lots_tillnow)+"/"+int(lots_in_this_session)+ " Brkg="+brokerage_total +"/"+brokerage_current+"/"+ " EQT " +equity_at_start+"/"+total_invested_money+"/"+ equity_allocated_touse +" to "+ current_equity+"/"+(current_equity-brokerage_total) +"/"+ usable_equity +"sprd="+(Ask-Bid)+ " Pft=" + (current_equity-equity_at_start-brokerage_total )+ "###--- "  );
   printf("######################## END #####################");
   return(1);
   }
   
   
   
   /* 
   
   //// RESULTS 
   
2022.02.12 19:19:12.220	2022.02.11 23:59:55  sk5_12feb22 BTCUSD,M1: ##highlow_diff=31.81 given_filter_normalized=270
2022.02.12 19:19:12.220	2022.02.11 23:59:55  sk5_12feb22 BTCUSD,M1: ##Account level Equity from 1000 to 1523/1075 Profit=75 min=998 max_equity=1546
2022.02.12 19:19:12.220	2022.02.11 23:59:55  sk5_12feb22 BTCUSD,M1: ##SL_points_touse=3448 allowed_SL_size=960 StopLoss=3448 Real avg.spread:17.240 maxlotsize=20 Next Lot=0.27
2022.02.12 19:19:12.220	2022.02.11 23:59:55  sk5_12feb22 BTCUSD,M1: ##Params :Filter=27000 SL=3448 TP=0 MaxTrades=10 Risk=0.1
2022.02.12 19:19:12.220	2022.02.11 23:59:55  sk5_12feb22 BTCUSD,M1: ##total_lots_traded=64 Orders=0/1398 Brokerage = 448
2022.02.12 19:19:12.220	2022.02.11 23:59:55  sk5_12feb22 BTCUSD,M1: ##Profit = 523 after brokerage = 75
2022.02.12 19:19:12.220	2022.02.11 23:59:55  sk5_12feb22 BTCUSD,M1: ##Equity from 20*3=60 to 208/135 brokerage_cr=73
2022.02.12 19:19:12.220	2022.02.11 23:59:55  sk5_12feb22 BTCUSD,M1: ##75##CHECK #0 Traded lots=64/10 Brkg=448/73/ EQT 1000/60/20 to 1523/1075/135sprd=17.24 Pft=75###--- 

2022.02.12 19:26:31.890	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Account level Equity from 1000 to 636926/309986 Profit=308986 min=994 max_equity=645076
2022.02.12 19:26:31.890	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##SL_points_touse=3302 allowed_SL_size=960 StopLoss=3302 Real avg.spread:16.510 maxlotsize=20 Next Lot=20.00
2022.02.12 19:26:31.890	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Params :Filter=27000 SL=3302 TP=0 MaxTrades=10 Risk=0.1
2022.02.12 19:26:31.890	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##total_lots_traded=46705.82 Orders=0/3192 Brokerage = 326940
2022.02.12 19:26:31.890	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Profit = 635926 after brokerage = 308986
2022.02.12 19:26:31.890	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Equity from 20*1=20 to 635946/309006 brokerage_cr=326940
2022.02.12 19:26:31.890	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##308986##CHECK #0 Traded lots=46705/46705 Brkg=326940/326940/ EQT 1000/20/20 to 636926/309986/309006sprd=16.51 Pft=308986###--- 

2022.02.12 22:03:04.992	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Account level Equity from 1000 to 673941/336769 Profit=335769 min=974 max_equity=682036
2022.02.12 22:03:04.992	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##SL_points_touse=3286 allowed_SL_size=960 StopLoss=3286 Real avg.spread:16.430 maxlotsize=20 Next Lot=20.00
2022.02.12 22:03:04.992	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Params :Filter=27000 SL=3286 TP=0 MaxTrades=10 Risk=0.1
2022.02.12 22:03:04.992	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##total_lots_traded=48167.5 Orders=0/3192 Brokerage = 337172
2022.02.12 22:03:04.992	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Profit = 672941 after brokerage = 335769
2022.02.12 22:03:04.992	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Equity from 100*1=100 to 673041/335869 brokerage_cr=337172
2022.02.12 22:03:04.992	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##335769##CHECK #0 Traded lots=48167/48167 Brkg=337172/337172/ EQT 1000/100/100 to 673941/336769/335869sprd=16.43 Pft=335769###--- 
   
2022.02.13 23:17:39.425	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Account level Equity from 1000 to 641638/315323 Profit=314323 min=967 max_equity=650271
2022.02.13 23:17:39.425	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##SL_points_touse=3444 allowed_SL_size=960 StopLoss=3444 Real avg.spread:17.220 maxlotsize=20 Next Lot=20.00
2022.02.13 23:17:39.425	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Params :Filter=27000 SL=3444 TP=3444 MaxTrades=10 Risk=0.1
2022.02.13 23:17:39.425	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##total_lots_traded=46616.44 Orders=0/3186 Brokerage = 326315
2022.02.13 23:17:39.425	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Profit = 640638 after brokerage = 314323
2022.02.13 23:17:39.425	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Equity from 100*1=100 to 640738/314423 brokerage_cr=326315
2022.02.13 23:17:39.425	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##314323##CHECK #0 Traded lots=46616/46616 Brkg=326315/326315/ EQT 1000/100/100 to 641638/315323/314423sprd=17.22 Pft=314323###--- 

2022.02.13 23:22:17.054	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Account level Equity from 1000 to 735590/386704 Profit=385704 min=988 max_equity=742804
2022.02.13 23:22:17.054	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##SL_points_touse=2960 allowed_SL_size=960 StopLoss=2960 Real avg.spread:14.800 maxlotsize=20 Next Lot=20.00
2022.02.13 23:22:17.054	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Params :Filter=27000 SL=2960 TP=2960 MaxTrades=10 Risk=0.1
2022.02.13 23:22:17.054	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##total_lots_traded=49840.88 Orders=0/3264 Brokerage = 348886
2022.02.13 23:22:17.054	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Profit = 734590 after brokerage = 385704
2022.02.13 23:22:17.054	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Equity from 100*1=100 to 734690/385804 brokerage_cr=348886
2022.02.13 23:22:17.054	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##385704##CHECK #0 Traded lots=49840/49840 Brkg=348886/348886/ EQT 1000/100/100 to 735590/386704/385804sprd=14.8 Pft=385704###--- 

   
2022.02.12 22:10:05.161	2022.02.11 23:59:55  sk5_12feb22 BTCUSD,M1: ##Account level Equity from 1000 to 655278/226173 Profit=225173 min=959 max_equity=657747
2022.02.12 22:10:05.161	2022.02.11 23:59:55  sk5_12feb22 BTCUSD,M1: ##SL_points_touse=3852 allowed_SL_size=960 StopLoss=3852 Real avg.spread:19.260 maxlotsize=20 Next Lot=20.00
2022.02.12 22:10:05.161	2022.02.11 23:59:55  sk5_12feb22 BTCUSD,M1: ##Params :Filter=27000 SL=3852 TP=0 MaxTrades=10 Risk=0.1
2022.02.12 22:10:05.161	2022.02.11 23:59:55  sk5_12feb22 BTCUSD,M1: ##total_lots_traded=61300.78 Orders=0/4098 Brokerage = 429105
2022.02.12 22:10:05.161	2022.02.11 23:59:55  sk5_12feb22 BTCUSD,M1: ##Profit = 654278 after brokerage = 225173
2022.02.12 22:10:05.161	2022.02.11 23:59:55  sk5_12feb22 BTCUSD,M1: ##Equity from 100*1=100 to 654378/225273 brokerage_cr=429105
2022.02.12 22:10:05.161	2022.02.11 23:59:55  sk5_12feb22 BTCUSD,M1: ##225173##CHECK #0 Traded lots=61300/61300 Brkg=429105/429105/ EQT 1000/100/100 to 655278/226173/225273sprd=19.26 Pft=225173###--- 

2022.02.14 16:49:01.089	2021.12.30 23:59:55  sk5_12feb22 BTCUSD,M1: highlow_diff=3842 given_filter_normalized=26000 highlow_diff_level=1
2022.02.14 16:49:01.089	2021.12.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Account level Equity from 1000 to 581547/310970 Profit=309970 min=981 max_equity=583888
2022.02.14 16:49:01.089	2021.12.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##SL_points_touse=3902 allowed_SL_size=960 StopLoss=3902 Real avg.spread:19.510 maxlotsize=20 Next Lot=20.00
2022.02.14 16:49:01.089	2021.12.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Params :Filter=26000 SL=3902 TP=3902 MaxTrades=10 Risk=0.1
2022.02.14 16:49:01.089	2021.12.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##total_lots_traded=38653.96 Orders=0/2310 Brokerage = 270577
2022.02.14 16:49:01.089	2021.12.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Profit = 580547 after brokerage = 309970
2022.02.14 16:49:01.089	2021.12.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Equity from 100*1=100 to 580647/310070 brokerage_cr=270577
2022.02.14 16:49:01.089	2021.12.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##309970##CHECK #0 Traded lots=38653/38653 Brkg=270577/270577/ EQT 1000/100/100 to 581547/310970/310070sprd=19.51 Pft=309970###--- 

2022.02.14 17:02:56.378	2022.02.13 23:59:55  sk5_12feb22 BTCUSD,M1: highlow_diff=4484 given_filter_normalized=26000 highlow_diff_level=1
2022.02.14 17:02:56.378	2022.02.13 23:59:55  sk5_12feb22 BTCUSD,M1: ##Account level Equity from 1000 to 2925/1663 Profit=663 min=989 max_equity=3019
2022.02.14 17:02:56.378	2022.02.13 23:59:55  sk5_12feb22 BTCUSD,M1: ##SL_points_touse=3298 allowed_SL_size=960 StopLoss=3298 Real avg.spread:16.490 maxlotsize=20 Next Lot=1.53
2022.02.14 17:02:56.378	2022.02.13 23:59:55  sk5_12feb22 BTCUSD,M1: ##Params :Filter=26000 SL=3298 TP=3297 MaxTrades=10 Risk=0.1
2022.02.14 17:02:56.378	2022.02.13 23:59:55  sk5_12feb22 BTCUSD,M1: ##total_lots_traded=180.4 Orders=0/350 Brokerage = 1262
2022.02.14 17:02:56.378	2022.02.13 23:59:55  sk5_12feb22 BTCUSD,M1: ##Profit = 1925 after brokerage = 663
2022.02.14 17:02:56.378	2022.02.13 23:59:55  sk5_12feb22 BTCUSD,M1: ##Equity from 100*1=100 to 2025/763 brokerage_cr=1262
2022.02.14 17:02:56.378	2022.02.13 23:59:55  sk5_12feb22 BTCUSD,M1: ##663##CHECK #0 Traded lots=180/180 Brkg=1262/1262/ EQT 1000/100/100 to 2925/1663/763sprd=16.49 Pft=663###--- 

2022.02.14 17:06:02.111	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: highlow_diff=5170 given_filter_normalized=26000 highlow_diff_level=1
2022.02.14 17:06:02.111	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Account level Equity from 1000 to 288640/150325 Profit=149325 min=975 max_equity=293064
2022.02.14 17:06:02.111	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##SL_points_touse=4424 allowed_SL_size=960 StopLoss=4424 Real avg.spread:22.120 maxlotsize=20 Next Lot=20.00
2022.02.14 17:06:02.111	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Params :Filter=26000 SL=4424 TP=4424 MaxTrades=10 Risk=0.1
2022.02.14 17:06:02.111	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##total_lots_traded=19759.32 Orders=0/1544 Brokerage = 138315
2022.02.14 17:06:02.111	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Profit = 287640 after brokerage = 149325
2022.02.14 17:06:02.111	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Equity from 100*2=200 to 287551/149525 brokerage_cr=138026
2022.02.14 17:06:02.111	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##149325##CHECK #0 Traded lots=19759/19718 Brkg=138315/138026/ EQT 1000/200/100 to 288640/150325/149525sprd=22.12 Pft=149325###--- 

2022.02.14 17:37:12.611	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1:  Next Lot=20.00/20 Time Period=1641014680-1643489155
 Orders#0 Traded_lots=22198/22172 Brkg=155392/155204/ EQT 1000/200/100 to 341858/186466/185666 Sprd=16.92 Pft=185466 
 Equity min=100/979 max_equity=190807/345919 Free=341858.23  

 Current Spread:   1692  ,  MaxSpread:  3000  
 AvgSpread:      16.92  
 Commission rate:0.000  
 Real avg.spread:16.920  
 Params :Filter=26000 SL=3384 TP=3383 MaxTrades=10 Risk=0.1 point=0.01 digit=2
 highlow_diff_level=1 given_fi

2022.02.14 17:49:06.366	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: Next Lot=20.00/20 Time Period=2022.01.01 05:24-2022.01.29 20:45
 Orders#0 Traded_lots=23246/23246 Brkg=162723/162723/ EQT 1000/100/100 to 359360/196637/195737 Sprd=15.18 Pft=195637 
 Equity min=100/990 max_equity=201798/363003 Free=359360.75  

 Current Spread:   1518  ,  MaxSpread:  3000  
 AvgSpread:      15.18  
 Commission rate:0.000  
 Real avg.spread:15.180  
 Params :Filter=26000 SL=3036 TP=3036 MaxTrades=10 Risk=0.1 point=0.01 digit=2
 highlow_diff_lev

2022.02.14 17:51:08.093	2022.02.13 23:59:55  sk5_12feb22 BTCUSD,M1:  Next Lot=2.71/20 Time Period=2022.02.01 09:04-2022.02.11 22:26
 Orders#0/348 Traded_lots=291/291 Brkg=2041/2041/ EQT 1000/100/100 to 4298/2257/1357 Sprd=16.63 Pft=1257 
 Equity min=100/988 max_equity=2704/4476 Free=4298.43  

 Current Spread:   1663  ,  MaxSpread:  3000  
 AvgSpread:      16.63  
 Commission rate:0.000  
 Real avg.spread:16.630  
 Params :Filter=26000 SL=3326 TP=3325 MaxTrades=10 Risk=0.1 point=0.01 digit=2  highlow_diff_level=1 given_filter_n

 2022.02.14 18:03:15.228	2022.02.13 23:59:55  sk5_12feb22 BTCUSD,M1: ######################## END #####################
 Next Lot=1.36/20 Time Period=2022.02.01 09:04-2022.02.11 22:26 point=0.01 digit=2
 Orders#0/342 Traded_lots=218/218 Brkg=1527/1527/ EQT 1000/100/100 to 3107/1580/680 Sprd=17.91 Pft=580 
 Equity min=100/988 max_equity=1902/3278 Free=3107.29  
 Current Spread:   1791  ,  MaxSpread:  3000   AvgSprd: 17.91 brkg actual:0.000 Real avg spread+comision: 17.910  
 Params :Filter=26000 SL=3582 TP=3582 MaxTrades=10 Risk=0.1 HL_df_lvl=1 Filter=44.84/260.00
2022.02.14 18:03:15.228	2022.02.13 23:59:55  sk5_12feb22 BTCUSD,M1: ######################## END #####################
2022.02.14 18:24:17.071	2022.02.13 23:59:55  sk5_12feb22 BTCUSD,M1: ######################## END #####################
2022.02.14 18:24:17.071	2022.02.13 23:59:55  sk5_12feb22 BTCUSD,M1: 

 Next Lot=0.33/20 Time Period=2022.02.01 09:04-2022.02.11 22:26 point=0.01 digit=2
 Orders#0/388 Traded_lots=51/51 Brkg=359/359/ EQT 1000/100/100 to 1586/1227/327 Sprd=13.25 Pft=227
 Equity min=100/992 max_equity=1246/1594 Free=1586.3
 Current Spread: 1325/3000|  
 AvgSprd: 13.25 brkg actual:0.000 Real avg spread+comision: 13.250  
 Params :Filter=26000 SL=2650 TP=2650 MaxTrades=10 Risk=0.05 MaxSpread=3000/4000 HL_df_lvl=1 Filter=44.84/260.00
2022.02.14 18:24:17.071	2022.02.13 23:59:55  sk5_12feb22 BTCUSD,M1: ######################## END #####################

2022.02.14 22:27:05.604	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ######################## END #####################
2022.02.14 22:27:05.604	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ##Account level Equity from 1000 to 574661/275856 Profit=274856 min=958 max_equity=579469
2022.02.14 22:27:05.604	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: 

 Next Lot=20.00/20 Time Period=2022.01.01 05:23-2022.01.29 21:04 point=0.01 digit=2
 Orders#0/3176 Traded_lots=42686/42674 Brkg=298805/298720/ EQT 1000/200/100 to 574661/275856/275056 Sprd=14.51 Pft=274856
 Equity min=100/958 max_equity=285531/579469 Free=574661.09
 Current Spread: 1451/3000|  
 AvgSprd: 14.51 brkg actual:0.000 Real avg spread+comision: 14.510  
 Params :Filter=21000 SL=2902 TP=2902 MaxTrades=10 Risk=0.1 MaxSpread=3000/4000 HL_df_lvl=1 Filter=5
2022.02.14 22:27:05.604	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ######################## END #####################

2022.02.14 23:03:44.149	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ######################## END #####################
 #Filter=19000 Traded lots=82232/82232 Brkg=575629/575629/ EQT 1000/100/100 to 1018640/443011/442111sprd=7.27 Pft=442011###--- 
 
 2022.02.14 23:22:30.146	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ######################## END #####################
2022.02.14 23:22:30.146	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: 
#Filter=19000 2022.01.01 05:23-2022.01.30 00:40 Traded lots=55616/55616 Brkg=389313/389313/ EQT 1000/100/100 to 693529/304216/303316sprd=13.41 Pft=303216###--- 

2022.02.14 23:26:38.985	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ######################## END #####################
2022.02.14 23:26:38.985	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: 
#Filter=19000 2022.01.01 05:23-2022.01.30 00:40 Traded lots=44182/44176 Brkg=309276/309235/ EQT 1000/200/100 to 432678/123402/122602sprd=17.85 Pft=122402###--- 


2022.02.14 23:08:44.465	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ######################## END #####################
 #Filter=17000 2022.01.01 05:22-2022.01.30 23:22 Traded lots=105175/105175 Brkg=736225/736225/ EQT 1000/100/100 to 1024111/287886/286986sprd=7.17 Pft=286886###--- 

2022.02.14 23:12:38.126	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ######################## END #####################
   #Filter=18000 2022.01.01 05:22-2022.01.30 00:40 Traded lots=74277/74277 Brkg=519943/519943/ EQT 1000/100/100 to 864735/344792/343892sprd=10.57 Pft=343792###--- 


2022.02.14 23:17:34.658	2022.01.30 23:59:55  sk5_12feb22 BTCUSD,M1: ######################## END #####################
 #Filter=20000 2022.01.01 05:23-2022.01.30 00:40 Traded lots=52593/52569 Brkg=368152/367985/ EQT 1000/200/100 to 603179/235027/234227sprd=10.16 Pft=234027###--- 

   
 */