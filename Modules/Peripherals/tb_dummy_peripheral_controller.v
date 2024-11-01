`timescale 1ns / 1ps

module tb_dummy_peripheral_controller;

    // Testbench signals
    reg clk;
    reg [3:0] address;
    reg [7:0] din;
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
        address = 0;
        din = 0;
        writeEnable = 0;
        cols = 0;

        // Wait for the system to stabilize
        #10;

        // Test Case 1: Write value to display_din and check display output
        address = 4'h4;
        writeEnable = 1;
        din = 8'h12; // Example data to write: '18' in decimal
        #10;
        writeEnable = 0; // Disable writing after one cycle

        // Display expected values for hex0, hex1, etc.
        $display("Test Case 1: Address = 4, writeEnable = 1, din = %h (decimal 18)", din);
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

        // Additional Tests: Try different values of display_din if desired

        // Test Case 2: Write another value to display_din and check display output
        #20;
        address = 4'h4;
        writeEnable = 1;
        din = 8'hAB; // Example data to write: '171' in decimal
        #10;
        writeEnable = 0; // Disable writing after one cycle

        $display("Test Case 2: Address = 4, writeEnable = 1, din = %h (decimal 171)", din);
        $display("Expected hex0 to display 1, hex1 to display 7, and hex2 to display 1.");

        // Check display outputs after write
        #10;
        if (hex0 != ~7'b0000110 || hex1 != ~7'b1101111 || hex2 != ~7'b0000110) begin
            $display("ERROR: Incorrect hex output for display_din = 171");
            $display("hex0 = %b, expected ~7'b0000110 (for 1)", hex0);
            $display("hex1 = %b, expected ~7'b1101111 (for 7)", hex1);
            $display("hex2 = %b, expected ~7'b0000110 (for 1)", hex2);
        end else begin
            $display("SUCCESS: Correct hex output for display_din = 171");
        end

        // End simulation
        #20;
        $finish;
    end
endmodule
