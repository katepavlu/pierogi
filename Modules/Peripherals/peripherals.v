module ClockDivider(input clk, output reg clkd);

	reg [31:0]ctr;

	initial clkd = 0;
	initial ctr = 0;
	
	reg clk2;
	initial clk2 = 0;
	
	always @(posedge clk) clk2 = ~clk2;
	
	always @(posedge clk2)
	begin
		if(ctr<25_000)
			ctr <= ctr+1;
		else begin
			ctr <= 0;
			clkd <= !clkd;
		end
	end

endmodule

module peripherals(
	output wire [6:0]HEX0,
	output wire [6:0]HEX1,
	output wire [6:0]HEX2,
	output wire [6:0]HEX3,
	output wire [6:0]HEX4,
	output wire [6:0]HEX5,
	output wire [35:0]GPIO_0,
	
	inout wire [35:0]GPIO_1,	
	input wire CLOCK_50,
	
	input wire [1:0]KEY);
	
	wire signed [31:0]data_out;
	
	wire clkd;
	
	peripheral_controller pc0(
		.hex0(hex0),
		.hex1(hex1),
		.hex2(hex2),
		.hex3(hex3),
		.hex4(hex4),
		.hex5(hex5),
		.hex6(hex6),
		.hex7(hex7),
		.hex8(hex8),
		.hex9(hex9),
		.hex10(hex10),
		.dot(dot),
		.rows(rows),
		.cols(GPIO_1[35:32]),  // Assume GPIO_1[35:32] are the column inputs for keypad
		.clk(clkd),
		.address(address),
		.din(din),
		.writeEnable(writeEnable),
		.dout(dout)
	);
	
	ClockDivider ckd0(
		.clk(CLOCK_50),
		.clkd(clkd)
	);
	
/*	// a simple dummy program
	initial begin
		data_out <= 32'h7fff_fff0;
	end
	
	always @(posedge KEY[0]) begin
		data_out <= data_out + 1;
	end
*/
endmodule