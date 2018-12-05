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
