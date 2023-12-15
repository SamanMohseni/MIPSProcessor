`timescale 1ns / 1ps

module ALUControll
#(parameter ALU_controll_unit_length = 3, ALU_command_length = 3)
	(
	input wire [ALU_command_length - 1 : 0] input_func,
	input wire [ALU_controll_unit_length - 1 : 0] command,
	
	output reg [ALU_command_length - 1 : 0] output_func
    );
	
	localparam _other_func = 3'b111;
	
	always @ (*)
	begin
		if(command == _other_func)
			output_func = input_func;
		else
			output_func = command;
	end

endmodule
