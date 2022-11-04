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
extern int brokerage_perlot=10;
extern int equity_allocated_touse_input=100;
extern int acceptable_equity_loss=0;
extern int MaxTrades = 10;
extern double Risk = 1;  // org 60

extern double MinLots = 0.01;
extern double MaxLots = 199.0;//100000.0;
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
extern int Filter = 30100;
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

bool Timed_Closing = TRUE;  
extern int Minutes_limit_for_order=3;



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
         
        ArrayInitialize(array_of_spreads, 0);
        GS_digits = Digits;
        GS_point = Point;
        Print("System_Digits: " + GS_digits + " Point: " + DoubleToStr(GS_point, GS_digits));
        double current_oGS_allowed_lotstep_size_for_symbolrder_price = MarketInfo(Symbol(), MODE_LOTSTEP);
        GS_allowed_SL_size_for_symbol = MarketInfo(Symbol(),MODE_STOPLEVEL)*1.2;
        GS_step_logvalue = MathLog(current_oGS_allowed_lotstep_size_for_symbolrder_price) / MathLog(0.1);
        GS_allowed_minlots_for_symbol = MathMax(MinLots, MarketInfo(Symbol(), MODE_MINLOT));
        GS_allowed_maxlots_for_symbol = MathMin(MaxLots, MarketInfo(Symbol(), MODE_MAXLOT));
        symbol_name = StringSubstr (Symbol(),0,6);
        SL_points_touse=MathMax(GS_allowed_SL_size_for_symbol,StopLoss) ; 
        
        if (symbol_name == "EURUSD" || symbol_name == "EURUSDc" ) 
        {
        MaxSpread  = MaxSpread_EU; Filter = Filter_EU;
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


        riskpercent = Risk / 100.0;
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
      // will work on current selected order 
      double lots_in_this_order=OrderLots();
      if( OrderDelete(ticket_number,clrWhite) )
         {
            
            total_traded_lots_tillnow-=lots_in_this_order;
            return(True);
         }
        else
        {
        printf("Failed to close order #"+ticket_number);
         return(False);
        }

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
      printf("making a reinvestment of "+equity_allocated_touse_input + " inventment_count="+investment_counter);
     return(0);
   }

	 	  	 			  	   	  	  	 				    	  	 					    	  	   	   	 	 	   	 	 		  		 					 			 		  	   				 		 		  	      			   			 	 	 	 					  	 			  	 
