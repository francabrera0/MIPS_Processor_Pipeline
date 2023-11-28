module controlUnit
#(
    parameter DATA_LEN = 32,
    parameter OPCODE_LEN = 6
)
(
    //Inputs
    input wire [DATA_LEN-1:0] i_instruction,

    //Outputs
    output wire o_regWrite,
    output wire [1:0] o_aluSrc,
    output wire [1:0] o_aluOp,
    output wire o_branch,
    output wire o_regDest,
    output wire o_memRead,
    output wire o_memWrite,
    output wire o_memToReg,
    output wire o_halt,
    output wire [1:0] o_loadStoreType
);

localparam RTYPE = 6'b000000;
localparam LB = 6'b100000;
localparam LH = 6'b100001;
localparam LW = 6'b100011;
localparam SW = 6'b101011;
localparam BEQ = 6'b000100;
localparam NOP = 6'b111111;
localparam HALT = 6'b111000;

reg r_regWrite;
reg [1:0] r_aluSrc;
reg [1:0] r_aluOp;
reg r_branch;
reg r_regDest;
reg r_memRead;
reg r_memWrite;
reg r_memToReg;
reg r_halt;
reg r_loadStoreType;

reg [OPCODE_LEN-1:0] r_opCode;
reg r_isShamt;

always @(*) begin
    r_opCode = i_instruction[DATA_LEN-1:DATA_LEN-OPCODE_LEN];
    r_isShamt = ~(i_instruction[2] || i_instruction[5]);       

    case (r_opCode)
        RTYPE: begin
            r_regDest = 1'b1;
            r_aluOp = 2'b10;
            r_aluSrc = (r_isShamt) ? 2'b10 : 2'b00;
            r_branch = 1'b0;
            r_memRead = 1'b0;
            r_memWrite = 1'b0;
            r_regWrite = 1'b1;
            r_memToReg = 1'b0;
            r_halt = 1'b0;
            r_loadStoreType = 2'b11;
        end 
        LW | LB | LH: begin
            r_regDest = 1'b0;
            r_aluOp = 2'b00;
            r_aluSrc = 2'b01;
            r_branch = 1'b0;
            r_memRead = 1'b1;
            r_memWrite = 1'b0;
            r_regWrite = 1'b1;
            r_memToReg = 1'b1;
            r_halt = 1'b0;
            r_loadStoreType = r_opCode[1:0];
        end
        SW: begin
            r_aluOp = 2'b00;
            r_aluSrc = 2'b01;
            r_branch = 1'b0;
            r_memRead = 1'b0;
            r_memWrite = 1'b1;
            r_regWrite = 1'b0;
            r_halt = 1'b0;
            r_loadStoreType = 2'b11;
        end
        BEQ: begin
            r_aluOp = 2'b01;
            r_aluSrc = 2'b00;
            r_branch = 1'b1;
            r_memRead = 1'b0;
            r_memWrite = 1'b0;
            r_regWrite = 1'b0;
            r_halt = 1'b0;
            r_loadStoreType = 2'b11;
        end
        NOP: begin
            r_regDest = 1'b0;
            r_aluOp = 2'b00;
            r_aluSrc = 2'b00;
            r_branch = 1'b0;
            r_memRead = 1'b0;
            r_memWrite = 1'b0;
            r_regWrite = 1'b0;
            r_memToReg = 1'b0;
            r_halt = 1'b0;
            r_loadStoreType = 2'b11;
        end 
        HALT: begin
            r_regDest = 1'b0;
            r_aluOp = 2'b00;
            r_aluSrc = 2'b00;
            r_branch = 1'b0;
            r_memRead = 1'b0;
            r_memWrite = 1'b0;
            r_regWrite = 1'b0;
            r_memToReg = 1'b0;
            r_halt = 1'b1;
            r_loadStoreType = 2'b11;
        end
        default: begin
            r_regDest = 1'b0;
            r_aluOp = 2'b00;
            r_aluSrc = 2'b00;
            r_branch = 1'b0;
            r_memRead = 1'b0;
            r_memWrite = 1'b0;
            r_regWrite = 1'b0;
            r_memToReg = 1'b0;
            r_halt = 1'b0;
            r_loadStoreType = 2'b11;
        end 
    endcase
end

assign o_regWrite = r_regWrite;
assign o_aluSrc = r_aluSrc;
assign o_aluOp = r_aluOp;
assign o_branch = r_branch;
assign o_regDest = r_regDest;
assign o_memRead = r_memRead;
assign o_memWrite = r_memWrite;
assign o_memToReg = r_memToReg;
assign o_halt = r_halt;

endmodule
