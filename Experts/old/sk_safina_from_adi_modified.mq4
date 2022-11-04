#property copyright "SKRAJ"
#import "stdlib.ex4"
string ErrorDescription(int a0); 
#import


// ================== variables 

input bool bothside=True;

extern int Filter = 140;
extern int Filter_EU = 130; //org 140
extern int Filter_GU = 170;
extern int Filter_UJ = 190;

extern int MagicNumber = 150115;
extern string TradeComment = "Shafina";
extern int MaxTrades = 20;
extern double Risk = 50;  // org 60

extern double StopLoss = 5;  //this is for our BUY/SELL STOP SL 2.3 pips modify, can not put 200 pips, will lose !!!

extern double NoTrade_Profit_Yet_StopLoss = 30;  //30 pips
extern double InTrade_Profit_StopLoss = 60;       //2.3 pips

extern double Distance_input = 30; // not used !!!
extern double NoTrade_Profit_Yet_Distance = 20;
extern double InTrade_Profit_Distance = 30;

extern double Limit = 23.0;    // 20 will cause order130 error
extern double NoTrade_Profit_Yet_Limit = 22;  // can not play with this , 20 should be ok!!!
extern double InTrade_Profit_Limit = 25;

extern bool Use_TrailingStep = TRUE;
extern double Start_Trailing_At = 2.9;  // org 2.9 meaning keep bid/ask Distance_input by x PIPS
extern double TrailingStep = 0.3;        // org 0.3

extern bool Use_Set_BreakEven = TRUE;
extern double LockPips =  0.3;           // org 0.3
extern double Set_BreakEvenAt = 2.3;   // org 2.3

extern double MinLots = 0.01;
extern double MaxLots = 100000000.0;//100000.0;
extern double FixedLots = 0.01;//0.1;
extern bool UseMM = TRUE;
 
extern double MaxSpreadPlusCommission = 6.3 ;//6.3 ok !
extern double MaxSpreadPlusCommission_EU = 10.3;//0.6 ok !
extern double MaxSpreadPlusCommission_GU = 10.0;//1.0 ok !
extern double MaxSpreadPlusCommission_UJ = 10.0;//0.6 ok !

extern double MaxSpread = 6.3  ;//6.3 ok !
extern double MaxSpread_EU = 0.6;//0.6 ok !
extern double MaxSpread_GU = 1.0;//1.0 ok !
extern double MaxSpread_UJ = 0.6;//0.6 ok !

extern int MAPeriod = 15;
extern int MAMethod = 1;

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

//------ variables ----------- 



int Env_low_band_price = PRICE_HIGH;
int Env_high_band_price = PRICE_LOW;

bool Timed_Closing = TRUE;  
int Minutes_Buy =  40; //Minute
int Minutes_Sell = 40; 
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
string sybol_name;

