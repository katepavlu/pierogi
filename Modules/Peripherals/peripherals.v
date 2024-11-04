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
	output wire [6:0] HEX6,
	output wire [6:0] HEX7,
	output wire [6:0] HEX8,
	output wire [6:0] HEX9,
	output wire [6:0] HEX10,
	
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
	wire [3:0] address = 4'h0; 
	wire [31:0] din = 32'h00000000;  // Example data input
	wire writeEnable = 1'b0;  

	// Peripheral controller instantiation
	peripheral_controller pc0(
		.hex0(HEX0),
		.hex1(HEX1),
		.hex2(HEX2),
		.hex3(HEX3),
		.hex4(HEX4),
		.hex5(HEX5),
		.hex6(HEX6),
		.hex7(HEX7),
		.hex8(HEX8),
		.hex9(HEX9),
		.hex10(HEX10),
		.dot(GPIO_0[35]),
		.rows(GPIO_1[29:26]),
		.cols(GPIO_1[33:30]),  
		.clk(clkd),
		.reset(KEY[0]),
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




endmodule