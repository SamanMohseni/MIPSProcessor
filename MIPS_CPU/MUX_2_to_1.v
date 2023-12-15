`timescale 1ns / 1ps

module MUX_2_to_1
#(parameter data_length = 32)
	(
	input wire [data_length - 1 : 0] input_1,
	input wire [data_length - 1 : 0] input_2,
	input wire  select,
	
	output reg [data_length - 1 : 0] out
    );
	
	always @(*)
	begin
		if(select)
			out = input_2;
		else
			out = input_1;
	end

endmodule