// E37F0136AA3FFAF149B351F6A4C948E9
int init() 
    {
        //int timeframe_8;
        ArrayInitialize(array_of_spreads, 0);
        GS_digits = Digits;
        GS_point = Point;
        Print("System_Digits: " + GS_digits + " Point: " + DoubleToStr(GS_point, GS_digits));
        double GS_allowed_lotstep_size_for_sybol = MarketInfo(Symbol(), MODE_LOTSTEP);
        GS_step_logvalue = MathLog(GS_allowed_lotstep_size_for_sybol) / MathLog(0.1);
        GS_allowed_minlots_for_symbol = MathMax(MinLots, MarketInfo(Symbol(), MODE_MINLOT));
        GS_allowed_maxlots_for_symbol = MathMin(MaxLots, MarketInfo(Symbol(), MODE_MAXLOT));
        sybol_name = StringSubstr (Symbol(),0,6);
            
        if (sybol_name == "EURUSD") {MaxSpread  = MaxSpread_EU; Filter = Filter_EU;}
        if (sybol_name == "GBPUSD") {MaxSpread  = MaxSpread_GU; Filter = Filter_GU;}
        if (sybol_name == "USDJPY") {MaxSpread  = MaxSpread_UJ; Filter = Filter_UJ;}

        riskpercent = Risk / 100.0;
        max_spreadandcommision = NormalizeDouble(MaxSpreadPlusCommission * GS_point, GS_digits + 1);
        given_limit_normalized = NormalizeDouble(Limit * GS_point, GS_digits);
        given_distance_normalized = NormalizeDouble(Distance_input * GS_point, GS_digits);
        given_filter_normalized = NormalizeDouble(Filter * GS_point , GS_digits);
        boolvar_to_run_once = FALSE;
        commision_forpip = NormalizeDouble(pips_input * GS_point, GS_digits + 1); 

        Dfactor_basedondigits = 1;
        
            if(GS_digits == 3|| GS_digits == 5) Dfactor_basedondigits = 10;        
        
        return (0);
    }
	 	  	 			  	   	  	  	 				    	  	 					    	  	   	   	 	 	   	 	 		  		 					 			 		  	   				 		 		  	      			   			 	 	 	 					  	 			  	 
// 52D46093050F38C27267BCE42543EF60
    int deinit() 
        {
            return (0);
        }
	 	 			  	    		   		  	 				 		   			   	  	  			  						 							 			 				  	    		    	 	 	    	 	    	 	 	 							 	  	 				 				 			  		  	 	
