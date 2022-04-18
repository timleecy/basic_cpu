//ROM module used to store program instructions
//Outputs 16 bits of data when RAM provides an address
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

module rom (input[`ADDR_SIZE-1:0] addr, output reg[`WORD_SIZE-1:0] data);

  always@(*) begin
	  case({addr+1,addr})
		  {8'd1,8'd0}: data = {8'd12,8'd34};
		  {8'd3,8'd2}: data = {8'd5,8'd76};
		  default: data = 'bx;
	  endcase
  end

endmodule

  
