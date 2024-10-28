module sdram_controller (
    input            clk,        // System clock
    input            reset,      // Asynchronous reset
    input            we,         // Write enable
    input  [23:0]    addr,       // Address bus (24-bit for 64MB)
    input  [15:0]    data_in,    // Data input (16-bit)
    output [15:0]    data_out,   // Data output (16-bit)

    // SDRAM interface
    output reg [12:0] DRAM_ADDR, // SDRAM address bus
    inout  [15:0]    DRAM_DQ,    // SDRAM data bus
    output reg       DRAM_WE_N,  // SDRAM Write Enable
    output reg       DRAM_CAS_N, // SDRAM Column Address Strobe
    output reg       DRAM_RAS_N, // SDRAM Row Address Strobe
    output reg       DRAM_CS_N,  // SDRAM Chip Select
    output           DRAM_CLK    // SDRAM Clock
);

    reg [15:0] data_buffer;      // Buffer to hold data to be written
    reg data_direction;          // 0 = Read, 1 = Write

    // Assign SDRAM clock to the system clock
    assign DRAM_CLK = clk;

    // Tri-state buffer for data lines
    assign DRAM_DQ = (data_direction) ? data_buffer : 16'bz;
    assign data_out = (data_direction) ? 16'bz : DRAM_DQ;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset state for SDRAM controller
            DRAM_ADDR  <= 13'b0;
            DRAM_WE_N  <= 1'b1;
            DRAM_CAS_N <= 1'b1;
            DRAM_RAS_N <= 1'b1;
            DRAM_CS_N  <= 1'b1;
            data_direction <= 0;
        end else begin
            // Activate chip
            DRAM_CS_N <= 1'b0;

            // Read or Write operation
            if (we) begin
                // Write cycle
                data_direction <= 1;
                data_buffer <= data_in;
                DRAM_ADDR <= addr[12:0]; // Map address to SDRAM
                DRAM_RAS_N <= 1'b0; // Select row
                DRAM_CAS_N <= 1'b0; // Select column
                DRAM_WE_N <= 1'b0;  // Enable write
            end else begin
                // Read cycle
                data_direction <= 0;
                DRAM_ADDR <= addr[12:0]; // Map address to SDRAM
                DRAM_RAS_N <= 1'b0; // Select row
                DRAM_CAS_N <= 1'b0; // Select column
                DRAM_WE_N <= 1'b1;  // Disable write
            end

            // Return to idle state
            DRAM_RAS_N <= 1'b1;
            DRAM_CAS_N <= 1'b1;
            DRAM_WE_N <= 1'b1;
        end
    end
endmodule