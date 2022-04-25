//CPU module
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

module cpu (input clk, rst, inout[`WORD_SIZE-1:0] data_bus, output[`ADDR_SIZE-1:0] addr_bus, output wr_en, boot);
  
  //states
  reg[7:0] state = 0;

  //registers
  localparam RESET=0, BOOT=1, WR_EN=2, OVFL=3; //used to reference bit of gpreg
  reg[`ADDR_SIZE-1:0] pc = 0;
  reg[`ADDR_SIZE-1:0] addr_reg = 0;
  reg[`WORD_SIZE-1:0] inst_reg;
  reg[`WORD_SIZE-1:0] data_out;
  reg[`WORD_SIZE-1:0] a,b;
  reg[`WORD_SIZE-1:0] gpreg = 0;  
  reg[`WORD_SIZE-1:0] temp;
  
  wire[4:0] opcode;
  wire[7:0] operand;
  assign opcode = inst_reg[15:11];
  assign operand = inst_reg[7:0];
  assign wr_en = gpreg[WR_EN];
  assign boot = gpreg[BOOT];

  //set RESET register to rst input wire
  always@(posedge clk) begin
	  gpreg[RESET] <= rst;
  end

  //ALU instantiation and setting output to registers
  wire[`WORD_SIZE-1:0] alu_out;
  wire overflow;
  alu ALU_cpu (.a(a), .b(b), .opcode(opcode), .c(alu_out), .overflow(overflow));
  
  //set OVFL reg to overflow wire
  always@(posedge clk) begin
	  gpreg[OVFL] <= overflow;
  end

  //Bus assignment
  assign addr_bus = boot? addr_reg: ((state == 0)? pc:addr_reg);
  assign data_bus = (~boot & wr_en)? data_out:'bz;


  //Seq logic for state
  always@(posedge clk) begin
	  if(rst)
		  state <= 0;
	  else begin
		  if(boot || state==4)
			  state <= 0;
		  else
			  state <= state + 1;
	  end
  end

  //Seq logic for boot reg
  always@(posedge clk) begin
	  if(rst)
		  gpreg[BOOT] <= 1;
	  else begin
		  if(boot && addr_reg==(2**`ADDR_SIZE - 2))
			  gpreg[BOOT] <= 0;
	  end
  end


  //Seq logic for inst_reg
  always@(posedge clk) begin
      if (state == 0)
          inst_reg <= data_bus;
  end

  //Main logic for boot flow and instructions
  always@(posedge clk) begin
	  if(rst) begin //reset flow
		  pc <= 0;
		  addr_reg <= 0;
		  a <= 0;
		  b <= 0;
		  data_out <= 0;
		  temp <= 0;
          gpreg[WR_EN] <= 1;
	  end
	  else if(boot) begin //boot flow
		  if(addr_reg!=(2**`ADDR_SIZE - 2)) 
			  addr_reg <= addr_reg + 2;
          else
              gpreg[WR_EN] <= 0;
	  end
	  else if(state==4) //pc increment
		  pc <= pc + 2;
	  else begin //instruction flow
		  case(opcode)
	
			  `LOAD: begin
				  case(state)
					  1: begin
						  case(inst_reg[9:8])
							  2: addr_reg <= operand;
						  endcase
					  end
					  2: begin
						  case(inst_reg[9:8])
							  1: addr_reg <= operand;
							  2: addr_reg <= data_bus;
						  endcase
					  end
					  3: begin
						  if(inst_reg[10]==0) begin //load a
							  case(inst_reg[9:8])
								  0: a <= operand;
								  1: a <= data_bus;
								  2: a <= data_bus;
							  endcase
						  end
						  else if(inst_reg[10]==1) begin //load b
							  case(inst_reg[9:8])
								  0: b <= operand;
								  1: b <= data_bus;
								  2: b <= data_bus;
							  endcase
						  end
					  end
				  endcase
			  end
	
			  `STO: begin
				  case(state)
					  1: begin
						  case(inst_reg[10:8])
							  0: data_out <= a;
							  1: data_out <= b;
							  2: data_out <= data_out;
							  3: data_out <= inst_reg;
							  4: data_out <= addr_reg;
							  5: data_out <= gpreg;
						  endcase
					  end
					  2: begin
						  addr_reg <= operand;
						  gpreg[WR_EN] <= 1;
					  end
					  3: gpreg[WR_EN] <= 0;
				  endcase
			  end
	
			  `MOV: begin
				  case(state)
					  1: begin
						  case(inst_reg[7:4])
							  0: temp <= a;
							  1: temp <= b;
							  2: temp <= data_out;
							  3: temp <= inst_reg;
							  4: temp <= addr_reg;
							  5: temp <= gpreg;
						  endcase
					  end
					  2: begin
						  case(inst_reg[3:0])
							  0: a <= temp;
							  1: b <= temp;
							  2: data_out <= temp;
							  3: inst_reg <= temp;
							  4: addr_reg <= temp;
							  5: gpreg <= temp;
						  endcase
					  end
				  endcase
			  end

			  `ADD: begin
				  case(state)
					  1: data_out <= alu_out;
				  endcase
			  end

			  `SUB: begin
				  case(state)
					  1: data_out <= alu_out;
				  endcase
			  end

		  endcase
	  end
  end

						 
endmodule
