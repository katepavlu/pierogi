module sign_extend(
	input [15:0] immediate,
	output [31:0] extended_immediate
	);
	
	// Sign extend the immediate value from 16 bits to 32 bits
	assign extended_immediate = {{16{immediate[15]}},immediate}; 
	
endmodule