//Basic testbench to test loading program into RAM and running ALU
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

module soc_basic_test;

  reg clk;
  reg rst;
  wire wr_en;
  wire boot_done;
  wire[`ADDR_SIZE-1:0] addr_bus;
  wire[`WORD_SIZE-1:0] data_bus;

  cpu_test CPU(.clk(clk), .rst(rst), .data_bus(data_bus), .addr_bus(addr_bus), .wr_en(wr_en), .boot_done_flag(boot_done));

  ram RAM(.clk(clk), .rst(rst), .wr_en(wr_en), .addr(addr_bus), .data(data_bus));

  rom ROM(.boot_done(boot_done), .addr(addr_bus), .data(data_bus));

  initial begin
    clk = 0;
    forever #1 clk=~clk;
  end

  initial begin
    rst = 1;
    #5 rst = 0;
	#50 rst = 1;
	#5 rst = 0;
  end

  always@(clk) begin
	  $display("%d, %d, %b, %d", addr_bus, data_bus, wr_en, $time);
  end

 //test RAM loading
 /*initial begin
	 #1 addr_bus=0; 
	 #1 $display(addr_bus,,data_bus);
	 #1 addr_bus=1; 
	 #1 $display(addr_bus,,data_bus);
	 #1 addr_bus=2; 
	 #1 $display(addr_bus,,data_bus);
 end*/

endmodule


