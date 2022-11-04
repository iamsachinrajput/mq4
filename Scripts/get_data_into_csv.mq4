//+------------------------------------------------------------------+
//|                                            get_data_into_csv.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
extern int barstouse=-1;
void OnStart()
  {
//---
if(barstouse==-1)
   barstouse=Bars;
printf(Symbol() + " Write Start " + Bars );


int timeframe=PERIOD_M1;
string filename="mq4_data_to_csv_"+Symbol()+"_"+timeframe+"_"+barstouse+".txt";
getData(Symbol(),timeframe,barstouse,filename);

timeframe=PERIOD_M5;
filename="mq4_data_to_csv_"+Symbol()+"_"+timeframe+"_"+barstouse+".txt";
getData(Symbol(),timeframe,barstouse,filename);

timeframe=PERIOD_M15;
filename="mq4_data_to_csv_"+Symbol()+"_"+timeframe+"_"+barstouse+".txt";
getData(Symbol(),timeframe,barstouse,filename);


printf(Symbol() + " Write FINISHED " + filename);
   
  }
//+------------------------------------------------------------------+

bool getData(string symbol,int timeframe,int startFrom,string fileName)
{
  string message="Symbol;date time;open;high;low;close;close5;close10;close15;AC;AD;AO;ATR;BEP;BUP;DMK;FORCE;FRACTAL;ICHIMOKU;BWMFI;Momentum_GAP;MA;OsMA;MACD_GAP;OBV;SAR;RSI;RVI;STDDEV;Stochastic_GAP;WPR";  
  string lastmessage="";
  for(int i=startFrom;i>=0;i--)
  {
     lastmessage=StringFormat("\n%s;%s;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f;%.5f",
        symbol+"_"+timeframe,
        TimeToString(iTime(symbol,timeframe,i)),
        iOpen(symbol,timeframe,i),
        iHigh(symbol,timeframe,i),
        iLow(symbol,timeframe,i),
        iClose(symbol,timeframe,i),
        iClose(symbol,timeframe,i+5),
        iClose(symbol,timeframe,i+10),
        iClose(symbol,timeframe,i+15),
        iAC(symbol,timeframe,i),
        iAD(symbol,timeframe,i),
        iAO(symbol,timeframe,i),
        iATR(symbol,timeframe,14,i),
        iBearsPower(symbol,timeframe,13,PRICE_CLOSE,i),
        iBullsPower(symbol,timeframe,13,PRICE_CLOSE,i),
        iDeMarker(symbol,timeframe,13,i),
        iForce(symbol,timeframe,13,MODE_SMA,PRICE_CLOSE,i),
        iFractals(symbol,timeframe,MODE_UPPER,i),
        iIchimoku(symbol,timeframe,9,26,52,MODE_TENKANSEN,i),
        iBWMFI(symbol,timeframe,i),
        (iMomentum(symbol,timeframe,12,PRICE_CLOSE,i)-iMomentum(symbol,timeframe,20,PRICE_CLOSE,i)),
        (iMFI(symbol,timeframe,14,i)-iMFI(symbol,timeframe,14,i+1)),
        iMA(symbol,timeframe,13,8,MODE_SMMA,PRICE_MEDIAN,i),
        iOsMA(symbol,timeframe,12,26,9,PRICE_OPEN,i),
        (iMACD(symbol,timeframe,12,26,9,PRICE_CLOSE,MODE_MAIN,i)-iMACD(symbol,timeframe,12,26,9,PRICE_CLOSE,MODE_SIGNAL,i)),
        iOBV(symbol,timeframe,PRICE_CLOSE,i),
        iSAR(symbol,timeframe,0.02,0.2,i),
        iRSI(symbol,timeframe,14,PRICE_CLOSE,i),
        iRVI(symbol,timeframe,10,MODE_MAIN,i),
        iStdDev(symbol,timeframe,10,0,MODE_EMA,PRICE_CLOSE,i),
        (iStochastic(symbol,timeframe,5,3,3,MODE_SMA,0,MODE_MAIN,i) - iStochastic(symbol,timeframe,5,3,3,MODE_SMA,0,MODE_SIGNAL,i)),
        iWPR(symbol,timeframe,14,i)
        
        );
        message=message+lastmessage;
        printf(lastmessage);
  }
  //printf("SKsymbol"+lastmessage);
  int handle=FileDelete(fileName,0);
  if(handle==INVALID_HANDLE)return(false);
  handle=FileOpen(fileName,FILE_READ|FILE_WRITE,FILE_CSV);
  if(handle==INVALID_HANDLE)return(false);
  FileSeek(handle,0,SEEK_END);
  FileWrite(handle,message);
  FileClose(handle);
  return(true);
}