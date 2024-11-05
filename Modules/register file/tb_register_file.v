`timescale 1ns / 1ps

module tb_register_file;
    // Inputs
    reg clk;
    reg rst_n;
    reg wen;
    reg [3:0] read_Ra;
    reg [3:0] read_Rb;
    reg [3:0] write_Rd;
    reg [31:0] write_data;

    // Outputs
    wire [31:0] data_Ra;
    wire [31:0] data_Rb;

    // Instantiate the register file module
    register_file uut (
        .clk(clk),
        .rst_n(rst_n),
        .wen(wen),
        .read_Ra(read_Ra),
        .read_Rb(read_Rb),
        .write_Rd(write_Rd),
        .write_data(write_data),
        .data_Ra(data_Ra),
        .data_Rb(data_Rb)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    // Test procedure
    initial begin
        // Initialize inputs
        rst_n = 0;
        wen = 0;
        read_Ra = 0;
        read_Rb = 1;
        write_Rd = 0;
        write_data = 0;

        // Apply reset
        #10 rst_n = 1;   // Release reset after 10ns

        // Test 1: Write to register 1 and read it back
        #10 wen = 1;
        write_Rd = 4'd1;
        write_data = 32'hA5A5A5A5;
        #10 wen = 0;     // Disable write enable

        // Read register 1 to data_Ra
        read_Ra = 4'd1;
        #10;

        // Test 2: Write to register 2 and read it back on data_Rb
        #10 wen = 1;
        write_Rd = 4'd2;
        write_data = 32'h5A5A5A5A;
        #10 wen = 0;

        // Read register 2 to data_Rb
        read_Rb = 4'd2;
        #10;

        // Test 3: Reset and verify that registers are cleared
        rst_n = 0;
        #10 rst_n = 1;

        // Check if register 1 and register 2 are reset to 0
        read_Ra = 4'd1;
        read_Rb = 4'd2;
        #10;

        // Test 4: Write to register 0 and confirm that it always reads as 0
        wen = 1;
        write_Rd = 4'd0;
        write_data = 32'hFFFFFFFF;
        #10 wen = 0;

        read_Ra = 4'd0;
        #10;

        // Finish the simulation
        $stop;
    end
endmodule
