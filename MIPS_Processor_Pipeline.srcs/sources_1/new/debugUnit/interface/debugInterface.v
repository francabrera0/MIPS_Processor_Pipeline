module debugInterface
#(
    parameter UART_DATA_LEN = 8,
    parameter CPU_DATA_LEN = 32,
    parameter REGISTER_BITS = 5,
    parameter PC_LEN = 32
)
(
    input wire i_clk,
    input wire i_reset,

    //Signals from uart
    input wire i_txFull,
    input wire i_rxEmpty,
    input wire [UART_DATA_LEN-1:0] i_dataToRead,

    //Signals from CPU
    input wire [CPU_DATA_LEN-1:0] i_regMemValue,
    input wire i_halt,
    input wire [PC_LEN-1:0] i_programCounter,

    //Signals to uart
    output wire o_readUart,
    output wire o_writeUart,
    output wire [UART_DATA_LEN-1:0] o_dataToWrite,

    //Signals to CPU
    output wire o_enable,
    output wire o_writeInstruction,
    output wire [CPU_DATA_LEN-1:0] o_instructionToWrite,
    output wire [REGISTER_BITS-1:0] o_regMemAddress,
    output wire o_regMemCtrl
);

localparam [3:0] IDLE = 4'b0000;
localparam [3:0] WAIT = 4'b0001;
localparam [3:0] DECODE = 4'b0010;
localparam [3:0] INSTRUCTION = 4'b0011;
localparam [3:0] STEP = 4'b0100;
localparam [3:0] SEND_VALUES = 4'b0101;
localparam [3:0] SEND_PC = 4'b0110;
localparam [3:0] RUN = 4'b0111;
localparam [3:0] HALT = 4'b1000;
localparam [3:0] WAIT_SEND = 4'b1001;
localparam [3:0] WRITE_INSTRUCTION = 4'b1010;

localparam [UART_DATA_LEN-1:0] PROGRAM_CODE = 8'h23;
localparam [UART_DATA_LEN-1:0] STEP_CODE= 8'h12;
localparam [UART_DATA_LEN-1:0] RUN_CODE = 8'h54;

reg [3:0] r_state, r_stateNext;
reg [3:0] r_wait, r_waitNext;

reg r_readUart;
reg r_writeUart;

reg [UART_DATA_LEN-1:0] r_dataToWrite;

reg r_enable;
reg r_writeInstruction;
reg [CPU_DATA_LEN-1:0] r_instructionToWrite;

reg [1:0] r_byteCounter, r_byteCounterNext;
reg [5:0] r_regMemAddress, r_regMemAddressNext;

reg r_halt;


