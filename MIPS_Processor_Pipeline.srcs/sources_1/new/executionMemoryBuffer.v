`timescale 1ns / 1ps


module executionMemoryBuffer
#(
    parameter DATA_LEN = 32,
    parameter PC_LEN = 32
)
(
    //Special inputs
    input wire i_clk,
    input wire i_reset,
    input wire i_enable,
    //Data inputs
    input wire [DATA_LEN-1:0] i_pcBranch,
    input wire [DATA_LEN-1:0] i_d2,
    input wire [DATA_LEN-1:0] i_aluResult,
    input wire [DATA_LEN-1:0] i_writeRegister,
    //Data outputs
    output wire [DATA_LEN-1:0] o_pcBranch,
    output wire [DATA_LEN-1:0] o_d2,
    output wire [DATA_LEN-1:0] o_aluResult,
    output wire [DATA_LEN-1:0] o_writeRegister
);

reg [DATA_LEN-1:0] pcBranch;
reg [DATA_LEN-1:0] d2;
reg [DATA_LEN-1:0] aluResult;
reg [DATA_LEN-1:0] writeRegister;

always @(posedge i_clk) begin
    if(i_reset) begin
        pcBranch <= 0;
        d2 <= 0;
        aluResult <= 0;
        writeRegister <= 0;
    end
    else if(i_enable) begin
        pcBranch <= i_pcBranch;
        d2 <= i_d2;
        aluResult <= i_aluResult;
        writeRegister <= i_writeRegister;
    end  
end

endmodule
