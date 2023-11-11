module mux2to1 
#(
    parameter DATA_LEN = 32
)
(
    //Inputs
    input wire [DATA_LEN-1:0] i_muxInputA,
    input wire [DATA_LEN-1:0] i_muxInputB,
    input wire                i_muxSelector,

    //Outputs
    output wire [DATA_LEN-1:0] o_muxOutput
);

localparam INPUTA = 1'b0;
localparam INPUTB = 1'b1;


reg [DATA_LEN-1:0] r_muxOutput;

always @(*) begin
    case (i_muxSelector)
        INPUTA: r_muxOutput = i_muxInputA;
        INPUTB: r_muxOutput = i_muxInputB;
        
        default: r_muxOutput = i_muxInputA; 
    endcase
end


//Assigns
assign o_muxOutput = r_muxOutput;

endmodule