`timescale 1ns / 1ps

module executionStage_tb;
    localparam DATA_LEN = 8;

    reg [DATA_LEN-1:0] i_nextPC;
    reg [DATA_LEN-1:0] i_d1;
    reg [DATA_LEN-1:0] i_d2;
    reg [DATA_LEN-1:0] i_inmediatoEx;
    reg [4:0] i_rt;
    reg [4:0] i_rd;
    //Control inputs
    reg i_aluSrc;
    reg [1:0] i_aluOP;
    reg i_regDst;
    reg i_regWrite;
    reg i_memRead;
    reg i_memWrite;
    reg i_branch;
    reg i_memToReg;
    //Data outputs
    wire [DATA_LEN-1:0] o_branchPC;
    wire [DATA_LEN-1:0] o_d2;
    wire [DATA_LEN-1:0] o_aluResult;
    wire [DATA_LEN-1:0] o_writeRegister;
    //Control outputs
    wire o_zero;
    wire o_regWrite;
    wire o_memRead;
    wire o_memWrite;
    wire o_branch;
    wire o_memToReg;


    executionStage executionStage(
    //Data inputs
    .i_nextPC(i_nextPC),
    .i_d1(i_d1),
    .i_d2(i_d2),
    .i_inmediatoEx(i_inmediatoEx),
    .i_rt(i_rt),
    .i_rd(i_rd),
    //Control inputs
    .i_aluSrc(i_aluSrc),
    .i_aluOP(i_aluOP),
    .i_regDst(i_regDst),
    .i_regWrite(i_regWrite),
    .i_memRead(i_memRead),
    .i_memWrite(i_memWrite),
    .i_branch(i_branch),
    .i_memToReg(i_memToReg),
    //Data outputs
    .o_branchPC(o_branchPC),
    .o_d2(o_d2),
    .o_aluResult(o_aluResult),
    .o_writeRegister(o_writeRegister),
    //Control outputs
    .o_zero(o_zero),
    .o_regWrite(o_regWrite),
    .o_memRead(o_memRead),
    .o_memWrite(o_memWrite),
    .o_branch(o_branch),
    .o_memToReg(o_memToReg)
    );

endmodule
