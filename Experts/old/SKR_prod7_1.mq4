#property copyright "by Sachin Rajput(iamsachinrajput@gmail.com)"
#property version   "2.01"
#property strict
#property description "INPUTS allowed "
                       "\nindicators_touse:,macd,rsi,rsi_macd,"
                       "\nwhentobuysell:,none,macd(up/down),rsi(up/down/zigzag),mkt(up/down/zigzag),"
                       "\nwhentosqoff=,levelchange,"
                       "|profit_method=perlotsize,fullorder"
                       "\nskpoints_gap= for eurousd=10,for btcusd=100,"
                       "|howtoclose=,tp,sl,all"
                       "\nlotsize_increase=self_ordercount,other_ordercount,level&1,level&level,level&level-1,level-1&level"
                       "\nbuysell_conditions=,ma,gapupbuy,gapdownbuy,gapupsell,gapdownsell,zoneswitch,smax,smin,sklevel,"
                       "\nskdebuglevel=check1,comp1,supp1,err,oinfo,close1,onew" ;
#include <stdlib.mqh>
#include <skfunctions.mqh>
// Variables define start 
   //INPUTS 

    string allowed_users_list="preeti1:19057218:19057219,24292087,19050422,adityacent:27108675:19054954";
    input bool executetrades_input=True;
    input string startwith="buysell";
    input string indicators_touse=",rsi,";
    input bool use_buttons=False;
    input bool show_indicators=False;
    input bool save_state_infile=False;
    //bool update_status=True;
    input bool update_status=False;
    input string whentobuysell=",levelreverse,";
    input string whentobuy=",,";
    input string whentosell=",,";
    input string whentosqoff=",,";
    input int wait_minutes_afterloss=120;
    input int closeall_if_loss_inr=0;
    input int closeall_if_profit_inr=10;
    input string profit_method="perlotsize";
    input int max_equity_required_INR=200;
    input double sktakeprofit_input_inr=2;
    input double sktakeprofit_input_quick_inr=2;
    input double sk_stop_loss_inr=0;
    input int skpoints_gap_between_orders_input=500;
    input bool skpoints_gap_between_orders_auto=False;
    input string howtoclose="all";
    input double Lots = 0.01;
    input int maxlot_size_multiply=10;
    input int maxlots_count = 10;
    input string lotsize_increase=",1&level,";
    input int increaselots_whenequityis=1000;
    input bool skreverse_input=False;
    input int skrsi_downlevel=35;
    input int skrsi_uplevel=65;
    input string buysell_conditions=",sklevel,";
    input string skdebuglevel=",err,check1,close1,";
    input double linegap=0;
    input int sleeptimebetween_simultaneous_orders=1000;
    input int MagicNumber = 2808;
    input bool take_quick_orders_in_mid=True;   

   //input variables for indicators 
    //RSI 
        input int skind_rsi_input1_PERIOD=12;
    //MACD 
        input int skind_macd_input1_FASTEMA=12;
        input int skind_macd_input2_SLOWEMA=26;
        input int skind_macd_input3_SIGNALSMA=9;

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




