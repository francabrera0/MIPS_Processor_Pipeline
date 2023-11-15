`timescale 1ns / 1ps

module ALUControl_tb;

    reg [5:0] funct;
    reg [1:0] aluOp;
    wire [5:0] aluCtl;

    ALUControl ALUControl
    (
        .i_funct(funct),
        .i_aluOP(aluOp),
        .o_opSelector(aluCtl)
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
