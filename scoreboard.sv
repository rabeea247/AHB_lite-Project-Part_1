//Gets the packet from monitor, generates the expected result and compares with the actual result received from the Monitor
//`include "amba_ahb_defines.v"

class scoreboard;
   
   //creating mailbox handle
  mailbox mon2scb;
  
  //local memory

  bit [7:0]mem[0:1023];
  
   
  
  //used to count the number of transactions
  int no_transactions;
  
  //constructor
  function new(mailbox mon2scb);
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
    foreach(mem[i]) mem[i] = 32'hFF;
    
  endfunction
  
  //Compares the Actual result with the expected result
  task main;
    transaction trans;
    forever begin
      #50;
      mon2scb.get(trans);
    
       if(trans.hwrite==0) 
      begin
      	if(mem[trans.haddr] != trans.hrdata)
       		 $error("[SCB-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.haddr,mem[trans.haddr],trans.hrdata);
      	else
          	$display("[SCB-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.haddr,mem[trans.haddr],trans.hrdata);
      end
      else if(trans.hwrite==1)
        mem[trans.haddr] = trans.hwdata;
  
        
        no_transactions++;
      trans.display("[ Scoreboard ]");
    end
   
           
  endtask
endclass


