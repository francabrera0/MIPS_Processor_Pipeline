`timescale 1ns / 1ps
module controlUnit_tb();

localparam DATA_LEN = 32;
localparam OPCODE_LEN = 6;

reg [DATA_LEN-1:0] i_instruction;

wire o_regWrite;
wire o_aluSrc;
wire o_aluOp;
wire o_branch;
wire o_regDest;

controlUnit#(
    .DATA_LEN(DATA_LEN),
    .OPCODE_LEN(OPCODE_LEN)
) controlUnit
(
    .i_instruction(i_instruction),
    .o_regWrite(o_regWrite),
    .o_aluSrc(o_aluSrc),
    .o_aluOp(o_aluOp),
    .o_branch(o_branch),
    .o_regDest(o_regDest)
);

localparam ADD = 32'b00000000001000100001100000100000;
localparam LW =  32'b10001100011000010000000011111101;
localparam SW =  32'b10101100011000010000000011111101;
localparam BEQ = 32'b00010000011000010000000001111111;

initial begin
    i_instruction = ADD;
    #10;
    i_instruction = LW;
    #10;
    i_instruction = SW;
    #10;
    i_instruction = BEQ;
    #10;
    i_instruction = {32{1'b1}};
end

endmodule
