`timescale 1ns / 1ps

module InstructionMemory
#(parameter address_length = 3)
	(
	input wire [address_length - 1 : 0] read_address,
	input wire clk,
	
	output reg [31 : 0] read_data
    );
	 
	localparam number_of_registers = 2**address_length;
	
	//reg [31 : 0] memory [number_of_registers - 1 : 0];
	//initial
	//begin
		//$readmemb ("Instructions.txt", memory);
	//end
	
	always @ (*)
	begin
		case(read_address)
			0: read_data <= 32'b001011_00000_00000_0000000000001010;//LDI R0, 1010
			1: read_data <= 32'b001011_00000_00001_0000000000000001;//LDI R1, 1
			2: read_data <= 32'b000010_00001_00001_0000000000000001;//ADDI R1, R1, 1
			3: read_data <= 32'b000110_00000_00001_0111111111111111;//BNE, R0, R1, -1
			default: read_data <= 32'b0;
		endcase
	end

endmodule
