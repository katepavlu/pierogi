`timescale 1ns/1ps

module sdram_controller_tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg we;
    reg [23:0] addr;
    reg [15:0] data_in;
    wire [15:0] data_out;

    // SDRAM interface signals
    wire [12:0] DRAM_ADDR;
    wire [15:0] DRAM_DQ;
    wire DRAM_WE_N;
    wire DRAM_CAS_N;
    wire DRAM_RAS_N;
    wire DRAM_CS_N;
    wire DRAM_CLK;

    // SDRAM data line (inout)
    reg [15:0] sdram_data_reg;
    assign DRAM_DQ = (we) ? sdram_data_reg : 16'bz;

    // Instantiate the SDRAM Controller
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

    // Generate clock signal
    initial clk = 0;
    always #5 clk = ~clk; // 100MHz clock (10ns period)

    // Test procedure
    initial begin
        // Initialize testbench signals
        reset = 1;
        we = 0;
        addr = 24'h0;
        data_in = 16'h0;
        sdram_data_reg = 16'h0;

        // Reset the SDRAM Controller
        #20 reset = 0;

        // Test Write Operation
        #20;
        addr = 24'h000001;        // Test address
        data_in = 16'hABCD;       // Test data to write
        we = 1;                   // Enable write
        sdram_data_reg = 16'hABCD; // Set SDRAM data to match input
        #20;
        we = 0;                   // End write

        // Test Read Operation
        #40;
        addr = 24'h000001;        // Test address (same as written)
        we = 0;                   // Disable write (read mode)
        sdram_data_reg = 16'hABCD; // Set SDRAM data for read
        #20;
        
        // Check data output
        if (data_out == 16'hABCD) begin
            $display("Read data matches expected value: 0x%h", data_out);
        end else begin
            $display("ERROR: Read data does not match expected value. Got: 0x%h", data_out);
        end

        // Finish simulation
        #40;
        $stop;
    end
endmodule
