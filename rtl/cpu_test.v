//CPU module for prelim testing
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

module cpu_test (input clk, rst, inout[`WORD_SIZE-1:0] data_bus, output[`ADDR_SIZE-1:0] addr_bus, output wr_en, boot);
  
  //states
  localparam FETCH=0, DECODE=1, EXECUTE=2, WRITE_BACK=3;
  reg[7:0] state = 0;
  reg[7:0] next_state;

  //registers
  localparam RESET=0, BOOT=1, WR_EN=2, OVFL=3; //used to reference bit of gpreg
  reg[`ADDR_SIZE-1:0] pc = 0;
  reg[`ADDR_SIZE-1:0] addr_reg = 0;
  reg[`WORD_SIZE-1:0] inst_reg;
  reg[`WORD_SIZE-1:0] data_reg;
  reg[`WORD_SIZE-1:0] a,b;
  reg[`WORD_SIZE-1:0] gpreg = 16'b0000_0000_0000_0010; //always initialise BOOT register to 1
  assign boot = gpreg[BOOT];
  assign wr_en = gpreg[WR_EN];

  //set Reset register to rst input wire
  always@(*) begin
	  gpreg[RESET] = rst;
  end

  //ALU instantiation and setting output to registers
  wire mode;
  wire overflow;
  wire[`WORD_SIZE-1:0] alu_out;
  alu ALU_cpu (.a(a), .b(b), .mode(mode), .c(alu_out), .overflow(overflow));
  //assign mode = inst_reg[0];

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
			  if(state == WRITE_BACK)
				  pc <= pc + 2;
		  end
	  end
  end
  
  //Seq logic for addr_reg
  always@(posedge clk) begin
	  if(boot) 
		  addr_reg <= pc;
	  else begin
		  case(state)
			  FETCH: addr_reg <= pc;
			  DECODE: begin
				  casex(inst_reg[15:8])
					  {`NOP,3'hx}: addr_reg <= pc; //NOP 
					  {`LOADA,3'h1}: addr_reg <= pc; //LOADA for constant
					  {`LOADA,3'h2}: addr_reg <= inst_reg[7:0]; //LOADA for mem
					  {`LOADB,3'h1}: addr_reg <= pc; //LOADB for constant
					  {`LOADB,3'h2}: addr_reg <= inst_reg[7:0]; //LOADB for mem
					  {`STO,3'hx}: addr_reg <= inst_reg[7:0]; //STO
				  endcase
			  end
			  EXECUTE: begin
				  casex(inst_reg[15:8])
					  {`NOP,3'hx}: addr_reg <= pc; //NOP
					  {`LOADA,3'hx}: addr_reg <= addr_reg; //LOADA for constant
					  {`LOADB,3'hx}: addr_reg <= addr_reg; //LOADB for constant
					  {`STO,3'hx}: addr_reg <= addr_reg; //STO
				  endcase
			  end
			  WRITE_BACK: begin
				  casex(inst_reg[15:8])
					  {`NOP,3'hx}: addr_reg <= pc; //NOP
					  {`LOADA,3'hx}: addr_reg <= addr_reg; //LOADA for constant
					  {`LOADB,3'hx}: addr_reg <= addr_reg; //LOADB for constant
					  {`STO,3'hx}: addr_reg <= addr_reg; //STO
				  endcase
			  end
		  endcase
	  end			  
  end

  //Seq logic for inst_reg
  always@(posedge clk) begin
	  if (state == FETCH)
		  inst_reg <= data_bus;
  end

  //Seq logic for data_reg
  always@(posedge clk) begin
	  if (state == WRITE_BACK) begin
		  case(inst_reg[15:8])
			  {`STO,3'h0}: data_reg <= a; //STO for different register contents
			  {`STO,3'h1}: data_reg <= b;
			  {`STO,3'h2}: data_reg <= inst_reg;
			  {`STO,3'h3}: data_reg <= data_reg;
			  {`STO,3'h4}: data_reg <= gpreg;
			  default: data_reg <= data_reg;
		  endcase
	  end
  end

  //Seq logic for reg a
  always@(posedge clk) begin
	  case(state) 
		  EXECUTE: begin
			  casex(inst_reg[15:8])
				  {`LOADA,3'hx}: a <= data_bus; //LOADA
				  default: a <= a;
			  endcase
		  end
		  default: a <= a;
	  endcase
  end

  //Seq logic for reg b
  always@(posedge clk) begin
	  case(state) 
		  EXECUTE: begin
			  casex(inst_reg[15:8])
				  {`LOADB,3'hx}: b <= data_bus; //LOADB
				  default: b <= b;
			  endcase
		  end
		  default: b <= b;
	  endcase
  end
  
  //Seq logic for overflow reg
  always@(posedge clk) begin
	  gpreg[OVFL] = overflow;
  end

  //Seq logic for boot reg
  always@(posedge clk) begin
	  if(rst)
		  gpreg[BOOT] <= 1;
	  else begin
		  if (boot && addr_reg==(2**`ADDR_SIZE - 2)) 
			  gpreg[BOOT] <= 0;
	  end
  end

  //Seq logic for wr_en reg
  always@(posedge clk) begin
	  if(boot) begin
		  if(addr_reg!=(2**`ADDR_SIZE - 2))
			  gpreg[WR_EN] <= 1;
		  else
			  gpreg[WR_EN] <= 0;
	  end

	  else begin
		  if(state == WRITE_BACK)
			  gpreg[WR_EN] <= 1;
		  else
			  gpreg[WR_EN] <= 0;
	  end
  end


  always@(*) begin
	  case(state)
		  FETCH: next_state = DECODE;
		  DECODE: next_state = EXECUTE;
		  EXECUTE: next_state = WRITE_BACK;
		  WRITE_BACK: next_state = FETCH;
	  endcase
  end




endmodule
