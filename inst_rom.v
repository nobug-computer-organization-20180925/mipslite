//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2014 leishangwen@163.com                       ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
// Module:  inst_rom
// File:    inst_rom.v
// Author:  Lei Silei
// E-mail:  leishangwen@163.com
// Description: ָ��洢��
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module inst_rom(

//	input	wire	clk,
	input wire  ce,
	input wire[`InstAddrBus]	addr,
	input wire rst,
	output reg[`InstBus]			inst
	
);

	reg[`InstBus]  inst_mem[0:`InstMemNum-1];
	wire[`InstBus] instDataTemp;
	integer i;
	always @(negedge rst) begin
	for(i=0;i<`InstMemNum;i=i+1) inst_mem[i]<=0;
	inst_mem[0]<=16'b11101_001_010_01101;//11101 or tail 01101: reg1=reg1 or reg2=0202 ans=0303
	inst_mem[1]<=16'b10011_000_001_00001;//10011 load reg1's value = 0 or 0404
	inst_mem[2]<=16'b11111_001_010_01101;//11111 ori: reg1 = reg1 or imm 01001101 004d ans=0000_0011_0100_1111
	inst_mem[3]<=16'b01111_001_011_00000;//01111 move: reg1 = reg2 tail 00000 ans=0404
	inst_mem[4]<=16'b11011_000_001_00001;//11011 save reg1's value 0404 to mem[1] 
	inst_mem[5]<=16'b00110_001_001_01100;//<<3
	inst_mem[6]<=16'b00110_001_001_01111;//>>3
	inst_mem[17]<=16'b00100_001_111_11100;//00100 branch: branch if=0 7:0 jump to pc=1
	inst_mem[18]<=16'b01101_001_000_00000;//01101 li reg1=0
	inst_mem[19]<=16'b01101_001_000_00001;//01101 li reg1=1
	inst_mem[20]<=16'b01101_010_000_00001;//01101 li reg2=1
	inst_mem[21]<=16'b11101_010_001_00001;//11101 cmp reg1 reg2
	inst_mem[22]<=16'b00100_001_111_11010;//00100 branch: branch if=0 7:0 jump to pc=1
	inst_mem[23]<=16'b01101_001_100_00001;//01101 li reg1=00000000_10000001 
	inst_mem[24]<=16'b01101_001_100_00010;//01101 li reg1=00000000_10000010 
	inst_mem[25]<=16'b01100_000_111_10000;//00101 branch: branch if equal jump to pc=0
	inst_mem[26]<=16'b01101_001_100_00101;//01101 li reg1=00000000_10000101 
	inst_mem[27]<=16'b01101_001_100_01010;//01101 li reg1=00000000_10001010 
	

	end
	
	

	assign instDataTemp = inst_mem[addr];//modified

	always @ (*) begin
		if (ce == `ChipDisable) begin
			inst = `ZeroWord;
	  end else begin
		  inst = instDataTemp;
		end
	end

endmodule
