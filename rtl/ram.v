//RAM module with sequential write and combo read
//byte-addressable memory for 16-bit word size
//timleecy16@gmail.com

`include "../macros/top_macro.vh"
`define SYNTH

module ram (input clk, wr_en, input[`ADDR_SIZE-1:0] addr, inout[`WORD_SIZE-1:0] data);
  
  reg[7:0] ram_data[(2**`ADDR_SIZE)-1:0];

  `ifdef SYNTH
  always@(posedge clk) begin
    if(wr_en)
		{ram_data[addr+1],ram_data[addr]} <= data;
  end
  `endif

  //load data into RAM for simulation only
  `ifdef SIM
	  always@(*) begin
	  	ram_data[0] = 'b0;
	  	ram_data[1] = 'd5;
	  	ram_data[2] = 'd3;
	  end
  `endif
	  
  assign data = wr_en? 'bz:{ram_data[addr+1],ram_data[addr]};
endmodule


