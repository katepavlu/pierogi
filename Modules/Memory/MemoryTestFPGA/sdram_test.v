module sdram_test (
    input            clk,        // System clock
    input            reset,      // Asynchronous reset
    output reg       test_pass,  // Indicates if the test passed
    output reg       test_fail,  // Indicates if the test failed

    // SDRAM interface
    output [12:0]    DRAM_ADDR,  // SDRAM address bus
    inout  [15:0]    DRAM_DQ,    // SDRAM data bus
    output           DRAM_WE_N,  // SDRAM Write Enable
    output           DRAM_CAS_N, // SDRAM Column Address Strobe
    output           DRAM_RAS_N, // SDRAM Row Address Strobe
    output           DRAM_CS_N,  // SDRAM Chip Select
    output           DRAM_CLK    // SDRAM Clock
);

    // Internal signals for connecting to the SDRAM controller
    reg [23:0] sdram_addr;       // Address for read/write test
    reg        sdram_we;         // Write enable for SDRAM controller
    reg [15:0] sdram_data_in;    // Data to be written to SDRAM
    wire [15:0] sdram_data_out;  // Data read from SDRAM

    // Instantiate the SDRAM controller module
    sdram_controller uut (
        .clk(clk),
        .reset(reset),
        .we(sdram_we),
        .addr(sdram_addr),
        .data_in(sdram_data_in),
        .data_out(sdram_data_out),
        .DRAM_ADDR(DRAM_ADDR),
        .DRAM_DQ(DRAM_DQ),
        .DRAM_WE_N(DRAM_WE_N),
        .DRAM_CAS_N(DRAM_CAS_N),
        .DRAM_RAS_N(DRAM_RAS_N),
        .DRAM_CS_N(DRAM_CS_N),
        .DRAM_CLK(DRAM_CLK)
    );

    // FSM state encoding for the test
    reg [3:0] state;
    parameter INIT         = 4'd0;
    parameter WRITE_TEST   = 4'd1;
    parameter WAIT_WRITE   = 4'd2;
    parameter READ_TEST    = 4'd3;
    parameter WAIT_READ    = 4'd4;
    parameter VERIFY_DATA  = 4'd5;
    parameter TEST_PASS    = 4'd6;
    parameter TEST_FAIL    = 4'd7;

    // Signals for test data and verification
    reg [15:0] test_data;       // Data to write to SDRAM
    reg [15:0] read_data;       // Data read back from SDRAM

    // Tri-state control for SDRAM DQ bus
    assign DRAM_DQ = (sdram_we) ? sdram_data_in : 16'bz;

    // FSM for SDRAM read/write testing
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize/reset all states and signals
            state <= INIT;
            sdram_we <= 0;
            sdram_addr <= 24'h0;
            test_pass <= 0;
            test_fail <= 0;
            test_data <= 16'hA5A5; // Test pattern
        end else begin
            // State machine for SDRAM testing
            case (state)
                INIT: begin
                    // Move to the WRITE_TEST state to start the write operation
                    state <= WRITE_TEST;
                end
                WRITE_TEST: begin
                    // Write test data to the SDRAM
                    sdram_we <= 1;
                    sdram_addr <= 24'h000001; // Set test address
                    sdram_data_in <= test_data; // Write test data
                    state <= WAIT_WRITE;
                end
                WAIT_WRITE: begin
                    // Wait for the write operation to complete
                    sdram_we <= 0; // De-assert write enable
                    state <= READ_TEST;
                end
                READ_TEST: begin
                    // Perform read operation from the same address
                    sdram_addr <= 24'h000001; // Set the same test address
                    state <= WAIT_READ;
                end
                WAIT_READ: begin
                    // Wait for the read operation to complete
                    read_data <= sdram_data_out; // Capture read data
                    state <= VERIFY_DATA;
                end
                VERIFY_DATA: begin
                    // Verify that the data read matches the test data
                    if (read_data == test_data) begin
                        state <= TEST_PASS;
                        test_pass <= 1;
                    end else begin
                        state <= TEST_FAIL;
                        test_fail <= 1;
                    end
                end
                TEST_PASS: begin
                    // Indicate that the test passed; remain here
                end
                TEST_FAIL: begin
                    // Indicate that the test failed; remain here
                end
                default: state <= INIT;
            endcase
        end
    end
endmodule