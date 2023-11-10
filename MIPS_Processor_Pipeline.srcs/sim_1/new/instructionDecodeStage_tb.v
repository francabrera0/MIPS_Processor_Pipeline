`timescale 1ns / 1ps

module instructionDecodeStage_tb();

    localparam DATA_LEN = 32;
    localparam OPCODE_LEN = 6;
    localparam ADDRESS_LEN = 5;
    localparam REGISTERS = 32;
    localparam IMMEDIATE_LEN = 16;
    
    reg i_clk;
    reg i_reset;
    reg [DATA_LEN-1:0] i_instruction;
    reg i_regWrite;
    reg [ADDRESS_LEN-1:0] i_writeRegister;
    reg [DATA_LEN-1:0] i_writeData;

    wire o_regWrite;
    wire o_aluSrc;
    wire [1:0] o_aluOp;
    wire o_branch;
    wire o_regDest;
    wire [DATA_LEN-1:0] o_readData1;
    wire [DATA_LEN-1:0] o_readData2;
    wire [DATA_LEN-1:0] o_immediateExtendValue;
    wire [ADDRESS_LEN-1:0] o_rt;
    wire [ADDRESS_LEN-1:0] o_rd;


instructionDecodeStage#(
    .DATA_LEN(DATA_LEN),
    .OPCODE_LEN(OPCODE_LEN),
    .ADDRESS_LEN(ADDRESS_LEN),
    .REGISTERS(REGISTERS),
    .IMMEDIATE_LEN(IMMEDIATE_LEN)
) instructionDecodeStage
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_instruction(i_instruction),
    .i_regWrite(i_regWrite),
    .i_writeRegister(i_writeRegister),
    .i_writeData(i_writeData),

    .o_regWrite(o_regWrite),
    .o_aluSrc(o_aluSrc),
    .o_aluOp(o_aluOp),
    .o_branch(o_branch),
    .o_regDest(o_regDest),
    .o_readData1(o_readData1),
    .o_readData2(o_readData2),
    .o_immediateExtendValue(o_immediateExtendValue),
    .o_rt(o_rt),
    .o_rd(o_rd)
);


always begin
    #10 i_clk = ~i_clk;
end

integer i;
initial begin
    i_clk = 1'b0;
    i_writeRegister = {ADDRESS_LEN{1'b0}};
    i_regWrite = 1'b0;
    i_writeData = {DATA_LEN{1'b0}};

    i_reset = 1'b1;
    #20;
    i_reset = 1'b0;

    for(i=0; i<REGISTERS; i=i+1) begin
        i_regWrite = 1'b1;
        i_writeRegister = i;
        i_writeData = i*2;
        #20;
    end
    i_regWrite = 1'b0;

    //Opcode = 000000
    //rs = 01101 = 0xD --> data1 = 0x1a
    //rt = 11100 = 0x1C --> data2 = 0x38
    //rd = 10101 = 0x15
    // Señales = 110001
    i_instruction = 32'b00000001101111001010100000100000;
    #10;
    //Opcode = 100011
    //base(rs) = 11111 = 0x1f --> data1 = 0x3E
    //rt = 00111 = 0x7 --> data2 = 0xE
    //imm = 0000000000001111 = 0x0f
    //Señales = 000101
    i_instruction = 32'b10001111111001110000000000001111;
    #10;
    //Opcode = 101011
    //base(rs) = 01000 = 0x8 --> data1 = 0x10
    //rt = 00001 = 0x1 --> data2 = 0x2
    //imm = 0000000000001111 = 0xf 
    //Señales = -00100
    i_instruction = 32'b10101101000000010000000000001111;
    #10;
    //Opcode = 000100
    //rs = 11100 = 0x1C --> data1 = 0x38
    //rt = 00111 = 0x7 --> data2 = 0xE
    //Imm = 10000 = 0x16
    //Señales = -01010
    i_instruction = 32'b00010011100001110000000000010000;
    #10;

end

endmodule
