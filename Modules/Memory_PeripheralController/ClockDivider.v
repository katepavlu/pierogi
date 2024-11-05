module ClockDivider(input clk, output reg clkd);

	reg [31:0] ctr;

	initial begin
		clkd = 0;
		ctr = 0;
	end
	
	// Clock division logic
	always @(posedge clk) begin
		if (ctr < 1_000)
			ctr <= ctr + 1;
		else begin
			ctr <= 0;
			clkd <= ~clkd;  // Toggle divided clock output
		end
	end
endmodule