//Finite State Machine with Data (State and Data registers)
always @(posedge i_clk) begin
    if(i_reset) begin
        r_state <= IDLE;
        r_readUart <= 1'b0;
        r_writeUart <= 1'b0;
        r_dataToWrite <= {UART_DATA_LEN{1'b0}};
        r_enable <= 1'b0;
        r_writeInstruction <= 1'b0;
        r_instructionToWrite <= {CPU_DATA_LEN{1'b0}};
        r_byteCounter <= 2'b00;
        r_wait <= 3'b000;
        r_regMemAddress <= 6'b00000;
        r_halt = 1'b0;

    end
    else begin
        r_state <= r_stateNext;
        r_byteCounter <= r_byteCounterNext;
        r_wait <= r_waitNext;
        r_regMemAddress <= r_regMemAddressNext;
    end
end

//Finiste State Machine with Data (Next logic state)
always @(*) begin
    r_stateNext = r_state;              
    r_byteCounterNext = r_byteCounter;
    r_waitNext = r_wait;
    r_regMemAddressNext = r_regMemAddress;

    case (r_state)
        IDLE: begin
            if(~i_rxEmpty) begin
                r_stateNext = DECODE;
            end
        end
        
        WAIT: begin
            if(~i_rxEmpty) begin
                r_stateNext = r_wait;
            end
        end

        WAIT_SEND: begin
            if(~i_txFull) begin
                r_stateNext = r_wait;
            end
        end

        DECODE: begin
            if(i_rxEmpty) begin
                r_stateNext = WAIT;
                r_waitNext = DECODE;
            end
            else begin
                if(i_dataToRead == PROGRAM_CODE) begin
                    r_stateNext = INSTRUCTION;
                    r_instructionToWrite = 32'b0;
                end
                else if(i_dataToRead == STEP_CODE) begin
                    r_stateNext = STEP;
                end
                else if(i_dataToRead == RUN_CODE) begin
                    r_stateNext = RUN;
                end
                else begin
                    r_stateNext = IDLE;
                end
            end
        end

        INSTRUCTION: begin
            if(i_rxEmpty) begin
                r_stateNext = WAIT;
                r_waitNext = INSTRUCTION;
            end
            else begin
                r_instructionToWrite = r_instructionToWrite | (i_dataToRead << (r_byteCounter * 8));
                                
                if(r_byteCounter == 2'b11) begin
                    r_byteCounterNext = 2'b00;
                    r_stateNext = WRITE_INSTRUCTION;
                end
                else begin
                    r_byteCounterNext = r_byteCounter + 1;
                    r_stateNext = INSTRUCTION;
                end
            end
        end

        WRITE_INSTRUCTION: begin
            r_stateNext = IDLE;
        end

        STEP: begin
            r_stateNext = SEND_VALUES;
            if(i_halt) begin
                r_stateNext = HALT;
            end
        end

        RUN: begin
            if(i_halt) begin
                r_stateNext = SEND_VALUES;
                r_halt = 1;
            end
        end

        SEND_VALUES: begin
            if(i_txFull) begin
                r_stateNext = WAIT_SEND;
                r_waitNext = SEND_VALUES;
            end
            else begin
                
                r_dataToWrite = (i_regMemValue >> (r_byteCounter*8) & 32'hff);
                
                r_stateNext = SEND_VALUES;
                
                if(r_byteCounter == 2'b11) begin
                    r_regMemAddressNext = r_regMemAddress + 1;
    
                    if(r_regMemAddress == 6'b111111) begin
                       r_stateNext = SEND_PC;
                    end
                end
                r_byteCounterNext = r_byteCounter + 1;
            end
        end

        SEND_PC: begin
            if(i_txFull) begin
                r_stateNext = WAIT_SEND;
                r_waitNext = SEND_PC;
            end
            else begin
                
                r_dataToWrite = (i_programCounter >> (r_byteCounter*8) & 32'hff);
    
                r_stateNext = SEND_PC;
    
                if(r_byteCounter == 2'b11) begin
    
                    if(r_halt)
                        r_stateNext = HALT;
                    else
                        r_stateNext = IDLE;
                end
                r_byteCounterNext = r_byteCounter + 1;
            end
        end
        
        HALT: begin
            //Logic
        end

        default: begin
            r_byteCounterNext = 2'b00;     
            r_stateNext = IDLE;
        end
    endcase

end

//Finiste State Machine with Data (output logic)
always @(*) begin

    case (r_state)
        IDLE: begin
            r_writeUart = 1'b0;
            r_writeInstruction = 1'b0;
            r_readUart = 1'b0;
        end
        
        WAIT: begin
            r_readUart = 1'b0;
        end

        WAIT_SEND: begin
            r_writeUart = 1'b0;
        end

        DECODE: begin
            r_readUart = 1'b1;
        end

        INSTRUCTION: begin
            r_readUart = 1'b1;
            r_enable = 1'b0;
        end

        WRITE_INSTRUCTION: begin
            r_writeInstruction = 1'b1;
        end

        STEP: begin
            r_readUart = 1'b0;
            r_enable = 1'b1;
        end

        RUN: begin
            r_readUart = 1'b0;
            r_enable = 1'b1;
        end

        SEND_VALUES: begin
            r_writeUart = 1'b1;
            r_enable = 1'b0;
            r_readUart = 1'b0;
        end

        SEND_PC: begin
            r_writeUart = 1'b1;
            r_enable = 1'b0;
            r_readUart = 1'b0;
        end
        
        HALT: begin
            r_writeUart = 1'b0;
            r_enable = 1'b0;
            r_readUart = 1'b0;
        end

        default: begin
            r_writeUart = 1'b0;
            r_enable = 1'b0;
            r_readUart = 1'b0;
        end
    endcase
end


assign o_instructionToWrite = r_instructionToWrite;
assign o_enable = r_enable;
assign o_writeInstruction = r_writeInstruction;
assign o_regMemAddress = r_regMemAddress[4:0];
assign o_regMemCtrl = r_regMemAddress[5];

assign o_readUart = r_readUart;
assign o_writeUart = r_writeUart;
assign o_dataToWrite = r_dataToWrite;


endmodule