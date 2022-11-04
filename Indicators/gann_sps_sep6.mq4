
// +------------------------------------------------------------------------------------------+ //
// |    .-._______                           XARD777                            _______.-.    | //
// |---( )_)______)                 Knowledge of the ancients                  (______(_( )---| //
// |  (    ()___)                              \¦/                               (___()    )  | //
// |       ()__)                              (o o)                               (__()       | //
// |--(___()_)__________________________oOOo___(_)___oOOo___________________________(_()___)--| //
// |______|______|______|______|______|______|______|______|______|______|______|______|______| //
// |___|______|_Cam__|______|______|______|______|______|______|______|Ismael|______|______|__| //
// |______|______|______|______|______|______|__Big_Joe____|______|______|______|______|______| //
// |___|______|______|______|_Mundu|______|______|______|______|______|______|______|______|__| //
// |______|__cja_|______|______|______|__Hendrik____|______|______|______|______|______|______| //
// |___|______|______|______|______|______|______|______|Tzuman|______|______|______|______|__| //
// |______|______|______|Hercs_|______|______|______|______|______|______|Joy22_|______|______| //
// |___|______|______|______|______|______|___Poruchik__|______|______|______|______|______|__| //
// |______|___Pava_the_Clown___|______|______|______|______|__Leledc_____|______|______|_Xard_| //
// |                                                                                     2011 | //
// |                 File:     !XPS v8 GANN SSL.mq4                                           | //
// | Programming language:     MQL4                                                           | //
// | Development platform:     MetaTrader 4                                                   | //
// |          End product:     THIS SOFTWARE IS FOR FOREX TRADERS                             | //
// |                                                                                          | //
// |                                                                                          | //
// |     Online Resources:     http://search4metatrader.com/index.php                         | //
// |                           www.2bgoogle.com/forex4.html                                   | //
// |                           www.forex-tsd.com                                              | //
// |                           www.forexstrategiesresources.com                               | //
// |                           www.traderszone.com                                            | //
// |                           http://fxcoder.ru/indicators                                   | //
// |                           www.worldwide-invest.org/                                      | //
// |                           http://indo-investasi.com                                      | //
// |                                                                                          | //
// |                                                           [Xard777 Proprietory Software] | //
// +------------------------------------------------------------------------------------------+ //

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1  Lime
#property indicator_width1  2
#property indicator_color2  Red
#property indicator_width2  2
#property indicator_color3  Red
#property indicator_width3  2




extern string TimeFrame       = "Current time frame";
extern int    Lb              = 13;
extern int    MaType          = MODE_LWMA;

extern bool   MultiColor      = true;
extern string note            = "turn on Alert = true; turn off = false";
extern bool   alertsOn        = true;
extern bool   alertsOnCurrent = true;
extern bool   alertsMessage   = true;
extern bool   alertsSound     = true;
extern bool   alertsEmail     = false;
extern string soundfile       = "alert.wav";




double ssl[];
double sslUa[];
double sslUb[];
double Hlv[];




string indicatorFileName;
int    timeFrame;
bool   returnBars;
bool   calculateValue;




int init()
{
   IndicatorBuffers(4);
   SetIndexBuffer(0,ssl); SetIndexDrawBegin(0,Lb+1);
   SetIndexBuffer(1,sslUa);
   SetIndexBuffer(2,sslUb);
   SetIndexBuffer(3,Hlv);



   
     indicatorFileName = WindowExpertName();
     calculateValue    = (TimeFrame=="calculateValue"); if (calculateValue) return(0);
     returnBars        = (TimeFrame=="returnBars");     if (returnBars)     return(0);
     timeFrame         = stringToTimeFrame(TimeFrame);
   



   
   IndicatorShortName(timeFrameToString(timeFrame)+  " SSL fast");
   
   return(0);
}




int deinit() {  return(0); }




