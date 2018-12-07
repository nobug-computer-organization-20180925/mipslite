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
`timescale 1ns/10ps

module openmips_min_sopc_tb();

  reg     CLOCK_50;
  reg     rst;

	wire[`RegBus] register1;
	reg tbre,tsre,data_ready;
	wire wrn,rdn;
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
	 tbre = 1;
	 tsre = 1;
	 data_ready = 0;
    #195 rst= `RstDisable;
    #4100 $stop;
	 
  end
       
  openmips_min_sopc openmips_min_sopc0(
		.clk(CLOCK_50),
		.rst(rst),
		.register1(register1),
		.tbre(tbre),
		.tsre(tsre),
		.data_ready(data_ready),
	.ram1_WE_L(ram1_WE_L),
   .ram2_WE_L(ram2_WE_L),
   .ram1_OE_L(ram1_OE_L),
   .ram2_OE_L(ram2_OE_L),
	.ram1_CE(ram1_CE),
   .ram2_CE(ram2_CE), 
	.ram1datainout(ram1datainout),
   .ram2datainout(ram2datainout),
	 
	.ram1addr(ram1addr),
	.ram2addr(ram2addr),
	.wrn(wrn),
	.rdn(rdn)
	);
	reg[`DataBus]  data_mem[0:`DataMemNum-1];
	wire[`DataBus] databf00;
	assign databf00 = data_mem[16'hbf00];
	wire[`DataBus] databf01;
	assign databf01 = data_mem[16'hbf01];	
	wire[`DataBus] mem_read;
	reg[`DataBus] data_o;
	assign mem_read = data_mem[ram2addr];
	assign ram2datainout = ram2_OE_L ? 16'bz : data_o;
	integer i;
	always @(negedge rst) begin
	data_mem[0]<=16'h0000;
data_mem[1]<=16'h0000;
data_mem[2]<=16'h0800;
data_mem[3]<=16'h1061;
data_mem[4]<=16'h0800;
data_mem[5]<=16'h0800;
data_mem[6]<=16'h0800;
data_mem[7]<=16'h0800;
data_mem[8]<=16'h6ebf;
data_mem[9]<=16'h36c0;
data_mem[10]<=16'h4e10;
data_mem[11]<=16'hde00;
data_mem[12]<=16'hde21;
data_mem[13]<=16'hde42;
data_mem[14]<=16'hde84;
data_mem[15]<=16'hdea5;
data_mem[16]<=16'h9100;
data_mem[17]<=16'h6301;
data_mem[18]<=16'h68ff;
data_mem[19]<=16'he90c;
data_mem[20]<=16'h9200;
data_mem[21]<=16'h6301;
data_mem[22]<=16'h63ff;
data_mem[23]<=16'hd300;
data_mem[24]<=16'h63ff;
data_mem[25]<=16'hd700;
data_mem[26]<=16'h6b0f;
data_mem[27]<=16'hef40;
data_mem[28]<=16'h4f03;
data_mem[29]<=16'h0800;
data_mem[30]<=16'h10ac;
data_mem[31]<=16'h0800;
data_mem[32]<=16'h6ebf;
data_mem[33]<=16'h36c0;
data_mem[34]<=16'hde60;
data_mem[35]<=16'h0800;
data_mem[36]<=16'h6ebf;
data_mem[37]<=16'h36c0;
data_mem[38]<=16'h4e10;
data_mem[39]<=16'h6800;
data_mem[40]<=16'he82a;
data_mem[41]<=16'h6102;
data_mem[42]<=16'h0800;
data_mem[43]<=16'h9e87;
data_mem[44]<=16'h6820;
data_mem[45]<=16'he82a;
data_mem[46]<=16'h6102;
data_mem[47]<=16'h0800;
data_mem[48]<=16'h9e88;
data_mem[49]<=16'h6810;
data_mem[50]<=16'he82a;
data_mem[51]<=16'h6102;
data_mem[52]<=16'h0800;
data_mem[53]<=16'h9e89;
data_mem[54]<=16'h0800;
data_mem[55]<=16'h9ea6;
data_mem[56]<=16'heca2;
data_mem[57]<=16'h610b;
data_mem[58]<=16'h0800;
data_mem[59]<=16'hde86;
data_mem[60]<=16'hef40;
data_mem[61]<=16'h4f03;
data_mem[62]<=16'h0800;
data_mem[63]<=16'h108b;
data_mem[64]<=16'h0800;
data_mem[65]<=16'h6ebf;
data_mem[66]<=16'h36c0;
data_mem[67]<=16'hde20;
data_mem[68]<=16'h0800;
data_mem[69]<=16'h0800;
data_mem[70]<=16'h6b0f;
data_mem[71]<=16'hef40;
data_mem[72]<=16'h4f03;
data_mem[73]<=16'h0800;
data_mem[74]<=16'h1080;
data_mem[75]<=16'h0800;
data_mem[76]<=16'h6ebf;
data_mem[77]<=16'h36c0;
data_mem[78]<=16'hde60;
data_mem[79]<=16'h0800;
data_mem[80]<=16'h42c0;
data_mem[81]<=16'hf300;
data_mem[82]<=16'h6880;
data_mem[83]<=16'h3000;
data_mem[84]<=16'heb0d;
data_mem[85]<=16'h6fbf;
data_mem[86]<=16'h37e0;
data_mem[87]<=16'h4f10;
data_mem[88]<=16'h9f00;
data_mem[89]<=16'h9f21;
data_mem[90]<=16'h9f42;
data_mem[91]<=16'h9f84;
data_mem[92]<=16'h9fa5;
data_mem[93]<=16'h9700;
data_mem[94]<=16'h6301;
data_mem[95]<=16'h6301;
data_mem[96]<=16'h0800;
data_mem[97]<=16'hf301;
data_mem[98]<=16'hee00;
data_mem[99]<=16'h93ff;
data_mem[100]<=16'h0800;
data_mem[101]<=16'h6807;
data_mem[102]<=16'hf001;
data_mem[103]<=16'h68bf;
data_mem[104]<=16'h3000;
data_mem[105]<=16'h4810;
data_mem[106]<=16'h6400;
data_mem[107]<=16'h0800;
data_mem[108]<=16'h6ebf;
data_mem[109]<=16'h36c0;
data_mem[110]<=16'h4e10;
data_mem[111]<=16'h6800;
data_mem[112]<=16'hde00;
data_mem[113]<=16'hde01;
data_mem[114]<=16'hde02;
data_mem[115]<=16'hde03;
data_mem[116]<=16'hde04;
data_mem[117]<=16'hde05;
data_mem[118]<=16'hde06;
data_mem[119]<=16'h4801;
data_mem[120]<=16'hde07;
data_mem[121]<=16'h4801;
data_mem[122]<=16'hde08;
data_mem[123]<=16'h4801;
data_mem[124]<=16'hde09;
data_mem[125]<=16'hef40;
data_mem[126]<=16'h4f03;
data_mem[127]<=16'h0800;
data_mem[128]<=16'h104a;
data_mem[129]<=16'h6ebf;
data_mem[130]<=16'h36c0;
data_mem[131]<=16'h684f;
data_mem[132]<=16'hde00;
data_mem[133]<=16'h0800;
data_mem[134]<=16'hef40;
data_mem[135]<=16'h4f03;
data_mem[136]<=16'h0800;
data_mem[137]<=16'h1041;
data_mem[138]<=16'h6ebf;
data_mem[139]<=16'h36c0;
data_mem[140]<=16'h684b;
data_mem[141]<=16'hde00;
data_mem[142]<=16'h0800;
data_mem[143]<=16'hef40;
data_mem[144]<=16'h4f03;
data_mem[145]<=16'h0800;
data_mem[146]<=16'h1038;
data_mem[147]<=16'h6ebf;
data_mem[148]<=16'h36c0;
data_mem[149]<=16'h680a;
data_mem[150]<=16'hde00;
data_mem[151]<=16'h0800;
data_mem[152]<=16'hef40;
data_mem[153]<=16'h4f03;
data_mem[154]<=16'h0800;
data_mem[155]<=16'h102f;
data_mem[156]<=16'h6ebf;
data_mem[157]<=16'h36c0;
data_mem[158]<=16'h680d;
data_mem[159]<=16'hde00;
data_mem[160]<=16'h0800;
data_mem[161]<=16'hef40;
data_mem[162]<=16'h4f03;
data_mem[163]<=16'h0800;
data_mem[164]<=16'h1031;
data_mem[165]<=16'h0800;
data_mem[166]<=16'h6ebf;
data_mem[167]<=16'h36c0;
data_mem[168]<=16'h9e20;
data_mem[169]<=16'h6eff;
data_mem[170]<=16'he9cc;
data_mem[171]<=16'h0800;
data_mem[172]<=16'h6852;
data_mem[173]<=16'he82a;
data_mem[174]<=16'h6032;
data_mem[175]<=16'h0800;
data_mem[176]<=16'h6844;
data_mem[177]<=16'he82a;
data_mem[178]<=16'h604d;
data_mem[179]<=16'h0800;
data_mem[180]<=16'h6841;
data_mem[181]<=16'he82a;
data_mem[182]<=16'h600e;
data_mem[183]<=16'h0800;
data_mem[184]<=16'h6855;
data_mem[185]<=16'he82a;
data_mem[186]<=16'h6007;
data_mem[187]<=16'h0800;
data_mem[188]<=16'h6847;
data_mem[189]<=16'he82a;
data_mem[190]<=16'h6009;
data_mem[191]<=16'h0800;
data_mem[192]<=16'h17e0;
data_mem[193]<=16'h0800;
data_mem[194]<=16'h0800;
data_mem[195]<=16'h10c0;
data_mem[196]<=16'h0800;
data_mem[197]<=16'h0800;
data_mem[198]<=16'h1082;
data_mem[199]<=16'h0800;
data_mem[200]<=16'h0800;
data_mem[201]<=16'h1103;
data_mem[202]<=16'h0800;
data_mem[203]<=16'h0800;
data_mem[204]<=16'h6ebf;
data_mem[205]<=16'h36c0;
data_mem[206]<=16'h4e01;
data_mem[207]<=16'h9e00;
data_mem[208]<=16'h6e01;
data_mem[209]<=16'he8cc;
data_mem[210]<=16'h20f8;
data_mem[211]<=16'h0800;
data_mem[212]<=16'hef00;
data_mem[213]<=16'h0800;
data_mem[214]<=16'h0800;
data_mem[215]<=16'h6ebf;
data_mem[216]<=16'h36c0;
data_mem[217]<=16'h4e01;
data_mem[218]<=16'h9e00;
data_mem[219]<=16'h6e02;
data_mem[220]<=16'he8cc;
data_mem[221]<=16'h20f8;
data_mem[222]<=16'h0800;
data_mem[223]<=16'hef00;
data_mem[224]<=16'h0800;
data_mem[225]<=16'h6906;
data_mem[226]<=16'h6a06;
data_mem[227]<=16'h68bf;
data_mem[228]<=16'h3000;
data_mem[229]<=16'h4810;
data_mem[230]<=16'he22f;
data_mem[231]<=16'he061;
data_mem[232]<=16'h9860;
data_mem[233]<=16'hef40;
data_mem[234]<=16'h4f03;
data_mem[235]<=16'h0800;
data_mem[236]<=16'h17de;
data_mem[237]<=16'h0800;
data_mem[238]<=16'h6ebf;
data_mem[239]<=16'h36c0;
data_mem[240]<=16'hde60;
data_mem[241]<=16'h3363;
data_mem[242]<=16'hef40;
data_mem[243]<=16'h4f03;
data_mem[244]<=16'h0800;
data_mem[245]<=16'h17d5;
data_mem[246]<=16'h0800;
data_mem[247]<=16'h6ebf;
data_mem[248]<=16'h36c0;
data_mem[249]<=16'hde60;
data_mem[250]<=16'h49ff;
data_mem[251]<=16'h0800;
data_mem[252]<=16'h29e6;
data_mem[253]<=16'h0800;
data_mem[254]<=16'h17a2;
data_mem[255]<=16'h0800;
data_mem[256]<=16'hef40;
data_mem[257]<=16'h4f03;
data_mem[258]<=16'h0800;
data_mem[259]<=16'h17d2;
data_mem[260]<=16'h0800;
data_mem[261]<=16'h6ebf;
data_mem[262]<=16'h36c0;
data_mem[263]<=16'h9ea0;
data_mem[264]<=16'h6eff;
data_mem[265]<=16'hedcc;
data_mem[266]<=16'h0800;
data_mem[267]<=16'hef40;
data_mem[268]<=16'h4f03;
data_mem[269]<=16'h0800;
data_mem[270]<=16'h17c7;
data_mem[271]<=16'h0800;
data_mem[272]<=16'h6ebf;
data_mem[273]<=16'h36c0;
data_mem[274]<=16'h9e20;
data_mem[275]<=16'h6eff;
data_mem[276]<=16'he9cc;
data_mem[277]<=16'h0800;
data_mem[278]<=16'h3120;
data_mem[279]<=16'he9ad;
data_mem[280]<=16'hef40;
data_mem[281]<=16'h4f03;
data_mem[282]<=16'h0800;
data_mem[283]<=16'h17ba;
data_mem[284]<=16'h0800;
data_mem[285]<=16'h6ebf;
data_mem[286]<=16'h36c0;
data_mem[287]<=16'h9ea0;
data_mem[288]<=16'h6eff;
data_mem[289]<=16'hedcc;
data_mem[290]<=16'h0800;
data_mem[291]<=16'hef40;
data_mem[292]<=16'h4f03;
data_mem[293]<=16'h0800;
data_mem[294]<=16'h17af;
data_mem[295]<=16'h0800;
data_mem[296]<=16'h6ebf;
data_mem[297]<=16'h36c0;
data_mem[298]<=16'h9e40;
data_mem[299]<=16'h6eff;
data_mem[300]<=16'heacc;
data_mem[301]<=16'h0800;
data_mem[302]<=16'h3240;
data_mem[303]<=16'heaad;
data_mem[304]<=16'h9960;
data_mem[305]<=16'hef40;
data_mem[306]<=16'h4f03;
data_mem[307]<=16'h0800;
data_mem[308]<=16'h1796;
data_mem[309]<=16'h0800;
data_mem[310]<=16'h6ebf;
data_mem[311]<=16'h36c0;
data_mem[312]<=16'hde60;
data_mem[313]<=16'h3363;
data_mem[314]<=16'hef40;
data_mem[315]<=16'h4f03;
data_mem[316]<=16'h0800;
data_mem[317]<=16'h178d;
data_mem[318]<=16'h0800;
data_mem[319]<=16'h6ebf;
data_mem[320]<=16'h36c0;
data_mem[321]<=16'hde60;
data_mem[322]<=16'h4901;
data_mem[323]<=16'h4aff;
data_mem[324]<=16'h0800;
data_mem[325]<=16'h2aea;
data_mem[326]<=16'h0800;
data_mem[327]<=16'h1759;
data_mem[328]<=16'h0800;
data_mem[329]<=16'hef40;
data_mem[330]<=16'h4f03;
data_mem[331]<=16'h0800;
data_mem[332]<=16'h1789;
data_mem[333]<=16'h0800;
data_mem[334]<=16'h6ebf;
data_mem[335]<=16'h36c0;
data_mem[336]<=16'h9ea0;
data_mem[337]<=16'h6eff;
data_mem[338]<=16'hedcc;
data_mem[339]<=16'h0800;
data_mem[340]<=16'hef40;
data_mem[341]<=16'h4f03;
data_mem[342]<=16'h0800;
data_mem[343]<=16'h177e;
data_mem[344]<=16'h0800;
data_mem[345]<=16'h6ebf;
data_mem[346]<=16'h36c0;
data_mem[347]<=16'h9e20;
data_mem[348]<=16'h6eff;
data_mem[349]<=16'he9cc;
data_mem[350]<=16'h0800;
data_mem[351]<=16'h3120;
data_mem[352]<=16'he9ad;
data_mem[353]<=16'h6800;
data_mem[354]<=16'he82a;
data_mem[355]<=16'h601d;
data_mem[356]<=16'h0800;
data_mem[357]<=16'hef40;
data_mem[358]<=16'h4f03;
data_mem[359]<=16'h0800;
data_mem[360]<=16'h176d;
data_mem[361]<=16'h0800;
data_mem[362]<=16'h6ebf;
data_mem[363]<=16'h36c0;
data_mem[364]<=16'h9ea0;
data_mem[365]<=16'h6eff;
data_mem[366]<=16'hedcc;
data_mem[367]<=16'h0800;
data_mem[368]<=16'hef40;
data_mem[369]<=16'h4f03;
data_mem[370]<=16'h0800;
data_mem[371]<=16'h1762;
data_mem[372]<=16'h0800;
data_mem[373]<=16'h6ebf;
data_mem[374]<=16'h36c0;
data_mem[375]<=16'h9e40;
data_mem[376]<=16'h6eff;
data_mem[377]<=16'heacc;
data_mem[378]<=16'h0800;
data_mem[379]<=16'h3240;
data_mem[380]<=16'heaad;
data_mem[381]<=16'hd940;
data_mem[382]<=16'h0800;
data_mem[383]<=16'h17c9;
data_mem[384]<=16'h0800;
data_mem[385]<=16'h0800;
data_mem[386]<=16'h171e;
data_mem[387]<=16'h0800;
data_mem[388]<=16'hef40;
data_mem[389]<=16'h4f03;
data_mem[390]<=16'h0800;
data_mem[391]<=16'h174e;
data_mem[392]<=16'h0800;
data_mem[393]<=16'h6ebf;
data_mem[394]<=16'h36c0;
data_mem[395]<=16'h9ea0;
data_mem[396]<=16'h6eff;
data_mem[397]<=16'hedcc;
data_mem[398]<=16'h0800;
data_mem[399]<=16'hef40;
data_mem[400]<=16'h4f03;
data_mem[401]<=16'h0800;
data_mem[402]<=16'h1743;
data_mem[403]<=16'h0800;
data_mem[404]<=16'h6ebf;
data_mem[405]<=16'h36c0;
data_mem[406]<=16'h9e20;
data_mem[407]<=16'h6eff;
data_mem[408]<=16'he9cc;
data_mem[409]<=16'h0800;
data_mem[410]<=16'h3120;
data_mem[411]<=16'he9ad;
data_mem[412]<=16'hef40;
data_mem[413]<=16'h4f03;
data_mem[414]<=16'h0800;
data_mem[415]<=16'h1736;
data_mem[416]<=16'h0800;
data_mem[417]<=16'h6ebf;
data_mem[418]<=16'h36c0;
data_mem[419]<=16'h9ea0;
data_mem[420]<=16'h6eff;
data_mem[421]<=16'hedcc;
data_mem[422]<=16'h0800;
data_mem[423]<=16'hef40;
data_mem[424]<=16'h4f03;
data_mem[425]<=16'h0800;
data_mem[426]<=16'h172b;
data_mem[427]<=16'h0800;
data_mem[428]<=16'h6ebf;
data_mem[429]<=16'h36c0;
data_mem[430]<=16'h9e40;
data_mem[431]<=16'h6eff;
data_mem[432]<=16'heacc;
data_mem[433]<=16'h0800;
data_mem[434]<=16'h3240;
data_mem[435]<=16'heaad;
data_mem[436]<=16'h9960;
data_mem[437]<=16'hef40;
data_mem[438]<=16'h4f03;
data_mem[439]<=16'h0800;
data_mem[440]<=16'h1712;
data_mem[441]<=16'h0800;
data_mem[442]<=16'h6ebf;
data_mem[443]<=16'h36c0;
data_mem[444]<=16'hde60;
data_mem[445]<=16'h3363;
data_mem[446]<=16'hef40;
data_mem[447]<=16'h4f03;
data_mem[448]<=16'h0800;
data_mem[449]<=16'h1709;
data_mem[450]<=16'h0800;
data_mem[451]<=16'h6ebf;
data_mem[452]<=16'h36c0;
data_mem[453]<=16'hde60;
data_mem[454]<=16'h4901;
data_mem[455]<=16'h4aff;
data_mem[456]<=16'h0800;
data_mem[457]<=16'h2aea;
data_mem[458]<=16'h0800;
data_mem[459]<=16'h16d5;
data_mem[460]<=16'h0800;
data_mem[461]<=16'hef40;
data_mem[462]<=16'h4f03;
data_mem[463]<=16'h0800;
data_mem[464]<=16'h1705;
data_mem[465]<=16'h0800;
data_mem[466]<=16'h6ebf;
data_mem[467]<=16'h36c0;
data_mem[468]<=16'h9ea0;
data_mem[469]<=16'h6eff;
data_mem[470]<=16'hedcc;
data_mem[471]<=16'h0800;
data_mem[472]<=16'hef40;
data_mem[473]<=16'h4f03;
data_mem[474]<=16'h0800;
data_mem[475]<=16'h16fa;
data_mem[476]<=16'h0800;
data_mem[477]<=16'h6ebf;
data_mem[478]<=16'h36c0;
data_mem[479]<=16'h9e40;
data_mem[480]<=16'h6eff;
data_mem[481]<=16'heacc;
data_mem[482]<=16'h0800;
data_mem[483]<=16'h3240;
data_mem[484]<=16'heaad;
data_mem[485]<=16'h42c0;
data_mem[486]<=16'h6fbf;
data_mem[487]<=16'h37e0;
data_mem[488]<=16'h4f10;
data_mem[489]<=16'h9fa5;
data_mem[490]<=16'h63ff;
data_mem[491]<=16'hd500;
data_mem[492]<=16'hf500;
data_mem[493]<=16'h6980;
data_mem[494]<=16'h3120;
data_mem[495]<=16'hed2d;
data_mem[496]<=16'h9f00;
data_mem[497]<=16'h9f21;
data_mem[498]<=16'h9f42;
data_mem[499]<=16'h9f63;
data_mem[500]<=16'h9f84;
data_mem[501]<=16'hef40;
data_mem[502]<=16'h4f04;
data_mem[503]<=16'hf501;
data_mem[504]<=16'hee00;
data_mem[505]<=16'h9500;
data_mem[506]<=16'h0800;
data_mem[507]<=16'h0800;
data_mem[508]<=16'h6301;
data_mem[509]<=16'h6fbf;
data_mem[510]<=16'h37e0;
data_mem[511]<=16'h4f10;
data_mem[512]<=16'hdf00;
data_mem[513]<=16'hdf21;
data_mem[514]<=16'hdf42;
data_mem[515]<=16'hdf63;
data_mem[516]<=16'hdf84;
data_mem[517]<=16'hdfa5;
data_mem[518]<=16'hf000;
data_mem[519]<=16'h697f;
data_mem[520]<=16'h3120;
data_mem[521]<=16'h6aff;
data_mem[522]<=16'he94d;
data_mem[523]<=16'he82c;
data_mem[524]<=16'hf001;
data_mem[525]<=16'h6907;
data_mem[526]<=16'hef40;
data_mem[527]<=16'h4f03;
data_mem[528]<=16'h0800;
data_mem[529]<=16'h16b9;
data_mem[530]<=16'h0800;
data_mem[531]<=16'h6ebf;
data_mem[532]<=16'h36c0;
data_mem[533]<=16'hde20;
data_mem[534]<=16'h168a;
data_mem[535]<=16'h0800;
data_mem[16'hbf00]<=16'h1234;
data_mem[16'hbf01]<=16'h0001;

	end
	
	
	
	always @ (posedge ram2_WE_L) begin
		if (ram2_CE == `ChipEnable) begin
			//data_o <= ZeroWord;
		end else if(ram2_OE_L == `WriteEnable) begin
		      data_mem[ram2addr] <= ram2datainout;
		end
	end
	
	always @ (*) begin
		if (ram2_CE == `ChipEnable) begin
			data_o <= `ZeroWord;
	  end else if(ram2_OE_L == `WriteDisable) begin
		    data_o <= mem_read;
		end else begin
				data_o <= `ZeroWord;
		end
	end		

endmodule
