`timescale 1ns / 1ps

module branchControl(
    //Control inputs
    input wire i_branch,
    input wire i_zero,
    //Control outputs
    output wire o_pcSrc
);

assign o_pcSrc = i_branch & i_zero;

endmodule
