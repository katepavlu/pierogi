`timescale 1ns / 1ps

module tb_dummy_peripheral_controller;

    // Testbench signals
    reg clk;
    reg reset;                // Added reset signal
    reg [3:0] address;
    reg [31:0] din;
    reg writeEnable;
    wire [7:0] dout;
    wire [6:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7, hex8, hex9, hex10;
    wire dot;
    wire [3:0] rows;
    reg [3:0] cols;

    // Instantiate the peripheral_controller module
    peripheral_controller uut (
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
        .reset(reset),           // Connect reset signal
        .address(address),
        .din(din),
        .writeEnable(writeEnable),
        .dout(dout)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test procedure
    initial begin
        // Initialize inputs
        reset = 1;               // Assert reset initially
        address = 0;
        din = 0;
        writeEnable = 0;
        cols = 0;

        // Wait for the system to stabilize
        #10;
        reset = 0;               // Deassert reset after initial setup
        
        // Check if reset worked
        #10;
        if (dout !== 8'h00) $display("Test failed: dout not reset to 0");
        if (uut.display_din !== 32'h00000000) $display("Test failed: display_din not reset to 0");

        // Test Case 1: Read dummy_filtered_out when address = 0
        address = 4'h0;
        #10;
        $display("Test Case 1: Address = 0, expecting dummy_filtered_out on dout.");
        $monitor("Time=%0t | Address=%h | dout=%h", $time, address, dout);

        // Wait a few clock cycles to observe dummy_out changes
        #10;

        // Test Case 2: Write value to display_din and check display output
        address = 4'h4;
        writeEnable = 1;
        din = 32'h00000012; // Example data to write: '18' in decimal
        #10;
        writeEnable = 0; // Disable writing after one cycle

        // Display expected values for hex0, hex1, etc.
        $display("Test Case 2: Address = 4, writeEnable = 1, din = %h (decimal 18)", din);
        $display("Expected hex0 to display 8 and hex1 to display 1.");

        // Check display outputs after write
        #10;
        if (hex0 != ~7'b1101111 || hex1 != ~7'b0000110) begin
            $display("ERROR: Incorrect hex output for display_din = 18");
            $display("hex0 = %b, expected ~7'b1101111 (for 8)", hex0);
            $display("hex1 = %b, expected ~7'b0000110 (for 1)", hex1);
        end else begin
            $display("SUCCESS: Correct hex output for display_din = 18");
        end

        // Test Reset Behavior During Operation
        $display("Asserting reset during operation...");
        reset = 1;
        #10; // Apply reset for one clock cycle
        reset = 0;

        // Check if dout and display_din have been reset
        #10;
        if (dout !== 8'h00) $display("Test failed: dout not reset to 0 after pressing reset");
        if (uut.display_din !== 32'h00000000) $display("Test failed: display_din not reset to 0 after pressing reset");

        // Test if normal operation resumes after reset
        address = 4'h4;
        writeEnable = 1;
        din = 32'hDEADBEEF; // New test data after reset
        #10;
        writeEnable = 0;

        if (uut.display_din !== 32'hDEADBEEF) $display("Test failed: display_din did not update after reset");

        // Final display check (adjust based on display logic)
        $display("Final display check after reset and data write.");
        #10;
        // Additional checks for display segments can go here.

        // End simulation
        $display("All tests completed.");
        $finish;
    end
endmodule
