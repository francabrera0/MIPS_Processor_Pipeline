`timescale 1ns / 1ps

module ALUControl(
    //Data inputs
    input wire [5:0] i_funct,
    //Control inputs
    input wire [1:0] i_aluOP,
    //Control outputs
    output reg [5:0] o_opSelector
);

always @(*)
        begin
            case(i_aluOP)
                //Load or store instruction ALU should add 
                2'b00: o_opSelector = 6'b100000;
                //Branch equal instruction ALU should substract                
                2'b01: o_opSelector = 6'b100010;
                //R.type instruction
                2'b10: o_opSelector = i_funct;

           
                default : o_opSelector = 0;
            endcase
        end
endmodule
