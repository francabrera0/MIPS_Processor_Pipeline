module uartRX#
(
    parameter DATA_LEN = 8,
    parameter SB_TICK = 16
)
(
    input wire i_clk,
    input wire i_reset,
    input wire i_uartRx,
    input wire i_tick,
    output reg o_rxDone,
    output wire [DATA_LEN-1:0] o_rxDataOut 
);


//Symbolic state declaration
localparam [1:0] IDLE  = 2'b00;
localparam [1:0] START = 2'b01;
localparam [1:0] DATA  = 2'b10;
localparam [1:0] STOP  = 2'b11;

//Signal declaration
reg [1:0] stateReg;  //Actual state
reg [1:0] stateNext; //Next state

reg [3:0] ticksReg;      //Register to count the number of ticks
reg [3:0] ticksNext;

reg [2:0] receivedBitsReg;     //Register to count the number of received bits
reg [2:0] receivedBitsNext;

reg [DATA_LEN-1:0] receivedByteReg;     //Register to save te received frame
reg [DATA_LEN-1:0] receivedByteNext;

//Finite State Machine with DATA (state and DATA registers)
always @(posedge i_clk) begin
    if (i_reset) begin
        stateReg <= IDLE;
        ticksReg <= 0;
        receivedBitsReg <= 0;
        receivedByteReg <= 0;
    end
    else begin
        stateReg <= stateNext;
        ticksReg <= ticksNext;
        receivedBitsReg <= receivedBitsNext;
        receivedByteReg <= receivedByteNext;
    end
end

//Finite State Machine with DATA (next state logic)
always @(*) begin
    stateNext = stateReg;
    o_rxDone = 1'b0;
    ticksNext = ticksReg;
    receivedBitsNext = receivedBitsReg;
    receivedByteNext = receivedByteReg;

    case (stateReg)
        IDLE:
            if (~i_uartRx) begin
               stateNext = START;
               ticksNext = 0; 
            end
        
        START:
            if (i_tick) begin
                if (ticksReg == 7) begin
                    stateNext = DATA;
                    ticksNext = 0;
                    receivedBitsNext = 0;
                end
                else begin
                    ticksNext = ticksReg + 1;
                end
                
            end

        DATA:
            if (i_tick) begin
                if (ticksReg == 15) begin
                    ticksNext = 0;
                    receivedByteNext = {i_uartRx, receivedByteReg[DATA_LEN-1:1]};
                    if (receivedBitsReg == (DATA_LEN-1)) begin
                        stateNext = STOP;
                    end
                    else begin
                        receivedBitsNext = receivedBitsReg + 1;
                    end

                end
                else begin 
                    ticksNext = ticksReg + 1;
                end
                
            end
        
        STOP:
            if (i_tick) begin
                if (ticksReg == (SB_TICK-1)) begin
                    stateNext = IDLE;
                    if(i_uartRx) begin
                        o_rxDone = 1'b1;
                    end
                end 
                else begin
                    ticksNext = ticksReg + 1;
                end
            end

        default: 
            stateNext = IDLE;   
    endcase
end

assign o_rxDataOut = receivedByteReg;

endmodule