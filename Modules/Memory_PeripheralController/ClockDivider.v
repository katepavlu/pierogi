// the keypad has to operate at a very slow frequency because of hardware limitations
// so we are reducing its clock to 1 kHz

module ClockDivider(input clk, output reg clkd);

	reg [31:0] ctr;

	initial begin
		clkd = 0;
		ctr = 0;
	end
	
	// Clock division logic
	always @(posedge clk) begin
		if (ctr < 50000)
			ctr <= ctr + 1;
		else begin
			ctr <= 0;
			clkd <= ~clkd;  // Toggle divided clock output
		end
	end
endmodule