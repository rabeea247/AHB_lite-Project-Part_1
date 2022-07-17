//Fields required to generate the stimulus are declared in the transaction class
`include "amba_ahb_defines.v"

class transaction;

  //declare transaction items
  rand bit [`AW-1:0] haddr;    // Address bus
  rand bit [1:0] htrans;   // Transfer type
  bit  hwrite;   // Transfer direction
  rand bit [2:0] hsize;    // Transfer size
  rand bit [2:0] hburst;   // Burst type
  rand bit [3:0] hprot;    // Protection control
  rand bit [`DW-1:0] hwdata;   // Write data bus
  // AMBA AHB slave signals
  bit [`DW-1:0] hrdata;   // Read data bus
  bit hready;   // Transfer done
  bit[`RW-1:0] hresp;    // Transfer response
  // slave control signal
  rand bit error;    // request an error response
  
  
  
  //Add Constraints
  
  //No burst
  constraint no_burst { hburst==`H_SINGLE; }
  
  //Transfer types with weightages
  constraint transf_t { htrans dist {`H_IDLE:=1,`H_BUSY:=1,`H_NONSEQ:=8} ;}
  
  //Transfer size of word only
  constraint transf_s { hsize==`H_SIZE_32;}
  
  //Protection control for data access only
  constraint pr_ctrl {{hprot[0]==1};}
  
  //Address aligned with respect to size

  constraint w_aligned_1 {{haddr[1]==0};}

  constraint w_aligned_2 {{haddr[0]==0};}
  
  constraint err {error inside {0};}
  
  
  //Add print transaction method
 function void display(string name);
    $display("-------------------------");
    $display("- %s ",name);
    $display("-------------------------");
   $display("- haddr = %0h, hwdata = %0h,htrans=%0h,hwrite=%0h,hsize=%0h,hburst=%0h,hprot=%0h",haddr,hwdata,htrans,hwrite,hsize,hburst,hprot);
    $display("- hrdata = %0h,hready=%0h,hresp=%0h",hrdata,hready,hresp);
    $display("-------------------------");
  endfunction
  
  
  
  
  
endclass
