`timescale 1ns / 1ps

module memoryWritebackBuffer
#(
    parameter DATA_LEN = 32
)
(
    //Special inputs
    input wire i_clk,
    input wire i_reset,
    input wire i_enable,
    //Data inputs
    input wire [DATA_LEN-1:0] i_memData,
    input wire [DATA_LEN-1:0] i_aluResult,
    input wire [DATA_LEN-1:0] i_writeRegister,
    //Control inputs
    input wire i_regWrite,
    input wire i_memToReg,
    //Data outputs
    output wire [DATA_LEN-1:0] o_memData,
    output wire [DATA_LEN-1:0] o_aluResult,
    output wire [DATA_LEN-1:0] o_writeRegister,
    //Control outputs
    output wire o_regWrite,
    output wire o_memToReg
);

//Data registers
reg [DATA_LEN-1:0] memData;
reg [DATA_LEN-1:0] aluResult;
reg [DATA_LEN-1:0] writeRegister;
//Control registers
reg regWrite;
reg memToReg;

always @(posedge i_clk) begin
    if(i_reset) begin
        //Data
        memData <= 0;
        aluResult <= 0;
        writeRegister <= 0;
        //Control
        regWrite <= 0;
        memToReg <= 0;    
    end
    else if(i_enable) begin
        //Data
        memData <= i_memData;
        aluResult <= i_aluResult;
        writeRegister <= i_writeRegister;
        //Control
        regWrite <= i_regWrite;
        memToReg <= i_memToReg;
    end  
end

//Data
assign o_memData = memData;
assign o_aluResult = aluResult;
assign o_writeRegister = writeRegister;
//Control
assign o_regWrite = regWrite;
assign o_memToReg = memToReg;

endmodule
