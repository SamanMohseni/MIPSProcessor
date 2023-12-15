`timescale 1ns / 1ps

module controllUnit
#(parameter ALU_controll_unit_length = 3)
	(
	input wire [5 : 0] opcode,
	
	output reg reg_bank_read_addr_1_mux,
	output reg [1 : 0] reg_bank_write_addr_mux,
	output reg [1 : 0] reg_bank_write_data_mux,
	output reg ALU_input_1_mux,
	output reg ALU_input_2_mux,
	output reg [1 : 0] PC_in_mux,
	
	output reg branch,
	output reg reg_bank_write_enable,
	output reg main_momory_write_enable,
	output reg [ALU_controll_unit_length : 0] ALU_controll
    );
	
	localparam _add = 3'b000;
	localparam _sub = 3'b001;
	localparam _and = 3'b010;
	localparam _or = 3'b011;
	localparam _nor = 3'b100;
	localparam _SLT = 3'b101;
	localparam _other_func = 3'b111;
	
	localparam arithmetic = 1;
	localparam addI = 2;
	localparam subI = 3;
	localparam LW = 4;
	localparam SW = 5;
	localparam BNE = 6;
	localparam J = 7;
	localparam JAL = 8;
	localparam JR = 9;
	localparam JM = 10;
	localparam LDI = 11;
	
	
	always @ (*)
	begin
		case(opcode)
			arithmetic : 
			begin
				reg_bank_read_addr_1_mux = 0;
				reg_bank_write_addr_mux = 1;
				reg_bank_write_data_mux = 2;
				ALU_input_1_mux = 0;
				ALU_input_2_mux = 0;
				PC_in_mux = 0;
	
				branch = 0;
				reg_bank_write_enable = 1;
				main_momory_write_enable = 0;
				ALU_controll = _other_func;
			end
			addI : 
			begin
				reg_bank_read_addr_1_mux = 0;
				reg_bank_write_addr_mux = 0;
				reg_bank_write_data_mux = 2;
				ALU_input_1_mux = 0;
				ALU_input_2_mux = 1;
				PC_in_mux = 0;
	
				branch = 0;
				reg_bank_write_enable = 1;
				main_momory_write_enable = 0;
				ALU_controll = _add;
			end
			subI : 
			begin
				reg_bank_read_addr_1_mux = 0;
				reg_bank_write_addr_mux = 0;
				reg_bank_write_data_mux = 2;
				ALU_input_1_mux = 0;
				ALU_input_2_mux = 1;
				PC_in_mux = 0;
	
				branch = 0;
				reg_bank_write_enable = 1;
				main_momory_write_enable = 0;
				ALU_controll = _sub;
			end
			LW : 
			begin
				reg_bank_read_addr_1_mux = 0;
				reg_bank_write_addr_mux = 0;
				reg_bank_write_data_mux = 1;
				ALU_input_1_mux = 0;
				ALU_input_2_mux = 1;
				PC_in_mux = 0;
	
				branch = 0;
				reg_bank_write_enable = 1;
				main_momory_write_enable = 0;
				ALU_controll = _add;
			end
			SW : 
			begin
				reg_bank_read_addr_1_mux = 0;
				reg_bank_write_addr_mux = 2'bx;
				reg_bank_write_data_mux = 2'bx;
				ALU_input_1_mux = 0;
				ALU_input_2_mux = 1;
				PC_in_mux = 0;
	
				branch = 0;
				reg_bank_write_enable = 0;
				main_momory_write_enable = 1;
				ALU_controll = _add;
			end
			BNE : 
			begin
				reg_bank_read_addr_1_mux = 0;
				reg_bank_write_addr_mux = 2'bx;
				reg_bank_write_data_mux = 2'bx;
				ALU_input_1_mux = 0;
				ALU_input_2_mux = 0;
				PC_in_mux = 0;
	
				branch = 1;
				reg_bank_write_enable = 0;
				main_momory_write_enable = 0;
				ALU_controll = _sub;
			end
			J : 
			begin
				reg_bank_read_addr_1_mux = 1'bx;
				reg_bank_write_addr_mux = 2'bx;
				reg_bank_write_data_mux = 2'bx;
				ALU_input_1_mux = 0;
				ALU_input_2_mux = 1'bx;
				PC_in_mux = 1;
	
				branch = 1'bx;
				reg_bank_write_enable = 0;
				main_momory_write_enable = 0;
				ALU_controll = 3'bx;
			end
			JAL : 
			begin
				reg_bank_read_addr_1_mux = 1'bx;
				reg_bank_write_addr_mux = 2;
				reg_bank_write_data_mux = 0;
				ALU_input_1_mux = 0;
				ALU_input_2_mux = 1'bx;
				PC_in_mux = 1;
	
				branch = 0;
				reg_bank_write_enable = 1;
				main_momory_write_enable = 0;
				ALU_controll = 3'bx;
			end
			JR : 
			begin
				reg_bank_read_addr_1_mux = 0;
				reg_bank_write_addr_mux = 2'bx;
				reg_bank_write_data_mux = 2'bx;
				ALU_input_1_mux = 0;
				ALU_input_2_mux = 1'bx;
				PC_in_mux = 2;
	
				branch = 1'bx;
				reg_bank_write_enable = 0;
				main_momory_write_enable = 0;
				ALU_controll = 3'bx;
			end
			JM : 
			begin
				reg_bank_read_addr_1_mux = 1;
				reg_bank_write_addr_mux = 2'bx;
				reg_bank_write_data_mux = 2'bx;
				ALU_input_1_mux = 0;
				ALU_input_2_mux = 1'bx;
				PC_in_mux = 2;
	
				branch = 1'bx;
				reg_bank_write_enable = 0;
				main_momory_write_enable = 0;
				ALU_controll = 3'bx;
			end
			LDI : 
			begin
				reg_bank_read_addr_1_mux = 1'bx;
				reg_bank_write_addr_mux = 0;
				reg_bank_write_data_mux = 2;
				ALU_input_1_mux = 1;
				ALU_input_2_mux = 1;
				PC_in_mux = 0;
	
				branch = 0;
				reg_bank_write_enable = 1;
				main_momory_write_enable = 0;
				ALU_controll = _add;
			end
			default : 
			begin
				reg_bank_read_addr_1_mux = 1'bx;
				reg_bank_write_addr_mux = 2'bx;
				reg_bank_write_data_mux = 2'bx;
				ALU_input_1_mux = 0;
				ALU_input_2_mux = 1'bx;
				PC_in_mux = 0;
	
				branch = 0;
				reg_bank_write_enable = 0;
				main_momory_write_enable = 0;
				ALU_controll = 3'bx;
			end
		endcase	
	end

endmodule
