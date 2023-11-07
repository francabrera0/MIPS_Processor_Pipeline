`timescale 1ns / 1ps


module executionStage(
    //Data inputs
    input wire [31:0] i_nextPC,
    input wire [31:0] i_d1,
    input wire [31:0] i_d2,
    input wire [31:0] i_inmediatoEx,
    input wire [4:0] i_rt,
    input wire [4:0] i_rd,
    //Control inputs
    input wire i_aluSrc,
    input wire [1:0] i_aluOP,
    input wire i_regDst,
    //Data outputs
    output wire [31:0] o_branchPC,
    output wire [31:0] o_aluResult,
    output wire [31:0] o_writeRegister,
    //Control outputs
    output wire o_zero
);
endmodule
