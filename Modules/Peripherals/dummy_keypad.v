module dummy_keypad (
    input clk,
    output reg [31:0] dummy_out
);

    initial begin
        dummy_out = 32'h55;  // Initialize dummy_out with a known value
    end

   

endmodule

