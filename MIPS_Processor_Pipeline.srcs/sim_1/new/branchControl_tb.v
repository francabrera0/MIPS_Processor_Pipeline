`timescale 1ns / 1ps

module branchControl_tb;
    
    reg i_branch;
    reg i_zero;
    wire o_pcSrc;
    
    branchControl branchControl(
        //Control inputs
        .i_branch(i_branch),
        .i_zero(i_zero),
        //Control outputs
        .o_pcSrc(o_pcSrc)
    );
    
    initial begin
        i_branch = 0;
        i_zero = 0;
        
        if(o_pcSrc != 0) begin
            $display("pcSrc should be 0 when branch and zero are 0");
        end
        
        #1
        
        i_branch = 1;
        i_zero = 0;
        
        if(o_pcSrc != 0) begin
            $display("pcSrc should be 0 when branch is 1 and zero is 0");
        end
        
        #1
        
        i_branch = 0;
        i_zero = 1;
        
        if(o_pcSrc != 0) begin
            $display("pcSrc should be 0 when branch is 0 and zero is 1");
        end
        
        #1
        
        i_branch = 1;
        i_zero = 1;
        
        if(o_pcSrc != 0) begin
            $display("pcSrc should be 1 when branch and zero are 1");
        end
    
    end

endmodule
