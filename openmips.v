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
// Module:  openmips
// File:    openmips.v
// Description: OpenMIPS??????????????
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module openmips(

	input	wire clk,
	input wire rst,
	
 
	input wire[`RegBus] rom_data_i,
	output wire[`RegBus] rom_addr_o,
	output wire rom_ce_o,
	output wire[`RegBus] register1,

		
  //�������ݴ洢��data_ram
	input wire[`RegBus]           ram_data_i,
	output wire[`RegBus]           ram_addr_o,
	output wire[`RegBus]           ram_data_o,
	output wire                    ram_we_o,
	output wire               ram_ce_o,
	output wire[5:0] stall,

    input wire tbre,
    input wire tsre,    
    input wire data_ready,    
    output wire[15:0] ram1addr,
    inout wire[15:0] ram1datainout,    
    output wire rdn,
    output wire wrn,
    output wire ram1_WE_L,
    output wire ram1_OE_L,
    output wire ram1_CE,
	 output wire[`InstAddrBus] pc,
	output wire[`RegBus]	reg0,
	output wire[`RegBus]	reg1,
	output wire[`RegBus]	reg2,
	output wire[`RegBus]	reg3,
	output wire[`RegBus]	reg4,
	output wire[`RegBus]	reg5,
	output wire[`RegBus]	reg6,
	output wire[`RegBus]	reg7
	
);
	wire[`RegBus] register2;

	wire write_sig;
	
	wire[`InstAddrBus] id_pc_i;
	wire[`InstBus] id_inst_i;
	
	//??????????ID?????????ID/EX????????
	wire[`AluOpBus] id_aluop_o;
	wire[`AluSelBus] id_alusel_o;
	wire[`RegBus] id_reg1_o;
	wire[`RegBus] id_reg2_o;
	wire	id_read_IH_o;
	wire id_wreg_o;
	wire[`RegAddrBus] id_wd_o;
	wire id_is_in_delayslot_o;
  wire[`RegBus] id_link_address_o;	
    wire[`RegBus] id_inst_o;
	
	//????ID/EX???????????��??EX????????
	wire[`AluOpBus] ex_aluop_i;
	wire[`AluSelBus] ex_alusel_i;
	wire[`RegBus] ex_reg1_i;
	wire[`RegBus] ex_reg2_i;
	wire ex_wreg_i;
	wire[`RegAddrBus] ex_wd_i;
	wire ex_is_in_delayslot_i;	
  wire[`RegBus] ex_link_address_i;	
	  wire[`RegBus] ex_inst_i;

	//??????��??EX?????????EX/MEM????????
	wire ex_wreg_o;
	wire[`RegAddrBus] ex_wd_o;
	wire[`RegBus] ex_wdata_o;
	wire[`AluOpBus] ex_aluop_o;
	wire[`RegBus] ex_mem_addr_o;
	wire[`RegBus] ex_reg1_o;
	wire[`RegBus] ex_reg2_o;	

	//????EX/MEM?????????????MEM????????
	wire mem_wreg_i;
	wire[`RegAddrBus] mem_wd_i;
	wire[`RegBus] mem_wdata_i;
	wire[`AluOpBus] mem_aluop_i;
	wire[`RegBus] mem_mem_addr_i;
	wire[`RegBus] mem_reg1_i;
	wire[`RegBus] mem_reg2_i;

	//????????MEM?????????MEM/WB????????
	wire mem_wreg_o;
	wire[`RegAddrBus] mem_wd_o;
	wire[`RegBus] mem_wdata_o;
	
	//????MEM/WB??????????��??��?????
	wire wb_wreg_i;
	wire[`RegAddrBus] wb_wd_i;
	wire[`RegBus] wb_wdata_i;
	
	//??????????ID???????��????Regfile???
  wire reg1_read;
  wire reg2_read;
  wire[`RegBus] reg1_data;
  wire[`RegBus] reg2_data;
  wire[`RegAddrBus] reg1_addr;
  wire[`RegAddrBus] reg2_addr;

	wire stallreq_from_id;	
	wire stallreq_from_id_o;	
	wire stallreq_from_ex;


	wire is_in_delayslot_i;
	wire is_in_delayslot_o;
	wire next_inst_in_delayslot_o;
	wire id_branch_flag_o;
	wire[`RegBus] branch_target_address;
  
  //pc_reg????
	pc_reg pc_reg0(
		.clk(clk),
		.rst(rst),
		.stall(stall),		
		.branch_flag_i(id_branch_flag_o),
		.branch_target_address_i(branch_target_address),		
		.ram_ce_o(ram_ce_o),
		.pc(pc),
		.ce(rom_ce_o)	
			
	);
	
  assign rom_addr_o = pc;

	
  //IF/ID???????
	if_id if_id0(
		.clk(clk),
		.rst(rst),
		.stall(stall),
		
		.if_pc(pc),
		.if_inst(rom_data_i),
		.id_pc(id_pc_i),
		.id_inst(id_inst_i)      	
	);
	
	//??????ID???
	id id0(
		.rst(rst),
		.pc_i(id_pc_i),
		.inst_i(id_inst_i),
		.ex_aluop_i(ex_aluop_o),

		.reg1_data_i(reg1_data),
		.reg2_data_i(reg2_data),

	  //����ִ�н׶ε�ָ��Ҫд���Ŀ�ļĴ������
		.ex_wreg_i(ex_wreg_o),
		.ex_wdata_i(ex_wdata_o),
		.ex_wd_i(ex_wd_o),

	  //���ڷô�׶ε�ָ��Ҫд���Ŀ�ļĴ�����Ϣ
		.mem_wreg_i(mem_wreg_o),
		.mem_wdata_i(mem_wdata_o),
		.mem_wd_i(mem_wd_o),

	  .is_in_delayslot_i(is_in_delayslot_i),
		//???regfile?????
		.reg1_read_o(reg1_read),
		.reg2_read_o(reg2_read), 	  

		.reg1_addr_o(reg1_addr),
		.reg2_addr_o(reg2_addr), 
	  
		//???ID/EX???????
		.aluop_o(id_aluop_o),
		.alusel_o(id_alusel_o),
		.reg1_o(id_reg1_o),
		.reg2_o(id_reg2_o),
		.wd_o(id_wd_o),
		.wreg_o(id_wreg_o),
		.inst_o(id_inst_o),
		
	 	.next_inst_in_delayslot_o(next_inst_in_delayslot_o),	
		.branch_flag_o(id_branch_flag_o),
		.branch_target_address_o(branch_target_address),       
		.link_addr_o(id_link_address_o),
		
		.is_in_delayslot_o(id_is_in_delayslot_o),

		.stallreq(stallreq_from_id_o)
	);

	wire[`RegBus] mem_out;
	assign register1={pc[10:8],tbre,tsre,mem_out[10:0]};
  //??��????Regfile????
	regfile regfile1(
		.clk (clk),
		.rst (rst),
		.we	(wb_wreg_i),
		.waddr (wb_wd_i),
		.wdata (wb_wdata_i),
		.re1 (reg1_read),
		.raddr1 (reg1_addr),
		.rdata1 (reg1_data),
		.re2 (reg2_read),
		.raddr2 (reg2_addr),
		.rdata2 (reg2_data),
		
		.register1(register2),
		.reg0(reg0),
		.reg1(reg1),
		.reg2(reg2),
		.reg3(reg3),
		.reg4(reg4),
		.reg5(reg5),
		.reg6(reg6),
		.reg7(reg7)

	);

	//ID/EX???
	id_ex id_ex0(
		.clk(clk),
		.rst(rst),
		.stall(stall),
		
		
		//????????ID??��??????
		.id_aluop(id_aluop_o),
		.id_alusel(id_alusel_o),
		.id_reg1(id_reg1_o),
		.id_reg2(id_reg2_o),
		.id_wd(id_wd_o),
		.id_wreg(id_wreg_o),
		.id_link_address(id_link_address_o),
		.id_is_in_delayslot(id_is_in_delayslot_o),
		.next_inst_in_delayslot_i(next_inst_in_delayslot_o),		
		.id_inst(id_inst_o),

		//???????��??EX???????
		.ex_aluop(ex_aluop_i),
		.ex_alusel(ex_alusel_i),
		.ex_reg1(ex_reg1_i),
		.ex_reg2(ex_reg2_i),
		.ex_wd(ex_wd_i),
		.ex_wreg(ex_wreg_i),
		.ex_link_address(ex_link_address_i),
		.ex_is_in_delayslot(ex_is_in_delayslot_i),
		.is_in_delayslot_o(is_in_delayslot_i),
		.ex_inst(ex_inst_i),
		.stallreq_i(stallreq_from_id_o),
		.stallreq_o(stallreq_from_id)
	);		
	
	//EX???
	ex ex0(
		.rst(rst),
	
		//?????��??EX???????
		.aluop_i(ex_aluop_i),
		.alusel_i(ex_alusel_i),
		.reg1_i(ex_reg1_i),
		.reg2_i(ex_reg2_i),
		.wd_i(ex_wd_i),
		.wreg_i(ex_wreg_i),
		.inst_i(ex_inst_i),

	  .link_address_i(ex_link_address_i),
		.is_in_delayslot_i(ex_is_in_delayslot_i),	  
	  
	  //EX?????????EX/MEM??????
		.wd_o(ex_wd_o),
		.wreg_o(ex_wreg_o),
		.wdata_o(ex_wdata_o),

		.aluop_o(ex_aluop_o),
		.mem_addr_o(ex_mem_addr_o),
		.reg2_o(ex_reg2_o),

		.stallreq(stallreq_from_ex)     				
		
	);

  //EX/MEM???
 wire[`RegBus] mem_mem_addr_last;
 wire[`RegBus] mem_wdata_last;

	wire tad0en;
	wire tad1en;
	wire tad2en;
	wire tad3en;
	wire[`RegBus] raddr;
	wire tchangeen;
	wire[1:0] tnexten;
	wire[`RegBus] waddr;
	wire[`RegBus] wdata;

	wire[`RegBus] rdata1;
	wire[`RegBus] rdata2;
	wire[`RegBus] rdata3;
	wire[`RegBus] rdata0;
	wire[`RegBus] tad0;
	wire[`RegBus] tad1;
	wire[`RegBus] tad2;
	wire[`RegBus] tad3;
  ex_mem ex_mem0(
		.clk(clk),
		.rst(rst),
	  .stall(stall),
	  
		.ex_aluop(ex_aluop_o),
		.ex_mem_addr(ex_mem_addr_o),
		.ex_reg2(ex_reg2_o),
		//??????��??EX???????
		.ex_wd(ex_wd_o),
		.ex_wreg(ex_wreg_o),
		.ex_wdata(ex_wdata_o),
	

		//????????MEM???????
		.mem_wd(mem_wd_i),
		.mem_wreg(mem_wreg_i),
		.mem_wdata(mem_wdata_i),

			.mem_aluop(mem_aluop_i),
		.mem_mem_addr(mem_mem_addr_i),
		.mem_reg2(mem_reg2_i),

		.mem_mem_addr_last(mem_mem_addr_last),
		.mem_wdata_last(mem_wdata_last),


	.tad0en(tad0en),
	.tad1en(tad1en),
	.tad2en(tad2en),
	.tad3en(tad3en),
	.raddr(raddr),
	.tchangeen(tchangeen),
	.waddr(waddr),
	.wdata(wdata),
.rdata1 (rdata1),
.rdata2 (rdata2),
.rdata3 (rdata3),
.rdata0 (rdata0),
.tad0 (tad0),
.tad1 (tad1),
.tad2 (tad2),
.tad3 (tad3)

						       	
	);
	
  //MEM???????
	mem mem0(
		.clk(clk),
		.rst(rst),
	
		//????EX/MEM???????
		.wd_i(mem_wd_i),
		.wreg_i(mem_wreg_i),
		.wdata_i(mem_wdata_i),

	  	.aluop_i(mem_aluop_i),
		.mem_addr_i(mem_mem_addr_i),
		.reg2_i(mem_reg2_i),
	
		//����memory����Ϣ
		.mem_data_i(ram_data_i),
		//???MEM/WB???????
		.wd_o(mem_wd_o),
		.wreg_o(mem_wreg_o),
		.wdata_o(mem_wdata_o),
			//�͵�memory����Ϣ
		.mem_addr_o(ram_addr_o),
		.mem_we_o(ram_we_o),
		.mem_data_o(ram_data_o),
		.mem_ce_o(ram_ce_o),

		.tbre(tbre),
		.tsre(tsre),
		.data_ready(data_ready),
		.wrn(wrn),
		.rdn(rdn),
		.ram1_CE(ram1_CE),
		.ram1_WE_L(ram1_WE_L),
		.ram1_OE_L(ram1_OE_L),
		.ram1datainout(ram1datainout),
		.ram1addr(ram1addr),
		.write_sig(write_sig),
		.mem_out(mem_out),

		.mem_addr_i_last(mem_mem_addr_last),
		.mem_data_i_last(mem_wdata_last),

	.tad0en(tad0en),
	.tad1en(tad1en),
	.tad2en(tad2en),
	.tad3en(tad3en),
	.raddr(raddr),
	.tchangeen(tchangeen),
	.tnexten(tnexten),
	.waddr(waddr),
	.wdata(wdata),
.rdata1 (rdata1),
.rdata2 (rdata2),
.rdata3 (rdata3),
.rdata0 (rdata0),
.tad0 (tad0),
.tad1 (tad1),
.tad2 (tad2),
.tad3 (tad3)

	);

  //MEM/WB???
	mem_wb mem_wb0(
		.clk(clk),
		.rst(rst),
    .stall(stall),

		//????????MEM???????
		.mem_wd(mem_wd_o),
		.mem_wreg(mem_wreg_o),
		.mem_wdata(mem_wdata_o),
	
		//?????��??��????
		.wb_wd(wb_wd_i),
		.wb_wreg(wb_wreg_i),
		.wb_wdata(wb_wdata_i)
									       	
	);
	wire zero;
	assign zero=`NoStop;
	ctrl ctrl0(
		.rst(rst),
	
		.stallreq_from_id(stallreq_from_id),
	
  	//??????��?��????????
		.stallreq_from_ex(stallreq_from_ex),

		.stall(stall)       	
	);

endmodule

