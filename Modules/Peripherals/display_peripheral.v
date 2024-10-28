// for internal use by the display peripheral
module hex_driver(
	input [3:0]din, 
	output reg [7:0] LEDpins);
	
	always @(*) begin
		case(din)
			4'h0: begin LEDpins=~7'b0111111; end
			4'h1: begin LEDpins=~7'b0000110; end
			4'h2: begin LEDpins=~7'b1011011; end
			4'h3: begin LEDpins=~7'b1001111; end
			4'h4: begin LEDpins=~7'b1100110; end
			4'h5: begin LEDpins=~7'b1101101; end
			4'h6: begin LEDpins=~7'b1111101; end
			4'h7: begin LEDpins=~7'b0000111; end
			4'h8: begin LEDpins=~7'b1111111; end
			4'h9: begin LEDpins=~7'b1100111; end
			4'ha: begin LEDpins=~7'b1110111; end
			4'hb: begin LEDpins=~7'b1111100; end
			4'hc: begin LEDpins=~7'b0111001; end
			4'hd: begin LEDpins=~7'b1011110; end
			4'he: begin LEDpins=~7'b1111001; end
			4'hf: begin LEDpins=~7'b1110001; end
		endcase
	end
endmodule

// signed decimal display: provide pins an a 32b input
module display_peripheral(
	input wire signed [31:0] din,
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
	output wire [7:0] hex10,
	output wire dot);
	
	wire [31:0]dinabs;
	
	assign dinabs = (din < 0)? -din: din;
	
	hex_driver d0(
		.din((dinabs/1) % 10),
		.LEDpins(hex0)
	);
	hex_driver d1(
		.din((dinabs/10) % 10),
		.LEDpins(hex1)
	);
	hex_driver d2(
		.din((dinabs/100) % 10),
		.LEDpins(hex2)
	);
	hex_driver d3(
		.din((dinabs/1_000) % 10),
		.LEDpins(hex3)
	);
	hex_driver d4(
		.din((dinabs/10_000) % 10),
		.LEDpins(hex4)
	);
	hex_driver d5(
		.din((dinabs/100_000) % 10),
		.LEDpins(hex5)
	);
	hex_driver d6(
		.din((dinabs/1000_000) % 10),
		.LEDpins(hex6)
	);
	hex_driver d7(
		.din((dinabs/10_000_000) % 10),
		.LEDpins(hex7)
	);
	hex_driver d8(
		.din((dinabs/100_000_000) % 10),
		.LEDpins(hex8)
	);
	hex_driver d9(
		.din((dinabs/1_000_000_000) % 10),
		.LEDpins(hex9)
	);
	
	assign hex10[5:0] = -1;
	assign hex10[6] = ~(din<0);
	assign hex10[7] = 1;
	
	assign dot = 1;
	
endmodule