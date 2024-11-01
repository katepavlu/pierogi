`timescale 1ns / 1ps

module peripheral_controller_tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg [3:0] address;
    reg [7:0] din;
    reg writeEnable;
    wire [7:0] dout;

    wire [6:0] hex0;
    wire [6:0] hex1;
    wire [6:0] hex2;
    wire [6:0] hex3;
    wire [6:0] hex4;
    wire [6:0] hex5;
    wire [6:0] hex6;
    wire [6:0] hex7;
    wire [6:0] hex8;
    wire [6:0] hex9;
    wire [6:0] hex10;
    wire dot;

    wire [3:0] cols;
    reg [3:0] rows;

    // Instantiate the peripheral controller
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
        .cols(cols),
        .rows(rows),
        .clk(clk),
        .reset(reset),
        .address(address),
        .din(din),
        .writeEnable(writeEnable),
        .dout(dout)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10 ns clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        reset = 1;
        address = 4'h0;
        din = 8'd0;
        writeEnable = 0;
        rows = 4'b0000;

        // Wait for reset to be processed
        #20;
        reset = 0;

        // Simulate a key press on the keypad
        // Assume the user presses the '2' key
        // '2' key is detected when cols[3] is active and rows[0] is pressed
        // Since cols are controlled by the keypad peripheral, we need to synchronize with it
        // For simplicity, we'll wait some time and then set rows[0] high
        #100;
        rows = 4'b0001;  // Simulate pressing '2' key

        // Wait for the peripheral to process the key press
        #100;

        // Read data from the keypad by setting address to 0
        address = 4'h0;
        #10;
        $display("Read dout: %d (ASCII code)", dout);

        // Release the key press
        rows = 4'b0000;

        // Wait some time
        #50;

        // Write data to the display
        address = 4'h4;
        din = 8'd65;       // ASCII code for 'A'
        writeEnable = 1;
        #10;
        writeEnable = 0;

        // Wait to observe the display outputs
        #100;

        // Finish simulation
        $stop;
    end

endmodule