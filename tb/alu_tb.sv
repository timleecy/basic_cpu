//ALU testbench
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

module alu_tb;

  enum {ADD,SUB} mode_t;

  reg signed[`WORD_SIZE-1:0] a,b;
  reg mode = ADD;
  wire signed[`WORD_SIZE-1:0] c;
  wire overflow;

  alu ALU1(.a(a), .b(b), .mode(mode), .c(c), .overflow(overflow));

  //test data
  int test_a[0:7] = {32767,2,127,128,5,5,-128,-129};
  int test_b[0:7] = {1,3,1,128,-1,-10,1,-5};
  int test_c[0:7];

  initial begin
	  for(int i=0;i<8;i++) begin
		  if(mode==ADD)
			  test_c[i] = test_a[i] + test_b[i];
		  else if(mode==SUB)
			  test_c[i] = test_a[i] - test_b[i];
	  end

	  #1
	  for(int i=0;i<8;i++) begin
		  #1
		  a = test_a[i];
		  b = test_b[i];
          
		  #1
		  if(c != test_c[i]) begin
			  $display("ERROR at a= %0d, b= %0d, c= %0d, a_test= %0d, b_test= %0d, c_test= %0d, overflow= %0b", a,b,c,test_a[i],test_b[i],test_c[i],overflow);
		  end
	  end
  end

  //manual check
  /*initial begin
	  $monitor("a= %d, b= %d, c= %d (%b), overflow= %b", a, b, c, c, overflow);
	  #1 a=1;b=0;
	  #1 a=2;b=3;
	  #1 a=127;b=1;
	  #1 a=128;b=128;
	  #1 a=5;b=-1;
	  #1 a=5;b=-10;
	  #1 a=-128;b=1;
	  #1 a=-129;b=-5;
  end*/

endmodule
