module debugInterface
#(
    parameter UART_DATA_LEN = 8,
    parameter CPU_DATA_LEN = 32
)
(
    input wire i_clk,
    input wire i_reset,

    //Signals from uart
    input wire i_txFull,
    input wire i_rxEmpty,
    input wire [UART_DATA_LEN-1:0] i_dataToRead,

    //Signals from CPU

    //Signals to uart
    output wire o_readUart,
    output wire o_writeUart,
    output wire [UART_DATA_LEN-1:0] o_dataToWrite,

    //Signals to CPU
    output wire o_enable,
    output wire o_writeInstruction,
    output wire [CPU_DATA_LEN-1:0] o_instructionToWrite
);

localparam [2:0] IDLE = 3'b000;
localparam [2:0] WAIT = 3'b001;
localparam [2:0] DECODE = 3'b010;
localparam [2:0] INSTRUCTION = 3'b011;

localparam [UART_DATA_LEN-1:0] PROGRAM_CODE = 8'h23;

reg [2:0] r_state, r_stateNext;
reg [2:0] r_wait, r_waitNext;

reg r_readUart, r_readUartNext;
reg r_writeUart, r_writeUartNext;

reg [UART_DATA_LEN-1:0] r_dataToRead, r_dataToReadNext;
reg [UART_DATA_LEN-1:0] r_dataToWrite, r_dataToWriteNext;

reg r_enable, r_enableNext;
reg r_writeInstruction, r_writeInstructionNext;
reg [CPU_DATA_LEN-1:0] r_instructionToWrite, r_instructionToWriteNext;

reg [1:0] r_byteCounter, r_byteCounterNext;


always @(posedge i_clk) begin
    if(i_reset) begin
        r_state <= IDLE;
        r_readUart <= 1'b0;
        r_writeUart <= 1'b0;
        r_dataToRead <= {UART_DATA_LEN{1'b0}};
        r_dataToWrite <= {UART_DATA_LEN{1'b0}};
        r_enable <= 1'b0;
        r_writeInstruction <= 1'b0;
        r_instructionToWrite <= {CPU_DATA_LEN{1'b0}};
        r_byteCounter <= 2'b00;
        r_wait <= 3'b000;
    end
    else begin
        r_state <= r_stateNext;
        r_readUart <= r_readUartNext;
        r_writeUart <= r_writeUartNext;
        r_dataToRead <= r_dataToReadNext;
        r_dataToWrite <= r_dataToWriteNext;
        r_enable <= r_enableNext;
        r_writeInstruction <= r_writeInstructionNext;
        r_instructionToWrite <= r_instructionToWriteNext;
        r_byteCounter <= r_byteCounterNext;
        r_wait <= r_waitNext;
    end
end

always @(*) begin
    r_stateNext = r_state;              
    r_readUartNext = r_readUart;           
    r_writeUartNext = r_writeUart;          
    r_dataToReadNext = r_dataToRead;         
    r_dataToWriteNext = r_dataToWrite;        
    r_enableNext = r_enable;             
    r_writeInstructionNext = r_writeInstruction;
    r_instructionToWriteNext = r_instructionToWrite; 
    r_byteCounterNext = r_byteCounter;
    r_waitNext = r_wait;

    case (r_state)
        IDLE: begin
            r_writeInstructionNext = 1'b0;
            if(~i_rxEmpty) begin
                r_stateNext = DECODE;
                r_readUartNext = 1'b1;
            end
        end
        
        WAIT: begin
            if(~i_rxEmpty) begin
                r_stateNext = r_wait;
                r_readUartNext = 1'b1;
            end
        end

        DECODE: begin
            if(i_rxEmpty) begin
                r_readUartNext = 1'b0;
                r_stateNext = WAIT;
                r_waitNext = DECODE;
            end
            else begin
                if(i_dataToRead == PROGRAM_CODE) begin
                    r_stateNext = INSTRUCTION;
                    r_readUartNext = 1'b1;
                end
                else begin
                    r_stateNext = IDLE;
                    r_readUartNext = 1'b0;
                end
            end
        end

        INSTRUCTION: begin
            if(i_rxEmpty) begin
                r_readUartNext = 1'b0;
                r_stateNext = WAIT;
                r_waitNext = INSTRUCTION;
            end
            else begin
                if(r_byteCounter == 2'b00) r_instructionToWriteNext[7:0] = i_dataToRead;
                if(r_byteCounter == 2'b01) r_instructionToWriteNext[15:8] = i_dataToRead;
                if(r_byteCounter == 2'b10) r_instructionToWriteNext[23:16] = i_dataToRead;

                if(r_byteCounter == 2'b11) begin
                    r_instructionToWriteNext[31 :24] = i_dataToRead;
                    r_byteCounterNext = 2'b00;
                    r_stateNext = IDLE;
                    r_writeInstructionNext = 1'b1;
                    r_readUartNext = 1'b0;
                end
                else begin
                    r_byteCounterNext = r_byteCounter + 1;
                    r_stateNext = INSTRUCTION;
                end
            end
        end

        default: begin
            r_byteCounterNext = 2'b00;
            r_readUartNext = 1'b0;
            r_writeInstructionNext = 1'b0;
            r_stateNext = IDLE;
        end
    endcase

end

assign o_instructionToWrite = r_instructionToWrite;
assign o_enable = r_enable;
assign o_writeInstruction = r_writeInstruction;

assign o_readUart = r_readUart;
assign o_writeUart = r_writeUart;
assign o_dataToWrite = r_dataToWrite;

endmodule