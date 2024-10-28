module keypad_tb();
	reg clk;
	wire [3:0]cols;
	reg [3:0]rows;
	
	wire [7:0]data_out;
	
	keypad_peripheral kp0(
		.cols(cols),
		.rows(rows),
		.clk(clk),
		.out(data_out)
	);
	
	parameter _1 = 4'b0001;
	parameter _2 = 4'b0010;
	parameter _3 = 4'b0100;
	parameter _4 = 4'b1000;
	
	always #10 clk=~clk;
	
	initial begin
		clk <= 0;	
		rows <= 0;
		
		#80
		rows <= _1;
		
		#80
		rows <= _2;
		
		#80
		rows <= _3;
		
		#80
		rows <= _4;
		
		#80
		
		$stop;
		
	end
endmodule