// System working functions 
    void init()
        {
                print_time("init_start");
                string skac1=AccountName();
                string skac2=AccountNumber();
                string skac3=AccountCompany();
                string skac4=AccountServer();
                userinfo="Name="+skac1+" Number="+skac2+" Company="+skac3+" Server="+skac4;

            // USER validation                  
                    skdebug(userinfo,dbgcheck1);
                    if(check_input(skac3,"Exness"))
                    if(  (check_input(allowed_users_list,skac2) && check_input(skac4,"Real") ) 
                        || ( check_input(skac4,"Demo") )
                        )
                        {
                        skdebug("user account number "+skac2+" is registered . enjoy the abundence of money ",dbgcheck1);
                            user_allowed=True;
                    if(update_status ) send_telegram_msg("Started:"+Symbol()+":Bal="+AccountBalance()+" profit="+AccountProfit()+" equity="+AccountEquity()+" by registered "+userinfo );
                            
                        }
                    else 
                    { 
                        Alert("your user is not registered for trading send email to iamsachinrajput@gmail.com for paid version ");
                        if(update_status ) send_telegram_msg("Started:Bal="+AccountBalance()+" profit="+AccountProfit()+" equity="+AccountEquity()+" by notregistered "+userinfo );
                        deinit();
                    }

                    print_time("init_button_pre");

            if(use_buttons) create_chart_buttons();
            if(show_indicators) show_indicators_on_chart();
                opening_balance=AccountBalance();
                        // while initializing get parameters from saved file
                  if(save_state_infile)
                  {
                   if(FileIsExist(skfile_name_params))
                    if(skfile_search(skfile_name_params,"opening_balance"))
                    {
                    opening_balance=StrToInteger(StringReplace(skfile_found_string,"opening_balalce=",""));
                    FileDelete(skfile_name_params);
                    }
                  }
                  
                start_balance=AccountEquity();
                usdtopoints=100;  
                pointstousd=.0001;
                Slippage = 30;
                if(Symbol()=="BTCUSD")
                    {
                        usdtopoints=100;
                        pointstousd=1;
                        Slippage = 300;

                    }
                    else if(Symbol()=="EURUSD")
                        {
                            usdtopoints=1000;  
                            pointstousd=.0001;
                            Slippage = 30;

                        }
                    print_time("init_calculate_current_orders_pre");
                //if(skpoints_gap_between_orders_auto) skpoints_gap_between_orders=skpoints_gap_between_orders_input;
                if(CalculateCurrentOrders("all")>0)
                    {
                        print_time("init_calculate_current_orders_post");
                        skdebug("there were open orders so setting the level settings ",dbgcheck1);
                        update_next_up_down_level_values();
                        skdebug("first ticket="+first_order_number+" sklevel_start_price="+sklevel_start_price+" next up="+sklevel_up_value+" down="+sklevel_down_value,dbgcheck1);
                    }
        print_time("init_END");

        }
    void OnTick()
        {
            print_time("tick_start");
            if(executetrades && user_allowed )
            {
                   
                   // MSG sending to telegram . 
                    //int skcurrent=TimeHour(TimeCurrent());
                    if(update_status) 
                        {  
                            datetime sknow=TimeCurrent();
                            //int skcurrent=TimeMinute(TimeCurrent());   
                            int skcurrent=TimeHour(TimeCurrent());   
                            if(skcurrent!=msg_last_sent ) 
                                {
                                Print(skcurrent+" time msg send ="+sknow);
                                msg_last_sent=skcurrent;
                                string balance_msg="Equity="+AccountEquity()+" ("+AccountBalance()+" "+AccountProfit()+")";
                                send_telegram_msg("#"+AccountNumber()+" "+ balance_msg+" AT:"+sknow);
                                }
                        }
                     
                    totalorderscount=CalculateCurrentOrders("all");
                    //if(!skpoints_gap_between_orders_auto) skpoints_gap_between_orders=skpoints_gap_between_orders_input;
                    update_next_up_down_level_values();
                    display_details_onchart();
                    actual_gap_from_last_order=NormalizeDouble( MathAbs(Ask-last_order_price)/pointstousd,2);
                    pointsgap_ok_from_lastorder_open=( actual_gap_from_last_order > skpoints_gap_between_orders ) ;
                    skdebug("total Orders :"+CalculateCurrentOrders("all"),dbgcheck2);

                    check_mkt_movement();
                    update_lotsize_lotcount_tp();
                    neworder_start_if_no_orders(startwith);
                    skdebug("gapcheck gap="+pointsgap_ok_from_lastorder_open+"|Ask="+Ask+" lastp="+last_order_price+" act_gap="+NormalizeDouble(MathAbs(Ask-last_order_price)/pointstousd,2)+" gapneeded="+ skpoints_gap_between_orders+" p2p="+(pointstousd),dbgcheck2);
                    if(pointsgap_ok_from_lastorder_open || 1==1)
                    {
                    skdebug("inside : gapcheck gap="+pointsgap_ok_from_lastorder_open+"|Ask="+Ask+" lastp="+last_order_price+" act_gap="+NormalizeDouble(MathAbs(Ask-last_order_price)/pointstousd,2)+" gapneeded="+ skpoints_gap_between_orders+" p2p="+(pointstousd),dbgcheck2);
                        if(check_input(buysell_conditions,"sklevel")) buy_sell_with_levels();
                        //buy_sell_based_on_mkt_movements();
                    }
                        exit_on_tp_or_sl(howtoclose);
                        close_all_if_equity_profit();
            }
            //print_time("tick_end");
        }
    void deinit()
        {
            print_time("deinit_start");

            string userstatus="registered";
            if(!user_allowed) 
            { 
                skdebug("exiting the EA due to user not registered",dbgerr);
                 userstatus="unregistered";
            }
                else
                    {
                        skdebug("Exiting the EA",dbgerr);
                        userstatus="registerd";
                    }
            // save last parameters to be restored 
            
            if(save_state_infile)
            {
               string dataline1="opening_balance="+opening_balance;
               skfilewrite(skfile_name_params,dataline1);
               
               skFileDisplay(skfile_name_params);
            }
            
            if(use_buttons) 
               {
               remove_chart_buttons();
               skdebug("removing buttons ",dbgcheck1);
               }
            
             if(update_status) 
               send_telegram_msg(userstatus+":Exit:"+Symbol()+":Bal="+AccountBalance()+" profit="+AccountProfit()+" equity="+AccountEquity()+" by "+userinfo );
            print_time("deinit_END");
        }


// END 