// EA2B2676C28C0DB26D39331A336C6B92
int start() {

    // defind variables 
    int error_8;
    string Ls_12;
    int ticket_20;
    double price_24;
    bool bool_32;
    double Ld_36;
    double Ld_44;
    double price_60;
    double factor_commision;
    int buyorsell;
    int sk_high_movement;
    int open_order_type;
    double Ld_196;
    double Ld_204;
    double High_array = iHigh(NULL, 0, 0);
    double Low_array = iLow(NULL, 0, 0);

    double indicator_low;
    double indicator_high;
    double indicator_highlow_diff;
	
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
   double highlow_diff = High_array - Low_array;
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
   
   int total_orders_open_live = 0;
   for (order_position_for_selecting = 0; order_position_for_selecting < OrdersTotal(); order_position_for_selecting++) 
   {
      if (OrderSelect(order_position_for_selecting, SELECT_BY_POS, MODE_TRADES)) 
      {
         if (OrderMagicNumber() == MagicNumber) 
         {
            open_order_type = OrderType();
            if (open_order_type == OP_BUYLIMIT || open_order_type == OP_SELLLIMIT) continue; //skip this !
         
            double TotalProfit = 0.0; 
            if (OrderSymbol() == Symbol()) {
               total_orders_open_live++;
               switch (open_order_type) {
               case OP_BUY:
                  if (Distance_input < 0) break;
                  
                 TotalProfit = (Bid - OrderOpenPrice()) /Point/Dfactor_basedondigits;
                
   	           if (TotalProfit <=1) {
          	   	  Distance_input = NoTrade_Profit_Yet_Distance; 
   	              Limit = NoTrade_Profit_Yet_Limit;
   	              StopLoss= NoTrade_Profit_Yet_StopLoss; }      	

                  given_distance_normalized = NormalizeDouble(Distance_input * GS_point, GS_digits);
                  given_limit_normalized = NormalizeDouble(Limit * GS_point, GS_digits); 
          	
                  Ld_44 = NormalizeDouble(OrderStopLoss(), GS_digits);
                  price_60 = NormalizeDouble(Bid - given_distance_normalized, GS_digits);  // Bid - Distance_input
                  
                  Print("*****TotalProfit=",TotalProfit, ", Distance_input=", Distance_input, ", Bid - Distance_input", price_60, ", Stoploss=",Ld_44 );
                  
                  if (!((Ld_44 == 0.0 || price_60 > Ld_44))) break;   // Bid - Distance_input > Stoploss 
                  bool_32 = OrderModify(OrderTicket(), OrderOpenPrice(), price_60, OrderTakeProfit(), 0, Blue);
                  if (!(!bool_32)) break;
                  error_8 = GetLastError();
                  Ls_12 = ErrorDescription(error_8);
                  Print("BUY Modify Error Code: " + error_8 + " Message: " + Ls_12 + " OP: " + DoubleToStr(price_24, GS_digits) + " SL: " + DoubleToStr(price_60, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  
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
          	          
                  Ld_44 = NormalizeDouble(OrderStopLoss(), GS_digits);
                  price_60 = NormalizeDouble(Ask + given_distance_normalized, GS_digits);
                  if (!((Ld_44 == 0.0 || price_60 < Ld_44))) break;
                  bool_32 = OrderModify(OrderTicket(), OrderOpenPrice(), price_60, OrderTakeProfit(), 0, Red);
                  if (!(!bool_32)) break;
                  error_8 = GetLastError();
                  Ls_12 = ErrorDescription(error_8);
                  Print("SELL Modify Error Code: " + error_8 + " Message: " + Ls_12 + " OP: " + DoubleToStr(price_24, GS_digits) + " SL: " + DoubleToStr(price_60, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  
                  break;
                  
               case OP_BUYSTOP:
                  price_24 = NormalizeDouble(Ask + given_limit_normalized, GS_digits);  // Ask + Limit
                  Ld_36 = NormalizeDouble(OrderOpenPrice(), GS_digits);
                  if (!((price_24 < Ld_36))) break;  // If Ask + Limit > Buystop OpenPrice , Go to modify...  
                  price_60 = NormalizeDouble(price_24 - StopLoss * Point, GS_digits);
                  bool_32 = OrderModify(OrderTicket(), price_24, price_60, OrderTakeProfit(), 0, Lime);
                  if (!(!bool_32)) break;
                  error_8 = GetLastError();
                  Ls_12 = ErrorDescription(error_8);
                  Print("BUYSTOP Modify Error Code: " + error_8 + " Message: " + Ls_12 + " OP: " + DoubleToStr(price_24, GS_digits) + " SL: " + DoubleToStr(price_60, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
                  break;
               case OP_SELLSTOP:
                  Ld_36 = NormalizeDouble(OrderOpenPrice(), GS_digits);
                  price_24 = NormalizeDouble(Bid - given_limit_normalized, GS_digits);
                  if (!((price_24 > Ld_36))) break;
                  price_60 = NormalizeDouble(price_24 + StopLoss * Point, GS_digits);
                  bool_32 = OrderModify(OrderTicket(), price_24, price_60, OrderTakeProfit(), 0, Orange);
                  if (!(!bool_32)) break;
                  error_8 = GetLastError();
                  Ls_12 = ErrorDescription(error_8);
                  Print("SELLSTOP Modify Error Code: " + error_8 + " Message: " + Ls_12 + " OP: " + DoubleToStr(price_24, GS_digits) + " SL: " + DoubleToStr(price_60, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
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
   
      Ld_196 = AccountBalance() * AccountLeverage() * riskpercent;
      if (!UseMM) Ld_196 = FixedLots;
      Ld_204 = NormalizeDouble(Ld_196 / MarketInfo(Symbol(), MODE_LOTSIZE), GS_step_logvalue);
      Ld_204 = MathMax(GS_allowed_minlots_for_symbol, Ld_204);
      Ld_204 = MathMin(GS_allowed_maxlots_for_symbol, Ld_204);
   
   // placing the order here . 
   if (total_orders_open_live <= MaxTrades -1 && buyorsell != 0 /*&& average_spread_withcommision <= max_spreadandcommision*/ && NormalizeDouble(Ask - Bid, GS_digits) < NormalizeDouble(MaxSpread * pp, pd + 1) && f0_4()) 
   {  // New BUY STOP & SELL STOP Orders placed here..
      printf("order type ( 1 for sell , -1 for buy , 2 for both )= "+buyorsell) ;
      if (buyorsell == -1 || buyorsell == 2 ) 
      {
         price_24 = NormalizeDouble(Ask + given_limit_normalized, GS_digits);
         //price_60 = NormalizeDouble(price_24 -  3 * StopLoss * Point, GS_digits);
         price_60 = NormalizeDouble(Bid -   StopLoss * Point, GS_digits);
         ticket_20 = OrderSend(Symbol(), OP_BUYSTOP, Ld_204, price_24, G_slippage_264, price_60, 0, TradeComment, MagicNumber, 0, Lime);
         if (ticket_20 <= 0) {
            error_8 = GetLastError();
            Ls_12 = ErrorDescription(error_8);
            Print("BUYSTOP Send Error Code: " + error_8 + " Message: " + Ls_12 + " LT: " + DoubleToStr(Ld_204, GS_step_logvalue) + " OP: " + DoubleToStr(price_24, GS_digits) + " SL: " + DoubleToStr(price_60, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
          }
         else 
            printf("sell order id = "+ticket_20+" price="+price_24+" SL="+price_60);

       }  
      if (buyorsell == 1 || buyorsell == 2 ) {
          price_24 = NormalizeDouble(Bid - given_limit_normalized, GS_digits);
          //price_60 = NormalizeDouble(price_24 +  3 *StopLoss  * Point, GS_digits);
          price_60 = NormalizeDouble(Ask +  StopLoss  * Point, GS_digits);
          //price_60 = NormalizeDouble(price_24 +  StopLoss  * Point, GS_digits);
          ticket_20 = OrderSend(Symbol(), OP_SELLSTOP, Ld_204, price_24, G_slippage_264, price_60, 0, TradeComment, MagicNumber, 0, Orange);
          if (ticket_20 <= 0) {
            error_8 = GetLastError();
            Ls_12 = ErrorDescription(error_8);
            Print("SELLSTOP Send Error Code: " + error_8 + " Message: " + Ls_12 + " LT: " + DoubleToStr(Ld_204, GS_step_logvalue) + " OP: " + DoubleToStr(price_24, GS_digits) + " SL: " +  DoubleToStr(price_60, GS_digits) + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
         }
         else 
            printf("sell order id = "+ticket_20+" price="+price_24+" SL="+price_60);
      }
   }
   string Ls_212 
   = "  \n\n Next Lot:     " + DoubleToStr(Ld_204, GS_digits) + " Equity=" + AccountEquity() +  " Orders="+ OrdersTotal() +"/"+ OrdersHistoryTotal()
   + "  \n\n Current Spread:   " + DoubleToStr(MarketInfo(Symbol(), MODE_SPREAD) / MathPow(10, GS_digits - pd), GS_digits - pd) 
   + IIFs((MarketInfo(Symbol(), MODE_SPREAD) / MathPow(10, GS_digits - pd))> MaxSpread, "    ***Exceeding MaxSpread at:  " + DoubleToStr(MaxSpread, GS_digits -pd ),"  ,  MaxSpread:  "+DoubleToStr(MaxSpread, GS_digits - pd))
   + "  \n AvgSpread:      " + DoubleToStr(average_spread, GS_digits) 
   + "  \n Commission rate:" + DoubleToStr(commision_forpip, GS_digits + 1) 
   + "  \n Real avg.spread:" + DoubleToStr(average_spread_withcommision, GS_digits + 1);

   
   
   if (average_spread_withcommision > max_spreadandcommision) {
      Ls_212 = Ls_212 
         + "\n\n" 
         + "  **The EA can not run with this spread ( " + DoubleToStr(average_spread_withcommision, GS_digits + 1) + " > " + DoubleToStr(max_spreadandcommision, GS_digits + 1) + " )";
   }

   Comment(Ls_212);
   
   TimedClosing();
   RapidTrailingStop();
   
   return (0);
}

void TimedClosing() {

  if (!Timed_Closing) return;  
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

   int total = OrdersTotal();
   for (int i = total - 1; i >= 0; i--) {
      
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE) { 
      if (OrderType() == OP_BUY && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber ) {
         if (TimeCurrent() - OrderOpenTime() >= 60 * ExpirationBuyTime && Bid >= OrderOpenPrice() + MinBuyProfit * Point) {
            RefreshRates();
            TicketClose = OrderClose(OrderTicket(), OrderLots(), Bid, G_slippage_264 , Blue);
            if (!TicketClose) {
            	Print("There was an error closing the trade. Error is:", GetLastError());
              return;
             }
           }
         }
       }
         
      if (OrderType() == OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (TimeCurrent() - OrderOpenTime() >= 60 * ExpirationSellTime && Ask <= OrderOpenPrice() - MinSellProfit * Point) {
            RefreshRates();
            TicketClose = OrderClose(OrderTicket(), OrderLots(), Ask, G_slippage_264, Red);
            //---
            if (!TicketClose) {
              Print("There was an error closing the trade. Error is:", GetLastError());
              return;
             }
          }
        }
      }
  }
      
			 	   	    	 			 						 				 			 		 	 	   				    	  	   		  	   		 		  	   	 				 		  		 			 	  	 		  		 		 	  				  	  		     		   					 	   
// 3B8B9927CE5F3E077818404E64D1C252
int f0_4() {
   if ((Hour() > StartHour && Hour() < EndHour) || (Hour() == StartHour && Minute() >= StartMinute) || (Hour() == EndHour && Minute() < EndMinute)) return (1);
   return (0);
}
	  				  			  		  	 	  	 	  	 		  	 		   				  												 							 		 			 	 	          	  		    		     	  		 				  	 	  		 			 		   			      	 	 	 	 	  	   			   			 	 							   		    	  		 			  	 				 		 				 		  				       		 	  	 	 		   	 	 	  	 	 											  	 		 	 				  		  		 		 		 			       		 	 		  	  			 		 	 			      	  		   					  						  			 		 	  	   			    			 	      	    			 	 			 			 	    				 	 		 			 			  	 			  	  	   	  			 	  			 		   			 	 		 	     		     	 	   	 	 	   	 			  	 			 					 	  		   	 	  		 	  		    	  		    	  	 	    				 						    		  	 	  		    	  	 		 	 		    		   	 		  			 							  						  		 					 	    	     	 			    	      	 			 					 	 	  	  			 			  			  	   	 		 			   		 	 	 		   							 		 		   	 	 		 					 	 		  	 	  	  	 	  	 		 			  	 	 	  		   					 		   		   				 	 		 		  		  	    		    		 	  	  	 	 			  	    		   		  	 				 		   			   	  	  			  						 							 			 				  	    		    	 	 	    	 	    	 	 	 							 	  	 				 				 			  		  	
string IIFs(bool condition, string ifTrue, string ifFalse) {
 
  if (condition) return(ifTrue); else return(ifFalse);
}

void RapidTrailingStop() {

   double l_point_36;
   double ld_44;
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
         ld_44 = TrailingStep * l_point_36;        /// 5 PIPS

         ld_68 = Set_BreakEvenAt * l_point_36;
         ld_60 = LockPips * l_point_36;
         
         
         if (OrderType() == OP_BUY && (OrderMagicNumber() == MagicNumber)) {
            if (Use_TrailingStep && Bid - OrderOpenPrice() >= ld_52) {
             
               if (Bid - OrderStopLoss() >= ld_52 + ld_44) {
                  result = OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss() + ld_44, OrderTakeProfit(), 0, DodgerBlue);
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
                 
                  if (OrderStopLoss() - Ask >= ld_52 + ld_44) {
                 
                   result= OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss() - ld_44, OrderTakeProfit(),0, Yellow);
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
