module peripheral_controller(
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
    output wire dot,

    output wire [3:0] cols,   // Output to keypad columns
    input wire [3:0] rows,    // Input from keypad rows

    input wire clk,
    input wire reset,
    input wire [3:0] address,
    input wire [7:0] din,         // 8-bit data input for display
    input wire writeEnable,
    output reg [7:0] dout         // 8-bit data output from keypad
);

    reg [7:0] display_din;        // 8-bit internal register for display data
    wire [7:0] keyboard_dout;     // 8-bit output from keypad_peripheral
    wire key_ready;               // Signal indicating new key is available
    reg key_read;                 // Signal to acknowledge key read

    // Instantiate the keypad peripheral
    keypad_peripheral kp0(
        .cols(cols),
        .rows(rows),
        .clk(clk),
        .out(keyboard_dout),
        .key_ready(key_ready),
        .key_read(key_read)
    );

    // Instantiate the display peripheral
    display_peripheral dp0(
        .din(display_din),
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
        .dot(dot)
    );

    // Main logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dout <= 0;
            display_din <= 0;
            key_read <= 0;
        end else begin
            key_read <= 0;  // Default to 0

            if (address == 4'h0) begin
                if (key_ready) begin
                    dout <= keyboard_dout;
                    key_read <= 1;  // Acknowledge the key read
                end else begin
                    dout <= 0;
                end
            end else begin
                dout <= 0;
            end

            if (address == 4'h4 && writeEnable) begin
                display_din <= din;
            end
        end
    end

endmodule