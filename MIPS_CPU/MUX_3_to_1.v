`timescale 1ns / 1ps

module MUX_3_to_1
#(parameter data_length = 32)
	(
	input wire [data_length - 1 : 0] input_1,
	input wire [data_length - 1 : 0] input_2,
	input wire [data_length - 1 : 0] input_3,
	input wire [1 : 0] select,
	
	output reg [data_length - 1 : 0] out
    );
	
	always @(*)
	begin
		case(select)
			0 : out = input_1;
			1 : out = input_2;
			default : out = input_3;
		endcase
	end

endmodule
