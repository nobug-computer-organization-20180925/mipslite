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
	inst_mem[0]<=16'b11101_001_010_01101;//11101 or tail 01101: reg1=reg1 or reg2=0202 ans=0303
	inst_mem[1]<=16'b10011_000_001_00001;//10011 load reg1's value = 0 or 0404
	inst_mem[2]<=16'b11111_001_010_01101;//11111 ori: reg1 = reg1 or imm 01001101 ans=0000_0011_0100_1111
	inst_mem[3]<=16'b01111_001_011_00000;//01111 move: reg1 = reg2 tail 00000 ans=0404
	inst_mem[4]<=16'b11011_000_001_00001;//11011 save reg1's value 0404 to mem[1] 
	inst_mem[5]<=16'b00110_001_001_01100;
	inst_mem[6]<=16'b00110_001_001_01111;
	inst_mem[7]<=16'b00100_001_111_11100;//00100 branch: branch if=0 7:0 jump to pc=1
	inst_mem[8]<=16'b01101_001_000_00000;//01101 li reg1=0
	inst_mem[9]<=16'b01101_001_000_00001;//01101 li reg1=1
	inst_mem[10]<=16'b00100_001_111_11010;//00100 branch: branch if=0 7:0 jump to pc=1
	inst_mem[11]<=16'b01101_001_100_00001;//01101 li reg1=00000000_10000001 
	inst_mem[12]<=16'b01101_001_100_00010;//01101 li reg1=00000000_10000010 
	inst_mem[13]<=16'b00101_001_111_10111;//00101 branch: branch if!=0 7:0 jump to pc=1
	inst_mem[14]<=16'b01101_001_100_00101;//01101 li reg1=00000000_10000101 
	inst_mem[15]<=16'b01101_001_100_01010;//01101 li reg1=00000000_10001010 
	
	for(i=16;i<`InstMemNum;i=i+1) inst_mem[i]<=0;

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
