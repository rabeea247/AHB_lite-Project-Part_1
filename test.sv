//A program block that creates the environment and initiate the stimulus
`include "environment.sv"
program test(dut_if i_intf);
  
  //declare environment handle
  environment env;
  
  initial begin
    //create environment
    env = new(i_intf); 
      
    //setting the repeat count of generator as 4, means to generate 4 packets
    env.gen.repeat_count = 4;
    
    //initiate the stimulus by calling run of env
    env.run();
  end

endprogram
