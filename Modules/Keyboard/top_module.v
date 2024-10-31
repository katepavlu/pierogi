module top_module(
    input wire clk,
    input wire [3:0] rows,
    output wire [3:0] cols,
    output wire [6:0] seg,
    output wire [3:0] anodes // Assuming 4 active-low displays
);

    wire [3:0] hex_digit;
    
    // Instantiate keypad peripheral
    keypad_peripheral kp(
        .cols(cols),
        .rows(rows),
        .clk(clk),
        .hex_digit(hex_digit)
    );

    // Instantiate seven-segment decoder
    hex_to_7seg decoder(
        .hex_digit(hex_digit),
        .seg(seg)
    );

    // Anode control (only display on the first display, modify if needed)
    assign anodes = 4'b1110; // Activate one display at a time (change for multiplexing)
endmodule