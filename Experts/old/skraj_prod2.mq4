#property copyright "Sachin Rajput"
#property version   "2.00"
#property strict
#include <stdlib.mqh>
// Variables define start 
   //INPUTS 
    input bool executetrades=True;
    input string startwith="buysell";
    input string whentobuysell_info=",none,macd(up/down),rsi(up/down/zigzag),mkt(up/down/zigzag),";
    input string whentobuysell=",rsizigzag,";
    input string whentobuy=",rsiup,";
    input string whentosell=",rsidown,";
    input string whentosqoff="none";
    input int wait_minutes_afterloss=120;
    input int closeall_if_loss_inr=0;
    input int closeall_if_profit_inr=5;
    input double sktakeprofit_input=1;
    input double sktakeprofit_input_quick=1;
    input double sksl=100;
    input string skpoints_gap_info="eurousd=10,btcusd=100";
    input int skpoints_gap_between_orders_input=10;
    input string howtoclose_info=",tp,sl,all";
    input string howtoclose="all";
    input double Lots = 0.01;
    input int maxlot_size_multiply=20;
    input int maxlots_count = 50;
    input string lotsize_increase="ordercount";
    input int increaselots_whenequityis=1000;
    input bool skreverse_input=False;
    input int skrsi_downlevel=35;
    input int skrsi_uplevel=65;
    input string buysell_conditions_info=",ma,gapupbuy,gapdownbuy,gapupsell,gapdownsell,zoneswitch,smax,smin,";
    input string buysell_conditions=",gapupbuy,gapdownbuy,gapupsell,gapdownsell,zoneswitch,smax,smin";
    input string skdebuglevel="check1,comp1,supp1,err,oinfo,close1,onew";
    input double linegap=0;
    input int action_on_sqoff=0;

//input variables for indicators 
    //RSI 
        input int skind_rsi_input1_PERIOD=12;
    //MACD 
        input int skind_macd_input1_FASTEMA=12;
        input int skind_macd_input2_SLOWEMA=26;
        input int skind_macd_input3_SIGNALSMA=9;

   // Other inputs 
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
      int maxlots;
      double sktakeprofit;
      int start_balance=0;
      bool skreverse=skreverse_input;
      int skpoints_gap_between_orders=skpoints_gap_between_orders_input;
      bool pointsgap_ok_from_lastorder_open=False;

      // some other variables 
         bool user_allowed=False;
         int buysellstrategy=1;
         int alwayscomporder=1;
         int band_length=24;
         int band_deviation=2;
         double maxloss_allowed_inr=1000;
         double maxloss_perday_inr=10;
         double lotsize_to_execute=0 , lotsize_to_execute_buy=0 , lotsize_to_execute_sell=0;
         int sksleeptime=500;
         int modifyorderinloss=0;
         double minprofitinr=3;
         int buyselltogether=0;
         int onloss_action=0;
         int opening_balance=0;
         int skbuy_lotsize=0, sksell_lotsize=0;
         int lastbuy_order=0,lastsell_order=0;
         int positivecount=0, negativecount=0, totalorderscount1=0, skbuycount=0, sksellcount=0;
         double last_order_price=0;
         string zone_switched="none";
         string textfromfile;

         double lastbuy_lots=0,lastsell_lots=0;
         string ordercomment="";
         int tp=0,sl=0,tpr=0,slr=0;
         string lastaction="";
         bool sklevel_switched=False;
         double sklevel_up_value=0,sklevel_down_value=0;
         int sklevel_gap_touse=sklevel_gap;
         bool oktotrade=True;

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


      // Variables 
         int n = 10;
         double usdtopoints=.001;
         double pointstoprice=.0001;
         int totalorderscount=0;
         int total=0;
         int MagicNumber = 2808;
         int Slippage = 30;
         int POPYTKY = 10;
         bool  gbDisabled = False;
         datetime currenttime=TimeCurrent();
         datetime lastupdatedtime=TimeCurrent();
         string randomname;
         double minpricegap=1.5*MarketInfo( Symbol(), MODE_STOPLEVEL )*Point();
         int sklevel=0,sklevel_prev=0 , sklevel_current=0;
         double sklevel_start_price=0 , sklevel_lotsize=0,sklevel_lotsize2=0;

   //some signals 

      double  ma=iMA(NULL,0,5,2,MODE_SMA,PRICE_CLOSE,0);
      double smax=iBands(NULL,0,band_length,band_deviation,0,PRICE_CLOSE,MODE_UPPER,0);
      double smin=iBands(NULL,0,band_length,band_deviation,0,PRICE_CLOSE,MODE_LOWER,0);
      
