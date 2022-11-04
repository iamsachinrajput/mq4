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
// Variables define start 
    //INPUTS 
        string allowed_users_list="preeti1:955021:19057218:19057219,24292087,19050422,adityacent:27108675:19054954";
        input bool letswork_input=True;
        input bool executetrades_input=True;
        input string startwith="none";
        input string indicators_touse=",none,";
        input bool use_buttons=False;
        input bool show_indicators=False;
        input bool save_state_infile=False;
        //bool update_status=False;
        input bool update_status=False;
        input string whentobuysell=",levelreverse,";
        input string whentobuy=",,";
        input string whentosell=",,";
        input string whentosqoff=",onesided_onreverse,";
        input int closeall_if_loss_inr=0;
        input int closeall_if_profit_inr=20;
        input string profit_method="perlotsize";
        input int max_equity_required_INR=0;
        input double sktakeprofit_input_inr=0;
        input double sktakeprofit_input_quick_inr=0;
        input double sk_stop_loss_inr=0;
        input double skpoints_gap_between_orders_input=10;
        input double skpoints_gap_inmid_input=10;
        input bool skpoints_gap_between_orders_auto=True;
        input bool take_quick_orders_in_mid=True;   
        input string howtoclose="all";
        input double Lots = 0.01;
        input int maxlot_size_multiply=10;
        input int maxlots_count = 50;
        input string lotsize_increase=",level&level-1,";
        input int increaselots_whenequityis=1000;
        input bool skreverse_input=False;
        input int skrsi_downlevel=35;
        input int skrsi_uplevel=65;
        input string skma_inputs="3,6,9,12,15";
        input string buysell_conditions=",sklevel,";
        input string skdebuglevel=",err,check1,close1,";
        input double linegap=0;
        input int sleeptimebetween_simultaneous_orders=1000;
        input int wait_minutes_afterloss=120;
        input int MagicNumber = 28081;

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
        bool letswork=letswork_input;



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
                    Print("not valid file open:"+filename1);
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
                Print("+---------------------+"); 
                PrintFormat("File name = %s",file_name); 
                while(!FileIsEnding(file_handle)) 
                    Print(FileReadString(file_handle)); 
                Print("+---------------------+"); 
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
                { Print("not valid file open:"+filename1);return;}
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
                { Print("not valid file open:"+filename1);return(0);}
                else
                    {
                        Print("will find "+tofind+" in file " + filename1);
                    while( !FileIsEnding(filehander))
                        {
                            textfromfile=FileReadString(filehander);
                            Print("line from file :"+textfromfile);
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
                            Print("not found "+tofind+" in file " + filename1);

                    }
                FileClose(filehander);
                }
            return(returnvalue);  
        }

    void skdebug(string msg1, string level)
        {
            //if(level <=skdebuglevel)
            if(StringFind(skdebuglevel,level) >=0 ) 
                Print( Bars,":",Ask," ",msg1," ",level);
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
            //---
            for(int i=0; i<OrdersTotal(); i++)
            {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
                break;
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
            {
                if(OrderType()==OP_BUY)
                buys++;
                if(OrderType()==OP_SELL)
                sells++;
            }
            }
            //--- return orders volume
            //if(buys>0)
            //  return(buys);
            //else
            int returnvalue=(buys+sells);
            if(whichorders=="buy") returnvalue=(buys);
            if(whichorders=="sell") returnvalue=(sells);
            
            return(returnvalue);
        }

    string GetNameOP(int op)
        {
            switch(op)
                {
                case OP_BUY      :
                    return("Buy");
                case OP_SELL     :
                    return("Sell");
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
            Print(returnvalue);
            return("mktinfo");
        }

    int check_mkt_movement()
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

            // value filling for RSI signal 
                skind_rsi_lastvalue=skind_rsi_currentvalue;
                skind_rsi_currentvalue=iCustom(Symbol(),Period(),skind_rsi,
                                                        skind_rsi_input1_PERIOD,
                                                        skind_rsi_output1,1);

            //check market status for macd indidicator  
            skind_macd_switched=False;   
            if(skind_macd_currentvalue > skind_signal_currentvalue 
                && skind_macd_lastvalue<0 
                && skind_macd_lastvalue<skind_signal_lastvalue
                && skind_macd_mkt!="up"
                    )
                {
                    skdebug("setting macd up "+skind_macd_currentvalue+":"+skind_signal_currentvalue,dbgcheck2);
                    skind_macd_mkt_prev=skind_macd_mkt;
                    skind_macd_mkt="up";
                    skind_macd_switched=True;
                }
                
                if(skind_macd_currentvalue < skind_signal_currentvalue 
                    && skind_macd_lastvalue>0 
                    && skind_macd_lastvalue>=skind_signal_lastvalue
                    && skind_macd_mkt!="down"
                        )
                    {
                        skdebug("setting macd down "+skind_macd_currentvalue+":"+skind_signal_currentvalue,dbgcheck2);
                        skind_macd_mkt_prev=skind_macd_mkt;
                        skind_macd_mkt="down";
                        skind_macd_switched=True;
                    }
            
            // Check market status based on rsi indicator 
                skind_rsi_switched=False;
            if(skind_rsi_currentvalue <= skrsi_downlevel && skind_rsi_mkt!="down") 
            {
                skind_rsi_mkt_prev=skind_rsi_mkt;
                skind_rsi_mkt="down";
                skind_rsi_switched=True;
            }
            else if(skind_rsi_currentvalue <= skrsi_uplevel && skind_rsi_currentvalue>skrsi_downlevel && skind_rsi_mkt!="zigzag" ) 
            {
                skind_rsi_mkt_prev=skind_rsi_mkt;
                skind_rsi_mkt="zigzag";
                skind_rsi_switched=True;
            }
            else if(skind_rsi_currentvalue <= 100 && skind_rsi_currentvalue>skrsi_uplevel && skind_rsi_mkt!="up"  ) 
            {
                skind_rsi_mkt_prev=skind_rsi_mkt;
                skind_rsi_mkt="up";
                skind_rsi_switched=True;
            }
            
            //Print("checking mkt movement");  
            //update last values for indicators 


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
                                        skdebug("setting mkt down mkt="+skmkt_movement+"| rsi="+skind_rsi_mkt+"| macd="+skind_macd_mkt,dbgcheck1);
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
                                                        skdebug("setting mkt zigzag mkt="+skmkt_movement+"| rsi="+skind_rsi_mkt+"| macd="+skind_macd_mkt,dbgcheck1);
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
            if(CalculateCurrentOrders("all")==0)
            if( whichorder=="buy" ||
                whichorder=="sell"  ||
                whichorder=="buysell"  )
            {
                int ticket=0;
                start_balance=AccountEquity();
                sklevel_start_price=Ask;

                sklevel_up_value=Ask+(skpoints_gap_between_orders*pointstousd)*0.2;
                sklevel_down_value=Ask-(skpoints_gap_between_orders*pointstousd)*0.2;
                skdebug("Going to open Fresh orders of "+whichorder,dbgcheck1);

                sklevel_current=0;

                //if(!skpoints_gap_between_orders_auto) skpoints_gap_between_orders=skpoints_gap_between_orders_input;
                skpoints_gap_between_orders=skpoints_gap_between_orders_input;

                if(whichorder=="buy")
                    ticket=OpenPosition(Symbol(), OP_BUY, Lots, 0, 0, MagicNumber,make_order_comment("buy"));

                if(whichorder=="sell")
                    ticket=OpenPosition(Symbol(), OP_SELL, Lots, 0, 0, MagicNumber,make_order_comment("sell"));
                if(whichorder=="buysell")
                {
                    ticket=OpenPosition(Symbol(), OP_BUY, Lots, 0, 0, MagicNumber,make_order_comment("buy"));
                    // wait for few seconds before sending next order 
                    Sleep(sleeptimebetween_simultaneous_orders);
                    ticket=OpenPosition(Symbol(), OP_SELL, Lots, 0, 0, MagicNumber,make_order_comment("sell"));
                }
                if(ticket>0)
                    skdebug("Success : Fresh orders open of  "+whichorder,dbgcheck1);
                    else
                    skdebug("Failed : Fresh orders open for "+whichorder+myerrmsg(),dbgcheck1);

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
            if(sklevel_current>=0) direction="up";
            string returnvalue=(whichone+"_level_"+sklevel_current+"_"+direction);
            if(special_comment!="none")
            {
                returnvalue+="_"+special_comment;
                special_comment="none";
            }
            skdebug("created comment="+returnvalue,dbgcheck2);
            return(returnvalue);

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
                            string msgtoshow="opening buy order:Lots="+lotsize2+" comment="+skcomment;
                            check_last_error(msgtoshow,msgtoshow);
                            
                        }

                    // wait for few seconds before sending next order 
                    if(whichorder=="both") Sleep(sleeptimebetween_simultaneous_orders);

                    if( ( whichorder=="sell" || whichorder=="both" ) )
                        {
                            ticketnumber=OpenPosition(Symbol(), OP_SELL, lotsize2, 0, 0, MagicNumber,skcomment);
                            string msgtoshow="opening sell order:Lots="+lotsize2+" comment="+skcomment;
                            check_last_error(msgtoshow,msgtoshow);
                        }
                }
            return(ticketnumber);
        }

    int skneworder_with_conditions(string whichorder,double lotsize2,string skcomment)
        {
            int ticketnumber=0;
                // set buy sell conditions  
                    bool pointsgap_up=(Ask-last_order_price) >= 2*skpoints_gap_between_orders*pointstousd;
                    bool pointsgap_down=(last_order_price-Ask) >= 2*skpoints_gap_between_orders*pointstousd;
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

                    skdebug("new order try for "+whichorder+" gap="+MathAbs(int(Ask-last_order_price)) + " last price="+last_order_price,dbgcheck2);
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
                            //if(ticketnumber) last_order_price=Ask;
                        skdebug("pointsgap_up Ask="+Ask+"|lastorderprice="+last_order_price+"|point="+pointstousd+"|diff="+(Ask-last_order_price)+"|vs ="+(2*skpoints_gap_between_orders*pointstousd)+"just gap="+MathAbs(Ask-last_order_price)+" vs "+(skpoints_gap_between_orders*pointstousd),dbgcheck2);
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
                        skdebug("pointsgap_up Ask="+Ask+"|lastorderprice="+last_order_price+"|point="+pointstousd+"|diff="+(Ask-last_order_price)+"|vs ="+(2*skpoints_gap_between_orders*pointstousd)+"just gap="+MathAbs(Ask-last_order_price)+" vs "+(skpoints_gap_between_orders*pointstousd),dbgcheck2);
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
                        closeall_orders("sell");
                        skdebug("mkt UP so close sell orders mkt="+skmkt_movement+"| live="+skmkt_movement_live+
                                "| rsi="+skind_rsi_mkt+"| macd="+skind_macd_mkt,dbgcheck1);
                        closed_all_once="up";
                    }

            if( (skmkt_movement=="down" && check_input(whentosqoff,"mktdown"))
                || (skind_rsi_mkt=="down" && check_input(whentosqoff,"rsidown"))
                || (skind_macd_mkt=="down" && check_input(whentosqoff,"macddown"))
                )
                if(closed_all_once!="down")
                    if(CalculateCurrentOrders("buy")>0)  
                    {
                        closeall_orders("buy");
                        skdebug("mkt down close buy orders mkt="+skmkt_movement+"| live="+skmkt_movement_live+
                                "| rsi="+skind_rsi_mkt+"| macd="+skind_macd_mkt,dbgcheck1);
                        closed_all_once="down";
                    }

            if( ( skmkt_movement=="zigzag" && check_input(whentosqoff,"mktzigzag"))
                || (skind_rsi_mkt=="zigzag" && check_input(whentosqoff,"rsizigzag"))
                )
                if(CalculateCurrentOrders("all")>0)  
                {
                    closeall_orders("all");
                    skdebug("mkt zigzag close all orders mkt="+skmkt_movement+"| live="+skmkt_movement_live+
                            "| rsi="+skind_rsi_mkt+"| macd="+skind_macd_mkt,dbgcheck1);
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


    void split_string_to_array_splitresult(string tosplit,string sep)
        {
                //string to_split=tosplit;   // A string to split into substrings 
                //string sep=",";                // A separator as a character 
                ushort u_sep;                  // The code of the separator character 
                u_sep=StringGetCharacter(sep,0); 
                StringSplit(tosplit,u_sep,splitresult); 
                //return(result);

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
            

                    if(Ask > sklevel_up_value) 
                        {
                            skdebug("inside level up setting ",dbgcheck2);
                            //sklevel_prev = sklevel_current;
                            //sklevel_current+=1;
                            sklevel_switched=True;
                            oktotrade=True;
                            update_next_up_down_level_values();
                            //should_buy=True;
                        }

                    if(Ask < sklevel_down_value) 
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
                    // while previous level is diffirent then current so level changed.  
                        oktotrade=False;
                        skdebug("skcheck4 : levels,p,c ="+sklevel_prev+","+sklevel_current,dbgcheck1);

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
                            // while Above the starting point 
                            // while going towards rally Above the starting point 
                                //if(sklevel_prev < sklevel_current && OrdersTotal()<maxlots && ( skmkt_movement_prev=="up" || skmkt_movement=="up") )
                                //if(sklevel_prev < sklevel_current && OrdersTotal()<maxlots && (  skmkt_movement!="down")  )
                                if(sklevel_prev < sklevel_current && CalculateCurrentOrders("all")<maxlots  )
                                {
                                        //skdebug("skcheck5 : levels,p,c ="+sklevel_prev+","+sklevel_current,dbgcheck1);
                                        lastbuy_lots=lotsize_in_direction;
                                        if(check_input(lotsize_increase,",opposite_lotsize,"))
                                            if(CalculateCurrentOrders("buy")==0 && 1==2) 
                                            {
                                                lastbuy_lots=sell_lots_total ;
                                                special_comment="quick";
                                            }

                                                lotsize_to_execute_buy=buy_lots_total ;
                                        lastsell_lots=lotsize_in_support;
                                        skdebug("sklevel upward movement level from "+sklevel_prev+" to "+sklevel_current+"| will open new sell order of lots "+lastsell_lots+" and buy order of lots "+lastbuy_lots+get_mkt_info("all"),dbgcheck1);
                                    //add 1 more buy standard lot
                                        //lastbuy_lots=Lots;
                                    if(!is_same_level_order_open("buy"))
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
                                    if(skmkt_movement!="up" || !check_input(whentobuysell,",level+mkt,") )
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

                                    skdebug("sklevel upward sqoff level from "+sklevel_prev+" to "+sklevel_current+"| will close last sell order #"+lastsell_order+" of "+lastsell_lots+" lots and last buy order #"+lastbuy_order+" of "+lastbuy_lots+" lots"+get_mkt_info("all"),dbgcheck1);
                                    skdebug("upward opposite rally  : levels,p,c ="+sklevel_prev+","+sklevel_current,dbgcheck1);
                                    if( check_input(whentosqoff,",onesided_onreverse,") )
                                        {
                                        closeall_orders("buy");
                                        no_reversebuy=True;
                                        }

                                    if(check_input(whentosqoff,",reverse_level_closeall,")) 
                                        if(CalculateCurrentOrders("buy")>1)
                                            closeall_orders("buy");
                                    //remove last buy lot 

                                    if( check_input(whentosqoff,"levelchange")  && no_reversebuy==False)
                                    if(skmkt_movement!="up" || !check_input(whentosqoff,",level+mkt,") )
                                        if(OrderClose(lastbuy_order,lastbuy_lots,mysqoff_price("buy"),Slippage,mysqoff_color("buy")) )
                                            skdebug("sklevel Success last buy order #"+lastbuy_order+" closed with lots ="+lastbuy_lots,dbgcheck1);
                                        else
                                            skdebug("sklevel Failed last buy order #"+lastbuy_order+" closed with lots ="+lastbuy_lots,dbgcheck1);
                                        
                                    // remove level+1 sell lots 
                                    if( check_input(whentosqoff,"levelchange") )
                                    if(skmkt_movement!="down" || !check_input(whentosqoff,",level+mkt,") )
                                        if(OrderClose(lastsell_order,lastsell_lots,mysqoff_price("sell"),Slippage,mysqoff_color("sell")) )
                                        skdebug("sklevel Success last sell order #"+lastsell_order+" closed with lots ="+lastsell_lots,dbgcheck1);
                                        else
                                            skdebug("sklevel Failed last sell order #"+lastsell_order+" closed with lots ="+lastsell_lots,dbgcheck1);
                                
                                    // while coming back open a new buy and sell position .
                                        lastsell_lots=lotsize_in_direction;
                                    if( check_input(whentobuysell,"levelreverse") && !is_same_level_order_open("sell") )
                                        if(lastsell_lots>0 )
                                            {
                                                if(lastsell_order=OpenPosition(Symbol(), OP_SELL, lastsell_lots, sl, tp, MagicNumber,make_order_comment("sell")))
                                                    skdebug("sklevel Success new sell order placed with lots ="+lastsell_lots,dbgcheck1);
                                                else
                                                    skdebug("sklevel Faild New sell order with lots ="+lastsell_lots+myerrmsg(),dbgerr);
                                            }
                                
                                        lastbuy_lots=lotsize_in_support;
                                    if( check_input(whentobuysell,"levelreverse") && !is_same_level_order_open("buy"))
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
                            // while Below the starting point 
                            // while going towards rally below the starting point 
                                skdebug("skcheck4 : levels,p,c ="+sklevel_prev+","+sklevel_current,dbgcheck1);

                                //if(sklevel_prev > sklevel_current && OrdersTotal()<maxlots && ( skmkt_movement_prev=="down" || skmkt_movement=="down" ) )
                                //if(sklevel_prev > sklevel_current && OrdersTotal()<maxlots && ( skmkt_movement!="up" ) )
                                if(sklevel_prev > sklevel_current && CalculateCurrentOrders("all")<maxlots  ) // it is rallying downward 
                                {
                                    skdebug("skcheck5: levels,p,c ="+sklevel_prev+","+sklevel_current,dbgcheck1);
                                        
                                    lastsell_lots=lotsize_in_direction;
                                        if(check_input(lotsize_increase,",opposite_lotsize,"))
                                            if(CalculateCurrentOrders("sell")==0) 
                                            {
                                                lastbuy_lots=buy_lots_total ;
                                                //special_comment="quick";
                                            }
                                    lastbuy_lots=lotsize_in_support;
                                        skdebug("sklevel downward movement : levels from "+sklevel_prev+" to "+sklevel_current+"| will open new sell order of "+lastsell_lots+"lots and new buy order of "+lastbuy_lots+" lots"+get_mkt_info("all"),dbgcheck1);
                                    //add 1 more sell standard lot
                                        //lastsell_lots=Lots;
                                        ordercomment="sell"+lastsell_lots;
                                    if(!is_same_level_order_open("sell"))
                                if(skmkt_movement!="up" || !check_input(whentobuysell,",level+mkt,"))
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
                                if(skmkt_movement!="down" || !check_input(whentobuysell,",level+mkt,"))
                                    if(lastbuy_lots>0 )
                                        if(lastbuy_order=OpenPosition(Symbol(), OP_BUY, lastbuy_lots, sl, tp, MagicNumber,make_order_comment("buy")))
                                            skdebug("sklevel Success 3 new buy order placed with lots ="+lastbuy_lots+" comment="+make_order_comment("buy"),dbgcheck1);
                                        else
                                            skdebug("sklevel  3 New buy order with lots ="+lastbuy_lots+" Err="+myerrmsg(),dbgerr);
                                }
                            // while going opposite rally below starting point 
                                //if(sklevel_prev < sklevel_current && skmkt_movement!="down" && check_input(whentosqoff,"levelchange") )
                                if(sklevel_prev < sklevel_current  ) // coming back upward 
                                {

                                    skdebug("sklevel downward sqoff : levels from "+sklevel_prev+" to "+sklevel_current +"| will close last sell order #"+lastsell_order+" of "+lastsell_lots+" lots and last buy order #"+lastbuy_order+" of "+lastbuy_lots+" lots"+get_mkt_info("all"),dbgcheck1);
                                    skdebug("downward opposite rally  : levels,p,c ="+sklevel_prev+","+sklevel_current,dbgcheck1);

                                    if( check_input(whentosqoff,",onesided_onreverse,") )
                                        {
                                        closeall_orders("sell");
                                        no_reversesell=True;
                                        }
                                    
                                    if(check_input(whentosqoff,",reverse_level_closeall,")) 
                                        if(CalculateCurrentOrders("sell")>1)
                                            closeall_orders("sell");
                                    
                                    //remove 1 sell lot ( last one )
                                    if( check_input(whentosqoff,"levelchange") && no_reversesell==False )
                                    if(skmkt_movement!="down" || !check_input(whentosqoff,",level+mkt,"))
                                        if(OrderClose(lastsell_order,lastsell_lots,mysqoff_price("sell"),Slippage,mysqoff_color("sell")) )
                                            skdebug("sklevel Success to close last sell order #"+lastsell_order+" of lots ="+lastsell_lots,dbgcheck1);
                                        else
                                            skdebug("sklevel Failed to close last sell order #"+lastsell_order+" of lots ="+lastsell_lots,dbgcheck1);
                                        
                                    // remove level+1 buy lots 
                                    if( check_input(whentosqoff,"levelchange") )
                                    if(skmkt_movement!="up" || !check_input(whentosqoff,",level+mkt,"))
                                        if(OrderClose(lastbuy_order,lastbuy_lots,mysqoff_price("buy"),Slippage,mysqoff_color("buy")) )
                                        skdebug("sklevel Success to close last buy order #"+lastbuy_order+" of lots ="+lastbuy_lots,dbgcheck1);
                                        else
                                            skdebug("sklevel Failed to close last buy order #"+lastbuy_order+" of lots ="+lastbuy_lots,dbgcheck1);
                                    
                                    // while coming back to level 0 open a new buy position .
                                        lastsell_lots=lotsize_in_support;
                                    if( check_input(whentobuysell,"levelreverse") && !is_same_level_order_open("buy"))
                                        if(lastsell_lots>0 )
                                            {
                                                if(lastsell_order=OpenPosition(Symbol(), OP_SELL, lastsell_lots, sl, tp, MagicNumber,make_order_comment("sell")))
                                                    skdebug("sklevel Success new sell order placed with lots ="+lastsell_lots,dbgcheck1);
                                                else
                                                    skdebug("sklevel Faild New sell order with lots ="+lastsell_lots+myerrmsg(),dbgerr);
                                            }
                                    
                                        lastbuy_lots=lotsize_in_direction;
                                    if( check_input(whentobuysell,"levelreverse") && !is_same_level_order_open("buy"))
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
                skdebug("required orders already in place"+totalorderscount+" > "+maxlots,4);
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
            //string   lsComm="http://ytg.com.ua/";
            string   skmsg=cm;

                if(skreverse==True)
                {
                    int opp;
                    if(op==OP_BUY)
                        opp=OP_SELL;
                    if(op==OP_SELL)
                        opp=OP_BUY;
                    op=opp;
                    skdebug(" skreverse : Asked to "+op+" but doing ="+opp,dbgcheck1);
                }

            if(sy=="" || sy=="0")
                sy=Symbol();
            if(op==OP_BUY)
                clOpen=Green;
            else
                clOpen=Red;

            for(it=1; it<=POPYTKY; it++)
                {
                if(!IsTesting() && (!IsExpertEnabled() || IsStopped()))
                {
                    skdebug("OpenPosition(): ",1);
                    break;
                }
                while(!IsTradeAllowed())
                    {
                        Print("having terminal hung issue : will retry again after 5 seconds ");
                        Sleep(5000);
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
                if(AccountFreeMarginCheck(Symbol(),op, ll)<=0 || myerrmsg()==134 || ( maxlots_check_foreachorder==1 && totalorderscount>maxlots ) )
                    {
                    skdebug("order not sent to terminal : Total orders : "+totalorderscount,dbgerr);
                    return(0);
                    }
                if( executetrades == False)
                {
                    skdebug("Order execution is not set to true change it in settings ",dbgcheck1);
                    return(0);
                }
                //----+
                skdebug(op+"just before putting order :Symbol:"+sy+":what:"+ op+":size:"+ ll+":price:"+ pp+ "SL:"+sl+"TP:"+ tp+":msg:"+skmsg,3);
                ticket=OrderSend(sy, op, ll, pp, Slippage, sl, tp, skmsg, mn, 0, clOpen);
                if(ticket>0)
                    last_order_price=pp;
                

                if(ticket>0)
                {
                    PlaySound("ok.wav");
                                //createvline(Bars);

                    break;
                }
                else
                {
                    err=myerrmsg();
                    if(pa==0 && pb==0)
                    skdebug("some error occured for buying position",dbgerr);
                    // Вывод сообщения об ошибке
                    skdebug("Error("+err+") opening position: "+ErrorDescription(err)+", try "+it,dbgerr);
                    skdebug("Ask="+pa+" Bid="+pb+" sy="+sy+" ll="+ll+" op="+GetNameOP(op)+
                        " pp="+pp+" sl="+sl+" tp="+tp+" mn="+mn,4);
                    // Блокировка работы советника
                    if(err==2 || err==64 || err==65 || err==133)
                    {
                    gbDisabled=True;
                    break;
                    }
                    // Длительная пауза
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
                    while(IsTradeContextBusy())
                        Sleep(1000*11);
                    if(err!=135)
                    Sleep(1000*7.7);
                }
                }
            return(ticket);
        }

// CLose postions functions 
    void close_all_if_equity_profit()
        {
            bool temp2;
            if(closeall_if_profit_inr>0)
                if( ( start_balance+closeall_if_profit_inr) < AccountEquity() )
                {
                    skdebug("Profit exit : closing all orders as equity balance changed from "+start_balance+" to "+AccountEquity(),dbgcheck1);
                    closeall_orders("all");
                    start_balance=AccountEquity();
                }
            if(closeall_if_loss_inr>0)
                if( ( start_balance-closeall_if_loss_inr) > AccountEquity() )
                {
                    skdebug("LOSS exit : closing all orders as equity balance changed from "+start_balance+" to "+AccountEquity(),dbgcheck1);
                    closeall_orders("all");
                    sleep_minutes(wait_minutes_afterloss);
                    //if(skreverse==True) temp2=False;
                    //else if(skreverse==False) temp2=True;
                    //skreverse=temp2;
                    start_balance=AccountEquity();
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
            
            Print("to sqoff I will use price ="+returnvalue + " Ask="+Ask + " Bid="+Bid );
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

    int closeall_orders(string whichorderstoclose)
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
                kk=OrdersTotal();
                skdebug("will close all "+whichorderstoclose+" orders : count= "+kk+"("+skbuycount+"+"+sksellcount+")",dbgclose1);
                    for(int ii=0; ii< kk; ii++)
                    {
                        //Print("order postion =",ii," why here : ",whichorderstoclose);
                        if(OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
                        {  //skdebug("1Closing the order :"+OrderTicket()+" at position #"+ii,dbgclose1);
                            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
                            {  
                                if ( check_input(OrderComment(),whichorderstoclose)  || whichorderstoclose=="all" ) 
                                    {
                                        skdebug("Closing "+whichorderstoclose+" order#"+OrderTicket()+" at position #"+ii,dbgclose1);
                                        OrderPrint();
                                        if(OrderClose(OrderTicket(),OrderLots(),mysqoff_price("checck"),Slippage,mysqoff_color("check")) )
                                        skdebug("Success Closing "+whichorderstoclose+" order#"+OrderTicket()+" at position #"+ii,dbgclose1);
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
                        Print("current Orders =",CalculateCurrentOrders("all"));          
                        Print("Still open orders will repeat again ");
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
                    //Print("order postion =",ii," why here : ",whichorderstoclose);
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

                            if((whichorderstoclose=="all" ||whichorderstoclose=="tp" ) && skprofit_triggered)
                            {
                                    OrderPrint();
                                    if(OrderClose(OrderTicket(),OrderLots(),mysqoff_price("check"),Slippage,mysqoff_color("check")))
                                        skdebug("success Closing order with Profit="+ cr_ord_profit+" order#"+OrderTicket()+" at position #"+ii+
                                        "|sqoffprice="+sqoff_price+"|profitset="+sktakeprofit+"("+sktakeprofit*(cr_ord_lots/Lots)+")",dbgclose1);
                                    else
                                        skdebug("Failed Closing order with Profit="+ cr_ord_profit+" order#"+OrderTicket()+" at position #"+ii+"|sqoffprice="+sqoff_price+" Err="+myerrmsg(),dbgerr);
                            }
                            else if((whichorderstoclose=="all" || whichorderstoclose=="sl" ) && sksl_triggered)
                            {
                                    OrderPrint();
                                    if(OrderClose(OrderTicket(),OrderLots(),mysqoff_price("check"),Slippage,mysqoff_color("check") ))
                                        skdebug("Success :Closing order with Loss="+ cr_ord_profit+" order#"+OrderTicket()+" at position #"+ii+"|sqoffprice="+sqoff_price,dbgclose1);
                                    else
                                        skdebug("Failed :Closing order with Loss="+ cr_ord_profit+" order#"+OrderTicket()+" at position #"+ii+"|sqoffprice="+sqoff_price+" Err="+myerrmsg(),dbgerr);
                            }
                        }
                        //else   skdebug("Order closing error for order#"+ii+" err="+myerrmsg(),dbgerr);

                    }
                    else   skdebug("Order selection error for order#"+ii+" err="+myerrmsg(),dbgerr);
                    
                }
            }          
                //Print("current Orders =",CalculateCurrentOrders("all"));          
                
                return(1);
        }
   
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

    void display_details_onchart()
        {
            double sktotalprofit=0,crprofit=0,spreadsize=0;
            buy_lots_total=sell_lots_total=0;
            bool onlyfirst=False;
            lowest_sell_price=Ask;
            totalorderscount1=OrdersTotal();
            string buy_comment="",sell_comment="";
            spreadsize=NormalizeDouble(Ask-Bid,1);
            double ap=NormalizeDouble(AccountProfit(),1);
            int balance=AccountBalance(),size1;   
            sksellcount=skbuycount=positivecount=negativecount=0;
                //---
                for(int x=0; x<totalorderscount1; x++)
                    {
                    if(OrderSelect(x,SELECT_BY_POS,MODE_TRADES)==false)
                    { skdebug("error in order selection of #"+x+" err="+myerrmsg(),dbgerr); break; }
                    if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
                    {
                        
                        //skdebug(" in display chart : index="+x,dbgerr);
                        //OrderPrint();
                        
                        if(onlyfirst==False)
                            {
                                first_order_number=OrderTicket();
                                first_order_price=OrderOpenPrice();
                                sklevel_start_price=first_order_price;
                                onlyfirst=True;
                            }
                        last_order_price=OrderOpenPrice();
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
                            buy_comment+=","+size1;
                        }
                        if(OrderType()==OP_SELL) 
                        {
                            size1=int(OrderLots()*100  );
                            sksellcount++;
                            sell_lots_total+=OrderLots();
                            sell_comment+=","+size1;
                            lastsell_order=OrderTicket();
                            lastsell_lots=OrderLots();
                            lastsell_price=OrderOpenPrice();
                            lowest_sell_price=MathMin(lowest_sell_price,OrderOpenPrice());

                        }
                        crprofit=OrderProfit();
                        sktotalprofit+=crprofit;
                        if(crprofit>0)
                            positivecount+=1;
                        if(crprofit<=0)
                            negativecount+=1;
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

                //ObjectCreate(0,"display_label",OBJ_LABEL,0,0,0);
                
            Comment("     Orders T(P+N)="+(negativecount+positivecount)+"(",positivecount+"+"+negativecount,
                    ") B+S = "+skbuycount+"+"+sksellcount+" Lots B+S("+buy_lots_total+"+"+sell_lots_total+") ",
                    ") start="+int(opening_balance)+"NOW Profit="+int(sktotalprofit)+"("+int(ap)+")/"+int(balance)+" equity="+int(AccountEquity()),
                    " free="+int(AccountFreeMargin())+" last_equity="+start_balance," wait till=",int(start_balance+closeall_if_profit_inr)+" spread=",int(spreadsize),
                    "Set TP="+sktakeprofit_input_inr,
                    "\n                                     BUY:",buy_comment,
                    "\n                                     SELL:",sell_comment,
                    "\n                                     Level=",sklevel_current," prev level=",sklevel_prev,
                    " Price Ask="+Ask+" level_0="+sklevel_start_price+"("+NormalizeDouble((Ask-sklevel_start_price)/pointstousd,5)+
                    ") last="+last_order_price+"("+NormalizeDouble((Ask-last_order_price)/pointstousd,5)+")"+
                    "\n                                    next up="+sklevel_up_value+"/"+NormalizeDouble((sklevel_up_value-Ask)/pointstousd,1)+
                    " down="+sklevel_down_value+"/"+NormalizeDouble((Ask-sklevel_down_value)/pointstousd,1)+
                    " gap Needed="+skpoints_gap_between_orders+" actual="+actual_gap_from_last_order+
                    " p2usd="+pointstousd+" autogap="+skpoints_gap_between_orders_auto,
                    "\n                                    RSI=",int(skind_rsi_lastvalue),"_",int(skind_rsi_currentvalue),
                                "|macd=",int(skind_macd_lastvalue),"_",int(skind_macd_currentvalue),
                                "|signal=",int(skind_signal_lastvalue),"_",int(skind_signal_currentvalue),
                    "\n                                   MKT MOVEMENT PREV=",skmkt_movement_prev,"| Current=",skmkt_movement,"| macdmove=",skind_macd_mkt,"| rsimove=",skind_rsi_mkt,
                    "|");
        }

// Some conditions 
    void donotwork_if_conditions()
        {
            // Max amount needed reached then close all and quit .
            if(max_equity_required_INR!=0) 
                if(AccountEquity() > max_equity_required_INR ) 
                    {
                        closeall_orders("all");
                        skdebug("we have got the target set of "+max_equity_required_INR+" in equity. have reached to "+AccountEquity()+" from "+opening_balance,dbgcheck1);
                        letswork=False;
                        executetrades=False;
                        //deinit();
                    }

        }
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
                                skdebug(whattodo+" Order at this level is alredy open",dbgcheck1);
                                OrderPrint();
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

            int lotscount_multiplier=int(MathMax(1,AccountEquity()/increaselots_whenequityis));
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


    void update_next_up_down_level_values2()
        {
             skpoints_gap_between_orders=skpoints_gap_between_orders_input;
                    //if(!skpoints_gap_between_orders_auto) skpoints_gap_between_orders=skpoints_gap_between_orders_input;
            display_details_onchart();
            //sklevel_start_price=first_order_price;
            skdebug("sklevel_start_price="+sklevel_start_price,dbgcheck1);

            sklevel_current=int((Ask-sklevel_start_price)/(skpoints_gap_between_orders*(1.01)*pointstousd));
            sklevel_prev=int((last_order_price-sklevel_start_price)/(skpoints_gap_between_orders*(1.02)*pointstousd));
            skdebug("sklevel_current="+sklevel_current,dbgcheck1);
            if ( sklevel_current < 0 ) sklevel_current--;
            if ( sklevel_current > 0 ) sklevel_current++;
            if ( sklevel_prev < 0 ) sklevel_prev--;
            if ( sklevel_prev > 0 ) sklevel_prev++;

            skdebug("sklevel_current_2="+sklevel_current,dbgcheck1);

            sklevel_current_abs=MathAbs(sklevel_current);
            int sklevel_prev_abs=MathAbs(sklevel_current);

            sklevel_up_value=last_order_price+(skpoints_gap_between_orders*pointstousd);
            sklevel_down_value=last_order_price-(skpoints_gap_between_orders*pointstousd);
            if(sklevel_current_abs!=0 && CalculateCurrentOrders("all") > 2 )
                {
                    sklevel_up_value=last_order_price+(skpoints_gap_between_orders*pointstousd)*sklevel_current_abs;
                    sklevel_down_value=last_order_price-(skpoints_gap_between_orders*pointstousd)*sklevel_current_abs;
                }


            if(sklevel_prev!=sklevel_current)
                {
                    skdebug("Level changed from "+sklevel_prev+" to "+sklevel_current+" and gaptouse="+sklevel_gap_touse+
                            " target UP="+sklevel_up_value+" Down="+sklevel_down_value+" oktotrade="+oktotrade,dbgcheck2);
                    skdebug("setting normal gaps up="+sklevel_up_value+" down="+sklevel_down_value,dbgcheck2);
                    skdebug("highest_buy_price="+highest_buy_price+" lowest_sell_price="+lowest_sell_price,dbgcheck2);
                    skdebug(" hemisphere upper="+(highest_buy_price - Ask)+" lower="+(Ask - lowest_sell_price ),dbgcheck2);
                }

            //special_comment="";

            if(skpoints_gap_between_orders_auto)
            if( (highest_buy_price - lowest_sell_price) >= (skpoints_gap_between_orders*pointstousd)  && take_quick_orders_in_mid)
                {
                    //special_comment="inloop";
                    skpoints_gap_between_orders=skpoints_gap_inmid_input;
                    sklevel_down_value=last_order_price-(skpoints_gap_between_orders*pointstousd);
                    sklevel_up_value=last_order_price+(skpoints_gap_between_orders*pointstousd);
                    /*
                if(  (highest_buy_price - Ask) <  (Ask - lowest_sell_price ) )
                    {
                    sklevel_down_value=last_order_price-(skpoints_gap_between_orders*pointstousd)/2;
                    sklevel_up_value=last_order_price+(skpoints_gap_between_orders*pointstousd)*sklevel_current_abs;
                    }
                if(  (highest_buy_price - Ask) >  (Ask - lowest_sell_price ) )
                    {
                        sklevel_up_value=last_order_price+(skpoints_gap_between_orders*pointstousd)/2;
                        sklevel_down_value=last_order_price-(skpoints_gap_between_orders*pointstousd)*sklevel_current_abs;
                    }
                    */
                skdebug("setting special gaps while inside the closed positions of buy and sell up="+sklevel_up_value+" down="+sklevel_down_value,dbgcheck1);
                }
        }

    void update_next_up_down_level_values()
        {
             skpoints_gap_between_orders=skpoints_gap_between_orders_input;
                    //if(!skpoints_gap_between_orders_auto) skpoints_gap_between_orders=skpoints_gap_between_orders_input;
            display_details_onchart();
            sklevel_start_price=first_order_price;

            sklevel_current=int((Ask-sklevel_start_price)/(skpoints_gap_between_orders*(1.01)*pointstousd));
            sklevel_prev=int((last_order_price-sklevel_start_price)/(skpoints_gap_between_orders*(1.02)*pointstousd));
            if ( sklevel_current < 0 ) sklevel_current--;
            if ( sklevel_current > 0 ) sklevel_current++;
            if ( sklevel_prev < 0 ) sklevel_prev--;
            if ( sklevel_prev > 0 ) sklevel_prev++;
            
            sklevel_current_abs=MathAbs(sklevel_current);
            int sklevel_prev_abs=MathAbs(sklevel_current);

            sklevel_up_value=last_order_price+(skpoints_gap_between_orders*pointstousd);
            sklevel_down_value=last_order_price-(skpoints_gap_between_orders*pointstousd);
            if(sklevel_current_abs!=0 && CalculateCurrentOrders("all") > 2 )
                {
                    sklevel_up_value=last_order_price+(skpoints_gap_between_orders*pointstousd)*sklevel_current_abs;
                    sklevel_down_value=last_order_price-(skpoints_gap_between_orders*pointstousd)*sklevel_current_abs;
                }


            if(sklevel_prev!=sklevel_current)
                {
                    skdebug("Level changed from "+sklevel_prev+" to "+sklevel_current+" and gaptouse="+sklevel_gap_touse+
                            " target UP="+sklevel_up_value+" Down="+sklevel_down_value+" oktotrade="+oktotrade,dbgcheck2);
                    skdebug("setting normal gaps up="+sklevel_up_value+" down="+sklevel_down_value,dbgcheck2);
                    skdebug("highest_buy_price="+highest_buy_price+" lowest_sell_price="+lowest_sell_price,dbgcheck2);
                    skdebug(" hemisphere upper="+(highest_buy_price - Ask)+" lower="+(Ask - lowest_sell_price ),dbgcheck2);
                }

            //special_comment="";

            if(skpoints_gap_between_orders_auto)
            if( (highest_buy_price - lowest_sell_price) >= (skpoints_gap_between_orders*pointstousd)  && take_quick_orders_in_mid)
                {
                    //special_comment="inloop";
                    skpoints_gap_between_orders=skpoints_gap_inmid_input;
                    sklevel_down_value=last_order_price-(skpoints_gap_between_orders*pointstousd);
                    sklevel_up_value=last_order_price+(skpoints_gap_between_orders*pointstousd);
                    /*
                if(  (highest_buy_price - Ask) <  (Ask - lowest_sell_price ) )
                    {
                    sklevel_down_value=last_order_price-(skpoints_gap_between_orders*pointstousd)/2;
                    sklevel_up_value=last_order_price+(skpoints_gap_between_orders*pointstousd)*sklevel_current_abs;
                    }
                if(  (highest_buy_price - Ask) >  (Ask - lowest_sell_price ) )
                    {
                        sklevel_up_value=last_order_price+(skpoints_gap_between_orders*pointstousd)/2;
                        sklevel_down_value=last_order_price-(skpoints_gap_between_orders*pointstousd)*sklevel_current_abs;
                    }
                    */
                skdebug("setting special gaps while inside the closed positions of buy and sell up="+sklevel_up_value+" down="+sklevel_down_value,dbgcheck2);
                }
        }

// Remote status update message
   void send_telegram_msg(string message1)
      {
         string tocken="1978145861:AAHRAD0hYnwjI3uP4nQx_jopMwkweSwqdx4";
         string chat_id="602973674";
         string message="SKR :"+message1;
         string base_url="https://api.telegram.org";
         string url=base_url+"/bot"+tocken+"/sendMessage?chat_id="+chat_id+"&text="+message;
         string cookie=NULL,headers;
         char post[],result[];
         
         
         ResetLastError();
         int timeout=2000;
         int result1;
         result1=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
         
         if(result1==-1)
            {
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
               skdebug("Status update msg sent "+message,dbgcheck2);
               
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

    void actions_for_button_hover(string button_name,bool ison)
        {
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
                    closeall_orders("all");
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

    void OnChartEvent( const int id,const long &lparam,const double &dparam,const string &sparam )
        {
            if(use_buttons)
                in_chart_works_on_button("CLOSEALL",lparam,dparam,sparam,id);
                in_chart_works_on_button("BUY",lparam,dparam,sparam,id);
                in_chart_works_on_button("SELL",lparam,dparam,sparam,id);
        }

    int size_of_string(string str1)
        {
            return(16*StringLen(str1));
        }

    void create_chart_buttons()
        {
                int xpostion1=1200;
                string button1;
                
                button1="BUY";  create_button(button1,xpostion1++,2); xpostion1+=size_of_string(button1);
                button1="SELL";  create_button(button1,xpostion1++,2); xpostion1+=size_of_string(button1);
                button1="CLOSEALL";  create_button(button1,xpostion1++,2); xpostion1+=size_of_string(button1);
        }
        
    void remove_chart_buttons()
        {
                string button1;
                button1="BUY"; ; ObjectDelete(0,button1);
                button1="SELL"; ; ObjectDelete(0,button1);
                button1="CLOSEALL"; ; ObjectDelete(0,button1);
        }

// INDICATOR show functions 

    void sk_indicators_to_show_filldata()
      {
            int countedbars=splitresult[4];
            if(countedbars >0 ) 
               {
               Print(" at bars="+Bars);
                  //countedbars--;
                  //int bars_to_use=Bars-countedbars;
                  int bars_to_use=100;
                  Print("Bars="+Bars+" limit="+bars_to_use+" indbars="+countedbars+" mainput="+splitresult[0]);
                 for ( int i=countedbars ;i<bars_to_use-- ; i++ )
                  {
                     Print(" bar fill value for "+i);
                      double ima1=iMA(NULL,1,splitresult[0],1,MODE_SMA,PRICE_OPEN,i);
                                        Print("value of close="+Open[i]+"ma1="+ima1);

                      //skbuffer_ma2[i]=iMA(NULL,1,splitresult[1],1,MODE_SMA,PRICE_CLOSE,i);
                      skbuffer_ma1[i]=ima1;
                      //skbuffer_ma3[i]=iMA(NULL,1,splitresult[2],1,MODE_SMA,PRICE_CLOSE,i);
                      //skbuffer_ma4[i]=iMA(NULL,1,splitresult[3],1,MODE_SMA,PRICE_CLOSE,i);
                      //skbuffer_ma5[i]=iMA(NULL,1,splitresult[4],1,MODE_SMA,PRICE_CLOSE,i);
                  } 
               }
              else
              Print("countedbar are less to show indictors");
            
      
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
// System working functions 

    string balance_info_string()
        {
            string balance_msg=" Equity="+int(AccountEquity())+" ("+int(AccountBalance())+" "+int(AccountProfit())+")";
            return(balance_msg);
        }

    string user_info_string()
        {
            
                    string skac1=AccountName();
                    string skac2=AccountNumber();
                    string skac3=AccountCompany();
                    string skac4=AccountServer();
                    userinfo="Name="+skac1+" Number="+skac2+" Company="+skac3+" Server="+skac4;


            return(userinfo);
        }
    
    string is_user_registered()
        {
                    string returnvalue;
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
                                returnvalue="registered";
                                    
                                }
                            else 
                            { 
                                Alert("your user is not registered for trading send email to iamsachinrajput@gmail.com for paid version ");
                                returnvalue="unregistered";
                                //deinit();
                            }
                        return(returnvalue);
                        
        }

    void init()
        {
        
            

            string user_status=is_user_registered();
            Print("user is "+user_status);
            if (user_status != "registered" ) deinit();
         
             if(update_status ) 
                  send_telegram_msg("Started:Bal="+int(AccountBalance())+" profit="+int(AccountProfit())+" equity="+int(AccountEquity())+" by "+userinfo );

            if(use_buttons) 
               create_chart_buttons();
            if(show_indicators) 
               sk_indicators_to_show_intialize();
                
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
                if(Symbol()=="EURUSD")
                {
                    usdtopoints=1000;  
                    pointstousd=.0001;
                    Slippage = 30;

                }
                
                 skpoints_gap_between_orders=skpoints_gap_between_orders_input;
                if(CalculateCurrentOrders("all")>0)
                    {
                        update_next_up_down_level_values();
                        skdebug("there were open orders so setting the level settings ",dbgcheck1);
                        skdebug("first ticket="+first_order_number+" sklevel_start_price="+sklevel_start_price+" next up="+sklevel_up_value+" down="+sklevel_down_value,dbgcheck1);
                    }


        }
    void OnTick()
        {
        
            //send_telegram_msg(":WORKING2:Bal="+AccountBalance()+" profit="+AccountProfit()+" equity="+AccountEquity()+" by#"+AccountNumber() );
            if(letswork && user_allowed )
            {

                    if(show_indicators) 
                        sk_indicators_to_show_filldata();

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
                            string balance_msg="Equity="+int(AccountEquity())+" ("+int(AccountBalance())+" "+int(AccountProfit())+")";
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
                        if(check_input(buysell_conditions,",sklevel,")) buy_sell_with_levels();
                        if(check_input(buysell_conditions,",justma,")) buy_sell_with_maonly();
                        //buy_sell_based_on_mkt_movements();
                    }
                        exit_on_tp_or_sl(howtoclose);
                        close_all_if_equity_profit();
                        donotwork_if_conditions();
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
               send_telegram_msg("Exited:Bal="+int(AccountBalance())+" profit="+int(AccountProfit())+" equity="+int(AccountEquity())+" by "+userinfo );
            
        }
