module decodeExecutionBuffer
#(
    parameter DATA_LEN = 32,
    parameter PC_LEN = 32,
    parameter REGISTER_BITS = 5
)
(
    //Inputs
    input wire i_clk,
    input wire i_reset,
    input wire i_enable,
    
    input wire [PC_LEN-1:0] i_incrementedPC,
    input wire i_regWrite,
    input wire [1:0] i_aluSrc,
    input wire [1:0] i_aluOp,
    input wire i_branch,
    input wire i_regDest,
    input wire [DATA_LEN-1:0] i_readData1,
    input wire [DATA_LEN-1:0] i_readData2,
    input wire [DATA_LEN-1:0] i_immediateExtendValue,
    input wire [REGISTER_BITS-1:0] i_rt,
    input wire [REGISTER_BITS-1:0] i_rd,
    input wire i_memRead,
    input wire i_memWrite,
    input wire i_memToReg,
    input wire [DATA_LEN-1:0] i_shamt,
    input wire i_halt,
    input wire [1:0] i_loadStoreType,
    input wire i_unsigned,

    //Outputs
    output wire [PC_LEN-1:0] o_incrementedPC,
    output wire o_regWrite,
    output wire [1:0] o_aluSrc,
    output wire [1:0] o_aluOp,
    output wire o_branch,
    output wire o_regDest,
    output wire [DATA_LEN-1:0] o_readData1,
    output wire [DATA_LEN-1:0] o_readData2,
    output wire [DATA_LEN-1:0] o_immediateExtendValue,
    output wire [REGISTER_BITS-1:0] o_rt,
    output wire [REGISTER_BITS-1:0] o_rd,
    output wire o_memRead,
    output wire o_memWrite,
    output wire o_memToReg,
    output wire [DATA_LEN-1:0] o_shamt,
    output wire o_halt,
    output wire [1:0] o_loadStoreType,
    output wire o_unsigned
);

reg [PC_LEN-1:0] r_incrementedPC;
reg r_regWrite;
reg [1:0] r_aluSrc;
reg [1:0] r_aluOp;
reg r_branch;
reg r_regDest;
reg [DATA_LEN-1:0] r_readData1;
reg [DATA_LEN-1:0] r_readData2;
reg [DATA_LEN-1:0] r_immediateExtendValue;
reg [REGISTER_BITS-1:0] r_rt;
reg [REGISTER_BITS-1:0] r_rd;
reg r_memRead;
reg r_memWrite;
reg r_memToReg;
reg [DATA_LEN-1:0] r_shamt;
reg r_halt;
reg [1:0] r_loadStoreType;
reg r_unsigned;

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
        r_memRead <= 0;
        r_memWrite <= 0;
        r_memToReg <= 0;
        r_shamt <= 0;
        r_halt <= 0;
        r_loadStoreType <= 2'b11;
        r_unsigned <= 0;
    end
    else if (i_enable) begin
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
        r_memRead <= i_memRead;
        r_memWrite <= i_memWrite;
        r_memToReg <= i_memToReg;
        r_shamt <= i_shamt;
        r_halt <= i_halt;
        r_loadStoreType <= i_loadStoreType;
        r_unsigned <= i_unsigned;
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
assign o_memRead = r_memRead;
assign o_memWrite = r_memWrite;
assign o_memToReg = r_memToReg;
assign o_shamt = r_shamt;
assign o_halt = r_halt;
assign o_loadStoreType = r_loadStoreType;
assign o_unsigned = r_unsigned;

endmodule
