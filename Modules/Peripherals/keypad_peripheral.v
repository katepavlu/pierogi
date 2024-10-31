module keypad_peripheral(
    output reg [3:0] cols,
    input wire [3:0] rows,
    input clk,
	 output reg [7:0] out);


    parameter _4 = 4'b0001;
    parameter _3 = 4'b0010;
    parameter _2 = 4'b0100;
    parameter _1 = 4'b1000;
    
    reg [7:0] c1, c2, c3, c4;
    reg [19:0] debounce_counter;  // debounce timer
    reg debounce_active;
    reg [7:0] key_value;  

    initial begin
        cols <= _1;
        out <= 0;
        key_value <= 0;
        debounce_counter <= 0;
        debounce_active <= 0;
    end

    // Keypad scanning and debounce logic
    always @(posedge clk) begin
        // Debounce logic
        if (debounce_active) begin
            if (debounce_counter < 20'hFFFFF) begin
                debounce_counter <= debounce_counter + 1;
            end else begin
                debounce_active <= 0;
                debounce_counter <= 0;
                key_value <= out;  // latch the keypress
            end
        end else begin
            // Key scanning logic with column cycling
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

            // Assign output only if one key is pressed
            if (c1 != 0 && c2 == 0 && c3 == 0 && c4 == 0) out <= c1;
            else if (c1 == 0 && c2 != 0 && c3 == 0 && c4 == 0) out <= c2;
            else if (c1 == 0 && c2 == 0 && c3 != 0 && c4 == 0) out <= c3;
            else if (c1 == 0 && c2 == 0 && c3 == 0 && c4 != 0) out <= c4;
            else out <= 0;

            // Trigger debounce when a valid key is detected
            if (out != 0 && !debounce_active) begin
                debounce_active <= 1;
                debounce_counter <= 0;
            end
        end
    end

endmodule