int start()
{
    int counted_bars=IndicatorCounted();
    int i,limit;

    if(counted_bars<0) return(-1);
    if(counted_bars>0) counted_bars--;
            limit = MathMin(Bars-counted_bars,Bars-1);
            if (returnBars) { ssl[0] = limit+1; return(0); }
            


               
    if (calculateValue || timeFrame == Period())
    {
    


           
    if (MultiColor && !calculateValue && Hlv[limit]==-1) CleanPoint(limit,sslUa,sslUb);
   


      
    for(i=limit; i>=0; i--)
    {
          Hlv[i] = Hlv[i+1];
             if(Close[i] > iMA(Symbol(),0,Lb,0,MaType,PRICE_HIGH,i+1))  Hlv[i] =  1;
             if(Close[i] < iMA(Symbol(),0,Lb,0,MaType,PRICE_LOW, i+1))  Hlv[i] = -1;
      
             if(Hlv[i] == -1)
                   ssl[i] = iMA(Symbol(),0,Lb,0,MaType,PRICE_HIGH,i+1);
             else  ssl[i] = iMA(Symbol(),0,Lb,0,MaType,PRICE_LOW, i+1);
         
        if (MultiColor && !calculateValue && Hlv[i] == -1) PlotPoint(i,sslUa,sslUb,ssl);
             

      
        }
      
        manageAlerts();
        return(0);
        }
     

   
        limit = MathMax(limit,MathMin(Bars,iCustom(NULL,timeFrame,indicatorFileName,"returnBars",0,0)*timeFrame/Period()));
        if (MultiColor && Hlv[limit]==-1) CleanPoint(limit,sslUa,sslUb);
      
        for(i=limit; i>=0; i--)
        {  
   
          int y = iBarShift(NULL,timeFrame,Time[i]);
              ssl[i]   = iCustom(NULL,timeFrame,indicatorFileName,"calculateValue",Lb,MaType,0,y);
              sslUa[i] = EMPTY_VALUE;
              sslUb[i] = EMPTY_VALUE;
              Hlv[i]   = iCustom(NULL,timeFrame,indicatorFileName,"calculateValue",Lb,MaType,3,y);
      

          
              }
          
              if (MultiColor) for (i=limit;i>=0;i--) if (Hlv[i]==-1) PlotPoint(i,sslUa,sslUb,ssl);
      
           manageAlerts();
           return(0);
    }




void manageAlerts()
{
   if (!calculateValue && alertsOn)
   {
      if (alertsOnCurrent)
           int whichBar = 0;
      else     whichBar = 1; whichBar = iBarShift(NULL,0,iTime(NULL,timeFrame,whichBar));
      if (Hlv[whichBar] != Hlv[whichBar+1])
      {
         if (Hlv[whichBar] ==  1) doAlert(whichBar,"up");
         if (Hlv[whichBar] == -1) doAlert(whichBar,"down");
      }
   }
}




void doAlert(int forBar, string doWhat)
{
   static string   previousAlert="nothing";
   static datetime previousTime;
   string message;
   
   if (previousAlert != doWhat || previousTime != Time[forBar]) {
       previousAlert  = doWhat;
       previousTime   = Time[forBar];




       message =  StringConcatenate(Symbol()," ",timeFrameToString(timeFrame)," at ",TimeToStr(TimeLocal(),TIME_SECONDS)," Current GANN SSL has changed direction to ",doWhat);
          if (alertsMessage) Alert(message);
          if (alertsEmail)   SendMail(StringConcatenate(Symbol()," Gannline  "),message);
          if (alertsSound)   PlaySound("alert.wav");
   }
}




void CleanPoint(int i,double& first[],double& second[])
{
   if ((second[i]  != EMPTY_VALUE) && (second[i+1] != EMPTY_VALUE))
        second[i+1] = EMPTY_VALUE;
   else
      if ((first[i] != EMPTY_VALUE) && (first[i+1] != EMPTY_VALUE) && (first[i+2] == EMPTY_VALUE))
          first[i+1] = EMPTY_VALUE;
}




void PlotPoint(int i,double& first[],double& second[],double& from[])
{
   if (first[i+1] == EMPTY_VALUE)
      {
      if (first[i+2] == EMPTY_VALUE) {
          first[i]    = from[i];
          first[i+1]  = from[i+1];
          second[i]   = EMPTY_VALUE;
         }
      else {
          second[i]   = from[i];
          second[i+1] = from[i+1];
          first[i]    = EMPTY_VALUE;
         }
      }
   else
      {
         first[i]   = from[i];
         second[i]  = EMPTY_VALUE;
      }
}




string sTfTable[] = {"M1","M5","M15","M30","H1","H4","D1","W1","MN"};
int    iTfTable[] = {1,5,15,30,60,240,1440,10080,43200};



