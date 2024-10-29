module control_tb;

  // Inputs
  reg [31:0] instruction;
  reg Eq;

  // Outputs
  wire M1, M2, M3, M4, M5, M6, M7;
  wire [3:0] ALU;
  wire Wr_en;

  // Instantiate the control module
  control uut (
    .instruction(instruction),
    .Eq(Eq),
    .M1(M1),
    .M2(M2),
    .M3(M3),
    .M4(M4),
    .M5(M5),
    .M6(M6),
    .M7(M7),
    .ALU(ALU),
    .Wr_en(Wr_en)
  );

  // Test procedure
  initial begin
    // Initialize inputs
    instruction = 0;
    Eq = 0;

    // Test each opcode
    $display("Starting control module testbench...");

    // Test AND (opcode = 4'b0000)
    instruction = 32'h0000_0000; // First 4 bits (31:28) = 4'b0000
    #10;
    $display("AND: M1=%b, M2=%b, M3=%b, M4=%b, M5=%b, M6=%b, M7=%b, ALU=%b, Wr_en=%b", M1, M2, M3, M4, M5, M6, M7, ALU, Wr_en);

    // Test OR (opcode = 4'b0001)
    instruction = 32'h1000_0000; // First 4 bits (31:28) = 4'b0001
    #10;
    $display("OR: M1=%b, M2=%b, M3=%b, M4=%b, M5=%b, M6=%b, M7=%b, ALU=%b, Wr_en=%b", M1, M2, M3, M4, M5, M6, M7, ALU, Wr_en);

    // Test XOR (opcode = 4'b0010)
    instruction = 32'h2000_0000;
    #10;
    $display("XOR: M1=%b, M2=%b, M3=%b, M4=%b, M5=%b, M6=%b, M7=%b, ALU=%b, Wr_en=%b", M1, M2, M3, M4, M5, M6, M7, ALU, Wr_en);

    // Test NOT (opcode = 4'b0011)
    instruction = 32'h3000_0000;
    #10;
    $display("NOT: M1=%b, M2=%b, M3=%b, M4=%b, M5=%b, M6=%b, M7=%b, ALU=%b, Wr_en=%b", M1, M2, M3, M4, M5, M6, M7, ALU, Wr_en);

    // Test ADD (opcode = 4'b0100)
    instruction = 32'h4000_0000;
    #10;
    $display("ADD: M1=%b, M2=%b, M3=%b, M4=%b, M5=%b, M6=%b, M7=%b, ALU=%b, Wr_en=%b", M1, M2, M3, M4, M5, M6, M7, ALU, Wr_en);

    // Test SUB (opcode = 4'b0101)
    instruction = 32'h5000_0000;
    #10;
    $display("SUB: M1=%b, M2=%b, M3=%b, M4=%b, M5=%b, M6=%b, M7=%b, ALU=%b, Wr_en=%b", M1, M2, M3, M4, M5, M6, M7, ALU, Wr_en);

    // Test CMP (opcode = 4'b0110)
    instruction = 32'h6000_0000;
    #10;
    $display("CMP: M1=%b, M2=%b, M3=%b, M4=%b, M5=%b, M6=%b, M7=%b, ALU=%b, Wr_en=%b", M1, M2, M3, M4, M5, M6, M7, ALU, Wr_en);

    // Test J (opcode = 4'b0111)
    instruction = 32'h7000_0000;
    #10;
    $display("J: M1=%b, M2=%b, M3=%b, M4=%b, M5=%b, M6=%b, M7=%b, ALU=%b, Wr_en=%b", M1, M2, M3, M4, M5, M6, M7, ALU, Wr_en);

    // Test BEQ (opcode = 4'b1000) with Eq=1
    instruction = 32'h8000_0000;
    Eq = 1;
    #10;
    $display("BEQ (Eq=1): M1=%b, M2=%b, M3=%b, M4=%b, M5=%b, M6=%b, M7=%b, ALU=%b, Wr_en=%b", M1, M2, M3, M4, M5, M6, M7, ALU, Wr_en);

    // Test BNE (opcode = 4'b1001) with Eq=0
    instruction = 32'h9000_0000;
    Eq = 0;
    #10;
    $display("BNE (Eq=0): M1=%b, M2=%b, M3=%b, M4=%b, M5=%b, M6=%b, M7=%b, ALU=%b, Wr_en=%b", M1, M2, M3, M4, M5, M6, M7, ALU, Wr_en);

    // Add additional test cases for each opcode as needed...

    $display("Testbench complete.");
  end

endmodule
