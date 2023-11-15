module fetchDecodeBuffer
#(
    parameter DATA_LEN = 32,
    parameter PC_LEN = 32
)
(
    //Inputs
    input wire i_clk,
    input wire i_reset,
    input wire [DATA_LEN-1:0] i_instruction,
    input wire [PC_LEN-1:0] i_incrementedPC,
    input wire i_enable,

    //Outputs
    output wire [PC_LEN-1:0] o_incrementedPC,
    output wire [DATA_LEN-1:0] o_instruction
);

reg [DATA_LEN-1:0] r_instruction;
reg [PC_LEN-1:0] r_incrementedPC;

always @(posedge i_clk) begin
    if(i_reset) begin
        r_instruction <= 32'hfc000000; //NOP
        r_incrementedPC <= 0;
    end
    else if(i_enable) begin
        r_instruction <= i_instruction;
        r_incrementedPC <= i_incrementedPC;
    end
end

//Assigns
assign o_instruction = r_instruction;
assign o_incrementedPC = r_incrementedPC;

endmodule
