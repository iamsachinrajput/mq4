// less editable functions 
    void check_last_error(string goodmsg,string errormsg)
        {
               int skerrorcode=GetLastError();
               if(skerrorcode)
                  skdebug("Failed:"+errormsg+":Error:"+ErrorDescription(GetLastError()),dbgerr);
               else 
                  skdebug("Success:"+goodmsg,dbgcheck1);
        }
     

    string myerrmsg()
        {
            if(GetLastError())
            {
            skdebug("myerr : got error ="+ErrorDescription(GetLastError()),dbgerr);
            return("myerr : got error ="+ErrorDescription(GetLastError()));
            }
            else return(" Good");
        }  
        
    void skfilewrite(string filename1,string dataline)
        {
            int filehander;
                {
                filehander==FileOpen(filename1,FILE_WRITE|FILE_CSV);
                if(filehander==INVALID_HANDLE)
                    skdebug("not valid file open:"+filename1,dbgcheck1);
                else
                    {
                    FileWriteString(filehander,dataline);
                    skdebug("write done ",dbgcheck2);
                    FileClose(filehander);
                    }
                FileClose(filehander);
                    skdebug("size of file "+filename1+" ="+FileSize(filehander),dbgcheck2);
                    FileCopy(skfile_name_params,0,skfile_name_params_1,0);
                }
        }

    bool skFileDisplay(const string file_name) 
        { 
            //--- reset the error value 
            ResetLastError(); 
            //--- open the file 
            bool returnvalue=False;
            int file_handle=FileOpen(file_name,FILE_READ|FILE_TXT); 
            if(file_handle!=INVALID_HANDLE) 
                { 
                //--- display the file contents in the loop 
                skdebug("File name ="+file_name,dbgcheck1); 
                while(!FileIsEnding(file_handle)) 
                    skdebug(FileReadString(file_handle),dbgcheck1); 
                //--- close the file 
                FileClose(file_handle); 
                returnvalue=True;
                } 
            return(returnvalue);
        } 

    void skfileread(string filename1)
        {
            int filehander;
            if(FileIsExist(filename1))
                {
                Alert("filename="+filename1);
                textfromfile="empty";
                filehander==FileOpen(filename1,FILE_READ|FILE_CSV);
                if(filehander==INVALID_HANDLE)
                { skdebug("not valid file open:"+filename1,dbgcheck1);return;}
                else
                    {
                    while( !FileIsEnding(filehander))
                        {
                            textfromfile=FileReadString(filehander)+"|";
                            Alert("filetext="+textfromfile+":");
                        if(FileIsEnding(filehander))   // File pointer is at the end
                            break; 
                        }
                    }
                FileClose(filehander);
                }
            
        }

    bool skfile_search(string filename1,string tofind)
        {
            int filehander,returnvalue=0;
            if(FileIsExist(filename1))
                {
                //Alert("filename="+filename1);
                textfromfile="empty";
                filehander==FileOpen(filename1,FILE_READ|FILE_TXT);
                if(filehander==INVALID_HANDLE)
                { skdebug("not valid file open:"+filename1,dbgcheck1);return(0);}
                else
                    {
                        skdebug("will find "+tofind+" in file " + filename1,dbgcheck1);
                    while( !FileIsEnding(filehander))
                        {
                            textfromfile=FileReadString(filehander);
                            skdebug("line from file :"+textfromfile,dbgcheck1);
                            if ( StringFind(textfromfile,tofind) > 0 )
                            {
                                skfile_found_string=textfromfile;
                                returnvalue=1;
                                Alert("found account ="+tofind+" listed in registered users  "+textfromfile+":");
                            }

                        if(FileIsEnding(filehander))   // File pointer is at the end
                            {
                                FileClose(filehander);
                                break; 
                            }
                        }
                    FileClose(filehander);
                        if(returnvalue==0)
                            skdebug("not found "+tofind+" in file " + filename1,dbgcheck1);

                    }
                FileClose(filehander);
                }
            return(returnvalue);  
        }

    void skdebug(string msg1, string level)
        {
            //if(level <=skdebuglevel)
            if(StringFind(skdebuglevel,level) >=0 || level==dbgmust) 
                Print( Bars+":"+skprice+" "+msg1+" "+level);
        }
    bool check_input(string input1,string tocheck)
        {
            bool returnvalue1=False;
            if(StringFind(input1,tocheck,0) >= 0 ) 
                returnvalue1=True;
                
            skdebug("stringcheck:"+input1+":"+tocheck+" result="+returnvalue1,dbgcheck2);

            return(returnvalue1);
        }
    void sleep_minutes(int minutestosleep)
        {
            datetime waitstart_time=TimeCurrent();
            skdebug("waiting for "+minutestosleep+" minutes because we got loss. Current time = "+waitstart_time,dbgcheck1); 
            Sleep(60*1000*minutestosleep);
            datetime afterwait_time=TimeCurrent();
            skdebug("wait Over for "+minutestosleep+" minutes because we got loss. Current time = "+afterwait_time+" lasttime="+waitstart_time,dbgcheck1); 
        }
    int CalculateCurrentOrders(string whichorders)
        {
            int buys=0,sells=0;
            open_orders_list="";
            //---
            for(int i=0; i<OrdersTotal(); i++)
            {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
                break;
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
            {
                open_orders_list+=OrderComment()+",";
                if(OrderType()==OP_BUY)
                {
                buys++;
                open_orders_list_buy+=OrderComment()+","; 
                }
                if(OrderType()==OP_SELL)
                {
                sells++;
                open_orders_list_sell+=OrderComment()+",";
                }
            }
            }
            //--- return orders volume
            //if(buys>0)
            //  return(buys);
            //else
            int returnvalue=0;
            if(whichorders=="buy") 
                {
                    returnvalue=(buys);
                    //skdebug("Open orders:buy="+buys+" list="+open_orders_list_buy,dbgcheck1);
                }
            if(whichorders=="sell") 
                {
                    returnvalue=(sells);
                    //skdebug("Open orders:sell="+sells+" list="+open_orders_list_sell,dbgcheck1);
                }
            if(whichorders=="all") 
                {
                    returnvalue=(buys+sells);
                    //skdebug("Open orders:all="+(buys+sells)+" buylist="+open_orders_list_buy+" sell list="+open_orders_list_sell,dbgcheck1);
                }
            
            return(returnvalue);
        }

    double getequity()
        {
            double returnvalue=(NormalizeDouble(AccountEquity(),2));
            if(check_input(lotsize_increase_input,"consider_brokerage"))
                returnvalue=(NormalizeDouble(AccountEquity()-(toal_transacted_lots*brokerageperlot),2));
            return(returnvalue);
        }
    string getordertype_name(int op)
        {
            switch(op)
                {
                case OP_BUY      :
                    return("buy");
                case OP_SELL     :
                    return("sell");
                case OP_BUYLIMIT :
                    return("Buy Limit");
                case OP_SELLLIMIT:
                    return("Sell Limit");
                case OP_BUYSTOP  :
                    return("Buy Stop");
                case OP_SELLSTOP :
                    return("Sell Stop");
                default          :
                    return("Unknown Operation");
            }
        }
// Market related information 
    double get_pip_value()
        {
            double returnvalue=.0001;
            if(Symbol()=="BTCUSD")
                returnvalue=.01;
            skdebug(Symbol()+" ki Pipvalue="+returnvalue,7);
            return(returnvalue);
        }

    string get_mkt_info(string indic)
        {
            check_mkt_movement();
            string returnvalue="";
            if(check_input(indic,"rsi") || indic=="all" ) returnvalue+=" rsi="+skind_rsi_mkt;
            if(check_input(indic,"macd") || indic=="all" ) returnvalue+=" macd="+skind_macd_mkt;
            if(check_input(indic,"mkt") || indic=="all" ) returnvalue+=" mkt="+skmkt_movement;
            skdebug(returnvalue,dbgcheck2);
            return("mktinfo");
        }


    void indicator_adi_fill_details()
        {
            //values filling for New Indicator from aditya  
                skind_adi_uptrend_value_prev=skind_adi_uptrend_value;
                skind_adi_downtrend_value_prev=skind_adi_downtrend_value;

                // fill only previous value current using 0 will not work.
                skind_adi_uptrend_value=iCustom(Symbol(),Period(),skind_adi,
                                                        skind_adi_input1_SIGNAL_PERIOD,skind_adi_input2_ARROW_PERIOD,skind_adi_input3_SL_PIPS,skind_adi_input4_AlertON,skind_adi_input5_Email,
                                                        skind_adi_output3_uptrend_signal,1);
                skind_adi_downtrend_value=iCustom(Symbol(),Period(),skind_adi,
                                                        skind_adi_input1_SIGNAL_PERIOD,skind_adi_input2_ARROW_PERIOD,skind_adi_input3_SL_PIPS,skind_adi_input4_AlertON,skind_adi_input5_Email,
                                                        skind_adi_output4_downtrend_signal,1);
                
                if(skind_adi_uptrend_value>0 || skind_adi_downtrend_value>0 )
                    {
                    skdebug("UP="+skind_adi_uptrend_value+" Down="+skind_adi_downtrend_value,dbgcheck2);
                    }



        }
    int check_mkt_movement()
        {

            if(check_input(indicators_touse,",macd,"))
                {
                    //values filling for MACD indicator 
                        skind_macd_lastvalue=skind_macd_currentvalue;
                        skind_signal_lastvalue=skind_rsi_currentvalue;

                        skind_macd_currentvalue=iCustom(Symbol(),Period(),skind_macd,
                                                                skind_macd_input1_FASTEMA,skind_macd_input2_SLOWEMA,skind_macd_input3_SIGNALSMA,
                                                                skind_macd_output1,1);
                        skind_signal_currentvalue=iCustom(Symbol(),Period(),skind_macd,
                                                                skind_macd_input1_FASTEMA,skind_macd_input2_SLOWEMA,skind_macd_input3_SIGNALSMA,
                                                                skind_macd_output2,1);
                        skdebug("macd and signal parameters "+skind_macd_currentvalue+":"+skind_signal_currentvalue,dbgcheck2);
                        
                    //check market status for macd indidicator  
                        skind_macd_switched=False;   
                        if(skind_macd_currentvalue > skind_signal_currentvalue 
                            && skind_macd_lastvalue<0 
                            //&& skind_macd_lastvalue<skind_signal_lastvalue
                            //&& skind_macd_mkt!="up"
                                )
                            {
                                //skdebug("setting macd up "+skind_macd_currentvalue+":"+skind_signal_currentvalue,dbgcheck2);
                                skind_macd_mkt_prev=skind_macd_mkt;
                                skind_macd_mkt="up";
                                skind_macd_switched=True;
                            }
                            
                            if(skind_macd_currentvalue < skind_signal_currentvalue 
                                && skind_macd_lastvalue>0 
                                //&& skind_macd_lastvalue>=skind_signal_lastvalue
                                //&& skind_macd_mkt!="down"
                                    )
                                {
                                    skdebug("setting macd down "+skind_macd_currentvalue+":"+skind_signal_currentvalue,dbgcheck2);
                                    skind_macd_mkt_prev=skind_macd_mkt;
                                    skind_macd_mkt="down";
                                    skind_macd_switched=True;
                                }
                            
                }
            if(check_input(indicators_touse,",rsi,"))
                {
                    // value filling for RSI signal 
                        skind_rsi_lastvalue=skind_rsi_currentvalue;
                        skind_rsi_currentvalue=iCustom(Symbol(),Period(),skind_rsi,
                                                                skind_rsi_input1_PERIOD,
                                                                skind_rsi_output1,1);

                    // Check market status based on rsi indicator 
                            skind_rsi_switched=False;
                        if ( ( skind_rsi_currentvalue <= skrsi_downlevel && skind_rsi_currentvalue>15 ) 
                           ||( skind_rsi_currentvalue>90)
                            )
                        {
                            skind_rsi_mkt_prev=skind_rsi_mkt;
                            skind_rsi_mkt="down";
                            skind_rsi_action="sell";
                            skind_rsi_switched=True;
                        }
                        else if(skind_rsi_currentvalue < skrsi_uplevel && skind_rsi_currentvalue>skrsi_downlevel ) 
                        {
                            skind_rsi_mkt_prev=skind_rsi_mkt;
                            skind_rsi_mkt="zigzag";
                            if(skind_rsi_currentvalue>50)
                                skind_rsi_action="buy";
                            if(skind_rsi_currentvalue<50)
                                skind_rsi_action="sell";
                            
                            skind_rsi_switched=True;
                        }
                        else if( ( skind_rsi_currentvalue>=skrsi_uplevel && skind_rsi_currentvalue<90 ) 
                              || ( skind_rsi_currentvalue<15 )
                                ) 
                        {
                            skind_rsi_mkt_prev=skind_rsi_mkt;
                            skind_rsi_mkt="up";
                            skind_rsi_action="buy";
                            skind_rsi_switched=True;
                        }
                }
            
            if(check_input(indicators_touse,",skmix1,"))
                {
                    int    TimeFrame = 1;
                    int    PeriodRSI = 14;     
                    int  PeriodCCI_1 = 34;
                    int  PeriodCCI_2 = 170;

                    double SKMIX1_RSI,SKMIX1_CCI_1,SKMIX1_CCI_2,SKMIX1_HAS_b,SKMIX1_HAS_s ;  
                    int y = 1;
                    SKMIX1_RSI   = iRSI(NULL,TimeFrame,PeriodRSI,PRICE_CLOSE,y);
                    SKMIX1_CCI_1 = iCCI(Symbol(),TimeFrame,PeriodCCI_1,PRICE_TYPICAL,y);
                    SKMIX1_CCI_2 = iCCI(Symbol(),TimeFrame,PeriodCCI_2,PRICE_TYPICAL,y);
                    SKMIX1_HAS_b = iMA(NULL,TimeFrame,6,0,MODE_SMMA,PRICE_CLOSE,y);
                    SKMIX1_HAS_s = iMA(NULL,TimeFrame,2,0,MODE_LWMA,PRICE_CLOSE,y);
                    SKMIX1_Signal_up=0;
                    SKMIX1_Signal_down=0;
                    SKMIX1_Signal_flat=1;
                    
                    if ((SKMIX1_RSI > 55)&&(SKMIX1_CCI_1>0)&&(SKMIX1_CCI_2>0)&&(SKMIX1_HAS_b<SKMIX1_HAS_s))
                            {  
                                SKMIX1_Signal_up=1;   SKMIX1_Signal_down=0; SKMIX1_Signal_flat=0;
                            }
   
                    if ((SKMIX1_RSI < 45)&&(SKMIX1_CCI_1<0)&&(SKMIX1_CCI_2<0)&&(SKMIX1_HAS_s<SKMIX1_HAS_b))
                        { 
                            SKMIX1_Signal_up=0;   SKMIX1_Signal_down=1; SKMIX1_Signal_flat=0;
                        } 

                }

            if(check_input(indicators_touse,",sma,"))
                {
                    // value filling for MA 10 and ma60 for mkt movement 
                        skma10=iMA(NULL,1,100,1,MODE_SMA,PRICE_CLOSE,1);
                        skma60=iMA(NULL,1,600,1,MODE_SMA,PRICE_CLOSE,1);
                        skma10_prev=iMA(NULL,1,100,1,MODE_SMA,PRICE_CLOSE,10);
                        skma60_prev=iMA(NULL,1,600,1,MODE_SMA,PRICE_CLOSE,10);
                        skma10_prev2=iMA(NULL,1,100,1,MODE_SMA,PRICE_CLOSE,20);
                        skma60_prev2=iMA(NULL,1,600,1,MODE_SMA,PRICE_CLOSE,20);

                        bool macross_up=(skma60_prev>skma10_prev) && (skma60 <skma10);
                        bool macross_down=(skma60_prev<skma10_prev) && (skma60 >skma10);

                        double magap2=MathAbs(skma10_prev2-skma60_prev2) ;
                        double magap1=MathAbs(skma10_prev-skma60_prev) ;
                        double magap=MathAbs(skma10-skma60);

                        if(check_input(direction_decider,",macross,") )
                            {
                                if(macross_up)
                                    draw_vline("mkt_buy"+Bars,skprice,clrBlue,2);
                                if(macross_down)
                                    draw_vline("mkt_sell"+Bars,skprice,clrYellow,2);
                            }

                        bool ma60_going_up=skma60 > skma60_prev && skma60_prev > skma60_prev2;
                        bool ma10_going_up=skma10 > skma10_prev && skma10_prev > skma10_prev2;
                        bool ma60_going_down=skma60 < skma60_prev && skma60_prev < skma60_prev2;
                        bool ma10_going_down=skma10 < skma10_prev && skma10_prev < skma10_prev2;

                        string maup_reason="none";
                        if( skma10<skma60 && magap2<magap1 && magap1<magap )
                            maup_reason="buy";


                                magap_down2=magap_down1;
                                magap_up2=magap_up1;

                        if( (skma10<skma60 && magap2<magap1 && magap1<magap ) 
                           ||(skma10>skma60 && magap2>magap1 && magap1>magap  ) 
                           || (ma60_going_down && ma10_going_down )
                           )
                            {
                                magap_down1=True;
                                //magap_up2=False;
                                magap_up1=False;
                            }
                        if( (skma10>skma60 && magap2<magap1 && magap1<magap ) 
                           ||(skma10<skma60 && magap2>magap1 && magap1>magap  ) 
                           || (ma60_going_up && ma10_going_up )
                           )
                           {
                                magap_up1=True;
                                //magap_down2=False;
                                magap_down1=False;
                           }
                        if(check_input(direction_decider,",magap,") )
                            {
                                if(magap_down2==True && magap_up1==True)
                                    {
                                        draw_vline("mktgap_buy"+Bars,skprice,clrAqua,2);
                                        //magap_up2=magap_up1;
                                    }
                                if(magap_up2==True && magap_down1==True)
                                    {
                                        draw_vline("mktgap_sell"+Bars,skprice,clrPink,2);
                                        //magap_down2=magap_down1;
                                    }
                            }



                        
                }

            // check market status based on all indicators 
                if( (skind_rsi_mkt=="up" && skind_macd_mkt=="up" && check_input(indicators_touse,",rsi_macd,") )
                        ||  (skind_rsi_mkt=="up" && check_input(indicators_touse,",rsi,") )
                        ||  (skind_macd_mkt=="up" && check_input(indicators_touse,",macd,") )
                            )
                    {
                        if(skmkt_movement!="up" )
                        {
                            zone_switched="up";
                            skmkt_movement_prev=skmkt_movement;
                            skmkt_movement="up";
                            skdebug("setting mkt up and zone switched| mkt="+skmkt_movement+"| rsi="+skind_rsi_mkt+"| macd="+skind_macd_mkt,dbgcheck2);
                        }
                        else
                            skmkt_movement_live="up";
                    }
                        else if(     (skind_rsi_mkt=="up" && skind_macd_mkt=="up" && check_input(indicators_touse,",rsi_macd,") )
                            ||  (skind_rsi_mkt=="up" && check_input(indicators_touse,",rsi,") )
                            ||  (skind_macd_mkt=="up" && check_input(indicators_touse,",macd,") )
                                    )
                                {
                                    if(skmkt_movement!="down")
                                        {
                                        zone_switched="down";
                                        skmkt_movement_prev=skmkt_movement;
                                        skmkt_movement="down";
                                        skdebug("setting mkt down mkt="+skmkt_movement+"| rsi="+skind_rsi_mkt+"| macd="+skind_macd_mkt,dbgcheck2);
                                        }
                                        else
                                            skmkt_movement_live="down";
                                }
                                    else if( skind_rsi_mkt=="zigzag" && 1==2)
                                            {
                                                if(skmkt_movement!="zigzag")
                                                    {
                                                        zone_switched="zigzag";
                                                        skmkt_movement_prev=skmkt_movement;
                                                        skmkt_movement="zigzag";
                                                        skdebug("setting mkt zigzag mkt="+skmkt_movement+"| rsi="+skind_rsi_mkt+"| macd="+skind_macd_mkt,dbgcheck2);
                                                    }
                                                    else
                                                        skmkt_movement_live="zigzag";
                                            }

                if( (skind_rsi_mkt=="up" && skind_macd_mkt!="up" ) || ( skind_macd_mkt=="up" && skind_rsi_mkt!="up") )
                    {
                        skmkt_movement_anyup=True;
                    }

                if( (skind_rsi_mkt=="down" && skind_macd_mkt!="down" ) || ( skind_macd_mkt=="down" && skind_rsi_mkt!="down") )
                    {
                        skmkt_movement_anydown=True;
                    }
        
            skmkt_movement_prev=skmkt_movement;
            skmkt_movement=skind_rsi_mkt;
            return(1);

        }
    void print_mkt_info_for_symbol()
        {
            Print("MODE_LOTSIZE = ", MarketInfo(Symbol(), MODE_LOTSIZE));
            Print("MODE_MINLOT = ", MarketInfo(Symbol(), MODE_MINLOT));
            Print("MODE_LOTSTEP = ", MarketInfo(Symbol(), MODE_LOTSTEP));
            Print("MODE_MAXLOT = ", MarketInfo(Symbol(), MODE_MAXLOT));
        }
