# basic_cpu

16-bit CPU 
- Word size: 16
- Address bus size: 8 (256 memory locations)
- byte-addressable
- little endian

Registers:
[7:0]pc
[7:0]addr_reg
[15:0]inst_reg
[15:0]data_out
[15:0]a
[15:0]b
[15:0]temp
[15:0]gpreg
-- 0:RESET
-- 1:BOOT
-- 2:WR_EN
-- 3:OVFL
**To be added with more


Instruction format:
Bit 15-11: Opcode (5bits == 32 instructions in total)
Bit 10-8: General purpose (can be used to reference registers or type of operand)
Bit 7-0: To store memory addresses or 8-bit constants

Instructions:

0. NOP (0x0)
   Does nothing.

1. LOAD (0x1)	
   Loads data into register.
   Bit [10] determines which register (0 for a, 1 for b)
   Bit [9:8] determines the type of operand:
   0: 8-bit constant
   1: memory location
   2: pointer to memory location

   eg: `LOAD 001 0xFF (Loads contents of memory location 0xFF into register a)

3. STO (0x2)
   Store contents of specified register in bit[10:8] into memory location in operand.
   0: a
   1: b
   2: data_out
   3: inst_reg
   4: addr_reg
   5: gpreg

   eg: `STO 010 0xFF (Stores data in data_out in memory location 0xFF)

4. MOV (0x3)
   Move contents of specified register in bit[7:4] to specified register in bit[3:0].
   0: a
   1: b
   2: data_out
   3: inst_reg
   4: addr_reg
   5: gpreg

   eg: `MOV 3'bx 0000_0001 (Move content of register a to register b)






