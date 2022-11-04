//+------------------------------------------------------------------+
//|                                            RSI+2CCI+HAS_MTF.mq4 |
//|                                           Copyright 2012, SANFIC |
//|                                        http://www.san-fic.ru     |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, SANFIC"
#property link      "http://www.metaquotes.net"
#property indicator_minimum 0
#property indicator_maximum 1

#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 ForestGreen
#property indicator_width1 2
#property indicator_color2 Red
#property indicator_width2 2
#property indicator_color3 Silver
#property indicator_width3 1

extern int    TimeFrame = 1;
extern int    PeriodRSI = 14;     
extern int  PeriodCCI_1 = 34;
extern int  PeriodCCI_2 = 170;

double Signal_up[];
double Signal_down[];
double Signal_flat[];
double RSI,CCI_1,CCI_2,HAS_b,HAS_s ;  
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
 SetIndexStyle(0,DRAW_HISTOGRAM);
 SetIndexBuffer(0,Signal_up);
 SetIndexStyle(1,DRAW_HISTOGRAM);
 SetIndexBuffer(1,Signal_down);
 SetIndexStyle(2,DRAW_HISTOGRAM);
 SetIndexBuffer(2,Signal_flat);


 
 IndicatorShortName ("RSI+2CCI+HAS_MTF") ;
 
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
    int limit;
    
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   
   
   
   for (int i=limit;i>=0;i--) 
   {
   int y = iBarShift(NULL,TimeFrame,Time[i]);
   
   RSI   = iRSI(NULL,TimeFrame,PeriodRSI,PRICE_CLOSE,y);
   CCI_1 = iCCI(Symbol(),TimeFrame,PeriodCCI_1,PRICE_TYPICAL,y);
   CCI_2 = iCCI(Symbol(),TimeFrame,PeriodCCI_2,PRICE_TYPICAL,y);
   HAS_b = iMA(NULL,TimeFrame,6,0,MODE_SMMA,PRICE_CLOSE,y);
   HAS_s = iMA(NULL,TimeFrame,2,0,MODE_LWMA,PRICE_CLOSE,y);
   
  Signal_up[i]=EMPTY_VALUE;   Signal_down[i]=EMPTY_VALUE; Signal_flat[i]= 1;
   
   if ((RSI > 55)&&(CCI_1>0)&&(CCI_2>0)&&(HAS_b<HAS_s))
   {  Signal_up[i]=1;   Signal_down[i]=EMPTY_VALUE; Signal_flat[i]= EMPTY_VALUE;
   
   }
     
      
   
   if ((RSI < 45)&&(CCI_1<0)&&(CCI_2<0)&&(HAS_s<HAS_b))
   { Signal_up[i]=EMPTY_VALUE;   Signal_down[i]=1; Signal_flat[i]= EMPTY_VALUE;
  
   } 
   
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+