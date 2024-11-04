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