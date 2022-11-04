#include <my_headers.mqh>
#include <stdlib.mqh>
//#include <inputs_minimum.mqh>
#include <inputs_maximum.mqh>
#include <variables_all.mqh>
bool itisme_sachin=True;
#include <skraj_all_functions.mqh>
    void init()
        {
            get_params_from_file();
        }
    void OnTick()
        {

                
        }
    void deinit()
        {
            if(save_state_infile)
            {
               string dataline1="opening_balance="+opening_balance;
               skfilewrite(skfile_name_params,dataline1);
               skFileDisplay(skfile_name_params);
            }
            
        }
