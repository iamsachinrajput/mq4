//+------------------------------------------------------------------+
//|                                         peak_ea_with_include.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

   #include <C:\Users\Admin\AppData\Roaming\MetaQuotes\Terminal\F88322FE42475AD7CA9BD6F29E7EB31C\MQL4\Include\peak_ea_for_all.mqh>

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
//--

init_from_file();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
  deinit_from_file(); 
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
tick_from_file();

  }
//+------------------------------------------------------------------+
