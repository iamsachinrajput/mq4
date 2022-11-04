#property copyright "SKRAJ"
#import "stdlib.ex4"
string ErrorDescription(int a0); 
#import



// ================== variables 
input string yourtelegramchannel="thisisforsachin"; 
input string yourlicensekey="thisisforsachin";
input datetime licesevaliddate;
input bool send_telgram_message_flag=True;
int old_msg_sent_time=0;

extern int MaxTrades = 20;
extern double Risk = 5;  // org 60
input int brokerage_perlot=5;

  double total_traded_lots_tillnow=0;
input int opening_balance=1000;
  int min_equity=opening_balance;
  int max_equity=0;
  int min_equity_nobrokerage=opening_balance;
  int max_equity_nobrokerage=0;
extern  bool bothside=True;

extern double StopLoss = 0;  //this is for our BUY/SELL STOP SL 2.3 pips modify, can not put 200 pips, will lose !!!
extern int target_input_points=100 ; 

extern int Filter = 140;
extern int Filter_EU = 130; //org 140
extern int Filter_GU = 170;
extern int Filter_UJ = 190;

extern int MagicNumber = 678234;
extern string TradeComment = "SKRAJ";


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
extern double MaxLots = 200.0;//100000.0;
extern double FixedLots = 0.01;//0.1;
extern bool UseMM = TRUE;
 
extern double MaxSpreadPlusCommission = 16.3 ;//6.3 ok !
extern double MaxSpreadPlusCommission_EU = 16.3;//0.6 ok !
extern double MaxSpreadPlusCommission_GU = 16.0;//1.0 ok !
extern double MaxSpreadPlusCommission_UJ = 16.0;//0.6 ok !

extern double MaxSpread = 12.3  ;//6.3 ok !
extern double MaxSpread_EU = 12.6;//0.6 ok !
extern double MaxSpread_GU = 12.0;//1.0 ok !
extern double MaxSpread_UJ = 20.6;//0.6 ok !

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
string symbol_name;
double SL_points_touse;
double TP_tobeused_inorder;
string message_to_display="msg";

// E37F0136AA3FFAF149B351F6A4C948E9
int init() 
    {
        //int timeframe_8;

        ArrayInitialize(array_of_spreads, 0);
        GS_digits = Digits;
        GS_point = Point;
        Print("System_Digits: " + GS_digits + " Point: " + DoubleToStr(GS_point, GS_digits));
        double current_oGS_allowed_lotstep_size_for_symbolrder_price = MarketInfo(Symbol(), MODE_LOTSTEP);
        double GS_allowed_SL_size_for_symbol = MarketInfo(Symbol(),MODE_STOPLEVEL)*1.2;
        SL_points_touse=MathMax(GS_allowed_SL_size_for_symbol,StopLoss) ; 
        printf("SL_points_touse="+SL_points_touse+" allowed_SL_size="+GS_allowed_SL_size_for_symbol+" StopLoss="+StopLoss);
        GS_step_logvalue = MathLog(current_oGS_allowed_lotstep_size_for_symbolrder_price) / MathLog(0.1);
        GS_allowed_minlots_for_symbol = MathMax(MinLots, MarketInfo(Symbol(), MODE_MINLOT));
        GS_allowed_maxlots_for_symbol = MathMin(MaxLots, MarketInfo(Symbol(), MODE_MAXLOT));
        symbol_name = StringSubstr (Symbol(),0,6);
            
        if (symbol_name == "EURUSD" || symbol_name == "EURUSDc" ) {MaxSpread  = MaxSpread_EU; Filter = Filter_EU;}
        if (symbol_name == "GBPUSD" || symbol_name == "GBPUSDc" ) {MaxSpread  = MaxSpread_GU; Filter = Filter_GU;}
        if (symbol_name == "USDJPY" || symbol_name == "USDJPYc" ) {MaxSpread  = MaxSpread_UJ; Filter = Filter_UJ;}

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
	
	
int start()
{


  int returnvalue=0;
      equity_filter="Filter:";
      for (int var1 = 120; var1 <= 190; var1+=5) 
      {
         Filter_EU=Filter=var1;
         #include <sk_prod11_tofind_filter_2_function_to_repeat.mq4>

         //returnvalue=mainwork();
         equity_filter+=" "+Filter+"="+ (AccountEquity()-( total_traded_lots_tillnow * brokerage_perlot )  ) ; 
      }
      

}
	
	

int deinit()
   {
   
   printf("Equity from "+ opening_balance+" to " + AccountEquity() +" wihtout brokerage = " + (AccountEquity()-( total_traded_lots_tillnow * brokerage_perlot )  ) + " min="+min_equity+"/"+min_equity_nobrokerage  +" max_equity="+max_equity+"/"+max_equity_nobrokerage);
      
   printf("Profit = " + (AccountEquity()- opening_balance ) + " after brokerage = " + (AccountEquity()- opening_balance -( total_traded_lots_tillnow * brokerage_perlot ) ) );
   printf("total_lots_traded="+total_traded_lots_tillnow +  " Orders="+ OrdersTotal() +"/"+ OrdersHistoryTotal() + " Brokerage = " + ( total_traded_lots_tillnow * brokerage_perlot )) ;
   printf("Params :Filter="+Filter+" SL="+SL_points_touse+" TP="+target_input_points +" MaxTrades="+ MaxTrades +" Risk="+ Risk );
return(0);
   }