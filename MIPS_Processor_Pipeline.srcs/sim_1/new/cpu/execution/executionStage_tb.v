`timescale 1ns / 1ps

module executionStage_tb;
    localparam DATA_LEN = 32;
    localparam REGISTER_BITS = 5;

    reg [DATA_LEN-1:0] i_incrementedPC;
    reg [DATA_LEN-1:0] i_d1;
    reg [DATA_LEN-1:0] i_d2;
    reg [DATA_LEN-1:0] i_inmediatoEx;
    reg [DATA_LEN-1:0] i_shamt;
    reg [REGISTER_BITS-1:0] i_rt;
    reg [REGISTER_BITS-1:0] i_rd;
    //Control inputs
    reg [1:0] i_aluSrc;
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
        .i_incrementedPC(i_incrementedPC),
        .i_readData1(i_d1),
        .i_readData2(i_d2),
        .i_immediateExtendValue(i_inmediatoEx),
        .i_shamt(i_shamt),
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
    wire [DATA_LEN-1:0] shiftedImmediate = {1'b0, i_inmediatoEx[DATA_LEN-2:0] << 2};
    wire [DATA_LEN-1:0] pcBranchResult = i_inmediatoEx[DATA_LEN-1]? i_incrementedPC - shiftedImmediate: i_incrementedPC + shiftedImmediate;
    
    initial begin
        seed = 100;
        i_inmediatoEx[DATA_LEN-1:16] = {16{1'b0}};
    
        //Load instruction control signals
        i_regDst = 1'b0;
        i_aluOP = 2'b00;
        i_aluSrc = 2'b01;
        //Load instruction data
        i_incrementedPC = $random(seed);
        i_d1 = $random(seed);
        i_d2 = $random(seed);
        i_rt = $random(seed);
        i_rd = $random(seed);      
        i_inmediatoEx[16:11] = i_rd;
        i_inmediatoEx[10:0] = $random(seed);
        
        #10
        
        //Check branchPC
        if(o_branchPC != pcBranchResult) begin
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
        i_aluSrc = 2'b01;
        //Store instruction data
        i_incrementedPC = $random(seed);
        i_d1 = $random(seed);
        i_d2 = $random(seed);
        i_rt = $random(seed);
        i_rd =$random(seed);
        i_inmediatoEx[16:11] = i_rd;
        i_inmediatoEx[10:0] = $random(seed);
        
        #10
        
        //Check branchPC
        if(o_branchPC != pcBranchResult) begin
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
        
        #20
        
        //R-type AND instruction control signals
        i_regDst = 1'b1;
        i_aluOP = 2'b10;
        i_aluSrc = 2'b00;
        //R-type instruction data
        i_incrementedPC = $random(seed);
        i_d1 = $random(seed);
        i_d2 = $random(seed);
        i_rt = $random(seed);
        i_rd =$random(seed);
        i_inmediatoEx[16:11] = i_rd;
        //Funct = AND
        i_inmediatoEx[10:0] = 11'b00000100100;
        
        #10
        
        //Check branchPC
        if(o_branchPC != pcBranchResult) begin
            $display("R-type AND instruction: Incorrect branchPC");
        end
        
        //Check aluResult, should d1 AND d2 
        if(o_aluResult != i_d1 & i_d2) begin
            $display("R-type AND instruction: Incorrect aluResult");
        end
        
        //Check zero
        if(&(~o_aluResult) != o_zero) begin
            $display("R-type AND instruction: Incorrect zero");
        end
        
        //Check writeRegister
        if(o_writeRegister != i_rd) begin
            $display("R-type AND instruction: Incorrect writeRegister");
        end
        
        #20
        
        //R-type SLL instruction control signals
        i_regDst = 1'b1;
        i_aluOP = 2'b10;
        i_aluSrc = 2'b10;
        //R-type instruction data
        i_incrementedPC = $random(seed);
        i_d1 = $random(seed);
        i_d2 = $random(seed);
        i_shamt = 32'h00000005;
        i_rt = $random(seed);
        i_rd =$random(seed);
        i_inmediatoEx[16:11] = i_rd;
        //Funct = SLL
        i_inmediatoEx[10:0] = 11'b00000000000;
        
        #10
        
        //Check branchPC
        if(o_branchPC != pcBranchResult) begin
            $display("R-type SLL instruction: Incorrect branchPC");
        end
        
        //Check aluResult, should d2 << i_shamt 
        if(o_aluResult != i_d2 << i_shamt) begin
            $display("R-type SLL instruction: Incorrect aluResult");
        end
        
        //Check zero
        if(&(~o_aluResult) != o_zero) begin
            $display("R-type SLL instruction: Incorrect zero");
        end
        
        //Check writeRegister
        if(o_writeRegister != i_rd) begin
            $display("R-type SLL instruction: Incorrect writeRegister");
        end
        
        #20
        
        //Branch equal instruction control signals
        i_aluOP = 2'b01;
        i_aluSrc = 2'b00;
        //Branch equal instruction data
        i_incrementedPC = $random(seed);
        i_d1 = $random(seed);
        i_d2 = i_d1;
        i_rt = $random(seed);
        i_inmediatoEx = 32'h800000ff;
        
        #10
        
        //Check branchPC
        if(o_branchPC != pcBranchResult) begin
            $display("Beq instruction: Incorrect branchPC");
        end
        
        //Check aluResult, should substract d1 - d2 
        if(o_aluResult != i_d1 - i_d2) begin
            $display("Beq instruction: Incorrect aluResult");
        end
        
        //Check zero
        if(&(~o_aluResult) != o_zero) begin
            $display("Beq instruction: Incorrect zero");
        end
        
    end

endmodule
