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
// Description: ����OpenMIPS��������һ����SOPC��������֤�߱���
//              wishbone���߽ӿڵ�openmips����SOPC����openmips��
//              wb_conmax��GPIO controller��flash controller��uart 
//              controller���Լ���������flash��ģ��flashmem��������
//              �洢ָ����������ⲿram��ģ��datamem�������д洢
//              ���ݣ����Ҿ���wishbone���߽ӿ�    
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module openmips_min_sopc(

	input	wire clk_p,
	input wire clk_50,
	input wire rst,
	input wire clk_50_en,
	

	output wire[`RegBus] register1,
	output wire[6:0] high7,
	output wire[6:0] low7,

    input wire tbre,
    input wire tsre,    
    input wire data_ready,    
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
  //����ָ��洢��
  wire[`InstAddrBus] inst_addr;
  wire[`InstBus] inst;
  wire rom_ce;
  wire mem_we_i;
  wire[`RegBus] mem_addr_i;
  wire[`RegBus] mem_data_o;
  wire[`RegBus] mem_data_i;  
  wire mem_ce_i;   
  wire[5:0] stall;
  wire[`RegBus] register;
  assign register1 = {register[15:1], data_ready};
  wire clk;
  assign clk =  clk_50_en ? clk_p : clk_50;
  reg clk25;
  
  always @(posedge clk) begin
	if(rst == `RstEnable) clk25=clk; else clk25=~clk25;
end
  wire[`RegBus] pc;
 sevenseg sevenseg0(
	.pc(pc[3:0]),
	.pc_out(low7)
	);
sevenseg sevenseg1(
	.pc(pc[7:4]),
	.pc_out(high7)
	);

 
 openmips openmips0(
		.clk(clk25),
		.rst(rst),
		.pc(pc),
	
		.rom_addr_o(inst_addr),
		.rom_data_i(inst),
		.rom_ce_o(rom_ce),
		
		.ram_we_o(mem_we_i),
		.ram_addr_o(mem_addr_i),
		.ram_data_o(mem_data_i),
		.ram_data_i(mem_data_o),
		.ram_ce_o(mem_ce_i),

		.register1(register),
		.stall(stall),

		.tbre(tbre),
		.tsre(tsre),
		.data_ready(data_ready),
		.wrn(wrn),
		.rdn(rdn),
		.ram1_CE(ram1_CE),
		.ram1_WE_L(ram1_WE_L),
		.ram1_OE_L(ram1_OE_L),
		.ram1datainout(ram1datainout),
		.ram1addr(ram1addr)
	
	);
	
/*	inst_rom inst_rom0(
		.addr(inst_addr),
		.inst(inst),
		.ce(rom_ce),
		.rst(rst)
	);
	data_ram data_ram0(
		.clk(clk),
		.we(mem_we_i),
		.addr(mem_addr_i),
		.data_i(mem_data_i),
		.data_o(mem_data_o),
		.ce(mem_ce_i)		
	);
*/

	 
//	 assign ram2_CE = ~mem_ce_i;
	 assign ram2_CE = 0;
	 assign ram2_WE_L = ~ram2_OE_L | clk25;
	 assign ram2_OE_L = mem_ce_i == `ChipEnable ? mem_we_i : `WriteDisable;
	 assign ram2datainout = (mem_ce_i == `ChipEnable && mem_we_i ? mem_data_i : 16'bz);
	 assign mem_data_o = ram2datainout;
	 assign inst = ram2datainout;
	 assign ram2addr = mem_ce_i == `ChipEnable ? mem_addr_i : inst_addr;
	
	 
endmodule
