`timescale 1ns / 1ps

module registerBank
#(parameter address_length = 3)
	(
	input wire [address_length - 1 : 0] read_address_1,
	input wire [address_length - 1 : 0] read_address_2,
	input wire [address_length - 1 : 0] write_address,
	input wire [31 : 0] write_data,
	input wire write_enable, 
	input wire clk,
	
	output reg [31 : 0] read_data_1,
	output reg [31 : 0] read_data_2
    );
	
	localparam number_of_registers = 2**address_length;
	
	reg [31 : 0] memory [number_of_registers - 1 : 0];
	
	always @ (read_address_1, read_address_2)
	begin
		read_data_1 <= memory[read_address_1];
		read_data_2 <= memory[read_address_2];
	end
	
	always @ (posedge clk)
	begin
		if(write_enable)
		begin
			memory[write_address] <= write_data;
		end
	end
	
endmodule
