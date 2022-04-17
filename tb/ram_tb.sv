//RAM testbench
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

module ram_tb;
  
  reg clk;
  reg wr_en;
  reg[`ADDR_SIZE-1:0] addr_bus;
  wire[`WORD_SIZE-1:0] data_bus;
 
  //workaround to set values to inout port
  reg[`WORD_SIZE-1:0] data_bus_driver;
  assign data_bus = wr_en? data_bus_driver:'bz;

  //add test data here as array
  int test_data[0:15] = {1,2,3,4,5,6,7,8,10,20,30,40,50,60,70,80};

  initial begin
    clk = 0;
    forever #1 clk=~clk;
  end
  
  ram RAM1(.clk(clk), .wr_en(wr_en), .addr(addr_bus), .data(data_bus));
  
  initial begin

	 //write
	 wr_en = 1;
	 for(int i=0;i<16;i=i+2) begin
		 data_bus_driver[15:8] = test_data[i+1];
		 data_bus_driver[7:0] = test_data[i];
		 addr_bus = i;
		 #2
		 $display("Writing (%0d,%0d) into memory location %0d and %0d", data_bus[15:8],data_bus[7:0], addr_bus+1, addr_bus);
	 end

	 //read
	 #2 wr_en = 0; 
	 for(int j=0;j<20;j=j+2) begin
		 addr_bus = j;
		 #2 
		 $display("Data in addr %0d is %0d", addr_bus, data_bus[7:0]);
		 $display("Data in addr %0d is %0d", addr_bus+1, data_bus[15:8]);
	 end

  end
  
endmodule
