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
// Module:  data_ram
// File:    data_ram.v
// Author:  Lei Silei
// E-mail:  leishangwen@163.com
// Description: ¨ºy?Y¡ä?¡ä¡é?¡Â
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module data_ram(

	input	wire	clk,
	input wire	ce,
	input wire we,
	input wire[`DataAddrBus]	addr,
	input wire[`DataBus]		data_i,
	output reg[`DataBus]		data_o
	
);

	reg[`DataBus]  data_mem[0:`DataMemNum-1];
	wire[`DataBus] mem_read;
	assign mem_read = data_mem[addr];
	
	always @ (posedge clk) begin
		if (ce == `ChipDisable) begin
			//data_o <= ZeroWord;
		end else if(we == `WriteEnable) begin
		      data_mem[addr] <= data_i;
		end
	end
	
	always @ (*) begin
		if (ce == `ChipDisable) begin
			data_o <= `ZeroWord;
	  end else if(we == `WriteDisable) begin
		    data_o <= mem_read;
		end else begin
				data_o <= `ZeroWord;
		end
	end		

endmodule