int stringToTimeFrame(string tfs)
{
   tfs = stringUpperCase(tfs);
   for (int i=ArraySize(iTfTable)-1; i>=0; i--)
         if (tfs==sTfTable[i] || tfs==""+iTfTable[i]) return(MathMax(iTfTable[i],Period()));
                                                      return(Period());
}
string timeFrameToString(int tf)
{
   for (int i=ArraySize(iTfTable)-1; i>=0; i--) 
         if (tf==iTfTable[i]) return(sTfTable[i]);
                              return("");
}



string stringUpperCase(string str)
{
   string   s = str;

   for (int length=StringLen(str)-1; length>=0; length--)
   {
      int char = StringGetChar(s, length);
         if((char > 96 && char < 123) || (char > 223 && char < 256))
                     s = StringSetChar(s, length, char - 32);
         else if(char > -33 && char < 0)
                     s = StringSetChar(s, length, char + 224);
   }
   return(s);
}
// ------------------------------------------------------------------------------------------ //
//                                     E N D   P R O G R A M                                  //
// ------------------------------------------------------------------------------------------ //
/*                                                         
                                        ud$$$**BILLION$bc.                          
                                    u@**"        PROJECT$$Nu                       
                                  J                ""#$$$$$$r                     
                                 @                       $$$$b                    
                               .F                        ^*3$$$                   
                              :% 4                         J$$$N                  
                              $  :F                       :$$$$$                  
                             4F  9                       J$$$$$$$                 
                             4$   k             4$$$$bed$$$$$$$$$                 
                             $$r  'F            $$$$$$$$$$$$$$$$$r                
                             $$$   b.           $$$$$$$$$$$$$$$$$N                
                             $$$$$k 3eeed$$b    XARD777."$$$$$$$$$                
              .@$**N.        $$$$$" $$$$$$F'L $$$$$$$$$$$  $$$$$$$                
              :$$L  'L       $$$$$ 4$$$$$$  * $$$$$$$$$$F  $$$$$$F         edNc   
             @$$$$N  ^k      $$$$$  3$$$$*%   $F4$$$$$$$   $$$$$"        d"  z$N  
             $$$$$$   ^k     '$$$"   #$$$F   .$  $$$$$c.u@$$$          J"  @$$$$r 
             $$$$$$$b   *u    ^$L            $$  $$$$$$$$$$$$u@       $$  d$$$$$$ 
              ^$$$$$$.    "NL   "N. z@*     $$$  $$$$$$$$$$$$$P      $P  d$$$$$$$ 
                 ^"*$$$$b   '*L   9$E      4$$$  d$$$$$$$$$$$"     d*   J$$$$$r   
                      ^$$$$u  '$.  $$$L     "#" d$$$$$$".@$$    .@$"  z$$$$*"     
                        ^$$$$. ^$N.3$$$       4u$$$$$$$ 4$$$  u$*" z$$$"          
                          '*$$$$$$$$ *$b      J$$$$$$$b u$$P $"  d$$P             
                             #$$$$$$ 4$ 3*$"$*$ $"$'c@@$$$$ .u@$$$P               
                               "$$$$  ""F~$ $uNr$$$^&J$$$$F $$$$#                 
                                 "$$    "$$$bd$.$W$$$$$$$$F $$"                   
                                   ?k         ?$$$$$$$$$$$F'*                     
                                    9$$bL     z$$$$$$$$$$$F                       
                                     $$$$    $$$$$$$$$$$$$                        
                                      '#$$c  '$$$$$$$$$"                          
                                       .@"#$$$$$$$$$$$$b                          
                                     z*      $$$$$$$$$$$$N.                       
                                   e"      z$$"  #$$$k  '*$$.                     
                                .u*      u@$P"      '#$$c   "$$c                   
                        u@$*"""       d$$"            "$$$u  ^*$$b.               
                      :$F           J$P"                ^$$$c   '"$$$$$$bL        
                     d$$  ..      @$#                      #$$b         '#$       
                     9$$$$$$b   4$$                          ^$$k         '$      
                      "$$6""$b u$$                             '$    d$$$$$P      
                        '$F $$$$$"                              ^b  ^$$$$b$       
                         '$W$$$$"                                'b@$$$$"         
                                                                  ^$$$*/     