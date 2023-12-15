`timescale 1ns / 1ps

module ALU
#(parameter command_length = 3)
	(
	input wire [31 : 0] input_1,
	input wire [31 : 0] input_2,
	input wire [command_length - 1 : 0] command,
	
	output reg [31 : 0] ALU_out,
	output reg zero
    );
	
	localparam _add = 3'b000;
	localparam _sub = 3'b001;
	localparam _and = 3'b010;
	localparam _or = 3'b011;
	localparam _nor = 3'b100;
	localparam _SLT = 3'b101;
	
	reg carry_out;
	
	always @(*)
	begin
		case(command)
			_add : 
			begin
				ALU_out = input_1 + input_2;
			end
			_sub :
			begin
				{carry_out, ALU_out} = input_1 - input_2 + 33'b0;
			end
			_and :
			begin
				ALU_out = input_1 & input_2;
			end
			_or :
			begin
				ALU_out = (input_1 | input_2);
			end
			_nor :
			begin
				ALU_out = ~ (input_1 | input_2);
			end
			_SLT :
			begin
				ALU_out = (input_1 < input_2);
			end
			default:
			begin
				ALU_out = 0;
			end
				
		endcase
	end
	
	always @(*)
	begin
		if(carry_out == 0 && ALU_out == 0)
			zero = 1;
		else
			zero = 0;
	end

endmodule
