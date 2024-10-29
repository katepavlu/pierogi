`timescale 1ns / 1ps

module peripheral_controller_tb;

    // Testbench signals
    reg clk;
    reg [3:0] address;
    reg din;
    reg writeEnable;
    reg [3:0] cols;        // Simulate keypad column inputs
    
    wire [6:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7, hex8, hex9, hex10;
    wire dot;
    wire [3:0] rows;       // Keypad row outputs
    wire dout;

    // Instantiate the peripheral_controller
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
        forever #5 clk = ~clk;  // 10 ns clock period (100 MHz)
    end

    // Test procedure
    initial begin
        // Initialize inputs
        address = 4'b0000;
        din = 0;
        writeEnable = 0;
        cols = 4'b0000;
        
        // Wait for global reset
        #10;
        
        // Test 1: Read Operation (address = 0)
        // Expect dout to reflect the value of keyboard_dout
        address = 4'h0;
        cols = 4'b1010;     // Set keypad column input to simulate a key press
        #10;
        
        $display("Test 1: Read Operation - address 0");
        if (dout === uut.keyboard_dout)
            $display("PASS: dout matches keyboard_dout");
        else
            $display("FAIL: dout does not match keyboard_dout");

        // Test 2: Write Operation (address = 4, writeEnable = 1)
        // Expect display_din to reflect din and be used by display_peripheral
        address = 4'h4;
        din = 1'b1;
        writeEnable = 1;
        #10;

        $display("Test 2: Write Operation - address 4, writeEnable 1");
        if (uut.display_din === din)
            $display("PASS: display_din matches din");
        else
            $display("FAIL: display_din does not match din");

        // Test 3: Write Operation without writeEnable (address = 4, writeEnable = 0)
        // Expect display_din to NOT update
        din = 1'b0;
        writeEnable = 0;
        #10;

        $display("Test 3: Write Operation without writeEnable - address 4, writeEnable 0");
        if (uut.display_din !== din)
            $display("PASS: display_din did not update when writeEnable is 0");
        else
            $display("FAIL: display_din updated when writeEnable is 0");

        // Test complete
        $stop;
    end

endmodule