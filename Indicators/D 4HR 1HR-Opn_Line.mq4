// Original "M-Candles.mq4" edit by Arshed Qurehi, arshedfx@gmail.com

#property copyright "Житнев Михаил aka MikeZTN"
#property link      "ICQ 138092006"
#property indicator_chart_window

extern int TFBar       = 240;           
extern int NumberOfBar = 4; 


// --- Main Start -------------------------------
int start() 
   {
   int shb=0;
   double   po, pc;        // PriceOpen, PriceClose
   datetime to, tc;        // TimeOpen, TimeClose
   bool Period_Chk=false;   
   switch (TFBar)
   {    
   case 1:Period_Chk=true;break;
   case 5:Period_Chk=true;break;
   case 15:Period_Chk=true;break;
   case 30:Period_Chk=true;break;
   case 60:Period_Chk=true;break;
   case 240:Period_Chk=true;break;
   case 1440:Period_Chk=true;break;
   case 10080:Period_Chk=true;break;
   case 43200:Period_Chk=true;break;
   }
   if (Period_Chk==0 )  { Comment("Wrong TimeFarme input, correct one of these = 1,5,15,30,60,240(H4), 1440(D1),10080(W1), 43200(MN) !");   return(0);}
   if (Period()>TFBar)  { Comment("Input Time should > "+Period());  return(0);}
    
   shb=0;
   while (shb<NumberOfBar) 
      {
      to = iTime(Symbol(), TFBar, shb);
      tc = iTime(Symbol(), TFBar, shb) + TFBar*60;
      po = iOpen(Symbol(), TFBar, shb);
      pc = iClose(Symbol(), TFBar, shb);
      
      ObjectSet("Open of "+TFBar+" Minut Bar # "+shb, OBJPROP_TIME1, to);  //время открытия
      ObjectSet("Open of "+TFBar+" Minut Bar # "+shb, OBJPROP_PRICE1, po); //цена открытия
      ObjectSet("Open of "+TFBar+" Minut Bar # "+shb, OBJPROP_TIME2, tc);  //время закрытия
      ObjectSet("Open of "+TFBar+" Minut Bar # "+shb, OBJPROP_PRICE2, po); //цена закрытия
      ObjectSet("Open of "+TFBar+" Minut Bar # "+shb, OBJPROP_WIDTH, 1);
      ObjectSet("Open of "+TFBar+" Minut Bar # "+shb, OBJPROP_RAY, False);
      shb++;
      }       
      
  
  return(0);
}
//+------------------------------------------------------------------+


















void init() 
   {
   int i;
   for (i=0; i<NumberOfBar; i++) 
      {
      ObjectDelete("Open of "+TFBar+" Minut Bar # "+i);
      }
   for (i=0; i<NumberOfBar; i++) 
      {
      ObjectCreate("Open of "+TFBar+" Minut Bar # "+i, OBJ_TREND, 0, 0,0, 0,0);
      }
   Comment("");
   }

//+------------------------------------------------------------------+
void deinit() 
   {
   for (int i=0; i<NumberOfBar; i++) 
      {
      ObjectDelete("Open of "+TFBar+" Minut Bar # "+i);
      }
   Comment("");
   }

