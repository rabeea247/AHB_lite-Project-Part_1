//A container class that contains Mailbox, Generator, Driver, Monitor and Scoreboard
//Connects all the components of the verification environment

`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
class environment;
  
  //generator and driver instance
  generator 	gen;
  driver    	driv;
  monitor   	mon;
  scoreboard	scb;
  
  //mailbox handle's
  mailbox gen2driv;
  mailbox mon2scb;
  
  //virtual interface
  virtual dut_if vif;
  
  //constructor
  function new(virtual dut_if vif);
    //get the interface from test
    this.vif = vif;
    
    //creating the mailbox (Same handle will be shared across generator and driver)
    gen2driv = new();
    mon2scb  = new();
    
    //creating generator and driver
    gen  = new(gen2driv);
    driv = new(vif,gen2driv);
    mon  = new(vif,mon2scb);
    scb  = new(mon2scb);
  endfunction
  
  
  task pre_test();
    driv.reset();
  endtask
  
  task test();
    fork 
      gen.main();
      driv.main();
      mon.main();
      scb.main();
    join_any
  endtask
  
  task post_test();
    
    wait(gen.packet_sent.triggered);
    wait(gen.repeat_count == driv.no_transactions);
    wait(gen.repeat_count == scb.no_transactions);
    
  endtask  
  
  //run task
  task run;
    pre_test();
    test();
    post_test();
    $finish;
  endtask
  
endclass

