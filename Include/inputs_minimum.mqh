// Variables define start 
    //INPUTS minimum
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
        input int ok_spread_input=21;
        input int skmoney_total_reserve_input=5000;
        input int skmoney_total_running_input=10;
        input int skmoney_minimum_running_input=2;
        input int closeall_if_loss_inr=0;
        input int closeall_if_profit_inr=50;
        string profit_method="perlotsize";
        input int max_equity_required_INR=0;
        input double sktakeprofit_input_inr=0;
        input double sktakeprofit_input_quick_inr=0;
        input double sk_stop_loss_inr=0;
        input double skpoints_gap_between_orders_input=10;
        input double skpoints_gap_inmid_input=10;
         bool skpoints_gap_between_orders_auto=True;
        input bool take_quick_orders_in_mid=True;   
        string howtoclose="none";
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
        input string skdebuglevel=",err,check1,close1,";
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