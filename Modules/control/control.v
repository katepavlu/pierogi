module control(
    input clk,
    input reset,
    input wire [3:0] opcode,
    input wire Eq, 
    output reg M13, 
    output reg M2,
    output reg M457,
    output reg M6,
    output reg pc_flag, 
    output reg instruction_flag,
    output reg change_address_flag,
    output reg Wr_en_rf,
    output reg state,
    output reg [3:0] ALU,
    output reg Wr_en
    );

    initial begin
        M13 = 1'b0;
        M2 = 1'b0;
        M457 = 1'b0;
        M6 = 1'b0;
        pc_flag <= 0;
        instruction_flag <= 1'b0;
        change_address_flag <= 1'b0;
        ALU = 4'b0000;
        Wr_en <= 1'b0;
        state <= 1'b0;
    end

    // State machine for sequential control
always @(posedge clk) begin
    case (state)
        1'b0: begin
            state <= 1'b1;
        end
        1'b1: begin
            state <= 1'b0;
        end
    endcase
end

always @(*) begin
    Wr_en <= 0;
    pc_flag <= 0;
    instruction_flag <= 0;
    Wr_en_rf <= 0;
    case (state)
        1'b0: begin
            change_address_flag <= 1;
            Wr_en <= 0;
            pc_flag <= 1;
            Wr_en_rf <= 1;
            instruction_flag <= 0;
        end
        1'b1: begin
            change_address_flag <= 0;
            if (opcode == 4'b1111)
                Wr_en <= 1;
            Wr_en_rf <= 0;
            pc_flag <= 0;
            instruction_flag <= 1;
        end
    endcase
end


    // Opcode logic for combinational control
    always @(*) begin
        if (reset == 1'b0) begin
            M13 = 1'b0;
            M2 = 1'b0;
            M457 = 1'b0;
            M6 = 1'b0;
            ALU = 4'b0000;
        end else begin
            M13 = 1'b0;
            M2 = 1'b0;
            M457 = 1'b0;
            M6 = 1'b0;
            ALU = 4'b0000;
            case (opcode)
                4'b0000: begin // and
                    M13 = 1'b0;
                    M2 = 1'b0;
                    M457 = 1'b1;
                    M6 = 1'b0;
                    ALU = 4'b0000;
                end
                4'b0001: begin // or
                    M13 = 1'b0;
                    M2 = 1'b0;
                    M457 = 1'b1;
                    M6 = 1'b0;
                    ALU = 4'b0001;
                end
                4'b0010: begin // xor
                    M13 = 1'b0;
                    M2 = 1'b0;
                    M457 = 1'b1;
                    M6 = 1'b0;
                    ALU = 4'b0010;
                end
                4'b0011: begin // not
                    M13 = 1'b0;
                    M2 = 1'b0;
                    M457 = 1'b1;
                    ALU = 4'b0011;
                end
                4'b0100: begin // add
                    M13 = 1'b0;
                    M2 = 1'b0;
                    M457 = 1'b1;
                    M6 = 1'b0;
                    ALU = 4'b0100;
                end
                4'b0101: begin // sub
                    M13 = 1'b0;
                    M2 = 1'b0;
                    M457 = 1'b1;
                    M6 = 1'b0;
                    ALU = 4'b0101;
                end
                4'b0110: begin // cmp
                    M13 = 1'b0;
                    M2 = 1'b0;
                    M457 = 1'b1;
                    M6 = 1'b0;
                    ALU = 4'b0110;
                end
                4'b0111: begin // j
                    M13 = 1'b1;
                    M2 = 1'b1;
                end
                4'b1000: begin // beq
                    M13 = 1'b0;
                    M2 = Eq;
                end
                4'b1001: begin // bne
                    M13 = 1'b0;
                    M2 = ~Eq;
                end
                4'b1010: begin // sl
                    M13 = 1'b0;
                    M2 = 1'b0;
                    M457 = 1'b1;
                    M6 = 1'b1;
                    ALU = 4'b1010;
                end
                4'b1011: begin // sr
                    M13 = 1'b0;
                    M2 = 1'b0;
                    M457 = 1'b1;
                    M6 = 1'b1;
                    ALU = 4'b1011;
                end
                4'b1100: begin // addi
                    M13 = 1'b0;
                    M2 = 1'b0;
                    M457 = 1'b1;
                    M6 = 1'b1;
                    ALU = 4'b0100;
                end
                4'b1101: begin // lui
                    M13 = 1'b0;
                    M2 = 1'b0;
                    M457 = 1'b1;
                    M6 = 1'b1;
                    ALU = 4'b1101;
                end
                4'b1110: begin // lw
                    M13 = 1'b0;
                    M2 = 1'b0;
                    M457 = 1'b0;
                end
                4'b1111: begin // sw
                    M13 = 1'b0;
                    M2 = 1'b0;
                    M457 = 1'b0;
                end
            endcase
        end
    end
endmodule
