   // INPUTS for Developers that is me . 
        input double initial_balance=0;
        input double closeall_if_profit_inr=10;
        input double skpoints_gap_between_orders_input=50;
        input int maxlot_size_multiply=5000   ;
        input int maxlots_count = 10;
        input string lotsize_increase_input=",triple,";
        input string buysell_conditions=",updownlevelonly,withsellbuygaps,singleifback,";
        input string whentobuysell=",,";
        input string whentosqoff=",withneworderall,";
        input string direction_decider=",,";
        input double sktakeprofit_input_inr=0.001;
        input double sktakeprofit_input_quick_inr=0.001;
        input int ordercount_to_takeprofit=50;
        input double sk_stop_loss_inr=0;
        input int closeall_if_loss_inr=0;
        input int ok_spread_input=100;
        input string howtoclose="none";
        input bool executetrades_input=True;
        input string startwith="none";
        input int min_equity_to_trade=0; 
        input int spread_wait_count_input=5;
        int spread_wait_count=0;
        input string indicators_touse=",sma,";
        input bool show_indicators=False;
        input bool save_state_infile=False;
        //input string update_status=",hourly,closeall,profit,eachorder,";
        input string update_status=",none,";
        //input bool update_status=True;
        input string whentobuy=",,";
        input string whentosell=",,";
        input int skmoney_total_reserve_input=5000;
        input int skmoney_total_running_input=10;
        input int skmoney_minimum_running_input=2;
        input string profit_method="perlotsize";
        input int max_equity_required_INR=0;
        input bool skpoints_gap_between_orders_auto=True;
        input bool take_quick_orders_in_mid=True;   
        input int increaselots_whenequityis=1000;
        input bool skreverse_input=False;
        input int skrsi_downlevel=35;
        input int skrsi_uplevel=65;
        //input string skdebuglevel=",err,check1,close1,";
        input string skdebuglevel=",err,check1,close1,explore,";
        input double linegap=0;
        input int sleeptimebetween_simultaneous_orders=10;
        input int wait_minutes_afterloss=120;

    //input variables for indicators 
        //skma 
            input string skma_inputs="4,10,100,600";
        //RSI 
            input int skind_rsi_input1_PERIOD=12;
        //MACD 
            input int skind_macd_input1_FASTEMA=12;
            input int skind_macd_input2_SLOWEMA=26;
            input int skind_macd_input3_SIGNALSMA=9;
        //ADI indicator 
            input int skind_adi_input1_SIGNAL_PERIOD=12;
            input int skind_adi_input2_ARROW_PERIOD=2;
            input int skind_adi_input3_SL_PIPS=100;
            input int skind_adi_input4_AlertON=False;
            input int skind_adi_input5_Email=False;