module mem_ctrl( 
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
		
		else begin
				wEnPhys = 0;
				wEnIO = 0;
				dataOutVirt = 0;
		end
	end
endmodule

module hex_driver(
	input [3:0]din, 
	output reg [7:0] LEDpins);
	
	always @(*) begin
		case(din)
			0:begin  LEDpins=~7'b0111111; end
			1:begin  LEDpins=~7'b0000110; end
			2:begin  LEDpins=~7'b1011011; end
			3:begin  LEDpins=~7'b1001111; end
			4:begin  LEDpins=~7'b1100110; end
			5:begin  LEDpins=~7'b1101101; end
			6:begin  LEDpins=~7'b1111101; end
			7:begin  LEDpins=~7'b0000111; end
			8:begin  LEDpins=~7'b1111111; end
			9:begin  LEDpins=~7'b1100111; end
			default:begin  LEDpins=~7'b0111111; end
		endcase
	end
endmodule

module display_peripheral(
	input wire  signed [31:0] din,
	output wire [7:0] hex0,
	output wire [7:0] hex1,
	output wire [7:0] hex2,
	output wire [7:0] hex3,
	output wire [7:0] hex4,
	output wire [7:0] hex5,
	output wire [7:0] hex6,
	output wire [7:0] hex7,
	output wire [7:0] hex8,
	output wire [7:0] hex9,
	output wire [7:0] hex10);
	
	hex_driver d0(
		.din((din/1) % 10),
		.LEDpins(hex0)
	);
	hex_driver d1(
		.din((din/10) % 10),
		.LEDpins(hex1)
	);
	hex_driver d2(
		.din((din/100) % 10),
		.LEDpins(hex2)
	);
	hex_driver d3(
		.din((din/1_000) % 10),
		.LEDpins(hex3)
	);
	hex_driver d4(
		.din((din/10_000) % 10),
		.LEDpins(hex4)
	);
	hex_driver d5(
		.din((din/100_000) % 10),
		.LEDpins(hex5)
	);
	hex_driver d6(
		.din((din/1000_000) % 10),
		.LEDpins(hex6)
	);
	hex_driver d7(
		.din((din/10_000_000) % 10),
		.LEDpins(hex7)
	);
	hex_driver d8(
		.din((din/100_000_000) % 10),
		.LEDpins(hex8)
	);
	hex_driver d9(
		.din((din/1_000_000_000) % 10),
		.LEDpins(hex9)
	);
	
	assign hex10[0:5] = 0;
	assign hex10[6] = din[31];
	assign hex10[7] = 0;
	
	
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
		.hex6(GPIO_1[6:0]),
		.hex7(GPIO_1[13:7]),
		.hex8(GPIO_1[20:15]),
		.hex9(GPIO_1[28:21]),
		.sign(GPIO_1[29])		
	);
	
	
endmodule