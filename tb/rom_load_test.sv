//Test loading ROM data into RAM
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

module rom_load_test;

  reg clk;
  reg rst = 0;
  reg wr_en;
  reg boot = 0;
  reg[`ADDR_SIZE-1:0] addr;
  wire[`WORD_SIZE-1:0] data;

  ram RAM(.clk(clk), .rst(rst), .wr_en(wr_en), .addr(addr), .data(data));
  rom ROM(.boot(boot), .addr(addr), .data(data));

  initial begin
	  clk = 0;
	  forever #1 clk = ~clk;
  end

  initial begin

	  //Loading ROM data into RAM
	  wr_en = 1;

	  for(int i=0;i<(2**`ADDR_SIZE)-1;i=i+2) begin
		  addr = i;
		  #2
		  $display("ROM is writing data (%0d,%0d) into RAM location (%0d,%0d)", data[15:8], data[7:0], addr+1, addr);
	  end

	  //Read loaded data
	  #2 wr_en = 0;
	  for(int j=0;j<20;j=j+2) begin
		  addr = j;
		  #2
		  $display("Data in addr %0d is %0d", addr, data[7:0]);
		  $display("Data in addr %0d is %0d", addr+1, data[15:8]);
	  end
  end
endmodule

