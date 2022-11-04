   // INPUTS for Developers that is me . 
        //string pattern_inputs="buy,1,1,sell,3,1,sell,3,1,buy,9,1,buy,1,1,buy,1,1,sell,5,1,sell,5,1,sell,5,1,sell,5,1,buy,6,1,buy,6,1,buy,6,1,buy,6,1,sell,7,1,sell,7,1,sell,7,1,sell,7,1";
        //string pattern_inputs="b1,s3,s1,s1,b3,b3,b1,s3,s3,s3,s3,b1,b1,b1";
        //string pattern_inputs="b1,s3,s1,b3,b3,b1,s3,s3,s1,s1,b3,b3,b3,b1,s3,s3,s1,b1,b1,s1";
        //string pattern_inputs="b1,s3,b2,s3,b3,s1,b1,s3,b3,s1,b1,s3,b3,s1,b1,s3,b3,b1,s1,b4,s4,b1,b3,s3,s1";
        //string pattern_inputs="b1,s15,s1,b5,b4,b3,b2,b1,b1,b1,b1,b1,b1,s1,b1";//good1
        //string pattern_inputs="b1,s6,s1,b5,b4,b1,s5,s2,s5,b6,b4,b6,b1,s1,b1";
        //string pattern_inputs="b1,s5,b8,b1,s1,";
        //string pattern_inputs="b1,s5,b8,s8,b6,s4,b3,s2,b2,s1,b1";//good2
        //string pattern_inputs="b1,s5,b7,b7,s20,b6,s4,b3,s2,b2,s1,b1";
        //string pattern_inputs="b1,s3,b9,s20,b40,s40,b80,b1"; // good 3 
        //string pattern_inputs="b1,s3,s1,s1,b10,b1,b1,s30,s1,s1,b90,b1,b1,s200,s1,s1,b400,b1,b1,";
        //string pattern_inputs="b1,s3,s1,b1,b1,b1,b1,b1,s5,s1,b1,b1,b1,b1,b1,s10,s1,b1,b1,b1,b1,b1,b1,b1,b1,b1,";
        //string pattern_inputs="b1,s3,b6,s12,b8,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,b1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1";
        string pattern_inputs="notset";
        //string pattern_inputs="b10,s10,b1,s1,b9,s9,b1,s1,b8,s8,b1,s1,b7,s7,b1,s1,b6,s6,b1,s1,b5,s5,b1,s1,b4,s4,b1,s1,b3,s3,b1,s1,b2,s2,b1,s1";
        //string pattern_inputs="b10,s10,b1,s1,b9,s9,b1,s1,b8,s8,b1,s1,b7,s7,b1,s1,b6,s6,b1,s1,b5,s5,b1,s1,b4,s4,b1,s1,b3,s3,b1,s1,b2,s2,b1,s1";
        //input string pattern_inputs="0  ,1,2,   3,4,5,   6,7,8,   9,10,";
        int maxlot_size_multiply=5000;
        //string buysell_conditions=",simple_pattern,firstwith_manewrsi,"; //super upto 3 order perfect 140wins 
        //string buysell_conditions=",simple_pattern,dynamicgapno,firstwith_manewrsi,allorder_withmacd,allorder_withmanew,trytoclose_1,trytoclose_10,allorder_withrsino,";
        //string buysell_conditions=",simple_pattern,firstwith_manewrsi_zigzag,dynamicgapno,allorder_withrsino,";
        //string buysell_conditions=",simple_pattern,firstwith_adimanewrsi,firstwith_rsino,firstwith_manewrsino,firstwith_manewrsimacdno,firstwith_adino,firstwith_manewno,firstwith_skmix1no,notinloop,dynamicgapno,";
        input string buysell_conditions=",simple_pattern,firstwith_direction5,notinloop,dynamicgapwithcap3,autoreverse,";
        //string buysell_conditions=",simple_pattern,justpattern,notinloop,dynamicgap,noautoreverse,";
        //string buysell_conditions=",updownlevelonly,withsellbuygaps,custom,";
        //string buysell_conditions=",updownlevelonly,withsellbuygaps,custom,";
        input string lotsize_increase_input=",single_directional,consider_brokerage,";
        input bool skreverse_input=False;
        string whentobuysell=",,";
        string whentosqoff=",";
        string direction_decider=",,";
        input double sktakeprofit_input_inr=0.001;
        double sktakeprofit_input_quick_inr=0.001;
        input int ordercount_to_takeprofit=100;
        input double sk_stop_loss_inr=0;
        double perlot_usdtopoints_input=100;
        input string howtoclose="tp";
        bool executetrades_input=True;
        string startwith="none";
        int min_equity_to_trade=0; 
        int spread_wait_count_input=20;
        int spread_wait_count=1;
        string indicators_touse=",skma,";
        bool show_indicators=False;
        bool save_state_infile=False;
        input string update_status=",hourly,closeall,profit,eachorder,";
        //string update_status=",none,";
        //input bool update_status=True;
        string whentobuy=",,";
        string whentosell=",,";
        int skmoney_total_reserve_input=5000;
        int skmoney_total_running_input=10;
        int skmoney_minimum_running_input=2;
        string profit_method="perlotsize";
        bool skpoints_gap_between_orders_auto=True;
        bool take_quick_orders_in_mid=True;   
        int increaselots_whenequityis=1000;
        //string skdebuglevel=",err,check1,close1,";
        //string skdebuglevel=",err,check1,close1,explore,";
        string skdebuglevel=",explore,";
        double linegap=0;
        int sleeptimebetween_simultaneous_orders=10;
        int wait_minutes_afterloss=120;

    //variables for indicators 
        //skma 
            string skma_inputs="4,10,100,600";
            int skma4_periods=6;
            int skma9_periods=12;  

        //RSI 
            int skind_rsi_input1_PERIOD=18;
            int skrsi_downlevel=30;
            int skrsi_uplevel=70;
        //MACD 
            int skind_macd_input1_FASTEMA=12;
            int skind_macd_input2_SLOWEMA=26;
            int skind_macd_input3_SIGNALSMA=9;
        //ADI indicator 
            int skind_adi_input1_SIGNAL_PERIOD=6;
            int skind_adi_input2_ARROW_PERIOD=2;
            int skind_adi_input3_SL_PIPS=10;
            int skind_adi_input4_AlertON=False;
            int skind_adi_input5_Email=False;