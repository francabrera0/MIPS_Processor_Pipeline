`timescale 1ns / 1ps

module hazardDetector  #(
    parameter DATA_LEN  = 32,
    parameter REGISTER_BITS = 5
)(
    //Data inputs
    input wire [REGISTER_BITS-1:0] i_rsID,
    input wire [REGISTER_BITS-1:0] i_rtID,
    input wire [REGISTER_BITS-1:0] i_rtE,
    input wire [REGISTER_BITS-1:0] i_rtM,
    //Control inputs
    input wire i_memReadE,
    input wire i_memReadM,
    //Control outputs
    output reg o_stall
);

always @(*) begin
    if(i_memReadE & (i_rtE == i_rsID | i_rtE == i_rtID ))
        o_stall = 1'b1;
    else if(i_memReadM & (i_rtM == i_rsID | i_rtM == i_rtID ))
        o_stall = 1'b1;
    else o_stall = 1'b0;
end

endmodule
