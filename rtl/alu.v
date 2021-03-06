//ALU module
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

module alu (input signed[`WORD_SIZE-1:0] a, b, input[4:0] opcode, output reg signed[`WORD_SIZE-1:0] c, output reg overflow, output reg[1:0] comp_flag);


  //Block for output c
  always@(*) begin
	  case(opcode) 
		  `ADD:c = a + b;
		  `SUB:c = a - b;
		  default: c = 'bx; 
	  endcase
  end

  //Block for comp_flag
  always@(*) begin
	  case(opcode)
		  `CMP: begin
			  comp_flag[0] = (a==b);
			  comp_flag[1] = (a>b);
		  end
		  default: comp_flag = 'bx;
	  endcase
  end

  //overflow handling
  always@(*) begin
	  if(opcode == `ADD) 
		  overflow = (a>0)&(b>0)&(c<=0) | (a<0)&(b<0)&(c>=0);
	  
	  else if(opcode == `SUB)
		  overflow = (a>0)&(b<0)&(c<=0) | (a<0)&(b>0)&(c>=0);
	  
	  else
		  overflow = 'bx;
  end

endmodule

