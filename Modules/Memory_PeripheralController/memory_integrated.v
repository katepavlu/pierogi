module memory_integrated(
    input wire [31:0] dataInVirt,
    input wire [31:0] addressVirt,
    input wire wEnVirt,
    input wire rstVirt,
    input wire clk,
    output wire [31:0] dataOutVirt
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

    // Example IO Module (you may replace with actual IO implementation)
    BRAM io_mem (
        .addr({28'b0, addressIO}), // Convert 4-bit IO address to 32-bit
        .din(dataInIO),
        .clk(clk),
        .wren(wEnIO),
        .dout(dataOutIO)
    );

endmodule
