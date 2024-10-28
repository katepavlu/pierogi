`timescale 1ns/1ps

module sdram_controller_tb2;

    // Testbench signals
    reg clk;
    reg reset;
    reg we;
    reg [23:0] addr;
    reg [15:0] data_in;
    wire [15:0] data_out;
    wire [12:0] DRAM_ADDR;
    wire [15:0] DRAM_DQ;
    wire DRAM_WE_N, DRAM_CAS_N, DRAM_RAS_N, DRAM_CS_N, DRAM_CLK;

    // Bidirectional data bus
    reg [15:0] sdram_data;  // SDRAM data bus controlled in the testbench
    assign DRAM_DQ = sdram_data;

    // Instantiate the SDRAM controller
    sdram_controller uut (
        .clk(clk),
        .reset(reset),
        .we(we),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out),
        .DRAM_ADDR(DRAM_ADDR),
        .DRAM_DQ(DRAM_DQ),
        .DRAM_WE_N(DRAM_WE_N),
        .DRAM_CAS_N(DRAM_CAS_N),
        .DRAM_RAS_N(DRAM_RAS_N),
        .DRAM_CS_N(DRAM_CS_N),
        .DRAM_CLK(DRAM_CLK)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 100MHz clock (10ns period)

    // Simulation procedure
    initial begin
        // Reset and initialize
        reset = 1;
        we = 0;
        addr = 24'h0;
        data_in = 16'h0;
        sdram_data = 16'bz; // Tri-state the data bus initially

        // Release reset
        #20;
        reset = 0;
        #500;  // Wait for initialization delay in the controller

        // Test write operation
        addr = 24'h0000A5;       // Set address
        data_in = 16'h1234;      // Data to write
        we = 1;                  // Set write enable
        #20;
        we = 0;                  // Deassert write enable
        #40;                     // Wait for write cycle to complete

        // Verify data is output on DRAM_DQ
        if (DRAM_DQ !== 16'h1234) begin
            $display("ERROR: Write data mismatch at time %t", $time);
        end else begin
            $display("Write data matched: 0x%h at address 0x%h", data_in, addr);
        end

        // Test read operation
        addr = 24'h0000A5;       // Set address for read
        sdram_data = 16'h1234;   // Place expected data on DRAM_DQ
        #20;                     // Allow read operation to occur
        if (data_out !== 16'h1234) begin
            $display("ERROR: Read data mismatch at time %t", $time);
        end else begin
            $display("Read data matched: 0x%h at address 0x%h", data_out, addr);
        end

        // End of test
        #100;
        $stop;
    end
endmodule
