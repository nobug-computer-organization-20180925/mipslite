`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:45:26 12/07/2018 
// Design Name: 
// Module Name:    sevenseg 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sevenseg(
	input wire[3:0] pc,
	output wire[6:0] pc_out
    );
	 reg[6:0] LED_out;
	 reg[6:0] pc_7;
	 
	 always @(*) begin
		case(pc)
		     4'b0000: LED_out = 7'b0000001; // "0"  
            4'b0001: LED_out = 7'b1001111; // "1" 
            4'b0010: LED_out = 7'b0010010; // "2" 
            4'b0011: LED_out = 7'b0000110; // "3" 
            4'b0100: LED_out = 7'b1001100; // "4" 
            4'b0101: LED_out = 7'b0100100; // "5" 
            4'b0110: LED_out = 7'b0100000; // "6" 
            4'b0111: LED_out = 7'b0001111; // "7" 
            4'b1000: LED_out = 7'b0000000; // "8"  
            4'b1001: LED_out = 7'b0000100; // "9" 
            default: LED_out = 7'b1111111; // "0"
			endcase
			case(pc)
			4'b1010: pc_7=7'b0000100;
			4'b1011: pc_7=7'b0110000;
			4'b1100: pc_7=7'b1011000;
			4'b1101: pc_7=7'b0100001;
			4'b1110: pc_7=7'b0011000;
			4'b1111: pc_7=7'b0001110;
			default: pc_7=7'b0000000;
		endcase
		end
	assign pc_out = pc_7 | ~LED_out;
	
endmodule