`timescale 1 ns/10 ps

module mctrl_tb();
	reg [31:0] dataInVirt;
	reg [31:0] addressVirt;
	wire [31:0] dataOutVirt;
	reg wEnVirt;
	reg rstVirt;
		
	wire [31:0]addressPhys;
	wire [31:0] dataInPhys;
	reg [31:0] dataOutPhys;
	wire wEnPhys;
	wire rstPhys;
	
	wire [3:0]addressIO;
	wire [31:0]dataInIO;
	reg [31:0]dataOutIO;
	wire wEnIO;
	wire rstIO;

	Memory_controller mctr0( 
		.dataInVirt(dataInVirt),
		.addressVirt(addressVirt),
		.dataOutVirt(dataOutVirt),
		.wEnVirt(wEnVirt),
		.rstVirt(rstVirt),
			
		.addressPhys(addressPhys),
		.dataInPhys(dataInPhys),
		.dataOutPhys(dataOutPhys),
		.wEnPhys(wEnPhys),
		.rstPhys(rstPhys),
		
		.addressIO(addressIO),
		.dataInIO(dataInIO),
		.dataOutIO(dataOutIO),
		.wEnIO(wEnIO),
		.rstIO(rstIO)
		);
		
	initial begin
		dataInVirt = 32'h12345678;
		dataOutPhys = 32'hdeadbeef;
		dataOutIO = 32'hfefefefe;
		
		rstVirt = 0;
		wEnVirt = 0;
		
		addressVirt = 0;
		#20
		
		addressVirt = 4;
		#20
		
		rstVirt = 1;
		#20
		
		wEnVirt = 1;
		#20
		
		addressVirt = 32'h1000_0008;
		wEnVirt = 0;
		rstVirt = 0;
		#20
		
		rstVirt = 1;
		#20
		
		wEnVirt = 1;
		#20
		
		addressVirt = 32'hffff_000c;
		wEnVirt = 0;
		rstVirt = 0;
		#20
		
		rstVirt = 1;
		#20
		
		wEnVirt = 1;
		#20
	
		wEnVirt = 0;
	
	end
endmodule