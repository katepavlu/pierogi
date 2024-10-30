module keypad_peripheral(
    output reg [3:0] cols,
    input wire [3:0] rows,
    input clk,
    output reg [6:0] hex0,  // HEX0 display (active low)
    output reg [6:0] hex1   // HEX1 display (active low)
);
    parameter _4 = 4'b0001;
    parameter _3 = 4'b0010;
    parameter _2 = 4'b0100;
    parameter _1 = 4'b1000;
    
    reg [7:0] c1, c2, c3, c4;
    reg [7:0] out;

    initial begin
        cols <= _1;
        out <= 0;
    end

    always @(posedge clk) begin
        case(cols)
            _1: begin
                case (rows)
                    _1: c1 <= 8'd49; // '1'
                    _2: c1 <= 8'd52; // '4'
                    _3: c1 <= 8'd55; // '7'
                    _4: c1 <= 8'd42; // '*'
                    default: c1 <= 0;
                endcase
                cols <= _2;
            end
            _2: begin
                case (rows)
                    _1: c2 <= 8'd50; // '2'
                    _2: c2 <= 8'd53; // '5'
                    _3: c2 <= 8'd56; // '8'
                    _4: c2 <= 8'd48; // '0'
                    default: c2 <= 0;
                endcase
                cols <= _3;
            end
            _3: begin
                case (rows)
                    _1: c3 <= 8'd51; // '3'
                    _2: c3 <= 8'd54; // '6'
                    _3: c3 <= 8'd57; // '9'
                    _4: c3 <= 8'd35; // '#'
                    default: c3 <= 0;
                endcase
                cols <= _4;
            end
            _4: begin
                case (rows)
                    _1: c4 <= 8'd65; // 'A'
                    _2: c4 <= 8'd66; // 'B'
                    _3: c4 <= 8'd67; // 'C'
                    _4: c4 <= 8'd68; // 'D'
                    default: c4 <= 0;
                endcase
                cols <= _1;
            end
            default: cols <= _1;
        endcase

        // Determine which value to output
        if (c1 != 0 && c2 == 0 && c3 == 0 && c4 == 0) out <= c1;
        else if (c1 == 0 && c2 != 0 && c3 == 0 && c4 == 0) out <= c2;
        else if (c1 == 0 && c2 == 0 && c3 != 0 && c4 == 0) out <= c3;
        else if (c1 == 0 && c2 == 0 && c3 == 0 && c4 != 0) out <= c4;
        else out <= 0;
    end

    // Hex display decoder for HEX0 and HEX1
    always @(*) begin
        hex0 = segment_decoder(out[3:0]);    // Lower nibble of ASCII value
        hex1 = segment_decoder(out[7:4]);    // Upper nibble of ASCII value
    end

    // Seven-segment display decoder function
    function [6:0] segment_decoder;
        input [3:0] bin;
        case (bin)
            4'h0: segment_decoder = 7'b100_0000; // 0
            4'h1: segment_decoder = 7'b111_1001; // 1
            4'h2: segment_decoder = 7'b010_0100; // 2
            4'h3: segment_decoder = 7'b011_0000; // 3
            4'h4: segment_decoder = 7'b001_1001; // 4
            4'h5: segment_decoder = 7'b001_0010; // 5
            4'h6: segment_decoder = 7'b000_0010; // 6
            4'h7: segment_decoder = 7'b111_1000; // 7
            4'h8: segment_decoder = 7'b000_0000; // 8
            4'h9: segment_decoder = 7'b001_0000; // 9
            4'hA: segment_decoder = 7'b000_1000; // A
            4'hB: segment_decoder = 7'b000_0011; // b
            4'hC: segment_decoder = 7'b100_0110; // C
            4'hD: segment_decoder = 7'b010_0001; // d
            4'hE: segment_decoder = 7'b000_0110; // E
            4'hF: segment_decoder = 7'b000_1110; // F
            default: segment_decoder = 7'b111_1111; // Off
        endcase
    endfunction
endmodule
