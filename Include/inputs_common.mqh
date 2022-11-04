// Variables define start 
   // INPUTS User 
         input string your_telegram_bot_tocken="";
         input string your_telegram_chat_id="";
         input string your_license_key="";
         input datetime expiry_date="";
    //INPUTS Common
        input bool letswork_input=True;
        input double lots_to_start_input = 0.01;
        input double Lots = 0.01;
        input double inr_gap_between_orders_input=1;
        input double closeall_if_profit_inr_input=-1;
        input int closeall_if_loss_inr=0;
        //input double skpoints_gap_between_orders_input=10;
        input double initial_balance=0;
        input int maxlots_count_input = 100;
        input double ok_spread_input=.3;
        input double brokerageperlot=7;
        input string show_in_chart=",comment,labels,buttons,";
        input string sk_colorfull_chart="none";
        input bool use_buttons=True;
        input int button_x=1;
        input int max_equity_required_INR=0;
        input int MagicNumber = 28081;
