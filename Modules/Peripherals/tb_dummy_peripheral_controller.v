`timescale 1ns / 1ps

module tb_dummy_peripheral_controller;

    // Testbench signals
    reg clk;
    reg [3:0] address;
    reg din;
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

        // Test case 1: Read dummy_filtered_out when address = 0
        address = 4'h0;
        #10;
        $display("Test Case 1: Address = 0, expecting dummy_filtered_out on dout.");
        $monitor("Time=%0t | Address=%h | dout=%h", $time, address, dout);
        
        // Wait a few clock cycles to observe dummy_out changes
        #50;

        // Test case 2: Write to display_din when address = 4 and writeEnable = 1
        address = 4'h4;
        writeEnable = 1;
        din = 8'hAA; // Example data to write
        #10;
        $display("Test Case 2: Address = 4, writeEnable = 1, din = %h, expecting display_din updated with din.", din);
        
        // Check if display_din is updated in the display peripheral
        #10;

        // Test case 3: Check that writing does not occur when writeEnable is 0
        writeEnable = 0;
        din = 8'hBB; // New data that should not be written
        #10;
        $display("Test Case 3: Address = 4, writeEnable = 0, din = %h, expecting no change in display_din.", din);

        // End simulation
        #20;
        $finish;
    end
endmodule
