module Memory_controller( 
	input wire [31:0] dataInVirt,
	input wire [31:0] addressVirt,
	output wire [31:0] dataOutVirt,
	input wire wEnVirt,
	input wire rstVirt,
		
	output wire [PHYSICAL_MEMORY_ADDR_BITS-1:0]addressPhys,
	output wire [31:0] dataInPhys,
	input wire [31:0] dataOutPhys,
	output wire wEnPhys,
	output wire rstPhys,
	
	output wire [IO_ADDR_BITS-1:0]addressIO,
	output wire [31:0] dataInIO,
	input wire [31:0] dataOutIO,
	output wire wEnIO,
	output wire rstIO
	);
	
	parameter VIRT_TEXT_SEGMENT_START	= 32'h_0000_0000;
	parameter VIRT_DATA_SEGMENT_START	= 32'h_1000_0000;
	parameter VIRT_STACK_END				= 32'h_8000_0000;
	parameter VIRT_IO_SEGMENT_START 		= 32'h_ffff_0000;
	
	parameter PHYSICAL_MEMORY_ADDR_BITS = 16;
	parameter IO_ADDR_BITS = 2;
	

	
endmodule