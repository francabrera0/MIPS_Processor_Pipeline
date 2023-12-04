`timescale 1ns / 1ps

module branchControl(
    //Control inputs
    input wire [1:0] i_branch,
    input wire i_zero,
    //Control outputs
    output reg o_PCSrc
);

//Bit bajo de branch indica si es instruccion de branch
//Bit alto indica si es equal o not equal
always @(*) begin
    case(i_branch)
        2'b10: o_PCSrc = 1;
        default: o_PCSrc = i_branch[0] & (i_branch[1] ^ i_zero);       
    endcase
end

endmodule
