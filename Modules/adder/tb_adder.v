`timescale 1ns / 1ps

module tb_adder;

    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] out;

    // Instantiate the adder module
    adder uut (
        .a(a),
        .b(b),
        .out(out)
    );

    initial begin
        // Test case 1: Simple addition
        a = 32'h0000_0001;
        b = 32'h0000_0002;
        #10;
        $display("Test Case 1: a = %h, b = %h, sum = %h", a, b, out);

        // Test case 2: Maximum positive numbers
        a = 32'h7FFF_FFFF;
        b = 32'h0000_0001;
        #10;
        $display("Test Case 2: a = %h, b = %h, sum = %h", a, b, out);

        // Test case 3: Negative and positive addition (2's complement representation)
        a = 32'hFFFF_FFFF; // -1 in 2's complement
        b = 32'h0000_0001;
        #10;
        $display("Test Case 3: a = %h, b = %h, sum = %h", a, b, out);

        // Test case 4: Overflow case (will wrap around)
        a = 32'h8000_0000;
        b = 32'h8000_0000;
        #10;
        $display("Test Case 4: a = %h, b = %h, sum = %h", a, b, out);

        $stop;
    end

endmodule
