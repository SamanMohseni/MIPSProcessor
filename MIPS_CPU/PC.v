`timescale 1ns / 1ps

module PC
#(parameter input_length = 3)
	(
	input wire [input_length - 1 : 0] in,
	input wire reset,
	input wire clk, 
	input wire fast_clk,
	
	output reg [input_length - 1 : 0] out
    );
	 
	 //reg bool;
	 
always @ (posedge fast_clk, posedge clk)
begin
	if(fast_clk)
	begin
	if(reset)
	begin
		out <= 0;
		//bool <= 0;
	end
	end
	else out <= in;
end

//always @(posedge clk)
//begin
		//bool <= 1;
		//if( bool == 1)
		//begin
		//out <= in;	
		//end
//end

endmodule