void skfilewrite(string filename1,string dataline)
    {
    int filehander;
        {
        filehander==FileOpen(filename1,FILE_WRITE|FILE_CSV);
        if(filehander==INVALID_HANDLE)
            { Print("not valid file open:"+filename1);return;}
            else
                {
                FileWrite(filehander,dataline);
                skdebug("write done ",dbgcheck2);
                }
        FileClose(filehander);
            skdebug("size of file "+filename1+" ="+FileSize(filehander),dbgcheck2);
        }
    
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


void init()
   {
   
         string skac1=AccountName();
         string skac2=AccountNumber();
         string skac3=AccountCompany();
         string skac4=AccountServer();
         string allowed_users_list="preeti1:19057218,";
         
          string userinfo="Name="+skac1+" Number="+skac2+" Company="+skac3+" Server="+skac4;
          skdebug(userinfo,dbgcheck1);
          if(  (check_input(allowed_users_list,skac2) && check_input(skac4,"Real") ) 
             || ( check_input(skac4,"Demo") )
               )
             {
             skdebug("user account number "+skac2+" is registered . enjoy the abundence of money ",dbgcheck1);
                user_allowed=True;
                
             }
          else 
          { 
              Alert("your user is not registered for trading send email to iamsachinrajput@gmail.com for paid version ");
              deinit();
           }
          
          //Alert(userinfo); 
          
          //skfilewrite("mq4input.txt","testline1 column2");
          //skfileread("mq4input.txt");
          //Alert("textfromfile:"+textfromfile+":");

         if(Symbol()=="BTCUSD")
         {
             usdtopoints=100;
             pointstoprice=1;
         }
         usdtopoints=100;  
         int opening_balance=AccountBalance();

   }


void skdebug(string msg1, string level)
   {
      //if(level <=skdebuglevel)
      if(StringFind(skdebuglevel,level) >=0 ) 
         Print( Bars,":",Ask," ",msg1," ",level);
    }


void skcloseorder(int tickettoclose)
   {
      if(onprofit_quit_or_trail==1 || OrderProfit()<0 )
         {
            //close the order 
            skdebug("will sqoff order # "+tickettoclose+" in loss "+OrderProfit() , dbgsqoff);
            if(OrderType()==OP_BUY)
            OrderClose(tickettoclose,OrderLots(),Ask,Slippage,clrAqua);
            if(OrderType()==OP_SELL)
            OrderClose(tickettoclose,OrderLots(),Bid,Slippage,clrBrown);
         }
    }


double get_pip_value()
   {
     double returnvalue=.0001;
     if(Symbol()=="BTCUSD")
         returnvalue=.01;
     skdebug(Symbol()+" ki Pipvalue="+returnvalue,7);
     return(returnvalue);
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
        && 1==1
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
        if( (skind_rsi_mkt=="up" && skind_macd_mkt=="up" ) )
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
        if( (skind_rsi_mkt=="down" && skind_macd_mkt=="down" ) )
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
        if( ((skind_rsi_mkt=="down" && skind_macd_mkt=="up" ) 
                || (skind_rsi_mkt=="up" && skind_macd_mkt=="down" ) ) 
                    )
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




   return(1);

   }

bool check_input(string input1,string tocheck)
    {
        bool returnvalue1=False;
        if(StringFind(input1,tocheck,0) >= 0 ) 
            returnvalue1=True;
            
        skdebug("stringcheck:"+input1+":"+tocheck+" result="+returnvalue1,dbgcheck2);

        return(returnvalue1);
    }

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
      {
        int ticket=0;
        start_balance=AccountEquity();
        //sklevel_switched=True;
        //sklevel_up_value=Ask+(sklevel_gap_touse * usdtopoints);
        //sklevel_down_value=Ask-(sklevel_gap_touse * usdtopoints);
        sklevel_up_value=Ask+(skpoints_gap_between_orders*pointstoprice);
        sklevel_down_value=Ask-(skpoints_gap_between_orders*pointstoprice);

        sklevel_current=0;
         if(whichorder=="buy")
            ticket=OpenPosition(Symbol(), OP_BUY, Lots, 0, 0, MagicNumber,"newbuy");

         if(whichorder=="sell")
            ticket=OpenPosition(Symbol(), OP_SELL, Lots, 0, 0, MagicNumber,"newsell");
         if(whichorder=="buysell")
         {
            ticket=OpenPosition(Symbol(), OP_BUY, Lots, 0, 0, MagicNumber,"newbuy");
            ticket=OpenPosition(Symbol(), OP_SELL, Lots, 0, 0, MagicNumber,"newsell");
         }

        skdebug("Fresh open of orders = "+whichorder,dbgcheck1);

      }
   }

