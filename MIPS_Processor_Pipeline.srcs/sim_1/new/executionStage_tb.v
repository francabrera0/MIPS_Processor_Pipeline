`timescale 1ns / 1ps

module executionStage_tb;
    localparam DATA_LEN = 8;

    reg [DATA_LEN-1:0] i_nextPC;
    reg [DATA_LEN-1:0] i_d1;
    reg [DATA_LEN-1:0] i_d2;
    reg [DATA_LEN-1:0] i_inmediatoEx;
    reg [4:0] i_rt;
    reg [4:0] i_rd;
    //Control inputs
    reg i_aluSrc;
    reg [1:0] i_aluOP;
    reg i_regDst;
    //Data outputs
    wire [DATA_LEN-1:0] o_branchPC;
    wire [DATA_LEN-1:0] o_aluResult;
    wire [DATA_LEN-1:0] o_writeRegister;
    //Control outputs
    wire o_zero;


    executionStage executionStage(
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
        .o_d2(o_d2),
        .o_aluResult(o_aluResult),
        .o_writeRegister(o_writeRegister),
        //Control outputs
        .o_zero(o_zero)
    );
    
     initial begin
        funct = 6'b100011;
        //Load or store instruction
        aluOp = 2'b00;
        
        #10
        
        //Load or store instruction should add
        if(aluCtl != 6'b100000) begin
            $display("Load Store instruction not adding");
        end
        
        #20
        
        funct = 6'b100011;
        //Branch
        aluOp = 2'b01;
        
        #10
        
        //Branch inistruction should substract
        if(aluCtl != 6'b100010) begin
            $display("Branch instruction not substracting");
        end
        
        #20
        
        //NOR
        funct = 6'b100111;
        //R-type
        aluOp = 2'b10;
        
        #10
        
        //R-type inistruction should foward funct
        if(aluCtl != funct) begin
            $display("R-type instruction not fordwaring funct");
        end
        
        #20
        
        funct = 6'b100111;
        //Invalid input
        aluOp = 2'b11;
        
        #10
        
        //R-type inistruction should foward funct
        if(aluCtl != 6'b000000) begin
            $display("Invalid aluOp not outputing zero");
        end
    
    end

endmodule
