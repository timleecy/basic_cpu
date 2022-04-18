//RAM module with sequential write and combo read
//byte-addressable memory for 16-bit word size
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

module ram (input clk, wr_en, input[`ADDR_SIZE-1:0] addr, inout[`WORD_SIZE-1:0] data);
  
  reg[7:0] ram_data[(2**`ADDR_SIZE)-1:0];

  always@(posedge clk) begin
    if(wr_en)
		{ram_data[addr+1],ram_data[addr]} <= data;
  end

  assign data = wr_en? 'bz:{ram_data[addr+1],ram_data[addr]};
endmodule