int skneworder(string whichorder,double lotsize2,string skcomment)
   {
       int ticketnumber=0;
        // set buy sell conditions  
            bool pointsgap_up=(Ask-last_order_price) >= 2*skpoints_gap_between_orders*pointstoprice;
            bool pointsgap_down=(last_order_price-Ask) >= 2*skpoints_gap_between_orders*pointstoprice;
            bool buy_cond1=(Open[1]<ma && Close[1]>ma) && check_input(buysell_conditions,",ma,");
            bool buy_cond2=(Close[1]>smax) && check_input(buysell_conditions,",smax,");
            bool buy_cond3=pointsgap_up && check_input(buysell_conditions,",gapupbuy,");
            bool buy_cond4=pointsgap_down && check_input(buysell_conditions,",gapdownbuy,");
            bool buy_cond5=zone_switched!="none" && check_input(buysell_conditions,",zoneswitched,");
            bool buy_cond6=skmkt_movement_anyup && check_input(buysell_conditions,",anyup,");
            bool buy_cond7=skind_rsi_mkt=="up" && check_input(buysell_conditions,",rsiup,");
            bool buy_cond8=skind_macd_mkt=="up" && check_input(buysell_conditions,",macdup,");
            

            bool sell_cond1=(Open[1]>ma && Close[1]<ma && check_input(buysell_conditions,",ma,"));
            bool sell_cond2=(Close[1]<smin) && check_input(buysell_conditions,",smin,");
            bool sell_cond3=pointsgap_up && check_input(buysell_conditions,",gapupsell,");
            bool sell_cond4=pointsgap_down && check_input(buysell_conditions,",gapdownsell,");
            bool sell_cond5=zone_switched!="none" && check_input(buysell_conditions,",zoneswitched,");
            bool sell_cond6=skmkt_movement_anydown && check_input(buysell_conditions,",anydown,");
            bool sell_cond7=skind_rsi_mkt=="down" && check_input(buysell_conditions,",rsidown,");
            bool sell_cond8=skind_macd_mkt=="down" && check_input(buysell_conditions,",macddown,");

            skdebug("new order try for "+whichorder+" gap="+MathAbs(int(Ask-last_order_price)) + " last price="+last_order_price,dbgcheck2);
            skdebug("buycond|1="+buy_cond1+" |2="+buy_cond2+" |3="+buy_cond3+" |4="+buy_cond4+" |5="+buy_cond5+" |6="+buy_cond6+" |7="+buy_cond7+" |8="+buy_cond8,dbgcheck2);
            skdebug("sellcond|1="+sell_cond1+" |2="+sell_cond2+" |3="+sell_cond3+" |4="+sell_cond4+" |5="+sell_cond5+" |6="+sell_cond6+" |7="+sell_cond7+" |8="+sell_cond8,dbgcheck2);
            skdebug("gapup="+pointsgap_up+"|gapdown="+pointsgap_down+" |Needed ="+(skpoints_gap_between_orders*pointstoprice)+"|gapok="+pointsgap_ok_from_lastorder_open,dbgcheck2);
            skdebug("gapok="+pointsgap_ok_from_lastorder_open+" |OrdersTotal="+OrdersTotal()+" |maxlot="+maxlots,dbgcheck2);

      //if(OrdersTotal()<maxlots && (pointsgap_ok_from_lastorder_open ) )
      if(pointsgap_ok_from_lastorder_open  )
        {
            if(CalculateCurrentOrders("buy")<=maxlots/2 && ( whichorder=="buy" || whichorder=="both" ) )
             if(buy_cond1 || buy_cond2 || buy_cond3 || buy_cond4  || buy_cond5 || buy_cond6 || buy_cond7 || buy_cond8 )
                {
                    //skdebug("will buy due to cond1="+buy_cond1+"|cond2="+buy_cond2+"|gapup="+pointsgap_up+"| gapdown="+pointsgap_down+"|zonesw="+zone_switched+" | gap="+pointsgap_ok_from_lastorder_open,dbgcheck1 );
                    skdebug("will buy due to cond1="+buy_cond1+" |2="+buy_cond2+" |3="+buy_cond3+" |4="+buy_cond4+" |5="+buy_cond5+" |6="+buy_cond6+" |7="+buy_cond7+" |8="+buy_cond8,dbgcheck1 );
                    ticketnumber=OpenPosition(Symbol(), OP_BUY, lotsize2, 0, 0, MagicNumber,skcomment);
                    //if(ticketnumber) last_order_price=Ask;
                skdebug("pointsgap_up Ask="+Ask+"|lastorderprice="+last_order_price+"|point="+pointstoprice+"|diff="+(Ask-last_order_price)+"|vs ="+(2*skpoints_gap_between_orders*pointstoprice)+"just gap="+MathAbs(Ask-last_order_price)+" vs "+(skpoints_gap_between_orders*pointstoprice),dbgcheck1);
                }

            if(CalculateCurrentOrders("sell")<=maxlots/2 && ( whichorder=="sell" || whichorder=="both" ) )
             if(sell_cond1 || sell_cond2 || sell_cond3 || sell_cond4 || sell_cond5 || sell_cond6 || sell_cond7 || sell_cond8)
                {
                    //skdebug("will sell due to  cond1="+sell_cond1+"|cond2="+sell_cond2+"|gapup="+pointsgap_up+"|gapdown="+pointsgap_down+"|zonesw="+zone_switched+" | gap="+pointsgap_ok_from_lastorder_open,dbgcheck1);
                    skdebug("will sell due to cond1="+sell_cond1+" |2="+sell_cond2+" |3="+sell_cond3+" |4="+sell_cond4+" |5="+sell_cond5+" |6="+sell_cond6+" |7="+sell_cond7+" |8="+sell_cond8,dbgcheck1 );
                    ticketnumber=OpenPosition(Symbol(), OP_SELL, lotsize2, 0, 0, MagicNumber,skcomment);
                    //if(ticketnumber) last_order_price=Bid;
                skdebug("pointsgap_up Ask="+Ask+"|lastorderprice="+last_order_price+"|point="+pointstoprice+"|diff="+(Ask-last_order_price)+"|vs ="+(2*skpoints_gap_between_orders*pointstoprice)+"just gap="+MathAbs(Ask-last_order_price)+" vs "+(skpoints_gap_between_orders*pointstoprice),dbgcheck1);
                }
            zone_switched="none";
        }
      return(ticketnumber);
   }
