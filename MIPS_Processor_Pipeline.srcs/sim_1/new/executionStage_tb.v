`timescale 1ns / 1ps

module executionStage_tb;
    localparam DATA_LEN = 8;
    localparam REGISTER_BITS = 8;

    reg [DATA_LEN-1:0] i_nextPC;
    reg [DATA_LEN-1:0] i_d1;
    reg [DATA_LEN-1:0] i_d2;
    reg [DATA_LEN-1:0] i_inmediatoEx;
    reg [REGISTER_BITS-1:0] i_rt;
    reg [REGISTER_BITS-1:0] i_rd;
    //Control inputs
    reg i_aluSrc;
    reg [1:0] i_aluOP;
    reg i_regDst;
    //Data outputs
    wire [DATA_LEN-1:0] o_branchPC;
    wire [DATA_LEN-1:0] o_aluResult;
    wire [REGISTER_BITS-1:0] o_writeRegister;
    //Control outputs
    wire o_zero;


    executionStage #(
        .DATA_LEN(DATA_LEN),
        .REGISTER_BITS(REGISTER_BITS)
    ) executionStage(
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
        //Data outputs
        .o_branchPC(o_branchPC),
        .o_aluResult(o_aluResult),
        .o_writeRegister(o_writeRegister),
        //Control outputs
        .o_zero(o_zero)
    );
    
     initial begin
        //Load instruction control signals
        i_regDst = 1'b0;
        i_aluOP = 2'b00;
        i_aluSrc = 1'b1;
        //Load instruction data
        i_nextPC = 8'b10001100;
        i_d1 = 8'b10001100;
        i_d2 = 8'b10001100;
        i_inmediatoEx = 8'b00011000;
        i_rt = 5'b10001;
        i_rd = 5'b10000;
        
        #10
        
        //Check branchPC
        if(o_branchPC != (i_inmediatoEx << 2) + i_nextPC) begin
            $display("Load instruction: Incorrect branchPC");
        end
        
        //Check aluResult, should add d1 and inmediatoEx 
        //This calculates the adrress where there is the data to load
        if(o_aluResult != i_d1 + i_inmediatoEx) begin
            $display("Load instruction: Incorrect aluResult");
        end
        
        //Check zero
        if(&(~o_aluResult) != o_zero) begin
            $display("Load instruction: Incorrect zero");
        end
        
        //Check writeRegister
        if(o_writeRegister != i_rt) begin
            $display("Load instruction: Incorrect writeRegister");
        end
        
    end

endmodule
