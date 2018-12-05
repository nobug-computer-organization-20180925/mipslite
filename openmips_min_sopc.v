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
// Module:  openmips_min_sopc
// File:    openmips_min_sopc.v
// Description: 基于OpenMIPS处理器的一个简单SOPC，用于验证具备了
//              wishbone总线接口的openmips，该SOPC包含openmips、
//              wb_conmax、GPIO controller、flash controller，uart 
//              controller，以及用来仿真flash的模块flashmem，在其中
//              存储指令，用来仿真外部ram的模块datamem，在其中存储
//              数据，并且具有wishbone总线接口    
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module openmips_min_sopc(

	input	wire clk,
	input wire rst,
	
	output wire[`RegBus] register1,
	
	 output wire rdn,
    output wire wrn,
	 
    output wire ram1_WE_L,
    output wire ram2_WE_L,
    output wire ram1_OE_L,
    output wire ram2_OE_L,
    output wire ram1_CE,
    output wire ram2_CE,
	 
	 inout wire[15:0] ram1datainout,
    inout wire[15:0] ram2datainout,
	 
	 output wire[`RegBus] ram1addr,
	 output wire[`RegBus] ram2addr
	
);
  //连接指令存储器
  wire[`InstAddrBus] inst_addr;
  wire[`InstBus] inst;
  wire rom_ce;
  wire mem_we_i;
  wire[`RegBus] mem_addr_i;
  wire[`RegBus] mem_data_o;
  wire[`RegBus] mem_data_i;  
  wire mem_ce_i;   

  
 openmips openmips0(
		.clk(clk),
		.rst(rst),
	
		.rom_addr_o(inst_addr),
		.rom_data_i(inst),
		.rom_ce_o(rom_ce),
		
		.ram_we_o(mem_we_i),
		.ram_addr_o(mem_addr_i),
		.ram_data_o(mem_data_i),
		.ram_data_i(mem_data_o),
		.ram_ce_o(mem_ce_i),

		.register1(register1)
	
	);
	
	inst_rom inst_rom0(
		.addr(inst_addr),
		.inst(inst),
		.ce(rom_ce),
		.rst(rst)
	);
/*	data_ram data_ram0(
		.clk(clk),
		.we(mem_we_i),
		.addr(mem_addr_i),
		.data_i(mem_data_i),
		.data_o(mem_data_o),
		.ce(mem_ce_i)		
	);
*/

	 assign wrn=1;
	 assign rdn=1;

    assign ram1_CE = 0;
	 assign ram1_WE_L = 0;
	 assign ram1_OE_L = 0;
	 assign ram1datainout = 16'bz;
	 assign ram1addr = 0;
	 
	 assign ram2_CE = ~mem_ce_i;
	 assign ram2_WE_L = ~mem_we_i | clk;
	 assign ram2_OE_L = mem_we_i;
	 assign ram2datainout = (mem_we_i ? mem_data_i : 16'bz);
    assign mem_data_o = ram2datainout;
	 assign ram2addr = mem_addr_i;
	
	 
endmodule
