module Memory_controller( 
		dataInVirt,
		addressVirt,
		dataOutVirt,
		wEnVirt,
		rstVirt,
			
		addressPhys,
		dataInPhys,
		dataOutPhys,
		wEnPhys,
		rstPhys,
		
		addressIO,
		dataInIO,
		dataOutIO,
		wEnIO,
		rstIO
	);	
	parameter VIRT_TEXT_START	= 32'h_0000_0000;
	parameter VIRT_TEXT_END		= 32'h_0fff_ffff;
	
	parameter VIRT_DS_START		= 32'h_1000_0000;
	parameter VIRT_DS_END		= 32'h_7fff_ffff;
	
	parameter VIRT_IO_START		= 32'h_ffff_0000;
	parameter VIRT_IO_END		= 32'h_ffff_ffff;
	
	
	parameter PHYS_ADDR_BITS = 11;
	parameter IO_ADDR_BITS = 4;
	
	parameter DS_OFFSET_SHIFT = 1;
	// in physical memmory, the data segment will start at address (capacity)>>DATA_OFFSET_SHIFT
	// the default is 1/2.
	
	input wire [31:0] dataInVirt;
	input wire [31:0] addressVirt;
	output reg [31:0] dataOutVirt;
	input wire wEnVirt;
	input wire rstVirt;
		
	output reg [31:0] addressPhys;
	output reg [31:0] dataInPhys;
	input wire [31:0] dataOutPhys;
	output reg wEnPhys;
	output wire rstPhys;
	
	output reg [3:0]addressIO;
	output reg [31:0] dataInIO;
	input wire [31:0] dataOutIO;
	output reg wEnIO;
	output wire rstIO;
	

	assign rstPhys = rstVirt;
	assign rstIO = rstVirt;
	
	always @(*) begin
		dataOutVirt <= 0;
		
		addressPhys <= 0;
		dataInPhys <= 0;
		wEnPhys <= 0;
		
		addressIO <= 0;
		dataInIO <= 0;
		wEnIO <= 0;
	
		if ( (VIRT_TEXT_START <= addressVirt) && (addressVirt <= VIRT_TEXT_END) ) begin
				dataInPhys <= dataInVirt;
				addressPhys <= addressVirt - VIRT_TEXT_START;
				dataOutVirt <= dataOutPhys;
				wEnPhys <= wEnVirt;
		end
		
		else if ( (VIRT_DS_START <= addressVirt) && (addressVirt <= VIRT_DS_END) ) begin
				dataInPhys <= dataInVirt;
				addressPhys <= addressVirt - VIRT_DS_START + ((2**(PHYS_ADDR_BITS+2)) >> DS_OFFSET_SHIFT );
				dataOutVirt <= dataOutPhys;
				wEnPhys <= wEnVirt;
		end
		
		else if ( (VIRT_IO_START <= addressVirt) && (addressVirt <= VIRT_IO_END) ) begin
				dataInIO <= dataInVirt;
				addressIO <= (addressVirt - VIRT_IO_START);
				dataOutVirt <= dataOutIO;
				wEnIO <= wEnVirt;
		end
	end
endmodule