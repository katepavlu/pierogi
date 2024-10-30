module keypad_peripheral(
    output reg [3:0] cols,
    input wire [3:0] rows,
    input wire clk,
    output reg [7:0] out,
    output reg key_ready,   // Indicates a new key is available
    input wire key_read     // Main module asserts this signal after reading the key
);

    // Parameters for column selection
    parameter _1 = 4'b1000;
    parameter _2 = 4'b0100;
    parameter _3 = 4'b0010;
    parameter _4 = 4'b0001;

    reg [7:0] key_code;
    reg [1:0] col_index; // Index to cycle through columns

    initial begin
        cols <= _1;
        out <= 0;
        key_ready <= 0;
        key_code <= 0;
        col_index <= 0;
    end

    always @(posedge clk) begin
        // Reset key_code at each clock cycle
        key_code <= 0;

        // Scanning logic to detect key press
        case (cols)
            _1: begin
                if (rows[0]) key_code <= 8'd49; // '1'
                else if (rows[1]) key_code <= 8'd52; // '4'
                else if (rows[2]) key_code <= 8'd55; // '7'
                else if (rows[3]) key_code <= 8'd42; // '*'
            end
            _2: begin
                if (rows[0]) key_code <= 8'd50; // '2'
                else if (rows[1]) key_code <= 8'd53; // '5'
                else if (rows[2]) key_code <= 8'd56; // '8'
                else if (rows[3]) key_code <= 8'd48; // '0'
            end
            _3: begin
                if (rows[0]) key_code <= 8'd51; // '3'
                else if (rows[1]) key_code <= 8'd54; // '6'
                else if (rows[2]) key_code <= 8'd57; // '9'
                else if (rows[3]) key_code <= 8'd35; // '#'
            end
            _4: begin
                if (rows[0]) key_code <= 8'd65; // 'A'
                else if (rows[1]) key_code <= 8'd66; // 'B'
                else if (rows[2]) key_code <= 8'd67; // 'C'
                else if (rows[3]) key_code <= 8'd68; // 'D'
            end
            default: ;
        endcase

        // Rotate columns for scanning
        case (cols)
            _1: cols <= _2;
            _2: cols <= _3;
            _3: cols <= _4;
            _4: cols <= _1;
            default: cols <= _1;
        endcase

        // Handshaking logic
        if (key_code != 0 && !key_ready) begin
            out <= key_code;
            key_ready <= 1;
        end else if (key_read) begin
            // Main module has read the key
            out <= 0;
            key_ready <= 0;
        end
    end
endmodule