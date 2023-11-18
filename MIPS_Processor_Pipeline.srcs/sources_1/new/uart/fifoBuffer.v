module fifoBuffer#
(
    parameter DATA_LEN = 8,
    parameter PTR_LEN = 4
)
(
    input wire i_clk,     
    input wire i_reset,
    input wire i_fifoRead,            
    input wire i_fifoWrite,
    input wire [DATA_LEN-1 : 0] i_dataToWrite,
    output wire o_fifoEmpty,
    output wire o_fifoFull,
    output wire [DATA_LEN-1 : 0] o_dataToRead
);

localparam NOP = 2'b00;
localparam READ = 2'b01;
localparam WRITE = 2'b10;
localparam READWRITE = 2'b11;


//Signal declaration
reg [DATA_LEN-1 : 0] arrayReg [(2**PTR_LEN)-1 : 0];
reg [PTR_LEN-1 : 0] writePtrReg; 
reg [PTR_LEN-1 : 0] writePtrNext; 
reg [PTR_LEN-1 : 0] writePtrSucc;

reg [PTR_LEN-1 : 0] readPtrReg;
reg [PTR_LEN-1 : 0] readPtrNext;
reg [PTR_LEN-1 : 0] readPtrSucc;

reg fullReg;
reg fullNext;
reg emptyReg;
reg emptyNext;

wire writeEnable;

//Register file write operation
always @(posedge i_clk) begin
    if(writeEnable) begin
        arrayReg[writePtrReg] <= i_dataToWrite;
    end
end

//Register file read operation
assign o_dataToRead = arrayReg[readPtrReg];

//Write enable only when FIFO is not o_fifoFull
assign writeEnable = i_fifoWrite & ~fullReg;

//Fifo control logic
//Register for read and write pointers
always @(posedge i_clk) begin
    if(i_reset) begin
        writePtrReg <= 0;
        readPtrReg <= 0;
        fullReg <= 0;
        emptyReg <= 1;
    end
    else begin
        writePtrReg <= writePtrNext;
        readPtrReg <= readPtrNext;
        fullReg <= fullNext;
        emptyReg <= emptyNext;
    end
end

//Next-state logic for read and write pointers
always @(*) begin
    //Successive pointer values
    writePtrSucc = writePtrReg + 1;
    readPtrSucc = readPtrReg + 1; 
    //Default: keep old values
    writePtrNext = writePtrReg;
    readPtrNext = readPtrReg;
    fullNext = fullReg;
    emptyNext = emptyReg;

    case ({i_fifoWrite, i_fifoRead})
        //NOP:
        READ:
            if (~emptyReg) begin
                readPtrNext = readPtrSucc;
                fullNext = 1'b0;
                if (readPtrSucc==writePtrReg) begin
                    emptyNext = 1'b1;
                end
            end
        WRITE:
            if (~fullReg) begin
                writePtrNext = writePtrSucc;
                emptyNext = 1'b0;
                if (writePtrSucc==readPtrReg) begin
                    fullNext = 1'b1;
                end
            end
        READWRITE:
            begin
                writePtrNext = writePtrSucc;
                readPtrNext = readPtrSucc; 
            end 
        default:
            begin
                writePtrNext = writePtrNext;
                readPtrNext = readPtrNext;
            end

    endcase
end

//Output
assign o_fifoFull = fullReg;
assign o_fifoEmpty = emptyReg;

endmodule
