         
// System working functions 
    void init()
        {
            print_mkt_info_for_symbol();
            if(!IsTesting()) executetrades=False;
            skprice=price_to_use();
            user_status=is_user_registered();
            if(update_status !="none" ) send_update_init();
            if (user_status == "unregistered")  deinit();
            if(use_buttons)  create_chart_buttons();
            if(show_indicators)  sk_indicators_to_show_intialize();
            set_basic_params_based_on_symbol_oninit();
            if(save_state_infile) get_params_from_file();
            automanage_money();
            //create_label_to_display();
            
            if(CalculateCurrentOrders("all")>0)  check_if_open_orders_at_start();
            //skdebug("skcheck just finished init  ="+Bars,dbgcheck1);
            //draw_hline("init",skprice,clrSkyBlue,1);

            if(check_input(show_in_chart,",labels,")==True)  
                {
                    create_label(mylabel_equity,1200,300);
                    create_label(mylabel_balance,1200,200);
                    update_label_text();
                }
            if(check_input(show_in_chart,",history,")==True)  
                display_historical_analysis();          
        }
    void OnTick()
        {
            //skdebug("inside ticks number="+Bars,dbgcheck1);
            
            if(check_input(buysell_conditions,",onlytelegram_monitor," ))
            {
               letswork=False;
               display_details_onchart();
               track_max_min_equity();
               update_label_text();
               send_update_ontick();

            }
            if(letswork && user_allowed )
            {
                    skprice=price_to_use();
                    if(show_indicators) sk_indicators_to_show_filldata();
                    
                    //skdebug("inside ticks number="+Bars,dbgcheck1);
                    // Non operational works 
                       display_details_onchart();
                       track_max_min_equity();
                       check_mkt_movement(); // just check mkt status based on rsi and macd indicators 
                                     
                    if(AccountEquity()<=0)
                        {
                            skdebug("NO money !not trade ",dbgmust);
                            return;
                        }
                   if(executetrades && good_day_to_work() && AccountEquity()>min_equity_to_trade && AccountEquity()>0 )
                     {
                       // updating the calcuation for works 
                          update_next_up_down_level_values();
                          update_lotsize_lotcount_tp();  // based on inputs recieved 
                          //automanage_gap();
                       // Placing the orders 
                           if(CalculateCurrentOrders("all")==0 && startwith!="none"  ) neworder_start_if_no_orders(startwith); // 
                           if(check_input(buysell_conditions,",sklevel,")  ) buy_sell_with_levels();
                           //if(check_input(buysell_conditions,",justma,")  ) buy_sell_with_maonly();
                           //buy_sell_with_adionly();
                           //if(check_input(buysell_conditions,",manew,")  ) buy_sell_with_manew_only();
                           
                            if(  check_input(buysell_conditions,",manew," ) 
                                || check_input(buysell_conditions,",justadi,")   
                                || check_input(buysell_conditions,",adiORmanew,")  
                                || check_input(buysell_conditions,",updownlevelonly,")  
                                || check_input(buysell_conditions,",updownwithma,")  
                                || check_input(buysell_conditions,",adiANDmanew,")  ) 
                                        buy_sell_actions_for_given_conditions();

                            if( check_input(buysell_conditions,",simple_pattern," ) ) 
                                buy_sell_simple_pattern();


                       // Exit from the orders     
                            if(howtoclose=="all" || howtoclose=="sl" || howtoclose=="tp") exit_on_tp_or_sl(howtoclose);
                            
                            if(check_input(whentosqoff,",otherside,") && first_order_direction=="buy" )  exit_on_tp_or_sl("tpsell");
                            if(check_input(whentosqoff,",otherside,") && first_order_direction=="sell" )  exit_on_tp_or_sl("tpbuy");
                                //if(sklevel_current<0 && sklevel_current_abs < ordercount_to_takeprofit )  exit_on_tp_or_sl("tpbuy");
                                //if(sklevel_current>0  || check_input(whentosqoff,",anydirectiontp,") )  exit_on_tp_or_sl("tpsell");
                                //if(sklevel_current<0  || check_input(whentosqoff,",anydirectiontp,")  )  exit_on_tp_or_sl("tpbuy");
                           if(closeall_if_profit_inr>0 || closeall_if_loss_inr>0 ) close_all_if_equity_profit();
                           if(max_equity_required_INR!=0) donotwork_if_conditions();
                    
                        display_details_onchart();
                        update_label_text();
                        send_update_ontick();
                    
                }
            
            
            }
                
        }
        
    void OnChartEvent( const int id,const long &lparam,const double &dparam,const string &sparam )
        {
            if(use_buttons)
               {
                in_chart_works_on_button("RESET",lparam,dparam,sparam,id);
                in_chart_works_on_button("PAUSE",lparam,dparam,sparam,id);
                in_chart_works_on_button("CLOSEALL",lparam,dparam,sparam,id);
                in_chart_works_on_button("BUY",lparam,dparam,sparam,id);
                in_chart_works_on_button("SELL",lparam,dparam,sparam,id);
                update_pause_button_live();
                }
      
            if(check_input(sk_colorfull_chart,"full")) update_chart_color();
            if(check_input(sk_colorfull_chart,"balance")) update_chart_color_balance();
         
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
             delete_label_to_display();
             remove_line("init");
            
            send_update_deinit();
        }
        
        
