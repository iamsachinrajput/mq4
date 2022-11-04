        string lotsize_increase=",level-1&level,";
        string buysell_conditions=",sklevel,";
        string whentobuysell=",levelreverse,";
        string whentosqoff=",onesided_onreverse,";
        double sktakeprofit_input_inr=1;
        double sktakeprofit_input_quick_inr=1;
        int ok_spread_input=10;
        bool executetrades_input=True;
        string startwith="buysell";
        int min_equity_to_trade=10;
        int spread_wait_count_input=5;
        int spread_wait_count=0;
        string indicators_touse=",none,";
        bool show_indicators=False;
        bool save_state_infile=False;
        bool update_status=True;
        //bool update_status=True;
        string whentobuy=",,";
        string whentosell=",,";
        int skmoney_total_reserve_input=5000;
        int skmoney_total_running_input=10;
        int skmoney_minimum_running_input=2;
        int closeall_if_loss_inr=0;
        string profit_method="perlotsize";
        int max_equity_required_INR=0;
        double sk_stop_loss_inr=0;
        bool skpoints_gap_between_orders_auto=True;
        bool take_quick_orders_in_mid=True;   
        string howtoclose="none";
        int increaselots_whenequityis=1000;
        bool skreverse_input=False;
        int skrsi_downlevel=35;
        int skrsi_uplevel=65;
        string skma_inputs="3,6,9,12,15";
        //string skdebuglevel=",err,check1,close1,";
        string skdebuglevel=",err,check1,close1,";
        double linegap=0;
        int sleeptimebetween_simultaneous_orders=10;
        int wait_minutes_afterloss=120;

    //variables for indicators 
        //RSI 
            int skind_rsi_input1_PERIOD=12;
        //MACD 
            int skind_macd_input1_FASTEMA=12;
            int skind_macd_input2_SLOWEMA=26;
            int skind_macd_input3_SIGNALSMA=9;