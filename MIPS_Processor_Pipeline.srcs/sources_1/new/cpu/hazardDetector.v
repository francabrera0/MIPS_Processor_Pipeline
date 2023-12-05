`timescale 1ns / 1ps

module hazardDetector  #(
    parameter DATA_LEN  = 32,
    parameter REGISTER_BITS = 5
)(
    input wire i_clk,
    input wire i_reset,
    //Data inputs
    input wire [REGISTER_BITS-1:0] i_rsID,
    input wire [REGISTER_BITS-1:0] i_rtID,
    input wire [REGISTER_BITS-1:0] i_rtE,
    //Control inputs
    input wire i_memRead,
    input wire i_branch,
    //Control outputs
    output reg o_stall
);

reg stallCounter;

always @(posedge i_clk) begin
    if(i_reset) stallCounter <= 0;
    
    if(i_branch | stallCounter > 0) begin
        if(stallCounter == 1'b1) stallCounter <= 1'b0;
        else stallCounter = stallCounter + 1;
    end
end

always @(*) begin
    if((i_memRead & (i_rtE == i_rsID | i_rtE == i_rtID )) | i_branch |(stallCounter > 0)) begin
        o_stall = 1'b1;
    end else o_stall = 1'b0;
end

endmodule
