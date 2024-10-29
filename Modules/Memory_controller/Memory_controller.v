module mem_virtualizer( 
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
	parameter IO_ADDR_BITS = 4;
	
	parameter DS_OFFSET_SHIFT = 2; 
	// in physical memmory, the data segment will start at address (capacity)>>DATA_OFFSET_SHIFT
	// the default is 1/4.
	

	assign rstPhys = rstVirt;
	assign rstIO = rstVirt;
	
	always @(*) begin
		dataOutVirt = 0;
		
		addressPhys = 0;
		dataInPhys = 0;
		wEnPhys = 0;
		
		addressIO = 0;
		dataInIO = 0;
		wEnIO = 0;
	
		if ( VIRT_TEXT_START <= addressVirt <= VIRT_TEXT_END ) begin
				dataInPhys = dataInVirt;
				addressPhys = addressVirt - VIRT_TEXT_START;
				dataOutVirt = dataOutPhys;
				wEnPhys = wEnVirt;
				wEnIO = 0;
		end
		
		else if ( VIRT_DS_START <= addressVirt <= VIRT_DS_END ) begin
				dataInPhys = dataInVirt;
				addressPhys = addressVirt - VIRT_DS_START + ((2**PHYS_ADDR_BITS) >> DS_OFFSET_SHIFT );
				dataOutVirt = dataOutPhys;
				wEnPhys = wEnVirt;
				wEnIO = 0;
		end
		
		else if ( VIRT_IO_START <= addressVirt <= VIRT_IO_END ) begin
				dataInIO = dataInVirt;
				addressIO = (addressVirt - VIRT_IO_START);
				dataOutVirt = dataOutIO;
				wEnIO = wEnVirt;
				wEnPhys = 0;
		end
	end
endmodule


module Memory_controller(
	output wire HEX0, output wire HEX1, output wire HEX2, output wire HEX3, output wire HEX4, output wire HEX5, output wire [35:0] GPIO_1);
	
	wire data_out;
	
	display_peripheral dp0(
		.din(data_out),
		.hex0(HEX0),
		.hex1(HEX1),
		.hex2(HEX2),
		.hex3(HEX3),
		.hex4(HEX4),
		.hex5(HEX5),
		.hex6(GPIO_0[6:0]),
		.hex7(GPIO_0[13:7]),
		.hex8(GPIO_0[20:14]),
		.hex9(GPIO_0[27:21]),
		.hex10(GPIO_0[34:28]),
		.dot(GPIO_0[35])
	);
	
	
endmodule