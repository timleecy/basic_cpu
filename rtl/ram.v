//RAM module with parameterized width and word size
//Depth of RAM will depend on word size which is defined in top_macro.vh
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

module ram #(parameter WIDTH=32, WORD_SIZE) (input clk, wr_en, input[WORD_SIZE-1:0] wr_addr, rd_addr, input[WIDTH-1:0] data_in, output[WIDTH-1:0] data_out);
  
  reg[(2**WORD_SIZE)-1:0] ram_data[WIDTH-1:0];

  always@(posedge clk) begin
    if(wr_en)
		ram_data[wr_addr] <= data_in;
  end

  //read implemented as combo logic.
  //Logic to avoid read & write from same location at the same time should be
  //implemented in CPU or memory controller
  assign data_out = ram_data[rd_addr];
endmodule


