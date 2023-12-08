`timescale 1ns / 1ps

module cpuFowarding_tb();

    localparam DATA_LEN = 32;
    localparam PC_LEN = 32;
    localparam MEM_SIZE_ADDRESS_BITS = 10; //Bits to address instruction memory;
    localparam OPCODE_LEN = 6; 
    localparam REGISTER_BITS = 5; //Cantidad de bits que direccionan registros
    localparam IMMEDIATE_LEN = 16;
    localparam FUNCTION_LEN = 6;

    localparam NOP = {32{1'b1}};

    reg i_clk;
    reg i_reset;
    reg i_writeInstruction;
    reg i_enable;
    reg [DATA_LEN-1:0] i_instructionToWrite;
    reg [REGISTER_BITS-1:0] i_regMemAddress;
    reg i_regMemCtrl;
    
    wire [DATA_LEN-1:0] o_regMemValue;
    wire o_halt;

cpu#(
    .DATA_LEN(DATA_LEN),
    .PC_LEN(PC_LEN),
    .MEM_SIZE_ADDRESS_BITS(MEM_SIZE_ADDRESS_BITS),
    .OPCODE_LEN(OPCODE_LEN), 
    .REGISTER_BITS(REGISTER_BITS),
    .IMMEDIATE_LEN(IMMEDIATE_LEN),
    .FUNCTION_LEN(FUNCTION_LEN)
) cpu
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_writeInstruction(i_writeInstruction),
    .i_enable(i_enable),
    .i_instructionToWrite(i_instructionToWrite),
    .i_regMemAddress(i_regMemAddress),
    .i_regMemCtrl(i_regMemCtrl),
    .o_regMemValue(o_regMemValue),
    .o_halt(o_halt)
);


always begin
    #10 i_clk = ~i_clk;
end

integer i;

initial begin
    i_clk = 1'b0;
    i_writeInstruction = 1'b0;
    i_enable = 1'b0;
    i_reset = 1'b1;
    i_regMemAddress = 0;
    i_regMemCtrl = 0;
    #20;
    i_reset = 1'b0;
    
    i_writeInstruction = 1'b1;
    //ADDI 10 to r3 2 veces
    i_instructionToWrite = 32'h2063000a;
    #40
    //Store r3 en direccion r[0]+0
    i_instructionToWrite = 32'hac030000;
    #20
    //ADDI 5 to r3
    i_instructionToWrite = 32'h20630005;
    #20
    //Add: Suma el contenido de register[5] + register[8] y lo guarda en register[3]
    i_instructionToWrite = 32'h00a81821;
    #20;
    //Sub: Resta el contenido de register[3] - register[0] y lo guarda en register[4]
    i_instructionToWrite = 32'h00602023;
    #20
    //Halt
    i_instructionToWrite = {6'b111000, 5'b00000, 5'b01000, 5'b01000, 5'b00000, 6'b000100};
    #20;
    i_writeInstruction = 1'b0;
    #60;
    i_enable = 1'b1;
end

endmodule
