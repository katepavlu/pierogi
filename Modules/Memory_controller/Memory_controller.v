module Memory_controller( 
	input wire [31:0] dataInVirt,
	input wire [31:0] addressVirt,
	output reg [31:0] dataOutVirt,
	input wire wEnVirt,
	input wire rstVirt,
		
	output reg [PHYS_ADDR_BITS-1:0]addressPhys,
	output reg [31:0] dataInPhys,
	input wire [31:0] dataOutPhys,
	output reg wEnPhys,
	output wire rstPhys,
	
	output reg [IO_ADDR_BITS-1:0]addressIO,
	output reg [31:0] dataInIO,
	input wire [31:0] dataOutIO,
	output reg wEnIO,
	output wire rstIO
	);
	
	
	parameter VIRT_TEXT_START	= 32'h_0000_0000;
	parameter VIRT_TEXT_END		= 32'h_0fff_ffff;
	
	parameter VIRT_DS_START		= 32'h_1000_0000;
	parameter VIRT_DS_END		= 32'h_7fff_ffff;
	
	parameter VIRT_IO_START		= 32'h_ffff_0000;
	parameter VIRT_IO_END		= 32'h_ffff_ffff;
	
	
	parameter PHYS_ADDR_BITS = 16;
	parameter IO_ADDR_BITS = 2;
	
	parameter DS_OFFSET_SHIFT = 2; 
	// in physical memmory, the data segment will start at address (capacity)>>DATA_OFFSET_SHIFT
	// the default is 1/4.
	

	assign rstPhys = rstVirt;
	assign rstIO = rstVirt;
	
	always @(*) begin
	
		if ( VIRT_TEXT_START <= addressVirt <= VIRT_TEXT_END ) begin
				dataInPhys = dataInVirt;
				addressPhys = addressVirt;
				dataOutVirt = dataOutPhys;
				wEnPhys = wEnVirt;
		end
		
		if ( VIRT_DS_START <= addressVirt <= VIRT_DS_END ) begin
				dataInPhys = dataInVirt;
				addressPhys = addressVirt - VIRT_DS_START + ((2**PHYS_ADDR_BITS) >> DS_OFFSET_SHIFT );
				dataOutVirt = dataOutPhys;
				wEnPhys = wEnVirt;				
		end
		
		if ( VIRT_IO_START <= addressVirt <= VIRT_IO_END ) begin
				dataInIO = dataInVirt;
				addressIO = addressVirt;
				dataOutVirt = dataOutIO;
				wEnIO = wEnVirt;
		end
	end
endmodule