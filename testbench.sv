`include "interface.sv"
`include "test.sv"
module testbench_top;
  
  //declare clock and reset signal
   bit hclk;
  bit hresetn;

  //clock generation
  
   always #5 hclk = ~hclk;

  //reset generation
   initial begin
    hresetn = 0;
    #5 hresetn =1;
     
  end

  //interface instance, inorder to connect DUT and testcase
  dut_if i_intf(hclk,hresetn,1);
  
  
  //testcase instance, interface handle is passed to test as an argument
  test t1(i_intf);
  
  
  //DUT instance, interface signals are connected to the DUT ports
  
  amba_ahb_slave DUT(
    .hclk(i_intf.hclk),
    .hresetn(i_intf.hresetn),
    .hsel(i_intf.hsel),
    .haddr(i_intf.haddr),
    .htrans(i_intf.htrans),
    .hwrite(i_intf.hwrite),
    .hsize(i_intf.hsize),
    .hburst(i_intf.hburst),
    .hprot(i_intf.hprot),
    .hwdata(i_intf.hwdata),
    .hrdata(i_intf.hrdata),
    .hready(i_intf.hready),
    .hresp(i_intf.hresp),
    .error(i_intf.error)
   );
  
  //enabling the wave dump
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
  
  
  
endmodule