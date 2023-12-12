module debugUnit
#(
    parameter UART_DATA_LEN = 8,
    parameter SB_TICK = 16,
    parameter COUNTER_MOD = 27,
    parameter COUNTER_BITS = 5,
    parameter PTR_LEN = 2,
    parameter CPU_DATA_LEN = 32,
    parameter REGISTER_BITS = 5,
    parameter PC_LEN = 32
)
(
    input wire i_clk,
    input wire i_reset,
    input wire i_uartRx,
    input wire [CPU_DATA_LEN-1:0] i_regMemValue,
    input wire i_halt,
    input wire [PC_LEN-1:0] i_programCounter,
    output wire o_uartTx,
    output wire o_enable,
    output wire o_writeInstruction,
    output wire [CPU_DATA_LEN-1:0] o_instructionToWrite,
    output wire [REGISTER_BITS-1:0] o_regMemAddress,
    output wire o_regMemCtrl,
    output wire o_reset
);


wire w_txFull;
wire w_rxEmpty;
wire [UART_DATA_LEN-1:0] w_dataToRead;

wire w_readUart;
wire w_writeUart;
wire [UART_DATA_LEN-1:0] w_dataToWrite;

uart#(
    .DATA_LEN(UART_DATA_LEN),
    .SB_TICK(SB_TICK),
    .COUNTER_MOD(COUNTER_MOD),
    .COUNTER_BITS(COUNTER_BITS),
    .PTR_LEN(PTR_LEN)        
) debugUnitUart
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_readUart(w_readUart),
    .i_writeUart(w_writeUart),
    .i_uartRx(i_uartRx),
    .i_dataToWrite(w_dataToWrite),
    .o_txFull(w_txFull),
    .o_rxEmpty(w_rxEmpty),
    .o_uartTx(o_uartTx),
    .o_dataToRead(w_dataToRead)
);

debugInterface# (
    .UART_DATA_LEN(UART_DATA_LEN),
    .CPU_DATA_LEN(CPU_DATA_LEN)
) debugInterface
(
    .i_clk(i_clk),

    //Signals from uart
    .i_txFull(w_txFull),
    .i_rxEmpty(w_rxEmpty),
    .i_dataToRead(w_dataToRead),

    //Signals from CPU
    .i_regMemValue(i_regMemValue),
    .i_halt(i_halt),
    .i_programCounter(i_programCounter),

    //Signals to uart
    .o_readUart(w_readUart),
    .o_writeUart(w_writeUart),
    .o_dataToWrite(w_dataToWrite),

    //Signals to CPU
    .o_enable(o_enable),
    .o_writeInstruction(o_writeInstruction),
    .o_instructionToWrite(o_instructionToWrite),
    .o_regMemAddress(o_regMemAddress),
    .o_regMemCtrl(o_regMemCtrl),
    .o_reset(o_reset)
);

endmodule