//Functions to ease instruction programming in ROM
//timleecy16@gmail.com

`include "../macros/top_macro.vh"

function[15:0] nop;
	nop = {`NOP,3'b0,8'b0};
endfunction

function[15:0] load (input string register, operand_type, input[7:0] address);

    logic register_num;
    logic[1:0] optype_num;

	if(register == "a")
		register_num = 0;
    else if(register == "b")
        register_num = 1;

    if(operand_type == "constant")
        optype_num[1:0] = 0;
    else if(operand_type == "memory")
        optype_num[1:0] = 1;
    else if(operand_type == "pointer")
        optype_num[1:0] = 2;

	load = {`LOAD,register_num,optype_num,address};
endfunction

function[15:0] sto (input string register, input[7:0] address);

	logic[2:0] register_num;

	case(register)
		"a": register_num = 0;
        "b": register_num = 1;
        "data_out": register_num = 2;
        "inst_reg": register_num = 3;
        "addr_reg": register_num = 4;
        "gpreg": register_num = 5;
    endcase

	sto = {`STO,register_num,address};
endfunction

function[15:0] mov (input string reg1, reg2);

	logic[3:0] reg1_num, reg2_num;

	case(reg1)
		"a": reg1_num = 0;
        "b": reg1_num = 1;
        "data_out": reg1_num = 2;
        "inst_reg": reg1_num = 3;
        "addr_reg": reg1_num = 4;
        "gpreg": reg1_num = 5;
    endcase

    case(reg2)
        "a": reg2_num = 0;
        "b": reg2_num = 1;
        "data_out": reg2_num = 2;
        "inst_reg": reg2_num = 3;
        "addr_reg": reg2_num = 4;
        "gpreg": reg2_num = 5;
    endcase

	mov = {`MOV,3'b0,reg1_num,reg2_num};
endfunction

function[15:0] add;
	add = {`ADD,3'b0,8'b0};
endfunction

function[15:0] sub;
	sub = {`SUB,3'b0,8'b0};
endfunction

function[15:0] cmp;
	cmp = {`CMP,3'b0,8'b0};
endfunction

function[15:0] jmpu (input[7:0] address);
	jmpu = {`JMPU,3'b0,address};
endfunction

function[15:0] jmpc (input string cond, input[7:0] address);

	logic[2:0] cond_num;

	case(cond)
        "==": cond_num = 0;
        "!=": cond_num = 1;
        ">" : cond_num = 2;
        ">=": cond_num = 3;
        "<" : cond_num = 4;
        "<=": cond_num = 5;
        "&" : cond_num = 6;
        "|" : cond_num = 7;
    endcase

	jmpc = {`JMPC,cond_num,address};
endfunction

function[15:0] movg (input string bit1, bit2);

	logic[3:0] bit1_num, bit2_num;

	case(bit1)
        "RESET": bit1_num = 0;
        "BOOT": bit1_num = 1;
        "WR_EN": bit1_num = 2;
        "OVFL": bit1_num = 3;
        "EQ": bit1_num = 4;
        "BIG": bit1_num = 5;
        "JUMP": bit1_num = 6;
        "COND1": bit1_num = 7;
        "COND2": bit1_num = 8;
    endcase

    case(bit2)
        "RESET": bit2_num = 0;
        "BOOT": bit2_num = 1;
        "WR_EN": bit2_num = 2;
        "OVFL": bit2_num = 3;
        "EQ": bit2_num = 4;
        "BIG": bit2_num = 5;
        "JUMP": bit2_num = 6;
        "COND1": bit2_num = 7;
        "COND2": bit2_num = 8;
    endcase

	movg = {`MOVG,3'b0,bit1_num,bit2_num};
endfunction
