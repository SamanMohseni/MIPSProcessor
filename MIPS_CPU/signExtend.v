`timescale 1ns / 1ps

module signExtend(
	input wire [15 : 0] in,
	
	output reg [31 : 0] out
    );
	
	integer i;
	
	always @(*)
		begin
			for(i = 31; i > 15; i = i - 1)
			begin
				out[i] = in[15];
				out[i - 16] = in[i - 16];
			end
		end
endmodule
