//RAM testbench
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

module ram_tb;
  
  parameter MEM_WIDTH;
  parameter WORD_SIZE;

  reg clk;
  reg wr_en;
  reg[WORD_SIZE-1:0] wr_addr;
  reg[WORD_SIZE-1:0] rd_addr;
  reg[MEM_WIDTH-1:0] data_in;
  wire[MEM_WIDTH-1:0] data_out;
  
  //add test data here as array
  int test_data[7:0] = {11,22,33,44,55,66,77,88};

  initial begin
    clk = 0;
    forever #1 clk=~clk;
  end
  
  ram #(MEM_WIDTH, WORD_SIZE) R(.clk(clk), .wr_en(wr_en), .wr_addr(wr_addr), .rd_addr(rd_addr), .data_in(data_in), .data_out(data_out));
  
  //write
  initial begin
	 wr_en = 1;

	 for(int i=0;i<8;i++) begin
		 #2 data_in = test_data[i]; wr_addr = i;
	 end
  end
  
  //read
  initial begin
	for(int j=0;j<2**WORD_SIZE;j++) begin
		#2 rd_addr = j;
		#2 $display("Data in addr %d is %d", rd_addr, data_out);
	end
end
  
  
endmodule
