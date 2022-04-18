//ROM module used to store program instructions
//Outputs 16 bits of data when RAM provides an address
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

module rom (input boot_done, input[`ADDR_SIZE-1:0] addr, inout[`WORD_SIZE-1:0] data);
  
  reg[`WORD_SIZE-1:0] rom_data;

  always@(addr) begin
	  case(addr)
		  0: rom_data = {8'd0,8'd0};
		  2: rom_data = {8'd0,8'd5};
		  4: rom_data = {8'd0,8'd3};
		  default: rom_data = 'bx; 
	  endcase
  end

  assign data = boot_done? 'bz:rom_data;
endmodule

  
