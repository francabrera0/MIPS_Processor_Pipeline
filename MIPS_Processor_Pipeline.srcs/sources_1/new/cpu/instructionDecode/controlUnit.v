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
    output wire [2:0] o_immediateFunct,
    output wire [1:0] o_branch,
    output wire o_jumpType,
    output wire [1:0] o_regDest,
    output wire o_memRead,
    output wire o_memWrite,
    output wire [1:0] o_memToReg,
    output wire o_halt,
    output wire [1:0] o_loadStoreType,
    output wire o_unsigned
);

localparam RTYPE = 6'b000000;
localparam J = 6'b000010;
localparam JAL = 6'b000011;

localparam BEQ = 6'b000100;
localparam BNE = 6'b000101;

localparam ADDI = 6'b001000;
localparam STLI = 6'b001010;

localparam ANDI = 6'b001100;
localparam ORI = 6'b001101;
localparam XORI = 6'b001110;
localparam LUI = 6'b001111;

localparam LB = 6'b100000;
localparam LH = 6'b100001;
localparam LW = 6'b100011;

localparam LHU = 6'b100101;
localparam LBU = 6'b100100;
localparam LWU = 6'b100111;

localparam SB = 6'b101000;
localparam SH = 6'b101001;
localparam SW = 6'b101011;

localparam HALT = 6'b111000;

localparam NOP = 6'b111111;

reg r_regWrite;
reg [1:0] r_aluSrc;
reg [1:0] r_aluOp;
reg [2:0] r_immediateFunct;
reg [1:0] r_branch;
reg r_jumpType;
reg [1:0] r_regDest;
reg r_memRead;
reg r_memWrite;
reg [1:0]r_memToReg;
reg r_halt;
reg [1:0] r_loadStoreType;
reg r_unsigned;

reg [OPCODE_LEN-1:0] r_opCode;
reg r_isShamt;
reg r_isNotJR;
reg r_isJARL;

