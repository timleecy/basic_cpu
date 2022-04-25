//ROM module used to store program instructions
//Outputs 16 bits of data when RAM provides an address
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

function[2:0] LOAD_op (input string register, operand_type);
  begin
	  if(register == "a")
		  LOAD_op[2] = 0;
	  else if(register == "b")
		  LOAD_op[2] = 1;

	  if(operand_type == "constant")
		  LOAD_op[1:0] = 0;
	  else if(operand_type == "memory")
		  LOAD_op[1:0] = 1;
	  else if(operand_type == "pointer")
		  LOAD_op[1:0] = 2;
  end
endfunction

function[2:0] STO_op (input string register);
  begin
	  case(register)
		  "a": STO_op = 0;
		  "b": STO_op = 1;
		  "data_out": STO_op = 2;
		  "inst_reg": STO_op = 3;
		  "addr_reg": STO_op = 4;
		  "gpreg": STO_op = 5;
	  endcase
  end
endfunction

function[7:0] MOV_op (input string reg1, reg2);
  begin
	  case(reg1)
		  "a": MOV_op[7:4] = 0;
		  "b": MOV_op[7:4] = 1;
		  "data_out": MOV_op[7:4] = 2;
		  "inst_reg": MOV_op[7:4] = 3;
		  "addr_reg": MOV_op[7:4] = 4;
		  "gpreg": MOV_op[7:4] = 5;
	  endcase

	  case(reg2)
		  "a": MOV_op[3:0] = 0;
		  "b": MOV_op[3:0] = 1;
		  "data_out": MOV_op[3:0] = 2;
		  "inst_reg": MOV_op[3:0] = 3;
		  "addr_reg": MOV_op[3:0] = 4;
		  "gpreg": MOV_op[3:0] = 5;
	  endcase
  end
endfunction



module rom (input boot, input[`ADDR_SIZE-1:0] addr, inout[`WORD_SIZE-1:0] data);

  reg[`WORD_SIZE-1:0] rom_data;

  always@(addr) begin
	  case(addr)
		  /*0: rom_data = {`LOAD,LOAD_op("a","constant"),8'h5}; //load constant 5 to reg a
		  2: rom_data = {`LOAD,LOAD_op("b","memory"),8'h12}; //load contents of memory location 0x12 to reg b
		  4: rom_data = {`STO,STO_op("a"),8'hFE}; //store contents of reg a to memory location 0xFE
		  6: rom_data = {`MOV,3'h0,MOV_op("a","b")}; //move contents of reg a to reg b
		  8: rom_data = {`ADD,3'h0,8'h0}; //add a+b
		  10: rom_data = {`STO,STO_op("data_out"),8'hFE}; //store sum in data_out to memory location 0xFE
		  18: rom_data = 16'h1388; //store number 5000 in this location*/
		  0: rom_data = {`LOAD, LOAD_op("a","memory"), 8'd18};
		  2: rom_data = {`LOAD, LOAD_op("b","memory"), 8'd20};
		  4: rom_data = {`SUB, 3'h0, 8'h0};
		  6: rom_data = {`STO, STO_op("data_out"), 8'hFE};
		  18: rom_data = -16'd32768;
		  20: rom_data = 16'd1;
		  default: rom_data = 'b0; 
	  endcase
  end

  assign data = boot? rom_data:'bz;
endmodule






