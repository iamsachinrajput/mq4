// Variables define start 
    // allowed users 
        string allowed_users_list="Demo:,37046806,6941268,|preeti1:955021:19057218:19057219,24292087,19050422,adityacent:27108675:19054954";

    // Other inputs changed to variables now 
        int losspositionsupport=3;
        double supportiflossinr=2;
        bool workonlywithlevels=True;
        int complementry_order=3;
        int quickstart=3;
        bool closeallcondition=False;
        int increaselots_support=1;
        int maxlots_check_foreachorder=0;
        int onprofit_quit_or_trail = 1;
        int increaselots=1;
        int sklevel_gap=2;
        int maxlots=maxlots_count_input;
        double sktakeprofit;
        double start_balance=0;
        bool skreverse=skreverse_input;
        bool pointsgap_ok_from_lastorder_open=False;
        double skpoints_gap_between_orders_input;
        double skpoints_gap_between_orders;
        int pattern_input_count=0;
        string skprofit_orders_string="none";
        int profit_with_orders_1=0,profit_with_orders_2=0,profit_with_orders_3=0,profit_with_orders_4=0,profit_with_orders_5=0,profit_with_orders_6=0,profit_with_orders_7=0,profit_with_orders_8=0,profit_with_orders_9=0,profit_with_orders_10=0,profit_with_orders_10more=0,profit_with_orders_max=0;
        double total_profit_accumulated=0;
        int loss_with_orders_max=0;
        double mygap=0;
        double margin_used_max=0;
        double margin_free_min=AccountEquity();
        double margin_free=0;
        double min_equity_profit=0;


    // Variables 
        // variables for money calculation 
            double closeall_if_profit_inr=closeall_if_profit_inr_input;
            double lots_to_start=lots_to_start_input;
            double maxlots_count=maxlots_count_input;
        int n = 10;
        double usdtopoints=.001;
        double pointstousd=.0001;
        int totalorderscount=0;
        int total=0;
        int Slippage = 30;
        int POPYTKY = 10;
        bool  gbDisabled = False;
        datetime currenttime=TimeCurrent();
        datetime lastupdatedtime=TimeCurrent();
        string randomname;
        double minpricegap=1.5*MarketInfo( Symbol(), MODE_STOPLEVEL )*Point();
        int sklevel=0,sklevel_prev=0 , sklevel_current=0;
        double sklevel_start_price=0 , sklevel_lotsize=0,sklevel_lotsize2=0;
        //string skfile_name_params="mq4_params_to_restore.txt";
        string skfile_name_params="mq4input.txt";
        string skfile_name_params_1="mq4input_1.txt";
        bool letswork=letswork_input;
        string user_status="notset";
        string open_orders_list="";
        string open_orders_list_buy="",open_orders_list_sell="";
        double skprice=(Ask+Bid)/2;
        double spreadsize=(Ask-Bid);
        int min_equity_reached=AccountEquity();
        int max_equity_reached=0;
        int max_gap_faced=0,current_gap_from_start=0;
        int max_loss_faced=0;
        double toal_transacted_lots=0,lots_count_till_profit=0;
        int total_transacted_orders=0;
        int new_counts=0,loss_count=0;
        double sktotalprofit=0;
        string string_from_history="notset";





    // variables for money calculations 
        int skmoney_total_profit=0;
        int skmoney_total_reserve=skmoney_total_reserve_input;
        int skmoney_total_running=skmoney_total_running_input;
        int skmoney_minimum_running=skmoney_minimum_running_input;
    // some other variables 
        string lotsize_increase=lotsize_increase_input;
        double next_lot_size=0,prev_lot_size=0;
        bool user_allowed=False;
        int buysellstrategy=1;
        int alwayscomporder=1;
        int band_length=24;
        int band_deviation=2;
        double maxloss_allowed_inr=1000;
        double maxloss_perday_inr=10;
        double lotsize_to_execute=0 , lotsize_to_execute_buy=0 , lotsize_to_execute_sell=0;
        double lotsize_in_support=0,lotsize_in_direction=0;
        int sksleeptime=500;
        int modifyorderinloss=0;
        double minprofitinr=3;
        int buyselltogether=0;
        int onloss_action=0;
        int opening_balance=0;
        int skbuy_lotsize=0, sksell_lotsize=0;
        int lastbuy_order=0,lastsell_order=0;
        int positivecount=0, negativecount=0, totalorderscount1=0, skbuycount=0, sksellcount=0;
        int positivecount_sell=0,positivecount_buy=0,negativecount_sell=0,negativecount_buy=0;
        double last_order_price=0,lastbuy_price=0,lastsell_price=0,lowest_sell_price=0,highest_buy_price=0;
        double last_order_size=0,second_last_order_size=0,second_last_order_price=0;
        int last_order_type=0,second_last_order_type=0;
        datetime last_order_time ;
        string zone_switched="none";
        string textfromfile;
        string space=" ";
        string equal="=";
        double actual_gap_from_last_order=0;
        double buy_lots_total=0,sell_lots_total=0;
        string special_comment="none";
        double first_order_price=0;
        int first_order_number=0;
        int sklevel_current_abs=0;
        bool executetrades=executetrades_input;
        string skfile_found_string="none";
        string userinfo="none";
        int msg_last_sent=0;
        string lastorder="none";
        string splitresult[];
        double skbuffer_ma1[],skbuffer_ma2[],skbuffer_ma3[],skbuffer_ma4[],skbuffer_ma5[];
        int daytoavoid=100;
        string first_order_direction="none";
        int order_count_til_profit=0,max_order_count_til_profit=0;
        double max_lotsize_reached=0;
        string lastorder_adi="none";
        double lastbuy_lots=0,lastsell_lots=0;
        string ordercomment="";
        int tp=0,sl=0,tpr=0,slr=0;
        string lastaction="";
        bool sklevel_switched=False;
        double sklevel_up_value=0,sklevel_down_value=0;
        double sklevel_gap_touse;
        bool send_telgram_message_flag = True;
        bool oktotrade=True;
        double top_price_order=0,least_price_order=0;
        //int sleeptimebetween_simultaneous_orders=70000;
        double last_gap_5bars=0,last_gap_10bars=0;
        int pacify_order_plus=0,pacify_order_minus=0,pacifier_order=0;

    // Variables for Indicators 
        //Variables for MA 
        double skma10=0,skma60=0,skma10_prev=0,skma60_prev=0,skma10_prev2=0,skma60_prev2=0;
        bool magap_up1=False,magap_up2=False,magap_down1=False,magap_down2=False;
        double skma4=0,skma9=0;
        // variables for indicator macd 
        const string skind_macd="MACD";
        const int skind_macd_output1=0;
        const int skind_macd_output2=1;
        static double skind_macd_lastvalue=0;
        double skind_macd_currentvalue=0;
        static double skind_signal_lastvalue=0;
        double skind_signal_currentvalue=0;

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


        // variables for labels
        const string mylabel_equity="equity";
        const string mylabel_balance="balance";
        
        // variables for indicator RSI 
        const string skind_rsi="RSI";
        const int skind_rsi_output1=0;
        static double skind_rsi_lastvalue=0;
        double skind_rsi_currentvalue=0;

        // Variables for market movement
        string skind_rsi_mkt_prev="notset",skind_rsi_mkt="notset",skind_rsi_action="notset";
        string skind_macd_mkt="notset",skind_macd_mkt_prev="notset";
        string skmkt_movement="notset",skmkt_movement_prev="notset",skmkt_movement_live="notset";
        bool skind_macd_switched=False,skind_rsi_switched=False;
        bool skmkt_movement_anyup=False,skmkt_movement_anydown=False;
        string closed_all_once=False;

        //Variables for indicator SKMIX1
            double SKMIX1_Signal_up=0;
            double SKMIX1_Signal_down=0;
            double SKMIX1_Signal_flat=0;


    // debug string constants  
        const string dbgsqoff="sqoff";
        const string dbgonew="onew";
        const string dbgoinfo="oinfo";
        const string dbgerr="err";
        const string dbgerr2="err2";
        const string dbgmodify1="modify1";
        const string dbgmodify2="modify2";
        const string dbgcomp1="comp1";
        const string dbgcomp2="comp2";
        const string dbgsupport1="supp1";
        const string dbgsupport2="supp2";
        const string dbgclose1="close1";
        const string dbgclose2="close2";
        const string dbgcheck1="check1";
        const string dbgcheck2="check2";
        const string dbgmust="must";
        const string dbgexplore="explore";
        

    //some signals 
        double  ma=iMA(NULL,0,5,2,MODE_SMA,PRICE_CLOSE,0);
        double smax=iBands(NULL,0,band_length,band_deviation,0,PRICE_CLOSE,MODE_UPPER,0);
        double smin=iBands(NULL,0,band_length,band_deviation,0,PRICE_CLOSE,MODE_LOWER,0);

