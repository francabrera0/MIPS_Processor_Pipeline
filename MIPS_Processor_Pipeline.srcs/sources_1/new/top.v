module top #(
    parameter CPU_DATA_LEN = 32,
    parameter UART_DATA_LEN = 8,
    parameter SB_TICK = 16,
    parameter COUNTER_MOD = 27,
    parameter COUNTER_BITS = 5,
    parameter PTR_LEN = 4,
    parameter PC_LEN = 32,
    parameter MEM_SIZE_ADDRESS_BITS = 10,
    parameter OPCODE_LEN = 6,
    parameter REGISTER_BITS = 5, //Cantidad de bits que direccionan registros
    parameter IMMEDIATE_LEN = 16,
    parameter FUNCTION_LEN = 6
)(
    input wire i_clk,
    input wire i_reset,
    input wire i_rx,
    output wire o_tx,
    output wire [15:0] o_instruction
);

wire w_enable;
wire w_halt;
wire [CPU_DATA_LEN-1:0] w_regMemValue;
wire w_writeInstruction;
wire [CPU_DATA_LEN-1:0] w_instructionToWrite;
wire [REGISTER_BITS-1:0] w_regMemAddress;
wire w_regMemCtrl;
wire [PC_LEN-1:0] w_programCounter;

wire o_locked;
wire o_clk;

//Debug unit
debugUnit#(
    .UART_DATA_LEN(UART_DATA_LEN),
    .SB_TICK(SB_TICK),
    .COUNTER_MOD(COUNTER_MOD),
    .COUNTER_BITS(COUNTER_BITS),
    .PTR_LEN(PTR_LEN),
    .CPU_DATA_LEN(CPU_DATA_LEN)
) debugUnit
(
    .i_clk(o_clk),
    .i_reset(i_reset),
    .i_uartRx(i_rx),
    .i_regMemValue(w_regMemValue),
    .i_halt(w_halt),
    .i_programCounter(w_programCounter),
    .o_uartTx(o_tx),
    .o_enable(w_enable),
    .o_writeInstruction(w_writeInstruction),
    .o_instructionToWrite(w_instructionToWrite),
    .o_regMemAddress(w_regMemAddress),
    .o_regMemCtrl(w_regMemCtrl)
);


cpu#(
    .DATA_LEN(CPU_DATA_LEN),
    .PC_LEN(PC_LEN),
    .MEM_SIZE_ADDRESS_BITS(MEM_SIZE_ADDRESS_BITS),
    .OPCODE_LEN(OPCODE_LEN), 
    .REGISTER_BITS(REGISTER_BITS),
    .IMMEDIATE_LEN(IMMEDIATE_LEN),
    .FUNCTION_LEN(FUNCTION_LEN)
) cpu
(
    .i_clk(o_clk),
    .i_reset(i_reset),
    .i_writeInstruction(w_writeInstruction),
    .i_enable(w_enable & o_locked),
    .i_instructionToWrite(w_instructionToWrite),
    .i_regMemAddress(w_regMemAddress),
    .i_regMemCtrl(w_regMemCtrl),
    .o_regMemValue(w_regMemValue),
    .o_halt(w_halt),
    .o_programCounter(w_programCounter),
    .o_instruction(o_instruction)
);

clk_wiz_0 clkWiz (
    .clk_out1(o_clk),
    .reset(i_reset),
    .locked(o_locked),      
    .clk_in1(i_clk)      
);

endmodule