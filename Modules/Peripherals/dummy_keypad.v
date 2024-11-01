module dummy_keypad (
    input clk,
    output reg [7:0] dummy_out
);

    initial begin
        dummy_out = 8'h55;  // Initialize dummy_out with a known value
    end

   

endmodule
