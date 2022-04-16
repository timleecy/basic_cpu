//Parameterized ALU module
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

module alu #(parameter WORD_SIZE) (input signed[WORD_SIZE-1:0] a, b, input mode, output reg signed[WORD_SIZE-1:0] c, output reg overflow);

  localparam ADD=0, SUB=1;

  //too be added with more modes
  always@(*) begin
	  case(mode) 
		  ADD:c = a + b;
		  SUB:c = a - b;
	  endcase
  end

  //overflow handling
  always@(*) begin
	  if(mode == ADD) 
		  assign overflow = (a>0)&(b>0)&(c<=0) | (a<0)&(b<0)&(c>=0);
	  
	  else if(mode == SUB)
		  assign overflow = (a>0)&(b<0)&(c<=0) | (a<0)&(b>0)&(c>=0);
  end

endmodule

