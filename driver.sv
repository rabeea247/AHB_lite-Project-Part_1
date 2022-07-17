//Gets the packet from generator and drive the transaction packet items into interface (interface is connected to DUT, so the items driven into interface signal will get driven in to DUT) 

`define DRIV_IF vif.driver_cb

class driver;
//used to count the number of transactions
  int no_transactions;
  
  //creating virtual interface handle
  virtual dut_if.drv vif;
  
  //creating mailbox handle
  mailbox gen2driv;
  
  //constructor
  function new(virtual dut_if.drv vif,mailbox gen2driv);
    //getting the interface
    this.vif = vif;
    //getting the mailbox handles from  environment 
    this.gen2driv = gen2driv;
  endfunction
  
  //Reset task, Reset the Interface signals to default/initial values
  task reset;
   
   wait(!vif.hresetn);
    
    $display("[ DRIVER ] ----- Reset Started -----");
    `DRIV_IF.haddr <= 0;
    `DRIV_IF.htrans <= 0;
    `DRIV_IF.hwrite <= 1;
    `DRIV_IF.hsize <= 0;
    `DRIV_IF.hburst <= 0;
    `DRIV_IF.hprot <= 0;
    `DRIV_IF.hwdata <= 0;
   
   
    wait(vif.hresetn);
    $display("[ DRIVER ] ----- Reset Ended   -----");
     `DRIV_IF.hwrite <= 0;
  endtask
  
  //drivers the transaction items to interface signals
  task main;
    forever begin
      transaction trans;
      gen2driv.get(trans);
      @(posedge vif.hclk);
      `DRIV_IF.haddr <= trans.haddr;
      `DRIV_IF.htrans <= trans.htrans;
      `DRIV_IF.hsize <= trans.hsize;
      `DRIV_IF.hburst <= trans.hburst;
      `DRIV_IF.hprot <= trans.hprot;
      `DRIV_IF.hwdata <= trans.hwdata;
      `DRIV_IF.error <= trans.error;
      `DRIV_IF.hwrite <= 1;
      
      @(posedge vif.hclk);
      trans.hrdata   = `DRIV_IF.hrdata;
      trans.hready   = `DRIV_IF.hready;
      trans.hresp   = `DRIV_IF.hresp;
      `DRIV_IF.hwrite <= 0;
      
     
   
      @(posedge vif.hclk);
      trans.display("[ Driver ]");
      no_transactions++;
    end
  endtask
  
        
endclass