void update_lotsize_lotcount_tp()
    {
        int lotscount_multiplier=int(MathMax(1,AccountEquity()/increaselots_whenequityis));
        int sklevel_current_abs=MathAbs(sklevel_current);

        lotsize_to_execute=Lots*lotscount_multiplier;
        lotsize_to_execute_buy=lotsize_to_execute_sell=lotsize_to_execute;

        if(lotsize_increase=="self_ordercount")
            {
                lotsize_to_execute_buy=MathMin(maxlot_size_multiply,CalculateCurrentOrders("sell")) * Lots ;
                lotsize_to_execute_sell=MathMin(maxlot_size_multiply,CalculateCurrentOrders("buy")) * Lots ;
            }
        
        if(lotsize_increase=="opposite_ordercount")
            {
                lotsize_to_execute_sell=MathMin(maxlot_size_multiply,CalculateCurrentOrders("sell")) * Lots ;
                lotsize_to_execute_buy=MathMin(maxlot_size_multiply,CalculateCurrentOrders("buy")) * Lots ;
            }
        if(lotsize_increase=="level&1")
            {
                lotsize_in_direction=Lots;
                lotsize_in_support=MathMin(maxlot_size_multiply,sklevel_current_abs)*Lots;
            }
        if(lotsize_increase=="level&level-1")
            {
                lotsize_in_direction=MathMax(1,(MathMin(maxlot_size_multiply,sklevel_current_abs)-1))*Lots;
                lotsize_in_support=MathMin(maxlot_size_multiply,sklevel_current_abs)*Lots;
            }
            
        if(lotsize_increase=="level&level")
            {
                lotsize_in_direction=lotsize_in_support=MathMin(maxlot_size_multiply,sklevel_current_abs)*Lots;
            }

        //sktakeprofit=MathMax(1, sktakeprofit_input*((20-lotscount_multiplier)/20));
        sktakeprofit=MathMax(1, sktakeprofit_input/lotscount_multiplier);
        sktakeprofit=sktakeprofit_input;
        //maxlots=MathMax(int(maxlots_count/4), int(maxlots_count*((20-lotscount_multiplier)/20)));
        maxlots=maxlots_count;

    }
    
void sleep_minutes(int minutestosleep)
   {
      datetime waitstart_time=TimeCurrent();
      skdebug("waiting for "+minutestosleep+" minutes because we got loss. Current time = "+waitstart_time,dbgcheck1); 
      Sleep(60*1000*minutestosleep);
      datetime afterwait_time=TimeCurrent();
      skdebug("wait Over for "+minutestosleep+" minutes because we got loss. Current time = "+afterwait_time+" lasttime="+waitstart_time,dbgcheck1); 
   }

