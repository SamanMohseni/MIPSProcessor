`timescale 1ns / 1ps

module mainMemory
#(parameter address_length = 3)
	(
	input wire [address_length - 1 : 0] address,
	input wire [31 : 0] write_data,
	input wire write_enable,
	input wire clk,
	
	output reg [31 : 0] read_data
    );
	
	localparam number_of_registers = 2**address_length;
	 
	reg [31 : 0] memory [number_of_registers - 1 : 0];
	 
	always @(address)
	begin
		read_data <= memory[address];
	end
		
	always @(posedge clk)
	begin
		//read_data <= memory[address];
		if(write_enable)
		begin
			memory[address] <= write_data;
		end
	end

endmodule
