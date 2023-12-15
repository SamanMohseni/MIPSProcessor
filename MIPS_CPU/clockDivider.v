`timescale 1ns / 1ps

module clockDivider
#(parameter divide_factor = 20_000_000)
	(
	input wire clk,
	input wire reset,
	
	output reg divided_clk
    );
	
	localparam number_of_bits = log2(divide_factor + 1);
	
	reg [number_of_bits - 1 : 0] count;
	
	always @(posedge clk)
	begin
		if(reset)
		begin
			count <= 0;
			divided_clk <= 0;
		end
		else
		begin
			count <= count + 1;
			if(count == divide_factor)
			begin
				count <= 0;
				divided_clk <= ~divided_clk;
			end
		end
	end
	
	function integer log2(input integer n);
		integer i;
	begin
	log2 = 1;
		for (i = 0; 2**i < n; i = i + 1)
			log2 = i + 1;
		end 
	endfunction 

endmodule
