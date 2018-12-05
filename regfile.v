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
// Module:  regfile
// File:    regfile.v
// Description: Í¨ÓÃ¼Ä´æÆ÷
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module regfile(

	input	wire clk,
	input wire rst,
	
	//Ð´¶Ë¿Ú
	input wire we,
	input wire[`RegAddrBus] waddr,
	input wire[`RegBus] wdata,
	
	//¶Á¶Ë¿Ú1
	input wire re1,
	input wire[`RegAddrBus] raddr1,
	output reg[`RegBus] rdata1,
	
	//¶Á¶Ë¿Ú2
	input wire re2,
	input wire[`RegAddrBus] raddr2,
	output reg[`RegBus] rdata2,
	
	output wire[`RegBus] register1
	
);

	reg[`RegBus]	regs[0:`RegNum-1];
	wire[`RegBus]	readDataTemp1;
	wire[`RegBus]	readDataTemp2;
	wire[`RegBus]	IHDataTemp;
	
	
	assign readDataTemp1 = regs[raddr1];
	assign readDataTemp2 = regs[raddr2];
	assign register1 = regs[1];

	always @ (posedge clk) begin
		if (rst == `RstDisable) begin
			if((we == `WriteEnable) && (waddr != `NOPRegAddr)) begin
				regs[waddr] <= wdata;
			end
		end
		else begin
			regs[0]<=16'h0;
			regs[1]<=16'h0101;
			regs[2]<=16'h0202;
			regs[3]<=16'h0404;
			regs[4]<=16'h0808;
			regs[5]<=16'h1010;
			regs[6]<=16'h2020;
			regs[7]<=16'h4040;
			regs[8]<=16'h0; //0
			regs[9]<=16'h0; //SP
			regs[10]<=16'h0; //T
			regs[11]<=16'h0; //RA
			regs[12]<=16'h0; //IH
			regs[13]<=16'h0;
			regs[14]<=16'h0;
			regs[15]<=16'h0;

		end
	end
	
	always @ (*) begin
		if(rst == `RstEnable) begin
			  rdata1 = `ZeroWord;
	  end else if(raddr1 == `NOPRegAddr) begin
	  		rdata1 = `ZeroWord;
	  end else if((raddr1 == waddr) && (we == `WriteEnable) 
	  	            && (re1 == `ReadEnable)) begin
	  	  rdata1 = wdata;
	  end else if(re1 == `ReadEnable) begin
	      rdata1 = readDataTemp1;
	  end else begin
	      rdata1 = `ZeroWord;
	  end
	end

	always @ (*) begin
		if(rst == `RstEnable) begin
			  rdata2 = `ZeroWord;
	  end else if(raddr2 == `NOPRegAddr) begin
	  		rdata2 = `ZeroWord;
	  end else if((raddr2 == waddr) && (we == `WriteEnable) 
	  	            && (re2 == `ReadEnable)) begin
	  	  rdata2 = wdata;
	  end else if(re2 == `ReadEnable) begin
	      rdata2 = readDataTemp2;
	  end else begin
	      rdata2 = `ZeroWord;
	  end
	end

endmodule