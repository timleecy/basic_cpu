//ROM module used to store program instructions
//Outputs 16 bits of data when RAM provides an address
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

module rom (input[`ADDR_SIZE-1:0] addr, output reg[`WORD_SIZE-1:0] data);

  always@(addr) begin
	  case(addr)
		  0: data = {8'd0,8'd0};
		  2: data = {8'd0,8'd5};
		  4: data = {8'd0,8'd3};
		  default: data = 'bx;
	  endcase
  end
endmodule

  
