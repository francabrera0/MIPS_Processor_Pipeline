`timescale 1ns / 1ps

module ALUControl(
    //Data inputs
    input wire [5:0] i_funct,
    //Control inputs
    input wire [1:0] i_aluOP,
    input wire [2:0] i_immediateFunct,
    //Control outputs
    output reg [5:0] o_opSelector
);

localparam LOAD_STORE = 2'b00;
localparam BRANCH = 2'b01;
localparam R_TYPE = 2'b10;
localparam IMMEDIATE = 2'b11;

localparam ADDI = 3'b000;
localparam ANDI = 3'b100;
localparam ORI = 3'b101;
localparam XORI = 3'b110;
localparam SLTI = 3'b010;
localparam LUI = 3'b111;

localparam ADDU = 6'b100001;
localparam SUBU = 6'b100011;
    
localparam AND = 6'b100100;
localparam OR  = 6'b100101;
localparam XOR = 6'b100110;
localparam NOR = 6'b100111;

localparam SRA = 6'b000011;
localparam SRAV = 6'b000111;
localparam SRL = 6'b000010;
localparam SRLV = 6'b000110;
    
localparam SLL = 6'b000000;
localparam SLLV = 6'b000100;

localparam SLT = 6'b101010;

localparam SET_UPPER = 6'b001111;

always @(*)
        begin
            case(i_aluOP)
                //Load or store instruction ALU should add 
                LOAD_STORE: o_opSelector = ADDU;
                //Branch equal instruction ALU should substract                
                BRANCH: o_opSelector = SUBU;
                //R-type instruction
                R_TYPE: o_opSelector = i_funct;
                //Immediate instruction
                IMMEDIATE: begin
                    case(i_immediateFunct)
                        ADDI: o_opSelector = ADDU;
                        ANDI: o_opSelector = AND;
                        ORI: o_opSelector = OR;
                        XORI: o_opSelector = XOR;
                        SLTI: o_opSelector = SLT;
                        LUI: o_opSelector = SET_UPPER;
                    endcase
                end 
                default : o_opSelector = 0;
            endcase
        end
endmodule
