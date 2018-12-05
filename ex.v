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
// Module:  ex
// File:    ex.v
// Description: 执行阶段
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module ex(

	input wire rst,
	
	//送到执行阶段的信息
	input wire[`AluOpBus]         aluop_i,
	input wire[`AluSelBus]        alusel_i,
	input wire[`RegBus]           reg1_i,
	input wire[`RegBus]           reg2_i,
	input wire[`RegAddrBus]       wd_i,
	input wire                    wreg_i,
	input wire[`RegBus]           inst_i,
	

	//是否转移、以及link address
	input wire[`RegBus]           link_address_i,
	input wire                    is_in_delayslot_i,	
	
	
	output reg[`RegAddrBus]       wd_o,
	output reg                    wreg_o,
	output reg[`RegBus]		wdata_o,
	
	//下面新增的几个输出是为加载、存储指令准备的
		output wire[`AluOpBus]        aluop_o,
	output wire[`RegBus]          mem_addr_o,
	output wire[`RegBus]          reg2_o,

		output wire stallreq       
);

	reg[`RegBus] logicout;
	reg[`RegBus] shiftres;//?
	reg[`RegBus] moveres;
	reg[`RegBus] arithmeticres;
	
	wire[`RegBus] reg2_i_mux;
	wire[`RegBus] result_sum;
	
	assign reg2_i_mux = (aluop_i == `EXE_SUBU_OP) ? (~reg2_i)+1 : reg2_i;
	assign result_sum = reg1_i + reg2_i_mux;

	assign stallreq = 0;
  //aluop_o传递到访存阶段，用于加载、存储指令
  assign aluop_o = aluop_i;
  
  //mem_addr传递到访存阶段，是加载、存储指令对应的存储器地址
  assign mem_addr_o = reg1_i + {{11{inst_i[4]}},inst_i[4:0]};

  //将两个操作数也传递到访存阶段，也是为记载、存储指令准备的
  assign reg2_o = reg2_i;
			
	always @ (*) begin
		if(rst == `RstEnable) begin
			logicout <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_OR_OP:			begin
					logicout <= reg1_i | reg2_i;
				end
				`EXE_AND_OP:			begin
					logicout <= reg1_i & reg2_i;
				end
				default:				begin
					logicout <= `ZeroWord;
				end
			endcase
		end    //if
	end      //always
	always @ (*) begin
		if(rst == `RstEnable) begin
			moveres <= `ZeroWord;
		end else begin
			moveres <= `ZeroWord;
			case (aluop_i)
				`EXE_MOVE_OP:		begin
					moveres <= reg2_i;
				end
				default : begin
				end
			endcase
		end	//if
	end	//always
	always @ (*) begin
		if(rst == `RstEnable) begin
			arithmeticres <= `ZeroWord;
		end else begin
			arithmeticres <= `ZeroWord;
			case (aluop_i)
				`EXE_ADDU_OP:		begin
					arithmeticres <= result_sum;
				end
				`EXE_SUBU_OP:		begin
					arithmeticres <= result_sum;
				end
				`EXE_ADDIU_OP:		begin
					arithmeticres <= result_sum;
				end
				`EXE_ADDIU3_OP:		begin
					arithmeticres <= result_sum;
				end
				default : begin
				end
			endcase
		end	//if
	end	//always

 always @ (*) begin
	 wd_o <= wd_i;	 	 	
	 wreg_o <= wreg_i;
	 case ( alusel_i ) 
	 	`EXE_RES_LOGIC:		begin
	 		wdata_o <= logicout;
	 	end
	 	`EXE_RES_MOVE:		begin
	 		wdata_o <= moveres;
	 	end	 	
	 	`EXE_RES_JUMP_BRANCH:	begin
	 		wdata_o <= link_address_i;
	 	end
		`EXE_RES_ARITHMETIC:	begin
	 		wdata_o <= arithmeticres;
	 	end
	 	default:					begin
	 		wdata_o <= `ZeroWord;
	 	end
	 endcase
 end	
	
endmodule
