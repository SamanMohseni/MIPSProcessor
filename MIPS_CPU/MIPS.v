`timescale 1ns / 1ps

module MIPS( 
	input wire clock,
	input wire reset,
	
	output wire [31 : 0] mips_alu_out
    );
	
	localparam CLOCK_DIVIDE_FACTOR = 11000000;
	localparam PC_INPUT_LENGTH = 3;
	localparam REGISTER_BANK_ADDRESS_LENGTH = 3;
	localparam ALU_CONTROLL_UNIT_LENGTH = 3;
	localparam ALU_COMMAND_LENGTH = 3;
	localparam MAIN_MEMORY_ADDRESS_LENGTH = 3;
	
	wire clk;
	clockDivider #(.divide_factor(CLOCK_DIVIDE_FACTOR)) clock_divider(.clk(clock), .reset(reset), .divided_clk(clk));
	
	
	wire [PC_INPUT_LENGTH - 1 : 0] PC_in_mux_out;
	wire [PC_INPUT_LENGTH - 1 : 0] pc_out;
	PC #(.input_length(PC_INPUT_LENGTH)) pc(.in(PC_in_mux_out), .reset(reset), .clk(clk), .fast_clk(clock), .out(pc_out));
	
	wire [31 : 0] instruction_memory_read_data;
	InstructionMemory #(.address_length(PC_INPUT_LENGTH)) instruction_memory(.read_address(pc_out), .clk(clk), .read_data(instruction_memory_read_data));
	
	wire controll_unit_register_bank_read_address_1_mux;
	wire [1 : 0] controll_unit_register_bank_write_address_mux;
	wire [1 : 0] controll_unit_register_bank_write_data_mux;
	wire controll_unit_ALU_input_1_mux;
	wire controll_unit_ALU_input_2_mux;
	wire [1 : 0] controll_unit_PC_in_mux;
	wire controll_unit_branch;
	wire controll_unit_regiter_bank_write_enable;
	wire controll_unit_main_momory_write_enable;
	wire [ALU_CONTROLL_UNIT_LENGTH : 0] controll_unit_ALU_controll;
	controllUnit #(.ALU_controll_unit_length(ALU_CONTROLL_UNIT_LENGTH)) controll_unit(
		.opcode(instruction_memory_read_data[31 : 26]),
		.reg_bank_read_addr_1_mux(controll_unit_register_bank_read_address_1_mux),
		.reg_bank_write_addr_mux(controll_unit_register_bank_write_address_mux),
		.reg_bank_write_data_mux(controll_unit_register_bank_write_data_mux),
		.ALU_input_1_mux(controll_unit_ALU_input_1_mux),
		.ALU_input_2_mux(controll_unit_ALU_input_2_mux),
		.PC_in_mux(controll_unit_PC_in_mux),
		.branch(controll_unit_branch),
		.reg_bank_write_enable(controll_unit_regiter_bank_write_enable),
		.main_momory_write_enable(controll_unit_main_momory_write_enable),
		.ALU_controll(controll_unit_ALU_controll));
	
	wire [REGISTER_BANK_ADDRESS_LENGTH - 1 : 0] register_bank_read_address_1_mux_out;
	MUX_2_to_1 #(.data_length(REGISTER_BANK_ADDRESS_LENGTH)) register_bank_read_address_1_mux(
		.input_1(instruction_memory_read_data[REGISTER_BANK_ADDRESS_LENGTH + 20 : 21]), 
		.input_2(3'b111), 
		.select(controll_unit_register_bank_read_address_1_mux), 
		.out(register_bank_read_address_1_mux_out));
	
	wire [REGISTER_BANK_ADDRESS_LENGTH - 1 : 0] register_bank_write_address_mux_out;
	MUX_3_to_1 #(.data_length(REGISTER_BANK_ADDRESS_LENGTH)) register_bank_write_address_mux(
		.input_1(instruction_memory_read_data[REGISTER_BANK_ADDRESS_LENGTH + 15 : 16]),
		.input_2(instruction_memory_read_data[REGISTER_BANK_ADDRESS_LENGTH + 10 : 11]),
		.input_3(3'b111),
		.select(controll_unit_register_bank_write_address_mux),
		.out(register_bank_write_address_mux_out));
	
	wire [PC_INPUT_LENGTH - 1 : 0] adder_out;
	wire [31 : 0] main_momory_read_data;
	wire [31 : 0] ALU_out;
	
	wire [31 : 0] register_bank_write_data_mux_out;
	MUX_3_to_1 #(.data_length(32)) register_bank_write_data_mux(
		.input_1(adder_out),
		.input_2(main_momory_read_data),
		.input_3(ALU_out),
		.select(controll_unit_register_bank_write_data_mux),
		.out(register_bank_write_data_mux_out));
	
	wire [31 : 0] register_bank_read_data_1;
	wire [31 : 0] register_bank_read_data_2;
	registerBank #(.address_length(REGISTER_BANK_ADDRESS_LENGTH)) register_bank(
		.read_address_1(register_bank_read_address_1_mux_out),
		.read_address_2(instruction_memory_read_data[REGISTER_BANK_ADDRESS_LENGTH + 15 : 16]),
		.write_address(register_bank_write_address_mux_out),
		.write_data(register_bank_write_data_mux_out),
		.write_enable(controll_unit_regiter_bank_write_enable), 
		.clk(clk),
		.read_data_1(register_bank_read_data_1),
		.read_data_2(register_bank_read_data_2));
	
	wire [31 : 0] sign_extend_out;
	signExtend sign_extend(.in(instruction_memory_read_data[15 : 0]), .out(sign_extend_out));
	
	wire [31 : 0] ALU_input_1_mux_out;
	MUX_2_to_1 #(.data_length(32)) ALU_input_1_mux(
		.input_1(register_bank_read_data_1), 
		.input_2(32'b0), 
		.select(controll_unit_ALU_input_1_mux), 
		.out(ALU_input_1_mux_out));
	
	wire [31 : 0] ALU_input_2_mux_out;
	MUX_2_to_1 #(.data_length(32)) ALU_input_2_mux(
		.input_1(register_bank_read_data_2), 
		.input_2(sign_extend_out), 
		.select(controll_unit_ALU_input_2_mux), 
		.out(ALU_input_2_mux_out));
		
	wire [ALU_CONTROLL_UNIT_LENGTH - 1 : 0] ALU_controll_out;
	ALUControll #(.ALU_controll_unit_length(ALU_CONTROLL_UNIT_LENGTH), .ALU_command_length(ALU_COMMAND_LENGTH)) ALU_controll(
		.input_func(instruction_memory_read_data[ALU_COMMAND_LENGTH - 1 : 0]),
		.command(controll_unit_ALU_controll),
		.output_func(ALU_controll_out));
		
	wire ALU_zero;
	ALU #(.command_length(ALU_COMMAND_LENGTH)) alu(
		.input_1(ALU_input_1_mux_out),
		.input_2(ALU_input_2_mux_out),
		.command(ALU_controll_out),
		.ALU_out(ALU_out),
		.zero(ALU_zero));
		
	assign mips_alu_out = ALU_out;
	
	wire branch;
	assign branch = controll_unit_branch & (~ALU_zero);
	
	
	wire [PC_INPUT_LENGTH - 1 : 0] adder_in_2_mux_out;
	MUX_2_to_1 #(.data_length(PC_INPUT_LENGTH)) adder_in_2_mux(
		.input_1(3'b001), 
		.input_2(sign_extend_out[PC_INPUT_LENGTH - 1 : 0]), 
		.select(branch), 
		.out(adder_in_2_mux_out));
		
	assign adder_out = pc_out + adder_in_2_mux_out;
	
	MUX_3_to_1 #(.data_length(PC_INPUT_LENGTH)) PC_in_mux(
		.input_1(adder_out),
		.input_2(instruction_memory_read_data[PC_INPUT_LENGTH - 1 : 0]),
		.input_3(register_bank_read_data_1[PC_INPUT_LENGTH - 1 : 0]),
		.select(controll_unit_PC_in_mux),
		.out(PC_in_mux_out));
	
	mainMemory #(.address_length(MAIN_MEMORY_ADDRESS_LENGTH)) main_memory(
		.address(ALU_out[MAIN_MEMORY_ADDRESS_LENGTH - 1 : 0]),
		.write_data(register_bank_read_data_2),
		.write_enable(controll_unit_main_momory_write_enable),
		.clk(clk),
		.read_data(main_momory_read_data));
	
	
endmodule 
