`timescale 1ns / 1ps

module memoryWritebackBuffer
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
    input wire [DATA_LEN-1:0] i_memData,
    input wire [DATA_LEN-1:0] i_aluResult,
    input wire [REGISTER_BITS-1:0] i_writeRegister,
    //Control inputs
    input wire i_regWrite,
    input wire i_memToReg,
    input wire i_halt,
    //Data outputs
    output wire [DATA_LEN-1:0] o_memData,
    output wire [DATA_LEN-1:0] o_aluResult,
    output wire [REGISTER_BITS-1:0] o_writeRegister,
    //Control outputs
    output wire o_regWrite,
    output wire o_memToReg,
    output wire o_halt
);

//Data registers
reg [DATA_LEN-1:0] memData;
reg [DATA_LEN-1:0] aluResult;
reg [REGISTER_BITS-1:0] writeRegister;
//Control registers
reg regWrite;
reg memToReg;
reg halt;

always @(posedge i_clk) begin
    if(i_reset) begin
        //Data
        memData <= 0;
        aluResult <= 0;
        writeRegister <= 0;
        //Control
        regWrite <= 0;
        memToReg <= 0;    
        halt <= 0;
    end
    else if(i_enable) begin
        //Data
        memData <= i_memData;
        aluResult <= i_aluResult;
        writeRegister <= i_writeRegister;
        //Control
        regWrite <= i_regWrite;
        memToReg <= i_memToReg;
        halt <= i_halt;
    end  
end

//Data
assign o_memData = memData;
assign o_aluResult = aluResult;
assign o_writeRegister = writeRegister;
//Control
assign o_regWrite = regWrite;
assign o_memToReg = memToReg;
assign o_halt = halt;

endmodule
