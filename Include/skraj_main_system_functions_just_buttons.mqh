         
// System working functions 
    void init()
        {
            if(!IsTesting()) executetrades=False;
            skprice=price_to_use();
            user_status=is_user_registered();
            if (user_status == "unregistered")  deinit();
            if(update_status )  send_telegram_msg("Started:"+balance_info_string()+" by "+userinfo );
            if(use_buttons)  create_chart_buttons();
            if(save_state_infile) get_params_from_file();
                else    set_basic_params_based_on_symbol();
            
            if(CalculateCurrentOrders("all")>0)  check_if_open_orders_at_start();
        }
    void OnTick()
        {

            if(letswork && user_allowed )
            {
                    skprice=price_to_use();
                    if(update_status ) send_update_ontick();

                    // Non operational works 
                       display_details_onchart();
                       track_max_min_equity();
                       //check_mkt_movement(); // just check mkt status based on rsi and macd indicators 
                                     
                   if(executetrades && good_day_to_work() && AccountEquity()>min_equity_to_trade)
                     {
                       // updating the calcuation for works 
                          //update_next_up_down_level_values();
                          update_lotsize_lotcount_tp();  // based on inputs recieved 
                       // Placing the orders 
                           //if(CalculateCurrentOrders("all")==0 && startwith!="none"  ) neworder_start_if_no_orders(startwith); // 
                           //if(check_input(buysell_conditions,",sklevel,")  ) buy_sell_with_levels();
                           //if(check_input(buysell_conditions,",justma,")  ) buy_sell_with_maonly();
   
                       // Exit from the orders     
                           //if(howtoclose=="all" || howtoclose=="sl" || howtoclose=="tp") exit_on_tp_or_sl(howtoclose);
                                //if(sklevel_current>0 && sklevel_current_abs < ordercount_to_takeprofit )  exit_on_tp_or_sl("tpsell");
                                //if(sklevel_current<0 && sklevel_current_abs < ordercount_to_takeprofit )  exit_on_tp_or_sl("tpbuy");
                                if(sklevel_current>0  || check_input(whentosqoff,",anydirectiontp,") )  exit_on_tp_or_sl("tpsell");
                                if(sklevel_current<0  || check_input(whentosqoff,",anydirectiontp,")  )  exit_on_tp_or_sl("tpbuy");
                           if(closeall_if_profit_inr>0 || closeall_if_loss_inr>0 ) close_all_if_equity_profit();
                           if(max_equity_required_INR!=0) donotwork_if_conditions();
                     }
            
            
            }
                
        }
    void deinit()
        {
            if(!user_allowed) 
                skdebug("exiting the EA due to user not registered",dbgerr);
            else
                skdebug("Exiting the EA",dbgerr);
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
               send_telegram_msg("Exited:"+balance_info_string()+" by "+userinfo );
            
        }
