// Variables define start 
    // allowed users 
        string allowed_users_list="preeti1:955021:19057218:19057219,24292087,19050422,adityacent:27108675:19054954";
    //INPUTS 
        input bool letswork_input=True;
        input bool executetrades_input=True;
        string startwith="buysell";
        string indicators_touse=",none,";
        input bool use_buttons=False;
        bool show_indicators=False;
        bool save_state_infile=False;
        bool update_status=True;
        //input bool update_status=True;
        input string whentobuysell=",levelreverse,";
        string whentobuy=",,";
        string whentosell=",,";
        input string whentosqoff=",onesided_onreverse,";
        input int closeall_if_loss_inr=0;
        input int closeall_if_profit_inr=50;
        string profit_method="perlotsize";
        input int max_equity_required_INR=0;
        input double sktakeprofit_input_inr=0;
        input double sktakeprofit_input_quick_inr=0;
        input double sk_stop_loss_inr=0;
        input double skpoints_gap_between_orders_input=10;
        input double skpoints_gap_inmid_input=10;
        input bool skpoints_gap_between_orders_auto=True;
        input bool take_quick_orders_in_mid=True;   
        string howtoclose="all";
        input double Lots = 0.01;
        input int maxlot_size_multiply=10   ;
        input int maxlots_count = 20;
        input string lotsize_increase=",level&level-1,";
        int increaselots_whenequityis=1000;
        input bool skreverse_input=False;
        int skrsi_downlevel=35;
        int skrsi_uplevel=65;
        string skma_inputs="3,6,9,12,15";
        input string buysell_conditions=",sklevel,";
        string skdebuglevel=",err,check1";
        double linegap=0;
        input int sleeptimebetween_simultaneous_orders=1000;
        int wait_minutes_afterloss=120;
        input int MagicNumber = 28081;

    //input variables for indicators 
        //RSI 
             int skind_rsi_input1_PERIOD=12;
        //MACD 
             int skind_macd_input1_FASTEMA=12;
             int skind_macd_input2_SLOWEMA=26;
             int skind_macd_input3_SIGNALSMA=9;

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
        int maxlots=maxlots_count;
        double sktakeprofit;
        int start_balance=0;
        bool skreverse=skreverse_input;
        double skpoints_gap_between_orders=skpoints_gap_between_orders_input;
        bool pointsgap_ok_from_lastorder_open=False;

    // Variables 
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


    // some other variables 
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
        double last_order_price=0,lastbuy_price=0,lastsell_price=0,lowest_sell_price=0,highest_buy_price=0;
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



        double lastbuy_lots=0,lastsell_lots=0;
        string ordercomment="";
        int tp=0,sl=0,tpr=0,slr=0;
        string lastaction="";
        bool sklevel_switched=False;
        double sklevel_up_value=0,sklevel_down_value=0;
        double sklevel_gap_touse;
        bool oktotrade=True;
        //int sleeptimebetween_simultaneous_orders=70000;

    // Variables for Indicators 
        // variables for indicator macd 
        const string skind_macd="MACD";
        const int skind_macd_output1=0;
        const int skind_macd_output2=1;
        static double skind_macd_lastvalue=0;
        double skind_macd_currentvalue=0;
        static double skind_signal_lastvalue=0;
        double skind_signal_currentvalue=0;

        // variables for indicator RSI 
        const string skind_rsi="RSI";
        const int skind_rsi_output1=0;
        static double skind_rsi_lastvalue=0;
        double skind_rsi_currentvalue=0;

        // Variables for market movement
        string skind_rsi_mkt_prev="notset",skind_rsi_mkt="notset";
        string skind_macd_mkt="notset",skind_macd_mkt_prev="notset";
        string skmkt_movement="notset",skmkt_movement_prev="notset",skmkt_movement_live="notset";
        bool skind_macd_switched=False,skind_rsi_switched=False;
        bool skmkt_movement_anyup=False,skmkt_movement_anydown=False;
        string closed_all_once=False;

    // debug string constants  
        const string dbgsqoff="sqoff";
        const string dbgonew="onew";
        const string dbgoinfo="oinfo";
        const string dbgerr="err";
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


    //some signals 
        double  ma=iMA(NULL,0,5,2,MODE_SMA,PRICE_CLOSE,0);
        double smax=iBands(NULL,0,band_length,band_deviation,0,PRICE_CLOSE,MODE_UPPER,0);
        double smin=iBands(NULL,0,band_length,band_deviation,0,PRICE_CLOSE,MODE_LOWER,0);

