//Basic testbench to test loading program into RAM and running ALU
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

module ram_cpu_basic_test;

  parameter WORD_SIZE=8;
  parameter MEM_WIDTH=8;

  reg clk;
  reg rst;
  wire wr_en;
  wire[WORD_SIZE-1:0] addr_bus;
  wire[MEM_WIDTH-1:0] data_bus;

  initial begin
    clk = 0;
    forever #1 clk=~clk;
  end

  initial begin
    rst = 1;
	#5 rst = 0;
  end

  cpu #(MEM_WIDTH, WORD_SIZE) C(.clk(clk), .rst(rst), .data_bus(data_bus), .addr_bus(addr_bus), .wr_en(wr_en));

  ram #(MEM_WIDTH, WORD_SIZE) R(.clk(clk), .wr_en(wr_en), .wr_addr(addr_bus), .rd_addr(addr_bus), .data_in(data_bus), .data_out(data_bus));

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


