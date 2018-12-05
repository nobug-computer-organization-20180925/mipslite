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
// Module:  openmips_min_sopc_tb
// File:    openmips_min_sopc_tb.v
// Description: openmips_min_sopcµÄtestbench
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"
`timescale 1ns/1ns

module openmips_min_sopc_tb();

  reg     CLOCK_50;
  reg     rst;

	wire[`RegBus] register1;
   wire ram1_WE_L;
   wire ram2_WE_L;
   wire ram1_OE_L;
   wire ram2_OE_L;	 
	wire ram1_CE;
	wire ram2_CE;
	wire[15:0] ram1datainout;
   wire[15:0] ram2datainout;
	 
	wire[`RegBus] ram1addr;
	wire[`RegBus] ram2addr;
       
  initial begin
    CLOCK_50 = 1'b0;
    forever #10 CLOCK_50 = ~CLOCK_50;
  end
      
  initial begin
    rst = `RstEnable;
    #195 rst= `RstDisable;
    #4100 $stop;
  end
       
  openmips_min_sopc openmips_min_sopc0(
		.clk(CLOCK_50),
		.rst(rst),
		.register1(register1),
	.ram1_WE_L(ram1_WE_L),
   .ram2_WE_L(ram2_WE_L),
   .ram1_OE_L(ram1_OE_L),
   .ram2_OE_L(ram2_OE_L),
	.ram1_CE(ram1_CE),
   .ram2_CE(ram2_CE), 
	.ram1datainout(ram1datainout),
   .ram2datainout(ram2datainout),
	 
	.ram1addr(ram1addr),
	.ram2addr(ram2addr)
	);
	
	reg[`DataBus]  data_mem[0:`DataMemNum-1];
	wire[`DataBus] mem_read;
	reg[`DataBus] data_o;
	assign mem_read = data_mem[ram2addr];
	assign ram2datainout = ram2_OE_L ? 16'bz : data_o;
	integer i;
	always @(negedge rst) begin
	for(i=0;i<`InstMemNum;i=i+1) data_mem[i]<=0;
	data_mem[0]<=16'b11101_001_010_01101;//11101 or tail 01101: reg1=reg1 or reg2=0202 ans=0303
	data_mem[1]<=16'b10011_000_001_00001;//10011 load reg1's value = 0 or 0404
	data_mem[2]<=16'b11111_001_010_01101;//11111 ori: reg1 = reg1 or imm 01001101 004d ans=0000_0011_0100_1111
	data_mem[3]<=16'b01111_001_011_00000;//01111 move: reg1 = reg2 tail 00000 ans=0404
	data_mem[4]<=16'b11011_000_001_00001;//11011 save reg1's value 0404 to mem[1] 
	data_mem[5]<=16'b00100_001_111_11100;//00100 branch: branch if=0 7:0 jump to pc=1
	data_mem[6]<=16'b01101_001_000_00000;//01101 li reg1=0
	data_mem[7]<=16'b01101_001_000_00010;//01101 li reg1=2
	data_mem[8]<=16'b01001_001_111_11111;//01001 addiu: reg1=reg1-1 ans=0001
	//data_mem[8]<=16'b01100_011_000_11111;//01100 addsp: sp=sp-1 ans=0021
	data_mem[9]<=16'b01000_010_001_01111;//01000 addiu3: reg1=reg2-1 ans=0201
	data_mem[10]<=16'b11100_010_001_00111;//11100 subu: reg1=reg2-reg1 ans=0001
	data_mem[11]<=16'b11110_010_000_00001;//11110 mtih: ih=reg2 ans=0001
	data_mem[12]<=16'b11110_001_000_00000;//11110 mfih: reg1=ih ans=0202
	data_mem[13]<=16'b00100_001_111_10101;//00100 branch: branch if=0 7:0 jump to pc=3
	data_mem[14]<=16'b01101_001_100_00001;//01101 li reg1=00000000_10000001 
	data_mem[15]<=16'b01101_001_100_00010;//01101 li reg1=00000000_10000010 
	data_mem[16]<=16'b00101_001_111_10010;//00101 branch: branch if!=0 7:0 jump to pc=3
	data_mem[17]<=16'b01101_001_100_00101;//01101 li reg1=00000000_10000101 
	data_mem[18]<=16'b01101_001_100_01010;//01101 li reg1=00000000_10001010 
	

	end
	
	
	
	always @ (posedge ram2_WE_L) begin
		if (ram2_CE == `ChipDisable) begin
			//data_o <= ZeroWord;
		end else if(ram2_OE_L == `WriteEnable) begin
		      data_mem[ram2addr] <= ram2datainout;
		end
	end
	
	always @ (*) begin
		if (ram2_CE == `ChipDisable) begin
			data_o <= `ZeroWord;
	  end else if(ram2_OE_L == `WriteDisable) begin
		    data_o <= mem_read;
		end else begin
				data_o <= `ZeroWord;
		end
	end		

endmodule
