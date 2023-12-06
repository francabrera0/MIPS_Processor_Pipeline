`timescale 1ns / 1ps

module hazardDetector  #(
    parameter DATA_LEN  = 32,
    parameter REGISTER_BITS = 5
)(
    //Data inputs
    input wire [REGISTER_BITS-1:0] i_rsID,
    input wire [REGISTER_BITS-1:0] i_rtID,
    input wire [REGISTER_BITS-1:0] i_rtE,
    //Control inputs
    input wire i_memRead,
    //Control outputs
    output reg o_stall
);

always @(*) begin
    if(i_memRead & (i_rtE == i_rsID | i_rtE == i_rtID )) begin
        o_stall = 1'b1;
    end else o_stall = 1'b0;
end

endmodule
