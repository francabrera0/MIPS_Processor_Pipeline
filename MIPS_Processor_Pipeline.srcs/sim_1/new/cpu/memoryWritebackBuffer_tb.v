`timescale 1ns / 1ps

module memoryWritebackBuffer_tb;

    localparam DATA_LEN = 32;

    //Special inputs
    reg i_clk;
    reg i_reset;
    reg i_enable;
    //Data inputs
    reg [DATA_LEN-1:0] i_memData;
    reg [DATA_LEN-1:0] i_aluResult;
    reg [DATA_LEN-1:0] i_writeRegister;
    //Control inputs
    reg i_regWrite;
    reg i_memToReg;
    //Data outputs
    wire [DATA_LEN-1:0] o_memData;
    wire [DATA_LEN-1:0] o_aluResult;
    wire [DATA_LEN-1:0] o_writeRegister;
    //Control outputs
    wire o_regWrite;
    wire o_memToReg;

    memoryWritebackBuffer #(
        .DATA_LEN(DATA_LEN)
    ) memoryWritebackBuffer(
        //Special inputs
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_enable(i_enable),
        //Data inputs
        .i_memData(i_memData),
        .i_aluResult(i_aluResult),
        .i_writeRegister(i_writeRegister),
        //Control inputs
        .i_regWrite(i_regWrite),
        .i_memToReg(i_memToReg),
        //Data outputs
        .o_memData(o_memData),
        .o_aluResult(o_aluResult),
        .o_writeRegister(o_writeRegister),
        //Control outputs
        .o_regWrite(o_regWrite),
        .o_memToReg(o_memToReg)
    );
    
    reg [DATA_LEN-1:0] seed = 100;
    
    initial begin
        i_memData = $random(seed);
        i_aluResult = $random(seed);
        i_writeRegister = $random(seed);
        //Control
        i_regWrite = $random(seed);
        i_memToReg = $random(seed);
        
        i_clk = 1;
        i_reset = 1;
        i_enable = 0;
        
        #1
        
        i_reset = 0;
        i_clk = 0;
        
        #1
        i_clk = 1;
        i_enable = 1;
    end

endmodule
