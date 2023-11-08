`timescale 1ns / 1ps

module executionStage_tb;
    localparam DATA_LEN = 32;
    localparam REGISTER_BITS = 5;

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
    
    reg [31:0] seed;
    
    initial begin
        seed = 100;
        i_inmediatoEx[DATA_LEN-1:16] = {16{1'b0}};
    
        //Load instruction control signals
        i_regDst = 1'b0;
        i_aluOP = 2'b00;
        i_aluSrc = 1'b1;
        //Load instruction data
        i_nextPC = $random(seed);
        i_d1 = $random(seed);
        i_d2 = $random(seed);
        i_rt = $random(seed);
        i_rd = $random(seed);      
        i_inmediatoEx[16:11] = i_rd;
        i_inmediatoEx[10:0] = $random(seed);
        
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
        
        #20
        
        //Store instruction control signals
        i_aluOP = 2'b00;
        i_aluSrc = 1'b1;
        //Store instruction data
        i_nextPC = $random(seed);
        i_d1 = $random(seed);
        i_d2 = $random(seed);
        i_rt = $random(seed);
        i_rd =$random(seed);
        i_inmediatoEx[16:11] = i_rd;
        i_inmediatoEx[10:0] = $random(seed);
        
        #10
        
        //Check branchPC
        if(o_branchPC != (i_inmediatoEx << 2) + i_nextPC) begin
            $display("Store instruction: Incorrect branchPC");
        end
        
        //Check aluResult, should add d1 and inmediatoEx 
        //This calculates the adrress where to store the data
        if(o_aluResult != i_d1 + i_inmediatoEx) begin
            $display("Store instruction: Incorrect aluResult");
        end
        
        //Check zero
        if(&(~o_aluResult) != o_zero) begin
            $display("Store instruction: Incorrect zero");
        end
        
        //Check writeRegister
        if(o_writeRegister != i_rt) begin
            $display("Store instruction: Incorrect writeRegister");
        end
        
        #20
        
        //R-type instruction control signals
        i_regDst = 1'b1;
        i_aluOP = 2'b10;
        i_aluSrc = 1'b0;
        //R-type instruction data
        i_nextPC = $random(seed);
        i_d1 = $random(seed);
        i_d2 = $random(seed);
        i_rt = $random(seed);
        i_rd =$random(seed);
        i_inmediatoEx[16:11] = i_rd;
        //Funct = AND
        i_inmediatoEx[10:0] = 11'b00000100100;
        
        #10
        
        //Check branchPC
        if(o_branchPC != (i_inmediatoEx << 2) + i_nextPC) begin
            $display("R-type instruction: Incorrect branchPC");
        end
        
        //Check aluResult, should d1 AND d2 
        if(o_aluResult != i_d1 & i_d2) begin
            $display("R-type instruction: Incorrect aluResult");
        end
        
        //Check zero
        if(&(~o_aluResult) != o_zero) begin
            $display("R-type instruction: Incorrect zero");
        end
        
        //Check writeRegister
        if(o_writeRegister != i_rd) begin
            $display("R-type instruction: Incorrect writeRegister");
        end
        
    end

endmodule
