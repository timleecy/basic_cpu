//ROM module used to store program instructions
//Outputs 16 bits of data when RAM provides an address
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

module rom (input boot, input[`ADDR_SIZE-1:0] addr, inout[`WORD_SIZE-1:0] data);
  
  reg[`WORD_SIZE-1:0] rom_data;

  always@(addr) begin
	  case(addr)
		  0: rom_data = {`LOADA,3'h1,8'h5};
		  2: rom_data = {`LOADB,3'h2,8'h12};
		  4: rom_data = {`STO,3'h0,8'hFF};
		  default: rom_data = 'b0; 
	  endcase
  end

  assign data = boot? rom_data:'bz;
endmodule

  
