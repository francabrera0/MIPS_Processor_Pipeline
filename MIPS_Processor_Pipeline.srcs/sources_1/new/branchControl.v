`timescale 1ns / 1ps

module branchControl(
    //Control inputs
    input wire i_branch,
    input wire i_zero,
    //Control outputs
    output wire o_PCSrc
);

assign o_PCSrc = i_branch & i_zero;

endmodule
