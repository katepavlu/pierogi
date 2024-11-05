module cpu_logic(
    input wire clk, // 50 MHz
    input rst,
    output reg [31:0] instruction, address,
    output reg [31:0] pc,
    output wire [1:0]state,
    output M13, M2, M457, M6, Wr_en, Eq, pc_flag, instruction_flag, change_address_flag, Wr_en_rf,
    output [3:0] ALU,
    output [31:0] mux3_out, mux7_out,
    
    output [31:0]memory_out, mux5_out1, mux6_out,
    
    inout [35:0] GPIO_1,
    output [35:0] GPIO_0,
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
    
);


/*
wire PLL_clk;
wire PLL_lock;

assign clk = PLL_clk & PLL_lock;

pll pll1 (
		.refclk(CLOCK_50),   //  refclk.clk
		.rst(!rst),      //   reset.reset
		.outclk_0(PLL_clk),  // outclk0.clk
        .locked(PLL_lock)
	);
*/
    
// Memory unit
wire [31:0] Ra_rf, Rb_rf;

// Initialize opcode, registers
wire [3:0] opcode, Ra, Rb, Rd;
wire [15:0] imm;
wire [31:0] extended_imm;

// Instruction decoding
assign opcode = instruction[31:28];
assign Rd = instruction[27:24];
assign Ra = instruction[23:20];
assign Rb = instruction[19:16];
assign imm = instruction[15:0];

// Mux outputs
wire [31:0] mux1_out, mux2_out, adder_out, ALU_out, mux5_out0, mux4_out0;

// Declare outputs for mux4 and mux5
wire [31:0] mux4_out1;

// Initialize pc
initial begin 
    pc <= 32'b0;
end

// Address to pc and instruction fetch
always @(*) begin
    if (change_address_flag  == 1'b1) begin
        address = mux4_out0;
    end else begin
        address = pc;
    end
end

always @(posedge clk) begin
    if (instruction_flag  == 1'b1)
        instruction <= memory_out;
end


// Always block to update 'pc'
always @(posedge clk) begin
        if (!rst)
            pc <= 32'b0;
        else  if (pc_flag==1'b1)
            pc <= mux1_out;
        
end

// Equality check
assign Eq = (Ra_rf == Rb_rf) ? 1'b1 : 1'b0;

// Adder instance
adder add (
    .a(pc),
    .b(mux2_out),
    .out(adder_out)
);

// Register file instance
register_file RF (
    .clk(clk),
    .wen(Wr_en_rf),
    .rst_n(rst),
    .read_Ra(Ra),
    .read_Rb(Rb),
    .write_Rd(Rd),
    .write_data(mux3_out),
    .data_Ra(Ra_rf),
    .data_Rb(Rb_rf)
);

// Control unit instance
control ctrl (
	.clk(clk),
    .reset(rst),
    .opcode(opcode),
    .Eq(Eq),
    .M13(M13),
    .M2(M2),
    .M457(M457),
    .M6(M6),
    .state(state),
    .pc_flag(pc_flag),
    .change_address_flag(change_address_flag),
    .instruction_flag(instruction_flag),
    .ALU(ALU),
    .Wr_en(Wr_en),
    .Wr_en_rf(Wr_en_rf)
);

// Sign extension instance
sign_extend extend (
    .immediate(imm),
    .extended_immediate(extended_imm)
);

// Multiplexer instances
mux mux1 (
    .in0(adder_out),
    .in1(Ra_rf),
    .control(M13),
    .out(mux1_out)
);

mux mux2 (
    .in0(32'd4),
    .in1(extended_imm),
    .control(M2),
    .out(mux2_out)
);

mux mux3 (
    .in0(mux7_out),
    .in1(pc + 4),
    .control(M13),
    .out(mux3_out)
);

mux mux6 (
    .in0(mux4_out1),
    .in1(extended_imm),
    .control(M6),
    .out(mux6_out)
);

mux mux7 (
    .in0(memory_out),
    .in1(ALU_out),
    .control(M457),
    .out(mux7_out)
);

// Decoder instances
decoder mux4 (
    .in(Rb_rf),
    .control(M457),
    .out0(mux4_out0),
    .out1(mux4_out1)
);

decoder mux5 (
    .in(Ra_rf),
    .control(M457),
    .out0(mux5_out0),
    .out1(mux5_out1)
);

// ALU instance
ALU alu (
    .AluOp(ALU),
    .busA(mux5_out1),
    .busB(mux6_out),
    .outBus(ALU_out)
);


// Memory instantiate
memory_integrated mem(
    .dataInVirt(mux5_out0),
    .addressVirt(address),
    .wEnVirt(Wr_en),
    .rstVirt(rst),
    .clk(clk),
    .dataOutVirt(memory_out),
    
    .hex0(HEX0),
    .hex1(HEX1),
    .hex2(HEX2),
    .hex3(HEX3),
    .hex4(HEX4),
    .hex5(HEX5),
    .hex6(GPIO_0[6:0]),
    .hex7(GPIO_0[13:7]),
    .hex8(GPIO_0[20:14]),
    .hex9(GPIO_0[27:21]),
    .hex10(GPIO_0[34:28]),
    .dot(GPIO_0[35]),
 
    .cols(GPIO_1[33:30]),
    .rows(GPIO_1[29:26])
);
   



endmodule

module cpu(
    input wire CLOCK_50, // 50 MHz
    input [3:0]KEY,
 
    inout [35:0] GPIO_1,
    output [35:0] GPIO_0,
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
    
);

cpu_logic cpu0 (
    .clk(CLOCK_50), // 50 MHz
    .rst(KEY[1]),
    .GPIO_1(GPIO_1),
    .GPIO_0(GPIO_0),
    .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5)
    );

endmodule
