module uartTX#
(
    parameter DATA_LEN = 8,
    parameter SB_TICK = 16
)
(
    input wire i_clk,
    input wire i_reset,
    input wire i_txStart,
    input wire i_tick,
    input wire [DATA_LEN-1 : 0] i_txDataIn,
    output reg o_txDone,
    output wire o_uartTx
);

//symbolic state declaration
localparam [1:0] IDLE = 2'b00;
localparam [1:0] START = 2'b01;
localparam [1:0] DATA = 2'b10;
localparam [1:0] STOP = 2'b11;

//signal declaration
reg [1:0] stateReg;
reg [1:0] stateNext;

reg [3:0] ticksReg;
reg [3:0] ticksNext;

reg [2:0] sendBitsReg;
reg [2:0] sendBitsNext;

reg [DATA_LEN-1:0] sendByteReg;
reg [DATA_LEN-1:0] sendByteNext;

reg txReg;
reg txNext;

//Finite State Machine with Data (state and DATA registers)
always @(posedge i_clk) begin
    if(i_reset) begin
        stateReg <= IDLE;
        ticksReg <= 0;
        sendBitsReg <= 0;
        sendByteReg <= 0;
        txReg <= 1'b1;
    end
    else begin
        stateReg <= stateNext;
        ticksReg <= ticksNext;
        sendBitsReg <= sendBitsNext;
        sendByteReg <= sendByteNext;
        txReg <= txNext;
    end
end

//Finite State Machine with Data (next state logic and functional units)
always @(*) begin
    stateNext = stateReg;
    o_txDone = 1'b0;
    ticksNext = ticksReg;
    sendBitsNext = sendBitsReg;
    sendByteNext = sendByteReg;
    txNext = txReg;

    case (stateReg)
        IDLE: begin
            txNext = 1'b1;
            if(i_txStart) begin
                stateNext = START;
                ticksNext = 0;
                sendByteNext = i_txDataIn;
            end
        end
        
        START: begin
            txNext = 1'b0;
            if (i_tick) begin
                if (ticksReg == 15) begin
                    stateNext = DATA;
                    ticksNext = 0;
                    sendBitsNext = 0;
                end
                else begin
                    ticksNext = ticksReg + 1;
                end
            end
        end

        DATA: begin
            txNext = sendByteReg[0];
            if (i_tick) begin
                if(ticksReg==15) begin
                    ticksNext = 0;
                    sendByteNext = sendByteReg >> 1;
                    if (sendBitsReg==(DATA_LEN-1)) begin
                        stateNext = STOP;
                    end
                    else begin
                        sendBitsNext = sendBitsReg + 1;
                    end
                end
                else begin
                    ticksNext = ticksReg + 1;
                end
            end
        end

        STOP: begin
            txNext = 1'b1;
            if (i_tick) begin
                if (ticksReg==(SB_TICK-1)) begin
                    stateNext = IDLE;
                    o_txDone = 1'b1;
                end
                else begin
                    ticksNext = ticksReg + 1;
                end
            end
        end
        default: begin
            stateNext = IDLE;
        end
    endcase
end

assign o_uartTx = txReg;

endmodule
