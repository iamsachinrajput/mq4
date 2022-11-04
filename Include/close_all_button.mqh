

int size_of_string(string str1)
  {
      return(16*StringLen(str1));
  }
 
 string close_all_button(string action)     
      {
         string skbutton_name="CLOSEALL";
         int givenx=1200;
         int giveny=2;
         string returnvalue="none";
         if(action == "create" )
          {
            ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,True);
            ObjectCreate(0,skbutton_name,OBJ_BUTTON,0,0,0);
            ObjectSetInteger(0,skbutton_name,OBJPROP_SELECTABLE,True);
            ObjectSetInteger(0,skbutton_name,OBJPROP_XDISTANCE,givenx);
            ObjectSetInteger(0,skbutton_name,OBJPROP_YDISTANCE,giveny);
            ObjectSetInteger(0,skbutton_name,OBJPROP_XSIZE,size_of_string(skbutton_name));
            ObjectSetText(skbutton_name,skbutton_name);
          }
         else if(action == "delete" )
            ObjectDelete(0,skbutton_name);
         else if(action=="red")
              ObjectSetInteger(0,skbutton_name,OBJPROP_BGCOLOR,clrRed);
         else if(action=="blue")
              ObjectSetInteger(0,skbutton_name,OBJPROP_BGCOLOR,clrBlue);
         else if(action=="pressed")
            {
              #ifdef MagicNumber
                 printf("defined magicnumber="+MagicNumber);
                 close_all_function(MagicNumber);
              #endif 
              
            }
        return(returnvalue);  

      }
      
    void close_all_button_mouse_events( long x , long y ,string nameid ,int id)
        {
         string skbutton_name="CLOSEALL";
          int skbutton_left=ObjectGetInteger(0,skbutton_name,OBJPROP_XDISTANCE);
          int skbutton_right=skbutton_left+ObjectGetInteger(0,skbutton_name,OBJPROP_XSIZE);
          int skbutton_top=ObjectGetInteger(0,skbutton_name,OBJPROP_YDISTANCE);
          int skbutton_bottom=skbutton_top+ObjectGetInteger(0,skbutton_name,OBJPROP_YSIZE);

            // by default on mouse check it is no hovered 
            close_all_button("blue");
            if(x>skbutton_left && x<skbutton_right && y>skbutton_top && y<skbutton_bottom ) 
                {
                    close_all_button("red");
                    if(id==CHARTEVENT_OBJECT_CLICK && nameid==skbutton_name ) 
                       close_all_function("pressed");
                } 
        }
        
        
 void OnChartEvent( const int id,const long &lparam,const double &dparam,const string &sparam )
     {
          close_all_button_mouse_events(lparam,dparam,sparam,id);
     }

void close_all_function(int MagicNumber)
{
   printf("will close all orders for Magicnumber="+MagicNumber+ " symbol="+Symbol());
   for (int i = (OrdersTotal() - 1); i >= 0; i--) 
   {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE) 
         { 
            //if ( OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber ) 
            {
               RefreshRates();
               if( !OrderClose(OrderTicket(), OrderLots(), Bid,0,0 ))
                  if(!OrderClose(OrderTicket(), OrderLots(), Ask,0,0 ))
               	   printf("There was an error closing buy/sell order#"+(string)OrderTicket()+". Error is:" + (string)GetLastError() );
               else 
               	   printf("Closed ("+(string)OrderType()+") order#"+(string)OrderTicket() +" PR="+(string)AccountProfit() + "orders#"+(string)OrdersTotal() );
                           	   
            }
         }
    }
}