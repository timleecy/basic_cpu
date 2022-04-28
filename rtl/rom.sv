//ROM module used to store program instructions
//Outputs 16 bits of data when RAM provides an address
//timleecy16@gmail.com

`include "../functions/rom_funcs.sv"
//`define FOR_LOOP 
//`define IF_ELSE_MULTI_COND
`define POINTER 

module rom (input boot, input[`ADDR_SIZE-1:0] addr, inout[`WORD_SIZE-1:0] data);

  reg[`WORD_SIZE-1:0] rom_data;

  /*always@(addr) begin
	  case(addr)
		  0: rom_data = {`LOAD,LOAD_op("a","constant"),8'h5}; //load constant 5 to reg a
		  2: rom_data = {`LOAD,LOAD_op("b","memory"),8'h12}; //load contents of memory location 0x12 to reg b
		  4: rom_data = {`STO,STO_op("a"),8'hFE}; //store contents of reg a to memory location 0xFE
		  6: rom_data = {`MOV,3'h0,MOV_op("a","b")}; //move contents of reg a to reg b
		  8: rom_data = {`ADD,3'h0,8'h0}; //add a+b
		  10: rom_data = {`STO,STO_op("data_out"),8'hFE}; //store sum in data_out to memory location 0xFE
		  18: rom_data = 16'h1388; //store number 5000 in this location
		  0: rom_data = {`LOAD, LOAD_op("a","memory"), 8'd18};
		  2: rom_data = {`LOAD, LOAD_op("b","memory"), 8'd20};
		  4: rom_data = {`SUB, 3'h0, 8'h0};
		  6: rom_data = {`STO, STO_op("data_out"), 8'hFE};
		  18: rom_data = -16'd32768;
		  20: rom_data = 16'd1;
		  default: rom_data = 'b0; 
	  endcase
  end*/

  //test for loop
  //x=0;y=0;z=2;
  //for(i=0;i<10;i++)
  //x=y+z
  //y+=1;
  //end
  `ifdef FOR_LOOP
  always@(addr) begin
	  case(addr)
		  0: rom_data = load("a","memory",8'd40);
		  2: rom_data = load("b","constant",8'd10);
		  4: rom_data = cmp;
		  6: rom_data = jmpc(">=",8'd32);
		  8: rom_data = load("a","memory",8'd44);
		  10: rom_data = load("b","memory",8'd46);
		  12: rom_data = add;
		  14: rom_data = sto("data_out",8'd42);
		  16: rom_data = load("b","constant",8'd1);
		  18: rom_data = add;
		  20: rom_data = sto("data_out",8'd44);
		  22: rom_data = load("a","memory",8'd40);
		  24: rom_data = load("b","constant",8'd1);
		  26: rom_data = add;
		  28: rom_data = sto("data_out",8'd40);
		  30: rom_data = jmpu(8'd0);
		  32: rom_data = halt;

		  40: rom_data = 16'd0; //i
		  42: rom_data = 16'd0; //x
		  44: rom_data = 16'd0; //y
		  46: rom_data = 16'd2; //z
		  default: rom_data = 16'b0;
	  endcase
  end
  `endif

  //test if with multiple conditions
  //if(x==y and w==z) x=1
  //else x=2
  `ifdef IF_ELSE_MULTI_COND
  always@(addr) begin
	  case(addr)
		  0: rom_data = load("a","memory",30);
		  2: rom_data = load("b","memory",32);
		  4: rom_data = cmp;
		  6: rom_data = movg("EQ","COND1");
		  8: rom_data = load("a","memory",34);
		  10: rom_data = load("b","memory",36);
		  12: rom_data = cmp;
		  14: rom_data = movg("EQ","COND2");
		  16: rom_data = jmpc("&",24);
		  18: rom_data = load("a","constant",2);
		  20: rom_data = sto("a",30);
		  22: rom_data = jmpu(28);
		  24: rom_data = load("a","constant",1);
		  26: rom_data = sto("a",30);
		  28: rom_data = halt;
		  30: rom_data = 16'd23;
		  32: rom_data = 16'd23;
		  34: rom_data = 16'd70;
		  36: rom_data = 16'd70;
		  default: rom_data = 16'b0;
	  endcase
  end
  `endif
  
  //test pointer
  //int x=450;
  //int* ptr_x = &x;
  `ifdef POINTER
  always@(addr) begin
	  case(addr)
		  0: rom_data = load("a","pointer",20);
		  2: rom_data = halt;
		  20: rom_data = 16'd22;
		  22: rom_data = 16'd450;
		  default: rom_data = 16'b0;
	  endcase
  end
  `endif

  assign data = boot? rom_data:'bz;
endmodule






