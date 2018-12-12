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
// Module:  ex_mem
// File:    ex_mem.v
// Description: EX/MEM阶段的寄存器
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module ex_mem(

	input	wire	clk,
	input wire	rst,
input wire[5:0]	stall,		
	
	//来自执行阶段的信息	
	input wire[`RegAddrBus]       ex_wd,
	input wire                    ex_wreg,
	input wire[`RegBus]				ex_wdata, 	
	
  input wire[`AluOpBus]        ex_aluop,
	input wire[`RegBus]          ex_mem_addr,
	input wire[`RegBus]          ex_reg2,
	
	//送到访存阶段的信息
	output reg[`RegAddrBus]      mem_wd,
	output reg                   mem_wreg,
	output reg[`RegBus]			  mem_wdata,
	
  output reg[`AluOpBus]        mem_aluop,
	output reg[`RegBus]          mem_mem_addr,
	output reg[`RegBus]          mem_reg2,

	output reg[`RegBus]	mem_wdata_last,
	output reg[`RegBus]	mem_mem_addr_last,

	input tad0en,
	input tad1en,
	input tad2en,
	input tad3en,
	input[`RegBus] raddr,
	input tchangeen,
	input[`RegBus] waddr,
	input[`RegBus] wdata,

	output[`RegBus] rdata1,
	output[`RegBus] rdata2,
	output[`RegBus] rdata3,
	output[`RegBus] rdata0,

	output reg[`RegBus] tad0,
	output reg[`RegBus] tad1,
	output reg[`RegBus] tad2,
	output reg[`RegBus] tad3
);

	reg[`RegBus] tlb0;
	reg[`RegBus] tlb1;
	reg[`RegBus] tlb2;
	reg[`RegBus] tlb3;
	reg[1:0] tnexten;

	assign rdata0 = tlb0;
	assign rdata1 = tlb1;
	assign rdata2 = tlb2;
	assign rdata3 = tlb3;

	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
		  tad0<=16'hbf00;
		  tad1<=16'hbf00;
		  tad2<=16'hbf00;
		  tad3<=16'hbf00;
		  tnexten<=2'b0;
		  end else begin
			if(tchangeen) begin
				if(tnexten==2'b0) tad0<=waddr;
				if(tnexten==2'b1) tad1<=waddr;
				if(tnexten==2'b10) tad2<=waddr;
				if(tnexten==2'b11) tad3<=waddr;
				tnexten<=tnexten+2'b1;
			end
		end
	end

	always @ (posedge clk) begin
		if(rst == `RstDisable) begin
			if(tad0en) tlb0<=wdata;
			if(tad1en) tlb1<=wdata;
			if(tad2en) tlb2<=wdata;
			if(tad3en) tlb3<=wdata;
		end
	end



	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
			mem_wdata <= `ZeroWord;	
			mem_aluop <= `EXE_NOP_OP; 
			mem_mem_addr <= `ZeroWord;
			mem_reg2 <= `ZeroWord;
			mem_wdata_last <= `ZeroWord;
			mem_mem_addr_last <= `ZeroWord;
		end else if(stall[3] == `Stop && stall[4] == `NoStop) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
			mem_wdata <= `ZeroWord;
		  	mem_aluop <= `EXE_NOP_OP;
			mem_mem_addr <= `ZeroWord;
			mem_reg2 <= `ZeroWord;
		end else if(stall[3] == `NoStop) begin
			mem_wd <= ex_wd;
			mem_wreg <= ex_wreg;
			mem_wdata <= ex_wdata;			
			mem_aluop <= ex_aluop;
			mem_mem_addr <= ex_mem_addr;
			mem_reg2 <= ex_reg2;
			if(ex_aluop == `EXE_SW_OP) begin
				mem_wdata_last <= mem_wdata;
				mem_mem_addr_last <= mem_mem_addr;
			end
		end    //if
	end      //always
			

endmodule
