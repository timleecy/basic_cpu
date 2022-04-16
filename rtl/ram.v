//RAM module with parameterized width and word size
//timleecy16@gmail.com

`include "../macros/top_macro.vh"
`define SIM

module ram #(parameter MEM_WIDTH, WORD_SIZE) (input clk, wr_en, input[WORD_SIZE-1:0] wr_addr, rd_addr, input[MEM_WIDTH-1:0] data_in, output[MEM_WIDTH-1:0] data_out);
  
  wire[(2**WORD_SIZE)-1:0] ram_data[MEM_WIDTH-1:0];

  `ifdef SYNTH
  always@(posedge clk) begin
    if(wr_en)
		ram_data[wr_addr] <= data_in;
  end
  `endif

  //load data into RAM for simulation only
  `ifdef SIM
	  assign ram_data[0] = 'b0;
	  assign ram_data[1] = 'd5;
	  assign ram_data[2] = 'd3;
  `endif
	  

  //read implemented as combo logic.
  //Logic to avoid read & write from same location at the same time should be
  //implemented in CPU or memory controller
  assign data_out = ram_data[rd_addr];
endmodule


