module mux4to1 
#(
    parameter DATA_LEN = 32
)
(
    //Inputs
    input wire [DATA_LEN-1:0] i_muxInputA,
    input wire [DATA_LEN-1:0] i_muxInputB,
    input wire [DATA_LEN-1:0] i_muxInputC,
    input wire [DATA_LEN-1:0] i_muxInputD,
    input wire [1:0]          i_muxSelector,

    //Outputs
    output wire [DATA_LEN-1:0] o_muxOutput
);

localparam INPUTA = 1'b00;
localparam INPUTB = 1'b01;
localparam INPUTC = 1'b10;
localparam INPUTD = 1'b11;

reg [DATA_LEN-1:0] r_muxOutput;

always @(*) begin
    case (i_muxSelector)
        INPUTA: r_muxOutput = i_muxInputA;
        INPUTB: r_muxOutput = i_muxInputB;
        INPUTC: r_muxOutput = i_muxInputC;
        INPUTD: r_muxOutput = i_muxInputD;
        
        default: r_muxOutput = i_muxInputA; 
    endcase
end

//Assigns
assign o_muxOutput = r_muxOutput;

endmodule