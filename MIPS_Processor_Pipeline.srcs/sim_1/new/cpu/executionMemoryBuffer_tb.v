`timescale 1ns / 1ps

module executionMemoryBuffer_tb;

    localparam DATA_LEN = 32;

    //Special inputs
    reg i_clk;
    reg i_reset;
    reg i_enable;
    //Data inputs
    reg [DATA_LEN-1:0] i_pcBranch;
    reg [DATA_LEN-1:0] i_d2;
    reg [DATA_LEN-1:0] i_aluResult;
    reg [DATA_LEN-1:0] i_writeRegister;
    //Control inputs
    reg i_zero;
    reg i_regWrite;
    reg i_memRead;
    reg i_memWrite;
    reg i_branch;
    reg i_memToReg;
    //Data outputs
    wire [DATA_LEN-1:0] o_pcBranch;
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

    executionMemoryBuffer #(
        .DATA_LEN(DATA_LEN)
    ) executionMemoryBuffer(
        //Special inputs
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_enable(i_enable),
        //Data inputs
        .i_pcBranch(i_pcBranch),
        .i_d2(i_d2),
        .i_aluResult(i_aluResult),
        .i_writeRegister(i_writeRegister),
        //Control inputs
        .i_zero(i_zero),
        .i_regWrite(i_regWrite),
        .i_memRead(i_memRead),
        .i_memWrite(i_memWrite),
        .i_branch(i_branch),
        .i_memToReg(i_memToReg),
        //Data outputs
        .o_pcBranch(o_pcBranch),
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
    
    reg [DATA_LEN-1:0] seed = 100;
    
    initial begin
        i_pcBranch = $random(seed);
        i_d2 = $random(seed);
        i_aluResult = $random(seed);
        i_writeRegister = $random(seed);
        //Control
        i_zero = $random(seed);
        i_regWrite = $random(seed);
        i_memRead = $random(seed);
        i_memWrite = $random(seed);
        i_branch = $random(seed);
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
