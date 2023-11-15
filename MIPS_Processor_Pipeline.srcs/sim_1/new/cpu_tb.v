`timescale 1ns / 1ps

module cpu_tb();

    localparam DATA_LEN = 32;
    localparam PC_LEN = 32;
    localparam MEM_SIZE_ADDRESS_BITS = 10; //Bits to address instruction memory;
    localparam OPCODE_LEN = 6; 
    localparam REGISTER_BITS = 5; //Cantidad de bits que direccionan registros
    localparam IMMEDIATE_LEN = 16;
    localparam FUNCTION_LEN = 6;

    reg i_clk;
    reg i_reset;
    reg i_writeInstruction;
    reg [DATA_LEN-1:0] i_instructionToWrite;

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
    .i_instructionToWrite(i_instructionToWrite)
);


always begin
    #10 i_clk = ~i_clk;
end

initial begin
    i_clk = 1'b0;
    i_writeInstruction = 1'b0;
    i_instructionToWrite = {DATA_LEN{1'b0}};
    i_reset = 1'b1;
    #20;
    i_reset = 1'b0;

    //Store: Guardamos en la posición de memoria register[0]+inmediato, el valor de register[20]
    i_instructionToWrite = {6'b101011, 5'b00000, 5'b10100, 16'b0000000000000110}; 
    i_writeInstruction = 1'b1;
    #20;
    i_instructionToWrite = {6'b000000, 5'b00000, 5'b00101, 5'b01010, 5'b00000, 6'b100000};
    #20;
    i_writeInstruction = 1'b0;

end

endmodule
