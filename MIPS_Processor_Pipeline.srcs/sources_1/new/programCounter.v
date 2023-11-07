module programCounter
#(
    parameter PC_LEN = 32
)
(
    //Inputs
    input wire i_clk,
    input wire i_reset,
    input wire [PC_LEN-1:0] i_programCounter,

    //Outputs
    output wire [PC_LEN-1:0] o_programCounter
);

reg [PC_LEN-1:0] r_programCounter;


always @(posedge i_clk) begin
    if(i_reset) begin
        r_programCounter <= 0;
    end
    else begin
        r_programCounter <= i_programCounter;
    end
end

//Assigns
assign o_programCounter = r_programCounter;

endmodule
