module modMCounter#
(
    parameter COUNTER_BITS = 4, //Number of bits in counter
    parameter COUNTER_MOD = 10 //Mod-M
)
(
    input wire i_clk,
    input wire i_reset,
    output wire o_counterMaxTick
);

//Signal declaration
reg [COUNTER_BITS-1 : 0] counterReg;
wire [COUNTER_BITS-1 : 0] counterNext;

//Body
//Register
always @(posedge i_clk) begin
    if (i_reset) begin
        counterReg <= 0;
    end
    else begin
        counterReg <= counterNext;
    end
end

//Next-state logic
assign counterNext = (counterReg == (COUNTER_MOD-1)) ? 0 : counterReg + 1;
assign o_counterMaxTick = (counterReg == (COUNTER_MOD-1)) ? 1'b1 : 1'b0;

endmodule