always @(*) begin
    r_opCode = i_instruction[DATA_LEN-1:DATA_LEN-OPCODE_LEN];
    r_isShamt = ~(i_instruction[2] || i_instruction[5]);
    r_isNotJR = (i_instruction[5:0] != 6'b001000); 
    r_isJARL = i_instruction[3] & i_instruction[0];

    case (r_opCode[OPCODE_LEN-1:2])
        RTYPE[OPCODE_LEN-1:2]: begin
            r_regDest = {r_opCode[0], 1'b1};
            r_aluOp = 2'b10;
            r_immediateFunct = 3'b000;
            r_aluSrc = (r_isShamt) ? 2'b10 : 2'b00;
            r_branch = r_opCode[1] | (!r_opCode[1] & i_instruction[3])? 2'b10 : 2'b00;
            r_jumpType = !r_opCode[1];
            r_memRead = 1'b0;
            r_memWrite = 1'b0;
            r_regWrite = (!(r_opCode[1] | r_opCode[0]))? r_isNotJR : r_opCode[0]; //Si es R-TYPE escribe en registro en todos los casos menos JR, si no es R-TYPE escribe solo en JAL
            r_memToReg = {r_opCode[0] | r_isJARL, 1'b0}; //Si es JL o JARL write return address
            r_halt = 1'b0;
            r_loadStoreType = 2'b11;
            r_unsigned = 0;
        end
        ADDI[OPCODE_LEN-1:2]: begin
            r_regDest = 2'b00;
            r_aluOp = 2'b11;
            r_immediateFunct = r_opCode[2:0];
            r_aluSrc = 2'b01;
            r_branch = 2'b00;
            r_jumpType = 1'b0;
            r_memRead = 1'b0;
            r_memWrite = 1'b0;
            r_regWrite = 1'b1;
            r_memToReg = 2'b00;
            r_halt = 1'b0;
            r_loadStoreType = 2'b11;
            r_unsigned = 1'b0;
        end
        ANDI[OPCODE_LEN-1:2]: begin
            r_regDest = 2'b00;
            r_aluOp = 2'b11;
            r_immediateFunct = r_opCode[2:0];
            r_aluSrc = 2'b01;
            r_branch = 2'b00;
            r_jumpType = 1'b0;
            r_memRead = 1'b0;
            r_memWrite = 1'b0;
            r_regWrite = 1'b1;
            r_memToReg = 2'b00;
            r_halt = 1'b0;
            r_loadStoreType = 2'b11;
            r_unsigned = 1'b0;
        end
        LW[OPCODE_LEN-1:2]: begin
            r_regDest = 2'b00;
            r_aluOp = 2'b00;
            r_immediateFunct = 3'b000;
            r_aluSrc = 2'b01;
            r_branch = 2'b00;
            r_jumpType = 1'b0;
            r_memRead = 1'b1;
            r_memWrite = 1'b0;
            r_regWrite = 1'b1;
            r_memToReg = 2'b01;
            r_halt = 1'b0;
            r_loadStoreType = r_opCode[1:0];
            r_unsigned = 1'b0;
        end
        LWU[OPCODE_LEN-1:2]: begin
            r_regDest = 2'b00;
            r_immediateFunct = 3'b000;
            r_aluOp = 2'b00;
            r_aluSrc = 2'b01;
            r_branch = 2'b00;
            r_jumpType = 1'b0;
            r_memRead = 1'b1;
            r_memWrite = 1'b0;
            r_regWrite = 1'b1;
            r_memToReg = 2'b01;
            r_halt = 1'b0;
            r_loadStoreType = r_opCode[1:0];
            r_unsigned = 1'b1;
        end
        SW[OPCODE_LEN-1:2]: begin
            r_regDest = 2'b00;
            r_aluOp = 2'b00;
            r_immediateFunct = 3'b000;
            r_aluSrc = 2'b01;
            r_branch = 2'b00;
            r_jumpType = 1'b0;
            r_memRead = 1'b0;
            r_memWrite = 1'b1;
            r_regWrite = 1'b0;
            r_memToReg = 2'b00;
            r_halt = 1'b0;
            r_loadStoreType = r_opCode[1:0];
            r_unsigned = 0;
        end
        BEQ[OPCODE_LEN-1:2]: begin
            r_regDest = 2'b00;
            r_aluOp = 2'b01;
            r_immediateFunct = 3'b000;
            r_aluSrc = 2'b00;
            r_branch = {r_opCode[0],1'b1};
            r_jumpType = 1'b0;
            r_memRead = 1'b0;
            r_memWrite = 1'b0;
            r_regWrite = 1'b0;
            r_memToReg = 2'b00;
            r_halt = 1'b0;
            r_loadStoreType = 2'b11;
            r_unsigned = 0;
        end
        NOP[OPCODE_LEN-1:2]: begin
            r_regDest = 2'b00;
            r_aluOp = 2'b00;
            r_immediateFunct = 3'b000;
            r_aluSrc = 2'b00;
            r_branch = 2'b00;
            r_jumpType = 1'b0;
            r_memRead = 1'b0;
            r_memWrite = 1'b0;
            r_regWrite = 1'b0;
            r_memToReg = 2'b00;
            r_halt = 1'b0;
            r_loadStoreType = 2'b11;
            r_unsigned = 0;
        end 
        HALT[OPCODE_LEN-1:2]: begin
            r_regDest = 2'b00;
            r_aluOp = 2'b00;
            r_immediateFunct = 3'b000;
            r_aluSrc = 2'b00;
            r_branch =  2'b00;
            r_jumpType = 1'b0;
            r_memRead = 1'b0;
            r_memWrite = 1'b0;
            r_regWrite = 1'b0;
            r_memToReg = 2'b00;
            r_halt = 1'b1;
            r_loadStoreType = 2'b11;
            r_unsigned = 0;
        end
        default: begin
            r_regDest = 2'b00;
            r_aluOp = 2'b00;
            r_immediateFunct = 3'b000;
            r_aluSrc = 2'b00;
            r_branch =  2'b00;
            r_jumpType = 1'b0;
            r_memRead = 1'b0;
            r_memWrite = 1'b0;
            r_regWrite = 1'b0;
            r_memToReg = 2'b00;
            r_halt = 1'b0;
            r_loadStoreType = 2'b11;
            r_unsigned = 0;
        end 
    endcase
end

assign o_regWrite = r_regWrite;
assign o_aluSrc = r_aluSrc;
assign o_aluOp = r_aluOp;
assign o_immediateFunct = r_immediateFunct;
assign o_branch = r_branch;
assign o_jumpType = r_jumpType;
assign o_regDest = r_regDest;
assign o_memRead = r_memRead;
assign o_memWrite = r_memWrite;
assign o_memToReg = r_memToReg;
assign o_halt = r_halt;
assign o_loadStoreType = r_loadStoreType;
assign o_unsigned = r_unsigned;

endmodule
