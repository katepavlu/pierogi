`timescale 1ns / 1ps

module tb_mux;

    // Testbench variables
    reg [31:0] in0;
    reg [31:0] in1;
    reg control;
    wire [31:0] out;

    // Instantiate the multiplexer module
    mux uut (
        .in0(in0),
        .in1(in1),
        .control(control),
        .out(out)
    );

    // Test procedure
    initial begin
        // Test Case 1: control = 0, expect out = in0
        in0 = 32'hAAAA_AAAA;
        in1 = 32'h5555_5555;
        control = 0;
        #10; // Wait for 10 time units
        $display("Test Case 1: control = %b, out = %h (Expected: %h)", control, out, in0);

        // Test Case 2: control = 1, expect out = in1
        control = 1;
        #10;
        $display("Test Case 2: control = %b, out = %h (Expected: %h)", control, out, in1);

        // Test Case 3: Change in0 and set control = 0, expect out = new in0
        in0 = 32'h1234_5678;
        control = 0;
        #10;
        $display("Test Case 3: control = %b, out = %h (Expected: %h)", control, out, in0);

        // Test Case 4: Change in1 and set control = 1, expect out = new in1
        in1 = 32'h8765_4321;
        control = 1;
        #10;
        $display("Test Case 4: control = %b, out = %h (Expected: %h)", control, out, in1);

        // Finish simulation
        $stop;
    end

endmodule
