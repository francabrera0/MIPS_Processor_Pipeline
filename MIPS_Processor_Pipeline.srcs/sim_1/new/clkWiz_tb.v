`timescale 1ns / 1ps


module clkWizTB();

    reg i_clk;
    reg i_reset;
    wire o_locked;
    wire o_clk;


    clk_wiz_0 clkWiz (
    .clk_out1(o_clk),
    .reset(i_reset),
    .locked(o_locked),      
    .clk_in1(i_clk)      
    );

    always begin
        #5 i_clk = ~i_clk;
    end

    initial begin
        i_clk = 0;
        i_reset = 1;
        #10;
        i_reset = 0;
    end


endmodule
