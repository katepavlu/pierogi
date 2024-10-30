`timescale 1 ns/10 ps

module ram_tb();
	
	reg [12:0]addr;
	reg [31:0]din;
	reg clk;
	reg wren;

	wire [31:0]dout;
	
	integer i;
	
	initial begin
		addr = 0;
		din = 0;
		clk = 1;
		wren = 0;
		
		for (i=0; i<9; i=i+1) begin
			#80
			addr = addr + 4;		
		end
		#80
		$stop;
	end
	
	always #20 clk=~clk;

	BRAM ram0 (
		.addr(addr),
		.din(din),
		.clk(clk),
		.wren(wren),
		.dout(dout)
	);

endmodule