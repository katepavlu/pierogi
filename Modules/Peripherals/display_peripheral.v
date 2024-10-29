// hex_driver module
module hex_driver(
    input [3:0] din, 
    output reg [6:0] LEDpins
);
    // 7-segment encoding for each hexadecimal digit
    always @(*) begin
        case (din)
            4'h0: LEDpins = ~7'b0111111;  // '0'
            4'h1: LEDpins = ~7'b0000110;  // '1'
            4'h2: LEDpins = ~7'b1011011;  // '2'
            4'h3: LEDpins = ~7'b1001111;  // '3'
            4'h4: LEDpins = ~7'b1100110;  // '4'
            4'h5: LEDpins = ~7'b1101101;  // '5'
            4'h6: LEDpins = ~7'b1111101;  // '6'
            4'h7: LEDpins = ~7'b0000111;  // '7'
            4'h8: LEDpins = ~7'b1111111;  // '8'
            4'h9: LEDpins = ~7'b1101111;  // '9'
            4'hA: LEDpins = ~7'b1110111;  // 'A'
            4'hB: LEDpins = ~7'b1111100;  // 'B'
            4'hC: LEDpins = ~7'b0111001;  // 'C'
            4'hD: LEDpins = ~7'b1011110;  // 'D'
            4'hE: LEDpins = ~7'b1111001;  // 'E'
            4'hF: LEDpins = ~7'b1110001;  // 'F'
            default: LEDpins = 7'b0000000;  // All segments off by default
        endcase
    end
endmodule

// display_peripheral module
module display_peripheral(
    input wire signed [31:0] din,
    output wire [6:0] hex0,
    output wire [6:0] hex1,
    output wire [6:0] hex2,
    output wire [6:0] hex3,
    output wire [6:0] hex4,
    output wire [6:0] hex5,
    output wire [6:0] hex6,
    output wire [6:0] hex7,
    output wire [6:0] hex8,
    output wire [6:0] hex9,
    output wire [6:0] hex10,
    output wire dot
);
    wire [31:0] dinabs;
    
    // Get the absolute value of din
    assign dinabs = (din < 0) ? -din : din;
    
    // Instantiate hex_driver modules for each digit in the display
    hex_driver d0(
        .din((dinabs / 1) % 10),
        .LEDpins(hex0)
    );
    hex_driver d1(
        .din((dinabs / 10) % 10),
        .LEDpins(hex1)
    );
    hex_driver d2(
        .din((dinabs / 100) % 10),
        .LEDpins(hex2)
    );
    hex_driver d3(
        .din((dinabs / 1_000) % 10),
        .LEDpins(hex3)
    );
    hex_driver d4(
        .din((dinabs / 10_000) % 10),
        .LEDpins(hex4)
    );
    hex_driver d5(
        .din((dinabs / 100_000) % 10),
        .LEDpins(hex5)
    );
    hex_driver d6(
        .din((dinabs / 1_000_000) % 10),
        .LEDpins(hex6)
    );
    hex_driver d7(
        .din((dinabs / 10_000_000) % 10),
        .LEDpins(hex7)
    );
    hex_driver d8(
        .din((dinabs / 100_000_000) % 10),
        .LEDpins(hex8)
    );
    hex_driver d9(
        .din((dinabs / 1_000_000_000) % 10),
        .LEDpins(hex9)
    );

    // Handle the sign bit in hex10
    // If din is negative, hex10 will have a '-' symbol, otherwise it's blank
    assign hex10 = (din < 0) ? ~7'b0000001 : ~7'b0000000;  // '-' symbol if negative, blank otherwise
    
    // Set dot to 1 (off) for simplicity; modify if you want a specific behavior
    assign dot = 1;

endmodule