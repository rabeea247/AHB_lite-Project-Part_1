//Samples the interface signals, captures into transaction packet and sends the packet to scoreboard.

`define MON_IF vif.monitor_cb

class monitor;

    //creating virtual interface handle
  virtual dut_if.mon vif;
  
  //creating mailbox handle
  mailbox mon2scb;
  
  //constructor
  function new(virtual dut_if.mon vif,mailbox mon2scb);
    //getting the interface
    this.vif = vif;
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
  endfunction
  
  //Samples the interface signal and send the sample packet to scoreboard
  task main;
    forever begin
      transaction trans;
      trans = new();
      @(posedge vif.hclk);
      //wait(vif.valid);
      trans.haddr   = `MON_IF.haddr;
      trans.htrans  = `MON_IF.htrans;
      trans.hwrite  = `MON_IF.hwrite;
      trans.hsize   = `MON_IF.hsize;
      trans.hburst  = `MON_IF.hburst;
      trans.hprot   = `MON_IF.hprot;
      trans.hwdata  = `MON_IF.hwdata;
      trans.error   = `MON_IF.error;
      
      @(posedge vif.hclk);
      
      trans.hrdata   = `MON_IF.hrdata;
      trans.hready   = `MON_IF.hready;
      trans.hresp    = `MON_IF.hresp;
      
      @(posedge vif.hclk);
      mon2scb.put(trans);
     trans.display("[ Monitor ]");
    
    end
  endtask
  
  
endclass
