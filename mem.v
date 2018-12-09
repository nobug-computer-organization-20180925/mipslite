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
// Module:  mem
// File:    mem.v
// Description: �ô�׶�
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module mem(

	input wire clk,
	input wire	rst,
	
	//����ִ�н׶ε���Ϣ	
	input wire[`RegAddrBus]       wd_i,
	input wire                    wreg_i,
	input wire[`RegBus]				wdata_i,

	
  input wire[`AluOpBus]        aluop_i,
	input wire[`RegBus]          mem_addr_i,
	input wire[`RegBus]          reg2_i,
	
	//����memory����Ϣ
	input wire[`RegBus]          mem_data_i,
	
	
	//�͵���д�׶ε���Ϣ
	output reg[`RegAddrBus]      wd_o,
	output reg                   wreg_o,
	output reg[`RegBus]			  wdata_o,

	//���ⲿmem
		output reg[`RegBus]          mem_addr_o,
	output wire	 mem_we_o,
	output reg[`RegBus]          mem_data_o,
	output reg                   mem_ce_o	,

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
	 output reg write_sig,
	 output reg read_sig,
	 output wire[`RegBus] mem_out
	 
	
);
	
	reg[`RegBus] bf00;
	reg[`RegBus] bf00_next;
	
	
	
	wire[`RegBus] bf01;
	reg wrn_n, rdn_n;
assign wrn = ~write_sig;
assign rdn = ~read_sig;
	 assign ram1_CE = 1;
	 assign ram1_WE_L = 1;
	 assign ram1_OE_L = 1;

	 assign ram1datainout =  ((write_sig==1 | wrn_n==0)) ?  bf00_next : 16'bz;
	 assign ram1addr = 0;

	reg  mem_we;
	assign mem_we_o = mem_we ;
	

	assign bf01[0] = tbre & tsre;
	assign bf01[1] = data_ready;
	assign bf01[15:2] = 14'b0;
	reg[`RegBus] bf00_load;
	
	wire temp;
	assign temp = (mem_addr_i == 16'hbf00 ? 1 : 0);
	assign mem_out = {bf00[6:0], temp, wdata_o[7:0]};
	
	always @ (posedge clk) begin
	
		if(rst == `RstEnable) begin
		  wrn_n<=1;
		  bf00_load <= 16'h5421;
		  rdn_n<=1;
		  bf00<=16'h1245;
		end  else begin
		  wrn_n<=1;
		  rdn_n<=1;
			
			  
			//	rdn<=1;
				
			//  if(data_ready == 1'b1) begin
		//		  rdn<=0;
		//	  end
		  if(write_sig==1) begin
				  wrn_n<=0;
			end
		  bf00 <= bf00_next;
		  end
	 end

	always @ (*) begin
		if(rst == `RstEnable) begin
			wd_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
		  wdata_o <= `ZeroWord;
		  	  mem_addr_o <= `ZeroWord;
		  mem_we <= `WriteDisable;
		  mem_data_o <= `ZeroWord;
		  mem_ce_o <= `ChipDisable;
		  bf00_next<=16'h1245;
		  write_sig<=0;
		  read_sig<=0;
		end else begin
		bf00_next<=16'h1245;
		write_sig<=0;
		  read_sig<=0;
		  wd_o <= wd_i;
			wreg_o <= wreg_i;
			wdata_o <= wdata_i;
  mem_data_o <= `ZeroWord;
			mem_we <= `WriteDisable;
			mem_addr_o <= `ZeroWord;
			mem_ce_o <= `ChipDisable;
		
			case (aluop_i)
			   `EXE_LW_OP:		begin
				   if(mem_addr_i == 16'hbf00) begin
					   read_sig<=1;
					   wdata_o <= ram1datainout;
				   end else if(mem_addr_i == 16'hbf01) begin
					   wdata_o <= bf01;
				    end else begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `WriteDisable;
					wdata_o <= mem_data_i;
					mem_ce_o <= `ChipEnable;	
				    end
				end	
					`EXE_SW_OP:		begin
				   if(mem_addr_i == 16'hbf00) begin
						 bf00_next <= reg2_i;
						 write_sig<=1;
				    end else begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `WriteEnable;
					mem_data_o <= reg2_i;
					mem_ce_o <= `ChipEnable;		
				    end
				end
				default:		begin
          //ʲôҲ����
				end
			endcase		
		end    //if
	end      //always



			

endmodule