void close_all_if_equity_profit()
    {
        bool temp2;
        if(closeall_if_profit_inr>0)
            if( ( start_balance+closeall_if_profit_inr) < AccountEquity() )
            {
                skdebug("Profit exit : closing all orders as equity balance changed from "+start_balance+" to "+AccountEquity(),dbgcheck1);
                closeall_orders("all");
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
            }

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
    
void set_sklevel()
   { 
            //if(sklevel_current!=sklevel_prev)
            sklevel_gap_touse=skpoints_gap_between_orders*pointstoprice;
            if(skpoints_gap_between_orders_input == 0)
                {
                    sklevel_gap_touse=MathAbs(sklevel_current);
                    if(sklevel_current==0)
                        sklevel_gap_touse=1;
                }
    

            if(Ask > sklevel_up_value) 
                {
                    sklevel_prev = sklevel_current;
                    sklevel_current+=1;
                    sklevel_switched=True;
                    //should_buy=True;
                }

            if(Ask < sklevel_down_value) 
            {
                    sklevel_prev = sklevel_current;
                    sklevel_current-=1;
                    sklevel_switched=True;
                    //shuould_sell=true;
            }

            if(sklevel_switched)
                { 
                    sklevel_up_value=Ask+(sklevel_gap_touse);
                    sklevel_down_value=Ask-(sklevel_gap_touse);
                    sklevel_switched=False;
                    skdebug("Level changed from "+sklevel_prev+" to "+sklevel_current+" and gaptouse="+
                        sklevel_gap_touse+" target UP="+sklevel_up_value+" Down="+sklevel_down_value,dbgcheck1);
                    oktotrade=True;
                }

            //sklevel_prev = sklevel_current;
            int riskfactor=1;
            //sklevel_lotsize=NormalizeDouble( Lots*(MathAbs(sklevel_current)+1),2);
            sklevel_lotsize2=Lots;
            sklevel_lotsize=Lots;
            //sklevel_lotsize2=sklevel_lotsize/2;
            //sklevel_lotsize2= NormalizeDouble( Lots*(MathAbs(2*sklevel_current)-1),2);
            //oktotrade=True;

            if(skmkt_movement=="up")
                {
                    //buy towards side of movement 
                    sklevel_lotsize=NormalizeDouble( Lots*(MathAbs(sklevel_current)+1),2);
                    sklevel_lotsize2=0;
                }
                    else if ( skmkt_movement=="down")
                    {
                        //sell keep only selling
                        sklevel_lotsize=NormalizeDouble( Lots*(MathAbs(sklevel_current)+1),2);
                        sklevel_lotsize2=0;
                    }

        if(skreverse==True)
        {
            double tempvar=sklevel_lotsize;
            sklevel_lotsize=sklevel_lotsize2;
            sklevel_lotsize2=tempvar;
        }
        
        sl=tp=0;
        string current_leveltransition="from_"+sklevel_prev+"_to_"+sklevel_current;

        if( ( OrdersTotal()>=maxlots && closeallcondition ) )
        {
                skdebug("max lots touched so will close all open orders ",dbgcheck1);
                closeall_orders("all");
        }

        if( sklevel_current!=sklevel_prev && oktotrade )
            {
                oktotrade=False;
                skdebug("skcheck4 : levels,p,c ="+sklevel_prev+","+sklevel_current,dbgcheck2);

                if(sklevel_current == 0)   // mkt back to position where started 
                {
                    if(sklevel_prev < sklevel_current)
                        {
                            skdebug("downward sqoff : levels,p,c="+sklevel_prev+","+sklevel_current,dbgcheck1);
                            //remove 1 sell lot ( last one )
                            if(OrderClose(lastsell_order,lastsell_lots,Bid,Slippage,clrAqua) )
                                skdebug("Success last sell order closed with lots ="+lastsell_lots,dbgcheck1);
                            else
                                skdebug("Failed last sell order closed with lots ="+lastsell_lots,dbgcheck1);
                                
                            // remove level+1 buy lots 
                            if(OrderClose(lastbuy_order,lastbuy_lots,Ask,Slippage,clrAqua) )
                                skdebug("Success last buy order closed with lots ="+lastbuy_lots,dbgcheck1);
                            else
                                skdebug("Failed last buy order closed with lots ="+lastbuy_lots,dbgcheck1);

                        }  
                    if(sklevel_prev > sklevel_current)
                        {
                            skdebug("upward sqoff : levels,p,c="+sklevel_prev+","+sklevel_current,dbgcheck1);
                            //remove 1 buy lot 
                            if(OrderClose(lastbuy_order,lastbuy_lots,Ask,Slippage,clrAqua) )
                                skdebug("Success last buy order closed with lots ="+lastbuy_lots,dbgcheck1);
                            else
                                skdebug("Failed last buy order closed with lots ="+lastbuy_lots,dbgcheck1);
                                
                            // remove level+1 sell lots 
                            if(OrderClose(lastsell_order,lastsell_lots,Bid,Slippage,clrAqua) )
                                skdebug("Success last sell order closed with lots ="+lastsell_lots,dbgcheck1);
                            else
                                skdebug("Failed last sell order closed with lots ="+lastsell_lots,dbgcheck1);

                        }
                }

                if(sklevel_current > 0) // mkt going up so book buy profits 
                {
                    //if(sklevel_prev < sklevel_current && OrdersTotal()<maxlots && ( skmkt_movement_prev=="up" || skmkt_movement=="up") )
                    if(sklevel_prev < sklevel_current && OrdersTotal()<maxlots && ( skmkt_movement!="down") )
                    {
                            skdebug("upward movement : levels,p,c="+sklevel_prev+","+sklevel_current,dbgcheck1);
                        //add 1 more buy standard lot
                            //lastbuy_lots=Lots;
                            lastbuy_lots=sklevel_lotsize;
                            ordercomment="buy"+lastbuy_lots;
                        if(lastbuy_lots>0 )
                            if(lastbuy_order=OpenPosition(Symbol(), OP_BUY, lastbuy_lots, sl, tp, MagicNumber,ordercomment))
                                skdebug("Success 2 new buy order placed with lots ="+lastbuy_lots,dbgcheck1);
                            else
                                skdebug("Faild 2 New buy order with lots ="+lastbuy_lots+GetLastError(),dbgerr);
                        //add level+1 sell lots 
                            lastsell_lots=sklevel_lotsize2;
                            ordercomment="sell"+lastsell_lots;
                        if(lastsell_lots>0 && 1==2 )
                            if(lastsell_order=OpenPosition(Symbol(), OP_SELL, lastsell_lots, sl, tp, MagicNumber,ordercomment))
                                skdebug("Success new sell order placed with lots ="+lastsell_lots,dbgcheck1);
                            else
                                skdebug("Faild New sell order with lots ="+lastsell_lots+GetLastError(),dbgerr);
                    }
                    if(sklevel_prev > sklevel_current && ( skmkt_movement!="up"))
                    {
                        closeall_orders("sell");
                        /*
                        skdebug("upward sqoff : levels,p,c,nu,nd="+sklevel_prev+","+sklevel_current,dbgcheck1);
                        //remove 1 buy lot 
                            if(OrderClose(lastbuy_order,lastbuy_lots,Ask,Slippage,clrAqua) )
                                skdebug("Success last buy order closed with lots ="+lastbuy_lots,dbgcheck1);
                            else
                                skdebug("Failed last buy order closed with lots ="+lastbuy_lots,dbgcheck1);
                            
                        // remove level+1 sell lots 
                            if(OrderClose(lastsell_order,lastsell_lots,Bid,Slippage,clrAqua) )
                            skdebug("Success last sell order closed with lots ="+lastsell_lots,dbgcheck1);
                            else
                                skdebug("Failed last sell order closed with lots ="+lastsell_lots,dbgcheck1);
                        */
                    }
                }

                if(sklevel_current < 0)   // mkt going down so book profit from sell 
                {
                    //if(sklevel_prev > sklevel_current && OrdersTotal()<maxlots && ( skmkt_movement_prev=="down" || skmkt_movement=="down" ) )
                    if(sklevel_prev > sklevel_current && OrdersTotal()<maxlots && ( skmkt_movement!="up" ) )
                    {
                            skdebug("downward movement : levels,p,c="+sklevel_prev+","+sklevel_current,dbgcheck1);
                        //add 1 more sell standard lot
                            //lastsell_lots=Lots;
                            lastsell_lots=sklevel_lotsize;
                            ordercomment="sell"+lastsell_lots;
                        if(lastsell_lots>0)
                            if(lastsell_order=OpenPosition(Symbol(), OP_SELL, lastsell_lots, sl, tp, MagicNumber,ordercomment))
                                skdebug("Success new sell order placed with lots ="+lastsell_lots,dbgcheck1);
                            else
                                skdebug("Faild New sell order with lots ="+lastsell_lots+GetLastError(),dbgerr);
                        //add level+1 buy lots 
                            lastbuy_lots=sklevel_lotsize2;
                            ordercomment="buy"+lastbuy_lots;
                        if(lastbuy_lots>0 && 1==2)
                            if(lastbuy_order=OpenPosition(Symbol(), OP_BUY, lastbuy_lots, sl, tp, MagicNumber,ordercomment))
                                skdebug("Success 3 new buy order placed with lots ="+lastbuy_lots,dbgcheck1);
                            else
                                skdebug("Faild 3 New buy order with lots ="+lastbuy_lots+GetLastError(),dbgerr);
                    }
                    if(sklevel_prev < sklevel_current && skmkt_movement!="down" )
                    {
                        closeall_orders("sell");
                        /*
                        skdebug("downward sqoff : levels,p,c,nu,nd="+sklevel_prev+","+sklevel_current,dbgcheck1);
                        //remove 1 sell lot ( last one )
                            if(OrderClose(lastsell_order,lastsell_lots,Bid,Slippage,clrAqua) )
                                skdebug("Success last sell order closed with lots ="+lastsell_lots,dbgcheck1);
                            else
                                skdebug("Failed last sell order closed with lots ="+lastsell_lots,dbgcheck1);
                            
                        // remove level+1 buy lots 
                            if(OrderClose(lastbuy_order,lastbuy_lots,Ask,Slippage,clrAqua) )
                            skdebug("Success last buy order closed with lots ="+lastbuy_lots,dbgcheck1);
                            else
                                skdebug("Failed last buy order closed with lots ="+lastbuy_lots,dbgcheck1);
                        */
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
      if(sksl!=0 && linegap!=0) 
         {
         sl =Bid-((sksl*usdtopoints)*linegap);
         slr=Ask+((sksl*usdtopoints)*linegap);
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
               skdebug("first buy,Size:"+ll+":SL:"+sl+":TP:"+tp+":msg:"+ordercomment,2);
               OpenPosition(Symbol(), OP_BUY, ll, sl, tp, MagicNumber,ordercomment);
               if(doubleorder==1)
               {
                  skdebug("first SELL ,Size:"+ll+":SL:"+sl+":TP:"+tp+":msg:"+ordercomment,2);
                  OpenPosition(Symbol(), OP_SELL, ll, slr,tpr, MagicNumber,ordercomment);
                  
               }
                  if (quickstart==2)
                   {
                     skdebug("first SELL ,Size:"+ll+":SL:"+sl+":TP:"+tp+":msg:"+ordercomment,2);
                     OpenPosition(Symbol(), OP_SELL, ll, slr,tpr, MagicNumber,ordercomment);
                     if(doubleorder==1)
                     {
                        skdebug("first buy,Size:"+ll+":SL:"+sl+":TP:"+tp+":msg:"+ordercomment,2);
                        OpenPosition(Symbol(), OP_BUY, ll, sl, tp, MagicNumber,ordercomment);
                        
                     }
                    }
               
               
         }
         else
         {
            if(check_buy_conditions()) // buy order 
            {
               skdebug("first buy,TP:"+tp,2);
               OpenPosition(Symbol(), OP_BUY, ll, sl, tp, MagicNumber,ordercomment);
               if(doubleorder==1)
                  OpenPosition(Symbol(), OP_SELL, ll, slr,tpr, MagicNumber,ordercomment);
            }
            if(check_sell_conditions()) // sell order 
            {
               skdebug("first sell ,TP:"+tpr,2);
               OpenPosition(Symbol(), OP_SELL, ll, slr, tpr, MagicNumber,ordercomment);
               //Sleep(5000);
               if(doubleorder==1)
                  OpenPosition(Symbol(), OP_BUY, ll, sl,tp, MagicNumber,ordercomment);
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
      if(sksl!=0 && linegap!=0) 
         {
         sl =Bid-((sksl*usdtopoints)*linegap);
         slr=Ask+((sksl*usdtopoints)*linegap);
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
               if(OpenPosition(Symbol(), OP_BUY, llbuy, sl, tp, MagicNumber,ordercomment))
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
                  if(OpenPosition(Symbol(), OP_SELL, llsell, slr,tpr, MagicNumber,ordercomment))
                     skdebug("for order #"+orginalticket+" complementry sell order placed successfully with comment"+ordercomment,dbgcomp1);
                     else
                     skdebug("for order #"+orginalticket+" complementry sell order failed to be placed",dbgcomp1);
            }
      }
   return(0);
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

void OnTick()
   {
       if(executetrades && user_allowed )
       {
            totalorderscount=CalculateCurrentOrders("all");
            pointsgap_ok_from_lastorder_open=MathAbs(Ask-last_order_price) > skpoints_gap_between_orders*pointstoprice;
            display_details_onchart();
            skdebug("total Orders :"+OrdersTotal(),dbgcheck2);

            check_mkt_movement();
            update_lotsize_lotcount_tp();
            if(pointsgap_ok_from_lastorder_open)
            {
            Print("1=",MathAbs(Ask-last_order_price) , skpoints_gap_between_orders,pointstoprice,skpoints_gap_between_orders*pointstoprice);
                neworder_start_if_no_orders(startwith);
                buy_sell_based_on_mkt_movements();
                exit_on_tp_or_sl(howtoclose);
                close_all_if_equity_profit();
            }
       }
        
    /*

      if(totalorderscount==0) // place new order as per condition .
      {
         skdebug("NO Orders created so placing orders ",7);
         //neworder_buy_sell_both();
         //neworder_check(buyselltogether);
         neworder_start_if_no_orders(quickstart);
         sklevel=0;
         sklevel_start_price=Ask;
      }
      set_sklevel();
      
      //totalorderscount=CalculateCurrentOrders("all");
      // trail the profit if orders are more then 1
      if(totalorderscount>0 )  // in loop keep checking all orders for exit 
         {
            int i,k,toalopenorders,check1=0,check2=0;
            k=toalopenorders=totalorderscount;
            //double maxlossallowedperorder=maxloss_allowed_inr/toalopenorders;

            for(i=0; i<k; i++)
               {
                  if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
                     {
                        if(OrderSymbol()==Symbol() && (OrderMagicNumber()==MagicNumber))
                        {
                           //definitions 
                              int cr_ord_type=OrderType();
                              string cr_ord_comment=OrderComment();
                              int cr_ord_ticket=OrderTicket();
                              double cr_ord_lots=OrderLots();
                              double cr_ord_profit=OrderProfit();
                              bool sksl_triggered=cr_ord_profit < (-1*sksl*cr_ord_lots/Lots);
                              bool skprofit_triggered=cr_ord_profit+minpricegap > (sktakeprofit*cr_ord_lots/Lots);
                              bool skmaxloss_triggered=cr_ord_profit < ( -1*maxloss_allowed_inr );
                              bool skorderinloss_needsupport=cr_ord_profit < (-1*supportiflossinr*cr_ord_lots/Lots);

                           if( skprofit_triggered ) 
                           {
                              if(OrderType()==OP_BUY )
                              {
                                  //if level postive 
                                 skdebug("SK Close BUY ORDER #"+OrderTicket()+" :CurrentProfit:"+OrderProfit()+" tgtfirst : "+(sktakeprofit*OrderLots()/Lots ) +" msg="+OrderComment() ,dbgclose2);
                                 check1=iscomplementry_open(cr_ord_comment,cr_ord_ticket);
                                 OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
                                 skcloseorder(cr_ord_ticket);
                                 if (check1==False && skprofit_triggered && OrdersTotal()<=maxlots ) 
                                       { 
                                          skdebug("complementry order for Profit booking against buy Order #"+cr_ord_ticket , dbgcomp1);
                                             if(StringFind(skdebuglevel,dbgcomp1) >=0) OrderPrint();
                                          randomname="comp2"+rand();
                                          new_complementry_order(OP_BUY,cr_ord_ticket,cr_ord_comment);
                                       }
                              }

                              if(OrderType()==OP_SELL  )
                              {
                                 skdebug("SK Close SELL ORDER #"+cr_ord_ticket+":CurrentProfit:"+cr_ord_profit+" tgtfirst : "
                                       +(sktakeprofit*OrderLots()/Lots )+" comment="+cr_ord_comment ,3 );
                                 check2=iscomplementry_open(cr_ord_comment,cr_ord_ticket);
                                 OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
                                 skcloseorder(cr_ord_ticket);
                                 if (check2==False && skprofit_triggered && OrdersTotal()<=maxlots )
                                 {
                                    {
                                          skdebug("complementry order for Profit booking against sell Order #"+cr_ord_ticket,dbgcomp1);
                                             if(StringFind(skdebuglevel,dbgcomp1) >=0) OrderPrint();
                                          randomname="comp4"+rand();
                                          new_complementry_order(OP_SELL,cr_ord_ticket,cr_ord_comment);
                                    }
                                 }
                              }
                           }

                           if( sksl_triggered ) 
                           {
                              skdebug("SL is triggered for one order so will exit all orders now ",dbgclose2);
                              int nextaction="sell";
                              if(OrderType()==OP_SELL) nextaction="buy";
                              if(quickstart==3) nextaction="buysell";
                              
                              while(CalculateCurrentOrders("all") >0 ) 
                                    closeall_orders("all");
                                 
                                if(CalculateCurrentOrders("all")==0) 
                                    {
                                        neworder_start_if_no_orders(nextaction);
                                    }
                              
                           }

                        }

                     }
               }


         }
      
    */
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
            Sleep(5000);
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
            err=GetLastError();
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



int closeall_orders(string whichorderstoclose)
   {
      int returnvalue,kk,mm;
      
      mm=CalculateCurrentOrders(whichorderstoclose);
      if( mm<=0)
        {
            skdebug("there are no orders to close for "+whichorderstoclose,dbgcheck1);
            return(1);
        }


      kk=OrdersTotal();

      //kk=CalculateCurrentOrders("all");
      //while ( OrdersTotal() > 0)
      //if( (whichorderstoclose=="sell" && sksellcount>0 ) || (whichorderstoclose=="buy" && skbuycount>0) || (whichorderstoclose=="all" && kk>0))
      if( mm>0 )
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
                     if(OrderType()==OP_BUY && ( whichorderstoclose=="buy" || whichorderstoclose=="all") )
                        {
                            skdebug("Closing the BUY order :"+OrderTicket()+" at position #"+ii,dbgclose1);
                            OrderClose(OrderTicket(),OrderLots(),Bid,Slippage,clrAqua);
                            OrderPrint();
                        }
                     else if(OrderType()==OP_SELL && ( whichorderstoclose=="sell" || whichorderstoclose=="all") )
                        {
                            skdebug("Closing the sell order :"+OrderTicket()+" at position #"+ii,dbgclose1);
                            OrderClose(OrderTicket(),OrderLots(),Ask,Slippage,clrBrown);
                        }
                  }
                  else   skdebug("Order closing error for order#"+ii+" err="+GetLastError(),dbgcheck1);

            }
            else   skdebug("Order selection error for order#"+ii+" err="+GetLastError(),dbgcheck1);
            
         }
      }          
         //Print("current Orders =",CalculateCurrentOrders("all"));          
      if(CalculateCurrentOrders("all") <=0 ) 
         returnvalue=1;
         else 
         returnvalue=0;
         
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
                     sqoff_price=Ask;
                        if(OrderType()==OP_BUY) sqoff_price=Bid;

                    int cr_ord_type=OrderType();
                    string cr_ord_comment=OrderComment();
                    int cr_ord_ticket=OrderTicket();
                    double cr_ord_lots=OrderLots();
                    double cr_ord_profit=OrderProfit();
                    bool sksl_triggered=cr_ord_profit < (-1*sksl*cr_ord_lots/Lots);
                    bool skprofit_triggered=cr_ord_profit > (sktakeprofit*(cr_ord_lots/Lots));
                    if(check_input(cr_ord_comment,"quick"))
                        skprofit_triggered=cr_ord_profit > (sktakeprofit_input_quick*(cr_ord_lots/Lots));


                      if((whichorderstoclose=="all" ||whichorderstoclose=="tp" ) && skprofit_triggered)
                      {
                            OrderPrint();
                            if(OrderClose(OrderTicket(),OrderLots(),sqoff_price,Slippage,clrBlue))
                                skdebug("success Closing order with Profit="+ cr_ord_profit+" order#"+OrderTicket()+" at position #"+ii+
                                "|sqoffprice="+sqoff_price+"|profitset="+sktakeprofit+"("+sktakeprofit*(cr_ord_lots/Lots)+")",dbgclose1);
                            else
                                skdebug("Failed Closing order with Profit="+ cr_ord_profit+" order#"+OrderTicket()+" at position #"+ii+"|sqoffprice="+sqoff_price+GetLastError(),dbgclose1);
                      }
                      else if((whichorderstoclose=="all" || whichorderstoclose=="sl" ) && sksl_triggered)
                      {
                            OrderPrint();
                            if(OrderClose(OrderTicket(),OrderLots(),sqoff_price,Slippage,clrRed))
                                skdebug("Success :Closing order with Loss="+ cr_ord_profit+" order#"+OrderTicket()+" at position #"+ii+"|sqoffprice="+sqoff_price,dbgclose1);
                            else
                                skdebug("Failed :Closing order with Loss="+ cr_ord_profit+" order#"+OrderTicket()+" at position #"+ii+"|sqoffprice="+sqoff_price+GetLastError(),dbgclose1);
                      }
                  }
                  else   skdebug("Order closing error for order#"+ii+" err="+GetLastError(),dbgcheck1);

            }
            else   skdebug("Order selection error for order#"+ii+" err="+GetLastError(),dbgcheck1);
            
         }
      }          
         //Print("current Orders =",CalculateCurrentOrders("all"));          
         
         return(1);
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
      double sktotalprofit=0,crprofit=0,spreadsize=0,buy_lots_total=0,sell_lots_total=0;
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
                  break;
               if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
               {
                  if(OrderType()==OP_BUY) 
                  {
                     skbuycount++;
                     buy_lots_total+=OrderLots();
                     size1=int(OrderLots()*100  );
                     lastbuy_order=OrderTicket();
                     lastbuy_lots=OrderLots();
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

                  }
                  crprofit=OrderProfit();
                  sktotalprofit+=crprofit;
                  if(crprofit>0)
                     positivecount+=1;
                  if(crprofit<=0)
                     negativecount+=1;
               }
            }
        skbuy_lotsize=skbuycount+1;
        sksell_lotsize=sksellcount+1;
        buy_lots_total=NormalizeDouble(buy_lots_total,2);
        sell_lots_total=NormalizeDouble(sell_lots_total,2);
        if(negativecount>0) skpoints_gap_between_orders=skpoints_gap_between_orders_input*(1+negativecount/maxlots);

        
       Comment("     Orders T(P+N)=",(negativecount+positivecount),"(",positivecount,"+",negativecount,
               ") B+S = ",skbuycount,"+",sksellcount," Lots B+S(",buy_lots_total,"+",sell_lots_total,") ",
               ") Profit=",int(sktotalprofit),"(",int(ap),")/",int(balance),"  gross =",int(balance+ap)," from ",int(opening_balance),
               "last_equity=",start_balance," spread=",int(spreadsize),
               "\n                                     BUY:",buy_comment,
               "\n                                     SELL:",sell_comment,
               "\n                                    Level=",sklevel_current," prev level=",sklevel_prev,
               " Ask=",Ask," sklevel_start_price=",sklevel_start_price,
               "\n                              RSI=",int(skind_rsi_lastvalue),"_",int(skind_rsi_currentvalue),
                        "|macd=",int(skind_macd_lastvalue),"_",int(skind_macd_currentvalue),
                        "|signal=",int(skind_signal_lastvalue),"_",int(skind_signal_currentvalue),
               "\n                            MKT MOVEMENT PREV=",skmkt_movement_prev,"| Current=",skmkt_movement,"| macdmove=",skind_macd_mkt,"| rsimove=",skind_rsi_mkt,
               "|");
       
     }
void deinit()
{
    Print("exiting the EA due to user not registered");

}
