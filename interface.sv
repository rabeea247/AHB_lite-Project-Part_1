//Interface groups the design signals, specifies the direction (Modport) and Synchronize the signals(Clocking Block)

`include "amba_ahb_defines.v"

interface dut_if(input logic hclk, hresetn,hsel);

    // Add design signals here
  
  // AMBA AHB master signals
  logic [`AW-1:0] haddr;    // Address bus
  logic    [1:0] htrans;   // Transfer type
  logic          hwrite;   // Transfer direction
  logic    [2:0] hsize;   // Transfer size
  logic    [2:0] hburst;   // Burst type
  logic    [3:0] hprot;    // Protection control
  logic [`DW-1:0] hwdata;   // Write data bus
  // AMBA AHB slave signals
  logic [`DW-1:0] hrdata;   // Read data bus
  logic           hready;   // Transfer done
  logic  [`RW-1:0] hresp;    // Transfer response
  // slave control signal
  logic  error;     // request an error response
  
    
  
    //Master Clocking block - used for Drivers
 
  clocking driver_cb @(posedge hclk);
    default input #1 output #1;
    input hrdata;
    input hready;
    input hresp;
    output haddr;
    output htrans;
    output hwrite;
    output hsize;
    output hburst;
    output hprot;
    output hwdata;
    output error;
  endclocking
  
  //Monitor Clocking block - For sampling by monitor components
  
  clocking monitor_cb @(posedge hclk);
    default input #1 output #1;
    input haddr;
    input htrans;
    input hwrite;
    input hsize;
    input hburst;
    input hprot;
    input hwdata;
    input hrdata;
    input hready;
    input hresp;
    input error;
  endclocking
  
 
  //Add modports here
  
   modport mon(input hclk,hresetn,hsel,clocking monitor_cb);
   modport drv(input hclk,hresetn,hsel,clocking driver_cb);
  
endinterface
