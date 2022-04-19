//CPU module
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

module cpu_test (input clk, rst, inout[`WORD_SIZE-1:0] data_bus, output[`ADDR_SIZE-1:0] addr_bus, output reg wr_en, output boot_flag);
  
  //states
  localparam FETCH=0, LOADA=1, LOADB=2, WRITE_BACK=3, DONE=4;
  reg[7:0] state = 0;
  reg[7:0] next_state;

  //registers
  reg[`ADDR_SIZE-1:0] pc = 0;
  reg[`ADDR_SIZE-1:0] addr_reg = 0;
  reg[`WORD_SIZE-1:0] inst_reg;
  reg[`WORD_SIZE-1:0] data_reg;
  reg[`WORD_SIZE-1:0] a,b;
  reg overflow; 
  reg boot = 1;
  assign boot_flag = boot;

  wire[`WORD_SIZE-1:0] alu_out;
  wire overflow_wire;
  wire mode;

  //ALU instantiation and setting output to registers
  alu ALU_cpu (.a(a), .b(b), .mode(mode), .c(alu_out), .overflow(overflow_wire));
  assign mode = inst_reg[0];

  //Bus assignment
  assign addr_bus = addr_reg;
  assign data_bus = (~boot & wr_en)? data_reg:'bz;

  //Seq logic for state
  always@(posedge clk) begin
	  if(rst)
		  state <= 0;
	  else begin
		  if(boot)
			  state <= 0;
		  else
			  state <= next_state;
	  end
  end

  //Seq logic for pc
  always@(posedge clk) begin
	  if(rst)
		  pc <= 0;
	  else begin
		  if(boot) begin
			  if(pc !=(2**`ADDR_SIZE - 2))
				  pc <= pc + 2;
			  else
				  pc <= 0;
		  end

		  else begin
			  if (state != WRITE_BACK) 
				  pc <= pc + 2;
			  else 
				  pc <= pc;
		  end
	  end
  end
  
  //Seq logic for addr_reg
  always@(posedge clk) begin
	  if(boot) 
		  addr_reg <= pc;
	  else begin
		  if(state == WRITE_BACK)
			  addr_reg <= addr_reg;
		  else
			  addr_reg <= pc;
	  end
  end

  //Seq logic for inst_reg
  always@(posedge clk) begin
	  if (state == FETCH)
		  inst_reg <= data_bus;
  end

  //Seq logic for data_reg
  always@(posedge clk) begin
	  if (state == WRITE_BACK)
		  data_reg <= alu_out;
  end

  //Seq logic for reg a
  always@(posedge clk) begin
	  if (state == LOADA)
		  a <= data_bus;
  end

  //Seq logic for reg b
  always@(posedge clk) begin
	  if (state == LOADB)
		  b <= data_bus;
  end
  
  //Seq logic for overflow reg
  always@(posedge clk) begin
	  overflow = overflow_wire;
  end

  //Seq logic for boot_done
  always@(posedge clk) begin
	  if(rst)
		  boot <= 1;
	  else begin
		  if (boot && addr_reg==(2**`ADDR_SIZE - 2)) 
			  boot <= 0;
	  end
  end

  //Seq logic for wr_en
  always@(posedge clk) begin
	  if(boot) begin
		  if(addr_reg!=(2**`ADDR_SIZE - 2))
			  wr_en <= 1;
		  else
			  wr_en <= 0;
	  end

	  else begin
		  if(state == WRITE_BACK)
			  wr_en <= 1;
		  else
			  wr_en <= 0;
	  end
  end


/*



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


  */

  always@(*) begin
	  case(state)
		  FETCH: next_state = LOADA;
		  LOADA: next_state = LOADB;
		  LOADB: next_state = WRITE_BACK;
		  WRITE_BACK: next_state = DONE;
		  DONE: next_state = FETCH;
	  endcase
  end




endmodule
