//+------------------------------------------------------------------+
//|                                              peak_ea_for_all.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010


input bool stopworkingflag_input=False;
input bool no_new_trades=True;
bool stopworkingflag=stopworkingflag_input;

void init_from_file()
{

Comment("taking inputs and showing from include file working init1 ");
printf("update 1");
}


void tick_from_file()
{

Comment("taking inputs and showing from include file working update6 ");
}

void deinit_from_file()
{

Comment("taking inputs and showing from include file working ");
}

//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
