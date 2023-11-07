`timescale 1ns / 1ps

module SumadorRestador#(
    parameter DATA_LEN  = 32
)
(
    input wire signed  [DATA_LEN-1 : 0] i_operandA,
    input wire signed  [DATA_LEN-1 : 0] i_operandB,
    input wire                          i_substract,
    output wire signed [DATA_LEN-1 : 0] o_result,
    output wire                         o_overflow
);
  
    //Invertir bits si se resta
    wire signed [DATA_LEN-1 : 0] operandB;

    assign operandB = i_operandB ^  {DATA_LEN {i_substract}};

    //Calculo - Sumar 1 si se resta pq es suma resta signada
    assign o_result = i_operandA + operandB + {{DATA_LEN - 1{1'b0}}, i_substract};           
    
    //Overflow
    assign o_overflow = (i_operandA[DATA_LEN -1] == operandB[DATA_LEN -1]) &
                        (i_operandA[DATA_LEN -1] != o_result[DATA_LEN -1]);
endmodule
