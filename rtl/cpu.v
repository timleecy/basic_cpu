//CPU module
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

module cpu #(parameter MEM_WIDTH, WORD_SIZE) (input clk, rst, inout[MEM_WIDTH-1:0] data_bus, output[WORD_SIZE-1:0] addr_bus, output wr_en);

  localparam DECODE=0, LOAD_A=1, LOAD_B=2, WRITE_BACK=3, DONE=4;

  reg[WORD_SIZE-1:0] pc = 0;
  reg[MEM_WIDTH-1:0] a,b;
  wire[MEM_WIDTH-1:0] c;
  reg mode;
  reg wr_en_flag = 0;
  wire overflow;

  reg[3:0] state = 0;

  assign wr_en = wr_en_flag;
  alu #(WORD_SIZE) ALU_cpu (.a(a), .b(b), .mode(mode), .c(c), .overflow(overflow));
  
  //program counter
  always@(state) begin
	  if(rst)
		  pc <= 0;
	  else begin
		  if(~wr_en_flag)
			  pc <= pc + 1;
	  end
  end

  always@(posedge clk) begin
	  if(rst || state==DONE)
		  state <= 0;
	  else
		  state <= state + 1;
  end

  always@(posedge clk) begin
  	  case(state)
		  DECODE: mode <= data_bus[0];
          LOAD_A: a <= data_bus;
          LOAD_B: b <= data_bus;
          WRITE_BACK: wr_en_flag <= 1;
          DONE: wr_en_flag <= 0;
  	  endcase
  end

  assign addr_bus = pc;
  assign data_bus = wr_en_flag? c:'bz;

endmodule
