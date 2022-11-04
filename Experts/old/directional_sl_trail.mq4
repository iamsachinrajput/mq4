//+------------------------------------------------------------------+
//|                                         directional_sl_trail.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022 Sachin Rajput."
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
take_decision();
new_position();
trail_SL();
display_details_onchart();
print_details();
   
  }
//+------------------------------------------------------------------+
int take_decision()
{

}


int new_pending_buy_position(price,sl,tgt,lotsize,slippage,)
{
         price_tobeused = NormalizeDouble(Ask + given_limit_normalized, GS_digits);
         SL_tobeused_inorder = NormalizeDouble(price_tobeused -  SL_points_touse * Point, GS_digits);
         TP_tobeused_inorder=0;
         if (target_input_points>0)
            TP_tobeused_inorder = NormalizeDouble(price_tobeused +  target_input_points * Point, GS_digits);
         //ticket_20 = OrderSend(Symbol(), OP_BUYSTOP, lot_size_to_trade, price_tobeused, G_slippage_264, SL_tobeused_inorder, 0, TradeComment, MagicNumber, 0, Lime);
         ticket_20 = OrderSend(Symbol(), OP_BUYSTOP, lot_size_to_trade, price_tobeused, G_slippage_264, SL_tobeused_inorder, TP_tobeused_inorder, TradeComment, MagicNumber, 0, Lime);
         if (ticket_20 <= 0) {
            error_code = GetLastError();
            error_details = ErrorDescription(error_code);
                  printf(" #"+ticket_20 + " given_limit_normalized="+given_limit_normalized+ "OP: " + DoubleToStr(price_tobeused, GS_digits) +"/"+(price_tobeused-current_order_price)+ " SL: " + DoubleToStr(SL_tobeused_inorder, GS_digits) +"/"+(price_tobeused-SL_tobeused_inorder)+ " Bid: " + DoubleToStr(Bid, GS_digits) +"/"+(Bid-SL_tobeused_inorder)+ " Ask: " + DoubleToStr(Ask, GS_digits) +"/"+(Ask-SL_tobeused_inorder) );
            printf("BUYSTOP Send Error Code: " + error_code + " Message: " + error_details + " LT: " + DoubleToStr(lot_size_to_trade, GS_step_logvalue) + " OP: " + DoubleToStr(price_tobeused, GS_digits) + " SL:"+DoubleToStr(SL_tobeused_inorder-Bid,GS_digits)+"=" + DoubleToStr(SL_tobeused_inorder, GS_digits)+" TP:" + TP_tobeused_inorder + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
          }
         else 
            {
            
            printf("BUYSTOP Send Success LT: " + DoubleToStr(lot_size_to_trade, GS_step_logvalue) + " OP: " + DoubleToStr(price_tobeused, GS_digits) + " SL:"+DoubleToStr(SL_tobeused_inorder-price_tobeused,GS_digits)+"=" + DoubleToStr(SL_tobeused_inorder, GS_digits)+" TP:" + TP_tobeused_inorder + " Bid: " + DoubleToStr(Bid, GS_digits) + " Ask: " + DoubleToStr(Ask, GS_digits));
               printf("Success : buy order id = "+ticket_20+" price="+price_tobeused+" SL="+SL_tobeused_inorder);
               total_traded_lots_tillnow+=lot_size_to_trade;
               lots_in_this_session+=lot_size_to_trade;
               //printf(message_to_display);
               total_orders_executed++;
               last_order_time=TimeCurrent();
               if(total_orders_executed==1)
               first_order_time=TimeCurrent();


}

int trail_SL()
{

}

int display_details_onchart()
{

}

int print_details()
{
   
}