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
[15:0]data_reg
[15:0]a
[15:0]b
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

1. LOADA (0x1)	
   Loads data into register a. Bit 5-7 represents type of operand.
   001: Constant
   010: Memory location
   100: Memory address of intended memory location (pointer)

   eg: 0xFF 010_5'd1 (Loads contents of memory location 0xFF into register a)

2. LOADB (0x2)
   Same as LOADA but for register b.

3. STO (0x3)
   Store contents of specified register in bit 5-7 into memory location stated.
   000: reg a
   001: reg b
   010: inst_reg
   011: data_reg
   100: gpreg

   eg: 0xFF 011_5'h3 (Stores data in data_reg in memory location 0xFF)

4. 







