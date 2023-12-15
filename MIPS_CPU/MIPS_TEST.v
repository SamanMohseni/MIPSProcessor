`timescale 1ns / 1ps

module MIPS_TEST;

	// Inputs
	reg clock;
	reg reset;

	// Outputs
	wire [31:0] mips_alu_out;

	// Instantiate the Unit Under Test (UUT)
	MIPS uut (
		.clock(clock),
		.reset(reset), 
		.mips_alu_out(mips_alu_out),
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		reset = 1;

		// Wait 100 ns for global reset to finish
		#500;
		
		reset = 0;
        
		// Add stimulus here

	end
	
	always
	begin
		#10 clock = ~clock;
	end
      
endmodule

