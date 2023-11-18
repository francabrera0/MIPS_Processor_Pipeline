module uart#
(
    parameter DATA_LEN = 8,
    parameter SB_TICK = 16,
    parameter COUNTER_MOD = 326,
    parameter COUNTER_BITS = 9,
    parameter PTR_LEN = 2        
)
(
    input wire i_clk,
    input wire i_reset,
    input wire i_readUart,
    input wire i_writeUart,
    input wire i_uartRx,
    input wire [DATA_LEN-1 : 0] i_dataToWrite,
    output wire o_txFull,
    output wire o_rxEmpty,
    output wire o_uartTx,
    output wire [DATA_LEN-1 : 0] o_dataToRead
);

//Signal declaration
wire tick;
wire txDone;
wire txEmpty;
wire txNotEmpty;
wire [DATA_LEN-1 : 0] txFifoOut;
wire [DATA_LEN-1 : 0] rxDataOut;


modMCounter #
(
    .COUNTER_MOD(COUNTER_MOD),
    .COUNTER_BITS(COUNTER_BITS)
) baudRateGeneratorUnit
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .o_counterMaxTick(tick)
);

uartRX #
(
    .DATA_LEN(DATA_LEN),
    .SB_TICK(SB_TICK)
) uartRxUnit
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_uartRx(i_uartRx),
    .i_tick(tick),
    .o_rxDone(rxDone),
    .o_rxDataOut(rxDataOut)
);

fifoBuffer #
(
    .DATA_LEN(DATA_LEN),
    .PTR_LEN(PTR_LEN)
) fifoBufferRXUnit
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_fifoRead(i_readUart),
    .i_fifoWrite(rxDone),
    .i_dataToWrite(rxDataOut),
    .o_fifoEmpty(o_rxEmpty),
    .o_fifoFull(),
    .o_dataToRead(o_dataToRead)
);

fifoBuffer #
(
    .DATA_LEN(DATA_LEN),
    .PTR_LEN(PTR_LEN)
) fifoBufferTXUnit
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_fifoRead(txDone),
    .i_fifoWrite(i_writeUart),
    .i_dataToWrite(i_dataToWrite),
    .o_fifoEmpty(txEmpty),
    .o_fifoFull(o_txFull),
    .o_dataToRead(txFifoOut)
);

uartTX #
(
    .DATA_LEN(DATA_LEN),
    .SB_TICK(SB_TICK)
) uartTxUnit
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_txStart(txNotEmpty),
    .i_tick(tick),
    .i_txDataIn(txFifoOut),
    .o_txDone(txDone),
    .o_uartTx(o_uartTx)
);

assign txNotEmpty = ~txEmpty;

endmodule