// New Orders opening  functions 
    bool check_buy_conditions()
        {
            bool buy_0=True,buy_1;

            if(buysellstrategy==1)
                if(Open[1]<ma && Close[1]>ma)
                    buy_1=True;
            if(buysellstrategy==2)
                if(Close[1]>smax)
                    buy_1=True;
            return(buy_0 || buy_1);
        }

    bool check_sell_conditions()
        {
            bool sell_0=True,sell_1;
            if(buysellstrategy==1)
                if(Open[1]>ma && Close[1]<ma)
                    sell_1=True;
            if(buysellstrategy==2)
                if(Close[1]<smin)
                    sell_1=True;

            return(sell_0 && sell_1);
        }

    void neworder_start_if_no_orders(string whichorder)
        {
            if(CalculateCurrentOrders("all")==0 && is_spread_ok("NEWORDER") )
                if( whichorder=="buy" || whichorder=="sell"  || whichorder=="buysell"  )
                    {
                        int ticket=0;
                        start_balance=getequity();
                        sklevel_start_price=skprice;

                        sklevel_up_value=skprice+(skpoints_gap_between_orders*pointstousd)*0.2;
                        sklevel_down_value=skprice-(skpoints_gap_between_orders*pointstousd)*0.2;
                        skdebug("Going to open Fresh orders of "+whichorder+" spreadsize="+spreadsize,dbgcheck1);

                        sklevel_current=0;
                        double buy_lots=lotsize_in_direction;
                        double sell_lots=lotsize_in_support;

                        //if(!skpoints_gap_between_orders_auto) skpoints_gap_between_orders=skpoints_gap_between_orders_input;
                        skpoints_gap_between_orders=skpoints_gap_between_orders_input;

                        if(whichorder=="buy")
                            ticket=OpenPosition(Symbol(), OP_BUY, buy_lots, 0, 0, MagicNumber,make_order_comment("buy"));

                        if(whichorder=="sell")
                            ticket=OpenPosition(Symbol(), OP_SELL, sell_lots, 0, 0, MagicNumber,make_order_comment("sell"));
                        if(whichorder=="buysell")
                        {
                            ticket=OpenPosition(Symbol(), OP_BUY, buy_lots, 0, 0, MagicNumber,make_order_comment("buy"));
                            // wait for few seconds before sending next order 
                            Sleep(sleeptimebetween_simultaneous_orders);
                            ticket=OpenPosition(Symbol(), OP_SELL, sell_lots, 0, 0, MagicNumber,make_order_comment("sell"));
                        }
                        if(ticket>0)
                            skdebug("Success : Fresh orders open of  "+whichorder,dbgcheck1);
                            else
                            skdebug("Failed : Fresh orders open for "+whichorder+myerrmsg(),dbgcheck1);
                    //new_counts++;
                    //draw_vline("profit_count"+new_counts+" "+getequity(),skprice,clrLime,3);

                    }
        }

    void neworder_adhoc(string whichorder)
        {
            int ticket=0;
            skdebug("Going to open ADHOC orders to "+whichorder+" size="+Lots,dbgcheck1);

            if(whichorder=="buy")
                ticket=OpenPosition(Symbol(), OP_BUY, Lots, 0, 0, MagicNumber,"adhoc_buy");

            if(whichorder=="sell")
                ticket=OpenPosition(Symbol(), OP_SELL, Lots, 0, 0, MagicNumber,"adhoc_sell");
            if(whichorder=="buysell")
                {
                    ticket=OpenPosition(Symbol(), OP_BUY, Lots, 0, 0, MagicNumber,"adhoc_buy");
                    // wait for few seconds before sending next order 
                    Sleep(sleeptimebetween_simultaneous_orders);
                    ticket=OpenPosition(Symbol(), OP_SELL, Lots, 0, 0, MagicNumber,"adhoc_sell");
                }
            if(ticket>0)
                skdebug("Success : ADHOC orders open of  "+whichorder,dbgcheck1);
                else
                skdebug("Failed : ADHOC orders open for "+whichorder+myerrmsg(),dbgcheck1);

        }

    string make_order_comment(string whichone)
        {   
            string direction="down";
            if(sklevel_current > sklevel_prev)
                direction="up";
            //if(sklevel_current>=0) direction="up";
            string returnvalue=(whichone+"_level_"+sklevel_current+"_"+direction);
            if(special_comment!="none")
            {
                returnvalue+="_"+special_comment;
                special_comment="none";
            }
            skdebug("created comment="+returnvalue,dbgcheck2);
            return(returnvalue);

        }
    string make_order_comment_prevlevel(string whichone)
        {   
            string direction="down";
            if(sklevel_current>=0) direction="up";
            string returnvalue=(whichone+"_level_"+sklevel_prev+"_"+direction);
            if(special_comment!="none")
            {
                returnvalue+="_"+special_comment;
                special_comment="none";
            }
            skdebug("created comment="+returnvalue,dbgcheck2);
            return(returnvalue);

        }
    int balance_new_order_with_old(string whichorder,double lotsize2)
        {
            int ticketnumber=0;
            lotsize2=MathMin(lotsize2,Lots*maxlot_size_multiply);
            return(lotsize2);

        }
    int skneworder(string whichorder,double lotsize2,string skcomment)
        {
            int ticketnumber=0;
            lotsize2=MathMin(lotsize2,Lots*maxlot_size_multiply);
            if(maxlots > CalculateCurrentOrders("all"))
                {
                    if(( whichorder=="buy" || whichorder=="both" ) )
                        {
                           ResetLastError();
                            ticketnumber=OpenPosition(Symbol(), OP_BUY, lotsize2, 0, 0, MagicNumber,skcomment);
                            if(ticketnumber>0)
                                skdebug(" Success opening buy order:Lots="+lotsize2+" comment="+skcomment+" spread="+spreadsize,dbgcheck1);
                            else
                                skdebug(" Failed opening buy order:Lots="+lotsize2+" comment="+skcomment,dbgerr);
                            
                        }

                    // wait for few seconds before sending next order 
                    if(whichorder=="both") Sleep(sleeptimebetween_simultaneous_orders);

                    if( ( whichorder=="sell" || whichorder=="both" ) )
                        {
                            ticketnumber=OpenPosition(Symbol(), OP_SELL, lotsize2, 0, 0, MagicNumber,skcomment);
                            if(ticketnumber>0)
                                skdebug(" Success opening sell order:Lots="+lotsize2+" comment="+skcomment+" spread="+spreadsize,dbgcheck1);
                            else
                                skdebug(" Failed opening sell order:Lots="+lotsize2+" comment="+skcomment,dbgerr);
                        }
                }
            return(ticketnumber);
        }

    int skneworder_with_conditions(string whichorder,double lotsize2,string skcomment)
        {
            int ticketnumber=0;
                // set buy sell conditions  
                    bool pointsgap_up=(skprice-last_order_price) >= 2*skpoints_gap_between_orders*pointstousd;
                    bool pointsgap_down=(last_order_price-skprice) >= 2*skpoints_gap_between_orders*pointstousd;
                    string buy_cond1_n="ma"; bool buy_cond1=(Open[1]<ma && Close[1]>ma) && check_input(buysell_conditions,",ma,");
                    string buy_cond2_n="smax"; bool buy_cond2=(Close[1]>smax) && check_input(buysell_conditions,",smax,");
                    string buy_cond3_n="gapupbuy"; bool buy_cond3=pointsgap_up && check_input(buysell_conditions,",gapupbuy,");
                    string buy_cond4_n="gapdownbuy"; bool buy_cond4=pointsgap_down && check_input(buysell_conditions,",gapdownbuy,");
                    string buy_cond5_n="zoneswitched"; bool buy_cond5=zone_switched!="none" && check_input(buysell_conditions,",zoneswitched,");
                    string buy_cond6_n="anyup"; bool buy_cond6=skmkt_movement_anyup && check_input(buysell_conditions,",anyup,");
                    string buy_cond7_n="rsiup"; bool buy_cond7=skind_rsi_mkt=="up" && check_input(buysell_conditions,",rsiup,");
                    string buy_cond8_n="macdup"; bool buy_cond8=skind_macd_mkt=="up" && check_input(buysell_conditions,",macdup,");
                    

                    string sell_cond1_n="ma"; bool sell_cond1=(Open[1]>ma && Close[1]<ma && check_input(buysell_conditions,",ma,"));
                    string sell_cond2_n="smin"; bool sell_cond2=(Close[1]<smin) && check_input(buysell_conditions,",smin,");
                    string sell_cond3_n="gapupsell"; bool sell_cond3=pointsgap_up && check_input(buysell_conditions,",gapupsell,");
                    string sell_cond4_n="gapdownsell"; bool sell_cond4=pointsgap_down && check_input(buysell_conditions,",gapdownsell,");
                    string sell_cond5_n="zoneswitched"; bool sell_cond5=zone_switched!="none" && check_input(buysell_conditions,",zoneswitched,");
                    string sell_cond6_n="anydown"; bool sell_cond6=skmkt_movement_anydown && check_input(buysell_conditions,",anydown,");
                    string sell_cond7_n="rsidown"; bool sell_cond7=skind_rsi_mkt=="down" && check_input(buysell_conditions,",rsidown,");
                    string sell_cond8_n="macddown"; bool sell_cond8=skind_macd_mkt=="down" && check_input(buysell_conditions,",macddown,");

                    skdebug("new order try for "+whichorder+" gap="+MathAbs(int(skprice-last_order_price)) + " last price="+last_order_price,dbgcheck2);
                    skdebug("buycond|"+buy_cond1_n+buy_cond1+" |2="+buy_cond2+" |3="+buy_cond3+" |4="+buy_cond4+" |5="+buy_cond5+" |6="+buy_cond6+" |7="+buy_cond7+" |8="+buy_cond8,dbgcheck2);
                    skdebug("sellcond|1="+sell_cond1+" |2="+sell_cond2+" |3="+sell_cond3+" |4="+sell_cond4+" |5="+sell_cond5+" |6="+sell_cond6+" |7="+sell_cond7+" |8="+sell_cond8,dbgcheck2);
                    skdebug("gapup="+pointsgap_up+"|gapdown="+pointsgap_down+" |Needed ="+(skpoints_gap_between_orders*pointstousd)+"|gapok="+pointsgap_ok_from_lastorder_open,dbgcheck2);
                    skdebug("gapok="+pointsgap_ok_from_lastorder_open+" |OrdersTotal="+CalculateCurrentOrders("all")+" |maxlot="+maxlots,dbgcheck2);

            //if(OrdersTotal()<maxlots && (pointsgap_ok_from_lastorder_open ) )
            if(pointsgap_ok_from_lastorder_open  )
                {
                    if(CalculateCurrentOrders("buy")<=maxlots/2 && ( whichorder=="buy" || whichorder=="both" ) )
                    if(buy_cond1 || buy_cond2 || buy_cond3 || buy_cond4  || buy_cond5 || buy_cond6 || buy_cond7 || buy_cond8 )
                        {
                            //skdebug("will buy due to cond1="+buy_cond1+"|cond2="+buy_cond2+"|gapup="+pointsgap_up+"| gapdown="+pointsgap_down+"|zonesw="+zone_switched+" | gap="+pointsgap_ok_from_lastorder_open,dbgcheck1 );
                            skdebug("will buy due to cond "+buy_cond1_n+equal+buy_cond1+space+buy_cond2_n+equal+buy_cond2+space+buy_cond3_n+equal+buy_cond3+space+buy_cond4_n+equal+buy_cond4+space+buy_cond5_n+equal+buy_cond5+space+buy_cond6_n+equal+buy_cond6+space+buy_cond7_n+equal+buy_cond7+space+buy_cond8_n+equal+buy_cond8,dbgcheck1 );
                            ticketnumber=OpenPosition(Symbol(), OP_BUY, lotsize2, 0, 0, MagicNumber,make_order_comment("buy"));
                            //if(ticketnumber) last_order_price=skprice;
                        skdebug("pointsgap_up skprice="+skprice+"|lastorderprice="+last_order_price+"|point="+pointstousd+"|diff="+(skprice-last_order_price)+"|vs ="+(2*skpoints_gap_between_orders*pointstousd)+"just gap="+MathAbs(skprice-last_order_price)+" vs "+(skpoints_gap_between_orders*pointstousd),dbgcheck2);
                        }

                    // wait for few seconds before sending next order 
                    if(whichorder=="both") Sleep(sleeptimebetween_simultaneous_orders);

                    if(CalculateCurrentOrders("sell")<=maxlots/2 && ( whichorder=="sell" || whichorder=="both" ) )
                    if(sell_cond1 || sell_cond2 || sell_cond3 || sell_cond4 || sell_cond5 || sell_cond6 || sell_cond7 || sell_cond8)
                        {
                            //skdebug("will sell due to  cond1="+sell_cond1+"|cond2="+sell_cond2+"|gapup="+pointsgap_up+"|gapdown="+pointsgap_down+"|zonesw="+zone_switched+" | gap="+pointsgap_ok_from_lastorder_open,dbgcheck1);
                            skdebug("will sell due to cond "+sell_cond1_n+equal+sell_cond1+space+sell_cond2_n+equal+sell_cond2+space+sell_cond3_n+equal+sell_cond3+space+sell_cond4_n+equal+sell_cond4+space+sell_cond5_n+equal+sell_cond5+space+sell_cond6_n+equal+sell_cond6+space+sell_cond7_n+equal+sell_cond7+space+sell_cond8_n+equal+sell_cond8,dbgcheck1 );
                            ticketnumber=OpenPosition(Symbol(), OP_SELL, lotsize2, 0, 0, MagicNumber,make_order_comment("sell"));
                            //if(ticketnumber) last_order_price=Bid;
                        skdebug("pointsgap_up skprice="+skprice+"|lastorderprice="+last_order_price+"|point="+pointstousd+"|diff="+(skprice-last_order_price)+"|vs ="+(2*skpoints_gap_between_orders*pointstousd)+"just gap="+MathAbs(skprice-last_order_price)+" vs "+(skpoints_gap_between_orders*pointstousd),dbgcheck2);
                        }
                    zone_switched="none";
                }
            return(ticketnumber);
        }

    void buy_sell_based_on_mkt_movements()
        {

            if( ( skmkt_movement=="up" && check_input(whentosqoff,"mktup"))
                || (skind_rsi_mkt=="up" && check_input(whentosqoff,"rsiup"))
                || (skind_macd_mkt=="up" && check_input(whentosqoff,"macdup"))
                )
                if(closed_all_once!="up")
                    if(CalculateCurrentOrders("sell")>0)  
                    {
                        closeall_orders("sell","buy_sell_based_on_mkt_movements for sell ");
                        skdebug("mkt UP so close sell orders mkt="+skmkt_movement+"| live="+skmkt_movement_live+
                                "| rsi="+skind_rsi_mkt+"| macd="+skind_macd_mkt,dbgcheck2);
                        closed_all_once="up";
                    }

            if( (skmkt_movement=="down" && check_input(whentosqoff,"mktdown"))
                || (skind_rsi_mkt=="down" && check_input(whentosqoff,"rsidown"))
                || (skind_macd_mkt=="down" && check_input(whentosqoff,"macddown"))
                )
                if(closed_all_once!="down")
                    if(CalculateCurrentOrders("buy")>0)  
                    {
                        closeall_orders("buy","buy_sell_based_on_mkt_movements buy");
                        skdebug("mkt down close buy orders mkt="+skmkt_movement+"| live="+skmkt_movement_live+
                                "| rsi="+skind_rsi_mkt+"| macd="+skind_macd_mkt,dbgcheck1);
                        closed_all_once="down";
                    }

            if( ( skmkt_movement=="zigzag" && check_input(whentosqoff,"mktzigzag"))
                || (skind_rsi_mkt=="zigzag" && check_input(whentosqoff,"rsizigzag"))
                )
                if(CalculateCurrentOrders("all")>0)  
                {
                    closeall_orders("all","buy_sell_based_on_mkt_movements all");
                    skdebug("mkt zigzag close all orders mkt="+skmkt_movement+"| live="+skmkt_movement_live+
                            "| rsi="+skind_rsi_mkt+"| macd="+skind_macd_mkt,dbgcheck2);
                    closed_all_once="zigzag";
                }

            if( ( skmkt_movement=="up" && check_input(whentobuy,"mktup"))
                || (skind_rsi_mkt=="up" && check_input(whentobuy,"rsiup"))
                || (skind_macd_mkt=="up" && check_input(whentobuy,"macdup"))
                || (skmkt_movement=="down" && check_input(whentobuy,"mktdown"))
                || (skind_rsi_mkt=="down" && check_input(whentobuy,"rsidown"))
                || (skind_macd_mkt=="down" && check_input(whentobuy,"macddown"))
                )
                    {
                        skdebug("inside buyzone",dbgcheck2);
                        skneworder("buy",lotsize_to_execute_buy,"skraj_quickup")  ;    
                    }

            if( ( skmkt_movement=="up" && check_input(whentosell,"mktup"))
                || (skind_rsi_mkt=="up" && check_input(whentosell,"rsiup"))
                || (skind_macd_mkt=="up" && check_input(whentosell,"macdup"))
                || (skmkt_movement=="down" && check_input(whentosell,"mktdown"))
                || (skind_rsi_mkt=="down" && check_input(whentosell,"rsidown"))
                || (skind_macd_mkt=="down" && check_input(whentosell,"macddown"))
                )
                    {
                        skdebug("inside sellzone",dbgcheck2);
                        skneworder("sell",lotsize_to_execute_sell,"skraj_quickdown")  ;    
                    }

            if( ( skmkt_movement=="up" && check_input(whentobuysell,"mktup"))
                || (skind_rsi_mkt=="up" && check_input(whentobuysell,"rsiup"))
                || (skind_macd_mkt=="up" && check_input(whentobuysell,"macdup"))
                || (skmkt_movement=="down" && check_input(whentobuysell,"mktdown"))
                || (skind_rsi_mkt=="down" && check_input(whentobuysell,"rsidown"))
                || (skind_macd_mkt=="down" && check_input(whentobuysell,"macddown"))
                || (skmkt_movement=="zigzag" && check_input(whentobuysell,"mktzigzag"))
                || (skind_rsi_mkt=="zigzag" && check_input(whentobuysell,"rsizigzag"))
                )
                    {
                        skdebug("inside zigzag",dbgcheck2);
                        skneworder("both",lotsize_to_execute,"skraj_bothside")  ;    
                    }
        }


    int split_string_to_array_splitresult(string tosplit,string sep)
        {
                //string to_split=tosplit;   // A string to split into substrings 
                //string sep=",";                // A separator as a character 
                ushort u_sep;                  // The code of the separator character 
                u_sep=StringGetCharacter(sep,0); 
                int count=StringSplit(tosplit,u_sep,splitresult); 
                return(count);

        }

    double find_good_gap(int howmanybars)
        {
        
            double return_value=High[iHighest(NULL,0,MODE_HIGH,howmanybars,1)]-Low[iLowest(NULL,0,MODE_LOW,howmanybars,1)];
            return(return_value);
            
        }
    void automanage_gap()
        {
                    mygap=(inr_gap_between_orders_input)*usdtopoints;
                    if(check_input(buysell_conditions,",dynamicgap,"))
                        //mygap=inr_gap_between_orders_input*usdtopoints*(1+CalculateCurrentOrders("all")/2);
                        //mygap=inr_gap_between_orders_input*usdtopoints*(1+MathMod(CalculateCurrentOrders("all"),6));
                        mygap=MathMax((inr_gap_between_orders_input)*usdtopoints,(find_good_gap(10)*1.5));
                    if(check_input(buysell_conditions,",dynamicgapwithcap3,"))
                        mygap=MathMin(mygap*3,MathMax((inr_gap_between_orders_input)*usdtopoints,(find_good_gap(10)*1.5)));
        }
  
    void automanage_money()
        {
            //skpoints_gap_between_orders
                //for odd square 5 lots of .01  needed minimum . 
                //upto 2 orders 5  lots = 15usd
                // upto 3 orders 14 lots 1 4 9 = 14 lots  = 45 usd 
                //upto 4 orders 1 4 9 16 = 30 lots . = 90 usd 
                //upto 5 orders 1 4 9 16 25 = 55 lots = 150 usd
                //for .01 money needed = 3 usd . so money needed = 15 usd . go ahead with 20 itself .
                //so  for .01 lot 15 usd needed  
                {
                    int skmoney=AccountFreeMargin();
                    if(lots_to_start<0)
                        lots_to_start=MathMin(maxlot_size_multiply,double(int(skmoney/(3*30)) *.01 ));

                    // if(skmoney>0 && skmoney<=500) lots_to_start=.01; 
                    // if(skmoney>500 && skmoney<=1000) lots_to_start=.03; 
                    // if(skmoney>1000 && skmoney<=2000) lots_to_start=.07; 
                    // if(skmoney>2000 && skmoney<=5000)   lots_to_start=.1;
                    // if(skmoney>5000 && skmoney<=10000)    lots_to_start=.3; 
                    // if(skmoney>10000 )                  lots_to_start=.7; 
                    
                    //lots_to_start=double(int(skmoney/(3*50)) *.01 );

                    if(closeall_if_profit_inr_input<0)
                    //closeall_if_profit_inr=(inr_gap_between_orders_input-spreadsize)*(lots_to_start/.01)*0.9;
                    //closeall_if_profit_inr=(inr_gap_between_orders_input-spreadsize)*(lots_to_start/.01)*0.5*((buy_lots_total+sell_lots_total)/lots_to_start);
                    closeall_if_profit_inr=min_equity_profit+(inr_gap_between_orders_input-spreadsize)*(lots_to_start/.01)*0.5*(last_order_size/lots_to_start);
                    
                    //skdebug("automange:lots_to_start="+lots_to_start+" closeall_if_profit_inr="+closeall_if_profit_inr,dbgexplore);

                }


        }
    void buy_sell_with_maonly()
        {
            split_string_to_array_splitresult(skma_inputs,",");
            
            double  ma1=iMA(NULL,1,splitresult[0],1,MODE_SMA,PRICE_CLOSE,0);
            double  ma2=iMA(NULL,1,splitresult[1],1,MODE_SMA,PRICE_CLOSE,0);
            double  ma3=iMA(NULL,1,splitresult[2],1,MODE_SMA,PRICE_CLOSE,0);
            double  ma4=iMA(NULL,1,splitresult[3],1,MODE_SMA,PRICE_CLOSE,0);
            double  ma5=iMA(NULL,1,splitresult[4],1,MODE_SMA,PRICE_CLOSE,0);

            skdebug("last ma input values="+splitresult[4],dbgcheck2);
            double lotsize3_buy=MathMax(Lots,sell_lots_total);
            double lotsize3_sell=MathMax(Lots,buy_lots_total);
            string skcomment="skraj_new";
            if(lastorder!="buy")
            //if(ma1> ma2 && ma1>ma2 && ma1>ma3 && ma1>ma4)
            if(ma1> ma2 && ma3>ma4 )
                {
                    skneworder("buy",lotsize3_buy,skcomment);
                    lastorder="buy";
                }
            if(lastorder!="sell")
            if(ma1< ma2 && ma3<ma4)
                {
                    skneworder("sell",lotsize3_sell,skcomment);
                    lastorder="sell";
                }

           
            
        }
    void order_based_on_pattern(int skordernumber)
        {

                    string gotstring=splitresult[skordernumber];
                    string gotstring_action=StringSubstr(gotstring,0,1);
                    string gotstring_lotsize=StringSubstr(gotstring,1,StringLen(gotstring));
                    string action="none";
                    bool use_first_order_conditions=False;
                    if(gotstring_action=="b") action="buy";
                    if(gotstring_action=="s") action="sell";
                    if(gotstring_action=="c") 
                        {
                            use_first_order_conditions=True;                                
                        }
                    if(gotstring_action=="o") 
                        {
                            pacifier_order=1;
                            if(last_order_type==OP_SELL)
                                action="buy";
                            if(last_order_type==OP_BUY)
                                action="sell";
                                
                        }
                    if(gotstring_action=="d") 
                        {
                            if(skprice>last_order_price)
                                action="buy";
                            if(skprice<last_order_price)
                                action="sell";
                                
                        }
                    if(gotstring_action=="r") 
                        {
                            if(skprice<last_order_price)
                                action="buy";
                            if(skprice>last_order_price)
                                action="sell";
                                
                        }
                        bool   action_taken=False;
                    
                    //double lotsize4=lots_to_start*int(gotstring_lotsize);
                    double lotsize4=lots_to_start+Lots*int(gotstring_lotsize);
                    string skcomment="skraj_"+action+NormalizeDouble(lotsize4,3);

                //if(CalculateCurrentOrders("all") ==2)
                   // closeall_if_profit_inr=(inr_gap_between_orders_input-spreadsize)*(lots_to_start/.01)/3; 
               //if(CalculateCurrentOrders("all") >=3)
                    //closeall_if_profit_inr=.001;


                    skdebug("inside order_based_on_pattern orders="+skordernumber+" action="+action+" lotsize4="+lotsize4+" gap="+mygap+" vs="+MathAbs(Ask-last_order_price),dbgcheck2);
                    if( use_first_order_conditions || ( check_input(buysell_conditions,",firstwith_") && CalculateCurrentOrders("all")==0 ) )
                        {
                            //action="none";
                            //be serious about first order and you will win 
                            //action=buy_sell_with_manew_only();
                            if(check_input(buysell_conditions,",firstwith_magapmanew,"))
                                {
                                    if( magap_up1 && buy_sell_with_manew_only()=="buy" )
                                        action="buy";
                                    if( magap_down1 && buy_sell_with_manew_only()=="sell" )
                                        action="sell";
                                }
                            if(check_input(buysell_conditions,",firstwith_skmix1,"))
                                {
                                    int current_orders=CalculateCurrentOrders("all");
                                    int change_after_orders=1;
                                    if(MathMod(current_orders/change_after_orders,2)==0 )
                                        {
                                            if( SKMIX1_Signal_up==1 )
                                                action="sell";
                                            if( SKMIX1_Signal_down==1 )
                                                action="buy";
                                        }
                                    if(MathMod(current_orders/change_after_orders,2)==1)
                                        {
                                            if( SKMIX1_Signal_up==1 )
                                                action="buy";
                                            if( SKMIX1_Signal_down==1 )
                                                action="sell";
                                        }

                                }
                            if(check_input(buysell_conditions,",firstwith_manew,"))
                                {
                                    if( buy_sell_with_manew_only()=="buy" )
                                        action="buy";
                                    if( buy_sell_with_manew_only()=="sell" )
                                        action="sell";
                                }
                            if(check_input(buysell_conditions,",firstwith_direction5,"))
                                {
                                    
                                    double last_higher_price=iHighest(NULL,0,MODE_HIGH,5,1);
                                    double last_lower_price=iLowest(NULL,0,MODE_LOW,5,1);
                                    if( skprice >  last_higher_price )
                                        action="buy";
                                    if( skprice < last_lower_price )
                                        action="sell";
                                }
                            if(check_input(buysell_conditions,",firstwith_manewrsi,"))
                                {
                                    if( skind_rsi_mkt=="up" && buy_sell_with_manew_only()=="buy" )
                                        action="buy";
                                    if( skind_rsi_mkt=="down" && buy_sell_with_manew_only()=="sell" )
                                        action="sell";
                                }
                            if(check_input(buysell_conditions,",firstwith_rsi,"))
                                {
                                    if(skind_rsi_mkt!="zigzag")
                                        action=skind_rsi_action;
                                }
                            if(check_input(buysell_conditions,",firstwith_rsizigzag,"))
                                {
                                    
                                    if(skind_rsi_currentvalue<10 
                                        || ( skind_rsi_currentvalue>skrsi_uplevel && skind_rsi_currentvalue<90 ) 
                                        //|| ( skind_rsi_currentvalue<50 && skind_rsi_currentvalue>skrsi_downlevel )
                                        || ( skind_rsi_currentvalue>50 && skind_rsi_currentvalue<90 )
                                        )
                                        {
                                            action="buy";
                                        }
                                    if(skind_rsi_currentvalue>90 
                                        || ( skind_rsi_currentvalue<skrsi_downlevel && skind_rsi_currentvalue>10 ) 
                                        //|| ( skind_rsi_currentvalue>50 && skind_rsi_currentvalue<skrsi_uplevel )
                                        || ( skind_rsi_currentvalue<50 && skind_rsi_currentvalue>10 )
                                        )
                                        {
                                            action="sell";
                                        }
                                    
                                }
                            if(check_input(buysell_conditions,",firstwith_rsi_zigzag_manew,"))
                                {
                                    if( skind_rsi_mkt=="up" )
                                        action="buy";
                                    if( skind_rsi_mkt=="down" )
                                        action="sell";
                                    if( skind_rsi_mkt=="zigzag" && buy_sell_with_manew_only()=="sell" )
                                        action="buy";
                                    if( skind_rsi_mkt=="zigzag" && buy_sell_with_manew_only()=="buy" )
                                        action="sell";
                                }
                            if(check_input(buysell_conditions,",firstwith_manewrsimacd,"))
                                {
                                    if( skind_macd_mkt=="up" && skind_rsi_mkt=="up" && buy_sell_with_manew_only()=="buy" )
                                        action="buy";
                                    if( skind_macd_mkt=="down" &&  skind_rsi_mkt=="down" && buy_sell_with_manew_only()=="sell" )
                                        action="sell";
                                }
                            if(check_input(buysell_conditions,",firstwith_macd,"))
                                {
                                    if( skind_macd_mkt=="up" )
                                        action="buy";
                                    if( skind_macd_mkt=="down" )
                                        action="sell";
                                }
                            if(check_input(buysell_conditions,",firstwith_adi,"))
                                {
                                    if( buy_sell_with_adionly()=="buy" )
                                        action="buy";
                                    if( buy_sell_with_adionly()=="sell" )
                                        action="sell";
                                }
                            if(check_input(buysell_conditions,",firstwith_adirsi,"))
                                {
                                    if( skind_rsi_mkt=="up" && buy_sell_with_adionly()=="buy" )
                                        action="buy";
                                    if( skind_rsi_mkt=="down" && buy_sell_with_adionly()=="sell" )
                                        action="sell";
                                }
                            if(check_input(buysell_conditions,",firstwith_adimanew,"))
                                {
                                    if( buy_sell_with_manew_only()=="buy" && buy_sell_with_adionly()=="buy" )
                                        action="buy";
                                    if( buy_sell_with_manew_only()=="sell" &&  buy_sell_with_adionly()=="sell" )
                                        action="sell";
                                }
                            if(check_input(buysell_conditions,",firstwith_adimanewrsi,"))
                                {
                                    if( skind_rsi_mkt=="up" && buy_sell_with_manew_only()=="buy" && buy_sell_with_adionly()=="buy" )
                                        action="buy";
                                    if( skind_rsi_mkt=="down" && buy_sell_with_manew_only()=="sell" &&  buy_sell_with_adionly()=="sell" )
                                        action="sell";
                                }
                            
                            //skneworder(action,lotsize4,skcomment);
                            action_taken=False;
                        }
                    
                    if( CalculateCurrentOrders("all")==1 && check_input(buysell_conditions,",trytoclose_1,") )
                        {
                            //lotsize4=lots_to_start+Lots*4;
                            lotsize4=last_order_size*3;
                            if( MathAbs(skprice-last_order_price) > (mygap))
                                if(  (action=="buy" && (check_input(buysell_conditions,",allorder_withrsi,")==False || skind_rsi_mkt=="up" ) ) 
                                    || ( action=="sell" && (check_input(buysell_conditions,",allorder_withrsi,")==False || skind_rsi_mkt=="down" )  ) 
                                    )
                                skneworder(action,lotsize4,skcomment);
                            action_taken=True;
                        }
                    if( CalculateCurrentOrders("all")==2 && check_input(buysell_conditions,",trytoclose_2,"))
                        {
                            //lotsize4=lots_to_start+Lots*10;
                            lotsize4=last_order_size*3;
                            if( MathAbs(skprice-last_order_price) > (mygap))
                                if(  (action=="buy" && (check_input(buysell_conditions,",allorder_withrsi,")==False || (skind_rsi_mkt=="up") ) ) 
                                    || ( action=="sell" && (check_input(buysell_conditions,",allorder_withrsi,")==False || (skind_rsi_mkt=="down") )  ) 
                                    )
                                skneworder(action,lotsize4,skcomment);
                            action_taken=True;



                        }
                    if (  CalculateCurrentOrders("all")==3 && check_input(buysell_conditions,",trytoclose_3,") ) 
                        {
                            //lotsize4=lots_to_start+Lots*10;
                            lotsize4=last_order_size*3;
                            if( MathAbs(skprice-last_order_price) > (mygap))
                                if(  (action=="buy" && (check_input(buysell_conditions,",allorder_withrsi,")==False || (skind_rsi_mkt=="up") ) ) 
                                    || ( action=="sell" && (check_input(buysell_conditions,",allorder_withrsi,")==False || (skind_rsi_mkt=="down") )  ) 
                                    )
                                skneworder(action,lotsize4,skcomment);
                            action_taken=True;
                        }
                    if (  ( MathMod( CalculateCurrentOrders("all"),10)==0 )  && check_input(buysell_conditions,",trytoclose_10,") ) 
                            {
                                //lotsize4=lots_to_start+Lots*10;
                                if(action=="buy")
                                    action="sell";
                                else if ( action=="sell")
                                        action="buy";

                                lotsize4=MathMax(buy_lots_total,sell_lots_total);
                                if( MathAbs(skprice-last_order_price) > (mygap))
                                    if(  (action=="buy" && (check_input(buysell_conditions,",allorder_withrsi,")==False || (skind_rsi_mkt=="up") ) ) 
                                        || ( action=="sell" && (check_input(buysell_conditions,",allorder_withrsi,")==False || (skind_rsi_mkt=="down") )  ) 
                                        )
                                    skneworder(action,lotsize4,skcomment);
                                action_taken=True;
                            }
                        
                    // now to buy sell based on actions . 
                    //if(skind_rsi_mkt=="up" || skind_rsi_mkt=="down")
                    if(action_taken==False)
                    if((check_input(buysell_conditions,",notinloop,")==False || is_between_last_two_orders()==False || gotstring_action=="o" || CalculateCurrentOrders("all")==0 ))
                        {
                            if(action=="buy" && (check_input(buysell_conditions,",allorder_withrsi,")==False || (skind_rsi_mkt=="up") ) )
                            if(action=="buy" && (check_input(buysell_conditions,",allorder_withmacd,")==False || (skind_macd_mkt=="up") ) )
                            if(action=="buy" && (check_input(buysell_conditions,",allorder_withmanew,")==False || (buy_sell_with_manew_only()=="buy") ) )
                                if( MathAbs(Bid-last_order_price) > (mygap) || check_input(buysell_conditions,",nogapcheck,") || CalculateCurrentOrders("all")==0 )
                                    {
                                        skneworder(action,lotsize4,skcomment);
                                    }
                            if(action=="sell" && (check_input(buysell_conditions,",allorder_withrsi,")==False || (skind_rsi_mkt=="down") ))
                            if(action=="sell" && (check_input(buysell_conditions,",allorder_withmacd,")==False || (skind_macd_mkt=="down") ) )
                            if(action=="sell" && (check_input(buysell_conditions,",allorder_withmanew,")==False || (buy_sell_with_manew_only()=="sell") ) )
                                if( MathAbs(Ask-last_order_price) > (mygap) || check_input(buysell_conditions,",nogapcheck,")  || CalculateCurrentOrders("all")==0 )
                                    {
                                        skneworder(action,lotsize4,skcomment);
                                    }
                        }


        }
    void make_pattern_based_on_money()
        {

            string controlled_pattern="";
            string extra_pattern="d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1";
            //string extra_pattern="";
            int skmoney=AccountFreeMargin();

            if(check_input(lotsize_increase_input,",13612,"))
                {
                    if(skmoney>0 && skmoney<=20) controlled_pattern="b1,s3,b2"; // 6 = 12
                    if(skmoney>20 && skmoney<=50) controlled_pattern="b1,s3,b6,s4"; // 14 = 30
                    if(skmoney>50 && skmoney<=100) controlled_pattern="b1,s3,b6,s12,b8"; // 29 = 58
                    if(skmoney>100 && skmoney<=200) controlled_pattern="b1,s3,b6,s12,b24,s16,"; // 62 = 124 
                    if(skmoney>200 && skmoney<=500) controlled_pattern="b1,s3,b6,s12,b24,s48,b32,"; // 126 = 252 
                    if(skmoney>500 && skmoney<=1000) controlled_pattern="b1,s3,b6,s12,b24,s48,b96,s64"; // 254 = 508 
                    if(skmoney>1000 && skmoney<=2000) controlled_pattern="b1,s3,b6,s12,b24,s48,b96,s192,b128"; // 510  = 1020 
                    if(skmoney>2000 && skmoney<=5000)  controlled_pattern="b1,s3,b6,s12,b24,s48,b96,s192,b384,s256"; // 1022  = 2044 
                    if(skmoney>5000 )                   controlled_pattern="b1,s3,b6,s12,b24,s48,b96,s192,b384,s768,b512"; // 2558   = 5116 
                }
            if(check_input(lotsize_increase_input,",pattern_bigsize1,"))
                {
                    controlled_pattern="c100,r100,r100,c300,d300,d300,c1000,o2000"; 

                    for(int i=1;i<=6;i++)
                        controlled_pattern+=controlled_pattern;

                    extra_pattern="d1,d1,d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",pattern_good4,"))
                {
                    controlled_pattern="c1,r2,r6,d6,d10,r15,r22,r23,d40,d42,d44,"; 

                    for(int i=1;i<=4;i++)
                        controlled_pattern+=controlled_pattern;

                    extra_pattern="d1,d1,d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",pattern_good3,"))
                {
                    controlled_pattern="b1,s3,b9,s20,b40,s40,b80,b1,"; 

                    for(int i=1;i<=6;i++)
                        controlled_pattern+=controlled_pattern;

                    extra_pattern="d1,d1,d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",pattern_good2,"))
                {
                    controlled_pattern="b1,s5,b8,s8,b6,s4,b3,s2,b2,s1,b1,"; 

                    for(int i=1;i<=6;i++)
                        controlled_pattern+=controlled_pattern;

                    extra_pattern="d1,d1,d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",pattern_good1,"))
                {
                    controlled_pattern="b1,s15,s1,b5,b4,b3,b2,b1,b1,b1,b1,b1,b1,s1,b1,"; 

                    for(int i=1;i<=6;i++)
                        controlled_pattern+=controlled_pattern;

                    extra_pattern="d1,d1,d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",single_directional,"))
                {
                    controlled_pattern="d1,d1,d1,d1,"; 

                    for(int i=1;i<=10;i++)
                        controlled_pattern+=controlled_pattern;

                    extra_pattern="d1,d1,d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",single_reverse,"))
                {
                    controlled_pattern="r1,r1,r1,r1,"; 

                    for(int i=1;i<=10;i++)
                        controlled_pattern+=controlled_pattern;

                    extra_pattern="d1,d1,d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",downsize_reverse,"))
                {
                    controlled_pattern="r10,r10,r8,r8,r5,r5,r2,r2,r1,r1,"; 

                    for(int i=1;i<=10;i++)
                        controlled_pattern+=controlled_pattern;

                    extra_pattern="d1,d1,d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",132,"))
                {
                    controlled_pattern="b1,s5,b4,"; 

                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;

                    extra_pattern="d1,d1,d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",pacify_123,"))
                {
                    controlled_pattern="c1,o1,c2,o2,c3,o3,"; 

                    for(int i=1;i<=10;i++)
                        controlled_pattern+=controlled_pattern;

                    extra_pattern="d1,d1,d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",pacifiy_multiply1,"))
                {
                    controlled_pattern="";
                    double newlotsize=0,multiplier=1;
                    for(int i=1;i<=100;i++)
                        {
                            newlotsize=1+(newlotsize*multiplier);
                            if(MathMod(i,2)==0)
                                controlled_pattern+="c"+newlotsize+",o"+newlotsize+",";
                            if(MathMod(i,2)!=0)
                                controlled_pattern+="c"+newlotsize+",o"+newlotsize+",";
                        }

                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                
                }
            if(check_input(lotsize_increase_input,",pacifiy_justone,"))
                {
                    controlled_pattern="";
                    double newlotsize=0,multiplier=1;
                    for(int i=1;i<=100;i++)
                        {
                            newlotsize=1;
                            if(MathMod(i,2)==0)
                                controlled_pattern+="c"+newlotsize+",o"+newlotsize+",";
                            if(MathMod(i,2)!=0)
                                controlled_pattern+="c"+newlotsize+",o"+newlotsize+",";
                        }

                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                
                }
            if(check_input(lotsize_increase_input,",pacifiy_bigger,"))
                {
                    controlled_pattern="";
                    if(CalculateCurrentOrders("all")==0)
                        controlled_pattern="c1,c1,c1,c1,c1,";
                    double newlotsize=0,multiplier=1;
                    for(int i=1;i<=40;i++)
                        {
                            //newlotsize=1+(newlotsize*multiplier);
                            if(  last_order_type==OP_SELL )
                                {
                                    if((skprice > last_order_price))
                                        {
                                            newlotsize=int(1+MathAbs((sell_lots_total-buy_lots_total)/Lots));
                                            controlled_pattern+="o"+newlotsize+","; 
                                        }
                                    if((skprice < last_order_price))
                                        {
                                            newlotsize=(last_order_size)/Lots;
                                            newlotsize=1+CalculateCurrentOrders("all");
                                            controlled_pattern+="c"+newlotsize+","; 
                                        }
                                }
                            if(  last_order_type==OP_BUY )
                                {
                                    if((skprice < last_order_price))
                                        {
                                            newlotsize=int(1+MathAbs((sell_lots_total-buy_lots_total)/Lots));
                                            controlled_pattern+="o"+newlotsize+","; 
                                        }
                                    if((skprice > last_order_price))
                                        {
                                            newlotsize=(last_order_size)/Lots;
                                            newlotsize=1+CalculateCurrentOrders("all");
                                            controlled_pattern+="c"+newlotsize+","; 
                                        }
                                }
                        }

                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                    
                }
            if(check_input(lotsize_increase_input,",pacifiy_bigger_single,"))
                {
                    controlled_pattern="";
                    if(CalculateCurrentOrders("all")==0)
                        controlled_pattern="c1,c1,c1,c1,c1,";
                    double newlotsize=0,multiplier=1;
                    for(int i=1;i<=40;i++)
                        {
                            //newlotsize=1+(newlotsize*multiplier);
                            if(  last_order_type==OP_SELL )
                                {
                                    if((skprice > last_order_price))
                                        {
                                            newlotsize=int(MathAbs((sell_lots_total-buy_lots_total-lots_to_start)/Lots));
                                            controlled_pattern+="o"+newlotsize+","; 
                                        }
                                    if((skprice < last_order_price))
                                        {
                                            newlotsize=i;
                                            controlled_pattern+="c"+newlotsize+","; 
                                        }
                                }
                            if(  last_order_type==OP_BUY )
                                {
                                    if((skprice < last_order_price))
                                        {
                                            newlotsize=int(MathAbs((sell_lots_total-buy_lots_total-lots_to_start)/Lots));
                                            controlled_pattern+="o"+newlotsize+","; 
                                        }
                                    if((skprice > last_order_price))
                                        {
                                            newlotsize=i;
                                            controlled_pattern+="c"+newlotsize+","; 
                                        }
                                }
                        }

                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                    
                }
            if(check_input(lotsize_increase_input,",pacifiy_bigger_justone,"))
                {
                    controlled_pattern="";
                    if(CalculateCurrentOrders("all")==0)
                        controlled_pattern="c1,c1,c1,c1,c1,";
                    double newlotsize=0,multiplier=1;
                    for(int i=1;i<=40;i++)
                        {
                            //newlotsize=1+(newlotsize*multiplier);
                            if(  last_order_type==OP_SELL )
                                {
                                    if((skprice > last_order_price))
                                        {
                                            newlotsize=int(1+MathAbs((sell_lots_total-buy_lots_total)/Lots));
                                            controlled_pattern+="o"+newlotsize+","; 
                                        }
                                    if((skprice < last_order_price))
                                        {
                                            newlotsize=1;
                                            controlled_pattern+="c"+newlotsize+","; 
                                        }
                                }
                            if(  last_order_type==OP_BUY )
                                {
                                    if((skprice < last_order_price))
                                        {
                                            newlotsize=int(1+MathAbs((sell_lots_total-buy_lots_total)/Lots));
                                            controlled_pattern+="o"+newlotsize+","; 
                                        }
                                    if((skprice > last_order_price))
                                        {
                                            newlotsize=1;
                                            controlled_pattern+="c"+newlotsize+","; 
                                        }
                                }
                        }

                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                    
                }
            if(check_input(lotsize_increase_input,",pacifiy_bigger_multiply2,"))
                {
                    controlled_pattern="c1,";
                    if(CalculateCurrentOrders("all")==0)
                        controlled_pattern="c1,";
                    double newlotsize=0,multiplier=2;
                    for(int i=1;i<=100;i++)
                        {
                            //newlotsize=1+(newlotsize*multiplier);
                            if(  last_order_type==OP_SELL )
                                {
                                    if((skprice > last_order_price))
                                        {
                                            newlotsize=int(1+MathAbs((sell_lots_total-buy_lots_total)/Lots));
                                            controlled_pattern+="o"+newlotsize+","; 
                                        }
                                    if((skprice < last_order_price))
                                        {
                                            newlotsize=(last_order_size)/Lots;
                                            newlotsize=CalculateCurrentOrders("all")*multiplier;
                                            controlled_pattern+="c"+newlotsize+","; 
                                        }
                                }
                            if(  last_order_type==OP_BUY )
                                {
                                    if((skprice < last_order_price))
                                        {
                                            newlotsize=int(1+MathAbs((sell_lots_total-buy_lots_total)/Lots));
                                            controlled_pattern+="o"+newlotsize+","; 
                                        }
                                    if((skprice > last_order_price))
                                        {
                                            newlotsize=(last_order_size)/Lots;
                                            newlotsize=CalculateCurrentOrders("all")*multiplier;
                                            controlled_pattern+="c"+newlotsize+","; 
                                        }
                                }
                        }

                    for(int i=1;i<=3;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1";
                    
                }
            if(check_input(lotsize_increase_input,",pacifiy_bigger_onesided_multiply3,"))
                {
                    controlled_pattern="c1,";
                    if(CalculateCurrentOrders("all")==0)
                        controlled_pattern="c1,";
                    double newlotsize=0,multiplier=3;
                    for(int i=1;i<=5;i++)
                        {

                            newlotsize=1+(newlotsize*multiplier);
                            controlled_pattern+="r"+newlotsize+",";

                        }
                    int lotsize_p=int(MathAbs((sell_lots_total-buy_lots_total)/Lots));

                    for(int i=1;i<=4;i++)
                        controlled_pattern+="r"+lotsize_p+","+controlled_pattern;

                    extra_pattern="d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1";
                    
                }
            if(check_input(lotsize_increase_input,",bigger_r2d3cpop,"))
                {
                    controlled_pattern="c1,";
                    if(CalculateCurrentOrders("all")==0)
                        controlled_pattern="c1,";
                    double newlotsize=1,multiplier=2;
                    for(int i=1;i<4;i++)
                        {
                            newlotsize=(newlotsize*multiplier);
                            //newlotsize=int(MathAbs((sell_lots_total-buy_lots_total)/Lots)+1);
                            //controlled_pattern+="r"+newlotsize+",";
                            if(MathMod(i,2)==0)
                            controlled_pattern+="d"+newlotsize+",d"+newlotsize+",";
                            if(MathMod(i,2)==1)
                            controlled_pattern+="r"+newlotsize+",r"+newlotsize+",";

                        }
                    int lotsize_p=int(MathAbs((sell_lots_total-buy_lots_total)/Lots));
                    for(int i=1;i<=5;i++)
                        controlled_pattern+="c"+lotsize_p+","+"o"+lotsize_p+","+controlled_pattern;
                        //controlled_pattern+=controlled_pattern;

                    extra_pattern="d1,d1,d1,d1,d1,d1,d1,d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",pacifiy_bigger_d4r4_quivalant,"))
                {
                    controlled_pattern="c1,";
                    if(CalculateCurrentOrders("all")==0)
                        controlled_pattern="c1,";
                    double newlotsize=1,multiplier=2;
                    for(int i=1;i<5;i++)
                        {
                            //newlotsize=(newlotsize*multiplier);
                            newlotsize=int(MathAbs((sell_lots_total-buy_lots_total)/Lots)+1);
                            //controlled_pattern+="r"+newlotsize+",";
                            if(MathMod(i,2)==0)
                            controlled_pattern+="d"+newlotsize+",d"+newlotsize+",d"+newlotsize+",d"+newlotsize+",";
                            if(MathMod(i,2)==1)
                            controlled_pattern+="r"+newlotsize+",r"+newlotsize+",r"+newlotsize+",r"+newlotsize+",";
                        }
                    int lotsize_p=int(MathAbs((sell_lots_total-buy_lots_total)/Lots));
                    for(int i=1;i<=5;i++)
                        //controlled_pattern+="o"+lotsize_p+","+controlled_pattern;
                        controlled_pattern+=controlled_pattern;

                    extra_pattern="d1,d1,d1,d1,d1,d1,d1,d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",pacifiy_bigger_d4r4_multiply2,"))
                {
                    controlled_pattern="c1,";
                    if(CalculateCurrentOrders("all")==0)
                        controlled_pattern="c1,";
                    double newlotsize=1,multiplier=2;
                    for(int i=1;i<5;i++)
                        {
                            newlotsize=(newlotsize*multiplier);
                            //controlled_pattern+="r"+newlotsize+",";
                            if(MathMod(i,2)==0)
                            controlled_pattern+="d"+newlotsize+",d"+newlotsize+",d"+newlotsize+",d"+newlotsize+",";
                            if(MathMod(i,2)==1)
                            controlled_pattern+="r"+newlotsize+",r"+newlotsize+",r"+newlotsize+",r"+newlotsize+",";
                        }
                    int lotsize_p=int(MathAbs((sell_lots_total-buy_lots_total)/Lots));
                    for(int i=1;i<=5;i++)
                        //controlled_pattern+="o"+lotsize_p+","+controlled_pattern;
                        controlled_pattern+=controlled_pattern;

                    extra_pattern="d1,d1,d1,d1,d1,d1,d1,d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",pacifiy_bigger_d3r3_multiply3,"))
                {
                    controlled_pattern="c1,";
                    if(CalculateCurrentOrders("all")==0)
                        controlled_pattern="c1,";
                    double newlotsize=0,multiplier=3;
                    for(int i=1;i<4;i++)
                        {
                            newlotsize=1+(newlotsize*multiplier);
                            //controlled_pattern+="r"+newlotsize+",";
                            if(MathMod(i,2)==0)
                            controlled_pattern+="d"+newlotsize+",d"+newlotsize+",d"+newlotsize+",";
                            if(MathMod(i,2)==1)
                            controlled_pattern+="r"+newlotsize+",r"+newlotsize+",r"+newlotsize+",";
                        }
                    int lotsize_p=int(MathAbs((sell_lots_total-buy_lots_total)/Lots));
                    for(int i=1;i<=4;i++)
                        controlled_pattern+="o"+lotsize_p+","+controlled_pattern;

                    extra_pattern="d1,d1,d1,d1,d1,d1,d1,d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",pacifiy_bigger_d2r2_multiply3,"))
                {
                    controlled_pattern="c1,";
                    if(CalculateCurrentOrders("all")==0)
                        controlled_pattern="c1,";
                    double newlotsize=0,multiplier=3;
                    for(int i=1;i<43;i++)
                        {
                            newlotsize=1+(newlotsize*multiplier);
                            //controlled_pattern+="r"+newlotsize+",";
                            if(MathMod(i,2)==0)
                            controlled_pattern+="d"+newlotsize+",d"+newlotsize+",";
                            if(MathMod(i,2)==1)
                            controlled_pattern+="r"+newlotsize+",r"+newlotsize+",";
                        }
                    int lotsize_p=int(MathAbs((sell_lots_total-buy_lots_total)/Lots));
                    for(int i=1;i<=4;i++)
                        controlled_pattern+="r"+lotsize_p+","+controlled_pattern;

                    extra_pattern="d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",pacifiy_bigger_onesided23_multiply3,"))
                {
                    controlled_pattern="c1,";
                    if(CalculateCurrentOrders("all")==0)
                        controlled_pattern="c1,";
                    double newlotsize=0,multiplier=3;
                    for(int i=1;i<=3;i++)
                        {

                            newlotsize=1+(newlotsize*multiplier);
                            //controlled_pattern+="r"+newlotsize+",";
                            controlled_pattern+="r"+newlotsize+",r"+newlotsize+",d"+newlotsize+",d"+newlotsize+",d"+newlotsize+",";

                        }
                    int lotsize_p=int(MathAbs((sell_lots_total-buy_lots_total)/Lots));

                    for(int i=1;i<=4;i++)
                        controlled_pattern+="r"+lotsize_p+","+controlled_pattern;

                    extra_pattern="d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1,d1";
                    
                }
            if(check_input(lotsize_increase_input,",pacifiy_multiply2,"))
                {
                    controlled_pattern="";
                    double newlotsize=0,multiplier=2;
                    for(int i=1;i<=20;i++)
                        {
                            newlotsize=1+(newlotsize*multiplier);
                            if(MathMod(i,2)==0)
                                controlled_pattern+="c"+newlotsize+",o"+newlotsize+",";
                            if(MathMod(i,2)!=0)
                                controlled_pattern+="c"+newlotsize+",o"+newlotsize+",";
                        }

                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",pacifiy_multiply3,"))
                {
                    controlled_pattern="";
                    double newlotsize=0,multiplier=3;
                    for(int i=1;i<=10;i++)
                        {
                            newlotsize=1+(newlotsize*multiplier);
                            if(MathMod(i,2)==0)
                                controlled_pattern+="c"+newlotsize+",o"+newlotsize+",";
                            if(MathMod(i,2)!=0)
                                controlled_pattern+="c"+newlotsize+",o"+newlotsize+",";
                        }

                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",directional,"))
                {
                    //controlled_pattern="d1,d3,d9,d30,d90,d300,d900,"; 
                    controlled_pattern="d"+(3+(buy_lots_total+sell_lots_total)/lots_to_start)+",d"+(6+(buy_lots_total+sell_lots_total)/lots_to_start)+","; 
                    //if(CalculateCurrentOrders("all")==1)
                    //  controlled_pattern="d1,d4,d"+(3+(buy_lots_total+sell_lots_total)/lots_to_start)+",d"+(6+(buy_lots_total+sell_lots_total)/lots_to_start)+","; 
                    for(int i=1;i<=5;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",directional_reverse,"))
                {
                    //controlled_pattern="d1,d3,d9,d30,d90,d300,d900,"; 
                    controlled_pattern="r"+(3+(buy_lots_total+sell_lots_total)/lots_to_start)+",r"+(6+(buy_lots_total+sell_lots_total)/lots_to_start)+","; 
                    //if(CalculateCurrentOrders("all")==1)
                    //  controlled_pattern="d1,d4,d"+(3+(buy_lots_total+sell_lots_total)/lots_to_start)+",d"+(6+(buy_lots_total+sell_lots_total)/lots_to_start)+","; 
                    for(int i=1;i<=8;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="r1,r1,r1";
                }
            if(check_input(lotsize_increase_input,",square,"))
                {
                    controlled_pattern="";
                    for(int i=1;i<=10;i++)
                        {
                            double newlotsize=(i*i);
                            if(MathMod(i,2)==0)
                                controlled_pattern+="d"+newlotsize+",";
                            if(MathMod(i,2)!=0)
                                controlled_pattern+="d"+newlotsize+",";
                        }

                    for(int i=1;i<=8;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                }   
            if(check_input(lotsize_increase_input,",counter,"))
                {
                    controlled_pattern="";
                    for(int i=1;i<=50;i++)
                        {
                            double newlotsize=(i);
                            if(MathMod(i,2)==0)
                                controlled_pattern+="b"+newlotsize+",";
                            if(MathMod(i,2)!=0)
                                controlled_pattern+="s"+newlotsize+",";
                        }

                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                } 
            if(check_input(lotsize_increase_input,",counter_repeat_multiple2,"))
                {
                    controlled_pattern="";
                    double newlotsize=1,multiplier=2;
                    for(int i=1;i<=50;i++)
                        {
                            if(MathMod(i,2)==0)
                                controlled_pattern+="b"+newlotsize+",d"+newlotsize+",d"+newlotsize+",";
                            if(MathMod(i,2)!=0)
                                controlled_pattern+="s"+newlotsize+",d"+newlotsize+",d"+newlotsize+",";
                        
                            newlotsize=1+(newlotsize*multiplier);
                        }

                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                } 
            if(check_input(lotsize_increase_input,",counter_repeat2,"))
                {
                    controlled_pattern="";
                    double newlotsize=1,multiplier=1;
                    for(int i=1;i<=50;i++)
                        {
                            newlotsize=i;
                            if(MathMod(i,2)==0)
                                controlled_pattern+="b"+newlotsize+",d"+newlotsize+",d"+newlotsize+",";
                            if(MathMod(i,2)!=0)
                                controlled_pattern+="s"+newlotsize+",d"+newlotsize+",d"+newlotsize+",";
                        
                        }

                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                } 
            if(check_input(lotsize_increase_input,",repeat2_multiply3,"))
                {
                    controlled_pattern="";
                    double newlotsize=1,multiplier=3;
                    for(int i=1;i<=50;i++)
                        {
                            if(MathMod(i,2)==0)
                                controlled_pattern+="b"+newlotsize+",d"+newlotsize+",d"+newlotsize+",";
                            if(MathMod(i,2)!=0)
                                controlled_pattern+="s"+newlotsize+",d"+newlotsize+",d"+newlotsize+",";
                            newlotsize=newlotsize*multiplier;
                        }

                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                } 
            if(check_input(lotsize_increase_input,",repeat3_multiply3,"))
                {
                    controlled_pattern="";
                    double newlotsize=1,multiplier=3;
                    for(int i=1;i<=50;i++)
                        {
                            if(MathMod(i,2)==0)
                                controlled_pattern+="b"+newlotsize+",d"+newlotsize+",d"+newlotsize+",d"+newlotsize+",";
                            if(MathMod(i,2)!=0)
                                controlled_pattern+="s"+newlotsize+",d"+newlotsize+",d"+newlotsize+",d"+newlotsize+",";
                            newlotsize=newlotsize*multiplier;
                        }

                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                } 
            if(check_input(lotsize_increase_input,",repeat3_multiply2,"))
                {
                    controlled_pattern="";
                    double newlotsize=1,multiplier=2;
                    for(int i=1;i<=50;i++)
                        {
                            if(MathMod(i,2)==0)
                                controlled_pattern+="b"+newlotsize+",d"+newlotsize+",d"+newlotsize+",d"+newlotsize+",";
                            if(MathMod(i,2)!=0)
                                controlled_pattern+="s"+newlotsize+",d"+newlotsize+",d"+newlotsize+",d"+newlotsize+",";
                            newlotsize=newlotsize*multiplier;
                        }

                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                } 
            if(check_input(lotsize_increase_input,",repeat3_multiply2_rsigap,"))
                {
                    controlled_pattern="";
                    string skbuy="b",sksell="s",skdirection="d",skopposite="r";
                    string skaction1=skdirection;
                    double newlotsize=1,multiplier=2;
                    for(int i=1;i<=50;i++)
                        {
                            skaction1=skdirection;
                            if(skind_rsi_mkt=="zigzag")
                                skaction1=skopposite;

                            if(MathMod(i,2)==0)
                                controlled_pattern+="b"+newlotsize+","+skaction1+newlotsize+","+skaction1+newlotsize+","+skaction1+newlotsize+",";
                            if(MathMod(i,2)!=0)
                                controlled_pattern+="s"+newlotsize+","+skaction1+newlotsize+","+skaction1+newlotsize+","+skaction1+newlotsize+",";
                            newlotsize=newlotsize*multiplier;
                        }
                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                } 
            if(check_input(lotsize_increase_input,",repeat3_multiply1_rsigap,"))
                {
                    controlled_pattern="";
                    string skbuy="b",sksell="s",skdirection="d",skopposite="r";
                    string skaction1=skdirection;
                    double newlotsize=1,multiplier=2;
                    for(int i=1;i<=50;i++)
                        {
                            skaction1=skdirection;
                            if(skind_rsi_mkt=="zigzag")
                                skaction1=skopposite;

                            if(MathMod(i,2)==0)
                                controlled_pattern+="b"+newlotsize+","+skaction1+newlotsize+","+skaction1+newlotsize+","+skaction1+newlotsize+",";
                            if(MathMod(i,2)!=0)
                                controlled_pattern+="s"+newlotsize+","+skaction1+newlotsize+","+skaction1+newlotsize+","+skaction1+newlotsize+",";
                            newlotsize=newlotsize*multiplier;
                        }
                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                } 
            if(check_input(lotsize_increase_input,",repeat3_multiply3_rsigap,"))
                {
                    controlled_pattern="";
                    string skbuy="b",sksell="s",skdirection="d",skopposite="r";
                    string skaction1=skdirection;
                    double newlotsize=1,multiplier=3;
                    for(int i=1;i<=50;i++)
                        {

                            skaction1=skdirection;
                            if(skind_rsi_mkt=="zigzag")
                                skaction1=skopposite;

                            if(MathMod(i,2)==0)
                                controlled_pattern+="b"+newlotsize+","+skaction1+newlotsize+","+skaction1+newlotsize+","+skaction1+newlotsize+",";
                            if(MathMod(i,2)!=0)
                                controlled_pattern+="s"+newlotsize+","+skaction1+newlotsize+","+skaction1+newlotsize+","+skaction1+newlotsize+",";
                            newlotsize=newlotsize*multiplier;
                        }


                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                } 
            if(check_input(lotsize_increase_input,",counter_repeat,"))
                {
                    controlled_pattern="";
                    for(int i=1;i<=50;i++)
                        {
                            double newlotsize=(i);
                            if(MathMod(i,2)==0)
                                controlled_pattern+="b"+newlotsize+",s"+newlotsize+",";
                            if(MathMod(i,2)!=0)
                                controlled_pattern+="s"+newlotsize+",b"+newlotsize+",";
                        }

                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                }   
            if(check_input(lotsize_increase_input,",counter_repeat_pacifier,"))
                {
                    controlled_pattern="";
                    for(int i=1;i<=50;i++)
                        {
                            double newlotsize=(i);
                            if(MathMod(i,2)==0)
                                controlled_pattern+="b"+newlotsize+",s"+newlotsize+",";
                            if(MathMod(i,2)!=0)
                                controlled_pattern+="s"+newlotsize+",b"+newlotsize+",";
                        }

                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                }   
            if(check_input(lotsize_increase_input,",squareodd,"))
                {
                    controlled_pattern="";
                    for(int i=1;i<=10;i++)
                        {
                            double newlotsize=(i*i);
                            if(MathMod(i,2)==0)
                                controlled_pattern+="b"+newlotsize+",";
                            if(MathMod(i,2)!=0)
                                controlled_pattern+="s"+newlotsize+",";
                        }

                    for(int i=1;i<=8;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                }   
            if(check_input(lotsize_increase_input,",multiple2,"))
                {
                    controlled_pattern="";
                    double newlotsize=0,multiplier=2;
                    for(int i=1;i<=10;i++)
                        {
                            newlotsize=1+(newlotsize*multiplier);
                            if(MathMod(i,2)==0)
                                controlled_pattern+="s"+newlotsize+",";
                            if(MathMod(i,2)!=0)
                                controlled_pattern+="b"+newlotsize+",";
                        }

                    for(int i=1;i<=8;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",last_multiple2,"))
                {
                    controlled_pattern="";
                    double newlotsize=0,multiplier=2;
                    for(int i=1;i<=10;i++)
                        {
                            newlotsize=1+(newlotsize*multiplier);
                            if(MathMod(i,2)==0)
                                controlled_pattern+="s"+newlotsize+",";
                            if(MathMod(i,2)!=0)
                                controlled_pattern+="b"+newlotsize+",";
                        }
                    for(int i=1;i<=8;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                        
                }
            if(check_input(lotsize_increase_input,",last_multiple3_custom,"))
                {
                    controlled_pattern="";
                    double newlotsize=1,multiplier=3;
                    for(int i=0;i<=10;i++)
                        {
                            if(MathMod(i,2)==0)
                                controlled_pattern+="s"+newlotsize+",";
                            if(MathMod(i,2)!=0)
                                controlled_pattern+="b"+newlotsize+",";
                            newlotsize=1+(newlotsize*multiplier);
                        }
                    controlled_pattern="b1,s3,b3,b3,s20,b20,b20,s81,b81,b81,s243,b243,b243,s729,";
                    for(int i=1;i<=3;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                        
                }
            if(check_input(lotsize_increase_input,",last_multiple3_custom_orderwise,"))
                {
                    int CalculateCurrentOrders=CalculateCurrentOrders("all");
                    if(CalculateCurrentOrders==0)
                        {
                            if( skind_rsi_mkt=="up" && buy_sell_with_manew_only()=="buy" )
                                controlled_pattern="b1,s3,"; 
                            if( skind_rsi_mkt=="down" && buy_sell_with_manew_only()=="sell" )
                                controlled_pattern="s1,s3,"; 

                        }
                    if(CalculateCurrentOrders==1)
                        {
                            if( MathAbs(Bid-last_order_price) > (mygap)) // moving up since last order 
                                controlled_pattern="b1,s3,"; 
                            if( MathAbs(Ask-last_order_price) > (mygap)) // moving down 
                                controlled_pattern="b1,b3,"; 
                        }
                    if(CalculateCurrentOrders==2)
                        {
                            controlled_pattern="b1,s3,b9,"; 
                        }
                    if(CalculateCurrentOrders==3)
                        {
                            controlled_pattern="b1,s3,"; 
                        }
                    if(CalculateCurrentOrders==4)
                        {
                            controlled_pattern="b1,s3,"; 
                        }
                    if(CalculateCurrentOrders==5)
                        {
                            controlled_pattern="b1,s3,"; 
                        }
                    if(CalculateCurrentOrders==6)
                        {
                            controlled_pattern="b1,s3,"; 
                        }

                    for(int i=1;i<=3;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                        
                }
            if(check_input(lotsize_increase_input,",last_multiple3,"))
                {
                    controlled_pattern="";
                    double newlotsize=1,multiplier=3;
                    for(int i=0;i<=8;i++)
                        {
                            if(MathMod(i,2)==0)
                                controlled_pattern+="s"+newlotsize+",";
                            if(MathMod(i,2)!=0)
                                controlled_pattern+="b"+newlotsize+",";
                            newlotsize=(newlotsize*multiplier);
                        }

                    for(int i=1;i<=8;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",lotstofinish,"))
                {
                    double newlotsize=1,multiplier=2;
                    //controlled_pattern="c"+(multiplier*closeall_if_profit_inr_input/inr_gap_between_orders_input)+",";
                    //controlled_pattern="c"+int(multiplier*closeall_if_profit_inr_input)+",";
                    //controlled_pattern="c"+int(closeall_if_profit_inr_input)+",";
                    controlled_pattern="c1,";
                    for(int i=0;i<=5;i++)
                        {   
                            //newlotsize=int(MathAbs(sktotalprofit/closeall_if_profit_inr_input)+1);
                            //newlotsize=int(MathAbs(multiplier*sktotalprofit/inr_gap_between_orders_input)+1);
                            newlotsize=int(MathAbs(multiplier*sktotalprofit)+1);
                            if(MathMod(i,3)==0)
                                controlled_pattern+="c"+newlotsize+",";
                            if(MathMod(i,3)!=0)
                                controlled_pattern+="c"+newlotsize+",";
                        }

                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",reverse_multiple2,"))
                {
                    controlled_pattern="c1,";
                    double newlotsize=1,multiplier=1;
                    int j=8;
                    for(int i=0;i<=j;i++)
                        {
                            if(i<j/2)
                            {
                            if(MathMod(i,2)==0)
                                {
                                    controlled_pattern+="r"+newlotsize+",";
                                }
                            if(MathMod(i,2)!=0)
                                {
                                    controlled_pattern+="r"+newlotsize+",";
                                }
                            }
                            if(i>=j/2)
                            {
                            if(MathMod(i,2)==0)
                                {
                                    controlled_pattern+="d"+newlotsize+",";
                                }
                            if(MathMod(i,2)!=0)
                                {
                                    controlled_pattern+="d"+newlotsize+",";
                                }
                            }
                            
                            newlotsize=(newlotsize*multiplier);
                        }

                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                }
            if(check_input(lotsize_increase_input,",reverse_add1,"))
                {
                    controlled_pattern="c1,";
                    double newlotsize=1,multiplier=1,toaddnumber=1;
                    int j=8;
                    for(int i=0;i<=j;i++)
                        {
                            if(i<j/2)
                            {
                            if(MathMod(i,2)==0)
                                {
                                    controlled_pattern+="r"+newlotsize+",";
                                }
                            if(MathMod(i,2)!=0)
                                {
                                    controlled_pattern+="r"+newlotsize+",";
                                }
                            }
                            if(i>=j/2)
                            {
                            if(MathMod(i,2)==0)
                                {
                                    controlled_pattern+="d"+newlotsize+",";
                                }
                            if(MathMod(i,2)!=0)
                                {
                                    controlled_pattern+="d"+newlotsize+",";
                                }
                            }
                            
                            //newlotsize=(newlotsize*multiplier);
                            newlotsize=(newlotsize+toaddnumber);
                        }

                    for(int i=1;i<=2;i++)
                        controlled_pattern+=controlled_pattern;
                    extra_pattern="d1,d1,d1";
                }

            pattern_inputs=controlled_pattern+extra_pattern;

        }
    void flip_reverse_signal()
        {
            if(skreverse==True)
                skreverse=False;
            if(skreverse==False)
                skreverse=True;
        }
    void buy_sell_simple_pattern()
        {

            //pattern_inputs="b1,s3,b6,s12,b8,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,b1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1,d5,d1,d1,d1,d1,d1";
            make_pattern_based_on_money();
            //if(CalculateCurrentOrders("all")==0)
                automanage_money();
            pattern_input_count=split_string_to_array_splitresult(pattern_inputs,",");
            int openorderscount=CalculateCurrentOrders("all");

                if(check_input(whentosqoff,",directionchangetp,"))
                    {
                        if(CalculateCurrentOrders("all")>1)
                        if( ( last_order_type==OP_SELL && (skprice > last_order_price+mygap) ) 
                            || ( last_order_type==OP_BUY && (skprice < last_order_price-mygap) )  )
                            {
                                    //exit_on_tp_or_sl("tp");
                                    //order_count_til_profit=0;
                            }
                    if(  last_order_type==OP_SELL && (skprice > last_order_price+mygap) )
                                    exit_on_tp_or_sl("tpbuy");
                    if(  last_order_type==OP_BUY && (skprice < last_order_price+mygap) )
                                    exit_on_tp_or_sl("tpsell");
                    }

                    if(check_input(whentosqoff,",directionchange_restart,") )
                        order_count_til_profit=0;



            openorderscount=order_count_til_profit;
            //skdebug("inside buy_sell_simple_pattern pattern_count="+pattern_input_count,dbgcheck1);
            if(pattern_input_count > openorderscount)
                {
                    //if(!check_input(buysell_conditions,",outofgap,") && !is_between_top_and_low() )
                    order_based_on_pattern(openorderscount);
                }
            //if(pattern_input_count-1 <= openorderscount)
            if(pattern_input_count < openorderscount)
                {
                    //closeall_orders("all","simple pattern count="+pattern_input_count+"is less then openorderscount="+openorderscount);
                    loss_with_orders_max++;
                }

        }
    void buy_sell_directional_repeat()
        {

            automanage_money();
            int openorderscount=CalculateCurrentOrders("all");

                if(check_input(whentosqoff,",directionchangetp,"))
                    {
                        if(CalculateCurrentOrders("all")>1)
                        if( ( last_order_type==OP_SELL && (skprice > last_order_price+mygap) ) 
                            || ( last_order_type==OP_BUY && (skprice < last_order_price-mygap) )  )
                            {
                                    //exit_on_tp_or_sl("tp");
                                    //order_count_til_profit=0;
                            }
                    if(  last_order_type==OP_SELL && (skprice > last_order_price+mygap) )
                                    exit_on_tp_or_sl("tpbuy");
                    if(  last_order_type==OP_BUY && (skprice < last_order_price+mygap) )
                                    exit_on_tp_or_sl("tpsell");
                    }




        }

    void buy_sell_simple_pattern_withdirection()
        {

            pattern_input_count=split_string_to_array_splitresult(pattern_inputs,",");
            int openorderscount=CalculateCurrentOrders("all");
            
            //skdebug("inside buy_sell_simple_pattern pattern_count="+pattern_input_count,dbgcheck1);
            if(pattern_input_count > openorderscount)
                {
                    //if(!check_input(buysell_conditions,",outofgap,") && !is_between_top_and_low() )
                    order_based_on_pattern(openorderscount);
                }
            if(pattern_input_count-1 <= openorderscount)
                {
                    closeall_orders("all","simple pattern finished all");
                    loss_with_orders_max++;
                }

        }

    bool is_between_top_and_low()
        {
            bool returnvalue=False;
            //double tollerance=spreadsize*pointstousd;
            double tollerance=mygap/4;
            if(   ( ( Ask<=top_price_order+tollerance && skprice>last_order_price ) 
                        || ( Bid>=least_price_order-tollerance && skprice<last_order_price ) 
                        
                        )
                  )
                returnvalue=True;
            
            //skdebug("between top and low = "+returnvalue,dbgcheck1);
            return(returnvalue);
                  
        }
    bool is_between_last_two_orders()
        {
            bool returnvalue=False;
            //double tollerance=spreadsize*pointstousd;
            double tollerance=mygap/2;
            double upperlimit=MathMax(second_last_order_price,last_order_price)+tollerance;
            double lowerlimit=MathMin(second_last_order_price,last_order_price)-tollerance;

            if( (skprice <  upperlimit && skprice > lowerlimit )  )
                returnvalue=True;
            
            //skdebug("between top and low = "+returnvalue,dbgcheck1);
            return(returnvalue);
                  
        }
    double update_lotsize_for_level_direction(double actuallots)
        {
            double returnvalue=actuallots;
            //if(  ( Ask<=top_price_order && skprice>first_order_price ) || ( Bid>=least_price_order && skprice<first_order_price  ) )
            if(  CalculateCurrentOrders("all") > 1 &&  is_between_top_and_low()  )
            //if(( ( Ask+spreadsize ) <=top_price_order && skprice>last_order_price ) || ( ( Bid-spreadsize) >=least_price_order && skprice<last_order_price ) )
                {
                    if(check_input(buysell_conditions,",singleifback,"))
                        returnvalue=lots_to_start;
                    //if(check_input(buysell_conditions,",zeroifback,"))
                      //  returnvalue=0;
                }
                else
                    {
                        next_lot_size=get_lot_size_for_quick_change();
                        returnvalue=next_lot_size;
                    }

            skdebug(returnvalue+" lots top="+top_price_order+" least="+least_price_order+" tempcheck1:P"+skprice+"|A"+Ask+"|B"+Bid+"|F"+first_order_price+"|L"+last_order_price,dbgcheck1); 
              return(returnvalue);

        }
    double get_lot_size_for_quick_change()
        {
            double lotsize_to_add=Lots;
            double lotsize_to_start=lots_to_start;
            double lotsize3=MathMax(lotsize_to_start,next_lot_size);
            prev_lot_size=next_lot_size;

            double next_lot_size_calculated=lotsize3;

            if(check_input(lotsize_increase,",addone,"))
                next_lot_size_calculated=MathMax(lotsize_to_start,(lotsize3+lotsize_to_add));
            else if(check_input(lotsize_increase,",single,"))
                    next_lot_size_calculated=lotsize_to_start;
            else if(check_input(lotsize_increase,",double,"))
                    next_lot_size_calculated=MathMax(lotsize_to_start,(lotsize3*2));
            else if(check_input(lotsize_increase,",triple,"))
                    next_lot_size_calculated=MathMax(lotsize_to_start,(lotsize3*3));
            else if(check_input(lotsize_increase,",4times,"))
                    next_lot_size_calculated=MathMax(lotsize_to_start,(lotsize3*4));
            else if(check_input(lotsize_increase,",5times,"))
                    next_lot_size_calculated=MathMax(lotsize_to_start,(lotsize3*5));
            else if(check_input(lotsize_increase,",6times,"))
                    next_lot_size_calculated=MathMax(lotsize_to_start,(lotsize3*6));
            else if(check_input(lotsize_increase,",10times,"))
                    next_lot_size_calculated=MathMax(lotsize_to_start,(lotsize3*10));
            else if(check_input(lotsize_increase,",addtwo,"))
                    next_lot_size_calculated=MathMax(lotsize_to_start,(lotsize3+(2*lotsize_to_add)));
            else if(check_input(lotsize_increase,",totallots,"))
                    next_lot_size_calculated=MathMax(lotsize_to_start,(buy_lots_total+sell_lots_total));
            else if(check_input(lotsize_increase,",totallots2,"))
                    next_lot_size_calculated=MathMax(lotsize_to_start,2*(buy_lots_total+sell_lots_total));
            skdebug("tempcheck6: in update lots :lotsize3="+lotsize3+" next="+next_lot_size_calculated,dbgcheck1);

            int openorderscount=CalculateCurrentOrders("all");
            if(openorderscount==0)
                next_lot_size_calculated=lotsize_to_start;
                
            if(check_input(buysell_conditions,",evenodd,")  )
                if(openorderscount >=2 )
                if(MathMod(openorderscount,2)==0)
                //if( MathAbs(skprice-last_order_price) > (skpoints_gap_between_orders) )
                    next_lot_size_calculated=prev_lot_size;

            if(check_input(buysell_conditions,",custom,")  )
                {
                   if(openorderscount==1)  next_lot_size_calculated=MathMax(lotsize_to_start,(lotsize3*2));
                   if(openorderscount==2)  next_lot_size_calculated=MathMax(lotsize_to_start,(lotsize3*1));
                   if(openorderscount==3)  next_lot_size_calculated=MathMax(lotsize_to_start,(lotsize3*3));
                   if(openorderscount==4)  next_lot_size_calculated=MathMax(lotsize_to_start,(lotsize3*1));
                   if(openorderscount==5)  next_lot_size_calculated=MathMax(lotsize_to_start,(lotsize3*1));
                   if(openorderscount==6)  next_lot_size_calculated=MathMax(lotsize_to_start,(lotsize3*3));
                   if(openorderscount==7)  next_lot_size_calculated=MathMax(lotsize_to_start,(lotsize3*1));
                   if(openorderscount==8)  next_lot_size_calculated=MathMax(lotsize_to_start,(lotsize3*1));
                   if(openorderscount==9)  next_lot_size_calculated=MathMax(lotsize_to_start,(lotsize3*1));
                   if(openorderscount>=10)  next_lot_size_calculated=MathMax(lotsize_to_start,(lotsize3*0));
                }

            skdebug("tempcheck7: in update lots :lotsize3="+lotsize3+" next="+next_lot_size_calculated,dbgcheck1);
            return(next_lot_size_calculated);
        }

    void update_maperiods_based_on_lots()
        {
            //skma4_periods=4+order_count_til_profit;
            if(order_count_til_profit<4)
                {
                    skma4_periods=4;
                    skma9_periods=10;
                }
            if(order_count_til_profit>4)
                    {
                        skma4_periods=10;
                        skma9_periods=60;
                    }

        }
    string buy_sell_with_manew_only()
        {
            //   MA required for order direction calculation . 
                 if(check_input(lotsize_increase_input,",changemavalue,"))
                    update_maperiods_based_on_lots();
                //    skma4_periods and skma10_periods global variables                      
                skma4=iMA(NULL,1,skma4_periods,1,MODE_SMA,PRICE_CLOSE,0);
                skma9=iMA(NULL,1,skma9_periods,1,MODE_SMA,PRICE_CLOSE,0);

            string returnvalue="none";
            if(skma4>skma9)
                returnvalue="buy";
            if(skma4<skma9 )
                returnvalue="sell";

            return(returnvalue);
        }
    string buy_sell_with_updown_level_only()
        {
                int openorderscount=CalculateCurrentOrders("all");
                  string returnvalue="none";  
                    {
                    if(Ask-last_order_price > (skpoints_gap_between_orders) )
                        returnvalue="buy"; 
                    if(last_order_price-Bid > (skpoints_gap_between_orders) )
                        returnvalue="sell"; 
                    //skdebug("skcheck what to do wit levels  condition ="+returnvalue,dbgcheck1);
                    }

                if(check_input(buysell_conditions,",evenodd,")  )
                if(openorderscount >=2 )
                if(MathMod(openorderscount,2)==0)
                    {
                    if(Ask-last_order_price > (skpoints_gap_between_orders) )
                        returnvalue="sell"; 
                    if(last_order_price-Bid > (skpoints_gap_between_orders) )
                        returnvalue="buy"; 
                    //skdebug("skcheck what to do wit levels  condition ="+returnvalue,dbgcheck1);
                    }

                if(check_input(buysell_conditions,",custom,")  )
                    {
                        if(openorderscount ==1 ) //d,r,r,d,d,d,r,r,r,r,d,d,d,d,d,d,
                            {
                                if(Ask-last_order_price > (skpoints_gap_between_orders) )
                                    returnvalue="sell"; 
                                if(last_order_price-Bid > (skpoints_gap_between_orders) )
                                    returnvalue="buy"; 
                            }
                        if(openorderscount ==2 ) 
                            {
                                if(Ask-last_order_price > (skpoints_gap_between_orders) )
                                    returnvalue="sell"; 
                                if(last_order_price-Bid > (skpoints_gap_between_orders) )
                                    returnvalue="buy"; 
                            }
                        if(openorderscount ==3 ) 
                            {
                                if(Ask-last_order_price > (skpoints_gap_between_orders) )
                                    returnvalue="buy"; 
                                if(last_order_price-Bid > (skpoints_gap_between_orders) )
                                    returnvalue="sell"; 
                            }
                        if(openorderscount ==4 ) 
                            {
                                if(Ask-last_order_price > (skpoints_gap_between_orders) )
                                    returnvalue="buy"; 
                                if(last_order_price-Bid > (skpoints_gap_between_orders) )
                                    returnvalue="sell"; 
                            }
                        if(openorderscount ==5 ) 
                            {
                                if(Ask-last_order_price > (skpoints_gap_between_orders) )
                                    returnvalue="buy"; 
                                if(last_order_price-Bid > (skpoints_gap_between_orders) )
                                    returnvalue="sell"; 
                            }
                        if(openorderscount ==6 ) 
                            {
                                if(Ask-last_order_price > (skpoints_gap_between_orders) )
                                    returnvalue="sell"; 
                                if(last_order_price-Bid > (skpoints_gap_between_orders) )
                                    returnvalue="buy"; 
                            }
                        if(openorderscount ==7 ) 
                            {
                                if(Ask-last_order_price > (skpoints_gap_between_orders) )
                                    returnvalue="sell"; 
                                if(last_order_price-Bid > (skpoints_gap_between_orders) )
                                    returnvalue="buy"; 
                            }
                        if(openorderscount ==8 ) 
                            {
                                if(Ask-last_order_price > (skpoints_gap_between_orders) )
                                    returnvalue="sell"; 
                                if(last_order_price-Bid > (skpoints_gap_between_orders) )
                                    returnvalue="buy"; 
                            }
                        if(openorderscount ==9 ) 
                            {
                                if(Ask-last_order_price > (skpoints_gap_between_orders) )
                                    returnvalue="sell"; 
                                if(last_order_price-Bid > (skpoints_gap_between_orders) )
                                    returnvalue="buy"; 
                            }
                        if(openorderscount >=10 ) 
                            {
                                if(Ask-last_order_price > (skpoints_gap_between_orders) )
                                    returnvalue="buy"; 
                                if(last_order_price-Bid > (skpoints_gap_between_orders) )
                                    returnvalue="sell"; 
                            }
                    }
                    

                if(check_input(buysell_conditions,",zeroifback,") && is_between_top_and_low() )
                     returnvalue="none";

                if(CalculateCurrentOrders("all") ==0 )
                    returnvalue=buy_sell_with_manew_only();
                skdebug("level condition ="+returnvalue,dbgcheck2);
              return(returnvalue);
        }
        
    string buy_sell_with_adionly()
        {
            indicator_adi_fill_details();
            string returnvalue="none";
            if(skind_adi_uptrend_value>1 )
                returnvalue="buy";
            if(skind_adi_downtrend_value>1 )
                returnvalue="sell";

            return(returnvalue);
        }
    bool get_buy_sell_condition(string whichone)
        {
                bool buy_cond1=False,sell_cond1=False;
                if(check_input(buysell_conditions,",justadi,")  )
                    {
                        if(buy_sell_with_adionly()=="buy" ) { buy_cond1=True ; sell_cond1=False; }
                        if(buy_sell_with_adionly()=="sell") { buy_cond1=False ; sell_cond1=True; }
                    }

                if(check_input(buysell_conditions,",manew,")  )
                    {
                        if(buy_sell_with_manew_only()=="buy" ) { buy_cond1=True ; sell_cond1=False; }
                        if(buy_sell_with_manew_only()=="sell") { buy_cond1=False ; sell_cond1=True; }
                    }
                if(check_input(buysell_conditions,",updownlevelonly,")  )
                    {
                        if(buy_sell_with_updown_level_only()=="buy" ) { buy_cond1=True ; sell_cond1=False; }
                        if(buy_sell_with_updown_level_only()=="sell") { buy_cond1=False ; sell_cond1=True; }
                    }

                if(check_input(buysell_conditions,",updownwithma,")  )
                    {
                        if(buy_sell_with_updown_level_only()=="buy" && buy_sell_with_manew_only()=="buy" ) 
                            { buy_cond1=True ; sell_cond1=False; }
                        if(buy_sell_with_updown_level_only()=="sell" && buy_sell_with_manew_only()=="sell") 
                            { buy_cond1=False ; sell_cond1=True; }
                    }

                if(check_input(buysell_conditions,",adiORmanew,")  )
                    {
                        //skdebug("check1:adiORmanew",dbgmust);
                        if(buy_sell_with_manew_only()=="buy" || buy_sell_with_adionly()=="buy" ) 
                            { buy_cond1=True ; sell_cond1=False; }
                        if(buy_sell_with_manew_only()=="sell" || buy_sell_with_adionly()=="sell" ) 
                            { buy_cond1=False ; sell_cond1=True; }
                    }
                if(check_input(buysell_conditions,",adiANDmanew,")  )
                    {
                        if(buy_sell_with_manew_only()=="buy" && buy_sell_with_adionly()=="buy" ) 
                            { buy_cond1=True ; sell_cond1=False; }
                        if(buy_sell_with_manew_only()=="sell" && buy_sell_with_adionly()=="sell" ) 
                            { buy_cond1=False ; sell_cond1=True; }
                    }

            if(whichone=="buy")
                return(buy_cond1);
                else
                    return(sell_cond1);
        }

    string is_gap_ok_for_buy_sell()
        {
            string returnvalue="any"; 
            double openorderscount=CalculateCurrentOrders("all");
            if(order_count_til_profit==0 )
                return(returnvalue);

            if(check_input(buysell_conditions,",timegap30,")  )
                {
                if( is_timegap_ok(60) == False )
                    returnvalue="none"; 
                }
            if(check_input(buysell_conditions,",withgaps,")  )
                {
                if( MathAbs(skprice-last_order_price) < (skpoints_gap_between_orders) )
                    returnvalue="any"; 
                }
            if(check_input(buysell_conditions,",withmovinggaps,")  )
                {
                int level_by_lots=next_lot_size/lots_to_start;
                if( MathAbs(skprice-last_order_price) < (level_by_lots*skpoints_gap_between_orders) )
                    returnvalue="any"; 
                }
            if(check_input(buysell_conditions,",withbuysellgaps,")  )
                {
                  returnvalue="none";  
                if( MathAbs(skprice-last_order_price) > (skpoints_gap_between_orders) )
                    {
                    if(skprice>last_order_price)
                        returnvalue="sell"; 
                    if(skprice<last_order_price)
                        returnvalue="buy"; 
                    if(skprice==last_order_price)
                        returnvalue="none";

                    }
                }
            if(check_input(buysell_conditions,",withsellbuygaps,")  )
                {
                  returnvalue="none";  
                if( MathAbs(skprice-last_order_price) > (skpoints_gap_between_orders) )
                    {
                    if(skprice>last_order_price)
                        returnvalue="buy"; 
                    if(skprice<last_order_price)
                        returnvalue="sell"; 
                    if(skprice==last_order_price)
                        returnvalue="none";
                    }
                if(check_input(buysell_conditions,",evenodd,")  )
                    if(openorderscount >=2 )
                    if(MathMod(openorderscount,2)==0)
                    if( MathAbs(skprice-last_order_price) > (skpoints_gap_between_orders) )
                        {
                        if(skprice>last_order_price)
                            returnvalue="sell"; 
                        if(skprice<last_order_price)
                            returnvalue="buy"; 
                        if(skprice==last_order_price)
                            returnvalue="none";
                        }

                if(check_input(buysell_conditions,",custom,")  )
                    {
                        if(openorderscount ==1 ) 
                            {
                                if(Ask-last_order_price > (skpoints_gap_between_orders) )
                                    returnvalue="sell"; 
                                if(last_order_price-Bid > (skpoints_gap_between_orders) )
                                    returnvalue="buy"; 
                            }
                        if(openorderscount ==2 ) 
                            {
                                if(Ask-last_order_price > (skpoints_gap_between_orders) )
                                    returnvalue="sell"; 
                                if(last_order_price-Bid > (skpoints_gap_between_orders) )
                                    returnvalue="buy"; 
                            }
                        if(openorderscount ==3 ) 
                            {
                                if(Ask-last_order_price > (skpoints_gap_between_orders) )
                                    returnvalue="buy"; 
                                if(last_order_price-Bid > (skpoints_gap_between_orders) )
                                    returnvalue="sell"; 
                            }
                        if(openorderscount ==4 ) 
                            {
                                if(Ask-last_order_price > (skpoints_gap_between_orders) )
                                    returnvalue="buy"; 
                                if(last_order_price-Bid > (skpoints_gap_between_orders) )
                                    returnvalue="sell"; 
                            }
                        if(openorderscount ==5 ) 
                            {
                                if(Ask-last_order_price > (skpoints_gap_between_orders) )
                                    returnvalue="buy"; 
                                if(last_order_price-Bid > (skpoints_gap_between_orders) )
                                    returnvalue="sell"; 
                            }
                        if(openorderscount ==6 ) 
                            {
                                if(Ask-last_order_price > (skpoints_gap_between_orders) )
                                    returnvalue="sell"; 
                                if(last_order_price-Bid > (skpoints_gap_between_orders) )
                                    returnvalue="buy"; 
                            }
                        if(openorderscount ==7 ) 
                            {
                                if(Ask-last_order_price > (skpoints_gap_between_orders) )
                                    returnvalue="sell"; 
                                if(last_order_price-Bid > (skpoints_gap_between_orders) )
                                    returnvalue="buy"; 
                            }
                        if(openorderscount ==8 ) 
                            {
                                if(Ask-last_order_price > (skpoints_gap_between_orders) )
                                    returnvalue="sell"; 
                                if(last_order_price-Bid > (skpoints_gap_between_orders) )
                                    returnvalue="buy"; 
                            }
                        if(openorderscount ==9 ) 
                            {
                                if(Ask-last_order_price > (skpoints_gap_between_orders) )
                                    returnvalue="sell"; 
                                if(last_order_price-Bid > (skpoints_gap_between_orders) )
                                    returnvalue="buy"; 
                            }
                        if(openorderscount >=10 ) 
                            {
                                if(Ask-last_order_price > (skpoints_gap_between_orders) )
                                    returnvalue="buy"; 
                                if(last_order_price-Bid > (skpoints_gap_between_orders) )
                                    returnvalue="sell"; 
                            }
                    }
                    

                }

                if(check_input(buysell_conditions,",sellbuyreverseifinside,") )
                    {
                        if(skprice>last_order_price)
                            returnvalue="buy"; 
                        if(skprice<last_order_price)
                            returnvalue="sell"; 
                        if(skprice==last_order_price)
                            returnvalue="none";

                        if(is_between_top_and_low())
                        {
                        if(skprice>last_order_price)
                            returnvalue="sell"; 
                        if(skprice<last_order_price)
                            returnvalue="buy"; 
                        if(skprice==last_order_price)
                            returnvalue="none";

                    }
                    //skdebug("skcheck what to do with reverseifback  condition ="+returnvalue,dbgcheck1);
                     }


            //if(is_between_top_and_low() && check_input(buysell_conditions,",reverseifinside,")  )
              //  returnvalue="any"; 

            if(returnvalue!="none")
                skdebug("tempcheck1:"+buysell_conditions+" "+returnvalue+" gap="+MathAbs(skprice-last_order_price)/pointstousd+" vs "+(skpoints_gap_between_orders),dbgcheck2);
            return(returnvalue);
        }

    bool is_timegap_ok( int minutesgap)
        {
            bool returnvalue=False;
            datetime sknow=TimeCurrent();
            int minute_of_last_order=TimeMinute(last_order_time)+TimeHour(last_order_time)*60;
            int skminutenow=TimeMinute(sknow)+TimeHour(sknow)*60 ;  
            
                if (minute_of_last_order + minutesgap  <= skminutenow )
                    returnvalue=True; 
            return(returnvalue);
        }

    bool is_gap_ok()
        {
            bool returnvalue=True; 
            if(check_input(buysell_conditions,",withgaps,")  )
                {
                if( MathAbs(skprice-last_order_price) < (skpoints_gap_between_orders*pointstousd) )
                    returnvalue=False; 
                }
            if(check_input(buysell_conditions,",withmovinggaps,")  )
                {
                int level_by_lots=next_lot_size/lots_to_start;
                if( MathAbs(skprice-last_order_price) < (level_by_lots*skpoints_gap_between_orders*pointstousd) )
                    returnvalue=False; 
                }
            return(returnvalue);
        }

    void buy_sell_actions_for_given_conditions()
        {
            string first_order_direction_prev=first_order_direction;
            if( check_input(direction_decider,",anytime,") || 
                (order_count_til_profit==0 && check_input(direction_decider,",anytime,")==False ) ) 
                    get_market_direction();
            if(first_order_direction_prev != first_order_direction)
                {
                    skdebug("direction changed ",dbgcheck1);
                    if(check_input(direction_decider,",close_all_inmid_direction_change,"))
                        closeall_orders("all","close_all_inmid_direction_change");
                }
            // Buy sell conditions fill 
                bool buy_cond1=get_buy_sell_condition("buy");
                bool sell_cond1=get_buy_sell_condition("sell");
            
            double lotsize3=MathMax(lots_to_start,next_lot_size);
            double next_lot_size_calculated=0;
            string skcomment_buy="skraj_buy_"+NormalizeDouble(lotsize3,3);
            string skcomment_sell="skraj_sell_"+NormalizeDouble(lotsize3,3);

            if(buy_cond1 || sell_cond1)
                skdebug("orders#"+CalculateCurrentOrders("all")+" "+OrdersTotal()+" "+order_count_til_profit+" sktempcheck0:lotsize="+lotsize3+" nexlot="+next_lot_size+" buy_cond1="+buy_cond1+" sell_cond1="+sell_cond1+"firstorder="+first_order_direction+" lastorder="+lastorder_adi,dbgcheck2);
            //if(buy_cond1 || sell_cond1 )
            if( lastorder_adi!="buy" || order_count_til_profit==0 || ( is_gap_ok_for_buy_sell()=="any" || is_gap_ok_for_buy_sell()=="buy") )
            //if(lastorder_adi!="buy"  )
                if(buy_cond1 && (  is_gap_ok_for_buy_sell()=="any" || is_gap_ok_for_buy_sell()=="buy") )
                    {
                        skdebug("sktempcheck3:inside buy  : lotsize="+lotsize3,dbgcheck1);

                            lastorder_adi="buy";
                        if( check_input(buysell_conditions,"unidirectional" )==False 
                            || ( check_input(buysell_conditions,"unidirectional") && first_order_direction=="buy") )
                        {
                            if(check_input(whentosqoff,",withneworderoneside,") && first_order_direction=="buy" ) 
                                exit_on_tp_or_sl("tpsell");
                            if(check_input(whentosqoff,",withneworderall,")  ) 
                                exit_on_tp_or_sl("tp");
                            if(check_input(buysell_conditions,",singleifback,"))
                                lotsize3=update_lotsize_for_level_direction(lotsize3);
                            //execute the buy order   
                            skdebug("sktempcheck1:about to buy  : lotsize="+lotsize3,dbgcheck1);
                            if(skneworder("buy",lotsize3,skcomment_buy)>0)
                                    {
                                        order_count_til_profit++;
                                        //skdebug("sktempcheck1:executed buy : lotsize="+lotsize3,dbgcheck1);
                                    }
                             if( check_input(buysell_conditions,",bothside," ) )
                                if(skneworder("sell",prev_lot_size,skcomment_sell)>0)
                                    {
                                        order_count_til_profit++;
                                        //skdebug("sktempcheck1:executed buy : lotsize="+lotsize3,dbgcheck1);
                                    }
                             if( check_input(buysell_conditions,",bothside-1," ) )
                                if(skneworder("sell",lots_to_start,skcomment_sell)>0)
                                    {
                                        order_count_til_profit++;
                                        //skdebug("sktempcheck1:executed buy : lotsize="+lotsize3,dbgcheck1);
                                    }

                            if(!check_input(buysell_conditions,",singleifback,") )
                                next_lot_size_calculated=get_lot_size_for_quick_change();
                                else
                                    next_lot_size_calculated=next_lot_size;
                        skdebug("2 orders#"+CalculateCurrentOrders("all")+" "+OrdersTotal()+" "+order_count_til_profit+" sktempcheck0:lotsize="+lotsize3+" nexlot="+next_lot_size+" buy_cond1="+buy_cond1+" sell_cond1="+sell_cond1+"firstorder="+first_order_direction+" lastorder="+lastorder_adi,dbgcheck1);
                            if(check_input(buysell_conditions,"unidirectional" )==False 
                                && first_order_direction=="buy" 
                                    )       
                                       {  next_lot_size=prev_lot_size;  }

                            if(check_input(buysell_conditions,",withbuysellgaps,") ||
                                check_input(buysell_conditions,",withsellbuygaps,")  )
                                next_lot_size=next_lot_size_calculated;

                        skdebug("3 orders#"+CalculateCurrentOrders("all")+" "+OrdersTotal()+" "+order_count_til_profit+" sktempcheck0:lotsize="+lotsize3+" nexlot="+next_lot_size+" buy_cond1="+buy_cond1+" sell_cond1="+sell_cond1+"firstorder="+first_order_direction+" lastorder="+lastorder_adi,dbgcheck1);
                        }

                    }

            if( lastorder_adi!="sell" || order_count_til_profit==0 || ( is_gap_ok_for_buy_sell()=="any" || is_gap_ok_for_buy_sell()=="sell")  )
            //if(lastorder_adi!="sell" )
                if(sell_cond1 && (  is_gap_ok_for_buy_sell()=="any" || is_gap_ok_for_buy_sell()=="sell") )
                    {
                            //skdebug("sktempcheck1:inside sell box : lotsize="+lotsize3,dbgcheck1);
                            lastorder_adi="sell";
                        if( check_input(buysell_conditions,"unidirectional" )==False
                            || ( check_input(buysell_conditions,"unidirectional") && first_order_direction=="sell") )
                        {   
                            //take profits if asked but for buy orders only 
                            if(check_input(whentosqoff,",withneworderoneside,") && first_order_direction=="sell" ) 
                                exit_on_tp_or_sl("tpbuy");
                            if(check_input(whentosqoff,",withneworderall,") ) 
                                exit_on_tp_or_sl("tp");

                            if(check_input(buysell_conditions,",singleifback,"))
                            lotsize3=update_lotsize_for_level_direction(lotsize3);

                            //execute sell 
                            if(skneworder("sell",lotsize3,skcomment_sell)>0)
                                    {
                                        order_count_til_profit++;
                                        //skdebug("sktempcheck1:executed buy : lotsize="+lotsize3,dbgcheck1);
                                    }
                            //execute both side order if asekd 
                            if( check_input(buysell_conditions,",bothside," ) )
                                if(skneworder("buy",prev_lot_size,skcomment_buy)>0)
                                    {
                                        order_count_til_profit++;
                                        //skdebug("sktempcheck1:executed buy : lotsize="+lotsize3,dbgcheck1);
                                    }
                            //execute both side order if asekd 
                            if( check_input(buysell_conditions,",bothside_1," ) )
                                if(skneworder("buy",lots_to_start,skcomment_buy)>0)
                                    {
                                        order_count_til_profit++;
                                        //skdebug("sktempcheck1:executed buy : lotsize="+lotsize3,dbgcheck1);
                                    }
                            if(!check_input(buysell_conditions,",singleifback,") )
                                next_lot_size_calculated=get_lot_size_for_quick_change();
                                else
                                    next_lot_size_calculated=next_lot_size;
                        skdebug("orders#"+CalculateCurrentOrders("all")+" "+OrdersTotal()+" "+order_count_til_profit+" sktempcheck0:lotsize="+lotsize3+" nexlot="+next_lot_size+" buy_cond1="+buy_cond1+" sell_cond1="+sell_cond1+"firstorder="+first_order_direction+" lastorder="+lastorder_adi,dbgcheck1);
                            if(check_input(buysell_conditions,"unidirectional" )==False 
                                && first_order_direction=="sell" 
                                    )       
                                        next_lot_size=prev_lot_size;

                            if(check_input(buysell_conditions,",withbuysellgaps,") ||
                                check_input(buysell_conditions,",withsellbuygaps,")  )
                                next_lot_size=next_lot_size_calculated;

                        skdebug("orders#"+CalculateCurrentOrders("all")+" "+OrdersTotal()+" "+order_count_til_profit+" sktempcheck0:lotsize="+lotsize3+" nexlot="+next_lot_size+" buy_cond1="+buy_cond1+" sell_cond1="+sell_cond1+"firstorder="+first_order_direction+" lastorder="+lastorder_adi,dbgcheck1);
                        }
                        
                    }

        }

    void button_color_based_on_market_direction()
        {
            if(first_order_direction=="buy")
               {
                ObjectSetInteger(0,"BUY",OBJPROP_COLOR,clrCyan);
                ObjectSetInteger(0,"BUY",OBJPROP_BORDER_TYPE,BORDER_RAISED);
                
                ObjectSetInteger(0,"SELL",OBJPROP_COLOR,clrGray);
                ObjectSetInteger(0,"SELL",OBJPROP_BORDER_TYPE,BORDER_FLAT);
                
                }
                
            if(first_order_direction=="sell")
               {
               
                ObjectSetInteger(0,"BUY",OBJPROP_COLOR,clrGray);
                ObjectSetInteger(0,"BUY",OBJPROP_BORDER_TYPE,BORDER_FLAT);
                
                ObjectSetInteger(0,"SELL",OBJPROP_COLOR,clrCyan);
                ObjectSetInteger(0,"SELL",OBJPROP_BORDER_TYPE,BORDER_RAISED);
               }
        }
    void get_market_direction()
        {
            //Set mkt direction based on MA .
                if(check_input(direction_decider,",macross,") )
                    {
                    if(skma10>skma60) first_order_direction="buy";
                    if(skma10<skma60) first_order_direction="sell";
                    }
                if(check_input(direction_decider,",macrossreverse,") )
                    {
                    if(skma10>skma60) first_order_direction="sell";
                    if(skma10<skma60) first_order_direction="buy";
                    }
                if(check_input(direction_decider,",magap,") )
                    {
                    if(magap_up1) first_order_direction="buy";
                    if(magap_down1) first_order_direction="sell";
                    //skdebug("check3 : firstorder="+first_order_direction+" lastorder="+lastorder_adi,dbgcheck2);
                    }
                if(check_input(direction_decider,",none,") )
                    {
                    first_order_direction="buy";
                    //skdebug("check3 : firstorder="+first_order_direction+" lastorder="+lastorder_adi,dbgcheck2);
                    }
            // IF no one setisfy our condition then set to buy by default .           
                if( first_order_direction=="none")
                    {
                    first_order_direction="buy";
                    }
                if( lastorder_adi=="none")
                    {
                    lastorder_adi="sell";
                    }
            //skdebug("firstorder="+first_order_direction+" lastorder="+lastorder_adi,dbgcheck2);
            button_color_based_on_market_direction();
        }

    void buy_sell_with_levels()
        { 


                    bool no_reversebuy=False,no_reversesell=False;
                    //if(sklevel_current!=sklevel_prev)
                    //if(sklevel_current>skpoints_gap_between_orders_input)
                      //  if(skpoints_gap_between_orders_auto) 
                        //    skpoints_gap_between_orders=MathAbs(sklevel_current);

                    sklevel_gap_touse=skpoints_gap_between_orders*pointstousd;
                    if(skpoints_gap_between_orders_input == 0)
                        {
                            sklevel_gap_touse=MathAbs(sklevel_current);
                            if(sklevel_current==0)
                                sklevel_gap_touse=1;
                        }
            

                    if(skprice > sklevel_up_value) 
                        {
                            skdebug("inside level up setting ",dbgcheck2);
                            //sklevel_prev = sklevel_current;
                            //sklevel_current+=1;
                            sklevel_switched=True;
                            oktotrade=True;
                            update_next_up_down_level_values();
                            //should_buy=True;
                        }

                    if(skprice < sklevel_down_value) 
                    {
                            skdebug("inside level down setting ",dbgcheck2);
                            //sklevel_prev = sklevel_current;
                            //sklevel_current-=1;
                            sklevel_switched=True;
                            oktotrade=True;
                            update_next_up_down_level_values();
                            //shuould_sell=true;
                    }

                    if(sklevel_switched && 1==2)
                        { 

                            sklevel_switched=False;
                            oktotrade=True;
                            //skdebug("Level changed from "+sklevel_prev+" to "+sklevel_current+" and gaptouse="+sklevel_gap_touse+
                            //      " target UP="+sklevel_up_value+" Down="+sklevel_down_value+" oktotrade="+oktotrade,dbgcheck1);
                        }

                    int riskfactor=1;
                    sklevel_lotsize2=Lots;
                    sklevel_lotsize=Lots;

                if(skreverse==True)
                {
                    double tempvar=sklevel_lotsize;
                    sklevel_lotsize=sklevel_lotsize2;
                    sklevel_lotsize2=tempvar;
                }
                
                sl=tp=0;
                string current_leveltransition="from_"+sklevel_prev+"_to_"+sklevel_current;

                if( sklevel_current!=sklevel_prev && oktotrade )  // actions if level changed
                    {
                        
                                    if( check_input(whentosqoff,",onesided_onreverse,") && check_input(whentosqoff,",anydirectionsqoff,") )
                                        {
                                        //if(CalculateCurrentOrders("buy")>0)
                                        //if(CalculateCurrentOrders("buy")>ordercount_to_takeprofit)
                                        if(positivecount_buy>ordercount_to_takeprofit)
                                            {
                                                closeall_orders("buy","positivecount_buy>ordercount_to_takeprofit close buy");
                                            }
                                        no_reversebuy=True;
                                        if(positivecount_sell>ordercount_to_takeprofit)
                                            {
                                                closeall_orders("sell","positivecount_sell>ordercount_to_takeprofit close sell");
                                            }
                                        no_reversesell=True;
                                        }

                    // while previous level is diffirent then current so level changed.  
                        oktotrade=False;
                        skdebug("skcheck4 : levels,p,c ="+sklevel_prev+","+sklevel_current,dbgcheck2);

                        if(sklevel_current == 0  )   // mkt back to position where started 
                            {

                            // while At the starting point
                            // while At the starting point but coming back 
                                if(sklevel_prev < sklevel_current )
                                    {
                                        skdebug("sklevel downward sqoff level 0 from -1: will sqoff last buy sell orders |levels,p,c="+sklevel_prev+","+sklevel_current+get_mkt_info("all"),dbgcheck1);
                                        //remove 1 sell lot ( last one )
                                    if( check_input(whentosqoff,"levelchange") )
                                        if(skmkt_movement!="up" || !check_input(whentosqoff,",level+mkt,"))
                                        if(OrderClose(lastsell_order,lastsell_lots,mysqoff_price("sell"),Slippage,mysqoff_color("sell")) )
                                            skdebug("sklevel Success last sell order #"+lastsell_order+" closed with lots ="+lastsell_lots,dbgcheck1);
                                        else
                                            skdebug("sklevel Failed last sell order #"+lastsell_order+" closed with lots ="+lastsell_lots,dbgcheck1);
                                            
                                        // remove level+1 buy lots 
                                    if( check_input(whentosqoff,"levelchange") )
                                        if(skmkt_movement!="down" || !check_input(whentosqoff,",level+mkt,") )
                                        if(OrderClose(lastbuy_order,lastbuy_lots,mysqoff_price("buy"),Slippage,mysqoff_color("buy")) )
                                            skdebug("sklevel Success last buy order #"+ lastbuy_order+" closed with lots ="+lastbuy_lots,dbgcheck1);
                                        else
                                            skdebug("sklevel Failed last buy order #"+lastbuy_order+" closed with lots ="+lastbuy_lots,dbgcheck1);
                                

                                        lastbuy_lots=lotsize_in_direction;
                                    if( check_input(whentobuysell,"levelreverse") && !is_same_level_order_open("buy") )
                                        if(lastbuy_lots>0 )
                                            {
                                                if(lastbuy_order=OpenPosition(Symbol(), OP_BUY, lastbuy_lots, sl, tp, MagicNumber,make_order_comment("buy")))
                                                    skdebug("sklevel Success 2 new buy order placed with lots ="+lastbuy_lots,dbgcheck1);
                                                else
                                                    skdebug("sklevel Faild 2 New buy order with lots ="+lastbuy_lots+" Err="+myerrmsg(),dbgerr);
                                            }

                                        lastsell_lots=lotsize_in_support;
                                    if( check_input(whentobuysell,"levelreverse") && !is_same_level_order_open("sell") )
                                    if(lastsell_lots>0  )
                                    {
                                        if(lastsell_order=OpenPosition(Symbol(), OP_SELL, lastsell_lots, sl, tp, MagicNumber,make_order_comment("sell")))
                                            skdebug("sklevel Success new sell order placed with lots ="+lastsell_lots,dbgcheck1);
                                        else
                                            skdebug("sklevel Faild New sell order with lots ="+lastsell_lots+myerrmsg(),dbgerr);
                                    }

                                    }  

                            // while coming back to level 0 open a new buy position .
                                if(sklevel_prev > sklevel_current)
                                    {
                                        skdebug("sklevel upward sqoff : from level 1 to 0 : levels,p,c="+sklevel_prev+","+sklevel_current,dbgcheck1);
                                        //remove 1 buy lot 
                                    if( check_input(whentosqoff,"levelchange") )
                                        if(skmkt_movement!="up" || !check_input(whentosqoff,",level+mkt,") )
                                        if(OrderClose(lastbuy_order,lastbuy_lots,mysqoff_price("buy"),Slippage,mysqoff_color("buy")) )
                                        //if(OrderClose(lastbuy_order,lastbuy_lots,Bid,Slippage,mysqoff_color()) )
                                            skdebug("sklevel Success last buy order #"+lastbuy_order+" closed with lots ="+lastbuy_lots,dbgcheck1);
                                        else
                                            skdebug("sklevel Failed last buy order #"+lastbuy_order+" closed with lots ="+lastbuy_lots,dbgcheck1);
                                            
                                        // remove level+1 sell lots 
                                    if( check_input(whentosqoff,"levelchange") )
                                        if(skmkt_movement!="down" || !check_input(whentosqoff,",level+mkt,") )
                                        if(OrderClose(lastsell_order,lastsell_lots,mysqoff_price("sell"),Slippage,mysqoff_color("sell")) )
                                        //if(OrderClose(lastsell_order,lastsell_lots,Ask,Slippage,mysqoff_color()) )
                                            skdebug("sklevel Success last sell order #"+lastsell_order+" closed with lots ="+lastsell_lots,dbgcheck1);
                                        else
                                            skdebug("sklevel Failed last sell order #"+lastsell_order+" closed with lots ="+lastsell_lots,dbgcheck1);

                                    // while coming back to level 0 open a new buy position .
                                        lastbuy_lots=lotsize_in_direction;
                                        skdebug("SKCHECK2 : "+lastbuy_lots,dbgcheck1);
                                    if( check_input(whentobuysell,"levelreverse") && !is_same_level_order_open("sell") )
                                        if(lastbuy_lots>0 )
                                            {
                                                if(lastbuy_order=OpenPosition(Symbol(), OP_BUY, lastbuy_lots, sl, tp, MagicNumber,make_order_comment("buy")))
                                                    skdebug("sklevel Success 2 new buy order placed with lots ="+lastbuy_lots,dbgcheck1);
                                                else
                                                    skdebug("sklevel Faild 2 New buy order with lots ="+lastbuy_lots+" Err="+myerrmsg(),dbgerr);
                                            }

                                    }
                            }

                        if(sklevel_current > 0) // mkt going up so book buy profits 
                            {

                                    if( check_input(whentosqoff,",onesided_onreverse,") && check_input(whentosqoff,",anydirectionsqoff,") )
                                    {
                                    //if(CalculateCurrentOrders("buy")>0)
                                    //if(CalculateCurrentOrders("buy")>ordercount_to_takeprofit)
                                    if(positivecount_buy>ordercount_to_takeprofit)
                                        {
                                            //closeall_orders_except_self_level("buy");
                                            closeall_orders("buy","positivecount_buy>ordercount_to_takeprofit buy");
                                        }
                                    no_reversebuy=True;
                                    //no_reverse_buy_sqoff=True;
                                    }
                                
                            // while Above the starting point 
                            // while going towards rally Above the starting point 
                                //if(sklevel_prev < sklevel_current && OrdersTotal()<maxlots && ( skmkt_movement_prev=="up" || skmkt_movement=="up") )
                                //if(sklevel_prev < sklevel_current && OrdersTotal()<maxlots && (  skmkt_movement!="down")  )
                                if(sklevel_prev < sklevel_current && CalculateCurrentOrders("all")<maxlots  )
                                {
                                    skdebug("sklevel upward rally newposition : levels from "+sklevel_prev+" to "+sklevel_current ,dbgcheck1);
                                    //skdebug("upward rally  : levels,p,c ="+sklevel_prev+","+sklevel_current,dbgcheck1);
                                        //skdebug("skcheck5 : levels,p,c ="+sklevel_prev+","+sklevel_current,dbgcheck1);
                                        lastbuy_lots=lotsize_in_direction;
                                        if(check_input(lotsize_increase,",opposite_lotsize,")  )
                                            if(CalculateCurrentOrders("buy")<=1) 
                                            {
                                                lastbuy_lots=sell_lots_total-buy_lots_total+lotsize_in_direction ;
                                                //special_comment="quick";
                                            }

                                                lotsize_to_execute_buy=buy_lots_total ;
                                        lastsell_lots=lotsize_in_support;
                                        //skdebug("sklevel upward movement level from "+sklevel_prev+" to "+sklevel_current+"| will open new sell order of lots "+lastsell_lots+" and buy order of lots "+lastbuy_lots+get_mkt_info("all"),dbgcheck1);
                                    //add 1 more buy standard lot
                                        //lastbuy_lots=Lots;
                                    if(!is_same_level_order_open("buy") )
                                        if( is_spread_ok("NEWLEVEL") ) 
                                    //if(skmkt_movement!="down" || !check_input(whentobuysell,",level+mkt,") )
                                        if(lastbuy_lots>0 )
                                        {
                                            if(lastbuy_order=OpenPosition(Symbol(), OP_BUY, lastbuy_lots, sl, tp, MagicNumber,make_order_comment("buy")))
                                                skdebug("sklevel Success 2 new buy order placed with lots ="+lastbuy_lots,dbgcheck1);
                                            else
                                                skdebug("sklevel Faild 2 New buy order with lots ="+lastbuy_lots+" Err="+myerrmsg(),dbgerr);
                                        }
                                    //add level+1 sell lots 
                                    // wait for few seconds before sending next order 
                                    //Sleep(sleeptimebetween_simultaneous_orders);
                                        //ordercomment="sell"+lastsell_lots;
                                    if(!is_same_level_order_open("sell"))
                                        if( is_spread_ok("NEWLEVEL") ) 
                                    //if(skmkt_movement!="up" || !check_input(whentobuysell,",level+mkt,") )
                                        if(lastsell_lots>0  )
                                        {
                                            //special_comment="quick";
                                            if(lastsell_order=OpenPosition(Symbol(), OP_SELL, lastsell_lots, sl, tp, MagicNumber,make_order_comment("sell")))
                                                skdebug("sklevel Success new sell order placed with lots ="+lastsell_lots,dbgcheck1);
                                            else
                                                skdebug("sklevel Faild New sell order with lots ="+lastsell_lots+myerrmsg(),dbgerr);
                                        }
                                }

                            // while going opposite rally Above the starting point 
                                    //if(sklevel_prev > sklevel_current && ( skmkt_movement!="up") && check_input(whentosqoff,"levelchange"))
                                if(sklevel_prev > sklevel_current )
                                {

                                //if(closeall_if_profit_inr>0 || closeall_if_loss_inr>0 ) close_all_if_equity_profit();

                                    if(!check_input(whentosqoff,",onesided_onreverse,"))
                                    skdebug("sklevel upward opposite rally sqoff level from "+sklevel_prev+" to "+sklevel_current+"| will close last sell order #"+lastsell_order+" of "+lastsell_lots+" lots and last buy order #"+lastbuy_order+" of "+lastbuy_lots+" lots"+get_mkt_info("all"),dbgcheck1);
                                    //skdebug("upward opposite rally  : levels,p,c ="+sklevel_prev+","+sklevel_current,dbgcheck1);
                                    
                                    if( check_input(whentosqoff,",onesided_onreverse,")  )
                                        {
                                        //if(CalculateCurrentOrders("buy")>0)
                                        if(CalculateCurrentOrders("buy")>ordercount_to_takeprofit)
                                        //if(positivecount_buy>ordercount_to_takeprofit)
                                            {
                                                //closeall_orders_except_self_level("buy");
                                                closeall_orders("buy","positivecount_buy>ordercount_to_takeprofit buy");
                                            }
                                        no_reversebuy=True;
                                        //no_reverse_buy_sqoff=True;
                                        }

                                    if( check_input(whentosqoff,",onesided_opposite_onreverse,") )
                                        {
                                        if(CalculateCurrentOrders("sell")>1)
                                            {
                                                //closeall_orders_except_self_level("buy");
                                                closeall_orders("sell","onesided_opposite_onreverse sell");
                                            }
                                        no_reversebuy=True;
                                        //no_reverse_buy_sqoff=True;
                                        }
                                        
                                    if(check_input(whentosqoff,",reverse_level_closeall,")) 
                                        if(CalculateCurrentOrders("all")>1)
                                            closeall_orders("all","reverse_level_closeall all " );
                                    //remove last buy lot 

                                    if( check_input(whentosqoff,"levelchange") )
                                    //if(skmkt_movement!="up" || !check_input(whentosqoff,",level+mkt,") )
                                        if(OrderClose(lastbuy_order,lastbuy_lots,mysqoff_price("buy"),Slippage,mysqoff_color("buy")) )
                                            skdebug("sklevel Success last buy order #"+lastbuy_order+" closed with lots ="+lastbuy_lots,dbgcheck1);
                                        else
                                            skdebug("sklevel Failed last buy order #"+lastbuy_order+" closed with lots ="+lastbuy_lots,dbgcheck1);
                                        
                                    // remove level+1 sell lots 
                                    if( check_input(whentosqoff,"levelchange") )
                                    //if( check_input(whentosqoff,"levelchange") || check_input(whentosqoff,",onesided_onreverse,"))
                                    //if(skmkt_movement!="down" || !check_input(whentosqoff,",level+mkt,") )
                                        if(OrderClose(lastsell_order,lastsell_lots,mysqoff_price("sell"),Slippage,mysqoff_color("sell")) )
                                            skdebug("sklevel Success last sell order #"+lastsell_order+" closed with lots ="+lastsell_lots,dbgcheck1);
                                        else
                                            skdebug("sklevel Failed last sell order #"+lastsell_order+" closed with lots ="+lastsell_lots,dbgcheck1);
                                
                                    // while coming back open a new buy and sell position .
                                        lastsell_lots=lotsize_in_direction;
                                        if(check_input(lotsize_increase,",1&level5,"))
                                            lastsell_lots=lotsize_in_direction;
                                    if( check_input(whentobuysell,"levelreverse") && !is_same_level_order_open("sell") )
                                        if( is_spread_ok("NEWLEVEL") ) 
                                        if(lastsell_lots>0 )
                                            {
                                                if(lastsell_order=OpenPosition(Symbol(), OP_SELL, lastsell_lots, sl, tp, MagicNumber,make_order_comment("sell")))
                                                    skdebug("sklevel Success new sell order placed with lots ="+lastsell_lots,dbgcheck1);
                                                else
                                                    skdebug("sklevel Faild New sell order with lots ="+lastsell_lots+myerrmsg(),dbgerr);
                                            }
                                
                                        lastbuy_lots=lotsize_in_support;
                                        if(check_input(lotsize_increase,",1&level5,"))
                                            lastbuy_lots=lotsize_in_direction;
                                            lastbuy_lots=0;
                                    if( check_input(whentobuysell,"levelreverse") && !is_same_level_order_open("buy"))
                                        if( is_spread_ok("NEWLEVEL") ) 
                                        if(no_reversebuy==False)
                                        if(lastbuy_lots>0 )
                                            {
                                                if(lastsell_order=OpenPosition(Symbol(), OP_BUY, lastbuy_lots, sl, tp, MagicNumber,make_order_comment("buy")))
                                                    skdebug("sklevel Success new buy order placed with lots ="+lastbuy_lots,dbgcheck1);
                                                else
                                                    skdebug("sklevel Faild New buy order with lots ="+lastbuy_lots+myerrmsg(),dbgerr);
                                            }

                                
                                }
                            }

                        if(sklevel_current < 0)   // mkt going down so book profit from sell 
                            {

                                    if( check_input(whentosqoff,",onesided_onreverse,") && check_input(whentosqoff,",anydirectionsqoff,") )
                                        {
                                            //if(CalculateCurrentOrders("sell")>0)
                                            //if(CalculateCurrentOrders("sell")>ordercount_to_takeprofit)
                                            if(positivecount_sell>ordercount_to_takeprofit)
                                                {
                                                    closeall_orders("sell","ordercount_to_takeprofit sell ");
                                                    //closeall_orders_except_self_level("sell");
                                                    no_reversesell=True;
                                                }
                                            no_reversesell=True;
                                        }
                                
                            // while Below the starting point 
                            // while going towards rally below the starting point 
                                //skdebug("skcheck4 : levels,p,c ="+sklevel_prev+","+sklevel_current,dbgcheck1);

                                //if(sklevel_prev > sklevel_current && OrdersTotal()<maxlots && ( skmkt_movement_prev=="down" || skmkt_movement=="down" ) )
                                //if(sklevel_prev > sklevel_current && OrdersTotal()<maxlots && ( skmkt_movement!="up" ) )
                                if(sklevel_prev > sklevel_current && CalculateCurrentOrders("all")<maxlots   ) // it is rallying downward 
                                {
                                    skdebug("sklevel downward rally newposition : levels from "+sklevel_prev+" to "+sklevel_current ,dbgcheck1);
                                    //skdebug("downward rally  : levels,p,c ="+sklevel_prev+","+sklevel_current,dbgcheck1);
                                    lastsell_lots=lotsize_in_direction;
                                        if(check_input(lotsize_increase,",opposite_lotsize,") )
                                            if(CalculateCurrentOrders("sell")<=1) 
                                            {
                                                lastsell_lots=buy_lots_total-sell_lots_total+lotsize_in_direction ;
                                                //special_comment="quick";
                                            }
                                    lastbuy_lots=lotsize_in_support;
                                        //skdebug("sklevel downward movement : levels from "+sklevel_prev+" to "+sklevel_current+"| will open new sell order of "+lastsell_lots+"lots and new buy order of "+lastbuy_lots+" lots"+get_mkt_info("all"),dbgcheck1);
                                    //add 1 more sell standard lot
                                        //lastsell_lots=Lots;
                                        ordercomment="sell"+lastsell_lots;
                                    if(!is_same_level_order_open("sell"))
                                    if( is_spread_ok("NEWLEVEL") ) 
                                    //if(skmkt_movement!="up" || !check_input(whentobuysell,",level+mkt,"))
                                    if(lastsell_lots>0)
                                        if(lastsell_order=OpenPosition(Symbol(), OP_SELL, lastsell_lots, sl, tp, MagicNumber,make_order_comment("sell")))
                                            skdebug("sklevel sklevel Success new sell order placed with lots ="+lastsell_lots +" comment="+make_order_comment("sell"),dbgcheck1);
                                        else
                                            skdebug("sklevel sklevel Faild New sell order with lots ="+lastsell_lots+" Err="+myerrmsg(),dbgerr);
                                    //add level+1 buy lots 
                                    // wait for few seconds before sending next order 
                                    Sleep(sleeptimebetween_simultaneous_orders);
                                        ordercomment="buy"+lastbuy_lots;
                                    if(!is_same_level_order_open("buy"))
                                    if( is_spread_ok("NEWLEVEL") ) 
                                    //if(skmkt_movement!="down" || !check_input(whentobuysell,",level+mkt,"))
                                    if(lastbuy_lots>0 )
                                        if(lastbuy_order=OpenPosition(Symbol(), OP_BUY, lastbuy_lots, sl, tp, MagicNumber,make_order_comment("buy")))
                                            skdebug("sklevel Success 3 new buy order placed with lots ="+lastbuy_lots+" comment="+make_order_comment("buy"),dbgcheck1);
                                        else
                                            skdebug("sklevel  3 New buy order with lots ="+lastbuy_lots+" Err="+myerrmsg(),dbgerr);
                                }
                            // while going opposite rally below starting point 
                                //if(sklevel_prev < sklevel_current && skmkt_movement!="down" && check_input(whentosqoff,"levelchange") )
                                if(sklevel_prev < sklevel_current && is_spread_ok("NEWLEVEL")  ) // coming back upward 
                                {

                                    if(closeall_if_profit_inr>0 || closeall_if_loss_inr>0 ) close_all_if_equity_profit();

                                    if(!check_input(whentosqoff,",onesided_onreverse,"))
                                        skdebug("sklevel downward opposite rally sqoff : levels from "+sklevel_prev+" to "+sklevel_current +"| will close last sell order #"+lastsell_order+" of "+lastsell_lots+" lots and last buy order #"+lastbuy_order+" of "+lastbuy_lots+" lots"+get_mkt_info("all"),dbgcheck1);
                                    //skdebug("downward   : levels,p,c ="+sklevel_prev+","+sklevel_current,dbgcheck1);

                                    if( check_input(whentosqoff,",onesided_onreverse,")  )
                                        {
                                            //if(CalculateCurrentOrders("sell")>0)
                                            if(CalculateCurrentOrders("sell")>ordercount_to_takeprofit)
                                            //if(positivecount_sell>ordercount_to_takeprofit)
                                                {
                                                    closeall_orders("sell","ordercount_to_takeprofit sell");
                                                    //closeall_orders_except_self_level("sell");
                                                    no_reversesell=True;
                                                }
                                            no_reversesell=True;
                                        }

                                    if( check_input(whentosqoff,",onesided_opposite_onreverse,") )
                                        {
                                            if(CalculateCurrentOrders("buy")>1)
                                                {
                                                    closeall_orders("buy","onesided_opposite_onreverse buy");
                                                    no_reversesell=True;
                                                }
                                            no_reversesell=True;
                                        }
                                    
                                    if(check_input(whentosqoff,",reverse_level_closeall,")) 
                                        if(CalculateCurrentOrders("all")>1)
                                            closeall_orders("all","reverse_level_closeall all");
                                    
                                    //remove 1 sell lot ( last one )
                                    if( check_input(whentosqoff,"levelchange")  )
                                    //if(skmkt_movement!="down" || !check_input(whentosqoff,",level+mkt,"))
                                        if(OrderClose(lastsell_order,lastsell_lots,mysqoff_price("sell"),Slippage,mysqoff_color("sell")) )
                                            skdebug("sklevel Success to close last sell order #"+lastsell_order+" of lots ="+lastsell_lots,dbgcheck1);
                                        else
                                            skdebug("sklevel Failed to close last sell order #"+lastsell_order+" of lots ="+lastsell_lots,dbgcheck1);
                                        
                                    // remove level+1 buy lots 
                                    if( check_input(whentosqoff,"levelchange")  )
                                    //if( check_input(whentosqoff,"levelchange") || check_input(whentosqoff,",onesided_onreverse,") )
                                    //if(skmkt_movement!="up" || !check_input(whentosqoff,",level+mkt,"))
                                        if(OrderClose(lastbuy_order,lastbuy_lots,mysqoff_price("buy"),Slippage,mysqoff_color("buy")) )
                                            skdebug("sklevel Success to close last buy order #"+lastbuy_order+" of lots ="+lastbuy_lots,dbgcheck1);
                                        else
                                            skdebug("sklevel Failed to close last buy order #"+lastbuy_order+" of lots ="+lastbuy_lots,dbgcheck1);
                                    
                                    // while coming back to level 0 open a new buy position .
                                        lastsell_lots=lotsize_in_support;
                                        if(check_input(lotsize_increase,",1&level5,"))
                                            lastsell_lots=lotsize_in_direction;
                                        lastsell_lots=0;
                                    if( check_input(whentobuysell,"levelreverse") && !is_same_level_order_open("buy"))
                                    if( is_spread_ok("NEWLEVEL") ) 
                                        if(no_reversesell==False)
                                        if(lastsell_lots>0 )
                                            {
                                                if(lastsell_order=OpenPosition(Symbol(), OP_SELL, lastsell_lots, sl, tp, MagicNumber,make_order_comment("sell")))
                                                    skdebug("sklevel Success new sell order placed with lots ="+lastsell_lots,dbgcheck1);
                                                else
                                                    skdebug("sklevel Faild New sell order with lots ="+lastsell_lots+myerrmsg(),dbgerr);
                                            }
                                    
                                        lastbuy_lots=lotsize_in_direction;
                                        if(check_input(lotsize_increase,",1&level5,"))
                                            lastbuy_lots=lotsize_in_direction;
                                    if( check_input(whentobuysell,"levelreverse") && !is_same_level_order_open("buy"))
                                    if( is_spread_ok("NEWLEVEL") ) 
                                        if(lastbuy_lots>0 )
                                            {
                                                if(lastsell_order=OpenPosition(Symbol(), OP_BUY, lastbuy_lots, sl, tp, MagicNumber,make_order_comment("buy")))
                                                    skdebug("sklevel Success new buy order placed with lots ="+lastbuy_lots,dbgcheck1);
                                                else
                                                    skdebug("sklevel Faild New buy order with lots ="+lastbuy_lots+myerrmsg(),dbgerr);
                                            }
                                    
                                }
                            }

                        //sklevel_prev = sklevel_current;

                    }
        }

    int neworder_check(int doubleorder)
        {
            double  ma=iMA(NULL,0,12,6,MODE_SMA,PRICE_CLOSE,0);
            //double x1=iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,1);
            //double x2=iMA(NULL,0,12,0,MODE_EMA,PRICE_CLOSE,1);
            //double x3=MathAbs((x1-x2)/Point);
            //double x4=iADX(NULL,0,6,0,MODE_PLUSDI,0);
            //double x5=iADX(NULL,0,6,0,MODE_MINUSDI,0);
            //double x6=iADX(NULL,0,6,0,MODE_PLUSDI,1);
            //double x7=iADX(NULL,0,6,0,MODE_MINUSDI,1);
            //double x8=iADX(NULL,0,6,0,MODE_PLUSDI,0);
            //double x9=iADX(NULL,0,6,0,MODE_MINUSDI,0);
                //if (x1<x2 && x3>n && x6<5 && x4>10 && x8>x9 ) then buy

                //if (x1>x2 && x3>n && x7<5 && x5>10 && x8<x9 ) // then sell 
            double ll=0,tp=0,sl=0,slr=0,tpr=0;
            
            if(sktakeprofit!=0 && linegap!=0) 
                {
                tp =Ask+((sktakeprofit*usdtopoints)*linegap);
                tpr=Bid-((sktakeprofit*usdtopoints)*linegap);
                }
            if(sk_stop_loss_inr!=0 && linegap!=0) 
                {
                sl =Bid-((sk_stop_loss_inr*usdtopoints)*linegap);
                slr=Ask+((sk_stop_loss_inr*usdtopoints)*linegap);
                }
            
            int totalorderscount=CalculateCurrentOrders("all");

            ll=Lots;
            currenttime=TimeCurrent();
            string ordercomment="n1_"+currenttime;
            total=totalorderscount;
            if(totalorderscount>=maxlots)
                skdebug("Max orders allowed = "+maxlots+" and current orders count = "+totalorderscount,4);
            
            if(total<=maxlots)
            {
                skdebug("lets check conditions for new order as sktotal orders : "+total+" < "+maxlots,7);
                if(AccountFreeMargin()<(1000*Lots) || Lots<=0)
                {
                    skdebug("Insufficient funds = "+AccountFreeMargin(),1);
                    return(0);
                }
                
                
                if (quickstart>=1)
                {
                    skdebug("first buy,Size:"+ll+":SL:"+sl+":TP:"+tp+":msg:"+make_order_comment("buy"),2);
                    OpenPosition(Symbol(), OP_BUY, ll, sl, tp, MagicNumber,make_order_comment("buy"));
                    if(doubleorder==1)
                    {
                        skdebug("first SELL ,Size:"+ll+":SL:"+sl+":TP:"+tp+":msg:"+make_order_comment("sell"),2);
                        OpenPosition(Symbol(), OP_SELL, ll, slr,tpr, MagicNumber,make_order_comment("sell"));
                        
                    }
                        if (quickstart==2)
                        {
                            skdebug("first SELL ,Size:"+ll+":SL:"+sl+":TP:"+tp+":msg:"+make_order_comment("sell"),2);
                            OpenPosition(Symbol(), OP_SELL, ll, slr,tpr, MagicNumber,make_order_comment("sell"));
                            if(doubleorder==1)
                            {
                                skdebug("first buy,Size:"+ll+":SL:"+sl+":TP:"+tp+":msg:"+make_order_comment("buy"),2);
                                OpenPosition(Symbol(), OP_BUY, ll, sl, tp, MagicNumber,make_order_comment("buy"));
                                
                            }
                            }
                    
                    
                }
                else
                {
                    if(check_buy_conditions()) // buy order 
                    {
                    skdebug("first buy,TP:"+tp,2);
                    OpenPosition(Symbol(), OP_BUY, ll, sl, tp, MagicNumber,make_order_comment("buy"));
                    if(doubleorder==1)
                        OpenPosition(Symbol(), OP_SELL, ll, slr,tpr, MagicNumber,make_order_comment("sell"));
                    }
                    if(check_sell_conditions()) // sell order 
                    {
                    skdebug("first sell ,TP:"+tpr,2);
                    OpenPosition(Symbol(), OP_SELL, ll, slr, tpr, MagicNumber,make_order_comment("sell"));
                    //Sleep(5000);
                    if(doubleorder==1)
                        OpenPosition(Symbol(), OP_BUY, ll, sl,tp, MagicNumber,make_order_comment("buy"));
                    }
                }
                
                
                
                
            }
            else
                skdebug("required orders already in place"+totalorderscount+" > "+maxlots,dbgcheck2);
            return(0);
        }

    int new_complementry_order(int skclosedordertype1,int orginalticket,string msg1) // place new complementry orders while closing another order .
        {
            double ll=0,tp=0,sl=0,slr=0,tpr=0,llbuy=0,llsell=0;
            double  ma=iMA(NULL,0,12,6,MODE_SMA,PRICE_CLOSE,0);
            totalorderscount=CalculateCurrentOrders("all");
            currenttime=TimeCurrent();
            string ordercomment="c_"+msg1;
            //string ordercomment1="support"+totalorderscount+"+"+currenttime;
            //sl and target setting 
                if(sktakeprofit!=0 && linegap!=0) 
                    {
                    tp =Ask+((sktakeprofit*usdtopoints)*linegap);
                    tpr=Bid-((sktakeprofit*usdtopoints)*linegap);
                    }
                if(sk_stop_loss_inr!=0 && linegap!=0) 
                    {
                    sl =Bid-((sk_stop_loss_inr*usdtopoints)*linegap);
                    slr=Ask+((sk_stop_loss_inr*usdtopoints)*linegap);
                    }
            
            
            //if(OrdersTotal()<maxlots)
            if(totalorderscount>=maxlots)
                skdebug("Max orders allowed = "+maxlots+" and current orders count = "+totalorderscount,dbgcomp2);
            if(totalorderscount<=maxlots)
                {
                    //if(increaselots==1)     ll=sklevel_lotsize;
                    llbuy=llsell=Lots;
                    if(increaselots==1)    { llbuy=Lots*skbuy_lotsize; llsell=Lots*sksell_lotsize;}
                        //ll=Lots*(1+totalorderscount);
                        
                    skdebug("last closed order #"+orginalticket+" type "+skclosedordertype1+" New Complementry Order comment will be :"+ordercomment,dbgcomp2);
                    if(complementry_order==2 || 
                        (complementry_order==1 && skclosedordertype1==OP_SELL) || 
                        (complementry_order==3 && skclosedordertype1==OP_BUY))
                        {
                        skdebug("random number from caller = "+randomname,dbgcomp2);
                        if(OpenPosition(Symbol(), OP_BUY, llbuy, sl, tp, MagicNumber,make_order_comment("buy")))
                            skdebug("for order #"+orginalticket+" complementry Buy order placed successfully with comment="+ordercomment,dbgcomp1);
                        else
                            skdebug("for order #"+orginalticket+" complementry buy order failed to be placed",dbgcomp1);
                        }
                    Sleep(500);
                    if(complementry_order==2 || 
                        (complementry_order==1 && skclosedordertype1==OP_BUY) || 
                        (complementry_order==3 && skclosedordertype1==OP_SELL))
                        {
                        skdebug("random number from caller = "+randomname,dbgcomp2);
                            if(OpenPosition(Symbol(), OP_SELL, llsell, slr,tpr, MagicNumber,make_order_comment("sell")))
                                skdebug("for order #"+orginalticket+" complementry sell order placed successfully with comment"+ordercomment,dbgcomp1);
                                else
                                skdebug("for order #"+orginalticket+" complementry sell order failed to be placed",dbgcomp1);
                        }
                }
            return(0);
        }

    int OpenPosition(string sy, int op, double ll, double sl=0, double tp=0, int mn=0, string cm ="")
        {
            color    clOpen;
            datetime ot;
            double   pp, pa, pb;
            int      dg, err, it, ticket=0;
            string   skmsg=cm;

                if(skreverse==True)
                {
                    int opp;
                    if(op==OP_BUY)
                        opp=OP_SELL;
                    if(op==OP_SELL)
                        opp=OP_BUY;
                    op=opp;
                    skdebug(" skreverse : Asked to "+op+" but doing ="+opp,dbgmust);
                }

            if(sy=="" || sy=="0")
                sy=Symbol();
            if(op==OP_BUY)
                clOpen=Green;
            else
                clOpen=Red;

            //for(it=1; it<=POPYTKY; it++)
            for(it=1; it<=2; it++)
                {
                if(!IsTesting() && (!IsExpertEnabled() || IsStopped()))
                {
                    skdebug("OpenPosition(): ",1);
                    break;
                }
                int retry_count=0;
                while(!IsTradeAllowed() && retry_count<1 )
                    {
                        retry_count++;
                        skdebug("ERR:"+GetLastError()+" Live trading not enabled:Enable in common setting of expert properties.",dbgmust);
                        Sleep(1000);

                    }

                if(retry_count==5 && !IsTradeAllowed() )
                    {
                        skdebug("Critical issue with terminal: stopping trades ",dbgmust);
                        executetrades=False;
                    }
                RefreshRates();

                dg=(int)MarketInfo(sy, MODE_DIGITS);
                pa=MarketInfo(sy, MODE_ASK);
                pb=MarketInfo(sy, MODE_BID);
                if(op==OP_BUY)
                    pp=pa;
                else
                    pp=pb;
                pp=NormalizeDouble(pp, dg);
                ot=TimeCurrent();
                //----+
                totalorderscount=CalculateCurrentOrders("all");

                if(AccountFreeMarginCheck(Symbol(),op, ll)<=0 || GetLastError()==134 || ( maxlots_check_foreachorder==1 && totalorderscount>maxlots ) )
                    {
                        if(AccountFreeMarginCheck(Symbol(),op, ll)<=0)
                            skdebug("margin khatam: for new order of lots"+ll+" free margin="+AccountFreeMargin()+" err="+GetLastError(),dbgcheck2);
                    skdebug("Try lower lot size : order not sent to terminal : Total orders : "+totalorderscount +" err="+GetLastError(),dbgcheck2);
                    //next_lot_size=Lots;
                    //lotsize_increase=",single,";
                    ll=Lots;
                    skdebug("changed the next_lot_size from"+ll+" to "+Lots +" lotsize_increase from"+lotsize_increase+" to single",dbgcheck2);
                    if(AccountFreeMarginCheck(Symbol(),op, ll)<=0)
                        {
                        skdebug("even the lowest lot size"+Lots+" not able to execute ",dbgcheck2);
                        return(0);

                        }
                    }
                if( executetrades == False)
                {
                    skdebug("Order execution is not set to true change it in settings ",dbgmust);
                    return(0);
                }
                //----+

                //skmsg="S:"+spreadsize+"_P:"+AccountProfit()+"_"+closeall_if_profit_inr;
                int take_away=getequity()-start_balance;
                double current_profit=sktotalprofit;
                //skmsg=skmsg+"_S"+NormalizeDouble(spreadsize,2)+"_P"+current_profit+"/"+NormalizeDouble(closeall_if_profit_inr,2)+"_E"+current_equity;
                skmsg="#"+(CalculateCurrentOrders("all")+1)+"R"+NormalizeDouble(skind_rsi_currentvalue,0)+"S"+NormalizeDouble(spreadsize,2)+"P"+current_profit+"/"+NormalizeDouble(closeall_if_profit_inr,1)+"#"+take_away;
                //skdebug("Before open new postion : spread="+(Ask-Bid),dbgcheck2);
                skdebug(op+"just before new order:Symbol:"+sy+":what:"+ getordertype_name(op)+":size:"+ ll+":price:"+ pp+ "SL:"+sl+"TP:"+ tp+":msg:"+skmsg,dbgmust);
                if(is_spread_ok("openpostion")==False)
                    return(0);
                //check_spread_recursively();
                ticket=OrderSend(sy, op, ll, pp, Slippage, sl, tp, skmsg, mn, 0, clOpen);
                if(ticket>0)
                    {
                    second_last_order_price=last_order_price;
                    last_order_price=pp;
                    if(check_input(update_status,"eachorder") ) msg_last_sent=100;
                    toal_transacted_lots+=ll;
                    total_transacted_orders++;
                    order_count_til_profit++;
                    lots_count_till_profit+=ll;
                    skdebug("NEWORDER:Count="+total_transacted_orders+" lots="+toal_transacted_lots+balance_info_string(),dbgonew);
                    print_log_messages(skdebuglevel);

                    if(  check_input(lotsize_increase_input,",pacifiy_") && pacifier_order==1 && CalculateCurrentOrders("all")>1 ) 
                        {
                            if( ( op==OP_BUY && last_order_price<second_last_order_price )
                                || ( op==OP_SELL && last_order_price>second_last_order_price )  ) 
                                    pacify_order_plus++;
                            if( ( op==OP_BUY && last_order_price>second_last_order_price )
                                || ( op==OP_SELL && last_order_price<second_last_order_price )  ) 
                                    pacify_order_minus++;
                           pacifier_order=0; 
                            
                        }

                    //draw next up down line 
                    automanage_gap();
                    double next_up_price=last_order_price+mygap;
                    double next_down_price=last_order_price-mygap;
                    draw_hline("next_up",(next_up_price-last_order_price),next_up_price,clrBlue,1);
                    draw_hline("next_down",(last_order_price-next_down_price),next_down_price,clrBrown,1);
                    skdebug("check1:skprice="+skprice+" skpoints_gap_between_orders="+skpoints_gap_between_orders+" nu="+next_up_price+" nd="+next_down_price,dbgcheck1);
                    }
                

                if(ticket>0)
                {
                    //PlaySound("ok.wav");

                    break;
                }
                else
                {
                    err=myerrmsg();
                    if(pa==0 && pb==0)
                    skdebug("some error occured for buying position",dbgerr);
                    skdebug("Error("+err+") opening position: "+ErrorDescription(err)+", try "+it,dbgerr);
                    skdebug("Ask="+pa+" Bid="+pb+" sy="+sy+" ll="+ll+" op="+getordertype_name(op)+
                        " pp="+pp+" sl="+sl+" tp="+tp+" mn="+mn,dbgerr);
                    if(err==2 || err==64 || err==65 || err==133)
                    {
                    gbDisabled=True;
                    break;
                    }
                    if(err==4 || err==131 || err==132)
                    {
                    Sleep(1000*300);
                    break;
                    }
                    if(err==128 || err==142 || err==143)
                    {
                    Sleep(1000*66.666);
                    if(ExistPositions(sy, op, mn, ot))
                        {
                        skdebug("order exist so exiting ",2);
                        PlaySound("ok.wav");
                        break;
                        }
                    }
                    if(err==140 || err==148 || err==4110 || err==4111)
                    break;
                    if(err==141)
                    Sleep(1000*100);
                    if(err==145)
                    Sleep(1000*17);
                    if(err==146)
                    retry_count=0;
                    while(IsTradeContextBusy() && retry_count<5 )
                        {
                            retry_count++;
                            skdebug("busy terminal hung issue : will retry again after 5 seconds count="+retry_count,dbgmust);
                            Sleep(5000);

                        }

                if(retry_count==5 && !IsTradeAllowed() )
                    {
                        skdebug("Critical issue with terminal: stopping trades ",dbgmust);
                        executetrades=False;
                    }
                    
                    if(err!=135)
                    Sleep(1000*7.7);
                }
                }
            return(ticket);
        }

// CLose postions functions 
    void put_hard_stop()
        {
            if(check_input(whentosqoff,",onedaystoponloss,") )
                {
                    closeall_orders("all","hard stop");
                    daytoavoid=DayOfWeek();
                    skdebug("HARD STOP due to loss : no further work for today : see you tomorrow : ",dbgmust);
                }
        }
    
    bool good_day_to_work()
         {
            // daytoavoid is global variable set when any condition sets it 
               if(DayOfWeek()==daytoavoid )
                  return (False);
                 else
                  {
                     daytoavoid=100;
                     return(True);
                  }
         }        

    void profit_after_how_many_orders()
        {
            int order_count_til_profit=CalculateCurrentOrders("all");
            if(order_count_til_profit==1) profit_with_orders_1++;
            else if(order_count_til_profit==2) profit_with_orders_2++;
            else if(order_count_til_profit==3) profit_with_orders_3++;
            else if(order_count_til_profit==4) profit_with_orders_4++;
            else if(order_count_til_profit==5) profit_with_orders_5++;
            else if(order_count_til_profit==6) profit_with_orders_6++;
            else if(order_count_til_profit==7) profit_with_orders_7++;
            else if(order_count_til_profit==8) profit_with_orders_8++;
            else if(order_count_til_profit==9) profit_with_orders_9++;
            else if(order_count_til_profit==10) profit_with_orders_10++;
            else if(order_count_til_profit>10)  { profit_with_orders_10more++; }

            profit_with_orders_max=MathMax(profit_with_orders_max, order_count_til_profit);
            
            double total_wins=profit_with_orders_1+profit_with_orders_2+profit_with_orders_3+profit_with_orders_4+profit_with_orders_5+profit_with_orders_6+profit_with_orders_7+profit_with_orders_8+profit_with_orders_9+profit_with_orders_10+profit_with_orders_10more;

            //else if(order_count_til_profit==pattern_input_count-1) profit_with_orders_max++;
            if(total_wins>0 )
                {
                int percent1=int(profit_with_orders_1*100/total_wins);
                int percent2=int((profit_with_orders_2+profit_with_orders_1)*100/total_wins);
                int percent3=int((profit_with_orders_3+profit_with_orders_2+profit_with_orders_1)*100/total_wins);
                int percent4=int((profit_with_orders_4+profit_with_orders_3+profit_with_orders_2+profit_with_orders_1)*100/total_wins);
                int percent5=int((profit_with_orders_5+profit_with_orders_4+profit_with_orders_3+profit_with_orders_2+profit_with_orders_1)*100/total_wins);
                int percent6=int((profit_with_orders_6+profit_with_orders_5+profit_with_orders_4+profit_with_orders_3+profit_with_orders_2+profit_with_orders_1)*100/total_wins);
                int percent7=int((profit_with_orders_7+profit_with_orders_6+profit_with_orders_5+profit_with_orders_4+profit_with_orders_3+profit_with_orders_2+profit_with_orders_1)*100/total_wins);
                int percent8=int((profit_with_orders_8+profit_with_orders_7+profit_with_orders_6+profit_with_orders_5+profit_with_orders_4+profit_with_orders_3+profit_with_orders_2+profit_with_orders_1)*100/total_wins);
                int percent9=int((profit_with_orders_9+profit_with_orders_8+profit_with_orders_7+profit_with_orders_6+profit_with_orders_5+profit_with_orders_4+profit_with_orders_3+profit_with_orders_2+profit_with_orders_1)*100/total_wins);
                int percent10=int((profit_with_orders_10+profit_with_orders_9+profit_with_orders_8+profit_with_orders_7+profit_with_orders_6+profit_with_orders_5+profit_with_orders_4+profit_with_orders_3+profit_with_orders_2+profit_with_orders_1)*100/total_wins);
               skprofit_orders_string="profit orders 1="+profit_with_orders_1+"("+percent1+") 2="+profit_with_orders_2+"("+percent2+") 3="+profit_with_orders_3+"("+percent3+") 4="+profit_with_orders_4+"("+percent4+") 5="+profit_with_orders_5+"("+percent5+") 6="+profit_with_orders_6+"("+percent6+") 7="+profit_with_orders_7+"("+percent7+") 8="+profit_with_orders_8+"("+percent8+") 9="+profit_with_orders_9+"("+percent9+") 10="+profit_with_orders_10+"("+percent10+") 10+="+profit_with_orders_10more+" max="+profit_with_orders_max;
                }
                

        }
    void close_all_if_equity_profit()
        {
            bool temp2;
            double brokerage_till_now=lots_count_till_profit*brokerageperlot;
            if(check_input(lotsize_increase_input,",consider_brokerage,"))
                sktotalprofit=sktotalprofit-brokerage_till_now;
            if(closeall_if_profit_inr>0)
                //if( getequity() > ( start_balance+closeall_if_profit_inr) )
                if( sktotalprofit > ( closeall_if_profit_inr) )
                {
                    int orders_count_till_profit_1=order_count_til_profit;
                    skdebug("Profit exit : closing all orders as equity balance changed from "+start_balance+" to "+getequity(),dbgcheck1);
                    closeall_orders("all","equity profit all close");
                    start_balance=getequity();
                    new_counts++;
                    draw_vline("wins="+new_counts+" in"+orders_count_till_profit_1+"\nP"+NormalizeDouble(sktotalprofit,2)+"B"+NormalizeDouble(brokerage_till_now,2)+"/TP"+int(total_profit_accumulated)+"E="+getequity(),skprice,clrLime,1);
                    PlaySound("alert.wav");
                    next_lot_size=Lots;  
                    print_log_messages(skdebuglevel);
                    order_count_til_profit=0;
                    lots_count_till_profit=0;
                    pacify_order_plus=0;pacify_order_minus=0;   

                }

            if(closeall_if_loss_inr>0 || check_input(whentosqoff,",rsiclose,") )
                if( getequity() < ( start_balance-closeall_if_loss_inr) && closeall_if_loss_inr>0 || (skind_rsi_currentvalue >= 40 && skind_rsi_currentvalue <= 60  && CalculateCurrentOrders("all")>=5 && check_input(whentosqoff,",rsiclose,") ) )
                {
                    skdebug("LOSS exit : closing all orders as equity balance changed from "+start_balance+" to "+getequity(),dbgcheck1);
                    closeall_orders("all","equity loss close all ");
                    sleep_minutes(wait_minutes_afterloss);
                    if(check_input(buysell_conditions,",autoreverse,"))
                        {
                            if(skreverse==True) temp2=False;
                            else if(skreverse==False) temp2=True;
                            skreverse=temp2;
                        }
                    start_balance=getequity();
                    loss_count++;
                    draw_vline("Loss_count"+loss_count+" "+getequity(),skprice,clrPink,1);
                    //put_hard_stop();
                    print_log_messages(skdebuglevel);
                    order_count_til_profit=0;  
                    //if(skreverse_input==True)
                        //flip_reverse_signal(); 

                }
            

        }

    void sqoff_if_direction_changed()
        {
            if(last_order_type==OP_SELL && (skprice > last_order_price+mygap) 
                || last_order_type==OP_BUY && (skprice < last_order_price-mygap)  )
                {
                        exit_on_tp_or_sl("tp");
                }
        }


    bool ExistPositions(string sy="", int op=-1, int mn=-1, datetime ot=0)
        {
            int i, k=OrdersTotal();

            if(sy=="0")
                sy=Symbol();
            for(i=0; i<k; i++)
                {
                if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
                {
                    if(OrderSymbol()==sy || sy=="")
                    {
                    if(OrderType()==OP_BUY || OrderType()==OP_SELL)
                        {
                        if(op<0 || OrderType()==op)
                            {
                            if(mn<0 || OrderMagicNumber()==mn)
                            {
                                if(ot<=OrderOpenTime())
                                return(True);
                            }
                            }
                        }
                    }
                }
                }
            return(False);
        }

    void skcloseorder(int tickettoclose)
        {
                    //close the order 
                    skdebug("will sqoff order # "+tickettoclose+" with lots="+OrderLots()+" and profit "+OrderProfit() , dbgsqoff);
                    OrderClose(tickettoclose,OrderLots(),mysqoff_price("check"),Slippage,mysqoff_color("check"));
                    print_log_messages(skdebuglevel);
        }

    double mysqoff_price(string whattodo)
        {

            double returnvalue=0;
            RefreshRates();
            returnvalue=Ask;
            if(whattodo=="buy") returnvalue=Bid;
            if(whattodo=="check") 
                {
                    if(OrderType()==OP_BUY) returnvalue=Bid;
                }
            
            skdebug("to sqoff "+whattodo+" order price="+returnvalue + " Ask="+Ask + " Bid="+Bid ,dbgcheck1);
            return(returnvalue);
        }

    color mysqoff_color(string whattodo)
        {
            color returnvalue=clrBrown;
            if(whattodo=="buy") returnvalue=clrBlue;
            if(whattodo=="check") 
                {
                    if(OrderType()==OP_BUY) returnvalue=clrBlue;
                }

            return(returnvalue);
        }

    int closeall_orders(string whichorderstoclose,string whocalled)
        {

            skdebug("closeall orders intiated by "+whocalled,dbgmust);
            profit_after_how_many_orders();
            order_count_til_profit=0;   
            int returnvalue,kk,mm,repeat_count=0;
            bool check_all_orders=True, repeat_close=True;

                skdebug("initiated close all "+whichorderstoclose+" orders",dbgclose1);
            while(repeat_close && repeat_count<10)
            {
                repeat_count++;
                if(whichorderstoclose=="buy" || whichorderstoclose=="sell" || whichorderstoclose=="all")
                    {
                        mm=CalculateCurrentOrders(whichorderstoclose);
                        if( mm<=0)
                            {
                                skdebug("there are no orders to close for "+whichorderstoclose,dbgcheck1);
                                check_all_orders=False;
                                repeat_close=False;
                                return(1);
                            }
                    }
                    else
                            {
                            string comment_to_check_in_orders="none";
                            if(whichorderstoclose=="levelbuy") comment_to_check_in_orders="buy_level_"+sklevel_current;
                            if(whichorderstoclose=="levelsell") comment_to_check_in_orders="sell_level_"+sklevel_current;
                            //repeat_close=True;
                            }
                
                //kk=CalculateCurrentOrders("all");
                //while ( OrdersTotal() > 0)
                //if( (whichorderstoclose=="sell" && sksellcount>0 ) || (whichorderstoclose=="buy" && skbuycount>0) || (whichorderstoclose=="all" && kk>0))
                if( check_all_orders )
                {
                    if(check_input(update_status,",closeall,") ) msg_last_sent=100;
                kk=OrdersTotal();
                skdebug("will close all "+whichorderstoclose+" orders : count= "+kk+"("+skbuycount+"+"+sksellcount+")",dbgclose1);
                    for(int ii=0; ii< kk; ii++)
                    {
                        if( OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
                        {  //skdebug("1Closing the order :"+OrderTicket()+" at position #"+ii,dbgclose1);
                            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
                            {  
                                if ( check_input(OrderComment(),whichorderstoclose)  || whichorderstoclose=="all" ) 
                                    {
                                        skdebug("Closing "+whichorderstoclose+" order#"+OrderTicket()+" at position #"+ii,dbgclose1);
                                        OrderPrint();
                                        if(OrderClose(OrderTicket(),OrderLots(),mysqoff_price("check"),Slippage,mysqoff_color("check")) )
                                            {
                                                total_profit_accumulated+=OrderProfit();
                                                skdebug("Success Closing "+whichorderstoclose+" order#"+OrderTicket()+" at position #"+ii,dbgclose1);
                                            }
                                        else
                                            skdebug("Failed Closing "+whichorderstoclose+" order#"+OrderTicket()+" at position #"+ii+myerrmsg(),dbgclose1);
                                        
                                    }
                                    
                                    
                            }

                        }
                        else   skdebug("dgcheck1 : Order selection error for order#"+ii+" err="+myerrmsg(),dbgerr);
                        
                    }
                }          
                if(CalculateCurrentOrders(whichorderstoclose) >0 ) 
                    { 
                        returnvalue=0; 
                        repeat_close=True ; 
                        skdebug("current Orders ="+CalculateCurrentOrders("all"),dbgcheck1);          
                        skdebug("Still open orders will repeat again ",dbgcheck1);
                        } 
                    else 
                    {
                        repeat_close=False ; 
                        returnvalue=1;
                    }
            }
            print_log_messages(skdebuglevel);
            return(returnvalue);
        }

    string order_type_name(int whichorder)
        {
            if(whichorder==OP_BUY) return("buy");
               else return("sell");
        }

    int closeall_orders_except_self_level(string whichorderstoclose)
        {
            int returnvalue,kk,mm,repeat_count=0;
            bool check_all_orders=True, repeat_close=True;

                skdebug("initiated close all "+whichorderstoclose+" orders",dbgclose1);
            while(repeat_close && repeat_count<5)
            {
                repeat_count++;
                if(whichorderstoclose=="buy" || whichorderstoclose=="sell" || whichorderstoclose=="all")
                    {
                        mm=CalculateCurrentOrders(whichorderstoclose);
                        if( mm<=0)
                            {
                                skdebug("there are no orders to close for "+whichorderstoclose,dbgcheck1);
                                check_all_orders=False;
                                repeat_close=False;
                                return(1);
                            }
                    }
                    else
                            {
                            string comment_to_check_in_orders="none";
                            if(whichorderstoclose=="levelbuy") comment_to_check_in_orders="buy_level_"+sklevel_current;
                            if(whichorderstoclose=="levelsell") comment_to_check_in_orders="sell_level_"+sklevel_current;
                            //repeat_close=True;
                            }
                
                //kk=CalculateCurrentOrders("all");
                //while ( OrdersTotal() > 0)
                //if( (whichorderstoclose=="sell" && sksellcount>0 ) || (whichorderstoclose=="buy" && skbuycount>0) || (whichorderstoclose=="all" && kk>0))
                if( check_all_orders )
                {
                    if(check_input(update_status,",closeall,") ) msg_last_sent=100;
                kk=OrdersTotal();
                skdebug("will close all "+whichorderstoclose+" orders : count= "+kk+"("+skbuycount+"+"+sksellcount+")",dbgclose1);
                    for(int ii=0; ii< kk; ii++)
                    {
                        if(OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
                        {  //skdebug("1Closing the order :"+OrderTicket()+" at position #"+ii,dbgclose1);
                            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
                            {  
                                string self_level_comment=make_order_comment(order_type_name(OrderType()));
                                if ( OrderComment()==self_level_comment)
                                    {
                                        skdebug(self_level_comment+":skipping to close same level order",dbgcheck1);
                                        continue;
                                    }
                                if ( check_input(OrderComment(),whichorderstoclose)  || whichorderstoclose=="all" ) 
                                    {
                                        skdebug("Closing "+whichorderstoclose+" order#"+OrderTicket()+" at position #"+ii,dbgclose1);
                                        OrderPrint();
                                        if(OrderClose(OrderTicket(),OrderLots(),mysqoff_price("check"),Slippage,mysqoff_color("check")) )
                                        skdebug("Success Closing "+whichorderstoclose+" order#"+OrderTicket()+" at position #"+ii,dbgclose1);
                                        else
                                            skdebug("Failed Closing "+whichorderstoclose+" order#"+OrderTicket()+" at position #"+ii+myerrmsg(),dbgclose1);
                                    
                                    }
                                    
                                    
                            }

                        }
                        else   skdebug("dgcheck1 : Order selection error for order#"+ii+" err="+myerrmsg(),dbgerr);
                        
                    }
                }          
                if(CalculateCurrentOrders(whichorderstoclose) >1 ) 
                    { 
                        returnvalue=0; 
                        repeat_close=True ; 
                        skdebug("current Orders ="+CalculateCurrentOrders("all"),dbgcheck1);          
                        skdebug("Still open orders will repeat again ",dbgcheck1);
                        } 
                    else 
                    {
                        repeat_close=False ; 
                        returnvalue=1;
                    }
            }
            
            return(returnvalue);
        }

    int exit_on_tp_or_sl(string whichorderstoclose)
        {
            int returnvalue,kk,mm;
            double sqoff_price=0;
            kk=OrdersTotal();
            //if( (whichorderstoclose=="sell" && sksellcount>0 ) || (whichorderstoclose=="buy" && skbuycount>0) || (whichorderstoclose=="all" && kk>0))
            if( kk>0 )
            {
            skdebug("will close  "+whichorderstoclose+" orders : total orders count= "+kk,dbgclose2);
                for(int ii=0; ii< kk; ii++)
                {
                    if(OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
                    {  //skdebug("1Closing the order :"+OrderTicket()+" at position #"+ii,dbgclose1);
                        if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
                        {  
                            int cr_ord_type=OrderType();
                            string cr_ord_comment=OrderComment();
                            int cr_ord_ticket=OrderTicket();
                            double cr_ord_lots=OrderLots();
                            double cr_ord_profit=OrderProfit();
                            bool sksl_triggered=False;
                            //if(check_input(whichorderstoclose,"tpsell") || check_input(whichorderstoclose,"tpbuy"))
                              //  sktakeprofit=skpoints_gap_between_orders/10;

                            if(sk_stop_loss_inr>0)
                                sksl_triggered=cr_ord_profit < (-1*sk_stop_loss_inr*cr_ord_lots/Lots);
                            bool skprofit_triggered=False;
                            if(sktakeprofit>0)
                                if(profit_method=="perlotsize")
                                    skprofit_triggered=cr_ord_profit > (sktakeprofit*(cr_ord_lots/Lots));
                                    else if(profit_method=="fullorder")
                                        skprofit_triggered=cr_ord_profit > (sktakeprofit);
                            if(check_input(cr_ord_comment,"quick"))
                                {
                                    if(sktakeprofit_input_quick_inr>0)
                                    if(profit_method=="perlotsize")
                                    skprofit_triggered=cr_ord_profit > (sktakeprofit_input_quick_inr*(cr_ord_lots/Lots));
                                    else if(profit_method=="fullorder")
                                        skprofit_triggered=cr_ord_profit > (sktakeprofit_input_quick_inr);
                                    skdebug("Taking quick profit",dbgcheck2);
                                }

                                    skdebug("skprofit_triggered="+skprofit_triggered+" in exit comment="+cr_ord_comment+" quickinr="+sktakeprofit_input_quick_inr,dbgcheck2);

                            if((whichorderstoclose=="all" || check_input(whichorderstoclose,"tp") ) && skprofit_triggered)
                            {
                                    if( (  OrderType()==OP_BUY && check_input(whichorderstoclose,"tpsell") ) 
                                        || (OrderType()==OP_SELL && check_input(whichorderstoclose,"tpbuy") ))
                                            continue;

                                    //OrderPrint();
                                    if(OrderClose(OrderTicket(),OrderLots(),mysqoff_price("check"),Slippage,mysqoff_color("check")))
                                        skdebug("success Closing order with Profit="+ cr_ord_profit+" order#"+OrderTicket()+" at position #"+ii+
                                        "|sqoffprice="+sqoff_price+"|profitset="+sktakeprofit+"("+sktakeprofit*(cr_ord_lots/Lots)+")",dbgclose1);
                                    else
                                        skdebug("Failed Closing order with Profit="+ cr_ord_profit+" order#"+OrderTicket()+" at position #"+ii+"|sqoffprice="+sqoff_price+" Err="+myerrmsg(),dbgerr);
                                    if(check_input(update_status,",tp,") ) msg_last_sent=100;
                           
                            }
                            else if((whichorderstoclose=="all" || whichorderstoclose=="sl" ) && sksl_triggered)
                            {
                                    if( (  OrderType()==OP_BUY && check_input(whichorderstoclose,"slsell") ) 
                                        || (OrderType()==OP_SELL && check_input(whichorderstoclose,"slbuy") ))
                                            continue;

                                    //OrderPrint();
                                    if(OrderClose(OrderTicket(),OrderLots(),mysqoff_price("check"),Slippage,mysqoff_color("check") ))
                                        skdebug("Success :Closing order with Loss="+ cr_ord_profit+" order#"+OrderTicket()+" at position #"+ii+"|sqoffprice="+sqoff_price,dbgclose1);
                                    else
                                        skdebug("Failed :Closing order with Loss="+ cr_ord_profit+" order#"+OrderTicket()+" at position #"+ii+"|sqoffprice="+sqoff_price+" Err="+myerrmsg(),dbgerr);
                                if(check_input(update_status,",sl,") ) msg_last_sent=100;
                            }
                        }
                        //else   skdebug("Order closing error for order#"+ii+" err="+myerrmsg(),dbgerr);

                    }
                    else   skdebug("Order selection error for order#"+ii+" err="+myerrmsg(),dbgerr);
                    
                }
            }          
                
                return(1);
        }
   

// COMMENTED Do money calculations 
    /*
        void skmoney_deposit(int amount)
            {
                skmoney_total_reserve=skmoney_total_reserve-amount;
                skmoney_total_running=skmoney_total_running+amount;
            }
        void skmoney_withdraw(int amount)
            {
                skmoney_total_reserve+=amount;
                skmoney_total_running-=amount;
            }
        void update_total_profit(double amount)
            {
                skmoney_total_profit+=amount;
            }

    */
// some calculations and display on chart 
    double total_open_profit_loss()
        {
            double skprofit=0;
            //---
            for(int x=0; x<OrdersTotal(); x++)
                {
                if(OrderSelect(x,SELECT_BY_POS,MODE_TRADES)==false)
                    break;
                if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
                {
                    skprofit+=OrderProfit();
                    skdebug("current PR:"+OrderProfit()+" total:"+skprofit,5);
                }
                }
            //--- return orders volume
            //if(buys>0)
            //  return(buys);
            //else
                return(skprofit);
        }

    
    void track_max_min_equity()
        {
            int max_equity_reached1=MathMax(max_equity_reached,getequity());
            int min_equity_reached1=MathMin(min_equity_reached,getequity());
            int max_loss_faced1=MathMin(max_loss_faced,sktotalprofit);
            if(max_loss_faced>sktotalprofit) 
                draw_vline("maxloss="+sktotalprofit+"\norders="+order_count_til_profit,skprice,clrRed,1);
            max_loss_faced=max_loss_faced1;
            max_equity_reached=max_equity_reached1;
            min_equity_reached=min_equity_reached1;
            max_order_count_til_profit=MathMax(max_order_count_til_profit,order_count_til_profit);

            skdebug("equity tracker:"+max_equity_reached+"|"+min_equity_reached,dbgcheck2);
            
            
        }
    void print_log_messages(string whichmessage)
        {
            if(check_input(whichmessage,"explore"))
            {
                string msg_to_show=first_order_direction+Symbol()+"#"+AccountNumber()+" N="+new_counts+" "+ balance_info_string()+
                    " L"+sklevel_current+"("+current_gap_from_start+"/"+max_gap_faced+")"+
                    " B="+buy_lots_total+"S="+sell_lots_total+"T="+int(toal_transacted_lots)+
                    " OC="+order_count_til_profit+"/"+max_order_count_til_profit+"/"+max_loss_faced+
                    "|" ;

                skdebug(msg_to_show,dbgexplore);
                skdebug("lotsize="+lots_to_start+" tpinr="+closeall_if_profit_inr +" "+skprofit_orders_string,dbgexplore);
                
            }
            
        }
    void display_details_onchart()
        {
            double crprofit=0;
            sktotalprofit=0;
            buy_lots_total=sell_lots_total=0;
            bool onlyfirst=False;
            lowest_sell_price=Ask;
            totalorderscount1=OrdersTotal();
            string buy_comment="",sell_comment="";
            double spreadsize1=NormalizeDouble((Ask-Bid)/usdtopoints,4);
            spreadsize=MarketInfo(Symbol(),MODE_SPREAD)*Point()/usdtopoints;
            if(IsTesting())
                spreadsize=MarketInfo(Symbol(),MODE_SPREAD)*Point()/usdtopoints;
            //spreadsize=spreadsize1;
            double ap=NormalizeDouble(AccountProfit(),1);
            int balance=AccountBalance(),size1;  
            margin_used_max=MathMax(margin_used_max,AccountMargin());
            margin_free=AccountFreeMargin();
            margin_free_min=MathMin(margin_free_min,AccountFreeMargin());
            

            if(CalculateCurrentOrders("all")==0)
                {
                    top_price_order=least_price_order=0;   
                    first_order_number=first_order_price=sklevel_start_price=0;
                    last_order_price=last_order_size=last_order_type=0;
                    order_count_til_profit=0;
                    next_lot_size=0;

                }

            sksellcount=skbuycount=positivecount=negativecount=positivecount_buy=positivecount_sell=negativecount_buy=negativecount_sell=0;
            string sksign="+";
                //---
                for(int x=0; x<totalorderscount1; x++)
                    {
                    if(OrderSelect(x,SELECT_BY_POS,MODE_TRADES)==false)
                    { skdebug("error in order selection of #"+x+" err="+myerrmsg(),dbgerr); break; }
                    if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
                    {
                        crprofit=OrderProfit();
                        //skdebug(" in display chart : index="+x,dbgerr);
                        //OrderPrint();
                        if(onlyfirst==False)
                            {
                                first_order_number=OrderTicket();
                                first_order_price=OrderOpenPrice();
                                sklevel_start_price=first_order_price;
                                onlyfirst=True;
                                top_price_order=least_price_order=first_order_price;

                                //first_order_direction=getordertype_name(OrderType());
                            }
                        // max lotsize fill 
                            max_lotsize_reached=MathMax(max_lotsize_reached,OrderLots());
                        // fill top and least order price 
                            top_price_order=MathMax(OrderOpenPrice(),top_price_order);
                            least_price_order=MathMin(least_price_order,OrderOpenPrice());
                        // fill details for second last order calculation 
                            second_last_order_price=last_order_price;
                            second_last_order_size=last_order_size;
                            second_last_order_type=last_order_type;
                        // fill details for last order calculation 
                            last_order_price=OrderOpenPrice();
                            last_order_size=OrderLots();
                            last_order_type=OrderType();
                            last_order_time=OrderOpenTime();
                        if(OrderType()==OP_BUY) 
                        {
                            skbuycount++;
                            buy_lots_total+=OrderLots();
                            size1=int(OrderLots()*100  );
                            lastbuy_order=OrderTicket();
                            lastbuy_lots=OrderLots();
                            lastbuy_price=OrderOpenPrice();
                            highest_buy_price=MathMax(highest_buy_price,OrderOpenPrice());
                            //buy_comment+=","+NormalizeDouble(OrderLots(),2);
                            if(crprofit>0)
                                { positivecount+=1; positivecount_buy+=1; sksign="+"; } 
                            if(crprofit<0)
                                {negativecount+=1; negativecount_buy+=1;sksign="-"; }

                            buy_comment+=","+size1+sksign;
                        }
                        if(OrderType()==OP_SELL) 
                        {
                            size1=int(OrderLots()*100  );
                            sksellcount++;
                            sell_lots_total+=OrderLots();
                            lastsell_order=OrderTicket();
                            lastsell_lots=OrderLots();
                            lastsell_price=OrderOpenPrice();
                            lowest_sell_price=MathMin(lowest_sell_price,OrderOpenPrice());

                            if(crprofit>0)
                                { positivecount+=1; positivecount_sell+=1;sksign="+";  } 
                            if(crprofit<0)
                                {negativecount+=1; negativecount_sell+=1;sksign="-";  }
                            sell_comment+=","+size1+sksign;
                        }
                        sktotalprofit+=crprofit;
                    }
                    }
                skbuy_lotsize=skbuycount+1;  // needs checking it is not good.
                sksell_lotsize=sksellcount+1; // needs checking it is not good.
                buy_lots_total=NormalizeDouble(buy_lots_total,2);
                sell_lots_total=NormalizeDouble(sell_lots_total,2);
                //skdebug("skpoints_gap_between_orders_input="+skpoints_gap_between_orders_input+"*((1+negativecount="+negativecount+")/maxlots="+maxlots+"  = ",dbgcheck1);
                //if(negativecount>0) 
                //{
                  //  double temp3=skpoints_gap_between_orders;
                   // skpoints_gap_between_orders=double(temp3*double(1+double(negativecount/maxlots)));
                //}

                check_mkt_movement();
                //actual_gap_from_last_order=int((skprice-last_order_price)/pointstousd);
                //current_gap_from_start=int((skprice-sklevel_start_price)/pointstousd);
                actual_gap_from_last_order=NormalizeDouble((skprice-last_order_price),5);
                current_gap_from_start=NormalizeDouble((skprice-sklevel_start_price),5);
                if (totalorderscount1>0) max_gap_faced=MathMax(max_gap_faced,MathAbs(current_gap_from_start));


            if(check_input(show_in_chart,",comment,")==True)  
            Comment("lost="+loss_count+" Wins="+new_counts+" of "+closeall_if_profit_inr+" equity="+int(getequity())+" last="+start_balance+"("+max_loss_faced+"/"+min_equity_reached+"|"+max_equity_reached+")"+skprofit_orders_string+
                    "\n     Orders T(P+N)="+(negativecount+positivecount)+"/"+pattern_input_count+"(",positivecount+"+"+negativecount,
                    ") B+S = "+skbuycount+"/"+positivecount_buy+"+"+sksellcount+"/"+positivecount_sell+
                    " Lots B+S("+buy_lots_total+"+"+sell_lots_total+"="+(buy_lots_total+sell_lots_total)+")"+max_lotsize_reached+"/"+int(toal_transacted_lots),
                    ") start="+int(opening_balance)+" NOW PRF="+int(sktotalprofit)+"("+int(ap)+")/"+max_loss_faced+" bal="+int(balance)+
                    " equity="+int(getequity())+"("+min_equity_reached+"|"+max_equity_reached+")",
                    " free="+int(AccountFreeMargin())+"("+margin_free_min+"/"+margin_used_max+") last_equity="+start_balance+" wait till=",(start_balance+closeall_if_profit_inr)+
                    " spread=",(spreadsize)+"/"+(ok_spread_input)+" TP="+sktakeprofit_input_inr,
                    "\n                                     BUY:"+buy_comment,
                    //"\n"+StringReplace(StringReplace(StringReplace(open_orders_list_buy,"level_",""),"_up",""),"_down",""),
                    "\n                                     SELL:"+sell_comment,
                    //"\n"+StringReplace(StringReplace(StringReplace(open_orders_list_buy,"level_",""),"_up",""),"_down",""),
                    "\n                                     Level=",sklevel_current," prev level=",sklevel_prev,
                    " Price skprice="+skprice+" level_0="+sklevel_start_price+"("+current_gap_from_start+
                    "/"+max_gap_faced+
                    ") last="+last_order_price+"("+int((skprice-last_order_price)/pointstousd)+")"+
                    " PO="+order_count_til_profit+"/"+max_order_count_til_profit+
                    "\n                                    next up="+sklevel_up_value+"/"+int((sklevel_up_value-skprice)/pointstousd)+
                    " down="+sklevel_down_value+"/"+int((skprice-sklevel_down_value)/pointstousd)+
                    " gap Needed="+readable_number(find_good_gap(10))+"/"+readable_number(skpoints_gap_between_orders)+"/"+readable_number(mygap)+" actual="+(actual_gap_from_last_order)+
                    " usd2p="+usdtopoints+" autogap="+skpoints_gap_between_orders_auto,
                    "\n                                    RSI=",int(skind_rsi_lastvalue),"_",int(skind_rsi_currentvalue),
                                "|macd=",int(skind_macd_lastvalue),"_",int(skind_macd_currentvalue),
                                "|signal=",int(skind_signal_lastvalue),"_",int(skind_signal_currentvalue)+
                    " MA"+skma4_periods+"="+skma4+" skma"+skma9_periods+"="+skma9+
                    "MA10="+skma10+" ma60="+skma60+" "+first_order_direction+
                    "\n                                   MKT MOVEMENT PREV="+skmkt_movement_prev+"| Current="+skmkt_movement+"| macdmove="+skind_macd_mkt+"| rsimove="+skind_rsi_mkt+
                    " Rev="+skreverse+
                    "\n"+"INPUTS="+buysell_conditions+" "+lotsize_increase+" "+pattern_inputs+
                    "\n"+"history:"+string_from_history+
                    "|");





        }
    double readable_number(double number1)
        {
            return(NormalizeDouble(number1/usdtopoints,2));
        }
// Some conditions 
    
    bool is_spread_ok(string wherecalled)
        {
            bool returnvalue=True;
            if(spreadsize  > ok_spread_input )
                {
                        if(spread_wait_count>spread_wait_count_input)
                            {
                                returnvalue=True;
                                skdebug("Spread not good but skipping after "+spread_wait_count_input+" retries |current="+spreadsize +" we need ="+ok_spread_input,dbgmust);
                            }
                        else
                        {
                            skdebug("Spread not good Trycount:"+spread_wait_count+"|current="+spreadsize +" we need ="+ok_spread_input,dbgcheck1);
                            returnvalue=False;
                            spread_wait_count++;
                            Sleep(1000);
                        }

                }
            if(spreadsize  <= ok_spread_input )
                {
                        skdebug("Spread check passed Trycount:"+spread_wait_count+"|current="+spreadsize +" we need ="+ok_spread_input,dbgmust);
                        returnvalue=True;
                }

            if(returnvalue==True)
                spread_wait_count=0;

            return(returnvalue);
        }
    void check_spread_recursively()
        {
                for (int spread_wait_count=0;spread_wait_count< spread_wait_count_input;spread_wait_count++)
                    {
                        RefreshRates();
                        if(is_spread_ok("recursive")==False)
                            {
                                spread_wait_count++;
                                Sleep(1000);
                            }
                        if(is_spread_ok("recursive")==True)
                            break;
                    }
        }
    void donotwork_if_conditions()
        {
            // Max amount needed reached then close all and quit .
            if(max_equity_required_INR!=0) 
                if(getequity() > max_equity_required_INR ) 
                    {
                        closeall_orders("all","do not work conditions all");
                        skdebug("we have got the target set of "+max_equity_required_INR+" in equity. have reached to "+getequity()+" from "+opening_balance,dbgcheck1);
                        letswork=False;
                        executetrades=False;
                        //deinit();
                    }

        }
  
   /* 
    void restart_work_after_ticks(int skticks)
        {

           if(suspend_work_for_someticks)
            {
                if(tickcounter>skticks)
                suspend_work_for_someticks=False;
                tickcounter==0;
                else
                tickcounter++;
            } 
        }
    */
    bool is_same_level_order_open(string whattodo)
        {
            bool returnvalue=False;
            string newcomment=make_order_comment(whattodo);
            for(int x=0; x<OrdersTotal(); x++)
                {
                if(OrderSelect(x,SELECT_BY_POS,MODE_TRADES))
                    if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
                    {
                        if(OrderComment()==newcomment)
                            {
                                returnvalue=True;
                                skdebug(whattodo+" Order at this level is alredy open",dbgcheck2);
                                //OrderPrint();
                                break;
                            }
                    }
                }
                return(returnvalue);
        }
    int iscomplementry_open(string commenttocheck,int skorderid)
        {
                int ii,kk;
                bool return_value;
                string ccc="c_"+commenttocheck;
                kk=CalculateCurrentOrders("all");

                skdebug("str to check:"+commenttocheck,7);
                for(ii=0; ii<kk; ii++)
                {
                    if(OrderSelect(ii, SELECT_BY_POS, MODE_TRADES))
                    {
                    if(OrderSymbol()==Symbol() && (OrderMagicNumber()==MagicNumber))
                    { 
                        skdebug("comment in order :"+OrderComment(),dbgcheck2);
                        if(StringFind(OrderComment(),ccc) >=0 )
                                {
                                return_value=True;
                                }
                    }
                    }
                    }
            return(return_value);
        }


    
// update lotsize gaps etc numbers 
    void update_lotsize_lotcount_tp()
        {
            int sklevel_balance=1;

            int lotscount_multiplier=int(MathMax(1,getequity()/increaselots_whenequityis));
            int sklevel_current_abs=MathAbs(sklevel_current);
            int balanced_current_level=sklevel_current_abs+sklevel_balance;
            lotsize_to_execute=Lots*lotscount_multiplier;
            lotsize_to_execute_buy=lotsize_to_execute_sell=lotsize_to_execute;

            if(check_input(lotsize_increase,",self_ordercount,"))
                {
                    lotsize_to_execute_buy=MathMin(maxlot_size_multiply,CalculateCurrentOrders("sell")) * Lots ;
                    lotsize_to_execute_sell=MathMin(maxlot_size_multiply,CalculateCurrentOrders("buy")) * Lots ;
                }
            
            if(check_input(lotsize_increase,",opposite_ordercount,"))
                {
                    lotsize_to_execute_sell=MathMin(maxlot_size_multiply,CalculateCurrentOrders("sell")) * Lots ;
                    lotsize_to_execute_buy=MathMin(maxlot_size_multiply,CalculateCurrentOrders("buy")) * Lots ;
                }

            if(check_input(lotsize_increase,",opposite_lotsize,"))
                {
                    if(CalculateCurrentOrders("sell")<1) 
                        lotsize_to_execute_sell=sell_lots_total ;
                        else if(CalculateCurrentOrders("buy")<1) 
                            lotsize_to_execute_buy=buy_lots_total ;
                }
                
            if(check_input(lotsize_increase,",1&1,"))
                {
                    lotsize_in_support=lotsize_in_direction=Lots;
                }
            if(check_input(lotsize_increase,",1&2,"))
                {
                    lotsize_in_support=Lots;
                    lotsize_in_direction=2*Lots;
                }
            if(check_input(lotsize_increase,",2&1,"))
                {
                    lotsize_in_direction=Lots;
                    lotsize_in_support=2*Lots;
                }


            if(check_input(lotsize_increase,",level&1,"))
                {
                    lotsize_in_direction=Lots;
                    lotsize_in_support=MathMin(maxlot_size_multiply,balanced_current_level)*Lots;
                }
            if(check_input(lotsize_increase,",1&level,"))
                {
                    lotsize_in_support=Lots;
                    lotsize_in_direction=MathMin(maxlot_size_multiply,balanced_current_level)*Lots;
                }
            if(check_input(lotsize_increase,",1&level_5,"))
                {
                    lotsize_in_support=Lots;
                    if(sklevel_current_abs>=5)
                        lotsize_in_direction=MathMin(maxlot_size_multiply,balanced_current_level)*Lots;
                        else
                    lotsize_in_direction=Lots*5;
                }
            if(check_input(lotsize_increase,",1&level_10,"))
                {
                    lotsize_in_support=Lots;
                    if(sklevel_current_abs>=10)
                        lotsize_in_direction=MathMin(maxlot_size_multiply,balanced_current_level)*Lots;
                        else
                    lotsize_in_direction=Lots*10;
                }

            if(check_input(lotsize_increase,",level&level-1,"))
                {
                    //skdebug("lot level changed to level-1",dbgcheck1);
                    lotsize_in_direction=MathMax(1,(MathMin(maxlot_size_multiply,balanced_current_level)-1))*Lots;
                    lotsize_in_support=MathMin(maxlot_size_multiply,balanced_current_level)*Lots;
                }
                
            if(check_input(lotsize_increase,",level-1&level,"))
                {
                    lotsize_in_support=MathMax(1,(MathMin(maxlot_size_multiply,balanced_current_level)-1))*Lots;
                    lotsize_in_direction=MathMin(maxlot_size_multiply,balanced_current_level)*Lots;
                }
                
            if(check_input(lotsize_increase,",level&level,"))
                {
                    lotsize_in_direction=lotsize_in_support=MathMin(maxlot_size_multiply,balanced_current_level)*Lots;
                }

            sktakeprofit=sktakeprofit_input_inr;
            //maxlots=MathMax(int(maxlots_count/4), int(maxlots_count*((20-lotscount_multiplier)/20)));
            maxlots=maxlots_count;

        }

    double price_to_use()
        {
            skprice=((Ask+Bid)/2);
            //skdebug("Ask="+Ask+" Bid="+Bid+" skprice="+skprice,dbgcheck1);
            return(skprice);
        }

//nextvalues
    void update_next_up_down_level_values()
        {
             skpoints_gap_between_orders=skpoints_gap_between_orders_input;
                    //if(!skpoints_gap_between_orders_auto) skpoints_gap_between_orders=skpoints_gap_between_orders_input;
            display_details_onchart();
            sklevel_start_price=first_order_price;

            sklevel_current=int((skprice-sklevel_start_price)/(skpoints_gap_between_orders*(1.01)*pointstousd));
            sklevel_prev=int((last_order_price-sklevel_start_price)/(skpoints_gap_between_orders*(1.02)*pointstousd));
            if(sklevel_start_price==0)
                {
                    sklevel_current=sklevel_prev=0;
                }
            if ( sklevel_current < 0 ) sklevel_current--;
            if ( sklevel_current > 0 ) sklevel_current++;
            if ( sklevel_prev < 0 ) sklevel_prev--;
            if ( sklevel_prev > 0 ) sklevel_prev++;
            
            sklevel_current_abs=MathAbs(sklevel_current);
            int sklevel_prev_abs=MathAbs(sklevel_current);

            sklevel_up_value=last_order_price+(skpoints_gap_between_orders*pointstousd);
            sklevel_down_value=last_order_price-(skpoints_gap_between_orders*pointstousd);

            //levels number will get impacted due to non-unique 
            if(skpoints_gap_between_orders_auto)
                if(sklevel_current_abs>3 && CalculateCurrentOrders("all") > 2 )
                    {
                        if(sklevel_current>0)
                            sklevel_up_value=last_order_price+(skpoints_gap_between_orders*pointstousd)*sklevel_current_abs;
                        if(sklevel_current<0)
                            sklevel_down_value=last_order_price-(skpoints_gap_between_orders*pointstousd)*sklevel_current_abs;
                    }


            if(sklevel_prev!=sklevel_current)
                {
                    skdebug("Level changed from "+sklevel_prev+" to "+sklevel_current+" and gaptouse="+sklevel_gap_touse+
                            " target UP="+sklevel_up_value+" Down="+sklevel_down_value+" oktotrade="+oktotrade,dbgcheck2);
                    skdebug("setting normal gaps up="+sklevel_up_value+" down="+sklevel_down_value,dbgcheck2);
                    skdebug("highest_buy_price="+highest_buy_price+" lowest_sell_price="+lowest_sell_price,dbgcheck2);
                    skdebug(" hemisphere upper="+(highest_buy_price - skprice)+" lower="+(skprice - lowest_sell_price ),dbgcheck2);
                }

            //special_comment="";

            if( (highest_buy_price - lowest_sell_price) >= (skpoints_gap_between_orders*pointstousd)  && take_quick_orders_in_mid)
                {
                    //special_comment="inloop";
                    //skpoints_gap_between_orders=skpoints_gap_inmid_input;
                    sklevel_down_value=last_order_price-(skpoints_gap_between_orders*pointstousd);
                    sklevel_up_value=last_order_price+(skpoints_gap_between_orders*pointstousd);
                    /*
                if(  (highest_buy_price - skprice) <  (skprice - lowest_sell_price ) )
                    {
                    sklevel_down_value=last_order_price-(skpoints_gap_between_orders*pointstousd)/2;
                    sklevel_up_value=last_order_price+(skpoints_gap_between_orders*pointstousd)*sklevel_current_abs;
                    }
                if(  (highest_buy_price - skprice) >  (skprice - lowest_sell_price ) )
                    {
                        sklevel_up_value=last_order_price+(skpoints_gap_between_orders*pointstousd)/2;
                        sklevel_down_value=last_order_price-(skpoints_gap_between_orders*pointstousd)*sklevel_current_abs;
                    }
                    */
                skdebug("setting special gaps while inside the closed positions of buy and sell up="+sklevel_up_value+" down="+sklevel_down_value,dbgcheck2);
                }
        }

// Remote status update message
    void send_update_ontick()
        {
            if(update_status!="none" && user_status!="testing") 
                { 
                datetime sknow=TimeCurrent();
                int skcurrent=0;   
                if(check_input(update_status,",eachorder,")  ) 
                    skcurrent+=CalculateCurrentOrders("all") ;   
                if(check_input(update_status,",hourly,") ) 
                    skcurrent+=TimeHour(TimeCurrent());   
                if(check_input(update_status,",everyminute,")  ) 
                    skcurrent+=TimeMinute(TimeCurrent());   

                if(skcurrent!=msg_last_sent && skcurrent!=0)   // msg_last_sent is global variable 
                    {

                    msg_last_sent=skcurrent;
                    send_telegram_msg(common_msg_for_update());
                    }
                }
        }
        

    string balance_info_string()
        {
            if(initial_balance>0)
                opening_balance=initial_balance;
            double skbalance=AccountBalance();
            double skequity=getequity();
            int booked=skbalance-opening_balance;
            int notbooked=skequity-skbalance;
            int actual_profit=skequity-opening_balance;
            double ap=NormalizeDouble(AccountProfit(),1);

            //string balance_msg="NBP:"+notbooked+"/NBmaxL:"+max_loss_faced+" BP:"+booked+" TPA:"+int(total_profit_accumulated)+" Eq:"+int(skequity)+"(min:"+min_equity_reached+"|max:"+max_equity_reached+
            //" (N"+new_counts+" Start:"+int(start_balance)+") B("+int(skbalance)+" TPN"+int(sktotalprofit)+") ";
            
            string balance_msg=" RP"+int(sktotalprofit)+" Pr"+actual_profit+"(NB"+notbooked+"/B"+booked+") B="+int(skbalance)+"_Eq="+int(skequity)+"(min:"+min_equity_reached+"|max:"+max_equity_reached+
            "|Start:"+int(opening_balance)+")";
            
            
            return(balance_msg);
        }

    string user_info_string()
        {
            
                    string skac1=AccountName();
                    string skac2=AccountNumber();
                    string skac3=AccountCompany();
                    string skac4=AccountServer();
                    userinfo="Name="+skac1+" Number="+skac2+" Company="+skac3+" Server="+skac4; 
                    // userinfo is global variable.


            return(userinfo);
        }


    string common_msg_for_update()
        {
            datetime sknow=TimeCurrent();
            string R_D="Real";
            if(IsDemo()) R_D="Demo";
            datetime time_till_last_order=TimeCurrent() - last_order_time ;
            string hours_till_last_order=" "+TimeHour(time_till_last_order)+ "Hr";
            // string msg_to_send="#"+R_D+AccountName()+Symbol()+" "+ balance_info_string()+
            //                     " L"+sklevel_current+"("+ int((skprice-sklevel_start_price)*pointstousd)+")"+
            //                     " B"+buy_lots_total+"S"+sell_lots_total+"T="+int(toal_transacted_lots)+"in"+order_count_til_profit+
            //                     " AT:"+sknow +"|"+userinfo ;
            //string msg_to_send="#"+R_D+AccountName()+" "+Symbol()+" C"+CalculateCurrentOrders("all")+ balance_info_string()+
              //                  " B"+buy_lots_total+"S"+sell_lots_total+"T="+(toal_transacted_lots)+"in"+order_count_til_profit+
                //                " AT:"+sknow +" |"+userinfo ;
            string msg_to_send="#"+R_D+" "+Symbol()+hours_till_last_order+" Oc"+CalculateCurrentOrders("all")+ balance_info_string()+
                                " Lots_B="+buy_lots_total+"_S="+sell_lots_total+" FM_Now="+int(margin_free)+"/Min="+int(margin_free_min)+
                                " AT:"+sknow +"_LT="+last_order_time+" |"+userinfo ;
            return(msg_to_send);
        }
        
    void send_update_init()
        {
            if(update_status != "none") 
                    send_telegram_msg("Start:"+userinfo+common_msg_for_update());
        }
    void send_update_deinit()
        {
            if(update_status !="none" ) 
                    send_telegram_msg("Exit:"+userinfo+common_msg_for_update());
        }


   int send_telegram_msg(string message1)
      {

        if(user_status == "testing")
            return(0);
        if(send_telgram_message_flag == False)
            return(0);

         string tocken="1978145861:AAHRAD0hYnwjI3uP4nQx_jopMwkweSwqdx4";
         string chat_id="602973674";
         string message="SKR:"+message1+" END"+msg_last_sent;
         string base_url="https://api.telegram.org";
         string url=base_url+"/bot"+tocken+"/sendMessage?chat_id="+chat_id+"&text="+message;
         string cookie=NULL,headers;
         char post[],result[];
         
         
         ResetLastError();
         int timeout=2000;
         int result1,returnvalue=0;
         result1=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
         
         if(result1==-1)
            {
                returnvalue=1;
               int errorcode=GetLastError();
               if(errorcode==4060)
                {
                  MessageBox("ERROR : EXITING : Add URL https://api.telegram.org in mt4 settings(tools -> options -> Expert -> Add the urls ) ");
                  deinit();
                }
                //else
                  //MessageBox("Some error while sending message code="+errorcode);
                  
            }
            else
                {
                    returnvalue=0;
                    skdebug("Status update msg sent "+message,dbgcheck2);
                }
        return(returnvalue);
               
      }


//SHOW BUTTONS on chart functions 
    void create_button(string skbutton_name,long givenx , long giveny )
        {
            ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,True);
            ObjectCreate(0,skbutton_name,OBJ_BUTTON,0,0,0);
            ObjectSetInteger(0,skbutton_name,OBJPROP_SELECTABLE,True);
            ObjectSetInteger(0,skbutton_name,OBJPROP_XDISTANCE,givenx);
            ObjectSetInteger(0,skbutton_name,OBJPROP_YDISTANCE,giveny);
            ObjectSetInteger(0,skbutton_name,OBJPROP_XSIZE,size_of_string(skbutton_name));
            
            ObjectSetText(skbutton_name,skbutton_name);
            
        }

    void update_pause_button_live()
        {
            if(executetrades==True)
                {
                    ObjectSetInteger(0,"PAUSE",OBJPROP_BGCOLOR,clrGreen);
                    ObjectSetText("PAUSE","PAUSE");
                }
                else if (executetrades==False)
                    {
                    set_basic_params_based_on_symbol_oninit();
                    ObjectSetInteger(0,"PAUSE",OBJPROP_BGCOLOR,clrRed);
                    ObjectSetText("PAUSE","RESUME");
                    }
        }
    void actions_for_button_hover(string button_name,bool ison)
        {
            if(button_name=="PAUSE")
                {
                    ObjectSetInteger(0,button_name,OBJPROP_BGCOLOR,clrRed);
                    if(ison==False)
                    ObjectSetInteger(0,button_name,OBJPROP_BGCOLOR,clrBlue);

                }
            if(button_name=="RESET")
                {
                    ObjectSetInteger(0,button_name,OBJPROP_BGCOLOR,clrRed);
                    if(ison==False)
                    ObjectSetInteger(0,button_name,OBJPROP_BGCOLOR,clrBlue);

                }
            if(button_name=="BUY")
                {
                    ObjectSetInteger(0,button_name,OBJPROP_BGCOLOR,clrRed);
                    if(ison==False)
                    ObjectSetInteger(0,button_name,OBJPROP_BGCOLOR,clrBlue);

                }
            if(button_name=="SELL")
                {
                    ObjectSetInteger(0,button_name,OBJPROP_BGCOLOR,clrRed);
                    if(ison==False)
                    ObjectSetInteger(0,button_name,OBJPROP_BGCOLOR,clrBlue);
                }
            if(button_name=="CLOSEALL")
                {
                    //closeall_orders("all");
                    ObjectSetInteger(0,button_name,OBJPROP_BGCOLOR,clrRed);
                    if(ison==False)
                    ObjectSetInteger(0,button_name,OBJPROP_BGCOLOR,clrBlue);
                }
        }

    void actions_for_button_click(string button_name)
        {
            skdebug(button_name+" Button Pressed for Action",dbgcheck1);
        
            if(button_name=="PAUSE")
                {
                    button_resume_pause_works();
                    //ObjectSetInteger(0,"Close_All",OBJPROP_BGCOLOR,clrRed);
                }
            if(button_name=="RESET")
                {
                    button_reset_works();
                    //ObjectSetInteger(0,"Close_All",OBJPROP_BGCOLOR,clrRed);
                }
            if(button_name=="BUY")
                {
                    neworder_adhoc("buy");
                    //ObjectSetInteger(0,"Close_All",OBJPROP_BGCOLOR,clrRed);
                    skdebug(button_name+" button used to place new buy order",dbgcheck1);
                }
            if(button_name=="SELL")
                {
                    neworder_adhoc("sell");
                    //ObjectSetInteger(0,"Close_All",OBJPROP_BGCOLOR,clrRed);
                    skdebug(button_name+" button used to place new sell order ",dbgcheck1);
                }
            if(button_name=="CLOSEALL")
                {
                    closeall_orders("all","button close all pressed " );
                    //ObjectSetInteger(0,"Close_All",OBJPROP_BGCOLOR,clrRed);
                    skdebug(button_name+" button used to close all positions ",dbgcheck1);
                }
            
        }

    void in_chart_works_on_button(string buttonname, long x , long y ,string nameid ,int id)
        {
            // Positions for button  
                int skbutton_left=ObjectGetInteger(0,buttonname,OBJPROP_XDISTANCE);
                int skbutton_right=skbutton_left+ObjectGetInteger(0,buttonname,OBJPROP_XSIZE);
                int skbutton_top=ObjectGetInteger(0,buttonname,OBJPROP_YDISTANCE);
                int skbutton_bottom=skbutton_top+ObjectGetInteger(0,buttonname,OBJPROP_YSIZE);

            if(x>skbutton_left && x<skbutton_right 
                && y>skbutton_top && y<skbutton_bottom ) 
                {
                    actions_for_button_hover(buttonname,True);
                    if(id==CHARTEVENT_OBJECT_CLICK && nameid==buttonname ) 
                        {
                            actions_for_button_click(buttonname);
                            
                        }
                }
                else
                    {
                    actions_for_button_hover(buttonname,False);
                    }


        }
    int size_of_string(string str1)
        {
            return(16*StringLen(str1));
        }

    void create_chart_buttons()
        {
                int xpostion1=1200;
                if(button_x>=0)
                    xpostion1=button_x;
                string button1;

                button1="PAUSE";  create_button(button1,xpostion1++,2); xpostion1+=size_of_string(button1);
                button1="BUY";  create_button(button1,xpostion1++,2); xpostion1+=size_of_string(button1);
                button1="SELL";  create_button(button1,xpostion1++,2); xpostion1+=size_of_string(button1);
                button1="RESET";  create_button(button1,xpostion1++,2); xpostion1+=size_of_string(button1);
                button1="CLOSEALL";  create_button(button1,xpostion1++,2); xpostion1+=size_of_string(button1);
        }
        
    void remove_chart_buttons()
        {
                string button1;
                button1="BUY"; ; ObjectDelete(0,button1);
                button1="SELL"; ; ObjectDelete(0,button1);
                button1="CLOSEALL"; ; ObjectDelete(0,button1);
                button1="RESET"; ; ObjectDelete(0,button1);
                button1="PAUSE"; ; ObjectDelete(0,button1);
        }
    void button_resume_pause_works()
        {
            if(executetrades==True)   
                {
                    executetrades=False;
                    send_telgram_message_flag = False ;
                    skdebug("Pause button used : paused the works ",dbgcheck1);
                    ObjectSetText("PAUSE","RESUME");
                }
            else if(executetrades==False)   
                {
                    executetrades=True;
                    msg_last_sent=0;
                    send_telgram_message_flag = True ;
                    skdebug("Resume button used: Starting the works ",dbgcheck1);
                    ObjectSetText("PAUSE","PAUSE");
                }
        }
    void button_reset_works()
        {
            //if(CalculateCurrentOrders("all")==0)   
                {   
                    init();
                    top_price_order=least_price_order=0;   
                    first_order_number=first_order_price=sklevel_start_price=0;
                    last_order_price=last_order_size=last_order_type=0;
                    order_count_til_profit=0;
                    next_lot_size=0;
                    max_loss_faced=0;
                    max_order_count_til_profit=0;
                    max_equity_reached=0;
                    min_equity_reached=0;
                    start_balance=AccountEquity();
                    //profit_with_orders_1=0;profit_with_orders_2=0; profit_with_orders_3=0;
                    //profit_with_orders_4=0;profit_with_orders_5more=0;
                    profit_with_orders_1=0;profit_with_orders_2=0;profit_with_orders_3=0;profit_with_orders_4=0;profit_with_orders_5=0;profit_with_orders_6=0;profit_with_orders_7=0;profit_with_orders_8=0;profit_with_orders_9=0;profit_with_orders_10=0;profit_with_orders_10more=0;
                    margin_free_min=AccountEquity();
                    margin_used_max=0;
                    new_counts=0;
                    total_profit_accumulated=0;
                    skdebug("RESET button used : Resetting all counters ",dbgcheck1);
                    set_basic_params_based_on_symbol_oninit();

                    //ObjectSetText("PAUSE","RESUME");
                }
                //else
                  //  skdebug("RESET button used : there are open orders so not resetting the counters ",dbgcheck1);
        }

// ON CHART GRAPHICAL ACTIVITIES 
    void update_chart_color()
        {
            if(IsDemo())
               {
               
                // set color to bluish
                ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrAliceBlue);
                }
                
            if(!IsDemo())
                // Set color to pink
                ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrPink);
            if(getequity() < 20 )
                // set color to red needing attention .
                ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrRosyBrown);
            if(getequity()>start_balance)
               {
                //Set color to green
                ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrGreen);
                ChartSetInteger(0,CHART_COLOR_CHART_LINE,clrAqua);
               }
        }
    void update_chart_color_balance()
        {
            if(getequity() < start_balance )
                {
                ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrSkyBlue);
                }
            else  if(getequity()>start_balance)
               {
                ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrGreen);
               }
        }


    void delete_label_to_display()
         {
            ObjectDelete(0,"sklabel_1");
        }

    void create_label_to_display()
         {
            int chart_ID=0;
            string name="sklabel_1";
            string msg_to_display="mylabel";
            ObjectCreate(chart_ID,name,OBJ_TEXT,0,0,0);
               ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,clrWhite);
            //ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,0,0,0);
            //--- set the text
                ObjectSetString(chart_ID,name,OBJPROP_TEXT,msg_to_display);
            //--- set text font
                ObjectSetString(chart_ID,name,OBJPROP_FONT,FONT_ITALIC);
            //--- set font size
                ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,10);            //--- set label coordinates
               ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,1500);
               ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,750);
            //--- set label size
               ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,200);
               ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,200);
               
            /*
            //--- set background color
               ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,clrBlack);
            //--- set border type
               ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,BORDER_RAISED);
            //--- set the chart's corner, relative to which point coordinates are defined
               ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,CORNER_LEFT_LOWER);
            //--- set flat border color (in Flat mode)
               //ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clrAqua);
            //--- set flat border line style
               ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,STYLE_DASHDOTDOT);
            //--- set flat border width
               ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,2);
            //--- display in the foreground (false) or background (true)
               ObjectSetInteger(chart_ID,name,OBJPROP_BACK,False);
            //--- enable (true) or disable (false) the mode of moving the label by mouse
               ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,False);
               ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,False);
            //--- hide (true) or display (false) graphical object name in the object list
               ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,False);
            //--- set the priority for receiving the event of a mouse click in the chart
              // ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
            //--- successful execution
            */
                        
         }
    void draw_vline(string linename,int location,color linecolor,int thickness)
        {
                //ObjectDelete("startline");
                if(check_input(linename,"profit"))
                    {
                        ObjectDelete("last_profit_line");
                        ObjectCreate(0,"last_profit_line",OBJ_VLINE,0,Time[0],location);
                        ObjectSetInteger(0,"last_profit_line",OBJPROP_COLOR,clrLime);

                        ObjectCreate(0,linename,OBJ_VLINE,0,Time[0],location);
                        //ObjectCreate(0,linename,OBJ_ARROW_THUMB_UP,0,Time[1],location+skpoints_gap_between_orders);
                        ObjectSetInteger(0,linename,OBJPROP_COLOR,clrBlue);
                        ObjectSetInteger(0,linename,OBJPROP_STYLE,STYLE_SOLID);
                        //ObjectSetInteger(0,linename,OBJPROP_BACK,False);
                        ObjectSetInteger(0,linename,OBJPROP_WIDTH,1);
                    }
                else if(check_input(linename,"loss"))
                    {
                        ObjectDelete("last_loss_line");
                        ObjectCreate(0,"last_loss_line",OBJ_VLINE,0,Time[0],location);
                        ObjectSetInteger(0,"last_loss_line",OBJPROP_COLOR,linecolor);

                        ObjectCreate(0,linename,OBJ_ARROW_DOWN,0,Time[0],location);
                        ObjectSetInteger(0,linename,OBJPROP_COLOR,linecolor);
                        ObjectSetInteger(0,linename,OBJPROP_BACK,True);
                    }
                    else
                        {

                            ObjectCreate(0,linename,OBJ_VLINE,0,Time[0],location);
                            ObjectSetInteger(0,linename,OBJPROP_COLOR,linecolor);
                            ObjectSetInteger(0,linename,OBJPROP_STYLE,STYLE_SOLID);
                            ObjectSetInteger(0,linename,OBJPROP_WIDTH,thickness);
                        }
        }
    void remove_line(string linename)
        {
            ObjectDelete(0,linename);
        }
    void draw_hline(string linename,string sometext,double location ,color linecolor,int thickness)
        {
                //ObjectDelete("startline");
                if(check_input(linename,"next_"))
                   {
                    ObjectDelete(linename);
                    ObjectCreate(0,linename,OBJ_HLINE,0,Time[0],location);
                    ObjectSetInteger(0,linename,OBJPROP_COLOR,linecolor);
                    ObjectSetInteger(0,linename,OBJPROP_STYLE,STYLE_DASHDOTDOT);
                    ObjectSetInteger(0,linename,OBJPROP_WIDTH,thickness);
                    ObjectSetText(linename,sometext,3,0,clrAqua);
                    ObjectSetInteger(0,linename,OBJPROP_BACK,TRUE);

                    // if(check_input(linename,"next_up") )
                    //     ObjectCreate(0,linename+Bars,OBJ_ARROW_UP,0,Time[0],location);
                    // if(check_input(linename,"next_down") )
                    //     ObjectCreate(0,linename+Bars,OBJ_ARROW_DOWN,0,Time[0],location);
                    // ObjectSetInteger(0,linename+Bars,OBJPROP_COLOR,linecolor);
                   }

        }

    void create_label(string name,int x , int y )
        {

            //string name="mylabel1",label_text="Sachin";
            int chart_ID=0;
            //ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrAliceBlue);
            ObjectDelete(name);
            ResetLastError();
            ObjectCreate(0,name,OBJ_LABEL,0,0,0) ;
            if(button_x>=0)
                x=button_x;
            ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
            ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
            ObjectSetString(chart_ID,name,OBJPROP_TEXT,name);
            ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,CORNER_LEFT_LOWER);            
            //--- set font size
            ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,50);
            ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,clrRed);
            //--- set color
            //ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clrLime);
            //--- display in the foreground (false) or background (true)
            ObjectSetInteger(chart_ID,name,OBJPROP_BACK,False);
        }

    void update_label_text()
        {
            // label display update 
            int booked=getequity()-opening_balance;
            int booked_withoutbrokerage=getequity()-opening_balance+toal_transacted_lots*brokerageperlot;
            int notbooked=sktotalprofit;
                string mylabel_equity_text=notbooked+"("+max_loss_faced+")"+" C"+order_count_til_profit+"/"+max_order_count_til_profit+"P"+pacify_order_plus+"/-"+pacify_order_minus;
                string mylabel_balance_text="W"+new_counts+"="+int(total_profit_accumulated)+"-B"+int(toal_transacted_lots*brokerageperlot)+" E"+int(getequity())+"("+booked+"/"+booked_withoutbrokerage+")";

                ObjectSetString(0,mylabel_equity,OBJPROP_TEXT,mylabel_equity_text);
                ObjectSetString(0,mylabel_balance,OBJPROP_TEXT,mylabel_balance_text);
                //if(opening_balance<=getequity())
                if((total_profit_accumulated+sktotalprofit)>0)
                    {
                        ObjectSetInteger(0,mylabel_equity,OBJPROP_COLOR,clrBlue);
                        ObjectSetInteger(0,mylabel_balance,OBJPROP_COLOR,clrBlue);
                    }
                else
                    {
                        ObjectSetInteger(0,mylabel_equity,OBJPROP_COLOR,clrRed);
                        ObjectSetInteger(0,mylabel_balance,OBJPROP_COLOR,clrRed);
                    }
        }
    void display_historical_analysis()
        {
            double hist_profit_accumulated=0,hist_profit_booked=0,hist_profit_running=0;
            int hist_buy=0,hist_sell=0;
            double hist_lastorder_price_execution=0,hist_lastorder_price_sqoff=0;
            int hist_lastorder_type=0;
            double hist_skprice=0,hist_Ask=0,hist_bid=0;
            string_from_history="history:"+Bars;
            for(int i=Bars-10;i>0;i++)
                {
                    hist_skprice=Ask;
                }

        }
// INDICATOR show functions 

    void sk_indicators_to_show_filldata()
      {
            int countedbars=splitresult[4];
            if(countedbars >0 ) 
               {
               skdebug(" at bars="+Bars,dbgcheck1);
                  //countedbars--;
                  //int bars_to_use=Bars-countedbars;
                  int bars_to_use=100;
                  skdebug("Bars="+Bars+" limit="+bars_to_use+" indbars="+countedbars+" mainput="+splitresult[0],dbgcheck1);
                 for ( int i=countedbars ;i<bars_to_use-- ; i++ )
                  {
                     skdebug(" bar fill value for "+i,dbgcheck1);
                      double ima1=iMA(NULL,1,splitresult[0],1,MODE_SMA,PRICE_OPEN,i);
                                        skdebug("value of close="+Open[i]+"ma1="+ima1,dbgcheck1);

                      //skbuffer_ma2[i]=iMA(NULL,1,splitresult[1],1,MODE_SMA,PRICE_CLOSE,i);
                      skbuffer_ma1[i]=ima1;
                      //skbuffer_ma3[i]=iMA(NULL,1,splitresult[2],1,MODE_SMA,PRICE_CLOSE,i);
                      //skbuffer_ma4[i]=iMA(NULL,1,splitresult[3],1,MODE_SMA,PRICE_CLOSE,i);
                      //skbuffer_ma5[i]=iMA(NULL,1,splitresult[4],1,MODE_SMA,PRICE_CLOSE,i);
                  } 
               }
              else
              skdebug("countedbar are less to show indictors",dbgcheck1);
            
      
      }
    void sk_indicators_to_show_intialize()
        {
            skdebug("Will show indicator on chart",dbgcheck2);
            split_string_to_array_splitresult(skma_inputs,",");
            
           // double  ma1=iMA(NULL,1,splitresult[0],1,MODE_SMA,PRICE_CLOSE,0);
            //double  ma2=iMA(NULL,1,splitresult[1],1,MODE_SMA,PRICE_CLOSE,0);
            //double  ma3=iMA(NULL,1,splitresult[2],1,MODE_SMA,PRICE_CLOSE,0);
            //double  ma4=iMA(NULL,1,splitresult[3],1,MODE_SMA,PRICE_CLOSE,0);
            // double  ma5=iMA(NULL,1,splitresult[4],1,MODE_SMA,PRICE_CLOSE,0);
            
                  // fill index buffer to show on chart 
                IndicatorBuffers(2);
                SetIndexBuffer(0,skbuffer_ma1);
                SetIndexStyle(0,DRAW_LINE,0,1,clrYellow);
                SetIndexBuffer(1,skbuffer_ma5);
                SetIndexStyle(1,DRAW_LINE,0,1,clrBlue);
            
            
        }
// License check functions . 
    
    string is_user_registered()
        {

            user_info_string();
            if(IsTesting())
                {
                    user_allowed=True;
                    return("testing");
                }

            // if(IsDemo())
            //     {
            //         user_allowed=True;
            //         return("demo");
            //     }

                    string returnvalue;
                    
                        string skac1=AccountName();
                        string skac2=AccountNumber();
                        string skac3=AccountCompany();
                        string skac4=AccountServer();
                        
                    // USER validation                  
                        if( ( check_input(skac3,"Exness") && check_input(allowed_users_list,skac2) )
                                || user_allowed==True || itisme_sachin)
                                {


                                    user_allowed=True;
                                    returnvalue="registered";
                                    if(IsDemo())
                                        {
                                            //Alert("OK for DEMO account of EXNESS only : iamsachinrajput@gmail.com");
                                            skdebug("OK for DEMO account of EXNESS only : iamsachinrajput@gmail.com",dbgmust);
                                            returnvalue="demo";
                                        }
                                    
                                    skdebug(returnvalue+" user account #"+skac2+"enjoy the abundence of money ",dbgcheck1);
                                    
                                    if(itisme_sachin)
                                        {
                                            skdebug("Sure Master you can do anything",dbgcheck1);
                                            //Alert("Sure Master you can do anything");
                                            user_allowed=True;
                                            return("super_user");
                                        }


                                }
                            else 
                            { 
                                Alert(" Name="+skac1+" Number="+skac2+" Company="+skac3+" Server="+skac4);
                                Alert("your user is not registered for trading send email to iamsachinrajput@gmail.com for paid version ");
                                returnvalue="unregistered";
                                //deinit();
                            }
                        userinfo=returnvalue+" Name="+skac1+" Number="+skac2+" Company="+skac3+" Server="+skac4;
                        skdebug(userinfo,dbgcheck1);

                        return(returnvalue);
                        
        }
    void get_params_from_file()
        {
            {
            if(FileIsExist(skfile_name_params))
            if(skfile_search(skfile_name_params,"opening_balance"))
            {
            opening_balance=StrToInteger(StringReplace(skfile_found_string,"opening_balalce=",""));
            FileDelete(skfile_name_params);
            }
            }
        }

    void set_basic_params_based_on_symbol_oninit()
        {
            opening_balance=AccountBalance();
            if(initial_balance>0)
                opening_balance=initial_balance;
            start_balance=getequity();
            usdtopoints=perlot_usdtopoints_input;  
            usdtopoints=.001;  
            Slippage = 30;
            if(Symbol()=="BTCUSD" || Symbol()=="BTCUSDc")
                {
                    usdtopoints=100;
                    Slippage = 30;
                }
            if(Symbol()=="EURUSD" || Symbol()=="EURUSDc")
                {
                    usdtopoints=.001;  
                    Slippage = 30;
                }
            if(Symbol()=="GBPUSD" || Symbol()=="GBPUSDc")
                {
                    usdtopoints=.001;  
                    Slippage = 30;
                }

            if(Symbol()=="USDJPY" || Symbol()=="USDJPYc")
                {
                    usdtopoints=.1;  
                    Slippage = 10;
                }
            if(Symbol()=="GBPJPY" || Symbol()=="GBPJPYc")
                {
                    usdtopoints=.1;  
                    Slippage = 10;
                }
            if(Symbol()=="AUDUSD" || Symbol()=="AUDUSDc")
                {
                    usdtopoints=.001;  
                    Slippage = 10;
                }
            if(Symbol()=="EURGBP" || Symbol()=="EURGBPc")
                {
                    usdtopoints=.001;  
                    Slippage = 10;
                }
            if(Symbol()=="EURAUD" || Symbol()=="EURAUDc")
                {
                    usdtopoints=.001;  
                    Slippage = 10;
                }
            if(Symbol()=="EURJPY" || Symbol()=="EURJPYc")
                {
                    usdtopoints=.1;  
                    Slippage = 10;
                }
            if(Symbol()=="LTCUSD" || Symbol()=="LTCUSDc")
                {
                    usdtopoints=10;  
                    Slippage = 10;
                }
            if(Symbol()=="BTCXAU" || Symbol()=="BTCXAUc")
                {
                    usdtopoints=1;  
                    Slippage = 10;
                }

            if(Symbol()=="USDINR" || Symbol()=="USDINRc")
                {
                    usdtopoints=.1;  
                    Slippage = 10;
                }


            closeall_if_profit_inr=closeall_if_profit_inr_input;
            lots_to_start=lots_to_start_input;
            maxlots_count=maxlots_count_input;

            pointstousd=1/usdtopoints;
            skpoints_gap_between_orders_input=inr_gap_between_orders_input*usdtopoints;
            skpoints_gap_between_orders=skpoints_gap_between_orders_input;

            
            
        }

    void check_if_open_orders_at_start()
        {
            if(CalculateCurrentOrders("all")>0)
                {
                    update_next_up_down_level_values();
                    skdebug("there were open orders so setting the level settings ",dbgcheck1);
                    skdebug("first ticket="+first_order_direction+" "+ first_order_number+" sklevel_start_price="+sklevel_start_price+" next up="+sklevel_up_value+" down="+sklevel_down_value,dbgcheck1);
                    start_balance=AccountBalance();  // should come from file 
                    toal_transacted_lots=buy_lots_total+sell_lots_total; // actually should use saved file
                    order_count_til_profit=total_transacted_orders=CalculateCurrentOrders("all"); // actualy use saved file 
                    lotsize_increase=lotsize_increase_input;  // should come from file 
                    next_lot_size=last_order_size;
                    
                    check_mkt_movement();
                    if(magap_up1)
                        draw_vline("mktgap_buy"+Bars,skprice,clrGreen,2);
                    if(magap_down1)
                        draw_vline("mktgap_sell"+Bars,skprice,clrPink,2);



                }

        }
        
