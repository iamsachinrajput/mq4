//+------------------------------------------------------------------+
//|                                                     sell&buy.mq4 |
//+------------------------------------------------------------------+

extern double per_lot_profit=1;
extern int magic=0000;

int start() {
 // calculate profit 
 int j=OrdersTotal()-1;
 for (int i=j;i>=0;i--)
  {
   OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(( OrderProfit()+OrderSwap() ) > per_lot_profit*OrderLots())
      {
        if(OrderType()==OP_BUY && OrderMagicNumber()==magic && OrderSymbol()==Symbol())
            OrderClose(OrderTicket(),OrderLots(),Bid,3,Blue);
        if(OrderType()==OP_SELL && OrderMagicNumber()==magic && OrderSymbol()==Symbol())
            OrderClose(OrderTicket(),OrderLots(),Ask,3,Red);
       }
  }
 return(0);
}