void OnTick() {

   if(stopworkingflag)
      return;

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

 // check if high movement is there 
 double High_array = iHigh(NULL, 0, 0);
 double Low_array = iLow(NULL, 0, 0);
 double High_array_last = iHigh(NULL,0,1);
 double Low_array_last = iLow(NULL, 0, 1);

   double highlow_diff_last2 = (MathMax(High_array_last, High_array) - MathMin(Low_array, Low_array_last) );
   double highlow_diff_last = High_array_last - Low_array_last;
   double highlow_diff_current = High_array - Low_array;
   highlow_diff=highlow_diff_last2;
   buyorsell=0;
   sk_high_movement=0;
   if (highlow_diff > given_filter_normalized) 
   {
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
               //printf("SK check order#"+ current_ticket_number + " type="+OrderType() +" CRP="+OrderProfit()+" current SL=" +OrderStopLoss()+ " OP_BUY="+ OP_BUY+" OP_SELL="+ OP_SELL+" OP_BUYSTOP"+ OP_BUYSTOP + " OP_SELLSTOP" + OP_SELLSTOP+ " OP_BUYLIMIT="+OP_BUYLIMIT+" OP_SELLLIMIT="+OP_SELLLIMIT   );
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
                  //Print("*****TotalProfit=",TotalProfit, ", Distance_input=", Distance_input, ", Bid - Distance_input", SL_tobeused_inorder, ", Stoploss=",order_SL_normalized );
                  if ( order_SL_normalized == 0.0 ||  SL_tobeused_inorder < order_SL_normalized )
                  {
                  //printf(" no need to modify SL ");
                  break;   // Bid - Distance_input > Stoploss 
                  }
                  if (target_input_points>0)
                     TP_tobeused_inorder = NormalizeDouble(Ask +  given_distance_normalized, GS_digits);
                     //TP_tobeused_inorder = NormalizeDouble(Ask +  target_input_points * Point, GS_digits);
                   else
                      TP_tobeused_inorder=OrderTakeProfit();
                      
                      //TP_tobeused_inorder=OrderTakeProfit();


                  boolvar_modify_done = OrderModify(current_ticket_number, OrderOpenPrice(), SL_tobeused_inorder, TP_tobeused_inorder, 0, Blue);
                  if(boolvar_modify_done) 
                  {
                  Print("++Modify success#"+current_ticket_number+" buy:"+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  printf("++#"+current_ticket_number+" given_limit_normalized="+given_limit_normalized+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
                     break;
                  }
                  error_code = GetLastError();
                  error_details = ErrorDescription(error_code);
                  printf("--#"+current_ticket_number+" given_limit_normalized="+given_limit_normalized+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
                  Print("--BUY Modify Error Code: " + error_code + " Message: " + error_details + " OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  //Print("Modify error order#"+ current_ticket_number+" type: "+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
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
                  //printf(" no need to modify SL ");
                  break;   // Bid - Distance_input > Stoploss 
                  }
                  
                  if (target_input_points>0)
                     TP_tobeused_inorder = NormalizeDouble(Bid -  given_distance_normalized, GS_digits);
                     //TP_tobeused_inorder = NormalizeDouble(Bid -  target_input_points * Point, GS_digits);
                   else
                      TP_tobeused_inorder=OrderTakeProfit();
                      //TP_tobeused_inorder=OrderTakeProfit();

                  boolvar_modify_done = OrderModify(current_ticket_number, OrderOpenPrice(), SL_tobeused_inorder, TP_tobeused_inorder, 0, Red);
                  if(boolvar_modify_done) 
                  {
                  Print("++Modify success#"+current_ticket_number+" sell:"+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  printf("++#"+current_ticket_number+" given_limit_normalized="+given_limit_normalized+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
                     break;
                  }
                                    error_code = GetLastError();
                  error_details = ErrorDescription(error_code);
                  printf("--#"+current_ticket_number+" given_limit_normalized="+given_limit_normalized+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
                  Print("--SELL Modify Error Code: " + error_code + " Message: " + error_details + " OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  //Print("Modify error  order#"+ current_ticket_number+" type:: "+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  break;
                  
               case OP_BUYSTOP:
               
                  if(buyorsell==0 && cancel_pending==True ) 
                     {
                     printf("check2 : removing the pending order because filter="+highlow_diff);
                     if( remove_pending_order(OrderTicket(),clrNONE) )
                     
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
                  Print("++Modify success#"+current_ticket_number+"buystop:"+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  printf("++#"+current_ticket_number+" given_limit_normalized="+given_limit_normalized+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
                     break;
                  }
                  
                  
                  error_code = GetLastError();
                  error_details = ErrorDescription(error_code);
                  printf("--#"+current_ticket_number+" given_limit_normalized="+given_limit_normalized+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
                  Print("--BUYSTOP Modify Error Code: " + error_code + " Message: " + error_details + " OP: " + DoubleToStr(price_tobeused, GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  //Print("Modify error order#"+ current_ticket_number+" type: "+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  break;
               case OP_SELLSTOP:
               
                  if(buyorsell==0 && cancel_pending==True) 
                     {
                     printf("check1 : removing the pending order because filter="+highlow_diff);
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
                  Print("++Modify success#"+current_ticket_number+" selstop:"+open_order_type+" OP: " + DoubleToStr(OrderOpenPrice(), GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  printf("++#"+current_ticket_number+" given_limit_normalized="+given_limit_normalized+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
                     break;
                  }
                  error_code = GetLastError();
                  error_details = ErrorDescription(error_code);
                  printf("--#"+current_ticket_number+" given_limit_normalized="+given_limit_normalized+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
                  Print("--SELLSTOP Modify Error Code: " + error_code + " Message: " + error_details + " OP: " + DoubleToStr(price_tobeused, GS_digits) + " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
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
   
   
   // calculate the lots to trade 
      //Ld_196 = AccountBalance() * AccountLeverage() * riskpercent;
      //Ld_196 =  usable_equity   * AccountLeverage() * riskpercent / ( equity_at_start/equity_allocated_touse)  ;
      Ld_196 =  usable_equity   * AccountLeverage() * riskpercent /MaxTrades/100  ;
      if (!UseMM) Ld_196 = FixedLots;
      lot_size_to_trade = NormalizeDouble(Ld_196 / MarketInfo(Symbol(), MODE_LOTSIZE), GS_step_logvalue);
      lot_size_to_trade = MathMax(GS_allowed_minlots_for_symbol, lot_size_to_trade);
      lot_size_to_trade = MathMin(GS_allowed_maxlots_for_symbol, lot_size_to_trade);
      
      last_lots_size=lot_size_to_trade;

   
   // placing the order here . 
   //if (total_orders_open_live <= MaxTrades -1 && buyorsell != 0 /*&& average_spread_withcommision <= max_spreadandcommision*/ && NormalizeDouble(Ask - Bid, GS_digits) < NormalizeDouble(MaxSpread * pp, pd + 1) && workinghours_check_function()) 
   //if((usable_equity - brokerage_current  ) <=0   )  // if current equity with brokerage is low 
   if((usable_equity  ) <=10   )  // if current equity with brokerage is low 
      {
         printf("##Equity from "+equity_allocated_touse+ "*" +investment_counter+"="+total_invested_money+" to " + usable_equity +"- brokerage("+brokerage_current+")=" + (usable_equity-brokerage_current  ) + " min="+min_equity_usable+"/"+min_equity_nobrokerage  +" max_equity="+max_equity_usable+"/"+max_equity_nobrokerage);
         if(OrdersTotal()>0)
         {
         printf("##acceptable_equity_loss="+acceptable_equity_loss+" ( usable_equity - equity_allocated_touse )="+( usable_equity - equity_allocated_touse ));
         if(( usable_equity  ) <= 10 && MathAbs( usable_equity  ) >  acceptable_equity_loss  )  
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
      }
   if (total_orders_open_live <= MaxTrades -1 && buyorsell != 0 && average_spread_withcommision <= max_spreadandcommision && NormalizeDouble(Ask - Bid, GS_digits) < NormalizeDouble(MaxSpread * pp, pd + 1) && workinghours_check_function()) 
   {  // New BUY STOP & SELL STOP Orders placed here..
      //printf("order type ( 1 for sell , -1 for buy , 2 for both )= "+buyorsell) ;
      //printf(message_to_display);
       
      
      printf("######## CHECK #########---- Traded lots="+ total_traded_lots_tillnow+ " Brokerage="+brokerage_total +" Profit = " + (current_equity-equity_at_start ) + " equity from " +equity_at_start +" to "+ (current_equity-brokerage_total) + "------#####--- "  );

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
                  printf("###"+ticket_20 + " given_limit_normalized="+given_limit_normalized+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
            printf("--BUYSTOP Send Error Code: " + error_code + " Message: " + error_details + " LT: " + DoubleToStr(lot_size_to_trade, GS_step_logvalue) + " OP: " + DoubleToStr(price_tobeused, GS_digits) + " SL:"+DoubleToStr(SL_tobeused_inorder-Bid,GS_digits)+"=" + DoubleToStr(SL_tobeused_inorder, GS_digits)+" TP:" + TP_tobeused_inorder + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
          }
         else 
            {
            printf("BUYSTOP Send Success LT: " + DoubleToStr(lot_size_to_trade, GS_step_logvalue) + " OP: " + DoubleToStr(price_tobeused, GS_digits) + " SL:"+DoubleToStr(SL_tobeused_inorder-price_tobeused,GS_digits)+"=" + DoubleToStr(SL_tobeused_inorder, GS_digits)+" TP:" + TP_tobeused_inorder + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
               printf("Success : buy order id = "+ticket_20+" price="+price_tobeused+" SL="+SL_tobeused_inorder);
               total_traded_lots_tillnow+=lot_size_to_trade;
               lots_in_this_session+=lot_size_to_trade;
               printf(message_to_display);
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
                  printf(" #"+ticket_20 + " given_limit_normalized="+given_limit_normalized+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
            printf("--SELLSTOP Send Error Code: " + error_code + " Message: " + error_details + " LT: " + DoubleToStr(lot_size_to_trade, GS_step_logvalue) + " OP: " + DoubleToStr(price_tobeused, GS_digits) + " SL: "+DoubleToStr(SL_tobeused_inorder-Ask,GS_digits)+"=" +  DoubleToStr(SL_tobeused_inorder, GS_digits)+" TP:" + TP_tobeused_inorder + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
         }
         else 
            {
            printf("++SELLSTOP succes LT: " + DoubleToStr(lot_size_to_trade, GS_step_logvalue) + " OP: " + DoubleToStr(price_tobeused, GS_digits) + " SL: "+DoubleToStr(SL_tobeused_inorder-price_tobeused,GS_digits)+"=" +  DoubleToStr(SL_tobeused_inorder, GS_digits)+" TP:" + TP_tobeused_inorder + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
               printf("++Success : sell order id = "+ticket_20+" price="+price_tobeused+" SL="+SL_tobeused_inorder);
               
               total_traded_lots_tillnow+=lot_size_to_trade;
               lots_in_this_session+=lot_size_to_trade;
               //printf(message_to_display);

            }
      }
   }
  
  
     
   // Display details on chart 
   min_equity_usable=MathMin(min_equity_usable,( usable_equity) );
   max_equity_usable=MathMax(max_equity_usable,( usable_equity) );
   min_equity=MathMin(min_equity,( current_equity ) );
   max_equity=MathMax(max_equity,( current_equity) );
   min_equity_nobrokerage=MathMin(min_equity_nobrokerage,( usable_equity +brokerage_total ) );
   max_equity_nobrokerage=MathMax(max_equity_nobrokerage,( usable_equity +brokerage_total) );
   
   message_to_display = "\n\n Next Lot=" + DoubleToStr(lot_size_to_trade, GS_step_logvalue)+" maxlotsize="+MarketInfo(Symbol(), MODE_MAXLOT)+" Equity from "+equity_allocated_touse+ "*" +investment_counter+"="+total_invested_money+" to " + usable_equity +"  - brokerage = " + (usable_equity  ) + " min="+min_equity_usable+"/"+min_equity_nobrokerage  +" max_equity="+max_equity_usable+"/"+max_equity_nobrokerage
   +" \n Profit = " + (usable_equity- total_invested_money ) + " after brokerage = " + (usable_equity- total_invested_money )
   +  "\n total_lots_traded="+total_traded_lots_tillnow +  " Orders="+ OrdersTotal() +"/"+ OrdersHistoryTotal() + " Brokerage = " + brokerage_current +"/"+brokerage_total
   +  "\n Account level Equity from "+equity_at_start+" to "+(current_equity )+ " Profit="+ (current_equity-equity_at_start) + " min="+min_equity +" max_equity="+max_equity + " Free=" + AccountFreeMargin()
   
   + "  \n\n Current Spread:   " + DoubleToStr(MarketInfo(Symbol(), MODE_SPREAD) / MathPow(10, Digits - pd), Digits - pd) 
   + quick_if_function((MarketInfo(Symbol(), MODE_SPREAD) / MathPow(10, Digits - pd))> MaxSpread, "    ***Exceeding MaxSpread at:  " + DoubleToStr(MaxSpread, Digits -pd ),"  ,  MaxSpread:  "+DoubleToStr(MaxSpread, Digits - pd))
   + "  \n AvgSpread:      " + DoubleToStr(average_spread, GS_digits) 
   + "  \n Commission rate:" + DoubleToStr(commision_forpip, GS_digits + 1) 
   + "  \n Real avg.spread:" + DoubleToStr(average_spread_withcommision, GS_digits + 1)
   + "  \n Params :Filter="+Filter+" SL="+SL_points_touse+" TP="+ target_input_points+" MaxTrades="+ MaxTrades +" Risk="+ Risk + " point="+GS_point+" digit="+GS_digits
   + "\n highlow_diff_current="+ DoubleToStr(highlow_diff_current, GS_digits )+" last="+highlow_diff_last+" forlast2="+highlow_diff_last2+" given_filter_normalized="+ DoubleToStr(given_filter_normalized, GS_digits ) 
   + "\n Lots:usable eq="+( usable_equity )  +" * leverage="+ AccountLeverage() +" * riskpercent="+ riskpercent + "="+( usable_equity * AccountLeverage() * riskpercent)
   ;
   
   
      //printf("Params :Filter="+Filter+" SL="+SL_points_touse+" TP="+target_input_points +" MaxTrades="+ MaxTrades +" Risk="+ Risk );

   
   if (average_spread_withcommision > max_spreadandcommision) {
      message_to_display = message_to_display 
         + "\n\n" 
         + "  **The EA can not run with this spread ( " + DoubleToStr(average_spread_withcommision, GS_digits + 1) + " > " + DoubleToStr(max_spreadandcommision, GS_digits + 1) + " )";
   }

   Comment(message_to_display);
   //Comment("this is me sk ");
   //if(OrdersTotal()>0)
      //printf("Price="+Ask+message_to_display ) ;
   
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
                       //return;
                     }
                  if(OrderType() == OP_SELLSTOP || OrderType() == OP_BUYSTOP )
                     if( !remove_pending_order(OrderTicket(),clrNONE) )
                     {
                        if( !remove_pending_order(OrderTicket(),clrNONE) )
                     	   printf("There was an error closing pending order#"+OrderTicket()+". Error is:" + GetLastError() );
                       //return;
                     }

            }
         }
      }
    return(0);
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
            printf("closing the op_Buy order#"+ OrderTicket()+" due to time limit of  "+Minutes_Buy + " Minutes ");
            TicketClose = OrderClose(OrderTicket(), OrderLots(), Bid, G_slippage_264 , Blue);
            if (!TicketClose) 
             {
            	Print("There was an error closing the order#"+OrderTicket()+". Error is:", GetLastError());
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
            printf("closing the op_sell order#"+ OrderTicket()+" due to time limit of  "+Minutes_Buy + " Minutes ");
            TicketClose = OrderClose(OrderTicket(), OrderLots(), Ask, G_slippage_264, Red);
            //---
            if (!TicketClose) {
              Print("There was an error closing the order#"+OrderTicket()+". Error is:", GetLastError());
              return;
             }
          }
        }
        
         
      if ( ( OrderType() == OP_SELLSTOP || OrderType() == OP_BUYSTOP) && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) 
      {
         if (TimeCurrent() - OrderOpenTime() >= 60 * ExpirationSellTime ) 
         {
            //RefreshRates();
            printf("closing the Pending order#"+ OrderTicket()+" due to time limit of  "+Minutes_Buy + " Minutes ");
            TicketClose = OrderDelete(OrderTicket(),clrNONE);
            //---
            if (!TicketClose) {
              Print("There was an error closing the order#"+OrderTicket()+". Error is:", GetLastError());
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
                  if ( GetLastError()!=0) Print(Symbol()+ ": Trail BUY OrderModify PROBLEM ! " );   
               }
            }

            if (Use_Set_BreakEven && Bid - OrderOpenPrice() >= ld_68) {
               if (OrderStopLoss() < OrderOpenPrice()) {
                  result= OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice() + ld_60, OrderTakeProfit(),0, DodgerBlue);
                  if ( GetLastError()!=0) Print(Symbol()+ ": BreakEven BUY OrderModify PROBLEM ! " );   

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

         string mytocken="1978145861:AAHRAD0hYnwjI3uP4nQx_jopMwkweSwqdx4";
         string chat_id="602973674";
         string message="SKR:"+message1+"END"+msg_last_sent;
         string base_url="https://api.telegram.org";
         string url=base_url+"/bot"+mytocken+"/sendMessage?chat_id="+chat_id+"&text="+message;
         string cookie=NULL,headers;
         char post[],result[];
         
         printf ( " url = "+ url ) ;
         ResetLastError();
         int timeout=2000;
         int result1,returnvalue=0;

                if(skcurrent!=msg_last_sent && skcurrent!=0 )   // msg_last_sent is global variable 
                    {
                    msg_last_sent=skcurrent;
                    result1=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
                    }
    

   printf("skcurrent="+skcurrent +" result1="+result1);
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


void OnChartEvent( const int id,const long &lparam,const double &dparam,const string &sparam )
  {
            string skbutton_name="bar_height";
           
            ObjectSetText(skbutton_name,skbutton_name+highlow_diff);
            //highlow_diff = High_array - Low_array;

            //string_height=""+
  
 
  }


int deinit()
   {
   
   printf("##Equity from "+equity_allocated_touse+ "*" +investment_counter+"="+total_invested_money+" to " + (usable_equity +brokerage_total ) +" - brokerage=" + (usable_equity  ) + " min="+min_equity_usable+"/"+min_equity_nobrokerage  +" max_equity="+max_equity_usable+"/"+max_equity_nobrokerage);
   printf("##Profit = " + (usable_equity- total_invested_money +brokerage_total ) + " after brokerage = " + (usable_equity- total_invested_money  ) );
   printf("##total_lots_traded="+total_traded_lots_tillnow +  " Orders="+ OrdersTotal() +"/"+ OrdersHistoryTotal() + " Brokerage = " + brokerage_total) ;
   printf("##Params :Filter="+Filter+" SL="+SL_points_touse+" TP="+target_input_points +" MaxTrades="+ MaxTrades +" Risk="+ Risk );
   printf("##SL_points_touse="+SL_points_touse+" allowed_SL_size="+GS_allowed_SL_size_for_symbol+" StopLoss="+StopLoss + " Real avg.spread:" + DoubleToStr(Ask-Bid, GS_digits + 1) +" maxlotsize="+( MarketInfo(Symbol(), MODE_MAXLOT) )+" Next Lot=" + DoubleToStr(last_lots_size, GS_step_logvalue) );
   printf("##Account level Equity from "+equity_at_start+" to "+current_equity+"/"+(current_equity-brokerage_total)+ " Profit="+ (current_equity-equity_at_start-brokerage_total) + " min="+min_equity +" max_equity="+max_equity  ) ;
   printf("##highlow_diff="+highlow_diff+" given_filter_normalized="+given_filter_normalized );
   
   return(1);
   }