module ClockDivider(input clk, output reg clkd);

	reg [31:0] ctr;

	initial begin
		clkd = 0;
		ctr = 0;
	end
	
	reg clk2 = 0;
	
	// Toggle clk2 on each positive edge of clk
	always @(posedge clk) 
		clk2 <= ~clk2;
	
	// Clock division logic
	always @(posedge clk2) begin
		if (ctr < 25_000)
			ctr <= ctr + 1;
		else begin
			ctr <= 0;
			clkd <= ~clkd;  // Toggle divided clock output
		end
	end
endmodule


module peripherals(
	output wire [6:0] HEX0,
	output wire [6:0] HEX1,
	output wire [6:0] HEX2,
	output wire [6:0] HEX3,
	output wire [6:0] HEX4,
	output wire [6:0] HEX5,
	output wire [35:0] GPIO_0,
	
	inout wire [35:0] GPIO_1,	
	input wire CLOCK_50,
	input wire [1:0] KEY
);
	
	// Internal wires for display and control signals
	wire [6:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7, hex8, hex9, hex10;
	wire dot;
	wire [3:0] rows;
	wire clkd;
	wire [3:0] address = 4'h0;  // Example address, you may need to set this based on your CPU control logic
	wire din = 1'b0;            // Example data input, set based on your CPU or external signals
	wire writeEnable = 1'b0;    // Example write enable, set based on your control logic
	wire dout;

	// Peripheral controller instantiation
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
		.cols(GPIO_1[35:32]),  // Assuming GPIO_1[35:32] are the keypad columns
		.clk(clkd),
		.address(address),
		.din(din),
		.writeEnable(writeEnable),
		.dout(dout)
	);
	
	// Clock Divider instantiation
	ClockDivider ckd0(
		.clk(CLOCK_50),
		.clkd(clkd)
	);

	// Connect internal hex signals to the output HEX displays
	assign HEX0 = hex0;
	assign HEX1 = hex1;
	assign HEX2 = hex2;
	assign HEX3 = hex3;
	assign HEX4 = hex4;
	assign HEX5 = hex5;

	// Map additional hex outputs to GPIO pins
	assign GPIO_0[6:0] = hex6;
	assign GPIO_0[13:7] = hex7;
	assign GPIO_0[20:14] = hex8;
	assign GPIO_0[27:21] = hex9;
	assign GPIO_0[34:28] = hex10;
	assign GPIO_0[35] = dot;

	/* Optional dummy program - Uncomment to use for testing
	reg signed [31:0] data_out;
	initial begin
		data_out <= 32'h7fff_fff0;
	end
	
	always @(posedge KEY[0]) begin
		data_out <= data_out + 1;
	end
	*/

endmodule