//Generates randomized transaction packets and put them in the mailbox to send the packets to driver 

class generator;
  
  int  repeat_count;
  
  //declare transaction class
    rand transaction trans;
  //create mailbox handle
  mailbox gen2driv;
  //declare an event
  event packet_sent;
 
  //constructor
  function new(mailbox gen2driv);
    //getting the mailbox handle from env, in order to share the transaction packet between the generator and driver, the same mailbox is shared between both.
    this.gen2driv = gen2driv;
  endfunction
  
  //main methods
  

  task main();
    repeat(repeat_count) begin
    trans = new();
    if( !trans.randomize() ) $fatal("Gen:: trans randomization failed");
      trans.display("[ Generator ]");
      gen2driv.put(trans);
    end
    -> packet_sent; //triggering indicates the end of generation
  endtask
  
endclass
