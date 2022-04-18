//CPU module
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

module cpu_test (input clk, rst, inout[`WORD_SIZE-1:0] data_bus, output[`ADDR_SIZE-1:0] addr_bus, output reg wr_en);

  localparam FETCH=0, LOADA=1, LOADB=2, WRITE_BACK=3, DONE=4;
  reg[7:0] state = 0;
  reg[7:0] next_state;

  reg[`ADDR_SIZE-1:0] pc = 0;
  reg[`ADDR_SIZE-1:0] addr_reg = 0;
  reg[`WORD_SIZE-1:0] inst_reg;
  reg[`WORD_SIZE-1:0] data_reg;
  reg[`WORD_SIZE-1:0] a,b;
  wire mode;
  reg overflow; 
  reg boot_done = 0;

  wire[`WORD_SIZE-1:0] alu_out;
  //wire[`WORD_SIZE-1:0] c;
  wire overflow_wire;

  //ALU instantiation and setting output to registers
  alu ALU_cpu (.a(a), .b(b), .mode(mode), .c(alu_out), .overflow(overflow_wire));
  assign mode = inst_reg[0];
  /*always@(posedge clk) begin
	  c <= alu_out;
	  overflow <= overflow_wire;
  end*/

  //Bus assignment
  assign addr_bus = addr_reg;
  //assign data_bus = boot_done? (wr_en? data_reg:'bz):'bz;
  assign data_bus = (boot_done & wr_en)? data_reg:'bz;
  /*always@(*) begin
	  if(boot_done) begin
		  if(wr_en)
			  data_bus = c;
		  else
			  data_bus = 'bz;
	  end
  end*/

  //Boot flow
  always@(posedge clk) begin
	  if(~boot_done && addr_reg!=(2**`ADDR_SIZE - 2)) begin //if addr haven't reach 254
		  wr_en <= 1;
		  addr_reg <= addr_reg + 2;
	  end
	  else if(~boot_done && addr_reg==(2**`ADDR_SIZE - 2)) begin
		  wr_en <= 0;
		  addr_reg <= 0;
		  boot_done <= 1;
	  end
  end

  //Program counter??
  always@(posedge clk) begin
	  if(rst) begin
		  addr_reg <= 0;
		  boot_done <= 0;
		  state <= 0;
	  end
	  else begin
		  if(boot_done && state!=WRITE_BACK) begin
			  addr_reg <= addr_reg + 2;
			  state <= next_state;
		  end
		  else if(boot_done && state==WRITE_BACK) begin
			  addr_reg <= addr_reg;
			  state <= next_state;
		  end
	  end
  end

  always@(posedge clk) begin
	  case(state)
		  FETCH: inst_reg <= data_bus;
		  LOADA: a <= data_bus;
		  LOADB: b <= data_bus;
		  WRITE_BACK: begin
			  data_reg <= alu_out;
			  wr_en <= 1;
		  end
		  DONE: wr_en <= 0;
	  endcase
  end

  always@(*) begin
	  case(state)
		  FETCH: next_state <= LOADA;
		  LOADA: next_state <= LOADB;
		  LOADB: next_state <= WRITE_BACK;
		  WRITE_BACK: next_state <= DONE;
		  DONE: next_state <= FETCH;
	  endcase
  end




endmodule
