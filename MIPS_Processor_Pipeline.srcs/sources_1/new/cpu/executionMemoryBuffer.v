`timescale 1ns / 1ps


module executionMemoryBuffer
#(
    parameter DATA_LEN = 32,
    parameter REGISTER_BITS = 5
)
(
    //Special inputs
    input wire i_clk,
    input wire i_reset,
    input wire i_enable,
    //Data inputs
    input wire [DATA_LEN-1:0] i_pcBranch,
    input wire [DATA_LEN-1:0] i_readData2,
    input wire [DATA_LEN-1:0] i_aluResult,
    input wire [REGISTER_BITS-1:0] i_writeRegister,
    //Control inputs
    input wire i_zero,
    input wire i_regWrite,
    input wire i_memRead,
    input wire i_memWrite,
    input wire i_branch,
    input wire i_memToReg,
    input wire i_halt,
    input wire [1:0] i_loadStoreType,
    input wire i_unsigned,
    //Data outputs
    output wire [DATA_LEN-1:0] o_pcBranch,
    output wire [DATA_LEN-1:0] o_readData2,
    output wire [DATA_LEN-1:0] o_aluResult,
    output wire [REGISTER_BITS-1:0] o_writeRegister,
    //Control outputs
    output wire o_zero,
    output wire o_regWrite,
    output wire o_memRead,
    output wire o_memWrite,
    output wire o_branch,
    output wire o_memToReg,
    output wire o_halt,
    output wire [1:0] o_loadStoreType,
    output wire o_unsigned
);

//Data registers
reg [DATA_LEN-1:0] pcBranch;
reg [DATA_LEN-1:0] d2;
reg [DATA_LEN-1:0] aluResult;
reg [REGISTER_BITS-1:0] writeRegister;
//Control registers
reg zero;
reg regWrite;
reg memRead;
reg memWrite;
reg branch;
reg memToReg;
reg halt;
reg [1:0] r_loadStoreType;
reg r_unsigned;

always @(posedge i_clk) begin
    if(i_reset) begin
        //Data
        pcBranch <= 0;
        d2 <= 0;
        aluResult <= 0;
        writeRegister <= 0;
        //Control
        zero <= 0;
        regWrite <= 0;
        memRead <= 0;
        memWrite <= 0;
        branch <= 0;
        memToReg <= 0;    
        halt <= 0;
        r_loadStoreType <= 2'b11;
        r_unsigned <= 0;
    end
    else if(i_enable) begin
        //Data
        pcBranch <= i_pcBranch;
        d2 <= i_readData2;
        aluResult <= i_aluResult;
        writeRegister <= i_writeRegister;
        //Control
        zero <= i_zero;
        regWrite <= i_regWrite;
        memRead <= i_memRead;
        memWrite <= i_memWrite;
        branch <= i_branch;
        memToReg <= i_memToReg;
        halt <= i_halt;
        r_loadStoreType <= i_loadStoreType;
        r_unsigned <= i_unsigned;
    end  
end

//Data
assign o_pcBranch = pcBranch;
assign o_readData2 = d2;
assign o_aluResult = aluResult;
assign o_writeRegister = writeRegister;
//Control
assign o_zero = zero;
assign o_regWrite = regWrite;
assign o_memRead = memRead;
assign o_memWrite = memWrite;
assign o_branch = branch;
assign o_memToReg = memToReg;
assign o_halt = halt;
assign o_loadStoreType = r_loadStoreType;
assign o_unsigned = r_unsigned;

endmodule
