module decodeExecutionBuffer
#(
    parameter DATA_LEN = 32,
    parameter PC_LEN = 32,
    parameter ADDRESS_LEN = 5
)
(
    //Inputs
    input wire i_clk,
    input wire i_reset,
    
    input wire [PC_LEN-1:0] i_incrementedPC,
    input wire i_regWrite,
    input wire i_aluSrc,
    input wire [1:0] i_aluOp,
    input wire i_branch,
    input wire i_regDest,
    input wire [DATA_LEN-1:0] i_readData1,
    input wire [DATA_LEN-1:0] i_readData2,
    input wire [DATA_LEN-1:0] i_immediateExtendValue,
    input wire [ADDRESS_LEN-1:0] i_rt,
    input wire [ADDRESS_LEN-1:0] i_rd,

    //Outputs
    output wire [PC_LEN-1:0] o_incrementedPC,
    output wire o_regWrite,
    output wire o_aluSrc,
    output wire [1:0] o_aluOp,
    output wire o_branch,
    output wire o_regDest,
    output wire [DATA_LEN-1:0] o_readData1,
    output wire [DATA_LEN-1:0] o_readData2,
    output wire [DATA_LEN-1:0] o_immediateExtendValue,
    output wire [ADDRESS_LEN-1:0] o_rt,
    output wire [ADDRESS_LEN-1:0] o_rd
);

reg [PC_LEN-1:0] r_incrementedPC;
reg r_regWrite;
reg r_aluSrc;
reg [1:0] r_aluOp;
reg r_branch;
reg r_regDest;
reg [DATA_LEN-1:0] r_readData1;
reg [DATA_LEN-1:0] r_readData2;
reg [DATA_LEN-1:0] r_immediateExtendValue;
reg [ADDRESS_LEN-1:0] r_rt;
reg [ADDRESS_LEN-1:0] r_rd;

always @(posedge i_clk) begin
    if(i_reset) begin
        r_incrementedPC <= 0;
        r_regWrite <= 0;
        r_aluSrc <= 0;
        r_aluOp <= 0;
        r_branch <= 0;
        r_regDest <= 0;
        r_readData1 <= 0;
        r_readData2 <= 0;
        r_immediateExtendValue <= 0;
        r_rt <= 0;
        r_rd <= 0;
    end
    else begin
        r_incrementedPC <= i_incrementedPC;
        r_regWrite <= i_regWrite;
        r_aluSrc <= i_aluSrc;
        r_aluOp <= i_aluOp;
        r_branch <= i_branch;
        r_regDest <= i_regDest;
        r_readData1 <= i_readData1;
        r_readData2 <= i_readData2;
        r_immediateExtendValue <= i_immediateExtendValue;
        r_rt <= i_rt;
        r_rd <= i_rd;
    end
end

//Assigns
assign o_incrementedPC = r_incrementedPC;
assign o_regWrite = r_regWrite;
assign o_aluSrc = r_aluSrc;
assign o_aluOp = r_aluOp;
assign o_branch = r_branch;
assign o_regDest = r_regDest;
assign o_readData1 = r_readData1;
assign o_readData2 = r_readData2;
assign o_immediateExtendValue = r_immediateExtendValue;
assign o_rt = r_rt;
assign o_rd = r_rd;

endmodule
