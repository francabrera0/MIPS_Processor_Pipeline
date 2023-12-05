`timescale 1ns / 1ps

module branchControl #(
    parameter DATA_LEN = 32
)(
    //Control inputs
    input wire [1:0] i_branch,
    input wire i_zero,
    input wire [DATA_LEN-1:0] i_pcBranch,
    input wire [DATA_LEN-1:0] i_pcJump,
    //Control outputs
    output reg o_PCSrc,
    output reg [DATA_LEN-1:0] o_pcBranch
);

always @(*) begin
    case(i_branch)
        2'b10: begin
            o_PCSrc = 1;
            o_pcBranch = i_pcJump;
        end
        default: begin 
            //Bit bajo de branch indica si es instruccion de branch
            //Bit alto indica si es equal o not equal
            o_PCSrc = i_branch[0] & (i_branch[1] ^ i_zero);       
            o_pcBranch = i_pcBranch;
        end
    endcase
end

endmodule
