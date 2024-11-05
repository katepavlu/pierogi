module memory_integrated(
    input wire [31:0] dataInVirt,
    input wire [31:0] addressVirt,
    input wire wEnVirt,
    input wire rstVirt,
    input wire clk,
    output wire [31:0] dataOutVirt,
	 
	  // Outputs for peripheral_controller (Display outputs)
    output wire [6:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7, hex8, hex9, hex10,
    output wire dot,	
	 
	 // Keypad connections for peripheral_controller
    output wire [3:0] cols,
    input wire [3:0] rows
	 
);


    // Internal connections for BRAM (Physical Memory)
    wire [10:0] addressPhys;
    wire [31:0] dataInPhys, dataOutPhys;
    wire wEnPhys, rstPhys;
	 
	 
    // Internal connections for IO
    wire [3:0] addressIO;
    wire [31:0] dataInIO, dataOutIO;
    wire wEnIO, rstIO;
	 
	 
	 

    // Instantiate Memory Controller
    Memory_controller mem_ctrl (
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

    // Instantiate BRAM for Physical Memory
    BRAM bram (
        .addr({21'b0, addressPhys}), // Convert 11-bit physical address to 32-bit
        .din(dataInPhys),
        .clk(clk),
        .wren(wEnPhys),
        .dout(dataOutPhys)
    );
	 
	 

     // Instantiate Peripheral Controller for IO operations
    peripheral_controller peripheral_ctrl (
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
		.cols(cols),  
		.clk(clk),
      .reset(rstIO),
      .address(addressIO),
      .din(dataInIO),
      .writeEnable(wEnIO),
      .dout(dataOutIO)  // Only the lower 8 bits are used for dout
        
 
    );

endmodule
