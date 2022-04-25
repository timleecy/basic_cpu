//ROM module used to store program instructions
//Outputs 16 bits of data when RAM provides an address
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

module rom (input boot, input[`ADDR_SIZE-1:0] addr, inout[`WORD_SIZE-1:0] data);
  
  reg[`WORD_SIZE-1:0] rom_data;

  always@(addr) begin
	  case(addr)
		  0: rom_data = {`LOAD,3'h0,8'h5}; //load constant 5 to reg a
		  2: rom_data = {`LOAD,3'h5,8'h12}; //load contents of memory location 0x12 to reg b
		  4: rom_data = {`STO,3'h0,8'hFE}; //store contents of reg a to memory location 0xFE
		  6: rom_data = {`MOV,3'h0,8'h1}; //move contents of reg a to reg b
		  default: rom_data = 'b0; 
	  endcase
  end

  assign data = boot? rom_data:'bz;
endmodule

  
